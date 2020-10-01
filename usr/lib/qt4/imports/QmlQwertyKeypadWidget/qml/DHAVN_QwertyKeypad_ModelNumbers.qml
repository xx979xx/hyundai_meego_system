import QtQuick 1.0

Item{
    id: numeric_keypad_model
    property int btn_count: 36
    property list<ListElement> keypad:[
        ListElement{
            property int btn_id: 0
            property variant trn_index:[0,0,0, 0,10,11, 0,1, 35,1]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A00"
            property int btn_keycode: Qt.Key_1  /*0x49*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 0
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 1
            property variant trn_index:[1,1,1, 10,11,12, 0,2, 0,2]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A01"
            property int btn_keycode: Qt.Key_2 /*0x50*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 127
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 2
            property variant trn_index:[2,2,2, 11,12,13, 1,3, 1,3]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A02"
            property int btn_keycode: Qt.Key_3 /*0x51*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 254
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 3
            property variant trn_index:[3,3,3, 12,13,14, 2,4, 2,4]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A03"
            property int btn_keycode: Qt.Key_4 /*0x52*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 381
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 4
            property variant trn_index:[4,4,4, 13,14,15, 3,5, 3,5]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A04"
            property int btn_keycode: Qt.Key_5 /*0x53*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 508
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 5
            property variant trn_index:[5,5,5, 14,15,16, 4,6, 4,6]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A05"
            property int btn_keycode: Qt.Key_6 /*0x54*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 635
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 6
            property variant trn_index:[6,6,6, 15,16,17, 5,7, 5,7]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A06"
            property int btn_keycode: Qt.Key_7  /*0x55;*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 762
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 7
            property variant trn_index:[7,7,7, 16,17,18, 6,8, 6,8]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A07"
            property int btn_keycode: Qt.Key_8 /*0x56*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 889
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 8
            property variant trn_index:[8,8,8, 17,18,8, 7,9, 7,9]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A08"
            property int btn_keycode: Qt.Key_9 /*0x57*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 1016
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 9
            property variant trn_index:[9,9,9, 18,18,9, 8,9, 8,10]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A09"
            property int btn_keycode: Qt.Key_0 /*0x48*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 1143
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 10
            property variant trn_index:[10,0,1, 10,19,19, 10,11, 9,11]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_B00"
            property int btn_keycode: Qt.Key_Apostrophe
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 0
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 11
            property variant trn_index:[0,1,2, 19,19,20, 10,12, 10, 12]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_B01"
            property int btn_keycode: Qt.Key_QuoteDbl
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 127
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 12
            property variant trn_index:[1,2,3, 19,20,21, 11,13, 11,13]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_B02"
            property int btn_keycode: Qt.Key_Colon
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 254
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 13
            property variant trn_index:[2,3,4, 20,21,22, 12,14, 12,14]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_B03"
            property int btn_keycode: Qt.Key_Semicolon /*0x3b*///  ";"
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 381
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 14
            property variant trn_index:[3,4,5, 21,22,23, 13,15, 13,15]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_B04"
            property int btn_keycode: Qt.Key_ParenLeft /*0x28*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 508
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 15
            property variant trn_index:[4,5,6, 22,23,24, 14,16, 14,16]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_B05"
            property int btn_keycode: Qt.Key_ParenRight /*0x29*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 635
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 16
            property variant trn_index:[5,6,7, 23,24,25, 15,17, 15,17]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_B06"
            property int btn_keycode: Qt.Key_Underscore   //95
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 762
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 17
            property variant trn_index:[6,7,8, 24,25,26, 16,18, 16,18]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_B07"
            property int btn_keycode: Qt.Key_Ampersand /*0x26*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 889
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 18
            property variant trn_index:[7,8,9, 25,26,27, 17,18, 17,19]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_B08"
            property int btn_keycode: Qt.Key_Dollar /*0x24*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 1016
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 19
            property variant trn_index:[19,10,11, 19,28,19, 19,20, 18,20]
            property int btn_width: 247
            property int btn_height: 86
            property string btn_suffix: 'kor_page'
            property string btn_text: "STR_KEYPAD_TYPE_C00"
            property int btn_keycode: Qt.Key_Launch7 /*0x2d*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 0
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 20
            property variant trn_index:[11,12,13, 20,30,31, 19,21, 19,21]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_C01"
            property int btn_keycode: Qt.Key_Period /*0x2e*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 254
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 21
            property variant trn_index:[12,13,14, 30,31,32, 20,22, 20,22]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_C02"
            property int btn_keycode: Qt.Key_Comma /*0x2c*///  ","
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 381
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 22
            property variant trn_index:[13,14,15, 31,32,32, 21,23, 21,23]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_C03"
            property int btn_keycode: Qt.Key_Question /*0x3f*///  "?"
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 508
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 23
            property variant trn_index:[14,15,16, 32,32,32, 22,24, 22,24]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_C04"
            property int btn_keycode: Qt.Key_Exclam /*0x21*/// !
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 635
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 24
            property variant trn_index:[15,16,17, 32,32,33, 23,25, 23,25]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_C05"
            property int btn_keycode: Qt.Key_Minus  // 45   // "-"
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 762
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 25
            property variant trn_index:[16,17,18, 32,33,34, 24,26, 24,26]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_C06"//  "/"
            property int btn_keycode: Qt.Key_Slash  /*0x2f*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 889
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 26
            property variant trn_index:[17,18,26, 33,34,35, 25,27, 25,27]
            property int btn_width: 120
            property int btn_height: 86;
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_C07"
            property int btn_keycode: Qt.Key_At  /*0x40*/   // @
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 1016
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 27
            property variant trn_index:[18,18,27, 34,35,27, 26,27, 26,28]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'la_del'
            property string btn_text: ""
            property int btn_keycode: Qt.Key_Back /*0x01000061*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 1143
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 28
            property variant trn_index:[28,19,20, 28,28,28, 28,30, 27,30]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_pad'
            property string btn_text: ""
            property int btn_keycode: Qt.Key_Launch0
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 0
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 29
            property variant trn_index:[29,29,29, 29,29,29, 29,29, 29,29]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_etc'          // 123#
            property string btn_text: "Launch1"
            property int btn_keycode: Qt.Key_Launch1
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 42
            property int btnXpos: 127
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 30
            property variant trn_index:[19,20,21, 28,30,30, 28,31, 28,31]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_etc'
            property string btn_text: "Launch2"
            property int btn_keycode: Qt.Key_Launch2
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 42
            property int btnXpos: 254
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 31
            property variant trn_index:[20,21,22, 31,31,31, 30,32, 30,32]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_etc'          // ABC
            property string btn_text: "Launch3"
            property int btn_keycode: Qt.Key_Launch3
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 42
            property int btnXpos: 381
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 32
            property variant trn_index:[/*21,22,23*/22,23,24, 32,32,32, 31,33, 31,33] //modified for ITS 232993 Space Focus Rule Issue
            property int btn_width: 374
            property int btn_height: 86
            property string btn_suffix: 'kor_space'    //'space'
            property string btn_text: " "
            property int btn_keycode: 0x20//Qt.Key_Space /*0x20*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 508
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 33
            property variant trn_index:[24,25,26, 33,33,33, 32,34, 32,34]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'      // 'comma'            // .-@
            property string btn_text: ".-@"
            property int btn_keycode: Qt.Key_Launch4
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 889
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 34
            property variant trn_index:[25,26,27, 34,34,34, 33,35, 33,35]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_set'
            property string btn_text: ""
            property int btn_keycode: Qt.Key_Launch5
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 1016
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 35
            property variant trn_index:[26,27,35, 35,35,35, 34,35, 34,0]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_done'
            property string btn_text: ""
            property int btn_keycode: 0x01000010//Qt.Key_Home  /*0x01000010*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 1143
            property int btnYpos: 288
        }
    ]
}
