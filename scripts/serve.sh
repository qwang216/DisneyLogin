#!/bin/sh
RUNNING_SERVER=$(lsof -i tcp:8000 -t)
echo "${RUNNING_SERVER}"
if [ -z "$RUNNING_SERVER" ]
then
  echo ""
else
  echo "KILLING SERVER"
  kill -9 "${RUNNING_SERVER}"
fi
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
REL_DIRECTORY=${1:-disney}
DIRECTORY="${SCRIPTPATH}/${REL_DIRECTORY}"

echo "path: ==> ${DIRECTORY}"
echo "\n\nServing files from ${DIRECTORY}\n\n"
cd "${DIRECTORY}"
ver=$(python -c"import sys; print(sys.version_info.major)")
if [ $ver -eq 2 ]; then
    echo "python version 2"
(echo "Python 3 not installed. Falling back to python 2" && python -m SimpleHTTPServer 8000)
elif [ $ver -eq 3 ]; then
  (echo "Starting server with python 3: " && python -m http.server 8000)
    echo "python version 3"
else
    echo "You must install python or use some other mechanism to serve this folder at http://localhost:8000"
    echo "Unknown python version: $ver"
fi
