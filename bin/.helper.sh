#!/usr/bin/env bash
#
#
# Bash script helper functions
#
#

info() { echo -e "\033[1;36mi\u2009\033[0m$1"; }
success() { echo -e "\033[1;32m✔\u2009\033[0m$1"; }
warn() { echo -e "\033[1;33m!\u2009\033[0m$1"; }
error() { echo -e "\033[1;31m✗\u2009\033[0m$1"; }
