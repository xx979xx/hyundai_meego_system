import QtQuick 1.0

Item{
    id: chinese_handwriting_keypad_model
    property int btn_count: 27
    property list<ListElement> keypad:[
        ListElement{
            property int btn_id: 0
            property variant trn_index:[0,0,0, 0,5,6, 0,1, 26,1]
            property int btn_width: 111
            property int btn_height: 88
            property string btn_suffix: 'chn_charater_01'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 0
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 1
            property variant trn_index:[1,1,1, 5,6,7, 0,2, 0,2]
            property int btn_width: 112
            property int btn_height: 88
            property string btn_suffix: 'chn_charater_02'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 111
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 2
            property variant trn_index:[2,2,2, 6,7,8, 1,3, 1,3]
            property int btn_width: 112
            property int btn_height: 88
            property string btn_suffix: 'chn_charater_02'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 223
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 3
            property variant trn_index:[3,3,3, 7,8,9, 2,4, 2,4]
            property int btn_width: 112
            property int btn_height: 88
            property string btn_suffix: 'chn_charater_02'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 335
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 4
            property variant trn_index:[4,4,4, 8,9,4, 3,4, 3,5]
            property int btn_width: 111
            property int btn_height: 88
            property string btn_suffix: 'chn_charater_03'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 447
            property int btnYpos: 0
        },
        ListElement{
            property int btn_id: 5
            property variant trn_index:[5,0,1, 5,10,11, 5,6, 4,6]
            property int btn_width: 111
            property int btn_height: 89
            property string btn_suffix: 'chn_charater_04'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 0
            property int btnYpos: 88
        },
        ListElement{
            property int btn_id: 6
            property variant trn_index:[0,1,2, 10,11,12, 5,7, 5,7]
            property int btn_width: 112
            property int btn_height: 89
            property string btn_suffix: 'chn_charater_05'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 111
            property int btnYpos: 88
        },
        ListElement{
            property int btn_id: 7
            property variant trn_index:[1,2,3, 11,12,13, 6,8, 6,8]
            property int btn_width: 112
            property int btn_height: 89
            property string btn_suffix: 'chn_charater_05'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 223
            property int btnYpos: 88
        },
        ListElement{
            property int btn_id: 8
            property variant trn_index:[2,3,4, 12,13,14, 7,9, 7,9]
            property int btn_width: 112
            property int btn_height: 89
            property string btn_suffix: 'chn_charater_05'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 335
            property int btnYpos: 88
        },
        ListElement{
            property int btn_id: 9
            property variant trn_index:[3,4,9, 13,14,9, 8,9, 8,10]
            property int btn_width: 111
            property int btn_height: 89
            property string btn_suffix: 'chn_charater_06'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 447
            property int btnYpos: 88
        },
        ListElement{
            property int btn_id: 10
            property variant trn_index:[10,5,6, 10,15,16, 10,11, 9,11]
            property int btn_width: 111
            property int btn_height: 89
            property string btn_suffix: 'chn_charater_04'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 0
            property int btnYpos: 177
        },
        ListElement{
            property int btn_id: 11
            property variant trn_index:[5,6,7, 15,16,17, 10,12, 10,12]
            property int btn_width: 112
            property int btn_height: 89
            property string btn_suffix: 'chn_charater_05'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 111
            property int btnYpos: 177
        },
        ListElement{
            property int btn_id: 12
            property variant trn_index:[6,7,8, 16,17,18, 11,13, 11,13]
            property int btn_width: 112
            property int btn_height: 89
            property string btn_suffix: 'chn_charater_05'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 223
            property int btnYpos: 177
        },
        ListElement{
            property int btn_id: 13
            property variant trn_index:[7,8,9, 17,18,19, 12,14, 12,14]
            property int btn_width: 112
            property int btn_height: 89
            property string btn_suffix: 'chn_charater_05'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 335
            property int btnYpos: 177
        },
        ListElement{
            property int btn_id: 14
            property variant trn_index:[8,9,14, 18,19,14, 13,14, 13,15]
            property int btn_width: 111
            property int btn_height: 89
            property string btn_suffix: 'chn_charater_06'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 447
            property int btnYpos: 177
        },
        ListElement{
            property int btn_id: 15
            property variant trn_index:[15,10,11, 15,20,20, 15,16, 14,16]
            property int btn_width: 111
            property int btn_height: 88
            property string btn_suffix: 'chn_charater_07'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 0
            property int btnYpos: 266
        },
        ListElement{
            property int btn_id: 16
            property variant trn_index:[10,11,12, 20,20,21, 15,17, 15,17]
            property int btn_width: 112
            property int btn_height: 88
            property string btn_suffix: 'chn_charater_08'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 111
            property int btnYpos: 266
        },
        ListElement{
            property int btn_id: 17
            property variant trn_index:[11,12,13, 20,21,21, 16,18, 16,18]
            property int btn_width: 112
            property int btn_height: 88
            property string btn_suffix: 'chn_charater_08'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 223
            property int btnYpos: 266
        },
        ListElement{
            property int btn_id: 18
            property variant trn_index:[12,13,14, 21,21,22, 17,19, 17,19]
            property int btn_width: 112
            property int btn_height: 88
            property string btn_suffix: 'chn_charater_08'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 335
            property int btnYpos: 266
        },
        ListElement{
            property int btn_id: 19
            property variant trn_index:[13,14,19, 21,22,19, 18,19, 18,20]
            property int btn_width: 111
            property int btn_height: 88
            property string btn_suffix: 'chn_charater_09'
            property string btn_text: ""
            property int btn_keycode: 0x41
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 447
            property int btnYpos: 266
        },
        ListElement{
            property int btn_id: 20
            property variant trn_index:[20,15,16, 20,23,24, 20,21, 19,21]
            property int btn_width: 222
            property int btn_height: 87
            property string btn_suffix: 'chn_left'
            property string btn_text: ""
            property int btn_keycode: 0x50//Qt.Key_P
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 0
            property int btnYpos: 356
        },
        ListElement{
            property int btn_id: 21
            property variant trn_index:[16,17,19, 23,24,26, 20,22, 20,22]
            property int btn_width: 222
            property int btn_height: 87
            property string btn_suffix: 'chn_right'
            property string btn_text: ""
            property int btn_keycode: 0x50//Qt.Key_P
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 45
            property int btnXpos: 224
            property int btnYpos: 356
        },
        ListElement{
            property int btn_id: 22
            property variant trn_index:[18,19,22, 25,26,22, 21,22, 21,23]
            property int btn_width: 110
            property int btn_height: 87
            property string btn_suffix: 'chn_del'
            property string btn_text: ""
            property int btn_keycode: 0x01000061//Qt.Key_Back
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 448
            property int btnYpos: 356
        },
        ListElement{
            property int btn_id: 23
            property variant trn_index:[23,20,21, 23,23,23, 23,24, 22,24]
            property int btn_width: 222
            property int btn_height: 87
            property string btn_suffix: 'chn_space'
            property string btn_text: " "
            property int btn_keycode: 0x20//Qt.Key_Space
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 0
            property int btnYpos: 445
        },
        ListElement{
            property int btn_id: 24
            property variant trn_index:[20,21,21, 24,24,24, 23,25, 23,25]
            property int btn_width: 110
            property int btn_height: 87
            property string btn_suffix: 'chn_etc'
            property string btn_text: "STR_KEYPAD_TYPE_LAUNCH9"
            property int btn_keycode: Qt.Key_Launch9   // chinese keypad popup
            property int btn_fontSize: 22
            property bool btn_Enabled: true
            property int textOffSet: 42
            property int btnXpos: 224
            property int btnYpos: 445
        },
        ListElement{
            property int btn_id: 25
            property variant trn_index:[21,21,22, 25,25,25, 24,26, 24,26]
            property int btn_width: 110
            property int btn_height: 87
            property string btn_suffix: 'chn_set'
            property string btn_text: ""
            property int btn_keycode: Qt.Key_Launch5
            property int btn_fontSize: 50
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 336
            property int btnYpos: 445
        },
        ListElement{
            property int btn_id: 26
            property variant trn_index:[18,22,26, 26,26,26, 25,26, 25,0]
            property int btn_width: 110
            property int btn_height: 87
            property string btn_suffix: 'chn_done_02'
            property string btn_text: ""
            property int btn_keycode: 0x01000010//Qt.Key_Home
            property int btn_fontSize: 36
            property bool btn_Enabled: true
            property int textOffSet: 0
            property int btnXpos: 448
            property int btnYpos: 445
        }
    ]
}
