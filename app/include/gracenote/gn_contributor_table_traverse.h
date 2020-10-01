/*
 * Copyright (c) 2008 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gn_contributor_table_traverse.h - Load, sort, and traverse a Gracenote contributor table
 */

#ifndef	_GN_CONTRIBUTOR_TABLE_TRAVERSE_H_
#define _GN_CONTRIBUTOR_TABLE_TRAVERSE_H_

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

/* Table of contributor strings and associated contributor IDs */
typedef struct
{
	gn_uchar_t *contributor;
	gn_uint32_t id;
} gn_contributor_browse_table_t;


/*
 * Prototypes.
 */

gn_error_t load_contributor_table(gn_contributor_browse_table_t **table, gn_uint32_t *count, const gn_uchar_t *substring);

gn_error_t smart_free_contributor_table(gn_contributor_browse_table_t **table, const gn_uint32_t count);


#ifdef __cplusplus
}
#endif

#endif /* _GN_CONTRIBUTOR_TABLE_TRAVERSE_H_ */
