/**
 * /BT/Call/Main/BtCallMain.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idCallMain
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    /* PROPERTIES */
    property int activeState: 0     // BtCoreCtrl.m_nActivatedCallPos
    property int blinkCount: 0

    //DEPRECATED property bool privateOnlyMode: false
    //DEPRECATED property bool privateOnlyModestate: false
    property bool tabListEnable: ("HoldCall" != idCallMain.state) && ("call_end_view" != idCallMain.state) && (false == BtCoreCtrl.m_bHfpPrivateOnlyMode) && ("OutgoingCall" != idCallMain.state) && (false == callPrivateMode)

    property string callDTMFDialInput: ""

    property bool firstCallStateIncoming:   (1 == BtCoreCtrl.m_ncallDirection0) ? true : false
    property bool secondCallStateIncoming:  (1 == BtCoreCtrl.m_ncallDirection1) ? true : false

    /* SIGNALS */
    signal sigBlinkingStart();
    signal sigBlinkingStop();
    signal holdCall();

    /* INTERNAL functions */
    function backKeyHandler() {
        if(true == callShowMicVolume) {
            hideMicVolume();
        } else if(true == callShowDTMF) {
            hideDTMFDial();
        } else {
            sigBlinkingStop();

            //DEPRECATED MOp.hideCallView();
/*DEPRECATED
            if(1 == callType) {
                /* 통화종료 중일때 back 키를 통해 밖으로 빠져나간 경우 바로 콜 화면을 초기화 함
                 * 통화종료 중일때 HOME -> 재진입 case에 콜화면을 다시 표시하는 로직과(onSigEventRequestFG)
                 * call type이 0으로 바뀌며 콜화면을 없애는 로직이 엉켜 콜 화면이 계속 표시되는 문제 발생함
                 *
                 * [주의] 같은 로직이 onSigEventRequestBG와 BtCallMain backKeyHandler() 2곳에 존재함
                 *

                BtCoreCtrl.m_ncallState = 0;
                BtCoreCtrl.HandleResetCallId();
                //DEPRECATED MOp.initCallView(4001);
            }
DEPRECATED*/

            //DEPRECATED if(1 == callType) {
            //DEPRECATED     BtCoreCtrl.HandleResetCallId();
            //DEPRECATED }

            //DEPRECATED MOp.postBackKey(200);
            //DEPRECATED MOp.initCallView(4002);
            // Call 화면 Back Key 동작 수정
            MOp.hideCallView();
        }
        idCallButtonGroup.forceActiveFocus();
    }

    function reload() {
        idLoaderCallBackground.reload()
        idLoaderCallBand.reload()
        idLoaderCallTab.reload()
        idLoaderCallSingle.reload()
        idLoaderCall3Way.reload()
        idLoaderCallConference.reload()
        idLoaderCallConference3Way.reload()
        idLoaderCallDTMF.reload()
        idLoaderCallMicVolume.reload()
        idLoaderCallPrivateMode.reload()
        idLoaderCallSingleButton.reload()
        idLoaderCall3WayButton.reload()
    }

    function showMicVolume() {
        if(false == idLoaderCallMicVolume.visible) {
            hideDTMFDial();

            callShowMicVolume = true;
            idLoaderCallMicVolume.show();
            idLoaderCallMicVolume.forceActiveFocus();

        }
    }

    function hideMicVolume() {
        if(true == idLoaderCallMicVolume.visible) {
            callShowMicVolume = false;
            idLoaderCallMicVolume.hide();
            if("FOREGROUND" == callViewState) {
                idLoaderCallTab.forceActiveFocus();
            }
        }
    }

    function showDTMFDial() {
        if(false == idLoaderCallDTMF.visible) {
            hideMicVolume();

            callShowDTMF = true;
            idLoaderCallDTMF.show();
            idLoaderCallDTMF.forceActiveFocus();
        }
    }

    function hideDTMFDial() {
        if(true == idLoaderCallDTMF.visible) {
            callShowDTMF = false;
            idLoaderCallDTMF.hide();

            idLoaderCallTab.forceActiveFocus();
        }
    }

    function setFocus(state) {
        switch(state) {
            case "call_end_view": {
                if(true == idLoaderCallBand.activeFocus) {
                    // BAND에서 Focus를 가지고 있을 경우 do nothing
                } else {
                    // 모두 Disable되므로 좌측 TAB의 Contact에 Focus 설정함
                    idLoaderCallSingleButton.focus = false;
                    idLoaderCall3WayButton.focus = false;
                    idLoaderCallTab.focus = true;

                    idLoaderCallTab.forceActiveFocus();
                }

                // 통화 중 연결 해제 되었을 때, 포커스 날아가는 동작 수정
                MOp.returnFocus();
                break;
            }

            case "Idle": {
                idLoaderCallTab.focus = false;
                idLoaderCall3WayButton.focus = false;
                idLoaderCallSingleButton.focus = true;
                break;
            }

            default:
                break;
        }
    }


    /* CONNECTIONS */
    Connections {
        target: idAppMain

        onSigHideMicOff: {
            // TODO: ddingddong 주석
            hideMicVolume();
        }
    }

    Connections {
        target: BtCoreCtrl

        /* 프라이빗 모드 진입 시 화면에 떠있는 모든 화면 사라지고 프라이빗으로 동작
         * 포커스 이동 동작
         */
        onPrivateModeOn: {
             qml_debug("## Signal onPrivateModeOn from Call Main");
             callPrivateMode = true;
             if(true == callShowMicVolume) {
                 hideMicVolume();
             }

             if(true == callShowDTMF) {
                 hideDTMFDial();
             }

             if("FOREGROUND" == callViewState) {
                // TODO: 정원 아래 if 문 PV1.08.01 branch와 비교 확인할 것
                if("popup_bt_not_transfer_call" == MOp.getPopupState()
                    || "popup_during_bluelink_not_transfer" == MOp.getPopupState()
                    || "popup_bt_switch_handfree" == MOp.getPopupState()
                    || "popup_bt_switch_handfreeNavi" ==  MOp.getPopupState()
                    || "popup_bluelink_popup" == popupState
                    || "Call_popup" == popupState
                    || "Call_3way_popup" == popupState
                    || "popup_Dim_For_Call" == MOp.getPopupState()) {
                    // do nothing
                } else {
                    idCallButtonGroup.forceActiveFocus();
                }
             }

             MOp.returnFocus();
         }

        onPrivateModeOff: {
            callPrivateMode = false;
            MOp.returnFocus();
        }
    }


    /* EVENT handlers */
    onActiveFocusChanged: {
        if(true == idCallMain.activeFocus) {
            if("popup_bt_not_transfer_call" == MOp.getPopupState()
                || "popup_during_bluelink_not_transfer" == MOp.getPopupState()
                || "popup_bt_switch_handfree" == MOp.getPopupState()
                || "popup_bt_switch_handfreeNavi" == MOp.getPopupState()
                || "popup_Dim_For_Call" == MOp.getPopupState()) {
                // do nothing
            } else {
                if("OutgoingCall" == idCallMain.state) {
                    idCallButtonGroup.forceActiveFocus();
                } else if(true == idLoaderCallMicVolume.activeFocus) {
                    idLoaderCallMicVolume.forceActiveFocus();
                } else if(true == idLoaderCallDTMF.activeFocus) {
                    idLoaderCallDTMF.forceActiveFocus();
                } else if(false == idLoaderCallTab.activeFocus) {
                    if("CallStart" == idCallMain.state) {
                        idCallButtonGroup.forceActiveFocus();
                    } else if("3WayCallStartCall" == idCallMain.state) {
                        idCallButtonGroup.forceActiveFocus();
                    }
                }
            }
        }
    }


    /* STATE */
    state: {
        if(BtCoreCtrl.m_ncallState == 1) {
            "call_end_view"
        } else if(BtCoreCtrl.m_ncallState == 10) {
            if(BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                "bluelink_incomingCall"
            } else {
                "incoming_call_view"
            }
        } else if(BtCoreCtrl.m_ncallState == 20) {
            "OutgoingCall"
        } else if(BtCoreCtrl.m_ncallState == 21) {
            // virtual outgoing state
            "OutgoingCall"
        } else if(BtCoreCtrl.m_ncallState == 30) {
            "HoldCall"
        } else if(BtCoreCtrl.m_ncallState == 31) {
            "CallStart"
        } else if(BtCoreCtrl.m_ncallState == 40 || BtCoreCtrl.m_ncallState == 41) {
            "3WayCallIncomingCall"
        } else if(BtCoreCtrl.m_ncallState == 50 || BtCoreCtrl.m_ncallState == 51) {
            "3WayCallOutgoingCall"
        } else if(BtCoreCtrl.m_ncallState == 61) {
            "3WayCallStartCall"
        } else if(BtCoreCtrl.m_ncallState == 91 || BtCoreCtrl.m_ncallState == 92
                  || BtCoreCtrl.m_ncallState == 121|| BtCoreCtrl.m_ncallState == 123
                  || BtCoreCtrl.m_ncallState == 151|| BtCoreCtrl.m_ncallState == 154
                  || BtCoreCtrl.m_ncallState == 181|| BtCoreCtrl.m_ncallState == 185
                  || BtCoreCtrl.m_ncallState == 211|| BtCoreCtrl.m_ncallState == 216
                  || BtCoreCtrl.m_ncallState == 241|| BtCoreCtrl.m_ncallState == 247 ) {
            "3way_conference_call"
        } else if(BtCoreCtrl.m_ncallState == 60 ||BtCoreCtrl.m_ncallState == 62) {
            if(0 < BtCoreCtrl.m_nMultiPartyCallCount0) {
                "one_way_conference_call"
            } else {
                "3WayCallStartCall"
            }
        } else if(BtCoreCtrl.m_ncallState == 90 || BtCoreCtrl.m_ncallState == 93
                  || BtCoreCtrl.m_ncallState == 120 || BtCoreCtrl.m_ncallState == 124
                  || BtCoreCtrl.m_ncallState == 150 || BtCoreCtrl.m_ncallState == 155
                  || BtCoreCtrl.m_ncallState == 180 || BtCoreCtrl.m_ncallState == 186
                  || BtCoreCtrl.m_ncallState == 210 || BtCoreCtrl.m_ncallState == 217
                  || BtCoreCtrl.m_ncallState == 240 || BtCoreCtrl.m_ncallState == 248
                  || BtCoreCtrl.m_ncallState == 270 || BtCoreCtrl.m_ncallState == 279) {
            "one_way_conference_call"
        } else if(BtCoreCtrl.m_ncallState == 70 || BtCoreCtrl.m_ncallState == 72
                  || BtCoreCtrl.m_ncallState == 100 || BtCoreCtrl.m_ncallState == 103
                  || BtCoreCtrl.m_ncallState == 130 || BtCoreCtrl.m_ncallState == 134
                  || BtCoreCtrl.m_ncallState == 160 || BtCoreCtrl.m_ncallState == 165
                  || BtCoreCtrl.m_ncallState == 190 || BtCoreCtrl.m_ncallState == 196
                  || BtCoreCtrl.m_ncallState == 220 || BtCoreCtrl.m_ncallState == 227
                  || BtCoreCtrl.m_ncallState == 250 || BtCoreCtrl.m_ncallState == 258) {
            "3way_conference_incomcall"
        } else if(BtCoreCtrl.m_ncallState == 80 || BtCoreCtrl.m_ncallState == 82
                  || BtCoreCtrl.m_ncallState == 110 || BtCoreCtrl.m_ncallState == 113
                  || BtCoreCtrl.m_ncallState == 140 || BtCoreCtrl.m_ncallState == 144
                  || BtCoreCtrl.m_ncallState == 170 || BtCoreCtrl.m_ncallState == 175
                  || BtCoreCtrl.m_ncallState == 200 || BtCoreCtrl.m_ncallState == 206
                  || BtCoreCtrl.m_ncallState == 230 || BtCoreCtrl.m_ncallState == 237
                  || BtCoreCtrl.m_ncallState == 260 || BtCoreCtrl.m_ncallState == 268) {
            "3way_conference_outgoingcall"
        } else {
            "Idle"
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        // 포커스 동작이 없고 항상 표시 되어야 하는 부분은 처음 Loading 되었을 때 visible true 설정
        idLoaderCallBackground.show();
        idLoaderCallTab.show();
        idLoaderCallBand.show();
        idLoaderCallSingleButton.show();
    }

    Component.onDestruction: {
    }

    onBackKeyPressed: {
        idCallMain.backKeyHandler();
    }

    onStateChanged: {
        switch(idCallMain.state) {
            case "Idle": {
                setFocus(idCallMain.state);

                if("popup_Bt_Disconnect_By_Phone" == popupState
                        || "popup_Bt_Dis_Connecting" == popupState
                        || "popup_bluelink_popup_Outgoing_Call" == popupState
                        ) {
                    // do nothing
                    /* 연결이 먼저 끊어지고 이 후 CallViewState 초기화가 되기 때문에
                     * 팝업을 띄우고 바로 사라지는 문제 예외처리
                     */
                } else {
                    if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode() && "popup_Contact_Change" == popupState) {
                        // 백그라운드 다운로드 상태면 전화번호부 업데이트 팝업을 유지한다.
                    } else {
                        MOp.hidePopup();
                    }
                }

                callDTMFDialInput = "";     // DTMF
                phoneNumInput = "";         // Dial

                //callShowMicVolume = false;
                //callShowDTMF = false;
                hideMicVolume();
                hideDTMFDial();

                /* 다운로드 중 통화 시도 > 다운로드 완료 이후 통화 종료 될 때
                 * 무한 다운로드 화면 발생하는 부분
                 */
                if(1 > UIListener.invokeGetScreenSize()) {
                    if(lastView == "BtInfoView") {
                        if(1 == contact_nstate) {
                            if("BAND_PHONEBOOK" == selectedBand) {
                                lastView = "BtContactMain"
                            }
                        }

                    // 전화화면으로 진입했는데 이전화면이 세팅으로 남아있는 경우 이전화면 초기화
                    } /*else if (btPhoneEnter == false
                               && (lastView == "SettingsBtDeviceConnect"
                                   || lastView == "BtDeviceDelMain"
                                   || lastView == "SettingsBtAutoConn"
                                   || lastView == "SettingsBtAutoDown"
                                   || lastView == "SettingsBtAudioStream"
                                   || lastView == "SettingsBtDeviceName"
                                   || lastView == "SettingsBtNameChange"
                                   || lastView == "SettingsBtPINCodeChange"
                                   || lastView == "SettingsBtCustomer")
                               ) {
                        lastView = ""
                    }*/

                    pushScreen(lastView)
                    MOp.returnFocus();
                }

                /* 통화 종료 후 이전화면을 확인하여 주행규제가 필요한 화면이라면
                 * 주행규제 팝업을 출력하도록 수정
                 */
                if(false == parking && (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
                    if("BtContactSearchMain" == idAppMain.state || "SettingsBtNameChange" == idAppMain.state || "SettingsBtPINCodeChange" == idAppMain.state){
                        MOp.showPopup("popup_search_while_driving");
                    }
                }

                break;
            }

            case "call_end_view": {
                if("popup_Bt_Disconnect_By_Phone" == popupState
                        || "popup_Bt_Dis_Connecting" == popupState
                        || "popup_bluelink_popup_Outgoing_Call" == popupState
                        || "popup_enter_setting_during_call" == popupState
                        ) {
                    // do nothing
                    /* 연결이 먼저 끊어지고 이 후 CallViewState 초기화가 되기 때문에
                     * 팝업을 띄우고 바로 사라지는 문제 예외처리
                     */
                //__IQS_15MY__ Call End Modify     
                } else if(true == iqs_15My && ("popup_bt_switch_handfree" == MOp.getPopupState()
                         || "popup_bt_switch_handfreeNavi" == MOp.getPopupState())) {
                    BtCoreCtrl.invokeCallFordPatentPopup(false);
                } else {
                    if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode() && "popup_Contact_Change" == popupState) {
                        // 백그라운드 다운로드 상태면 전화번호부 업데이트 팝업을 유지한다.
                    } else {
                        MOp.hidePopup();
                    }
                }

                if(true == BtCoreCtrl.m_handsfreeMicMute) {
                    // MIC mute 해제
                    BtCoreCtrl.invokeHandsfreeSetMicMute(false);
                }

                if(true == gContactFromCall) {
                    MOp.reshowCallView(8005);
                }
                
                //gContactFromCall = false;

                // 통화 종료 화면에서 바로 전화 거는 경우 DTMF 초기화 안되는 문제 수정
                callDTMFDialInput = "";     // DTMF

                hideMicVolume();
                hideDTMFDial();

                if("FOREGROUND" == callViewState) {
                    // 콜화면이 보여지고 있다면 통화시간 blinking

                    // Start blinking && "통화 종료" 포커스 이동
                    sigBlinkingStart();

                } else {
                    // 콜화면이 보여지고 있지 않다면 바로 종료함

                    //DEPRECATED BtCoreCtrl.m_ncallState = 0;
                    //DEPRECATED BtCoreCtrl.HandleResetCallId();
                    BtCoreCtrl.invokeCallStateChange(0);
                }

                idCallMain.setFocus(idCallMain.state);
                callEndEvent();
                break;
            }

            case "bluelink_incomingCall":
                MOp.showPopup("popup_bluelink_popup");
                break;

            case "incoming_call_view":
                MOp.showPopup("Call_popup");
                break;

            case "3way_conference_incomcall":
                MOp.showPopup("Call_3way_popup");
                break;

            case "3WayCallIncomingCall":
                MOp.showPopup("Call_3way_popup");
                break;

            default: {
                if("popup_Bt_Disconnect_By_Phone" == popupState
                    || "popup_Bt_Dis_Connecting" == popupState
                    || "popup_bt_switch_handfree" == MOp.getPopupState()
                    || "popup_bt_switch_handfreeNavi" == MOp.getPopupState()
                    || "popup_bluelink_popup_Outgoing_Call" == popupState
                    || "popup_enter_setting_during_call" == popupState
                    || "popup_Dim_For_Call" == MOp.getPopupState())
                {
                    // do nothing
                    /* 연결이 먼저 끊어지고 이 후 CallViewState 초기화가 되기 때문에
                     * 팝업을 띄우고 바로 사라지는 문제 예외처리
                     */
                } else {
                    if("HoldCall" == idCallMain.state) {
                        holdCall();
                    }
                    //[ITS 235447], [ITS 0235452], [ITS 235461] Add condition. in case of manual phonebook download in Call state..
                    if("popup_redownload" == popupState && "BACKGROUND" == callViewState) {
                        /* nothing */
                    }
                    else {
                        if("popup_Bt_State_Calling_No_OutCall" != textPopupName) {
                            MOp.hidePopup();
                        }
                    }

                    if("OutgoingCall" == idCallMain.state) {
                        // Stop blinking
                        sigBlinkingStop();
                    }

                    if("FOREGROUND" == callViewState) {
                        // 콜 화면이 표시되지 않을때 포커스 이동 방지
                        if("OutgoingCall" == idCallMain.state) {
                            idCallButtonGroup.forceActiveFocus();
                        } else if(false == idLoaderCallTab.activeFocus) {
                            if("CallStart" == idCallMain.state) {
                                idCallButtonGroup.forceActiveFocus();
                            } else if("3WayCallStartCall" == idCallMain.state) {
                                idCallButtonGroup.forceActiveFocus();
                            }
                        }
                    }

                    MOp.returnFocus();
                }
                break;
            }
        }
    }


    /* WIDGETS */
    Rectangle {
        anchors.fill: parent
        color: "Black"
    }

    MouseArea {
        beepEnabled: false
        anchors.fill: parent
    }

    MComp.DDLoader {
        id: idLoaderCallBackground
        x: 9
        y: 81
        width: 1260
        height: 538

        sourcePath: "../../BT/Call/BtCallBackground.qml"
        arabicSourcePath: "../../BT_arabic/Call/BtCallBackground.qml"
    }

    MComp.DDLoader {
        id: idLoaderCallBand
        x: 0
        y: 0
        visible: false

        sourcePath: "../../BT/Call/BtCallBand.qml"
        arabicSourcePath: "../../BT_arabic/Call/BtCallBand.qml"

        KeyNavigation.down: {
            callMainView
//            if(true == callShowMicVolume) {
//                idLoaderCallMicVolume
//            } else if (true == callShowDTMF) {
//                idLoaderCallDTMF
//            } else {
//                callMainView
//            }
        }
    }

    FocusScope {
        id: callMainView
        MComp.DDLoader {
            id: idLoaderCallTab
            x: (20 != gLanguage) ? 16 : 9 + 928
            y: 89
            visible: false

            sourcePath: "../../BT/Call/BtCallTabList.qml"
            arabicSourcePath: "../../BT_arabic/Call/BtCallTabList.qml"

            naviRight: {
                if(2 > BtCoreCtrl.m_ncallState) {
                    // 통화종료 중이라면 오른쪽으로 이동 없음
                    idLoaderCallTab
                } else {
                    if(true == callShowDTMF) {
                        idLoaderCallDTMF
                    } else if(true == callShowMicVolume && false == BtCoreCtrl.m_handsfreeMicMute) {
                        idLoaderCallMicVolume
                    } else {
                        idCallButtonGroup
                    }
                }
            }

            KeyNavigation.up: idLoaderCallBand
        }

        MComp.DDLoader {
            id: idLoaderCallSingle
            x: (20 != gLanguage) ? 442 : 0
            y: 213
            width: 787
            height: 195
            visible: false

            sourcePath: "../../BT/Call/BtCallSingle.qml"
            arabicSourcePath: "../../BT_arabic/Call/BtCallSingle.qml"
        }

        MComp.DDLoader {
            id: idLoaderCall3Way
            x: (20 != gLanguage) ? 385 : 0
            y: 104
            width: 848
            height: 195
            visible: false

            sourcePath: "../../BT/Call/BtCall3Way.qml"
            arabicSourcePath: "../../BT_arabic/Call/BtCall3Way.qml"
        }

        MComp.DDLoader {
            id: idLoaderCallConference
            x: (20 != gLanguage) ? 442 : 0
            y: 213
            visible: false

            sourcePath: "../../BT/Call/BtCallConference.qml"
            arabicSourcePath: "../../BT_arabic/Call/BtCallConference.qml"
        }

        MComp.DDLoader {
            id: idLoaderCallConference3Way
            x: (20 != gLanguage) ? 385 : 0
            y: 104
            width: 848
            height: 383
            visible: false

            sourcePath: "../../BT/Call/BtCallConference3Way.qml"
            arabicSourcePath: "../../BT_arabic/Call/BtCallConference3Way.qml"
        }

        MComp.DDLoader {
            id: idLoaderCallDTMF
            x: (20 != gLanguage) ? 386 : 49
            y: 111
            visible: false

            sourcePath: "../../BT/Call/BtCallDTMF.qml"
            arabicSourcePath: "../../BT_arabic/Call/BtCallDTMF.qml"

            KeyNavigation.up: idLoaderCallBand
            KeyNavigation.down: idCallButtonGroup
            naviLeft: idLoaderCallTab
        }

        MComp.DDLoader {
            id: idLoaderCallMicVolume
            x: (20 != gLanguage) ? 386 : 49
            y: 105
            visible: false

            sourcePath: "../../BT/Call/BtCallMicVolume.qml"
            arabicSourcePath: "../../BT_arabic/Call/BtCallMicVolume.qml"

            KeyNavigation.up: idLoaderCallBand
            KeyNavigation.down: idCallButtonGroup
            naviLeft: idLoaderCallTab
        }

        MComp.DDLoader {
            id: idLoaderCallPrivateMode
            x: (20 != gLanguage) ? 442 : 0
            y: 132 + 81
            //__IQS_15MY__ Call End Modify
            visible: (false == iqs_15My) ? (callPrivateMode && "OutgoingCall" != idCallMain.state) : (callPrivateMode && "OutgoingCall" != idCallMain.state && "call_end_view" != idCallMain.state)

            sourcePath: "../../BT/Call/BtCallPrivateMode.qml"
            arabicSourcePath: "../../BT_arabic/Call/BtCallPrivateMode.qml"
        }


        FocusScope {
            id: idCallButtonGroup
            y: 492
            focus: true

            MComp.DDLoader {
                id: idLoaderCallSingleButton
                x: (20 != gLanguage) ? 385 : 48
                visible: false
                focus: false

                sourcePath: "../../BT/Call/BtCallSingleButton.qml"
                arabicSourcePath: "../../BT_arabic/Call/BtCallSingleButton.qml"

                naviLeft: idLoaderCallTab
            }

            MComp.DDLoader {
                id: idLoaderCall3WayButton
                x: (20 != gLanguage) ? 365 : 33
                visible: false
                focus: false

                sourcePath: "../../BT/Call/BtCall3WayButton.qml"
                arabicSourcePath: "../../BT_arabic/Call/BtCall3WayButton.qml"

                naviLeft: idLoaderCallTab
            }

            MComp.DDLoader {
                id: idLoaderCall3WayPrivateButton
                x: (20 != gLanguage) ? 385 : 48
                visible: false
                focus: false

                sourcePath: "../../BT/Call/BtCall3WayPrivateButton.qml"
                arabicSourcePath: "../../BT_arabic/Call/BtCall3WayPrivateButton.qml"

                naviLeft: idLoaderCallTab
            }

            MComp.DDLoader {
                id: idLoaderCallHoldCallButton
                x: (20 != gLanguage) ? 365 : 33
                visible: false
                focus: false

                sourcePath: "../../BT/Call/BtCallHoldCallButton.qml"
                arabicSourcePath: "../../BT_arabic/Call/BtCallHoldCallButton.qml"

                naviLeft: idLoaderCallTab
            }

            KeyNavigation.up: {
                if(true == callShowDTMF) {
                    idLoaderCallDTMF
                } else if(true == callShowMicVolume && false == BtCoreCtrl.m_handsfreeMicMute) {
                    idLoaderCallMicVolume
                } else {
                    idLoaderCallBand
                }
            }
            }
    }


    /* STATE */
    states: [
        State {
            name: "call_end_view"
            PropertyChanges { target: idLoaderCallSingle;           visible: true  }
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: true;  focus: true  }
            PropertyChanges { target: idLoaderCall3WayButton;       visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: false; focus: false }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "bluelink_incomingCall"
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayButton;       visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: false; focus: false }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "incoming_call_view"
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayButton;       visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: false; focus: false }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "OutgoingCall"
            PropertyChanges { target: idLoaderCallSingle;           visible: true  }
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: true;  focus: true  }
            PropertyChanges { target: idLoaderCall3WayButton;       visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: false; focus: false }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "CallStart"
            PropertyChanges { target: idLoaderCallSingle;           visible: true  }
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: true;  focus: true }
            PropertyChanges { target: idLoaderCall3WayButton;       visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: false; focus: false }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "HoldCall"
            PropertyChanges { target: idLoaderCallSingle;           visible: true  }
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayButton;       visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: false; focus: false }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: true;  focus: true }
        }
        , State {
            name: "3WayCallIncomingCall"
            PropertyChanges { target: idLoaderCallSingle;           visible: false }
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayButton;       visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: false; focus: false }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "one_way_conference_call"
            PropertyChanges { target: idLoaderCallSingle;           visible: false }
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: true  }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: true;  focus: true }
            PropertyChanges { target: idLoaderCall3WayButton;       visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: false; focus: false }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "3WayCallOutgoingCall"
            PropertyChanges { target: idLoaderCallSingle;           visible: false }
            PropertyChanges { target: idLoaderCall3Way;             visible: true  }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: false; focus: false }
            PropertyChanges {
                target: idLoaderCall3WayButton;
                visible: callPrivateMode ? false : true
                focus: callPrivateMode ? false : true
            }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: callPrivateMode; focus: callPrivateMode }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "3WayCallStartCall"
            PropertyChanges { target: idLoaderCallSingle;           visible: false }
            PropertyChanges { target: idLoaderCall3Way;             visible: true  }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: false; focus: false }
            PropertyChanges {
                target: idLoaderCall3WayButton;
                visible: callPrivateMode ? false : true
                focus: callPrivateMode ? false : true
            }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: callPrivateMode; focus: callPrivateMode }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "3way_conference_incomcall"
            PropertyChanges { target: idLoaderCallSingle;           visible: false }
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayButton;       visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: false; focus: false }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "3way_conference_outgoingcall"
            PropertyChanges { target: idLoaderCallSingle;           visible: false }
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: true  }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: false; focus: false }
            PropertyChanges {
                target: idLoaderCall3WayButton;
                visible: callPrivateMode ? false : true
                focus: callPrivateMode ? false : true
            }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: callPrivateMode; focus: callPrivateMode }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "3way_conference_call"
            PropertyChanges { target: idLoaderCallSingle;           visible: false }
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: true  }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: false; focus: false }
            PropertyChanges {
                target: idLoaderCall3WayButton;
                visible: callPrivateMode ? false : true
                focus: callPrivateMode ? false : true
            }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: callPrivateMode; focus: callPrivateMode }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
        , State {
            name: "Idle"
            PropertyChanges { target: idLoaderCallSingle;           visible: false }
            PropertyChanges { target: idLoaderCall3Way;             visible: false }
            PropertyChanges { target: idLoaderCallConference;       visible: false }
            PropertyChanges { target: idLoaderCallConference3Way;   visible: false }
            PropertyChanges { target: idLoaderCallSingleButton;     visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayButton;       visible: false; focus: false }
            PropertyChanges { target: idLoaderCall3WayPrivateButton;visible: false; focus: false }
            PropertyChanges { target: idLoaderCallHoldCallButton;   visible: false; focus: false }
        }
    ]
}
/* EOF */
