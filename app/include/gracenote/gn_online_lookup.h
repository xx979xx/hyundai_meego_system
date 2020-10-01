/*
 * Copyright (c) 2000, 2008 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_online_lookup.h
 *   Declarations to support online lookups.
 */


#ifndef _GN_ONLINE_LOOKUP_H_
#define _GN_ONLINE_LOOKUP_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_lookup_defs.h"

#ifdef __cplusplus
extern "C"{
#endif


/*
 * Structures and typedefs.
 */

#ifndef GN_OLC_HANDLE
	#define GN_OLC_HANDLE
	typedef void* gn_olc_handle_t;
#endif /* GN_OLC_HANDLE */

/* gn_olc_error_info_t
 *
 * Online result error information. Appropriate for display to the user.
 *   error_code    - The error code associated with the online error.
 *   error_message - Message string describing the error code.
 *   retry_flag    - Indicates whether a request retry may result in success
 *                   "Y" indicates a retry may result in success.
 *                   "N" indicates a retry likely won't result in success.
 */
typedef struct gn_olc_error_info
{
	gn_uchar_t*	error_code;
	gn_uchar_t*	error_message;
	gn_uchar_t*	retry_flag;
} gn_olc_error_info_t;

/*
 * Prototypes.
 */

/**
 ** Online list update related functions.
 **/

/* gnolu_update_list_data
 *
 * Retrieve new list files and files which depend on list data from Gracenote
 * service and install them.
 *
 * The complete set of files retrieved depends on your product configuration
 * and is listed your Implementation Guide.
 * Args:
 *   validate - The update package file will be validated after download before
 *      installation is attempted. The validation is optional as it is very 
 *      resource intensive.
 *   package_file_name (required) - Filename, including any necessary path
 *      information, to which the update package will be downloaded. If this
 *      function completes without error, you may wish to delete the file
 *      package_file_name. It is not needed after the update.
 */
gn_error_t
gnolu_update_list_data(
	gn_bool_t         validate,
	const gn_uchar_t* package_file_name
);

/* gnolu_list_update_required
 *
 * Performs an online query to service to determine whether the list files and
 * files which depend on list data currently installed on the device need to be
 * updated.
 *
 * The same information is returned with every online lookup via a boolean
 * output argument of the lookup function. However, because updating the list
 * data may, for example, adversely affect the responsiveness of GUI in which
 * lookup results are presented, this function is provided as a way to initiate
 * the list update process outside the context of an online lookup.
 *
 * Args:
 *   list_update_required - Upon successful return, this will indicate whether
 *      or not the currently installed list and list dependent databases
 *      require updating. If this is GN_TRUE upon return, then it is strongly
 *      recommended that you call gnolu_update_list_data() to obtain the most
 *      recent list data in order to ensure the highest quality results in
 *      subsequent online metadata retrievel.
 */
gn_error_t
gnolu_list_update_required(
	gn_bool_t* list_update_required
);

/* gnolu_get_error_info
 *
 * Populate error_info with online lookup error results.
 * The error_info structure will be populated only if an online error has
 * occurred. A TLERR_NotFound value is returned if no online error information
 * has been set.
 *
 * Memory is allocated by this call. The gnolu_free_error_info function should
 * be called once the error information is no longer needed.
 *
 * Args:
 *   olc_handle - Reserved, should be set to GN_NULL.
 *   error_info - A gn_olc_error_info_t structure provided by the caller which
 *     is populated by this function. If there is already data present in the
 *     structure, from a previous call to gnolu_get_error_info(), you must free
 *     that data with gnolu_free_error_info() before calling this function.
 */
gn_error_t
gnolu_get_error_info(
	gn_olc_handle_t      olc_handle,
	gn_olc_error_info_t* error_info
);

/* gnolu_free_error_info
 *
 * Description: Frees the contents of the given gn_olc_error_info_t structure.
 * This does not free the structure itself. The structure is owned by the
 * application.
 *
 * Args:
 *   error_info - A gn_olc_error_info_t stucture which has been populated via a
 *     call to gnolu_get_error_info().
 */
gn_error_t
gnolu_free_error_info(
	gn_olc_error_info_t* error_info
);

/* gnolu_select_album_match
 *
 * Select a matching album, using the 0-based match_index.
 * Provide copies of tui_id, tui_id_tag, and/or track_ord,
 * if any or all of these parameters are non-null.
 * Values assigned to tui_id, tui_id_tag, and track_ord
 * represent allocated memory; it is the caller's responsibility
 * to free the associated memory via gnolu_free_match_params().
 */
gn_error_t
gnolu_select_album_match(
	gn_olc_handle_t handle,
	gn_size_t match_index,
	gn_uchar_t** tui_id,
	gn_uchar_t** tui_id_tag,
	gn_uchar_t** track_ord
	);

/* gnolu_free_match_params
 *
 * Free the parameters allocated by gnolu_select_album_match().
 * Upon successful return, all parameters are set to GN_NULL.
 */
gn_error_t
gnolu_free_match_params(
	gn_uchar_t** tui_id,
	gn_uchar_t** tui_id_tag,
	gn_uchar_t** track_ord
	);

/* gnolu_lookup_album_tui
 *
 *	Perform an online lookup on an album tui.
 *	The tui may be retrieved via gnolu_select_album_match().
 */
gn_error_t
gnolu_lookup_album_tui(
	gn_olc_handle_t		 handle,
	const gn_uchar_t	*tui_id_str,
	const gn_uchar_t	*tui_id_tag_str,
	gn_bool_t			 short_album_data,
	gn_bool_t			*list_update_required,
	gn_lu_match_t		*match_type
	);

/* gnolu_get_match_count
 *
 * Get the number of matches from the last online lookup if that lookup was
 * successful, i.e. if it returned GN_SUCCESS.
 *
 * Args:
 *   olc_handle  - Reserved, should be set to GN_NULL.
 *   match_count - The number of records which were matched by the most recent
 *     online lookup.
 */
gn_error_t
gnolu_get_match_count(
	gn_olc_handle_t olc_handle,
	gn_uint32_t*    match_count
);

/**
 ** Proxy server configuration functions.
 **/

/* gnolu_set_proxy_info
 *
 * Dynamically sets the proxy URL, username, and password for online lookups.
 *
 * Args
 *   olc_handle - Reserved, should be set to GN_NULL.
 *   proxy_url - NULL-terminated string containing proxy server and port, in
 *     the form "server:port".
 *     If this argument is GN_NULL or an empty string, the current proxy
 *     settings will be cleared.
 *   proxy_username - username required to log in to the proxy server
 *     optional, ignored if proxy_url is GN_NULL or an empty string
 *   proxy_password - password required to log in to the proxy server
 *     optional, ignored if proxy_username is GN_NULL or an empty string
 *
 * Returns:	TLERR_NoError upon success or an error.
 *			Failure conditions include:
 *				invalid input
 *				memory allocation error
 */
gn_error_t
gnolu_set_proxy_info(
	gn_olc_handle_t   olc_handle,
	const gn_uchar_t* proxy_url,
	const gn_uchar_t* proxy_username,
	const gn_uchar_t* proxy_password
	);

/* gnolu_get_proxy_info
 *
 * Gets the current proxy URL, username, and password for online lookups.
 *
 * If no proxy info is set, all three fields will be set to GN_NULL.
 *
 * No memory is allocatated by this function, the proxy info reult pointers 
 * are owned by the library, and should only be considered valid until the 
 * next call to a gnolu_* API.
 *
 * Args:
 *   olc_handle - Reserved, should be set to GN_NULL.
 *   proxy_url - pointer to a buffer to recieve the proxy server and port,
 *     in the form "server:port"
 *     If not set in the library, this parameter will be set to GN_NULL.
 *   proxy_username - pointer to a buffer to recieve the proxy username,
 *     If not set in the library, this parameter will be set to GN_NULL.
 *   proxy_password - pointer to a buffer to recieve the proxy password
 *     If not set in the library, this parameter will be set to GN_NULL.
 *
 * Returns:	TLERR_NoError upon success or an error.
 *			Failure conditions include:
 *				invalid input
 */
gn_error_t
gnolu_get_proxy_info(
	gn_olc_handle_t olc_handle,
	const gn_uchar_t**    proxy_url,
	const gn_uchar_t**    proxy_username,
	const gn_uchar_t**    proxy_password
	);

#ifdef __cplusplus
}
#endif

#endif /* _GN_ONLINE_LOOKUP_H_ */
