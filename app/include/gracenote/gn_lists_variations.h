/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_lists_variations.h - Header file containing functions for querying
 *    display and configuration variations available for the list
 *    module.
 */


#ifndef _GN_LISTS_VARIATIONS_H_
#define _GN_LISTS_VARIATIONS_H_

/*
 * Dependencies.
 */

#include	"gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants
 */



/*
 * Structures and typedefs.
 */


/* Structure containing data returned from call a to
 * gn_list_get_available_hierarchies()
 */
typedef struct
{
	gn_uchar_t	*hierarchy_id;
	gn_uchar_t	*hierarchy_str;
	gn_bool_t	is_default;
} gn_available_hierarchy_t;

/* Structure containing data returned from call a to
 * gn_list_get_available_languages()
 */
typedef struct
{
	gn_uchar_t	*lang_id;		/* "eng", "jpn", etc */
	gn_uchar_t	*lang_str;		/* "English", "Japanese", etc */
	gn_uchar_t	*lang_id_code;	/* "1", "44", etc */
	gn_bool_t	is_default;
} gn_available_language_t;


/*
 * Prototypes.
 */



/* For fetching display language and display hierarchy settings */

/* Upon successful return, display_language is a displayable representation
 * of the currently selected display language for hierarchy elements.
 * This is the language in which display strings are presented. This
 * language can be selected by the user at initialization time via the
 * display_language_id member of the gn_emms_configuration_t structure passed
 * to gninit_initialize_emms().
 *
 * If a configuration structure is not provided during initialization or the
 * display_language_id member is not set, a default value is used.
 *
 * NOTE: No memory is allocated by this function.
 */
gn_error_t
gn_list_get_display_language(
	gn_uchar_t** display_language
);


/* Upon successful return, display_language_id is the language ID of the
 * currently selected display language for hierarchy elements.
 * For example: "eng", "jpn", etc.
 * This language can be selected by the user at initialization time via the
 * display_language_id member of the gn_emms_configuration_t structure passed
 * to gninit_initialize_emms().
 *
 * If a configuration structure is not provided during initialization or the
 * display_language_id member is not set, a default value is used.
 *
 * NOTE: No memory is allocated by this function.
 */
gn_error_t
gn_list_get_display_language_id(
	gn_uchar_t** display_language_id
);

/* Upon successful return, display_language_id_code is the language ID code of
 * the currently selected display language for hierarchy elements.
 * For example: "1", "44", etc.
 * This language can be selected by the user at initialization time via the
 * display_language_id member of the gn_emms_configuration_t structure passed
 * to gninit_initialize_emms().
 *
 * If a configuration structure is not provided during initialization or the
 * display_language_id member is not set, a default value is used.
 *
 * NOTE: No memory is allocated by this function.
 */
gn_error_t
gn_list_get_display_language_id_code(
	gn_uchar_t** display_language_id_code
);

/* Upon successful return, hierarchy_name is the name of the display hierarchy
 * from which genre display strings are accessed. The hierarchy can be
 * selected by the user at initialization time via the genre_display_hierarchy_id
 * member of the gn_emms_configuration_t structure passed to
 * gninit_initialize_emms().  If a configuration structure is not provided or
 * the genre_display_hierarchy_id member is not set, a default value will be used.
 *
 * NOTE: No memory is allocated by this function.
 */
gn_error_t
gn_list_get_genre_hierarchy_name(
	gn_uchar_t** hierarchy_name
);


/* Upon successful return, hierarchy_id is the ID of the display hierarchy from
 * which genre display strings are accessed. The hierarchy can be selected by
 * the user at initialization time via the genre_display_hierarchy_id member of
 * the gn_emms_configuration_t structure passed to gninit_initialize_emms().
 * If a configuration structure is not provided or the genre_display_hierarchy_id
 * member is not set, a default value will be used.
 *
 * NOTE: No memory is allocated by this function.
 */
gn_error_t
gn_list_get_genre_hierarchy_id(
	gn_uchar_t** hierarchy_id
);


/* Get the list of all available genre display hierarchy ID values and associated
 * display strings, via the list management subsystem. If successful, the following
 * values will be set:
 *
 * count:     The number of elements in the hierarchy array
 * hierarchy: Allocated array of gn_available_hierarchy_t elements
 *
 * hierarchy needs to be freed with a call to
 * gn_displayhierarchy_free_available_hierarchies().
 */
gn_error_t
gn_list_get_available_hierarchies(
	gn_uint32_t *count,
	gn_available_hierarchy_t **hierarchy
	);


/* Free the gn_available_hierarchy_t structure allocated from the call to
 * gn_displayhierarchy_get_available_hierarchies()
 */
gn_error_t
gn_list_free_available_hierarchies(
	const gn_uint32_t count,
	gn_available_hierarchy_t **hierarchy
	);


/* Get the list of all available written language ID values and associated
 * display strings, via the list management subsystem. If successful, the following
 * values will be set:
 *
 * count:     The number of elements in the hierarchy array
 * languages: Allocated array of gn_available_language_t elements
 *
 * language needs to be freed with a call to
 * gn_displayhierarchy_free_available_languages().
 */
gn_error_t
gn_list_get_available_languages(
	gn_uint32_t *count,
	gn_available_language_t **languages
	);


/* Free the gn_available_language_t structure allocated from the call to
 * gn_displayhierarchy_get_available_languages()
 */
gn_error_t
gn_list_free_available_languages(
	const gn_uint32_t count,
	gn_available_language_t **languages
	);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_LISTS_VARIATIONS_H_ */
