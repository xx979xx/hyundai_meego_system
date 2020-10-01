/*
 * Copyright (c) 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_displayhierarchy.h - display hierarchy data accessors.
 */

/*
 * Dependencies.
 */

#ifndef _GN_DISPLAYHIERARCHY_H_
#define _GN_DISPLAYHIERARCHY_H_

#include "gn_defines.h"
#include "gn_ext_data.h"


#ifdef __cplusplus
extern "C"{
#endif


/* Typedefs and Defines */

/*  gn_displayhierarchy_element_t
 * Primary data structure for holding all relevant data about a Display Hierarchy element.
 */
typedef void* gn_displayhierarchy_element_t;

/*  gn_displayhierarchy_type_t
 * Enumerated values to describe type of Display Hierarchy element.
 */
typedef gn_uint32_t gn_displayhierarchy_type_t;

#define GN_DISPLAYHIERARCHY_TYPE_INVALID        0
#define GN_DISPLAYHIERARCHY_TYPE_MOOD           1
#define GN_DISPLAYHIERARCHY_TYPE_TEMPO          2
#define GN_DISPLAYHIERARCHY_TYPE_GENRE          3


/*
 * Prototypes.
 */

/* gn_displayhierarchy_get_master_id
 *
 * Description: Return the display hierarchy master ID associated with an extended
 * data structure.
 *
 * Args: pext_data              - pointer to a populated extended data structure
 *                              pext_data can be populated via gn_ext_data_deserialize(), 
 *                              gn_album_data_get_album_ext_data() or gn_album_data_get_track_ext_data().
 *
 *       displayhierarchy_type  - Enumerated value of GN_DISPLAYHIERARCHY_TYPE_*, specifying the
 *                              type of display hierarchy element to retrieve.
 *
 *       master_id              - Upon successful return will point to the display hierarchy
 *                              master ID. If no master ID is present in the extended data structure,
 *                              this API will return GN_SUCCESS and set element to 0.
 *
 * Returns: GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *            Invalid input.
 *            Memory error.
 */
gn_error_t
gn_displayhierarchy_get_master_id(
        const gn_pext_data_t            pext_data,
        gn_displayhierarchy_type_t      displayhierarchy_type,
        gn_uint32_t*                    master_id
);

/* gn_displayhierarchy_get_element
 *
 * Description: Return the display hierarchy element associated with a master ID.
 *
 * Args: master_id              - master display hierarchy ID
 *
 *       displayhierarchy_type  - Enumerated value of GN_DISPLAYHIERARCHY_TYPE_*, specifying the
 *                              type of display hierarchy element to retrieve.
 *
 *       element                - Upon successful return will point to the display hierarchy
 *                              element. If no master ID is present in the extended data structure,
 *                              this API will return GN_SUCCESS and set element to GN_NULL.
 *
 * NOTE: System parameters influence the behavior of this function.
 *       All parameters have default values which the application developer 
 *              can override as described below.
 *         - display language: set at initialization time (see 
 *              gn_emms_configuration_t declaration in gn_init_emms.h)
 *
 * NOTE: element should be freed with gn_displayhierarchy_free_element()
 *
 * Returns: GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *            Invalid input.
 *            Memory error.
 */
gn_error_t
gn_displayhierarchy_get_element(
        gn_uint32_t                     master_id,
        gn_displayhierarchy_type_t      displayhierarchy_type,
        gn_displayhierarchy_element_t*  element
);

/* gn_displayhierarchy_element_get_category_levels
 *
 * Description: Return the number of category levels associated with the given
 * display hierarchy element.
 *
 * Args: element                - pointer to a populated display hierarchy element
 *
 *       category_levels        - Upon successful return will point to the number of
 *                              category levels associated with the display hierarchy element.
 *
 * Returns: GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *            Invalid input.
 *            Memory error.
 */
gn_error_t
gn_displayhierarchy_element_get_category_levels(
        gn_displayhierarchy_element_t   element,
        gn_uint32_t*                    category_levels
);

/* gn_displayhierarchy_element_get_category_string
 *
 * Description: Return the category string associated with the given display
 * hierarchy element and level.
 *
 * Args: element                - pointer to a populated display hierarchy element
 *
 *       category_level         - Display hierarchy level to retrieve the category
 *                              string (1-based).
 *
 *       category_string        - Upon successful return will point to the category
 *                              string associated with the display hierarchy element and level.
 *
 * Returns: GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *            Invalid input.
 *            Memory error.
 */
gn_error_t
gn_displayhierarchy_element_get_category_string(
        gn_displayhierarchy_element_t   element,
        gn_uint32_t                     category_level,
        gn_uchar_t**                    category_string
);

/* gn_displayhierarchy_element_get_category_id
 *
 * Description: Return the category ID associated with the given display
 * hierarchy element and level.
 *
 * Args: element        - pointer to a populated display hierarchy element
 *
 *       category_level - Display hierarchy level to retrieve the category
 *                      string (1-based).
 *
 *       category_id    - Upon successful return will point to the category
 *                      ID associated with the display hierarchy element and level.
 *
 * Returns: GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *            Invalid input.
 *            Memory error.
 */
gn_error_t
gn_displayhierarchy_element_get_category_id(
        gn_displayhierarchy_element_t   element,
        gn_uint32_t                     category_level,
        gn_uint32_t*                    category_id
);

/* gn_displayhierarchy_element_free
 *
 * Description: Frees a display hierarchy element, created by 
 * gn_displayhierarchy_get_element().
 *
 * Args: element        - pointer to a populated display hierarchy element
 *                      to be freed
 *
 * Returns: GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *            Invalid input.
 */
gn_error_t
gn_displayhierarchy_element_free(
        gn_displayhierarchy_element_t*  element
);


/* Yields the number of levels in the currently configured genre display 
 * hierarchy.
 */
gn_error_t
gn_displayhierarchy_get_genre_level_count(
	gn_uint32_t*	level_count
);

/* Yields the number of levels in the currently configured video genre display
 * hierarchy.
 */
gn_error_t
gn_displayhierarchy_get_video_genre_level_count(
	gn_uint32_t*	level_count
);

/* Sets the system genre display hierarchy level to the given value.
 * The value of level is constrained by 1 <= level <= level_count from 
 * gn_displayhierarchy_get_genre_level_count.
 * Higher values of level provide more refined genre definitions.
 * Subsequent access of genre display strings will be at the hierarchy level 
 * indicated by level.
 * If this function is not called, a default value will be used.
 */
gn_error_t
gn_displayhierarchy_set_genre_hierarchy_level(
	const gn_uint32_t level
);

/* Upon successful return, level will indicate the current value of the 
 * system genre display hierarchy level.
 * This is the level at which genre display strings will be accessed.
 * The system genre display hierarchy level can be changed via a call to
 * gn_displayhierarchy_set_genre_hierarchy_level().
 */
gn_error_t
gn_displayhierarchy_get_genre_hierarchy_level(
	gn_uint32_t* level
);

/* Sets the system video genre display hierarchy level to the given value.
 * The value of level is constrained by 1 <= level <= level_count from 
 * gn_displayhierarchy_get_video_genre_level_count.
 * Higher values of level provide more refined genre definitions.
 * Subsequent access of genre display strings will be at the hierarchy level 
 * indicated by level.
 * If this function is not called, a default value will be used.
 */
gn_error_t
gn_displayhierarchy_set_video_genre_hierarchy_level(
	const gn_uint32_t level
);

/* Upon successful return, level will indicate the current value of the 
 * system video genre display hierarchy level.
 * This is the level at which genre display strings will be accessed.
 * The system genre display hierarchy level can be changed via a call to
 * gn_album_set_video_genre_hierarchy_level().
 */
gn_error_t
gn_displayhierarchy_get_video_genre_hierarchy_level(
	gn_uint32_t* level
);



/* External Data Routines */

/* gn_displayhierarchy_get_genre
 *
 * Description: Return the display string associated with the genre master ID 
 *	in the given extended data structure.
 *
 * Args: pext_data	 - pointer to a populated extended data structure
 *			pext_data can be populated via gn_ext_data_deserialize(), 
 *			gn_album_data_get_album_ext_data() or gn_album_data_get_track_ext_data().
 *       genre_string - Upon successful return will point to the genre display
 *			string. If no genre data is present in the extended data structure,
 *			this API will return GN_SUCCESS and set genre_string to GN_NULL.
 * NOTE: Several system parameters influence the behavior of this function.
 *       All parameters have default values which the application developer 
 *			can override as described below.
 *         - display language: set at initialization time (see 
 *			gn_emms_configuration_t declaration in gn_init_emms.h)
 *         - genre display hierarchy: set at initialization time (see 
 *			gn_emms_configuration_t declaration in gn_init_emms.h)
 *         - genre display hierarchy level: set at any time by calling
 *			gn_displayhierarchy_set_genre_hierarchy_level().
 *
 * NOTE: genre_string should be freed with gnmem_free()
 *
 * Returns: GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *            Invalid input.
 *            Memory error.
 */
gn_error_t
gn_displayhierarchy_get_genre(
	const gn_pext_data_t	pext_data,
	gn_uchar_t**			genre_string
);

/* Given a lookup_string, sets *category_id to the category id for 
 * the currently selected genre display level if *found is set to GN_TRUE.
 * If *found is set to GN_FALSE, then lookup_string did not match any of the
 * genre display strings at the currently selected genre display level.
 */

gn_error_t
gn_displayhierarchy_genre_string_lookup(
					gn_uchar_t* lookup_string, 
					gn_bool_t* found,
					gn_uint32_t *category_id
					);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_DISPLAYHIERARCHY_H_ */
