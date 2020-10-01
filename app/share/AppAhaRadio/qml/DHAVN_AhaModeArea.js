/** ModeArea */
.pragma library

var SEARCH_BAR = 0
var RIGHT_BTN_2 = 1    //wsuk.kim title_bar
var RIGHT_BTN_1 = 2    //wsuk.kim title_bar
var RIGHT_BTN = 3
var MENU_BTN = 4
var BACK_BTN = 5

var const_WIDGET_WIDTH = 1280
var const_WIDGET_Y = 93
var const_WIDGET_HEIGHT = 72 //modified by HWS 2013.04.11 for New UX

/** Main layout of ModeArea */
var const_WIDGET_LANGCONTEXT = "main"
var const_WIDGET_SPACING = 0 // changed by minho 20120829 for display focus on back button
var const_WIDGET_RIGHTMARGIN = 3 //0 //modified by HWS 2013.04.11 for New UX
// modified by minho 20120821
// { for NEW UX: Added active tab on media
//var const_WIDGET_LEFTMARGIN = 7
var const_WIDGET_LEFTMARGIN = 5
// } modified by minho

//hsryu_0618_trackmode_btn
// Mode area right button
var const_AHA_MODE_WIDGET_RB_WIDTH = 138
var const_AHA_MODE_WIDGET_CONTENTS_WIDTH = 184

/** Common for Right and Back buttons */
var const_SPIN_CTRL_COLOR_TEXT_BRIGHT_GREY = "#FAFAFA"

var const_WIDGET_RB_COLOR = "#FAFAFA"
var const_WIDGET_RB_COLOR_DISABLED = "#9E9E9E"
var const_WIDGET_RB_FONT_SIZE = 30

var const_WIDGET_BG_IMG = "/app/share/images/general/bg_title.png"
var const_WIDGET_BUTTON_TEXT_FONT_FAMILY = "NewHDB"    //added by aettie.ji 2012.11.22 for New UX

/** Right button */
var const_WIDGET_RB_IMG_NORMAL = "/app/share/images/general/btn_title_sub_n.png"
var const_WIDGET_RB_IMG_PRESSED = "/app/share/images/general/btn_title_sub_p.png"
var const_WIDGET_RB_FOCUS_IMG = "/app/share/images/general/btn_title_sub_f.png"
var const_WIDGET_RB_FOCUS_IMG_PRESSED = "/app/share/images/general/btn_title_sub_fp.png"

// added by minho 20120821
// { for NEW UX: Added menu button on ModeArea
/** Menu button */
var const_WIDGET_MB_IMG_NORMAL = "/app/share/images/general/btn_title_sub_n.png"
var const_WIDGET_MB_IMG_PRESSED = "/app/share/images/general/btn_title_sub_p.png"
var const_WIDGET_MB_FOCUS_IMG = "/app/share/images/general/btn_title_sub_f.png"
var const_WIDGET_MB_FOCUS_IMG_PRESSED = "/app/share/images/general/btn_title_sub_fp.png"
// } added by minho

/** Back button */
//{ added by yongkyun.lee 20130215 for : ISV 73369
//var const_WIDGET_BB_IMG_NORMAL = "/app/share/images/general/general/btn_title_back_n.png"
//var const_WIDGET_BB_IMG_PRESSED = "/app/share/images/general/general/btn_title_back_p.png"
//var const_WIDGET_BB_IMG_FOCUS = "/app/share/images/general/general/btn_title_back_f.png"
//var const_WIDGET_BB_FOCUS_PRESSED = "/app/share/images/general/general/btn_title_back_fp.png"
var const_WIDGET_BB_IMG_NORMAL = "/app/share/images/general/btn_title_back_n.png"
var const_WIDGET_BB_IMG_PRESSED = "/app/share/images/general/btn_title_back_p.png"
var const_WIDGET_BB_IMG_FOCUS = "/app/share/images/general/btn_title_back_f.png"
var const_WIDGET_BB_FOCUS_PRESSED = "/app/share/images/general/btn_title_back_fp.png"
//} added by yongkyun.lee 20130215

/** Title text */
var const_WIDGET_TITLE_COLOR = "#FAFAFA"
//{ modifyed by eunhye 2012.08.27 for Music(LGE) # 39
//var const_WIDGET_TITLE_TEXT_SIZE = 26
var const_WIDGET_TITLE_TEXT_SIZE = 40
//} modifyed by eunhye 2012.08.27 for 
var const_WIDGET_TITLE_TEXT_LEFTMARGIN = 45
var const_WIDGET_CONNECT_TITLE_TEXT_LEFTMARGIN = 185

/** Counter text */
var const_WIDGET_COUNT_FONT_SIZE = 30
var const_WIDGET_COUNTER_TEXT_FONT_FAMILY_NEW = "NewHDB"
//var const_WIDGET_COUNTER_TEXT_PIXEL_SIZE = 35
var const_WIDGET_COUNTER_TEXT_PIXEL_SIZE = 30 //modified by aettie.ji 2012.12.20 for new ux
var const_WIDGET_COUNTER_TEXT_COLOR = "#7CBDFF"

/** Icons */
var const_WIDGET_CATEGORY_ICON_VERTICAL_OFFSET = 33 //added by aettie.ji 2012.12.20 for new ux

/** Tab grouped buttons */
var const_WIDGET_TAB_MEDIA_BUTTON_NORMAL = "/app/share/images/general/btn_title_media_n.png"
var const_WIDGET_TAB_MEDIA_BUTTON_PRESSED = "/app/share/images/general/btn_title_media_p.png"
var const_WIDGET_TAB_MEDIA_BUTTON_FOCUSED = "/app/share/images/general/btn_title_media_f.png"
var const_WIDGET_TAB_MEDIA_BUTTON_FOCUSED_PRESSED = "/app/share/images/general/btn_title_media_fp.png"
// { added by lssanh 2012.09.22 for music_tab
var const_WIDGET_MUSIC_TAB_MEDIA_BUTTON_NORMAL = "/app/share/images/general/btn_title_music_n.png"
var const_WIDGET_MUSIC_TAB_MEDIA_BUTTON_PRESSED = "/app/share/images/general/btn_title_music_p.png"
var const_WIDGET_MUSIC_TAB_MEDIA_BUTTON_FOCUSED = "/app/share/images/general/btn_title_music_f.png"
var const_WIDGET_MUSIC_TAB_MEDIA_BUTTON_FOCUSED_PRESSED = "/app/share/images/general/btn_title_music_fp.png"
// } added by lssanh 2012.09.22 for music_tab

var const_WIDGET_TAB_TEXT_FONT_SIZE = 30
var const_WIDGET_TAB_TEXT_FONT_FAMILY = "NewHDB"
var const_WIDGET_TAB_TEXT_FONT_COLOR_BRIGHT_GREY = "#FAFAFA"

var const_WIDGET_TAB_BUTTON_BOTTOM_MARGIN = 2
// modified by minho 20120821
// { for NEW UX: Added active tab on media
//var const_WIDGET_TAB_BUTTON_WIDTH = 165
var const_WIDGET_TAB_BUTTON_WIDTH = 170 
// } modified by minho
var const_WIDGET_MUSIC_TAB_BUTTON_WIDTH = 147 // added by lssanh 2012.09.22 for music_tab
var const_WIDGET_TAB_BUTTON_HEIGHT = 72

var const_WIDGET_SEARCHBAR_QML = "DHAVN_ModeArea_SearchBar.qml"

/** Search bar */
var const_WIDGET_SEARCH_IMG = "/app/share/images/music/music_searchbar.png"
var const_WIDGET_SEARCH_TEXT_LEFTMARGIN = 114
var const_WIDGET_SEARCH_TEXT_COLOR = "#9E9E9E"
var const_WIDGET_SEARCH_TEXT_PT = 36
var const_WIDGET_SEARCH_TEXT_RIGHTMARGIN = 12
var const_WIDGET_SEARCH_FOCUS_COLOR = "#0087EF"

// { added by eugene 2012.12.12 for NewUX - Photo #5-2
/** Phto list image icons */
var const_PHOTOLIST_IMAGE_ICON_RIGHTMARGIN = 332
var const_PHOTOPLAY_IMAGE_ICON_RIGHTMARGIN = 450
var const_FOLDER_IMAGE_ICON_IMG = "/app/share/images/photo/list_ico_folder.png"
var const_PHOTO_IMAGE_ICON_IMG = "/app/share/images/photo/list_ico_photo.png"
// } added by eugene 2012.12.12 for NewUX - Photo #5-2

//wsuk.kim title_bar
var const_APP_AHA_TRACK_VIEW_ICON_NAVIGATION = "/app/share/images/aha/ico_navi.png"
var const_APP_AHA_TRACK_VIEW_ICON_NAVIGATION_N = "/app/share/images/aha/ico_navi_n.png"
var const_APP_AHA_TRACK_VIEW_ICON_NAVIGATION_D = "/app/share/images/aha/ico_navi_d.png"
var const_APP_AHA_TRACK_VIEW_ICON_CALL = "/app/share/images/aha/ico_call.png"
var const_APP_AHA_TRACK_VIEW_ICON_CALL_N = "/app/share/images/aha/ico_call_n.png"
var const_APP_AHA_TRACK_VIEW_ICON_CALL_D = "/app/share/images/aha/ico_call_d.png"
//wsuk.kim title_bar
