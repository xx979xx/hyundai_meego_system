/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gn_stdio.h - Abstraction of limited subset of stdio functions.
 */

#ifndef	_GN_STDIO_H_
#define _GN_STDIO_H_

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

/*
 * ANSI Compliant Functions 
 */

/* Read a single line from the passed file, null-terminating,
 * leaving the newline at the end, and leaving the file pointer
 * in the correct place.
 *
 * handle: The handle of the file to read data from
 * buffer: Data pointer to read data into
 * size  : The maximum size in bytes to read from the file
 */
gn_uchar_t*
gn_fgets(
	gn_uchar_t* buffer,
	gn_size_t size,
	gn_handle_t handle
	);

/*
 * Non-ANSI Compliant Functions
 */

/* Read a single line from the passed file, null-terminating,
 * removing the newline (and carriage return) at the end, and
 * leaving the file pointer in the right place.
 *
 * handle: The handle of the file to read data from
 * buffer: Data pointer to read data into
 * size  : The maximum size in bytes to read from the file
 */
gn_uchar_t*
gnfs_readln(
	gn_handle_t handle,
	gn_uchar_t* buffer,
	gn_size_t size
	);


/* Produce an output according to the specified output format string and
 * supplied variable length parameter list. Do not write more than size
 * characters to the output string.
 *
 * Upon successful return, these functions return the number of characters
 * printed (not including the trailing '\0' used to end output to strings).
 * If an output error is encountered, a negative value is returned.
 *
 * s     : The destination for the formatted output
 * size  : The maximum number of bytes to write to s
 * format: The format strings
 * ...   : The arguments for the format string
 */
gn_int32_t
gn_snprintf(
	gn_uchar_t* s,
	gn_size_t size,
	const gn_uchar_t* format,
	...);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_STDIO_H_ */
