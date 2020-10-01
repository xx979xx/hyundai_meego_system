import QtQuick 1.1

import "../system" as MSystem

MComponent{
    width: 620
    height: 160

    focus: true

    property bool bIsDecoderMode: true;

    signal closeWindow();

    //Decoder setting values
    property int iBlue: 0
    property int iRed: 0
    property int iBright: 0
    property int iContra: 0
    property int iSharp: 0

    //Display setting values
    property int iContrast: 0
    property int iSaturation: 0
    property int iBrightness: 0
    property int iGammaLevel: 0

    property int levelOffset: 128
    property int defaultValue: 32768
    property int maxValue: 65535
    property int decoderBrMinValue: -128
    property int decoderBrMaxValue: 127
    property int decoderMinValue: 0
    property int decoderMaxValue: 255

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }

//    Rectangle {
//        color: "Black"
//        anchors.fill: parent
//    }

    Item {
        anchors.fill: parent

        Column {
            x:0; y:0
            spacing: 0

            Row {
                spacing: 10

                Item {
                    width: 1
                    height: 45
                }

                Text {
                    id: titleName
                    width: 250
                    color: "white"
                    font.pointSize: 30
                    font.family: stringInfo.fontName
                    style: Text.Outline; styleColor: "black"
                    text: (bIsDecoderMode)? "Decoder Tuning" : "Display Tuning"
                }

                MButton {
                    id: changeModeBtn
                    width: 200
                    height: 45
                    bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                    bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                    bgImageActive: bgImagePress
                    bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                    firstText: "Change Mode"
                    focus: true

                    onClickOrKeySelected: {
                        if (bIsDecoderMode) {
                            //get display setting values and binding
                            iContrast=VideoSetting.nContrast;
                            iSaturation=VideoSetting.nSaturation;
                            iBrightness=VideoSetting.nBrightness;
                            iGammaLevel=0;
                            bIsDecoderMode = false;
                            decoderRow.visible=false;
                            displayRow.visible=true;
                        }
                        else {
                            bIsDecoderMode = true;
                            displayRow.visible=false;
                            decoderRow.visible=true;
                        }
                    }
                    KeyNavigation.down: (bIsDecoderMode)? btn1 : btn5
                    KeyNavigation.left: closeBtn
                    KeyNavigation.right: closeBtn
                    onWheelRightKeyPressed: closeBtn.forceActiveFocus()
                    onWheelLeftKeyPressed: closeBtn.forceActiveFocus()
                }

                MButton {
                    id: closeBtn
                    width: 135
                    height: 45
                    bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                    bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                    bgImageActive: bgImagePress
                    bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                    firstText: "Close"

                    onClickOrKeySelected: {
                        //VideoSetting.CloseDecoderDevice();
                        closeWindow();
                    }
                    KeyNavigation.down: (bIsDecoderMode)? btn1 : btn5
                    KeyNavigation.left: changeModeBtn
                    KeyNavigation.right: changeModeBtn
                    onWheelLeftKeyPressed: changeModeBtn.forceActiveFocus()
                    onWheelRightKeyPressed: changeModeBtn.forceActiveFocus()
                }
            }

            Row {
                id: decoderRow
                spacing: 5

                Item {
                    width: 5
                    height: 130
                }

                Rectangle {
                    color: "blue"
                    width: 120
                    height: 120

                    Column {
                        spacing: 5
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            id: tBox1
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "white"
                            font.pointSize: 20
                            font.family: stringInfo.fontName
                            text: "Blue Gain"
                        }

                        MButton {
                            id: btn1
                            width: 110; height: 50
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: iBlue
                            firstTextSize: 30

                            KeyNavigation.up: changeModeBtn
                            KeyNavigation.left: btn4
                            KeyNavigation.right: btn2
                            onKeySelected: {
                                VideoSetting.SetDecoderRegister(19,VideoSetting.nCB+decoderMinValue);
                                iBlue=128
                            }
                            onWheelRightKeyPressed: {
                                if (iBlue==decoderMaxValue) return;
                                VideoSetting.SetDecoderRegister(19,iBlue+1);
                                iBlue=iBlue+1
                            }
                            onWheelLeftKeyPressed: {
                                if (iBlue==decoderMinValue) return;
                                VideoSetting.SetDecoderRegister(19,iBlue-1);
                                iBlue=iBlue-1
                            }
                        }

                    }

                }

                Rectangle {
                    color: "red"
                    width: 120
                    height: 120

                    Column {
                        spacing: 5
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            id: tBox2
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "white"
                            font.pointSize: 20
                            font.family: stringInfo.fontName
                            text: "Red Gain"
                        }

                        MButton {
                            id: btn2
                            width: 110; height: 50
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: iRed
                            firstTextSize: 30

                            KeyNavigation.up: changeModeBtn
                            KeyNavigation.left: btn1
                            KeyNavigation.right: btn3
                            onKeySelected: {
                                VideoSetting.SetDecoderRegister(20,VideoSetting.nCR+decoderMinValue);
                                iRed=128
                            }
                            onWheelRightKeyPressed: {
                                if (iRed==decoderMaxValue) return;
                                VideoSetting.SetDecoderRegister(20,iRed+1);
                                iRed=iRed+1
                            }
                            onWheelLeftKeyPressed: {
                                if (iRed==decoderMinValue) return;
                                VideoSetting.SetDecoderRegister(20,iRed-1);
                                iRed=iRed-1
                            }
                        }

                    }

                }

                Rectangle {
                    color: "yellow"
                    width: 120
                    height: 120

                    Column {
                        spacing: 5
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            id: tBox3
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "black"
                            font.pointSize: 20
                            font.family: stringInfo.fontName
                            text: "Brightness"
                        }

                        MButton {
                            id: btn3
                            width: 110; height: 50
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: iBright
                            firstTextSize: 30

                            KeyNavigation.up: changeModeBtn
                            KeyNavigation.left: btn2
                            KeyNavigation.right: btn3_2
                            onKeySelected: {
                                VideoSetting.SetDecoderRegister(16,VideoSetting.nBright);
                                iBright=VideoSetting.nBright
                            }
                            onWheelRightKeyPressed: {
                                if (iBright==decoderBrMaxValue) return;
                                VideoSetting.SetDecoderRegister(16,iBright+1);
                                iBright=iBright+1
                            }
                            onWheelLeftKeyPressed: {
                                if (iBright==decoderBrMinValue) return;
                                VideoSetting.SetDecoderRegister(16,iBright-1);
                                iBright=iBright-1
                            }
                        }

                    }

                }

                Rectangle {
                    color: "green"
                    width: 120
                    height: 120

                    Column {
                        spacing: 5
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            id: tBox3_2
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "black"
                            font.pointSize: 20
                            font.family: stringInfo.fontName
                            text: "Contrast"
                        }

                        MButton {
                            id: btn3_2
                            width: 110; height: 50
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: iContra
                            firstTextSize: 30

                            KeyNavigation.up: changeModeBtn
                            KeyNavigation.left: btn3
                            KeyNavigation.right: btn4
                            onKeySelected: {
                                VideoSetting.SetDecoderRegister(17,VideoSetting.nContra);
                                iContra=VideoSetting.nContra
                            }
                            onWheelRightKeyPressed: {
                                if (iContra==decoderMaxValue) return;
                                VideoSetting.SetDecoderRegister(17,iContra+1);
                                iContra=iContra+1
                            }
                            onWheelLeftKeyPressed: {
                                if (iContra==decoderMinValue) return;
                                VideoSetting.SetDecoderRegister(17,iContra-1);
                                iContra=iContra-1
                            }
                        }

                    }

                }

                Rectangle {
                    color: "gray"
                    width: 120
                    height: 120

                    Column {
                        spacing: 5
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            id: tBox4
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "black"
                            font.pointSize: 20
                            font.family: stringInfo.fontName
                            text: "Sharpness"
                        }

                        MButton {
                            id: btn4
                            width: 110; height: 50
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: iSharp
                            firstTextSize: 30

                            KeyNavigation.up: changeModeBtn
                            KeyNavigation.left: btn3_2
                            KeyNavigation.right: btn1
                            onKeySelected: {
                                VideoSetting.SetDecoderRegister(18,21);
                                iSharp=21
                            }
                            onWheelRightKeyPressed: {
                                if (iSharp==31) return;
                                VideoSetting.SetDecoderRegister(18,iSharp+1);
                                iSharp=iSharp+1
                            }
                            onWheelLeftKeyPressed: {
                                if (iSharp==16) return;
                                VideoSetting.SetDecoderRegister(18,iSharp-1);
                                iSharp=iSharp-1
                            }
                        }

                    }

                }
            } // End Row


            Row {
                id: displayRow
                spacing: 5
                visible: false

                Item {
                    width: 5
                    height: 130
                }

                Rectangle {
                    color: "green"
                    width: 150
                    height: 120

                    Column {
                        spacing: 3
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            //id: tBox5
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "white"
                            font.pointSize: 18
                            font.family: stringInfo.fontName
                            text: "Contrast"
                        }

                        MButton {
                            id: btn5
                            width: 140; height: 40
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: iContrast
                            firstTextSize: 26

                            KeyNavigation.up: changeModeBtn
                            KeyNavigation.down: btn5s
                            KeyNavigation.left: btn8
                            KeyNavigation.right: btn6
                            onKeySelected: {
                                VideoSetting.SetDisplaySetting(0,defaultValue);
                                iContrast=defaultValue
                            }
                            onWheelRightKeyPressed: {
                                if (iContrast>=maxValue) return;
                                VideoSetting.SetDisplaySetting(0,iContrast+levelOffset);
                                iContrast=iContrast+levelOffset
                            }
                            onWheelLeftKeyPressed: {
                                if (iContrast<=0) return;
                                VideoSetting.SetDisplaySetting(0,iContrast-levelOffset);
                                iContrast=iContrast-levelOffset
                            }
                        }

                        MButton {
                            id: btn5s
                            width:80; height: 30
                            anchors.horizontalCenter: parent.horizontalCenter
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: "-1/+1"
                            firstTextSize: 18

                            KeyNavigation.up: btn5
                            KeyNavigation.left: btn7s
                            KeyNavigation.right: btn6s

                            onWheelRightKeyPressed: {
                                if (iContrast>=maxValue) return;
                                VideoSetting.SetDisplaySetting(0,iContrast+1);
                                iContrast=iContrast+1
                            }
                            onWheelLeftKeyPressed: {
                                if (iContrast<=0) return;
                                VideoSetting.SetDisplaySetting(0,iContrast-1);
                                iContrast=iContrast-1
                            }

                        }


                    }

                }

                Rectangle {
                    color: "purple"
                    width: 150
                    height: 120

                    Column {
                        spacing: 3
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            //id: tBox6
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "white"
                            font.pointSize: 18
                            font.family: stringInfo.fontName
                            text: "Saturation"
                        }

                        MButton {
                            id: btn6
                            width: 140; height: 40
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: iSaturation
                            firstTextSize: 26

                            KeyNavigation.up: changeModeBtn
                            KeyNavigation.down: btn6s
                            KeyNavigation.left: btn5
                            KeyNavigation.right: btn7
                            onKeySelected: {
                                VideoSetting.SetDisplaySetting(1,defaultValue);
                                iSaturation=defaultValue
                            }
                            onWheelRightKeyPressed: {
                                if (iSaturation>=maxValue) return;
                                VideoSetting.SetDisplaySetting(1,iSaturation+levelOffset);
                                iSaturation=iSaturation+levelOffset
                            }
                            onWheelLeftKeyPressed: {
                                if (iSaturation<=0) return;
                                VideoSetting.SetDisplaySetting(1,iSaturation-levelOffset);
                                iSaturation=iSaturation-levelOffset
                            }
                        }

                        MButton {
                            id: btn6s
                            width:80; height: 30
                            anchors.horizontalCenter: parent.horizontalCenter
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: "-1/+1"
                            firstTextSize: 18

                            KeyNavigation.up: btn6
                            KeyNavigation.left: btn5s
                            KeyNavigation.right: btn7s

                            onWheelRightKeyPressed: {
                                if (iSaturation>=maxValue) return;
                                VideoSetting.SetDisplaySetting(1,iSaturation+1);
                                iSaturation=iSaturation+1
                            }
                            onWheelLeftKeyPressed: {
                                if (iSaturation<=0) return;
                                VideoSetting.SetDisplaySetting(1,iSaturation-1);
                                iSaturation=iSaturation-1
                            }

                        }

                    }

                }

                Rectangle {
                    color: "yellow"
                    width: 150
                    height: 120

                    Column {
                        spacing: 3
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            //id: tBox7
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "black"
                            font.pointSize: 18
                            font.family: stringInfo.fontName
                            text: "Brightness"
                        }

                        MButton {
                            id: btn7
                            width: 140; height: 40
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: iBrightness
                            firstTextSize: 26

                            KeyNavigation.up: changeModeBtn
                            KeyNavigation.down: btn7s
                            KeyNavigation.left: btn6
                            KeyNavigation.right: btn8
                            onKeySelected: {
                                VideoSetting.SetDisplaySetting(2,defaultValue);
                                iBrightness=defaultValue
                            }
                            onWheelRightKeyPressed: {
                                if (iBrightness>=maxValue) return;
                                VideoSetting.SetDisplaySetting(2,iBrightness+levelOffset);
                                iBrightness=iBrightness+levelOffset
                            }
                            onWheelLeftKeyPressed: {
                                if (iBrightness<=0) return;
                                VideoSetting.SetDisplaySetting(2,iBrightness-levelOffset);
                                iBrightness=iBrightness-levelOffset
                            }
                        }

                        MButton {
                            id: btn7s
                            width:80; height: 30
                            anchors.horizontalCenter: parent.horizontalCenter
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: "-1/+1"
                            firstTextSize: 18

                            KeyNavigation.up: btn7
                            KeyNavigation.left: btn6s
                            KeyNavigation.right: btn5s

                            onWheelRightKeyPressed: {
                                if (iBrightness>=maxValue) return;
                                VideoSetting.SetDisplaySetting(2,iBrightness+1);
                                iBrightness=iBrightness+1
                            }
                            onWheelLeftKeyPressed: {
                                if (iBrightness<=0) return;
                                VideoSetting.SetDisplaySetting(2,iBrightness-1);
                                iBrightness=iBrightness-1
                            }

                        }

                    }

                }

                Rectangle {
                    color: "gray"
                    width: 150
                    height: 120

                    Column {
                        spacing: 3
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            //id: tBox8
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "black"
                            font.pointSize: 18
                            font.family: stringInfo.fontName
                            text: "GammaLevel"
                        }

                        MButton {
                            id: btn8
                            width: 140; height: 50
                            bgImage: systemInfo.imageInternal+"btn_dab_n.png"
                            bgImagePress: systemInfo.imageInternal+"btn_dab_p.png"
                            bgImageActive: bgImagePress
                            bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
                            firstText: iGammaLevel
                            firstTextSize: 30

                            KeyNavigation.up: changeModeBtn
                            KeyNavigation.left: btn7
                            KeyNavigation.right: btn5
                            onKeySelected: {
                                VideoSetting.SetGammaLevel(0);
                                iGammaLevel=0
                            }
                            onWheelRightKeyPressed: {
                                if (iGammaLevel==10) return;
                                VideoSetting.SetGammaLevel(iGammaLevel+1);
                                iGammaLevel=iGammaLevel+1
                            }
                            onWheelLeftKeyPressed: {
                                if (iGammaLevel==-10) return;
                                VideoSetting.SetGammaLevel(iGammaLevel-1);
                                iGammaLevel=iGammaLevel-1
                            }
                        }

                    }

                }
            } // End Row

        }
    }

    Component.onCompleted: {
        UIListener.GetAllDecoderValues();
        iBlue = VideoSetting.nCB;
        iRed = VideoSetting.nCR;
        iBright = VideoSetting.nBright;
        iSharp = VideoSetting.nSharp;
        iContra = VideoSetting.nContra;
    }
}
