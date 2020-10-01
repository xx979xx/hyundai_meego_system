import QtQuick 1.0

Item
{
    id: european_azerty_keypad_model
    property int btn_count: 37
    property list<ListElement> keypad:[

        ListElement
        {
            property list<ListElement> line: [
                ListElement
                {
                     property int btn_id: 0
                     property variant trn_index:[0,0,0, 0,10,11, 0,1, 0,1]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A00"
                     property int btn_keycode: 0x51//Qt.Key_Q  /*0x51*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 1
                     property variant trn_index:[1,1,1, 10,11,12, 0,2, 0,2]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A01"
                     property int btn_keycode: 0x57//Qt.Key_W /*0x57*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 2
                     property variant trn_index:[2,2,2, 11,12,13, 1,3, 1,3]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A02"
                     property int btn_keycode: 0x45//Qt.Key_E /*0x45*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 3
                     property variant trn_index:[3,3,3, 12,13,14, 2,4, 2,4]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A03"
                     property int btn_keycode: 0x52//Qt.Key_R /*0x52*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 4
                     property variant trn_index:[4,4,4, 13,14,15, 3,5, 3,5]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A04"
                     property int btn_keycode: 0x54//Qt.Key_T /*0x54*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 5
                     property variant trn_index:[5,5,5, 14,15,16, 4,6, 4,6]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A05"
                     property int btn_keycode: 0x59//Qt.Key_Y /*0x59*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 6
                     property variant trn_index:[6,6,6, 15,16,17, 5,7, 5,7]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A06"
                     property int btn_keycode: 0x55//Qt.Key_U  /*0x55*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 7
                     property variant trn_index:[7,7,7, 16,17,18, 6,8, 6,8]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A07"
                     property int btn_keycode: 0x49//Qt.Key_I /*0x49*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 8
                     property variant trn_index:[8,8,8, 17,18,8, 7,9, 7,9]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A08"
                     property int btn_keycode: 0x4f//Qt.Key_O /*0x4f*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 9
                     property variant trn_index:[9,9,9, 18,18,9, 8,9, 8,10]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A09"
                     property int btn_keycode: 0x50//Qt.Key_P /*0x50*/
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
                     property int btn_id: 10
                     property variant trn_index:[10,0,1, 10,19,20, 10,11, 9,11]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B00"
                     property int btn_keycode: 0x41//Qt.Key_A /*0x41*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 11
                     property variant trn_index:[0,1,2, 19,20,21, 10,12, 10,12]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B01"
                     property int btn_keycode: 0x53//Qt.Key_S /*0x53*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 12
                     property variant trn_index:[1,2,3, 20,21,22, 11,13, 11,13]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B02"
                     property int btn_keycode: 0x44//Qt.Key_D /*0x44*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 13
                     property variant trn_index:[2,3,4, 21,22,23, 12,14, 12,14]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B03"
                     property int btn_keycode: 0x46//Qt.Key_F /*0x46 */
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 14
                     property variant trn_index:[3,4,5, 22,23,24, 13,15, 13,15]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B04"
                     property int btn_keycode: 0x47//Qt.Key_G /*0x47*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 15
                     property variant trn_index:[4,5,6, 23,24,25, 14,16, 14,16]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B05"
                     property int btn_keycode:0x48//Qt.Key_H /*0x48*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 16
                     property variant trn_index:[5,6,7, 24,25,26, 15,17, 15,17]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B06"
                     property int btn_keycode: 0x4a//Qt.Key_J /*0x4a*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 17
                     property variant trn_index:[6,7,8, 25,26,27, 16,18, 16,18]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B07"
                     property int btn_keycode: 0x4b//Qt.Key_K /*0x4b*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 18
                     property variant trn_index:[7,8,9, 26,27,18, 17,18, 17,19]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B08"
                     property int btn_keycode: 0x4c//Qt.Key_L  /*0x4c*/
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
                     property int btn_id: 19
                     property variant trn_index:[19,10,11, 19,28,29, 19,20, 19,20]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_shift' //const_BTN_SHIFT_L_SUFFIX
                     property string btn_text: ""
                     property int btn_keycode: 0x01000020//Qt.Key_Shift  /*0x01000020*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 20
                     property variant trn_index:[10,11,12, 28,29,20, 19,21, 19,21]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C00"
                     property int btn_keycode: 0x58//Qt.Key_X /*0x58*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 21
                     property variant trn_index:[11,12,13, 29,21,31, 20,22, 20,22]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C01"
                     property int btn_keycode: 0x43 /*Qt.Key_C*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 22
                     property variant trn_index:[12,13,14, 22,31,32, 21,23, 21,23]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C02"
                     property int btn_keycode:0x56//Qt.Key_V /*0x56*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 23
                     property variant trn_index:[13,14,15, 31,32,33, 22,24, 22,24]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C03"
                     property int btn_keycode: 0x42//Qt.Key_B /*0x42*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 24
                     property variant trn_index:[14,15,16, 32,33,33, 23,25, 23,25]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C04"
                     property int btn_keycode: 0x4e//Qt.Key_N /*0x4e*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 25
                     property variant trn_index:[15,16,17, 33,33,34, 24,26, 24,26]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C05"
                     property int btn_keycode:0x4d//Qt.Key_M //0x4d
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 26
                     property variant trn_index:[16,17,18, 33,34,35, 25,27, 25,27]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C06"
                     property int btn_keycode:0x4d//Qt.Key_M //0x4d
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 27
                     property variant trn_index:[17,18,27, 34,35,36, 26,27, 26,28]
                     property int btn_width: 247
                     property int btn_height: 87
                     property string btn_suffix: 'kor_del'
                     property string btn_text: ""
                     property int btn_keycode: 0x01000061//Qt.Key_Back /*0x01000061*/
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
                     property int btn_id: 28
                     property variant trn_index:[28,19,20, 28,28,28, 28,29, 27,29]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_pad'
                     property string btn_text: ""
                     property int btn_keycode: Qt.Key_Launch0
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 29
                     property variant trn_index:[19,20,21, 29,29,29, 28,31, 28,31]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_etc'          // 123@
                     property string btn_text: "Launch1"
                     property int btn_keycode: Qt.Key_Launch1
                     property int btn_pad: 0
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 30
                     property variant trn_index:[30,30,30, 30,30,30, 30,30, 30,30]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_etc'          // change lang
                     property string btn_text: "Launch2"
                     property int btn_keycode: Qt.Key_Launch2
                     property int btn_pad: 0
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 31
                     property variant trn_index:[21,22,23, 31,31,31, 29,32, 29,32]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_etc'          // 123@
                     property string btn_text: "Launch3"
                     property int btn_keycode: Qt.Key_Launch3
                     property int btn_pad: 0
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 32
                     property variant trn_index:[22,23,24, 32,32,32, 31,33, 31,33]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_etc'          // change lang
                     property string btn_text: "Launch6"
                     property int btn_keycode: Qt.Key_Launch6
                     property int btn_pad: 0
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 33
                     property variant trn_index:[23,24,25, 33,33,33, 32,34, 32,34]
                     property int btn_width: 247
                     property int btn_height: 87
                     property string btn_suffix: 'eu_space'    //'space'
                     property string btn_text: " "
                     property int btn_keycode: 0x20//Qt.Key_Space /*0x20*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 34
                     property variant trn_index:[25,26,27, 34,34,34, 33,35, 33,35]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'      // 'comma'            // .@/
                     property string btn_text: ".-@"
                     property int btn_keycode: Qt.Key_Launch4
                     property int btn_pad: 0
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 35
                     property variant trn_index:[26,27,27, 35,35,35, 34,36, 34,36]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_set'
                     property string btn_text: ""
                     property int btn_keycode: Qt.Key_Launch5
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 36
                     property variant trn_index:[27,27,36, 36,36,36, 35,36, 35,36]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_done'
                     property string btn_text: "Completion"
                     property int btn_keycode: 0x01000010//Qt.Key_Home  /*0x01000010*/
                     property int btn_pad: 0
                     property int btn_fontSize: 40
                }
            ]
        }
    ]
}
