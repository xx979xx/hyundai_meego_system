/*
 * Copyright (c) 2009 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_collation_data.h - interface for retrieving strings suitable for collation.
 *
 * Some languages, such as Chinese use logogram characters that cannot be easily
 * used for producing sort keys for collation.  In such cases, an alternative string
 * containing an "alphabetic" or "soundable" variation on the display string is
 * needed for collation of the display string.
 *
 * It is important to note that the strings provided by this interface are not
 * necessarily a sort key suitable for bytewise comparison (as performed by
 * common C library functions as strcmp), but are instead intended to be used to
 * generate a sort key which is then used in a collation algorithm supplied the
 * developer.
 *
 * Note: Caller does not own memory yieled by any accessors in this API.
 * 
 */

/*
 * Dependencies.
 */

#ifndef _GN_COLLATION_DATA_H_
#define _GN_COLLATION_DATA_H_

#include "gn_defines.h"

/*
 * Constants.
 */

/* Identify the "type" of the collation string. */

/* The collation string is an unknown type. */
#define		GN_COLLATION_DATA_UNKNOWN			1

/* The collation string is HANYU PINYIN. */
#define		GN_COLLATION_DATA_HANYU_PINYIN		2

#ifdef __cplusplus
extern "C"{
#endif


/*
 * Structures and typedefs.
 */

/* Data type which can take on the GN_COLLATION_ values. */
typedef gn_uint32_t	gn_collation_element_type_t;

/* A collation element, consisting of a "type", and a collation string.
 */
typedef void* gn_collation_element_t;

/* A collation array, containing an array of gn_collation_element_t
 * elements.
 */
typedef void* gn_collation_data_array_t;


/*
 * Prototypes.
 */

/*	gn_collation_data_get_element_count
 *
 *	Get the number of elements in the collation array.
 *
 *	Parameters
 *		coll_arr:		The array containing all collation elements for
 *						a given collation data array.
 *		element_count:	The number of elements in the collation array.
 *
 *	Error Return
 *		GN_SUCCESS				The number of elements in the collation
 *								array has been retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*element_count parameter is indeterminate.
 */
gn_error_t
gn_collation_data_get_element_count(
	const gn_collation_data_array_t coll_arr,
	gn_uint32_t*          element_count
);

/*	gn_collation_data_get_element
 *
 *	Get a gn_collation_data_element_t element from the collation array.
 *	The index is 0-based.
 *  Note, there is no guarantee that the official collation will be the
 *  first in the array. To find the official collation, you should loop
 *  over the collations using this function and then check for the
 *  language and collation string type.
 *
 *	Parameters
 *		coll_array:		The array containing all collation elements for
 *						a given display object (e.g., name, title, genre
 *						description).
 *		index:			The index (0-based) of the collation element to
 *						retrieve.
 *		collation:		The collation element to retrieve.
 *
 *	Error Return
 *		GN_SUCCESS				The collation has been retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer, or the index value is greater than
 *								the number of elements in the coll_array.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*collation parameter is indeterminate.
 */
gn_error_t
gn_collation_data_get_collation_data_element(
	const gn_collation_data_array_t	coll_array,
	gn_uint32_t						index,
	gn_collation_element_t*			collation
);

/*	gn_collation_data_get_collation_data_element_type
 *
 *	Get the type of the collation string.
 *	Collation types are defined as GN_COLLATION_ values.
 *
 *	Parameters
 *		coll:			The collation object.
 *		type:			A pointer to a gn_collation_element_type_t; the value represents
 *						the "type" of the collation.
 *
 *	Error Return
 *		GN_SUCCESS				The "type" value for the collation object has
 *								been retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*type parameter is indeterminate.
 */
gn_error_t
gn_collation_data_get_collation_data_element_type(
	const gn_collation_element_t			coll,
	gn_collation_element_type_t*            type
);

/*	gn_collation_data_get_collation_data_element_by_type
 *
 *	Get the collation data element from the passed in collation array. The element
 *  returned will be the one which matches the passed in element type.
 *	Collation types are defined as GN_COLLATION_ values.
 *
 *	Parameters
 *		coll_array:		The collation array to check
 *		type:			The collation element type to look for in the array
 *		collation:		A pointer to the gn_collation_element_t. This value will
 *						be the GN_NULL if the type is not found in the array.
 *
 *	Error Return
 *		GN_SUCCESS				The collation element which mathces the passed in type
 *								was found and returned. If It is not found, GN_NULL is
 *								returned.
 *		GNDACCERR_InvalidArg	The collation array is invalid or the type is invalid.
 */
gn_error_t
gn_collation_data_get_collation_data_element_by_type(
	const gn_collation_data_array_t coll_array,
	gn_collation_element_type_t     type,
	gn_collation_element_t*         collation
);


/*	gn_collation_data_get_collation_string
 *
 *	Get the collation string associated with the collation object.
 *
 *	Parameters
 *		coll:				The collation object.
 *		collation_string:	A pointer to the display string associated with the
 *							collation object.
 *
 *	Error Return:
 *		GN_SUCCESS				The collation objects's collation string has been
 *								retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*collation_string parameter is indeterminate.
 */
gn_error_t
gn_collation_data_get_collation_string(
	const gn_collation_element_t		coll,
	gn_uchar_t**				collation_string
);

	
#ifdef __cplusplus
}
#endif 

#endif /* _GN_COLLATION_DATA_H_ */
