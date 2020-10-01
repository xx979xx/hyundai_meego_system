/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_odl.h - API for managing on demand lookups.
 */

#ifndef	_GN_ODL_H_
#define _GN_ODL_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_album_types.h"
#include "gn_dvd_video_data_types.h"
#include "gn_video_toc.h"
#include "gn_coverart.h"

#ifdef GN_TEXTID
#include "gn_textid_lookup.h"
#endif

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Defines and typedefs
 */

typedef void* gn_odl_request_pkg_t;
typedef void* gn_odl_response_pkg_t;

/* 
 * Lookup types
 */
typedef gn_uint32_t gn_odl_request_type_t;
 
#define GN_ODL_REQUEST_TYPE_NONE                   0
#define GN_ODL_REQUEST_TYPE_CD_TOC                 1
#define GN_ODL_REQUEST_TYPE_ALBUM_ART              2


/*
 * Match types
 */
typedef gn_uint32_t gn_odl_match_type_t;

#define GN_ODL_MATCH_TYPE_UNKNOWN                  0
#define GN_ODL_MATCH_TYPE_NONE                     1
#define GN_ODL_MATCH_TYPE_SINGLE_EXACT             2
#define GN_ODL_MATCH_TYPE_MULTI_EXACT              3
#define GN_ODL_MATCH_TYPE_FUZZY                    4


/*
 * List Update Package Delivery Methods
 */
typedef gn_uint32_t gn_odl_lfs_pkg_source_t;

#define GN_ODL_LFS_PKG_SOURCE_UNKNOWN              0
#define GN_ODL_LFS_PKG_SOURCE_FILE                 1
#define GN_ODL_LFS_PKG_SOURCE_URL                  2

/*
 * Cover Art Delivery Methods
 */
typedef gn_uint32_t gn_odl_coverart_source_t;

#define GN_ODL_COVER_ART_SOURCE_UNKNOWN            0
#define GN_ODL_COVER_ART_SOURCE_FILE               1
#define GN_ODL_COVER_ART_SOURCE_URL                2
#define GN_ODL_COVER_ART_SOURCE_PACKAGE            3

/*
 * Response types
 */
typedef gn_uint32_t gn_odl_response_type_t;
#define GN_ODL_RESPONSE_TYPE_NONE                  0
#define GN_ODL_RESPONSE_TYPE_DONE                  1
#define GN_ODL_RESPONSE_TYPE_ALBUM                 2
#define GN_ODL_RESPONSE_TYPE_COVER_ART             3

typedef struct gn_odl_request_config_s {
	gn_bool_t                  single_match;
	gn_bool_t                  full_data_on_multi;
	gn_coverart_dimension_t    coverart_dimension_on_partial;
	gn_odl_coverart_source_t   coverart_source;
	gn_coverart_dimension_t    coverart_dimension;
	gn_uint32_t                multi_match_limit;
} gn_odl_request_config_t;

/*
 * Function Prototypes
 */

/************************************************************
 * ODL Request Creation
 ************************************************************/

/* gn_odl_create_request_pkg
 *
 * Description:
 *   Create the ODL Request Package.
 *
 * Arguments:
 *   OUT
 *     odl_request -
 *        A newly created ODL Request Package.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_create_request_pkg(
	gn_odl_request_pkg_t*      odl_request
);

/************************************************************
 * ODL Lookup Functions
 ************************************************************/

/* gn_odl_request_pkg_add_request
 *
 * Description:
 *   Add a query to the ODL Request Package.
 *
 * Arguments:
 *   IN
 *     odl_request -
 *        The ODL Request Package to add the ODL Request 
 *        to.
 *     odl_config -
 *        Configuration options for this ODL Request.
 *     request_type - 
 *        The type of lookup that is being performed.
 *        Takes the format GN_ODL_REQUEST_TYPE_...
 *     request_object -
 *        A pointer to the lookup object that contains 
 *        the necessary data for a lookup.
 *     user_data -
 *        User data to tie with this lookup (unique
 *        identifier) which will be returned with
 *        the results. Must be a null terminated string.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_request_pkg_add_request(
	gn_odl_request_pkg_t       odl_request,
	gn_odl_request_config_t*   odl_config,
	gn_odl_request_type_t      request_type,
	void*                      request_object,
	gn_uchar_t*                user_data
);

/* gn_odl_request_pkg_export
 *
 * Description:
 *   Process the ODL Request Package and write it to a 
 *   buffer so that it might be transported to a device
 *   runnnig an ODL enabled application.
 *
 * Arguments:
 *   IN
 *     odl_request -
 *        The ODL Request Package.
 *   OUT
 *     list_update_source
 *        One of the GN_ODL_LFS_PKG_SOURCE_* defines. You should not use the
 *        value GN_ODL_LFS_PKG_SOURCE_FILE if you are connecting online through
 *        gnserver. See the Implementation Guide for more details.
 *     request_buffer -
 *        A buffer containing the ODL Request.
 *     request_buffer_size -
 *        The size of the buffer.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_request_pkg_export(
	gn_odl_request_pkg_t       odl_request,
	gn_odl_lfs_pkg_source_t    list_update_source,
	gn_uchar_t**               request_buffer,
	gn_uint32_t*               request_buffer_size
);

/* gn_odl_request_pkg_smart_free
 *
 * Description:
 *   Free the ODL Request Package and associated memory.
 *
 * Arguments:
 *   IN
 *     odl_request -
 *        The ODL Request object to free.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_request_pkg_smart_free(
	gn_odl_request_pkg_t*      odl_request
);

/************************************************************
 * Process ODL Response Functions
 ************************************************************/

 /* gn_odl_response_pkg_import
 *
 * Description:
 *   Process the ODL Response buffer and queue each 
 *   ODL Result for review.
 *
 * Arguments:
 *   IN
 *     response_buffer -
 *        A buffer containing the ODL Response
 *     response_buffer_size -
 *        The size of the buffer.
 *   OUT
 *     response_pkg -
 *        The imported ODL Response Package.
 *     list_update_required -
 *        A boolean indicating that a list update is 
 *        required.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_import(
	gn_uchar_t*                response_buffer,
	gn_uint32_t                response_buffer_size,
	gn_odl_response_pkg_t*     response_pkg,
	gn_bool_t*                 list_update_required
);


 /* gn_odl_response_retrieve_list_update_url
 *
 * Description:
 *   Get the URL to download the list update file.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *
 *   OUT
 *     list_update_url -
 *        A string containing the location (URL) for fetching the
 *        list update.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_retrieve_list_update_url(
	gn_odl_response_pkg_t      response_pkg,
	gn_uchar_t**               list_update_url
);

 /* gn_odl_response_retrieve_list_update_filename
 *
 * Description:
 *   Get the URL to download the list update file.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *
 *   OUT
 *     file_name -
 *        A string containing the file name of the
 *        list update file.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_retrieve_list_update_filename(
	gn_odl_response_pkg_t      response_pkg,
	gn_uchar_t**               file_name
);

/************************************************************
 * Resolve Functions
 ************************************************************/

 /* gn_odl_response_pkg_review_next_response
 *
 * Description:
 *   Review the next result that was processed in a call
 *   to gn_odl_response_import. Each reviewed result
 *   must be resolved before reviewing the next result.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *
 *   OUT
 *     user_data -
 *        User data that was tied to the lookup when it was 
 *        serialized.
 *     response_type -
 *        The response type that this result corresponsds to.
 *     match_type -
 *        The type of match for the lookup.
 *        Takes the format GN_ODL_MATCH_TYPE_...
 *     match_count -
 *        The number of matches in the result.
 *     full_data_matches -
 *        A boolean indicating if the matches in this result
 *        have full data or partial data.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_review_next_response(
	gn_odl_response_pkg_t      response_pkg,
	gn_uchar_t**               user_data,
	gn_odl_response_type_t*    response_type,
	gn_odl_match_type_t*       match_type,
	gn_uint32_t*               match_count,
	gn_bool_t*                 full_data_matches
);
 
/* gn_odl_response_pkg_convert_album_data
 *
 * Description:
 *   Convert the match specified by the provided match_index
 *   to album data for metadata access.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *     match_index -
 *        The index of the match within the result to
 *        convert.
 *
 *   OUT
 *     album_data -
 *        The converted album data which can be used to access
 *        the metadata.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_convert_album_data(
	gn_odl_response_pkg_t      response_pkg,
	gn_uint32_t                match_index,
	gn_palbum_t*               album_data
);

/* gn_odl_response_pkg_add_match_to_request_pkg
 *
 * Description:
 *   Resolve the lookup by selecting one of the matches.
 *   Add the selected match to an ODL Request to retrieve
 *   full data. Only call if the match has partial data 
 *   and it needs to be looked up again for full data.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *     odl_request -
 *        The ODL Request object for relookups.
 *     coverart_dimension -
 *        The dimension of cover art that is desired. Use
 *        GN_COVERART_DIMENSION_NONE to indicate that you
 *        already have the cover art and it does not need
 *        to be retrieved again.
 *     coverart_source
 *        One of the GN_ODL_COVER_ART_SOURCE_* defines. You should not use the
 *        value GN_ODL_COVER_ART_SOURCE_FILE if you are fetching data online
 *        through gnserver. See the Implementation Guide for more details.
 *     match_index -
 *        The index of the match within the result to
 *        select.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_add_match_to_request_pkg(
	gn_odl_response_pkg_t      response_pkg,
	gn_odl_request_pkg_t       odl_request,
	gn_coverart_dimension_t    coverart_dimension,
	gn_odl_coverart_source_t   coverart_source,
	gn_uint32_t                match_index
);

/* gn_odl_response_pkg_write_match_to_cache
 *
 * Description:
 *   Resolve the lookup by selecting one of the matches.
 *   Writes the selected match to the ODL Cache.
 *   May only be called for CD TOC lookups and VIDEO
 *   TOC lookups.
 *   This should only be called for a match that has
 *   full data. If it has partial data, then a relookup
 *   is required and gn_odl_response_pkg_add_match_to_request_pkg
 *   should be called instead.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *     match_index -
 *        The index of the match within the result to
 *        select.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_write_match_to_cache(
	gn_odl_response_pkg_t      response_pkg,
	gn_uint32_t                match_index
);

/* gn_odl_response_pkg_retrieve_coverart_url
 *
 * Description:
 *   Retrieve the URL needed to downloading
 *   the coverart. Note that this function is
 *   only available when GN_ODL_COVER_ART_SOURCE_URL
 *   is set as the delivery method.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *     match_index -
 *        The index of the match within the result to
 *        select
 *
 *   OUT
 *     coverart_url -
 *        A string containing the cover art URL
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_retrieve_coverart_url(
	gn_odl_response_pkg_t      response_pkg,
	gn_uint32_t                match_index,
	gn_uchar_t**               coverart_url
);

/* gn_odl_response_pkg_retrieve_coverart_filename
 *
 * Description:
 *   Retrieve the filename that contains the coverart.
 *   Note that this function is only available when
 *   GN_ODL_COVER_ART_SOURCE_FILE is set as the
 *   delivery method.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *     match_index -
 *        The index of the match within the result to
 *        select
 *
 *   OUT
 *     file_name -
 *        The name of the file that accompanied the
 *        response package that contains the coverart
 *        associated with this match.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_retrieve_coverart_filename(
	gn_odl_response_pkg_t      response_pkg,
	gn_uint32_t                match_index,
	gn_uchar_t**               file_name
);

/* gn_odl_response_pkg_associate_coverart_buffer
 *
 * Description:
 *   Associate a buffer containing coverart (either
 *   retrieved from the URL, or the file) with the match.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *     match_index -
 *        The index of the match within the result to
 *        select
 *
 *   OUT
 *     coverart_buffer -
 *        Buffer containting the coverart.
 *     coverart_buffer_size -
 *        Size of the coverart buffer.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_associate_coverart_buffer(
	gn_odl_response_pkg_t      response_pkg,
	gn_uint32_t                match_index,
	gn_uchar_t*                coverart_buffer,
	gn_uint32_t                coverart_buffer_size
);

/* gn_odl_response_pkg_detach_coverart
 *
 * Description:
 *   Get the coverart object from the response package
 *   for further handling with other coverart functions
 *   such as gn_coverart_get_image.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *     match_index -
 *        The index of the match within the result to
 *        select
 *
 *   OUT
 *     coverart -
 *        The coverart object used for retrieving the
 *        image.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_detach_coverart(
	gn_odl_response_pkg_t      response_pkg,
	gn_uint32_t                match_index,
	gn_coverart_t*             coverart
);

/* gn_odl_response_pkg_get_server_error
 *
 * Description:
 *   Get an error code and error string for a server error
 *   if an occured. This should be called in the case that
 *   gn_odl_response_pkg_review_next_response,
 *   gn_odl_response_pkg_import, 
 *   gn_odl_response_retrieve_list_update_url or
 *   gn_odl_response_retrieve_list_update_filename returns 
 *   ODLERR_ServerError. Errors can occur at the response 
 *   package level or in individual responses and which
 *   function listed above that errors indicates what level
 *   the error occured (Package level on import and response
 *   level for all the rest).
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *     get_lfs_error -
 *        Boolean indicating that you are looking for an LFS
 *        Request related error.
 *
 *   OUT
 *     error_code -
 *        The error code the server returned.
 *     error_str -
 *        A string containing descriptive text on the error
 *        returned by the server.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_get_server_error(
	gn_odl_response_pkg_t      response_pkg,
	gn_bool_t                  get_lfs_error,
	gn_error_t*                error_code,
	gn_uchar_t**               error_str
);

/* gn_odl_response_pkg_smart_free
 *
 * Description:
 *   Free the ODL Response Package and associated memory.
 *
 * Arguments:
 *   IN
 *     response_pkg -
 *        The ODL Response Package.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_response_pkg_smart_free(
	gn_odl_response_pkg_t*     response_pkg
);

/************************************************************
 * General use functions
 ************************************************************/

/* gn_odl_buffer_smart_free
 *
 * Description:
 *   Frees a buffer that has been allocated by an ODL API.
 *
 * Arguments:
 *   IN
 *     buffer -
 *        The buffer to be freed.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_buffer_smart_free(
	gn_uchar_t**               buffer
);

/************************************************************
 * ODL Cache Functions
 ************************************************************/

/* gn_odl_write_coverart_to_cache
 *
 * Description:
 *   Write this coverart to the cache so that it may
 *   later be looked up.
 *
 * Arguments:
 *   IN
 *     coverart -
 *        The coverart object.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_write_coverart_to_cache(
	gn_coverart_t              coverart
);
 
/* gn_odl_cache_lookup_cd_toc
 *
 * Description:
 *   Perform a lookup in the ODL Cache. You will either have a
 *   GN_ODL_MATCH_TYPE_SINGLE_EXACT or GN_ODL_MATCH_TYPE_NONE.
 *   Does not need to be resolved, gn_odl_response_pkg_convert_album_data
 *   can be used to access the metadata.
 *
 * Arguments:
 *   IN
 *     toc_str -
 *        The toc to lookup.
 *
 *   OUT
 *     match_type -
 *        The type of match for the lookup.
 *        Takes the format GN_ODL_MATCH_TYPE_...
 *        Can only be GN_ODL_MATCH_TYPE_SINGLE_EXACT
 *        or GN_ODL_MATCH_TYPE_NONE.
 *     album_data -
 *        The converted album data which can be used to access
 *        the metadata.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_cache_lookup_cd_toc(
	gn_uchar_t*                toc_str,
	gn_odl_match_type_t*       match_type,
	gn_palbum_t*               album_data
);

/* gn_odl_cache_delete_cd_entry
 *
 * Description:
 *   Deletes the entry in the cache corresponding to the
 *   specified toc string.
 *
 * Arguments:
 *   IN
 *     toc_str -
 *        The toc to delete from the cache.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_cache_delete_cd_toc_entry(
	gn_uchar_t*                toc_str
);

/* gn_odl_cache_delete_coverart_entry
 *
 * Description:
 *   Deletes the entry in the cache corresponding to the
 *   specified gn_coverart_t instance.
 *
 * Arguments:
 *   IN
 *     coverart -
 *        The gn_coverart_t instance to delete from the cache.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_cache_delete_coverart_entry(
	gn_coverart_t              coverart
);

/* gn_odl_cache_delete
 *
 * Description:
 *   Deletes the ODL Cache.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_cache_delete(void);

/* gn_odl_cache_revert
 *
 * Description:
 *   Revert the ODL Cache to the last backup.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_cache_revert(void);

/* gn_odl_cache_backup
 *
 * Description:
 *   Backs up the ODL Cache.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_cache_backup(void);

/* gn_odl_cache_compact
 *
 * Description:
 *   Compact the ODL Cache. Deletion of entries
 *   in the cache can cause the cache to become
 *   fragmented. Use this function to compact
 *   the cache and get rid of wasted space.
 *
 * Returns:
 *   GN_SUCCESS on success or an error code.
 */
gn_error_t
gn_odl_cache_compact(void);


/* gn_odl_cache_get_size
 * Summary:
 *		Returns the size on disk of the cache. The returned size is in bytes. 
 *		
 *
 * Paramaters
 *  OUT: size of file on disk.
 *
 *
 * Return values:
 *  GN_SUCCESS or an error value.
 *  
 */

gn_error_t
gn_odl_cache_get_size(
	gn_uint32_t *size
	);

#ifdef __cplusplus
}
#endif
#endif /* _GN_ODL_H_ */
