#!/usr/bin/env bash
set -euo pipefail

# Build script for Render or CI
# - Ensures JAVA_HOME (defaults to Java 17 path commonly available on Linux)
# - Ensures ./mvnw is executable (fixes permission denied on some checkouts)
# - Runs Maven wrapper to build the project

JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}
export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"

echo "Using JAVA_HOME=$JAVA_HOME"

# If mvnw exists but is not executable, try to make it executable
if [ -f "./mvnw" ] && [ ! -x "./mvnw" ]; then
  echo "Fixing mvnw permissions..."
  chmod +x ./mvnw || true
fi

# Run the maven build (skip tests for faster build in CI; remove -DskipTests if you want tests)
./mvnw -B -DskipTests clean package

echo "Build finished: status=$?"
