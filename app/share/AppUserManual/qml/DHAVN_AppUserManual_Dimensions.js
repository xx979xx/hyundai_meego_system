/*
**  DHAVN_AppUserManual_Dimensions.js
*/

.pragma library

//common

var const_AppUserManual_MainScreenWidth = 1280
var const_AppUserManual_MainScreenHeight = 720

var const_AppUserManual_StatusBar_Height = 93 //93
var const_AppUserManual_ModeArea_Height = 73

var const_FULLSCREEN_DURATION_ANIMATION = 300//200
var const_AppUserManual_Animation_Duration = 1000

var const_AppUserManual_FocusNone = -1
var const_AppUserManual_StatusBar_FocusIndex = 0
var const_AppUserManual_ModeArea_FocusIndex = 1
var const_AppUserManual_OptionMenu_FocusIndex = 2
var const_AppUserManual_KeyPad_FocusIndex = 3
var const_AppUserManual_TitleList_FocusIndex = 4
var const_AppUserManual_PageNumList_FocusIndex = 5
var const_AppUserManual_VisualCue_FocusIndex = 6
var const_AppUserManual_SearchBox_FocusIndex = 7
var const_AppUserManual_SearchButton_FocusIndex = 8
var const_AppUserManual_SearchBack_FocusIndex = 9
var const_AppUserManual_PDF_Screen_FocusIndex = 10
var const_AppUserManual_PDF_List_FocusIndex = 11
var const_AppUserManual_Search_View_FocusIndex = 12

var const_AppUserManual_Page_Title_List_Width = 590
var const_AppUserManual_Page_Title_List_Height = 534

var const_AppUserManual_List_Highlight_MoveSpeed = 100
var const_AppUserManual_List_Highlight_MoveDuration =  100

var const_AppUserManual_Title_ScrollBar_X = 540
var const_AppUserManual_Title_ScrollBar_Y = 28

var const_AppUserManual_ListDelegate_Width = 530 // 493
var const_AppUserManual_ListDelegate_Height = 89

var const_AppUserManual_ListText_Color_BrightGrey = Qt.rgba(250/255, 250/255, 250/255, 1) // "#FAFAFA"
var const_AppUserManual_ListText_Color_DimmedGrey = Qt.rgba(158/255, 158/255, 158/255, 1) // "#9E9E9E"
var const_AppUserManual_ListText_Color_DisableGrey = Qt.rgba(91/255, 91/255, 91/255, 1)
var const_AppUserManual_ListText_Color_Grey = Qt.rgba(193/255, 193/255, 193/255, 1)
var const_AppUserManual_ListText_Color_Black = "black"
var const_AppUserManual_ListText_Color_Select = Qt.rgba(124/255, 189/255, 255/255, 1)  //"#7CBDFF" // "#447CAD"// Qt.rgba(124,189,255)
var const_AppUserManual_Rectangle_Color_Transparent = "transparent"
var const_AppUserManual_Color_White = "white"

var const_AppUserManual_TitleList_Item_Width = 479 // 465
var const_AppUserManual_TitleList_LeftMargin = 14
var const_AppUserManual_PageList_LeftMargin = 20

var const_AppUserManual_Font_Size_46 = 46
var const_AppUserManual_Font_Size_40 = 40
var const_AppUserManual_Font_Size_36 = 36
var const_AppUserManual_Font_Size_32 = 32
var const_AppUserManual_Font_Size_30 = 30

var const_AppUserManual_ModeArea_MenuBtn = 0
var const_AppUserManual_ModeArea_MenuBtn_X = 860 + 138
var const_AppUserManual_ModeArea_BackBtn = 1

var const_AppUserManual_ModeArea_Y = 0
var const_AppUserManual_ModeArea_Z = 10
var const_AppUserManual_Background_Y = 73
var const_AppUserManual_TitleList_X = 43
var const_AppUserManual_TitleList_ME_X = 744
var const_AppUserManual_TitleList_Y = 6 //8
var const_AppUserManual_PageNumList_X = 708
var const_AppUserManual_Z_1 = 1
var const_AppUserManual_Z_2 = 2
var const_AppUserManual_Z_1000 = 10
var const_AppUserManual_OptionsMenu_AutoHide = 10000

var const_AppUserManual_VisualCue_X = 575
var const_AppUserManual_VisualCue_Y = 460
var const_AppUserManual_LeftZoom_TopMargin = 34
var const_AppUserManual_LeftZoom_LeftMargin = 14
var const_AppUserManual_Prev_X = 471
var const_AppUserManual_PrevNext_Y = 506
var const_AppUserManual_Next_X = 721

var const_AppUserManual_Cue_X = 566
var const_AppUserManual_Cue_Y = 198

var const_AppUserManual_Cue_Left_Margin_X = 22
var const_AppUserManual_Cue_TopBottom_Margin_X = 22+31
var const_AppUserManual_Cue_Right_Margin_X = 22+31+34

var const_AppUserManual_Cue_LeftRight_Margin_Y = 27+31
var const_AppUserManual_Cue_Top_Margin_Y = 27
var const_AppUserManual_Cue_Bottom_Margin_Y = 27+31+34

var const_AppUserManual_Back_Button_X =  920 + 121 + 80 + 20// 121 //1059
var const_AppUserManual_Search_Button_X = 920 + 80 //121 //859
var const_AppUserManual_Button_Border_Width = 5 //8
var const_AppUserManual_SearchBox_X = 0
var const_AppUserManual_SearchBox_Z = 3
var const_AppUserManual_SearchBox_Width = 991 //1034//850
var const_AppUserManual_SearchBox_Height = 140
var const_AppUserManual_TextInput_LeftMargin = 34+67// 164
var const_AppUserManual_TextInput_RightMargin = 15

var const_AppUserManual_Search_Font_Size_30 = 30
var const_AppUserManual_Search_Font_Size_32 = 32
var const_AppUserManual_Search_Font_Color = Qt.rgba(98/255, 98/255, 98/255, 1) // "#9E9E9E"
var const_AppUserManual_Search_Font_Color_1 = "#0087EF"
var const_AppUserManual_Search_BottomMargin = 0
var const_AppUserManual_Search_X = 7// 15
var const_AppUserManual_Search_Y = 92
var const_AppUserManual_Search_NoResults_X = 20
var const_AppUserManual_Search_NoResults_Y = 200
var const_AppUserManual_Search_NoResults_Z = 10
var const_AppUserManual_KeyPad_Y = 175

var const_AppUserManual_List_Width = 1246
var const_AppUserManual_List_Height = 540
var const_AppUserManual_List_Height_1 = 90
var const_AppUserManual_List_LeftMargin = 87

var const_AppUserManual_NumericKeyPad_Height = 158
var const_AppUserManual_KeyPad_CellWidth = 212
var const_AppUserManual_KeyPad_CellHeight = 77
var const_AppUserManual_NumericKeyPad_Y = 562
var const_AppUserManual_GoTo_Search_Width = 197
var const_AppUserManual_GoTo_Search_Height = 73
var const_AppUserManual_GoTo_TopMargin = 18
var const_AppUserManual_GoTo_Text_Pixel_Size = 30
var const_AppUserManual_GoTo_Text_Color = "#7CBDFF"
var const_AppUserManual_Goto_Search_X = 821 // 841
var const_AppUserManual_Goto_Search_Arab_X = 276 +10 // 332 // 312

var const_AppUserManual_PDFControls_Width = 340
var const_AppUserManual_PDFControls_Height = 163

var const_AppUserManual_LeftMenu_Pane = 1
var const_AppUserManual_RightMenu_Pane = 2

var const_AppUserManual_Cue_Focus_VisualCue = 0
var const_AppUserManual_Cue_Focus_Left = 1
var const_AppUserManual_Cue_Focus_Right = 2
var const_AppUserManual_Cue_Focus_Up = 3
var const_AppUserManual_Cue_Focus_Down = 4
var const_AppUserManual_Cue_Focus_Top_Left = 5
var const_AppUserManual_Cue_Focus_Top_Right = 6
var const_AppUserManual_Cue_Focus_Bottom_Left = 7
var const_AppUserManual_Cue_Focus_Bottom_Right = 8
var const_AppUserManual_Cue_Focus_Numeric = 9

var const_AppUserManual_Cue_Focus_Wheel = 0
var const_AppUserManual_Cue_Focus_Wheel_Left = 1
var const_AppUserManual_Cue_Focus_Wheel_Right = 2


var const_AppUserManual_Focus_SearchBar = 0
var const_AppUserManual_Focus_SearchBar_Search = 1
var const_AppUserManual_Focus_SearchBar_Back = 2
var const_AppUserManual_Focus_SearchBar_Keypad = 3

var const_AppUserManual_Scroll_Count = 6

//double tap
var const_DOUBLE_TAP_MAX_TIME_DELTA = 350 //delta in milliseconds



var JOG_CENTER = 0
var JOG_UP = 1
var JOG_DOWN = 2
var JOG_LEFT = 3
var JOG_RIGHT = 4
var JOG_TOP_RIGHT = 5
var JOG_BOTTOM_RIGHT = 6
var JOG_TOP_LEFT = 7
var JOG_BOTTOM_LEFT = 8
var JOG_WHEEL_LEFT = 9
var JOG_WHEEL_RIGHT = 10
var JOG_WHEEL_LONG_LEFT = 11
var JOG_WHEEL_LONG_RIGHT = 12
var JOG_NONE = 13
