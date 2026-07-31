#!/bin/bash

# Check if file name argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <elf_file>"
    exit 1
fi

file_name="$1"

# Check if file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi

# Check if file is a valid ELF file using readelf or file command
if ! readelf -h "$file_name" >/dev/null 2>&1; then
    echo "Error: File '$file_name' is not a valid ELF file."
    exit 1
fi

# Source messages.sh if available, or define the function locally
if [ -f "./messages.sh" ]; then
    source ./messages.sh
else
    display_elf_header_info() {
        echo "ELF Header Information for '$file_name':"
        echo "----------------------------------------"
        echo "Magic Number: $magic_number"
        echo "Class: $class"
        echo "Byte Order: $byte_order"
        echo "Entry Point Address: $entry_point_address"
    }
fi

# Extract ELF header information using readelf
magic_number=$(readelf -h "$file_name" | grep "Magic:" | sed 's/.*Magic:[ \t]*//')
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{print $2, $3}')
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

display_elf_header_info
