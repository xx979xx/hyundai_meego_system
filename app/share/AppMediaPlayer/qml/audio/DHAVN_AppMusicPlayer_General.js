/**
 * DHAVN_AppMusicPlayer_General.js
 */
.pragma library

// Common
var const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH = 1280
var const_APP_MUSIC_PLAYER_MAIN_SCREEN_HEIGHT = 720
var const_APP_MUSIC_PLAYER_CATEGORY_SCREEN_WIDTH = 999	//added by aettie.ji 2012.12.1 for New UX
// { modified by aettie.ji 2012.10.30 for New UX
//var const_APP_MUSIC_PLAYER_EDIT_SCREEN_WIDTH = 1009
//var const_APP_MUSIC_PLAYER_EDIT_RIGHT_MARGIN = 271
//aettie
//var const_APP_MUSIC_PLAYER_EDIT_SCREEN_WIDTH = 1020
//var const_APP_MUSIC_PLAYER_EDIT_RIGHT_MARGIN = 260
var const_APP_MUSIC_PLAYER_EDIT_SCREEN_WIDTH = 1030	//modified by aettie 2013.03.20 for New UX
var const_APP_MUSIC_PLAYER_EDIT_RIGHT_MARGIN = 250	//modified by aettie 2013.03.20 for New UX

// } modified by aettie.ji 2012.10.30 for New UX
var const_APP_MUSIC_PLAYER_LISTVIEW_ITEM_HEIGHT = 92  //added by aettie.ji 2012.12.1 for New UX

var const_APP_MUSIC_PLAYER_Y_MODE_AREA_WIDGET = 125

var const_APP_MUSIC_PLAYER_BACK_ITEM_HEIGHT = 83
var const_APP_MUSIC_PLAYER_BACK_ITEM_RIGHT_MARGIN = 23
var const_APP_MUSIC_PLAYER_TOP_TOOLBAR_LEFT_MARGIN = 23

var const_APP_MUSIC_PLAYER_TAB_VIEW_TOP_MARGIN = 16

var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_BUTTON_FONT = 34
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_24_FONT = 24
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_22_FONT = 22
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_24_FONT = 24
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_36_FONT = 36
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_29_FONT = 29
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_28_FONT = 28//added by edo.lee 2012.08.29 for New UX BT Music
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_30_FONT = 30   // added by dongjin 2012.08.27 for New UX
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_32_FONT = 32
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT = 40   // added by dongjin 2012.08.14 for CR12351
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_40_FONT = 40   // added by Michael.Kim 2013.03.17 for new UX
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_45_FONT = 45   // added by edo.lee 2012.08.29 for NEW UX BT Music
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_TIME_FONT = 34
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_SUB_FONT = 28
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_INDEX_FONT = 22
//{ added by yongkyun.lee 20130404 for : ISV_KR 78361
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_BLUETOOTH = 62
//var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_BLUETOOTH = 52
//} added by yongkyun.lee 20130404 
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_BT_DEVICE = 36
var const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_AUX = 120// modified by eunhye.yoo 2012.08.14 for New UX : Music(LGE) #41
var const_APP_MUSIC_PLAYER_FONT_PIXEL_SIZE_TEXT_BUTTON_FONT_LEFT = 32
var const_APP_MUSIC_PLAYER_FONT_PIXEL_SIZE_TEXT_BUTTON_FONT = 25

var const_APP_MUSIC_PLAYER_COLOR_TEXT_DIMMED_GREY = "#9E9E9E"
var const_APP_MUSIC_PLAYER_COLOR_TEXT_BLACK = "#000000"
var const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY = "#FAFAFA"
var const_APP_MUSIC_PLAYER_COLOR_TEXT_PROGRESS_BLUE = "#0087EF"
var const_APP_MUSIC_PLAYER_COLOR_TEXT_BUTTON_GREY = "#2F2F2F"
var const_APP_MUSIC_PLAYER_COLOR_TEXT_GREY = "#C1C1C1"
var const_APP_MUSIC_PLAYER_COLOR_SUB_TEXT_GREY = "#D4D4D4"
var const_APP_MUSIC_PLAYER_COLOR_DISABLE_GREY = "#5B5B5B"
var const_APP_MUSIC_PLAYER_COLOR_FOCUSED = "#0080FF"
var const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT = "#7CBDFF" // added by ruindmby 2012.08.19 for CR 13087
var const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157 = "#92949D"
var const_APP_MUSIC_PLAYER_COLOR_RGB_141_179_255 = "#8DB3FF"//added  by edo.lee 2012.08.29 for New UX BT Music

var const_APP_MUSIC_PLAYER_FONT_FAMILY_HDR = "HDR"
var const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB = "HDB"

// { modified by wonseok.heo for add amiri font 2013.09.02
var const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR = "DH_HDR"
var const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB = "DH_HDB"
// } modified by wonseok.heo for add amiri font 2013.09.02

// PlayerView
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_BG_NUMBER = 3
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_DVD_AUDIO_BG_NUMBER = 100 // added by kihyung 2012.08.30 for DVD-Audio
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_TOP_MARGIN = 20
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_ITEM_WIDTH = 726
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_ITEM_LEFT_MARGIN = 81
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_ITEM_BOTTOM_MARGIN = 150
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_ITEM_LEFT_MARGIN = 29

// DiscManagerView
var const_APP_MUSIC_PLAYER_DISC_MANAGER_VIEW_BG_NUMBER = 1
var const_APP_MUSIC_PLAYER_DISC_MANAGER_VIEW_CONTAINER_X = 82
var const_APP_MUSIC_PLAYER_DISC_MANAGER_TEXT_LEFT_MARGIN = 1
var const_APP_MUSIC_PLAYER_DISC_MANAGER_AUDIO_CD_COVER_THUMBNAIL_WIDTH = 343
var const_APP_MUSIC_PLAYER_DISC_MANAGER_AUDIO_CD_COVER_THUMBNAIL_HEIGHT = 343
var const_APP_MUSIC_PLAYER_DISC_MANAGER_AUDIO_CD_COVER_THUMBNAIL_X = 25
var const_APP_MUSIC_PLAYER_DISC_MANAGER_AUDIO_CD_COVER_THUMBNAIL_Y = 1
var const_APP_MUSIC_PLAYER_DISC_MANAGER_AUDIO_CD_TOP_MARGIN = 49

var  const_APP_MUSIC_PLAYER_DISC_MANAGER_COPY_BTN_TOP_MARGIN = 97
var  const_APP_MUSIC_PLAYER_DISC_MANAGER_COPY_BTN_LEFT_MARGIN = 13
var  const_APP_MUSIC_PLAYER_DISC_MANAGER_COPY_BTN_WIDTH = 97
var  const_APP_MUSIC_PLAYER_DISC_MANAGER_COPY_BTN_VERTICAL_OFFSET = 110
var  const_APP_MUSIC_PLAYER_DISC_MANAGER_VIRTUAL_CD_LEFT_MARGIN = 535

// FileListView
//var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_BG_NUMBER = 1 // removed by eugeny.novikov 2012.11.30 for CR 16133
//{ modifyed by eunhye 2012.08.25 for Music(LGE) # 4-22
//var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_TOPMARGIN_AREA_CONTAINER = 4
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_TOPMARGIN_AREA_CONTAINER = -8
// } //modifyed by eunhye
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_HEIGHT_AREA_CONTAINER = 472
var const_APP_MUSIC_PLAYER_DISK_LIST_VIEW_HEIGHT_AREA_CONTAINER = 545
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_WIDTH_AREA_CONTAINER = 1280
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_WIDTH_CATEGORY_LIST = 276   // modified by nhj 2013.10.10 for New UX :281->276
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_COLUMN_X = 39
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_COLUMN_SPACING = 5
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_ROW_HEIGHT = 85
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_ROW_SPACING = 28
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_ITEM_TITLE_WIDTH = 860
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_DISC_ITEM_TITLE_WIDTH = 1145   // added by dongjin 2012.09.05 for New UX
//{ modified by yongkyun 2013.01.19 for ISV 69665
//var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_ITEM_TITLE_CHECKBOX_MARGIN = 15   // added by aettie.ji 2012.10.30 for New UX
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_ITEM_TITLE_CHECKBOX_MARGIN = 45   // added by aettie.ji 2012.10.30 for New UX
//{ modified by yongkyun 2013.01.19
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_SECTION_IMAGE_X = 21
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_SECTION_IMAGE_WIDTH = 966   // added by dongjin 2012.08.27 for New UX
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_IMAGE_WIDTH = 969   // added by aettie 2013.03.20 for New UX
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_IMAGE_WIDTH_SHORT = 922 //added by aettie 2013.03.20 for New UX
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_SECTION_IMAGE_WIDTH_SHORT = 919  //added by aettie 2013.03.20 for New UX
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_SECTION_TEXT_X = 27
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_THUMBNAIL_IMAGE_SIZE = 78
var const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_PICT_IMAGE_SIZE = 45
//var const_APP_MUSIC_PLAYER_PLAY_PROGRESS_BAR_BG_NUMBER = 3 // removed by eugeny.novikov 2012.11.30 for CR 16133
var const_APP_MUSIC_PLAYER_PLAY_PROGRESS_BAR_LEFT_MARGIN = 28
var const_APP_MUSIC_PLAYER_PLAY_PROGRESS_BAR_TOP_MARGIN = -28
var const_APP_MUSIC_PLAYER_PLAY_PROGRESS_BAR_RIGHT_MARGIN = 38
var const_APP_MUSIC_PLAYER_FILE_LIST_TITLE_WIDTH = 150
var const_APP_MUSIC_PLAYER_DISC_FILE_LIST_TITLE_WIDTH = 130 //added by wonseok.heo for ITS 211210 2013.11.26
var const_APP_MUSIC_PLAYER_FILE_LIST_TITLE_MARGIN_X = 88
//var const_APP_MUSIC_PLAYER_FILE_LIST_ICON_WIDTH = 63
var const_APP_MUSIC_PLAYER_FILE_LIST_ICON_WIDTH = 58 //modified by aettie 2013.01.16 for ISV 68135/68124
var const_APP_MUSIC_PLAYER_FILE_LIST_ICON_MARGIN_X = 25
var const_APP_MUSIC_PLAYER_FILE_LIST_INDEX_MARGIN_X = 32   // added by dongjin 2012.08.27 for New UX
//added by aettie 20130924 for ux fix
var const_APP_MUSIC_PLAYER_FILE_LIST_INDEX_NEW_MARGIN_X = 50
var const_APP_MUSIC_PLAYER_FILE_LIST_INDEX_NEW_MARGIN_X_EDIT = 56
var const_APP_MUSIC_PLAYER_LIST_VIEW_HEIGHT = 554
var const_APP_MUSIC_PLAYER_FILE_LIST_PLAYING_ICON_WIDTH = 49
var const_APP_MUSIC_PLAYER_LIST_VIEW_TOP_MARGIN = 25          // added by dongjin 2012.08.29 for New UX
var const_APP_MUSIC_PLAYER_FILE_LIST_INDEX_TEXT_WIDTH = 880   // added by dongjin 2012.08.29 for New UX
var const_APP_MUSIC_PLAYER_DISC_FILE_LIST_PLAYING_ICON_WIDTH = 102      // added by dongjin 2012.09.05 for New UX
var const_APP_MUSIC_PLAYER_DISC_FILE_LIST_PLAYING_ICON_LEFT_MARGIN = 37 // added by dongjin 2012.09.05 for New UX
var const_APP_MUSIC_PLAYER_EDIT_MODE_FILE_LIST_VIEW_SECTION_IMAGE_LEFT_MARGIN = 29  //20131025 GUI fix
var const_APP_MUSIC_PLAYER_FILE_LIST_MARGIN_X = 72 // added by eunhye 2013.03.07 for New UX
var const_APP_MUSIC_PLAYER_LIST_VIEW_MP3_TOP_MARGIN = 0 //added by wonseok.heo for ITS 187104 2013.08.28

var const_APP_MUSIC_PLAYER_EDIT_MODE_FILE_LIST_PLAYING_ICON_WIDTH = 70//91 // added by changjin 2012.09.07 for New UX Music(LGE)
var const_APP_MUSIC_PLAYER_EDIT_MODE_FILE_LIST_PLAYING_ICON_LEFT_MARGIN = 20 //30 // added by changjin 2012.09.07 for New UX Music(LGE)

//iPodFileList
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_BG_NUMBER = 1
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_TOPMARGIN_AREA_CONTAINER = 6
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_WIDTH_CATEGORY_LIST = 250
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_HEIGHT_AREA_CONTAINER = 555
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_WIDTH_AREA_CONTAINER = 1280
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_SECTION_IMAGE_X = 28 //21
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_SECTION_TEXT_X = 27
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_COLUMN_X = 46//39
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_COLUMN_SPACING = 5
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_ROW_HEIGHT = 85
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_ROW_SPACING = 28
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_THUMBNAIL_IMAGE_SIZE = 78
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_WIDTH_NULL_THUMBNAIL_IMAGE = 0
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_WIDTH_TEXT_WITH_THUMBNAIL_IMAGE = 737
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_WIDTH_TEXT_WITHOUT_THUMBNAIL_IMAGE = 843
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_X_TEXT_CATEGORYLIST = 35
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_WIDTH_ICON_LIST_PLAY = 45
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_HEIGHT_ICON_LIST_PLAY = 45
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_GRID_LEFTMARGIN = 9
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_GRID_CELLWIDTH = 253
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_GRId_CELLHEIGHT = 185
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_GRID_VERTICALLINE_TOPMARGIN = 10
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_GRID_HORIZONLINE_LEFTMARGIN = 22
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_GRID_GRIDIMAGE_TOPMARGIN = 23
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_GRID_GRIDIMAGE_LEFTMARGIN = 82
var const_APP_MUSIC_PLAYER_IPOD_FILE_LIST_GRID_TEXTIMAGE_BOTTOMMARGIN = 61
// { added by dongjin 2012.09.14 for New UX
var const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_WIDTH = 1214 //modified by aettie 2013.03.20 for New UX
var const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_HEIGHT = 45 //added by junam 2013.08.10 for ITS_KOR_183783
var const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_TEXT_X = 88 - 16 //20131025 GUI fix
var const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_IMAGE_X = 16
// } added by dongjin

// ProgressBar
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_WIDTH = 500
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SMALL_HEIGHT = 80
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_BIG_HEIGHT = 100
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN = 14
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_TOTAL_TIME_LEFT_MARGIN = 14
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_ALBUM_TEXT_BOTTOM_MARGIN = 9
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SONG_TEXT_LEFT_MARGIN = 10
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_LINE_HEIGHT = 50
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_LINE_LEFT_MARGIN = 76
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_Y = -25
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_0 = 0
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_10 = 10
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_20 = 20
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_30 = 30
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_40 = 40
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_50 = 50
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_60 = 60
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_70 = 70
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_80 = 80
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_90 = 90
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_SLIDER_X_100 = 100
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_PLAY_RANDOM_BOTTOM_MARGIN = 8
var const_APP_MUSIC_PLAYER_PROGRESS_BAR_PLAY_REPEAT_RIGHT_MARGIN = 7

// MusicPathView
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_HEIGHT = 369
var const_APP_MUSIC_PLAYER_MUSIC_CAROUSEL_HEIGHT = 650
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_COLUMN_HEIGHT = 182 + 182
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_COLUMN_WIDTH = 182
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_AXIS_X = 0
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_AXIS_Y = 1
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_AXIS_Z = 0
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_SONG_IMAGE_WIDTH = 182
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_SONG_IMAGE_HEIGHT = 182
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_SONG_IMAGE_TOP_MARGIN = 5
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_SONG_LIST_VIEW_HEIGHT = 369
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_PATH_ITEM_COUNT = 7

var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_FOCUSED_WIDTH = 210
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_FOCUSED_HEIGHT = 210
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_FOCUSED_Z = 100
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_FOCUSED_Y = 8
var const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_FOCUSED_DURATION = 500



// PlayerItemUSB
var const_APP_MUSIC_PLAYER_PLAYER_ITEM_USB_ANGLE = -28
var const_APP_MUSIC_PLAYER_PLAYER_ITEM_USB_DURATION = 1000
var const_APP_MUSIC_PLAYER_PLAYER_ITEM_USB_WIDTH = 418
var const_APP_MUSIC_PLAYER_PLAYER_ITEM_USB_HEIGHT = 418
var const_APP_MUSIC_PLAYER_PLAYER_ITEM_USB_RIGHT_MARGIN = 34

// PlayerItemCD
var const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_TIMER_INTERVAL = 2000
var const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_WIDTH = 418
var const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_HEIGHT = 418
var const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_RIGHT_MARGIN = 34
var const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_DURATION = 1000

// PlayerViewItem
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_HEIGHT = 474
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_SONG_DATA_HEIGHT = 404
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_SONG_DATA_WIDTH = 726
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_SONG_DATA_LEFT_MARGIN = 78
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_FOLDER_NAME_COLOR = "#FFFFFF"
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_FOLDER_NAME_FONT_SIZE = 20
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_FOLDER_NAME_TOP_MARGIN = 20
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_SONG_NUMBER_TOP_MARGIN = 3
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_SONG_NAME_FONT_SIZE = 36
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_SONG_TITLE_COLOR = "#FFFFFF"
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_ITEM_SONG_TITLE_FONT_SIZE = 52
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_SONG_ITEM_WIDTH = 160
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_SONG_ITEM_HEIGHT = 60
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_SONG_ITEM_TRANSFORM_ANGLE = 70
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_SONG_LIST_CONTAINER_WIDTH = 800
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_SONG_LIST_CONTAINER_HEIGHT = 450
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_SONG_LIST_CONTAINER_RIGHT_MARGIN = 55
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_SONG_LIST_CONTAINER_TOP_MARGIN = 13
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_SONG_LIST_WIDTH = 200
var const_APP_MUSIC_PLAYER_PLAYER_VIEW_SONG_LIST_HEIGHT = 100

//PopupList
var const_APP_MUSIC_PLAYER_POPUP_LIST_WIDTH = 1077
var const_APP_MUSIC_PLAYER_POPUP_LIST_HEIGHT = 379
var const_APP_MUSIC_PLAYER_POPUP_LIST_TOP_MARGIN = 175
var const_APP_MUSIC_PLAYER_POPUP_LIST_BORDER_WIDTH = 10
var const_APP_MUSIC_PLAYER_POPUP_LIST_BORDER_COLOR = "white"
var const_APP_MUSIC_PLAYER_POPUP_LIST_BG_COLOR = "black"
var const_APP_MUSIC_PLAYER_POPUP_LIST_CLOSE_BTN_RIGHT_MARGIN = 50
var const_APP_MUSIC_PLAYER_POPUP_LIST_CLOSE_BTN_TOP_MARGIN = 20
var const_APP_MUSIC_PLAYER_POPUP_LIST_CLOSE_BTN_BORDER_COLOR = "white"
var const_APP_MUSIC_PLAYER_POPUP_LIST_CLOSE_BTN_BORDER_WIDTH = 2
var const_APP_MUSIC_PLAYER_POPUP_LIST_CLOSE_BTN_BORDER_RADIUS = 2
var const_APP_MUSIC_PLAYER_POPUP_LIST_CLOSE_BTN_WIDTH = 35
var const_APP_MUSIC_PLAYER_POPUP_LIST_CLOSE_BTN_HEIGHT = 35
var const_APP_MUSIC_PLAYER_POPUP_LIST_CLOSE_BTN_FONT_SIZE = 20
var const_APP_MUSIC_PLAYER_POPUP_LIST_CLOSE_BTN_FONT_COLOR = "white"
var const_APP_MUSIC_PLAYER_POPUP_LIST_ALBUM_COVER_LEFT_MARGIN = 50
var const_APP_MUSIC_PLAYER_POPUP_LIST_ALBUM_COVER_IMAGE_WIDTH = 250
var const_APP_MUSIC_PLAYER_POPUP_LIST_ALBUM_COVER_IMAGE_HEIGHT = 250
var const_APP_MUSIC_PLAYER_POPUP_LIST_ALBUM_COVER_ALBUM_TITLE_SIZE = 24
var const_APP_MUSIC_PLAYER_POPUP_LIST_ALBUM_COVER_SINGER_TITLE_SIZE = 20
var const_APP_MUSIC_PLAYER_POPUP_LIST_SONGS_LIST_LEFT_MARGIN = 40
var const_APP_MUSIC_PLAYER_POPUP_LIST_SONGS_LIST_RIGHT_MARGIN = 40
var const_APP_MUSIC_PLAYER_POPUP_LIST_SONGS_LIST_TOP_MARGIN = 20
var const_APP_MUSIC_PLAYER_POPUP_LIST_SONGS_LIST_BOTTOM_MARGIN = 20
var const_APP_MUSIC_PLAYER_POPUP_LIST_SONGS_LIST_ROW_SPACING = 5
var const_APP_MUSIC_PLAYER_POPUP_LIST_SONGS_LIST_FOCUS_WIDTH = 5
var const_APP_MUSIC_PLAYER_POPUP_LIST_SONGS_LIST_FOCUS_HEIGHT = 5
var const_APP_MUSIC_PLAYER_POPUP_LIST_SONGS_LIST_FONT_SIZE = 20

// More Like This Screen
var const_APP_MUSIC_PLAYER_MLT_LIST_X = 40
var const_APP_MUSIC_PLAYER_MLT_LIST_HEIGHT = 520
var const_APP_MUSIC_PLAYER_MLT_LIST_HIGHLIGHT_BORDER_WIDTH = 5
var const_APP_MUSIC_PLAYER_MLT_LIST_COLUMN_WIDTH = 1200
var const_APP_MUSIC_PLAYER_MLT_LIST_COLUMN_TEXT_WIDTH = 1160

//AUX
var const_APP_MUSIC_PLAYER_AUX_LIST_TEXT_Y = 165 //modified by aettie.ji 2012.10.24 for New UX : Music(LGE) #6
//var const_APP_MUSIC_PLAYER_AUX_LIST_TEXT_Y = 150
var const_APP_MUSIC_PLAYER_AUX_LIST_TEXT_Y_TRANSF = 330
//var const_APP_MUSIC_PLAYER_AUX_LIST_Y_IMAGE = 386
var const_APP_MUSIC_PLAYER_AUX_LIST_Y_IMAGE = 189 //modified by eunhye 2013.03.07 for New UX
var const_APP_MUSIC_PLAYER_AUX_LIST_X_IMAGE = 462//added by eunhye 2013.03.07 for New UX

//AlphabeticList
// { added by cychoi 2015.08.21 for ITS 267745
var const_APP_MUSIC_PLAYER_ALPHABETIC_POPUP_LEFTMARGIN = 396
var const_APP_MUSIC_PLAYER_ALPHABETIC_POPUP_TOPMARGIN = 204
// } added by cychoi 2015.08.21
//var const_APP_MUSIC_PLAYER_ALPHABETIC_POPUP_TEXT_LEFTMARGIN = 21 // removed ITS 238998
//var const_APP_MUSIC_PLAYER_ALPHABETIC_POPUP_TEXT_TOPMARGIN = 108
//var const_APP_MUSIC_PLAYER_ALPHABETIC_POPUP_TEXT_WIDTH = 171
var const_APP_MUSIC_PLAYER_ALPHABETIC_FONT_SIZE_TEXT_HDB_100_FONT = 100
var const_APP_MUSIC_PLAYER_ALPHABETIC_FONT_SIZE_TEXT_HDB_22_FONT = 22
//{ modified by eunhye 2012.08.23 New UX:Music(LGE) #5,7,8,11,14,17,18
//var const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_RIGHT_MARGIN = 12
//var const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_RIGHT_MARGIN = 33
var const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_RIGHT_MARGIN = 33//30 (1280-1209-38) -//modified by ys-20130322 new ux music 1.2.8
var const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_RIGHT_MARGIN_EDITMODE = 275    //added by aettie 2013.03.20 for New UX
//var const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_TOP_MARGIN = 12 // modify by EUNHYE 2012.07.09 for CR11224
var const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_TOP_MARGIN = 52
//} modified by eunhye 2012.08.23 New UX:Music(LGE) #5,7,8,11,14,17,18
var const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_LISTVIEW_TOP_MARGIN = 4
var const_APP_MUSIC_PLAYER_ALPHABETIC_TEXT_COLOR = "#FFFFFF"

//var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_WIDTH = 22
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_WIDTH = 30 // modified by eunhye 2012.08.23 New UX:Music(LGE) #5,7,8,11,14,17,18 
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ICON_SEARCH_LEFT_MARGIN = 0
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ICON_INDEX_LEFT_MARGIN = 4 // modify by EUNHYE 2012.07.09 for CR11224
//{modified by aettie 2013.03.20 for New UX
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_TOP_PART = 28
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_BOTTOM_PART = 21
// { add modify by EUNHYE 2012.07.09 for CR11224
var const_APP_MUSIC_PLAYER_ALPHABETIC_ICON_INDEX_MARGIN = 5
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_TOP_PART_ENG = 34
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_BOTTOM_PART_ENG = 21
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_TOP_PART_MED = 25
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_BOTTOM_PART_MED = 19
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_MARGIN = 6
// } add by EUNHYE 2012.07.09 for CR11224
//}modified by aettie 2013.03.20 for New UX
var const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_HANGUL = 32

var const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ITEM_WIDTH = 33
var const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_SEARCH_LEFT_MARGIN = 5
//{ modified by eunhye 2012.08.23 New UX:Music(LGE) #5,7,8,11,14,17,18
//var const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_LEFT_MARGIN = 11
var const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_LEFT_MARGIN = 12
// { added by cychoi 2015.12.04 for ITS 270606
var const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_TOP_MARGIN_A = 12
var const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_TOP_MARGIN_B = 8
// } added by cychoi 2015.12.04
//var const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ITEM_HEIGHT_TOP_PART = 32
var const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ITEM_HEIGHT_TOP_PART = 31
//var const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ITEM_HEIGHT_BOTTOM_PART = 20
var const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ITEM_HEIGHT_BOTTOM_PART = 10
//} modified by eunhye 2012.08.23 New UX:Music(LGE) #5,7,8,11,14,17,18
var const_JOG_EVENT_ARROW_UP = 0
var const_JOG_EVENT_ARROW_DOWN = 1
var const_JOG_EVENT_ARROW_LEFT = 2
var const_JOG_EVENT_ARROW_RIGHT = 3
var const_JOG_EVENT_WHEEL_LEFT = 4
var const_JOG_EVENT_WHEEL_RIGHT = 5
var const_JOG_EVENT_CENTER = 6
var const_JOG_EVENT_HOLD_LEFT = 7
var const_JOG_EVENT_HOLD_RIGHT = 8

var const_APP_MUSIC_PLAYER_LANGCONTEXT = "main"

//Search
var const_SEARCH_PAD_WIDGET_POS_Y = 345
var const_SEARCH_TEXT_BOX_TOP_MARGIN = 93
var const_SEARCH_LIST_Z = 2
var const_SEARCH_KEYPAD_Z = 3
var const_SEARCH_BOX_MAX_KEY_CODE = 0xFF
var const_SEARCH_ICO_SEARCH_LEFT_MARGIN = 27
var const_SEARCH_TEXT_INPUT_WIDTH = 670
var const_SEARCH_TEXT_INPUT_LEFT_MARGIN = 67
var const_SEARCH_COUNTER_TEXT_WIDTH = 183
var const_SEARCH_COUNTER_TEXT_LEFT_MARGIN = 24
var const_SEARCH_DELETE_BUTTON_LEFT_MARGIN = 5
var const_SEARCH_CATEGORY_TEXT_VC_OFFSET = 35

var const_SEARCH_LIST_ITEM_MUSIC_HEIGHT = 90
var const_SEARCH_LIST_ITEM_MUSIC_WIDTH = 1280
var const_SEARCH_LIST_ITEM_TRACK_TITLE_L_OFFSET = 101
var const_SEARCH_LIST_ITEM_TRACK_TITLE_L_OFFSET_ALL = 49
var const_SEARCH_LIST_ITEM_TRACK_TITLE_VC_OFFSET = 46 // 90 - (27 + 17)
//{ modified by aettie.ji 2012.11.2 for New UX Music #37
//var const_SEARCH_LIST_ITEM_TRACK_TITLE_WIDTH = 340
var const_SEARCH_LIST_ITEM_TRACK_TITLE_WIDTH = 532
//var const_SEARCH_LIST_ITEM_TRACK_TITLE_WIDTH_ALL = 347
var const_SEARCH_LIST_ITEM_TRACK_TITLE_WIDTH_ALL = 447
var const_SEARCH_LIST_ITEM_TRACK_TITLE_WIDTH_ARTIST_ALL = 844
//var const_SEARCH_LIST_ITEM_ALBUM_ARTIST_L_OFFSET = 31
var const_SEARCH_LIST_ITEM_ALBUM_ARTIST_L_OFFSET = 40
var const_SEARCH_LIST_ITEM_ALBUM_ARTIST_L_OFFSET_ALL = 25
var const_SEARCH_LIST_ITEM_TRACK_ALBUM_VC_OFFSET = 26 // 90 - (27 + 17 + 20)
//var const_SEARCH_LIST_ITEM_ALBUM_ARTIST_WIDTH = 565
var const_SEARCH_LIST_ITEM_ALBUM_ARTIST_WIDTH = 507
//var const_SEARCH_LIST_ITEM_ALBUM_ARTIST_WIDTH_ALL = 472
var const_SEARCH_LIST_ITEM_ALBUM_ARTIST_WIDTH_ALL = 372
var const_SEARCH_LIST_ITEM_TRACK_ARTIST_VC_OFFSET = 63 // 90 - 27
var const_SEARCH_LIST_ITEM_TRACK_ARTIST_VC_OFFSET_ALL = 46
var const_SEARCH_LIST_ITEM_SOURCE_ICON_L_OFFSET = 1180
//var const_SEARCH_LIST_ITEM_SOURCE_ICON_L_OFFSET_ALL = 893
var const_SEARCH_LIST_ITEM_SOURCE_ICON_L_OFFSET_ALL = 903
//} modified by aettie.ji 2012.11.2 for New UX Music #37
var const_SEARCH_LIST_ITEM_SOURCE_ICON_TOP_MARGIN = 7 // 90 - 83

/*New UI*/
var const_APP_MUSIC_PLAYER_FONT_PIXEL_SIZE_TEXT_BUTTON_LEFT = 32
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN = 158
//var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN = 161 //modified by aettie 2013.03.08 for ISV 73578
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_TOP_MARGIN = 50
//var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN_REFLECT = 161 //added by Michael.Kim 2013.03.07 for New UX
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN_REFLECT = 158 //modified by aettie.ji 2013.03.11
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN_REFLECT_X = 163 //added by Michael.Kim 2013.03.14 for New UX
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_TOP_MARGIN_REFLECT_Y = 274 //added by Michael.Kim 2013.03.14 for New UX
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_TOP_MARGIN_REFLECT = 285 //added by Michael.Kim 2013.03.07 for New UX
//var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_LEFT_MARGIN = 16
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_LEFT_MARGIN = 19 //modified by aettie 2013.03.08 for ISV 73578
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_LEFT_MARGIN_REFLECT = 2 //added by Michael.Kim 2013.03.07 for New UX
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_TOP_MARGIN = 3
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_TOP_MARGIN_REFLECT = 2 //added by Michael.Kim 2013.03.07 for New UX
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_RIGHT_MARGIN = 6 //added by Michael.Kim 2013.03.07 for New UX
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BOTTOM_MARGIN = 9 //added by Michael.Kim 2013.03.07 for New UX
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_WIDTH = 224
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_HEIGHT = 224
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_WIDTH_BT = 249  //added by aettie.ji 2013.01.18
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_HEIGHT_BT = 238 //added by aettie.ji 2013.01.18

// { modified by dongjin 2012.08.21 for NEW UX
//var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH = 720
//var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_HEIGHT = 200
//var const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN = 59
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH = 655
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_HEIGHT = 244
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN = 64
// } modified by dongjin
// { added by kihyung 2012.08.21 for new UX MUSIC(LGE) #3
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH_GN = 558
// } added by kihyung
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET = 24
// { modified by dongjin 2012.08.21 for NEW UX
//var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_LEFT_MARGIN = 435
//var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_TOP_MARGIN = 75
//var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_COUNT_WIDTH = 200
//var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_COUNT_HEIGHT = 50
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_LEFT_MARGIN = 436
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_TOP_MARGIN = 48
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_COUNT_WIDTH = 188
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_COUNT_HEIGHT = 80
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_COUNT_FONT_SIZE = 30
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_COUNT_RIGHT_MARGIN = 42
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_COUNT_VC_OFFSET = 42
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_SCAN_POS_X = 90
// } modified by dongjin
var const_APP_MUSIC_PLAYER_ALBUM_VIEW_INFO_WIDTH = 411   // added by dongjin 2012.08.14 for CR12351

var const_COVER_FLOW_ITEM_SIZE = 200

/*BT Music UI*/
//{added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
var const_BT_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_14_FONT = 14

//var const_BT_MUSIC_PLAYER_TRANSFERRING_ITEM_BOTTOM_MARGIN = 29
var const_BT_MUSIC_PLAYER_TRANSFERRING_ITEM_BOTTOM_MARGIN = 20
var const_BT_MUSIC_PLAYER_TRANSFERRING_BOTTOM_MARGIN = 41 //modified by edo.lee 2012.08.29 for New UX BT Music
//{modified by edo.lee 2012.08.29 for New UX BT Music
//var const_BT_MUSIC_PLAYER_TRANSFERRING_LEFT_MARGIN = 20
//var const_BT_MUSIC_PLAYER_TRANSFERRING_ITEM_LEFT_MARGIN = 40
var const_BT_MUSIC_PLAYER_TRANSFERRING_LEFT_MARGIN = 10
var const_BT_MUSIC_PLAYER_TRANSFERRING_ITEM_LEFT_MARGIN = 20
var const_BT_MUSIC_PLAYER_TRANSFERRING_TEXT_WIDTH = 260 // 270 // modified by cychoi 2014.09.30 for HMC Request. Display "Paused" when Streaming is stopped (KH)
//}modified by edo.lee

//var const_BT_MUSIC_PLAYER_TRANSFERRING_ITEM_BOTTOM_MARGIN = 29
//var const_BT_MUSIC_PLAYER_TRANSFERRING_BOTTOM_MARGIN = 40
//var const_BT_MUSIC_PLAYER_TRANSFERRING_LEFT_MARGIN = 20
//var const_BT_MUSIC_PLAYER_TRANSFERRING_ITEM_LEFT_MARGIN = 40
//}added by edo.lee

// { added by cychoi 2015.12.04 for ITS 270606
var const_LANG_KOR = 2
var const_LANG_CHN = 3
var const_LANG_ARB = 20
// } added by cychoi 2015.12.04

//Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
var iPodPlaybackMode_NoMedia = 100;
var iPodPlaybackMode_Normal = 101;
var iPodPlaybackMode_3rdParty = 102;
//end of Hyundai Spec Change
