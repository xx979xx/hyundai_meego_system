import QtQuick 1.0

Item{
    id: english_qwerty_keypad_model
    property int btn_count: 36
    property list<ListElement> keypad:[
        ListElement{
            property int btn_id: 0
            property variant trn_index:[0,0,0, 0,10,11, 0,1, 35,1]
            property variant trn_index2:[0,0,0, 0,10,11, 0,1, 35,1]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_Q"
            property int btn_keycode: 0x51//Qt.Key_Q  /*0x51*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 0
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 1
            property variant trn_index:[1,1,1, 10,11,12, 0,2, 0,2]
            property variant trn_index2:[1,1,1, 10,11,12, 0,2, 0,2]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_W"
            property int btn_keycode: 0x57//Qt.Key_W /*0x57*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 127
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 2
            property variant trn_index:[2,2,2, 11,12,13, 1,3, 1,3]
            property variant trn_index2:[2,2,2, 11,12,13, 1,3, 1,3]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_E"
            property int btn_keycode: 0x45//Qt.Key_E /*0x45*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 254
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 3
            property variant trn_index:[3,3,3, 12,13,14, 2,4, 2,4]
            property variant trn_index2:[3,3,3, 12,13,14, 2,4, 2,4]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_R"
            property int btn_keycode: 0x52//Qt.Key_R /*0x52*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 381
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 4
            property variant trn_index:[4,4,4, 13,14,15, 3,5, 3,5]
            property variant trn_index2:[4,4,4, 13,14,15, 3,5, 3,5]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_T"
            property int btn_keycode: 0x54//Qt.Key_T /*0x54*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 508
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 5
            property variant trn_index:[5,5,5, 14,15,16, 4,6, 4,6]
            property variant trn_index2:[5,5,5, 14,15,16, 4,6, 4,6]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_Y"
            property int btn_keycode: 0x59//Qt.Key_Y /*0x59*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 635
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 6
            property variant trn_index:[6,6,6, 15,16,17, 5,7, 5,7]
            property variant trn_index2:[6,6,6, 15,16,17, 5,7, 5,7]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_U"
            property int btn_keycode: 0x55//Qt.Key_U  /*0x55*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 762
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 7
            property variant trn_index:[7,7,7, 16,17,18, 6,8, 6,8]
            property variant trn_index2:[7,7,7, 16,17,18, 6,8, 6,8]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_I"
            property int btn_keycode: 0x49//Qt.Key_I /*0x49*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 889
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 8
            property variant trn_index:[8,8,8, 17,18,18, 7,9, 7,9]
            property variant trn_index2:[8,8,8, 17,18,18, 7,9, 7,9]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_O"
            property int btn_keycode: 0x4f//Qt.Key_O /*0x4f*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 1016
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 9
            property variant trn_index:[9,9,9, 18,18,9, 8,9, 8,10]
            property variant trn_index2:[9,9,9, 18,18,9, 8,9, 8,10]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_P"
            property int btn_keycode: 0x50//Qt.Key_P /*0x50*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 1143
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 10
            property variant trn_index:[10,0,1, 10,19,20, 10,11, 9,11]
            property variant trn_index2:[10,0,1, 10,19,20, 10,11, 9,11]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_A"
            property int btn_keycode: 0x41//Qt.Key_A /*0x41*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 0
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 11
            property variant trn_index:[0,1,2, 19,20,21, 10,12, 10,12]
            property variant trn_index2:[0,1,2, 19,20,21, 10,12, 10,12]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_S"
            property int btn_keycode: 0x53//Qt.Key_S /*0x53*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 127
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 12
            property variant trn_index:[1,2,3, 20,21,22, 11,13, 11,13]
            property variant trn_index2:[1,2,3, 20,21,22, 11,13, 11,13]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_D"
            property int btn_keycode: 0x44//Qt.Key_D /*0x44*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 254
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 13
            property variant trn_index:[2,3,4, 21,22,23, 12,14, 12,14]
            property variant trn_index2:[2,3,4, 21,22,23, 12,14, 12,14]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_F"
            property int btn_keycode: 0x46//Qt.Key_F /*0x46 */
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 381
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 14
            property variant trn_index:[3,4,5, 22,23,24, 13,15, 13,15]
            property variant trn_index2:[3,4,5, 22,23,24, 13,15, 13,15]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_G"
            property int btn_keycode: 0x47//Qt.Key_G /*0x47*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 508
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 15
            property variant trn_index:[4,5,6, 23,24,25, 14,16, 14,16]
            property variant trn_index2:[4,5,6, 23,24,25, 14,16, 14,16]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_H"
            property int btn_keycode:0x48//Qt.Key_H /*0x48*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 635
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 16
            property variant trn_index:[5,6,7, 24,25,26, 15,17, 15,17]
            property variant trn_index2:[5,6,7, 24,25,26, 15,17, 15,17]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_J"
            property int btn_keycode: 0x4a//Qt.Key_J /*0x4a*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 762
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 17
            property variant trn_index:[6,7,8, 25,26,27, 16,18, 16,18]
            property variant trn_index2:[6,7,8, 25,26,27, 16,18, 16,18]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_K"
            property int btn_keycode: 0x4b//Qt.Key_K /*0x4b*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 889
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 18
            property variant trn_index:[7,8,9, 26,27,27, 17,18, 17,19]
            property variant trn_index2:[7,8,9, 26,27,27, 17,18, 17,19]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_L"
            property int btn_keycode: 0x4c//Qt.Key_L  /*0x4c*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 1016
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 19
            property variant trn_index:[19,10,11, 19,28,29, 19,20, 18,20]
            property variant trn_index2:[19,10,11, 19,28,29, 19,20, 18,20]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_shift'
            property string btn_text: ""
            property int btn_keycode: 0x01000020//Qt.Key_Shift  /*0x01000020*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 0
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 20
            property variant trn_index:[10,11,12, 28,29,20, 19,21, 19,21]
            property variant trn_index2:[10,11,12, 28,29,30, 19,21, 19,21]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_Z"
            property int btn_keycode: 0x5a//Qt.Key_Z /*0x5a*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 127
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 21
            property variant trn_index:[11,12,13, 29,21,31, 20,22, 20,22]
            property variant trn_index2:[11,12,13, 29,30,21, 20,22, 20,22]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_X"
            property int btn_keycode: 0x58//Qt.Key_X /*0x58*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 254
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 22
            property variant trn_index:[12,13,14, 22,31,32, 21,23, 21,23]
            property variant trn_index2:[12,13,14, 30,22,32, 21,23, 21,23]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_C"
            property int btn_keycode: 0x43 /*Qt.Key_C*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 381
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 23
            property variant trn_index:[13,14,15, 31,32,32, 22,24, 22,24]
            property variant trn_index2:[13,14,15, 23,32,32, 22,24, 22,24]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_V"
            property int btn_keycode:0x56//Qt.Key_V /*0x56*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 508
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 24
            property variant trn_index:[14,15,16, 32,32,32, 23,25, 23,25]
            property variant trn_index2:[14,15,16, 32,32,32, 23,25, 23,25]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_B"
            property int btn_keycode: 0x42//Qt.Key_B /*0x42*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 635
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 25
            property variant trn_index:[15,16,17, 32,32,33, 24,26, 24,26]
            property variant trn_index2:[15,16,17, 32,32,33, 24,26, 24,26]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_N"
            property int btn_keycode: 0x4e//Qt.Key_N /*0x4e*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 762
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 26
            property variant trn_index:[16,17,18, 32,33,34, 25,27, 25,27]
            property variant trn_index2:[16,17,18, 32,33,34, 25,27, 25,27]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'
            property string btn_text: "STR_KEYPAD_TYPE_M"
            property int btn_keycode:0x4d//Qt.Key_M /*0x4d*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 889
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 27
            property variant trn_index:[17,18,27, 33,34,35, 26,27, 26,28]
            property variant trn_index2:[17,18,27, 33,34,35, 26,27, 26,28]
            property int btn_width: 247
            property int btn_height: 86
            property string btn_suffix: 'me_type_02_del'
            property string btn_text: "STR_KEYPAD_TYPE_DELETE"
            property int btn_keycode: 0x01000061//Qt.Key_Back /*0x01000061*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 42
            property int btnXpos: 1016
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 28
            property variant trn_index:[28,19,20, 28,28,28, 28,29, 27,29]
            property variant trn_index2:[28,19,20, 28,28,28, 28,29, 27,29]
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
            property variant trn_index:[19,20,21, 29,29,29, 28,31, 28,31]
            property variant trn_index2:[19,20,21, 29,29,29, 28,30, 28,30]
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
            property variant trn_index:[30,30,30, 30,30,30, 30,30, 30,30]
            property variant trn_index2:[20,21,22, 30,30,30, 29,32, 29,32]
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
            property variant trn_index:[21,22,23, 31,31,31, 29,32, 29,32]
            property variant trn_index2:[31,31,31, 31,31,31, 31,31, 31,31]
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
            property variant trn_index:[23,24,25, 32,32,32, 31,33, 31,33]
            property variant trn_index2:[23,24,25, 32,32,32, 30,33, 30,33]
            property int btn_width: 374
            property int btn_height: 86
            property string btn_suffix: 'kor_space'
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
            property variant trn_index:[25,26,27, 33,33,33, 32,34, 32,34]
            property variant trn_index2:[25,26,27, 33,33,33, 32,34, 32,34]
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
            property variant trn_index:[26,27,27, 34,34,34, 33,35, 33,35]
            property variant trn_index2:[26,27,27, 34,34,34, 33,35, 33,35]
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
            property variant trn_index:[27,27,35, 35,35,35, 34,35, 34,0]
            property variant trn_index2:[27,27,35, 35,35,35, 34,35, 34,0]
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
