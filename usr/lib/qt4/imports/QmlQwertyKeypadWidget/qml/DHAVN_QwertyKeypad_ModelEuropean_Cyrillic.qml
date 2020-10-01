import QtQuick 1.0

Item{
    id: european_cyrillic_keypad_model
    property int btn_count: 44
    property list<ListElement> keypad:[
        ListElement{
            property int btn_id: 0
            property variant trn_index:[0,0,0, 0,13,14, 0,1, 44,1]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A00"
            property int btn_keycode: 0x51//Qt.Key_Q  /*0x51*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 0
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 1
            property variant trn_index:[1,1,1, 13,14,15, 0,2, 0,2]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A01"
            property int btn_keycode: 0x57//Qt.Key_W /*0x57*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 97
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 2
            property variant trn_index:[2,2,2, 14,15,16, 1,3, 1,3]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A02"
            property int btn_keycode: 0x45//Qt.Key_E /*0x45*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 194
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 3
            property variant trn_index:[3,3,3, 15,16,17, 2,4, 2,4]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A03"
            property int btn_keycode: 0x52//Qt.Key_R /*0x52*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 291
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 4
            property variant trn_index:[4,4,4, 16,17,18, 3,5, 3,5]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A04"
            property int btn_keycode: 0x54//Qt.Key_T /*0x54*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 388
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 5
            property variant trn_index:[5,5,5, 17,18,19, 4,6, 4,6]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A05"
            property int btn_keycode: 0x59//Qt.Key_Y /*0x59*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 485
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 6
            property variant trn_index:[6,6,6, 18,19,20, 5,7, 5,7]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A06"
            property int btn_keycode: 0x55//Qt.Key_U  /*0x55*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 582
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 7
            property variant trn_index:[7,7,7, 19,20,21, 6,8, 6,8]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A07"
            property int btn_keycode: 0x49//Qt.Key_I /*0x49*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 679
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 8
            property variant trn_index:[8,8,8, 20,21,22, 7,9, 7,9]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A08"
            property int btn_keycode: 0x4f//Qt.Key_O /*0x4f*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 776
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 9
            property variant trn_index:[9,9,9, 21,22,23, 8,10, 8,10]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A09"
            property int btn_keycode: 0x50//Qt.Key_P /*0x50*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 873
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 10
            property variant trn_index:[10,10,10, 22,23,24, 9,11, 9,11]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A10"
            property int btn_keycode: 0x50//Qt.Key_P /*0x50*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 970
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 11
            property variant trn_index:[11,11,11, 23,24,11, 10,12, 10,12]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A11"
            property int btn_keycode: 0x50//Qt.Key_P /*0x50*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 1067
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 12
            property variant trn_index:[12,12,12, 24,24,12, 11,12, 11,13]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_A12"
            property int btn_keycode: 0x50//Qt.Key_P /*0x50*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 1164
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 13
            property variant trn_index:[13,0,1, 13,25,26, 13,14, 12,14]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B00"
            property int btn_keycode: 0x41//Qt.Key_A /*0x41*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 0
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 14
            property variant trn_index:[0,1,2, 25,26,26, 13,15, 13,15]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B01"
            property int btn_keycode: 0x53//Qt.Key_S /*0x53*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 97
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 15
            property variant trn_index:[1,2,3, 26,26,27, 14,16, 14,16]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B02"
            property int btn_keycode: 0x44//Qt.Key_D /*0x44*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 194
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 16
            property variant trn_index:[2,3,4, 26,27,28, 15,17, 15,17]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B03"
            property int btn_keycode: 0x46//Qt.Key_F /*0x46 */
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 291
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 17
            property variant trn_index:[3,4,5, 27,28,29, 16,18, 16,18]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B04"
            property int btn_keycode: 0x47//Qt.Key_G /*0x47*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 388
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 18
            property variant trn_index:[4,5,6, 28,29,30, 17,19, 17,19]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B05"
            property int btn_keycode:0x48//Qt.Key_H /*0x48*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 485
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 19
            property variant trn_index:[5,6,7, 29,30,31, 18,20, 18,20]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B06"
            property int btn_keycode: 0x4a//Qt.Key_J /*0x4a*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 582
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 20
            property variant trn_index:[6,7,8, 30,31,32, 19,21, 19,21]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B07"
            property int btn_keycode: 0x4b//Qt.Key_K /*0x4b*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 679
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 21
            property variant trn_index:[7,8,9, 31,32,33, 20,22, 20,22]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B08"
            property int btn_keycode: 0x4c//Qt.Key_L  /*0x4c*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 776
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 22
            property variant trn_index:[8,9,10, 32,33,34, 21,23, 21,23]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B09"
            property int btn_keycode: 0x4c//Qt.Key_L  /*0x4c*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 873
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 23
            property variant trn_index:[9,10,11, 33,34,35, 22,24, 22,24]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B10"
            property int btn_keycode: 0x4c//Qt.Key_L  /*0x4c*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 970
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 24
            property variant trn_index:[10,11,12, 34,35,35, 23,24, 23,25]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_B11"
            property int btn_keycode: 0x4c//Qt.Key_L  //0x4c
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 1067
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 25
            property variant trn_index:[25,13,14, 25,36,37, 25,26, 24,26]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'cy_shift'   //const_BTN_SHIFT_L_SUFFIX
            property string btn_text: ""
            property int btn_keycode: 0x01000020//Qt.Key_Shift  /*0x01000020*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 0
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 26
            property variant trn_index:[13,14,16, 36,37,39, 25,27, 25,27]
            property int btn_width: 189
            property int btn_height: 86
            property string btn_suffix: 'cy_page'
            property string btn_text: "STR_KEYPAD_TYPE_C00"
            property int btn_keycode: Qt.Key_LaunchA
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 97
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 27
            property variant trn_index:[15,16,17, 38,39,40, 26,28, 26,28]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_C01"
            property int btn_keycode: 0x58//Qt.Key_X /*0x58*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 291
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 28
            property variant trn_index:[16,17,18, 39,40,41, 27,29, 27,29]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_C02"
            property int btn_keycode: 0x43 /*Qt.Key_C*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 388
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 29
            property variant trn_index:[17,18,19, 40,41,41, 28,30, 28,30]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_C03"
            property int btn_keycode:0x56//Qt.Key_V /*0x56*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 485
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 30
            property variant trn_index:[18,19,20, 41,41,41, 29,31, 29,31]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_C04"
            property int btn_keycode: 0x42//Qt.Key_B /*0x42*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 582
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 31
            property variant trn_index:[19,20,21, 41,41,41, 30,32, 30,32]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_C05"
            property int btn_keycode: 0x4e//Qt.Key_N /*0x4e*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 679
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 32
            property variant trn_index:[20,21,22, 41,41,42, 31,33, 31,33]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_C06"
            property int btn_keycode:0x4d//Qt.Key_M /*0x4d*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 776
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 33
            property variant trn_index:[21,22,23, 41,42,43, 32,34, 32,34]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_C07"
            property int btn_keycode:0x4d//Qt.Key_M /*0x4d*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 873
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 34
            property variant trn_index:[22,23,24, 42,43,44, 33,35, 33,35]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'
            property string btn_text: "STR_KEYPAD_TYPE_C08"
            property int btn_keycode:0x4d//Qt.Key_M /*0x4d*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 970
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 35
            property variant trn_index:[23,24,35, 43,44,35, 34,35, 34,36]
            property int btn_width: 188
            property int btn_height: 86
            property string btn_suffix: 'me_del'
            property string btn_text: ""
            property int btn_keycode: 0x01000061//Qt.Key_Back
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 1067
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 36
            property variant trn_index:[36,25,26, 36,36,36, 36,37, 35,37]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_keypad'
            property string btn_text: ""
            property int btn_keycode: Qt.Key_Launch0
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 0
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 37
            property variant trn_index:[25,26,26, 37,37,37, 36,38, 36,38]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_etc'          // 123#
            property string btn_text: "Launch1"
            property int btn_keycode: Qt.Key_Launch1
            property int btn_fontSize: 32
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 97
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 38
            property variant trn_index:[26,26,27, 38,38,38, 37,39, 37,39]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_etc'          // A..Z
            property string btn_text: "Launch2"
            property int btn_keycode: Qt.Key_Launch2
            property int btn_fontSize: 32
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 194
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 39
            property variant trn_index:[26,27,28, 39,39,39, 38,41, 38,41]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_etc'          // A...Y
            property string btn_text: "Launch3"
            property int btn_keycode: Qt.Key_Launch3
            property int btn_fontSize: 32
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 291
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 40
            property variant trn_index:[40,40,40, 40,40,40, 40,40, 40,40]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_etc'          // A..R
            property string btn_text: "Launch6"
            property int btn_keycode: Qt.Key_Launch6
            property int btn_fontSize: 32
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 388
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 41
            property variant trn_index:[28,29,33, 41,41,41, 39,42, 39,42]
            property int btn_width: 382
            property int btn_height: 86
            property string btn_suffix: 'me_space'    //'space'
            property string btn_text: " "
            property int btn_keycode: 0x20//Qt.Key_Space /*0x20*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 485
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 42
            property variant trn_index:[32,33,34, 42,42,42, 41,43, 41,43]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_character'      // 'comma'            // .-@
            property string btn_text: ".-@"
            property int btn_keycode: Qt.Key_Launch4
            property int btn_fontSize: 32
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 873
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 43
            property variant trn_index:[33,34,35, 43,43,43, 42,44, 42,44]
            property int btn_width: 91
            property int btn_height: 86
            property string btn_suffix: 'me_set'
            property string btn_text: ""
            property int btn_keycode: Qt.Key_Launch5
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 970
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 44
            property variant trn_index:[34,35,44, 44,44,44, 43,44, 43,0]
            property int btn_width: 189
            property int btn_height: 86
            property string btn_suffix: 'me_done'
            property string btn_text: ""
            property int btn_keycode: 0x01000010//Qt.Key_Home  /*0x01000010*/
            property int btn_fontSize: 36
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 1067
            property int btnYpos: 288
        }
    ]
}
