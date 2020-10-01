/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_representation.h - displayable metadata representation container.
 *
 * The representation API provides a mechanism by which to associate different
 * phrases with each other, where all phrases are intended to refer to an
 * identical object; for instance, an artist name, an album title, a genre
 * description.
 *
 * Associated with each phrase are one or more phonetic transcriptions, each
 * transcription providing a different pronunciation of the phrase.
 *
 * NOTE: Only the transcript array accessor allocates memory. Refer to that API
 *       for clean up instructions. All other accessed data items are owned by
 *       the library.
 */

/*
 * Dependencies.
 */

#ifndef _GN_REPRESENTATION_H_
#define _GN_REPRESENTATION_H_

#include "gn_defines.h"
#include "gn_transcript_types.h"
#include "gn_collation_data.h"

/*
 * Constants.
 */

/* Identify the "type" of the representation. */

/* A note on official and official variant representations:
 *
 *  An object (title or name) has representations that are different depending
 *  on what written language is used to represent them.  Between written languages
 *  it is possible to have representations that even though different in appearance 
 *  spoken sound, and or meaning, are both considered to be official.
 *
 *  A representation that is considered official for a specific written language
 *  is of type GN_REPRESENTATION_OFFICIAL_VARIANT.
 *  
 *  When a representation is is not associated with a specific written language
 *  then the representation is of type GN_REPRESENTATION_OFFICIAL.
 *  This can be considered to be a default official representation.
 *
 *  The function gn_representation_get_official is provided to choose the
 *  appropriate official representation for the selected written language.
 *  See comments on gn_representation_get_official for more information.
 */

/* The representation type  is unknown. */
#define		GN_REPRESENTATION_UNKNOWN			1

/* The representation is the default official representation.  Used when a suitable 
 * official variant is not available. */
#define		GN_REPRESENTATION_OFFICIAL			2

/* The representation is an alternate variant, "nick-name", or lengthened 
 * or more formal form of the representation. Alternate variants should 
 * not be displayed the user and should only be used for MediaVOCS.
 */
#define		GN_REPRESENTATION_ALTERNATE			3

/* The representation reflects a variant of an official representation
 * for a specific written language.
 * For example a transliteration, where an artist name is written in a different 
 * character set then the official artist name.
 *
 * Another example is when a name is commonly ascribed to an artist in a particular
 * language that is different from one ascribed to an artist in another language,
 * even though both are considered to be official.
 */
#define		GN_REPRESENTATION_OFFICIAL_VARIANT	4

/* The representation is the TLS representation of a classical title or 
 * contributor name.
 */
#define		GN_REPRESENTATION_TLS				5

#ifdef __cplusplus
extern "C"{
#endif


/*
 * Structures and typedefs.
 */

/* Data type which can take on the GN_REPRESENTATION_ values. */
typedef gn_uint32_t	gn_rep_type_t;

/* A representation element, consisting of a "type", a display string
 * (or "phrase"), and an optional array of phonetic transcriptions.
 */
typedef void* gn_prepresentation_t;

/* A representation array, containing an array of gn_representation_t
 * pointers, a count of populated array elements, and the total size of the
 * pointer array (consisting of populated and open array elements).
 */
typedef void* gn_prep_array_t;


/*
 * Prototypes.
 */

/*	gn_representation_get_element_count
 *
 *	Get the number of elements in the representation array.
 *
 *	Parameters
 *		rep_arr:		The array containing all representation elements for
 *						a given display object (e.g., name, title, genre
 *						description).
 *		element_count:	The number of elements in the representation array.
 *
 *	Error Return
 *		GN_SUCCESS				The number of elements in the representation
 *								array has been retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*element_count parameter is indeterminate.
 */
gn_error_t
gn_representation_get_element_count(
	gn_prep_array_t const rep_arr,
	gn_uint32_t*          element_count
);

/*	gn_representation_get_rep
 *
 *	Get a gn_representation_t element from the representation array.
 *
 *	Parameters
 *		rep_array:		The array containing all representation elements for
 *						a given display object (e.g., name, title, genre
 *						description).
 *		index:			The index (0-based) of the representation element to
 *						retrieve.
 *		representation:	The representation element to retrieve.
 *
 *	Error Return
 *		GN_SUCCESS				The representation has been retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer, or the index value is greater than
 *								the number of elements in the rep_array.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*representation parameter is indeterminate.
 */
gn_error_t
gn_representation_get_rep(
	const gn_prep_array_t rep_array,
	gn_uint32_t			  index,
	gn_prepresentation_t* representation
);

/**
 ** The following two functions have been deprecated as of the 5.1 Release.
 ** They may be removed from a future release.
 **/

/*	gn_representation_is_official
 *
 *  Deprecation Note: As of Release 5.1, there can be more than 1 official
 *     representation. This is due to support for different official
 *     representations in different languages. To fetch the official
 *     representation, rather than iterating over the representations with
 *     gn_representation_get_rep() and calling gn_representation_is_official(),
 *     you should call gn_representation_get_official().
 *     In R14, this function will return GN_TRUE if "rep" is the official
 *     representation in any language.
 *
 *	Query whether the representation is an official representation.
 *	This is a convenience function. The function tests the representation
 *	type against the GN_REPRESENTATION_OFFICIAL value.
 *
 *	Parameters
 *		rep:			The representation object.
 *		is_official:	A pointer to a boolean flag. The value is GN_TRUE
 *						if the representation is "official", and GN_FALSE
 *						if it is not.
 *
 *	Error Return
 *		GN_SUCCESS				The "official" status of the representation
 *								has been retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*is_official parameter is indeterminate.
 */
gn_error_t
gn_representation_is_official(
	const gn_prepresentation_t rep,
	gn_bool_t*                 is_official
);

/*	gn_representation_is_primary
 *
 *	Query whether the representation is the primary representation.
 *
 *	Parameters
 *		rep:			The representation object.
 *		is_primary:		A pointer to a boolean flag. The value is GN_TRUE
 *						if the representation is "primary", and GN_FALSE
 *						if it is not.
 *
 *	Error Return
 *		GN_SUCCESS				The "primary" status of the representation
 *								has been retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*is_primary parameter is indeterminate.
 */
gn_error_t
gn_representation_is_primary(
	const gn_prepresentation_t rep,
	gn_bool_t*                 is_primary
);

/**
 ** End of deprecated functions.
 **/

/*	gn_representation_get_official
 *
 *	Get an official gn_representation_t element from the representation array.
 *  There can be different official variant representations corresponding to
 *  different written languages.
 *  You can select the written language of the official variant representation
 *  to fetch using the optional "variant_lang" argument. If an official variant
 *  representation exists in that language, it will be fetched. Otherwise this
 *  will return GN_NULL.
 *  If preferred_lang is GN_NULL, the non-regional official representation will
 *  be fetched.
 *
 *	Parameters
 *		rep_array:		The array containing all representation elements for
 *						a given display object (e.g., name, title, genre
 *						description).
 *		representation:	On successful return, this will be the non-regional
 *						official representation if variant_lang was GN_NULL.
 *						If variant_lang was specified, this will be the
 *						official variant if available, or GN_NULL.
 *		variant_lang: Optional argument used to select the language of the
 *                      official variant representation to fetch. Note that an
 *						official variant representation will not exist in all
 *						supported written languages. If this argument is
 *						GN_NULL, then the non-regional official representation
 *						will be fetched. This is usually the official
 *						representation in the native language of the object.
 *
 *	Error Return
 *		GN_SUCCESS				The representation has been retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *                              pointer.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*representation parameter is indeterminate.
 */
gn_error_t
gn_representation_get_official(
	const gn_prep_array_t rep_array,
	gn_prepresentation_t* representation,
	const gn_langid_t     variant_lang
);

/*	gn_representation_get_rep_type
 *
 *	Get the type of the representation.
 *	Representation types are defined as GN_REPRESENTATION_ values.
 *
 *	Parameters
 *		rep:			The representation object.
 *		type:			A pointer to a gn_rep_type_t; the value represents
 *						the "type" of the representation.
 *
 *	Error Return
 *		GN_SUCCESS				The "type" value for the representation has
 *								been retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*type parameter is indeterminate.
 */
gn_error_t
gn_representation_get_rep_type(
	const gn_prepresentation_t rep,
	gn_rep_type_t*             type
);

/*	gn_representation_get_display_string
 *
 *	Get the display string associated with the representation.
 *	In "MediaVOCS" terms, this is the "orthography".
 *
 *	Parameters
 *		rep:			The representation object.
 *		display_string:	A pointer to the display string associated with the
 *						representation.
 *
 *	Error Return:
 *		GN_SUCCESS				The representation's display string has been
 *								retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*display_string parameter is indeterminate.
 */
gn_error_t
gn_representation_get_display_string(
	const gn_prepresentation_t rep,
	gn_uchar_t**               display_string
);

/*	gn_representation_get_language_id
 *
 *	Get the written language ID of the given gn_representation_t instance.
 *  This will correspond to the language of the display string returned by
 *  gn_representation_get_display_string().
 *
 *  As mentioned in above, only official representation variants will have an 
 *  associated written language ID, so it is possible for this function to 
 *  return GN_NULL.
 *
 *	Parameters
 *		rep:			The representation object.
 *		language_id:	A pointer to the language ID associated with the
 *						representation.
 *
 *	Error Return:
 *		GN_SUCCESS				The representation's language ID has been
 *								retrieved.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*language_id parameter is indeterminate.
 */
gn_error_t
gn_representation_get_language_id(
	const gn_prepresentation_t rep,
	gn_langid_t*               language_id
);

/*	gn_representation_get_transcript_array
 *
 *	Retrieve an array of phonetic transcriptions associated with the given
 *	representation object.
 *
 *	Error Return:
 *		GN_SUCCESS				An error-free attempt was made to retrieve
 *								phonetic transcriptions for the given spoken
 *								language ID.
 *		GNDACCERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *		GNTRANSCRIPTERR_NotInited	The transcription subsystem is not
 *									initialized.
 *		GNTRANSCRIPTERR_NoMemory	Memory allocation error.
 *
 *	Parameters:
 *		rep:						The representation object.
 *		target_spoken_language_id:	The target spoken language ID, e.g USA_eng
 *                                  or FRA_fre. Refer to your library reference
 *                                  manual for available values.
 *		transcript_array:			A pointer to the transcription array to
 *									retrieve.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*transcript_array parameter is indeterminate.
 *
 *		This function allocates memory for transcript_array. It must be
 *		freed by the caller via gn_transcript_array_destroy.

 *		Phonetic transcriptions are internally stored in their "native" spoken
 *		language. These transcriptions will populate the transcript_array, if
 *		the "native" spoken language is identical to the value for
 *		target_spoken_language_id.
 *		If the target spoken language is not identical to the "native" spoken
 *		language, the function will attempt to convert the internally stored
 *		phonetic transcriptions into the target spoken language, using phoneme
 *		conversion maps.
 *		In either of these cases, transcript_array will be populated and the
 *      error return value will be GN_SUCCESS.
 *		If "native" phonetic transcriptions are unavailable, and if phoneme
 *		conversion maps are unavailable to convert the transcriptions, then
 *		*transcript_array will be set to GN_NULL and the error return value
 *		will be GN_SUCCESS.
 *
 *		Refer to the gn_transcript_ API for further information on phonetic
 *		transcriptions.
 */
gn_error_t
gn_representation_get_transcript_array(
	const gn_prepresentation_t rep,
	const gn_spklangid_t       target_spoken_language_id,
	gn_ptranscript_arr_t*      transcript_array
);

/*	gn_representation_get_collation_array
 *
 *	Retrieve an array of collation objects associated with the given
 *	representation object.
 *
 *	Parameters:
 *		rep:						The representation object.
 *									initialization.
 *		coll_array:					A pointer to the collation object array to
 *									retrieve.
 *
 *	Remarks:
 *		If the return value is not GN_SUCCESS, then the value of the
 *		*coll_array parameter is indeterminate.
 *
 *		This function should only be called if the type of rep is
 *      GN_REPRESENTATION_OFFICIAL or GN_REPRESENTATION_OFFICIAL_VARIANT.
 *
 *		This function will set coll_array to GN_NULL if no collation objects
 *		for the representation exist.
 * 
 *		This function does not allocate memory for the collation array.
 *
 *		Refer to the gn_collation.h API for further information on collation
 *		objects.
 */
gn_error_t
gn_representation_get_collation_array(
	const gn_prepresentation_t rep,									  
	gn_collation_data_array_t* coll_array
);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_REPRESENTATION_H_ */
