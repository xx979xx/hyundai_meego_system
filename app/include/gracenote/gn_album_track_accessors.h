/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_album_track_accessors.h: Data accessors for gn_palbum_t instances.
 *
 *  All functions return GN_SUCCESS upon successful completion. If any other
 *  value is returned, the output data should be considered invalid.
 *
 *  Common errors returned by these functions include:
 *    GNDACCERR_InvalidArg: Usually indicates either a required pointer input
 *      argument is GN_NULL or an integer input argument is outside of its
 *      valid range.
 *    GNDACCERR_NotFound: Indicates that the member being accessed was not
 *      found but should have been, i.e. is required.
 *
 *  Boolean output arguments will be set to either GN_TRUE or GN_FALSE.
 */

#ifndef	_GN_ALBUM_TRACK_ACCESSORS_H_
#define _GN_ALBUM_TRACK_ACCESSORS_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_album_track_types.h"
#include "gn_ext_data.h"
#ifdef GN_MEDIAVOCS
#include "gn_transcript_types.h"
#endif
#include "gn_lang_types.h"
#include "gn_genre.h"


#ifdef __cplusplus
extern "C"{
#endif

/*
 * Prototypes.
 */

/***
 *** DESTRUCTOR
 ***/

/* gn_album_data_release_album
 *
 * Release all memory allocated to the given gn_palbum_t structure.
 * Beware that any pointer attained via the data accessor functions will be invalidated by this call.
 */
gn_error_t
gn_album_data_release_album(
	gn_palbum_t* album
);


#ifdef GN_MEDIAVOCS
/*
 *	MediaVOCS provides phonetic transcriptions in a target spoken language for use in an
 *	ASR/TTS system and also provides support for the recognition of alternate phrases.
 */

/*	gn_album_data_cache_alternate_phrases
 *
 *	Add alternate phrases from a converted+extended album data structure for artist, album,
 *	and title to the APM cache.
 *
 *	This function is typically called after a successful local or online lookup.
 *	See gnllu_local_lookup() and gnllu_convert_album_data() or gnolu_lookup_album_by_toc() and
 *	gnolu_convert_album_data().
 *
 *	Phrases are retrieved from the cache with gn_apm_get_official_phrase_array().
 *
 *	Error Return:
 *		GN_SUCCESS		Alternate phrases were written to the cache.
 *
 *		XLTERR_UnsupportedFunctionality
 *						Your configuration does not support this operation.
 *
 *		XLTERR_InvalidParam
 *						The parameter is not a proper album structure.
 *
 *		GNAPMERR_NotInited
 *						The APM cache system has not been initialized.
 *
 *		GNAPMERR_NoMemory
 *						There is not enough memory to complete this request.
 *
 *		DBERR_NoSpace
 *						There is not enough file space to write the APM cache.
 *
 *	This function is available only in configurations that support MediaVOCS.
 */
gn_error_t
gn_album_data_cache_alternate_phrases(
	gn_palbum_t	palbum
	);

#endif	/* GN_MEDIAVOCS */



/***
 *** ACCESSORS
 ***/

/*** CONVENIENCE FUNCTIONS
 ***
 *** These functions can be implemented by calling the BASIC DATA ELEMENT
 *** ACCESSORS and performing further processing on the result.
 ***/

/* Retrieve a pointer to the display title of the album. */
/* When an album has multiple display titles (official, alternate, tls), */
/* this accessor will return the display string of the default (official). */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_album_title(
	const gn_palbum_t  album,
	const gn_uchar_t** title
);

/* Retrieve a pointer to the display name of primary artist for the album. */
/* When an album's primary artist has multiple display names (official, alternate, tls), */
/* this accessor will return the display string of the default (official). */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_album_artist(
	const gn_palbum_t  album,
	const gn_uchar_t** name
);

/* Retrieve a pointer to the display string of the primary genre associated with the given album.
 * The returned display string will be in the configured language and display hierarchy and at the selected
 * display hierarchy level.
 * Memory is allocated by this function, but the caller does not own the memory.
 */
gn_error_t
gn_album_data_get_album_genre(
	const gn_palbum_t	album,
	gn_uchar_t**		genre
);

/* Retrieve a pointer to the display string of the era of the primary artist associated with the given album.
 * Memory is allocated by this function, but the caller does not own the memory.
 */
gn_error_t
gn_album_data_get_album_artist_era(
	const gn_palbum_t	album,
	gn_uchar_t**		artist_era
);

/* Retrieve a pointer to the display string of the type of the primary artist associated with the given album.
 * Memory is allocated by this function, but the caller does not own the memory.
 */
gn_error_t
gn_album_data_get_album_artist_type(
	const gn_palbum_t	album,
	gn_uchar_t**		artist_type
);

/* Retrieve a pointer to the display string of the origin of the primary artist associated with the given album.
 * Memory is allocated by this function, but the caller does not own the memory.
 */
gn_error_t
gn_album_data_get_album_artist_origin(
	const gn_palbum_t	album,
	gn_uchar_t**		artist_origin
);

/* Retrieve a pointer to the display title of the track. */
/* When an track has multiple display titles (official, alternate, tls), */
/* this accessor will return the display string of the default (official). */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_track_title(
	const gn_palbum_track_t	track,
	const gn_uchar_t**		title
);

/* Retrieve a pointer to the display name of primary artist for the track. */
/* When an track primary artist has multiple display names (official, alternate, tls), */
/* this accessor will return the display string of the default (official). */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_track_artist(
	const gn_palbum_track_t	track,
	const gn_uchar_t**		name
);

/* Retrieve a pointer to the display string of the primary genre associated with the given track.
 * The returned display string will be in the configured language and display hierarchy and at the selected
 * display hierarchy level.
 * Memory is allocated by this function, but the caller does not own the memory.
 */
gn_error_t
gn_album_data_get_track_genre(
	const gn_palbum_track_t	track,
	gn_uchar_t**			genre
);

/* Retrieve a pointer to the display string of the era of the primary artist associated with the given track.
 * Memory is allocated by this function, but the caller does not own the memory.
 */
gn_error_t
gn_album_data_get_track_artist_era(
	const gn_palbum_track_t track,
	gn_uchar_t**			artist_era
);

/* Retrieve a pointer to the display string of the type of the primary artist associated with the given track.
 * Memory is allocated by this function, but the caller does not own the memory. 
 */
gn_error_t
gn_album_data_get_track_artist_type(
	const gn_palbum_track_t track,
	gn_uchar_t**			artist_type
);

/* Retrieve a pointer to the display string of the origin of the primary artist associated with the given track.
 * Memory is allocated by this function, but the caller does not own the memory.
 */
gn_error_t
gn_album_data_get_track_artist_origin(
	const gn_palbum_track_t track,
	gn_uchar_t**			artist_origin
);

/*** FUNCTIONS for retrieving specified data associated with names and titles.
 ***
 *** These functions can be implemented by calling the BASIC DATA ELEMENT
 *** ACCESSORS and performing further processing on the result.
 ***/

/* In the following functions
 *  album  A gn_palbum_t instance from which the data will be fetched.
 *  track  A gn_palbum_track_t instance from which the data will be fetched.
 *  key    A string indicating which associated value to fetch
 *  value  Upon successful return this will point to the requested string.
 *         Memory is NOT allocated by this function. DO NOT free value.
 *
 *  The available "key" types are application dependent. Those available to
 *  your application will be communicated to you directly.
 */

/* Get the indicated data associated with the "primary" album artist. */
gn_error_t
gn_album_data_get_album_artist_keyedvalue(
	const gn_palbum_t  album,
	const gn_uchar_t*  key,
	const gn_uchar_t** value
);

/* Get the indicated data associated with the "primary" track artist. */
gn_error_t
gn_album_data_get_track_artist_keyedvalue(
	const gn_palbum_track_t track,
	const gn_uchar_t*       key,
	const gn_uchar_t**      value
);

/* Get the indicated data associated with the album title. */
gn_error_t
gn_album_data_get_album_title_keyedvalue(
	const gn_palbum_t  album,
	const gn_uchar_t*  key,
	const gn_uchar_t** value
);

/* Get the indicated data associated with the track title. */
gn_error_t
gn_album_data_get_track_title_keyedvalue(
	const gn_palbum_track_t track,
	const gn_uchar_t*       key,
	const gn_uchar_t**      value
);

/*** CONVENIENCE FUNCTIONS for primary artist data
 ***
 *** These functions can be implemented by calling the BASIC DATA ELEMENT
 *** ACCESSORS and performing further processing on the result.
 ***/

/* Get the representation array of the "primary" album credit. */
gn_error_t
gn_album_data_get_album_artist_rep_array(
	const gn_palbum_t album,
	gn_prep_array_t*  artist_rep_array
);

/* Get the representation array of the "primary" track credit. */
gn_error_t
gn_album_data_get_track_artist_rep_array(
	const gn_palbum_track_t track,
	gn_prep_array_t*        artist_rep_array
);

/***
 *** BASIC DATA ELEMENT ACCESSORS
 ***/

/* Retrieve a pointer to the revision of the album. */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_album_revision(
	const gn_palbum_t  album,
	const gn_uchar_t** revision
);

/* Retrieve a pointer to the language id of the album. */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_album_language_id(
	const gn_palbum_t  album,
	const gn_uchar_t** language_id
);

/* Retrieve a pointer to the year of the album. */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_album_year(
	const gn_palbum_t  album,
	const gn_uchar_t** year
);

/* gn_album_data_get_album_certification_level
 *
 * Retrieves the album certification code.
 *
 * A value of 0 indicates that the album is not certified.
 * Any other value indicates that the album has been certified.
 * A certified album may be of higher quality than a non-certified album.
 * You should not assume that higher certification values indicate higher 
 * quality.
 * This value may be of use in resolving a multiple match in the following
 * limited ways.
 *  1) When presenting results of a multiple match to the user for selection,
 *     you may wish to put certified albums at the top of the list.
 *  2) In UI limited devices, you may wish to filter on albums that have a
 *     non-zero certifier. However, you should be aware that in this case you
 *     may actually not present the user with the match of interest.
 */
gn_error_t
gn_album_data_get_album_certification_level(
	const gn_palbum_t album,
	gn_uint32_t * const certification_level
);

/*	gn_album_data_get_album_label
 *
 *	Retrieves a pointer to the album label.  If the album data does not contain a label string
 *	the returned label string will be null and the returned value will be GN_SUCCESS.
 *	This function does not allocate memory.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the album or label pointers are null.
 *
 *	Parameters
 *		album		A converted album data structure, allocated by gn_album_data_convert_album.
 *		label		Pointer into which to return the album label.
 */
gn_error_t
gn_album_data_get_album_label(
	const gn_palbum_t   album,
	const gn_uchar_t**  label
);

/*	gn_album_data_get_album_disc_in_set
 *
 *	Retrieves a pointer to the "disc number in set" of the album.  If the album data does not
 *	contain a disc number the returned disc string will be null and the returned value will
 *	be GN_SUCCESS.  This function does not allocate memory.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the album or disc_in_set pointers are null.
 *
 *	Parameters
 *		album			A converted album data structure, allocated by gn_album_data_convert_album.
 *		disc_in_set		Pointer into which to return the "disc number in set" of the album.
 */
gn_error_t
gn_album_data_get_album_disc_in_set(
	const gn_palbum_t   album,
	const gn_uchar_t**  disc_in_set
);

/*	gn_album_data_get_album_total_in_set
 *
 *	Retrieves a pointer to the "total number of discs in set" of the album. If the album data
 *	does not contain a total in set number the returned total string will be null and the
 *	returned value will be GN_SUCCESS.  This function does not allocate memory.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the album or total_in_set pointers are null.
 *
 *	Parameters
 *		album			A converted album data structure, allocated by gn_album_data_convert_album.
 *		total_in_set	Pointer into which to return the "total number of discs in set" of the album.
 */
gn_error_t
gn_album_data_get_album_total_in_set(
	const gn_palbum_t   album,
	const gn_uchar_t**  total_in_set
);

/* gn_album_data_get_primary_album_genre_id_v1
 * Description: Retrieve a pointer to the primary V1 genre ID associated with the album.
 *			Memory is NOT allocated by this function. The caller does NOT own the memory.
 *
 * Args:	album						- opaque pointer to an album data struct
 *			primary_album_genre_id_v1	- pointer for the output primary V1 genre ID
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 * 				Invalid argument
 */
gn_error_t
gn_album_data_get_primary_album_genre_id_v1(
	const gn_palbum_t	album,
	const gn_uchar_t**	primary_album_genre_id_v1
);

/* Retrieve a pointer to the track count of the album. */
/* Note: the "track count" is not necessarily the same as the number of track elements */
/* contained in the album data structure. */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_album_track_count(
	const gn_palbum_t  album,
	const gn_uchar_t** count
);

/* Retrieve the number of track elements associated with the album. */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_album_track_array_size(
	const gn_palbum_t album,
	gn_size_t*        array_size
);

/* Retrieve a pointer to one of the tracks associated with the album. */
/* The index parameter is 0-based, and must be less than the array_size returned by */
/* gn_album_data_get_album_track_array_size. */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_album_track(
	const gn_palbum_t  album,
	const gn_size_t    index,
	gn_palbum_track_t* track
);

/* Retrieve a pointer to one of the tracks associated with the album base on */
/* its ordinal (ie track number */
/* The ord parameter starts at 1, and must be less than or equal to the array_size returned by */
/* gn_album_data_get_album_track_count (however this is not a guarantee of success) */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_album_track_by_ord(
	const gn_palbum_t  album,
	const gn_size_t    ord,
	gn_palbum_track_t* track
);

/* Retrieve a pointer to the ordinal (position) of the track on the album. */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_track_ordinal(
	const gn_palbum_track_t track,
	const gn_uchar_t**      ordinal
);

/* gn_album_data_get_primary_track_genre_id_v1
 * Description: Retrieve a pointer to the primary V1 genre ID associated with the track.
 *			Memory is NOT allocated by this function. The caller does NOT own the memory to the point
 *
 * Args:	track						- opaque pointer to a track data struct
 *			primary_track_genre_id_v1	- pointer for the output primary V1 genre ID
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 * 				Invalid argument
 */
gn_error_t
gn_album_data_get_primary_track_genre_id_v1(
	const gn_palbum_track_t track,
	const gn_uchar_t**      primary_track_genre_id_v1
);

/* Retrieve a pointer to the year of the track. */
/* Memory is NOT allocated by this function. */
gn_error_t
gn_album_data_get_track_year(
	const gn_palbum_track_t track,
	const gn_uchar_t**      year
);

/*** TITLES ***/

/*	gn_album_data_get_album_title_rep_array
 *
 *	Retrieves a pointer to an array of representations of the album title.
 *	This function does not allocate memory.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the album or title_array pointers are null.
 *
 *		GCSPERR_NotFound	no title array exists for this album.
 *
 *	Parameters
 *		album         An album data structure.
 *		title_array   Pointer to the opaque title array data structure to be populated
 */
gn_error_t
gn_album_data_get_album_title_rep_array(
	const gn_palbum_t  album,
	gn_prep_array_t*   title_array
);

/*	gn_album_data_get_track_title_rep_array
 *
 *	Retrieves a pointer to an array of representations of the track title.
 *	This function does not allocate memory.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the track or title_array pointers are null.
 *
 *		GCSPERR_NotFound	no title array exists for this album.
 *
 *	Parameters
 *		track         An track data structure.
 *		title_array   Pointer to the opaque title array data structure to be populated
 */
gn_error_t
gn_album_data_get_track_title_rep_array(
	const gn_palbum_track_t  track,
	gn_prep_array_t*         title_array
);

/*** CREDITS ***/

/*	gn_album_data_get_album_credit_array
 *
 *	Retrieves a pointer to an array of credits describing the roles of various contributors for
 *	a given album.  This function does not allocate memory.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the album or credit_array pointers are null.
 *
 *		GCSPERR_NotFound	no credit array exists for this album.
 *
 *	Parameters
 *		album			A converted album data structure, allocated by gn_album_data_convert_album
 *		credit_array	Pointer to the opaque credit array data structure to be populated
 */
gn_error_t
gn_album_data_get_album_credit_array(
	const gn_palbum_t		album,
	gn_pcredit_array_t*		credit_array
);

/*	gn_album_data_get_track_credit_array
 *
 *	Retrieves a pointer to an array of credits describing the roles of various contributors for
 *	that track.  This function does not allocate memory.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the track or credit_array pointers are null.
 *
 *		GCSPERR_NotFound	no credit array exists for this track.
 *
 *	Parameters
 *		track			Album track data structure to retrieve credit array from
 *		credit_array	Pointer to the opaque credit array data structure to be populated
 */
gn_error_t
gn_album_data_get_track_credit_array(
	const gn_palbum_track_t  track,
	gn_pcredit_array_t*      credit_array
);

/*	gn_album_data_credit_array_get_size
 *
 *	Get the number of elements in the credit representation array.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the credit_array or array_size pointers are null.
 *
 *	Parameters
 *		credit_array	Pointer to the credit array obtained by gn_album_data_get_track_credit_array
 *		array_size		The size of the credit array
 */
gn_error_t
gn_album_data_credit_array_get_size(
	const gn_pcredit_array_t	credit_array,
	gn_uint32_t*				array_size
);

/*	gn_album_data_credit_array_get_element
 *
 *	Retrieves a specific element from the credit array.  The index is zero-based, and the largest
 *	valid value for the index is credit_array_size -1.  The credit_array_size is provided by the
 *	gn_album_data_credit_array_get_size function.  This function does not allocate memory.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the credit_array or credit_element pointers are null
 *							or the index is greater than the array size.
 *
 *		GCSPERR_NotFound	the element at the specified index is null.
 *
 *	Parameters
 *		credit_array	Pointer to the credit array obtained by gn_album_data_get_track_credit_array
 *		index			Zero-based index of the element to be retrieved
 *		credit_element	Pointer to the opaque credit element data structure to be populated
 */
gn_error_t
gn_album_data_credit_array_get_element(
	const gn_pcredit_array_t	credit_array,
	const gn_uint32_t			index,
	gn_pcredit_t*				credit_element
);

/*	gn_album_data_credit_is_featured
 *
 *	Given a gn_pcredit_t instance, the function indicates if the credit_element is designated as
 *	a "featured" credit associated with an album or track.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the credit_element or is_featured pointers are null
 *
 *	Parameters
 *		credit_element	A gn_pcredit_t instance.
 *
 *		is_featured		set to GN_TRUE if the credit_element is a "featured" credit
 *						(e.g., a soloist); GN_FALSE otherwise.
 */
gn_error_t
gn_album_data_credit_is_featured(
	const gn_pcredit_t		credit_element,
	gn_bool_t*				is_featured
);

/*	gn_album_data_credit_get_role_id
 *
 *	Given a gn_pcredit_t instance, retrieves a pointer to the role id for that credit (from
 *	the ROLES list).  If there is no role id for a particular credit the credit refers to the
 *	"primary artist" of the associated track or album. Memory is not allocated by this function.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the credit_element or role_id pointers are null
 *
 *	Parameters
 *		credit_element	A gn_pcredit_t instance.
 *		role_id			Pointer into which to return a displayable ID string (from the ROLES list)
 *						for this credit element. The returned string will be null if no role id
 *						exists for the credit element.
 */
gn_error_t
gn_album_data_credit_get_role_id(
	const gn_pcredit_t		credit_element,
	const gn_uchar_t**		role_id
);

/*	gn_album_data_credit_get_role_name
 *
 *	Given a gn_pcredit_t instance, retrieves a pointer to the role name for that credit (from
 *	the ROLES list).  If there is no role name for a particular credit the credit refers to the
 *	"primary artist".  Memory is NOT allocated by this function.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the credit_element or role_id pointers are null
 *
 *	Parameters
 *		credit_element	A gn_pcredit_t instance.
 *		role_name		Pointer into which to return a displayable string (from the ROLES list)
 *						for the type of contribution associated with this credit element.  The
 *						returned string will be null if no role name exists for the credit element.
 */
gn_error_t
gn_album_data_credit_get_role_name(
	const gn_pcredit_t		credit_element,
	const gn_uchar_t**		role_name
);

/*	gn_album_data_credit_get_keyedvalue
 *
 *	Given a gn_pcredit_t instance, retrieves a pointer to an indicated value
 *  associated with the name, if available.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	One of the arguments is a NULL pointer.
 *
 *	Parameters
 *		credit_element  A gn_pcredit_t instance.
 *      key             A string indicating which associated value to fetch.
 *      value           Upon successful return, will point to the requested string.
 *                      Memory is NOT allocated by this function. DO NOT free
 *                      value.
 *
 *  The available "key" types are application dependent. Those available to
 *  your application will be communicated to you directly.
 */
gn_error_t
gn_album_data_credit_get_keyedvalue(
	const gn_pcredit_t  credit_element,
	const gn_uchar_t*   key,
	const gn_uchar_t**  value
);

/*	gn_album_data_credit_get_rep_array
 *
 *	Given a gn_pcredit_t instance, retrieves a pointer to an array of
 *  representations of credit.
 *
 *	Return Value: GN_SUCCESS or error code:
 *		GCSPERR_InvalidArg	either the credit_element or rep_array pointers are null
 *
 *	Parameters
 *		credit_element	A gn_pcredit_t instance.
 *		rep_array		Pointer into which to return the representation array.
 */
gn_error_t
gn_album_data_credit_get_rep_array(
	const gn_pcredit_t  credit_element,
	gn_prep_array_t*    rep_array
);

/*** GENRE ARRAY ***/

/*	gn_album_data_get_album_genre_array
 *
 *	Get the genre array associated with the album.
 *	Call this function when populating your ASR/TTS dictionaries and grammars.
 *
 *	Parameters
 *		album:			The album object containing the genre.
 *		genre_array:	A pointer to the genre array. This array is owned by
 *						the album object, and should NOT be freed by the
 *						caller.
 *
 *	Error Return
 *		GN_SUCCESS				The genre array was successfully retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *		GNLISTSERR_NotInited	The list subsystem has not been initialized.
 *		GNLISTSERR_NoMemory		Memory allocation error.
 *		GNLISTSERR_NotFound		Display information does not exist for the
 *								genre master ID.
 *
 *	Remarks:
 *		The function may allocate memory internally the for gn_pgenre_arr_t,
 *		depending on whether this is the first call to the function.
 *		The caller SHOULD NOT free genre_array; the album data subsystem will
 *		take care of that.
 *		If the error return value is GN_SUCCESS, then the *genre_array value
 *		will not be GN_NULL.
 *		If the error return value is not GN_SUCCESS, then the *genre_array
 *		value is indeterminate.
 */
gn_error_t
gn_album_data_get_album_genre_array(
	const gn_palbum_t album,
	gn_pgenre_arr_t*  genre_array
);

/*	gn_album_data_get_track_genre_array
 *
 *	Get the genre array associated with the track.
 *	Call this function when populating your ASR/TTS dictionaries and grammars.
 *
 *	Parameters
 *		track:			The track object containing the genre.
 *		genre_array:	A pointer to the genre array. This array is owned by
 *						the track object, and should NOT be freed by the
 *						caller.
 *
 *	Error Return
 *		GN_SUCCESS				The genre array was successfully retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *		GNLISTSERR_NotInited	The list subsystem has not been initialized.
 *		GNLISTSERR_NoMemory		Memory allocation error.
 *		GNLISTSERR_NotFound		Display information does not exist for the
 *								genre master ID.
 *
 *	Remarks:
 *		The function may allocate memory internally for the gn_pgenre_arr_t,
 *		depending on whether this is the first call to the function.
 *		The caller SHOULD NOT free genre_array; the album data subsystem will
 *		take care of that.
 *		If the error return value is GN_SUCCESS, then the *genre_array value
 *		may be GN_NULL. You must check for GN_NULL before attempting to
 *		dereference genre_array.
 *		If the error return value is not GN_SUCCESS, then the *genre_array
 *		value is indeterminate.
*/
gn_error_t
gn_album_data_get_track_genre_array(
	const gn_palbum_track_t track,
	gn_pgenre_arr_t*        genre_array
);

/*** EXTENDED DATA ***/

/* gn_album_data_get_album_ext_data
 *
 * Retrieves a pointer to an extended data structure associated with the album.
 * If no extended data is present, this function will return GN_SUCCESS, and
 * the pext_data parameter will be GN_NULL.
 *
 * Args: album:     album data structure to retrieve extended data from
 *       pext_data: pointer to the extended data structure to be populated.
 *                  This structure should NOT be initialized with
 *                  gn_ext_data_init()
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Memory allocation error
 *              Invalid input
 */
gn_error_t
gn_album_data_get_album_ext_data(
	const gn_palbum_t album,
	gn_pext_data_t*   pext_data
);

/* gn_album_data_get_track_ext_data
 *
 * Retrieves a pointer to an extended data structure associated with the track.
 * If no extended data is present, this function will return GN_SUCCESS, and
 * the pext_data parameter will be GN_NULL.
 *
 * Args: track:     track data structure to retrieve extended data from
 *       pext_data: pointer to the extended data structure to be populated.
 *                  This structure should NOT be initialized with
 *                  gn_ext_data_init()
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Memory allocation error
 *              Invalid input
 */
gn_error_t
gn_album_data_get_track_ext_data(
	const gn_palbum_track_t track,
	gn_pext_data_t*         pext_data
);

/*** EXTERNAL IDS ***/

/* gn_album_data_get_album_external_id
 *
 * Retrieves a pointer to a selected external ID associated with the given
 * album. External IDs are used to access third party content from Gracenote
 * hosted servers.
 *
 * Refer to your documentation for a complete list of external IDs available to
 * your application.
 *
 * Args: album:       Album data structure from which to retrieve the ID
 *       data_source: Identifier of the (external) source of the ID to retrieve
 *       data_type:   Identifier of the (external) type of the ID to retrieve
 *       external_id: Upon successful return, this will be a pointer to the
 *                    requested external ID.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_album_data_get_album_external_id(
	const gn_palbum_t  album,
	const gn_uchar_t*  data_source,
	const gn_uchar_t*  data_type,
	const gn_uchar_t** external_id
);

/* gn_album_data_get_track_external_id
 *
 * Retrieves a pointer to a selected external ID associated with the given
 * track. External IDs are used to access third party content from Gracenote
 * hosted servers.
 *
 * Refer to your documentation for a complete list of external IDs available to
 * your application.
 *
 * Args: track:       Track data structure from which to retrieve the ID
 *       data_source: Identifier of the (external) source of the ID to retrieve
 *       data_type:   Identifier of the (external) type of the ID to retrieve
 *       external_id: Upon successful return, this will be a pointer to the
 *                    requested external ID.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_album_data_get_track_external_id(
	const gn_palbum_track_t  track,
	const gn_uchar_t*        data_source,
	const gn_uchar_t*        data_type,
	const gn_uchar_t**       external_id
);

/*** TAG IDS ***/

/* gn_album_data_get_album_tagid
 *
 * Retrieves a pointer to the tag ID associated with the given album. The tagid
 * can be used, for example, to tag music files. It can be used later to
 * uniquely identify the album record to Gracenote music ID technology.
 *
 * Args: album: Album data structure from which to retrieve the tagid.
 *       tagid: Upon successful return, this will be a pointer to the tagid
 *              associated with the given album.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_album_data_get_album_tagid(
	const gn_palbum_t  album,
	const gn_uchar_t** tagid
);

/* gn_album_data_get_track_tagid
 *
 * Retrieves a pointer to the tag ID associated with the given track. The tagid
 * can be used, for example, to tag music files. It can be used later to
 * uniquely identify the record to Gracenote music ID technology.
 *
 * Args: track: Track data structure from which to retrieve the tagid.
 *       tagid: Upon successful return, this will be a pointer to the tagid
 *              associated with the given track.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_album_data_get_track_tagid(
	const gn_palbum_track_t  track,
	const gn_uchar_t**       tagid
);

/***
 *** Accessors to support classical music
 ***/

/* gn_album_data_is_album_classical
 *
 * Indicates whether or not the given album has additional metadata specific to
 * classical works. If so, then that data can be accessed via the works array
 * of the album.
 *
 * Args: album: Album instance to query for presence of classical works data.
 *       is_classical: Upon successful return, this will be GN_TRUE if 'album'
 *              contains classical works data. Otherwise, it will be GN_FALSE.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_album_data_is_album_classical(
	const gn_palbum_t        album,
	gn_bool_t*               is_classical
);

/* gn_album_data_get_album_work_count
 *
 * Returns the number of classical works represented, wholely or in part, on a
 * given album. If an album contains a complete classical work, e.g. a symphony,
 * concerto or opera, or part of a single work, e.g. a movement, or an act or
 * scene, this will be 1. In cases where a single album contains more than 1
 * complete work or parts of more than 1 work, this will be more than 1.
 *
 * Args: album: Album instance to query for the work count.
 *       work_count: Upon successful return, this will be the number of
 *            classical works represented on the album.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_album_data_get_album_work_count(
	const gn_palbum_t        album,
	gn_uint32_t*             work_count
);

/* gn_album_data_get_album_work
 *
 * Returns one of the work instances represented on the given track.
 *
 * Args: album: album instance to query for the work.
 *       work_index: 0 based index for the work to retrieve. This must be less
 *            than the value of work_count returned by a previous call to
 *            gn_album_data_get_album_work_count().
 *       work: Upon successful return, this will be a pointer to the requested
 *            work. Note, this object is owned by the track and must not be
 *            freed by the caller.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 *              Index out of range
 */
gn_error_t
gn_album_data_get_album_work(
	const gn_palbum_t        album,
	gn_uint32_t              work_index,
	gn_pwork_t*              work
);

/* gn_album_data_get_track_work_count
 *
 * Returns the number of classical works represented, wholely or in part, on a
 * given track. If a track contains a complete classical work, e.g. a symphony,
 * concerto or opera, or part of a single work, e.g. a movement, or an act or
 * scene, this will be 1. In rare cases where a single track contains more than
 * 1 complete work or parts of more than 1 work, this will be more than 1.
 *
 * Args: track: Track instance to query for the work count.
 *       work_count: Upon successful return, this will be the number of
 *            classical works represented on the track.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_album_data_get_track_work_count(
	const gn_palbum_track_t  track,
	gn_uint32_t*             work_count
);

/* gn_album_data_get_track_work
 *
 * Returns one of the work instances represented on the given track. Note that
 * the works returned by a track on a given album will be a subset of the works
 * returned by the album.
 *
 * Args: track: Track instance to query for the work.
 *       work_index: 0 based index for the work to retrieve. This must be less
 *            than the value of work_count returned by a previous call to
 *            gn_album_data_get_track_work_count().
 *       work: Upon successful return, this will be a pointer to the requested
 *            work. Note, this object is owned by the track and must not be
 *            freed by the caller.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 *              Index out of range
 */
gn_error_t
gn_album_data_get_track_work(
	const gn_palbum_track_t  track,
	gn_uint32_t              work_index,
	gn_pwork_t*              work
);

/* gn_work_get_title
 *
 * Return a pointer to the display string of the official representation of the
 * title of the work.
 *
 * Args: work: Work instance to query for the title.
 *       work_title: The official title of the work. Note, this string is owned
 *            by the work and should not be freed by the caller.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_work_get_title(
	const gn_pwork_t         work,
	const gn_uchar_t**       work_title
);

/* gn_work_get_composer
 *
 * Retrieve a pointer to the display string of the official representation of
 * the composer's name.
 *
 * Args: work: Work instance to query for the composer name.
 *       composer_name: The official name of the work's composer. Note, this
 *            string is owned by the work and should not be freed by the caller.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_work_get_composer(
	const gn_pwork_t         work,
	const gn_uchar_t**       composer_name
);

/* gn_work_get_composer_origin
 *
 * Retrieve the display string of the country of origin of the work's composer.
 *
 * Args: work: Work instance to query for the composer origin.
 *       composer_origin: The display string of the composer's country of
 *            origin. Note, this string is owned by the work and should not be
 *            freed by the caller.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_work_get_composer_origin(
	const gn_pwork_t         work,
	const gn_uchar_t**       composer_origin
);

/* gn_work_get_era
 *
 * Retrieve the display string of the era of the composition.
 *
 * Args: work: Work instance to query for the era.
 *       era: The display string of the era of the work. Note, this string is
 *            owned by the work and should not be freed by the caller.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_work_get_era(
	const gn_pwork_t         work,
	const gn_uchar_t**       era
);

/* gn_work_get_genre
 *
 * Retrieve the display string of the primary genre of the work.
 *
 * Args: work: Work instance to query for the genre.
 *       genre: The display string of the genre of the work. Note, this string
 *            is owned by the work and should not be freed by the caller.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_work_get_genre(
	const gn_pwork_t         work,
	const gn_uchar_t**       genre
);

/* gn_work_get_title_rep_array
 *
 * Retrieves a pointer to the array of representations of the work title. The
 * returned title_array is owned by the work and should not be freed by the
 * caller.
 *
 * Args: work: Work instance to query for the title representations.
 *       title_array: Upon successful return this will be a pointer to the
 *            array of representations (official, alternate, etc) of the
 *            work's title.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_work_get_title_rep_array(
	const gn_pwork_t         work,
	gn_prep_array_t*         title_array
);

/* gn_work_get_composer_rep_array
 *
 * Retrieves a pointer to the array of representations of the composer. The
 * returned composer_array is owned by the work and should not be freed by
 * the caller.
 *
 * Args: work: Work instance to query for the title representations.
 *       composer_array: Upon successful return this will be a pointer to the
 *            array of representations (official, alternate, etc) of the
 *            work's composer.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_work_get_composer_rep_array(
	const gn_pwork_t         work,
	gn_prep_array_t*         composer_array
);

/* gn_work_get_credit_array
 *
 * Retrieves a pointer to an array of credits associated with the work. In most
 * cases this will only contain a member for the work's composer and nothing
 * more. The credit_array is owned by the work and should not be freed by the
 * caller.
 *
 * Args: work: Work instance to query for the credit array.
 *       credit_array: Upon successful return this will be a pointer to the
 *            array of credits associated with the work.
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *          Failure conditions include:
 *              Invalid input
 */
gn_error_t
gn_work_get_credit_array(
	const gn_pwork_t         work,
	gn_pcredit_array_t*      credit_array
);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_ALBUM_TRACK_ACCESSORS_H_ */
