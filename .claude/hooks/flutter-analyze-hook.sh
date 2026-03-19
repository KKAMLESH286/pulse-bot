#!/bin/bash
# Stop hook that runs flutter analyze after code changes

# Run flutter analyze and capture output
OUTPUT=$(flutter analyze 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "Flutter analyze passed - no issues found"
else
    echo "Flutter analyze found issues:"
    echo "$OUTPUT"
    echo ""
    echo "Please fix the above issues before completing the task."
fi
