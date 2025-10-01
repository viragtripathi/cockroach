# Building CockroachDB for ppc64le (PowerPC 64-bit Little Endian)

This document describes how to build CockroachDB for the ppc64le architecture.

## Overview

CockroachDB now supports cross-compilation for ppc64le (PowerPC 64-bit Little Endian) architecture. This support is similar to the s390x support and allows building CockroachDB binaries that run on IBM POWER systems.

## Prerequisites

### On Linux (Native Build)

Install the ppc64le cross-compilation toolchain:

```bash
# Debian/Ubuntu
sudo apt-get install gcc-powerpc64le-linux-gnu g++-powerpc64le-linux-gnu

# RHEL/CentOS/Fedora
sudo dnf install gcc-powerpc64le-linux-gnu g++-powerpc64le-linux-gnu
```

### On macOS (Docker Build)

Since macOS doesn't natively support Linux cross-compilation, use Docker or Podman:

```bash
# Build the Docker image
docker build -f Dockerfile.ppc64le-builder -t cockroach-ppc64le-builder .

# Run the build in Docker
docker run -v $(pwd):/work -it cockroach-ppc64le-builder bash
```

## Building

### Quick Build

Use the provided helper script:

```bash
./build-ppc64le.sh
```

Or for a specific target:

```bash
./build-ppc64le.sh cockroach-short  # Faster build without UI
./build-ppc64le.sh workload         # Build workload tool
```

### Manual Build

Use the `./dev` tool with the ppc64le cross-compilation configuration:

```bash
# Full build with UI
./dev build cockroach --config=crosslinuxppc64le

# Faster build without UI
./dev build short --config=crosslinuxppc64le

# Build specific packages
./dev build workload --config=crosslinuxppc64le
```

### Docker Build

Inside the Docker container:

```bash
cd /work
./dev build cockroach --config=crosslinuxppc64le
```

## Output Location

After a successful build, the binary will be located at:

```
_bazel/bin/pkg/cmd/cockroach/cockroach_/cockroach
```

## Verification

To verify the binary architecture:

```bash
file _bazel/bin/pkg/cmd/cockroach/cockroach_/cockroach
```

You should see output indicating it's a PowerPC 64-bit LSB executable.

## Technical Details

### Toolchain Configuration

The ppc64le support uses:
- **Target Triple**: `powerpc64le-unknown-linux-gnu`
- **Platform**: `//build/platforms:linux_ppc64le_target`
- **Toolchain**: Local system toolchain at `/usr/bin/powerpc64le-linux-gnu-*`

### Files Modified

The following files were added/modified to support ppc64le:

1. **WORKSPACE** - Added ppc64le Go SDK and registered toolchains
2. **build/toolchains/BUILD.bazel** - Added ppc64le platform and toolchain definitions
3. **build/toolchains/REPOSITORIES.bzl** - Added ppc64le toolchain repository
4. **build/toolchains/local_ppc64le_toolchain.bzl** - Custom toolchain using system compiler
5. **.bazelrc** - Added `crosslinuxppc64le` configuration
6. **build/platforms/BUILD.bazel** - Added ppc64le platform constraints

### Cross-Compilation Flags

The build uses these configurations:

```bash
--config=crosslinuxppc64le
--platforms=//build/toolchains:cross_linux_ppc64le
--workspace_status_command=./build/bazelutil/stamp.sh -t powerpc64le-unknown-linux-gnu
```

## Building a Proper Toolchain (Advanced)

The current implementation uses the system's cross-compiler. For a production-ready build, you may want to build a proper crosstool-ng toolchain:

### Creating a crosstool-ng Configuration

A sample configuration file would need to be created at:
`build/toolchains/toolchainbuild/crosstool-ng/powerpc64le-unknown-linux-gnu.config`

Key configuration options:
```
CT_ARCH_POWERPC=y
CT_ARCH="powerpc"
CT_ARCH_64=y
CT_ARCH_LE=y
CT_TARGET_VENDOR="unknown"
CT_LINUX_KERNEL_VERSION="5.10.x"
CT_GLIBC_VERSION="2.31"
CT_GCC_VERSION="10.3.0"
```

### Building the Toolchain

```bash
cd build/toolchains/toolchainbuild/crosstool-ng
docker run --rm -v $(pwd):/bootstrap \
  -v $(pwd)/artifacts:/artifacts \
  ubuntu:focal-20210119 /bootstrap/perform-build.sh
```

This would create a toolchain tarball that can be uploaded to Google Cloud Storage.

## Troubleshooting

### Missing Toolchain Error

If you see errors about missing toolchain, ensure:
1. The ppc64le cross-compiler is installed
2. The compiler is in your PATH: `/usr/bin/powerpc64le-linux-gnu-gcc`

### Bazel Cache Issues

Clear the Bazel cache if you encounter strange errors:

```bash
bazel clean --expunge
```

### Go SDK Issues

The ppc64le Go SDK is configured in WORKSPACE. If you need a different version:

1. Update the version in `WORKSPACE` (search for `linux_ppc64le`)
2. Update the SHA256 hash
3. Run `./dev generate bazel`

## Known Limitations

1. **Pre-built Toolchain**: Currently uses system toolchain, not a pre-built crosstool-ng toolchain
2. **CI/CD**: Not integrated into official CI/CD pipelines yet
3. **Testing**: Limited testing on actual ppc64le hardware

## See Also

- [s390x Build Documentation](docs/) - Similar architecture with official support
- [CockroachDB Build System](CLAUDE.md) - General build system documentation
- [Cross-Compilation in Bazel](https://bazel.build/docs/platforms)

## Contributing

If you improve ppc64le support, please consider contributing back:
1. Build and test the toolchain
2. Upload the toolchain tarball to a public location
3. Update REPOSITORIES.bzl with the proper SHA256
4. Submit a PR with your improvements

