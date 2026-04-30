#!/bin/bash

# ========================================
# Lab 10: File Permission Security Scanner
# ========================================

TEST_DIR="$HOME/cus1163-lab10/test_files"

setup_test_environment() {
    mkdir -p "$TEST_DIR/web"
    mkdir -p "$TEST_DIR/config"
    mkdir -p "$TEST_DIR/scripts"
    mkdir -p "$TEST_DIR/data"
    mkdir -p "$TEST_DIR/uploads"

    touch "$TEST_DIR/web/index.html"
    touch "$TEST_DIR/web/style.css"
    touch "$TEST_DIR/web/script.js"

    touch "$TEST_DIR/config/database.conf"
    touch "$TEST_DIR/config/api_keys.conf"
    touch "$TEST_DIR/config/settings.conf"

    touch "$TEST_DIR/scripts/deploy.sh"
    touch "$TEST_DIR/scripts/backup.sh"

    touch "$TEST_DIR/data/users.txt"
    touch "$TEST_DIR/data/logs.txt"

    chmod 777 "$TEST_DIR/web/index.html"
    chmod 755 "$TEST_DIR/web/style.css"
    chmod 644 "$TEST_DIR/web/script.js"

    chmod 666 "$TEST_DIR/config/database.conf"
    chmod 644 "$TEST_DIR/config/api_keys.conf"
    chmod 755 "$TEST_DIR/config/settings.conf"

    chmod 755 "$TEST_DIR/scripts/deploy.sh"
    chmod 777 "$TEST_DIR/scripts/backup.sh"

    chmod 666 "$TEST_DIR/data/users.txt"
    chmod 640 "$TEST_DIR/data/logs.txt"

    chmod 777 "$TEST_DIR/uploads"

    echo "Test files created in: $TEST_DIR"
}


find_world_writable() {
    count=0

    while IFS= read -r item; do
        perms=$(stat -c "%a" "$item")

        if [ -f "$item" ]; then
            echo "[FILE] $item ($perms)"
        elif [ -d "$item" ]; then
            echo "[DIR]  $item ($perms)"
        fi

        ((count++))
    done < <(find "$TEST_DIR" -perm -002)

    echo
    echo "Found $count world-writable items"
}

find_executable_non_scripts() {
    count=0

    while IFS= read -r file; do
        perms=$(stat -c "%a" "$file")
        echo "[EXEC] $file ($perms)"
        ((count++))
    done < <(find "$TEST_DIR" -type f \( -name "*.html" -o -name "*.css" -o -name "*.txt" -o -name "*.conf" \) -perm /111)

    echo
    echo "Found $count files that shouldn't be executable"
}

main() {
    echo "========================================"
    echo "File Permission Security Scanner"
    echo "========================================"

    echo "Setting up test environment..."
    setup_test_environment

    echo
    echo "========================================"
    echo "Scanning for INSECURE Files/Directories"
    echo "========================================"
    echo

    echo "--- World-Writable Files & Directories ---"
    echo
    find_world_writable

    echo
    echo "--- Executable Non-Script Files ---"
    echo
    find_executable_non_scripts

    echo
    echo "========================================"
    echo "Security Scan Complete"
    echo "========================================"
}

main
