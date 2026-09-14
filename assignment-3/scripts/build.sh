#!/usr/bin/env bash

echo "Building Docker image..."

docker build -t devops-tool .

echo "Running Docker smoke tests..."

echo "Test 1: help"
docker run --rm devops-tool help

echo "Test 2: system-info"
docker run --rm devops-tool system-info

echo "Test 3: invalid command"
docker run --rm devops-tool banana
exit_code=$?

if [[ "$exit_code" -eq 2 ]]; then
    echo "PASS: invalid command returned exit code 2"
else
    echo "FAIL: invalid command returned exit code $exit_code"
    exit 1
fi
