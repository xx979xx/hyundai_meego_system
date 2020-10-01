
var LHD_left_VENT_X= 4  // arrow_01 (1)
var LHD_left_VENT_Y= 109 + 31 + 47 + 53 + 34 // arrow_01 (1)
var LHD_left_FLOOR_X= LHD_left_VENT_X + 143
var LHD_left_FLOOR_Y= LHD_left_VENT_Y + 106

var LHD_right_VENT_X= 4 + 143 + 67 + 125 + 111 + 27
var LHD_right_VENT_Y= 109
var LHD_right_FLOOR_X= LHD_right_VENT_X - 27
var LHD_right_FLOOR_Y= LHD_right_VENT_Y + 31 + 47 + 53

var LHD_left_VENT_X_margin = 143 + 67   // arrow_01 (2)
var LHD_left_VENT_Y_margin = - 53 - 34  // arrow_01 (2)
var LHD_right_VENT_X_margin = -111 - 27
var LHD_right_VENT_Y_margin = 53

var RHD_left_VENT_X= 7
var RHD_left_VENT_Y= 100 + 73 + 58 + 6 +97
var RHD_left_FLOOR_X= RHD_left_VENT_X + 120
var RHD_left_FLOOR_Y= RHD_left_VENT_Y + 106

var RHD_right_VENT_X= 7 + 120 + 72 + 101 + 155
var RHD_right_VENT_Y= 100
var RHD_right_FLOOR_X= RHD_right_VENT_X
var RHD_right_FLOOR_Y= RHD_right_VENT_Y + 73 +58 + 6

var RHD_left_VENT_X_margin = 120 + 72
var RHD_left_VENT_Y_margin = - 97 - 6
var RHD_right_VENT_X_margin = -155
var RHD_right_VENT_Y_margin =  73

var rear_X= 531
var rear_Y= 412
var const_LANGCONTEXT = "main"
var left_BOX_X= 354
var left_BOX_Y= 282+48+104-21+26 //26(+offset)
var left_BOX_TITLE_X= left_BOX_X + 10
var left_BOX_TITLE_Y= left_BOX_Y
var left_BOX_TEMP_X= left_BOX_X + 13 + 38
var left_BOX_TEMP_Y= left_BOX_Y
var left_BOX_TEXT_WIDTH= 192

var right_BOX_X= 354+192+73
var right_BOX_Y= 282-21+26 //26(+offset)
var right_BOX_TITLE_X= right_BOX_X + 10
var right_BOX_TITLE_Y= right_BOX_Y
var right_BOX_TEMP_X= right_BOX_TITLE_X
var right_BOX_TEMP_Y= right_BOX_Y + 31 + 10
var right_BOX_TEXT_WIDTH= 184

var single_VENT_X= 313
var single_VENT_Y= 257
var single_FLOOR_X= single_VENT_X + 13
var single_FLOOR_Y= single_VENT_Y + 58
var single_BOX_X= 567
var single_BOX_Y= 388-20
var single_BOX_TEMP_X= single_BOX_X + 10
var single_BOX_TEMP_Y= single_BOX_Y

var topButton_RECT_X = 860 + 138 + 138
var topButton_RECT_Y = 93
var topButton_reverse_RECT_X = 3
var topButton_reverse_RECT_Y = 93

var icon_DEF_X = 12
var icon_DEF_Y = 103
var icon_DEF_reverse_X = 12 //3 + 6
var icon_DEF_reverse_Y = 103 //93 + 84

var rect_off_X = 572
var rect_off_Y = 640

var rect_off_reverse_X = 572
var rect_off_reverse_Y = 640

var rect_off_text_X = rect_off_X + 53
var rect_off_text_Y = rect_off_Y + 11

var rect_off_text_reverse_X = rect_off_reverse_X
var rect_off_text_reverse_Y = rect_off_reverse_Y + 11

var rect_off_icon_wind_reverse_X = rect_off_reverse_X + 77 + 7
var rect_off_icon_wind_reverse_Y = rect_off_reverse_Y

var bg_option_menu_X = 767
var bg_option_menu_Y = 93

var bg_option_menu_reverse_X = 0
var bg_option_menu_reverse_Y = 93

var bg_optionmenu_line_X = 845
var bg_optionmenu_line_Y = 172

var bg_optionmenu_line_reverse_X = 5 + 8
var bg_optionmenu_line_reverse_Y = 172

var id_option_menu_rect_X = bg_optionmenu_line_X + 3
var id_option_menu_rect_Y = bg_option_menu_Y

var id_option_menu_rect_reverse_X = bg_optionmenu_line_reverse_X + 3
var id_option_menu_rect_reverse_Y = bg_option_menu_Y

var FR_CONTROL = 0x1
var TEMP = 0x6
var MODE = 0x18
var REAR_CONTROL = 0x20
var RHD = 0x40
var EU = 0x80
