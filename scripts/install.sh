#!/bin/sh
# SPDX-License-Identifier: MIT

source $(dirname $0)/build-env.sh

cd ${wd}

echo '开始编译'
go install -ldflags "${ldflags}" -v
