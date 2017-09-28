#!/bin/bash

uri="$1"
uri=$(echo "$uri" | sed 's/\\/\//g')
uri=$(echo "$uri" | sed 's/://g')
uri=$(echo "$uri" | sed 's/^./\L&\E/')
uri="/mnt/$uri"

PWD="$uri"
cd "$uri"

cmd="bash -c \"$2\""
eval $cmd