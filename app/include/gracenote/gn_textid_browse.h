/*
 * Copyright (c) 2010 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/* gn_textid_browse.h - Interface for browsing each available contributor.  
 * Results are returned in an unsorted manner. 
 */


#ifndef _GN_TEXTID_BROWSE_
#define _GN_TEXTID_BROWSE_

/*
 * Dependencies.
 */

#include    "gn_defines.h"
#include    "gn_textid_lookup.h"

#ifdef __cplusplus
extern "C"{
#endif

typedef void* gn_textid_browse_t;

/* gn_textid_browse_create_iterator
 *   Behavior: Creates a new contributor table iterator.
 *
 *   Args: IN:  iter - pointer to iterator handle.
 *
 *   Remarks:  Must be freed by calling gn_textid_browse_destroy_iterator.
 */

gn_error_t
gn_textid_browse_create_iterator(gn_textid_browse_t *iter);


/* gn_textid_browse_iterate_next
 *   Behavior: Produces the next contributor display string and asociated contributor id
 *             or sets found to GN_FALSE.
 *
 *   Args: IN:  iter - pointer to iterator handle.
 *
 *        OUT:  found - Pointer to a boolean value indicating whether or not a contributor
 *              has been retrieved.
 *              contributor_display_string - Pointer to a contributor display string.
 *              contributor_id - Pointer to a contributor id.
 * 
 *
 *   Remarks:  Once iteration has completed over the display strings and asociated 
 *             contributor id's, it is up to you to perform any sorting of the gathered 
 *             strings.  The caller will also be responsible for maintaining the pairing 
 *             between the display string and the contributor id since the contributor id
 *             is necessary to fetch result data.
 *             
 *             Records are not returned in sorted order.
 *             
 *             After all contributors have been iterated over, *found is set to GN_FALSE. 
 *             The caller does not own the memory pointed to by 
 *             *contributor_display_string.
 */

gn_error_t
gn_textid_browse_iterate_next(
                            gn_textid_browse_t iter,
                            gn_bool_t *found,
                            gn_uchar_t **contributor_display_string,
                            gn_uint32_t *contributor_id                                     
                            );

/* gn_textid_browse_destroy_iterator
 *   Behavior: Free's any resources held by iter and sets it to GN_NULL.
 *
 *   Args: IN:  iter - Pointer to an iterator handle.
 *
 */
gn_error_t
gn_textid_browse_destroy_iterator(gn_textid_browse_t *iter);


/* gn_textid_browse_fetch_result_data
 *   Behavior: Gets the match source of the result.
 *
 *   Args: IN:  contributor_id - The contributor ID yielded by
 *                               gn_textid_browse_iterate_next
 *
 *        OUT:  result_data - The match source of the lookup.
 *              
 *
 *   Remarks: Fetch result data for a particular contributor id.  Result data can then
 *            be used for manual assignment of Playlist entries.
 *            MediaVOCS data may be fetched by using the functionality provide by  
 *            gn_textid_lookup.h.
 *            User must call gn_textid_free_result() to free result_data.
 *             
 *            Result data may be have either a lead performer or composer match source.
 *            Use gn_textid_get_result_match_source() to determine the match
 *            source.
 */

gn_error_t
gn_textid_browse_fetch_result_data(
                        gn_uint32_t contributor_id,
                        gn_textid_presult_data_t* result_data
                        );

                        
#ifdef __cplusplus
}
#endif

#endif /* _GN_TEXTID_BROWSE_ */

