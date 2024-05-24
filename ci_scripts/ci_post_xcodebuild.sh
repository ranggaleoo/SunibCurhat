#!/bin/sh

#  ci_post_xcodebuild.sh
#  SunibCurhat
#
#  Created by Rangga Leo on 28/02/24.
#  Copyright © 2024 Rangga Leo. All rights reserved.

if [[ -d "$CI_APP_STORE_SIGNED_APP_PATH" ]]; then
  TESTFLIGHT_DIR_PATH=../TestFlight
  mkdir $TESTFLIGHT_DIR_PATH
  git fetch --deepen 3 && git log -3 --pretty=format:"%s" >! $TESTFLIGHT_DIR_PATH/WhatToTest.en-US.txt
fi
