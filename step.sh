#!/bin/bash
set -e
set -x
set -o pipefail
curl -u "$bs_username:$bs_access_key" -X POST https://api-cloud.browserstack.com/app-live/upload -F "file=@$upload_path" -F 'data={"custom_id": "'$custom_id'"}' | jq -j '.app_url' | cut -c6- |  envman add --key BS_APP_HASH_ID
envman add --key BS_APP_URL --value "https://app-live.browserstack.com/dashboard#os=android&os_version=12.0&device=Samsung+Galaxy+S22&app_hashed_id=$BS_APP_HASH_ID&scale_to_fit=false&speed=1&start=true"

