#!/bin/bash

set -x

ls "$QT_DIR"
if [ -z "$1" ]
then
  echo "No Qt version selected"
else
  echo "Qt version $1 selected"
  echo "$2 selected"
  
  git clone https://github.com/qt/qtbase.git
  cd qtbase
  git checkout "$1"
  cd src/plugins/sqldrivers
  if [ "$2" = "linux" ]
  then
    cmake -B build -DMySQL_INCLUDE_DIR=/usr/include/mariadb/ -DMySQL_LIBRARY=/usr/lib/x86_64-linux-gnu/libmariadb.so -DCMAKE_BUILD_TYPE=Release
    make
  elif [ "$2" = "mac" ]
  then
    export HOMEBREW="$(brew --prefix)"
    cmake -DMySQL_INCLUDE_DIR="$HOMEBREW"/include/mariadb -DMySQL_LIBRARY="$HOMEBREW"/lib/libmariadb.dylib -DCMAKE_PREFIX_PATH=$QT_DIR/macos -DCMAKE_BUILD_TYPE=Release
    make
  fi
fi
