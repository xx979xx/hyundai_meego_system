/*
 * Copyright (c) 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_transcript_types.h - transcription data structures and types.
 */

#ifndef	_GN_TRANSCRIPT_TYPES_H_
#define _GN_TRANSCRIPT_TYPES_H_


/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_lang_types.h"

#ifdef __cplusplus
extern "C"{
#endif 


/*
 * Structures and typedefs.
 */

typedef gn_langid_t gn_spklangid_t;

/* Opaque pointer to phonetic transcription data suitable for ASR/TTS
	systems. */
typedef void* gn_ptranscript_t;

/* Opaque pointer to a container holding one or more gn_ptranscript_t
	instances. */
typedef void* gn_ptranscript_arr_t;

#ifdef __cplusplus
}
#endif 


#endif /* _GN_TRANSCRIPTION_DATA_TYPES_H_ */


