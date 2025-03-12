#!/bin/bash

# Script to compile Swift sources into standalone executables
# This script should be run on a development machine with developer tools

echo "Compiling Default App Scripts into standalone executables..."

# Check if swiftc is available
if ! command -v swiftc &> /dev/null; then
    echo "Error: swiftc compiler not found."
    echo "Please make sure you have Xcode or the Command Line Tools installed."
    exit 1
fi

# Create bin directory if it doesn't exist
mkdir -p bin

# Compile SetDefaultApp (primary tool)
echo "Compiling SetDefaultApp..."
swiftc -o bin/SetDefaultApp SetDefaultApp.swift
if [ $? -ne 0 ]; then
    echo "Failed to compile SetDefaultApp."
    exit 1
fi

# Set executable permissions
chmod +x bin/SetDefaultApp

echo "Successfully compiled executables to the 'bin' directory:"
echo "  - bin/SetDefaultApp"
echo ""
echo "These executables can now be distributed to systems without developer tools."