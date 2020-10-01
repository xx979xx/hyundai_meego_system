/*
 * Copyright (c) 2012 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_cancel.h
 *
 * These APIs should be used by emms with playlist enabled libraries.
 */


#ifndef _GN_CANCEL_H_
#define _GN_CANCEL_H_

/*
 * Dependencies.
 */

#ifdef __cplusplus
extern "C"{
#endif
    
/* 
 * Identifies types of cancel available and affected routines.
 * This may not be an exhaustive list.
 *
 *  GN_CANCEL_CD_LOCAL
 *      gnllu_lookup()
 *      gnllu_cache_and_local_toc_lookup()
 *  GN_CANCEL_ONLINE
 *      gnolu_lookup_selected_album_match()
 *      gnolu_lookup_album_toc()   (deprecated)
 *      gnolu_lookup_album_by_toc()
 *      gnolu_lookup_video_toc()
 *      gnolu_lookup_selected_video_match()   
 *      gnolu_video_external_code_lookup() 
 *      gnolu_video_title_search()  
 *      gn_musicid_lookup_albumid()
 *      gn_musicid_lookup_trackid()
 *      gn_musicid_lookup_libraryid()
 *      gnolu_update_list_data()
 *      gn_coverart_retrieve_online_album_art()
 *      gn_coverart_retrieve_online_album_image()
 *  GN_CANCEL_TEXTID
 *      gn_textid_local_lookup()
 *      gn_textid_result_to_entrydata()
 *      gn_textid_get_result()
 *  GN_CANCEL_VIDEO 
 *      gndvd_get_title_unit_array_internal_handle()
 */
#define GN_CANCEL_CD_LOCAL	0
#define GN_CANCEL_ONLINE	1
#define GN_CANCEL_TEXTID	2
#define GN_CANCEL_VIDEO     3
#define	GN_CANCEL_NUM_OPS	4
    
/*
 * Prototypes.
 */

/*	gn_cancel_callback_t
 *
 *	A function with this prototype is implemented by the developer to return GN_TRUE if
 *	the activity is to be canceled, otherwise GN_FALSE.
 *
 *	NOTE: The user callback function, if it is set should be as lightweight and efficient as possible.
 *
 *	Parameters:
 *		user_data		Address of optional user defined data that was set in the initial
 *						call to gn_set_cancel_callback().
 */
typedef gn_bool_t (gncancel_callback_t)(void * user_data);

/*	gn_set_cancel_callback
 *
 *	Set a callback function to test if the user wishes to cancel the playlist.
 *
 *	Return Value:
 *		GN_SUCCESS		This function returns GN_SUCCESS if cancel_type is valid
 *      GN_FAILURE      otherwise
 *
 *	Parameters:
 *      cancel_type     Specifies the type of cancel function 
 *
 *		callback_func	Address of a user defined callback function or GN_NULL to remove
 *						the callback.
 *
 *		user_data		Address of optional user defined data that will be passed to the user's
 *						callback function. Pass GN_NULL if no data is to be provided.
 */
gn_error_t
gn_set_cancel_callback(
    gn_uint32_t			cancel_type,
	gncancel_callback_t	*callback_func,
	void				*user_data
	);


#ifdef __cplusplus
}
#endif

#endif /* _GN_PLAYLIST_H_ */
