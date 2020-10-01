/**
 * /QML/DH_arabic/MEditMode.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MComponent
{
    id: idEditMode

    width: 256
    height: 555
    anchors.left: parent.left
    anchors.bottom: parent.bottom

    // PROPERTIES
    property int buttonNumber: 4
    property string buttonText1: "Btn1Line"
    property string buttonText2: "Btn2Line"
    property string buttonText3: "Btn3Line"
    property string buttonText4: "Btn4Line"

    property alias buttonEnabled1: editButton1.mEnabled;
    property alias buttonEnabled2: editButton2.mEnabled;
    property alias buttonEnabled3: editButton3.mEnabled;
    property alias buttonEnabled4: editButton4.mEnabled;

    property QtObject editModeBand;
    property bool first_clicked: false;

    // SIGNALS
    signal clickButton1()
    signal clickButton2()
    signal clickButton3()
    signal clickButton4()


    Component.onCompleted: {
        // 진입시점에 Button 초기 Enable/Disable 설정(MButton의 mEnabled 값은 기본으로 true)
        if(true == buttonEnabled1) {
            editButton1.focus = true;
        } else if(true == buttonEnabled2) {
            editButton2.focus = true;
        } else if(true == buttonEnabled3) {
            editButton3.focus = true;
        } else {
            editButton4.focus = true;
        }

        first_clicked = true;
    }

    onVisibleChanged: {
        if(true == idEditMode.visible) {
            // 진입시점에 Button 초기 Enable/Disable 설정(MButton의 mEnabled 값은 기본으로 true)
            if(true == buttonEnabled1) {
                editButton1.focus = true;
            } else if(true == buttonEnabled2) {
                editButton2.focus = true;
            } else if(true == buttonEnabled3) {
                editButton3.focus = true;
            } else {
                editButton4.focus = true;
            }

            first_clicked = true;
        }
    }

    onButtonEnabled1Changed: {
        if(true == buttonEnabled1) {
            first_clicked = true
        }

        // 버튼이 Disable될 경우 다른 버튼으로 포커스를 옮김
        if(true == first_clicked) {
            if(true == buttonEnabled1) {
                editButton1.focus = true;
            } else {
                editButton2.focus = true;
            }
        } else {
            if(true == editButton1.focus) {
                if(true == buttonEnabled2) {
                    editButton2.focus = true;
                } else if(true == buttonEnabled3) {
                    editButton3.focus = true;
                } else if(true == buttonEnabled4) {
                    editButton4.focus = true;
                }
            }
        }
    }

    onButtonEnabled2Changed: {
        // 버튼이 Disable될 경우 다른 버튼으로 포커스를 옮김
        if(true == editButton2.focus) {
            if(true == buttonEnabled1) {
                editButton1.focus = true;
            } else if(true == buttonEnabled3) {
                editButton3.focus = true;
            } else if(true == buttonEnabled4) {
                editButton4.focus = true;
            }
        }
    }

    onButtonEnabled3Changed: {
        // 버튼이 Disable될 경우 다른 버튼으로 포커스를 옮김
        if(true == editButton3.focus) {
            if(true == buttonEnabled2) {
                editButton2.focus = true;
            } else if(true == buttonEnabled1) {
                editButton1.focus = true;
            } else if(true == buttonEnabled4) {
                editButton4.focus = true;
            }
        }
    }

    onButtonEnabled4Changed: {
        // 버튼이 Disable될 경우 다른 버튼으로 포커스를 옮김
        if(true == editButton4.focus) {
            if(true == buttonEnabled3) {
                editButton3.focus = true;
            } else if(true == buttonEnabled2) {
                editButton2.focus = true;
            } else if(true == buttonEnabled1) {
                editButton1.focus = true;
            }
        }
    }

    onActiveFocusChanged: {
/*DEPRECATED
        if(true == idEditMode.activeFocus) {
            if(true == buttonEnabled1) {
                editButton1.forceActiveFocus();
            } else if(true == buttonEnabled2) {
                editButton2.forceActiveFocus();
            } else if(true == buttonEnabled3) {
                editButton3.forceActiveFocus();
            } else {
                editButton4.forceActiveFocus();
            }
        }
DEPRECATED*/

        if(true == idEditMode.activeFocus && true == first_clicked) {
            first_clicked = false;
        }
    }

    Image {
        anchors.fill: parent
        source: ImagePath.imgFolderGeneral + "bg_edit_mode.png"
    }

    /* Button1
     */
    MButton {
        id: editButton1
        x: 12
        y: buttonNumber == 3 ? 79 : 9
        //focus: true
        width: 214
        height: 129

        bgImage:        ImagePath.imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress:   ImagePath.imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus:   ImagePath.imgFolderGeneral+"btn_edit_mode_f.png"

        firstText: buttonText1
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64 - 16
        firstTextSize: 32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
        firstTextAlies: "Center"
        firstTextElide: ""
        firstTextWrap: "Text.WordWrap"

        onClickOrKeySelected: {
            editButton1.forceActiveFocus();
            clickButton1();
        }

        onWheelRightKeyPressed: {
/*DEPRECATED
            if(3 == buttonNumber) {
                // 3 --> 2
                if(true == buttonEnabled3) {
                    editButton3.forceActiveFocus();
                } else if(true == buttonEnabled2) {
                    editButton2.forceActiveFocus();
                }
            } else {
                // 4 --> 3 --> 2
                if(true == buttonEnabled4) {
                    editButton4.forceActiveFocus();
                } else if(true == buttonEnabled3) {
                    editButton3.forceActiveFocus();
                } else if(true == buttonEnabled2) {
                    editButton2.forceActiveFocus();
                }
            }
DEPRECATED*/
        }

        onWheelLeftKeyPressed: {
            if(3 == buttonNumber) {
                // 2 --> 3
                if(true == buttonEnabled2) {
                    editButton2.forceActiveFocus();
                } else if(true == buttonEnabled3) {
                    editButton3.forceActiveFocus();
                }
            } else {
                // 2 --> 3 --> 4
                if(true == buttonEnabled2) {
                    editButton2.forceActiveFocus();
                } else if(true == buttonEnabled3) {
                    editButton3.forceActiveFocus();
                } else if(true == buttonEnabled4) {
                    editButton4.forceActiveFocus();
                }
            }
        }
    }

    /* Button2
     */
    MButton {
        id: editButton2
        x: 12
        anchors.top: editButton1.bottom
        anchors.topMargin: 5
        width: 214
        height: 129
        focus: true

        bgImage:        ImagePath.imgFolderGeneral + "btn_edit_mode_n.png"
        bgImagePress:   ImagePath.imgFolderGeneral + "btn_edit_mode_p.png"
        bgImageFocus:   ImagePath.imgFolderGeneral + "btn_edit_mode_f.png"

        firstText: buttonText2
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64 - 16
        firstTextSize:32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
        firstTextAlies: "Center"
        firstTextElide: ""
        firstTextWrap: "Text.WordWrap"

        onClickOrKeySelected: {
            first_clicked = true

            if(true == buttonEnabled1) {
                editButton1.forceActiveFocus();
            } else {
                editButton2.forceActiveFocus();
            }


            clickButton2();
        }

        onWheelRightKeyPressed: {
            if(3 == buttonNumber) {
                // 1 --> 3
                if(true == buttonEnabled1) {
                    editButton1.forceActiveFocus();
                } else if(true == buttonEnabled3) {
                    editButton3.forceActiveFocus();
                }
            } else {
                // 1 --> 4 --> 3
                if(true == buttonEnabled1) {
                    editButton1.forceActiveFocus();
                } /*else if(true == buttonEnabled4) {
                    editButton4.forceActiveFocus();
                } else if(true == buttonEnabled3) {
                    editButton3.forceActiveFocus();
                }*/
            }
        }

        onWheelLeftKeyPressed: {
            if(3 == buttonNumber) {
                // 3 --> 1
                if(true == buttonEnabled3) {
                    editButton3.forceActiveFocus();
                } else if(true == buttonEnabled1) {
                    editButton1.forceActiveFocus();
                }
            } else {
                // 3 --> 4 --> 1
                if(true == buttonEnabled3) {
                    editButton3.forceActiveFocus();
                } else if(true == buttonEnabled4) {
                    editButton4.forceActiveFocus();
                } else if(true == buttonEnabled1) {
                    editButton1.forceActiveFocus();
                }
            }
        }
    }

    /* Button3
     */
    MButton {
        id: editButton3
        x: 12
        anchors.top:editButton2.bottom
        anchors.topMargin: 5
        width: 214
        height: 129

        bgImage:        ImagePath.imgFolderGeneral + "btn_edit_mode_n.png"
        bgImagePress:   ImagePath.imgFolderGeneral + "btn_edit_mode_p.png"
        bgImageFocus:   ImagePath.imgFolderGeneral + "btn_edit_mode_f.png"

        firstText: buttonText3
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64 - 16
        firstTextSize:32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
        firstTextAlies: "Center"
        firstTextElide: ""
        firstTextWrap: "Text.WordWrap"

        onClickOrKeySelected: {
            editButton3.forceActiveFocus();
            clickButton3();
        }

        onWheelRightKeyPressed: {
            if(3 == buttonNumber) {
                // 2 --> 1
                if(true == buttonEnabled2) {
                    editButton2.forceActiveFocus();
                } else if(true == buttonEnabled1) {
                    editButton1.forceActiveFocus();
                }
            } else {
                // 2 --> 1 --> 4
                if(true == buttonEnabled2) {
                    editButton2.forceActiveFocus();
                } else if(true == buttonEnabled1) {
                    editButton1.forceActiveFocus();
                } /*else if(true == buttonEnabled4) {
                    editButton4.forceActiveFocus();
                }*/
            }
        }

        onWheelLeftKeyPressed: {
            if(3 == buttonNumber) {
                // 1 --> 2
                if(true == buttonEnabled1) {
                    editButton1.forceActiveFocus();
                } else if(true == buttonEnabled2) {
                    editButton2.forceActiveFocus();
                }
            } else {
                // 4 --> 1 --> 2
                if(true == buttonEnabled4) {
                    editButton4.forceActiveFocus();
                } /*else if(true == buttonEnabled1) {
                    editButton1.forceActiveFocus();
                } else if(true == buttonEnabled2) {
                    editButton2.forceActiveFocus();
                }*/
            }
        }
    }

    /* Button4
     */
    MButton {
        id: editButton4
        x: 12
        anchors.top: editButton3.bottom
        anchors.topMargin: 5
        visible: buttonNumber == 3 ? false:true
        width: 214
        height: 129

        bgImage:        ImagePath.imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress:   ImagePath.imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus:   ImagePath.imgFolderGeneral+"btn_edit_mode_f.png"

        firstText: buttonText4
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64 - 16
        firstTextSize: 32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
        firstTextAlies: "Center"
        firstTextElide: ""
        firstTextWrap: "Text.WordWrap"

        onClickOrKeySelected: {
            editButton4.forceActiveFocus();
            clickButton4();
        }

        onWheelRightKeyPressed: {
            // 3 --> 2 --> 1
            if(true == buttonEnabled3) {
                editButton3.forceActiveFocus();
            } else if(true == buttonEnabled2) {
                editButton2.forceActiveFocus();
            } else if(true == buttonEnabled1) {
                editButton1.forceActiveFocus();
            }
        }

        onWheelLeftKeyPressed: {
            /*// 1 --> 2 --> 3
            if(true == buttonEnabled1) {
                editButton1.forceActiveFocus();
            } else if(true == buttonEnabled2) {
                editButton2.forceActiveFocus();
            } else if(true == buttonEnabled3) {
                editButton3.forceActiveFocus();
            }*/
        }
    }
}
/* EOF */
