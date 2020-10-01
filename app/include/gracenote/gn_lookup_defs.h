/*
 * Copyright (c) 2000, 2002 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_lookup_defs.h - Application interface definition for the "toc lookup" module.
 */


#ifndef _GN_LOOKUP_DEFS_H_
#define _GN_LOOKUP_DEFS_H_

/*
 * Dependencies.
 */

#include	"gn_defines.h"


#ifdef __cplusplus
extern "C"{
#endif 


/*
 * Constants.
 */

#define	TLOPT_Default				0x00000000

/* Options for doing TOC lookups */
#define	TLOPT_AutoFuzzy				0x00000001	/* (local CD) Pick best choice for fuzzy matches. */
#define	TLOPT_ExactOnly				0x00000002	/* (local CD) Don't perform fuzzy lookup if not exact. */
#define TLOPT_SingleConnect			0x00000004	/* (online CD, File, Stream) Get full data from Grancenote service for single best result on 1st connection. */

#define	TLOPT_Result_Album			0x00000008	/* Return album-level data. This is the default. */
#define	TLOPT_Result_Album_Short	0x00000010	/* Return (short) album-level data. */
#define	TLOPT_Result_Track			0x00000020	/* Return track-level data. UNSUPPORTED (March 03, 2006) */

#define	TLOPT_TOC_LOOKUP			0x00000040	/* (local CD) Perform a local CD TOC lookup. */
#define	TLOPT_TUI_LOOKUP			0x00000080	/* (Private flag) */
#define	TLOPT_FP_LOOKUP				0x00000100	/* (Private flag) */
#define	TLOPT_MEDIAID_LOOKUP		0x00000200	/* (Private flag) */
#define	TLOPT_TRACK_TUI_LOOKUP		0x00000400	/* (Private flag) */
#define	TLOPT_TRACK_TEXT_SEARCH		0x00000800	/* (Private flag) */
#define	TLOPT_VIDEO_TUI_LOOKUP		0x00001000	/* (Private flag) */
#define	TLOPT_VIDEO_TOC_LOOKUP		0x00002000	/* (Private flag) */
#define TLOPT_LOOKUP_TYPE_MASK		0x00003FC0	/* Mask for the lookup type bits. */

/* Options for DVD TITLE TEXT Search */
#define	TSOPT_DVD_TITLE_SEARCH		0x00000800	/* Perform a DVD Title Text Search */
#define TSOPT_ADULT_CONTENT_FILTER	0x00001000	/* Filter adult content out of results */

/* Match types for TOC lookups */
#define	TLMATCH_None			0			/* No match */
#define	TLMATCH_Exact			1			/* Single exact match */
#define	TLMATCH_Fuzzy			2			/* One or more fuzzy matches */
#define TLMATCH_LUCache			3			/* The match was from the lookup_cache. */
#define TLMATCH_Title			4			/* One or more title matches (video) */
#define TLMATCH_Aggressive		5			/* Aggressive Match (video) */

/* "Match" types to assist in GCSP result code mappings. */
#define	TLMATCH_MultiExact		6			/* Multiple exact matches */
#define	TLMATCH_NoNewRev		7			/* No new revision of the item (usually a list) */
#define	TLMATCH_Unknown			8			/* An unknown match type; this may not be good */


/*
 * Typedefs
 */

typedef gn_uint32_t		gn_lu_options_t;
typedef gn_uint32_t		gn_lu_match_t;


#ifdef __cplusplus
}
#endif 

#endif /* _GN_LOOKUP_DEFS_H_ */
