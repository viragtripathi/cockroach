"""Local ppc64le toolchain that uses system compiler."""

def _local_ppc64le_toolchain_impl(rctx):
    """Creates a toolchain repository using the system's ppc64le compiler."""
    
    # Create BUILD file
    build_content = """
load(":cc_toolchain_config.bzl", "cc_toolchain_config")

package(default_visibility = ["//visibility:public"])

cc_toolchain_config(name = "toolchain_config")

filegroup(name = "empty")

filegroup(
    name = "all_files",
    srcs = [
        ":compiler_files",
        ":linker_files",
        ":ar_files",
    ],
)

filegroup(
    name = "compiler_files",
    srcs = [":empty"],
)

filegroup(
    name = "linker_files",
    srcs = [":empty"],
)

filegroup(
    name = "ar_files",
    srcs = [":empty"],
)

cc_toolchain(
    name = "toolchain",
    toolchain_identifier = "powerpc64le-cross-toolchain",
    toolchain_config = ":toolchain_config",
    all_files = ":all_files",
    ar_files = ":ar_files",
    compiler_files = ":compiler_files",
    dwp_files = ":empty",
    linker_files = ":linker_files",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
)
"""
    
    rctx.file("BUILD", build_content)
    
    # Create cc_toolchain_config.bzl
    config_content = """
load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
     "feature",
     "flag_group",
     "flag_set",
     "tool_path",
     "with_feature_set")
load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")

def _impl(ctx):
    tool_paths = [
        tool_path(name = "ar", path = "/usr/bin/powerpc64le-linux-gnu-ar"),
        tool_path(name = "cpp", path = "/usr/bin/powerpc64le-linux-gnu-cpp"),
        tool_path(name = "gcc", path = "/usr/bin/powerpc64le-linux-gnu-gcc"),
        tool_path(name = "g++", path = "/usr/bin/powerpc64le-linux-gnu-g++"),
        tool_path(name = "gcov", path = "/usr/bin/powerpc64le-linux-gnu-gcov"),
        tool_path(name = "ld", path = "/usr/bin/powerpc64le-linux-gnu-ld"),
        tool_path(name = "nm", path = "/usr/bin/powerpc64le-linux-gnu-nm"),
        tool_path(name = "objcopy", path = "/usr/bin/powerpc64le-linux-gnu-objcopy"),
        tool_path(name = "objdump", path = "/usr/bin/powerpc64le-linux-gnu-objdump"),
        tool_path(name = "strip", path = "/usr/bin/powerpc64le-linux-gnu-strip"),
    ]

    all_link_actions = [
        ACTION_NAMES.cpp_link_executable,
        ACTION_NAMES.cpp_link_dynamic_library,
        ACTION_NAMES.cpp_link_nodeps_dynamic_library,
    ]

    all_compile_actions = [
        ACTION_NAMES.c_compile,
        ACTION_NAMES.cpp_compile,
        ACTION_NAMES.linkstamp_compile,
        ACTION_NAMES.assemble,
        ACTION_NAMES.preprocess_assemble,
        ACTION_NAMES.cpp_header_parsing,
        ACTION_NAMES.cpp_module_compile,
        ACTION_NAMES.cpp_module_codegen,
        ACTION_NAMES.clif_match,
        ACTION_NAMES.lto_backend,
    ]

    default_link_flags_feature = feature(
        name = "default_link_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-lstdc++",
                            "-lm",
                            "-Wl,-z,relro,-z,now",
                            "-no-canonical-prefixes",
                            "-pass-exit-codes",
                        ],
                    ),
                ],
            ),
        ],
    )

    default_compile_flags_feature = feature(
        name = "default_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-U_FORTIFY_SOURCE",
                            "-D_FORTIFY_SOURCE=1",
                            "-fstack-protector",
                            "-Wall",
                            "-no-canonical-prefixes",
                            "-fno-omit-frame-pointer",
                        ],
                    ),
                ],
            ),
        ],
    )

    supports_pic_feature = feature(name = "supports_pic", enabled = True)
    supports_dynamic_linker_feature = feature(name = "supports_dynamic_linker", enabled = True)

    features = [
        default_compile_flags_feature,
        default_link_flags_feature,
        supports_pic_feature,
        supports_dynamic_linker_feature,
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        toolchain_identifier = "powerpc64le-cross-toolchain",
        host_system_name = "local",
        target_system_name = "powerpc64le-unknown-linux-gnu",
        target_cpu = "ppc",
        target_libc = "glibc",
        compiler = "gcc",
        abi_version = "local",
        abi_libc_version = "local",
        tool_paths = tool_paths,
        cxx_builtin_include_directories = [
            "/usr/powerpc64le-linux-gnu/include/c++/12",
            "/usr/powerpc64le-linux-gnu/include/c++/12/powerpc64le-linux-gnu",
            "/usr/powerpc64le-linux-gnu/include",
            "/usr/lib/gcc-cross/powerpc64le-linux-gnu/12/include",
            "/usr/lib/gcc-cross/powerpc64le-linux-gnu/12/include-fixed",
        ],
    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)
"""
    
    rctx.file("cc_toolchain_config.bzl", config_content)

local_ppc64le_toolchain = repository_rule(
    implementation = _local_ppc64le_toolchain_impl,
    local = True,
)

