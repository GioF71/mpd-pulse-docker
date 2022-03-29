#!/bin/bash

script_relative_path1=`dirname $0`
script_relative_path2=`dirname "$BASH_SOURCE"`

script_path1=$(dirname $(readlink -f $0))
script_path2=`dirname $(realpath $0)`
script_path3=$(dirname "$(readlink -f "$BASH_SOURCE")")
script_path4=`pwd`

echo "Script-Dir-Relative : $script_relative_path1"
echo "Script-Dir-Relative : $script_relative_path1"

echo "Script Path 1: $script_path1"
echo "Script Path 2: $script_path2"
echo "Script Path 3: $script_path3"
echo "Script Path 4: $script_path4"
