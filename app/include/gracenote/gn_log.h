/*
* Copyright (c) 2001 Gracenote.
*
* This software may not be used in any way or distributed without
* permission. All rights reserved.
*
* Some code herein may be covered by US and international patents.
*/

/*
* gn_log.h - General logging / tracing functionality.
*/


#ifndef	_GN_LOG_H_
#define _GN_LOG_H_

/*
* Dependencies
*/

#include "gn_abs_types.h"


#ifdef __cplusplus
extern "C"{
#endif


/*
 * Constants
 */

/* identifier masks */

#define		GNLOG_MASK_CATEGORY			0x00FFFFFF
#define		GNLOG_MASK_OVERRIDE			0xFF000000

/* logging override bits */

#define		GNLOG_FORCE				0x01000000	/* force logging */
#define		GNLOG_VERBOSE			0x02000000	/* print lots of text */
#define		GNLOG_NO_TIME_STAMP		0x04000000	/* don't print the current time */

/* for specific package identifiers, consult gn_error_codes.h */

#define		GNLOG_PKG_ALL	0xFF		/* indicates all package ids */

/* Logging identifiers; used to identify logging calls throughout the code */
/* Add new IDs here, as opposed to other header files, to avoid ID collisions down the road. */

#define		GNLOG_IDS_ALL	0xFFFFFF	/* indicates all log identifiers */

#define		GNLOG_ERROR		0x000001	/* logging an error */

#define		GNLOG_FTRACE	0x000002	/* function trace - log at beginning of function call */

#define		GNLOG_CTRACE	0x000004	/* conditional trace - log at beginning of top-level conditionals */
#define		GNLOG_CTRACE2	0x000008	/* conditional trace 2 - log at beginning of second-level conditionals */

#define		GNLOG_DTRACE	0x000100	/* debug trace - log variable values of a given category at any point in code */
#define		GNLOG_DTRACE2	0x000200	/* debug trace 2 - log variable values of a given category
										different from first debug trace at any point in code */
#define		GNLOG_DTRACE3	0x000400	/* debug trace 3 - log variable values of a given category
										different from second debug trace at any point in code */
#define		GNLOG_DTRACE4	0x000800	/* debug trace 4 - log variable values of a given category
										different from third debug trace at any point in code */

#define		GNLOG_MEMORY	0x001000	/* log memory usage */
#define		GNLOG_FS		0x002000	/* log file system usage */

#define		NULL_FILE_NAME		"(null)"


/*
 * Structures and typedefs.
 */

/* module configuration data */
typedef struct gnlog_config
{
	gn_uchar_t	log_file[GN_MAX_PATH];
	gn_uint16_t	enable_pkgid;
	gn_uint32_t	enable_logid;
	gn_uint16_t	disable_pkgid;
	gn_uint32_t	disable_logid;
}
gnlog_config_t;


/*
 * Macros
 */

#ifdef GN_LOGGING

/* basic logging macro */
#define		GNLOG(package_id,mask,logf_call)			if (gnlog_filter(package_id,mask) == GN_TRUE) {	\
															gnlog_write(logf_call);	\
														}

/* basic logging macro, prints out header */
#define		GNLOGH(package_id,mask,logf_call)			if (gnlog_filter(package_id,mask) == GN_TRUE) {	\
															gnlog_header(package_id,mask,__LINE__,((gn_uchar_t*)__FILE__));	\
															gnlog_write(logf_call);	\
														}

#else /* #ifdef GN_LOGGING */

#define		GNLOG(package_id,mask,logf_call)
#define		GNLOGH(package_id,mask,logf_call)

#endif /* #ifdef GN_LOGGING */


/*
 * Prototypes
 */

/* Logging functions called from the guts of the code. */

gn_bool_t
gnlog_filter(gn_uint16_t package_id, gn_uint32_t mask);

void
gnlog_header(gn_uint16_t package_id, gn_uint32_t mask, gn_uint32_t line, gn_uchar_t* file);

void
gnlog_write(gn_size_t message_length);

gn_size_t
gnlog_logf(const gn_uchar_t* format, ...);

gn_size_t
gnlog_dumpf(const gn_uchar_t* description, void* buffer, gn_size_t number_of_bytes);


/* Initialization */

gn_error_t
gnlog_query_availability(gn_uint32_t* feature_mask);

gn_error_t
gnlog_init(const gn_uchar_t* override_log_file_name);

void
gnlog_shutdown(void);

/* Control functions called during initialization (or at other opportune times). */
/* Control settings are stored on a package-by-package basis. */

gn_error_t
gnlog_enable(gn_uint16_t package_id, gn_uint32_t category_mask);

gn_error_t
gnlog_disable(gn_uint16_t package_id, gn_uint32_t category_mask);

/* If output_file == "stdout", then output is to standard out. */
/* If output_file == "stderr", then output is to standard error. */
gn_error_t
gnlog_set_output(const gn_uchar_t* output_file);

const gn_uchar_t*
gnlog_getid_string(gn_uint32_t logid);

gn_bool_t
gnlog_get_pkg_mask(gn_uint32_t package_index, gn_uint32_t *mask);

/* is logging verbose for this package_id and this mask? */
gn_bool_t
gnlog_is_verbose(gn_uint16_t package_id, gn_uint32_t mask);

/* include a time stamp on the log entry? */
gn_bool_t
gnlog_do_timestamp(gn_uint16_t package_id, gn_uint32_t mask);

/* return a pointer to a printable file name - could be "(null)", could be non-verbose */
gn_uchar_t*
gnlog_file_ptr(gn_uint16_t package_id, gn_uint32_t mask, gn_uchar_t* file);

gn_uchar_t*
gnlog_stripf(const gn_uchar_t* file);

#ifdef __cplusplus
}
#endif

#endif /* _GN_LOG_H_ */

