cmake_minimum_required(VERSION 3.13)

project(jose_ffi)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_POLICY_DEFAULT_CMP0079 NEW)

add_library(jose_ffi SHARED
  misc.c           misc.h
  cfg.c
  io.c
  b64.c
  hsh.c            hsh.h
  hooks.c           hooks.h
  jwk.c
  jws.c
  jwe.c
  zlib/deflate.c
  openssl/aescbch.c
  openssl/aesgcm.c
  openssl/aesgcmkw.c
  openssl/aeskw.c
  openssl/compat.c openssl/compat.h
  openssl/dir.c
  openssl/ec.c
  openssl/ecdh.c
  openssl/ecdhes.c
  openssl/ecmr.c
  openssl/ecdsa.c
  openssl/hash.c
  openssl/hmac.c
  openssl/jwk.c
  openssl/lock.c
  openssl/misc.c   openssl/misc.h
  openssl/oct.c
  openssl/pbes2.c
  openssl/rsa.c
  openssl/rsaes.c
  openssl/rsassa.c
)

target_include_directories(jose_ffi PUBLIC
  include
)

target_link_libraries(jose_ffi
  zlib
  jansson
  libcrypto
  threads
)