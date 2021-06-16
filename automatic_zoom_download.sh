#!/bin/bash
<<<<<<< HEAD
# fill in the variables: YOURTOKEN, /path/to/, SPECIALFOLDER, meetingID

cd ~/Downloads/myzoomvideos

export TOKEN=YOURTOKEN

export authorization="Authorization: Bearer $TOKEN"

export meetingID=12345678#${1:-382352152}

my_url=$(/path/to/anaconda3/bin/curl --header "$authorization" \
 --url "https://api.zoom.us/v2/meetings/$meetingID/recordings" | /usr/local/bin/jq -r '[.recording_files[]?.download_url] | join(",") ')
IFS=',' read -ra myurls <<< "$my_url"

mynames=$(/path/to/anaconda3/bin/curl --header "$authorization" \
--url "https://api.zoom.us/v2/meetings/$meetingID/recordings" | \
/usr/local/bin/jq -r ['.topic as $parent | .recording_files[]? | "\(.recording_start)_\($parent[0:12]).\(.file_type)"] | join(",")')
IFS=',' read -ra mynamevar <<< "$mynames"

# echo "${#myurls[@]}"

for i in $(echo ${!mynamevar[@]}); do \
/path/to/anaconda3/bin/curl -L -v --output "${mynamevar[$i]}" --url "${myurls[$i]}?access_token=$TOKEN";
done

## DELETE THE VIDEOS ALREADY DOWNLOADED##
recID=$(curl --header "$authorization" \
--url "https://api.zoom.us/v2/meetings/$meetingID/recordings" | \
/usr/local/bin/jq -r ['.recording_files[]?.id] | join(",")')
IFS=',' read -ra recID <<< "$recID"

for i in "${recID[@]}"; do \
/path/to/anaconda3/bin/curl -X DELETE --header "$authorization" --url https://api.zoom.us/v2/meetings/$meetingID/recordings/${i}?action=trash
done

mv *SPECIAL*.MP4 SPECIALFOLDER/vid 2>/dev/null;
mv *SPECIAL* SPECIALFOLDER 2>/dev/null;
=======

cd ~/Downloads/myzoomvideos

export TOKEN=YOURTOKEN # Add your Token
export authorization="Authorization: Bearer $TOKEN"
export meetingID=12345678 #Change to your meetingID
export CURLPATH=$(which curl)
export JQPATH=$(which jq)

my_url=$($CURLPATH --header "$authorization" \
 --url "https://api.zoom.us/v2/meetings/$meetingID/recordings" | $JQPATH -r '[.recording_files[]?.download_url] | join(",") ')
IFS=',' read -ra myurls <<< "$my_url"

mynames=$($CURLPATH --header "$authorization" \
--url "https://api.zoom.us/v2/meetings/$meetingID/recordings" | \
$JQPATH -r ['.topic as $parent | .recording_files[]? | "\(.recording_start)_\($parent[0:12]).\(.file_type)"] | join(",")')
IFS=',' read -ra mynamevar <<< "$mynames"

for i in $(echo ${!mynamevar[@]}); do \
$CURLPATH -L -v --output "${mynamevar[$i]}" --url "${myurls[$i]}?access_token=$TOKEN";
done

## DELETE the videos already downloaded from Zoom##

recID=$(curl --header "$authorization" \
--url "https://api.zoom.us/v2/meetings/$meetingID/recordings" | \
$JQPATH -r ['.recording_files[]?.id] | join(",")')
IFS=',' read -ra recID <<< "$recID"

for i in "${recID[@]}"; do \
$CURLPATH -X DELETE --header "$authorization" --url https://api.zoom.us/v2/meetings/$meetingID/recordings/${i}?action=trash
done

mv -i *SPECIAL*.MP4 SPECIALFOLDER/vid 2>/dev/null; # change SPECIAL and SPECIALFOLDER according to your desired sorting strucure
mv -i *SPECIAL* SPECIALFOLDER/ 2>/dev/null;
>>>>>>> b81a075 (changed jq and curl path to variables)
mv 202* OTHERS 2>/dev/null;

echo "Download and deletion successful."
