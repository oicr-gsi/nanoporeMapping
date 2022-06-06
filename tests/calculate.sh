#!/bin/bash
set -euo pipefail

#enter the workflow's final output directory ($1)
cd $1

#find all fastq.gz files, return their md5sums to std out, list all file types
find . -name *frequency.bed -xtype f -exec sh -c "cat {} | grep -v ^# | md5sum" \;
ls | sed 's/.*\.//' | sort | uniq -c
