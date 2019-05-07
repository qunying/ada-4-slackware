#!/bin/sh

ARCH=$(uname -m)
PKGS=$(find -type f -name '*.info' -exec basename {} .info \;)

for pkg in $PKGS; do
  if [ ! -f $pkg/$pkg.info ]; then
      continue
  fi
  . $pkg/$pkg.info
  if [ "$ARCH" = "x86_64" ]; then
    case $pkg in
      *)
        DOWNLOAD="$DOWNLOAD $DOWNLOAD_x86_64"
        MD5SUM="$MD5SUM $MD5SUM_x86_64"
        ;;
    esac
  fi

  DOWNLOAD=($DOWNLOAD)
  MD5SUM=($MD5SUM)

  len=${#DOWNLOAD[@]}

  cd $pkg
  for (( i=0; i < $len; i++ )); do
    src=$(basename ${DOWNLOAD[$i]})

    if [ -e "$src" ]; then
      continue;
    fi

    if [ -z "$file" ]; then
      wget2 ${DOWNLOAD[$i]}
    fi
  done
  cd ..
done
