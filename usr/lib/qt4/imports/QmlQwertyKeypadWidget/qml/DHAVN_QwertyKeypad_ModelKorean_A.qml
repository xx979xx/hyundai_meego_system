import QtQuick 1.0

Item{
    id: korean_abcd_keypad_model
    property int btn_count: 42
    property list<ListElement> keypad:[
        ListElement{
            property int btn_id: 0
            property variant trn_index:[0,0,0, 0,13,14, 0,1, 41,1]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A00"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 0
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 1
            property variant trn_index:[1,1,1, 13,14,15, 0,2, 0,2]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A01"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 97
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 2
            property variant trn_index:[2,2,2, 14,15,16, 1,3, 1,3]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A02"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 194
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 3
            property variant trn_index:[3,3,3, 15,16,17, 2,4, 2,4]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A03"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 291
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 4
            property variant trn_index:[4,4,4, 16,17,18, 3,5, 3,5]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A04"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 388
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 5
            property variant trn_index:[5,5,5, 17,18,19, 4,6, 4,6]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A05"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 485
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 6
            property variant trn_index:[6,6,6, 18,19,20, 5,7, 5,7]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A06"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 582
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 7
            property variant trn_index:[7,7,7, 19,20,21, 6,8, 6,8]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A07"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 689
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 8
            property variant trn_index:[8,8,8, 20,21,22, 7,9, 7,9]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A08"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 786
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 9
            property variant trn_index:[9,9,9, 21,22,23, 8,10, 8,10]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A09"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 883
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 10
            property variant trn_index:[10,10,10, 22,23,23, 9,11, 9,11]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A10"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 980
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 11
            property variant trn_index:[11,11,11, 23,23,11, 10,12, 10,12]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A11"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 1077
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 12
            property variant trn_index:[12,12,12, 23,23,12, 11,12, 11,13]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_A12"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 1174
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 13
            property variant trn_index:[13,0,1, 13,24,25, 13,14, 12,14]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B00"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 0
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 14
            property variant trn_index:[0,1,2, 24,25,26, 13,15, 13,15]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B01"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 97
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 15
            property variant trn_index:[1,2,3, 25,26,27, 14,16, 14,16]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B02"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 194
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 16
            property variant trn_index:[2,3,4, 26,27,28, 15,17, 15,17]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B03"
            property int btn_keycode:0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 291
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 17
            property variant trn_index:[3,4,5, 27,28,28, 16,18, 16,18]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B04"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 388
            property int btnYpos: 96

        },
        ListElement{
            property int btn_id: 18
            property variant trn_index:[4,5,6, 28,28,29, 17,19, 17,19]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B05"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 485
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 19
            property variant trn_index:[5,6,7, 28,28,29, 18,20, 18,20]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B06"
            property int btn_keycode:0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 582
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 20
            property variant trn_index:[6,7,8, 37,29,30, 19,21, 19,21]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B07"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 689
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 21
            property variant trn_index:[7,8,9, 29,30,31, 20,22, 20,22]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B08"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 786
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 22
            property variant trn_index:[8,9,10, 30,31,32, 21,23, 21,23]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B09"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 883
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 23
            property variant trn_index:[9,10,11, 31,32,33, 22,23, 22,24]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_B10"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 980
            property int btnYpos: 96
        },
        ListElement{
            property int btn_id: 24
            property variant trn_index:[24,13,14, 24,34,35, 24,25, 23,25]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_C00"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 0
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 25
            property variant trn_index:[13,14,15, 34,35,35, 24,26, 24,26]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_C01"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 97
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 26
            property variant trn_index:[14,15,16, 35,35,26, 25,27, 25,27]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_C02"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 194
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 27
            property variant trn_index:[15,16,17, 35,27,27, 26,28, 26,28]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_C03"
            property int btn_keycode:0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 291
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 28
            property variant trn_index:[16,17,18, 28,28,37, 27,29, 27,29]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_C04"
            property int btn_keycode:0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 388
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 29
            property variant trn_index:[19,20,21, 37,38,38, 28,30, 28,30]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_C05"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 689
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 30
            property variant trn_index:[20,21,22, 38,38,39, 29,31, 29,31]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_C06"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 786
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 31
            property variant trn_index:[21,22,23, 38,39,40, 30,32, 30,32]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_C07"
            property int btn_keycode:0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 883
            property int btnYpos: 192

        },
        ListElement{
            property int btn_id: 32
            property variant trn_index:[22,23,32, 39,40,41, 31,33, 31,33]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'
            property string btn_text: "STR_KEYPAD_TYPE_C08"
            property int btn_keycode: 0x50 //dummy
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 980
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 33
            property variant trn_index:[23,23,33, 40,41,33, 32,33, 32,34]
            property int btn_width: 187
            property int btn_height: 86
            property string btn_suffix: 'kor3_del'
            property string btn_text: ""
            property int btn_keycode: 0x01000061//Qt.Key_Back /*0x01000061*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 1077
            property int btnYpos: 192
        },
        ListElement{
            property int btn_id: 34
            property variant trn_index:[34,24,25, 34,34,34, 34,35, 33,35]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_pad'
            property string btn_text: ""
            property int btn_keycode: Qt.Key_Launch0
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 0
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 35
            property variant trn_index:[24,25,26, 35,35,35, 34,37, 34,37]
            property int btn_width: 187
            property int btn_height: 86
            property string btn_suffix: 'kor3_etc_02'          // 123#
            property string btn_text: "Launch1"
            property int btn_keycode: Qt.Key_Launch1
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 43
            property int btnXpos: 97
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 36
            property variant trn_index:[36,36,36, 36,36,36, 36,36, 36,36]
            property int btn_width: 187
            property int btn_height: 86
            property string btn_suffix: 'kor3_etc_02'          // change lang
            property string btn_text: "Launch2"
            property int btn_keycode: Qt.Key_Launch2
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 43
            property int btnXpos: 291
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 37
            property variant trn_index:[28,28,37, 37,37,37, 35,38, 35,38]
            property int btn_width: 187
            property int btn_height: 86
            property string btn_suffix: 'kor3_etc_02'    // ABC
            property string btn_text: "Launch3"
            property int btn_keycode: Qt.Key_Launch3
            property int btn_fontSize: 40
            property bool btn_Enabled: true
            property int textOffSet: 43
            property int btnXpos: 485
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 38
            property variant trn_index:[28,29,30, 38,38,38, 37,39, 37,39]
            property int btn_width: 187
            property int btn_height: 86
            property string btn_suffix: 'kor3_space'    //'space'
            property string btn_text: " "
            property int btn_keycode: 0x20//Qt.Key_Space /*0x20*/
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 689
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 39
            property variant trn_index:[30,31,32, 39,39,39, 38,40, 38,40]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_character'      // 'comma'            // .-@
            property string btn_text: ".-@"
            property int btn_keycode: Qt.Key_Launch4
            property int btn_fontSize: 45
            property bool btn_Enabled: true
            property int textOffSet: 41
            property int btnXpos: 883
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 40
            property variant trn_index:[31,32,33, 40,40,40, 39,41, 39,41]
            property int btn_width: 90
            property int btn_height: 86
            property string btn_suffix: 'kor3_set'
            property string btn_text: ""
            property int btn_keycode: Qt.Key_Launch5
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 980
            property int btnYpos: 288
        },
        ListElement{
            property int btn_id: 41
            property variant trn_index:[32,33,41, 41,41,41, 40,41, 40,0]
            property int btn_width: 187
            property int btn_height: 86
            property string btn_suffix: 'kor3_done'
            property string btn_text: ""
            property int btn_keycode: 0x01000010//Qt.Key_Home  /*0x01000010*/
            property int btn_fontSize: 36
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 1077
            property int btnYpos: 288
        }
    ]
}
