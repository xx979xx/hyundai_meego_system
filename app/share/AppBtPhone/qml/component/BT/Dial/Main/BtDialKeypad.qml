/**
 * /BT/Dial/Main/BtDialDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idBtDialKeypad
    width: 519
    height: 505
    focus: true

    /* INTERNAL functions */
    function dialKeyHandler(key) {
        /* [주의] 32자까지 입력을 제한하는 코드로 아래의 다른 코드들과 달리 33이 아님
         */
        if(32 > phoneNumInput.length) {
            phoneNumInput = phoneNumInput + key;
            BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput);

            /* 다운로드 중일때 리스트 보이지 않게 수정
             * dialListView 값에 따라 Dial 리스트 show/hide 결정
             */
            if(7 == contact_value) {
                dialListView = true;
            }
        }
    }

    function filterShortCutNumber(number) {
        if(1 > number.length) {
            return false;
        }

        return (null == number.match(/[+, *, #]/g)) ? true : false;
    }

    function dialLongKeyHandler(key) {
        /* 다운로드 중일때 리스트 보이지 않게 수정
         * dialListView 값에 따라 Dial 리스트 show/hide 결정
         */
        if(7 == contact_value) {
            dialListView = true;
        }

        if(9 < BtCoreCtrl.m_ncallState) {
            /* 통화중 추가 통화 막음
             */
            MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
        } else {
            // Dial화면에서 숫자 32자 입력시 전화 안되던 문제 수정
            if(32 > phoneNumInput.length) {
                phoneNumInput = phoneNumInput + key;
                BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput);

                /* 표준형동작:
                 * 1) 3자리 이하일때 *, #, +가 포함되어 있으면 단축 다이얼로 전화하지 않음
                 * 2) 3자리 이하 일때 단축 다이얼로 전화
                 * 3) 4자리 이상부터는 Long Press에 대해 키 입력만 실행함
                 */
                if(4 > phoneNumInput.length && true == filterShortCutNumber(phoneNumInput)) {
                    BtCoreCtrl.invokeCallStartFromMemory(phoneNumInput);
                }
            }
        }
    }

    function dialCallKeyHandler() {
        if(phoneNumInput != "" ) {
            // Dial화면에서 숫자 32자 입력시 전화 안되던 문제 수정
            if(BtCoreCtrl.m_strConnectedDeviceName != "" && phoneNumInput.length < 33) {
                if(BtCoreCtrl.m_ncallState > 9 ) {
                    /* 통화중일 경우 진입 막음
                    */
                    MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
                } else {
                    /*블루 링크 통화 중이지 않은 경우 일반 BT 통화 발생
                     */
                    BtCoreCtrl.HandleCallStart(phoneNumInput);
                }

                //DEPRECATED idBtGeneralSubMain.forceActiveFocus();
            }
        } else {
            /* 최근통화 목록 중 가장 마지막 목록을 가져옴
             */
            if(1 > BtCoreCtrl.m_outgoingCallHistoryCount
                    && 1 > BtCoreCtrl.m_incomingCallHistoryCount
                    && 1 > BtCoreCtrl.m_missedCallHistoryCount) {
                // UX 변경: 최근통화목록이 없습니다 팝업 표시
                // UX 재변경: 동작없음
                //DEPRECATED MOp.showPopup("popup_outgoing_calls_empty");
            } else {
                phoneNumInput = BtCoreCtrl.invokeTrackerGetLastOutgoing();
                if("" == phoneNumInput) {
                    // 최근통화목록이 없을때 "" 을 반환함
                    MOp.showPopup("popup_outgoing_calls_empty");
                    return;
                }

                BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput);
                dialListView = true;
                btnKeypadCall.forceActiveFocus();
            }
        }
    }


    /* CONNECTIONS */
    Connections {
        target: idAppMain

        onSigDialCallKeyHandler: {
            // 다이얼 화면에서 HK call 키가 눌린 경우 호출됨(DHBtSignals.qml)
            dialCallKeyHandler();
        }

        onCallEndEvent: {
            btnKeypad1.focus = true
            btnKeypad2.focus = false
            btnKeypad3.focus = false
            btnKeypad4.focus = false
            btnKeypad5.focus = false
            btnKeypad6.focus = false
            btnKeypad7.focus = false
            btnKeypad8.focus = false
            btnKeypad9.focus = false
            btnKeypad0.focus = false
            btnKeypadDel.focus = false
            btnKeypadSharp.focus = false
            btnKeypadStar.focus = false
        }
    }

    Connections {
        target:  idBtDialMain

        onSigSetDialFocus: {
            // 다이얼 Candidate List를 클릭한경우 통화버튼에 포커스를 위치시킴
            btnKeypadCall.forceActiveFocus();
        }
    }

    Connections {
        target: BtCoreCtrl

       /* //CarPlay  모드 Test 코드
       target: idAppMain
       */

        onSigAAPConnected: {
                btnKeypadConnect.fgImage = ImagePath.imgFolderBt_phone + "ico_dial_bt_set_d.png"
                btnKeypadConnect.bgImage = ImagePath.imgFolderBt_phone + "btn_dial_set_d.png"
        }

        onSigAAPDisconnected: {
                btnKeypadConnect.fgImage = ImagePath.imgFolderBt_phone + "ico_dial_bt_set.png"
                btnKeypadConnect.bgImage = ImagePath.imgFolderBt_phone + "btn_dial_set_n.png"
        }
    }

    /* WIDGETS */
    Row {
        // 1, 2, 3
        focus: true
        spacing: -1

        MComp.DDDialButton {
            id: btnKeypad1
            width: 175
            height: 101
            focus: true

            playLongPressBeep: true

            bgImage:        ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:   ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:  ImagePath.imgFolderBt_phone + "btn_dial_num_s.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_1.png"
            fgImageX: 63        //36 + 27
            fgImageY: 9

            onClickOrKeySelected: {
                btnKeypad1.forceActiveFocus();
                dialKeyHandler("1");

                if(phoneNumInput != "" && dial_list_count != 0) {
                    idVisualCue.setVisualCue(true, true, true, true)
                } else {
                    idVisualCue.setVisualCue(true, true, true, false)
                }
            }

            onPressAndHold: {
                btnKeypad1.forceActiveFocus();
                dialLongKeyHandler("1");

                if(phoneNumInput != "" && dial_list_count != 0) {
                    idVisualCue.setVisualCue(true, true, true, true)
                } else {
                    idVisualCue.setVisualCue(true, true, true, false)
                }
            }

            onActiveFocusChanged: {
                if(true == btnKeypad1.activeFocus) {
                    if(phoneNumInput != "" && dial_list_count != 0) {
                        idVisualCue.setVisualCue(true, true, true, true)
                    } else {
                        idVisualCue.setVisualCue(true, true, true, false)
                    }
                }
            }

            KeyNavigation.right:    btnKeypad2
            KeyNavigation.down:     btnKeypad4
            KeyNavigation.left:     dial_list_count == 0 ? btnKeypad1 : idBtDialListView
            onDownRightKeyPressed:  btnKeypad5.focus = true

            onWheelRightKeyPressed: btnKeypad2.focus = true;

            onWheelLeftKeyPressed: {
                if(false == btnKeypadDel.mEnabled) {
                    btnKeypadConnect.focus = true;
                } else {
                    btnKeypadDel.focus = true;
                }
            }
        }

        MComp.DDDialButton {
            id: btnKeypad2
            width: 175
            height: 101

            playLongPressBeep: true

            bgImage:        ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:   ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:  ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_2.png"
            fgImageX: 63        //36 + 27
            fgImageY: 9

            firstTextX: 36
            firstTextY: 63      //9 + 66 - 12
            firstText: "ABC"
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextSize: 24
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.brightGrey : colorInfo.grey
            firstTextHeight:24
            firstTextWidth:103      //26+77
            firstTextPressColor: firstTextColor
            firstTextFocusColor: firstTextColor

            onClickOrKeySelected: {
                btnKeypad2.forceActiveFocus();
                dialKeyHandler("2");
            }

            onPressAndHold: {
                btnKeypad2.forceActiveFocus();
                dialLongKeyHandler("2");
            }

            onActiveFocusChanged: {
                if(true == btnKeypad2.activeFocus) {
                    idVisualCue.setVisualCue(true, true, true, true)
                }
            }

            KeyNavigation.left:     btnKeypad1
            KeyNavigation.right:    btnKeypad3
            KeyNavigation.down:     btnKeypad5

            onDownLeftKeyPressed:   btnKeypad4.focus = true
            onDownRightKeyPressed:  btnKeypad6.focus = true

            onWheelRightKeyPressed: btnKeypad3.focus = true
            onWheelLeftKeyPressed:  btnKeypad1.focus = true
        }

        MComp.DDDialButton {
            id: btnKeypad3
            width: 175
            height: 101

            playLongPressBeep: true

            bgImage:            ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:       ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:      ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:       ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_3.png"
            fgImageX: 63    //36 + 27
            fgImageY: 9

            firstTextX: 36
            firstTextY: 63      //9 + 66 - 12
            firstText: "DEF"
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextSize: 24
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.brightGrey : colorInfo.grey
            firstTextHeight: 24
            firstTextWidth: 103     //26 + 77
            firstTextPressColor: firstTextColor
            firstTextFocusColor: firstTextColor

            onClickOrKeySelected: {
                btnKeypad3.forceActiveFocus();
                dialKeyHandler("3");
            }

            onPressAndHold: {
                btnKeypad3.forceActiveFocus();
                dialLongKeyHandler("3");
            }

            onActiveFocusChanged: {
                if(true == btnKeypad3.activeFocus) {
                    idVisualCue.setVisualCue(true, false, true, true)
                }
            }

            KeyNavigation.left:     btnKeypad2
            KeyNavigation.down:     btnKeypad6

            onDownLeftKeyPressed:   btnKeypad5.focus = true

            onWheelRightKeyPressed: btnKeypad4.focus = true
            onWheelLeftKeyPressed:  btnKeypad2.focus = true
        }
    }

    Row {
        // 4, 5, 6
        y: 104
        spacing: -1

        MComp.DDDialButton {
            id: btnKeypad4
            width: 175
            height: 101

            playLongPressBeep: true

            bgImage:        ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:   ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:  ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_4.png"
            fgImageX: 63    //36 + 27
            fgImageY: 9

            firstTextX: 36
            firstTextY: 63      //9 + 66 - 12
            firstText: "GHI"
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextSize: 24
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.brightGrey : colorInfo.grey
            firstTextHeight: 24
            firstTextWidth: 103     //26 + 77
            firstTextPressColor: firstTextColor
            firstTextFocusColor: firstTextColor

            onClickOrKeySelected: {
                btnKeypad4.forceActiveFocus();
                dialKeyHandler("4");

                if(phoneNumInput != "" && dial_list_count != 0) {
                    idVisualCue.setVisualCue(true, true, true, true)
                } else {
                    idVisualCue.setVisualCue(true, true, true, false)
                }
            }

            onPressAndHold: {
                btnKeypad4.forceActiveFocus();
                dialLongKeyHandler("4");

                if(phoneNumInput != "" && dial_list_count != 0) {
                    idVisualCue.setVisualCue(true, true, true, true)
                } else {
                    idVisualCue.setVisualCue(true, true, true, false)
                }
            }

            onActiveFocusChanged: {
                if(true == btnKeypad4.activeFocus) {
                    if(phoneNumInput != "" && dial_list_count != 0) {
                        idVisualCue.setVisualCue(true, true, true, true)
                    } else {
                        idVisualCue.setVisualCue(true, true, true, false)
                    }
                }
            }

            KeyNavigation.down:     btnKeypad7
            KeyNavigation.up:       btnKeypad1
            KeyNavigation.left:     dial_list_count == 0 ? btnKeypad4 : idBtDialListView
            KeyNavigation.right:    btnKeypad5

            onUpRightKeyPressed:    btnKeypad2.focus = true
            onDownRightKeyPressed:  btnKeypad8.focus = true

            onWheelRightKeyPressed: btnKeypad5.focus = true
            onWheelLeftKeyPressed:  btnKeypad3.focus = true
        }

        MComp.DDDialButton {
            id: btnKeypad5
            width: 175
            height: 101

            playLongPressBeep: true

            bgImage:            ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:       ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:      ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:       ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_5.png"
            fgImageX: 63        //36 + 27
            fgImageY: 9

            firstTextX: 36
            firstTextY: 63      //9 + 66 - 12
            firstText: "JKL"
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextSize: 24
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.brightGrey : colorInfo.grey
            firstTextHeight: 24
            firstTextWidth: 103     //26 + 77
            firstTextPressColor: firstTextColor
            firstTextFocusColor: firstTextColor

            onClickOrKeySelected: {
                btnKeypad5.forceActiveFocus();
                dialKeyHandler("5");
            }

            onPressAndHold: {
                btnKeypad5.forceActiveFocus();
                dialLongKeyHandler("5");
            }

            onActiveFocusChanged: {
                if(true == btnKeypad5.activeFocus) {
                    idVisualCue.setVisualCue(true, true, true, true)
                }
            }

            KeyNavigation.up:       btnKeypad2
            KeyNavigation.left:     btnKeypad4
            KeyNavigation.right:    btnKeypad6
            KeyNavigation.down:     btnKeypad8

            onUpLeftKeyPressed:     btnKeypad1.focus = true
            onUpRightKeyPressed:    btnKeypad3.focus = true
            onDownLeftKeyPressed:   btnKeypad7.focus = true
            onDownRightKeyPressed:  btnKeypad9.focus = true

            onWheelRightKeyPressed: btnKeypad6.focus = true
            onWheelLeftKeyPressed:  btnKeypad4.focus = true
        }

        MComp.DDDialButton {
            id: btnKeypad6
            width: 175
            height: 101

            playLongPressBeep: true

            bgImage:            ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:       ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:      ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:       ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_6.png"
            fgImageX: 63        //36 + 27
            fgImageY: 9

            firstTextX: 36
            firstTextY: 63      //9 + 66 - 12
            firstText: "MNO"
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextSize: 24
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.brightGrey : colorInfo.grey
            firstTextHeight: 24
            firstTextWidth: 103     //26 + 77
            firstTextPressColor: firstTextColor
            firstTextFocusColor: firstTextColor

            onClickOrKeySelected: {
                btnKeypad6.forceActiveFocus();
                dialKeyHandler("6");
            }

            onPressAndHold: {
                btnKeypad6.forceActiveFocus();
                dialLongKeyHandler("6");
            }

            onActiveFocusChanged: {
                if(true == btnKeypad6.activeFocus) {
                    idVisualCue.setVisualCue(true, false, true, true)
                }
            }

            KeyNavigation.up:       btnKeypad3
            KeyNavigation.left:     btnKeypad5
            KeyNavigation.down:     btnKeypad9

            onUpLeftKeyPressed:     btnKeypad2.focus = true
            onDownLeftKeyPressed:   btnKeypad8.focus = true

            onWheelRightKeyPressed: btnKeypad7.focus = true
            onWheelLeftKeyPressed:  btnKeypad5.focus = true
        }
    }

    Row {
        // 7, 8, 9
        y: 208      //104 + 104
        spacing: -1

        MComp.DDDialButton {
            id: btnKeypad7
            width: 175
            height: 101

            playLongPressBeep: true

            bgImage:            ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:       ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:      ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:       ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_7.png"
            fgImageX: 63        //36 + 27
            fgImageY: 9

            firstTextX: 36
            firstTextY: 63      //9 + 66 - 12
            firstText: "PQRS"
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextSize: 24
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.brightGrey : colorInfo.grey
            firstTextHeight: 24
            firstTextWidth: 103     //26 + 77
            firstTextPressColor: firstTextColor
            firstTextFocusColor: firstTextColor

            onClickOrKeySelected: {
                btnKeypad7.forceActiveFocus();
                dialKeyHandler("7");

                if(phoneNumInput != "" && dial_list_count != 0) {
                    idVisualCue.setVisualCue(true, true, true, true)
                } else {
                    idVisualCue.setVisualCue(true, true, true, false)
                }
            }

            onPressAndHold: {
                btnKeypad7.forceActiveFocus();
                dialLongKeyHandler("7");

                if(phoneNumInput != "" && dial_list_count != 0) {
                    idVisualCue.setVisualCue(true, true, true, true)
                } else {
                    idVisualCue.setVisualCue(true, true, true, false)
                }
            }

            onActiveFocusChanged: {
                if(true == btnKeypad7.activeFocus) {
                    if(phoneNumInput != "" && dial_list_count != 0) {
                        idVisualCue.setVisualCue(true, true, true, true)
                    } else {
                        idVisualCue.setVisualCue(true, true, true, false)
                    }
                }
            }

            KeyNavigation.up:       btnKeypad4
            KeyNavigation.down:     btnKeypadStar
            KeyNavigation.left:     dial_list_count == 0 ? btnKeypad7 : idBtDialListView
            KeyNavigation.right:    btnKeypad8

            onUpRightKeyPressed:    btnKeypad5.focus = true
            onDownRightKeyPressed:  btnKeypad0.focus = true

            onWheelRightKeyPressed: btnKeypad8.focus = true
            onWheelLeftKeyPressed:  btnKeypad6.focus = true
        }

        MComp.DDDialButton {
            id: btnKeypad8
            width: 175
            height: 101

            playLongPressBeep: true

            bgImage:            ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:       ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:      ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:       ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_8.png"
            fgImageX: 63        //36 + 27
            fgImageY: 9

            firstTextX: 36
            firstTextY: 63      //9 + 66 - 12
            firstText: "TUV"
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextSize: 24
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.brightGrey : colorInfo.grey
            firstTextHeight: 24
            firstTextWidth: 103     //26 + 77
            firstTextPressColor: firstTextColor
            firstTextFocusColor: firstTextColor

            onClickOrKeySelected: {
                btnKeypad8.forceActiveFocus();
                dialKeyHandler("8");
            }

            onPressAndHold: {
                btnKeypad8.forceActiveFocus();
                dialLongKeyHandler("8");
            }

            onActiveFocusChanged: {
                if(true == btnKeypad8.activeFocus) {
                    idVisualCue.setVisualCue(true, true, true, true)
                }
            }

            KeyNavigation.up: btnKeypad5
            KeyNavigation.left: btnKeypad7
            KeyNavigation.right: btnKeypad9
            KeyNavigation.down: btnKeypad0

            onUpLeftKeyPressed: btnKeypad4.focus = true
            onUpRightKeyPressed: btnKeypad6.focus = true
            onDownLeftKeyPressed: btnKeypadStar.focus = true
            onDownRightKeyPressed: btnKeypadSharp.focus = true

            onWheelRightKeyPressed: btnKeypad9.focus = true
            onWheelLeftKeyPressed: btnKeypad7.focus = true
        }

        MComp.DDDialButton {
            id:btnKeypad9
            width: 175
            height: 101

            playLongPressBeep: true

            bgImage:            ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:       ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:      ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:       ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_9.png"
            fgImageX: 63    //36 + 27
            fgImageY: 9

            firstTextX: 36
            firstTextY: 63      //9 + 66 - 12
            firstText: "WXYZ"
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextSize: 24
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.brightGrey : colorInfo.grey
            firstTextHeight: 24
            firstTextWidth: 103     //26 + 77
            firstTextPressColor: firstTextColor
            firstTextFocusColor: firstTextColor

            onClickOrKeySelected: {
                btnKeypad9.forceActiveFocus();
                dialKeyHandler("9");
            }

            onPressAndHold: {
                btnKeypad9.forceActiveFocus();
                dialLongKeyHandler("9");
            }

            onActiveFocusChanged: {
                if(true == btnKeypad9.activeFocus) {
                    idVisualCue.setVisualCue(true, false, true, true)
                }
            }

            KeyNavigation.left:     btnKeypad8
            KeyNavigation.up:       btnKeypad6
            KeyNavigation.down:     btnKeypadSharp

            onUpLeftKeyPressed:     btnKeypad5.focus = true
            onDownLeftKeyPressed:   btnKeypad0.focus = true

            onWheelRightKeyPressed: btnKeypadStar.focus = true
            onWheelLeftKeyPressed:  btnKeypad8.focus = true
        }
    }

    Row {
        // *, 0, #
        y: 312      //104 + 104 + 104
        spacing: -1

        MComp.DDDialButton {
            id: btnKeypadStar
            width: 175
            height: 101

            bgImage:            ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:       ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:      ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:       ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_asterisk.png"
            fgImageX: 60
            fgImageY: 19

            onClickOrKeySelected: {
                btnKeypadStar.forceActiveFocus();
                dialKeyHandler("*");

                if(phoneNumInput != "" && dial_list_count != 0) {
                    if(false == btnKeypadCall.mEnabled) {
                        idVisualCue.setVisualCue(true, true, false, true)
                    } else {
                        idVisualCue.setVisualCue(true, true, true, true)
                    }
                } else {
                    if(false == btnKeypadCall.mEnabled) {
                        idVisualCue.setVisualCue(true, true, false, false)
                    } else {
                        idVisualCue.setVisualCue(true, true, true, false)
                    }
                }
            }

            onPressAndHold: {
                btnKeypadStar.forceActiveFocus();
                dialLongKeyHandler("*");

                if(phoneNumInput != "" && dial_list_count != 0) {
                    idVisualCue.setVisualCue(true, true, true, true)
                } else {
                    idVisualCue.setVisualCue(true, true, true, false)
                }
            }

            onActiveFocusChanged: {
                if(true == btnKeypadStar.activeFocus) {
                    if(phoneNumInput != "" && dial_list_count != 0) {
                        if(false == btnKeypadCall.mEnabled) {
                            idVisualCue.setVisualCue(true, true, false, true)
                        } else {
                            idVisualCue.setVisualCue(true, true, true, true)
                        }
                    } else {
                        if(false == btnKeypadCall.mEnabled) {
                            idVisualCue.setVisualCue(true, true, false, false)
                        } else {
                            idVisualCue.setVisualCue(true, true, true, false)
                        }
                    }
                }
            }

            KeyNavigation.right:    btnKeypad0
            KeyNavigation.left:     dial_list_count == 0 ? btnKeypadStar : idBtDialListView
            KeyNavigation.up:       btnKeypad7
            KeyNavigation.down:     false == btnKeypadCall.mEnabled ? btnKeypadStar : btnKeypadCall

            onUpRightKeyPressed:    btnKeypad8.focus = true
            onDownRightKeyPressed:  btnKeypadConnect.focus = true

            onWheelRightKeyPressed: btnKeypad0.focus = true
            onWheelLeftKeyPressed:  btnKeypad9.focus = true
        }

        MComp.DDDialButton {
            id: btnKeypad0
            width: 175
            height: 101

            playLongPressBeep: true

            bgImage:        ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:   ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:  ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_0.png"
            fgImageX: 60        //36 + 24
            fgImageY: 13

            firstTextX: 36
            firstTextY: 57      //13 + 62 - 18
            firstText: "+"
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextSize: 36
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.brightGrey : colorInfo.grey
            firstTextHeight: 36
            firstTextWidth: 103     //24 + 79
            firstTextPressColor: firstTextColor
            firstTextFocusColor: firstTextColor

            onClickOrKeySelected: {
                btnKeypad0.forceActiveFocus();
                dialKeyHandler("0");
            }

            onPressAndHold: {
                btnKeypad0.forceActiveFocus();
                if(BtCoreCtrl.m_ncallState > 35) {
                    MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
                } else {
                    if(7 == contact_value) {
                        dialListView = true;
                    }

                    if(phoneNumInput.length == 0) {
                        phoneNumInput = phoneNumInput + "+"
                        BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput)
                    } else if(phoneNumInput.length > 0) {
                        dialLongKeyHandler("0");
                    }
                }
            }

            onActiveFocusChanged: {
                if(true == btnKeypad0.activeFocus) {
                    idVisualCue.setVisualCue(true, true, true, true);
                }
            }

            KeyNavigation.up:       btnKeypad8;
            KeyNavigation.right:    btnKeypadSharp;
            KeyNavigation.left:     btnKeypadStar;
            KeyNavigation.down:     btnKeypadConnect;

            onUpLeftKeyPressed:     btnKeypad7.focus = true;
            onUpRightKeyPressed:    btnKeypad9.focus = true;
            onDownLeftKeyPressed:   {
                if(false == btnKeypadCall.mEnabled) {
                    btnKeypad0.focus = true
                } else {
                    btnKeypadCall.focus = true
                }
            }

            onDownRightKeyPressed: {
                if(false == btnKeypadDel.mEnabled) {
                    btnKeypad0.focus = true
                } else {
                    btnKeypadDel.focus = true
                }
            }

            onWheelRightKeyPressed: btnKeypadSharp.focus = true;
            onWheelLeftKeyPressed:  btnKeypadStar.focus = true;
        }

        MComp.DDDialButton {
            id: btnKeypadSharp
            width: 175
            height: 101

            bgImage:        ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:   ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:  ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: ImagePath.imgFolderBt_phone + "dial_num_sharp.png"
            fgImageX: 60
            fgImageY: 19

            onClickOrKeySelected: {
                btnKeypadSharp.forceActiveFocus();
                dialKeyHandler("#");

                if(0 != phoneNumInput.length) {
                    idVisualCue.setVisualCue(true, false, true, true)
                }
            }

            onPressAndHold: {
                btnKeypadSharp.forceActiveFocus();
                dialLongKeyHandler("#");

                if(0 != phoneNumInput.length) {
                    idVisualCue.setVisualCue(true, false, true, true)
                }
            }

            onActiveFocusChanged: {
                if(true == btnKeypadSharp.activeFocus) {
                    if(false == btnKeypadDel.mEnabled){
                        idVisualCue.setVisualCue(true, false, false, true)
                    } else {
                        idVisualCue.setVisualCue(true, false, true, true)
                    }
                }
            }

            KeyNavigation.up:       btnKeypad9;
            KeyNavigation.left:     btnKeypad0;
            KeyNavigation.down:     false == btnKeypadDel.mEnabled ? btnKeypadSharp : btnKeypadDel

            onUpLeftKeyPressed:     btnKeypad8.focus = true;
            onDownLeftKeyPressed:   btnKeypadConnect.focus = true;

            onWheelRightKeyPressed: {
                if(false == btnKeypadCall.mEnabled) {
                    btnKeypadConnect.focus = true;
                } else {
                    btnKeypadCall.focus = true;
                }
            }

            onWheelLeftKeyPressed:  btnKeypad0.focus = true;
        }
    }

    Row {
        // 통화, 설정, 삭제
        y: 416
        spacing: -1

        MComp.DDDialButton {
            id: btnKeypadCall
            width: 175
            height: 101

            playLongPressBeep: true

            bgImage:        ImagePath.imgFolderBt_phone + "btn_dial_call_n.png"
            bgImagePress:   ImagePath.imgFolderBt_phone + "btn_dial_call_p.png"
            bgImageActive:  ImagePath.imgFolderBt_phone + "btn_dial_call_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_dial_call_f.png"

            fgImage: mEnabled == true ? ImagePath.imgFolderBt_phone + "ico_dial_call.png" : ImagePath.imgFolderBt_phone + "ico_dial_call_d.png"
            fgImageX: 49
            fgImageY: 13

            mEnabled: (recent_nstate == 1 || phoneNumInput != "")

            onClickOrKeySelected: {
                /* 포커스를 동작 이후에 주게 되면 팝업이 뜨고 포커스 간 상태에서
                 * 다시 콜버튼에 포커스를 주기때문에 포커스가 팝업으로 가지 않고
                 * 키패드에 남아있음
                 */
                btnKeypadCall.forceActiveFocus();
                dialCallKeyHandler();

                if(phoneNumInput != "" && dial_list_count != 0) {
                    idVisualCue.setVisualCue(true, true, false, true)
                } else {
                    idVisualCue.setVisualCue(true, true, false, false)
                }
            }

            onPressAndHold: {
                if(BtCoreCtrl.m_ncallState > 9 ) {
                    /* 통화중일 경우 진입 막음
                     */
                    MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
                } else {
                    if(0 < phoneNumInput.length) {
                        BtCoreCtrl.HandleCallStart(phoneNumInput);
                        phoneNumInput = "";
                    } else {
                        var number = BtCoreCtrl.invokeTrackerGetLastOutgoing();
                        if("" == number) {
                            MOp.showPopup("popup_outgoing_calls_empty");
                        } else {
                            BtCoreCtrl.HandleCallStart(number);
                        }
                    }
                }

                if(phoneNumInput != "" && dial_list_count != 0) {
                    idVisualCue.setVisualCue(true, true, false, true)
                } else {
                    idVisualCue.setVisualCue(true, true, false, false)
                }
            }

            onActiveFocusChanged: {
                if(true == btnKeypadCall.activeFocus) {
                    if(phoneNumInput != "" && dial_list_count != 0) {
                        idVisualCue.setVisualCue(true, true, false, true);
                    } else {
                        idVisualCue.setVisualCue(true, true, false, false);
                    }

                    if(false == btnKeypadCall.mEnabled) {
                        btnKeypadConnect.forceActiveFocus();
                    }
                }
            }

            KeyNavigation.up:       btnKeypadStar
            KeyNavigation.right:    btnKeypadConnect
            KeyNavigation.left:     dial_list_count == 0 ? btnKeypadCall : idBtDialListView

            onUpRightKeyPressed:    btnKeypad0.focus = true

            onWheelRightKeyPressed: btnKeypadConnect.focus = true
            onWheelLeftKeyPressed:  btnKeypadSharp.focus = true
        }

        MComp.DDImageButton {
            id: btnKeypadConnect
            width: 175
            height: 101

            bgImage:        /* CarPlay */(true == projectionOn) ? ImagePath.imgFolderBt_phone + "btn_dial_set_d.png" : ImagePath.imgFolderBt_phone + "btn_dial_set_n.png"
            bgImagePress:   ImagePath.imgFolderBt_phone + "btn_dial_set_p.png"
            bgImageActive:  ImagePath.imgFolderBt_phone + "btn_dial_set_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_dial_set_f.png"

            fgImage:        /* CarPlay */(true == projectionOn) ? ImagePath.imgFolderBt_phone + "ico_dial_bt_set_d.png" : ImagePath.imgFolderBt_phone + "ico_dial_bt_set.png"
            fgImageX: 49
            fgImageY: 13

            onClickOrKeySelected: {
                // 설정 -> 연결설정
                if(9 < BtCoreCtrl.m_ncallState) {
                    /* 통화중일 경우 진입 막음
                     */
                    MOp.showPopup("popup_bt_invalid_during_call");
                }
                /* CarPlay */
                else if(true == projectionOn) {
                    MOp.showPopup("popup_Bt_enter_setting_during_CarPlay")
                }
                  else {
                    btSettingsEnter = false;
                    pushScreen("SettingsBtDeviceConnect", 510);
                    //DEPRECATED idBtSettingsLeft.forceActiveFocus();

                    if(true == btDeleteMode) {
                        MOp.showPopup("popup_Bt_Deleting");
                    } else {
                        if((4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                            || 10 /* CONNECT_STATE_PBAP_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                            || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState())) {
                            /* DialKeypad를 사용할 수 있는것은 HFP가 붙었다는 것을 의미함.
                             * 연결 상태가 완료 되었다면 아무런 동작 없이 Settings화면으로 진입
                             */
                        } else {
                            // 연결 중이기 때문에 연결 중 팝업을 띄운다.
                            MOp.showPopup("popup_Bt_Connecting");
                        }
                    }
                }
                callEndEvent();
            }

            onActiveFocusChanged: {
                if(true == btnKeypadConnect.activeFocus) {
                    if(false == btnKeypadDel.mEnabled) {
                        if(false == btnKeypadCall.mEnabled) {
                            idVisualCue.setVisualCue(true, false, false, false)
                        } else {
                            idVisualCue.setVisualCue(true, false, false, true)
                        }
                    } else {
                        if(false == btnKeypadCall.mEnabled) {
                            idVisualCue.setVisualCue(true, true, false, false)
                        } else {
                            idVisualCue.setVisualCue(true, true, false, true)
                        }
                    }
                }
            }

            KeyNavigation.up:       btnKeypad0
            KeyNavigation.right:    false == btnKeypadDel.mEnabled ? btnKeypadConnect : btnKeypadDel
            KeyNavigation.left:     false == btnKeypadCall.mEnabled ? btnKeypadConnect : btnKeypadCall

            onUpRightKeyPressed:    btnKeypadSharp.focus = true
            onUpLeftKeyPressed:     btnKeypadStar.focus = true

            onWheelRightKeyPressed:
            {
                if(false == btnKeypadDel.mEnabled) {
                    btnKeypad1.focus = true
                } else {
                    btnKeypadDel.focus = true
                }
            }

            onWheelLeftKeyPressed: {
                if(false == btnKeypadCall.mEnabled) {
                    btnKeypadSharp.focus = true
                } else {
                    btnKeypadCall.focus = true
                }
            }
        }

        MComp.DDDialButton {
            id: btnKeypadDel
            width: 175
            height: 101

            playLongPressBeep: false

            bgImage:        (1 == UIListener.invokeGetVehicleVariant()) ? ImagePath.imgFolderBt_phone + "btn_dial_set_n.png" : ImagePath.imgFolderBt_phone + "btn_dial_num_n.png"
            bgImagePress:   (1 == UIListener.invokeGetVehicleVariant()) ? ImagePath.imgFolderBt_phone + "btn_dial_set_p.png" : ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageActive:  (1 == UIListener.invokeGetVehicleVariant()) ? ImagePath.imgFolderBt_phone + "btn_dial_set_p.png" : ImagePath.imgFolderBt_phone + "btn_dial_num_p.png"
            bgImageFocus:   (1 == UIListener.invokeGetVehicleVariant()) ? ImagePath.imgFolderBt_phone + "btn_dial_set_f.png" : ImagePath.imgFolderBt_phone + "btn_dial_num_f.png"

            fgImage: firstTextVisible == true ? "" : mEnabled == true ? ImagePath.imgFolderBt_phone + "ico_dial_del.png" : ImagePath.imgFolderBt_phone + "ico_dial_del_d.png"
            fgImageX: 36
            fgImageY: 23

            firstText: stringInfo.str_Dial_Delete
            firstTextColor: colorInfo.brightGrey
            firstTextSize: 35
            firstTextHeight: 35
            firstTextX: 15
            firstTextY: 40 - 10
            firstTextWidth: 135
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextVisible: UIListener.invokeGetCountryVariant() == 4

            mEnabled: "" == phoneNumInput ? false : true

            onClickOrKeySelected: {
                btnKeypadDel.forceActiveFocus();
                phoneNumInput = phoneNumInput.toString().slice(0, -1);
                BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput);

                if("" == phoneNumInput) {
                    btnKeypad1.forceActiveFocus();
                }
                MOp.returnFocus();
            }

            onPressAndHold: {
                //2013.09.17 LongPress시 Focus 1로 이동하도록 수정
                if(inputMode == "touch"){
                console.log("## ~ Play Beep Sound(BtDialKeypad) ~ ##")
                UIListener.ManualBeep();
                btnKeypad1.forceActiveFocus();
                phoneNumInput = ""
                }
            }

            onActiveFocusChanged: {
                if(true == btnKeypadDel.activeFocus) {
                    idVisualCue.setVisualCue(true, false, false, true)
                }
            }

            onMEnabledChanged: {
                if(false == mEnabled && btnKeypadDel.focus == true) {
                    btnKeypadDel.focus = false
                    btnKeypad1.focus = true
                }
            }

            KeyNavigation.up:       btnKeypadSharp
            KeyNavigation.left:     btnKeypadConnect

            onUpLeftKeyPressed:     btnKeypad0.focus = true

            onWheelLeftKeyPressed:  btnKeypadConnect.focus = true
            onWheelRightKeyPressed: btnKeypad1.focus = true
        }
    }
}
/* EOF */
