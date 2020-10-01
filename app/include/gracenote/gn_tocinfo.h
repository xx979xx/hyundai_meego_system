/*
 * Copyright (c) 2000 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_tocinfo.h - structures and contstants for dealing with TOCs.
 */

#ifndef _GN_TOCINFO_H_
#define _GN_TOCINFO_H_

/*
 * Dependencies.
 */

#include	"gn_defines.h"

/*
 * Constants.
 */

/* Some characteristics of audio CDs. */
#define MAXTRKS			99				/* Max # of tracks in a disc. */
#define MINTRKS			1				/* Min # of tracks in a disc. */
#define MAXOFFSETS		(MAXTRKS + 1)	/* Max # of offsets. */
#define MINOFFSETS		(MINTRKS + 1)	/* Min # of offsets. */
#define FRAMESPERSEC	75				/* # of frames in a second. */

/* buffer large enough to hold string representation of TOC */
#define TOCBUFSIZE	2048


#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Structures and typedefs.
 */

/* structure encapsulating TOC information */
typedef struct toc_info {
	gn_uint32_t			num_offsets;	/* number of valid offsets following */
	gn_uint32_t			*offsets;		/* track frame offsets and lead-out */
} gn_toc_info_t;

/* Abbreviated structure encapsulating TOC information */
typedef struct toc_hdr {
	gn_uint32_t			num_offsets;	/* number of valid offsets following */
	gn_uint32_t			offsets[1];		/* track frame offsets and lead-out (actual size 'num_offsets') */
} gn_toc_hdr_t;

/* Full structure encapsulating TOC information */
typedef struct toc_full {
	gn_uint32_t			num_offsets;			/* number of valid offsets following */
	gn_uint32_t			offsets[MAXOFFSETS];	/* track frame offsets and lead-out (actual size 'num_offsets') */
} gn_toc_full_t;


typedef gn_uint32_t		gn_toc_id_t;


/*
 * Macros.
 */
/* Calculate actual size of TOC in gn_toc_hdr_t from the number of offsets */
#define		TOC_SIZE_FROM_HDR(n)		(((n) + 1) * sizeof(gn_uint32_t))


#ifdef __cplusplus
}
#endif 

#endif /* _GN_TOCINFO_H_ */
