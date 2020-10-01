/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_genre.h - genre data object.
 *
 * This API provides access to all representations of all genre display
 * hierarchy levels for a given genre.
 * The genres are dependent on the genre display hierarchy set for the
 * system on initialization.
 *
 * The type of access provided here is necessary for populating ASR/TTS
 * grammars and dictionaries, a MediaVOCS-related activity.
 *
 * The data model consists of a "genre array". Each element in the "genre
 * array" represents a genre at one of the display levels in the genre display
 * hierarchy.
 */

/*
 * Dependencies.
 */

#ifndef _GN_GENRE_H_
#define _GN_GENRE_H_

#include "gn_defines.h"
#include "gn_representation.h"


#ifdef __cplusplus
extern "C"{
#endif

/*
 * Structures and typedefs.
 */

/* A genre element, representing an entry in the genre display hierarchy at a
 * specific display level.
 */
typedef void* gn_pgenre_t;

/* An array of genre elements, representing all display levels in the genre
 * display hierarchy that are associated with a given master genre ID.
 */
typedef void* gn_pgenre_arr_t;

/*
 * Prototypes.
 */

/*	gn_genre_array_get_element_count
 *
 *	Get the number of elements in the gn_pgenre_arr_t array.
 *	Each element in the array represents a specific display level
 *	for the given genre.
 *
 *	Parameters
 *		genre_array:	The array containing all genre elements for all display
 *						levels for a given master genre ID.
 *		element_count:	A reference to an element count variable. On success,
 *						this value is assigned the number of elements in the
 *						genre_array.
 *
 *	Error Return
 *		GN_SUCCESS				The element_count has been retrieved.
 *		GNLISTSERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *		GNLISTSERR_NotInited:	The List subsystem is not initialized.
 */
gn_error_t
gn_genre_array_get_element_count(
	const gn_pgenre_arr_t genre_arr,
	gn_uint32_t* element_count
);

/*	gn_genre_array_get_genre
 *
 *	Get a gn_pgenre_t element out of the gn_pgenre_arr_t array.
 *	This is a 0-based array.
 *
 *	Parameters
 *		genre_array:	The array containing all genre elements for all display
 *						levels for a given master genre ID.
 *		index:			The index (0-based) of the genre element to retrieve.
 *		genre:			The genre element to retrieve.
 *
 *	Error Return
 *		GN_SUCCESS				The genre has been retrieved.
 *		GNLISTSERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer, or the index value is greater than
 *								the number of elements in the genre_array.
 *		GNLISTSERR_NotInited:	The List subsystem is not initialized.
 *
 *	Remarks:
 *		On GN_SUCCESS, the genre pointer will be populated. That is, *genre
 *		will not have a value of GN_NULL.
 */
gn_error_t
gn_genre_array_get_genre(
	const gn_pgenre_arr_t genre_arr,
	const gn_uint32_t index,
	gn_pgenre_t* genre
);

/*	gn_genre_get_representation_array
 *
 *	Get a representation array with all of the representations of a given
 *  gn_pgenre_t. For operations on the representation array, refer to
 *  gn_representation.h.
 *
 *	Parameters
 *		genre:					A genre element, retrieved via a call to
 *								gn_genre_array_get_genre.
 *		representation_array:	The representation array to retrieve.
 *
 *	Error Return
 *		GN_SUCCESS				The representation_array has been retrieved.
 *		GNLISTSERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		On GN_SUCCESS, the representation_array pointer will be populated.
 *		That is, *representation_array will not have a value of GN_NULL.
 */
gn_error_t
gn_genre_get_representation_array(
	gn_pgenre_t const genre,
	gn_prep_array_t* representation_array
);

/*	gn_genre_get_category_id
 *
 *	Get a category ID associated with a given gn_pgenre_t.
 *	For operations related to categoy IDs, refer to gn_lists.h.
 *
 *	Parameters
 *		genre:					A genre element, retrieved via a call to
 *								gn_genre_array_get_genre.
 *		category_id:			The category ID to retrieve.
 *
 *	Error Return
 *		GN_SUCCESS				The category_id has been retrieved.
 *		GNLISTSERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		On GN_SUCCESS, the category_id pointer will be populated.
 *		That is, *category_id will not have a value of 0.
 */
gn_error_t
gn_genre_get_category_id(
	gn_pgenre_t const genre,
	gn_uint32_t* category_id
);

/*	gn_genre_get_by_category_id
 *
 *	Get a gn_pgenre_t element from a category ID.
 *	This function allocates memory for the genre element, and should be freed
 *	with a call to gn_genre_smart_free().
 *
 *	Parameters
 *		category_id:	The category ID associated with the genre element to
 *						retrieve.
 *		genre:			The genre element to retrieve.
 *
 *	Error Return
 *		GN_SUCCESS				The genre has been retrieved.
 *		GNLISTSERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer, or the category ID is invalid.
 *		GNLISTSERR_NotInited:	The List subsystem is not initialized.
 *
 *	Remarks:
 *		On GN_SUCCESS, the genre pointer will be populated. That is, *genre
 *		will not have a value of GN_NULL.
 */
gn_error_t
gn_genre_get_by_category_id(
	gn_uint32_t category_id,
	gn_pgenre_t* genre
);

/*	gn_genre_smart_free
 *
 *	Frees a genre array (gn_pgenre_t) that was allocated via a call
 *	to gn_genre_get_by_category_id(). This function frees all memory
 *	associated with the genre element, and nulls out the pointer.
 *
 *	Parameters
 *		genre:			The genre element to be freed.
 *
 *	Error Return
 *		GN_SUCCESS				All resources associated with genre have been
 *								freed.
 */
gn_error_t
gn_genre_smart_free(
	gn_pgenre_t* genre
);

/*	gn_genre_array_smart_free
 *
 *	Frees a genre array (gn_pgenre_arr_t) that was allocated via a call
 *	to gnplaylist_get_genre_array(). This function frees all memory
 *	associated with the genre array, and nulls out the pointer to the array.
 *
 *	Parameters
 *		genre_array:	The array containing all genre elements for all display
 *						levels for a given master genre ID.
 *
 *	Error Return
 *		GN_SUCCESS				All resources associated with genre_array have
 *								been freed.
 */
gn_error_t
gn_genre_array_smart_free(
	gn_pgenre_arr_t* genre_arr
);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_GENRE_H_ */
