#!/bin/sh

source setup.sh

echo "test build for android.."
lime build android || echo "ERROR: ANDROID BUILD FAILED!!!"

echo "test build for html5.."
lime build html5 || echo "ERROR: HTML5 BUILD FAILED!!!"

echo "test build for linux.."
lime build linux || echo "ERROR: LINUX BUILD FAILED!!!"


python3 testrunner.py . test/tests test/testbed

