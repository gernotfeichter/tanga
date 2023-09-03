cmake_minimum_required(VERSION 3.13)

project(jose)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_POLICY_DEFAULT_CMP0079 NEW)

# Install the header files
install(
  FILES
    jose.h
    cfg.h
    io.h
    b64.h
    jwk.h
    jws.h
    jwe.h
    openssl.h
  DESTINATION include/${PROJECT_NAME}
)