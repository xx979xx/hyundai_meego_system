/*
 * Copyright (c) 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

#ifndef _GNID3_UTIL_H_
#define _GNID3_UTIL_H_

#include "gn_defines.h"
#include "gnex_errors.h"

#ifdef __cplusplus
extern "C"{
#endif 


/*  gnid3_util_has_tags
 * Description: Checks for the existence of ID3 v2 or v1 tags.
 * Args:	path_to_file - the path to the file to delete the tag from.
 *			hasV2Tag - set to GN_TRUE if the file has an ID3v2.2, ID3v2.3, or 
 *					ID3v2.4 tag.
 *			hasV1Tag - set to GN_TRUE if the file has an ID3v1.0 or ID3v1.1 tag
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t
gnid3_util_has_tags(const gn_uchar_t* pathToFile, gn_bool_t *hasV2Tag, gn_bool_t *hasV1Tag);


/*Routines for deleting ID3 tags */

/*  gnid3_delete_v1tag_filename
 * Description: Deletes an ID3v1 or ID3v1.1 tag from an mp3 file
 * Args:	filename - the path to the file to delete the tag from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_util_delete_v1tag(const gn_uchar_t* filename);

/*  gnid3_delete_tag_filename
 * Description: Deletes an ID3v2 tag from an mp3 file
 * Args:	filename - the path to the file to delete the tag from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_util_delete_v2tag(const gn_uchar_t* filename);


#ifdef __cplusplus
}
#endif 

#endif /* end _GNID3_UTIL_H_ */

