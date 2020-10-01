/*
 * Copyright (c) 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_transcript_accessors.h - phonetic transcription data accessor interface.
 */

#ifndef	_GN_TRANSCRIPT_ACCESSORS_H_
#define _GN_TRANSCRIPT_ACCESSORS_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_transcript_types.h"


#ifdef __cplusplus
extern "C"{
#endif

/*
 * Prototypes.
 */

/* gn_transcript_array_destroy
 *
 *   Free all resources allocated to the given gn_ptranscript_arr_t instance.
 */
gn_error_t
gn_transcript_array_destroy(
	gn_ptranscript_arr_t* transcript_array
);

/* gn_transcript_array_get_array_size
 *
 *   Get the total number of elements in the transcript_array.
 */
gn_error_t
gn_transcript_array_get_array_size(
	const gn_ptranscript_arr_t transcript_array,
	gn_uint32_t* transcript_array_size
);

/* gn_transcript_array_get_element
 *
 *   The index is zero-based.
 *   The largest valid value for index is transcript_array_size - 1,
 *   where transcript_array_size is provided by 
 *   gn_transcript_array_get_array_size.
 */
gn_error_t
gn_transcript_array_get_element(
	const gn_ptranscript_arr_t transcript_array,
	const gn_uint32_t index,
	gn_ptranscript_t* transcript
);

/* gn_transcript_is_correct_pronunciation
 *
 *    Given a gn_ptranscript_t instance, indicates whether the transcription
 *    corresponds to the "correct" pronunciation of the associated orthography.
 *
 *    There may be one correct pronunciation transcription and/or several
 *    mispronunciation transcriptions for each unique spoken language ID in a
 *    transcription array associated with a given orthography.
 */
gn_error_t
gn_transcript_is_correct_pronunciation(
	const gn_ptranscript_t transcript,
	gn_bool_t* is_correct_pronunciation
);

/* gn_transcript_is_origin_language
 *
 *    Given a gn_ptranscript_t instance, indicates whether the spoken language
 *    ID of the transcription is the origin language of the orthography.
 */
gn_error_t
gn_transcript_is_origin_language(
	const gn_ptranscript_t transcript,
	gn_bool_t* is_origin_language
);

/* gn_transcript_get_transcript_string
 *
 *    Given a gn_ptranscript_t instance, provides the phonetic transcription
 *    string.
 */
gn_error_t
gn_transcript_get_transcript_string(
	const gn_ptranscript_t transcript,
	gn_uchar_t** transcript_string
);

/* gn_transcript_get_spoken_language_id
 *
 *    Given a gn_ptranscript_t instance, provides the spoken language ID, e.g.
 *    USA_eng, for the transcription.
 */
gn_error_t
gn_transcript_get_spoken_language_id(
	const gn_ptranscript_t transcript,
	gn_spklangid_t* spoken_language_id
);


#ifdef __cplusplus
}
#endif 


#endif /* _GN_TRANSCRIPTION_DATA_ACCESSORS_H_ */
