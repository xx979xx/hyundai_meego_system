/**
 * DHAVN_AppPandoraRes.js
 */
.pragma library

var const_APP_PANDORA_URL_IMG_GENERAL_BACKGROUND_1 = "/app/share/images/general/bg_main.png"//modified by esjang 2013.04.16 for new ux
var const_APP_PANDORA_URL_IMG_GENERAL_BACKGROUND_F = "/app/share/images/general/bg_full_f.png" //added by wonseok.heo for ITS 266944 2015.07.30

var const_APP_PANDORA_URL_IMG_ICON_PLAY = "/app/share/images/pandora/icon_play.png"
var const_APP_PANDORA_URL_IMG_ICON_PAUSE = "/app/share/images/pandora/icon_pause.png"

var const_APP_PANDORA_URL_IMG_ICON_SEARCH = "/app/share/images/music/icon_search.png"
var const_APP_PANDORA_URL_IMG_ICON_INDEX = "/app/share/images/music/icon_index.png"


var const_APP_PANDORA_URL_IMG_LOCKOUT_ICON = "/app/share/images/general/ico_block.png" // added by wonseok.heo for driving

/**********************************************************/
// Pandora Connecting Screen specific
/**********************************************************/
var const_APP_PANDORA_CONNECTING_WAIT = new Array()
//{ modified by cheolhwan 2013.11.27. for Guideline Pandora v2.0.4
//const_APP_PANDORA_CONNECTING_WAIT[0] = "/app/share/images/pandora/loading/loading_01.png"
//const_APP_PANDORA_CONNECTING_WAIT[1] = "/app/share/images/pandora/loading/loading_02.png"
//const_APP_PANDORA_CONNECTING_WAIT[2] = "/app/share/images/pandora/loading/loading_03.png"
//const_APP_PANDORA_CONNECTING_WAIT[3] = "/app/simages/pandora/loading/loading_04.png"
//const_APP_PANDORA_CONNECTING_WAIT[4] = "/app/share/images/pandora/loading/loading_05.png"
//const_APP_PANDORA_CONNECTING_WAIT[5] = "/app/share/images/pandora/loading/loading_06.png"
//const_APP_PANDORA_CONNECTING_WAIT[6] = "/app/share/images/pandora/loading/loading_07.png"
//const_APP_PANDORA_CONNECTING_WAIT[7] = "/app/share/images/pandora/loading/loading_08.png"
//const_APP_PANDORA_CONNECTING_WAIT[8] = "/app/share/images/pandora/loading/loading_09.png"
//const_APP_PANDORA_CONNECTING_WAIT[9] = "/app/share/images/pandora/loading/loading_10.png"
//const_APP_PANDORA_CONNECTING_WAIT[10] = "/app/share/images/pandora/loading/loading_11.png"
//const_APP_PANDORA_CONNECTING_WAIT[11] = "/app/share/images/pandora/loading/loading_12.png"
//const_APP_PANDORA_CONNECTING_WAIT[12] = "/app/share/images/pandora/loading/loading_13.png"
//const_APP_PANDORA_CONNECTING_WAIT[13] = "/app/share/images/pandora/loading/loading_14.png"
//const_APP_PANDORA_CONNECTING_WAIT[14] = "/app/share/images/pandora/loading/loading_15.png"
//const_APP_PANDORA_CONNECTING_WAIT[15] = "/app/share/images/pandora/loading/loading_16.png"
const_APP_PANDORA_CONNECTING_WAIT[0] = "/app/share/images/aha/loading/loading_01.png"
const_APP_PANDORA_CONNECTING_WAIT[1] = "/app/share/images/aha/loading/loading_02.png"
const_APP_PANDORA_CONNECTING_WAIT[2] = "/app/share/images/aha/loading/loading_03.png"
const_APP_PANDORA_CONNECTING_WAIT[3] = "/app/share/images/aha/loading/loading_04.png"
const_APP_PANDORA_CONNECTING_WAIT[4] = "/app/share/images/aha/loading/loading_05.png"
const_APP_PANDORA_CONNECTING_WAIT[5] = "/app/share/images/aha/loading/loading_06.png"
const_APP_PANDORA_CONNECTING_WAIT[6] = "/app/share/images/aha/loading/loading_07.png"
const_APP_PANDORA_CONNECTING_WAIT[7] = "/app/share/images/aha/loading/loading_08.png"
const_APP_PANDORA_CONNECTING_WAIT[8] = "/app/share/images/aha/loading/loading_09.png"
const_APP_PANDORA_CONNECTING_WAIT[9] = "/app/share/images/aha/loading/loading_10.png"
const_APP_PANDORA_CONNECTING_WAIT[10] = "/app/share/images/aha/loading/loading_11.png"
const_APP_PANDORA_CONNECTING_WAIT[11] = "/app/share/images/aha/loading/loading_12.png"
const_APP_PANDORA_CONNECTING_WAIT[12] = "/app/share/images/aha/loading/loading_13.png"
const_APP_PANDORA_CONNECTING_WAIT[13] = "/app/share/images/aha/loading/loading_14.png"
const_APP_PANDORA_CONNECTING_WAIT[14] = "/app/share/images/aha/loading/loading_15.png"
const_APP_PANDORA_CONNECTING_WAIT[15] = "/app/share/images/aha/loading/loading_16.png"
//} modified by cheolhwan 2013.11.27. for Guideline Pandora v2.0.4

/**********************************************************/
// Pandora Connecting Off Screen specific
/**********************************************************/

var const_APP_PANDORA_ERROR_VIEW_WARNING_IMG = "/app/share/images/pandora/icon_warning.png"
//{ add by cheolhwan 2013.12.04 for ITS 212559 (by GUI guideline).
//var const_APP_PANDORA_ERROR_VIEW_OK_NORMAL = "/app/share/images/pandora/btn_ok_n.png"
//var const_APP_PANDORA_ERROR_VIEW_OK_PRESSED = "/app/share/images/pandora/btn_ok_p.png"
//var const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED = "/app/share/images/pandora/btn_ok_f.png"
var const_APP_PANDORA_ERROR_VIEW_OK_NORMAL = "/app/share/images/aha/btn_ok_n.png"
var const_APP_PANDORA_ERROR_VIEW_OK_PRESSED = "/app/share/images/aha/btn_ok_p.png"
var const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED = "/app/share/images/aha/btn_ok_f.png"
//} add by cheolhwan 2013.12.04 for ITS 212559 (by GUI guideline).



/**********************************************************/
// Pandora Track View Screen specific
/**********************************************************/
var const_APP_PANDORA_TRACK_VIEW_ICON_STATION_IMG = "/app/share/images/pandora/bg_station.png"
var const_APP_PANDORA_TRACK_VIEW_ICON_SHUFFLE_IMG = "/app/share/images/pandora/ico_main_shuffle.png" // added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
var const_APP_PANDORA_TRACK_VIEW_ICON_MUSIC_IMG = "/app/share/images/music/basic_ico_song.png"
var const_APP_PANDORA_TRACK_VIEW_ICON_ALBUM_IMG = "/app/share/images/music/basic_ico_album.png"
var const_APP_PANDORA_TRACK_VIEW_ICON_ARTIST_IMG = "/app/share/images/music/basic_ico_artist.png"
var const_APP_PANDORA_TRACK_VIEW_ALBUM_BG_IMG = "/app/share/images/pandora/album_bg.png"
var const_APP_PANDORA_TRACK_VIEW_ICON_THUMBS_UP_S = "/app/share/images/pandora/icon_thumbs_up_s.png"
var const_APP_PANDORA_TRACK_VIEW_ICON_THUMBS_DOWN_S = "/app/share/images/pandora/icon_tumbs_down_s.png"
var const_APP_PANDORA_TRACK_VIEW_ICON_THUMBS_UP_N = "/app/share/images/pandora/icon_thumbs_up_n.png"
var const_APP_PANDORA_TRACK_VIEW_ICON_THUMBS_DOWN_N = "/app/share/images/pandora/icon_tumbs_down_n.png"
var const_APP_PANDORA_TRACK_VIEW_NO_ALBUM_ART_IMG = "/app/share/images/music/basic_album_light.png"// esjang 2013.04.16 "/app/share/images/pandora/noImageAvailable.jpg"
var const_APP_PANDORA_TRACK_VIEW_ALBUM_BG_IMG_2 =  "/app/share/images/music/basic_album_bg.png"// added by esjang 2013.04.17 for new ux

var const_APP_PANDORA_TRACK_VIEW_PANDORALOGO_IMAGE = "/app/share/images/pandora/logo_pandora.png"

var const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_S = "/app/share/images/pandora/ico_like_up_s.png"
var const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_N = "/app/share/images/pandora/ico_like_up_n.png"
var const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_D = "/app/share/images/pandora/ico_like_up_d.png"
var const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_P = "/app/share/images/pandora/ico_like_up_p.png"

// add from wonseok.heo for bookmark icon 2015.04.21
var const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_S = "/app/share/images/pandora/ico_bookmark_s.png"
var const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_N = "/app/share/images/pandora/ico_bookmark_n.png"
var const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_D = "/app/share/images/pandora/ico_bookmark_d.png"
var const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_P = "/app/share/images/pandora/ico_bookmark_p.png"
var const_APP_PANDORA_TRACK_VIEW_SHARE_STATION    = "/app/share/images/pandora/ico_share_station.png" // added by wonseok.heo for DH PE


var const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_S = "/app/share/images/pandora/ico_like_down_s.png"
var const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_N = "/app/share/images/pandora/ico_like_down_n.png"
var const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_D = "/app/share/images/pandora/ico_like_down_d.png"
var const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_P = "/app/share/images/pandora/ico_like_down_p.png"

var const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_N = "/app/share/images/general/media_visual_cue_n.png"
var const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_F = "/app/share/images/general/media_visual_cue_f.png"
var const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_D = "/app/share/images/general/media_visual_cue_d.png"
var const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_P = "/app/share/images/general/media_visual_cue_p.png" // added by cheolhwan 2014-01-14. ITS 218715.
var const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_P = "/app/share/images/general/media_for_p.png"
var const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N = "/app/share/images/general/media_for_n.png"
var const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D = "/app/share/images/general/media_for_d.png"
var const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_F = "/app/share/images/general/media_for_f.png" //added by cheolhwan 2014-03-22. ITS 230499.

var const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N = "/app/share/images/general/media_play_02_n.png" // esjang 2012.12.18
var const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_D = "/app/share/images/general/media_play_02_d.png" // esjang 2012.12.18
var const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_P = "/app/share/images/general/media_play_02_p.png" // esjang 2012.12.18
var const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N = "/app/share/images/general/media_pause_n.png"
var const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_D = "/app/share/images/general/media_pause_d.png"
var const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_P = "/app/share/images/general/media_pause_p.png"
/**********************************************************/
// Pandora Wait View Screen specific
/**********************************************************/
var const_APP_PANDORA_WAIT_VIEW_LOGO_PANDORA_IMG = "/app/share/images/pandora/logo_pandora.png"

/**********************************************************/
// Pandora List View Screen specific
/**********************************************************/
var const_APP_PANDORA_LIST_VIEW_LIST_LINE ="/app/share/images/general/list_line.png"
var const_APP_PANDORA_LIST_VIEW_BG_LIST_ALPHABET = "/app/share/images/pandora/bg_list_alphabet.png"
var const_APP_PANDORA_LIST_VIEW_ICON_QUICKMIX = "/app/share/images/pandora/ico_quickmix.png"
var const_APP_PANDORA_LIST_VIEW_ICON_STATION_IMG = "/app/share/images/pandora/bg_station.png"
var const_APP_PANDORA_DEFAULT_STATION_ICON_IMG =   "/app/share/images/pandora/bg_station_B.png" //added by wonseok.heo 2014.10.29

var const_APP_PANDORA_LIST_VIEW_BG_STATION_LIST_IMG = "/app/share/images/pandora/bg_station_list.png" // added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
var const_APP_PANDORA_USB_DEVICE_TYPE_ICON = "/app/share/images/music/icon_usb_n.png"

var const_APP_PANDORA_LIST_VIEW_ICON_FOCUS = "/app/share/images/pandora/icon_focus.png"
//var const_APP_PANDORA_LIST_VIEW_ITEM_HEADING_BACKGROUND = "/app/share/images/pandora/tab_list_index.png"
var const_APP_PANDORA_LIST_VIEW_ITEM_HEADING_BACKGROUND = "/app/share/images/pandora/tab_list_pandora_index.png"
var const_APP_PANDORA_LIST_VIEW_ITEM_BACKGROUND = "/app/share/images/general/list_p.png"
var const_APP_PANDORA_LIST_VIEW_ITEM_BORDER_IMAGE = "/app/share/images/general/list_f.png"
//var const_APP_PANDORA_LIST_VIEW_ITEM_BORDER_IMAGE = "/app/share/images/pandora/list_f.png"
var const_APP_PANDORA_LIST_VIEW_CURRENT_TRACK_SIGN_IMAGE = "/app/share/images/dmb/ico_play.png"
var const_APP_PANDORA_LIST_VIEW_ITEM_LIST_LINE ="/app/share/images/general/list_line.png"
//var const_APP_PANDORA_LIST_VIEW_ITEM_PRESSED = "/app/share/images/general/list_fp.png"
var const_APP_PANDORA_LIST_VIEW_ITEM_PRESSED = "/app/share/images/pandora/list_p.png"
//var const_APP_PANDORA_LIST_VIEW_ITEM_RELEASED = "/app/share/images/general/list_p.png"
var const_APP_PANDORA_LIST_VIEW_ITEM_RELEASED = "/app/share/images/pandora/list_f.png"
//{ modified by yongkyun.lee 2014-03-21 for : ITS 230348
//var const_APP_PANDORA_LIST_VIEW_POPUP_QUICKSCROLL_BG = "/app/share/images/pandora/bg_popup_quickscroll.png"
var const_APP_PANDORA_LIST_VIEW_POPUP_QUICKSCROLL_BG = "/app/share/images/music/quickscroll_popup.png"
//} modified by yongkyun.lee 2014-03-21 for : ITS 230348
var const_APP_PANDORA_LIST_VIEW_ALPHAMENU_BG = "/app/share/images/music/quickscroll_bg.png"
var const_APP_PANDORA_LIST_VIEW_ALPHAMENU_DOT_IMAGE = "/app/share/images/music/quickscroll_dot.png"
var const_APP_PANDORA_LIST_VIEW_ICON_SHARED = "/app/share/images/xm_data/icon_shared.png" // added by jyjeon 2013.12.09 for UX Update 
/**********************************************************/
//searck keyboard
/**********************************************************/
//var const_APP_PANDORA_SEARCH_BOX ="/app/share/images/home/bg_search_bar.png"
//var const_APP_PANDORA_IMG_BTN_SEARCH_P = "/app/share/images/general/btn_mode_p.png"
//var const_APP_PANDORA_IMG_BTN_SEARCH_N = "/app/share/images/general/btn_mode_6_n.png"
//var const_APP_PANDORA_IMG_BTN_SEARCH_F = "/app/share/images/general/bg_top_btn_f.png"

///** Back button */
//var const_WIDGET_BB_IMG_NORMAL = "/app/share/images/general/btn_back_n.png"
//var const_WIDGET_BB_IMG_PRESSED = "/app/share/images/general/btn_back_p.png"

/**********************************************************************/
var const_APP_PANDORA_DEVICE_ICON_BG_N = "/app/share/images/pandora/btn_entry_n.png"
var const_APP_PANDORA_DEVICE_ICON_BG_P = "/app/share/images/pandora/btn_entry_p.png"
var const_APP_PANDORA_DEVICE_ICON_BG_FP = "/app/share/images/pandora/btn_entry_fp.png"
var const_APP_PANDORA_DEVICE_ICON_BG_F = "/app/share/images/pandora/btn_entry_f.png"
var const_APP_PANDORA_DEVICE_ICON_CONNECTION_USB_TYPE = "/app/share/images/pandora/ico_ipod.png"
var const_APP_PANDORA_DEVICE_ICON_CONNECTION_BT_TYPE = "/app/share/images/pandora/ico_bt.png"

var const_APP_PANDORA_EXPLAIN_VIEW_BG_MASK = "/app/share/images/pandora/bg_mask.png"

/**PopUp images*/
var const_POPUP_LOAD_RES_PATH = "/app/share/images/pandora/loading/"
var const_LOADING_IMG = const_POPUP_LOAD_RES_PATH + "loading_01.png"

//==========================Added for new ux
var const_IMG_ALBUM_LIGHT =  "/app/share/images/music/basic_album_light.png"
var const_BG_BASIC_BOTTOM_IMG = "/app/share/images/music/bg_basic_bottom.png"
//==========================Added for new ux


//=============Search view mode area
//searck keyboard
/**********************************************************/
var const_APP_PANDORA_SEARCH_BOX ="/app/share/images/Qwertykeypad/bg_search_m.png"
var const_APP_PANDORA_KEYPAD_BG = "/app/share/images/keypad/bg_keypad.png"
var const_CURSOR =  "/app/share/images/Qwertykeypad/cursor.png"
//{ modified by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
var const_CURSOR_F =  "/app/share/images/AppBtPhone/keypad/cursor_f.png"
var const_CURSOR_N =  "/app/share/images/AppBtPhone/keypad/cursor_n.png"
//} modified by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
var const_MARKER =  "/app/share/images/Qwertykeypad/ico_marker.png"

/** Menu button */
var const_WIDGET_MB_IMG_NORMAL = "/app/share/images/general/btn_title_sub_n.png"
var const_WIDGET_MB_IMG_PRESSED = "/app/share/images/general/btn_title_sub_p.png"
var const_WIDGET_MB_FOCUS_IMG = "/app/share/images/general/btn_title_sub_f.png"
var const_WIDGET_MB_FOCUS_IMG_PRESSED = "/app/share/images/general/btn_title_sub_fp.png"

/** back button */
var const_WIDGET_BB_IMG_NORMAL = "/app/share/images/general/btn_title_back_n.png"
var const_WIDGET_BB_IMG_PRESSED = "/app/share/images/general/btn_title_back_p.png"
var const_WIDGET_BB_IMG_FOCUS = "/app/share/images/general/btn_title_back_f.png"
var const_WIDGET_BB_FOCUS_PRESSED = "/app/share/images/general/btn_title_back_fp.png"

/** search  button */
var const_WIDGET_SB_IMG_N = "/app/share/images/Qwertykeypad/icon_title_search_n.png"
var const_WIDGET_SB_IMG_D = "/app/share/images/Qwertykeypad/icon_title_search_d.png"
