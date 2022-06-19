#!/bin/bash
set -euo pipefail

#enter the workflow's final output directory ($1)
cd $1

#find all fastq.gz files, return their md5sums to std out, list all file types
find ./*/mapped -name *frequency.bed -xtype f \;
ls ./mapped | sed 's/.*\.//' | sort | uniq -c
