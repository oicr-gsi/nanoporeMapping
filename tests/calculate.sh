#!/bin/bash
set -euo pipefail

#enter the workflow's final output directory ($1)
cd $1

#find all frequency.bed files
find  -name '*frequency.bed' -xtype f 

