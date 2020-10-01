import QtQuick 1.0

Item
{
    id: arabic_type2_keypad_model
    property int btn_count: 51
    property list<ListElement> keypad:[

        ListElement
        {
            property list<ListElement> line: [
                ListElement
                {
                     property int btn_id: 0
                     property variant trn_index:[0,0,0, 0,11,12, 0,1, 0,1]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A00"
                     property string btn_text2: " "
                     property int btn_keycode: 0x51//Qt.Key_Q  /*0x51*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 1
                     property variant trn_index:[1,1,1, 11,12,13, 0,2, 0,2]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A01"
                     property string btn_text2: " "
                     property int btn_keycode: 0x57//Qt.Key_W /*0x57*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 2
                     property variant trn_index:[2,2,2, 12,13,14, 1,3, 1,3]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A02"
                     property string btn_text2: " "
                     property int btn_keycode: 0x45//Qt.Key_E /*0x45*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 3
                     property variant trn_index:[3,3,3, 13,14,15, 2,4, 2,4]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A03"
                     property string btn_text2: " "
                     property int btn_keycode: 0x52//Qt.Key_R /*0x52*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 4
                     property variant trn_index:[4,4,4, 14,15,16, 3,5, 3,5]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A04"
                     property string btn_text2: " "
                     property int btn_keycode: 0x54//Qt.Key_T /*0x54*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 5
                     property variant trn_index:[5,5,5, 15,16,17, 4,6, 4,6]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A05"
                     property string btn_text2: " "
                     property int btn_keycode: 0x59//Qt.Key_Y /*0x59*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 6
                     property variant trn_index:[6,6,6, 16,17,18, 5,7, 5,7]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A06"
                     property string btn_text2: " "
                     property int btn_keycode: 0x55//Qt.Key_U  /*0x55*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 7
                     property variant trn_index:[7,7,7, 17,18,19, 6,8, 6,8]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A07"
                     property string btn_text2: " "
                     property int btn_keycode: 0x49//Qt.Key_I /*0x49*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 8
                     property variant trn_index:[8,8,8, 18,19,20, 7,9, 7,9]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A08"
                     property string btn_text2: " "
                     property int btn_keycode: 0x4f//Qt.Key_O /*0x4f*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 9
                     property variant trn_index:[9,9,9, 19,20,21, 8,10, 8,10]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A09"
                     property string btn_text2: " "
                     property int btn_keycode: 0x50//Qt.Key_P /*0x50*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 10
                     property variant trn_index:[10,10,10, 20,21,10, 9,10, 9,11]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "A10"
                     property string btn_text2: " "
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
                     property int btn_id: 11
                     property variant trn_index:[11,0,1, 11,22,23, 11,12, 10,12]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B00"
                     property string btn_text2: " "
                     property int btn_keycode: 0x41//Qt.Key_A /*0x41*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 12
                     property variant trn_index:[0,1,2, 22,23,24, 11,13, 11,13]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B01"
                     property string btn_text2: " "
                     property int btn_keycode: 0x41//Qt.Key_A /*0x41*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 13
                     property variant trn_index:[1,2,3, 23,24,25, 12,14, 12,14]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B02"
                     property string btn_text2: " "
                     property int btn_keycode: 0x53//Qt.Key_S /*0x53*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 14
                     property variant trn_index:[2,3,4, 24,25,26, 13,15, 13,15]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B03"
                     property string btn_text2: " "
                     property int btn_keycode: 0x44//Qt.Key_D /*0x44*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 15
                     property variant trn_index:[3,4,5, 25,26,27, 14,16, 14,16]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B04"
                     property string btn_text2: " "
                     property int btn_keycode: 0x46//Qt.Key_F /*0x46 */
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 16
                     property variant trn_index:[4,5,6, 26,27,28, 15,17, 15,17]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B05"
                     property string btn_text2: " "
                     property int btn_keycode: 0x47//Qt.Key_G /*0x47*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 17
                     property variant trn_index:[5,6,7, 27,28,29, 16,18, 16,18]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B06"
                     property string btn_text2: " "
                     property int btn_keycode:0x48//Qt.Key_H /*0x48*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 18
                     property variant trn_index:[6,7,8, 28,29,30, 17,19, 17,19]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B07"
                     property string btn_text2: " "
                     property int btn_keycode: 0x4a//Qt.Key_J /*0x4a*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 19
                     property variant trn_index:[7,8,9, 29,30,31, 18,20, 18,20]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B08"
                     property string btn_text2: " "
                     property int btn_keycode: 0x4b//Qt.Key_K /*0x4b*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 20
                     property variant trn_index:[8,9,10, 30,31,32, 19,21, 19,21]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B09"
                     property string btn_text2: " "
                     property int btn_keycode: 0x4c//Qt.Key_L  /*0x4c*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 21
                     property variant trn_index:[9,10,21, 31,32,21, 20,21, 20,22]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "B10"
                     property string btn_text2: " "
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
                     property int btn_id: 22
                     property variant trn_index:[22,11,12, 22,33,34, 22,23, 21,23]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C00"
                     property string btn_text2: " "
                     property int btn_keycode: 0x41//Qt.Key_A /*0x41*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 23
                     property variant trn_index:[11,12,13, 33,34,35, 22,24, 22,24]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C01"
                     property string btn_text2: " "
                     property int btn_keycode: 0x41//Qt.Key_A /*0x41*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 24
                     property variant trn_index:[12,13,14, 34,35,36, 23,25, 23,25]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C02"
                     property string btn_text2: " "
                     property int btn_keycode: 0x53//Qt.Key_S /*0x53*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 25
                     property variant trn_index:[13,14,15, 35,36,37, 24,26, 24,26]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C03"
                     property string btn_text2: " "
                     property int btn_keycode: 0x44//Qt.Key_D /*0x44*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 26
                     property variant trn_index:[14,15,16, 36,37,38, 25,27, 25,27]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C04"
                     property string btn_text2: " "
                     property int btn_keycode: 0x46//Qt.Key_F /*0x46 */
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 27
                     property variant trn_index:[15,16,17, 37,38,39, 26,28, 26,28]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C05"
                     property string btn_text2: " "
                     property int btn_keycode: 0x47//Qt.Key_G /*0x47*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 28
                     property variant trn_index:[16,17,18, 38,39,40, 27,29, 27,29]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C06"
                     property string btn_text2: " "
                     property int btn_keycode:0x48//Qt.Key_H /*0x48*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 29
                     property variant trn_index:[17,18,19, 39,40,41, 28,30, 28,30]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C07"
                     property string btn_text2: " "
                     property int btn_keycode: 0x4a//Qt.Key_J /*0x4a*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 30
                     property variant trn_index:[18,19,20, 40,41,42, 29,31, 29,31]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C08"
                     property string btn_text2: " "
                     property int btn_keycode: 0x4b//Qt.Key_K /*0x4b*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 31
                     property variant trn_index:[19,20,21, 30,31,32, 30,32, 30,32]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C09"
                     property string btn_text2: " "
                     property int btn_keycode: 0x4c//Qt.Key_L  /*0x4c*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 32
                     property variant trn_index:[20,21,32, 42,42,32, 31,32, 31,33]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "C10"
                     property string btn_text2: " "
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
                     property int btn_id: 33
                     property variant trn_index:[33,22,23, 33,43,44, 33,34, 32,34]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_shift'   //const_BTN_SHIFT_L_SUFFIX
                     property string btn_text: ""
                     property string btn_text2: " "
                     property int btn_keycode: 0x01000020//Qt.Key_Shift  /*0x01000020*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 34
                     property variant trn_index:[22,23,24, 43,44,34, 33,35, 33,35]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "D00"
                     property string btn_text2: " "
                     property int btn_keycode: 0x5a//Qt.Key_Z /*0x5a*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 35
                     property variant trn_index:[23,24,25, 44,35,46, 34,36, 34,36]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "D01"
                     property string btn_text2: " "
                     property int btn_keycode: 0x58//Qt.Key_X /*0x58*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 36
                     property variant trn_index:[24,25,26, 36,46,47, 35,37, 35,37]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "D02"
                     property string btn_text2: " "
                     property int btn_keycode: 0x43 /*Qt.Key_C*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 37
                     property variant trn_index:[25,26,27, 46,47,47, 36,38, 36,38]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "D03"
                     property string btn_text2: " "
                     property int btn_keycode:0x56//Qt.Key_V /*0x56*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 38
                     property variant trn_index:[26,27,28, 47,47,47, 37,39, 37,39]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "D04"
                     property string btn_text2: " "
                     property int btn_keycode: 0x42//Qt.Key_B /*0x42*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 39
                     property variant trn_index:[27,28,29, 47,47,48, 38,40, 38,40]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "D05"
                     property string btn_text2: " "
                     property int btn_keycode: 0x4e//Qt.Key_N /*0x4e*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 40
                     property variant trn_index:[28,29,30, 47,48,49, 39,41, 39,41]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "D06"
                     property string btn_text2: " "
                     property int btn_keycode:0x4d//Qt.Key_M /*0x4d*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 41
                     property variant trn_index:[29,30,31, 48,49,50, 40,42, 40,42]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'
                     property string btn_text: "D07"
                     property string btn_text2: " "
                     property int btn_keycode:0x4d//Qt.Key_M /*0x4d*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 42
                     property variant trn_index:[30,31,32, 49,50,42, 41,42, 41,43]
                     property int btn_width: 223
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_del' //const_BTN_DEL_SUFFIX
                     property string btn_text: ""
                     property string btn_text2: " "
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
                     property int btn_id: 43
                     property variant trn_index:[43,33,34, 43,43,43, 43,44, 42,44]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_pad'
                     property string btn_text: ""
                     property string btn_text2: " "
                     property int btn_keycode: Qt.Key_Launch0
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 44
                     property variant trn_index:[33,34,35, 44,44,44, 43,46, 43,46]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_etc'          // 123@
                     property string btn_text: "Launch1"
                     property string btn_text2: " "
                     property int btn_keycode: Qt.Key_Launch1
                     property int btn_pad: 0
                     property int btn_fontSize: 28
                },
                ListElement
                {
                     property int btn_id: 45
                     property variant trn_index:[45,45,45, 45,45,45, 45,45, 45,45]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_etc'          // change lang
                     property string btn_text: "Launch2"
                     property string btn_text2: " "
                     property int btn_keycode: Qt.Key_Launch2
                     property int btn_pad: 0
                     property int btn_fontSize: 28
                },
                ListElement
                {
                     property int btn_id: 46
                     property variant trn_index:[35,36,37, 46,46,46, 44,47, 44,47]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_etc'          // ABC
                     property string btn_text: "Launch3"
                     property string btn_text2: " "
                     property int btn_keycode: Qt.Key_Launch3
                     property int btn_pad: 0
                     property int btn_fontSize: 28
                },
                ListElement
                {
                     property int btn_id: 47
                     property variant trn_index:[37,38,39, 47,47,47, 46,48, 46,48]
                     property int btn_width: 338
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_space'    //'space'
                     property string btn_text: " "
                     property string btn_text2: " "
                     property int btn_keycode: 0x20//Qt.Key_Space /*0x20*/
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 48
                     property variant trn_index:[39,40,41, 48,48,48, 47,49, 47,49]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_character'      // 'comma'            // .@/
                     property string btn_text: ".-@"
                     property string btn_text2: " "
                     property int btn_keycode: Qt.Key_Launch4
                     property int btn_pad: 0
                     property int btn_fontSize: 28
                },
                ListElement
                {
                     property int btn_id: 49
                     property variant trn_index:[40,41,42, 49,49,49, 48,50, 48,50]
                     property int btn_width: 108
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_set'
                     property string btn_text: ""
                     property string btn_text2: " "
                     property int btn_keycode: Qt.Key_Launch5
                     property int btn_pad: 0
                     property int btn_fontSize: 50
                },
                ListElement
                {
                     property int btn_id: 50
                     property variant trn_index:[41,42,50, 50,50,50, 49,50, 49,50]
                     property int btn_width: 223
                     property int btn_height: 66
                     property string btn_suffix: 'arab2_done'
                     property string btn_text: "Completion"
                     property string btn_text2: " "
                     property int btn_keycode: 0x01000010//Qt.Key_Home  /*0x01000010*/
                     property int btn_pad: 0
                     property int btn_fontSize: 28
                }
            ]
        }
    ]
}
