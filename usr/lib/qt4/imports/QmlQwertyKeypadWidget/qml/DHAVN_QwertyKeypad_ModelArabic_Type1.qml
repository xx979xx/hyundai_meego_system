import QtQuick 1.0

Item{
    id: arabic_type1_keypad_model
    property int btn_count: 37

    property list<ListElement> keypad:[
        ListElement{
            property int btn_id: 0
            property variant trn_index:[0,0,0, 0,10,11, 0,1, 39,1]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_A00"
            property int btn_keycode: 0x51//Qt.Key_Q  /*0x51*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 0
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 1
            property variant trn_index:[1,1,1, 10,11,12, 0,2, 0,2]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_A01"
            property int btn_keycode: 0x57//Qt.Key_W /*0x57*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 127
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 2
            property variant trn_index:[2,2,2, 11,12,13, 1,3, 1,3]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_A02"
            property int btn_keycode: 0x45//Qt.Key_E /*0x45*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 254
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 3
            property variant trn_index:[3,3,3, 12,13,14, 2,4, 2,4]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_A03"
            property int btn_keycode: 0x52//Qt.Key_R /*0x52*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 381
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 4
            property variant trn_index:[4,4,4, 13,14,15, 3,5, 3,5]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_A04"
            property int btn_keycode: 0x54//Qt.Key_T /*0x54*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 508
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 5
            property variant trn_index:[5,5,5, 14,15,16, 4,6, 4,6]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_A05"
            property int btn_keycode: 0x59//Qt.Key_Y /*0x59*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 635
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 6
            property variant trn_index:[6,6,6, 15,16,17, 5,7, 5,7]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_A06"
            property int btn_keycode: 0x55//Qt.Key_U  /*0x55*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 762
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 7
            property variant trn_index:[7,7,7, 16,17,18, 6,8, 6,8]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_A07"
            property int btn_keycode: 0x49//Qt.Key_I /*0x49*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 889
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 8
            property variant trn_index:[8,8,8, 17,18,19, 7,9, 7,9]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_A08"
            property int btn_keycode: 0x4f//Qt.Key_O /*0x4f*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 1016
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 9
            property variant trn_index:[9,9,9, 18,19,9, 8,9, 8,10]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_A09"
            property int btn_keycode: 0x50//Qt.Key_P /*0x50*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 1143
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 10
            property variant trn_index:[10,0,1, 10,20,21, 10,11, 9,11]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_B00"
            property int btn_keycode: 0x41//Qt.Key_A /*0x41*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 0
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 11
            property variant trn_index:[0,1,2, 20,21,22, 10,12, 10,12]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_B01"
            property int btn_keycode: 0x53//Qt.Key_S /*0x53*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 127
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 12
            property variant trn_index:[1,2,3, 21,22,23, 11,13, 11,13]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_B02"
            property int btn_keycode: 0x44//Qt.Key_D /*0x44*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 254
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 13
            property variant trn_index:[2,3,4, 22,23,24, 12,14, 12,14]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_B03"
            property int btn_keycode: 0x46//Qt.Key_F /*0x46 */
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 381
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 14
            property variant trn_index:[3,4,5, 23,24,25, 13,15, 13,15]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_B04"
            property int btn_keycode: 0x47//Qt.Key_G /*0x47*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 508
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 15
            property variant trn_index:[4,5,6, 24,25,26, 14,16, 14,16]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_B05"
            property int btn_keycode:0x48//Qt.Key_H /*0x48*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 635
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 16
            property variant trn_index:[5,6,7, 25,26,27, 15,17, 15,17]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_B06"
            property int btn_keycode: 0x4a//Qt.Key_J /*0x4a*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 762
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 17
            property variant trn_index:[6,7,8, 26,27,28, 16,18, 16,18]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_B07"
            property int btn_keycode: 0x4b//Qt.Key_K /*0x4b*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 889
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 18
            property variant trn_index:[7,8,9, 27,28,29, 17,19, 17,19]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_B08"
            property int btn_keycode: 0x4c//Qt.Key_L  /*0x4c*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 1016
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 19
            property variant trn_index:[8,9,19, 28,29,19, 18,19, 18,20]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_B09"
            property int btn_keycode: 0x4c//Qt.Key_L  /*0x4c*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 1143
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 20
            property variant trn_index:[20,10,11, 20,30,31, 20,21, 19,21]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_C00"
            property int btn_keycode: 0x4c//Qt.Key_L  /*0x4c*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 0
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 21
            property variant trn_index:[10,11,12, 30,31,32, 20,22, 20,22]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_C01"
            property int btn_keycode: 0x5a//Qt.Key_Z /*0x5a*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 127
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 22
            property variant trn_index:[11,12,13, 31,32,22, 21,23, 21,23]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_C02"
            property int btn_keycode: 0x58//Qt.Key_X /*0x58*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 254
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 23
            property variant trn_index:[12,13,14, 32,23,34, 22,24, 22,24]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_C03"
            property int btn_keycode: 0x43 /*Qt.Key_C*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 381
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 24
            property variant trn_index:[13,14,15, 24,34,35, 23,25, 23,25]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_C04"
            property int btn_keycode:0x56//Qt.Key_V /*0x56*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 508
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 25
            property variant trn_index:[14,15,16, 34,35,36, 24,26, 24,26]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_C05"
            property int btn_keycode: 0x42//Qt.Key_B /*0x42*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 635
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 26
            property variant trn_index:[15,16,17, 35,36,37, 25,27, 25,27]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_C06"
            property int btn_keycode: 0x4e//Qt.Key_N /*0x4e*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 762
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 27
            property variant trn_index:[16,17,18, 36,37,38, 26,28, 26,28]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_C07"
            property int btn_keycode:0x4d//Qt.Key_M /*0x4d*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 889
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 28
            property variant trn_index:[17,18,19, 37,38,39, 27,29, 27,29]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_02_character'
            property string btn_text: "STR_KEYPAD_TYPE_C08"
            property int btn_keycode:0x4d//Qt.Key_M /*0x4d*/
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 40
            property int btnXpos: 1016
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 29
            property variant trn_index:[18,19,29, 38,39,29, 28,29, 28,30]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'me_type_01_del'
            property string btn_text: "STR_KEYPAD_TYPE_DELETE"
            property int btn_keycode: 0x01000061//Qt.Key_Back /*0x01000061*/
            property int btn_fontSize: 33
            property bool btn_Enabled: true
            property int textOffSet: 42
            property int btnXpos: 1143
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 30
            property variant trn_index:[30,20,21, 30,30,30, 30,31, 29,31]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_pad'
            property string btn_text: ""
            property int btn_keycode: Qt.Key_Launch0
            property int btn_fontSize: 0
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 0
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 31
            property variant trn_index:[20,21,22, 31,31,31, 30,32, 30,32]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_etc'          // 123#
            property string btn_text: "Launch1"
            property int btn_keycode: Qt.Key_Launch1
            property int btn_fontSize: 36
            property bool btn_Enabled: true
            property int textOffSet: 43
            property int btnXpos: 127
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 32
            property variant trn_index:[21,22,23, 32,32,32, 31,34, 31,34]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_etc'          // Arabic toggle
            property string btn_text: "STR_KEYPAD_TYPE_D02"
            property int btn_keycode: Qt.Key_LaunchB
            property int btn_fontSize: 36
            property bool btn_Enabled: true
            property int textOffSet: 43
            property int btnXpos: 254
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 33
            property variant trn_index:[33,33,33, 33,33,33, 33,33, 33,33]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_etc'          // Arabic
            property string btn_text: "Launch2"
            property int btn_keycode: Qt.Key_Launch2
            property int btn_fontSize: 36
            property bool btn_Enabled: true
            property int textOffSet: 43
            property int btnXpos: 381
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 34
            property variant trn_index:[23,24,25, 34,34,34, 32,35, 32,35]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_etc'          // ABC
            property string btn_text: "Launch3"
            property int btn_keycode: Qt.Key_Launch3
            property int btn_fontSize: 36
            property bool btn_Enabled: true
            property int textOffSet: 43
            property int btnXpos: 508
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 35
            property variant trn_index:[24,25,26, 35,35,35, 34,36, 34,36]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_etc'          // AAA
            property string btn_text: "Launch6"
            property int btn_keycode: Qt.Key_Launch6
            property int btn_fontSize: 36
            property bool btn_Enabled: true
            property int textOffSet: 43
            property int btnXpos: 635
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 36
            property variant trn_index:[25,26,27, 36,36,36, 35,37, 35,37]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_me_space'    //'space'
            property string btn_text: " "
            property int btn_keycode: 0x20//Qt.Key_Space /*0x20*/
            property int btn_fontSize: 0
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 762
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 37
            property variant trn_index:[26,27,28, 37,37,37, 36,38, 36,38]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_character'      // 'comma'            // .-@
            property string btn_text: ".-@"
            property int btn_keycode: Qt.Key_Launch4
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 42
            property int btnXpos: 889
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 38
            property variant trn_index:[27,28,29, 38,38,38, 37,39, 37,39]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_set'
            property string btn_text: ""
            property int btn_keycode: Qt.Key_Launch5
            property int btn_fontSize: 0
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 1016
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 39
            property variant trn_index:[28,29,39, 39,39,39, 38,39, 38,0]
            property int btn_width: 120
            property int btn_height: 86
            property string btn_suffix: 'kor_done'
            property string btn_text: ""
            property int btn_keycode: 0x01000010//Qt.Key_Home  /*0x01000010*/
            property int btn_fontSize: 0
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 1143
            property int btnYpos: 288
        }
    ]
}
