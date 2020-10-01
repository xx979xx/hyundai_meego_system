/*
 * Copyright (c) 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_ext_data.h - extended data structure and access.
 */

#ifndef	_GN_EXT_DATA_H_
#define _GN_EXT_DATA_H_


/*
 * Dependencies.
 */

#include "gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif

/*
 * Constants.
 */

#define GN_EXT_DATA_MERGE_TYPE_1	1 /* favor track-level data over album-level data */

/*
 * Extended Data flags
 */

typedef gn_uint32_t gn_ext_data_flags_t;

/*
 * GN_EXT_DATA_DEFAULT
 * All fields present in the extended data structure.
 */
#define GN_EXT_DATA_DEFAULT		0x00000000

/*
 * GN_EXT_DATA_PLAYLIST
 * Fields relevant to Playlist (Genre, Era, Origin, Artist Type, Popularity, Mood, Tempo, etc).
 * Useful with the gnplaylist_setentry_ext_data() API.
 */
#define GN_EXT_DATA_PLAYLIST	0x00000001

/*
 * GN_EXT_DATA_CONTENT
 * External IDs, Cover Art, etc.
 * Useful with the gn_coverart_prepare_from_ext_data() API.
 */
#define GN_EXT_DATA_CONTENT		0x00000002


/* Opaque pointers to underlying C data structures.
 *
 * Always access data fields via the data accessor functions declared here.
 */

typedef void*	gn_pext_data_t;

/*
 * public interface
 */

/*	gn_ext_data_init
 * Description: Allocates memory for an extended data container, and sets the version number
 * Args: 	pext_data	- pointer to the extended data container to be allocated
 * Returns:	EDBERR_NoError upon success or an error.
 */
gn_error_t
gn_ext_data_init(gn_pext_data_t* pext_data);


 /*	gn_ext_data_smart_free
 * Description: Frees memory associated with the extended data container, and sets the pointer to GN_NULL
 * Args: 	pext_data	- pointer to the extended data container to be freed
 * Returns:	EDBERR_NoError upon success or an error.
 */
gn_error_t
gn_ext_data_smart_free(gn_pext_data_t* pext_data);

/*	gn_ext_data_serialize
 * Description: Gets a serialized version of the extended data structure.
 *				Equivalent to calling gn_ext_data_serialize_ex() with GN_EXT_DATA_DEFAULT.
 *				This function allocates memory for the serialized data output which should be freed by calling gn_ext_data_serialize_smart_free()
 *				If no extended data is present, the function returns GN_SUCCESS,
 *				but the data member is set to GN_NULL
 * Args: 	pext_data	- pointer to an extended data structure
 * 			data		- pointer to a string to hold the serialized data (NULL terminated)
 * Returns:	EDBERR_NoError upon success or an error.
 *			Failure conditions include:
 *				Memory allocation error
 */
gn_error_t
gn_ext_data_serialize(
	const gn_pext_data_t pext_data,
	gn_uchar_t** data
	);

/*	gn_ext_data_serialize_ex
 * Description: Gets a serialized version of the extended data structure
 *				This function allocates memory for the serialized data output which should be freed by calling gn_ext_data_serialize_smart_free()
 *				If no extended data is present, the function returns GN_SUCCESS,
 *				but the data member is set to GN_NULL
 * Args: 	pext_data		- pointer to an extended data structure
 *			ext_data_flags	- flags indicating which fields to serialize, may be logically ORed
 * 			data			- pointer to a string to hold the serialized data (NULL terminated)
 * Returns:	EDBERR_NoError upon success or an error.
 *			Failure conditions include:
 *				Memory allocation error
 */
gn_error_t
gn_ext_data_serialize_ex(
	const gn_pext_data_t pext_data,
	const gn_ext_data_flags_t ext_data_flags,
	gn_uchar_t** data
	);

/*	gn_ext_data_serialize_smart_free
 * Description: Frees a serialized string created with gn_ext_data_serialize()
 *				This function frees memory for the serialized data
 * Args: 	data		- pointer holding a string with serialized data (NULL terminated)
 * Returns:	EDBERR_NoError upon success or an error.
 *			Failure conditions include:
 *				Invalid input
 */
gn_error_t
gn_ext_data_serialize_smart_free(
	gn_uchar_t** data
	);

/*	gn_ext_data_deserialize
 * Description: Populate the extended data structure with a serialized version.
 *
 * Args: 	pext_data	- pointer to the extended data structure to be populated, must first be allocated and initialized with gn_ext_data_init()
 * 			data		- pointer to a string that holds the serialized data (NULL terminated )
 * Returns:	EDBERR_NoError upon success or an error.
 *			Failure conditions include:
 *				Memory allocation error
 *				Invalid format
 */
gn_error_t
gn_ext_data_deserialize(
	gn_pext_data_t pext_data,
	const gn_uchar_t* data
	);


/*	gn_ext_data_merge
 * Description: Merges album-level and track-level extended data into a single gn_pext_data_t struct
 *				track-level data is always favored over album-level data
 *				At least one of track/album level data structs must be present
 *
 * Args: 	pext_data_album		- album-level extended data structure, can be GN_NULL if pext_data_track is present
 * 			pext_data_track		- track-level extended data structure, can be GN_NULL if pext_data_album is present
 * 			pext_data_merged	- merged track-level extended data output, must first be allocated and initialized with gn_ext_data_init()
 *			merge_flags			- flag specifying the type of merge, currently only GN_EXT_DATA_MERGE_TYPE_1
 * Returns:	EDBERR_NoError upon success or an error.
 *			Failure conditions include:
 *				Invalid input
 */
gn_error_t
gn_ext_data_merge(
	const gn_pext_data_t pext_data_album,
	const gn_pext_data_t pext_data_track,
	gn_pext_data_t pext_data_merged,
	const gn_uint32_t merge_type
	);

#ifdef __cplusplus
}
#endif


#endif /* _GN_EXT_DATA_H_ */


