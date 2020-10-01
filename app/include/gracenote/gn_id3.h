/*
 * Copyright (c) 2003 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_id3.h -  Header file for ID3 tag reading/writing.
 *             This file contains the abstracted "high level" ID3
 *             tagging functions that don't care about the internal ID3
 *             structure. 
 */

#ifndef _GN_ID3_H_
#define _GN_ID3_H_

#include "gn_defines.h"
#include "gnepal_fs.h"

#include "gnex_errors.h"

#ifdef __cplusplus
extern "C"{
#endif 

/* gnid3_id3version_t is used as a way to sepecify a version number of the ID3 standard*/ 
typedef gn_uchar_t gnid3_id3version_t;

#define GNID3_VERSION_2 2 /*ID3V2.2*/
#define GNID3_VERSION_3 3 /*ID3v2.3*/
#define GNID3_VERSION_4 4 /*ID3v2.4*/

#define GNID3_MIME_IMAGE_JPEG	(gn_uchar_t*) "image/jpeg"
#define GNID3_MIME_IMAGE_PNG	(gn_uchar_t*) "image/png"
#define GNID3_MIME_IMAGE_GIF	(gn_uchar_t*) "image/gif"
#define GNID3_MIME_IMAGE_BMP	(gn_uchar_t*) "image/bmp"

/*
 * Used to uniquely identify a frame inside an ID3 tag in a version independent manner
 */
typedef gn_uint16_t gnid3_frameid_t;

/* 
 * Used to identify a frame without having to know what the frame id is for the 
 * specific version of the tag.
 */

/*misc frames*/
#define GNID3_AudioEncryption 					0
#define GNID3_AttachedPicture 					1
#define GNID3_AudioSeekPoints					2
#define GNID3_Comments 							3
#define GNID3_CommercialFrame 					4
#define GNID3_EncryptionMethodRegistration 		5
#define GNID3_Equalization 						6
#define GNID3_EventTimingCodes 					7
#define GNID3_GeneralEncapsulatedObject 		8
#define GNID3_GroupIdentificationRegistration 	9
#define GNID3_InvolvedPeopleList 				10
#define GNID3_LinkedInformation 				11
#define GNID3_MusicCDIdentifier 				12
#define GNID3_MPEGLocationLookupTable 			13
#define GNID3_OwnershipFrame 					14
#define GNID3_PrivateFrame 						15
#define GNID3_PlayCounter 						16
#define GNID3_Popularimeter 					17
#define GNID3_PositionSynchronisationFrame 		18
#define GNID3_RecommendedBufferSize 			19
#define GNID3_RelativeVolumeAdjustment 			20
#define GNID3_Reverb 							21
#define GNID3_SeekFrame							22
#define GNID3_SignatureFrame					23
#define GNID3_SynchronizedLyrics 				24
#define GNID3_SynchronizedTempoCodes 			25

/*text frames*/
#define GNID3_AlbumTitle 						26 /* Album/Movie/Show title */
#define GNID3_BPM 								27
#define GNID3_Composer 							28
#define GNID3_Genre								29 /*aka ContentType*/
#define GNID3_CopyrightMessage 					30
#define GNID3_Date 								31
#define GNID3_EncodingTime						32
#define GNID3_PlaylistDelay 					33
#define GNID3_TaggingTime						34
#define GNID3_EncodedBy 						35
#define GNID3_Lyricist 							36
#define GNID3_FileType 							37
#define GNID3_Time 								38
#define GNID3_ContentGroupDescription 			39 /*aka ContentGroupDescription*/
#define GNID3_SongTitle 						40
#define GNID3_Subtitle 							41
#define GNID3_InitialKey 						42
#define GNID3_Language 							43
#define GNID3_Length 							44
#define GNID3_MusicianCreditsList				45
#define GNID3_MediaType 						46
#define GNID3_Mood								47
#define GNID3_OriginalTitle 					48
#define GNID3_OriginalFilename 					49
#define GNID3_OriginalLyricist 					50
#define GNID3_OriginalArtist 					51
#define GNID3_OriginalReleaseYear 				52
#define GNID3_OriginalReleaseTime				GNID3_OriginalReleaseYear /* v3 <-> v4 mapping */
#define GNID3_FileOwner 						53
#define GNID3_LeadPerformer 					54
#define GNID3_BandOrOrchestra 					55
#define GNID3_Conductor 						56
#define GNID3_ModifiedBy 						57
#define GNID3_PartOfSet 						58
#define GNID3_ProducedNotice					59
#define GNID3_Publisher 						60 /*aka Record Label */
#define GNID3_TrackNumber 						61
#define GNID3_RecordingDates 					62
#define GNID3_InternetRadioStationName 			63
#define GNID3_InternetRadioStationOwner 		64
#define GNID3_Size 								65
#define GNID3_AlbumSortOrder					66
#define GNID3_PerformerSortOrder 				67
#define GNID3_TitleSortOrder					68
#define GNID3_ISRC 								69
#define GNID3_SettingsForEncoding 				70
#define GNID3_SetSubtitle						71
#define GNID3_ReleaseYear 						72
#define GNID3_RecordingTime						GNID3_ReleaseYear /* v3 <-> v4 mapping */
#define GNID3_ReleaseTime						GNID3_ReleaseYear /* v3 <-> v4 mapping */

/*misc frames*/
#define GNID3_UserDefinedText 					73
#define GNID3_UniqueFileIdentifier 				74	/* Use GNID3_GNTagID for Gracenote TagID */
#define GNID3_TermsOfUse 						75
#define GNID3_UnsynchronizedLyrics 				76

/*Link Frames*/
#define GNID3_CommercialInformation 			77
#define GNID3_CopyrightInformation 				78
#define GNID3_AudioFileWebpage 					79
#define GNID3_ArtistWebpage 					80
#define GNID3_AudioSourceWebpage 				81
#define GNID3_InternetRadioStationWebpage 		82
#define GNID3_PaymentLink 						83
#define GNID3_PublisherWebpage 					84
#define GNID3_UserDefinedLink 					85

/*Gracenote Custom Frames*/
#define GNID3_GNDiscArtist 						GNID3_UserDefinedText
#define GNID3_GNExtData							GNID3_UserDefinedText
#define GNID3_GNTagID							GNID3_UniqueFileIdentifier

/*For error reporting*/
#define GNID3_UnknownFrame 						86

/* Valid Picture Types */

/* Other */
#define	GNID3_PICTURE_OTHER					0x00
/* 32x32 pixels 'file icon' (PNG only) */
#define GNID3_PICTURE_FILE_ICON				0x01
/* Other file icon */
#define GNID3_PICTURE_OTHER_FILE_ICON		0x02
/* Cover (front) */
#define GNID3_PICTURE_FRONT_COVER			0x03
/* Cover (back) */
#define GNID3_PICTURE_BACK_COVER			0x04
/* Leaflet page */
#define GNID3_PICTURE_LEAFLET_PAGE			0x05
/* Media (e.g. lable side of CD) */
#define GNID3_PICTURE_CD_LABEL				0x06
/* Lead artist/lead performer/soloist */
#define GNID3_PICTURE_LEAD_PERFORMER		0x07
/* Artist/performer */
#define GNID3_PICTURE_PERFORMER				0x08
/* Conductor */
#define GNID3_PICTURE_CONDUCTOR				0x09
/* Band/Orchestra */
#define GNID3_PICTURE_BAND_ORCHESTRA		0x0A
/* Composer */
#define GNID3_PICTURE_COMPOSER				0x0B
/* Lyricist/text writer */
#define GNID3_PICTURE_LYRICIST				0x0C
/* Recording Location */
#define GNID3_PICTURE_RECORDING_LOCATION	0x0D
/* During recording */
#define GNID3_PICTURE_BAND_RECORDING		0x0E
/* During performance */
#define GNID3_PICTURE_BAND_PERFORMANCE		0x0F
/* Movie/video screen capture */
#define GNID3_PICTURE_SCREEN_CAPTURE		0x10
/* ...aka "A bright coloured fish" */
#define GNID3_PICTURE_UNUSED				0x11
/* Illustration */
#define GNID3_PICTURE_ILLUSTRATION			0x12
/* Band/artist logotype */
#define GNID3_PICTURE_BAND_LOG				0x13
/* Publisher/Studio logotype */
#define GNID3_PICTURE_LABEL_LOGO			0x14

/* handle to gnid3tag struct */



typedef struct gnid3tag_tag_s gnid3_tag_t;
typedef gnid3_tag_t* gnid3_tag_ref;

/* Maps an gnid3_frameid_t to an id_str.  Useful for getting the id string for */
/* a specific version of ID3 */
/*Sets *id_str to point to a string containing the id string of a specific version*/
gnex_error_t 
gnid3_framemap_lookup(gnid3_id3version_t vers, 
					  gnid3_frameid_t id, 
					  const gn_uchar_t* *id_str);

gnex_error_t 
gnid3_search_framemap(const gn_uchar_t* findme, 
					  gnid3_frameid_t *id, 
					  gnid3_id3version_t version);

/*
 * When writing frames that involve text formatted in either ISO-8859-1 (aka ISO-Latin-1)
 * or UTF-16 (Big or Little Endian) the user can specify which method they prefer,  If the
 * UTF-8 input string cannot be converted into the desired output then a string conversion
 * error is returned and the tag is not modified.
 */
typedef gn_uint16_t  gnid3_stringconv_t;

/** V2 Writing flags **/

/*force conversion to ISO-LATIN-1*/
#define GNID3_STRCONV_V2_WRITE_FORCE_ISO8859	0x1

/*force conversion to Big Endian UTF-16 (not recommended) */
#define GNID3_STRCONV_V2_WRITE_FORCE_UTF16_BE	0x2

/*force conversion to Little Endian UTF-16*/
#define GNID3_STRCONV_V2_WRITE_FORCE_UTF16_LE	0x4

/*Convert the string to USASCII, if this fails, convert to Little Endian UTF-16 */
#define GNID3_STRCONV_V2_WRITE_AUTO_PROMOTE		0x8

/** V2 Reading flags **/

/*read frames in whatever encoding they are marked*/
#define GNID3_STRCONV_V2_READ_DEFAULT			0x10

/*read frames in whatever encoding they are marked
 *but, read iso8859-1 frames as local code page
 */
#define GNID3_STRCONV_V2_READ_LOCAL				0x20


/** V1 Writing flags **/

/*force conversion to ISO-LATIN-1*/
#define GNID3_STRCONV_V1_WRITE_ISO8859			0x100

/*force conversion to local code page*/
#define GNID3_STRCONV_V1_WRITE_LOCAL			0x200

/** V1 Reading flags **/

/*read all frames as ISO-LATIN-1*/
#define GNID3_STRCONV_V1_READ_ISO8859			0x1000

/*read all frames as local code page*/
#define GNID3_STRCONV_V1_READ_LOCAL				0x2000

/*
 *	gnid3_cfg_t
 * A configuration structure that is used to pass settings to the GNID3Library.
 *
 *1. _id
 *
 * Don't ever change this...
 *
 * Each arguement sets the value for a seperate setting:
 *2. keep_inmemory	
 * If set to true, the entire tag is read into memory and not commited to disk 
 * untill the user calls write(tag).
 *
 * If set to false,  only the tag header will be stored in memory.
 * A disk read is performed each time a get operation is requested 
 * A disk write is performed each time a set operation is performed.
 *
 *3. gn_bool_t force_unsync	
 *
 * If set to GN_TRUE: if a file is unsynchronized and the user adds a new 
 * frame that could cause GN_FALSE synchronization signals in older mp3 players
 * GNID3LIB will unsynchronize the entire existing tag as well as the new
 * frame to be added.
 * 	
 * If  set to GN_FALSE all unsynchronized tags will never be "re-unsynchronized"
 *
 * Note that regardless of the value of `force_unsync' all tags that 
 * unsynchronized flag set in there tag header will be written to according to 
 * the ID3Lib unsynchronization scheme.
 * 
 *4. gn_size_t block_sz
 *
 * The size in bytes of the host architecture's disk block size.  If different
 * from the default, set this to improve I/O performance
 * 
 *5. gn_size_t padding_sz
 *
 * The size in bytes of the default amount of padding to add to a tag if
 * the tag is too small to hold the frame information to be added.
 *
 *6. gnid3_stringconv_t strconv
 *
 * When writing frames that involve text formatted in either ISO-8859-1 (aka ISO-Latin-1)
 * or UTF-16 (Big or Little Endian) the user can specify which method they prefer,  If the
 * UTF-8 input string cannot be converted into the desired output then a string conversion
 * error is returned and the tag is not modified.
 *
 *7. gnex_error_t (*compress)
 *
 * A pointer to the zlib compatible compression function to be used.
 * If left as GN_NULL writing frames whose compression flag is set in their 
 * frame headers will return a GNEX_ID3ERR_CompressNotAvailable error.
 *
 * The compression function must have the following signature:
 *		gnex_error_t compress(gn_uchar_t *dest, 
 *							gn_uint32_t *destLen, 
 *							gn_uchar_t *source, 
 *							gn_uint32_t sourceLen)
 *
 * In other words the compression function must take as its first arguement the
 * destination buffer which stores the compressed data after the function has 
 * returned, and must be a pointer to an array of unsigned characters large 
 * enough to hold the compressed data.  The second arguement must be the size 
 * in bytes of this buffer.  The third arguement is the source buffer which 
 * contains the data to compress, which must be a pointer to an array of 
 * unsigned characters. The fourth arguement must be the size of the source 
 * buffer in bytes.  The compression function must return GNEX_SUCCESS if 
 * compress was successfull or another error value if compression failed.
 *
 *8. gn_uint32_t (*compress_size)
 * A pointer to a function that, when given the size of an uncompressed buffer,
 * returns the maximum size (in bytes) of that buffer after being compressed 
 * by the function pointed to by `compress'. 
 *
 * If left as GN_NULL a default zlib compatible function is supplied for you.
 *
 * The compress_size function must have the following signature:
 *		gn_uint32_t compress_size( gn_uint32_t uncompressed_size)
 *
 * In other words the comress_size funtion must take as its sole arguement 
 * the size in bytes of the uncompressed buffer and return the maximum size 
 * of that buffer after compression.
 *
 *
 *8. gnex_error_t (*decompress)
 * A pointer to the zlib compatible decompression function to be used.
 * If left as GN_NULL reading frames whose frame header denotes compression 
 * will return a GNEX_ID3ERR_DecompressNotAvailable error.
 *
 * The decompress function must have the following signature:
 *		gnex_error_t compress(gn_uchar_t *dest, 
 *							gn_uint32_t *destLen, 
 *							gn_uchar_t *source, 
 *							gn_uint32_t sourceLen)
 *
 * In other words, the decompression function must take as its first arguement
 * the destination buffer which stores the decompressed data after the function
 * has returned, and must be a pointer to an array of unsigned characters large
 * enough to hold the decompressed data.  The second arguement must be the size 
 * in bytes of this buffer.  The third arguement is the source buffer which 
 * contains the compressed data to decompress, which must be a pointer to an 
 * array of unsigned characters, The fourth arguement muts be the source buffer
 * size in bytes.  The decompress function must return GNEX_SUCCESS if 
 * decompression was successfull or another error value if compression failed.
 *
 */

/* Signatures for "compress"/"decompress" functions supplied to provide compression support */
typedef gnex_error_t (*GNID3CompressFunc)(gn_uchar_t *dest, 
										gn_uint32_t *destLen, 
										gn_uchar_t *source, 
										gn_uint32_t sourceLen);

typedef gnex_error_t (*GNID3DecompressFunc)(gn_uchar_t *dest, 
										  gn_uint32_t *destLen, 
										  gn_uchar_t *source, 
										  gn_uint32_t sourceLen);

typedef struct gnid3_cfg_s {
		const gn_uchar_t*			_id;
		gn_size_t			keep_inmemory;
		gn_bool_t			force_unsync;
		gn_size_t			block_sz;
		gn_size_t			padding_sz;
		gnid3_stringconv_t	strconv;

		gnex_error_t (*compress) (gn_uchar_t	 *dest, 
								gn_uint32_t *destLen,
								gn_uchar_t *source, 
								gn_uint32_t sourceLen);

		gn_uint32_t (*compress_size) (gn_uint32_t sourceLen);

		gnex_error_t (*decompress) (gn_uchar_t *dest, 
									gn_uint32_t *destLen,
 									gn_uchar_t *source, 
									gn_uint32_t sourceLen);
} gnid3_cfg_t;

/*	gnid3_init_cfg
 * Description: 
 *	Adds a Gracenote ID (aka Unique File Identifier) ID3 frame to a tag.  When
 *  passed a pointer to a configuration structure, cfg, 
 *	initializes cfg to the following default values:
 *		-keep_inmemory		= GN_TRUE 
 *		-force_unsyc		= GN_FALSE
 *		-block_sz			= 4096
 *		-padding_sz			= 1024
 *		-compress			= GN_NULL
 *		-compress_size		= GN_NULL
 *		-decompress			= GN_NULL
 * Inputs:
 *	cfg 	- a pointer to a gnid3 configuration structure.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_init_cfg( gnid3_cfg_t *cfg );


/*	gnid3_load
 * Description: 
 *	Loads an ID3v2 tag -behaves according to the settings specified
 *	in cfg - allocating a ID3v2 tag structure and pointing to tag to refer
 *	to it.
 * Inputs: 
 *	fh		- a valid file descriptor of a file to load the tag from 
 *	tag 	- a pointer to an ID3 v2 tag reference.
 * 	cfg		- a pointer to a configuration structure.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_load( gn_handle_t fh, gnid3_tag_ref *tag, const gnid3_cfg_t *cfg );

/*	gnid3_create
 * Description: 
 *	Creates an empty ID3v2 tag with no frames, 
 *	creating an internal copy of the cfg ID3v2 configuration sturct.
 * Inputs: 
 *  tag 	- a pointer to an ID3v2 tag reference.
 * 	cfg 	- a pointer to a ID3v2 configuration struct.
 *  version - the ID3v2 version to create
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_create( gnid3_tag_ref *tag, const gnid3_cfg_t *cfg, gnid3_id3version_t version );


/*	gnid3_free
 * Description: 
 *	Free the memory pointed to by the id3 tag reference (does not
 *	write the ID3 tag or otherwise modify the disk).  The tag reference is
 *	then set to NULL;
 * Inputs: 
 *	tag 	- a pointer to an ID3v2 tag reference.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_free( gnid3_tag_ref *tag );

/*	gnid3_tie
 * Description: Ties a valid file handle to a tag.  If the tag is stored in 
 *		memory the file will not be affected untill a subsequent gnid3_write
 *		command is issued.  Otherwise any ID3v2.2 or ID3v2.3 tag will be
 *		immediately deleted from the the file.
 * Inputs: 
 *	tag 	- a pointer to an ID3v2 tag reference
 *	fh		- a valid file handle
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_tie (gnid3_tag_ref tag, gn_handle_t fh);


/*	gnid3_clear
 * Description: 
 *	Removes all frames from a tag.
 * Inputs: 
 *	tag 	- an ID3v2 tag reference
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */ 

gnex_error_t 
gnid3_clear(gnid3_tag_ref tag);

/*	gnid3_write
 * Description: 
 *	Commits all changes to the tag to disk.
 * Inputs: 
 *	tag 	- an ID3v2 tag reference.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */ 

gnex_error_t 
gnid3_write(gnid3_tag_ref tag );

/*	gnid3_render
 * Description: Render the tag to the specified buffer.  After rendering
 *		is complete *buf_sz is set to point to the number of bytes in
 *		written to the buffer.  A special case occurs if the destination 
 *		buffer is NULL. In this case buf_sz is set to the number 
 *		of bytes a rendered buffer would occupy and no actual render takes
 *		place.
 * Inputs: 
 *	tag 	- an ID3v2 tag reference
 *	buf	- a pointer to a buffer of unsigned characters or NULL
 *	buf_sz - a pointer to an unsigned integer
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_render(gnid3_tag_ref tag, gn_uchar_t *buf, gn_uint32_t *buf_sz);

/*	gnid3_remove_frame
 * Description: Removes a specified frame from the tag.
 * Inputs: 
 *	tag 	- an ID3v2 tag reference
 *	frame_id - the id of the frame to remove
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */ 

gnex_error_t 
gnid3_remove_frame(gnid3_tag_ref tag, gnid3_frameid_t frame_id);

/*	gnid3_get_frame
 * Description: Get the data field straight from the desired frame allocating
 *		space for the data buffer and setting *data_sz to reflect the number
 *		of bytes in the buffer.
 * Inputs: 
 *	tag 	- an ID3v2 tag reference
 *	frame_id - the id of the frame to retrieve.
 *	data - a pointer to an unsigned character pointer.
 *	data_sz - a pointer to a gn_size_t 
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */ 

gnex_error_t 
gnid3_get_frame( 
			gnid3_tag_ref tag, 
			gnid3_frameid_t frame_id, 
			gn_uchar_t **data, 
			gn_size_t *data_sz
			);

/*	gnid3_get_text_frame
 * Description: Get data from any text frame ie frames with id's that start 
 *		with `T' except from TXX(X). Allocates memory for *text and store 
 *		the UTF-8 encoded string in *text.
 * Inputs: 
 *	tag 	- an ID3v2 tag reference
 *	frame_id - the id of the frame to remove
 * Outputs:
 *	text - a pointer to an array of unsigned characters which will contain
 *		a null-terminated UTF-8 encoded string representing the data in the
 *		text frame.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_get_text_frame( 
			gnid3_tag_ref tag, 
			gnid3_frameid_t frame_id, 
			gn_uchar_t **text 
			);

/*	gnid3_get_link_frame
 * Description: 
 *	Get data from any link frame ie frames with id's that start 
 *	with `W' except for WXXX.  Allocates memory for *url and store the 
 *	URL (a US-ASCII string) in *text.
 * Inputs: 
 *	tag 	- an ID3v2 tag reference
 *	frame_id - the id of the frame to remove
 * Outputs:
 *	url - a pointer to an array of unsigned characters which will contain
 *		a null-terminated UTF-8 encoded string representing the data in the
 *		link frame.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */ 

gnex_error_t 
gnid3_get_link_frame( 
			gnid3_tag_ref tag, 
			gnid3_frameid_t frame_id, 
			gn_uchar_t* *url 
			);

/*	gnid3_remove_matching_ufid_frame
 * Description: 
 *	Removes a UFID frame that contains a matching url.
 * Inputs:
 *	tag 	- an ID3v2 tag reference
 * 	url 	- an ASCII string containing a URL.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_remove_matching_ufid_frame(gnid3_tag_ref tag,  const gn_uchar_t* url);

/*	gnid3_remove_matching_comment_frame
 * Description: 
 *	Removes a comment frame that contains a matching desc.
 * Inputs:
 *	tag 	- an ID3v2 tag reference
 * 	desc 	- a UTF-8 encoded string matching the description of the
 *			particular comment frame to remove.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_remove_matching_comment_frame(gnid3_tag_ref tag, const gn_uchar_t* desc);


/*	gnid3_remove_matching_unsynclyrics_frame
 * Description: 
 *	Removes an unsynchronized lyrics frame that contains a matching desc.
 * Inputs:
 *	tag 	- an ID3v2 tag reference
 * 	desc 	- a UTF-8 encoded string matching the description of the
 *			particular lyrics frame to remove.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_remove_matching_unsynclyrics_frame(gnid3_tag_ref tag, const gn_uchar_t* desc);


/*	gnid3_remove_matching_image_frame
 * Description: 
 *	Removes a image frame that contains a matching picturetype.
 * Inputs:
 *	tag 	- an ID3v2 tag reference
 * 	desc 	- a UTF-8 encoded string matching the description of the
 *			particular image descriptor to remove.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_remove_matching_image_frame(gnid3_tag_ref tag, const gn_uchar_t* desc);

/*	gnid3_remove_matching_custom_text_frame
 * Description: 
 *	Removes a custom text frame that contains a matching desc.
 * Inputs:
 *	tag 	- an ID3v2 tag reference
 * 	desc 	- a UTF-8 encoded string matching the description of the
 *			particular custom text frame to remove.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_remove_matching_custom_text_frame(
								gnid3_tag_ref tag, 
								const gn_uchar_t* desc
								);

/* 
 * Public stucture to retrieve information about the tag
 */

typedef struct gnid3_taginfo_s
{
	/* the size of the tag including the tag header as it would appear on the 
	 * disk, ie the size after any unsynchronization or compression takes 
	 * place
	 */
	gn_uint32_t tag_sz;

	/* ID3v2.`version' where `version' is either 2 or 3*/
	gn_uchar_t version;
	
	/* the amount of padding in the tag, ie the number of zero bytes included 
	 * in tag_sz that are not part of a frame or tag header
	 */
	gn_uint32_t padding_sz;

	/* equal to GN_TRUE if the tag is unsynchronized */
	gn_bool_t is_unsynced;

} gnid3_taginfo_t;

gnex_error_t 
gnid3_get_tag_info(gnid3_tag_ref tag, gnid3_taginfo_t *info);

/* 
 * Public structure to retrieve information about a frame
 */


typedef struct gnid3_frameinfo_s
{
	/* The size of the data field of the frame specified by frame_id.  
	 * Note this is the size reflects the size of the synchronized (resynchronized), 
	 * decompressed data field of the frame.
	 */
	
	gn_uint32_t frame_sz;

	/* Equal to GN_TRUE if the frame is compressed, otherwise equal to 
	 * GN_FALSE. 
	 */
	gn_bool_t is_compressed;

} gnid3_frameinfo_t;

gnex_error_t 
gnid3_get_frame_info(
				gnid3_tag_ref tag, 
				gnid3_frameid_t id, 
				gnid3_frameinfo_t *info
				);

/* ID3v2 Setters
 * The following functions are used to add or replace an existing frame.
 * The version of the frame written will depend on the version of the tag.
 */ 

/*	gnid3_set_frame
 * Description: 
 *	Assume user has correctly fromatted data and insert the 
 *	desired frame into the tag.  If the replace flag is set to true, 
 *	the function will delete the first frame found with a matching
 *	frame ID.
 * Inputs: 
 *	tag 		- an ID3v2 tag reference
 *	frame_id 	- the id of the frame to add
 *	data		- an array of unsigned characters to be written to the
 *	data_sz 	- the number of bytes to write to the data segment of
 *				the frame.
 *	strconv 	- the string conversion preference.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 *
 * Note: 
 *	That the format of data requires specific knowledge of 
 * 	particular ID3v2 format that tag is using.  In most cases,
 * 	helper functions detailed below, such as gnid3_set_comment_frame,
 * 	is much easier.
 */ 

gnex_error_t 
gnid3_set_frame(
			gnid3_tag_ref tag, 
			gnid3_frameid_t frame_id, 
			gn_uchar_t *data, 
			gn_uint32_t data_sz, 
			gn_bool_t replace
			);

/*  gnid3_set_text_frame
 * Description: 
 *	Insert the desired text frame into the tag, converting 
 *	the text from utf8 to the destination format according to the 
 *	sttrconv string conversion setting.  If the tag contains a frame
 *	with a identical frame_id, the frame will first be removed.
 * Inputs: 
 *	tag 		- an ID3v2 tag reference
 *	frame_id 	- the id of the frame to add
 *	text 		- a NULL terminated UTF-8 encoded string
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */ 

gnex_error_t 
gnid3_set_text_frame(
				gnid3_tag_ref tag, 
				gnid3_frameid_t frame_id, 
				gn_uchar_t * text 
				);

/*  gnid3_set_link_frame
 * Description: 
 *	Insert the desired link frame into the tag, converting 
 *	the text from utf8 to iso8859-1 format. If the tag contains a frame
 *	with a identical frame_id, the frame will first be removed.
 * Inputs: 
 *	tag 		- an ID3v2 tag reference
 *	frame_id 	- the id of the frame to add, must be a valid link frame type
 *	url 		- a NULL terminated UTF-8 encoded string
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */ 

gnex_error_t 
gnid3_set_link_frame(
				gnid3_tag_ref tag, 
				gnid3_frameid_t frame_id, 
				gn_uchar_t* url
				);

/*	gnid3_set_comment_frame
 * Description: 
 *	Adds a comment ID3 frame to a tag. If the language string is GN_NULL the 
 *	value "eng" (english language code) is specified.
 * 	If the description string is GN_NULL the description portion of the 
 *	comment frame will be left blank.	
 * Inputs:  	
 *	tag - an ID3v2 tag reference
 * 	language - a three letter ASCII string or GN_NULL.
 * 	desc	 - a UTF-8 encoded description string or GN_NULL.	        
 * 	title	 - a UTF-8 encoded string containing the text to add.
 * 	strconv - the desired destination format of the string
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 * 
 * Note:
 *		For maximum compatibility with most players, it is recommended that 
 *		the description string be left as GN_NULL.
 */
gnex_error_t
gnid3_set_comment_frame(
				gnid3_tag_ref tag, 
				const gn_uchar_t* language, 
				gn_uchar_t* description, 
				gn_uchar_t* comment 
				); 


/*	gnid3_set_image_frame                                                   
 * Description:                                                             
 *	Adds an image ID3 frame to a tag replacing an existing frame			
 *	if that frame has the same picture type.                            	
 * Inputs:                                                                    
 *	mimetype	 - UTF-8 encoded string describing the image format.  Must be 
 *				byte-wise equivalent to one of the following values:
 *				
 *				GNID3_MIME_IMAGE_JPEG
 *   			GNID3_MIME_IMAGE_PNG
 *   			GNID3_MIME_IMAGE_GIF
 *   			GNID3_MIME_IMAGE_BMP 	
 *                                       
 * 	pictype		- a single byte value describing picture type (see ID3v2       
 *     			APIC frame spec)
 *				The following values are recognised by a wide assortment of
 *				media players and are compatible over each ID3v2 version.
 *					0x00  Other
 *                 	0x03  Cover (front)
 *                 	0x04  Cover (back)                                                    
 * 	desc 		- a UTF-8 encoded description string or GN_NULL.               
 * 	data		- a pointer to image data                                      
 * 	data_sz		- size in bytes of data pointed to by data                     
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t
gnid3_set_image_frame(
					gnid3_tag_ref tag, 
					const gn_uchar_t* mimetype, 
					gn_uchar_t pictype, 
					const gn_uchar_t* desc, 
					gn_uchar_t* data, 
					gn_uint32_t data_sz
					);

/*	gnid3_set_ufid_frame
 * Description: 
 *	Adds a Gracenote ID (aka Unique File Identifier) ID3 frame to a
 *  tag.  This function will automatically replace a UFID frame whose URL 
 *  matches "url" with new data.
 * Inputs:
 *	tag 	- an ID3v2 tag reference
 * 	url 	- an ASCII string containing a URL where more information about
 * 			the ID can be found.
 * 	data 	- an array of unsigned characters containing the ID (usually a database
 * 			key) that can be used to find information about the file.
 * 	data_sz - the size, in bytes, of `data'.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_ufid_frame(gnid3_tag_ref tag, 
					 const gn_uchar_t* url, 
					 gn_uchar_t* data, 
					 gn_uint32_t data_sz);


/*	gnid3_set_unsynclyrics_frame
 * Description: 
 *	Sets a unsyncronized lyrics frame (USLT). This function will replace 
 *	an existing custom lyrics frame if found in the tag.
 * Inputs: 
 *	tag 	- an ID3v2 tag reference
 *	lang	- a three letter language code string or GN_NULL.
 * 	desc	- a UTF-8 encoded string which descibes the lyrics
 * 	text 	- a UTF-8 encoded string containing the lyric data to store to
 *			the frame.
 *	strconv - the string conversion preference.
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_unsynclyrics_frame(
					gnid3_tag_ref tag, 
					const gn_uchar_t*  lang,
					gn_uchar_t *desc, 
					gn_uchar_t *text
					);


/*	gnid3_set_custom_text_frame
 * Description: 
 *	Sets a user customizable text frame, uniquely identified by its 
 *	'desc' description string.  This function will replace an existing custom 
 *	text frame with a matching description if found in the tag.
 * Inputs: 
 *	tag 	- an ID3v2 tag reference
 * 	desc	- a UTF-8 encoded string which uiquely identifies this kind of 
 *			custom text frame.
 * 	text 	- a UTF-8 encoded string containing the text data to store to
 *			the frame.
 *	strconv - the string conversion preference.
 * Returns:	
 * 	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_set_custom_text_frame(
					gnid3_tag_ref tag, 
					gn_uchar_t *desc, 
					gn_uchar_t *text
					);

/*
 * The following functions replace an existing frame of the same type.
 */

/*	gnid3_set_title_frame
 * Description: 
 *	Sets a track title ID3 frame in the tag.
 * Inputs:
 *	tag 	- the tag to add the frame to.
 *	title	- a UTF-8 encoded string containing the text to add.
 *	strconv - the desired destination format of the string
 * Returns:	
 * 	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_title_frame(
					gnid3_tag_ref tag, 
					gn_uchar_t *title
					);

/*	gnid3_set_lead_performer_frame
 * Description: 
 *	Sets a artist ID3 frame in the tag.
 * Inputs:    	
 *	tag		- the tag to add the frame to.
 *	artist	- a UTF-8 encoded string containing the text to add.
 * 	strconv - the desired destination format of the string
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_lead_performer_frame(gnid3_tag_ref tag, 
							   gn_uchar_t *artist );

/*	gnid3_set_album_frame
 * Description: 
 *	Sets a album ID3 frame to a tag.
 * Inputs:	
 *	tag 	- the tag to add the frame to.
 *	album	- a UTF-8 encoded string containing the text to add.
 * 	strconv - the desired destination format of the string
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_album_frame(gnid3_tag_ref tag, 
					  gn_uchar_t *album );

/*	gnid3_set_release_year_frame
 * Description: 
 *	Sets a year ID3 frame to a tag.
 * Inputs:	
 *	tag 	- the tag to add the frame to.
 * 	year 	- an unsigned integer greater than or equal to 0 and less 
 *			than 10,000.
 * 	strconv - the desired destination format of the string
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_release_year_frame(
							gnid3_tag_ref tag, 
							gn_int32_t year
							); 

/*	gnid3_set_track_num_frame
 * Description: 
 *	Sets a track ID3 frame in the tag. If num_tracks is equal to 0 then the 
 *	number of tracks in the file are not written.
 * Inputs:	
 *	tag - the tag to add the frame to.
 * 	track	 	- an unsigned integer whose value is greater than or equal to 
 *				0 and less than 100.
 *	track_num	- an unsigned integer whose value is greater than or equal 
 *				to 0 and less than 100.
 * Returns:	
 * 	GNEX_SUCCESS upon success or an error.
 *
 * Note:
 * If either the track number or the number of tracks on the album is unknown,
 * the value 0 may be specified to indicate an unknown value.
 */
gnex_error_t 
gnid3_set_track_num_frame(
						gnid3_tag_ref tag, 
						gn_uint32_t track, 
						gn_uint32_t num_tracks
						); 

/*	gnid3_set_genre_frame
 * Description: 
 *	Sets a genre ID3 frame in the tag.
 * Inputs:        tag	 - the tag to add the frame to.
 * 		genre	 - a UTF-8 encoded string containing the text to add.
 * 		strconv - the desired destination format of the string
 * Returns:	
 *	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_genre_frame(gnid3_tag_ref tag, 
					  gn_uchar_t *genre ); 

/*	gnid3_set_composer_frame
 * Description: Sets a composer ID3 frame in the tag.
 * Args:        tag	 - the tag to add the frame to.
 * 		composer - a UTF-8 encoded string containing the name of the composer.
 * 		strconv - the desired destination format of the string
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_composer_frame(gnid3_tag_ref tag, 
						 gn_uchar_t *composer );

/*	gnid3_set_orchestra
 * Description: Sets a orchestra (aka band name) ID3 frame in the tag.
 * Args:        tag	 - the tag to add the frame to.
 * 		orchestra - a UTF-8 encoded string containing the name of the orchestra
 * 		strconv - the desired destination format of the string
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_orchestra_frame(gnid3_tag_ref tag, 
						  gn_uchar_t *orchestra );

/*	gnid3_set_conductor_frame
 * Description: Sets a conductor ID3 frame in the tag.
 * Args:        tag	 - the tag to add the frame to.
 * 		conductor - a UTF-8 encoded string containing the name of the conductor
 * 		strconv - the desired destination format of the string
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_conductor_frame(gnid3_tag_ref tag, 
						  gn_uchar_t *conductor );


/*	gnid3_set_original_release_year
 * Description: Sets a release year ID3 frame in the tag.
 * Args:        tag	 - the tag to add the frame to.
 * 		original_release_year - an integer containing the songs original 
 *			release year.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_original_release_year_frame(gnid3_tag_ref tag, 
									  gn_uint32_t original_release_year );

/*	gnid3_set_original_artist
 * Description: Sets a original artist ID3 frame in the tag.
 * Args:        tag	 - the tag to add the frame to.
 * 		original_artist - a UTF-8 encoded string containing the name of the 
 *			original artist.
 * 		strconv - the desired destination format of the string
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_original_artist_frame(gnid3_tag_ref tag, 
								gn_uchar_t *original_artist );

/* Description: Sets a encoder (aka "encoded by") ID3 frame in the tag.
 * Args:        tag	 - the tag to add the frame to.
 * 		encoder - a UTF-8 encoded string containing the name of the 
 *			software/hardware that encoded the mp3 file.
 * 		strconv - the desired destination format of the string
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_encoder_frame(gnid3_tag_ref tag, 
						gn_uchar_t *encoder );

/*	gnid3_set_publisher
 * Description: Sets a publisher ID3 frame (ie the name of the record label) to
 *		a tag.
 * Args:        tag	 - the tag to add the frame to.
 * 		publisher - a UTF-8 encoded string containing the name of the original
 *			artist.
 * 		strconv - the desired destination format of the string
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_publisher_frame(gnid3_tag_ref tag, 
						  gn_uchar_t *publisher );

/*	gnid3_set_part_of_set
 * Description: Sets a part of set ID3 frame in the tag.
 * Args:        tag	 - the tag to add the frame to.
 * 		diskNo	- an unsigned integer containing the disk number of the song 
 *			if the album that song came from is part of a set.
 * 		disksInSet - an unsigned integer either containing the total number of 
 *			disks in the set or containing the value 0 if the number of disks 
 *			in the set is unknown.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_part_of_set_frame(gnid3_tag_ref tag, 
							gn_uint32_t diskNo, 
							gn_uint32_t disksInSet);

/*	gnid3_set_isrc
 * Description: Sets a ISRC (International Standard Recording Code) ID3 frame in the tag.
 * Args:    tag	 - the tag to add the frame to.
 * 		isrc 	 - a null terminated pointer to a string of 12 unsigned chars 
 *			containing a ISRC.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_isrc_frame(gnid3_tag_ref tag, gn_uchar_t *isrc);

/*	gnid3_set_bpm
 * Description: Sets a BPM (Beats Per Minute) ID3 frame in the tag.
 * Args:        tag	 - the tag to add the frame to.
 * 		bpm - an unsigned integer containing the number of beats per minute of the mp3 file.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_set_bpm_frame(gnid3_tag_ref tag, gn_uint32_t bpm);

/*	Get a frame from a ID3 tag
 * The following function retrieve the requested information from an ID3 tag. Each 
 */ 

/*	gnid3_get_title
 * Description: Gets a title ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		title	- a pointer to an UTF-8 encoded string that will contain song title.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_title_frame(gnid3_tag_ref tag, gn_uchar_t** track); 

/*	gnid3_get_lead_performer
 * Description: Gets an artist ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		artist	- a pointer to an UTF-8 encoded string that will contain the artist name.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_lead_performer_frame(gnid3_tag_ref tag, gn_uchar_t** artist); 

/*	gnid3_get_album
 * Description: Gets a album ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		album	- a pointer to an UTF-8 encoded string that will contain the album name.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_album_frame(gnid3_tag_ref tag, gn_uchar_t** album); 

/*	gnid3_get_release_year
 * Description: Gets a year ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		year	- a pointer to an integer that will contain the release year.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_release_year_frame(gnid3_tag_ref tag, gn_int32_t *year); 

/*	gnid3_get_custom_text_frame
 * Description: Retrieves a custom text data whose description matches desc.
 *		The behavior of this function depends on the value of desc and index.
 *
 *		If desc is non-NULL the function will search for a custom text frame
 *		with a matching description.  If desc is NULL the fuction will match
 *		any description.
 *
 *		The value of the 'index' paramater specifies which text frame match to
 *		retrieve.  A value of 0 represents the first match, a value of 1 
 *		represents the second match and so on.  If no match is found for the
 *		specified index, GNEX_ID3ERR_NotFound is returned.
 *
 * Args:	tag 	- the tag to get the frame from.
 * 		desc- a pointer to a unsigned string of characters or GN_NULL.
 * 		text- a pointer to an unsigned character string.
 *		index - the index of the custom test frame to retrieve.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result: Upon successfull termination a a UTF-8 encoded text field is 
 *		allocated and pointed to by *text.  A null terminated string 
 *		representing the description may be allocated and *desc points to it.
 */

gnex_error_t 
gnid3_get_custom_text_frame(gnid3_tag_ref tag, 
							gn_uchar_t **desc, 
							gn_uchar_t **text, 
							gn_uint32_t index);



/*	gnid3_get_custom_link_frame
 * Description: Retrieves a custom link url whose description matches desc.
 *		The behavior of this function depends on the value of desc and index.
 *
 *		If desc is non-NULL the function will search for a custom link frame
 *		with a matching description.  If desc is NULL the fuction will match
 *		any description.
 *
 *		The value of the 'index' paramater specifies which text frame match to
 *		retrieve.  A value of 0 represents the first match, a value of 1 
 *		represents the second match and so on.  If no match is found for the
 *		specified index, GNEX_ID3ERR_NotFound is returned.
 *
 * Args:	tag 	- the tag to get the frame from.
 * 		desc- a pointer to a unsigned string of characters or GN_NULL.
 * 		url - a pointer to an unsigned character string.
 *		index - the index of the custom test frame to retrieve.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result: Upon successfull termination a a UTF-8 encoded text field is 
 *		allocated and pointed to by *text.  A null terminated string 
 *		representing the description may be allocated and *desc points to it.
 */

gnex_error_t 
gnid3_get_custom_link_frame(gnid3_tag_ref tag, 
							gn_uchar_t **desc, 
							gn_uchar_t **url, 
							gn_uint32_t index);



/*	gnid3_get_comment_frame
 * Description: Gets the index'th (0 based) comment ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		language- a pointer to a gn_uchar_t* that will contain the language code string.
 * 		desc 	- a pointer to an UTF-8 encoded string that will contain the description of the comment.
 * 		comment - a pointer to an  UTF-8 encoded string that will contain the comment body.
 *		index   - index of comment in tag since multiple comments are allowed (0 based)
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A null terminated string representing the 3 byte language code of the comment is allocated.  
 * 		Additionally, UTF-8 strings are allocated for description and comment, or an error is returned.
 * Note: The client should never assume that description is non-NULL after a call to gnid3_get_comment_frame. 
 *		It is possible for a valid comment frame to have an empty description field and if this is the case,
 *		*description is set to NULL.
 */
gnex_error_t 
gnid3_get_comment_frame(gnid3_tag_ref tag, 
						gn_uchar_t* *language, 
						gn_uchar_t** description, 
						gn_uchar_t** comment,
						gn_uint32_t index); 

/*	gnid3_get_image_frame
* Description: Gets an image ID3 frame from the tag. replacing an existing frame if that frame has the same
* 		picture type. 
* ARGS: 	mimetype - a ISO-8859-1 encoded mimetype string such as 'image/jpeg' or 'image/png'.
* 		pictype	 - a single byte value describing picture type (see ID3v2 APIC frame spec)
* 		desc	 - a UTF-8 encoded description string or GN_NULL.		
* 		data	 - a pointer to image data
* 		data_sz	 - size in bytes of data pointed to by data
 *		index	 - index of image in tag since multiple images are allowed (0 based)
* Returns:	GNEX_SUCCESS upon success or an error.
* 
 */
gnex_error_t
gnid3_get_image_frame(gnid3_tag_ref tag, 
					  gn_uchar_t** mimetype, 
					  gn_uchar_t* pictype, 
					  gn_uchar_t** desc, 
					  gn_uchar_t** data, 
					  gn_uint32_t* data_sz,
					  gn_uint32_t index);

/*	gnid3_get_track_num_frame
 * Description: Gets the track numbers from ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		track	- a pointer to a unsigned integer that will contain the track number.
 * 		num_tracks- a pointer to an unsigned integer that will contain the number of tracks on the original disk.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	The requested data is asigned to *track and *num_tracks or an error is returned
 */
gnex_error_t 
gnid3_get_track_num_frame(gnid3_tag_ref tag, 
						  gn_uint32_t *track, 
						  gn_uint32_t *num_tracks); 

/*	gnid3_get_genre_frame
 * Description: Gets a genre ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		genre	- a pointer to an UTF-8 encoded string that will contain the song genre.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_genre_frame(gnid3_tag_ref tag, gn_uchar_t **genre); 


/*	gnid3_get_matching_ufid_frame 
 * Description: Gets the first UFID frame (the ID3 frame that stores a Gracenote
 *              TAGID) whose URL matches "url".
 * Args: tag 	- the tag to get the frame from.
 *	 	url	- a string containing a http URL to a web page where information about the UFID can be found.	
 *		UFID 	- a pointer to an UTF-8 encoded string that will contain the song genre.
 * 		UFID_sz - a pointer to a unisigned integer that will containt the size (in bytes) of the
 * 			UFID.	
 * Returns:	GNEX_SUCCESS upon success or an error.
 *
 */

gnex_error_t 
gnid3_get_matching_ufid_frame(gnid3_tag_ref tag, 
							  const gn_uchar_t* url, 
							  gn_uchar_t **id, 
							  gn_uint32_t *id_sz
							  );

/*	gnid3_get_unsynclyrics_frame
 * Description: Sets a unsyncronized lyrics frame (USLT). This function will replace 
 *				an existing custom lyrics frame if found in the tag.
 * Args: tag 	- an ID3v2 tag reference
 *		lang	- a three letter language code string or GN_NULL.
 * 		desc	- a UTF-8 encoded string which descibes the lyrics
 * 		text 	- a UTF-8 encoded string containing the lyric data to store to
 *					the frame.
 *		index   - index of lyric in tag since multiple lyrics are allowed (0 based)
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_get_unsynclyrics_frame(gnid3_tag_ref tag, 
						gn_uchar_t* *language, 
						gn_uchar_t** description, 
						gn_uchar_t** text,
						gn_uint32_t index); 


/*	gnid3_get_composer_frame
 * Description: Gets the composer ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		composer 	- a pointer to an UTF-8 encoded string that will contain the song's composer.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_get_composer_frame(gnid3_tag_ref tag, gn_uchar_t **composer);

/*	gnid3_get_orchestra_frame
 * Description: Gets the orchestra ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		orchestra 	- a pointer to an UTF-8 encoded string that will contain the orchestra.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_orchestra_frame(gnid3_tag_ref tag, gn_uchar_t **orchestra);

/*	gnid3_get_conductor_frame
 * Description: Gets the conductor ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		conductor - a pointer to an UTF-8 encoded string that will contain the conductor. 
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_get_conductor_frame(gnid3_tag_ref tag, gn_uchar_t **conductor);

/*	gnid3_get_original_release_year_frame
 * Description: Gets the original release year ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		original_release_year 	- a pointer to an UTF-8 encoded string that will contain the
 * 					original release year of the song.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_original_release_year_frame(gnid3_tag_ref tag, 
									  gn_uint32_t *original_release_year);

/*	gnid3_get_original_artist_frame
 * Description: Gets the original artist frame ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		original_artist - a pointer to an UTF-8 encoded string that will contain the original
 * 				artist name.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_original_artist_frame(gnid3_tag_ref tag, 
								gn_uchar_t **original_artist);

/*	gnid3_get_encoder_frame
 * Description: Gets the encoder ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		encoder	- a pointer to an UTF-8 encoded string that will contain the "encoded by" frame
 * 			ie the name of the encoding software/hardware used to encode the file.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_encoder_frame(gnid3_tag_ref tag, gn_uchar_t **encoder);

/*	gnid3_get_publisher_frame
 * Description: Gets the publisher ID3 frame from a tag.  
 * Args:	tag 	- the tag to get the frame from.
 * 		publisher - a pointer to an UTF-8 encoded string that will contain the publisher
 * 			aka record label of the song. 
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_publisher_frame(gnid3_tag_ref tag, gn_uchar_t **publisher);

/*	gnid3_get_part_of_set_frame
 * Description: Gets the part of set ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		diskNo	- a pointer to an integer containing the disk number of the song if the album that song
 * 			came from is part of a set.
 * 		disksInSet - (optional) a pointer to an integer containing the total number of disks in the set
 * 			or a pointer to integer containing the value 0 if no such field exists in the frame.
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_part_of_set_frame(gnid3_tag_ref tag, 
							gn_uint32_t *diskNo, 
							gn_uint32_t *disksInSet);

/*	gnid3_get_isrc_frame
 * Description: Gets the ISRC ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		isrc 	- a pointer to an array of unsigned bytes that will contain the 8 byte 
 * 			ISRC (Internation Standard Recording Code).
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A null terminated array of unsigned chars is allocated or an error
 *		is returned.
 */
gnex_error_t 
gnid3_get_isrc_frame(gnid3_tag_ref tag, gn_uchar_t **isrc);

/*	gnid3_get_bpm_frame
 * Description: Gets the Bits Per Minute ID3 frame from a tag.
 * Args:	tag 	- the tag to get the frame from.
 * 		bpm 	- a pointer to an integer contain the BPM (beats per minute of the MP3 file containing this tag. 
 * Returns:	GNEX_SUCCESS upon success or an error.
 * Result:	A UTF-8 string is allocated or an error is returned.
 */
gnex_error_t 
gnid3_get_bpm_frame(gnid3_tag_ref tag, gn_uint32_t *bpm);
 
 /*	Delete a frame from an ID3 tag
 * The following functions delete the specified ID3 frame frame. Certain functions also will delete a
 * ID3v1 frame, if present, as well as the ID3v2 frame.  If so the function summary will indicate this
 * by a `Yes.' in the ID3v1 field.
 */ 

/*	gnid3_remove_title_frame
 * Description: Deletes the song title ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_title_frame(gnid3_tag_ref tag);

/*	gnid3_remove_lead_performer_frame
 * Description: Deletes the artist ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_lead_performer_frame(gnid3_tag_ref tag);

/*	gnid3_remove_album_frame
 * Description: Deletes the album ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_album_frame(gnid3_tag_ref tag);

/*	gnid3_remove_release_year_frame
 * Description: Deletes the year ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_release_year_frame(gnid3_tag_ref tag); 

/*	gnid3_remove_comment_frame
 * Description: Deletes the comment ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t
gnid3_remove_comment_frame(gnid3_tag_ref tag); 

/*	gnid3_remove_track_num_frame
 * Description: Deletes the track number ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t
gnid3_remove_track_num_frame(gnid3_tag_ref tag);

/*	gnid3_remove_genre_frame
 * Description: Deletes the genre ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_genre_frame(gnid3_tag_ref tag);

/*	gnid3_remove_ufid_frame
 * Description: Deletes the Gracenote ID (aka Unique File Identifier) ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t
gnid3_remove_ufid_frame(gnid3_tag_ref tag);

/*	gnid3_remove_unsynclyrics_frame
 * Description: Deletes the unsynchronized lyrics (USLT) ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t
gnid3_remove_unsynclyrics_frame(gnid3_tag_ref tag);

/*	gnid3_remove_composer_frame
 * Description: Deletes the composer ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_composer_frame(gnid3_tag_ref tag);

/*	gnid3_remove_orchestra_frame
 * Description: Deletes the orchestra aka the band ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_orchestra_frame(gnid3_tag_ref tag);

/*	gnid3_remove_conductor_frame
 * Description: Deletes the conductor ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_conductor_frame(gnid3_tag_ref tag);

/*	gnid3_remove_original_release_year_frame
 * Description: Deletes the original release year ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_original_release_year_frame( gnid3_tag_ref tag);

/*	gnid3_remove_original_artist_frame
 * Description: Deletes the original artist ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_original_artist_frame(gnid3_tag_ref tag);

/*	gnid3_remove_encoder_frame
 * Description: Deletes the encoder aka the "EncodedBy" ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_encoder_frame(gnid3_tag_ref tag);

/*	gnid3_remove_publisher_frame
 * Description: Deletes the publisher aka the record label ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_publisher_frame(gnid3_tag_ref tag);

/*	gnid3_remove_composer_frame
 * Description: Deletes the composer ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_part_of_set_frame(gnid3_tag_ref tag);

/*	gnid3_remove_isrc_frame
 * Description: Deletes the ISRC (Internation Standard Recording Code) frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_isrc_frame(gnid3_tag_ref tag);

/*	gnid3_remove_bpm_frame
 * Description: Deletes the BPM (Beats Per Minute) ID3 frame from a file.
 * Args:	tag - the tag to delete the frame from.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_remove_bpm_frame(gnid3_tag_ref tag);


/*ID3v1 Functions*/
typedef struct gnid3_v1_tag_s {
	/*holds a memory address internal to gnid3_id3v1.c to verify the tag has been properly created*/
	const gn_uchar_t* _id;
	/*holds the ID3v1.x tag as it would appear in the file*/
	gn_uchar_t* buf;
	/*points to the mp3 file*/
	gn_handle_t handle;	
	/*specifies whether to convert strings to/from iso8859-1 or the local code page*/
	gn_bool_t	use_local;

} gnid3_v1_tag_t;

typedef gnid3_v1_tag_t* gnid3_v1_tag_ref;

/* ID3v1 specific funcitons*/
gnex_error_t 
gnid3_id3v1_genre_to_index(gn_uchar_t* genre, gn_int32_t* index);

gnex_error_t 
gnid3_id3v1_index_to_genre(gn_int32_t index, gn_uchar_t* *genre);


gnex_error_t 
gnid3_v1_create(gnid3_v1_tag_ref* v1tag, gn_bool_t use_local);

gnex_error_t 
gnid3_v1_load(gn_handle_t handle, gnid3_v1_tag_ref* v1tag, gn_bool_t use_local);

gnex_error_t 
gnid3_v1_tie(gnid3_v1_tag_ref tag, gn_handle_t fh);

gnex_error_t 
gnid3_v1_untie(gnid3_v1_tag_ref tag);

gnex_error_t 
gnid3_v1_clear(gnid3_v1_tag_ref tag);

gnex_error_t 
gnid3_v1_write(gnid3_v1_tag_ref v1tag);

gnex_error_t 
gnid3_v1_free(gnid3_v1_tag_ref* v1tag);

gnex_error_t 
gnid3_v1_render(gnid3_v1_tag_ref tag, gn_uchar_t *buf, gn_uint32_t *buf_sz);

gnex_error_t 
gnid3_v1_set_title(gnid3_v1_tag_ref tag, gn_uchar_t *title);

gnex_error_t 
gnid3_v1_set_lead_performer(gnid3_v1_tag_ref tag, gn_uchar_t *artist);

gnex_error_t 
gnid3_v1_set_album(gnid3_v1_tag_ref tag, gn_uchar_t *album);

gnex_error_t 
gnid3_v1_set_release_year(gnid3_v1_tag_ref tag, gn_int32_t year);

/*
 * Note: 
 *	overwrite is set to GN_TRUE and the number of ISO-8859-1 encoded octets is greater than 28 any information stored in the ID3v1 track field will be overwritten. 		 
 */

gnex_error_t 
gnid3_v1_set_comment(gnid3_v1_tag_ref tag, 
					 gn_uchar_t *comment, 
					 gn_bool_t overwrite);

gnex_error_t 
gnid3_v1_set_track_num(gnid3_v1_tag_ref tag, gn_int32_t track, gn_bool_t overwrite);

gnex_error_t 
gnid3_v1_set_genre(gnid3_v1_tag_ref tag, gn_int32_t genre);

gnex_error_t 
gnid3_v1_get_title(gnid3_v1_tag_ref tag, gn_uchar_t **title);

gnex_error_t 
gnid3_v1_get_lead_performer(gnid3_v1_tag_ref tag, gn_uchar_t **artist);

gnex_error_t 
gnid3_v1_get_album(gnid3_v1_tag_ref tag, gn_uchar_t **album);

gnex_error_t 
gnid3_v1_get_release_year(gnid3_v1_tag_ref tag, gn_int32_t *year);

gnex_error_t 
gnid3_v1_get_comment(gnid3_v1_tag_ref tag, gn_uchar_t **comment);

gnex_error_t 
gnid3_v1_get_track_num(gnid3_v1_tag_ref tag, gn_int32_t *track);

gnex_error_t 
gnid3_v1_get_genre(gnid3_v1_tag_ref tag, gn_int32_t *genre);

gnex_error_t 
gnid3_v1_remove_title(gnid3_v1_tag_ref tag);

gnex_error_t 
gnid3_v1_remove_lead_performer(gnid3_v1_tag_ref tag);

gnex_error_t 
gnid3_v1_remove_album(gnid3_v1_tag_ref tag);

gnex_error_t 
gnid3_v1_remove_release_year(gnid3_v1_tag_ref tag);

gnex_error_t 
gnid3_v1_remove_comment(gnid3_v1_tag_ref tag);

gnex_error_t 
gnid3_v1_remove_track_num(gnid3_v1_tag_ref tag);

gnex_error_t 
gnid3_v1_remove_genre(gnid3_v1_tag_ref tag);

gnex_error_t 
gnid3_convert_v1_to_v2(gnid3_v1_tag_ref srcTag, 
					   gnid3_tag_ref dstTag);

/*  gnid3_convert_v2_to_v1
 * Description: Converts the source ID3v2.2 or ID3v2.3 tag to a destination
 *			ID3v1 tag, creating the destination tag.  The dstTag will be 
 *			created entirely in-memory, meaning it will not be bound to any 
 *			file. The dstTag will be encoded in IS0-Latin-1.  
 *
 *			If id3v11 is set to GN_TRUE, dstTag will be an ID3v1.1 tag, meaning 
 *			it will preserve space for a track number in the last 3 bytes of 
 *			the comment field.  Also, if ID3v2.X tag contains a track number 
 *			frame, this value with be stored in the ID3v1.1 track field.
 *
 *			After successfull, termination of the function, *frames_converted
 *			will be set to the number of ID3v2.X frames successfully converted
 *			to ID3v1.  This is especially usefull when not operating in strict
 *			mode, whereby it is possible for the function to report success
 *			when no frames have been successfully converted to ID3v1.
 *			
 * Args:	srcTag - a GNID3 v1 tag reference to the source ID3v2.X tag
 *			dstTag - a pointer to a GNID3 v2 tag refrence to be created
 *			strict - a boolean value indicating whether to operated in strict
 *					mode.
 *			id3v11 - a boolean vaule indicating wether or not to write a 
 *					ID3v1.1 tag.
 *			frames_converted - the number of frames converted upon successfull
 *					termination of the function.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */

gnex_error_t 
gnid3_convert_v2_to_v1(gnid3_tag_ref srcTag, 
								  gnid3_v1_tag_ref dstTag, 
								  gn_bool_t strict, 
								  gn_bool_t id3v11, 
								  gn_uint32_t *frames_converted);


/*Conversion Routines between ID3v2.3 and ID3v2.2*/

/*  gnid3_convert_tag_2r2_to_2r3
 * Description: Converts the source ID3v2.2 tag to an ID3v2.3 tag, 
 *			creating the ID3v2.3 tag.  The dstTag will be created entirely
 *			in-memory, meaning it will not be bound to any file.
 *
 *			If operating in strict mode the command will fail if either the
 *			srcTag has flags set in its tag or frame headers that are not
 *			supported in ID3v2.3.  In strict mode the the function will also
 *			fail if the scrTag contains frames which are not supported in 
 *			ID3v2.3.  If not operating in strict mode, the function will
 *			discard any flags and or frames not supported in the ID3v2.3
 *			standard.
 *			
 * Args:	srcTag - a GNID3 tag reference to the source ID3v2.2 tag.
 *			dstTag - a pointer to a GNID3 tag refrence to be created
 *			strict - a boolean value indicating whether to operated in strict
 *					mode.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_convert_tag_2r2_to_2r3(gnid3_tag_ref srcTag, 
										gnid3_tag_ref *dstTag, 
										gn_bool_t strict);

/*  gnid3_convert_tag_2r3_to_2r2
 * Description: Converts the source ID3v2.3 tag to an ID3v2.2 tag,
 *			creating the ID3v2.3 tag.  The dstTag will be created entirely
 *			in-memory, meaning it will not be bound to any file.
 *
 *			If operating in strict mode the command will fail if either the
 *			srcTag has flags set in its tag or frame headers that are not
 *			supported in ID3v2.2.  In strict mode the the function will also
 *			fail if the scrTag contains frames which are not supported in 
 *			ID3v2.2 or if the frame is to large to conform to the ID3v2.2.  
 *			If not operating in strict mode, the function will discard any 
 *			flags and or frames not supported in the ID3v2.2 standard.
 *
 * Args:	srcTag - a GNID3 tag reference to the source ID3v2.3 tag.
 *			dstTag - a pointer to a GNID3 tag refrence to be created
 *			strict - a boolean value indicating whether to operated in strict
 *					mode.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_convert_tag_2r3_to_2r2(gnid3_tag_ref srcTag, 
							 gnid3_tag_ref *dstTag, 
							 gn_bool_t strict);


/*Conversion Routines between ID3v2.3 and ID3v2.3 */

/*  gnid3_convert_tag_2r3_to_2r4
 * Description: Converts the source ID3v2.3 tag to an ID3v2.4 tag, 
 *			creating the ID3v2.4 tag.  The dstTag will be created entirely
 *			in-memory, meaning it will not be bound to any file.
 *
 *			If operating in strict mode the command will fail if either the
 *			srcTag has flags set in its tag or frame headers that are not
 *			supported in ID3v2.3.  In strict mode the the function will also
 *			fail if the scrTag contains frames which are not supported in 
 *			ID3v2.3.  If not operating in strict mode, the function will
 *			discard any flags and or frames not supported in the ID3v2.3
 *			standard.
 *			
 * Args:	srcTag - a GNID3 tag reference to the source ID3v2.3 tag.
 *			dstTag - a pointer to a GNID3 tag refrence to be created
 *			strict - a boolean value indicating whether to operated in strict
 *					mode.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_convert_tag_2r3_to_2r4(gnid3_tag_ref srcTag, 
										gnid3_tag_ref *dstTag, 
										gn_bool_t strict);

/*  gnid3_convert_tag_2r4_to_2r3
 * Description: Converts the source ID3v2.4 tag to an ID3v2.3 tag,
 *			creating the ID3v2.3 tag.  The dstTag will be created entirely
 *			in-memory, meaning it will not be bound to any file.
 *
 *			If operating in strict mode the command will fail if either the
 *			srcTag has flags set in its tag or frame headers that are not
 *			supported in ID3v2.3.  In strict mode the the function will also
 *			fail if the scrTag contains frames which are not supported in 
 *			ID3v2.3 or if the frame is to large to conform to the ID3v2.2.  
 *			If not operating in strict mode, the function will discard any 
 *			flags and or frames not supported in the ID3v2.2 standard.
 *
 * Args:	srcTag - a GNID3 tag reference to the source ID3v2.4 tag.
 *			dstTag - a pointer to a GNID3 tag refrence to be created
 *			strict - a boolean value indicating whether to operated in strict
 *					mode.
 * Returns:	GNEX_SUCCESS upon success or an error.
 */
gnex_error_t 
gnid3_convert_tag_2r4_to_2r3(gnid3_tag_ref srcTag, 
							 gnid3_tag_ref *dstTag, 
							 gn_bool_t strict);



/* Deprecated Functions */

/*	gnid3_get_ufid_frame (DEPRECATED)
 * Description: Gets the first Gracenote ID (aka Unique File Identifier) ID3 frame 
 * from a tag.
 * Args:	tag 	- the tag to get the frame from.
 *	 	url	- a pointer to a string containing a http URL to a web page where information
 * 			about the UFID can be found.	
 *		UFID 	- a pointer to an UTF-8 encoded string that will contain the song genre.
 * 		UFID_sz - a pointer to a unisigned integer that will containt the size (in bytes) of the
 * 			UFID.	
 * Returns:	GNEX_SUCCESS upon success or an error.
 *
 * NOTE: Developers should use gnid3_get_matching_ufid_frame instead of this function
 */
gnex_error_t 
gnid3_get_ufid_frame(gnid3_tag_ref tag, 
					 gn_uchar_t* *url, 
					 gn_uchar_t **id, 
					 gn_uint32_t *id_sz);



#ifdef __cplusplus
}
#endif 

#endif /*_GN_ID3_H_*/
