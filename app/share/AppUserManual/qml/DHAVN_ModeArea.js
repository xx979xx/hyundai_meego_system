/** ModeArea */
.pragma library

var SEARCH_BAR = 0
var RIGHT_BTN = 1
// modified by minho 20120821
// { for NEW UX: Added menu button on ModeArea
//var BACK_BTN = 2
var MENU_BTN = 2
var BACK_BTN = 3
// } modified by minho

var const_WIDGET_WIDTH = 1280
var const_WIDGET_Y = 93
var const_WIDGET_HEIGHT = 73

/** Main layout of ModeArea */
var const_WIDGET_LANGCONTEXT = "main"
var const_WIDGET_SPACING = 0 // changed by minho 20120829 for display focus on back button
var const_WIDGET_RIGHTMARGIN = 5
// modified by minho 20120821
// { for NEW UX: Added active tab on media
//var const_WIDGET_LEFTMARGIN = 7
var const_WIDGET_LEFTMARGIN = 5
// } modified by minho

/** Common for Right and Back buttons */
var const_SPIN_CTRL_COLOR_TEXT_BRIGHT_GREY = "#FAFAFA"

var const_WIDGET_RB_COLOR = "#FAFAFA"
var const_WIDGET_RB_COLOR_DISABLED = "#9E9E9E"
var const_WIDGET_RB_FONT_SIZE = 30

var const_WIDGET_BG_IMG = "/app/share/images/AppSettings/general/bg_title.png"
var const_WIDGET_BUTTON_TEXT_FONT_FAMILY = "HDB"    //added by aettie.ji 2012.11.22 for New UX

/** Right button */
var const_WIDGET_RB_IMG_NORMAL = "/app/share/images/AppMobileTv/general/btn_title_sub_n.png" //"/app/share/images/AppSettings/general/btn_title_sub_n.png"
var const_WIDGET_RB_IMG_PRESSED = "/app/share/images/AppMobileTv/general/btn_title_sub_p.png"  //"/app/share/images/general/btn_title_sub_p.png"
var const_WIDGET_RB_FOCUS_IMG = "/app/share/images/AppMobileTv/general/btn_title_sub_f.png"
var const_WIDGET_RB_FOCUS_IMG_PRESSED = "/app/share/images/AppMobileTv/general/btn_title_sub_p.png"

// added by minho 20120821
// { for NEW UX: Added menu button on ModeArea
/** Menu button */
var const_WIDGET_MB_IMG_NORMAL = "/app/share/images/AppMobileTv/general/btn_title_sub_n.png"
var const_WIDGET_MB_IMG_PRESSED = "/app/share/images/AppMobileTv/general/btn_title_sub_p.png"
var const_WIDGET_MB_FOCUS_IMG = "/app/share/images/AppMobileTv/general/btn_title_sub_fp.png"
// } added by minhoS

/** Back button */
var const_WIDGET_BB_IMG_NORMAL = "/app/share/images/AppSettings/general/btn_title_back_n.png"
var const_WIDGET_BB_IMG_PRESSED ="/app/share/images/AppSettings/general/btn_title_back_p.png"
var const_WIDGET_BB_IMG_FOCUS = "/app/share/images/AppSettings/general/btn_title_back_f.png"
var const_WIDGET_BB_ME_IMG_NORMAL = "/app/share/images/AppCamera/btn_title_back_n-rev.png";
var const_WIDGET_BB_ME_IMG_PRESSED ="/app/share/images/AppCamera/btn_title_back_p-rev.png"
var const_WIDGET_BB_ME_IMG_FOCUS = "/app/share/images/AppCamera/btn_title_back_f-rev.png"

/** Title text */
var const_WIDGET_TITLE_COLOR = "#FAFAFA"
//{ modifyed by eunhye 2012.08.27 for Music(LGE) # 39
//var const_WIDGET_TITLE_TEXT_SIZE = 26
var const_WIDGET_TITLE_TEXT_SIZE = 40
//} modifyed by eunhye 2012.08.27 for
var const_WIDGET_TITLE_TEXT_LEFTMARGIN = 45

/** Counter text */
var const_WIDGET_COUNTER_TEXT_FONT_FAMILY = "HDB"
//var const_WIDGET_COUNTER_TEXT_PIXEL_SIZE = 35
var const_WIDGET_COUNTER_TEXT_PIXEL_SIZE = 30 //modified by aettie.ji 2012.12.20 for new ux
var const_WIDGET_COUNTER_TEXT_COLOR = "#7CBDFF"

