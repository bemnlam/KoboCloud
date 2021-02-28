#!/bin/sh

sh ./makeKoboRoot.sh
ls -al KoboRoot.tgz
mv KoboRoot.tgz /Volumes/KOBOeReader/.kobo/KoboRoot.tgz
ls -al /Volumes/KOBOeReader/.kobo/KoboRoot.tgz
