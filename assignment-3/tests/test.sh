#!/usr/bin/env bash

# cd "$(dirname "$0")/.."

APP="assignment-3/app/app.sh"

passed=0
failed=0

echo "Testing help..."

"$APP" help
exit_code=$?

echo "Exit code: $exit_code"

if [[ "$exit_code" -eq 0 ]]; then
    echo "Help test passed."
    ((passed++))
else
    echo "Help test failed."
    ((failed++))
fi


echo "Testing system-info..."

"$APP" system-info
exit_code=$?

if [[ "$exit_code" -eq 0 ]]; then
    echo "System info test passed."
    ((passed++))
else
    echo "System info test failed."
    ((failed++))
fi


echo "Testing invalid command..."

"$APP" banana
exit_code=$?

if [[ "$exit_code" -eq 2 ]]; then
    echo "PASS"
    ((passed++))
else
    echo "FAIL"
    ((failed++))
fi


echo
echo "Testing check-host with missing host..."

"$APP" check-host
exit_code=$?

if [[ "$exit_code" -eq 2 ]]; then
    echo "PASS"
    ((passed++))
else
    echo "FAIL"
    ((failed++))
fi


echo
echo "Testing check-host with valid host..."

"$APP" check-host example.com
exit_code=$?

if [[ "$exit_code" -eq 0 ]]; then
    echo "PASS"
    ((passed++))
else
    echo "FAIL"
    ((failed++))
fi


echo
echo "Testing check-port with missing arguments..."

"$APP" check-port
exit_code=$?

if [[ "$exit_code" -eq 2 ]]; then
    echo "PASS"
    ((passed++))
else
    echo "FAIL"
    ((failed++))
fi


echo
echo "Testing check-port with missing port..."

"$APP" check-port example.com
exit_code=$?

if [[ "$exit_code" -eq 2 ]]; then
    echo "PASS"
    ((passed++))
else
    echo "FAIL"
    ((failed++))
fi


echo
echo "Testing non-numeric port..."

"$APP" check-port example.com abc
exit_code=$?

if [[ "$exit_code" -eq 2 ]]; then
    echo "PASS"
    ((passed++))
else
    echo "FAIL"
    ((failed++))
fi


echo
echo "Testing port 0..."

"$APP" check-port example.com 0
exit_code=$?

if [[ "$exit_code" -eq 2 ]]; then
    echo "PASS"
    ((passed++))
else
    echo "FAIL"
    ((failed++))
fi


echo
echo "Testing port 65536..."

"$APP" check-port example.com 65536
exit_code=$?

if [[ "$exit_code" -eq 2 ]]; then
    echo "PASS"
    ((passed++))
else
    echo "FAIL"
    ((failed++))
fi


echo
echo "=============================="
echo "Tests passed: $passed"
echo "Tests failed: $failed"
echo "=============================="


if [[ "$failed" -eq 0 ]]; then
    exit 0
else
    exit 1
fi