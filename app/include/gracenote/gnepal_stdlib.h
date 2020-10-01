/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gnepal_stdlib.h - Abstraction of limited subset of stdlib functions.
 */

#ifndef	_GNEPAL_STDLIB_H_
#define _GNEPAL_STDLIB_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Prototypes.
 */

/* Convert a string representation of a signed 32 bit number
 * into a signed integer type
 *
 * Returns 0 if there was a conversion error
 *
 * s: The string containing the data to convert
 */
gn_int32_t 
gnepal_atoi32(const gn_uchar_t *s);

/* Convert a string representation of an unsigned 32 bit number
 * into an unsigned integer type
 *
 * Returns 0 if there was a conversion error
 *
 * s: The string containing the data to convert
 */
gn_uint32_t 
gnepal_atou32(const gn_uchar_t *s);

/* Converts the initial part of the string in s to a long integer
 * value according to the given base, which must be between 2 and 36
 * inclusive, or be the special value 0.
 *
 * If base is zero or 16, the string may then include a '0x' prefix,
 * and the number will be read in base 16; otherwise, a zero base is
 * taken as 10 (decimal) unless the next character is '0', in which
 * case  it is taken as 8 (octal).
 *
 * Returns 0 if there was a conversion error
 *
 * s   : The string containing the data to convert
 * endp: If endptr is not GN_NULL, gn_strtol() stores the address of
 *       the first invalid character in *endp. If there were no digits
 *       at all, gn_strtol() stores the original value of s in *endp
 *       (and returns 0). In particular, if *s is not '\0' but **endp
 *       is  '\0' on return, the entire string is valid.
 * base: The base of the number represented by s
 */
gn_int32_t 
gnepal_strtol(const gn_uchar_t * s, gn_uchar_t ** endp, gn_int16_t base);

/* Converts the initial part of the string in s to an unsigned
 * long integer value according to the given base, which must be between
 * 2 and 36 inclusive, or be the special value 0.
 *
 * If base is zero or 16, the string may then include a '0x' prefix,
 * and the number will be read in base 16; otherwise, a zero base is
 * taken as 10 (decimal) unless the next character is '0', in which
 * case  it is taken as 8 (octal).
 *
 * Returns 0 if there was a conversion error
 *
 * s   : The string containing the data to convert
 * endp: If endptr is not GN_NULL, gn_strtol() stores the address of
 *       the first invalid character in *endp. If there were no digits
 *       at all, gn_strtol() stores the original value of s in *endp
 *       (and returns 0). In particular, if *s is not '\0' but **endp
 *       is  '\0' on return, the entire string is valid.
 * base: The base of the number represented by s
 */
gn_uint32_t 
gnepal_strtoul(const gn_uchar_t * s, gn_uchar_t ** endp, gn_int16_t base);

/* Returns a signed 32 bit integer between 0 and GN_RAND_MAX
 */
gn_int32_t 
gnepal_rand(void);

#ifdef __cplusplus
}
#endif 

#endif /* _GNEPAL_STDLIB_H_ */
