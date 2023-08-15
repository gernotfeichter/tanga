# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(jose_ffi_library VERSION 0.0.1 LANGUAGES C)

add_library(jose_ffi SHARED
  "jose_ffi.c"
)

set_target_properties(jose_ffi PROPERTIES
  PUBLIC_HEADER jose_ffi.h
  OUTPUT_NAME "jose_ffi"
)

target_compile_definitions(jose_ffi PUBLIC DART_SHARED_LIB)
