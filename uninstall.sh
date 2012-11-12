#!/bin/sh
ls -alF ~ | grep " -> `pwd`" | sed -e "s/.* \(.*\) -> .*/\1/" | xargs -t -I {} rm ~/{}
