/*
 * Copyright (c) 2003-2009 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_encode_tagid.h
 */

#ifndef	_GN_ENCODE_TAGID_H_
#define _GN_ENCODE_TAGID_H_

#ifdef __cplusplus
extern "C"{
#endif

/*
 * Prototypes
 */


/*  gnencode_tagid_tui_to_tagid
 * Description: Given the ID and TAG attributes from a TID element, returns a string which can
 *				be used as the value for the UFID frame used to hold the Gracenote CDDB
 *				file identifier. This function allocates memory for the tagid output.
 *
 * Args:	track	- track number
 *			id		- tui_id input
 *			tag		- tui_id_tag input
 *			tagid	- pointer to hold tagid output (allocated by this function)
 *
 * Returns:	GNENCODEERR_NoError upon success or an error.
 *			Failure conditions include:
 *				Invalid input
 *				Memory allocation error
 */
gn_error_t
gnencode_tagid_tui_to_tagid(gn_int32_t track, const gn_uchar_t* id, const gn_uchar_t* tag, gn_uchar_t** tagid);


/*  gnencode_tagid_tagid_to_tui
 * Description: Given the TagID (the value for the UFID frame used to hold the Gracenote CDDB
 *				file identifier), returns the track tui_id and tui_id_tag which can be used to look
 *				up metadata for the album/track. This function allocates memory for the tui_id and tui_id_tag output.
 *
 * Args:	tag_id		- tagid input
 *			tui_id		- tui_id ouput (allocated by this function)
 *			tui_id_tag	- tui_id_tag output (allocated by this function)
 *
 * Returns:	GNENCODEERR_NoError upon success or an error.
 *			Failure conditions include:
 *				Invalid input
 *				Memory allocation error
 */
gn_error_t
gnencode_tagid_tagid_to_tui(const gn_uchar_t* tag_id, gn_uchar_t** tui_id, gn_uchar_t** tui_id_tag);


/*  gnencode_tagid_is_tagid_valid
 * Description: Verifies that a tag id is valid
 *
 * Args:	tag_id	- tagid input
 *
 * Returns:	GN_TRUE if tag_id is valid
 */
gn_bool_t
gnencode_tagid_is_tagid_valid(const gn_uchar_t* tag_id);

#ifdef __cplusplus
}
#endif


#endif /* _GN_ENCODE_TAGID_H_ */


