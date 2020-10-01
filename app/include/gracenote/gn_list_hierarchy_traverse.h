/*
 * Copyright (c) 2008 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gn_list_hierarchy_traverse.h - Load, sort, and traverse a Gracenote V2 List hierarchy
 */

#ifndef	_GN_LIST_HIERARCHY_TRAVERSE_H_
#define _GN_LIST_HIERARCHY_TRAVERSE_H_

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

/* Helper structures for the pl_list_list_hierarchy function
 */
typedef struct list_hierarchy_data_s
{
	gn_uchar_t*					display_string;
	gn_uint32_t					category_id;
	gn_uint32_t					ordinal;
	struct list_hierarchy_s*	child;
} list_hierarchy_data_t;

typedef struct list_hierarchy_s
{
	gn_uint32_t				count;
	list_hierarchy_data_t*	data;
} list_hierarchy_t;


/*
 * Prototypes.
 */

gn_error_t load_list_hierarchy(gn_list_selector_t list_selector, list_hierarchy_t** hierarchy_root);

gn_error_t smart_free_list_hierarchy(list_hierarchy_t** hierarchy_root);


#ifdef __cplusplus
}
#endif

#endif /* _GN_LIST_HIERARCHY_TRAVERSE_H_ */
