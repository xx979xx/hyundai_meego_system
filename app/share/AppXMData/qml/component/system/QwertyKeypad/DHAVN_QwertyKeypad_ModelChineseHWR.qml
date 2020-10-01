import QtQuick 1.0

Item
{
    id: chinese_handwriting_keypad_model
    property int btn_count: 30
    property list<ListElement> keypad:[

        ListElement
        {
            property list<ListElement> line: [
                ListElement
                {
                     property int btn_id: 0
                     property variant trn_index:[0,0,0, 0,10,11, 0,1]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "A00"
                     property int btn_keycode: 0x51//Qt.Key_Q  /*0x51*/
                     property int btn_pad: 575
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 1
                     property variant trn_index:[1,1,1, 10,11,12, 0,2]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "A01"
                     property int btn_keycode: 0x57//Qt.Key_W /*0x57*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 2
                     property variant trn_index:[2,2,2, 11,12,13, 1,3]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "A02"
                     property int btn_keycode: 0x45//Qt.Key_E /*0x45*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 3
                     property variant trn_index:[3,3,3, 12,13,14, 2,4]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "A03"
                     property int btn_keycode: 0x52//Qt.Key_R /*0x52*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 4
                     property variant trn_index:[4,4,4, 13,14,15, 3,5]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "A04"
                     property int btn_keycode: 0x54//Qt.Key_T /*0x54*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 5
                     property variant trn_index:[4,4,4, 13,14,15, 3,5]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "A05"
                     property int btn_keycode: 0x54//Qt.Key_T /*0x54*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                }
            ]
        },
        ListElement
        {
            property list<ListElement> line: [
                ListElement
                {
                     property int btn_id: 6
                     property variant trn_index:[5,5,5, 14,15,16, 4,6]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "B00"
                     property int btn_keycode: 0x59//Qt.Key_Y
                     property int btn_pad: 575
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 7
                     property variant trn_index:[6,6,6, 15,16,17, 5,7]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "B01"
                     property int btn_keycode: 0x55//Qt.Key_U
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 8
                     property variant trn_index:[7,7,7, 16,17,18, 6,8]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "B02"
                     property int btn_keycode: 0x49//Qt.Key_I
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 9
                     property variant trn_index:[8,8,8, 17,18,18, 7,9]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "B03"
                     property int btn_keycode: 0x4f//Qt.Key_O
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 10
                     property variant trn_index:[9,9,9, 18,18,9, 8,9]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "B04"
                     property int btn_keycode: 0x50//Qt.Key_P
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 11
                     property variant trn_index:[9,9,9, 18,18,9, 8,9]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "B05"
                     property int btn_keycode: 0x50//Qt.Key_P
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                }
            ]
        },
        ListElement
        {
            property list<ListElement> line: [
                 ListElement
                {
                     property int btn_id: 12
                     property variant trn_index:[10,0,1, 10,19,20, 10,11]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "C00"
                     property int btn_keycode: 0x41//Qt.Key_A
                     property int btn_pad: 575
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 13
                     property variant trn_index:[0,1,2, 19,20,21, 10,12]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "C01"
                     property int btn_keycode: 0x53//Qt.Key_S
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 14
                     property variant trn_index:[1,2,3, 20,21,22, 11,13]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "C02"
                     property int btn_keycode: 0x44//Qt.Key_D
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 15
                     property variant trn_index:[2,3,4, 21,22,23, 12,14]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "C03"
                     property int btn_keycode: 0x46//Qt.Key_F
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 16
                     property variant trn_index:[3,4,5, 22,23,24, 13,15]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "C04"
                     property int btn_keycode: 0x47//Qt.Key_G
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 17
                     property variant trn_index:[3,4,5, 22,23,24, 13,15]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "C05"
                     property int btn_keycode: 0x47//Qt.Key_G
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                }
            ]
        },
        ListElement
        {
            property list<ListElement> line: [
                ListElement
                {
                     property int btn_id: 18
                     property variant trn_index:[3,4,5, 22,23,24, 13,15]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'
                     property string btn_text: "D00"
                     property int btn_keycode: 0x47//Qt.Key_G
                     property int btn_pad: 575
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 19
                     property variant trn_index:[10,0,1, 10,19,20, 10,11]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'chn_left'
                     property string btn_text: ""
                     property int btn_keycode: 0x41//Qt.Key_A
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 20
                     property variant trn_index:[0,1,2, 19,20,21, 10,12]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'chn_right'
                     property string btn_text: ""
                     property int btn_keycode: 0x53//Qt.Key_S
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 21
                     property variant trn_index:[1,2,3, 20,21,22, 11,13]
                     property int btn_width: 338
                     property int btn_height: 86
                     property string btn_suffix: 'chn_del'
                     property string btn_text: ""
                     property int btn_keycode: 0x01000061//Qt.Key_Back
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                }
            ]
        },
        ListElement
        {
            property list<ListElement> line: [
                ListElement
                {
                     property int btn_id: 22
                     property variant trn_index:[28,19,20, 28,28,28, 28,29]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_pad'
                     property string btn_text: ""
                     property int btn_keycode: Qt.Key_Launch0
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 23
                     property variant trn_index:[19,20,21, 29,29,29, 28,30]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_etc'          // 123@
                     property string btn_text: "Launch1"
                     property int btn_keycode: Qt.Key_Launch1
                     property int btn_pad: 0
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 24
                     property variant trn_index:[20,21,22, 30,30,30, 29,31]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_etc'          // Chinese
                     property string btn_text: "Launch2"
                     property int btn_keycode: Qt.Key_Launch2
                     property int btn_pad: 0
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 25
                     property variant trn_index:[21,22,23, 31,31,31, 30,32]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_etc'          // ABC
                     property string btn_text: "Launch3"
                     property int btn_keycode: Qt.Key_Launch3
                     property int btn_pad: 0
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 26
                     property variant trn_index:[22,23,24, 32,32,32, 31,33]
                     property int btn_width: 453
                     property int btn_height: 86
                     property string btn_suffix: 'chn_space'
                     property string btn_text: " "
                     property int btn_keycode: 0x20//Qt.Key_Space
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 27
                     property variant trn_index:[24,25,26, 33,33,33, 32,34]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_character'      // 'comma'            // .@/
                     property string btn_text: ".-@"
                     property int btn_keycode: Qt.Key_Launch4
                     property int btn_pad: 0
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 28
                     property variant trn_index:[25,26,27, 34,34,34, 33,35]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_set'
                     property string btn_text: ""
                     property int btn_keycode: Qt.Key_Launch5
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 29
                     property variant trn_index:[26,27,35, 35,35,35, 34,35]
                     property int btn_width: 108
                     property int btn_height: 86
                     property string btn_suffix: 'eu_la_done'
                     property string btn_text: "Completion"
                     property int btn_keycode: 0x01000010//Qt.Key_Home
                     property int btn_pad: 0
                     property int btn_fontSize: 36
                }
            ]
        }
    ]
}
