cmake_minimum_required(VERSION 3.13)

project(jose)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_POLICY_DEFAULT_CMP0079 NEW)

include_directories(include)
include_directories(include/jose)

add_subdirectory(include)
add_subdirectory(include/jose)
add_subdirectory(lib)
add_subdirectory(cmd)

target_link_libraries(cmd jose_ffi)
