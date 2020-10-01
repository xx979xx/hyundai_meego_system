/*
 * Copyright (c) 2000 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gn_fs.h - File system interface for abstraction layer 
 */

#ifndef	_GN_FS_H_
#define _GN_FS_H_

/*
 * Dependencies.
 */

#include	"gn_abs_types.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants.
 */

/* invalid handle value */
#define		GN_FS_INVALID_HANDLE	((gn_handle_t)-1)

/* invalid offset value */
#define		GN_FS_INVALID_OFFSET	((gn_foffset_t)-1L)

/* read or write error return value */
#define		GN_FS_READ_WRITE_ERR	((gn_size_t)-1)

/* invalid attribute value */
#define		GN_FSATTR_Invalid		((gnfs_attr_t)-1)


/* seek origin values */
#define GN_FS_SEEK_START			0
#define GN_FS_SEEK_CURRENT			1
#define GN_FS_SEEK_END				2

/* open modes (flags) */
#define GN_FSMODE_ReadOnly			0x0001
#define GN_FSMODE_WriteOnly			0x0002
#define GN_FSMODE_ReadWrite			0x0004
#define GN_FSMODE_Append			0x0008
#define GN_FSMODE_Create			0x0100
#define GN_FSMODE_Truncate			0x0200
#define GN_FSMODE_Exclusive			0x0400

/* file attributes */
#define GN_FSATTR_Read				0x0001
#define GN_FSATTR_Write				0x0002
#define GN_FSATTR_ReadWrite			(GN_FSATTR_Read|GN_FSATTR_Write)


/*
 * Typedefs.
 */

typedef gn_uint32_t		gnfs_mode_t;

typedef gn_uint32_t		gnfs_attr_t;

/* abstract type for file offsets */
typedef gn_int32_t		gn_foffset_t;

typedef gn_int32_t		gnfs_seek_origin_t;

/* file subsystem configuration structure */
typedef struct fs_config_t
{
	gn_uchar_t	file_image_path[GN_MAX_PATH];
	gn_bool_t	set_file_image_path;
}
gnfs_config_t;

/*
 * Macros
 */
 
#ifndef gnfs_get_error
#define gnfs_get_error				_gnfs_get_error
#endif
#ifndef gnfs_open
#define gnfs_open					_gnfs_open
#endif
#ifndef gnfs_create
#define gnfs_create					_gnfs_create
#endif
#ifndef gnfs_delete
#define gnfs_delete					_gnfs_delete
#endif
#ifndef gnfs_exists
#define gnfs_exists					_gnfs_exists
#endif
#ifndef gnfs_copy_file
#define gnfs_copy_file				_gnfs_copy_file
#endif
#ifndef gnfs_rename_file
#define gnfs_rename_file			_gnfs_rename_file
#endif
#ifndef gnfs_get_attr
#define gnfs_get_attr				_gnfs_get_attr
#endif
#ifndef gnfs_set_attr
#define gnfs_set_attr				_gnfs_set_attr
#endif
#ifndef gnfs_read
#define gnfs_read					_gnfs_read
#endif
#ifndef gnfs_write
#define gnfs_write					_gnfs_write
#endif
#ifndef gnfs_read_at
#define gnfs_read_at				_gnfs_read_at
#endif
#ifndef gnfs_write_at
#define gnfs_write_at				_gnfs_write_at
#endif
#ifndef gnfs_tell
#define gnfs_tell					_gnfs_tell
#endif
#ifndef gnfs_seek
#define gnfs_seek					_gnfs_seek
#endif
#ifndef gnfs_get_eof
#define gnfs_get_eof				_gnfs_get_eof
#endif
#ifndef gnfs_set_eof
#define gnfs_set_eof				_gnfs_set_eof
#endif
#ifndef gnfs_commit
#define gnfs_commit					_gnfs_commit
#endif
#ifndef gnfs_close
#define gnfs_close					_gnfs_close
#endif


/*
 * Prototypes.
 */

/* Determine whether the file system functionality is
 * compiled in, and is initialized
 */
gn_error_t
gnfs_query_availability(
	gn_uint32_t* feature_mask
	);


/* Initialize file system subsystem
 *
 * Perform any platform specific file system initialization steps that
 * are necessary on the target platform
 */
gn_error_t
gnfs_initialize(
	void
	);


/* Shutdown file system subsystem
 *
 * Perform any platform specific file system shutdown steps that
 * are necessary on the target platform
 */
gn_error_t
gnfs_shutdown(
	void
	);


/* Open an existing file and leave it open for use
 *
 * If GN_FSMODE_Create is set in mode then the file
 * will be created.
 *
 * filename: The name of the file to create
 * mode    : The file open mode of the created file
 */
gn_handle_t
_gnfs_open(
	const gn_uchar_t* filename,
	gnfs_mode_t mode
	);

/* Create a file and leave it open for use
 *
 * filename : The name of the file to create
 * mode     : The file open mode of the created file
 * attribute: The file attributes of the created file
 */
gn_handle_t
_gnfs_create(
	const gn_uchar_t* filename,
	gnfs_mode_t mode,
	gnfs_attr_t attribute
	);


/* Delete a file
 *
 * filename: The name of the file to delete
 */
gn_error_t
_gnfs_delete(
	const gn_uchar_t* filename
	);


/* Check to see if file exists
 *
 * filename: The name of the file to check the existence of
 */
gn_bool_t
_gnfs_exists(
	const gn_uchar_t* filename
	);


/* Copy an existing file
 *
 * source_file: The name of the source file
 * dest_file  : The name of the new copied file
 */
gn_error_t
_gnfs_copy_file(
	const gn_uchar_t* source_file,
	const gn_uchar_t* dest_file
	);


/* Rename a file
 *
 * old_file: The original file name
 * new_file: The new file name
 */
gn_error_t
_gnfs_rename_file(
	const gn_uchar_t* old_file,
	const gn_uchar_t* new_file
	);


/* Get the file attributes of a file
 *
 * Return Value: The current file attributes or GN_FSATTR_Invalid if there
 * was an error.
 *
 * filename: The name of the file
 * attribute: The new attributes for the file
 *
 * NOTE: In the case where the file system does not support file attributes
 * is it assumed that files will always be read-write, so GN_FSATTR_ReadWrite
 * should be returned in this case.
 */
gnfs_attr_t
_gnfs_get_attr(
	const gn_uchar_t* filename
	);


/* Set the file attributes of a file
 *
 * filename: The name of the file
 * attribute: The new attributes for the file
 *
 * NOTE: In the case where the file system does not support file attributes
 * is it assumed that files will always be read-write. In this situration
 * GN_SUCCESS should be returned for any value of attribute, and this
 * function will not perform any modifications to file system attributes.
 */
gn_error_t
_gnfs_set_attr(
	const gn_uchar_t* filename,
	gnfs_attr_t attribute
	);


/* Read data from a file
 *
 * Return Value: The number of bytes actually read or GN_FS_READ_WRITE_ERR
 * if there was an error
 *
 * handle: The handle of the file to read from
 * buffer: The data buffer to store the read data
 * size  : The number of bytes to read from the file
 *
 */
gn_size_t
_gnfs_read(gn_handle_t handle,
	void* buffer,
	gn_size_t size
	);


/* Write data to a specified file
 *
 * Return Value: The number of bytes actually written or GN_FS_READ_WRITE_ERR
 * if there was an error
 *
 * handle: The handle of the file to write to
 * buffer: The data to write to the file
 * size  : The number of bytes to write to the file
 *
 */
gn_size_t
_gnfs_write(
	gn_handle_t handle,
	void* buffer,
	gn_size_t size
	);


/* Read data from the specified offset of a file
 *
 * Return Value: The number of bytes actually read or GN_FS_READ_WRITE_ERR
 * if there was an error
 *
 * handle: The handle of the file to read from
 * offset: The offset, in bytes, to read the data from
 * buffer: The data buffer to store the read data
 * size  : The number of bytes to read from the file
 *
 */
gn_size_t
_gnfs_read_at(
	gn_handle_t handle,
	gn_foffset_t offset,
	void* buffer,
	gn_size_t size
	);


/* Write data to the specified offset of a file
 *
 * Return Value: The number of bytes actually written or GN_FS_READ_WRITE_ERR
 * if there was an error
 *
 * handle: The handle of the file to write to
 * offset: The offset, in bytes, to write the data to
 * buffer: The data to write to the file
 * size  : The number of bytes to write to the file
 *
 */
gn_size_t
_gnfs_write_at(
	gn_handle_t handle,
	gn_foffset_t offset,
	void* buffer,
	gn_size_t size
	);


/* Get the current file pointer position (offset) in bytes
 *
 * handle: The handle of the file
 */
gn_foffset_t
_gnfs_tell(
	gn_handle_t handle
	);


/* Set the current file pointer to the location indicated to by
 * offset in relation to origin.
 *
 * handle: The handle of the file
 * offset: The offset in bytes to set the pointer
 * origin: The seek origin
 */
gn_foffset_t
_gnfs_seek(
	gn_handle_t handle,
	gn_foffset_t offset,
	gnfs_seek_origin_t origin
	);


/* Get the end-of-file position of the file pointed to by handle.
 *
 * handle: The handle of the file
 */
gn_foffset_t
_gnfs_get_eof(
	gn_handle_t handle
	);


/* Set the end-of-file position of the file pointed to by handle to the
 * value of offset.
 *
 * This API is not expected to be able to shorten the length of a file.
 *
 * The contents of the data in the newly extended portion of the file are
 * undefined.
 *
 * handle: The handle of the file
 * offset: The new new end-of-file offset for the file
 */
gn_foffset_t
_gnfs_set_eof(
	gn_handle_t handle,
	gn_foffset_t offset
	);


/* Commit any unwritten/cached data to disk.
 *
 * handle: The handle of the file
 */
gn_error_t
_gnfs_commit(
	gn_handle_t handle
	);


/* Close the file pointed to by handle
 *
 * handle: The handle of the file
 */
gn_error_t
_gnfs_close(
	gn_handle_t handle
	);


/* Retrieves the last error set by one of the other file system functions.
 * This function returns a valid error value only if the last gnfs
 * function call generated an error.
 */
gn_error_t
_gnfs_get_error(
	void
	);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_FS_H_ */
