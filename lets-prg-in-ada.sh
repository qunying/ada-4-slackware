#!/bin/sh
# This script is borrowed from the slackENLIGHTENMENT
# (https://github.com/ryanpcmcquen/slackENLIGHTENMENT) project
#
# This is where all the compilation and final results will be placed
TMP=${TMP:-/tmp}

# This is the original directory where you started this script
ROOT=$(pwd)

sbo_pkg_install() {
  SBO_PACKAGE=$1
  if [ -z "`find /var/log/packages/ -name $SBO_PACKAGE-*`" ]; then
    ## `echo p` fixes sqg confusion
    echo p | sboinstall $SBO_PACKAGE
  fi
}

PKGTYPE=${PKGTYPE:-txz}

echo "Updating sbopkg ..."
sbosnap update > /dev/null
## grab these from SBo
sbo_pkg_install fswatch
sbo_pkg_install	snowballstemmer


# get source balls
sh download.sh

# gnat-env is special
version=1.0
package=gnat-env
cd $package
if [ -z "`find /var/log/packages/ -name $package-$version-*`" ] ; then
  sh ${package}.SlackBuild || exit 1
  PACKAGE="${package}-$version-*sAda.$PKGTYPE"
  if [ -f $TMP/$PACKAGE ]; then
    upgradepkg --install-new --reinstall $TMP/$PACKAGE
  else
    echo "Error:  package to upgrade "$PACKAGE" not found in $TMP"
    exit 1
  fi
fi

cd ..
# we need to do a boot strap first
BOOTSTRAP_DSTDIR=$TMP/slackAda/bootstrap
if [ ! -f $BOOTSTRAP_DSTDIR/bin/gprbuild ] ; then
    (cd gprbuild; ./bootstrap.SlackBuild)
fi
# Loop for all packages:
for dir in \
  xmlada \
  gprbuild \
  gtkada \
  aunit \
  gnatcoll-core \
  gnatcoll-bindings \
  gnatcoll-db \
  ada_libfswatch \
  ada-rm \
  spawn \
  VSS \
  libadalang \
  templates-parser \
  libadalang-tools \
  ada_language_server \
  gnatstudio \
  ahven \
  ncurses-ada \
  sparforte \
  florist \
  ada-rm \
  alire \
  ; do
  # get the package name
  package=$dir

  # Change to package directory
  cd $ROOT/$dir || exit 1 

  # Get the version
  version=$(grep "VERSION=" ${package}.info | cut -d "=" -f2 | rev | cut -c 2- | rev | cut -c 2-)

  if [ -n "`find /var/log/packages/ -name $package-$version-*`" ] ; then
      continue
  fi
  echo "$package $version"
  # The real build starts here
  PACKAGE="${package}-$version-*sAda.$PKGTYPE"
  if [ -f $TMP/$PACKAGE ]; then
    upgradepkg --install-new --reinstall $TMP/$PACKAGE
  else
    sh ${package}.SlackBuild || exit 1
    if [ -f $TMP/$PACKAGE ]; then
	    upgradepkg --install-new --reinstall $TMP/$PACKAGE
    else
       echo "Error:  package to upgrade "$PACKAGE" not found in $TMP"
       exit 1
    fi
  fi
  
  # back to original directory
  cd $ROOT
done

if [ -z "$(grep _sAda /etc/slackpkg/greylist)" ]; then
  echo [0-9]+_sAda >> /etc/slackpkg/greylist
fi


echo
echo "-----------------------------------------------------"
echo "-- Congratulations! Let's start to program in Ada! --"
echo "-----------------------------------------------------"
echo


