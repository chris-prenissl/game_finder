#!/bin/zsh
COVERAGE_DIR="coverage"
OUTPUT_HTML="$COVERAGE_DIR/html/index.html"

rm -R "$COVERAGE_DIR"
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html --dark-mode
open "$OUTPUT_HTML"