/*
 * Copyright (c) 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_apm_types.h - Alternate Phrase Types
 */

#ifndef	_GN_APM_TYPES_H_
#define _GN_APM_TYPES_H_

#include "gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif

/*
 * Typedefs 
 */

/* Types of alternate phrases */
typedef gn_uchar_t gn_apm_type_t;

/*
 * Constants
 */

/* The types of alternate phrases that mapped */
/* by the alternate phrase mapper. */
#define GN_APM_TYPE_ARTIST			1
#define GN_APM_TYPE_ALBUM_TITLE		2
#define GN_APM_TYPE_TRACK_TITLE		3
#define GN_APM_TYPE_COMPOSER		4
#define GN_APM_TYPE_WORK_TITLE		5

#ifdef __cplusplus
}
#endif 

#endif /* #ifndef	_GN_APM_TYPES_H_ */
