/*
 * Copyright (c) 2005 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * platform_map.h - holds temporary mappings between old GN_... defines and new
 *	"affirmative" GN_... defines.
 */

#ifndef	_PLATFORM_MAP_H_
#define	_PLATFORM_MAP_H_
/* Start by turning everything off */

#ifdef GN_LISTS
#undef GN_LISTS
#endif

#ifdef GN_ID3
#undef GN_ID3
#endif

#ifdef GN_DVD_VIDEO
#undef GN_DVD_VIDEO
#endif

#ifdef GN_BD_VIDEO
#undef GN_BD_VIDEO
#endif

#ifdef GN_MUSICID_DATA
#undef GN_MUSICID_DATA
#endif

#ifdef GN_MUSICID_TEXTHINT
#undef GN_MUSICID_TEXTHINT
#endif

#ifdef GN_UPDATES
#undef GN_UPDATES
#endif

#ifdef GN_CD
#undef GN_CD
#endif

#ifdef GN_COVER_ART
#undef GN_COVER_ART
#endif

#ifdef GN_SRC_ONLINE
#undef GN_SRC_ONLINE
#endif

#ifdef GN_SRC_LOCAL
#undef GN_SRC_LOCAL
#endif

/* All configurations use the following "tweaks" */
#define GN_UNICODE

#if defined(GN_CD_LOCAL) || defined(GN_CD_ONLINE)
#ifndef GN_CD
#define GN_CD
#endif
#endif

#if defined(GN_COVER_ART_LOCAL) || defined(GN_COVER_ART_ONLINE)
#ifndef GN_COVER_ART
#define GN_COVER_ART
#endif
#endif

#if defined(GN_CD_ONLINE)					\
 || defined(GN_TEXTID_ONLINE)				\
 || defined(GN_COVER_ART_ONLINE)			\
 || defined(GN_DVD_VIDEO_ONLINE)			\
 || defined(GN_BD_VIDEO_ONLINE)				\
 || defined(GN_MUSICID_CANTAMETRIX_ONLINE)	\
 || defined(GN_MUSICID_FAPI_FIXED)			\
 || defined(GN_MMID)
#ifndef GN_SRC_ONLINE
#define GN_SRC_ONLINE
#endif
#endif

#if defined(GN_CD_LOCAL)
#ifndef GN_SRC_LOCAL
#define GN_SRC_LOCAL
#endif
#endif

/* Every configuration seems to need lists */
#if defined(GN_PLAYLIST)					\
 || defined(GN_CD_LOCAL)					\
 || defined(GN_CD_ONLINE)					\
 || defined(GN_SRC_ONLINE)					\
 || defined(GN_MUSICID_CANTAMETRIX_FIXED)	\
 || defined(GN_MUSICID_CANTAMETRIX_FLOAT)	\
 || defined(GN_MUSICID_FAPI_FIXED)			\
 || defined(GN_DVD_VIDEO_ONLINE)			\
 || defined(GN_BD_VIDEO_ONLINE)
#define GN_LISTS
#endif

#if defined(GN_DVD_VIDEO_ONLINE)
#define GN_DVD_VIDEO
#endif

#if defined(GN_BD_VIDEO_ONLINE)
#define GN_BD_VIDEO
#endif


/* Temporary hooks for new defines */

#ifdef GN_PLAYLIST

/* we already defined the necessary old stuff */

#endif /* GN_PLAYLIST */

#ifdef GN_TEXTID

#define GN_ID3

#endif /* GN_TEXTID */

#if defined(GN_MUSICID_CANTAMETRIX_FIXED) || defined(GN_MUSICID_CANTAMETRIX_FLOAT) || defined(GN_MUSICID_FAPI_FIXED) || defined(GN_MMID)

/* This is temporary.  Replace this constant with GNIF_MUSICID_CANTAMETRIX_FIXED. */
#define CANTADB_FIXED_POINT 0

/* Map the high level music ID configuration to the code switches. */
#if defined(GN_MUSICID_CANTAMETRIX_FIXED)
#ifndef GN_MUSICID_CANTAMETRIX
#define GN_MUSICID_CANTAMETRIX
#endif

/* This is temporary.  This constant should be replaced by GNIF_MUSICID_CANTAMETRIX_FIXED. */
#undef CANTADB_FIXED_POINT
#define CANTADB_FIXED_POINT 1
#endif

#if defined(GN_MUSICID_CANTAMETRIX_FLOAT)
#ifndef GN_MUSICID_CANTAMETRIX
#define GN_MUSICID_CANTAMETRIX
#endif
#endif

#if defined(GN_MUSICID_FAPI_FIXED)
#ifndef GN_MUSICID_FAPI
#define GN_MUSICID_FAPI
#endif
#endif

#ifndef GN_MMID
#define GN_MUSICID_TEXTHINT
#endif

/* Turn on high level music ID interface. */
#define GN_MUSICID_DATA

#ifndef GN_MUSIC_ID_LOCAL
/* no MusicID-File local, yet */
/*#define GN_MUSIC_ID_LOCAL*/
#endif

#define GN_ID3

#endif /* defined(GN_MUSICID_CANTAMETRIX_FIXED) || defined(GN_MUSICID_CANTAMETRIX_FLOAT) || defined(GN_MUSICID_FAPI_FIXED) || defined(GN_MMID) */

#ifdef GN_SRC_ONLINE

#define GN_LISTFILESET_UPDATES

#endif /* GN_SRC_ONLINE */

#endif	/* _PLATFORM_MAP_H_ */
