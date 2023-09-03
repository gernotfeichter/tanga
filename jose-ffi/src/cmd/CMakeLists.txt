cmake_minimum_required(VERSION 3.13)

project(cmd)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_POLICY_DEFAULT_CMP0079 NEW)

add_executable(cmd
  jose.c jose.h
  b64/b64.h
  b64/dec.c
  b64/enc.c
  jwk/jwk.h
  jwk/eql.c
  jwk/exc.c
  jwk/gen.c
  jwk/pub.c
  jwk/thp.c
  jwk/use.c
  jws/jws.h
  jws/fmt.c
  jws/sig.c
  jws/ver.c
  jwe/jwe.h
  jwe/pwd.h
  jwe/fmt.c
  jwe/dec.c
  jwe/enc.c
  alg.c
  fmt.c
)

# target_link_libraries(cmd jose_ffi)
target_link_libraries(cmd jose_ffi)