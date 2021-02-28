#!/bin/sh

outputFileTmp="/tmp/kobo-remote-file-tmp.log"

#load config
. $(dirname $0)/config.sh

baseURL="$1" # bearer token
# file=KoboReader-$(date +%s).sqlite
file=KoboReader.sqlite
# ts=KoboReader-$($Dt).sqlite

rm KoboReader.sqlite.tmp
cp $DB/KoboReader.sqlite KoboReader.sqlite.tmp

echo "Upload: $file"
echo "Authorization: $baseURL"

$CURL -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36" \
      -X POST https://content.dropboxapi.com/2/files/upload \
      --header "Authorization: $baseURL" \
      --header "Dropbox-API-Arg: {\"path\": \"/$file\",\"mode\": \"overwrite\",\"autorename\": true}" \
      --header "Content-Type: application/octet-stream" \
      --data-binary @KoboReader.sqlite.tmp \
      -k -L -v 2>$outputFileTmp
status=$?
echo "Status: $status"
echo "Output: "
cat $outputFileTmp

statusCode=`cat $outputFileTmp | grep 'HTTP/' | tail -n 1 | cut -d' ' -f3`
rm $outputFileTmp
echo "Remote file information:"
echo "  Status code: $statusCode"

if echo "$statusCode" | grep -q "403"; then
    echo "Error: Forbidden"
    exit 2
fi
if echo "$statusCode" | grep -q "50.*"; then
    echo "Error: Server error"
    exit 3
fi

rm KoboReader.sqlite.tmp