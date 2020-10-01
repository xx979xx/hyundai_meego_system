.pragma library

//General
var  const_SCREEN_WIDTH = 1280
var  const_SCREEN_HEIGHT = 720
var  const_FULLSCREEN_DURATION_ANIMATION = 300// 500//modified by edo.lee 2013.08.09 ITS 183057
var  const_MILLISECONDS_IN_SEC = 1000
var  const_VIDEO_START_POSITION = 0
var  const_LANGCONTEXT = "main"
var  const_POPUP_TIMEOUT = 3000
var const_CONTENT_AREA_TOP_OFFSET = 166 // added by Sergey 08.05.2013
var const_FULL_SCREEN_OFFSET = 260 // added by edo.lee 2013.08.10 ITS 183057

// z-order
var  const_VIDEO_LAYER   = 100
var  const_CONTROL_LAYER = 200
var  const_POPUP_LAYER   = 300
//Status bar //modified by edo.lee 2013.04.04
var const_STATUSBAR_SHOW_TOP = 0
var const_STATUSBAR_HIDE_TOP = -166
//Mode Area
var const_MODEAREA_OFFSET_TOP = 93
var const_MODEAREA_INVALID_TAB_NUMBER = -1
var const_MODEAREA_JUKEBOX_TAB_NUMBER = 0
var const_MODEAREA_USB1_TAB_NUMBER = 1
var const_MODEAREA_USB2_TAB_NUMBER = 2
var const_MODEAREA_DISC_TAB_NUMBER = 3
var const_MODEAREA_AUX1_TAB_NUMBER = 4
var const_MODEAREA_AUX2_TAB_NUMBER = 5

//Cmd Button Area
var const_WIDGET_BTN_LEFT_FOCUS_LOST = 0
var const_WIDGET_BTN_RIGHT_FOCUS_LOST = 1

// { modified by Sergey 05.05.2013
//Video Progress Bar
var const_PB_DEFAULT_PARENT_OFFSET = 20
var const_PB_TITLE_CHAPTER_GAP = 39
var const_PB_CHAPTER_RIGHT_OFFSET = 360
var const_PB_CHAPTER_LEFT_OFFSET_ME = 360
var const_PB_RANDOM_LEFT_OFFSET = 1062
var const_PB_RANDOM_LEFT_OFFSET_ME = 42//22 modified by hyejin 2013.11.25 for ITS 0210851
var const_PB_REPEAT_LEFT_OFFSET = 1150
var const_PB_REPEAT_LEFT_OFFSET_ME = 130//110 modified by hyejin 2013.11.25 for ITS 0210851
var const_PB_REPEAT_BOTTOM_MARGIN = 88 //added by hyejin 2013.11.25 for ITS 0210851
//deleted by aettie same constant exists
var const_PB_FILE_LEFT_OFFSET_ME = 180
var const_PB_FILE_WIDTH = 1080
var const_PB_FOLDER_LEFT_OFFSET_ME = 734
var const_PB_VCD_TRACK_RIGHT_OFFSET = 359
var const_PB_VCD_TRACK_REPEAT_GAP = 95
var const_PB_VCD_TRACK_LEFT_OFFSET_ME = 360


var const_PB_OFFSET_LEFT_DEFAULT = 20
var const_PB_OFFSET_RIGHT_DEFAULT = 20
var const_PB_REPEAT_ID = "Repeat"
var const_PB_RANDOM_ID = "Random"
// } modified by Sergey 05.05.2013
// { modified by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
var const_PB_CURR_TIME_OFFSET = 1
var const_PB_CURR_TIME_WIDTH = 156
var const_PB_TOTAL_TIME_OFFSET = 1
var const_PB_TOTAL_TIME_WIDTH = 156
// } added by cychoi 2014.04.02

//Fonts
var const_FONT_FAMILY_HDB = "HDB"
var const_FONT_FAMILY_HDR = "HDR"       // added by aettie.ji 2010.11.2 for New UX Video #16
var const_FONT_FAMILY_NEW_HDB = "DH_HDB"
var const_FONT_FAMILY_NEW_HDR = "DH_HDR"       // added by aettie.ji 2010.11.2 for New UX Video #16

//Font color
var const_FONT_COLOR_BLACK = "#000000"
var const_FONT_COLOR_BRIGHT_GREY = "#FAFAFA"
var const_FONT_COLOR_GREY = "#C1C1C1"
var const_FONT_COLOR_BUTTON_GREY = "#2F2F2F"
var const_FONT_COLOR_WHITE = "#FFFFFF"
var const_FONT_COLOR_DIMMED_BLUE = "#447CAD"
var const_FONT_COLOR_DIMMED_GREY = "#9E9E9E"
var const_FONT_COLOR_PB_STATUS = "#0087EF"
var const_FONT_COLOR_PB_HIGHLIGHTED = "#800000"
var const_FONT_COLOR_RGB_BLUE_TEXT = "#7CBDFF" // modified by ravikanth 12-10-03

//Font Size
var const_FONT_SIZE_TIME = 24//34
var const_FONT_SIZE_BUTTON = 34
var const_FONT_SIZE_LIST = 40
var const_FONT_SIZE_SEARCH_TITLES = 28
var const_FONT_SIZE_POPUP_PLAYBACK_SPEED_LEVEL = 42


var const_FONT_SIZE_INITIALIZE_BUTTON = 24
var const_FONT_SIZE_TEXT_LIST_FONT = 36
var const_FONT_SIZE_TEXT_SUN_FONT = 21
var const_FONT_SIZE_TEXT_INDEX_FONT = 21
var const_FONT_SIZE_TEXT_HDR_32_FONT = 34
// { modified by eunhye 2012.08.14 for CR 12562
/*
var const_FONT_SIZE_TEXT_HDR_30_FONT = 32
var const_FONT_SIZE_TEXT_HDR_26_FONT = 28
*/
var const_FONT_SIZE_TEXT_HDR_30_FONT = 30
var const_FONT_SIZE_TEXT_HDR_26_FONT = 26
// } modified by eunhye
var const_FONT_SIZE_MODE_AREA = 24

//Settings>DVD
var const_DVD_SETTINGS_COUNT_FONT_SIZE = 3
//var const_DVD_SETTINGS_MARGIN_STATBAR = 82 //Need 93
var const_DVD_SETTINGS_MARGIN_STATBAR = 93 //modified by aettie 2013.03.21 for ITS 160768
var const_DVD_SETTINGS_MARGIN_MODEAREA = 83 //Need 73

//USB>Caption
var const_CAPTION_DEVIDER_TOP_OFFSET = 260
var const_CAPTION_DEVIDER_SPACING = 90
var const_CAPTION_CONTENT_TEXT_LEFT_OFFSET = 31
var const_CAPTION_CONTENT_LINE1_TOP_OFFSET = 186
var const_CAPTION_CONTENT_LINE2_TOP_OFFSET = const_CAPTION_CONTENT_LINE1_TOP_OFFSET + 87
var const_CAPTION_CONTENT_LINE3_TOP_OFFSET = const_CAPTION_CONTENT_LINE2_TOP_OFFSET + 90
var const_CAPTION_CONTENT_LINE4_TOP_OFFSET = const_CAPTION_CONTENT_LINE3_TOP_OFFSET + 90
var const_CAPTION_CONTENT_LINE5_TOP_OFFSET = const_CAPTION_CONTENT_LINE4_TOP_OFFSET + 95
var const_CAPTION_CONTENT_LINE1_LEFT_OFFSET = 1023
var const_CAPTION_CONTENT_LINE2_LEFT_OFFSET = 805
var const_CAPTION_CONTENT_LINE3_LEFT_OFFSET = 805
var const_CAPTION_CONTENT_LINE4_LEFT_OFFSET = 805
var const_CAPTION_CONTENT_LINE5_LEFT_OFFSET = 1023
var const_CAPTION_LIST_LINE1_TOP_OFFSET = 217
var const_CAPTION_VIEW_CAPTION_ITEM_INDEX = 0
var const_CAPTION_SYNC_CONTROL_ITEM_INDEX = 1
var const_CAPTION_FONT_SIZE_ITEM_INDEX = 2
var const_CAPTION_FONT_COLOR_ITEM_INDEX = 3
var const_CAPTION_FIND_CAPTION_ITEM_INDEX = 4
var const_USB_CAPTION_ITEM_WIDTH = 92
var const_USB_CAPTION_SLIDER_Y_INDENT = 15
var const_USB_CAPTION_SPIN_Y_INDENT = 10
var const_USB_CAPTION_TEXT_Y_INDENT = 20
var const_USB_CAPTION_SLIDER_X_INDENT = 1020
var const_USB_CAPTION_SPIN_X_INDENT = 800
var const_USB_CAPTION_LIST_LISTVIEW_Y_INDENT = 170
var const_USB_CAPTION_LIST_LISTVIEW_ITEM_HEIGHT = 93

var const_CAPTION_TYPE_SMALL = 0
var const_CAPTION_TYPE_NORMAL = 1
var const_CAPTION_TYPE_LARGE = 2
var const_CAPTION_SIZE_SMALL = 22
var const_CAPTION_SIZE_NORMAL = 32
var const_CAPTION_SIZE_LARGE = 42
var const_CAPTION_PLACE_BOTTOM_MARGIN = 50
var const_CAPTION_FONT_COLOR_STR = "white"
var const_CAPTION_FONT_COLOR_OUTLINE_STR = "black"

//USB List
var const_USB_LIST_ICON_PLAY_WIDTH = 38
var const_USB_LIST_ICON_PLAY_HEIGHT = 28
var const_USB_LIST_ICON_PLAY_X = 3
var const_USB_LIST_ICON_PLAY_Y = 11
var const_USB_LIST_TEXT_X = 41


var const_COLOR_TEXT_BRIGHT_GREY = "#FAFAFA"
var const_COLOR_TEXT_WHITE = "#FFFFFF"
var const_COLOR_TEXT_DIMMED_BLUE = "#447CAD"
var const_COLOR_TEXT_DIMMED_GREY = "#9E9E9E"

//USB list
var const_USB_LIST_THUMBNAIL_WIDTH = 245
var const_USB_LIST_THUMBNAIL_HEIGHT = 184
var const_USB_LIST_THUMBNAIL_TEXT_HEIGHT = 50
var const_USB_LIST_IMAGE_Y = 1
var const_USB_LIST_IMAGE_X = 1
var const_USB_LIST_HORIZONTAL_GAPE = 2
var const_USB_LIST_VERTICAL_GAPE = 30
var const_USB_LIST_THUMBNAIL_BORDER_WIDTH = 1
var const_USB_LIST_THUMBNAIL_FOCUSED_BORDER_WIDTH = 2
var const_USB_LIST_TOP_MARGIN = 197

var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_BUTTON_FONT = 34
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_24_FONT = 24
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_22_FONT = 22
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_24_FONT = 24
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_36_FONT = 36
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_29_FONT = 29
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_32_FONT = 32

var const_APP_MUSIC_PLAYER_COLOR_SUB_TEXT_GREY = "#D4D4D4"
var const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY = "#FAFAFA"


var const_SELECTION_COLOR = "#00aef8"
var const_TRANSPARENT_COLOR="#00ffffff"
var const_BORDER_SELECTION_WIDTH = 8

var const_DISC_MGR_CELL_WIDTH_AND_HEIGHT = 156
var const_DISC_MGR_CELL_WIDTH_AND_HEIGHT_LARGE_IMAGE = 350
var const_DISC_MGR_GRID_VIEW_TOP_MARGIN = 38
var const_GRID_VIEW_WIDTH =  621
var const_GRID_VIEW_HEIGHT = 424
var const_GRID_VIEW_CELL_WIDTH = 207
var const_GRID_VIEW_CELL_HEIGHT = 212
var const_VIRTUAL_CD_X = 12
var const_VIRTUAL_CD_Y = 10
var const_VIRTUAL_CD_IMAGE_WIDTH = 154
var const_VIRTUAL_CD_IMAGE_HEIGHT = const_VIRTUAL_CD_IMAGE_WIDTH
var const_BORDER_TOP_MARGIN = 4
var const_BORDER_LEFT_MARGIN = 18
var const_SELECTION_RECTANGLE_X_OFFSET = 6

//VCDMenuScreen
var const_VCD_MENU_ITEM_WIDTH = 158
var const_VCD_MENU_ITEM_HEIGHT = 78
var const_VCD_MENU_GAP = 3

var const_VCD_MENU_REPEAT_BTN_NUMBER = 0
var const_VCD_MENU_SHUFFLE_BTN_NUMBER = 1
var const_VCD_MENU_CAPTIONLANG_BTN_NUMBER = 2
var const_VCD_MENU_VOICELANG_BTN_NUMBER = 3
var const_VCD_MENU_PBCTOGGLE_BTN_NUMBER = 4

var const_VCD_PREV_BTN_NUMBER = 0
var const_VCD_PLAY_BTN_NUMBER = 1
var const_VCD_NEXT_BTN_NUMBER = 2
var const_VCD_MENU_BTN_NUMBER = 3
var const_VCD_SEARCH_BTN_NUMBER = 4

//Caption Screen
var const_FS_CAPTION_COUNT_FONT_SIZE = 3
var const_FS_CAPTION_FOCUS_NONE = 0
var const_FS_CAPTION_MARGIN_STATBAR = 82 //Need 93
var const_FS_CAPTION_MARGIN_MODEAREA = 83 //Need 73
var const_FS_CAPTION_TEXT_MARGIN_BOTTOM = 140
// { modified by junggil 2012.08.29 for NEW UX caption settings
//var const_FS_CAPTION_TEXT_SIZE = 20 // 28
//var const_FS_CAPTION_TEXT_SIZE = 28
var const_FS_CAPTION_TEXT_SIZE = 32 //modified by aettie.ji 2012.11.19 for New Ux
// } modified by junggil
var const_FS_CAPTION_TEXT_WIDTH = 490
var const_FS_CAPTION_TEXT_HEIGHT = 540 // added by Sergey 20.08.2013 for ITS#184640 
//DHAVN_VP_main.js
//TEXT CONST
var  const_SCREEN_WIDTH = 1280
var  const_SCREEN_HEIGHT = 720
var  const_MODE_AREA_WIDGET_Y = 120
var  const_DURATION_ANIMATION = 500

var const_START_ANGEL =   0
var const_END_ANGEL   = -30

var const_ZERO_ANGEL             =    0
var const_START_TRANSLATE_ANGEL  =  700
var const_FINISH_TRANSLATE_ANGEL = -1500


var const_ANIMATION_DURATION    =  500

var const_ANIMATION_DURATION_1  = 500

var const_THUMBNAIL_GRID_LEFT_POSITION = 190
var const_GRID_CELL_WIDTH   = 280
var const_GRID_CELL_WIDTH_SPACE = 44
var const_GRID_CELL_HEIGHT =  196
var const_GRID_CELL_HEIGHT_SPACE = 30
var const_GRID_CELL_FOCUS_WIDTH = const_GRID_CELL_WIDTH + 20
var const_GRID_CELL_FOCUS_HEIGHT = const_GRID_CELL_HEIGHT + 63

var const_THUMBNAIL_GRID_TOP_POSITION = 208
var const_TEXT_HEIGHT = 30

var const_TITLE_COLOR = "#FFFFFF"
var const_CAPTION_TEXT_SIZE = 28
var const_SELECTION_COLOR = "#00aef8"
var const_BACKGROUND_COLOR = "#778185"
var const_RIGHT_BUTTON_TITLE_TEXT="Title"
var const_BORDER_SELECTION_WIDTH = 8
var const_TITLE_TEXT_DELEGATE="Chapter"
var  const_CHAPTER_TEXT_DELEGATE="Title"
var  const_TRANSPARENT_SCREEN="#00ffffff"
var const_TITLE_TEXT_SIZE=18
var const_TOP_MARGIN_TEXT_FIELD = 10
var const_TITLE_LIST_ITEM_HEIGHT = 89


//Settings.js

var const_SCREEN_WIDTH = 1280
var const_SCREEN_HEIGHT =  720
var const_URL_IMG_BG_2 = "/app/share/images/music/bg_2.png"
var const_SCREEN_BACKGROUND_SHADOW = "/app/share/images/settings/shadow_bottom.png";
var const_Y_MODE_AREA_WIDGET = 120

var const_LEFT_AREA_BG_URL = "/app/share/images/settings/bg_menu.png";
var const_LEFT_AREA_BG_TOP_OFFSET = 168

var const_LEFT_AREA_WIDTH = 498
var const_LEFT_AREA_HEIGHT = 480
var const_LEFT_AREA_TOP_OFFSET = 162
var const_LEFT_AREA_FONT_SIZE = 40
var const_LEFT_AREA_FONT_COLOR   = "#9E9E9E"
var const_LEFT_AREA_FONT_COLOR_S = "#000000"
var const_LEFT_AREA_TEXT_LEFT_OFFSET = 62
var const_LEFT_AREA_ROW_HEIGHT = 90
var const_LEFT_AREA_ITEM_BG_URL_N = ""
var const_LEFT_AREA_ITEM_BG_URL_S = "/app/share/images/settings/bg_menu_s.png"
var const_LEFT_AREA_ITEM_BG_URL_P = "/app/share/images/settings/bg_menu_p.png"
var const_LEFT_AREA_ITEM_BG_URL_F = "/app/share/images/settings/bg_menu_f.png"
var const_LEFT_AREA_ITEM_BG_S_TOP_OFFSET = -4
var const_LEFT_AREA_ITEM_BG_S_LEFT_OFFSET = -4
var const_LEFT_AREA_DELIMITER_URL =  "/app/share/images/settings/line_menu.png"
var const_LEFT_AREA_DELIMITER_LEFT_OFFSET = 13

var const_CENTER_AREA_TOP_OFFSET = 172
var const_CENTER_AREA_LEFT_OFFSET = 502
var const_CENTER_AREA_WIDTH = const_SCREEN_WIDTH - const_LEFT_AREA_WIDTH
var const_CENTER_AREA_HEIGHT = const_SCREEN_HEIGHT - const_CENTER_AREA_TOP_OFFSET

var const_INITIALIZE_TOP_OFFSET = 354
var const_INITIALIZE_LEFT_OFFSET = 516
var const_INITIALIZE_WIDTH = 722
var const_INITIALIZE_TEXT_SIZE = 32
var const_INITIALIZE_TEXT_COLOR = "#FAFAFA"
var const_INITIALIZE_BUTTON_TOP_OFFSET = 92

var const_INITIALIZE_BUTTON_TEXT_SIZE = 34
var const_INITIALIZE_BUTTON_TEXT_COLOR = "#000000"
var const_INITIALIZE_BUTTON_TEXT_TYPE = "HDB"
var const_INITIALIZE_BUTTON_TEXT_TYPE_NEW = "DH_HDB"
var const_INITIALIZE_BUTTON_URL_N = "/app/share/images/settings/btn_browse_n.png"
var const_INITIALIZE_BUTTON_URL_P = "/app/share/images/settings/btn_browse_p.png"

var const_INDEX_FOR_ENGLISH_LANGUAGE = 0

var const_USB_CAPTION_TEXT_LEFT_MARGIN = 18
var const_VIDEO_PLAYER_SPIN_CONTROL = 2
var const_USB_CAPTION_BOTTOM_MARGIN = 11


/** Knob events */
var const_STATUS_BAR_INDEX = 1
var const_MODE_AREA_INDEX = 2
var const_ACTIVE_SCREEN_INDEX = 3
var const_BOTTOM_AREA_INDEX = 4

/** Repeat mode consts */
var const_REPEAT_OFF = 0
var const_REPEAT_FILE = 1
var const_REPEAT_FOLDER = 2

//Popups
var const_POPUP_ID_IMAGE_INFO = 1

var const_SEARCH_CHAPTER_ITEM_HEIGHT = 90
var const_SEARCH_CHAPTER_ITEM_SELECTED_BG_BOTTOM_MARGIN = -4
var const_SEARCH_CHAPTER_ITEM_TEXT_BOTTOM_MARGIN = 43
var const_SEARCH_CHAPTER_ITEM_NORMAL_TEXT_COLOR = "#9E9E9E"
var const_SEARCH_CHAPTER_ITEM_TEXT_SIZE = 40
var const_SEARCH_CHAPTER_ITEM_TEXT_LEFT_MARGIN = 42
var const_SEARCH_CHAPTER_ITEM_LINE_LEFT_MARGIN = 27
var const_SEARCH_CHAPTER_ITEM_FOCUSED_BG_BOTTOM_MARGIN = -9

var const_SEARCH_CHAPTER_LIST_TOP_MARGIN = 168
var const_SEARCH_CHAPTER_LIST_HEIGHT = 552
var const_SEARCH_CHAPTER_LIST_WIDTH = 500

var const_SEARCH_CHAPTER_VIDEO_ITEM_TOP_MARGIN = 168
var const_SEARCH_CHAPTER_VIDEO_ITEM_LEFT_MARGIN = 500
var const_SEARCH_CHAPTER_VIDEO_ITEM_HEIGHT = 552
var const_SEARCH_CHAPTER_VIDEO_ITEM_WIDTH = 780

var const_SEARCH_CHAPTER_VIDEO_TOP_MARGIN = 40
var const_SEARCH_CHAPTER_VIDEO_LEFT_MARGIN = 70
var const_SEARCH_CHAPTER_VIDEO_HEIGHT = 360
var const_SEARCH_CHAPTER_VIDEO_WIDTH = 640

var const_SEARCH_CHAPTER_BUTTON_BOTTOM_MARGIN = 20

var const_POPUP_DIMMED_TOP_OFFSET = 477
var const_POPUP_DIMMED_LEFT_OFFSET = 265

var const_POPUP_PLAYBACK_SPEED_4X = "4"
var const_POPUP_PLAYBACK_SPEED_16X = "16"
var const_POPUP_PLAYBACK_SPEED_20X = "20"
var const_POPUP_SIZE_WIDTH = 190
var const_POPUP_SIZE_HEIGHT = 192
var const_POPUP_PROGRESS_MAX_VAL = 100
var const_POPUP_PROGRESS_MIN_VAL = 0
var const_POPUP_TOAST_BOTTOM_MARGIN = 137

var const_POPUP_PBINFO_ROOT_LEFT_OFFSET = 539
var const_POPUP_PBINFO_ROOT_TOP_OFFSET = 260
var const_POPUP_PBINFO_PAUSE_LEFT_OFFSET = 59
var const_POPUP_PBINFO_PAUSE_TOP_OFFSET = 35
var const_POPUP_PBINFO_X_LEFT_OFFSET = 59
var const_POPUP_PBINFO_X_TOP_OFFSET = 49
var const_POPUP_PBINFO_TEXT_LEFT_OFFEST = 98
var const_POPUP_PBINFO_TEXT_SIZE = 70

var const_POPUP_TYPEA_TOP_MARGIN = 208 //added by yungi 2013.09.26 for ITS_NA 191163
var const_POPUP_TYPEA_LEFT_MARGIN = 93 //added by yungi 2013.09.26 for ITS_NA 191163

/** Playback control **/

var const_FF_REW_ICON_WIDTH = 90
var const_FF_REW_ICON_HEIGHT = 81
//var const_VISUALCUE_ICON_WIDTH = 132
//var const_VISUALCUE_ICON_HEIGHT = 163
var const_VISUALCUE_ICON_WIDTH = 148 //modified by aettie 20130625 for New GUI
var const_VISUALCUE_ICON_HEIGHT = 157

var const_CONTROLS_DUMMY = 0  // added for expand touch area
var const_CONTROLS_REW_BTN_NUMBER = 1
var const_CONTROLS_VISUALCUE_BTN_NUMBER = 2
var const_CONTROLS_FF_BTN_NUMBER = 3

var const_CONTROLS_LEFT_MARGIN = 391 //471  modified for expand touch area
//var const_CONTROLS_TOP_MARGIN = 460
var const_CONTROLS_TOP_MARGIN = 450 //Fixed by aettie 20130730 Video Cue location 
var const_CONTROLS_SPACING = 14
var const_CONTROLS_MA_LEFT_MARGIN = 52 // added by cychoi 2015.11.06 for ISV 120461
var const_CONTROLS_MA_TOP_MARGIN = 3 // added by cychoi 2015.11.06 for ISV 120461

var const_CONTROLS_SPEED_RATE_4X = 4
var const_CONTROLS_SPEED_RATE_16X = 16
var const_CONTROLS_SPEED_RATE_20X = 20

var const_FF_REW_TEXT_COLOR = "#FAFAFA"
var const_WIDGET_CMDBTN_DIMMED_TEXT_COLOR = "#9E9E9E"
var const_WIDGET_CMDBTN_TEXT_SIZE = 32
var const_WIDGET_CMDBTN_TEXT_FAMILY = "HDB"     // added by aettie.ji 2012.11.22 for NEW UX
var const_WIDGET_CMDBTN_TEXT_FAMILY_NEW = "DH_HDB"     // added by aettie.ji 2012.11.22 for NEW UX

var const_POPUP_WARNING_ICON_TOP_OFFSET = 202

// { added by Sergey Vetugov. CR#10273
/** Lockout **/
var const_LOCKOUT_ICON_TOP_OFFSET = 189
var const_LOCKOUT_TEXT_TOP_OFFSET = 367
// } added by Sergey Vetugov. CR#10273

// { added by lssanh 2013.05.24 ISV84099
//[KOR][ITS][181226][comment](aettie.ji)
var const_NO_PBCUE_LOCKOUT_ICON_TOP_OFFSET = 289
var const_NO_PBCUE_LOCKOUT_TEXT_TOP_OFFSET = 457
// } added by lssanh 2013.05.24 ISV84099

// { removed by Sergey for CR#15744
//var const_POPUP_TXT_BTN_NO_LANG_AVAILABLE = 0 
//var const_POPUP_TXT_BTN_UNSUPPORTED_FILE = 1
//var const_POPUP_TXT_BTN_USB_REMOVED = 2
//var const_POPUP_TXT_BTN_NO_VIDEO_ON_USB = 3
//var const_POPUP_TXT_BTN_NO_VIDEO_ON_JUKEBOX = 4
//var const_POPUP_TXT_BTN_UNAVAILABLE_TRACK = 5
//var const_POPUP_TXT_BTN_COPY_EXISTED_FILE = 6
// } removed by Sergey for CR#15744.

var const_PLAY_PAUSE_ICON_TOP_MARGIN = 43  //modified by aettie 20130625 for New GUI
var const_PLAY_PAUSE_ICON_LEFT_MARGIN = 29             //modified by aettie UX fix 20130916


// { added by Sergey for CR16250
var const_LOADING_POPUP_TEXT_TOP_OFFSET = 333
var const_LOADING_POPUP_ICON_TOP_OFFSET = 459
// } added by Sergey for CR16250

//{ added by yongkyun.lee 20130612 for : ITS 172810
var const_CENTER_AREA_4ARROW_TOP_OFFSET = 350
//} added by yongkyun.lee 20130611 

// { added by yungi 2013.09.26 for ITS_NA 191163
var const_POPUP_BG_BLACKOUT_1 = 0.8
var const_LOADING_POPUP_TYPEA_TEXT_TOP_MARGIN = 170
var const_LOADING_POPUP_TYPEA_ICON_TOP_MARGIN = 50
// } added by yungi

//added by suilyou 20131008 START
var const_JOG_NONE_PRESSED = 0
var const_CCP_JOG_CENTER_PRESSED = 1
var const_CCP_JOG_LEFT_PRESSED = 2
var const_CCP_JOG_RIGHT_PRESSED = 4
var const_RRC_JOG_CENTER_PRESSED = 8
var const_RRC_JOG_LEFT_PRESSED = 16
var const_RRC_JOG_RIGHT_PRESSED = 32
var const_HU_SEEK_PREV = 64
var const_HU_SEEK_NEXT = 128
var const_RRC_SEEK_PREV = 256
var const_RRC_SEEK_NEXT = 51
//added by suilyou 20131008 END

var const_DVD_CAPTION_LANG_KOR = 2 // added by yungi 2013.10.19 for ITS 196375
var const_DVD_CAPTION_LANG_CHN = 3 // added by yungi 2013.10.30 for Nex UX - DVD-Setting AR,RUS List Add
var const_DVD_CAPTION_LANG_ARB = 20 // added by yungi 2013.10.30 for Nex UX - DVD-Setting AR,RUS List Add

// country variant from ECountryVariant enumeration in DHAVN_AppFramework_Def.h)
var const_DISC_CV_MIDDLE_EAST = 4 // added by cychoi 2013.12.03 for New UX 

// { added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
var const_JOG_EVENT_ARROW_UP = 0
var const_JOG_EVENT_ARROW_DOWN = 1
var const_JOG_EVENT_ARROW_LEFT = 2
var const_JOG_EVENT_ARROW_RIGHT = 3
var const_JOG_EVENT_WHEEL_LEFT = 4
var const_JOG_EVENT_WHEEL_RIGHT = 5
var const_JOG_EVENT_CENTER = 6
var const_JOG_EVENT_HOLD_LEFT = 7
var const_JOG_EVENT_HOLD_RIGHT = 8
// { added by yungi 2014.02.14 for ITS 225174
var const_JOG_EVENT_ARROW_UP_LEFT = 9
var const_JOG_EVENT_ARROW_UP_RIGHT = 10
var const_JOG_EVENT_ARROW_DOWN_LEFT = 11
var const_JOG_EVENT_ARROW_DOWN_RIGHT = 12
// } added by yungi 2014.02.14
// } added by yungi 2013.11.29
var const_SEARCHCAPTION_LIST_SECTION_HEIGHT = 90 // added by yungi 2013.12.12 for NoCR DVD-SearchCaption TopFocus Not visible

var const_FRONT_VIEW = 1 // added by yungi 2014.01.23 for ITS 221843
var const_REAR_VIEW = 0 // added by yungi 2014.01.23 for ITS 221843
