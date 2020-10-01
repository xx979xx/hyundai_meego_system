

#include "gn_defines.h"
#include "gn_playlist_enums.h"

const gn_uchar_t* gnpl_field_descriptions[gnpl_crit_field_last+1] =
{
	(gn_uchar_t *)"",							/* gnpl_crit_field_first			*/

	(gn_uchar_t *)"filename",					/* gnpl_crit_field_file_name		*/	/* name of physical file on disk */
	(gn_uchar_t *)"file size (bytes)",			/* gnpl_crit_field_file_size		*/	/* in bytes */
	(gn_uchar_t *)"file length (seconds)",		/* gnpl_crit_field_file_length		*/	/* in seconds */
	(gn_uchar_t *)"created date",				/* gnpl_crit_field_file_created_date	*/
	(gn_uchar_t *)"modified date",				/* gnpl_crit_field_file_modified_date	*/
	(gn_uchar_t *)"last played date",			/* gnpl_crit_field_file_lastplayed_date	*/
	(gn_uchar_t *)"bitrate",					/* gnpl_crit_field_file_bitrate			*/
	
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_01	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_02	*/	/* unsupported */
	
	(gn_uchar_t *)"track name",					/* gnpl_crit_field_track_name			*/
	(gn_uchar_t *)"track sort name",			/* gnpl_crit_field_track_sort_name		*/
	(gn_uchar_t *)"artist name",				/* gnpl_crit_field_track_artist_name	*/
	(gn_uchar_t *)"artist sort name",			/* gnpl_crit_field_track_artist_sort_name	*/
	(gn_uchar_t *)"track release year",			/* gnpl_crit_field_track_releaseyear	*/

	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_03	*/	/* unsupported */

	(gn_uchar_t *)"bpm",						/* gnpl_crit_field_track_bpm		*/	/* available for SDK use, but we don't populate it */
	(gn_uchar_t *)"track number",				/* gnpl_crit_field_track_num		*/
	(gn_uchar_t *)"genre (v1)",					/* gnpl_crit_field_track_genre		*/
	(gn_uchar_t *)"genre",						/* gnpl_crit_field_track_genrev2	*/
	(gn_uchar_t *)"mood",						/* gnpl_crit_field_track_mood		*/	
	(gn_uchar_t *)"tempo",						/* gnpl_crit_field_track_tempo		*/

	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_04	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_05	*/	/* unsupported */
	
	(gn_uchar_t *)"album name",					/* gnpl_crit_field_album_name		*/
	(gn_uchar_t *)"album sort name",			/* gnpl_crit_field_album_sortname	*/
	(gn_uchar_t *)"primary artist",				/* gnpl_crit_field_album_primaryartist	*/
	(gn_uchar_t *)"album release year",			/* gnpl_crit_field_album_releaseyear	*/
	(gn_uchar_t *)"label",						/* gnpl_crit_field_album_label			*/

	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_06	*/	/* unsupported */

	(gn_uchar_t *)"region",						/* gnpl_crit_field_album_region		*/
	(gn_uchar_t *)"genre (v1)",					/* gnpl_crit_field_album_genre		*/
	(gn_uchar_t *)"genre",						/* gnpl_crit_field_album_genrev2	*/

	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_07	*/	/* unsupported */
	
	(gn_uchar_t *)"artist region",				/* gnpl_crit_field_artist_region	*/
	(gn_uchar_t *)"era",						/* gnpl_crit_field_artist_era		*/
	(gn_uchar_t *)"artist type",				/* gnpl_crit_field_artist_type		*/

	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_08	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_09	*/	/* unsupported */
	
	(gn_uchar_t *)"play count",					/* gnpl_crit_field_track_playcount	*/
	(gn_uchar_t *)"user rating",				/* gnpl_crit_field_track_myrating	*/

	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_10	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_11	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_12	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_13	*/	/* unsupported */
	
	(gn_uchar_t *)"developer field 1",			/* gnpl_crit_field_xdev1		*/
	(gn_uchar_t *)"developer field 2",			/* gnpl_crit_field_xdev2		*/
	(gn_uchar_t *)"developer field 3",			/* gnpl_crit_field_xdev3		*/
	(gn_uchar_t *)"developer field",			/* gnpl_crit_field_xdev			*/
	
	(gn_uchar_t *)"tag id",						/* gnpl_crit_field_tagid		*/
	(gn_uchar_t *)"path",						/* gnpl_crit_field_path_name	*/
	(gn_uchar_t *)"Genre description",			/* gnpl_crit_field_genredesc	*/
	(gn_uchar_t *)"Composer",					/* gnpl_crit_field_track_composer		*/
	(gn_uchar_t *)"Conductor",					/* gnpl_crit_field_track_conductor		*/
	(gn_uchar_t *)"Ensemble",					/* gnpl_crit_field_track_ensemble		*/

	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_14	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_15	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_16	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_17	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_18	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_19	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_20	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_21	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_22	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_23	*/	/* unsupported */
	(gn_uchar_t *)"",							/* gnpl_crit_field_reserved_24	*/	/* unsupported */

	(gn_uchar_t *)"INDEV1",						/* gnpl_crit_field_idx_numdev1 */
	(gn_uchar_t *)"INDEV2",						/* gnpl_crit_field_idx_numdev2 */
	(gn_uchar_t *)"INDEV3",						/* gnpl_crit_field_idx_numdev3 */

	(gn_uchar_t *)"IADEV1",						/* gnpl_crit_field_idx_alphdev1 */
	(gn_uchar_t *)"IADEV2",						/* gnpl_crit_field_idx_alphdev2 */
	(gn_uchar_t *)"IADEV3",						/* gnpl_crit_field_idx_alphdev3 */

	(gn_uchar_t *)"NDEV1",						/* gnpl_crit_field_numdev1 */
	(gn_uchar_t *)"NDEV2",						/* gnpl_crit_field_numdev2 */
	(gn_uchar_t *)"NDEV3",						/* gnpl_crit_field_numdev3 */
	(gn_uchar_t *)"NDEV4",						/* gnpl_crit_field_numdev4 */
	(gn_uchar_t *)"NDEV5",						/* gnpl_crit_field_numdev5 */

	(gn_uchar_t *)"ADEV1",						/* gnpl_crit_field_alphdev1 */
	(gn_uchar_t *)"ADEV2",						/* gnpl_crit_field_alphdev2 */
	(gn_uchar_t *)"ADEV3",						/* gnpl_crit_field_alphdev3 */
	(gn_uchar_t *)"ADEV4",						/* gnpl_crit_field_alphdev4 */
	(gn_uchar_t *)"ADEV5",						/* gnpl_crit_field_alphdev5 */

	(gn_uchar_t *)"Mood",						/* gnpl_crit_field_primary_mood_id		*/
	(gn_uchar_t *)"Tempo",						/* gnpl_crit_field_primary_tempo_id		*/
	(gn_uchar_t *)"General",					/* gnpl_crit_field_track_general_dsp	*/

	(gn_uchar_t *)""							/* gnpl_crit_field_last */
};

const gn_uchar_t* gnpl_op_descriptions[gnpl_crit_op_last+1] = 
{
	(gn_uchar_t *)"",							/* gnpl_crit_op_str_first	*/
	(gn_uchar_t *)"is equal to %s",				/* gnpl_crit_op_str_eq		*/
	(gn_uchar_t *)"is not equal to %s",			/* gnpl_crit_op_str_neq		*/
	(gn_uchar_t *)"contains %s",				/* gnpl_crit_op_str_cont	*/
	(gn_uchar_t *)"does not contain %s",		/* gnpl_crit_op_str_ncont	*/
	(gn_uchar_t *)"starts with %s",				/* gnpl_crit_op_str_sta		*/
	(gn_uchar_t *)"ends with %s",				/* gnpl_crit_op_str_end		*/
	(gn_uchar_t *)"",							/* gnpl_crit_op_str_last	*/

	(gn_uchar_t *)"",							/* gnpl_crit_op_num_first	*/
	(gn_uchar_t *)"is equal to %s",				/* gnpl_crit_op_num_eq		*/
	(gn_uchar_t *)"is not equal to %s",			/* gnpl_crit_op_num_neq		*/
	(gn_uchar_t *)"is less than %s",			/* gnpl_crit_op_num_lt		*/
	(gn_uchar_t *)"is greater than %s",			/* gnpl_crit_op_num_gt		*/
	(gn_uchar_t *)"is between %s and %s",		/* gnpl_crit_op_num_rang	*/
	(gn_uchar_t *)"",							/* gnpl_crit_op_num_last	*/

	(gn_uchar_t *)"",							/* gnpl_crit_op_enum_first	*/
	(gn_uchar_t *)"is equal to %s",				/* gnpl_crit_op_enum_eq		*/
	(gn_uchar_t *)"is not equal to %s",			/* gnpl_crit_op_enum_neq	*/
	(gn_uchar_t *)"is similar to %s (%s similarity, %s variation)",			/* gnpl_crit_op_enum_sim	*/
	(gn_uchar_t *)"",							/* gnpl_crit_op_enum_last	*/

	(gn_uchar_t *)"",							/* gnpl_crit_op_date_first	*/
	(gn_uchar_t *)"is equal to %s",				/* gnpl_crit_op_date_eq		*/
	(gn_uchar_t *)"is not equal to %s",			/* gnpl_crit_op_date_neq	*/
	(gn_uchar_t *)"is before %s",				/* gnpl_crit_op_date_lt		*/
	(gn_uchar_t *)"is after %s",				/* gnpl_crit_op_date_gt		*/
	(gn_uchar_t *)"is between %s and %s",		/* gnpl_crit_op_date_rang	*/
	(gn_uchar_t *)"is in the last %s days",		/* gnpl_crit_op_date_inlast	*/
	(gn_uchar_t *)"is not in the last %s days",	/* gnpl_crit_op_date_notinlast	*/
	(gn_uchar_t *)"",							/* gnpl_crit_op_date_last	*/
	(gn_uchar_t *)"",							/* gnpl_crit_op_enum_rang	*/

	(gn_uchar_t *)"",							/* gnpl_crit_op_kiva_first	*/
	(gn_uchar_t *)"is equal to %s",				/* gnpl_crit_op_kiva_eq		*/
	(gn_uchar_t *)"is not equal to %s",			/* gnpl_crit_op_kiva_neq	*/
	(gn_uchar_t *)"is similar to %s (%s similarity, %s variation)",			/* gnpl_crit_op_kiva_sim	*/
	(gn_uchar_t *)"",							/* gnpl_crit_op_kiva_last	*/

	(gn_uchar_t *)""							/* gnpl_crit_op_last		*/
};


