#!/bin/bash
set -e
set -x
set -o pipefail
if [[ "$bs_os" == "android" ]]; then
   set filename = "$BITRISE_APP_TITLE-${BITRISE_BUILD_NUMBER}.apk"
else
   set filename = "$BITRISE_APP_TITLE-${BITRISE_BUILD_NUMBER}.ipa"
fi
mv $upload_path $filename
curl -u "$bs_username:$bs_access_key" -X POST https://api-cloud.browserstack.com/app-live/upload -F "file=@$upload_path" -F 'data={"custom_id": "'$custom_id'"}' | jq -j '.app_url' | cut -c6- |  envman add --key BS_APP_HASH_ID
envman add --key BS_APP_URL --value "https://app-live.browserstack.com/dashboard#os=$bs_os&os_version=$bs_os_version&device=$bs_device&app_hashed_id=$BS_APP_HASH_ID&scale_to_fit=false&speed=1&start=true"

