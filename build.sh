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

# Diagnostic block: print java/javac info and available JVMs so Render build logs show what's installed
echo "--- Diagnostic: environment ---"
echo "PATH=$PATH"
echo "Which java: $(command -v java || true)"
echo "Which javac: $(command -v javac || true)"
if [ -x "$JAVA_HOME/bin/java" ]; then
  echo "java from JAVA_HOME:"; "$JAVA_HOME/bin/java" -version || true
else
  echo "NOTE: $JAVA_HOME/bin/java is not executable or does not exist"
fi
if [ -x "$JAVA_HOME/bin/javac" ]; then
  echo "javac from JAVA_HOME:"; "$JAVA_HOME/bin/javac" -version || true
else
  echo "NOTE: $JAVA_HOME/bin/javac is not executable or does not exist"
fi
echo "Listing /usr/lib/jvm (if present):"
ls -la /usr/lib/jvm || true
echo "Find java installations under /usr/lib/jvm:"
find /usr/lib/jvm -maxdepth 3 -type f -name java -o -name javac 2>/dev/null || true
echo "--- End diagnostic ---"

# Run the maven build (skip tests for faster build in CI; remove -DskipTests if you want tests)
./mvnw -B -DskipTests clean package

echo "Build finished: status=$?"
