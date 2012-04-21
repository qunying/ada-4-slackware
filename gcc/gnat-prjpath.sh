#!/bin/sh
if [ ! "$GPR_PROJECT_PATH" = "" ]; then
   GPR_PROJECT_PATH=${GPR_PROJECT_PATH}:/usr/local/LIB_SUBDIR/gnat
else
   GPR_PROJECT_PATH=/usr/local/LIB_SUBDIR/gnat:/usr/LIB_SUBDIR/gnat
fi
export GPR_PROJECT_PATH
export ADA_PROJECT_PATH=$GPR_PROJECT_PATH
