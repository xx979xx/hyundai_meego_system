import QtQuick 1.1
import "../system" as MSystem

MComponent{
    id:idAVMCalibInitMenu
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.StringInfo {id:stringInfo}

    focus: true

    signal backFromCalibMain();

    Component.onCompleted:{
        avmCalibBtn1.focus = true;
        UIListener.SendAutoTestSignal(); //For AutoTest
    }

    //Msg Area
    Image {
        id: idCalibMsgArea
        x:9; y:524
        width: systemInfo.avmMenuBarWidth
        height: 84
        source: systemInfo.imageInternal + "bg_camera_info.png"
        visible: (canDB.AVM_DispMsg==2)? true : false

        Text {
            anchors.centerIn: parent
            text: stringInfo.alert0txt
            color: colorInfo.brightGrey
            font.family: stringInfo.fontName
            font.pointSize : systemInfo.alertFontSize
        }
    }

    //Menus
    Item {
        id: idCalibMenus
        x:systemInfo.avmMenuBarX; y:idCalibMsgArea.y+idCalibMsgArea.height
        width: systemInfo.avmMenuBarWidth; height: 96+9+9

        Row {
            spacing:8
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            MButton {
                id: avmCalibBtn1
                width: systemInfo.aVMButtonWidth; height: systemInfo.aVMButtonHeight
                focus: true
                bgImage:systemInfo.imageInternal+"btn_camera_m_n.png"
                bgImagePress:systemInfo.imageInternal+"btn_camera_m_p.png"
                bgImageActive:bgImagePress
                bgImageFocus: systemInfo.imageInternal+"btn_camera_m_f.png"
                firstText: stringInfo.calibInitMenuTxt1
                firstTextSize: systemInfo.btnFontSize

                onClickOrKeySelected: {
                    canCon.selectAVMCalCmd(5); //front
                }

                KeyNavigation.right: avmCalibBtn2
                onWheelLeftKeyPressed: avmCalibBtn5.forceActiveFocus()
                onWheelRightKeyPressed: avmCalibBtn2.forceActiveFocus()
            }

            MButton {
                id: avmCalibBtn2
                width: systemInfo.aVMButtonWidth; height: systemInfo.aVMButtonHeight
                bgImage:systemInfo.imageInternal+"btn_camera_m_n.png"
                bgImagePress:systemInfo.imageInternal+"btn_camera_m_p.png"
                bgImageActive:bgImagePress
                bgImageFocus: systemInfo.imageInternal+"btn_camera_m_f.png"
                firstText: stringInfo.calibInitMenuTxt2
                firstTextSize: systemInfo.btnFontSize

                onClickOrKeySelected: {
                    canCon.selectAVMCalCmd(6); //rear
                }

                KeyNavigation.right: avmCalibBtn3
                KeyNavigation.left: avmCalibBtn1
                onWheelLeftKeyPressed: avmCalibBtn1.forceActiveFocus()
                onWheelRightKeyPressed: avmCalibBtn3.forceActiveFocus()
            }

            MButton {
                id: avmCalibBtn3
                width: systemInfo.aVMButtonWidth; height: systemInfo.aVMButtonHeight
                bgImage:systemInfo.imageInternal+"btn_camera_m_n.png"
                bgImagePress:systemInfo.imageInternal+"btn_camera_m_p.png"
                bgImageActive:bgImagePress
                bgImageFocus: systemInfo.imageInternal+"btn_camera_m_f.png"
                firstText: stringInfo.calibInitMenuTxt3
                firstTextSize: systemInfo.btnFontSize

                onClickOrKeySelected: {
                    canCon.selectAVMCalCmd(7); //left
                }

                KeyNavigation.right: avmCalibBtn4
                KeyNavigation.left: avmCalibBtn2
                onWheelLeftKeyPressed: avmCalibBtn2.forceActiveFocus()
                onWheelRightKeyPressed: avmCalibBtn4.forceActiveFocus()
            }

            MButton {
                id: avmCalibBtn4
                width: systemInfo.aVMButtonWidth; height: systemInfo.aVMButtonHeight
                bgImage:systemInfo.imageInternal+"btn_camera_m_n.png"
                bgImagePress:systemInfo.imageInternal+"btn_camera_m_p.png"
                bgImageActive:bgImagePress
                bgImageFocus: systemInfo.imageInternal+"btn_camera_m_f.png"
                firstText: stringInfo.calibInitMenuTxt4
                firstTextSize: systemInfo.btnFontSize

                onClickOrKeySelected: {
                    canCon.selectAVMCalCmd(8); //right
                }

                KeyNavigation.right: avmCalibBtn5
                KeyNavigation.left: avmCalibBtn3
                onWheelLeftKeyPressed: avmCalibBtn3.forceActiveFocus()
                onWheelRightKeyPressed: avmCalibBtn5.forceActiveFocus()
            }

            MButton {
                id: avmCalibBtn5
                width: systemInfo.aVMButtonWidth; height: systemInfo.aVMButtonHeight
                bgImage:systemInfo.imageInternal+"btn_camera_m_n.png"
                bgImagePress:systemInfo.imageInternal+"btn_camera_m_p.png"
                bgImageActive:bgImagePress
                bgImageFocus: systemInfo.imageInternal+"btn_camera_m_f.png"
                firstText: stringInfo.calibInitMenuTxt5
                firstTextSize: systemInfo.btnFontSize

                onClickOrKeySelected: {
                    canCon.selectAVMCalCmd(4); //finish
                }

                KeyNavigation.left: avmCalibBtn4
                onWheelLeftKeyPressed: avmCalibBtn4.forceActiveFocus()
                onWheelRightKeyPressed: avmCalibBtn1.forceActiveFocus()
            }
        }
    }



}
