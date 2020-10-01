/**
 * /BT/Call/BtCallTabList.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idCallTabList
    x: 0
    y: 0
    width: 325
    height: 538
    focus: true


    /* INTERNAL functions */
    function initFocus(number) {
        //btcalltablist.setFocus(0);
        console.log("initFocus = " + number)
    }

    function setinitFocus() {
        btnContact.focus = true;
        btnOutgoing.focus = false;
        btnMute.focus = false;
        btnKeyPad.focus = false;
    }

    function setFocus(index) {
        switch(index) {
            case 0: btnContact.forceActiveFocus();  break;
            case 1: btnOutgoing.forceActiveFocus(); break;
            case 2: btnMute.forceActiveFocus();     break;
            case 3: btnKeyPad.forceActiveFocus();   break;

            default:
                console.log("# invalid focus index = " + index);
                break;
        }
    }

    function getFocus() {
        if(true == btnContact.activeFocus) {
            return 0;
        } else if(true == btnOutgoing.activeFocus) {
            return 1;
        } else if(true == btnMute.activeFocus) {
            return 2;
        } else if(true == btnKeyPad.activeFocus) {
            return 3;
        } else {
            console.log("# invalid focus index");
            return -1;
        }
    }

    /* CONNECTIONS */
    Connections {
        target: BtCoreCtrl

        onPrivateModeOn: {
            setinitFocus();
        }
    }

    Connections {
        target: idCallMain

        onSigBlinkingStart: {
            if(true == parent.visible) {
                btnContact.forceActiveFocus();
            }
        }

        onHoldCall: {
            setinitFocus();
        }
    }
    
    
    /* WIDGETS */
    MComp.MButton {
        id: btnContact
        width: 325
        height: 131
        focus: true
        // 발신 통화 시 좌측 리스트 버튼 Disable
        mEnabled: true

        bgImage: ""
        bgImagePress:   ImagePath.imgFolderBt_phone + "bg_call_tab_01_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "bg_call_tab_01_f.png"

        firstText: stringInfo.str_Bt_Call_Phonebook
        firstTextX: 27
        firstTextY: 49
        firstTextWidth: 236
        firstTextHeight: 32
        firstTextSize: 32
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
        firstTextElide: "Right"
        firstTextColor: colorInfo.brightGrey    //(idCallMain.state == "call_end_view") ? colorInfo.disableGrey : colorInfo.brightGrey
        firstTextAlies: "Left"

        onClickOrKeySelected: {
            console.log("#########################################");
            console.log("# callTabList contact = " + BtCoreCtrl.m_ncallState);
            console.log("#########################################");
            btnContact.forceActiveFocus();

            /* 전화번호부로 화면전환
             * 밑에 있는 전화번호부 화면을 제거하고 새 전화번호부를 push
             */
                //__IQS_15MY_ Call End Modify)
                if(1 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                /* 통화중 전화번호부로 전환한 경우 back-key를 통해 다시 통화화면으로 돌아올 수 있어야 함
                 */
                gContactFromCall = true;
                favoriteAdd = ""
            } else {
                /* 이미 통화가 종료되어 통화시간이 Blinking되고 있는 동안은 통화가 끊어진 것으로 간주하고
                 * 전화번호부 화면에서 back-key를 통해 통화화면으로 다시 돌아올수 없도록 함
                 */
                //DEPRECATED gContactFromCall = false;
            }

            //DEPRECATED btnContact.focus = true;
            contactSearchInput = ""
            MOp.dragdownCallView();
            clickedContactsCallView();
        }

        onWheelRightKeyPressed: {
            if(true == tabListEnable) {
                if(true == btnOutgoing.mEnabled) {
                    btnOutgoing.forceActiveFocus();
                } else {
                    btnMute.forceActiveFocus();
                }
            }
        }
    }

    MComp.MButton {
        id: btnOutgoing
        y: 131
        width: 325
        height: 131
        active: callShowMicVolume
        // 발신 통화 시 좌측 리스트 버튼 Disable
        mEnabled: tabListEnable && false == BtCoreCtrl.m_handsfreeMicMute

        bgImagePress:   ImagePath.imgFolderBt_phone + "bg_call_tab_02_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "bg_call_tab_02_f.png"

        Text {
            id: textMicVol
            text: stringInfo.str_Btn_Mic_Vol
            x: 27
            // anchors.left: textMicOffNumber.right
            // anchors.leftMargin: 8
            y: 40
            height: 32
            width: 200
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            lineHeight: 0.7
            //elide: Text.ElideRight
            color: {
                /* 마이크 음량 버튼 선택 시 파란색 글씨 출력
                 * 통화 종료 시 마이크 음량 비활성화
                 */
                if(idCallMain.state == "call_end_view" || false == btnOutgoing.mEnabled) {
                    colorInfo.disableGrey
                } else if(true == callShowMicVolume) {
                    colorInfo.bandBlue
                } else {
                    colorInfo.brightGrey
                }
            }
        }

        /* 마이크 음량 버튼에 포커스가 위치한 경우 글씨 색상 Bright Grey 색상 적용
         * 기존 Text에서 ActiveFocus 체크가 안되어, 포커스 Text 추가
         */
        Text {
            id: textMicVolFocus
            text: stringInfo.str_Btn_Mic_Vol
            x: 27
            // anchors.left: textMicOffNumber.right
            // anchors.leftMargin: 8
            y: 40
            height: 32
            width: 200
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            lineHeight: 0.7
            color: colorInfo.brightGrey
            visible: (true == btnOutgoing.activeFocus) ? true : false
            //elide: Text.ElideRight
        }

        Text {
            id: textMicOffNumber
            text: ": "  + BtCoreCtrl.m_handsfreeMicVolume;
            x: 27 + textMicVolFocus.paintedWidth + 8
            //anchors.left: textMicVol.right
            //anchors.leftMargin: 8
            y: 49
            height: 32
            width: 57
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            //elide: Text.ElideRight
            color: {
                /* 마이크 음량 버튼 선택 시 파란색 글씨 출력
                 * 통화 종료 시 마이크 음량 비활성화
                 */
                if(idCallMain.state == "call_end_view" || false == btnOutgoing.mEnabled) {
                    colorInfo.disableGrey
                } else if(true == callShowMicVolume) {
                    colorInfo.bandBlue
                } else {
                    colorInfo.brightGrey
                }
            }
        }

        /* 마이크 음량 버튼에 포커스가 위치한 경우 글씨 색상 Bright Grey 색상 적용
         * 기존 Text에서 ActiveFocus 체크가 안되어, 포커스 Text 추가
         */
        Text {
            id: textMicOffNumberFocus
            text: ": "  + BtCoreCtrl.m_handsfreeMicVolume;
            x: 27 + textMicVolFocus.paintedWidth + 8
            //anchors.left: textMicVol.right
            //anchors.leftMargin: 8
            y: 49
            height:32
            width: 57
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            //elide: Text.ElideRight
            color: colorInfo.brightGrey
            visible: (true == btnOutgoing.activeFocus) ? true : false
        }

        onClickOrKeySelected: {
            //버튼 선택 시 포커스 가지도록 수정
            btnOutgoing.forceActiveFocus();

            if(true == callShowMicVolume) {
                idCallMain.hideMicVolume();
            } else {
                idCallMain.showMicVolume();
            }
        }

        /* 마이크 볼륨 조절 버튼 화살표 추가
         */
        Image {
            source: {
                if(idCallMain.state == "call_end_view" || false == btnOutgoing.mEnabled) {
                    ImagePath.imgFolderBt_phone + "ico_call_menu_arw_d.png"
                } else if(true == callShowMicVolume && false == btnOutgoing.activeFocus) {
                    ImagePath.imgFolderBt_phone + "ico_call_menu_arw_s.png"
                } else {
                    ImagePath.imgFolderBt_phone + "ico_call_menu_arw_n.png"
                }
            }

            x: 272
            y: 49
            width: 30
            height: 30
        }

        onWheelLeftKeyPressed:  btnContact.forceActiveFocus()
        onWheelRightKeyPressed: btnMute.forceActiveFocus()
    }

    MComp.MButton {
        id: btnMute
        y: 262
        width: 325
        height: 131
        // 발신 통화 시 좌측 리스트 버튼 Disable
        mEnabled: tabListEnable
        active: (true == BtCoreCtrl.m_handsfreeMicMute) ? true : false

        bgImage: ""
        bgImagePress: ImagePath.imgFolderBt_phone + "bg_call_tab_03_p.png"
        bgImageFocus: ImagePath.imgFolderBt_phone + "bg_call_tab_03_f.png"

        onWheelLeftKeyPressed:  (true == btnOutgoing.mEnabled) ? btnOutgoing.forceActiveFocus() : btnContact.forceActiveFocus()
        onWheelRightKeyPressed: btnKeyPad.forceActiveFocus()

        /* 음소거 아이콘 위치 수정*/
        Text {
            id: textMicOff
            text:(true == BtCoreCtrl.m_handsfreeMicMute)
                 ? stringInfo.str_Mic_On : stringInfo.str_Mic_Off
            x: 27
            y: 40
            height: 32
            width: 231 < hidenText.paintedWidth ? 232 : hidenText.paintedWidth
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            lineHeight: 0.7
            //elide: Text.ElideRight
            color: (true == tabListEnable) ? colorInfo.brightGrey : colorInfo.disableGrey;
        }

        Text {
            id: hidenText
            text: (true == BtCoreCtrl.m_handsfreeMicMute)
                  ? stringInfo.str_Mic_On : stringInfo.str_Mic_Off
            x: 27
            y: 49
            height:32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            visible: false
        }

        Image {
            id: micMuteIcon
            source: ImagePath.imgFolderBt_phone + "ico_mic_on.png"
            x: (17 == gLanguage)? 190 : (14 == gLanguage)? 225 : textMicOff.width + 30
            y: 43
            visible: (true == BtCoreCtrl.m_handsfreeMicMute) ? true : false

            onVisibleChanged: {
                if(true == micMuteIcon.visible) {
                    idCallMain.hideMicVolume();

                    // Mute 선택 시 마이크 음량 버튼에 포커스가 있는 경우 포커스 위치 수정 하도록 수정
                    if(true == btnOutgoing.activeFocus) {
                        setinitFocus();
                    }
                }
            }
        }

        onClickOrKeySelected: {
            /// 마이크 끄기 선택 시 마이크 화면 내림
            idCallMain.hideMicVolume();

            if(true == BtCoreCtrl.m_handsfreeMicMute) {
                BtCoreCtrl.invokeHandsfreeSetMicMute(false);
            } else {
                BtCoreCtrl.invokeHandsfreeSetMicMute(true);
            }

            btnMute.forceActiveFocus();
        }
    }

    MComp.MButton {
        id: btnKeyPad
        y: 393
        width: 325
        height: 131
        // 발신 통화 시 좌측 리스트 버튼 Disable
        mEnabled: tabListEnable        //idCallMain.state != "call_end_view" && callPrivateMode == false && idCallMain.state != "OutgoingCall"
        active: callShowDTMF

        bgImage: ""
        bgImagePress:   ImagePath.imgFolderBt_phone + "bg_call_tab_04_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "bg_call_tab_04_f.png"

        firstText: stringInfo.str_Keypad
        firstTextX: 27
        firstTextY: 45
        firstTextWidth: 236
        firstTextHeight: 32
        firstTextSize: 32
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"\
        firstTextAlies: "Left"
        firstTextElide: ""
        firstTextColor: {
            if(false == tabListEnable) {
                colorInfo.disableGrey
            } else if(true == callShowDTMF) {
                colorInfo.bandBlue
            } else {
                colorInfo.brightGrey
            }
        }
        firstTextPressColor: (true == tabListEnable && true == callShowDTMF && false == btnKeyPad.activeFocus) ? colorInfo.bandBlue : colorInfo.brightGrey
        firstTextClip: false
        firstTextLineHeight: 0.7

        onClickOrKeySelected: {
            if(callShowDTMF == false) {
                callDTMFDialInput = ""
            }

            //버튼 선택 시 포커스 가지도록 수정
            btnKeyPad.forceActiveFocus();

            // toggle DTMF dial
            if(true == callShowDTMF) {
                hideDTMFDial();
            } else {
                showDTMFDial();
            }
        }

        Image {
            source: {
                if(idCallMain.state == "call_end_view" || false == btnKeyPad.mEnabled) {
                    ImagePath.imgFolderBt_phone + "ico_call_menu_arw_d.png"
                } else if(true == callShowDTMF && false == btnKeyPad.activeFocus) {
                    ImagePath.imgFolderBt_phone + "ico_call_menu_arw_s.png"
                } else {
                    ImagePath.imgFolderBt_phone + "ico_call_menu_arw_n.png"
                }
            }
            x: 272
            y: 49
            width: 30
            height: 30
        }

        onWheelLeftKeyPressed: {
            btnMute.forceActiveFocus();
        }
    }
}
/* EOF */
