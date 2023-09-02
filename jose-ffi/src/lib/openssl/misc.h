/* vim: set tabstop=8 shiftwidth=4 softtabstop=4 expandtab smarttab colorcolumn=80: */
/*
 * Copyright 2016 Red Hat, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once

#include "compat.h"

#include <jansson.h>
#include <stdbool.h>
#include <stdint.h>

#define KEYMAX 1024

#define containerof(ptr, type, member) \
    ((type *)((char *) ptr - offsetof(type, member)))

#define declare_cleanup_full(type, prfx) \
    static inline void \
    type ## _auto(type **p) { \
        if (!p) return; \
        prfx ## _free(*p); \
        *p = NULL; \
    }

#define declare_cleanup(type) declare_cleanup_full(type, type)

#define openssl_auto(type) type __attribute__((cleanup(type ## _auto)))

declare_cleanup_full(BIGNUM, BN_clear)

size_t
str2enum(const char *str, ...);

BIGNUM *
bn_decode(const uint8_t buf[], size_t len);

BIGNUM *
bn_decode_json(const json_t *json);

bool
bn_encode(const BIGNUM *bn, uint8_t buf[], size_t len);

json_t *
bn_encode_json(const BIGNUM *bn, size_t len);

bool
add_entity(json_t *root, json_t *obj, const char *plural, ...);

bool
copy_val(const json_t *from, json_t *into, ...);
