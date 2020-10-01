/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gn_path_parser.h - Parses a path into filename and folders strings
 */

#ifndef	_GN_PATH_PARSER_H_
#define _GN_PATH_PARSER_H_

/*
 * Dependencies.
 */

#include	"gn_defines.h"
#include	"gn_platform.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants.
 */


/*
 * Typedefs.
 */

typedef struct
{
	gn_uchar_t *filename;
	gn_uchar_t *path;
	gn_uchar_t *parent_folder;
	gn_uchar_t *g_parent_folder;
	gn_uchar_t *gg_parent_folder;
} gn_path_parser_pathinfo_t;


/*
 * Prototypes.
 */
gn_error_t
gn_parse_path_get_info(
	const gn_uchar_t* filepath,
	const gn_uchar_t path_delimiter,
	gn_path_parser_pathinfo_t **pathinfo
	);

gn_error_t
gn_parse_path_smart_free(
	gn_path_parser_pathinfo_t **pathinfo
	);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_PATH_PARSER_H_ */
