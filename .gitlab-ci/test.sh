#!/usr/bin/env bash
#
# Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
# Copyright (C) 2022 - Dassault Systèmes S.E. - Clément DAVID
# Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
#
#
# Execute module tests for a module name ${TEST}, download and install
# latest build if needed.
#


# predefined env
CCACHE_DIR="${CI_PROJECT_DIR}/ccache"
export CCACHE_DIR

# install
echo -e "\e[0Ksection_start:$(date +%s):install\r\e[0KInstall Scilab binary"
tar -xJf "${SCI_VERSION_STRING}.bin.${ARCH}.tar.xz" -C $HOME

echo -e "\e[0Ksection_end:$(date +%s):install\r\e[0K"

LOG_PATH=$SCI_VERSION_STRING/$ARCH
[ ! -d "$LOG_PATH" ] && mkdir "$LOG_PATH"

echo -e "\e[0Ksection_start:$(date +%s):test\r\e[0KTesting $TEST"
xvfb-run $HOME/${SCI_VERSION_STRING}/bin/scilab -nw -quit -e 'test_run("'"${TEST}"'",[],[],"'"${LOG_PATH}/${TEST}.xml"'")'
echo -e "\e[0Ksection_end:$(date +%s):test\r\e[0K"

# fail without xml report
du -h "${LOG_PATH}/${TEST}.xml"
