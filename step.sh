#!/bin/bash

set -euxo pipefail

XCRESULT_ARCHIVE_FOLDER="/buildArchive"
XCRESULT_ARCHIVE_NAME="${xcodebuild_scheme}.xcarchive"
XCRESULT_ARCHIVE_PATH="${XCRESULT_ARCHIVE_FOLDER}/${XCRESULT_ARCHIVE_NAME}"

envman add --key XCRESULT_ARCHIVE_PATH --value "${XCRESULT_ARCHIVE_PATH}"

env NSUnbufferedIO=YES \
xcodebuild \
-scheme "${xcodebuild_scheme}" \
-configuration "${xcodebuild_config}" \
clean archive -archivePath "${XCRESULT_ARCHIVE_PATH}" \
CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

(
  cd "${XCRESULT_ARCHIVE_FOLDER}"
  exec zip -r "${BITRISE_DEPLOY_DIR}/${xcodebuild_scheme}.zip" "${XCRESULT_ARCHIVE_NAME}"
)
