/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

#ifndef _GN_ID3_BRIDGE_TAGGER_H_
#define _GN_ID3_BRIDGE_TAGGER_H_

#include "gn_defines.h"
#include "gn_errors.h"
#include "gn_album_track_types.h"

#ifdef __cplusplus
extern "C"{
#endif 


/*	gnid3_bridge_tagger_tag_file
 * Description: Convenience function to tag a file with an ID3v2 tag using 
 *              Gracenote metadata.
 * Args: filename	- path to the file to tag.  Caller must have read/write 
 *                privileges to the file.
 *		album_data 	- a Gracenote album data structure.
 *      track_no    - the track number of the song, used to tag the file with
 *                    track specific metadata. Must be between 1 and 99.
 * 		delFrames	- set to GN_TRUE to delete any previously stored ID3 data.
 *		v3Convert   - any existing ID3 tag to ID3v2.3 (recommended)
 * Returns:	ID3ERR_NoError upon success or an error.
 */

gn_error_t 
gnid3_bridge_tagger_tag_file(
				const gn_uchar_t* filename, 
				gn_palbum_t album_data, 
				gn_uint32_t track_no, 
			  	gn_bool_t delFrames, 
				gn_bool_t v3Convert
				);

/*	gnid3_bridge_tagger_v1_tag_file
 * Description: Convenience function to tag a file with an ID3v2 tag using 
 *              Gracenote metadata.
 * Args: filename	- path to the file to tag.  Caller must have read/write 
 *                privileges to the file.
 *		album_data 	- a Gracenote album data structure.
 *      track_no    - the track number of the song, used to tag the file with
 *                    track specific metadata. Must be between 1 and 99.
 * 		delFrames	- set to GN_TRUE to delete any previously stored ID3 data.
 *		useLocalCodePage  - Write all text encoded in the local code page.
 *                  Allows for ID3v1 tags to be written in whatever text
 *                  encoding is native to the host platform (ie Shift-JIS).
 *                  Developers must implement the gn_utf8_to_local() function
 *                  (in the Abstract Layer) if set to GN_TRUE.
 * Returns:	ID3ERR_NoError upon success or an error.
 */

gn_error_t 
gnid3_bridge_tagger_v1_tag_file( 
				const gn_uchar_t* filename, 
				gn_palbum_t album_data, 
				gn_uint32_t track_no, 
				gn_bool_t delFrames, 
				gn_bool_t writeLocalCodePage
				);



/* gnid3_bridge_tagger_ufid_ownerid
 *
 * Returns the string which goes in the "owner id" field of the UFID tags used
 * to hold Gracenote CDDB file identifiers.  This buffer should not be freed
 * by the caller.
 */
const gn_uchar_t*
gnid3_bridge_tagger_ufid_ownerid(void);


#ifdef __cplusplus
}
#endif 

#endif /* end _GN_ID3_BRIDGE_TAGGER_H_ */
