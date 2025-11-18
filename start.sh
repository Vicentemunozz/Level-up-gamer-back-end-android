#!/usr/bin/env bash
set -euo pipefail

# Start script for Render or container runtime
# - Exports JAVA_HOME (uses existing env var if set, otherwise defaults to Java 17 path)
# - Runs the built JAR from target/

JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}
export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"

echo "Using JAVA_HOME=$JAVA_HOME"

# Find the first matching JAR in target/
JAR=$(ls target/*.jar 2>/dev/null | head -n 1 || true)
if [ -z "$JAR" ]; then
  echo "No jar found in target/. Did the build succeed?" >&2
  ls -la target || true
  exit 1
fi

echo "Starting $JAR"
exec java -jar "$JAR"
