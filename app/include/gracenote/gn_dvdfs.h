/*
 * Copyright (c) 2000-2008 Gracenote, Inc. All rights reserved.
 *
 * This software may not be used in any way or distributed without
 * Gracenote's written permission. 
 *
 * One or more patents owned by Gracenote apply to this software.
 */

/*
 *	gn_dvdfs.h - DVD File system interface for abstraction layer 
 */

#ifndef	_GN_DVDFS_H_
#define _GN_DVDFS_H_

/*
 * Dependencies.
 */

#include "gn_abs_types.h"


#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants.
 */

/* invalid handle value */
#define		GN_DVDFS_INVALID_HANDLE	((gn_dvdhandle_t)-1)

/* invalid offset value */
#define		GN_DVDFS_INVALID_OFFSET	((gn_dvd_foffset_t)-1L)

/* read or write error return value */
#define		GN_DVDFS_READ_WRITE_ERR	((gn_size_t)-1)


/* seek origin values */
#define GN_DVDFS_SEEK_START			0
#define GN_DVDFS_SEEK_CURRENT		1
#define GN_DVDFS_SEEK_END			2

/* open modes (flags) */
#define GN_DVDFSMODE_ReadOnly			0x0001


/*
 * Typedefs.
 */

typedef gn_uint32_t		gndvdfs_mode_t;


/* abstract type for file offsets */
typedef gn_int32_t		gn_dvd_foffset_t;

typedef gn_int32_t		gndvdfs_seek_origin_t;


/* This structure represents the data that is found in the lead-in Area of
 * each layer of the DVD. Structure was derived from "DVD Demystified",
 * volume 1, table 4.3 on page 132
 *
 * Each element has its own valid flag because different operating systems
 * read the fields in different groups, so saying "group 1 is valid" would
 * have different meanings in different platforms. It is a little clunky
 * but it works.
 */
typedef struct
{
	/* For now we are only interested in getting the book type */
	gn_uchar_t	book_type;
	gn_bool_t	book_type_valid;
} gndvd_lead_in_t;


/*
 * Prototypes.
 */



/* Determine whether the file system functionality is
 * compiled in, and is initialized
 */
gn_error_t
gndvdfs_query_availability(
	gn_uint32_t* feature_mask
	);

/* initialize file system subsystem */
gn_error_t
gndvdfs_initialize(void);

/* initialize file system subsystem */
gn_error_t
gndvdfs_shutdown(void);

/* open existing file for reading and/or writing */
gn_dvdhandle_t
gndvdfs_open(const gn_uchar_t* filename, gndvdfs_mode_t mode);

/* check to see if file exists */
gn_bool_t
gndvdfs_exists(const gn_uchar_t* filename);

/* read bytes from file (returns -1 if error) */
gn_size_t
gndvdfs_read(gn_dvdhandle_t handle, void* buffer, gn_size_t size);

/* read bytes from file at offset (returns -1 if error) */
gn_size_t
gndvdfs_read_at(gn_dvdhandle_t handle, gn_dvd_foffset_t offset, void* buffer, gn_size_t size);

/* set current file position */
gn_dvd_foffset_t
gndvdfs_seek(gn_dvdhandle_t handle, gn_dvd_foffset_t offset, gndvdfs_seek_origin_t origin);

/* close file */
gn_error_t
gndvdfs_close(gn_dvdhandle_t handle);

/* retrieve last error */
gn_error_t
gndvdfs_get_error(void);

/* These functions construct file names for VTS files in the video_ts directory */
void
gndvdfs_get_vts_ifoname(const gn_uchar_t* basepath, const gn_uint16_t titleset, gn_uchar_t* ifoname, gn_uint16_t size);

void
gndvdfs_get_video_ts_ifoname(const gn_uchar_t* basepath, gn_uchar_t* ifoname, gn_uint16_t size);

/* Get the number of layers on the DVD
 *
 * A DVD has either 1 or 2 layers and each layer contains its own lead-in
 * data. This function will tell us how many lead-in structures to read.
 *
 * Parameters:
 *   IN:
 *     path - The path to the root of the DVD file system
 *
 *   OUT:
 *     count - The number of layers on the disc
 *
 *
 * If the targer platform can not support reading the layer count
 * then 0 (zero) should be returned through the count parameter.
 *
 *
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *
 *   On error:
 *     error value : Gracenote Error Value
 */
gn_error_t
gndvdfs_get_layer_count(
	const gn_uchar_t *path,
	gn_uint32_t *count
	);


/* Read the lead-in structure for the specified layer number
 *
 * A DVD has either 1 or 2 layers and each layer contains its own lead-in
 * data. This function will tell us how many lead-in structures to read.
 *
 * Parameters:
 *   IN:
 *     path - The path to the root of the DVD file system
 *     layer_num - The layer number to read the lead-in from
 *
 *   OUT:
 *     lead_in - The lead-in data for the specified DVD layer
 *               This value is zero-based
 *
 *
 * If the target platform can not support reading a specified element in the
 * lead-in structure then the "valid" boolean value for that element should
 * be set to GN_FALSE. Otherwise is should be set to GN_TRUE.
 *
 *
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *
 *   On error:
 *     error value : Gracenote Error Value
 */
gn_error_t gndvdfs_read_lead_in(
	const gn_uchar_t *path,
	gn_uint32_t layer_num,
	gndvd_lead_in_t *lead_in
	);

/* Read the volume label from the DVD disc
 *
 *
 * Parameters:
 *   IN:
 *     path - The path to the root of the DVD file system
 *     label_size - The maximum number of bytes to write to label
 *
 *   OUT:
 *     size_written - The number of bytes written to the label
 *     label - The buffer for the volume label
 *
 *
 * If the target platform can not support reading a volume label then
 * a value of zero should be placed in the "size_written" field.
 *
 * The volume label buffer should be filled with the physical volume label
 * up to the label_size parameter. If the actual volume label is larger then
 * label_size then just a subset of the volume label will be copied. The
 * buffer does not need to be NULL terminated.
 *
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *
 *   On error:
 *     error value : Gracenote Error Value
 */
gn_error_t gndvdfs_read_vol_label(
	const gn_uchar_t *path,
	gn_uint32_t label_size,
	gn_uint32_t *size_written,
	gn_uchar_t *label
  );


#ifdef __cplusplus
}
#endif 

#endif /* _GN_DVDFS_H_ */
