/*
 * Copyright (c) 2004 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_math.h - Abstraction of limited subset of mathlib functions.
 *
 * NOTE: These functions are only needed if MusicID functionality exists
 *       on the device.
 */

#ifndef	_GN_MATH_H_
#define _GN_MATH_H_

/*
 * Dependencies.
 */
#include "gn_abs_types.h"

#ifdef __cplusplus
extern "C"{
#endif 

gn_int32_t gn_min(gn_int32_t x, gn_int32_t y);

/* 
 * These floating point functions are only necessary if your 
 * configuration supports Floating Point MusicID-File
 */
gn_flt64_t gn_sqrt(gn_flt64_t x);
gn_flt64_t gn_sin(gn_flt64_t x);
gn_flt64_t gn_cos(gn_flt64_t x);
gn_flt64_t gn_fabs(gn_flt64_t x);
gn_flt64_t gn_floor(gn_flt64_t x);
gn_flt64_t gn_log(gn_flt64_t x);
gn_flt64_t gn_exp(gn_flt64_t x);
gn_flt64_t gn_pow(gn_flt64_t x, gn_flt64_t y);

#ifdef __cplusplus
}
#endif 
    
#endif
