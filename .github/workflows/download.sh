#!/bin/bash

FENNEC_URL="https://f-droid.org/repo/org.mozilla.fennec_fdroid"
MULL_URL="https://f-droid.org/repo/us.spotco.fennec_dos"

FENNEC_64V8A="1142020"
FENNEC_V7A="1142000"
MULL_64V8A="21142020"
MULL_V7A="21142000"

mkdir -p Downloads
wget --progress=dot:mega "$FENNEC_URL"_"$FENNEC_64V8A".apk -O fennec.64.v8a.apk
wget --progress=dot:mega "$FENNEC_URL"_"$FENNEC_V7A".apk -O fennec.v7a.apk
wget --progress=dot:mega "$MULL_URL"_"$MULL_64V8A".apk -O mull.64.v8a.apk
wget --progress=dot:mega "$MULL_URL"_"$MULL_V7A".apk -O mull.v7a.apk
mv -v *.apk Downloads
