/*
 * Copyright (c) 2000 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * toc_util.h - handy stuff for dealing with TOCs.
 */

/*
 * Dependencies.
 */

#include	"gn_defines.h"
#include	"gn_tocinfo.h"


/*
 * Constants.
 */

/* Return values for "read toc" functions. */
#define RT_OK			0
#define	RT_DONE			1	/* no more TOC in file */
#define RT_TOOMANY		2
#define RT_TOOFEW		3
#define RT_INVAL		4
#define	RT_NOTFOUND		5

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Prototypes.
 */

/* read toc string from standard input and parse into offset table */
gn_int32_t
read_toc_stdin(gn_toc_hdr_t *toc);

/* read toc string from passed file and parse into offset table */
gn_int32_t
read_toc_file(gn_handle_t handle, gn_toc_hdr_t *toc);

gn_int32_t
read_toc_file_name(gn_custr_t file_name, gn_toc_hdr_t *toc);

/* Convert the passed TOC string into a table of offsets. */
gn_int32_t
convert_toc_string_to_array(const gn_uchar_t * tocstr, gn_toc_hdr_t *toc);

gn_int32_t
convert_toc_array_to_string(gn_toc_hdr_t* toc, gn_uchar_t* toc_str, gn_size_t buffer_size);

/* read video toc string from passed file */
gn_int32_t 
read_video_toc_file_name(gn_custr_t file_name, gn_uchar_t **video_toc_str);

#ifdef __cplusplus
}
#endif 
