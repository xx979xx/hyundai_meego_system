/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gnepal_ctype.h - Character Manipulation functions
 */

#ifndef	_GNEPAL_CTYPE_H_
#define _GNEPAL_CTYPE_H_

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

/* Return a non-zero value if c is an alphanumberic character,
 * otherwise return 0
 */
gn_bool_t 
gnepal_isalnum(gn_uchar_t c);

/* Return a non-zero value if c is an alphabetic character,
 * otherwise return 0
 */
gn_bool_t 
gnepal_isalpha(gn_uchar_t c);

/* Return a non-zero value if c is a digit,
 * otherwise return 0
 */
gn_bool_t 
gnepal_isdigit(gn_uchar_t c);

/* Return a non-zero value if c is a hexedicimal character,
 * otherwise return 0
 */
gn_bool_t 
gnepal_isxdigit(gn_uchar_t c);

/* Return a non-zero value if c is a lower case character,
 * otherwise return 0
 */
gn_bool_t 
gnepal_islower(gn_uchar_t c);

/* Return a non-zero value if c is whitespace,
 * otherwise return 0
 */
gn_bool_t 
gnepal_isspace(gn_uchar_t c);

/* Return a non-zero value if c is an upper case character,
 * otherwise return 0
 */
gn_bool_t 
gnepal_isupper(gn_uchar_t c);

/* Convert a character to a lower case
 */
gn_uchar_t
gnepal_tolower(gn_uchar_t c);

/* Covert a character to upper case
 */
gn_uchar_t 
gnepal_toupper(gn_uchar_t c);


#ifdef __cplusplus
}
#endif 

#endif /* _GNEPAL_CTYPE_H_ */
