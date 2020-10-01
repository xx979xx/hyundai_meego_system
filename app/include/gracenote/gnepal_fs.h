/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gnepal_fs.h - File system interface for abstraction layer 
 */

#ifndef	_GNEPAL_FS_H_
#define _GNEPAL_FS_H_

/*
 * Dependencies.
 */

#include	"gn_defines.h"
#include	"gn_platform.h"
#include	"gnex_errors.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants.
 */

/* invalid handle value */
#define		GNEPAL_FS_INVALID_HANDLE	((gn_handle_t)-1)

/* invalid offset value */
#define		GNEPAL_FS_INVALID_OFFSET	((gnepal_foffset_t)-1L)

/* read or write error return value */
#define		GNEPAL_FS_READ_WRITE_ERR	((gn_size_t)-1)

/* invalid attribute value */
#define		GNEPAL_FSATTR_Invalid		((gnepal_fs_attr_t)-1)


/* seek origin values */
#define GNEPAL_FS_SEEK_START			0
#define GNEPAL_FS_SEEK_CURRENT			1
#define GNEPAL_FS_SEEK_END				2

/* open modes (flags) */
#define GNEPAL_FSMODE_ReadOnly			0x0001
#define GNEPAL_FSMODE_WriteOnly			0x0002
#define GNEPAL_FSMODE_ReadWrite			0x0004
#define GNEPAL_FSMODE_Append			0x0008
#define GNEPAL_FSMODE_Create			0x0100
#define GNEPAL_FSMODE_Truncate			0x0200
#define GNEPAL_FSMODE_Exclusive			0x0400

/* file attributes */
#define GNEPAL_FSATTR_Read				0x0001
#define GNEPAL_FSATTR_Write				0x0002
#define GNEPAL_FSATTR_ReadWrite			(GNEPAL_FSATTR_Read|GNEPAL_FSATTR_Write)


/*
 * Typedefs.
 */

typedef gn_uint32_t		gnepal_fs_mode_t;

typedef gn_uint32_t		gnepal_fs_attr_t;

/* abstract type for file offsets */
typedef gn_int32_t		gnepal_foffset_t;

typedef gn_int32_t		gnepal_fs_seek_origin_t;


/*
 * Prototypes.
 */


/* Open an existing file and leave it open for use
 *
 * If GNEPAL_FSMODE_Create is set in mode then the file
 * will be created.
 *
 * filename: The name of the file to create
 * mode    : The file open mode of the created file
 */
gn_handle_t
gnepal_fs_open(const gn_uchar_t* filename, gnepal_fs_mode_t mode);

/* Create a file and leave it open for use
 *
 * filename : The name of the file to create
 * mode     : The file open mode of the created file
 * attribute: The file attributes of the created file
 */
gn_handle_t
gnepal_fs_create(const gn_uchar_t* filename, gnepal_fs_mode_t mode, gnepal_fs_attr_t attribute);

/* Delete a file
 *
 * filename: The name of the file to delete
 */
gnex_error_t
gnepal_fs_delete(const gn_uchar_t* filename);

/* Check to see if file exists
 *
 * filename: The name of the file to check the existence of
 */
gn_bool_t
gnepal_fs_exists(const gn_uchar_t* filename);

/* Copy an existing file
 *
 * source_file: The name of the source file
 * dest_file  : The name of the new copied file
 */
gnex_error_t
gnepal_fs_copy_file(const gn_uchar_t* source_file, const gn_uchar_t* dest_file);

/* Rename a file
 *
 * old_file: The original file name
 * new_file: The new file name
 */
gnex_error_t
gnepal_fs_rename_file(const gn_uchar_t* old_file, const gn_uchar_t* new_file);

/* Get the file attributes of a file
 *
 * Return Value: The current file attributes or GNEPAL_FSATTR_Invalid if there
 * was an error.
 *
 * filename: The name of the file
 * attribute: The new attributes for the file
 */
gnepal_fs_attr_t
gnepal_fs_get_attr(const gn_uchar_t* filename);

/* Set the file attributes of a file
 *
 * filename: The name of the file
 * attribute: The new attributes for the file
 */
gnex_error_t
gnepal_fs_set_attr(const gn_uchar_t* filename, gnepal_fs_attr_t attribute);

/* Read data from a file
 *
 * Return Value: The number of bytes actually read or GNEPAL_FS_READ_WRITE_ERR
 * if there was an error
 *
 * handle: The handle of the file to read from
 * buffer: The data buffer to store the read data
 * size  : The number of bytes to read from the file
 *
 */
gn_size_t
gnepal_fs_read(gn_handle_t handle, void* buffer, gn_size_t size);

/* Write data to a specified file
 *
 * Return Value: The number of bytes actually written or 
 * GNEPAL_FS_READ_WRITE_ERR if there was an error.
 *
 * handle: The handle of the file to write to
 * buffer: The data to write to the file
 * size  : The number of bytes to write to the file
 *
 */
gn_size_t
gnepal_fs_write(gn_handle_t handle, void* buffer, gn_size_t size);

/* Read data from the specified offset of a file
 *
 * Return Value: The number of bytes actually read or 
 * GNEPAL_FS_READ_WRITE_ERR if there was an error.
 *
 * handle: The handle of the file to read from
 * offset: The offset, in bytes, to read the data from
 * buffer: The data buffer to store the read data
 * size  : The number of bytes to read from the file
 *
 */
gn_size_t
gnepal_fs_read_at(gn_handle_t handle, gnepal_foffset_t offset, void* buffer, gn_size_t size);

/* Write data to the specified offset of a file
 *
 * Return Value: The number of bytes actually written or 
 * GNEPAL_FS_READ_WRITE_ERR if there was an error.
 *
 * handle: The handle of the file to write to
 * offset: The offset, in bytes, to write the data to
 * buffer: The data to write to the file
 * size  : The number of bytes to write to the file
 *
 */
gn_size_t
gnepal_fs_write_at(gn_handle_t handle, gnepal_foffset_t offset, void* buffer, gn_size_t size);

/* Get the current file pointer position (offset) in bytes
 *
 * handle: The handle of the file
 */
gnepal_foffset_t
gnepal_fs_tell(gn_handle_t handle);

/* Set the current file pointer to the location indicated to by
 * offset in relation to origin.
 *
 * handle: The handle of the file
 * offset: The offset in bytes to set the pointer
 * origin: The seek origin
 */
gnepal_foffset_t
gnepal_fs_seek(gn_handle_t handle, gnepal_foffset_t offset, gnepal_fs_seek_origin_t origin);

/* Get the end-of-file position of the file pointed to by handle.
 *
 * handle: The handle of the file
 */
gnepal_foffset_t
gnepal_fs_get_eof(gn_handle_t handle);

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
gnepal_foffset_t
gnepal_fs_set_eof(gn_handle_t handle, gnepal_foffset_t offset);

/* Commit any unwritten/cached data to disk.
 *
 * handle: The handle of the file
 */
gnex_error_t
gnepal_fs_commit(gn_handle_t handle);

/* Close the file pointed to by handle
 *
 * handle: The handle of the file
 */
gnex_error_t
gnepal_fs_close(gn_handle_t handle);

/* Retrieves the last error set by one of the other file system functions.
 * This function returns a valid error value only if the last gnfs
 * function call generated an error.
 */
gnex_error_t
gnepal_fs_get_error(void);


/* Clears the last error value that was set by the file system functions
 *
 */

void
gnepal_fs_clear_error(void);

#ifdef __cplusplus
}
#endif 

#endif /* _GNEPAL_FS_H_ */
