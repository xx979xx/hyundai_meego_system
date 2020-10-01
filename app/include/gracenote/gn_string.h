/*
 * Copyright (c) 2000 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gn_string.h - String Manipulation functions
 */

#ifndef	_GN_STRING_H_
#define _GN_STRING_H_

/*
 * Dependencies.
 */

#include "gn_abs_types.h"

#ifdef __cplusplus
extern "C"{
#endif 


/*
 * Macros
 */


/*
 * Prototypes.
 */

/*************************************/
/*******	ANSI strings	**********/
/*************************************/

/* Concatenate up to size bytes of "from" onto "to"
 *
 * to  : The string to be concatenated to
 * from: The string to concatenate onto "to"
 */
gn_uchar_t*
gn_strncat(
	gn_uchar_t* to,
	const gn_uchar_t* from,
	gn_size_t count
	);


/* Find first occurrence of the specified character in string
 *
 * Returns a pointer to the first occurance of c in string. Returns
 * GN_NULL if c was not found.
 *
 * string: The string to search
 * c     : The character to search for
 */
gn_uchar_t*
gn_strchr(
	const gn_uchar_t* string,
	gn_int16_t c
	);

/* Compare two strings. If stringa < stringb return a value < 0.
 * If stringa > stringb return a value > 0. Return 0 if the two
 * strings are equal.
 *
 * stringa: The first string to compare
 * stringb: The second string to compare
 */
gn_int16_t
gn_strcmp(
	const gn_uchar_t* stringa,
	const gn_uchar_t* stringb
	);

/* Compute the length of the string in bytes
 *
 * string: The string to compute the length on
 */
gn_size_t
gn_strlen(
	const gn_uchar_t* string
	);

/* Compare two strings. If stringa < stringb return a value < 0.
 * If stringa > stringb return a value > 0. Return 0 if the two
 * strings are equal.
 *
 * Do not compare more than "size" characters when doing the comparison.
 *
 * stringa: The first string to compare
 * stringb: The second string to compare
 * size   : The maximum number of bytes to compare
 */
gn_int16_t
gn_strncmp(
	const gn_uchar_t* stringa,
	const gn_uchar_t* stringb,
	gn_size_t size
	);

/* Copy the first n characters of source to destination
 *
 * to   : the destination string
 * from : Thhe source string
 * count: The maximum number of characters to copy
 */
gn_uchar_t*
gn_strncpy(
	gn_uchar_t* to,
	const gn_uchar_t* from,
	gn_size_t count
	);

/* Find the last occurrence of specified character in string
 *
 * Returns a pointer to the last occurance of c in string. Returns
 * GN_NULL if c was not found.
 *
 * string: The string to search
 * c     : The character to search for
 */
gn_uchar_t*
gn_strrchr(
	const gn_uchar_t* string,
	gn_int16_t c
	);

/* Finds the specified string pattern in a string
 *
 * Returns a pointer to the start of the substring or GN_NULL if the
 * substring was not found.
 *
 * string : The string to search
 * pattern: The substring pattern to search for
 */
gn_uchar_t*
gn_strstr(
	const gn_uchar_t* string,
	const gn_uchar_t* pattern
	);

/* Tokenise the string
 *
 * Parses a string into a sequence of tokens. On
 * the first call the string to be parsed should be specified
 * in string.  In each subsequent call that should parse the same string,
 * string should be GN_NULL.
 *
 * The token argument specifies a set of characters that delimit the
 * tokens in the parsed string. The caller may specify different strings
 * in token in successive calls that parse the same string.
 *
 * Each call to gn_strtok() returns a pointer to a null-terminated string
 * containing the next token. This string does not include the delimiting
 * character. If no more tokens are found, GN_NULL is returned.
 *
 * string: The string to search
 * sep: The delimiters
 */
gn_uchar_t*
gn_strtok(
	gn_uchar_t* string,
	const gn_uchar_t* sep
	);

/*
 * Utility routines involving memory (move/copy/fill)
 *
 * Semantics match that of ANSI C.
 */

/* Copy memory from point A to point B, assuming NO overlap
 *
 * dest: Destination of the memory to be copied
 * src : Source of the memory to be copied
 * size: Number of bytes to copy
 */
void *
gnmem_memcpy(
	void *dest,
	const void *src,
	gn_size_t size
	);

/* Copy memory from point A to point B, allowing for overlap
 *
 * dest: Destination of the memory to be copied
 * src : Source of the memory to be copied
 * size: Number of bytes to copy
 */
void *
gnmem_memmove(
	void *dest,
	const void *src,
	gn_size_t size
	);

/* Set a range of memory to a specific value
 *
 * dest : The memory to modify
 * ch   : The value to set in the memory
 * count: The number of bytes to modify
 */
void *
gnmem_memset(
	void *dest,
	gn_int16_t ch,
	gn_size_t count
	);

/* Compare two regions of memory. If buff1 < buff2 return a value < 0.
 * If buff1 > buff2 return a value > 0. Return 0 if the two
 * buffers are equal.
 *
 * buff1: The first buffer to compare
 * buff2: The second buffer to compare
 * count: The number of bytes to compare
 */
gn_int16_t
gnmem_memcmp(
	const void *buff1,
	const void *buff2,
	gn_size_t count
	);


/*****************************************/
/*******	NON-ANSI strings	**********/
/*****************************************/

/* Compare two strings ignoring case.
 * If stringa < stringb return a value < 0.
 * If stringa > stringb return a value > 0. Return 0 if the two
 * strings are equal.
 *
 * stringa: The first string to compare
 * stringb: The second string to compare
 */
gn_int16_t
gn_stricmp(
	const gn_uchar_t* stringa,
	const gn_uchar_t* stringb
	);

/* Compare two strings ignoring case.
 * If stringa < stringb return a value < 0.
 * If stringa > stringb return a value > 0. Return 0 if the two
 * strings are equal.
 *
 * Do not compare more than "size" characters when doing the comparison.
 *
 * stringa: The first string to compare
 * stringb: The second string to compare
 * size   : The maximum number of bytes to compare
 */
gn_int16_t
gn_strnicmp(
	const gn_uchar_t* stringa,
	const gn_uchar_t* stringb,
	gn_size_t size
	);

/* Duplicates a C string, using gnmem_malloc to do the allocation.
 * Returns a pointer to a copy of the given string or GN_NULL if the
 * allocation failed or if the given string is null.
 *
 * str: The string to duplicate
 */
gn_uchar_t*
gn_strdup(
	const gn_uchar_t* str
	);

/* Convert (in place) a string to lower case
 *
 * str: The string to convert
 */
gn_uchar_t*
gn_strlwr(
	gn_uchar_t* str);

/* Perform a gn_strncpy but then make sure the string is properly
 * terminated because gn_strncpy doesn't do this for us.
 *
 * This function will place a '\0' at or before to[count-1]
 *
 * to   : the destination string
 * from : The source string
 * count: The maximum number of characters to copy
 */
gn_uchar_t*
gn_strncpy_term(
	gn_uchar_t* to,
	const gn_uchar_t* from,
	gn_size_t count
	);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_STRING_H_ */
