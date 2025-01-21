#!/bin/bash

# Get the current dark mode status
current_status=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

# Determine the next dark mode status
if [ "$current_status" == "Dark" ]; then
    next_status=false  # Turn off dark mode
else
    next_status=true   # Turn on dark mode
fi

# Use AppleScript to toggle dark mode
osascript <<EOF
tell application "System Events"
    tell appearance preferences
        set dark mode to $next_status
    end tell
end tell
EOF

echo "Dark mode toggled. Current status: $(defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light')"
