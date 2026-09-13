#!/usr/bin/env bash

/app/diagnostic.sh system >/dev/null 2>&1
exit $?