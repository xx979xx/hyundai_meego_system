/*
 * Copyright (c) 2004 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_lists.h - Application and mid-level interface definition for
 *				the module supporting local and online access to the
 *				various lists used by other modules.
 */

/* Gracenote's embedded software utilizes lists stored locally or retrieved with online			*/
/*  lookups primarily to map IDs returned from lookups to strings which can be displayed		*/
/*  as part of a metadata display.  They may also be used where users may be presented an		*/
/*  opportunity to make a selection (such as creating criteria for playlist generation).		*/
/*  For the former case, the data conversion or retrieval functions typically perform the		*/
/*  list manipulation necessary to obtain a displayable string.  The latter case may require	*/
/*  more direct access to the contents of the lists.											*/

/* The APIs in this module are used to access the various lists.  The specific list which		*/
/*  is being accessed is specified by a gn_list_selector_t parameter, which must be one of		*/
/*  values defined below (beginning with GN_LIST_SEL_).  A list can be "opened" for repeated	*/
/*  access (or iteration) or a single list "element" can be fetched using the list selector		*/
/*  and the ID associated with the desired element.  Each list element has the following		*/
/*  data fields (which are retrieved through accessor functions):																				*/
/*  	gn_item_id_t				item_id								*/
/*      gn_uint32_t					ordinal								*/
/*      gn_uint16_t					num_children						*/
/*      gn_item_id_t*				children_ids_list					*/
/*      gn_uint16_t					num_parents							*/
/*      gn_item_id_t*				parents_ids_list					*/
/*      gn_uchar_t*					item_name							*/
/*      gn_uchar_t*					item_description					*/
/*     																	*/
/* Some of the more specialized lists contain elements which have additional data fields, which	*/
/*  are also retrieved through accessors.  For example, the list of artist eras (specified 		*/
/*  with GN_LIST_SEL_PLAYLIST_ERAS) contains elements which also have a "start year" and an		*/
/*  "end year".																					*/

/* In addition to the lists, the lists module supports access to certain "maps" which are used	*/
/*  internally.  Maps are not directly used by the application */

#ifndef _GN_LISTS_H_
#define _GN_LISTS_H_

/*
 * Dependencies.
 */

#include	"gn_defines.h"
#include	"gn_descriptors.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants
 */

/* the following are used to group lists by product */
#define		GN_LS_GENERAL			0x1		/* "general" lists, used among more than one product */
#define		GN_LS_MUSICID			0x2		/* lists specific to MusicID (file and CD)	*/
#define		GN_LS_DVD				0x4		/* lists specific to VideoID */
#define		GN_LS_PLAYLIST			0x8		/* lists specific to Playlist */


#define		GN_LS_MAP				0x80	/* flag indicating this "list" refers to a "map" */

/* list "sources" (NOT YET IMPLEMENTED) */
#define		GN_LS_LOCAL				0x100
#define		GN_LS_CACHE				0x200
#define		GN_LS_ONLINE			0x400

/* list "access method"  (PARTIALLY IMPLEMENTED - UPDATE) */
#define		GN_LS_MEMORY			0x1000
#define		GN_LS_FILE				0x2000
#define		GN_LS_UPDATE			0x8000

/* list "identifiers" - used to create a gn_list_selector_t */
#define		GN_LS_GEN_first					20		/* The first GEN list ID. */
#define		GN_LS_GEN_LANGUAGES				20
#define		GN_LS_GEN_MUSIC_GENRES			21
#define		GN_LS_GEN_REGIONS				22
#define		GN_LS_GEN_V1_TO_V2_GENRE_MAP	23

/*original define*/
#define		GN_LS_GEN_V2_MUSIC_GENRES		24
#define		GN_LS_GEN_GENRE_DISPLAY_TO_CATEGORY_ID_MAP	25
#define		GN_LS_GEN_CATEGORY_TO_CDS_ID	26
#define		GN_LS_GEN_MEDIATYPES			27
#define		GN_LS_GEN_last					27		/* The last GEN list ID. */


/* Video */
#define		GN_LS_DVD_first				1		/* The first DVD list ID. */
#define		GN_LS_DVD_CONTRIBUTORS		1
#define		GN_LS_DVD_RATINGS			2
#define		GN_LS_DVD_VIDEOTYPES		3
#define		GN_LS_DVD_RATINGTYPES		4
#define		GN_LS_DVD_DVDREGIONS		5
#define		GN_LS_DVD_VIDEO_GENRES		6
#define		GN_LS_DVD_MICRO_TO_GENRE_DISPLAY_MAP	7
#define		GN_LS_DVD_FEATURETYPES		8
#define		GN_LS_DVD_last				8		/* The last DVD list ID. */

#define		GN_LS_CD_first				30		/* The first CD list ID. */
#define		GN_LS_CD_ROLES				30
#define		GN_LS_MUSICID_ROLES			30
#define		GN_LS_MUSICID_SPOKENLANG	31
#define		GN_LS_CD_last				31		/* The last CD list ID. */

#define		GN_LS_PLAYLIST_first		40		/* The first PLAYLIST list ID. */
#define		GN_LS_PLAYLIST_ARTIST_TYPES	40
#define		GN_LS_PLAYLIST_ERAS			41
#define		GN_LS_PLAYLIST_ORIGINS		42
#define		GN_LS_PLAYLIST_POPULARITIES	43
#define		GN_LS_PLAYLIST_MACRO_GENRES	44
#define		GN_LS_PLAYLIST_MICRO_TO_MACRO_GENRE_MAP	45

#define		GN_LS_PLAYLIST_MICRO_TO_GENRE_DISPLAY_MAP	46
#define		GN_LS_PLAYLIST_MACRO_ORIGINS	47
#define		GN_LS_PLAYLIST_MICRO_TO_MACRO_ORIGIN_MAP	48
#define		GN_LS_PLAYLIST_MICRO_TO_ORIGIN_DISPLAY_MAP	49
#define		GN_LS_PLAYLIST_MACRO_ERAS	50
#define		GN_LS_PLAYLIST_MICRO_TO_MACRO_ERA_MAP	51
#define		GN_LS_PLAYLIST_MICRO_TO_ERA_DISPLAY_MAP	52
#define		GN_LS_PLAYLIST_MICRO_TO_ARTIST_TYPE_DISPLAY_MAP	53

/* DSP */
#define		GN_LS_PLAYLIST_MOODS						54
#define		GN_LS_PLAYLIST_TEMPO						55
#define		GN_LS_PLAYLIST_MICRO_TO_MOOD_DISPLAY_MAP	56
#define		GN_LS_PLAYLIST_MICRO_TO_TEMPO_DISPLAY_MAP	57
#define		GN_LS_PLAYLIST_MACRO_MOODS					58
#define		GN_LS_PLAYLIST_MICRO_TO_MACRO_MOOD_MAP		59

/* Classical */
#define		GN_LS_PLAYLIST_COMPOSITION_FORM							60
#define		GN_LS_PLAYLIST_MICRO_TO_COMPOSITION_FORM_DISPLAY_MAP	61

#define		GN_LS_PLAYLIST_last							61		/* The last PLAYLIST list ID. */


/*
 * Macros
 */
#define		GN_LIST_DESCRIPTOR(cls, src, id)	((cls<<16)|(src<<16)|id)
#define		GN_LIST_ID_MASK						0xFFFF
#define		GN_LIST_CLASS_MASK					0xFF0000
#define		GN_LIST_SOURCE_MASK					0xFF000000
#define		GN_LS_ID_MAX_ID_LEN					16

#define		GN_LIST_GENERAL						((GN_LS_GENERAL)<<16|GN_LIST_ID_MASK)
#define		GN_LIST_DVD							((GN_LS_DVD|GN_LS_GENERAL)<<16|GN_LIST_ID_MASK)  /* NKTODO - probably not used any more, but double check and update if necessary */
#define		GN_LIST_CD							((GN_LS_MAP|GN_LS_CD|GN_LS_GENERAL)<<16|GN_LIST_ID_MASK)
#define		GN_LIST_MUSICID						((GN_LS_MAP|GN_LS_MUSICID|GN_LS_GENERAL)<<16|GN_LIST_ID_MASK)
#define		GN_LIST_PLAYLIST					((GN_LS_MAP|GN_LS_PLAYLIST|GN_LS_GENERAL)<<16|GN_LIST_ID_MASK)
#define		GN_LIST_ALL							((GN_LS_MAP|GN_LS_GENERAL|GN_LS_MUSICID|GN_LS_DVD|GN_LS_PLAYLIST)<<16|GN_LIST_ID_MASK)
#define		GN_LIST_NONE						0
#define		GN_MAP_NONE							0
#define		GN_SELECTOR_IS_MAP(x)				(((x) & (GN_LIST_DESCRIPTOR(GN_LS_MAP, 0, 0)) ) != 0)





/*List types/ map names */
#define GN_LIST_STR_DVD_CONTRIBUTORS								((gn_uchar_t *)"Contributors")
#define GN_LIST_STR_DVD_RATINGS										((gn_uchar_t *)"Ratings")
#define GN_LIST_STR_DVD_VIDEOTYPES									((gn_uchar_t *)"VideoTypes")
#define GN_LIST_STR_DVD_RATINGTYPES									((gn_uchar_t *)"RatingTypes")
#define GN_LIST_STR_DVD_DVDREGIONS									((gn_uchar_t *)"DVDRegions")
#define GN_LIST_STR_DVD_VIDEO_GENRES								((gn_uchar_t *)"VideoGenreDisplayHierarchy")
#define GN_LIST_STR_DVD_MICRO_TO_GENRE_DISPLAY_MAP					((gn_uchar_t *)"ZZZDVD_MICRO_TO_GENRE_DISPLAY_MAP")
#define GN_LIST_STR_DVD_FEATURETYPES								((gn_uchar_t *)"FeatureTypes")
#define GN_LIST_STR_GEN_MUSIC_GENRES								((gn_uchar_t *)"Genre")
#define GN_LIST_STR_GEN_LANGUAGES									((gn_uchar_t *)"WrittenLanguage")
#define GN_LIST_STR_GEN_V1_TO_V2_MUSIC_GENRE_MAP					((gn_uchar_t *)"ZZZGEN_V1_TO_V2_MUSIC_GENRE_MAP")
#define GN_LIST_STR_GEN_V2_MUSIC_GENRES								((gn_uchar_t *)"GenreDisplayHierarchy")
#define GN_LIST_STR_GEN_MEDIA_TYPES									((gn_uchar_t *)"MediaTypes")
#define GN_LIST_STR_MUSICID_ROLES									((gn_uchar_t *)"Roles")
#define GN_LIST_STR_MUSICID_SPOKENLANG								((gn_uchar_t *)"SpokenLanguage")
#define GN_LIST_STR_PLAYLIST_ARTIST_TYPES							((gn_uchar_t *)"ArtistTypes")
#define GN_LIST_STR_PLAYLIST_ERAS									((gn_uchar_t *)"Eras")
#define GN_LIST_STR_PLAYLIST_ORIGINS								((gn_uchar_t *)"Origins")
#define GN_LIST_STR_PLAYLIST_COMPOSITION_FORM						((gn_uchar_t *)"CompositionFormDisplayHierarchy")
#define GN_LIST_STR_PLAYLIST_POPULARITIES							((gn_uchar_t *)"PopularityPercentRanges")
#define GN_LIST_STR_PLAYLIST_MACRO_GENRES							((gn_uchar_t *)"MacroGenres")
#define GN_LIST_STR_PLAYLIST_MOODS									((gn_uchar_t *)"MoodDisplayHierarchy")
#define GN_LIST_STR_PLAYLIST_TEMPO									((gn_uchar_t *)"TempoDisplayHierarchy")
#define GN_LIST_STR_GEN_GENRE_DISPLAY_TO_CATEGORY_ID_MAP			((gn_uchar_t *)"ZZZGEN_GENRE_DISPLAY_TO_CATEGORY_ID_MAP")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_GENRE_DISPLAY_MAP				((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_GENRE_DISPLAY_MAP")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_MACRO_GENRE_MAP				((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_MACRO_GENRE_MAP")
#define GN_LIST_STR_PLAYLIST_MACRO_ORIGINS							((gn_uchar_t *)"MacroOrigins")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_ORIGIN_DISPLAY_MAP			((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_ORIGIN_DISPLAY_MAP")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_COMPOSITION_FORM_DISPLAY_MAP	((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_COMPOSITION_FORM_DISPLAY_MAP")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_MACRO_ORIGIN_MAP				((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_MACRO_ORIGIN_MAP")
#define GN_LIST_STR_PLAYLIST_MACRO_ERAS								((gn_uchar_t *)"MacroEras")
#define GN_LIST_STR_PLAYLIST_MACRO_MOODS							((gn_uchar_t *)"MacroMoods")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_ERA_DISPLAY_MAP				((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_ERA_DISPLAY_MAP")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_MACRO_ERA_MAP					((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_MACRO_ERA_MAP")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_MACRO_MOOD_MAP				((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_MACRO_MOOD_MAP")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_ARTIST_TYPE_DISPLAY_MAP		((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_ARTIST_TYPE_DISPLAY_MAP")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_MOOD_DISPLAY_MAP				((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_MOOD_DISPLAY_MAP")
#define GN_LIST_STR_PLAYLIST_MICRO_TO_TEMPO_DISPLAY_MAP				((gn_uchar_t *)"ZZZPLAYLIST_MICRO_TO_TEMPO_DISPLAY_MAP")
#define GN_LIST_STR_CATEGORY_ID_TO_CDS_ID							((gn_uchar_t *)"ZZZCategoryToCDS")

/*Public List Selectors*/

#define GN_LIST_SEL_DVD_CONTRIBUTORS								gn_list_type_to_list_sel(GN_LIST_STR_DVD_CONTRIBUTORS)
#define GN_LIST_SEL_DVD_RATINGS										gn_list_type_to_list_sel(GN_LIST_STR_DVD_RATINGS)
#define GN_LIST_SEL_DVD_VIDEOTYPES									gn_list_type_to_list_sel(GN_LIST_STR_DVD_VIDEOTYPES)
#define GN_LIST_SEL_DVD_RATINGTYPES									gn_list_type_to_list_sel(GN_LIST_STR_DVD_RATINGTYPES)
#define GN_LIST_SEL_DVD_DVDREGIONS									gn_list_type_to_list_sel(GN_LIST_STR_DVD_DVDREGIONS)
#define GN_LIST_SEL_DVD_VIDEO_GENRES								gn_list_type_to_list_sel(GN_LIST_STR_DVD_VIDEO_GENRES)
#define GN_LIST_SEL_DVD_MICRO_TO_GENRE_DISPLAY_MAP					gn_map_name_to_map_sel  (GN_LIST_STR_DVD_MICRO_TO_GENRE_DISPLAY_MAP)
#define GN_LIST_SEL_DVD_FEATURETYPES								gn_list_type_to_list_sel(GN_LIST_STR_DVD_FEATURETYPES)
#define GN_LIST_SEL_GEN_MUSIC_GENRES								gn_list_type_to_list_sel(GN_LIST_STR_GEN_MUSIC_GENRES)
#define GN_LIST_SEL_GEN_LANGUAGES									gn_list_type_to_list_sel(GN_LIST_STR_GEN_LANGUAGES)
#define GN_LIST_SEL_GEN_V1_TO_V2_MUSIC_GENRE_MAP					gn_map_name_to_map_sel  (GN_LIST_STR_GEN_V1_TO_V2_MUSIC_GENRE_MAP)
#define GN_LIST_SEL_GEN_V2_MUSIC_GENRES								gn_list_type_to_list_sel(GN_LIST_STR_GEN_V2_MUSIC_GENRES)
#define GN_LIST_SEL_GEN_MEDIA_TYPES									gn_list_type_to_list_sel(GN_LIST_STR_GEN_MEDIA_TYPES)
#define GN_LIST_SEL_MUSICID_ROLES									gn_list_type_to_list_sel(GN_LIST_STR_MUSICID_ROLES)
#define GN_LIST_SEL_MUSICID_SPOKENLANG								gn_list_type_to_list_sel(GN_LIST_STR_MUSICID_SPOKENLANG)
#define GN_LIST_SEL_PLAYLIST_ARTIST_TYPES							gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_ARTIST_TYPES)
#define GN_LIST_SEL_PLAYLIST_ERAS									gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_ERAS)
#define GN_LIST_SEL_PLAYLIST_ORIGINS								gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_ORIGINS)
#define GN_LIST_SEL_PLAYLIST_COMPOSITION_FORM						gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_COMPOSITION_FORM)
#define GN_LIST_SEL_PLAYLIST_POPULARITIES							gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_POPULARITIES)
#define GN_LIST_SEL_PLAYLIST_MACRO_GENRES							gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_MACRO_GENRES)
#define GN_LIST_SEL_PLAYLIST_MOODS									gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_MOODS)
#define GN_LIST_SEL_PLAYLIST_TEMPO									gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_TEMPO)
#define GN_LIST_SEL_GEN_GENRE_DISPLAY_TO_CATEGORY_ID_MAP			gn_map_name_to_map_sel  (GN_LIST_STR_GEN_GENRE_DISPLAY_TO_CATEGORY_ID_MAP)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_GENRE_DISPLAY_MAP				gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_GENRE_DISPLAY_MAP)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_MACRO_GENRE_MAP				gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_MACRO_GENRE_MAP)
#define GN_LIST_SEL_PLAYLIST_MACRO_ORIGINS							gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_MACRO_ORIGINS)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_ORIGIN_DISPLAY_MAP			gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_ORIGIN_DISPLAY_MAP)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_COMPOSITION_FORM_DISPLAY_MAP	gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_COMPOSITION_FORM_DISPLAY_MAP)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_MACRO_ORIGIN_MAP				gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_MACRO_ORIGIN_MAP)
#define GN_LIST_SEL_PLAYLIST_MACRO_ERAS								gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_MACRO_ERAS)
#define GN_LIST_SEL_PLAYLIST_MACRO_MOODS							gn_list_type_to_list_sel(GN_LIST_STR_PLAYLIST_MACRO_MOODS)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_ERA_DISPLAY_MAP				gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_ERA_DISPLAY_MAP)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_MACRO_ERA_MAP					gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_MACRO_ERA_MAP)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_MACRO_MOOD_MAP				gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_MACRO_MOOD_MAP)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_ARTIST_TYPE_DISPLAY_MAP		gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_ARTIST_TYPE_DISPLAY_MAP)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_MOOD_DISPLAY_MAP				gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_MOOD_DISPLAY_MAP)
#define GN_LIST_SEL_PLAYLIST_MICRO_TO_TEMPO_DISPLAY_MAP				gn_map_name_to_map_sel  (GN_LIST_STR_PLAYLIST_MICRO_TO_TEMPO_DISPLAY_MAP)
#define GN_LIST_SEL_CATEGORY_ID_TO_CDS_ID							gn_list_type_to_list_sel(GN_LIST_STR_CATEGORY_ID_TO_CDS_ID)




/*
 * Structures and typedefs.
 */
typedef struct list_rev_info
{
	gn_uint32_t			flags;
	gn_uint32_t			count;
	gn_uint32_t			language_id;
	gn_uint32_t			region_id;
	gn_uint32_t			levels;
	gn_uint32_t			revision_level;
	gn_uchar_t			revision_tag[36];
}
gn_list_rev_info_t;

/* for dates */
typedef struct list_timestamp_t
{
	gn_uint32_t		minute;
	gn_uint32_t		hour;
	gn_uint32_t		day;
	gn_uint32_t		month;
	gn_uint32_t		year; /* must be >= 2000 */
	gn_uint32_t		reserved;
} gn_list_timestamp_t;


/* Opaque type for accessing lists and list elements */
typedef gn_selector_t	gn_list_selector_t;
typedef gn_selector_t	gn_map_selector_t;
typedef gn_uint16_t		gn_list_access_t;
typedef gn_uint32_t		gn_list_id_t;
typedef gn_uint32_t		gn_map_id_t;
typedef gn_uint32_t		gn_item_id_t;
typedef void*			gn_list_handle_t;
typedef void*			gn_map_handle_t;
typedef void*			gn_list_element_t;
typedef void*			gn_list_iterator_t;
typedef void*			gn_map_iterator_t;
typedef gn_list_rev_info_t	gn_map_rev_info_t;


/*
 * Prototypes.
 */


/*
 * List-related functions.
 */

/* NOTE: Functions that use list selectors should be called as seldom as possible.
 *			The preferred method of accessing a list is by handle.
 */

/* Is specified list available (local/cache). */
/* The "selector" parameter specifies the desired list (e.g., GN_LIST_SEL_GEN_MUSIC_GENRES). */
/* If the list is available locally, the boolean at available is set to GN_TRUE */
gn_error_t
gn_list_available(gn_list_selector_t selector, gn_bool_t* available);

/* Is list, or are lists, available locally? */
/* The "selector" parameter can be a specific list or a grouping (GN_LIST_DVD, etc.) */
/* All lists that match "which" must be present to return GN_TRUE. */
gn_error_t
gn_lists_available(gn_list_selector_t selector, gn_bool_t* available);

/* Get revision info of specified list. */
/* The "selector" parameter specifies the list (e.g., GN_LIST_SEL_GEN_MUSIC_GENRES). */
/* The structure at "rev_info" is filled with the current revision information. */
gn_error_t
gn_list_get_rev_info(gn_list_selector_t selector, gn_list_rev_info_t* rev_info);

/* Get type of list. */
/* The "selector" parameter specifies the list (e.g., GN_LIST_SEL_GEN_MUSIC_GENRES). */
/* The pointer at "type" is filled with a pointer to the internal type of the list. */
gn_error_t
gn_list_get_type(gn_list_selector_t selector, const gn_uchar_t** type);

/* Open list for repeated access. */
/* The "selector" parameter specifies the desired list (e.g., GN_LIST_SEL_GEN_MUSIC_GENRES). */
/* The "handle" is returned */
/* Currently only GN_LS_FILE is supported for the "access" parameter */
gn_error_t
gn_list_get_handle(gn_list_selector_t selector, gn_list_handle_t* handle, gn_list_access_t access);

/* Close list "handle" returned through gn_list_get_handle. */
gn_error_t
gn_list_free_handle(gn_list_handle_t handle);

/* Get selectors for "group" of list used by specified product (GN_LIST_GENERAL, GN_LIST_MUSICID, GN_LIST_DVD, GN_LIST_PLAYLIST). */
/* The list of gn_list_selector_t's returned through "selectors" is terminated with a zero value */
/* NOTE: This function is now deprecated, and only meant to be used in multi-list-file mode
          (Legacy lists.) */
gn_error_t
gn_list_get_list_selectors(gn_uint32_t group, const gn_list_selector_t** selectors);


/*
 * Element lookup functions.
 */

/* Lookup list element with passed id string. */
/* The "handle" for the list must have been returned through gn_list_get_handle. */
/* The "item_id_str" is the string representation of the id for the associated element, usually retrieved */
/*  from a data structure returned by a lookup function */
/* The "element" returned should be released using gn_list_free_element. */
gn_error_t
gn_list_get_element_by_id_str(gn_list_handle_t handle, const gn_uchar_t* item_id_str, gn_list_element_t* element);

/* Lookup list element with passed id. */
/* The "handle" for the list must have been returned through gn_list_get_handle. */
/* The "item_id" is the numeric representation of the id for the associated element, usually retrieved */
/*  from a data structure returned by a lookup function or through another list element */
/* The "element" returned should be released using gn_list_free_element. */
gn_error_t
gn_list_get_element_by_id(gn_list_handle_t handle, gn_item_id_t item_id, gn_list_element_t* element);

/* Creates an "iterator" for returning all the elements in the list. */
/* The "handle" for the list must have been returned through gn_list_get_handle. */
/* The "iterator" returned should be released using gn_list_destroy_element_iterator. */
gn_error_t
gn_list_create_element_iterator(gn_list_handle_t handle, gn_list_iterator_t* iterator);

/* Return next element in list. */
/* The "handle" for the list must have been returned through gn_list_get_handle. */
/* The "iterator" must have been returned through gn_list_create_element_iterator. */
/* The "element" returned should be released using gn_list_free_element. */
gn_error_t
gn_list_iterate_next_element(gn_list_handle_t handle, gn_list_iterator_t iterator, gn_list_element_t* element);

/* Releases an "iterator" previously obtained. */
/* The "handle" for the list must have been returned through gn_list_get_handle. */
/* The "iterator" must have been returned through gn_list_create_element_iterator. */
gn_error_t
gn_list_destroy_element_iterator(gn_list_handle_t handle, gn_list_iterator_t iterator);

/* Lookup element with passed id string (not list handle based). */
/* The "selector" parameter specifies which list should be accessed. */
/* The "item_id_str" is the string representation of the id for the associated element, usually retrieved */
/*  from a data structure returned by a lookup function */
/* The "element" returned should be released using gn_list_free_element. */
gn_error_t
gn_list_raw_get_element_by_id_str(gn_list_selector_t selector, const gn_uchar_t* item_id_str, gn_list_element_t* element);

/* Lookup element with passed id (not list handle based). */
/* The "selector" parameter specifies which list should be accessed. */
/* The "item_id" is the numeric representation of the id for the associated element, usually retrieved */
/*  from a data structure returned by a lookup function or through another list element */
/* The "element" returned should be released using gn_list_free_element. */
gn_error_t
gn_list_raw_get_element_by_id(gn_list_selector_t selector, gn_item_id_t item_id, gn_list_element_t* element);

/* Free a list element retrieved from a list access. */
/* The "handle" for the list must have been returned through gn_list_get_handle (or GN_NULL, if the element */
/*  was retrieved through one of the "raw" functions. */
/* The "element" which was returned through an iterator or a "get" function. */
gn_error_t
gn_list_free_element(gn_list_handle_t handle, gn_list_element_t element);


/*
 * Map-related functions.
 */

/* Is specified map available (local/cache). */
/* The "selector" parameter specifies the desired map (e.g., GN_LIST_SEL_GEN_V1_TO_V2_MUSIC_GENRE_MAP). */
/* If the map is available locally, the boolean at available is set to GN_TRUE */
gn_error_t
gn_map_available(gn_map_selector_t selector, gn_bool_t* available);

/* Get revision info of specified map. */
/* The "selector" parameter specifies the map (e.g., GN_LIST_SEL_GEN_V1_TO_V2_MUSIC_GENRE_MAP). */
/* The structure at "rev_info" is filled with the current revision information. */
gn_error_t
gn_map_get_rev_info(gn_map_selector_t selector, gn_map_rev_info_t* rev_info);

/* Open map for repeated access. */
/* The "selector" parameter specifies the desired map (e.g., GN_LIST_SEL_GEN_V1_TO_V2_MUSIC_GENRE_MAP). */
/* The "handle" is returned */
gn_error_t
gn_map_get_handle(gn_map_selector_t selector, gn_map_handle_t* handle);

/* Close map "handle" returned through gn_map_get_handle. */
gn_error_t
gn_map_free_handle(gn_map_handle_t handle);


/*
 * Map lookup functions.
 */

/* Retrieve the ID which is mapped to the passed id string. */
/* The "handle" for the map must have been returned through gn_map_get_handle. */
/* The "item_id_str" is the string representation of the id for the id being queried */
/* The "mapped_id" is filled with the id that is mapped to the source id. */
gn_error_t
gn_map_get_mapped_id_by_id_str(gn_map_handle_t handle, const gn_uchar_t* item_id_str, gn_item_id_t* mapped_id);

/* Retrieve the ID which is mapped to the passed id. */
/* The "handle" for the map must have been returned through gn_map_get_handle. */
/* The "item_id" is the id being queried */
/* The "mapped_id" is filled with the id that is mapped to the source id. */
gn_error_t
gn_map_get_mapped_id_by_id(gn_map_handle_t handle, gn_item_id_t item_id, gn_item_id_t* mapped_id);

/* Creates an "iterator" for returning all the ids in the map. */
/* The "handle" for the map must have been returned through gn_map_get_handle. */
/* The "iterator" returned should be released using gn_map_destroy_iterator. */
gn_error_t
gn_map_create_iterator(gn_map_handle_t handle, gn_map_iterator_t* iterator);

/* Return next id in the map. */
/* The "handle" for the map must have been returned through gn_map_get_handle. */
/* The "iterator" must have been returned through gn_map_create_iterator. */
/* The "id" is filled with the id that has a mapped id. */
/* The "mapped_id" is filled with the id that is mapped to the returned id. */
gn_error_t
gn_map_iterate_next_mapped_id(gn_map_handle_t handle, gn_map_iterator_t iterator, gn_item_id_t* id, gn_item_id_t* mapped_id);

/* Releases an "iterator" previously obtained. */
/* The "handle" for the map must have been returned through gn_map_get_handle. */
/* The "iterator" must have been returned through gn_map_create_iterator. */
gn_error_t
gn_map_destroy_iterator(gn_map_handle_t handle, gn_map_iterator_t iterator);

/* Retrieve the ID which is mapped to the passed id string (not map handle based). */
/* The "item_id_str" is the string representation of the id for the id being queried */
/* The "mapped_id" is filled with the id that is mapped to the source id. */
gn_error_t
gn_map_raw_get_mapped_id_by_id_str(gn_map_selector_t selector, const gn_uchar_t* item_id_str, gn_item_id_t* mapped_id);

/* Retrieve the ID which is mapped to the passed id (not map handle based). */
/* The "item_id" is the id being queried */
/* The "mapped_id" is filled with the id that is mapped to the source id. */
gn_error_t
gn_map_raw_get_mapped_id_by_id(gn_map_selector_t selector, gn_item_id_t item_id, gn_item_id_t* mapped_id);


/*
 * Element accessor functions.
 */

/* Retrieve the id string for the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The buffer at "id_str" is filled with the id string for the list element */
/* The "id_str_len" is the size of the "id_str" parameter */
/* No memory is allocated by this function */
gn_error_t
gn_list_element_get_id_str(gn_list_element_t element, gn_uchar_t* id_str, gn_uint32_t id_str_len);

/* Retrieve the id for the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The "id" parameter is filled with the id of the element */
gn_error_t
gn_list_element_get_id(gn_list_element_t element, gn_item_id_t* id);

/* Retrieve a pointer to the name string of the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The pointer at "name" is filled with a pointer to the name string for the list element */
/* No memory is allocated by this function */
gn_error_t
gn_list_element_get_name(gn_list_element_t element, const gn_uchar_t** name);

/* Retrieve a pointer to the description string of the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The pointer at "description" is filled with a pointer to the description string for the list element, */
/*  which may be GN_NULL.  */
/* No memory is allocated by this function */
gn_error_t
gn_list_element_get_description(gn_list_element_t element, const gn_uchar_t** description);

/* Retrieve the ordinal value of the passed element (used for display sorting) */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The value at "ordinal" is filled with ordinal value for the list element, which may be 0. */
/* No memory is allocated by this function */
gn_error_t
gn_list_element_get_ordinal(gn_list_element_t element, gn_uint32_t* ordinal);

/* Retrieve a list of child id strings of the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The value at "count" is filled with number of children for the list element, which may be 0. */
/* The value at "children", if the count is non-zero, points to an array of string pointers, */
/*  one for each child element */
/* Memory is allocated by this function, returned in *children, and should be freed */
gn_error_t
gn_list_element_get_children_strs(gn_list_element_t element, gn_uint16_t* count, gn_uchar_t** children);

/* Retrieve a list of child ids of the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The value at "count" is filled with number of children for the list element, which may be 0. */
/* The value at "children", if the count is non-zero, points to an array of list item ids, */
/*  one for each child element */
/* No memory is allocated by this function */
gn_error_t
gn_list_element_get_children(gn_list_element_t element, gn_uint16_t* count, gn_item_id_t** children);

/* Retrieve a list of parent id strings of the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The value at "count" is filled with number of parents for the list element, which may be 0. */
/* The value at "parents", if the count is non-zero, points to an array of string pointers, */
/*  one for each parent element */
/* Memory is allocated by this function, returned in *parents, and should be freed */
gn_error_t
gn_list_element_get_parents_strs(gn_list_element_t element, gn_uint16_t* count, gn_uchar_t** parents);

/* Retrieve a list of parent ids of the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The value at "count" is filled with number of parents for the list element, which may be 0. */
/* The value at "parents", if the count is non-zero, points to an array of list item ids, */
/*  one for each parent element */
/* No memory is allocated by this function */
gn_error_t
gn_list_element_get_parents(gn_list_element_t element, gn_uint16_t* count, gn_item_id_t** parents);

/* Retrieve the parent id of the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The value of "parent" is a list item id for the parent element. */
/* An error is returned if there is no parent, or if there is more than one parent. */
/* No memory is allocated by this function */
gn_error_t
gn_list_element_get_parent(gn_list_element_t element, gn_uint32_t* parent);

/* for DESCRIPTORS list (GN_LIST_SEL_DVD_DESCRIPTORS) */

/* Retrieve the descriptor type id string for the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The buffer at "descriptor_type_id_str" is filled with the id string of the descriptor type field */
/*  for the list element */
/* The "descriptor_type_id_str" is the size of the "descriptor_type_id_str" parameter */
/* No memory is allocated by this function */
gn_error_t
gn_list_element_get_descriptor_type_id_str(gn_list_element_t element, gn_uchar_t* descriptor_type_id_str, gn_uint32_t descriptor_type_id_str_len);

/* Retrieve the descriptor type id for the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The "descriptor_type_id" parameter is filled with the id of the descriptor type field for the element */
gn_error_t
gn_list_element_get_descriptor_type_id(gn_list_element_t element, gn_item_id_t* descriptor_type_id);


/* for RATINGS list (GN_LIST_SEL_DVD_RATINGS) */

/* Retrieve the rating type id for the passed element (refer to GN_LIST_SEL_GEN_RATINGTYPES */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The "rating_type_id" parameter is filled with the id of the descriptor type field for the element */
void
gn_list_element_get_rating_type_id(gn_list_element_t element, gn_item_id_t* rating_type_id);


/* for MEDIATYPEID list (GN_LIST_SEL_DVD_DVDREGIONS) */

/* Retrieve the media type id for the passed element (refer to GN_LIST_SEL_DVD_MEDIA_TYPES */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The "media_type_id" parameter is filled with the id of the descriptor type field for the element */
void
gn_list_element_get_media_type_id(gn_list_element_t element, gn_item_id_t* media_type_id);

/* for ERAS list (GN_LIST_SEL_PLAYLIST_ERAS) */

/* Retrieve the start and end years for the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The "start" and "end" parameters are filled with the first year and last year, respectively, */
/* for the era that the element represents */
gn_error_t
gn_list_element_get_era_range(gn_list_element_t element, gn_uint16_t* start, gn_uint16_t* end);

/* for COMPOSITION-FORM list (GN_LIST_SEL_PLAYLIST_COMPOSITION_FORM) */

/* Retrieve the start and end BPM for the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The "start" and "end" parameters are filled with the first BPM and last BPM, respectively, */
/* for the Tempo that the element represents */
gn_error_t
gn_list_element_get_tempo_range(gn_list_element_t element, gn_uint32_t* start, gn_uint32_t* end);

/* for POPULARITY list (GN_LIST_SEL_PLAYLIST_POPULARITIES) */

/* Retrieve the start and end percentages for the passed element */
/* The "element" is a list element which was retrieved through a "get" or "iterate" function */
/* The "start" and "end" parameters are filled with the low and high percentiles, respectively, */
/* for the popularity range that the element represents */
gn_error_t
gn_list_element_get_pop_range(gn_list_element_t element, gn_int32_t* start, gn_int32_t* end);



/* This following function declarations are called by the previously defined list selector macros above.
 * They ate not meant to be called on its own
 */
gn_list_selector_t  gn_list_type_to_list_sel(gn_uchar_t* name);
gn_map_selector_t  gn_map_name_to_map_sel(gn_uchar_t* name);
/* Please do not call these function directly. */


#ifdef __cplusplus
}
#endif 

#endif /* _GN_LISTS_H_ */
