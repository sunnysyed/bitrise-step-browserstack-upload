#!/bin/bash
set -e
set -x
set -o pipefail
if [[ "$bs_os" == "android" ]]; then
   export filename="${BITRISE_DEPLOY_DIR}/$BITRISE_APP_TITLE-${BITRISE_BUILD_NUMBER}.apk"
else
    export filename="${BITRISE_DEPLOY_DIR}/$BITRISE_APP_TITLE-${BITRISE_BUILD_NUMBER}.ipa"
fi
cp "${upload_path}" "${filename}"
response=$(curl -u "$bs_username:$bs_access_key" -X POST "https://api-cloud.browserstack.com/app-live/upload" -F "file=@$filename" -F 'data={"custom_id": "'$custom_id'"}')
app_url=$(echo "$response" | jq -r '.app_url' | sed 's/^bs:\/\///')  # Remove 'bs://'
export BS_APP_HASH_ID="$app_url"
envman add --key BS_APP_URL --value "https://app-live.browserstack.com/dashboard#os=$bs_os&os_version=$bs_os_version&device=$bs_device&app_hashed_id=$BS_APP_HASH_ID&scale_to_fit=false&speed=1&start=true"
envman add --key BS_APP_HASH_ID --value BS_APP_HASH_ID