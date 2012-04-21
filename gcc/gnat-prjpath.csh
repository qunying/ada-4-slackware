#!/bin/csh
if ( $?GPR_PROJECT_PATH) then
    setenv GPR_PROJECT_PATH ${GPR_PROJECT_PATH}:/usr/local/LIB_SUBDIR/gnat
else
    setenv GPR_PROJECT_PATH /usr/local/LIB_SUBDIR/gnat:/usr/LIB_SUBDIR/gnat
endif
setenv ADA_PROJECT_PATH ${GPR_PROJECT_PATH}
