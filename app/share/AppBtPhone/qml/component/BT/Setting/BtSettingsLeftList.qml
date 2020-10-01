/**
 * /BT/Setting/BtSettingsLeftList.qml
 *
 */
import QtQuick 1.1
import "../../QML" as DDComp
import "../../QML/DH" as MComp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idBtSettingsLeft
    y: 3
    width: 547
    height: 534 - 3
    focus: true
    clip: true

    property bool longPressed: false

    /* INTERNAL functions */
    function currentIndexChange() {
        switch(settingCurrentIndex) {
            case 1: idBtSettingLeftListBtn2.focus = true; break;
            case 2: idBtSettingLeftListBtn3.focus = true; break;
            case 3: idBtSettingLeftListBtn4.focus = true; break;
            case 4: idBtSettingLeftListBtn5.focus = true; break;
            case 5: idBtSettingLeftListBtn6.focus = true; break;

            case 0:
            default:
                idBtSettingLeftListBtn1.focus = true;
                break;
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        currentIndexChange();
        idBtSettingsLeft.forceActiveFocus();
    }

    Component.onDestruction: {
    }

    onVisibleChanged: {
        if(true == idBtSettingsLeft.visible) {
            currentIndexChange();
            idBtSettingsLeft.forceActiveFocus()
        }
    }

    Flickable {
        width: 547
        height: 534
        focus: true
        flickableDirection: Flickable.VerticalFlick

        onMovementEnded: {
            if(true == idBtSettingsLeft.visible) {
                if(popupState == "" && menuOn == false) {
                    idBtSettingsLeft.forceActiveFocus();
                }
            }
        }

        /* WIDGETS */
        // 블루투스 연결설정
        MComp.MButtonHaveTicker {
            id: idBtSettingLeftListBtn1
            y: 0
            width: 547
            height: 89
            active: settingCurrentIndex == 0


            /* Ticker Enable! */
            tickerEnable: true


            bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_p.png"
            bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 547
            bgImageHeight: 95

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: 9
            lineImageY: 89

            firstText : stringInfo.str_Bluetooth_Connect_Setting
            firstTextX : 23
            firstTextY : 25
            firstTextWidth: 479
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue //RGB(124,189,255)
            firstTextStyle: (settingCurrentIndex == 0)? stringInfo.fontFamilyBold : stringInfo.fontFamilyRegular     //"HDR"
            firstTextElide: "Right"
            firstTextAlies: "Left"

            onClickOrKeySelected: {
                idBtSettingLeftListBtn1.focus = true
                switchScreen("SettingsBtDeviceConnect", false, 51);
                idLoaderSettingsDeviceConnect.forceActiveFocus();
            }

            onWheelLeftKeyPressed:  {}
            onWheelRightKeyPressed: {
                // 자동연결이 Disable되어 있을 경우 Skip
                if(true == idBtSettingLeftListBtn2.mEnabled) {
                    switchScreen("SettingsBtAutoConn", false, 531);
                    idBtSettingLeftListBtn2.forceActiveFocus();
                } else {
                    if(true == iqs_15My) {
                        switchScreen("SettingsBtDeviceName", false, 23);
                        idBtSettingLeftListBtn5.forceActiveFocus();
                    } else {
                        switchScreen("SettingsBtAutoDown", false, 532);
                        idBtSettingLeftListBtn3.forceActiveFocus();
                    }
                }
            }

            onActiveFocusChanged: {
                if(true == idBtSettingLeftListBtn1.activeFocus) {
                   /* 터치와 조그 모드가 사라져 다르게 처리할 필요 없음
                     */
                    idVisualCue.setVisualCue(true, true, false, false);
                }
            }

            // 포커스 이동 후 재진입 시 이전 포커스 저장되는 문제 수정
            onActiveChanged: {
                if(true == idBtSettingLeftListBtn1.active) {
                    currentIndexChange();
                }
            }
        }

        // 자동연결 설정
        MComp.MButtonHaveTicker {
            id: idBtSettingLeftListBtn2
            y: 89
            width: 547
            height: 89
            active: settingCurrentIndex == 1
            mEnabled: BtCoreCtrl.m_pairedDeviceCount != 0

            /* Ticker Enable! */
            tickerEnable: true


            bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_p.png"
            bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 547
            bgImageHeight: 95

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: 9
            lineImageY: 89

            firstText : stringInfo.str_Auto_Connection_Priority
            firstTextX : 23
            firstTextY : 25
            firstTextWidth: 479
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue //RGB(124,189,255)
            firstTextStyle: (settingCurrentIndex == 1)? stringInfo.fontFamilyBold : stringInfo.fontFamilyRegular     //"HDR"
            firstTextElide: "Right"
            firstTextAlies: "Left"

            onClickOrKeySelected: {
                idBtSettingLeftListBtn2.focus = true
                switchScreen("SettingsBtAutoConn", false, 54);
                idLoaderSettingsAutoConnect.forceActiveFocus();
            }

            onWheelLeftKeyPressed:  {
                switchScreen("SettingsBtDeviceConnect", false, 55);
                idBtSettingLeftListBtn1.forceActiveFocus();
            }

            onWheelRightKeyPressed: {
                if(true == iqs_15My) {
                    switchScreen("SettingsBtDeviceName", false, 23);
                    idBtSettingLeftListBtn5.forceActiveFocus();
                } else {
                    switchScreen("SettingsBtAutoDown", false, 56);
                    idBtSettingLeftListBtn3.forceActiveFocus();
                }
            }


            onActiveFocusChanged: {
                if(true == idBtSettingLeftListBtn2.activeFocus) {
                    /* 터치와 조그 모드가 사라져 다르게 처리할 필요 없음
                     */
                    idVisualCue.setVisualCue(true, true, false, false);
                }
            }

            // 포커스 이동 후 재진입 시 이전 포커스 저장되는 문제 수정
            onActiveChanged: {
                if(true == idBtSettingLeftListBtn2.active) {
                    currentIndexChange();
                }
            }
        }

        // 자동다운로드 설정
        MComp.MButtonHaveTicker {
            id: idBtSettingLeftListBtn3
            y: 178
            width: 547
            height: 89
            active: settingCurrentIndex == 2
            // For IQS_15MY
            visible: (false == iqs_15My)

            /* Ticker Enable! */
            tickerEnable: true


            bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_p.png"
            bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 547
            bgImageHeight: 95

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: 9
            lineImageY: 89

            firstText : stringInfo.str_Bt_Auto_Download_Setting_Btn
            firstTextX : 23
            firstTextY : 25
            firstTextWidth: 479
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue //RGB(124,189,255)
            firstTextStyle: (settingCurrentIndex == 2)? stringInfo.fontFamilyBold : stringInfo.fontFamilyRegular     //"HDR"
            firstTextElide: "Right"
            firstTextAlies: "Left"

            onClickOrKeySelected: {
                idBtSettingLeftListBtn3.focus = true;
                switchScreen("SettingsBtAutoDown", false, 57);
                idLoaderSettingsAutoDownload.forceActiveFocus();
            }

            onWheelLeftKeyPressed: {
                // 자동연결이 Disable되어 있을 경우 Skip
                if(true == idBtSettingLeftListBtn2.mEnabled) {
                    switchScreen("SettingsBtAutoConn", false, 581);
                    idBtSettingLeftListBtn2.forceActiveFocus();
                } else {
                    switchScreen("SettingsBtDeviceConnect", false, 582);
                    idBtSettingLeftListBtn1.forceActiveFocus();
                }
            }

            onWheelRightKeyPressed: {
                switchScreen("SettingsBtAudioStream", false, 59);
                idBtSettingLeftListBtn4.forceActiveFocus();
            }

            onActiveFocusChanged: {
                if(true == idBtSettingLeftListBtn3.activeFocus) {
                    /* 터치와 조그 모드가 사라져 다르게 처리할 필요 없음
                     */
                    idVisualCue.setVisualCue(true, true, false, false);
                }
            }

            // 포커스 이동 후 재진입 시 이전 포커스 저장되는 문제 수정
            onActiveChanged: {
                if(true == idBtSettingLeftListBtn3.active) {
                    currentIndexChange();
                }
            }
        }

        // 오디오 스트리밍
        MComp.MButtonHaveTicker {
            id: idBtSettingLeftListBtn4
            y: 267
            width: 547
            height: 89
            active: settingCurrentIndex == 3
            // For IQS_15MY
            visible: (false == iqs_15My)

            /* Ticker Enable! */
            tickerEnable: true


            bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_p.png"
            bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 547
            bgImageHeight: 95

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: 9
            lineImageY: 89

            DDComp.DDCheckBox {
                id: idAudioStreamingCheckBox
                x: 469
                y: 0
                width: 51
                height: parent.height

                visible: false == BtCoreCtrl.m_bAudioStreamingPlaying

                checkCondition: BtCoreCtrl.m_bAudioStreamingMode
            }

            firstText : stringInfo.str_Audio_Streming
            firstTextX : 23
            firstTextY : 25
            firstTextWidth: 435
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue //RGB(124,189,255)
            firstTextStyle: (settingCurrentIndex == 3)? stringInfo.fontFamilyBold : stringInfo.fontFamilyRegular     //"HDR"
            firstTextElide: "Right"
            firstTextAlies: "Left"

            // "실행중" TEXT > ICON 변경
            MComp.DDPlayAnimation {
                x: 480
                y: 26
                visible: (true == BtCoreCtrl.m_bAudioStreamingMode && true == BtCoreCtrl.m_bAudioStreamingPlaying) ? true : false // PLAY or STOP
            }

            onClickOrKeySelected: {
                //DEPRCECATED idVisualCue.setVisualCue(true, false, false, false);

                switchScreen("SettingsBtAudioStream", false, 21);

                if(false == BtCoreCtrl.m_bAudioStreamingPlaying) {
                    if(true == BtCoreCtrl.m_bAudioStreamingMode) {
                        BtCoreCtrl.invokeSetAudioStreamingMode(false);
                    } else {
                        BtCoreCtrl.invokeSetAudioStreamingMode(true);
                    }
                }

                idBtSettingLeftListBtn4.forceActiveFocus()
            }

            onWheelLeftKeyPressed: {
                /*if(true == idBtSettingLeftListBtn2.mEnabled) {
                    switchScreen("SettingsBtAutoConn", false, 581);
                    idBtSettingLeftListBtn2.forceActiveFocus();
                } else {
                    switchScreen("SettingsBtDeviceConnect", false, 582);
                    idBtSettingLeftListBtn1.forceActiveFocus();
                }*/
                switchScreen("SettingsBtAutoDown", false, 22);
                idBtSettingLeftListBtn3.forceActiveFocus();
            }

            onWheelRightKeyPressed: {
                switchScreen("SettingsBtDeviceName", false, 23);
                idBtSettingLeftListBtn5.forceActiveFocus();
            }

            onActiveFocusChanged: {
                if(true == idBtSettingLeftListBtn4.activeFocus) {
                    /* 터치와 조그 모드가 사라져 다르게 처리할 필요 없음
                     */
                    idVisualCue.setVisualCue(true, false, false, false)
                }
            }

            // 포커스 이동 후 재진입 시 이전 포커스 저장되는 문제 수정
            onActiveChanged: {
                if(true == idBtSettingLeftListBtn4.active) {
                    currentIndexChange();
                }
            }
        }

        // 기기정보
        MComp.MButtonHaveTicker {
            id: idBtSettingLeftListBtn5
            y: (false == iqs_15My) ? 356 : 178
            width: 547
            height: 89
            active: settingCurrentIndex == 4

            /* Ticker Enable! */
            tickerEnable: true


            bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_p.png"
            bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 547
            bgImageHeight: 95

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: 9
            lineImageY: 89

            firstText : stringInfo.str_Device_Info
            firstTextX : 23
            firstTextY : 25
            firstTextWidth: 479
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue //RGB(124,189,255)
            firstTextStyle: (settingCurrentIndex == 4)? stringInfo.fontFamilyBold : stringInfo.fontFamilyRegular     //"HDR"
            firstTextElide: "Right"
            firstTextAlies: "Left"

            onClickOrKeySelected: {
                idBtSettingLeftListBtn5.focus = true
                switchScreen("SettingsBtDeviceName", false, 24);
                idLoaderSettingsDeviceInfo.forceActiveFocus();
            }

            onWheelLeftKeyPressed: {
                if(true == iqs_15My) {
                    if(true == idBtSettingLeftListBtn2.mEnabled) {
                        switchScreen("SettingsBtAutoConn", false, 581);
                        idBtSettingLeftListBtn2.forceActiveFocus();
                    } else {
                        switchScreen("SettingsBtDeviceConnect", false, 582);
                        idBtSettingLeftListBtn1.forceActiveFocus();
                    }
                } else {
                    switchScreen("SettingsBtAudioStream", false, 25);
                    idBtSettingLeftListBtn4.forceActiveFocus();
                }
            }

            onWheelRightKeyPressed: {
                if(true == idBtSettingLeftListBtn6.visible) {
                    switchScreen("SettingsBtCustomer", false);
                    idBtSettingLeftListBtn6.forceActiveFocus();
                } else {

                }
            }

            onActiveFocusChanged: {
                if(true == idBtSettingLeftListBtn5.activeFocus) {
                    /* 터치와 조그 모드가 사라져 다르게 처리할 필요 없음
                     */
                    idVisualCue.setVisualCue(true, true, false, false);
                    if(false == idBtSettingLeftListBtn6.visible) {
                        visualCueDownActive = false
                    }
                } else {
                    visualCueDownActive = true
                }
            }

            // 포커스 이동 후 재진입 시 이전 포커스 저장되는 문제 수정
            onActiveChanged: {
                if(true == idBtSettingLeftListBtn5.active) {
                    currentIndexChange();
                }
            }
        }

        // 고객센터
        MComp.MButtonHaveTicker {
            id: idBtSettingLeftListBtn6
            y: (false == iqs_15My) ? 445 : 267
            width: 547
            height: 89
            active: (settingCurrentIndex == 5)

            /* Ticker Enable! */
            tickerEnable: true


            bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_p.png"
            bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 547
            bgImageHeight: 95

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: 9
            lineImageY: 89

            firstText : stringInfo.str_Bt_Customer
            firstTextX : 23
            firstTextY : 25
            firstTextWidth: 479
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue //RGB(124,189,255)
            firstTextStyle: (settingCurrentIndex == 5)? stringInfo.fontFamilyBold : stringInfo.fontFamilyRegular    //"HDR"
            firstTextElide: "Right"
            firstTextAlies: "Left"

            visible: UIListener.invokeGetCountryVariant() == 1 || UIListener.invokeGetCountryVariant() == 0

            onClickOrKeySelected: {
                switchScreen("SettingsBtCustomer", false);
                idBtSettingLeftListBtn6.forceActiveFocus();
            }

            onWheelLeftKeyPressed: {
                switchScreen("SettingsBtDeviceName", false);
                idBtSettingLeftListBtn5.forceActiveFocus();
            }

            onWheelRightKeyPressed: {}

            onActiveFocusChanged: {
                if(true == idBtSettingLeftListBtn6.activeFocus) {
                    /* 터치와 조그 모드가 사라져 다르게 처리할 필요 없음
                     */
                    idVisualCue.setVisualCue(true, false, false, false);
                    visualCueDownActive = false
                } else {
                    visualCueDownActive = true
                }
            }

            // 포커스 이동 후 재진입 시 이전 포커스 저장되는 문제 수정
            onActiveChanged: {
                if(true == idBtSettingLeftListBtn6.active) {
                    currentIndexChange();
                }
            }
        }
    }

    Keys.onPressed: {
        console.log("onPressed > ShiftModifier")
        if(Qt.Key_Up == event.key) {
            if(true == idBtSettingLeftListBtn1.activeFocus) {
                settingBandFocus()
            } else {
                if(Qt.ShiftModifier == event.modifiers) {
                    longPressed = true
                    settingLeftTimerUpStart();
                    event.accepted = true
                }
            }
            event.accepted = true
        } else if(Qt.Key_Down == event.key) {
            if(Qt.ShiftModifier == event.modifiers) {
                longPressed = true
                settingLeftTimerDownStart();
                event.accepted = true
            }
            event.accepted = true
        }
    }

    Keys.onReleased: {
        settingLeftTimerStop()

        if(Qt.Key_Up == event.key) {
            if(true == longPressed) {
                longPressed = false
            } else {
                settingBandFocus()
            }
            event.accepted = true
        } else if(Qt.Key_Down == event.key) {
            if(true == longPressed) {
                longPressed = false
            }
            event.accepted = true
        }
    }
}
/* EOF */
