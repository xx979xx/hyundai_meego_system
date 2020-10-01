/*
 * Copyright (c) 2000-2008 Gracenote, Inc. All rights reserved.
 *
 * This software may not be used in any way or distributed without
 * Gracenote's written permission. 
 *
 * One or more patents owned by Gracenote apply to this software.
 */

/*
 *	gn_bdfs.h - Blu-ray File system interface for abstraction layer 
 */

#ifndef	_GN_BDFS_H_
#define _GN_BDFS_H_

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

/* For directory browsing
 */

/* invalid handle value */
#define		GN_BDFS_INVALID_HANDLE	((gn_bdhandle_t)-1)

/* invalid offset value */
#define		GN_BDFS_INVALID_OFFSET	((gn_bd_foffset_t)-1L)

/* read or write error return value */
#define		GN_BDFS_READ_WRITE_ERR	((gn_size_t)-1)


/* seek origin values */
#define GN_BDFS_SEEK_START			0
#define GN_BDFS_SEEK_CURRENT		1
#define GN_BDFS_SEEK_END			2



/*
 * Typedefs.
 */


typedef void* gnbdfs_dir_t;
typedef void* gnbdfs_dirent_t;

typedef gn_uint32_t gn_bdhandle_t;

/* abstract type for file offsets */
typedef gn_int32_t		gn_bd_foffset_t;

/* abstract type for file seek origin */
typedef gn_int32_t		gnbdfs_seek_origin_t;


/*
 * Prototypes.
 */

/*
 * General file IO functions
 */

/* Determine whether the file system functionality is
 * compiled in, and is initialized
 *
 * Parameters:
 *
 *   IN
 *     feature_mask: Not used at this time. Set to GN_NULL.
 *   
 * Return values:
 *     If initialized: FSERR_Busy
 *     If not initialized: FSERR_NotInited
 */
gn_error_t
gnbdfs_query_availability(
	gn_uint32_t* feature_mask
	);

/* Initialize file system subsystem
 *
 * Perform any platform specific file system initialization steps that
 * are necessary on the target platform
 *
 * Parameters:
 *     None
 *   
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *
 *   On error:
 *     error value : Gracenote Error Value
 */
gn_error_t
gnbdfs_initialize(
	void
	);

/* Shutdown file system subsystem
 *
 * Perform any platform specific file system shutdown steps that
 * are necessary on the target platform
 *
 * Parameters:
 *     None
 *   
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *
 *   On error:
 *     error value : Gracenote Error Value
 */
gn_error_t
gnbdfs_shutdown(
	void
	);

/* Open an existing file and leave it open for use
 *
 *
 * Parameters:
 *
 *   IN
 *     filename: The name of the file to open
 *
 *   OUT
 *     None
 *
 * Return values:
 *   On success:
 *     handle to opened file
 *
 *   On error:
 *     GN_BDFSERR_InvalidHandle
 */
gn_bdhandle_t
gnbdfs_open(
	const gn_uchar_t* filename
	);

/* Check to see if file exists
 *
 * Parameters:
 *
 *   IN
 *     filename: The name of the file to check the existence of
 *
 *   OUT
 *
 * Return values:
 *   GN_TRUE if the file exists
 *   GN_FALSE if the file does not exist
 */
gn_bool_t
gnbdfs_exists(
	const gn_uchar_t* filename
	);

/* Read data from a file
 *
 * Return Value: The number of bytes actually read or GN_BDFS_READ_WRITE_ERR
 * if there was an error
 *
 * Parameters:
 *
 *   IN
 *     handle: The handle of the file to read from
 *     buffer: The data buffer to store the read data
 *     size  : The number of bytes to read from the file
 *
 *   OUT
 *
 * Return values:
 *   The number of bytes read
 */
gn_size_t
gnbdfs_read(
	gn_bdhandle_t handle,
	void* buffer,
	gn_size_t size
	);

/* Read data from the specified offset of a file
 *
 * Return Value: The number of bytes actually read or GN_FS_READ_WRITE_ERR
 * if there was an error
 *
 * Parameters:
 *
 *   IN
 *     handle: The handle of the file to read from
 *     offset: The offset, in bytes, to read the data from
 *     buffer: The data buffer to store the read data
 *     size  : The number of bytes to read from the file
 *
 *   OUT
 *
 * Return values:
 *   The number of bytes read
 */
gn_size_t
gnbdfs_read_at(
	gn_bdhandle_t handle,
	gn_bd_foffset_t offset,
	void* buffer,
	gn_size_t size
	);

/* Set the current file pointer to the location indicated to by
 * offset in relation to origin.
 *
 * Parameters:
 *
 *   IN
 *     handle: The handle of the file
 *     offset: The offset in bytes to set the pointer
 *     origin: The seek origin
 *
 *   OUT
 *
 * Return values:
 *     The new file offset or GN_BDFS_INVALID_OFFSET on error
 */
gn_bd_foffset_t
gnbdfs_seek(
	gn_bdhandle_t handle,
	gn_bd_foffset_t offset,
	gnbdfs_seek_origin_t origin
	);

/* Close the file pointed to by handle
 *
 * Parameters:
 *
 *   IN
 *     handle: The handle of the file
 *
 *   OUT
 *
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *
 *   On error:
 *     error value : Gracenote Error Value
 */
gn_error_t
gnbdfs_close(
	gn_bdhandle_t handle
	);

/* Retrieves the last error set by one of the other file system functions.
 * This function returns a valid error value only if the last gnfs
 * function call generated an error.
 *
 * Calling this function resets the internal file system error value
 * to GN_SUCCESS.
 *
 * Parameters:
 *
 *   IN
 *
 *   OUT
 *
 * Return values:
 *   The last BD file system error
 */
gn_error_t
gnbdfs_get_error(
	void
	);

/*
 * File name generation functions
 */

/* Generate a directory name that contains Blu-ray MPLS file
 *
 * Parameters:
 *
 *   IN
 *     basepath: The root of the Blu-ray drive
 *               Example might be "d:\"
 *
 *     size    : The size in bytes of the filename buffer
 *
 *   OUT
 *     dirname : The fully qualified directory name
 *               Example: If basepath is "D:\" then the
 *               directory name would be "D:\BDMV\PLAYLIST\"
 *
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *     filename    : The name of the directory
 *
 *   On error:
 *     error value : Gracenote Error Value
 *     dir         : Undefined
 */
gn_error_t
gnbdfs_get_playlist_dirname(
	const gn_uchar_t* basepath,
	gn_uchar_t* dirname,
	gn_uint32_t size
	);

/* Generate a file name for a Blu-ray MPLS file
 *
 * Parameters:
 *
 *   IN
 *     basepath: The root of the Blu-ray drive
 *               Example might be "d:\"
 *
 *     mpls_num: The number contained in the mpls file
 *               Example - If you want to open "00042.mpls" then
 *               mpls_num would be 42
 *
 *     size    : The size in bytes of the filename buffer
 *
 *   OUT
 *     filename: The fully qualified file name
 *               Example: If basepath is "D:\" and mpls_num is 42 then the
 *               filename would be "D:\BDMV\PLAYLIST\00042.mpls"
 *
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *     filename    : The name of the file
 *
 *   On error:
 *     error value : Gracenote Error Value
 *     dir         : Undefined
 */
gn_error_t
gnbdfs_get_playlist_filename(
	const gn_uchar_t* basepath,
	const gn_uint32_t mpls_num,
	gn_uchar_t* filename,
	gn_uint32_t size
	);

/* Generate a file name for a Blu-ray index.bdmv file
 *
 * Parameters:
 *
 *   IN
 *     basepath: The root of the Blu-ray drive
 *               Example might be "d:\"
 *
 *     size    : The size in bytes of the filename buffer
 *
 *   OUT
 *     filename: The fully qualified file name
 *               Example: If basepath is "D:\" then the
 *               filename would be "D:\BDMV\index.bdmv"
 *
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *     filename    : The name of the file
 *
 *   On error:
 *     error value : Gracenote Error Value
 */
gn_error_t
gnbdfs_get_index_bdmv_name(
	const gn_uchar_t* basepath,
	gn_uchar_t* filename,
	gn_uint32_t size
	);

/* Generate a file name for a Blu-ray MovieObject.bdmv file
 *
 * Parameters:
 *
 *   IN
 *     basepath: The root of the Blu-ray drive
 *               Example might be "d:\"
 *
 *     size    : The size in bytes of the filename buffer
 *
 *   OUT
 *     filename: The fully qualified file name
 *               Example: If basepath is "D:\" then the
 *               filename would be "D:\BDMV\MovieObject.bdmv"
 *
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *     filename    : The name of the file
 *
 *   On error:
 *     error value : Gracenote Error Value
 */
gn_error_t
gnbdfs_get_movieobject_bdmv_name(
	const gn_uchar_t* basepath,
	gn_uchar_t* filename,
	gn_uint32_t size
	);


/*
 * Directory browsing functions
 */

/* Opens a Blu-ray directory for browsing
 *
 * Parameters:
 *
 *   IN
 *     path: The file system directory to open.
 *           An example might be "d:\BDMV\PLAYLIST\"
 *
 *   OUT
 *     dir : A directory pointer containing information about the opened
 *           directory
 *
 * Return values:
 *   On success:
 *     error value : GN_SUCCESS
 *     dir         : Allocated and populated directory pointer
 *
 *   On error:
 *     error value : Gracenote Error Value
 *     dir         : Undefined
 */
gn_error_t
gnbdfs_open_dir(
	const gn_uchar_t *path,
	gnbdfs_dir_t *dir
	);

/* Close the directory entry
 *
 * Parameters:
 *
 *   IN
 *     bd_dir: The directory
 *
 * Return values:
 *     None
 */
void
gnbdfs_close_dir(
	gnbdfs_dir_t bd_dir
	);


/* Reads a Blu-ray directory
 *
 * Parameters:
 *
 *   IN
 *     bd_dir: The previously opened directory pointer
 *
 *   OUT
 *             A directory entry pointer containing information about the
 *             next entry in the directory
 *
 * Return values:
 *   On success:
 *              Allocated and populated directory entry pointer if another
 *              entry is available, or GN_NULL if the last entry in the
 *              directory has been read.
 *
 *   On error:
 *              GN_NULL
 */
gnbdfs_dirent_t
gnbdfs_readdir(
	gnbdfs_dir_t bd_dir
	);

/* Gets the system directory delimiter
 *
 * Parameters:
 *
 *   IN
 *     None
 *
 * Return values:
 *             The character used as a directory delimiter on the system
 */
gn_uchar_t
gnbdfs_dir_get_delim(
	);

/* Get the name of the file or directory referenced by the directory entry.
 *
 * Parameters:
 *
 *   IN
 *     bd_dirent: The directory entry
 *
 * Return values:
 *   On success:
 *              A NULL terminated string contaning just the name of the file
 *              pointed to by bd_direct. This name does not contain the path
 *              information.
 *              The string should not be modified or freed by the caller.
 *
 *   On error:
 *              GN_NULL
 */
gn_uchar_t *
gnbdfs_dirent_get_name(
	gnbdfs_dirent_t bd_dirent
	);

/* Find out if the directory entry represents a directory
 *
 * Parameters:
 *
 *   IN
 *     bd_dirent: The directory entry
 *
 * Return values:
 *   GN_TRUE if the entry is a directory or GN_FALSE if it is something else
 *   (like a file)
 */
gn_bool_t
gnbdfs_dirent_is_dir(
	gnbdfs_dirent_t bd_dirent
	);

/* Find out if the directory entry represents a file
 *
 * Parameters:
 *
 *   IN
 *     bd_dirent: The directory entry
 *
 * Return values:
 *   GN_TRUE if the entry is a file or GN_FALSE if it is something else
 *   (like a directory)
 */
gn_bool_t
gnbdfs_dirent_is_file(
	gnbdfs_dirent_t bd_dirent
	);

/* Find out if the directory entry represents a parent directory
 *
 * Parameters:
 *
 *   IN
 *     bd_dirent: The directory entry
 *
 * Return values:
 *   GN_TRUE if the entry is a parent directory or GN_FALSE if it is something else
 *   (like a file)
 */
gn_bool_t
gnbdfs_dirent_is_parent_dir(
	gnbdfs_dirent_t bd_dirent
	);

/* Find out if the directory entry represents the current directory
 *
 * Parameters:
 *
 *   IN
 *     bd_dirent: The directory entry
 *
 * Return values:
 *   GN_TRUE if the entry is the current directory or GN_FALSE if it is something else
 *   (like a file)
 */
gn_bool_t
gnbdfs_dirent_is_current_dir(
	gnbdfs_dirent_t bd_dirent
	);

/* Free the directory entry
 *
 * Parameters:
 *
 *   IN
 *     bd_dirent: The directory entry
 *
 * Return values:
 *     None
 */
void
gnbdfs_free_dirent(
	gnbdfs_dirent_t bd_dirent
	);

/* Return the name of the AACS certificate directory
 *
 * Parameters:
 *
 * IN
 *   basepath: The basepath of the BD filesystem  (such as d:\ or /mnt/dvd/ )
 *   size:     Size of the buffer pointed to by dirname
 *
 * OUT
 *   dirname:  The full pathname of the AACS directory  (such as d:\aacs\)
 *
 * Return values:
 *
 * On success:
 *   return: GN_SUCCESS
 *   dirname: will contain the name of the AACS directory
 *
 * On Error:
 *   return: GN error value
 *   dirname: undefined
 */
gn_error_t
gnbdfs_get_cert_dirname(
	const gn_uchar_t* basepath,
	gn_uchar_t* dirname,
	gn_uint32_t size
	);

 
/* Read the volume label from the BD disc
 *
 *
 * Parameters:
 *   IN:
 *     path - The path to the root of the BD file system
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
gn_error_t gnbdfs_read_vol_label(
	const gn_uchar_t *path,
	gn_uint32_t label_size,
	gn_uint32_t *size_written,
	gn_uchar_t *label
  );



/* Get the number of layers on the BD
 *
 *
 * Parameters:
 *   IN:
 *     path - The path to the root of the BD file system
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
gnbdfs_get_layer_count(
	const gn_uchar_t *path,
	gn_uint32_t *count
	);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_BDFS_H_ */
