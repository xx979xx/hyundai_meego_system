/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_coverart.h - Cover art delivery mechanism.
 */

#ifndef	_GN_COVERART_H_
#define _GN_COVERART_H_

/*
 * Dependencies.
 */

#include "gn_ext_data.h"
#include "gn_coverart_types.h"

#include "gn_album_track_types.h"		/* for gn_palbum_t */
#include "gn_dvd_video_data_types.h"	/* for gn_pvideo_t */


#ifdef GN_TEXTID
#include "gn_textid_lookup.h"			/* for gn_textid_presult_data_t */
#endif /* GN_TEXTID */


#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants
 */


/*
 * Typedefs
 */

#ifndef GN_OLC_HANDLE
	#define GN_OLC_HANDLE
	typedef void* gn_olc_handle_t;
#endif /* GN_OLC_HANDLE */

/*
 * Prototypes
 */

/* Prepare to perform a cover art lookup from an album lookup result.
 *
 * Parameters:
 *   IN
 *     album_data: the album lookup you wish to retrieve cover art for
 *   OUT
 *     cover_art: Data structure containing cover art image
 *                The caller owns the returned object and must free the object
 *                via a call to gn_coverart_smart_free().
 *
 * Return values:
 *   If there is enough information to attempt to retrieve cover art 
 *     error value : GN_SUCCESS
 *     cover_art   : Allocated and populated cover art structure
 *
 *   On error:
 *     error value : Gracenote Error Value
 *     cover_art   : Undefined
 *     Errors include:
 *       - cover_art is a null pointer.
 *       - Attempt to prepare for cover art retrieval before performing an album lookup.
 */
gn_error_t
gn_coverart_prepare_from_album_data(
	const gn_palbum_t		album_data,
	gn_coverart_t*			cover_art
	);

/* Prepare to perform a cover art lookup from an video lookup result.
 *
 * Parameters:
 *   IN
 *     video_data: the video lookup you wish to retrieve cover art for
 *   OUT
 *     cover_art: Data structure containing cover art image
 *                The caller owns the returned object and must free the object
 *                via a call to gn_coverart_smart_free().
 *
 * Return values:
 *   If there is enough information to attempt to retrieve cover art 
 *     error value : GN_SUCCESS
 *     cover_art   : Allocated and populated cover art structure
 *
 *   On error:
 *     error value : Gracenote Error Value
 *     cover_art   : Undefined
 *     Errors include:
 *       - cover_art is a null pointer.
 *       - Attempt to prepare for cover art retrieval before performing an album lookup.
 */
gn_error_t
gn_coverart_prepare_from_video_data(
	const gn_pvideo_t		video_data,
	gn_coverart_t*			cover_art
	);

/* Prepare to perform a cover art lookup from the most recent local album lookup result.
 *
 * Parameters:
 *   OUT
 *     cover_art: Data structure containing cover art image
 *                The caller owns the returned object and must free the object
 *                via a call to gn_coverart_smart_free().
 *
 * Return values:
 *   If there is enough information to attempt to retrieve cover art 
 *     error value : GN_SUCCESS
 *     cover_art   : Allocated and populated cover art structure
 *
 *   On error:
 *     error value : Gracenote Error Value
 *     cover_art   : Undefined
 *     Errors include:
 *       - cover_art is a null pointer.
 *       - Attempt to prepare for cover art retrieval before performing an album lookup.
 */
gn_error_t
gn_coverart_prepare_from_local_lookup(
	gn_coverart_t*	cover_art
	);

/* Prepare to perform a cover art lookup from the most recent online album lookup result.
 *
 * Parameters:
 *   IN
 *     olc_handle: Reserved, should be set to GN_NULL.
 *   OUT
 *     cover_art: Data structure containing cover art image
 *                The caller owns the returned object and must free the object
 *                via a call to gn_coverart_smart_free().
 *
 * Return values:
 *   If there is enough information to attempt to retrieve cover art 
 *     error value : GN_SUCCESS
 *     cover_art   : Allocated and populated cover art structure
 *
 *   On error:
 *     error value : Gracenote Error Value
 *     cover_art   : Undefined
 *     Errors include:
 *       - cover_art is a null pointer.
 *       - Attempt to prepare for cover art retrieval before performing an album lookup.
 */
gn_error_t
gn_coverart_prepare_from_online_lookup(
	gn_olc_handle_t				olc_handle,
	gn_coverart_t*				cover_art
	);

#ifdef GN_TEXTID

/* Prepare to perform a cover art lookup from the a textid lookup result.
 *
 * Parameters:
 *   IN
 *     textid_result: the textID result you wish to retrieve cover art for
 *   OUT
 *     cover_art: Data structure containing cover art image
 *                The caller owns the returned object and must free the object
 *                via a call to gn_coverart_smart_free().
 *
 * Return values:
 *   If there is enough information to attempt to retrieve cover art 
 *     error value : GN_SUCCESS
 *     cover_art   : Allocated and populated cover art structure
 *
 *   On error:
 *     error value : Gracenote Error Value
 *     cover_art   : Undefined
 *     Errors include:
 *       - cover_art is a null pointer.
 *       - Attempt to prepare for cover art retrieval before performing an textID lookup.
 */
gn_error_t
gn_coverart_prepare_from_textid_lookup(
	const gn_textid_presult_data_t	textid_result,
	gn_coverart_t*					cover_art
	);

#endif /* GN_TEXTID */

/* Prepare to perform a cover art lookup from data which has been previously cached.
 *
 * Parameters:
 *   IN
 *	 pext_data: An extended data object which was populated by gn_coverart_to_extended_data().
 *   OUT
 *	 cover_art: A newly constructed gn_coverart_t instance which has been populated with
 *				information from extended_data. This gn_coverart_t instance may be used to
 *				attempt a cover art fetch.
 *				The caller owns the returned object and must free the object via a call to
 *				gn_coverart_smart_free().
 *
 * Return Values:
 *   On success:
 *	 error value   : GN_SUCCESS
 *	 cover_art	 : Will have been created and populated with information required to attempt
 *					 a cover art fetch.
 *
 *   On error:
 *	 error value   : Gracenote Error Value
 *	 cover_art	 : Will not have been allocated.
 *
 *	 Errors include:
 *	   - extended_data does not contain any information which would enable a cover art fetch
 */
gn_error_t
gn_coverart_prepare_from_ext_data(
	const gn_pext_data_t pext_data,
	gn_coverart_t*	   cover_art
);

/* Attempt an ODL Cache album cover art retrieval.
 *
 * Parameters:
 *   IN/OUT
 *     cover_art: A prepared gn_coverart_t data structure
 *
 * Return values:
 *   Cover art found:
 *     error value			: GN_SUCCESS
 *     cover_art			: The retrieved cover art will be stored in the existing gn_coverart_t data structure
 *     cover_art_available	: GN_TRUE
 *
 *   Cover art not found:
 *     error value			: GN_SUCCESS
 *     cover_art			: no change
 *     cover_art_available	: GN_FALSE
 *
 *   On error:
 *     error value			: Gracenote Error Value
 *     cover_art			: no change
 *     cover_art_available	: GN_FALSE
 *
 *     Errors include:
 *       - cover_art has not been prepared
 */
gn_error_t
gn_coverart_retrieve_odl_cache_album_art(
	gn_coverart_t				cover_art,
	gn_bool_t*					cover_art_available
);

/* Attempt a local album cover art retrieval.
 *
 * Parameters:
 *   IN/OUT
 *     cover_art: A prepared gn_coverart_t data structure
 *
 * Return values:
 *   Cover art found:
 *     error value			: GN_SUCCESS
 *     cover_art			: The retrieved cover art will be stored in the existing gn_coverart_t data structure
 *     cover_art_available	: GN_TRUE
 *
 *   Cover art not found:
 *     error value			: GN_SUCCESS
 *     cover_art			: no change
 *     cover_art_available	: GN_FALSE
 *
 *   On error:
 *     error value			: Gracenote Error Value
 *     cover_art			: no change
 *     cover_art_available	: GN_FALSE
 *
 *     Errors include:
 *       - cover_art has not been prepared
  */
gn_error_t
gn_coverart_retrieve_local_album_art(
	gn_coverart_t				cover_art,
	gn_bool_t*					cover_art_available
	);

/* Attempt a local artist art retrieval.
 *
 * Parameters:
 *   IN/OUT
 *     artist_image					: A prepared gn_coverart_t data structure
 *
 * Return values:
 *   Artist art found:
 *     error value					: GN_SUCCESS
 *     artist_image					: The retrieved artist image will be stored in the existing gn_coverart_t data structure
 *     artist_image_available		: GN_TRUE
 *
 *   Artist art not found:
 *     error value					: GN_SUCCESS
 *     artist_image					: no change
 *     artist_image_available		: GN_FALSE
 *
 *   On error:
 *     error value					: Gracenote Error Value
 *     artist_image					: no change
 *     artist_image_available		: GN_FALSE
 *
 *     Errors include:
 *       - artist_image has not been prepared
  */
gn_error_t
gn_coverart_retrieve_local_artist_image(
	gn_coverart_t				artist_image,
	gn_bool_t*					artist_image_available
	);

/* Attempt an online album cover art retrieval.
 *
 * Parameters:
 *   IN/OUT
 *     cover_art: A prepared gn_coverart_t data structure
 *
 * Return values:
 *   Cover art found:
 *     error value			: GN_SUCCESS
 *     cover_art			: The retrieved cover art will be stored in the existing gn_coverart_t data structure
 *     cover_art_available	: GN_TRUE
 *
 *   Cover art not found:
 *     error value			: GN_SUCCESS
 *     cover_art			: no change
 *     cover_art_available	: GN_FALSE
 *
 *   On error:
 *     error value			: Gracenote Error Value
 *     cover_art			: no change
 *     cover_art_available	: GN_FALSE
 *
 *     Errors include:
 *       - cover_art has not been prepared
 */
gn_error_t
gn_coverart_retrieve_online_album_art(
	gn_olc_handle_t				olc_handle,
	gn_coverart_t				cover_art,
	gn_bool_t*					cover_art_available
	);

/* Attempt an online artist art retrieval.
 *
 * Parameters:
 *   IN/OUT
 *     artist_image: A prepared gn_coverart_t data structure
 *
 * Return values:
 *   Cover art found:
 *     error value				: GN_SUCCESS
 *     artist_image				: The retrieved artist image will be stored in the existing gn_coverart_t data structure
 *     artist_image_available	: GN_TRUE
 *
 *   Cover art not found:
 *     error value				: GN_SUCCESS
 *     artist_image				: no change
 *     artist_image_available	: GN_FALSE
 *
 *   On error:
 *     error value				: Gracenote Error Value
 *     artist_image				: no change
 *     artist_image_available	: GN_FALSE
 *
 *     Errors include:
 *       - artist_image has not been prepared
 */
gn_error_t
gn_coverart_retrieve_online_artist_image(
	gn_olc_handle_t				olc_handle,
	gn_coverart_t				artist_image,
	gn_bool_t*					artist_image_available
	);

/* Attempt a local genre cover art retrieval.
 *
 * Parameters:
 *   IN/OUT
 *     cover_art: A prepared gn_coverart_t data structure
 *
 * Return values:
 *   Cover art found:
 *     error value			: GN_SUCCESS
 *     cover_art			: The retrieved cover art will be stored in the existing gn_coverart_t data structure
 *     cover_art_available	: GN_TRUE
 *
 *   Cover art not found:
 *     error value			: GN_SUCCESS
 *     cover_art			: no change
 *     cover_art_available	: GN_FALSE
 *
 *   On error:
 *     error value			: Gracenote Error Value
 *     cover_art			: no change
 *     cover_art_available	: GN_FALSE
 *
 *     Errors include:
 *       - cover_art has not been prepared
  */
gn_error_t
gn_coverart_retrieve_local_genre_art(
	gn_coverart_t				cover_art,
	gn_bool_t*					cover_art_available
	);

/* Prepare to perform a cover art lookup from an album tagID.
 *
 * Parameters:
 *   IN
 *     tagid:     the tagid of the album you wish to retrieve cover art for
 *   OUT
 *     cover_art: Data structure containing cover art image
 *                The caller owns the returned object and must free the object
 *                via a call to gn_coverart_smart_free().
 *
 * Return values:
 *   If there is enough information to attempt to retrieve cover art 
 *     error value : GN_SUCCESS
 *     cover_art   : Allocated and populated cover art structure
 *
 *   On error:
 *     error value : Gracenote Error Value
 *     cover_art   : Undefined
 *     Errors include:
 *       - cover_art is a null pointer.
 */

gn_error_t
gn_coverart_prepare_from_album_tagid(
	const gn_uchar_t*		tagid,
	gn_coverart_t*			cover_art
	);

/* Retrieve an album tagId from the coverart data structure which may be used to retrieve cover art at a later date
 *
 * Parameters:
 *   IN
 *     cover_art: Pointer to a previously prepared cover art data structure
 *   OUT
 *     tagid:     Upon successful return, this will be a pointer to the tagid
 *                associated with the given cover art.
 *
 * Return values:
 *   If a tagID is available.
 *     error value : GN_SUCCESS
 *     tagid   : Allocated and populated cover art structure
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *              Failure conditions include:
 *                  Invalid input
 */

gn_error_t
gn_coverart_get_album_tagid(
	const gn_coverart_t		cover_art,
	const gn_uchar_t**		tagid
	);


/* Add information from the given gn_coverart_t object to the given extended data object.
 * The extended data object can be serialized and saved. It can then be deserialized at a later
 * time in order to access information required to attempt a cover art fetch. The serialization
 * and deserialization interface can be found in gn_ext_data.h. The information required to
 * attempt a cover art fetch is obtained from an extended data object via
 * gn_coverart_prepare_from_extended_data().
 *
 * The extended data object must already have been created with gn_ext_data_init().
 * The extended data object may already contain information from other sources.
 *
 * The gn_coverart_t must have already been created with one of the gn_coverart_prepare_from_*()
 * functions. If, in addition to a gn_coverart_prepare_from_*() function, a cover art fetch has
 * also been attempted with the gn_coverart_t prior to calling this function, the gn_coverart_t
 * may contain more information.
 *
 * Parameters:
 *   IN
 *	 cover_art: A prepared gn_coverart_t data structure. A cover art fetch may or may not have
 *				already been attempted with this object.
 *   IN/OUT
 *	 pext_data: A previously constructed gn_pext_data_t object to which information from
 *					the given gn_coverart_t object will be added.
 *
 * Return Values:
 *   On success:
 *	 error value	 : GN_SUCCESS
 *	 pext_data       : Will contain additional data from the given gn_coverart_t.
 *
 *   On error:
 *	 error value	 : Gracenote Error Value
 *	 extended_data   : Will not have been modified.
 *
 *	 Errors include:
 *	   - cover_art has not been prepared
 */
gn_error_t
gn_coverart_to_ext_data(
	const gn_coverart_t cover_art,
	gn_pext_data_t	  pext_data
);

/* Indicates whether a gn_coverart_t instance has been modified since it was created. This
 * function should only be called on gn_coverart_t instances which were created by a call
 * to gn_coverart_prepare_from_extended_data().
 *
 * Between the time an extended data object with cover art information is serialized and the time
 * a gn_coverart_t is reconstituted from it, it is possible that the available cover art will have
 * changed. In this case, during the lookup the contents of the gn_coverart_t may be modified and
 * so it will be necessary to reserialize the data and store it in place of the original object.
 * This function indicates whether this is necessary. If called before attempting a lookup, the
 * return argument will always be GN_FALSE.
 *
 * Parameters:
 *   IN
 *	 cover_art: A gn_coverart_t instance created with gn_coverart_prepare_from_extended_data().
 *   OUT
 *	 serialization_required: Indicates whether any information in cover_art which is required
 *				to attempt a cover art fetch has been modified since cover_art was created.
 *
 * Return Values:
 *   Cover art fetch information has not changed since cover_art was created:
 *	 error value   : GN_SUCCESS
 *	 cover_art	 : GN_FALSE
 *
 *   Cover art fetch information has changed since cover_art was created:
 *	 error value   : GN_SUCCESS
 *	 cover_art	 : GN_TRUE
 *
 *   On error:
 *	 error value   : Gracenote Error Value
 *	 cover_art	 : Indeterminant
 */
gn_error_t
gn_coverart_serialization_required(
	const gn_coverart_t cover_art,
	gn_bool_t*		   serialization_required
);

/* Frees all memory held by the cover_art structure and nulls the pointer.
 */
gn_error_t
gn_coverart_smart_free(
	gn_coverart_t* cover_art
	);
	
/* Retrieves the source of the image stored in the given gn_coverart_t struct.
 * 
 * Parameters:
 *
 *   IN:  A gn_coverart_t structure.
 *   OUT: The format of the image represented by cover_art.
 *        This can take on one of the GN_COVERART_SOURCE_* values defined in
 *        gn_coverart_types.h.
 */
gn_error_t
gn_coverart_get_image_source(
	gn_coverart_t				cover_art,
	gn_coverart_source_t*			source
	);

/* Retrieves the image format of the given gn_coverart_t struct.
 * 
 * Parameters:
 *
 *   IN:  A gn_coverart_t structure.
 *   OUT: The format of the image represented by cover_art.
 *        This can take on one of the GN_COVERART_FORMAT_* values defined in
 *        gn_coverart_types.h.
 */
gn_error_t
gn_coverart_get_image_format(
	gn_coverart_t         cover_art,
	gn_coverart_format_t* image_format
	);

/* Retrieves the image dimension of the given gn_coverart_t struct.
 * 
 * Parameters:
 *
 *   IN:  A gn_coverart_t structure.
 *   OUT: The dimension of the image represented by cover_art.
 *        This can take on one of the GN_COVERART_DIMENSION_* values defined in
 *        gn_coverart_types.h.
 */
gn_error_t
gn_coverart_get_image_dimension(
	gn_coverart_t            cover_art,
	gn_coverart_dimension_t* image_dimension
	);

/* Retrieves the image size of the given gn_coverart_t struct.
 * 
 * Parameters:
 *
 *   IN:  A gn_coverart_t structure.
 *   OUT: The size in bytes of the image represented by cover_art.
 */
gn_error_t
gn_coverart_get_image_size(
	gn_coverart_t cover_art,
	gn_uint32_t*  image_size
	);

/* Retrieves the image buffer of the given gn_coverart_t struct.
 * 
 * Parameters:
 *
 *   IN:  A gn_coverart_t structure.
 *   OUT: The image buffer retrieved from cover_art.
 */
gn_error_t
gn_coverart_get_image(
	gn_coverart_t cover_art,
	gn_uchar_t**   image
	);

/* Sets the desired dimension of cover art images retrieved for online cover art
 *
 * If the desired dimension is not available from the online lookup,
 * no cover art is returned.
 *
 * Return values:
 *   On error:
 *     error value : Gracenote Error Value
 *     Errors include:
 *       - not intialized
 *       - invalid argument
 *       - not supported
 */
gn_error_t
gn_coverart_set_online_dimension(
    gn_coverart_dimension_t dimension
    );

/* Sets the desired dimension of VIDEO cover art images retrieved for online cover art
 *
 * If the desired dimension is not available from the online lookup,
 * no cover art is returned.
 *
 *
 * Return values:
 *   On error:
 *     error value : Gracenote Error Value
 *     Errors include:
 *       - not intialized
 *       - invalid argument
 *       - not supported
 */

gn_error_t
gn_coverart_set_online_video_dimension(
    gn_coverart_dimension_t dimension
    );


#ifdef __cplusplus
}
#endif


#endif /* _GN_COVERART_H_ */
