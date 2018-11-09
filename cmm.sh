#!/bin/bash
#
#  Created by wzxjiang on 18/11/6.
#  Copyright © 2018年 wzxjiang. All rights reserved.
#
#  https://github.com/Wzxhaha/cmm.sh
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

# Xcode
cache_dt_xcode="$HOME/Library/Caches/com.apple.dt.Xcode";
# Carthage
cache_carthage="$HOME/Library/Caches/org.carthage.CarthageKit";
# QQ
cache_qq_image="$HOME/Library/Containers/com.tencent.qq/Data/Library/Caches/Images"
cache_qq_video="$HOME/Library/Containers/com.tencent.qq/Data/Library/Caches/Videos"
cache_qq_avatar="$HOME/Library/Containers/com.tencent.qq/Data/Library/Caches/Avatar"
items=(
  $cache_dt_xcode
  $cache_carthage
  $cache_qq_image
  $cache_qq_video
  $cache_qq_avatar
)
debug_log() {
  if [[ $debug -eq 1 ]]; then
    echo -e $1;
  fi
}
get_size() {
  if [ -d "$1" ]; then
    du -sh $1;
    return 0;
  else
    debug_log "\033[31m0 $1\033[0m";
    return 1;
  fi
}
clean() {
  get_size $1;
  exist=$?
  if [[ $exist -eq 0 ]]; then
    if [[ $force -eq 1 ]]; then
      sure="y"
    else
      read -p "Are you sure clean $1: y/N " sure;
    fi
    if [ "$sure" == "y" ]; then
      debug_log "Cleaning...";
      rm -rf $1
      debug_log "Cleaned";
    elif [ "$sure" == "N" ]; then
      debug_log "Abort";
    else
      debug_log "Error, try again";
      clean $1;
    fi
  fi
}
help() {
  echo "usage: cmm [--version] [--force]
command:
  size
  clean"
}
check_option() {
  for argv in $@
    do 
      if [ "$argv" == "--version" ]; then
        debug=1
      elif [ "$argv" == "--force" ]; then
        force=1
      fi
    done
  return 0
}
command() {
  if [ "$1" == "size" ]; then
    for i in ${items[@]}
    do 
      get_size ${i};
    done
  elif [ "$1" == "clean" ]; then
    for i in ${items[@]}
    do 
      clean ${i};
    done
  else
    debug_log "Invaild command.";
    help;
  fi
}
check_option $@;
command $1;