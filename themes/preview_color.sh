#!/bin/bash

# Check if file argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <theme_file.conf>"
    echo "Example: $0 catppuccin_frappe_tmux.conf"
    exit 1
fi

THEME_FILE="$1"

# Check if file exists
if [ ! -f "$THEME_FILE" ]; then
    echo "Error: File '$THEME_FILE' not found!"
    exit 1
fi

# Function to convert hex to RGB
hex_to_rgb() {
    local hex=$1
    # Remove # if present
    hex=${hex#\#}

    # Extract RGB components
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))

    echo "$r $g $b"
}

# Function to display colored square with color info
show_color() {
    local name=$1
    local hex=$2

    # Convert hex to RGB
    read -r r g b <<< "$(hex_to_rgb "$hex")"

    # Create colored square using background color + space
    local colored_square="\033[48;2;${r};${g};${b}m  \033[0m"

    # Display: name: colored_square (hex_code)
    printf "%-15s %b (%s)\n" "$name:" "$colored_square" "$hex"
}

# Extract theme name from file
THEME_NAME=$(basename "$THEME_FILE" .conf | sed 's/catppuccin_//' | sed 's/_tmux//')

echo "🎨 Catppuccin ${THEME_NAME^} Color Palette"
echo "======================================"

# Parse the theme file and extract colors
while IFS= read -r line; do
    # Match lines like: set -ogq @thm_bg "#24273a"
    if [[ $line =~ set\ -ogq\ @(thm_[a-zA-Z_0-9]+)\ \"(#[0-9a-fA-F]{6})\" ]]; then
        color_name="${BASH_REMATCH[1]}"
        color_hex="${BASH_REMATCH[2]}"
        show_color "$color_name" "$color_hex"
    fi
done < "$THEME_FILE"

echo ""
