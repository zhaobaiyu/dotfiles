#!/bin/bash
# Test script for Debian installation scripts

set -e

echo "==================================="
echo "Testing Debian Installation Scripts"
echo "==================================="

# Function to run a test
run_test() {
    local test_name="$1"
    local distro="$2"
    local dockerfile="$3"

    echo ""
    echo "🧪 Running test: $test_name"
    echo "-----------------------------------"

    docker build -f "$dockerfile" -t "chezmoi-test-$distro" . && \
    echo "✅ $test_name: PASSED" || \
    echo "❌ $test_name: FAILED"
}

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker to run tests."
    exit 1
fi

echo ""
echo "1️⃣  Syntax Check"
echo "-----------------------------------"
bash -n run_onchange_before_install_debian.sh && \
    echo "✅ Debian install script: Syntax OK" || \
    echo "❌ Debian install script: Syntax Error"

if [ -f run_onchange_after_configure_debian.sh.tmpl ]; then
    bash -n run_onchange_after_configure_debian.sh.tmpl && \
        echo "✅ Debian configure script: Syntax OK" || \
        echo "❌ Debian configure script: Syntax Error"
fi

echo ""
echo "2️⃣  Docker Container Tests"
echo "-----------------------------------"

# Test on Debian
if [ -f test-debian.Dockerfile ]; then
    run_test "Debian Bookworm" "debian" "test-debian.Dockerfile"
fi

# Test on Ubuntu
if [ -f test-ubuntu.Dockerfile ]; then
    run_test "Ubuntu 22.04" "ubuntu" "test-ubuntu.Dockerfile"
fi

echo ""
echo "==================================="
echo "Test Summary"
echo "==================================="
echo "All tests completed. Check output above for results."
echo ""
echo "💡 To interactively test in a container, run:"
echo "   docker build -f test-debian.Dockerfile -t chezmoi-test-debian ."
echo "   docker run -it chezmoi-test-debian /bin/bash"
echo ""
echo "   Then you can check:"
echo "   - which fish"
echo "   - fish --version"
echo "   - ls ~/.oh-my-zsh"
echo "   - ls ~/.local/bin"
echo "   - etc."
