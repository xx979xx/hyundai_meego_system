/*
 * Copyright (c) 2004 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gndvd_changer.h - DVD Changer ID Generation
 */

#ifndef _GNDVD_CHANGER_H_
#define _GNDVD_CHANGER_H_

/*
 * Dependencies
 */

#include "gn_defines.h"
#include "gn_encode_md5.h"
#include "gn_topinfo.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants
 */

/* 
 * The CHGR ID is an md5 digest in null-terminated ASCII
 */
#define GNDVD_CHGR_ID_SIZE ((MD5_DIGESTSZ * 2) + 1)
/*
 * Structures and typedefs
 */

typedef	void*	gndvd_chgr_id_handle_t;


/*
 * Prototypes
 */

/* Create changer id handle. */
/* Allocate any necessary memory. */
/* Initialize any necessary subsystems. */
gn_error_t
gndvd_chgr_genid_start(
	gndvd_chgr_id_handle_t* id_handle
	);

/* Destroy changer id handle. */
/* Deallocate all memory allocated by gndvd_chgr_genid_start. */
/* Deinitialize any subsystems initialized by gndvd_chgr_genid_start. */
gn_error_t
gndvd_chgr_genid_free(
	gndvd_chgr_id_handle_t* id_handle
	);

/* Complete the chgr id generation */
gn_error_t
gndvd_chgr_genid_stop(gndvd_chgr_id_handle_t id_handle);

/* Add the frame data contained in the array for the indicated title set. */
/* The title_set_ord parameter is a 1-based index identifying the position of
 *     the title set on the DVD. */
/* The frame_data_array parameter is an array allocated / deallocated by the
 *     caller; */
/* the array is assumed to be at least as long as the array_count parameter
 *     value. */
gn_error_t
gndvd_chgr_genid_continue(
	gndvd_chgr_id_handle_t id_handle,
	gn_uint16_t title_set_ord,
	gn_uint16_t array_count,
	gn_uint32_t* frame_data_array
	);

/* Produce an ASCII representation of the changer id. */
/* The id will be GNDVD_CHGR_ID_SIZE characters long. 
 * Thus, the buffer size should be at least that size. 
 */
gn_error_t
gndvd_chgr_getid_string(
	gndvd_chgr_id_handle_t id_handle,
	gn_uchar_t* buffer,
	gn_size_t buffer_size
	);


/* Generates a topid that contains the chgr_id from id_handle */
gn_error_t
gndvd_chgr_getid(gndvd_chgr_id_handle_t id_handle, gn_top_info_t *id);

/* sets *chgr to true if this is a chgr_id */
gn_error_t
gndvd_chgr_id_test(gn_top_info_t *id, gn_bool_t *chgr);

gn_error_t
gndvd_gen_chgr_id_from_str(gn_uchar_t* buffer, gn_size_t buffer_size, gn_top_info_t *id);

#ifdef __cplusplus
}
#endif

#endif  /* _GNDVD_CHANGER_H_ */
