/*
 * Copyright (c) 2005 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_dvd_video_data_types.h - external dvd data types.
 */

#ifndef	_GN_DVD_VIDEO_DATA_TYPES_H_
#define _GN_DVD_VIDEO_DATA_TYPES_H_


/*
 * Dependencies.
 */

#include "gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif

/* Old types */
typedef		void*	gn_pdvd_video_t;
typedef		void*	gn_pdvd_video_region_t;
typedef		void*	gn_pdvd_video_disc_t;
typedef		void*	gn_pdvd_video_side_t;
typedef		void*	gn_pdvd_video_layer_t;
typedef		void*	gn_pdvd_video_feature_t;
typedef		void*	gn_pdvd_video_chapter_t;
typedef		void*	gn_pdvd_video_genre_t;
typedef		void*	gn_pdvd_video_credit_t;
typedef		void*	gn_pdvd_video_character_t;
typedef		void*	gn_pdvd_video_tui_t;

/* New types */
typedef		void*	gn_pvideo_t;
typedef		void*	gn_pvideo_region_t;
typedef		void*	gn_pvideo_disc_t;
typedef		void*	gn_pvideo_side_t;
typedef		void*	gn_pvideo_layer_t;
typedef		void*	gn_pvideo_feature_t;
typedef		void*	gn_pvideo_chapter_t;
typedef		void*	gn_pvideo_genre_t;
typedef		void*	gn_pvideo_credit_t;
typedef		void*	gn_pvideo_character_t;
typedef		void*	gn_pvideo_tui_t;

#ifdef __cplusplus
}
#endif 

#endif /* _GN_DVD_VIDEO_DATA_TYPES_H_ */
