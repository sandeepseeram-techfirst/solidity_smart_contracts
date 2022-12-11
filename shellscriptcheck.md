$ shellcheck myscript
 
Line 91:
        i) TIMEOUT_S=${OPTARG} ;;
        ^-- SC2214 (warning): This case is not specified by getopts.
 
Line 115:
BUILD_LOG_FILE="${BUILD_DIR}/${NAME}_build.log.txt
^-- SC2097 (warning): This assignment is only seen by the forked process.
               ^-- SC1078 (warning): Did you forget to close this double quoted string?
 
Line 116:
LOCK_FILE="${BUILD_DIR}/${NAME}_ci.lck"
          ^-- SC1079 (info): This is actually an end quote, but due to next char it looks suspect.
 
Line 119:
        rm -rf "${BUILD_DIR}"
                ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
 
Line 120:
        rm -f "${LOCK_FILE}"
               ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
               ^-- SC2153 (info): Possible misspelling: LOCK_FILE may not be assigned. Did you mean LOG_FILE?
 
Line 122:
        find "${BUILD_DIR_BASE}"/* -type d -atime +1 -exec rm {} -rf +
              ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                               ^-- SC1078 (warning): Did you forget to close this double quoted string?
 
Line 123:
        echo "cleanup done"
             ^-- SC1079 (info): This is actually an end quote, but due to next char it looks suspect.
                      ^-- SC2289 (error): This is interpreted as a command name containing a tab. Double check syntax.
 
Line 128:
        if [[ ${LOG_FILE} != "" ]] && [[ ${MAIL_CMD_ATTACH_FLAG} != "" ]]
>>                                                                   ^-- SC1078 (warning): Did you forget to close this double quoted string?
 
Line 132:
        if [[ ${EMAIL} != "" ]] && [[ ${MAIL_CMD} != "" ]]
                          ^-- SC1079 (info): This is actually an end quote, but due to next char it looks suspect.
                                                      ^-- SC1078 (warning): Did you forget to close this double quoted string?
 
Line 134:
                echo "${msg}" | ${MAIL_CMD} "${MAIL_CMD_SUBJECT_FLAG}" "${msg}" "${log_file_arg[@]}" "${MAIL_CMD_RECIPIENTS_FLAG}" "${EMAIL}"
                     ^-- SC1079 (info): This is actually an end quote, but due to next char it looks suspect.
                      ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                      ^-- SC2154 (warning): msg is referenced but not assigned.
                      ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
                                             ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                                             ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
>>                                                                      ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
>>                                                                      ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
>>                                                                               ^-- SC2068 (error): Double quote array expansions to avoid re-splitting elements.
>>                                                                               ^-- SC2145 (error): Argument mixes string and array. Use * or separate argument.
>>                                                                               ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
>>                                                                               ^-- SC2154 (warning): log_file_arg is referenced but not assigned.
>>                                                                                                    ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
>>                                                                                                    ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
>>                                                                                                                                  ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
>>                                                                                                                                  ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
                echo ""${msg}"" | ${MAIL_CMD} ""${MAIL_CMD_SUBJECT_FLAG}"" ""${msg}"" "${log_file_arg[@]}" ""${MAIL_CMD_RECIPIENTS_FLAG}"" ""${EMAIL}""
 
Line 136:
                echo "${msg}"
                      ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                      ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
                echo ""${msg}""
 
Line 140:
date 2>&1 | tee -a "${BUILD_LOG_FILE}"
                    ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                    ^-- SC2098 (warning): This expansion will not see the mentioned assignment.
                    ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
date 2>&1 | tee -a ""${BUILD_LOG_FILE}""
 
Line 145:
        echo "Already running" | tee -a "${BUILD_LOG_FILE}"
                                         ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                                         ^-- SC2098 (warning): This expansion will not see the mentioned assignment.
                                         ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
        echo "Already running" | tee -a ""${BUILD_LOG_FILE}""
 
Line 151:
touch "${LOCK_FILE}"
       ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
       ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
touch ""${LOCK_FILE}""
 
Line 153:
pushd "${LOCAL_CHECKOUT}"
       ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
       ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
pushd ""${LOCAL_CHECKOUT}""
 
Line 154:
git fetch origin main 2>&1 | tee -a "${BUILD_LOG_FILE}"
                                     ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                                     ^-- SC2098 (warning): This expansion will not see the mentioned assignment.
                                     ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
git fetch origin main 2>&1 | tee -a ""${BUILD_LOG_FILE}""
 
Line 157:
echo "Updates: ${updates}" | tee -a "${BUILD_LOG_FILE}"
               ^-- SC2154 (warning): updates is referenced but not assigned.
               ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
                                     ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                                     ^-- SC2098 (warning): This expansion will not see the mentioned assignment.
                                     ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
echo "Updates: "${updates}"" | tee -a ""${BUILD_LOG_FILE}""
 
Line 160:
        touch "${LOG_FILE}"
               ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
               ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
        touch ""${LOG_FILE}""
 
Line 161:
        pushd "${LOCAL_CHECKOUT}"
               ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
               ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
        pushd ""${LOCAL_CHECKOUT}""
 
Line 162:
        echo "Pulling" | tee -a "${LOG_FILE}"
              ^-- SC2140 (warning): Word is of the form "A"B"C" (B indicated). Did you mean "ABC" or "A\"B\"C"?
                                 ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                                 ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
        echo "Pulling" | tee -a ""${LOG_FILE}""
 
Line 163:
        git pull origin main 2>&1 | tee -a "${LOG_FILE}"
                                            ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                                            ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
        git pull origin main 2>&1 | tee -a ""${LOG_FILE}""
 
Line 166:
        pushd "${BUILD_DIR}"
               ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
               ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
        pushd ""${BUILD_DIR}""
 
Line 168:
        git clone "${REPO}" "${NAME}"
                   ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                   ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
                             ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                             ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
        git clone ""${REPO}"" ""${NAME}""
 
Line 170:
        ${PRE_SCRIPT} 2>&1 | tee -a "${LOG_FILE}"
                                     ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                                     ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
        ${PRE_SCRIPT} 2>&1 | tee -a ""${LOG_FILE}""
 
Line 171:
        EXIT_CODE="${?}"
                   ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
 
Line 174:
                msg="ANGRY ${NAME} on $(hostname)"
                           ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
                                      ^-- SC2046 (warning): Quote this to prevent word splitting.

Did you mean: (apply this, apply all SC2086)
                msg="ANGRY "${NAME}" on $(hostname)"
 
Line 175:
        pushd "${BUILD_DIR}"/"${NAME}"/"${TEST_DIR}"
               ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
               ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
                              ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                              ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
                                        ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                                        ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
        pushd ""${BUILD_DIR}""/""${NAME}""/""${TEST_DIR}""
 
Line 176:
        timeout "${TIMEOUT_S}" "${TEST_COMMAND}" 2>&1 | tee -a "${LOG_FILE}"
                 ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                 ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
                                ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
                                ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
>>                                                              ^-- SC2027 (warning): The surrounding quotes actually unquote this. Remove or escape them.
>>                                                              ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
        timeout ""${TIMEOUT_S}"" ""${TEST_COMMAND}"" 2>&1 | tee -a ""${LOG_FILE}""
 
Line 183:
                        msg="ANGRY (TIMEOUT) ${NAME} on $(hostname)"
                                   ^-- SC1036 (error): '(' is invalid here. Did you forget to escape it?
                                   ^-- SC1088 (error): Parsing stopped here. Invalid use of parentheses?

$
