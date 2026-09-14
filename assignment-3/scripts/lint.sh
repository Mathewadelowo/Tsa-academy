#!/usr/bin/env bash
cd "$(dirname "$0")/.."

required_files=(
    "README.md"
    "app/app.sh"
    "scripts/lint.sh"
    "scripts/build.sh"
    "tests/test.sh"
    "../.github/workflows/ci.yml"
    "Dockerfile"
    "compose.yaml"
    ".dockerignore"
)


# echo "Checking for required files..."

failed=0

for file in "${required_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "Pass: $file exists"
      
    else
        echo "Fail: $file is missing"
        ((failed++))
    fi
done


## checking for bash syntax errors in the scripts

bash_scripts=(
    "app/app.sh"
    "scripts/lint.sh"
    "scripts/build.sh"
    "tests/test.sh"
)

for file in "${bash_scripts[@]}"; do
    if [[ -f "$file" ]]; then
        if bash -n "$file";then
            echo "PASS: $file syntax is valid"
        else
            echo "FAIL: $file has a syntax error"
            ((failed++))
        fi
    fi
done

echo

if [[ "$failed" -eq 0 ]]; then
    echo "Linting passed."
    exit 0
else
    echo "Linting failed. $failed issue(s) found."
    exit 1
fi
