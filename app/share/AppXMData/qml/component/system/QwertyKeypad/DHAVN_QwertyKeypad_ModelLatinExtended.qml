import QtQuick 1.0


Item
{
    id : latin_extended_keypad_model
    property int btn_count: 38
    property list<ListElement> keypad:[

        ListElement
        {
            property list<ListElement> line: [

                ListElement
                {
                     property int btn_id: 0
                     property variant trn_index:[0,0,0, 0,10,11, 0,1, 0,1]
                     property int btn_width: 120
                     property int  btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A00"
                     property int btn_keycode: 0x50 //dummy
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
                     property int btn_keycode: 0x50 //dummy
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
                     property int btn_keycode: 0x50 //dummy
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
                     property int btn_keycode: 0x50 //dummy
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
                     property int btn_keycode: 0x50 //dummy
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
                     property int btn_keycode: 0x50 //dummy
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
                     property int btn_keycode: 0x50 //dummy
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
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 8
                     property variant trn_index:[8,8,8, 17,18,19, 7,9, 7,9]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A08"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 9
                     property variant trn_index:[9,9,9, 18,19,9, 8,9, 8,10]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "A09"
                     property int btn_keycode: 0x50 //dummy
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
                     property variant trn_index:[10,0,1, 10,20,21, 10,11, 9,11]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B00"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 11
                     property variant trn_index:[0,1,2, 20,21,22, 10,12, 10,12]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B01"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 12
                     property variant trn_index:[1,2,3, 21,22,23, 11,13, 11,13]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B02"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 13
                     property variant trn_index:[2,3,4, 22,23,24, 12,14, 12,14]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B03"
                     property int btn_keycode:0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 14
                     property variant trn_index:[3,4,5, 23,24,25, 13,15, 13,15]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B04"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50

                },
                ListElement
                {
                     property int btn_id: 15
                     property variant trn_index:[4,5,6, 24,25,26, 14,16, 14,16]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B05"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 16
                     property variant trn_index:[5,6,7, 25,26,27, 15,17, 15,17]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B06"
                     property int btn_keycode:0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 17
                     property variant trn_index:[6,7,8, 26,27,28, 16,18, 16,18]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B07"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 18
                     property variant trn_index:[7,8,9, 27,28,29, 17,19, 17,19]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B08"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 19
                     property variant trn_index:[8,9,19, 28,29,19, 18,19, 18,20]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "B09"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                }
            ]

        },
        ListElement
        {
            property list<ListElement> line: [
                ListElement
                {
                     property int btn_id: 20
                     property variant trn_index:[20,10,11, 20,30,31, 20,21, 19,21]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_shift' //const_BTN_SHIFT_L_SUFFIX
                     property string btn_text: ""
                     property int btn_keycode: 0x01000020//Qt.Key_Shift  /*0x01000020*/
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 21
                     property variant trn_index:[10,11,12, 30,31,32, 20,22, 20,22]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C01"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 22
                     property variant trn_index:[11,12,13, 31,32,22, 21,23, 21,23]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C02"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 23
                     property variant trn_index:[12,13,14, 32,23,34, 22,24, 22,24]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C03"
                     property int btn_keycode:0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 24
                     property variant trn_index:[13,14,15, 24,34,34, 23,25, 23,25]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C04"
                     property int btn_keycode:0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 25
                     property variant trn_index:[14,15,16, 34,34,34, 24,26, 24,26]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C05"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 26
                     property variant trn_index:[15,16,17, 34,34,35, 25,27, 25,27]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C06"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 27
                     property variant trn_index:[16,17,18, 34,35,36, 26,28, 26,28]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C07"
                     property int btn_keycode:0x50 //dummy
                     property int btn_fontSize: 50

                },
                ListElement
                {
                     property int btn_id: 28
                     property variant trn_index:[17,18,19, 35,36,37, 27,29, 27,29]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'
                     property string btn_text: "C08"
                     property int btn_keycode: 0x50 //dummy
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 29
                     property variant trn_index:[18,29,29, 36,37,29, 28,29, 28,30]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'la_del'
                     property string btn_text: ""
                     property int btn_keycode: 0x01000061//Qt.Key_Back /*0x01000061*/
                     property int btn_fontSize: 50
                }
            ]

        },
        ListElement
        {
            property list<ListElement> line: [
                ListElement
                {
                     property int btn_id: 30
                     property variant trn_index:[30,20,21, 30,30,30, 30,31, 29,31]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_pad'
                     property string btn_text: ""
                     property int btn_keycode: Qt.Key_Launch0//0x010000a2//Qt::Key_Launch0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 31
                     property variant trn_index:[20,21,22, 31,31,31, 30,32, 30,32]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_etc'          // 123@
                     property string btn_text: "Launch1"
                     property int btn_keycode: Qt.Key_Launch1//0x010000a3//Qt::Key_Launch1
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 32
                     property variant trn_index:[21,22,23, 32,32,32, 31,34, 31,34]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_etc'          // A
                     property string btn_text: "Launch2"
                     property int btn_keycode: Qt.Key_Launch2//0x010000a4//Qt::Key_Launch2
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 33
                     property variant trn_index:[33,33,33, 33,33,33, 33,33, 33,33]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_etc'          // change lang
                     property string btn_text: "Launch3"
                     property int btn_keycode: Qt.Key_Launch3//0x010000a4//Qt::Key_Launch2
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 34
                     property variant trn_index:[24,25,26, 34,34,34, 32,35, 32,35]
                     property int btn_width: 374
                     property int btn_height: 87
                     property string btn_suffix: 'kor_space'    //'space'
                     property string btn_text: " "
                     property int btn_keycode: 0x20//Qt.Key_Space /*0x20*/
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 35
                     property variant trn_index:[26,27,28, 35,35,35, 34,36, 34,36]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_character'      // 'comma'            // .@/
                     property string btn_text: ".-@"
                     property int btn_keycode: Qt.Key_Launch4//Qt.Key_Launch3
                     property int btn_fontSize: 40
                },
                ListElement
                {
                     property int btn_id: 36
                     property variant trn_index:[27,28,29, 36,36,36, 35,37, 35,37]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_set'
                     property string btn_text: ""
                     property int btn_keycode: Qt.Key_Launch5//Qt.Key_Launch4
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 37
                     property variant trn_index:[28,29,37, 37,37,37, 36,37, 36,37]
                     property int btn_width: 120
                     property int btn_height: 87
                     property string btn_suffix: 'kor_done'
                     property string btn_text: "Completion"
                     property int btn_keycode: 0x01000010//Qt.Key_Home  /*0x01000010*/
                     property int btn_fontSize: 40
                }
            ]
        }
    ]
}
