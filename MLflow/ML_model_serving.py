# split-oriented
curl http://localhost:5001/invocations -H 'Content-Type: application/json' -d '{
    "columns": ["a", "b", "c"],
    "data": [[1, 2, 3], [4, 5, 6]]
}'

# record-oriented (fine for vector rows, loses ordering for JSON records)
curl http://localhost:5000/invocations -H 'Content-Type: application/json; format=pandas-records' -d '[[1, 2, 3], [4, 5, 6]]'