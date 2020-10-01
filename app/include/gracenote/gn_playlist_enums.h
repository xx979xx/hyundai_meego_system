/*
 * gn_playlist_enums.h Copyright (C) 2005 Gracenote, Inc. All Rights Reserved.
 *
 *
 * This file is published to 3rd party developers for playlist generation management constants and enums.
 */
#ifndef __CddbPlaylist2_h__ /* hack to avoid type redefinitions from this file and CDDBPlaylist.h */
#ifndef __CDDBPLAYLIST2Lib_LIBRARY_DEFINED__

#ifndef __CDDB_PlaylistEnums_H__
#define __CDDB_PlaylistEnums_H__


/*
 *	Some compilers have trouble with enums, but we require them for the Windows
 *	COM implementation.  Therefore, when defining new fields you must provide
 *	both flavors: #define and enum.
 */

/*
 * We have to include gn_defines.h below this define, because we don't want PC SDK to include it.
 * For all device builds of the cedev code, this is not an issue, because
 * GN_EPLAYLIST_USE_ENUMS is never defined.
 * For PC SDK to build properly, all cedev code must know that GN_EPLAYLIST_USE_ENUMS is defined,
 * so any file that include gn_playlist_enums.h must first include gn_defines.h.
 */

#if !defined(GN_EPLAYLIST_USE_ENUMS)

#include "gn_defines.h"		/* needed for the gn_uint16_t and gn_uint32_t types */

/*
 *	Fields
 *
 *	Fields allowed for criteria (and DB access)
 */


/*
 *	gnpl_crit_field_t is used in criteria structures when creating criteria for a playlist generator
 *
 *
 *	----- Note ----- Note ----- Note ----- Note ----- Note ----- Note ----- Note ----- Note -----
 *
 *	The numerical order ane names of these field definitions must never change because the
 *	PC SDK employs a Windows COM object that depends on old field numbers never changing.
 *	All new fields must be added to the end.
 *
 *	----- Note ----- Note ----- Note ----- Note ----- Note ----- Note ----- Note ----- Note -----
 *
 *	Also note that these field definitions must map one-to-one with gn_pl_field_enum_mapping in gn_playlist_plgen_xml.c.
 */
typedef gn_uint16_t										gnpl_crit_field_t;

/*	Fields marked INTERNAL are not available for use by the developer.
 *	All others are available for public use.
 */
#define gnpl_crit_field_first              			0	/* INTERNAL - placeholder used internally */

#define gnpl_crit_field_file_name          			1	/* Indexed	Name of physical file on disk					gnpl_crit_field_type_string		*/
#define gnpl_crit_field_file_size          			2	/*			File size, in kilobytes							gnpl_crit_field_type_num		*/
#define gnpl_crit_field_file_length        			3	/*			File length, in seconds							gnpl_crit_field_type_num		*/
#define gnpl_crit_field_file_created_date  			4	/* Indexed	Date track was added to MLDB					gnpl_crit_field_type_date		*/
#define gnpl_crit_field_file_modified_date 			5	/*			Date entry was last changed						gnpl_crit_field_type_date		*/
#define gnpl_crit_field_file_lastplayed_date 		6	/* Indexed	Date playcount was incremented					gnpl_crit_field_type_date		*/
#define gnpl_crit_field_file_bitrate       			7	/*			Bitrate of file in kbps							gnpl_crit_field_type_num		*/
#define gnpl_crit_field_file_codec_format       	8	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_file_drm					9	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_track_name         			10	/*			Track title name								gnpl_crit_field_type_string		*/
#define gnpl_crit_field_track_sort_name    			11	/*			Developer defined track sorting title			gnpl_crit_field_type_string		*/
#define gnpl_crit_field_track_artist_name  			12	/*			Track artist name								gnpl_crit_field_type_string		*/
#define gnpl_crit_field_track_artist_sortname		13	/*			Developer defined artist sorting name			gnpl_crit_field_type_string		*/
#define gnpl_crit_field_track_releaseyear  			14	/* Indexed	Original release year of track					gnpl_crit_field_type_num		*/
#define gnpl_crit_field_track_langid      			15	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_track_bpm          			16	/* Indexed	Track's beats per minute						gnpl_crit_field_type_num		*/
#define gnpl_crit_field_track_num          			17	/*			Track sequence number on the CD					gnpl_crit_field_type_num		*/
#define gnpl_crit_field_track_genre        			18	/*			Enumerated id from version 1 genre list			gnpl_crit_field_type_enum
														 *			Deprecated - v2 genre should be used											*/
#define gnpl_crit_field_track_genrev2      			19	/* Indexed	Enumerated id from version 2 genre list			gnpl_crit_field_type_enum
														 *			Interpolated from version 1 genre if only v1 is available.						*/
#define gnpl_crit_field_track_mood         			20	/*			PROTECTED - array of mood descriptors			gnpl_crit_field_type_key_ivalue_array */
#define gnpl_crit_field_track_tempo      			21	/*			PROTECTED - array of tempo descriptors			gnpl_crit_field_type_key_ivalue_array */
#define gnpl_crit_field_track_album_pop				22	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_track_global_pop			23	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_album_name         			24	/*			Album Name										gnpl_crit_field_type_string		*/
#define gnpl_crit_field_album_sortname     			25	/*			Developer defined album sorting name			gnpl_crit_field_type_string		*/
#define gnpl_crit_field_album_primaryartist			26	/*			UNSUPPORTED										gnpl_crit_field_type_string		*/
#define gnpl_crit_field_album_releaseyear  			27	/*			Album release year								gnpl_crit_field_type_num		*/
#define gnpl_crit_field_album_label        			28	/*			Album label										gnpl_crit_field_type_string		*/
#define gnpl_crit_field_album_compilation  			29	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_album_region       			30	/*			Enumerated id from origins list					gnpl_crit_field_type_enum
														 *			Same as gnpl_crit_field_artist_region as far as the SDK is concerned.			*/
#define gnpl_crit_field_album_genre        			31	/*			Enumerated id from version 1 genre list			gnpl_crit_field_type_enum
														 *			Deprecated - v2 genre should be used											*/
#define gnpl_crit_field_album_genrev2      			32	/*			Enumerated id from version 2 genre list			gnpl_crit_field_type_enum		*/
#define gnpl_crit_field_album_pop       			33	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_artist_region      			34	/* Indexed	Enumerated id from origins list					gnpl_crit_field_type_enum		*/
#define gnpl_crit_field_artist_era         			35	/* Indexed	Enumerated id from era list						gnpl_crit_field_type_enum		*/
#define gnpl_crit_field_artist_type        			36	/* Indexed	Enumerated id from artist type list				gnpl_crit_field_type_enum		*/
#define gnpl_crit_field_track_local_pop    			37	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_artist_local_pop   			38	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_track_playcount    			39	/* Indexed	Number of times play count has been incremented	gnpl_crit_field_type_num		*/
#define gnpl_crit_field_track_myrating     			40	/* Indexed	User track rating. Scale of 0-100 (internally)	gnpl_crit_field_type_num		*/
#define gnpl_crit_field_album_myrating    			41	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_artist_myrating    			42	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_genre_myrating    			43	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_playlist_myrating 			44	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_xdev1              			45	/*			developer defined field 1 - can hold any type of data	gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_xdev2              			46	/*			developer defined field 2 - can hold any type of data	gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_xdev3              			47	/*			developer defined field 3 - can hold any type of data	gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_xdev						48  /* INTERNAL	Used internally for the "infinite" developer fields		gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_tagid						49	/*			Gracenote tagid for the file							gnpl_crit_field_type_string		*/
#define gnpl_crit_field_path_name					50	/*			Path of the file										gnpl_crit_field_type_string		*/
#define gnpl_crit_field_genredesc					51	/*			developer defined genre description						gnpl_crit_field_type_string		*/

#define gnpl_crit_field_track_composer				52	/*			UNSUPPORTED								gnpl_crit_field_type_string		*/
#define gnpl_crit_field_track_conductor				53	/*			UNSUPPORTED								gnpl_crit_field_type_string		*/
#define gnpl_crit_field_track_ensemble				54	/*			UNSUPPORTED								gnpl_crit_field_type_string		*/

#define gnpl_crit_field_reserved4					55	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_reserved5					56	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_reserved6					57	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_reserved7					58	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_reserved8					59	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_reserved9					60	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_reserved10					61	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_reserved11					62	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_reserved12					63	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_reserved13					64	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
#define gnpl_crit_field_reserved14					65	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/

/*	New developer fields added for 4.3 Device 2.5 Stage 10	*/
#define gnpl_crit_field_idx_numdev1            		66	/* Indexed	numeric developer field						gnpl_crit_field_type_num	*/
#define gnpl_crit_field_idx_numdev2            		67	/* Indexed	numeric developer field						gnpl_crit_field_type_num	*/
#define gnpl_crit_field_idx_numdev3            		68	/* Indexed	numeric developer field						gnpl_crit_field_type_num	*/
#define gnpl_crit_field_idx_alphdev1           		69	/* Indexed	alpha developer field						gnpl_crit_field_type_string	*/
#define gnpl_crit_field_idx_alphdev2           		70	/* Indexed	alpha developer field						gnpl_crit_field_type_string	*/
#define gnpl_crit_field_idx_alphdev3           		71	/* Indexed	alpha developer field						gnpl_crit_field_type_string	*/
#define gnpl_crit_field_numdev1						72	/*			numeric developer field						gnpl_crit_field_type_num	*/
#define gnpl_crit_field_numdev2						73	/*			numeric developer field						gnpl_crit_field_type_num	*/
#define gnpl_crit_field_numdev3						74	/*			numeric developer field						gnpl_crit_field_type_num	*/
#define gnpl_crit_field_numdev4						75	/*			numeric developer field						gnpl_crit_field_type_num	*/
#define gnpl_crit_field_numdev5						76	/*			numeric developer field						gnpl_crit_field_type_num	*/
#define gnpl_crit_field_alphdev1					77	/*			alpha developer field						gnpl_crit_field_type_string	*/
#define gnpl_crit_field_alphdev2					78	/*			alpha developer field						gnpl_crit_field_type_string	*/
#define gnpl_crit_field_alphdev3					79	/*			alpha developer field						gnpl_crit_field_type_string	*/
#define gnpl_crit_field_alphdev4					80	/*			alpha developer field						gnpl_crit_field_type_string	*/
#define gnpl_crit_field_alphdev5					81	/*			alpha developer field						gnpl_crit_field_type_string	*/

#define gnpl_crit_field_primary_mood_id				82	/* Indexed	PROTECTED - primary mood descriptor ID		gnpl_crit_field_type_enum	*/
#define gnpl_crit_field_primary_tempo_id			83	/* Indexed	PROTECTED - primary tempo descriptor ID		gnpl_crit_field_type_enum	*/
#define gnpl_crit_field_track_general_dsp			84	/*			PROTECTED - general dsp attributes			gnpl_crit_field_type_key_ivalue_array */

/*	New fields added for 5.4.  Not supported for MLDBs older than 5.4	*/
#define gnpl_crit_field_track_id					85	/* Indexed	PROTECTED - Track unique id									gnpl_crit_field_type_enum	*/
#define gnpl_crit_field_track_tui_id				86	/*			PROTECTED - Title unique id									gnpl_crit_field_type_enum	*/
#define gnpl_crit_field_album_id					87	/*			PROTECTED - Album unique id									gnpl_crit_field_type_enum	*/

#define gnpl_crit_field_album_era					88	/*			Enumerated id from era list									gnpl_crit_field_type_enum	*/
#define gnpl_crit_field_album_type					89	/*			Enumerated id from type list								gnpl_crit_field_type_enum	*/
#define gnpl_crit_field_album_artist_id				90	/*			PROTECTED - Artist unique id								gnpl_crit_field_type_enum	*/
#define gnpl_crit_field_album_track_count			91	/*			PROTECTED - Numer of tracks from album in local collection	gnpl_crit_field_type_num	*/

#define gnpl_crit_field_artist_id					92	/*			PROTECTED - Artist unique id								gnpl_crit_field_type_enum	*/
#define gnpl_crit_field_artist_genrev2				93	/*			Enumerated id from version 2 genre list						gnpl_crit_field_type_enum	*/
#define gnpl_crit_field_artist_track_count			94	/* 			PROTECTED - Numer of tracks by artist in local collection	gnpl_crit_field_type_num	*/

#define gnpl_crit_field_last						95	/* INTERNAL	Placeholder used internally */

/* Field Types
gnpl_crit_field_type_t is used in criteria structures when creating criteria for a playlist generator */
typedef gn_uint16_t		gnpl_crit_field_type_t;
#define gnpl_crit_field_type_unknown			0	/* unknown field type							*/
#define gnpl_crit_field_type_string				1	/* textual field type							*/
#define gnpl_crit_field_type_num				2	/* numerical field type							*/
#define gnpl_crit_field_type_enum				3	/* enumerated field type (same as numerical, but less than/greater than is not valid) */
#define gnpl_crit_field_type_date				4	/* date field type								*/
#define gnpl_crit_field_type_key_ivalue_array	5	/* key:value array type - for internal use only */
#define gnpl_crit_field_type_last				6	/* invalid field type - do not use				*/

/* Operators
gnpl_crit_op_t is used in criteria structures when creating criteria for a playlist generator */
typedef gn_uint16_t					gnpl_crit_op_t;
/* Operator */										   /* Description */				/* Parameters required */
#define gnpl_crit_op_str_first       				0  /* unused - placeholder */		/* 1 */
#define gnpl_crit_op_str_eq          				1  /* is equal to */				/* 1 */
#define gnpl_crit_op_str_neq         				2  /* is not equal to */			/* 1 */
#define gnpl_crit_op_str_cont        				3  /* contains */					/* 1 */
#define gnpl_crit_op_str_ncont       				4  /* does not contain */			/* 1 */
#define gnpl_crit_op_str_sta         				5  /* starts with */				/* 1 */
#define gnpl_crit_op_str_end         				6  /* ends with */					/* 1 */
#define gnpl_crit_op_str_last        				7  /* unused - placeholder */

#define gnpl_crit_op_num_first       				8  /* unused - placeholder */
#define gnpl_crit_op_num_eq          				9  /* is equal to */				/* 1 */
#define gnpl_crit_op_num_neq         				10 /* is not equal to */			/* 1 */
#define gnpl_crit_op_num_lt          				11 /* is less than */				/* 1 */
#define gnpl_crit_op_num_gt          				12 /* is greater than */			/* 1 */
#define gnpl_crit_op_num_rang        				13 /* is in the range */			/* 2 */
#define gnpl_crit_op_num_last        				14 /* unused - placeholder */

#define gnpl_crit_op_enum_first      				15 /* unused - placeholder */
#define gnpl_crit_op_enum_eq         				16 /* is equal to */				/* 1 */
#define gnpl_crit_op_enum_neq        				17 /* is not equal to */			/* 1 */
#define gnpl_crit_op_enum_sim        				18 /* is similar to */				/* 3 */
#define gnpl_crit_op_enum_last       				19 /* unused - placeholder */

#define gnpl_crit_op_date_first      				20 /* unused - placeholder */
#define gnpl_crit_op_date_eq         				21 /* is equal to */				/* 1 */
#define gnpl_crit_op_date_neq        				22 /* is not equal to */			/* 1 */
#define gnpl_crit_op_date_lt						23 /* is before */					/* 1 */
#define gnpl_crit_op_date_gt						24 /* is after */					/* 1 */
#define gnpl_crit_op_date_rang       				25 /* is between */					/* 2 */
#define gnpl_crit_op_date_inlast     				26 /* is in the last <x> days */	/* 1 */
#define gnpl_crit_op_date_notinlast  				27 /* is not in the last <x> days *//* 1 */
#define gnpl_crit_op_date_last       				28 /* unused - placeholder */
#define gnpl_crit_op_enum_rang						29 /* unused - internal use only */

#define gnpl_crit_op_kiva_first      				30 /* unused - placeholder */
#define gnpl_crit_op_kiva_eq         				31 /* is equal to */				/* 1 */
#define gnpl_crit_op_kiva_neq        				32 /* is not equal to */			/* 1 */
#define gnpl_crit_op_kiva_sim        				33 /* is similar to */				/* 3 */
#define gnpl_crit_op_kiva_last       				34 /* unused - placeholder */

#define gnpl_crit_op_last							35 /* unused - placeholder */

/* Matchmode
gnpl_criteria_matchmode_t is used in the playlist generator structure to describe matchmodes */
typedef gn_uint32_t					gnpl_criteria_matchmode_t;
#define gnpl_matchmode_match_any        0	/* Match any criteria */
#define gnpl_matchmode_match_all        1	/* Match all criteria */

/* Parameter Numbers
gnpl_crit_param_num_t is used in in criteria structures when creating criteria for a playlist generator.
	It is used to identify which parameter (1, 2, 3) of a criterion you are setting/getting criterion parameters. */
typedef gn_uint16_t						gnpl_crit_param_num_t;
#define gnpl_crit_param_1				0	/* First parameter */
#define gnpl_crit_param_2				1	/* Second parameter */
#define gnpl_crit_param_3				2	/* Third parameter */

/* Rank Order
gnpl_rank_order_t is used in criteria structures when creating criteria for a playlist generator.
	It is used to define whether the playlist generator should prefer higher or lower values for a field.*/
typedef	gn_uint16_t						gnpl_rank_order_t;
#define gnpl_rank_order_none			0					/* No rank order, field will not actually be used for ranking */
#define gnpl_rank_order_ascending		1					/* Ascending rank order, higher values will be preferred. */
#define gnpl_rank_order_descending		2					/* Descending rank order, lower values will be preferred. */

/* User Info
gnpl_user_info_t identify certain strings that are useful for playlist */
typedef gn_uint16_t						gnpl_user_info_t;
#define gnpl_user_rating_first			0
#define gnpl_user_rating_highest		1
#define gnpl_user_rating_favorite		2
#define gnpl_user_rating_lowest			3
#define gnpl_user_rating_good			4
#define gnpl_user_play_never			5
#define gnpl_user_play_recent			6
#define gnpl_user_play_last_30_days		7
#define gnpl_user_play_last_week		8
#define gnpl_user_play_last_day			9
#define gnpl_user_info_last				10

/* gnpl_results_data_mask_flags_enum : used in gnplaylist_get_results_data, to specify what data to get in the results */
typedef gn_uint32_t						gnpl_results_data_mask_flags_enum;

#define GNPL_RESULTS_DATA_MINIMUM		0x00000000
		/*	The minimum set of data that's always returned for a result:
		 *	filename      - gnpl_crit_field_file_name
		 *	title         - gnpl_crit_field_track_name
		 *	length_secs   - gnpl_crit_field_file_length
		 *	size_bytes    - gnpl_crit_field_file_size
		 *	tag_id        - gnpl_crit_field_tagid
		 *	tui_id        - (derived from gnpl_crit_field_tagid)
		 *	collection_id - (derived internally by the system)
		 */

#define GNPL_RESULTS_DATA_FILEPATH		0x00000001 /* path				- gnpl_crit_field_path_name				*/
#define GNPL_RESULTS_DATA_ARTIST		0x00000002 /* artist			- gnpl_crit_field_track_artist_name		*/
#define GNPL_RESULTS_DATA_ALBUM			0x00000004 /* album				- gnpl_crit_field_album_name			*/
#define GNPL_RESULTS_DATA_POPULARITY	0x00000008 /* deprecated												*/
#define GNPL_RESULTS_DATA_USER_RATING	0x00000010 /* user_rating		- gnpl_crit_field_track_myrating		*/
#define GNPL_RESULTS_DATA_BITRATE		0x00000020 /* bitrate			- gnpl_crit_field_file_bitrate			*/
#define GNPL_RESULTS_DATA_DEVFIELD1		0x00000040 /* devfield1			- gnpl_crit_field_xdev1					*/
#define GNPL_RESULTS_DATA_RELEASEYEAR	0x00000080 /* release_year		- gnpl_crit_field_track_releaseyear		*/
#define GNPL_RESULTS_DATA_LASTPLAYED	0x00000100 /* lastplayed_date	- gnpl_crit_field_file_lastplayed_date	*/
#define GNPL_RESULTS_DATA_ALL			0xFFFFFFFF /* all fields in the gnpl_result_t will be populated			*/

/*
 *	playlist 2.5 morelikethis config algorithm
 *
 *	ALG_20 is the 4.1 "intelemix" version of more like this.
 *
 *	ALG_25 is the new (4.3) improved more like this.
 *
 *	ALG_DSP_1 is basically the same mix of criteria as ALG_25 but also includes the mood and
 *	tempo fields and uses the GNPL_CRIT_SIMILARITY_FUNCTION_1 similarity function.
 *
 *	ALG_DSP2 is used internally by Gracenote for testing and is not intended for public use.
 *
 *	The algorithm can be set with a call to gnplaylist_morelikethis_cfg_set_algorithm() but
 *	it is highly recommended that you do not use anything other than GNPL_MORELIKETHIS_ALG_DEFAULT.
 *	The gnplaylist_morelikethis_cfg_new_cfg() API automatically creates a configuration object
 *	with the algorithm set to GNPL_MORELIKETHIS_ALG_DEFAULT.  This default algorithm tells MoreLikeThis
 *	to use ALG_DSP_1 if your seed song contains DSP mood and tempo data but if the seed does not have
 *	DSP data MoreLikeThis will use ALG_25.
 *
 *	If you set the algorithm to anything other than GNPL_MORELIKETHIS_ALG_DEFAULT, MoreLikeThis will
 *	assume you know what you are doing and explicitly use that algorithm without examining the seed track. 
 */
typedef gn_uint32_t gnpl_morelikethis_algorithm_t;

#define	GNPL_MORELIKETHIS_BEGIN_ALG			0
#define	GNPL_MORELIKETHIS_ALG_DEFAULT 		0	/*	This is the recommended default.	*/
#define	GNPL_MORELIKETHIS_ALG_20 			1	/*	NOT RECOMMENDED - backward compatible with the 4.1 release.	*/
#define	GNPL_MORELIKETHIS_ALG_25 			2
#define	GNPL_MORELIKETHIS_ALG_DSP_1			3
#define	GNPL_MORELIKETHIS_ALG_DSP_2			4	/*	NOT RECOMMENDED - Used only for internal testing.	*/
#define	GNPL_MORELIKETHIS_END_ALG			GNPL_MORELIKETHIS_ALG_DSP_2


/*
 *	Define a similarity function enumerator to indicate which algorithm will be used for the
 *	DSP similarity function.  Initially we have only one but more are sure to follow.
 *	Note that this is different from the More Like This algorithm.  The similarity function
 *	is specific to when the SIM operator is used with any key:value field and it is set with
 *	a call to gnplaylist_crit_setop_function().
 */

typedef gn_uint32_t		gnpl_crit_similarity_function_t;

#define	GNPL_CRIT_SIMILARITY_FUNCTION_DEFAULT	0	/* for now, same as GNPL_CRIT_SIMILARITY_FUNCTION_1 */
#define	GNPL_CRIT_SIMILARITY_FUNCTION_1			1
#define	GNPL_CRIT_SIMILARITY_FUNCTION_2			2
#define	GNPL_CRIT_SIMILARITY_FUNCTION_3			3


/*	**********************************************************************
 *	Criteria seed song selection types to be used in conjunction with
 *	gnplaylist_crit_set_selection_type() or gnplaylist_crit_get_selection_type().
 */

typedef gn_uint32_t gnpl_crit_selection_t;

#define GNPL_CRITERION_NOT_SELECTION_BASED		((gnpl_crit_selection_t) 0)
	/*	Mark the criterion as not based on a seed song.  This option is identical
	 *	to the call: gnplaylist_crit_setselection_based( crit_handle, GN_FALSE )
	 */

#define GNPL_CRITERION_IS_SELECTION_BASED		((gnpl_crit_selection_t) 1)
	/*	Mark the criterion as being based on one or more seed songs.
	 *	The seed songs may or may not be included in the result set
	 *	depending on randomization and song count limits. This option is identical
	 *	to the call:  gnplaylist_crit_setselection_based( crit_handle, GN_TRUE )
	 */

#define GNPL_CRITERION_INCLUDE_SEED_SELECTION	((gnpl_crit_selection_t) 2)
	/*	Mark the criterion as being based on one or more seed songs.
	 *	The seed songs will always be included in the result set.
	 */

#define GNPL_CRITERION_TOP_SEED_SELECTION		((gnpl_crit_selection_t) 3)
	/*	Mark the criterion as being based on one or more seed songs.
	 *	The seed songs will always be included as the first songs in the
	 *	result set.
	 */

#define GNPL_CRITERION_EXCLUDE_SEED_SELECTION	((gnpl_crit_selection_t) 4)
	/*	Mark the criterion as being based on one or more seed songs.
	 *	The seed songs will not be included in the result set.
	 */

/*	**********************************************************************	*/


/* used in StatsGetDate in the Windows SDK Only */
typedef gn_uint16_t						gnpl_stats_getdate_enum;
#define gnpl_stats_lastplaydate				1
#define gnpl_stats_lastupdateddate			2
#define gnpl_stats_createddate				3

#else /* GN_EPLAYLIST_USE_ENUMS */

/*
 *	gnpl_crit_field_t is used in criteria structures when creating criteria for a playlist generator
 *
 *
 *	----- Note ----- Note ----- Note ----- Note ----- Note ----- Note ----- Note ----- Note -----
 *
 *	The numerical order and names of these field definitions must never change because the
 *	PC SDK employs a Windows COM object that depends on old field numbers never changing.
 *	All new fields must be added to the end.
 *
 *	----- Note ----- Note ----- Note ----- Note ----- Note ----- Note ----- Note ----- Note -----
 *
 *	Also note that these field definitions must map one-to-one with gn_pl_field_enum_mapping in gn_playlist_plgen_xml.c.
 *
 *	Fields marked INTERNAL are not available for use by the developer.
 *	All others are available for public use.
 */
typedef enum gnpl_crit_field_t
{
    gnpl_crit_field_first					= 0,	/* INTERNAL - placeholder used internally */
    gnpl_crit_field_file_name				= 1,	/* Indexed	Name of physical file on disk					gnpl_crit_field_type_string		*/
    gnpl_crit_field_file_size				= 2,	/*			File size, in kilobytes							gnpl_crit_field_type_num		*/
    gnpl_crit_field_file_length				= 3,	/*			File length, in seconds							gnpl_crit_field_type_num		*/
    gnpl_crit_field_file_created_date		= 4,	/* Indexed	Date track was added to MLDB					gnpl_crit_field_type_date		*/
    gnpl_crit_field_file_modified_date		= 5,	/*			Date entry was last changed						gnpl_crit_field_type_date		*/
    gnpl_crit_field_file_lastplayed_date	= 6,	/* Indexed	Date playcount was incremented					gnpl_crit_field_type_date		*/
    gnpl_crit_field_file_bitrate			= 7,	/*			Bitrate of file in kbps							gnpl_crit_field_type_num		*/

	gnpl_crit_field_file_codec_format		= 8,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_file_drm				= 9,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/

    gnpl_crit_field_track_name				= 10,	/*			Track title name								gnpl_crit_field_type_string		*/
    gnpl_crit_field_track_sort_name			= 11,	/*			Developer defined track sorting title			gnpl_crit_field_type_string		*/
    gnpl_crit_field_track_artist_name		= 12,	/*			Track artist name								gnpl_crit_field_type_string		*/
    gnpl_crit_field_track_artist_sortname	= 13,	/*			Developer defined artist sorting name			gnpl_crit_field_type_string		*/
    gnpl_crit_field_track_releaseyear		= 14,	/* Indexed	Original release year of track					gnpl_crit_field_type_num		*/
	gnpl_crit_field_track_langid			= 15,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
    gnpl_crit_field_track_bpm				= 16,	/* Indexed	Track's beats per minute						gnpl_crit_field_type_num		*/
    gnpl_crit_field_track_num				= 17,	/*			Track sequence number on the CD					gnpl_crit_field_type_num		*/
    gnpl_crit_field_track_genre				= 18,	/*			Enumerated id from version 1 genre list			gnpl_crit_field_type_enum
													 *			Deprecated - v2 genre should be used											*/
    gnpl_crit_field_track_genrev2			= 19,	/* Indexed	Enumerated id from version 2 genre list			gnpl_crit_field_type_enum
													 *			Interpolated from version 1 genre if only v1 is available.						*/
    gnpl_crit_field_track_mood				= 20,	/*			PROTECTED - array of mood descriptors			gnpl_crit_field_type_key_ivalue_array */
    gnpl_crit_field_track_tempo				= 21,	/*			PROTECTED - array of tempo descriptors			gnpl_crit_field_type_key_ivalue_array */
	gnpl_crit_field_track_album_pop			= 22,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_track_global_pop		= 23,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
    gnpl_crit_field_album_name				= 24,	/*			Album Name										gnpl_crit_field_type_string		*/
    gnpl_crit_field_album_sortname			= 25,	/*			Developer defined album sorting name			gnpl_crit_field_type_string		*/
    gnpl_crit_field_album_primaryartist		= 26,	/*			UNSUPPORTED										gnpl_crit_field_type_string		*/
    gnpl_crit_field_album_releaseyear		= 27,	/*			Album release year								gnpl_crit_field_type_num		*/
    gnpl_crit_field_album_label				= 28,	/*			Album label										gnpl_crit_field_type_string		*/
	gnpl_crit_field_album_compilation		= 29,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
    gnpl_crit_field_album_region			= 30,	/*			Enumerated id from origins list					gnpl_crit_field_type_enum
													 *			Same as gnpl_crit_field_artist_region as far as the SDK is concerned.			*/
    gnpl_crit_field_album_genre				= 31,	/*			Enumerated id from version 1 genre list			gnpl_crit_field_type_enum
													 *			Deprecated - v2 genre should be used											*/
	gnpl_crit_field_album_genrev2			= 32,	/*			Enumerated id from version 2 genre list			gnpl_crit_field_type_enum		*/
	gnpl_crit_field_album_pop				= 33,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
    gnpl_crit_field_artist_region			= 34,	/* Indexed	Enumerated id from origins list					gnpl_crit_field_type_enum		*/
    gnpl_crit_field_artist_era				= 35,	/* Indexed	Enumerated id from era list						gnpl_crit_field_type_enum		*/
    gnpl_crit_field_artist_type				= 36,	/* Indexed	Enumerated id from artist type list				gnpl_crit_field_type_enum		*/
	gnpl_crit_field_track_local_pop			= 37,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_artist_local_pop		= 38,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
    gnpl_crit_field_track_playcount			= 39,	/* Indexed	Number of times play count has been incremented	gnpl_crit_field_type_num		*/
    gnpl_crit_field_track_myrating			= 40,	/* Indexed	User track rating. Scale of 0-100 (internally)	gnpl_crit_field_type_num		*/
	gnpl_crit_field_album_myrating			= 41,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_artist_myrating			= 42,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_genre_myrating			= 43,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_playlist_myrating		= 44,	/*			UNSUPPORTED										gnpl_crit_field_type_unknown	*/
    gnpl_crit_field_xdev1					= 45,	/*			developer defined field 1 - can hold any type of data	gnpl_crit_field_type_unknown	*/
    gnpl_crit_field_xdev2					= 46,	/*			developer defined field 2 - can hold any type of data	gnpl_crit_field_type_unknown	*/
    gnpl_crit_field_xdev3					= 47,	/*			developer defined field 3 - can hold any type of data	gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_xdev					= 48,	/* INTERNAL	Used internally for the "infinite" developer fields		gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_tagid					= 49,	/*			Gracenote tagid for the file							gnpl_crit_field_type_string		*/
	gnpl_crit_field_path_name				= 50,	/*			Path of the file										gnpl_crit_field_type_string		*/
	gnpl_crit_field_genredesc				= 51,	/*			developer defined genre description						gnpl_crit_field_type_string		*/

	gnpl_crit_field_track_composer			= 52,	/*			UNSUPPORTED								gnpl_crit_field_type_string		*/
	gnpl_crit_field_track_conductor			= 53,	/*			UNSUPPORTED								gnpl_crit_field_type_string		*/
	gnpl_crit_field_track_ensemble			= 54,	/*			UNSUPPORTED								gnpl_crit_field_type_string		*/

	gnpl_crit_field_reserved4				= 55,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_reserved5				= 56,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_reserved6				= 57,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_reserved7				= 58,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_reserved8				= 59,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_reserved9				= 60,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_reserved10				= 61,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_reserved11				= 62,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_reserved12				= 63,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_reserved13				= 64,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/
	gnpl_crit_field_reserved14				= 65,	/*			UNSUPPORTED								gnpl_crit_field_type_unknown	*/

	/*	New developer fields added for 4.3 Device 2.5 Stage 10	*/

	gnpl_crit_field_idx_numdev1				= 66,	/* Indexed	numeric developer field						gnpl_crit_field_type_num	*/
	gnpl_crit_field_idx_numdev2				= 67,	/* Indexed	numeric developer field						gnpl_crit_field_type_num	*/
	gnpl_crit_field_idx_numdev3				= 68,	/* Indexed	numeric developer field						gnpl_crit_field_type_num	*/
	gnpl_crit_field_idx_alphdev1			= 69,	/* Indexed	alpha developer field						gnpl_crit_field_type_string	*/
	gnpl_crit_field_idx_alphdev2			= 70,	/* Indexed	alpha developer field						gnpl_crit_field_type_string	*/
	gnpl_crit_field_idx_alphdev3			= 71,	/* Indexed	alpha developer field						gnpl_crit_field_type_string	*/
	gnpl_crit_field_numdev1					= 72,	/*			numeric developer field						gnpl_crit_field_type_num	*/
	gnpl_crit_field_numdev2					= 73,	/*			numeric developer field						gnpl_crit_field_type_num	*/
	gnpl_crit_field_numdev3					= 74,	/*			numeric developer field						gnpl_crit_field_type_num	*/
	gnpl_crit_field_numdev4					= 75,	/*			numeric developer field						gnpl_crit_field_type_num	*/
	gnpl_crit_field_numdev5					= 76,	/*			numeric developer field						gnpl_crit_field_type_num	*/
	gnpl_crit_field_alphdev1				= 77,	/*			alpha developer field						gnpl_crit_field_type_string	*/
	gnpl_crit_field_alphdev2				= 78,	/*			alpha developer field						gnpl_crit_field_type_string	*/
	gnpl_crit_field_alphdev3				= 79,	/*			alpha developer field						gnpl_crit_field_type_string	*/
	gnpl_crit_field_alphdev4				= 80,	/*			alpha developer field						gnpl_crit_field_type_string	*/
	gnpl_crit_field_alphdev5				= 81,	/*			alpha developer field						gnpl_crit_field_type_string	*/

	gnpl_crit_field_primary_mood_id			= 82,	/* Indexed	PROTECTED - primary mood descriptor ID		gnpl_crit_field_type_enum	*/
	gnpl_crit_field_primary_tempo_id		= 83,	/* Indexed	PROTECTED - primary tempo descriptor ID		gnpl_crit_field_type_enum	*/
	gnpl_crit_field_track_general_dsp		= 84,	/*			PROTECTED - general dsp attributes			gnpl_crit_field_type_key_ivalue_array */

/*	New fields added for 5.4.  Not supported for MLDBs older than 5.4	*/
	gnpl_crit_field_track_id				= 85,	/* Indexed	PROTECTED - Track unique id									gnpl_crit_field_type_enum	*/
	gnpl_crit_field_track_tui_id			= 86,	/*			PROTECTED - Title unique id									gnpl_crit_field_type_enum	*/
	gnpl_crit_field_album_id				= 87,	/*			PROTECTED - Album unique id									gnpl_crit_field_type_enum	*/

	gnpl_crit_field_album_era				= 88,	/*			Enumerated id from era list									gnpl_crit_field_type_enum	*/
	gnpl_crit_field_album_type				= 89,	/*			Enumerated id from type list								gnpl_crit_field_type_enum	*/
	gnpl_crit_field_album_artist_id			= 90,	/*			PROTECTED - Artist unique id								gnpl_crit_field_type_enum	*/
	gnpl_crit_field_album_track_count		= 91,	/*			PROTECTED - Numer of tracks from album in local collection	gnpl_crit_field_type_num	*/

	gnpl_crit_field_artist_id				= 92,	/*			PROTECTED - Artist unique id								gnpl_crit_field_type_enum	*/
	gnpl_crit_field_artist_genrev2			= 93,	/*			Enumerated id from version 2 genre list						gnpl_crit_field_type_enum	*/
	gnpl_crit_field_artist_track_count		= 94,	/* 			PROTECTED - Numer of tracks by artist in local collection	gnpl_crit_field_type_num	*/

    gnpl_crit_field_last					= 95	/* INTERNAL - placeholder used internally */
} gnpl_crit_field_t;


/* gnpl_crit_field_type_t is used in criteria structures when creating criteria for a playlist generator */
typedef enum gnpl_crit_field_type_t
{
	gnpl_crit_field_type_unknown			= 0,
	gnpl_crit_field_type_string				= 1,
	gnpl_crit_field_type_num				= 2,
	gnpl_crit_field_type_enum				= 3,
	gnpl_crit_field_type_date				= 4,
	gnpl_crit_field_type_key_ivalue_array	= 5,
	gnpl_crit_field_type_last				= 6		/* invalid field type - do not use */
} gnpl_crit_field_type_t;

/* gnpl_rank_order_t is used in criteria structures when creating criteria for a playlist generator.
	It is used to define whether the playlist generator should prefer higher or lower values for a field.*/
typedef enum gnpl_rank_order_t
{
    gnpl_rank_order_none				= 0x0000, /* No rank order, field will not actually be used for ranking */
    gnpl_rank_order_ascending           = 0x0001,
    gnpl_rank_order_descending          = 0x0002
} gnpl_rank_order_t;


/* gnpl_crit_op_t is used in criteria structures when creating criteria for a playlist generator */
typedef enum gnpl_crit_op_t {
    gnpl_crit_op_str_first		= 0,
    gnpl_crit_op_str_eq			= 1,
    gnpl_crit_op_str_neq		= 2,
    gnpl_crit_op_str_cont		= 3,
    gnpl_crit_op_str_ncont		= 4,
    gnpl_crit_op_str_sta		= 5,
    gnpl_crit_op_str_end		= 6,
    gnpl_crit_op_str_last		= 7,

    gnpl_crit_op_num_first		= 8,
    gnpl_crit_op_num_eq			= 9,
    gnpl_crit_op_num_neq		= 10,
    gnpl_crit_op_num_lt			= 11,
    gnpl_crit_op_num_gt			= 12,
    gnpl_crit_op_num_rang		= 13,
    gnpl_crit_op_num_last		= 14,

    gnpl_crit_op_enum_first		= 15,
    gnpl_crit_op_enum_eq		= 16,
    gnpl_crit_op_enum_neq		= 17,
    gnpl_crit_op_enum_sim		= 18,
    gnpl_crit_op_enum_last		= 19,

    gnpl_crit_op_date_first		= 20,
    gnpl_crit_op_date_eq		= 21,
    gnpl_crit_op_date_neq		= 22,
	gnpl_crit_op_date_lt		= 23,
	gnpl_crit_op_date_gt		= 24,
    gnpl_crit_op_date_rang		= 25,
    gnpl_crit_op_date_inlast	= 26,
    gnpl_crit_op_date_notinlast	= 27,
    gnpl_crit_op_date_last		= 28,
	gnpl_crit_op_enum_rang		= 29,	/* unused - internal use only */

	gnpl_crit_op_kiva_first		= 30,
	gnpl_crit_op_kiva_eq		= 31,
	gnpl_crit_op_kiva_neq		= 32,
	gnpl_crit_op_kiva_sim		= 33,
	gnpl_crit_op_kiva_last		= 34,

	gnpl_crit_op_last			= 35
} gnpl_crit_op_t;

/*
 *	gnpl_crit_param_num_t is used in in criteria structures when creating criteria for a
 *	playlist generator it identifies which parameter (1, 2, 3) of a criterion you are
 *	setting/getting
 */
typedef enum gnpl_crit_param_num_t
{
	gnpl_crit_param_1 = 0,
	gnpl_crit_param_2 = 1,
	gnpl_crit_param_3 = 2
} gnpl_crit_param_num_t;

/* gnpl_criteria_matchmode_t is used in the playlist generator structure to describe matchmodes */
typedef enum gnpl_criteria_matchmode_t
{
    gnpl_matchmode_match_any           = 0,
    gnpl_matchmode_match_all           = 1
} gnpl_criteria_matchmode_t;

/* gnpl_stats_getdate_enum used in StatsGetDate in the Windows SDK Only */
typedef enum
{
	gnpl_stats_lastplaydate = 1,
	gnpl_stats_lastupdateddate = 2,
	gnpl_stats_createddate = 3
} gnpl_stats_getdate_enum;

/* gnpl_user_info_t identify certain strings that are useful for playlist */
typedef enum gnpl_user_info_t
{
    gnpl_user_rating_first              = 0,
    gnpl_user_rating_highest            = 1,
    gnpl_user_rating_favorite           = 2,
    gnpl_user_rating_lowest             = 3,
    gnpl_user_rating_good               = 4,
    gnpl_user_play_never                = 5,
    gnpl_user_play_recent               = 6,
    gnpl_user_play_last_30_days         = 7,
    gnpl_user_play_last_week            = 8,
    gnpl_user_play_last_day             = 9,
    gnpl_user_info_last                 = 10
} gnpl_user_info_t;


/* used in gnplaylist_get_results_data, to specify what data to get in the results */
typedef enum
{
	GNPL_RESULTS_DATA_MINIMUM		=	0x00000000,
		/*	The minimum set of data that's always returned for a result:
		 *	filename      - gnpl_crit_field_file_name
		 *	title         - gnpl_crit_field_track_name
		 *	length_secs   - gnpl_crit_field_file_length
		 *	size_bytes    - gnpl_crit_field_file_size
		 *	tag_id        - gnpl_crit_field_tagid
		 *	tui_id        - (derived from gnpl_crit_field_tagid)
		 *	collection_id - (derived internally by the system)
		 */
	GNPL_RESULTS_DATA_FILEPATH		=	0x00000001, /* path				- gnpl_crit_field_path_name				*/
	GNPL_RESULTS_DATA_ARTIST		=	0x00000002, /* artist			- gnpl_crit_field_track_artist_name		*/
	GNPL_RESULTS_DATA_ALBUM			=	0x00000004, /* album			- gnpl_crit_field_album_name			*/
	GNPL_RESULTS_DATA_POPULARITY	=	0x00000008, /* deprecated												*/
	GNPL_RESULTS_DATA_USER_RATING	=	0x00000010, /* user_rating		- gnpl_crit_field_track_myrating		*/
	GNPL_RESULTS_DATA_BITRATE		=	0x00000020, /* bitrate			- gnpl_crit_field_file_bitrate			*/
	GNPL_RESULTS_DATA_DEVFIELD1		=	0x00000040, /* devfield1		- gnpl_crit_field_xdev1					*/
	GNPL_RESULTS_DATA_RELEASEYEAR	=	0x00000080, /* release_year		- gnpl_crit_field_track_releaseyear		*/
	GNPL_RESULTS_DATA_LASTPLAYED	=	0x00000100, /* lastplayed_date	- gnpl_crit_field_file_lastplayed_date	*/
	GNPL_RESULTS_DATA_ALL			=	-1			/* all fields in the gnpl_result_t will be populated		*/
} gnpl_results_data_mask_flags_enum;


/*	playlist 2.5 morelikethis config algorithm
 *
 *	The algorithm can be set with a call to gnplaylist_morelikethis_cfg_set_algorithm() but
 *	it is highly recommended that you do not use anything other than GNPL_MORELIKETHIS_ALG_DEFAULT.
 *	The gnplaylist_morelikethis_cfg_new_cfg() API automatically creates a configuration object
 *	with the algorithm set to GNPL_MORELIKETHIS_ALG_DEFAULT.  This default algorithm tells MoreLikeThis
 *	to use ALG_DSP_1 if your seed song contains DSP mood and tempo data but if the seed does not have
 *	DSP data MoreLikeThis will use ALG_25.
 *
 *	If you set the algorithm to anything other than GNPL_MORELIKETHIS_ALG_DEFAULT, MoreLikeThis will
 *	assume you know what you are doing and explicitly use that algorithm without examining the seed track. 
 */
typedef enum
{
	GNPL_MORELIKETHIS_BEGIN_ALG			= 0,
	GNPL_MORELIKETHIS_ALG_DEFAULT 		= 0,	/*	This is the recommended default.	*/
	GNPL_MORELIKETHIS_ALG_20 			= 1,	/*	NOT RECOMMENDED - backward compatible with the 4.1 release.	*/
	GNPL_MORELIKETHIS_ALG_25 			= 2,
	GNPL_MORELIKETHIS_ALG_DSP_1			= 3,
	GNPL_MORELIKETHIS_ALG_DSP_2			= 4,	/*	NOT RECOMMENDED - Used only for internal testing.	*/
	GNPL_MORELIKETHIS_END_ALG			= GNPL_MORELIKETHIS_ALG_DSP_2
} gnpl_morelikethis_algorithm_t;


typedef enum
{
	GNPL_CRIT_SIMILARITY_FUNCTION_DEFAULT	= 0,	/* for now, same as GNPL_CRIT_SIMILARITY_FUNCTION_1 */
	GNPL_CRIT_SIMILARITY_FUNCTION_1			= 1,
	GNPL_CRIT_SIMILARITY_FUNCTION_2			= 2,
	GNPL_CRIT_SIMILARITY_FUNCTION_3			= 3
}	gnpl_crit_similarity_function_t;


typedef enum
{
	GNPL_CRITERION_NOT_SELECTION_BASED		= 0,
	GNPL_CRITERION_IS_SELECTION_BASED		= 1,
	GNPL_CRITERION_INCLUDE_SEED_SELECTION	= 2,
	GNPL_CRITERION_TOP_SEED_SELECTION		= 3,
	GNPL_CRITERION_EXCLUDE_SEED_SELECTION	= 4
}	gnpl_crit_selection_t;


#endif /* !defined(GN_EPLAYLIST_USE_ENUMS) */

#endif /* __CDDB_PlaylistEnums_H__ */

#endif /* __CDDBPLAYLISTLib_LIBRARY_DEFINED__ (hack) */
#endif /* __CddbPlaylist2_h__ */
