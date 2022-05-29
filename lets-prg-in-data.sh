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

sbosnap update > /dev/null
## grab these from SBo
sbo_pkg_install fswatch
#sbo_pkg_install psutil
#sbo_pkg_install pycodestyle
#sbo_pkg_install typed_ast
#sbo_pkg_install typing-extensions
#sbo_pkg_install mypy_extensions
#sbo_pkg_install mypy
##sbo_pkg_install pycodestyle 
#sbo_pkg_install python-zipp
#sbo_pkg_install python-importlib_metadata
#sbo_pkg_install python3-mccabe
#sbo_pkg_install python3-pyrsistent
#sbo_pkg_install python3-jsonschema
#sbo_pkg_install funcy
#sbo_pkg_install Mako
sbo_pkg_install sphinx-rtd-theme

# get source balls
sh download.sh

#  python3-autopep8 \
#  python3-coverage \
#  python3-e3-core \
#  python3-e3-testsuite \
#  python3-funcy \
#  python3-pbr \
#  python3-railroad-diagrams \
#  python3-stevedore \
#  python3-yapf \
#  python3-pyflakes \
#  python3-flake8 \
#  python3-railroad-diagrams \
#  python3-wheel \

# gnat-env is special
version=$(gcc -dumpversion)
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
  ahven \
  ncurses-ada \
  ada-rm \
  sparforte \
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
  # The real build starts here
  sh ${package}.SlackBuild || exit 1
  PACKAGE="${package}-$version-*sAda.$PKGTYPE"
  if [ -f $TMP/$PACKAGE ]; then
    upgradepkg --install-new --reinstall $TMP/$PACKAGE
  else
    echo "Error:  package to upgrade "$PACKAGE" not found in $TMP"
    exit 1
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


