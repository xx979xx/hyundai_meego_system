.pragma library

//Lang context
var const_APP_PHOTO_LANGCONTEXT = "main"

//Values
var const_SCREEN_WIDTH = 1280
var const_SCREEN_HEIGHT = 720
var const_MODE_AREA_WIDGET_Y = 93
var const_STATUSBAR_WIDGET_Y = 166 //modified by edo.lee 2013.04.04
var const_FULLSCREEN_DURATION_ANIMATION = 300//500//modified by edo.lee 2013.08.09 ITS 183057
var const_FULL_SCREEN_OFFSET = 260// added by edo.lee  2013.08.10 ITS 183057

var const_HOME_AREA_WIDTH = 149 // added by Michael.Kim 2014.05.12 for ITS 236807
var const_HOME_AREA_HEIGHT = 93 // added by Michael.Kim 2014.05.12 for ITS 236807

var const_START_ANGEL =   0
var const_END_ANGEL   = -30

var const_ZERO_ANGEL             =    0
var const_START_TRANSLATE_ANGEL  =  700
var const_FINISH_TRANSLATE_ANGEL = -1500

var const_ANIMATION_DURATION     =  1000
var const_ANIMATION_DURATION_1   = 500

var const_ANIMATION_INTERVAL = 5000

var const_TRANSFORM_X_START_POINT   = 0
var const_TRANSFORM_Y_START_POINT   = 1
var const_TRANSFORM_Z_START_POINT   = 0

var const_SLIDE_SHOW_DELAY_1 = 5
var const_SLIDE_SHOW_DELAY_2 = 10
var const_SLIDE_SHOW_DELAY_3 = 20
var const_SLIDE_SHOW_DELAY_4 = 30

var const_BOTTOM_MENU_FONT_SIZE = 25

//double tap
var const_DOUBLE_TAP_MAX_PIX_DELTA = 30 //delta in pixels
var const_DOUBLE_TAP_MAX_TIME_DELTA = 350 //delta in milliseconds

//ITS 189019
var const_PAN_MAX_TIME = 750

//Colors
var const_COLOR_BACKGROUND   = "#000000"
var const_COLOR_BUTTON_TEXT  = "#474747"

//Popups
var const_POPUP_ID_NONE			   = 0  //added by edo.lee 2012.10.23 for Function_USB_1721
var const_POPUP_ID_IMAGE_INFO      = 1
var const_POPUP_ID_MEMORY_FULL     = 2
var const_POPUP_ID_IMAGE_SAVED     = 3
var const_POPUP_ID_ROTATE_ANGLE    = 4
var const_POPUP_ID_VALUE_SAVED     = 5
var const_POPUP_ID_NO_IMAGE_FILES_IN_USB = 6
var const_POPUP_ID_NO_IMAGE_FILES_IN_JUKEBOX = 7
var const_POPUP_ID_HIGH_TEMPERATURE = 8
var const_POPUP_ID_UNAVAILABLE_FORMAT = 9
var const_POPUP_ID_ZOOM_VALUE = 10
var const_POPUP_ID_COPY_COMPLETED   = 11
var const_POPUP_ID_FILE_EXISTS      = 12
var const_POPUP_ID_FILE_EXISTS_INJUKEBOX      = 13 // added by wspark 2012.11.20 for CR15521
var const_POPUP_ID_DRS              = 14 //added by yongkyun.lee 2012.12.03 for photo DRS from VR.
var const_POPUP_ID_COPY_TO_JUKEBOX_PROGRESS = 15 // modified by ravikanth 16-04-13

var const_PHOTOPLAYER_Z            = 1
var const_MODEAREA_Z               = 2
var const_BOTTOMAREA_Z             = 2
//source masks
var const_SOURCE_JUKEBOX_MASK      = 1
var const_SOURCE_USB1_MASK         = 2
var const_SOURCE_USB2_MASK         = 4

//source IDs
var const_JUKEBOX_SOURCE_ID        = 0
var const_USB1_SOURCE_ID           = 1
var const_USB2_SOURCE_ID           = 2

//Visual Cue
var const_VISUAL_CUE_LEFT_MARGIN = 391 //471  modified for expand touch area
var const_VISUAL_CUE_TOP_MARGIN = 460
var const_VISUAL_CUE_ELEMENTS_SPACING = 14
var const_ROTATION_OK_BUTTON_TOP_MARGIN = 38
var const_COLOR_ROTATION_BTN_TEXT  = "#FAFAFA"
var const_COLOR_ROTATION_BTN_TEXT_DIMMED = "#9E9E9E"
var const_ROTATION_BTN_TEXT_SIZE = 32
//modified by aettie 20130625 for New GUI
var const_VISUAL_CUE_WHEEL_L_LEFT_MARGIN = 22 
var const_VISUAL_CUE_WHEEL_R_LEFT_MARGIN = 68
var const_VISUAL_CUE_WHEEL_TOP_MARGIN = 31
var const_VISUAL_CUE_ZOOM_LEFT_MARGIN = 640
//var const_VISUAL_CUE_ZOOM_TOP_MARGIN = 574
var const_VISUAL_CUE_ZOOM_TOP_MARGIN = 460 + 73  //const_VISUAL_CUE_TOP_MARGIN + mode area width
//modified by aettie.ji 2013.02.08
var const_VISUAL_CUE_MA_LEFT_MARGIN = 52 // added by cychoi 2015.11.06 for ISV 120461
var const_VISUAL_CUE_MA_TOP_MARGIN = 3 // added by cychoi 2015.11.06 for ISV 120461

// Visual cue button's index
var const_DUMMY = 0 //added for expand touch area
var const_REW_BTN_NUMBER = 1
var const_VISUALCUE_BTN_NUMBER = 2
var const_FOR_BTN_NUMBER = 3
//Lockout 2013.05.24 modified by edo.lee 
var const_LOCKOUT_ICON_TOP_OFFSET = 289//189
var const_LOCKOUT_TEXT_TOP_OFFSET = 467//367

var const_APP_PHOTO_FONT_FAMILY_HDR = "HDR"
var const_APP_PHOTO_FONT_FAMILY_HDB = "HDB"
var const_APP_PHOTO_FONT_FAMILY_NEW_HDR = "DH_HDR"
var const_APP_PHOTO_FONT_FAMILY_NEW_HDB = "DH_HDB"

