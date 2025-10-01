#!/usr/bin/env bash

# Build CockroachDB for ppc64le (PowerPC 64-bit Little Endian)
# This script helps build CockroachDB for ppc64le architecture using cross-compilation.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Building CockroachDB for ppc64le ==="
echo ""

# Check if required cross-compilation tools are available
check_tools() {
    echo "Checking for required tools..."
    local missing_tools=()
    
    for tool in powerpc64le-linux-gnu-gcc powerpc64le-linux-gnu-g++ powerpc64le-linux-gnu-ar; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        echo "ERROR: Missing required cross-compilation tools:"
        printf '  - %s\n' "${missing_tools[@]}"
        echo ""
        echo "On Debian/Ubuntu, install with:"
        echo "  sudo apt-get install gcc-powerpc64le-linux-gnu g++-powerpc64le-linux-gnu"
        echo ""
        echo "On macOS, you'll need to use Docker with the provided Dockerfile.ppc64le-builder"
        exit 1
    fi
    
    echo "✓ All required tools found"
    echo ""
}

# Check if running on macOS and suggest Docker
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "WARNING: Building on macOS requires Docker/Podman for cross-compilation."
    echo ""
    echo "You can build using Docker:"
    echo "  docker build -f Dockerfile.ppc64le-builder -t cockroach-ppc64le-builder ."
    echo "  docker run -v \$(pwd):/work cockroach-ppc64le-builder ./build-ppc64le.sh --docker"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Check for --docker flag
if [[ "${1:-}" == "--docker" ]]; then
    echo "Running in Docker mode..."
    export CC=powerpc64le-linux-gnu-gcc
    export CXX=powerpc64le-linux-gnu-g++
fi

check_tools

# Determine what to build
BUILD_TARGET="${1:-cockroach}"
if [[ "$BUILD_TARGET" == "--docker" ]]; then
    BUILD_TARGET="${2:-cockroach}"
fi

echo "Building target: $BUILD_TARGET"
echo ""

# Build using bazel directly with ppc64le cross-compilation config
echo "Starting build..."
if [[ "$BUILD_TARGET" == "cockroach" ]]; then
    bazel build //pkg/cmd/cockroach --config=crosslinuxppc64le
elif [[ "$BUILD_TARGET" == "short" ]]; then
    bazel build //pkg/cmd/cockroach-short --config=crosslinuxppc64le
elif [[ "$BUILD_TARGET" == "workload" ]]; then
    bazel build //pkg/cmd/workload --config=crosslinuxppc64le
else
    bazel build "//pkg/cmd/$BUILD_TARGET" --config=crosslinuxppc64le
fi

echo ""
echo "=== Build Complete! ==="
echo ""
echo "The ppc64le binary should be in:"
echo "  _bazel/bin/pkg/cmd/cockroach/cockroach_/cockroach"
echo ""

