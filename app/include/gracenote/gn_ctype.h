/*
 * Copyright (c) 2001 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gn_ctype.h - Character Manipulation functions
 */

#ifndef	_GN_CTYPE_H_
#define _GN_CTYPE_H_

/*
 * Dependencies.
 */

#include "gn_abs_types.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Prototypes.
 */

/* Return a non-zero value if c is an alphanumberic character,
 * otherwise return 0
 */
gn_int16_t
gn_isalnum(
	gn_int16_t c
	);

/* Return a non-zero value if c is an alphabetic character,
 * otherwise return 0
 */
gn_int16_t
gn_isalpha(
	gn_int16_t c
	);

/* Return a non-zero value if c is a digit,
 * otherwise return 0
 */
gn_int16_t
gn_isdigit(
	gn_int16_t c
	);

/* Return a non-zero value if c is a hexedicimal character,
 * otherwise return 0
 */
gn_int16_t
gn_isxdigit(
	gn_int16_t c
	);

/* Return a non-zero value if c is a lower case character,
 * otherwise return 0
 */
gn_int16_t
gn_islower(
	gn_int16_t c
	);

/* Return a non-zero value if c is whitespace,
 * otherwise return 0
 */
gn_int16_t
gn_isspace(
	gn_int16_t c
	);

/* Return a non-zero value if c is an upper case character,
 * otherwise return 0
 */
gn_int16_t
gn_isupper(
	gn_int16_t c
	);

/* Convert a character to a lower case
 */
gn_int16_t
gn_tolower(
	gn_int16_t c
	);

/* Covert a character to upper case
 */
gn_int16_t
gn_toupper(
	gn_int16_t c
	);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_CTYPE_H_ */
