/*
 * Copyright (c) 2010 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/* gn_textid_id_fetch.h - Interface for getting ID values from TextID results 
 *                        so that results can then be fetched at a later date.  
 *                        Useful if result data, such as MediaVOCS, is needed
 *                        after a lookup event has taken place and the 
 *                        developer wishes to avoid the overhead
 *                        of storing the result information.
 */


#ifndef _GN_TEXTID_ID_FETCH_
#define _GN_TEXTID_ID_FETCH_

/*
 * Dependencies.
 */

#include    "gn_defines.h"
#include    "gn_textid_lookup.h"

#ifdef __cplusplus
extern "C"{
#endif
    
/* gn_textid_id_fetch_identifier
 *   Behavior: Yields a ID value from a TextID result.
 *
 *   Args: IN: result_data - The result object, typically yielded by 
 *                           gn_textid_get_result()
 *
 *         OUT: result_id - The ID string corresponding to the result object.
 *
 *   Remarks: The results object must be associated with a match source of 
 *            GN_TEXTID_MATCH_SOURCE_CONTRIB, GN_TEXTID_MATCH_SOURCE_COMPOSER, 
 *            GN_TEXTID_MATCH_SOURCE_ALBUM, or GN_TEXTID_MATCH_SOURCE_GENRE.
 *            The match source value is yielded by the 
 *            gn_textid_local_lookup()
 *
 *            function and is typically stored along with the ID value yielded 
 *            by this function.
 *
 *            This function allocated memory.  result_id must be freed by 
 *            calling gn_textid_id_fetch_free_id().
 *
 *            The result_id object is a null terminated string consisting only 
 *            of of ASCII characters.  It is designed to be readily 
 *            serializable by your system.
 *
 *   Return values: The value handed back in result only has meaning if 
 *                  GN_SUCCESS is returned.
 *                  Errors which can originate in this function are:
 *                   - GNTEXTIDERR_NotInited indicates the textid subsystem is
 *                     not initialized for lookups.
 *                   - GNTEXTIDERR_InvalidArg indicates one of the parameters 
 *                     was invalid.
 *                   - GNTEXTIDERR_BadMatchSource - The result is associated 
 *                     with an unsupported match source. (See Remarks).
 */
    
gn_error_t
gn_textid_id_fetch_identifier(
                              gn_textid_presult_data_t result_data,
                              gn_uchar_t ** result_id
                              );

/* gn_textid_id_fetch_identifier
 *   Behavior: Yields a ID value from a TextID result.
 *
 *   Args: IN: result_id - The ID string, created by 
 *                         gn_textid_id_fetch_identifier().
 *
 *
 *   Remarks: *result_id is set to GN_NULL on success.
 *
 *   Return values: The value handed back in result only has meaning if 
 *                  GN_SUCCESS is returned.
 *                  Errors which can originate in this function are:
 *                   - GNTEXTIDERR_InvalidArg indicates one of the parameters 
 *                     was invalid.
 */

gn_error_t
gn_textid_id_fetch_free_id(
                            gn_uchar_t ** result_id
                            );

/* gn_textid_id_fetch_result_data
 *   Behavior: Returns a TextID results structure that contains the full 
 *             result information.  
 *             The results structure can then be used with the accessor 
 *             functions in gn_textid_lookup.h.
 *
 *             Memory allocated to result is owned by the caller. You must 
 *             free it with a call to gn_textid_free_result().
 *
 *   Args: IN: result_id - The ID value, originally yielded by 
 *                         gn_textid_id_fetch_identifier.
 *         OUT:match_source - The match source associated with the result.
 *             secondary_match_source - The secondary match source associated 
 *                                      with the result.
 *             result - The results data which is handed back.
 *              
 *
 *   Remarks: Use the id yielded by gn_textid_id_fetch_identifier() 
 *            for the result_id paramerter for this function.
 *            A typical use case will involve storing these values for later
 *            fetching by this function.  If the your system supports updating the 
 *            TextID databases, it is important to note that applying
 *            an update of these databases can invalidate the ID's stored by 
 *            your system.  In this case, (the ID is invalid)
 *            the function will return the GNTEXTIDERR_IDFetchNotFound error 
 *            code.
 *
 *   Return values: The value handed back in result only has meaning if 
 *                  GN_SUCCESS is returned.
 *                  Errors which can originate in this function are:
 *                   - GNTEXTIDERR_NotInited indicates the textid subsystem is
 *                     not initialized for lookups.
 *                   - GNTEXTIDERR_InvalidArg indicates one of the parameters 
 *                     was invalid.
 *                   - GNTEXTIDERR_BadMatchSource - A valid id_match_source 
 *                     was not specified.
 *                   - GNTEXTIDERR_NoMemory indicates *result could not be
 *                     allocated.
 *                   - GNTEXTIDERR_IDFetchNotFound indicates that the ID
 *                     fetch could not find a value for the specified match 
 *                     source and ID combination. (See Remarks). 
 */

gn_error_t
gn_textid_id_fetch_result_data(
                       const gn_uchar_t             * result_id,
                       gn_textid_match_source_t     * match_source,
                       gn_textid_match_source_t     * secondary_match_source,
                       gn_textid_presult_data_t     * result_data
                       );

#ifdef __cplusplus
}
#endif

#endif /* _GN_TEXTID_ID_FETCH_ */

