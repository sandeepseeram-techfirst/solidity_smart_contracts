#!/bin/bash

# Simple CI

set -o pipefail
set -o nounset

# Defaults
FORCE=0
VERBOSE=0
REPO=""
EMAIL=""
NAME="ci"
TEST_DIR="."
TEST_COMMAND="./test.sh"
MAIL_CMD="mail"
MAIL_CMD_ATTACH_FLAG="-A"
MAIL_CMD_RECIPIENTS_FLAG="-t"
MAIL_CMD_SUBJECT_FLAG="-s"
PRE_SCRIPT="/bin/true"
POST_SCRIPT="/bin/true"
TIMEOUT_S=86400

PAGER=${PAGER:-more}

function show_help() {
	cat > /dev/stdout << END
${0} -r <repo> -l <local_checkout> [-q <pre-script>] [-w <post-script>]
   [-m <email>] [-a <mail command>] [-t <mail command attach flag>]
   [-s <mail command subject flag] [-e <recipients flag>] [-n name] [-d <dir>]
   [-c <command>] [-f] [-v] [-h]

REQUIRED ARGS:
-r - git repository, eg https://github.com/myname/myproj (required)
-l - local checkout of code (that gets updated to determine whether a run is needed) (required)

OPTIONAL ARGS:
-q - script to run just before actually performing test (default ${PRE_SCRIPT})
-w - script to run just after actually performing test (default ${POST_SCRIPT})
-m - email address to send to using "mail" command (default logs to stdout)
-a - mail command to use (default=${MAIL_CMD})
-n - name for ci (unique, must be a valid directory name), eg myproj (default=${NAME})
-d - directory within repository to navigate to (default=${TEST_DIR})
-c - test command to run from -d directory (default=${TEST_COMMAND})
-t - attach argument flag for mail command (default=${MAIL_CMD_ATTACH_FLAG}, empty string means no-attach)
-s - subject flag for mail command (default=${MAIL_CMD_RECIPIENTS_FLAG})
-e - recipients flag (default=${MAIL_CMD_RECIPIENTS_FLAG}, empty string means no flag needed)
-f - force a run even if repo has no updates (default off)
-v - verbose logging (default off)
-i - timeout in seconds (default 86400, ie one day, does KILL one hour after that)
-h - show help

EXAMPLES

- "Clone -r https://github.com/ianmiell/shutit.git if a git pull on /space/git/shutit indicates there's been an update.
  Then navigate to test, run ./test.sh and mail ian.miell@gmail.com if there are any issues"

  ./cheapci -r https://github.com/ianmiell/shutit.git -l /space/git/shutit -d test -c ./test.sh -m ian.miell@gmail.com


- "Run this continuously in a crontab."

  Crontab line:

  * * * * * cd /path/to/cheapci && ./cheapci -r https://github.com/ianmiell/shutit.git -l /space/git/shutit -d test -c ./test.sh -m ian.miell@gmail.com
END
}


while getopts "h?vfm:n:d:r:l:c:a:q:w:t:e:s:" opt
do
	case "${opt}" in
	h|\?)
		show_help
		exit 0
		;;
	v) VERBOSE=1 ;;
	f) FORCE=1 ;;
	r) REPO=${OPTARG} ;;
	m) EMAIL=${OPTARG} ;;
	n) NAME=${OPTARG} ;;
	d) TEST_DIR=${OPTARG} ;;
	l) LOCAL_CHECKOUT=${OPTARG} ;;
	c) TEST_COMMAND=${OPTARG} ;;
	q) PRE_SCRIPT=${OPTARG} ;;
	w) POST_SCRIPT=${OPTARG} ;;
	a) MAIL_CMD=${OPTARG} ;;
	t) MAIL_CMD_ATTACH_FLAG=${OPTARG} ;;
	e) MAIL_CMD_RECIPIENTS_FLAG=${OPTARG} ;;
	s) MAIL_CMD_SUBJECT_FLAG=${OPTARG} ;;
	i) TIMEOUT_S=${OPTARG} ;;
	esac
done

shift "$((OPTIND-1))"

if [[ ${REPO} = "" ]]
then
	show_help
	exit 1
fi


# To force a run even if no updates.

if [[ ${VERBOSE} -gt 0 ]]
then
	set -x
fi

BUILD_DIR_BASE="/tmp/${NAME}"
BUILD_DIR="${BUILD_DIR_BASE}/${NAME}_builddir"
mkdir -p "${BUILD_DIR}"
LOG_FILE="${BUILD_DIR}/${NAME}_build_${RANDOM}.log.txt"
BUILD_LOG_FILE="${BUILD_DIR}/${NAME}_build.log.txt
LOCK_FILE="${BUILD_DIR}/${NAME}_ci.lck"

function cleanup() {
	rm -rf "${BUILD_DIR}"
	rm -f "${LOCK_FILE}"
	# get rid of /tmp detritus, leaving anything accessed 2 days ago+
	find "${BUILD_DIR_BASE}"/* -type d -atime +1 -exec rm {} -rf +
	echo "cleanup done"
}

function send_mail() {
	msg=${1}
	if [[ ${LOG_FILE} != "" ]] && [[ ${MAIL_CMD_ATTACH_FLAG} != "" ]]
	then
		log_file_arg=(${MAIL_CMD_ATTACH_FLAG} ${LOG_FILE})
	fi
	if [[ ${EMAIL} != "" ]] && [[ ${MAIL_CMD} != "" ]]
	then
		echo "${msg}" | ${MAIL_CMD} "${MAIL_CMD_SUBJECT_FLAG}" "${msg}" "${log_file_arg[@]}" "${MAIL_CMD_RECIPIENTS_FLAG}" "${EMAIL}"
	else
		echo "${msg}"
	fi
}

date 2>&1 | tee -a "${BUILD_LOG_FILE}"

# Lockfile
if [[ -a ${LOCK_FILE} ]]
then
	echo "Already running" | tee -a "${BUILD_LOG_FILE}"
	exit
fi

trap cleanup TERM INT QUIT EXIT

touch "${LOCK_FILE}"
# Fetch changes
pushd "${LOCAL_CHECKOUT}"
git fetch origin main 2>&1 | tee -a "${BUILD_LOG_FILE}"
# See if there are any incoming changes
updates=$(git log HEAD..origin/main --oneline | wc -l)
echo "Updates: ${updates}" | tee -a "${BUILD_LOG_FILE}"
if [[ ${updates} -gt 0 ]] || [[ ${FORCE} -gt 0 ]]
then
	touch "${LOG_FILE}"
	pushd "${LOCAL_CHECKOUT}"
	echo "Pulling" | tee -a "${LOG_FILE}"
	git pull origin main 2>&1 | tee -a "${LOG_FILE}"
	popd
	# This won't exist in a bit so no point pushd'ing
	pushd "${BUILD_DIR}"
	# Clone to NAME
	git clone "${REPO}" "${NAME}"
	popd
	${PRE_SCRIPT} 2>&1 | tee -a "${LOG_FILE}"
	EXIT_CODE="${?}"
	if [[ ${EXIT_CODE} -ne 0 ]]
	then
		msg="ANGRY ${NAME} on $(hostname)"
	pushd "${BUILD_DIR}"/"${NAME}"/"${TEST_DIR}"
	timeout "${TIMEOUT_S}" "${TEST_COMMAND}" 2>&1 | tee -a "${LOG_FILE}"
	EXIT_CODE=$?
	popd
		if [[ ${EXIT_CODE} -ne 0 ]]
	then
		if [[ ${EXIT_CODE} -eq 124 ]]
		then
			msg="ANGRY (TIMEOUT) ${NAME} on $(hostname)"
		else
			msg="ANGRY ${NAME} on $(hostname)"
		fi
	else
		msg="HAPPY ${NAME} on $(hostname)"
	fi
	${POST_SCRIPT} 2>&1 | tee -a "${LOG_FILE}"
	EXIT_CODE=$?
		if [[ ${EXIT_CODE} -ne 0 ]]
	then
		msg="ANGRY ${NAME} on $(hostname)"
	fi
	send_mail "${msg}"
fi
