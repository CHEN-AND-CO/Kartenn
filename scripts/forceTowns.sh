#!/bin/bash

set -e

url=$1
townList=$2

while IFS= read -r line
do
    echo $line
    wget -qO- $url/cities/$line?create=true
done < "$townList"