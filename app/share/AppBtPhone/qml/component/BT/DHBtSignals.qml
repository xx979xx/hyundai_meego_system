/**
 * DHBSignals.qml
 *
 */
import QtQuick 1.1
import "./Common/Javascript/operation.js" as MOp


Item
{
    id: idConnections

    /* BtCoreCtrl connections
     */
    Connections {
        target: BtCoreCtrl

        onBluetoothDisConnectCancel: {
            qml_debug("Signal : onBluetoothDisConnectCancel")
            MOp.hidePopup();
            MOp.postBackKey(300);
        }

/*DEPRECATED
        onBluetoothServiceChangedOk: {
            qml_debug("Signal : onBluetoothServiceChangedOk")
            btSevice = BtCoreCtrl.invokeGetServiceState()
            qml_debug("1. btSevice : " + btSevice)
            qml_debug("2. UIListener.invokeGetServiceState() : " + UIListener.invokeGetServiceState())
        }

        onBluetoothServiceChangedNG: {
            btSevice = BtCoreCtrl.invokeGetServiceState()
            qml_debug("Signal : onBluetoothServiceChangedNG")
        }
DEPRECATED*/

        onSigMoveToPhonebook: {
            // 최근통화에서 폰북으로 이동할 Index를 전달
            qml_debug("onSignalMoveToPhonebook")
            qml_debug("index :" + index)

            //MOp.hidePopup();

            switchScreen("BtContactMain", false, 137);
            phonebookSearch(index);
        }

        onBluetoothConnectionNothing: {
            if(false == btSettingsEnter) {
                MOp.hidePopup();
            } else {
                MOp.postBackKey(500);
            }
        }

        onInvalidBTModuleVersion: {
            qml_debug("## Signal : onInvalidBTModuleVersion")
//TEMP
            //testPopup = true;
//TEMP
        }
    }

    /* UIListener connections
     */
    Connections {
        target: UIListener

        onSigBluetoothInitializePairedDeviceOk: {
            qml_debug("## Signal : onSigBluetoothInitializePairedDeviceOK")
            MOp.showPopup("DimDeleted");
        }
    }

    Connections {
        target: BtCoreCtrl

        /* //CarPlay 모드 Test 코드
       target: idAppMain
       */

       onSigAAPConnected: {
           projectionOn = true
       }

       onSigAAPDisconnected: {
           projectionOn = false
           if("popup_Bt_enter_setting_during_CarPlay" == popupState) {
               MOp.hidePopup();
           }
       }

        onPopupInitializeBT: {
            qml_debug("## Signal onPopupInitializeBT")
            MOp.showPopup("popup_Bt_Initialized");
        }

        onHandsFreeGeneralError: {
            qml_debug("## Signal onHandsFreeGeneralError");
            /* 발신실패, 통화권 이탈 등에 발생하는 Generic Error
             */
            MOp.showPopup("popup_Bt_No_Dial_No_Connect_Device");
        }
        
//__IQS_15MY__ Call End Modify
        onHandsFreeCallEndFailPopup: {
            qml_debug("## Signal onHandsFreeCallEndFailPopup");
            if(true == gContactFromCall) {
                MOp.reshowCallView(8005);
            }            
            MOp.showPopup("popup_Dim_For_Call");
        }
//#endif

        onHandsFreeGeneralErrorCallend: {
            qml_debug("## Signal onHandsFreeGeneralErrorCallend");
            /* 발신실패, 통화권 이탈 등에 발생하는 Generic Error
             */
            MOp.hideSiriView(false)
            console.log("Hide SiriView")

            //DEPRECATED UIListener.invokePostDialView();
            MOp.showPopup("popup_Bt_Call_Connect_Fail");
        }

        onSigHideCallConnectFailPopup: {
            if("popup_Bt_Call_Connect_Fail" == popupState) {
                MOp.hidePopup();
            }
        }

        onSigCheckCallConectFailPopup: {
            qml_debug("Signal onSigCheckCallConectFailPopup");

            if("popup_Bt_Call_Connect_Fail" == popupState) {
                BtCoreCtrl.invokeHandsfreeCallEndedEventToUISH();
            }
        }

        //BlueLink 상태 BT 수신창 인데 BlueLink 상태 아닐 경우 Call popup 변경
        onSigBLEndChangePopup: {
            qml_debug("Signal onSigBLEndChangePopup");

            if("popup_bluelink_popup" == popupState && 10 == BtCoreCtrl.m_ncallState) {
                MOp.showPopup("Call_popup");
            } else if("popup_bluelink_popup_Outgoing_Call" == popupState) {
                if("Short" == gSwrcInput) {
                    pushScreen("BtDialMain", 77777);
                } else if("Long" == gSwrcInput) {
                    BtCoreCtrl.HandleCallStart(BtCoreCtrl.invokeTrackerGetLastOutgoing());
                } else {
                    console.log("###### gSwrcInput Value fail")
                    console.log("###### gSwrcInput = " + gSwrcInput)
                    /* Enter Phone by SK from HOME & Other App */
                    if(true == BtCoreCtrl.invokeGetIsOutgoingCallFromApp())
                    {
                        BtCoreCtrl.HandleCallStart(BtCoreCtrl.invokeGetOutgoingCallNumber());
                    }
                }

                gSwrcInput = "";
                MOp.hidePopup();


                /* 블루링크 통화 중 블루투스 진입 시 배경화면이 없는 경우
                 * Dial화면 표시 함
                 */
                if(1 > UIListener.invokeGetScreenSize()) {
                    pushScreen("BtDialMain");
                    MOp.returnFocus();
                }
            }
        }

        onDeviceHFPConnectSuccess: {
            qml_debug("Signal onDeviceHFPConnectSuccess")
            //start. moved from BtPopupConnectSuccess.qml
            phoneNumInput = "";

            // 폰북 초기 1회 재정렬을 위한 변수
            gPhonebookReloadForDial = true;
            //end.

            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                if(true == btPhoneEnter) {
                    // 자동연결, 폰에서 연결한 경우 완료되면 화면을 띄움
                    MOp.hidePopup();
                    console.log("RestustFGState = " + UIListener.invokeGetRequsetFGState());
                    console.log("Bluelink Call Activated = " + BtCoreCtrl.invokeIsBluelinkCallActivated());
                    if(true == UIListener.invokeGetRequsetFGState() && true == BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                        // 블루링크 전화상태에서 재연결 팝업으로 HFP연결이 완료되었을 때 Dial화면이아닌 블루링크 팝업을 띄우도록 함
                        UIListener.invokeSetRequestFGState(false);
                        qml_debug("Bluelink Outgoing Call")
                        MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                    } else {
                        /* HFP 연결되었을 때 블루링크 콜 상태이면 팝업을 출력하도록 예외처리 추가
                         * 아래 조건이 없으면 바로 Dial로 진입되어 BT통화가 가능하기 때문에 예외처리해야됨
                         */
                        if(true == BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                            qml_debug("Bluelink Outgoing Call")
                            MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                        } else {
                            switchScreen("BtDialMain", false, 138);
                        }
                    }
                } else {
                     // do nothing
                }
            } else {
                // do nothing
            }
        }

        onConnectSuccessPopup: {
            qml_debug("Signal onConnectSuccessPopup")

            console.log("hfpConnected = " + hfpConnected);
            if(true == hfpConnected) {
                MOp.showPopup("connectSuccessPopup");
                // ITS 0241987 최근 통화 목록 다운로드 완료 시 All 탭으로 포커스 이동하도록 수정
                if(false == iqs_15My) {
                    select_recent_call_type = 2
                } else {
                    select_recent_call_type = 5
                }

                // 폰북 초기 1회 다이얼 화면 표시안되는 문제
                gPhonebookReloadForDial = true;

            } else {
                if(false == btPhoneEnter) {
                    MOp.showPopup("connectSuccessPopup");

                    // 폰북 초기 1회 다이얼 화면 표시안되는 문제
                    gPhonebookReloadForDial = true;

                } else {
                    /* IPOD과 같이 HFP를 지원하지 않는 기기를 연결완료
                     * 설정 화면이 아닌 상태(Home > 연결 시작 후 완료했을 때)
                     */
                    MOp.showPopup("connectSuccessA2DPOnlyPopup");
                }
            }
        }

        onConnectFailurePopup: {
            qml_debug("Signal onConnectFailurePopup");
            qml_debug("iqs_15My = " + iqs_15My);
            if(true == iqs_15My) {
                // For IQS 15My(수동 연결 실패 시 10sec timeout popup -> Auto Connect Start)
                if(popupState != "popup_restrict_while_driving") {
                    MOp.showPopup("popup_Bt_Connection_Fail_15MY");
                }
            } else {
                // For IQS
                if(popupState != "popup_restrict_while_driving") {
                    if(false == btPhoneEnter) {
                        MOp.showPopup("popup_Bt_Connection_Fail");
                    } else {
                        MOp.showPopup("popup_Bt_Connection_Fail_Re_Connect");
                    }
                }
            }
        }

        onDisconnectingPopup: {
            qml_debug("Signal onDisconnectingPopup");
            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                if(false == btPhoneEnter) {
                    MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn");
                } else {
                    MOp.showPopup("popup_Bt_Dis_Connecting");
                }
            }
        }

        onDisconnectFailedPopup: {
            /* 해제 완료시 관련된 설정 변수초기화 하기 때문에
             * 해제 실패했을 경우에도 마찬가지로 관련 변수를 초기화 하도록 함
             */
            btConnectAfterDisconnect = false;
            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                MOp.showPopup("popup_Bt_Disconnection_Fail");
            }
        }

        onSigDisconnectFlagInitialize: {
            // 연결된 상태에서 연결 시도 및 페어링 시도 시 모듈 리셋되었을 경우 해당 변수 초기화
            qml_debug("Signal sigDisconnectFlagInitialize")
            btConnectAfterDisconnect = false;
            btDisconnectAfterSSPAdd  = false;
        }

        onDisconnectSuccessPopup: {
            qml_debug("Signal onDisconnectSuccessPopup")
            qml_debug("Signal btConnectAfterDisconnect = " + btConnectAfterDisconnect)
            qml_debug("Signal btDeleteMode = " + btDeleteMode)
            qml_debug("Signal deleteAllMode = " + deleteAllMode)
            //DEPRECATED qml_debug("Signal btDisconnectAfterInitialize = " + btDisconnectAfterInitialize)
            qml_debug("Signal btDisconnectAfterSSPAdd = " + btDisconnectAfterSSPAdd)
            qml_debug("Signal parking = " + parking)
            qml_debug("Signal BtCoreCtrl.invokeGetConnectState() = " + BtCoreCtrl.invokeGetConnectState())
            qml_debug("Signal downloadComplete = " + downloadComplete)
            qml_debug("Signal btPhoneEnter = " + btPhoneEnter)
            qml_debug("Signal autoConnectStart = " + autoConnectStart)

            if(true == btConnectAfterDisconnect) {
                btConnectAfterDisconnect = false;
                /* 재연결을 위해 연결해제 완료 알림
                 */
                BtCoreCtrl.invokeStartReConnect();

                MOp.showPopup("popup_Bt_Connecting");

                BtCoreCtrl.invokeSetConnectedDeviceID(BtCoreCtrl.invokeGetConnectingDeviceID())

                BtCoreCtrl.invokeSetConnectingDeviceID(-1 /* BT_INVALID */);
                BtCoreCtrl.invokeSetConnectingDeviceName("");

                qml_debug("[QML_CONNECTED_ID] ConnectedID = " + BtCoreCtrl.invokeGetConnectedDeviceID())
                qml_debug("[QML_CONNECTING_ID] ConnectingID = " + BtCoreCtrl.invokeGetConnectingDeviceID())
                BtCoreCtrl.invokeStartConnect(BtCoreCtrl.invokeGetConnectedDeviceID())
            } else if(true == btDeleteMode) {
                MOp.showPopup("popup_Bt_Deleting");

                if(true == deleteAllMode) {
                    BtCoreCtrl.invokeRemoveAllPairedDevice();
                } else {
                    BtCoreCtrl.invokeRemovePairedDevice();
                }
/* DEPRECATED
            } else if(true == btDisconnectAfterInitialize) {
                BtCoreCtrl.invokeResetSettings(true, blutooth_setting_initialize)
DEPRECATED */
            } else if(true == btDisconnectAfterSSPAdd) {
                // 재연결을 위해 연결해제 완료 알림
                BtCoreCtrl.invokeEndReConnect();

                btDisconnectAfterSSPAdd = false

                if(true == parking) {
                    // 정차상태
                    BtCoreCtrl.invokeSetDiscoverableMode(true);
                    MOp.showPopup("popup_Bt_SSP_Add");
                } else {
                    // 주행상태
                    qml_debug("## parking = false");
                    MOp.showPopup("popup_restrict_while_driving");
                    BtCoreCtrl.invokeStartAutoConnect();
                }
            } else if(9 /* CONNECT_STATE_CONNECTING_CANCEL */ == BtCoreCtrl.invokeGetConnectState()) {
                qml_debug("BtCoreCtrl.invokeGetStartConnectingFromHU() = " + BtCoreCtrl.invokeGetStartConnectingFromHU());

                if(false == BtCoreCtrl.invokeGetStartConnectingFromHU()) {
                    if(true == downloadComplete) {
                        MOp.showPopup("disconnectSuccessPopup");
                    } else {
                        // 최근통화/전화번호부 다운로드 중 연결해제
                        MOp.showPopup("popup_bt_contact_callhistory_download_stop_disconnect");
                    }
                } else {
                    MOp.showPopup("popup_Bt_Connect_Canceled");
                }
            } else if(false == btPhoneEnter) {
                qml_debug("In onDisconnectSuccessPopup call disconnectSuccessPopup -> btPhoneEnter == false");
                if(false == autoConnectStart) {
                    if(true == downloadComplete) {
                        MOp.showPopup("disconnectSuccessPopup");
                    } else {
                        // 최근통화/전화번호부 다운로드 중 연결해제
                        MOp.showPopup("popup_bt_contact_callhistory_download_stop_disconnect");
                    }
                }
            } else if(true == btPhoneEnter) {
                if(true == autoConnectStart) {
                    MOp.showPopup("popup_Bt_Connecting");
                } else {
                    MOp.showPopup("disconnectSuccessPopup");
                }
            } else {
                qml_debug("In onDisconnectSuccessPopup else");
                // false == btSettingsEnter
                MOp.hidePopup();
            }
        }

        onDisconnectByPhonePopup: {
            // TODO: OJ sigShowPopupDisconnectByPhone
            MOp.showPopup("popup_Bt_Disconnect_By_Phone");
        }

        onRequestPBAPPopup: {
            // For IQS
            if(1 > callType && popupState != "popup_restrict_while_driving") {
                MOp.showPopup("popup_Bt_Request_Phonebook");
            }
        }

        onRequestPBAPHidePopup: {
            // TODO: OJ sigHidePopupRequestPBAP
            if("popup_text" == popupState && false == btPhoneEnter) {
                MOp.hidePopup();
            } else {
                // 폰북 다운로드 완료 되었을 때 PBAP 요청팝업 Hide
                if("popup_Bt_Request_Phonebook" == popupState) {
                    MOp.hidePopup();
                }
            }
        }

        onBtAutoConnectDevice: {
            // TODO: sigShowPopupAutoConnectDevice
            qml_debug("Signal onBtAutoConnectDevice")
            if(true == BtCoreCtrl.invokeIsHFPConnected()) {
                // HFP 지원 기기인 경우
                //[ITS 0272118]: AA Hidden 연결할 경우 자동 연결 우선 설정 팝업 출력
                if(BtCoreCtrl.m_pairedDeviceCount < 6){
                    MOp.showPopup("popup_Bt_AutoConnect_Device");
                }else{
                    if(false == BtCoreCtrl.invokeGetPBAPNotSupport())
                    {
                        BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);
                    }
                    else
                    {
                        if(popupState != "popup_restrict_while_driving") {
                            if(1 > callType) {
                                MOp.showPopup("popup_Bt_PBAP_Not_Support");
                            }
                        }
                    }
                }
            } else {
                // HFP 미지원 기기인 경우
                MOp.showPopup("popup_Bt_AutoConnect_Device_A2DPOnly");
            }
        }

        onContactDownFailPopup: {
            // For IQS
            if(popupState != "popup_restrict_while_driving"
                && popupState != "popup_search_while_driving") {
                if(1 > callType
                    || ("FOREGROUND" != callViewState
                        && (popupState != "Call_popup" && popupState != "Call_3way_popup" && popupState != "popup_bluelink_popup"))
                    ) {
                    if(0 == UIListener.invokeGetCountryVariant() || 1 == UIListener.invokeGetCountryVariant()) {
                        MOp.showPopup("popup_Contact_Down_fail");
                    } else {
                        MOp.showPopup("popup_Contact_Down_fail_EU");
                    }
                } else {
                    BtCoreCtrl.invokeSetPhonebookState();
                }
            } else {
                /* 폰북검색, 기기명변경, 인증번호설정 화면에서 주행규제 팝업이 출력되어 있는 경우
                 * 주행 규제팝업의 "확인"을 선택한 동작과 동일하게 화면이 빠지고 폰북 업데이트 팝업출력
                 */
                if("BtContactSearchMain" == idAppMain.state) {
                    popScreen(207);

                    if("FROM_SEARCH" == favoriteAdd) {
                        favoriteAdd = "FROM_CONTACT";
                    }
                } else if("SettingsBtNameChange" == idAppMain.state || "SettingsBtPINCodeChange" == idAppMain.state){
                    popScreen(208);
                }

                //ITS 233880
                if(popupState != "popup_restrict_while_driving") {
                    if(1 > callType
                            || ("FOREGROUND" != callViewState
                                && (popupState != "Call_popup" && popupState != "Call_3way_popup" && popupState != "popup_bluelink_popup"))
                            ) {
                        if(0 == UIListener.invokeGetCountryVariant() || 1 == UIListener.invokeGetCountryVariant()) {
                            MOp.showPopup("popup_Contact_Down_fail");
                        } else {
                            MOp.showPopup("popup_Contact_Down_fail_EU");
                        }
                    } else {
                        BtCoreCtrl.invokeSetPhonebookState();
                    }
                }
            }
        }

        onNotSupportPBAPPopup: {
            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                if(1 > callType) {
                    MOp.showPopup("popup_Bt_PBAP_Not_Support");
                }
            }
        }

        onContactUpdatePopup: {
            if("popup_restrict_while_driving" == popupState
                || "popup_search_while_driving" == popupState){
                /* 폰북검색, 기기명변경, 인증번호설정 화면에서 주행규제 팝업이 출력되어 있는 경우
                 * 주행 규제팝업의 "확인"을 선택한 동작과 동일하게 화면이 빠지고 폰북 업데이트 팝업출력
                 */
                if("BtContactSearchMain" == idAppMain.state) {
                    popScreen(207);

                    if("FROM_SEARCH" == favoriteAdd) {
                        favoriteAdd = "FROM_CONTACT";
                    }
                } else if("SettingsBtNameChange" == idAppMain.state || "SettingsBtPINCodeChange" == idAppMain.state){
                    popScreen(208);
                }

                MOp.showPopup("popup_Contact_Change");
            } else if("popup_Bt_Deleting" == popupState
                || "popup_Bt_Initialing" == popupState) {
                /* 삭제중 또는 초기화중인 상태에서 Update 여부 팝업이 출력되어야할 경우
                 * 삭제 또는 초기화가 완료된 후 Update 여부 팝업을 출력한다.
                 */
                waitContactUpdatePopup = true
            } else {
                MOp.showPopup("popup_Contact_Change");
            }
        }

        onHandsFreeTransferredErrorCall: {
            qml_debug("## Signal onHandsFreeTransferredErrorCall");
            //__IQS_15MY_ Call End Modify
            if(10 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                MOp.showPopup("popup_bt_not_transfer_call");
            }
        }

        //Bluelink Bt 동시 통화 시 Bt Call 화면에서 통화 전환 관련 수정
        onHandsFreeTransferredErrorDuringBluelink: {
            qml_debug("## Signal onHandsFreeTransferredErrorDuringBluelink");
            //__IQS_15MY_ Call End Modify
            if(10 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                MOp.showPopup("popup_during_bluelink_not_transfer");
            }
        }

        // __NEW_FORD_PATENT__ start  포더 특허 변경 사양 적용.
        // 포드특허 팝업 출력
        onHandsFreeFordPatentPopup: {
            qml_debug("## Signal onHandsFreeFordPatentPopup");
            MOp.showPopup("popup_bt_switch_handfree");
            BtCoreCtrl.invokeSetFordPopupShow(true);
        }

        onHandsFreeFordPatentNaviPopup: {
            qml_debug("## Signal onHandsFreeFordPatentPopup");
            MOp.showPopup("popup_bt_switch_handfreeNavi");
            BtCoreCtrl.invokeSetFordPopupShow(true);
        }
        // __NEW_FORD_PATENT__ end

        onSigCancellingPopup: {
            qml_debug("Signal onSigCancellingPopup")
            MOp.showPopup("popup_Bt_Connect_Cancelling");
        }
    }

    Connections {
        target: UIListener

        onConnectionCancelling: {
            qml_debug("Signal onConnectionCancelling")
            MOp.showPopup("popup_Bt_Connect_Cancelling");
        }

        onSigEventPairingFailed : {
            // Auth fail popup(Failed auth SSP)
            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                MOp.showPopup("popup_Bt_Connection_Auth_Fail_Ssp");
            }
        }

        onConnectingPopup: {
            qml_debug("1. Signal onConnectingPopup")
            qml_debug("1. btPhoneEnter = " + btPhoneEnter);
            qml_debug("1. btSettingsEnter = " + btSettingsEnter);
            qml_debug("1. isHFPConnected = " + BtCoreCtrl.invokeIsHFPConnected());
            qml_debug("1. autoConnectStart = " + autoConnectStart);
            qml_debug("1. deleteMode = " + btDeleteMode);
            qml_debug("1. deleteAllMode = " + deleteAllMode);
            qml_debug("1. popupState = " + popupState);

            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                /* A폰 삭제 중 B폰에서 연결을 시도했을 때는 ConnectableMode와 상관없이 연결이 진행됨
                 * 이 때 삭제 중인 상태에서는 삭제 완료 이 후 연결중 팝업을 띄우도록 함
                 * 정차 중에만 연결중 팝업을 띄우도록 함
                 */
                if(false == btDeleteMode && false == deleteAllMode) {
                    // BtCoreCtrl의 onConnectingPopup도 동일하게 처리해야됨
                    //start.ISV 100233 need to add condition bgrequested
                    if(false == bgrequested)
                    {
                        if(false == btPhoneEnter || false == btSettingsEnter) {
                            MOp.showPopup("popup_Bt_Connecting");
                        } else if(true == autoConnectStart){
                            MOp.showPopup("popup_Bt_Connecting");
                        } else if(false == BtCoreCtrl.invokeIsHFPConnected()) {
                            MOp.showPopup("popup_Bt_Connecting");
                        } else {
                            // do nothing
                        }
                    }
                    //end.

                    // 세팅 화면 진입 시 화면 뒤쪽에 포커스 이동되는 현상을 막기 위한 returnFocus
                    MOp.returnFocus();
                }
            } else {
                // do nothing. 주행 중에는 연결중팝업 안띄움
            }
        }

        onDisconnectingPopup: {
            qml_debug("Signal onDisconnectingPopup")
            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                if(false == btPhoneEnter) {
                    MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn");
                } else {
                    MOp.showPopup("popup_Bt_Dis_Connecting");
                }
            }
        }
    }

    Connections {
        target: BtCoreCtrl

        onConnectionCanceled: {
            qml_debug("Signal onConnectionCanceled");
            qml_debug("iqs_15My = " + iqs_15My);
            qml_debug("parking = " + parking);
            qml_debug("connectingPopupAddNewClick = " + connectingPopupAddNewClick);
            qml_debug("pairedDeviceCount = " + BtCoreCtrl.m_pairedDeviceCount);
            // For IQS 15MY
            if(true == iqs_15My) {
                // 연결중 팝업에서 AddNew Button 선택 했을 경우
                if(true == connectingPopupAddNewClick) {
                    connectingPopupAddNewClick = false;
                    // 주행규제를 제일 먼저 검사하도록 수정
                    if(false == parking) {
                        MOp.showPopup("popup_restrict_while_driving");
                    } else {
                        // 페어링 리스트가 5개인지 체크
                        if(5 > BtCoreCtrl.m_pairedDeviceCount) {
                            BtCoreCtrl.invokeSetDiscoverableMode(true)
                            MOp.showPopup("popup_Bt_SSP_Add");
                        } else {
                            if(true == btPhoneEnter) {
                                MOp.showPopup("popup_Bt_Max_Device");
                            } else {
                                MOp.showPopup("popup_Bt_Max_Device_Setting");
                            }
                        }
                    }
                } else {
                    if("popup_Bt_Connect_Cancelling" == popupState)
                    {
                        MOp.hidePopup();
                    }
                    MOp.showPopup("popup_Bt_Connect_Canceled");
                }
            } else {
                MOp.showPopup("popup_Bt_Connect_Canceled");
            }
        }

        onConnectingPopup: {
            qml_debug("2. Signal onConnectingPopup")
            qml_debug("2. btPhoneEnter = " + btPhoneEnter);
            qml_debug("2. btSettingsEnter = " + btSettingsEnter);
            qml_debug("2. isHFPConnected = " + BtCoreCtrl.invokeIsHFPConnected());
            qml_debug("2. autoConnectStart = " + autoConnectStart);
            qml_debug("2. deleteMode = " + btDeleteMode);
            qml_debug("2. deleteAllMode = " + deleteAllMode);
            qml_debug("2. popupState = " + popupState);
            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                /* A폰 삭제 중 B폰에서 연결을 시도했을 때는 ConnectableMode와 상관없이 연결이 진행됨
                 * 이 때 삭제 중인 상태에서는 삭제 완료 이 후 연결중 팝업을 띄우도록 함
                 */
                if(false == btDeleteMode && false == deleteAllMode) {
                    // UIListener onConnectingPopup도 동일하게 처리해야됨
                    //start.ISV 100233 need to add condition bgrequested
                    if(false == bgrequested)
                    {
                        if(false == btPhoneEnter || false == btSettingsEnter) {
                            MOp.showPopup("popup_Bt_Connecting");
                        } else if(true == autoConnectStart) {
                            MOp.showPopup("popup_Bt_Connecting");
                        } else if(false == BtCoreCtrl.invokeIsHFPConnected()) {
                            MOp.showPopup("popup_Bt_Connecting");
                        } else {
                            // do nothing
                        }
                    }
                    //end.

                    // 세팅 화면 진입 시 화면 뒤쪽에 포커스 이동되는 현상을 막기 위한 returnFocus
                    MOp.returnFocus();
                }
            } else {
                // do nothing. 주행 중에는 연결중팝업 안띄움
            }
        }

        onFavoriteContactAdding: {
            qml_debug("Signal onFavoriteContactAdding");
            // TODO: ddingddong
        }

        onPopupFavoriteAddSuccess: {
            qml_debug("Signal onPopupFavoriteAddSuccess");
            MOp.showPopup("popup_Bt_Add_Favorite");
            favoriteButtonPress = false
        }

        onPopupFavoriteAddDuplicate: {
            qml_debug("Signal onPopupFavoriteAddDuplicate")
            MOp.showPopup("popup_Bt_Add_Favorite_Duplicate");
            favoriteButtonPress = false
        }

        onPopupFavoriteAddFail: {
            qml_debug("Signal onPopupFavoriteAddFail")
            //popupState = "AddFail"
        }

        onPopupCallHistoryDownloadFailed: {
            qml_debug("Signal onPopupCallHistoryDownloadFailed");
            MOp.showPopup("popup_bt_callhistory_download_fail");
            downloadCallHistory = false;
        }

        onSigPopupNoCallHistory: {
            qml_debug("Signal onSigPopupNoCallHistory");
            /* Phonebook 다운로드 관련 팝업이 떠 있을 경우 팝업을 띄우지 않도록 함
             * (ex. 5000개 초과 팝업, Phonebook 다운로드 개수 하나도 없음 팝업)
             * 설정 화면이 아닌 경우(true == btPhoneEnter)에만 팝업을 출력하도록 함
             * IQS 적용
             */
            if(true == btPhoneEnter
                && "popup_bt_no_phonebook_on_phone" != popupState
                && "popup_Bt_Max_Phonebook" != popupState
                && "popup_Contact_Down_fail" != popupState
                && "popup_Contact_Down_fail_EU" != popupState) {
                if(1 > callType
                    || ("FOREGROUND" != callViewState
                        && (popupState != "Call_popup" && popupState != "Call_3way_popup"
                        && popupState != "popup_bluelink_popup"))
                ) {
                    MOp.showPopup("popup_outgoing_calls_empty_download");
                }
            }

            downloadCallHistory = false;
        }

        onSigPopupNoPhonebook: {
            qml_debug("Signal popup_bt_no_phonebook_on_phone");
            /* Phonebook 다운로드를 완료했지만 데이터가 1개도 없을 경우 팝업
             * 설정 화면이 아닌 경우(true == btPhoneEnter)에만 팝업을 출력하도록 함
             * IQS 적용
             */
            if(true == btPhoneEnter &&  popupState != "popup_restrict_while_driving") {
                if(1 > callType
                    || ("FOREGROUND" != callViewState
                        && (popupState != "Call_popup" && popupState != "Call_3way_popup"
                        && popupState != "popup_bluelink_popup"))
                ) {
                    MOp.showPopup("popup_bt_no_phonebook_on_phone");
                }
            } else {
                if("popup_Bt_Request_Phonebook" == popupState) {
                    MOp.hidePopup();
                }
            }
        }

        onPopupPhonebookDownloadFailed: {
            qml_debug("Signal onPopupPhonebookDownloadFailed")
            downloadContact = false
            MOp.showPopup("popup_bt_contact_download_fail");
        }

        onFavoriteContactRemoving: {
            qml_debug("Signal onFavoriteContactRemoving")
            //MOp.showPopup("popup_Bt_Deleting");
        }

        onFavoriteContactRemovingOk: {
            // 즐겨찾기 삭제 완료
            qml_debug("Signal onFavoriteContactRemovingOk")
            MOp.showPopup("popup_Bt_Deleted");
            favoriteSelectInt = 0
        }

        onFavoriteContactRemovingNG: {
            qml_debug("Signal onFavoriteContactRemovingNG")
            //DEPRECATED showPopup("DeleteFail");
            favoriteSelectInt = 0
        }

/*DEPRECATED
        onCallHistoryRemoving: {
            qml_debug("Signal onCallHistoryRemoving")
        }
DEPRECATED*/

        onCallHistoryRemovingOk: {
            qml_debug("Signal onCallHistoryRemoving")
            MOp.showPopup("popup_Bt_Deleted");
        }

/*DEPRECATED
        onCallHistoryRemovingNG: {
            qml_debug("Signal onCallHistoryRemovingNG")
            //DEPRECATED showPopup("DeleteFail");
        }
DEPRECATEED*/

        onSigPopupNoOutgoing: {
            console.log("############################### FLAG!!!!");
            gNoOutgoing = true;
        }

        onSigNoLastDialedNumber: {
            qml_debug("Signal onSigNoLastDialedNumber")
        }

        onSigPairedDeviceDeleted: {
            // 디바이스 삭제완료
            qml_debug("Signal onSigPairedDeviceDeleted");
            qml_debug("btDeleteMode = " + btDeleteMode);
            qml_debug("deleteAllMode = " + deleteAllMode);
            qml_debug("delete_type = " + delete_type);
            //DEPRECATED qml_debug("selectDeviceDelete = " + selectDeviceDelete);
            //DEPRECATED qml_debug("btDisconnectAfterInitialize = " + btDisconnectAfterInitialize);

            // 삭제 완료 또는 초기화가 완료되었기 때문에 연결된 deviceId와 연결된 기기 삭제관련 변수를 초기화 함.
            if(false == BtCoreCtrl.invokeIsAnyConnected())
            {
                BtCoreCtrl.invokeSetConnectedDeviceID(-1);
            }

            //DEPRECATED selectDeviceDelete = false;

            // 페어링 중이면 "popup_Bt_SSP" or "popup_Bt_Authentication_Wait"팝업이 떠있는 상태로 팝업을 유지해야 함
            if(1 /* CONNECT_STATE_PAIRING */ == BtCoreCtrl.invokeGetConnectState()) {
                if(true == btDeleteMode) {
                    btDeleteMode = false;
                    deleteAllMode = false;
                }
            } else {
                if(true == btDeleteMode) {
                    btDeleteMode = false;
                    deleteAllMode = false;
                    MOp.showPopup("popup_Bt_Deleted");
                } else {
                    // For IQS
                    if(popupState != "popup_restrict_while_driving") {
                        MOp.showPopup("popup_Bt_Initialized");
                    }
                }
            }

/* DEPRECATED
            if(true == btDisconnectAfterInitialize) {
                // 연결해제 후 패어링 기기 초기화시 사용
                btDisconnectAfterInitialize = false
                MOp.showPopup("popup_Bt_Initialized");
            }
DEPRECATED */
        }

        onSigWrongLastDialedNumber: {
            qml_debug("Signal onSigWrongLastDialedNumber")
            MOp.showPopup("popup_Bt_No_Dial_No_Connect_Device");
        }

        onPhonebookDownloadCompleted: {
            qml_debug("Signal onPhonebookDownloadCompleted")
            // 현재 BT화면 체크 하고 통화상태인지 아닌지를 체크하고 팝업 출력 Issue List #596
            // For IQS
            if(true == btPhoneEnter && popupState != "popup_restrict_while_driving") {
                /* Outgoing 상태이나 통화화면이 아닌경우 팝업 표시
                 * Incoming 팝업 상태가 아닐 경우 팝업 표시
                 */
                if(1 > callType
                    || ("FOREGROUND" != callViewState
                        && (popupState != "Call_popup" && popupState != "Call_3way_popup"
                        && popupState != "popup_bluelink_popup"))
                ) {
                    MOp.showPopup("popup_bt_phonebook_download_completed");
                } else {
                    qml_debug("Main View > Calling Popup No Display : Phonebook")
                }
            } else {
                qml_debug("Main View > Setting Popup No Display : Phonebook")
            }
        }

        onCallHistoryDownloadCompleted: {
            qml_debug("Signal onCallHistoryDownloadCompleted")
            // 현재 BT화면 체크 하고 통화상태인지 아닌지를 체크하고 팝업 출력 Issue List #596
            // For IQS (주행규제 팝업이 떠있을 경우 팝업 출력안함
            qml_debug("btPhoneEnter = " + btPhoneEnter);
            qml_debug("popupState = " + popupState);
            if(true == btPhoneEnter
                && popupState != "popup_Bt_Max_Phonebook"
                && popupState != "popup_Contact_Down_fail"
                && popupState != "popup_Contact_Down_fail_EU"
                && popupState != "popup_restrict_while_driving") {
                // 폰북 초과 팝업이 떠있는 경우 최근통화 다운로드 완료팝업을 미출력하도록 함
                if(1 > callType
                    || ("FOREGROUND" != callViewState
                        && (popupState != "Call_popup" && popupState != "Call_3way_popup"
                        && popupState != "popup_bluelink_popup"))
                    ) {
                    MOp.showPopup("popup_Bt_RecentCall_Down_completed");
                } else {
                    qml_debug("Main View > Calling Popup No Display : Recent Call")
                }
            } else {
                qml_debug("Main View > Setting Popup No Display : Recent Call")
            }
        }

        onPhonebookUpdateCompleted: {
            qml_debug("Signal onPhonebookUpdateCompleted");
            // 전화번호부 검색화면에서 검색중 전화번호부 업데이트가 완료되었을 경우 화면을 검색화면을 초기화한다.
            iniKeypadInput();

            /* BT 업데이트 완료팝업 출력
             * VR 전화번호부 업데이트 완료 시 VR에서 업데이트 완료 OSD 출력
             */
            if(true == btPhoneEnter) {
                if(1 > callType
                    || ("FOREGROUND" != callViewState
                        && (popupState != "Call_popup" && popupState != "Call_3way_popup" && popupState != "popup_bluelink_popup"))
                ) {
                    MOp.showPopup("popup_Bt_Contact_Update_Completed");
                }
            }
        }

        onSigHidePopup: {
            // 팝업이 떠있는 경우 "확인", "예", "아니오"를 누르기까지 팝업을 유지
            switch(popupState) {
                case "popup_Bt_Max_Phonebook":
                case "popup_bt_checkbox_ini":
                case "popup_text":
                case "popup_Bt_Other_Device_Connect_Menu":
                case "popup_bt_conn_paired_device_all":
                case "popup_bt_conn_paired_device_delete":
                case "popup_Bt_Dis_Connection":
                case "popup_bluelink_popup":
                case "popup_bluelink_popup_Outgoing_Call":
                case "popup_Contact_Down_fail":
                case "popup_Contact_Down_fail_EU":
                case "popup_restrict_while_driving":
                case "popup_Contact_Change":
                    // do nothing
                    break;

                default:
                    MOp.hidePopup();
                    break;
            }
        }

        onSigHideConnectingPopup: {
            if(true == iqs_15My) {
                if("popup_Bt_Connecting_15MY" == popupState) {
                    MOp.hidePopup();
                }
            } else {
                if("popup_Bt_Connecting" == popupState) {
                    MOp.hidePopup();
                }
            }
        }

        // __NEW_FORD_PATENT__ start  포더 특허 변경 사양 적용.
        // 포드 특허 팝업 hide
        onSigHideCallFordPatentPopup: {
            if("popup_bt_switch_handfree" == MOp.getPopupState()) {
                qml_debug("Signal onSigHideCallFordPatentPopup")
                MOp.hidePopup();
            } else if(true == BtCoreCtrl.m_bFordNaviFg) {
                qml_debug("Signal onSigHideCallFordPatentPopup")
                UIListener.invokePostHideBtSwitchCallPopup();
     
                if(("popup_bt_switch_handfreeNavi"  == MOp.getPopupState())
                    && (false == UIListener.invokeGetAppState())) {
                   MOp.hidePopup();
                }
            }
            
            if(false == UIListener.invokeGetAppState()) {
                BtCoreCtrl.invokeSetFordPopupShow(false);
            }
  
        }

        onSigHideCallFordPatentNaviPopup: {
            if("popup_bt_switch_handfreeNavi"  == MOp.getPopupState()) {
               MOp.hidePopup();
            }
            
            if(false == UIListener.invokeGetAppState()) {
                BtCoreCtrl.invokeSetFordPopupShow(false);
            }            
        }
        // __NEW_FORD_PATENT__ end
        
        onPhonebookDownloadFailed: {
            qml_debug("Signal onPhonebookDownloadFailed");
            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                if(1 > callType
                || ("FOREGROUND" != callViewState
                    && (popupState != "Call_popup" && popupState != "Call_3way_popup"
                    && popupState != "popup_bluelink_popup"))
                ) {
                    MOp.showPopup("popup_bt_phonebook_download_fail");
                }
            }
        }

        onCallHistoryDownloadFailed: {
            qml_debug("Signal onCallHistoryDownloadFailed");
            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                if(1 > callType
                || ("FOREGROUND" != callViewState
                    && (popupState != "Call_popup" && popupState != "Call_3way_popup"
                    && popupState != "popup_bluelink_popup"))
                ) {
                    MOp.showPopup("popup_bt_recentcall_download_fail");
                }
            }
        }

        onBluelinkOutgoing: {
/*DEPRECATED
            qml_debug("Signal onBluelinkOutgoing")
            if(BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                qml_debug("SWRC Call Press > During Bluelink Call")
                MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
            } else {
                qml_debug("SWRC Call Press > InputNumber Call Start")
                BtCoreCtrl.HandleLastCallStart()
            }
DEPRECATED*/
        }
    }

    Connections {
        target: BtCoreCtrl

        onSigNoCallHistoryInMobile: {
            /* SWRC Call(short) 키가 눌렸을때 최근통화 목록이 없다면 호출되는 SIGNAL
             */

            // 휴대폰에 최근 통화 목록 없음을 나타내는 변수 : callhistoryinPhone
            //DEPRECATED callhistoryinPhone = false

            if(mainViewState == "RecentCall") {
                switch(popupState) {
                    case "popup_Bt_Disconnect_By_Phone":
                    case "popup_launch_help_in_driving":
                    case "disconnectSuccessPopup":
                    case "popup_Bt_Max_Device":
                    case "popup_Bt_Dis_Connecting":
                    case "popup_Bt_Linkloss":
                    case "popup_Bt_Authentication_Wait_Btn":
                    case "popup_Bt_No_Device":
                    case "popup_Bt_No_Connection":
                    case "popup_Bt_Connect_Wait_Phone":
                    case "popup_Bt_SSP_Add":
                    case "popup_Bt_Connection_Auth_Fail_Ssp":
                    case "popup_Bt_Connection_Auth_Fail":
                    case "popup_Bt_Connection_Fail_Re_Connect":
                    case "popup_Bt_Not_Support_Bluetooth_Phone":
                    case "popup_restrict_while_driving":
                    case "popup_Bt_Connection_Fail":
                    case "popup_Bt_Initialized":
                    case "popup_Bt_Connect_Canceled":
                    case "popup_Bt_Connect_Cancelling":
                    case "popup_Bt_Phone_Request_Connect_Device":
                    case "popup_paired_list":
                    case "connectSuccessA2DPOnlyPopup":
                    case "popup_Bt_AutoConnect_Device_A2DPOnly":
                    case "popup_Bt_Connecting": {
                        // do noting
                        break;
                    }

                    default:
                        MOp.showPopup("popup_Bt_No_CallHistory_Phone");
                        break;
                }
            }
        }

        onSigGapSspRequested: {
            qml_debug("Signal onSigGapSspRequested")

            sspOk = BtCoreCtrl.invokeGetSSPcode();

            qml_debug("sspDeviceName =  " + sspDeviceName);
            qml_debug("BtCoreCtrl.m_strSSPDeviceName =  " + BtCoreCtrl.invokeGetSSPDeviceName());
            sspDeviceName = BtCoreCtrl.invokeGetSSPDeviceName();
            MOp.showPopup("popup_Bt_SSP");
        }

        onSigCountContactsListOverStacked: {
            qml_debug("Signal onSigCountContactsListOverStacked");
            /* 설정화면이 아닌 경우와 통화 상태가 아닌 경우 팝업을 띄우도록 함
             * IncomingCall 팝업을 가리는 문제가 발생하기 때문에 추가(1 > callType)
             * IQS 적용
             */
            if(true == btPhoneEnter && popupState != "popup_restrict_while_driving") {
                if(1 > callType
                    || ("FOREGROUND" != callViewState
                        && (popupState != "Call_popup" && popupState != "Call_3way_popup"
                        && popupState != "popup_bluelink_popup"))
                ) {
                    MOp.showPopup("popup_Bt_Max_Phonebook");
                }
            }
        }
    }

    Connections {
        target: UIListener

        onSigPhonebooksearchScreenRequest: {
            console.log("# [SIGNAL] onSigPhonebooksearchScreenRequest");
            mainViewState = "Phonebook"

            console.log("invokeFgFromVRCommand()     = " + UIListener.invokeFgFromVRCommand());
            console.log("invokeFgFromPowerOn()       = " + UIListener.invokeFgFromPowerOn());
            console.log("invokeRequestDispOrCamera() = " + UIListener.invokeRequestDispOrCamera());
            /* VR 실행 명령으로 시작한 상태라면 Temporal Mode를 무시한다
             * 후방 카메라, DisplayMode, Power Off/On 동작으로 실행되었을 때의 예외처리
             */
            if((false == UIListener.invokeFgFromVRCommand())
                && (true == UIListener.invokeFgFromPowerOn() || true == UIListener.invokeRequestDispOrCamera())
            ) {
                // VR -> PhoneBook Search -> BackKey -> Contact List -> Camera On/Off 또는 Disp Off/On 예외처리
            } else if(contact_value == 7 || (contact_value == 5 && true == BtCoreCtrl.invokeGetBackgroundDownloadMode())) {
                mainViewState = "Phonebook";
                contactSearchInput = phoneName;
                BtCoreCtrl.invokeTrackerSearchPhonebook(contactSearchInput, false);

                /* VR --> 검색화면으로 진입할 경우 BACK 동작에 대한 UX 수정으로
                 * 최하단 Dial을 빼고(FG에 의해 push되는) 폰북화면을 넣고
                 * 그 위에 폰북검색화면을 다시 넣어 화면에 표시함
                 */
                //DEPRECATED switchScreen("BtContactSearchMain", false, 801);
                var topScreen = UIListener.invokePopScreen();
                if("" != topScreen) {
                    MOp.closeScreen(topScreen);
                }

                UIListener.invokePushScreen("BtContactMain");
                pushScreen("BtContactSearchMain", false, 801);
            } else if(contact_value <= 6) {
                MOp.switchInfoViewScreen(contactState);
                //infoState = contactState;
                //switchScreen("BtInfoView", false, 802);

                selectedBand = "BAND_PHONEBOOK";
            } else {
                qml_debug("Error");
            }
        }

        onSigPhonebookScreenRequest: {
            console.log("# [SIGNAL] onSigPhonebookScreenRequest");
            mainViewState = "Phonebook";

            if(contact_value <= 6) {
                //infoState = contactState;
                //switchScreen("BtInfoView", false, 803);
                MOp.switchInfoViewScreen(contactState);

                if(true == downloadCallHistory) {
                    // 최근 통화 목록 다운로드중인 상태
                    MOp.showPopup("popup_Bt_Downloading_Callhistory");
                } else {
                    BtCoreCtrl.invokeTrackerDownloadPhonebook()
                }
            } else {
                switchScreen("BtContactMain", false, 804);
            }
        }

        onSigRecentcalllogScreenRequest : {
            console.log("# [SIGNAL] onSigRecentcalllogScreenRequest");
            mainViewState = "RecentCall"

            if(recent_value <= 6) {
                if(5 == contact_nstate || 9 == contact_nstate || 10 == contact_nstate) {
                    // 폰북 다운로드 중인 상태
                    MOp.showPopup("popup_bt_no_downloading_phonebook");
                } else {
                    BtCoreCtrl.invokeTrackerDownloadCallHistory();
                }

                //infoState = recentCallState;
                //switchScreen("BtInfoView", false, 805);
                MOp.switchInfoViewScreen(recentCallState);
            } else {
                switchScreen("BtRecentCall", false, 806);
            }
        }

        onSigDialScreenRequest: {
            // 외부에서 Dial 검색으로 직접 들어오는 경우
            console.log("# [Signal] onSigDialScreenRequest");
            mainViewState = "Dial";
            switchScreen("BtDialMain", false, 807);

            //phoneNumFlag = true;
            phoneNumInput = phoneNumber;
            BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput);
        }

// __PROJECITON__
        onSigDeviceDelMainScreenRequest: {
            console.log("# [Signal] onSigDeviceDelMainScreenRequest");
            mainViewState = "Settings";
            switchScreen("BtDeviceDelMain", false, 808);

        }

        onSigSettingsScreenRequest: {
            // 외부에서 설정으로 직접 들어오는 경우
            console.log("# [SIGNAL] onSigSettingsScreenRequest");

            if(8 == appEntryPoint && "SettingsBtDeviceConnect" == idAppMain.state){
                btPhoneEnter = false;
            }
            /* [주의] onSigHomeSettingsBtSettingsEnable --> onSigEventRequestFg --> onSigSettingsScreenRequest
             * 의 순서로 signal이 호출되며, 여기서 hidePopup()할 경우 onSigEventRequestFg()에서 통화중에
             * 설정화면 진입을 막는 팝업이 사라져 버려 screen stack이 엉킴
             */
             
            console.log("## screen = " + idAppMain.state)
            console.log("## UIListener.invokeGetScreenSize = " + UIListener.invokeGetScreenSize());
            console.log("## UIListener.invokeTopScreen = " + UIListener.invokeTopScreen());
            console.log("## popupState = " + popupState)
            console.log("## btPhoneEnter = " + btPhoneEnter)

            /* HFP 미지원 팝업의 버튼 선택 시, 한번에 popup이 빠지지 않는 이슈
             * 해당 팝업의 파일에서 postPopupBackKey만 수행하면서 BG만 바뀌고 팝업은 유지되는 현상
             * onSigSettingsScreenRequest가 호출되면서 화면 천이를 다시 진행하기 때문에
             * 해당 팝업의 파일 내에서 hidePopup()하면 BT 빈화면 잠깐 보이는 현상 생김
             */
            switch(popupState) {
                case "popup_Bt_Not_Support_Bluetooth_Phone": {
                    if(idAppMain.state == UIListener.invokeTopScreen()) {
                        MOp.hidePopup();
                        break;
                    }
                }

                default:
                    break;
            }
        }

        onRecentcalllogWithoutSyncScreenRequest: {
            console.log("# [SIGNAL] onRecentcalllogWithoutSyncScreenRequest");

            if(BtCoreCtrl.m_ncallState == 10) {
                // 수신 전화 시 SWRC를 통하여 전화 받기 동작 추가
                MOp.showCallView();
            } else {
                if(recent_value == 7) {
                    if(phoneNumInput == "") {
                        qml_debug("SWRC Call Press > No InputNumber")
                        phoneNumInput = BtCoreCtrl.invokeTrackerGetLastOutgoing()
                        BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput)
                    } else if(phoneNumInput != "") {
                        //__IQS_15MY_ Call End Modify
                        if(BtCoreCtrl.m_ncallState > 9 || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                            qml_debug("SWRC Call Press > Calling")
                            /* 통화중일 경우 진입 막음
                             */
                            MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
                        } else {
                            if(BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                                qml_debug("SWRC Call Press > During Bluelink Call")
                                gSwrcInput = "Short"
                                MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                            } else {
                                qml_debug("SWRC Call Press > InputNumber Call Start")
                                BtCoreCtrl.HandleCallStart(phoneNumInput)
                            }
                        }
                    }
                } else {
                    // SWRC Call Key 입력 시 현재 전화번호부가 없는 경우 팝업 출력부
                    if(popupState != "popup_Bt_No_CallHistory") {
                        qml_debug("SWRC Call Press > NoCall History")
                            switch(popupState) {
                                case "popup_Bt_Disconnect_By_Phone":
                                case "popup_launch_help_in_driving":
                                case "disconnectSuccessPopup":
                                case "popup_Bt_Max_Device":
                                case "popup_Bt_Dis_Connecting":
                                case "popup_Bt_Linkloss":
                                case "popup_Bt_Authentication_Wait_Btn":
                                case "popup_Bt_No_Device":
                                case "popup_Bt_No_Connection":
                                case "popup_Bt_Connect_Wait_Phone":
                                case "popup_Bt_SSP_Add":
                                case "popup_Bt_Connection_Auth_Fail_Ssp":
                                case "popup_Bt_Connection_Auth_Fail":
                                case "popup_Bt_Connection_Fail_Re_Connect":
                                case "popup_Bt_Not_Support_Bluetooth_Phone":
                                case "popup_restrict_while_driving":
                                case "popup_Bt_Connection_Fail":
                                case "popup_Bt_Initialized":
                                case "popup_Bt_Connect_Canceled":
                                case "popup_Bt_Connect_Cancelling":
                                case "popup_Bt_Phone_Request_Connect_Device":
                                case "popup_paired_list":
                                case "connectSuccessA2DPOnlyPopup":
                                case "popup_Bt_AutoConnect_Device_A2DPOnly":
                                case "popup_Bt_Connecting": {
                                    // do noting
                                    break;
                                }

                                default:
                                    // do nothing
                                    MOp.showPopup("popup_Bt_No_CallHistory");
                                    break;
                            }
                    } else {
                        /* No Action */
                    }
                }
            }
        }

        /* System Popup show/hide signals */
        onSignalShowSystemPopup: {
            console.log("\n\n\n\n onSignalShowSystemPopup :\n\n\n\n" + systemPopupOn)
            // 시스템 팝업이 표시될 때 포커스 Hiding
            if(false == systemPopupOn) {
            sigPopupStateChanged();
            }

            //[ITS 0270239]
            if("popup_Bt_SSP_Add" == popupState) popupBackGroundBlack = false;

            systemPopupOn = true;

            if("popup_bt_phonebook_download_completed" == popupState ||
                "popup_Bt_RecentCall_Down_completed" == popupState ||
                "popup_Bt_Downloading_Callhistory" == popupState ||
                "popup_bt_recentcall_download_fail" == popupState ||
                "popup_bt_phonebook_download_fail" == popupState ||
                "popup_Bt_Authentication_Fail" == popupState ||
                "popup_bt_invalid_during_call" == popupState ||
                "popup_bt_contact_callhistory_download_stop_disconnect" == popupState ||
                "popup_bt_no_phonebook_on_phone" == popupState ||
                "popup_bt_not_transfer_call" == MOp.getPopupState() ||
                "popup_during_bluelink_not_transfer" == MOp.getPopupState() ||
                "connectSuccessA2DPOnlyPopup" == popupState ||
                "popup_Bt_AutoConnect_Device_A2DPOnly" == popupState ||
                "popup_Bt_Connection_Auth_Fail" == popupState ||
                "popup_Bt_Connection_Auth_Fail_Ssp" == popupState ||
                "popup_Bt_Authentication_Wait" == popupState ||
                "popup_Bt_Connect_Canceled" == popupState ||
                "popup_Bt_Connect_Cancelling" == popupState ||
                "popup_Bt_Connecting" == popupState ||
                "popup_Bt_Connecting_15MY" == popupState ||
                "popup_Bt_Connection_Fail" == popupState ||
                "popup_Bt_Connect_Wait_Phone" == popupState ||
                "popup_Bt_Disconnection_Fail" == popupState ||
                "popup_Bt_Initialized" == popupState ||
                "popup_Bt_No_Connection" == popupState ||
                "popup_Bt_No_Device" == popupState ||
                "popup_paired_list" == popupState ||
                "popup_Bt_Phone_Request_Connect_Device" == popupState ||
                "popup_Bt_Connection_Fail_Re_Connect" == popupState ||
                "popup_restrict_while_driving" == popupState ||
                "popup_Bt_SSP" == popupState ||
                "popup_Bt_SSP_Add" == popupState ||
                "Call_popup" == popupState ||
                "popup_bluelink_popup" == popupState ||
                "popup_bluelink_popup_Outgoing_Call" == popupState ||
                "popup_bt_paired_device_delete_all" == popupState ||
                "popup_Bt_Disconnect_By_Phone" == popupState ||
                "disconnectSuccessPopup" == popupState ||
                "popup_Bt_Add_Favorite" == popupState ||
                "popup_Bt_Deleting" == popupState ||
                "popup_Bt_Deleted" == popupState ||
                "popup_Bt_Max_Device" == popupState ||
                "popup_Bt_Dis_Connecting" == popupState ||
                "popup_Contact_Down_fail" == popupState ||
                "popup_Contact_Down_fail_EU" == popupState ||
                "popup_Bt_Ini" == popupState ||
                "popup_bt_switch_handfree" == popupState ||
                "popup_bt_switch_handfreeNavi" == popupState ||
                "popup_bt_invalid_during_call" == popupState ||
                "Call_3way_popup" == popupState ||
                "popup_Bt_Initialing" == popupState ||
                "connectSuccessPopup" == popupState ||
                "popup_Bt_Contact_Update_Completed" == popupState ||
                "popup_enter_setting_during_call" == popupState ||
                "popup_Bt_Not_Support_Bluetooth_Phone" == popupState ||
                "popup_search_while_driving" == popupState ||
                "popup_Bt_Authentication_Wait_Btn" == popupState) {
            } else {
                MOp.hidePopup();
                idMenu.hide();
            }
        }

        onSignalHideSystemPopup: {
            console.log("\n\n\n\n onSignalHideSystemPopup \n\n\n\n")
            // 시스템 팝업이 표시될 때 포커스 Show
            sigPopupStateChanged();
            systemPopupOn = false;
        }
    }

    /* HK signals
     */
    Connections {
        target: BtCoreCtrl

        onSigHKCallShortKey: {
            console.log("#############################################");
            console.log("## Signal onSigHKCallShortKey");
            console.log("#############################################");
            /* onSigHKCallShortHandler()가 App이 Background 상태일때 호출되지 않도록 수정되어
             * Bluelink 관련 팝업에서의 처리를 위해 임시 Signal 추가함
             */
            gSwrcInput = "Short";
        }

        onSigHKCallLongKey: {
            gSwrcInput = "Long";
        }

        onSigHKCallShortHandler: {
            console.log("# [SIGNAL] onSigHKCallShortHandler");
            /* SWRC call(short)키가 눌린 경우 호출
             * 해당 Signal 수정 시 onSigHKCallLongHandler, onSigHKPhoneHandler Signal도 같이 적용해야 함
             */
            gSwrcInput = "Short"

            /* Home > Settings > Bluetooth Setting > Menu > Call Short Key
             * Dial 화면으로 전환되고 Menu 남아있는 문제
             */
            idMenu.hide();

            if("popup_Bt_SSP_Add" == popupState  && false == btPhoneEnter)
            {
                UIListener.invokeRequestSetLastEntrySetting();
                return;
            }

            // ISV(NA) 75232
            /* Siri > HK Phone Key를 선택 했을 때 Home으로 빠지는 문제가 발생하기 때문에 hideSiriView(true)로 호출
             * Home으로 빠지는 이유: hideSiriView의 postBackKey()
             */
            if(true == siriViewState) {
                MOp.hideSiriView(true);

                /**************************************************************************
             * [주의] 유사한 코드가 FG Handler(연결되었을때 처리코드)와 PHONE, CALL short/long HK 에 존재함
             * (수정할 경우 함께 수정해야 함)
             **************************************************************************/
                if(true == BtCoreCtrl.invokeIsAnyConnected()) {
                    if(false == BtCoreCtrl.invokeIsHFPConnected()) {
                        if(false == btPhoneEnter) {
                            if(3 /* CONNECT_STATE_CONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                                && 7 /* CONNECT_STATE_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                                && 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                            ) {
                                btPhoneEnter = true;
                                btSettingsEnter = true;
                                MOp.clearScreen(11121);
                            }
                        }

                        if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                            || 10 /* CONNECT_STATE_PBAP_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                            || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                        ) {
                            // HFP를 지원하지 않고 연결이 완료된 상태에서 Home > Phone 선택 시 Dial 진입을 못하도록 함.
                            MOp.showPopup("popup_Bt_Not_Support_Bluetooth_Phone");
                        } else {
                            // For IQS
                            if(popupState != "popup_restrict_while_driving") {
                                // 연결중인 상태에서 HFP가 붙지 않았을 경우 Dial화면 진입이 불가하기 때문에 연결중 팝업을 띄운다
                                MOp.showPopup("popup_Bt_Connecting");
                            }
                        }
                    //__IQS_15MY_ Call End Modify
                    } else if(10 < callType || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) {
                        /* 통화중일때 Call SHORT이면 콜 화면으로 전환 + 3Way일때 Swap Call(Logic에서 수행)
                         */
                        //DEPRECATED MOp.clearScreen(3412);
                        // Incoming call이 아닌 경우에만 팝업 Hide
                        if(popupState != "Call_popup" && popupState != "Call_3way_popup" && popupState != "popup_bluelink_popup") {
                            MOp.hidePopup();
                        }

                        MOp.showCallView();
                    } else if("FOREGROUND" == callViewState) {
                        /* 현재 BT화면이 Call화면이고 HK 동작 없음, do nothing
                         */
                    } else {
                        if(BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                            if(false == btPhoneEnter) {
                                btPhoneEnter = true;
                                btSettingsEnter = true;
                                MOp.clearScreen(11122);
                            }
                            /*블루 링크 통화 중 일때 팝업 출력 부분
                             */
                            MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                        } else {
                            if("" != popupState) {
                                //__IQS_15MY_ Call End Modify
                                if(true == iqs_15My) {
                                    if(1 > callType || (false == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) {
                                        /* 통화 종료 후 이전화면을 확인하여 주행규제가 필요한 화면이라면
                                         * 주행규제 팝업을 출력하도록 수정
                                         */
                                        if(false == btPhoneEnter) {
                                            btPhoneEnter = true;
                                            btSettingsEnter = true;
                                            MOp.clearScreen(11121);
                                        }

                                        MOp.hidePopup();
                                        MOp.recallScreen("BtDialMain", false, 114);
                                    }
                                } else {
                                    if(2 > callType) {
                                        /* 통화 종료 후 이전화면을 확인하여 주행규제가 필요한 화면이라면
                                         * 주행규제 팝업을 출력하도록 수정
                                         */
                                        if(false == btPhoneEnter) {
                                            btPhoneEnter = true;
                                            btSettingsEnter = true;
                                            MOp.clearScreen(11121);
                                        }

                                        MOp.hidePopup();
                                        MOp.recallScreen("BtDialMain", false, 114);
                                    }
                                }

                                MOp.returnFocus();
                            } else {
                                if("" != favoriteAdd) {
                                    favoriteAdd = ""
                                }
                                if(false == MOp.recallScreen("BtDialMain", 4087)) {
                                    // 이미 다이얼 화면이라면 Dial에서 Call 키 입력처리 해야 함
                                    //sigDialCallKeyHandler();
                                }
                            }
                        }
                    }
                } else {
                    qml_debug("popupState = " + popupState);
                    if(false == btPhoneEnter) {
                        if(3 /* CONNECT_STATE_CONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                            && 7 /* CONNECT_STATE_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                            && 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                        ) {
                            btPhoneEnter = true;
                            btSettingsEnter = true;
//                            MOp.clearScreen(1112);
                        }
                    }

                    if(1 /* CONNECT_STATE_PAIRING */ == BtCoreCtrl.invokeGetConnectState()
                        && ("popup_Bt_Authentication_Wait_Btn" == popupState || "popup_Bt_Authentication_Wait" == popupState)) {
                        if("popup_Bt_Authentication_Wait" == popupState) {
                            //MOp.showPopup("popup_Bt_Authentication_Wait_Btn");

                            if(false == btPhoneEnter) {
                                MOp.showPopup("popup_Bt_Authentication_Wait");
                            } else {
                                MOp.showPopup("popup_Bt_Authentication_Wait_Btn");
                            }

                            MOp.returnFocus();
                        }
                    } else if("popup_Bt_SSP" == popupState) {
                        // do nothing
                    } else if(3 /* CONNECT_STATE_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                        || 7 /* CONNECT_STATE_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                        || 2 /* CONNECT_STATE_PAIRED */ == BtCoreCtrl.invokeGetConnectState()
                        || 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                    ) {
                        MOp.showPopup("popup_Bt_Connecting");
                        // TODO: ddingddong
                        MOp.returnFocus();
                    } else if(8 /* CONNECT_STATE_AUTOCONNECTING_PAIRED_FAILED */ == BtCoreCtrl.invokeGetConnectState()) {
                        // For IQS 페어링 실패 상태면 연결 중 팝업 출력
                        if(true == BtCoreCtrl.invokeGetStartConnectingFromHU()) {
                            // For IQS 페어링 실패 상태면 연결 중 팝업 출력
                            MOp.showPopup("popup_Bt_Connecting");
                        } else {
                            MOp.showPopup("popup_Bt_Connection_Auth_Fail_Ssp");
                        }
                    } else if(9 /* CONNECT_STATE_CONNECTING_CANCEL */ == BtCoreCtrl.invokeGetConnectState()) {
                        /* 9 = 취소중 상태
                         */
                        MOp.showPopup("popup_Bt_Connect_Cancelling");
                        // TODO: ddingddong
                        MOp.returnFocus();
                    } else {
                        if(true == btDeleteMode) {
                            MOp.showPopup("popup_Bt_Deleting");
                        } else if("popup_Bt_SSP_Add" == popupState) {
                            BtCoreCtrl.invokeStartAutoConnect();
                        } else {
                            MOp.hidePopup();

                            if(0 < BtCoreCtrl.m_pairedDeviceCount) {
                                MOp.showPopup("popup_paired_list");
                            } else {
                                if(true == duringINI) {
                                    // 최초 부팅 시 App시작을 준비하는 중인 상태
                                    MOp.showPopup("popup_Bt_Ini");
                                } else if(false == parking) {
                                    // UX변경 - 주행중 등록 불가 팝업
                                    MOp.showPopup("popup_restrict_while_driving");
                                } else {
                                    BtCoreCtrl.invokeSetDiscoverableMode(true);
                                    MOp.showPopup("popup_Bt_SSP_Add");
                                }
                            }
                        }
                    }
                }
            } else {
                /**************************************************************************
                 * [주의] 유사한 코드가 FG Handler(연결되었을때 처리코드)와 PHONE, CALL short/long HK 에 존재함
                 * (수정할 경우 함께 수정해야 함)
                 **************************************************************************/
                if(true == BtCoreCtrl.invokeIsAnyConnected()) {
                    if(false == BtCoreCtrl.invokeIsHFPConnected()) {
                        if(false == btPhoneEnter) {
                            if(3 /* CONNECT_STATE_CONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                                && 7 /* CONNECT_STATE_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                                && 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                            ) {
                                btPhoneEnter = true;
                                btSettingsEnter = true;
                                MOp.clearScreen(11121);
                            }
                        }

                        if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                            || 10 /* CONNECT_STATE_PBAP_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                            || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                        ) {
                            // HFP를 지원하지 않고 연결이 완료된 상태에서 Home > Phone 선택 시 Dial 진입을 못하도록 함.
                            MOp.showPopup("popup_Bt_Not_Support_Bluetooth_Phone");
                        } else {
                            // For IQS
                            if(popupState != "popup_restrict_while_driving") {
                                // 연결중인 상태에서 HFP가 붙지 않았을 경우 Dial화면 진입이 불가하기 때문에 연결중 팝업을 띄운다
                                MOp.showPopup("popup_Bt_Connecting");
                            }
                        }
                    //__IQS_15MY_ Call End Modify
                    } else if(10 < callType || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) {
                        /* 통화중일때 Call SHORT이면 콜 화면으로 전환 + 3Way일때 Swap Call(Logic에서 수행)
                         */
                        //DEPRECATED MOp.clearScreen(3412);
                        // Incoming call이 아닌 경우에만 팝업 Hide
                        if(popupState != "Call_popup" && popupState != "Call_3way_popup" && popupState != "popup_bluelink_popup") {
                            MOp.hidePopup();
                        }

                        MOp.showCallView();
                    } else if("FOREGROUND" == callViewState) {
                        /* 현재 BT화면이 Call화면이고 HK 동작 없음, do nothing
                         */
                    } else {
                        if(BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                            if(false == btPhoneEnter) {
                                btPhoneEnter = true;
                                btSettingsEnter = true;
                                MOp.clearScreen(11122);
                            }
                            /*블루 링크 통화 중 일때 팝업 출력 부분
                             */
                            MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                        } else {
                            if("" != popupState) {
                                //__IQS_15MY_ Call End Modify
                                if(true == iqs_15My) {
                                    if(1 > callType || (false == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) {
                                        /* 통화 종료 후 이전화면을 확인하여 주행규제가 필요한 화면이라면
                                         * 주행규제 팝업을 출력하도록 수정
                                         */
                                        if(false == btPhoneEnter) {
                                            btPhoneEnter = true;
                                            btSettingsEnter = true;
                                            MOp.clearScreen(11121);
                                        }

                                        MOp.hidePopup();
                                        MOp.recallScreen("BtDialMain", false, 114);
                                    }
                                } else {
                                    if(2 > callType) {
                                        /* 통화 종료 후 이전화면을 확인하여 주행규제가 필요한 화면이라면
                                         * 주행규제 팝업을 출력하도록 수정
                                         */
                                        if(false == btPhoneEnter) {
                                            btPhoneEnter = true;
                                            btSettingsEnter = true;
                                            MOp.clearScreen(11121);
                                        }

                                        MOp.hidePopup();
                                        MOp.recallScreen("BtDialMain", false, 114);
                                    }
                                }
                                MOp.returnFocus();
                            } else {
                                if("" != favoriteAdd) {
                                    favoriteAdd = ""
                                }
                                if(false == MOp.recallScreen("BtDialMain", 4087)) {
                                    // 이미 다이얼 화면이라면 Dial에서 Call 키 입력처리 해야 함
                                    if(systemPopupOn == true){
                                        //[15MY_Dynamic]Dial 화면에서 system popup이 떠있을 경우 해제 요청 후 Dial 화면 표시
                                        console.log("system popup true ==> close");
                                        BtCoreCtrl.invokeRequestCloseSystemPopup();
                                    }
                                    else{
                                        console.log("system popup false");
                                        sigDialCallKeyHandler();
                                    }
                                }
                            }
                        }
                    }
                } else {
                    qml_debug("popupState = " + popupState);
                    if(false == btPhoneEnter) {
                        if(3 /* CONNECT_STATE_CONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                            && 7 /* CONNECT_STATE_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                            && 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                            && (0 < BtCoreCtrl.m_pairedDeviceCount || true == parking)
                        ) {
                            btPhoneEnter = true;
                            btSettingsEnter = true;
//                            MOp.clearScreen(1112);
                        }
                    }

                    if(1 /* CONNECT_STATE_PAIRING */ == BtCoreCtrl.invokeGetConnectState()
                        && ("popup_Bt_Authentication_Wait_Btn" == popupState || "popup_Bt_Authentication_Wait" == popupState)) {
                        if("popup_Bt_Authentication_Wait" == popupState) {
                            //MOp.showPopup("popup_Bt_Authentication_Wait_Btn");

                            if(false == btPhoneEnter) {
                                MOp.showPopup("popup_Bt_Authentication_Wait");
                            } else {
                                MOp.showPopup("popup_Bt_Authentication_Wait_Btn");
                            }

                            MOp.returnFocus();
                        }
                    } else if("popup_Bt_SSP" == popupState) {
                        // do nothing
                    } else if(3 /* CONNECT_STATE_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                        || 7 /* CONNECT_STATE_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                        || 2 /* CONNECT_STATE_PAIRED */ == BtCoreCtrl.invokeGetConnectState()
                        || 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                    ) {
                        MOp.showPopup("popup_Bt_Connecting");
                        // TODO: ddingddong
                        MOp.returnFocus();
                    } else if(8 /* CONNECT_STATE_AUTOCONNECTING_PAIRED_FAILED */ == BtCoreCtrl.invokeGetConnectState()) {
                        // For IQS 페어링 실패 상태면 연결 중 팝업 출력
                        if(true == BtCoreCtrl.invokeGetStartConnectingFromHU()) {
                            // For IQS 페어링 실패 상태면 연결 중 팝업 출력
                            MOp.showPopup("popup_Bt_Connecting");
                        } else {
                            MOp.showPopup("popup_Bt_Connection_Auth_Fail_Ssp");
                        }
                    } else if(9 /* CONNECT_STATE_CONNECTING_CANCEL */ == BtCoreCtrl.invokeGetConnectState()) {
                        // 9 = 취소중 상태
                        MOp.showPopup("popup_Bt_Connect_Cancelling");
                        // TODO: ddingddong
                        MOp.returnFocus();
                    } else {
                        if(true == btDeleteMode) {
                            MOp.showPopup("popup_Bt_Deleting");
                        } else if("popup_Bt_SSP_Add" == popupState) {
                            BtCoreCtrl.invokeStartAutoConnect();
                        } else {
                            MOp.hidePopup();

                            if(0 < BtCoreCtrl.m_pairedDeviceCount) {
                                MOp.showPopup("popup_paired_list");
                            } else {
                                if(true == duringINI) {
                                    // 최초 부팅 시 App시작을 준비하는 중인 상태
                                    MOp.showPopup("popup_Bt_Ini");
                                } else if(false == parking) {
                                    // UX변경 - 주행중 등록 불가 팝업
                                    MOp.showPopup("popup_restrict_while_driving");
                                    if(false == btPhoneEnter)
                                    {
                                        UIListener.invokeRequestSetLastEntrySetting();
                                    }
                                } else {
                                    BtCoreCtrl.invokeSetDiscoverableMode(true);
                                    MOp.showPopup("popup_Bt_SSP_Add");
                                }
                            }
                        }
                    }
                }
            }
        }

        onSigHKCallLongHandler: {
            console.log("# [SIGNAL] onSigHKCallLongHandler");
            /* SWRC call(long)키가 눌린 경우 호출
             * 해당 Signal 수정 시 onSigHKCallShortHandler, onSigHKPhoneHandler Signal도 같이 적용해야 함
             */
            gSwrcInput = "Long"

            /* Home > Settings > Bluetooth Setting > Menu > Call Short Key
             * Dial 화면으로 전환되고 Menu 남아있는 문제
             */
            idMenu.hide();

            // ISV(NA) 75232
            /* Siri > HK Phone Key를 선택 했을 때 Home으로 빠지는 문제가 발생하기 때문에 hideSiriView(true)로 호출
             * Home으로 빠지는 이유: hideSiriView의 postBackKey()
             */
            MOp.hideSiriView(true);

            if(true == BtCoreCtrl.invokeIsAnyConnected()) {
                /* Profile 중 어떤 1개라도 연결되어 있을때
                 */
                if(false == BtCoreCtrl.invokeIsHFPConnected()) {
                    if(false == btPhoneEnter) {
                        btPhoneEnter = true;
                        btSettingsEnter = true;
                        MOp.clearScreen(11124);
                    }

                    if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                        || 10 /* CONNECT_STATE_PBAP_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                        || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                    ) {
                        // HFP를 지원하지 않고 연결이 완료된 상태에서 Home > Phone 선택 시 Dial 진입을 못하도록 함.
                        MOp.showPopup("popup_Bt_Not_Support_Bluetooth_Phone");
                    } else {
                        // For IQS
                        if(popupState != "popup_restrict_while_driving") {
                            // 연결중인 상태에서 HFP가 붙지 않았을 경우 Dial화면 진입이 불가하기 때문에 연결중 팝업을 띄운다
                            MOp.showPopup("popup_Bt_Connecting");
                        }
                    }
                //__IQS_15MY_ Call End Modify
                } else if(10 < callType || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) {
                    /* 통화중일때 Call SHORT이면 콜 화면으로 전환 + 3Way일때 Swap Call(Logic에서 수행)
                     */
                    //DEPRECATED MOp.clearScreen(3412);
                    // Incoming call이 아닌 경우에만 팝업 Hide
                    if(popupState != "Call_popup" && popupState != "Call_3way_popup" && popupState != "popup_bluelink_popup") {
                        MOp.hidePopup();
                    }

                    MOp.showCallView();
                } else {
                    /* 블루 링크 통화 중이지 않은 경우 일반 BT 통화 발생, 최근통화 목록 중 가장 마지막 목록을 가져옴
                     */
                    var lastNumber = BtCoreCtrl.invokeTrackerGetLastOutgoing();
                    console.log("# lastNumber = " + lastNumber);
                    if("" == lastNumber) {
                        if(popupState != "popup_Bt_No_CallHistory") {
                            switch(popupState) {
                                case "popup_Bt_Disconnect_By_Phone":
                                case "popup_launch_help_in_driving":
                                case "disconnectSuccessPopup":
                                case "popup_Bt_Max_Device":
                                case "popup_Bt_Dis_Connecting":
                                case "popup_Bt_Linkloss":
                                case "popup_Bt_Authentication_Wait_Btn":
                                case "popup_Bt_Ini":
                                case "popup_Bt_No_Device":
                                case "popup_Bt_No_Connection":
                                case "popup_Bt_Connect_Wait_Phone":
                                case "popup_Bt_SSP_Add":
                                case "popup_Bt_Connection_Auth_Fail_Ssp":
                                case "popup_Bt_Connection_Auth_Fail":
                                case "popup_Bt_Connection_Fail_Re_Connect":
                                case "popup_Bt_Not_Support_Bluetooth_Phone":
                                case "popup_restrict_while_driving":
                                case "popup_Bt_Connection_Fail":
                                case "popup_Bt_Initialized":
                                case "popup_Bt_Connect_Canceled":
                                case "popup_Bt_Connect_Cancelling":
                                case "popup_Bt_Phone_Request_Connect_Device":
                                case "popup_paired_list":
                                case "connectSuccessA2DPOnlyPopup":
                                case "popup_Bt_AutoConnect_Device_A2DPOnly":
                                case "popup_Bt_Connecting": {
                                    //do noting
                                    break;
                                }

                                default:
                                    // do nothing
                                    MOp.showPopup("popup_Bt_No_CallHistory");
                                    break;
                            }
                        } else {

                            /* No Action */
                        }
                        if(true == UIListener.invokeGetAppState()) {
                            MOp.showPopup("popup_bt_outgoing_calls_empty");
                        } else {
                            // UX 변경으로 팝업 > OSD로 변경 되어 팝업 삭제
                            //DEPRECATED MOp.showPopup("popup_toast_outgoing_calls_empty");
                        }
                    } else {
                        BtCoreCtrl.HandleCallStart(lastNumber);
                    }
                }
            } else {
                /* 16MY PreAudit Issue
		BT Setting -> SWRC LongPress -> No Operate
                 */
                qml_debug("popupState = " + popupState);
                if(false == btPhoneEnter) {
                    if(3 /* CONNECT_STATE_CONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                            && 7 /* CONNECT_STATE_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                            && 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()
                            && (0 < BtCoreCtrl.m_pairedDeviceCount || true == parking)
                            ) {
                        btPhoneEnter = true;
                        btSettingsEnter = true;
                        //                            MOp.clearScreen(1112);
                    }
                }

                if(1 /* CONNECT_STATE_PAIRING */ == BtCoreCtrl.invokeGetConnectState()
                        && ("popup_Bt_Authentication_Wait_Btn" == popupState || "popup_Bt_Authentication_Wait" == popupState)) {
                    if("popup_Bt_Authentication_Wait" == popupState) {
                        //MOp.showPopup("popup_Bt_Authentication_Wait_Btn");

                        if(false == btPhoneEnter) {
                            MOp.showPopup("popup_Bt_Authentication_Wait");
                        } else {
                            MOp.showPopup("popup_Bt_Authentication_Wait_Btn");
                        }

                        MOp.returnFocus();
                    }
                } else if("popup_Bt_SSP" == popupState) {
                    // do nothing
                } else if(3 /* CONNECT_STATE_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                          || 7 /* CONNECT_STATE_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                          || 2 /* CONNECT_STATE_PAIRED */ == BtCoreCtrl.invokeGetConnectState()
                          || 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                          ) {
                    MOp.showPopup("popup_Bt_Connecting");
                    // TODO: ddingddong
                    MOp.returnFocus();
                } else if(8 /* CONNECT_STATE_AUTOCONNECTING_PAIRED_FAILED */ == BtCoreCtrl.invokeGetConnectState()) {
                    // For IQS 페어링 실패 상태면 연결 중 팝업 출력
                    if(true == BtCoreCtrl.invokeGetStartConnectingFromHU()) {
                        // For IQS 페어링 실패 상태면 연결 중 팝업 출력
                        MOp.showPopup("popup_Bt_Connecting");
                    } else {
                        MOp.showPopup("popup_Bt_Connection_Auth_Fail_Ssp");
                    }
                } else if(9 /* CONNECT_STATE_CONNECTING_CANCEL */ == BtCoreCtrl.invokeGetConnectState()) {
                    // 9 = 취소중 상태
                    MOp.showPopup("popup_Bt_Connect_Cancelling");
                    // TODO: ddingddong
                    MOp.returnFocus();
                } else {
                    if(true == btDeleteMode) {
                        MOp.showPopup("popup_Bt_Deleting");
                    } else if("popup_Bt_SSP_Add" == popupState) {
                        MOp.returnFocus();
                        BtCoreCtrl.invokeStartAutoConnect();
                    } else {
                        MOp.hidePopup();

                        if(0 < BtCoreCtrl.m_pairedDeviceCount) {
                            MOp.showPopup("popup_paired_list");
                            //UIListener.invokeRequestForeground();
                        } else {
                            if(true == duringINI) {
                                // 최초 부팅 시 App시작을 준비하는 중인 상태
                                MOp.showPopup("popup_Bt_Ini");
                            } else if(false == parking) {
                                // UX변경 - 주행중 등록 불가 팝업
                                MOp.showPopup("popup_restrict_while_driving");
                                if(false == btPhoneEnter)
                                {
                                    UIListener.invokeRequestSetLastEntrySetting();
                                }
                            } else {
                                BtCoreCtrl.invokeSetDiscoverableMode(true);
                                MOp.showPopup("popup_Bt_SSP_Add");
                            }
                        }
                        UIListener.invokeRequestForeground();
                    }
                }
            }
        }

        onSigHKCallEndHandler: {
            console.log("#############################################");
            console.log("## Signal onSigHKCallEndHandler");
            console.log("#############################################");
            console.log("btPhoneEnter = " + btPhoneEnter);
            console.log("popupState = " + popupState);

            /* CALL HK or PHONE HK를 눌렀을 때 설정 화면이 아닌 Dial화면에 팝업이 뜨고
             * 이 때 CALL END HK를 누르면 이전 화면으로 빠지기 위한 처리
             * true == btPhoneEnter => 설정 화면이 아닌상태
             */
            if(true == btPhoneEnter) {
                switch(popupState) {
                    case "popup_Bt_Disconnect_By_Phone":
                    case "popup_launch_help_in_driving":
                    case "disconnectSuccessPopup":
                    case "popup_Bt_Max_Device":
                    case "popup_Bt_Dis_Connecting":
                    case "popup_Bt_Linkloss":
                    case "popup_Bt_Authentication_Wait_Btn":
                    case "popup_Bt_Ini":
                    case "popup_Bt_No_Device":
                    case "popup_Bt_No_Connection":
                    case "popup_Bt_Connect_Wait_Phone":
                    case "popup_Bt_SSP_Add":
                    case "popup_Bt_Connection_Auth_Fail_Ssp":
                    case "popup_Bt_Connection_Auth_Fail":
                    case "popup_Bt_Connection_Fail_Re_Connect":
                    case "popup_Bt_Not_Support_Bluetooth_Phone":
                    case "popup_restrict_while_driving":
                    case "popup_Bt_Connection_Fail":
                    case "popup_Bt_Initialized":
                    case "popup_Bt_Connect_Canceled":
                    case "popup_Bt_Connect_Cancelling":
                    case "popup_Bt_Phone_Request_Connect_Device":
                    case "popup_paired_list":
                    case "connectSuccessA2DPOnlyPopup":
                    case "popup_Bt_AutoConnect_Device_A2DPOnly":
                    case "popup_Bt_Connecting":
                    case "popup_Bt_Connecting_15MY": {
                        MOp.postPopupBackKey(5757);
                        break;
                    }

                    default:
                        // do nothing
                        break;
                }
            }
        }
    }

    Connections {
        target: UIListener

        onSigHKPhoneHandler: {
            console.log("#############################################");
            console.log("## onSigHKPhoneHandler");
            console.log("#############################################");
            /* 다이얼 화면 이외의 화면에 있을 경우 Dial 화면으로 전환
             * (설정화면에 있을 경우에도 다이얼 화면으로 전환해야 함)
             * 해당 Signal 수정 시 onSigHKCallShortHandler, onSigHKCallLongHandler Signal도 같이 적용해야 함
             */

            gSwrcInput = "Short"

            // ShowMenu > Phone > Dial > HideMenu
            idMenu.off();

            // ISV(NA) 75232
            /* Siri > HK Phone Key를 선택 했을 때 Home으로 빠지는 문제가 발생하기 때문에 hideSiriView(true)로 호출
             * Home으로 빠지는 이유: hideSiriView의 postBackKey()
             */
            MOp.hideSiriView(true);

            if("popup_Bt_SSP_Add" == popupState  && false == btPhoneEnter)
            {
                UIListener.invokeRequestSetLastEntrySetting();
                return;
            }

            if(0 < BtCoreCtrl.m_pairedDeviceCount || true == parking)
            {
                btPhoneEnter = true;
                btSettingsEnter = true;
            }

            //
            //DEPRECATED MOp.clearScreen(11125);
            /**************************************************************************
             * [주의] 유사한 코드가 FG Handler(연결되었을때 처리코드)와 PHONE, CALL short/long HK 에 존재함
             * (수정할 경우 함께 수정해야 함)
             **************************************************************************/
            if(3 /* CONNECT_STATE_CONNECTING */ == BtCoreCtrl.invokeGetConnectState() && false == BtCoreCtrl.invokeIsHFPConnected()) {
                BtCoreCtrl.invokeSetStartConnectingFromHU(true);
                MOp.showPopup("popup_Bt_Connecting");
            } else if(8 /* CONNECT_STATE_AUTOCONNECTING_PAIRED_FAILED */ == BtCoreCtrl.invokeGetConnectState()) {
                // For IQS 페어링 실패 상태면 연결 중 팝업 출력
                if(true == BtCoreCtrl.invokeGetStartConnectingFromHU()) {
                    // For IQS 페어링 실패 상태면 연결 중 팝업 출력
                    MOp.showPopup("popup_Bt_Connecting");
                } else {
                    MOp.showPopup("popup_Bt_Connection_Auth_Fail_Ssp");
                }
            } else if(9 /* CONNECT_STATE_CONNECTING_CANCEL */ == BtCoreCtrl.invokeGetConnectState()) {
                /* 9 = 취소중 상태
                 */
                MOp.showPopup("popup_Bt_Connect_Cancelling");
            } else if("popup_Bt_SSP" == popupState) {
                // do nothing
            } else if(7 /* CONNECT_STATE_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                || 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
            ) {
                if(false == BtCoreCtrl.invokeIsHFPConnected()) {
                    MOp.showPopup("popup_Bt_Connecting");
                } else {
                    if(true == BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                        /*블루 링크 통화 중 일때 팝업 출력 부분
                         */
                        if(10 == BtCoreCtrl.m_ncallState) {
                            // incoming call로 들어온 상태이므로 Blue Link Incoming Calll 팝업을 띄움(BtCallMain.qml)
                            MOp.showPopup("popup_bluelink_popup");
                        } else {
                            MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                        }
                    } else {
                        //__IQS_15MY_ Call End Modify
                        if(10 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                            // Incoming call이 아닌 경우에만 팝업 Hide
                            if(popupState != "Call_popup" && popupState != "Call_3way_popup" && popupState != "popup_bluelink_popup") {
                                MOp.hidePopup();
                            }

                            // 통화 중 진입 시 Call화면 표시
                            MOp.showCallView();
                        } else if(10 == BtCoreCtrl.m_ncallState) {
                            //DEPRECATED MOp.clearScreen(1111);
                            // 통화수신 팝업 표시중, do nothing
                        } else {
                            MOp.hidePopup();
                            MOp.recallScreen("BtDialMain", 4089);
                            pressContacts();
                        }
                    }
                }
            } else if(5 /* CONNECT_STATE_DISCONNECTING */ == BtCoreCtrl.invokeGetConnectState()) {
                if(false == btPhoneEnter) {
                    MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn");
                } else {
                    MOp.showPopup("popup_Bt_Dis_Connecting");
                }
            } else if(13 /* CONNECT_STATE_RECONNECTION */ == BtCoreCtrl.invokeGetConnectState()) {
                // do nothing
            } else if(true == BtCoreCtrl.invokeIsAnyConnected()) {
                /* 연결이 되어 있다면
                 */
                if(false == BtCoreCtrl.invokeIsHFPConnected()) {
                    if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                        || 10 /* CONNECT_STATE_PBAP_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                        || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()) {
                        // HFP를 지원하지 않고 연결이 완료된 상태에서 Home > Phone 선택 시 Dial 진입을 못하도록 함.
                        MOp.showPopup("popup_Bt_Not_Support_Bluetooth_Phone");
                    } else {
                        // For IQS
                        if(popupState != "popup_restrict_while_driving") {
                            // 연결중인 상태에서 HFP가 붙지 않았을 경우 Dial화면 진입이 불가하기 때문에 연결중 팝업을 띄운다
                            MOp.showPopup("popup_Bt_Connecting");
                        }
                    }
                } else {
                    //DEPRECATED MOp.clearScreen(11126);

                    if(true == BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                        /*블루 링크 통화 중 일때 팝업 출력 부분
                         */
                        if(BtCoreCtrl.m_ncallState == 10) {
                            // incoming call로 들어온 상태이므로 Blue Link Incoming Calll 팝업을 띄움(BtCallMain.qml)
                            MOp.showPopup("popup_bluelink_popup");
                        } else {
                            if(false == callPrivateMode){
                                MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                            } else {
                                if(0 < callType){
                                    if("BACKGROUND" == callViewState) {
                                        callViewState = "FOREGROUND"
                                        popScreen();
                                    } else {
                                        MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                                    }
                                }
                            }
                            //MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                        }
                    //__IQS_15MY_ Call End Modify
                    } else if(10 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                        // Incoming call이 아닌 경우에만 팝업 Hide
                        if(popupState != "Call_popup" && popupState != "Call_3way_popup" && popupState != "popup_bluelink_popup") {
                            MOp.hidePopup();
                        }

                        // 통화 중 진입 시 Call화면 표시
                        MOp.showCallView(7015);
                    } else if(10 == BtCoreCtrl.m_ncallState) {
                        // 통화수신 팝업 표시중
                    } else {
                        /* 전화번호부 요청 팝업에서 Phone HK 눌렀을 때, 팝업 사라지지 않는 문제 */
                        if("popup_Bt_Request_Phonebook" == popupState){
                            setBtDialScreen = true
                        }
                        MOp.hidePopup();
                        //[15MY_Dynamic]Dial 화면에서 system popup이 떠있을 경우 해제 요청 후 Dial 화면 표시
                        if(false == MOp.recallScreen("BtDialMain", 4092)) {
                            if(systemPopupOn == true){
                                console.log("system popup true ==> close");
                                BtCoreCtrl.invokeRequestCloseSystemPopup();
                            }
                            else{
                                console.log("system popup false");
                            }
                        }
                        favoriteAdd = "";
                        pressContacts();
                    }
                }
            } else if(1 /* CONNECT_STATE_PAIRING */ == BtCoreCtrl.invokeGetConnectState()
                      && ("popup_Bt_Authentication_Wait_Btn" == popupState || "popup_Bt_Authentication_Wait" == popupState)) {
                if("popup_Bt_Authentication_Wait" == popupState) {
                    // Switch popup
                    //MOp.showPopup("popup_Bt_Authentication_Wait_Btn");

                    if(false == btPhoneEnter) {
                        MOp.showPopup("popup_Bt_Authentication_Wait");
                    } else {
                        MOp.showPopup("popup_Bt_Authentication_Wait_Btn");
                    }
                    MOp.returnFocus();
                }
            } else if(2 /* CONNECT_SATE_PAIRED */ == BtCoreCtrl.invokeGetConnectState()
                      && ("popup_Bt_Connecting" == popupState || "popup_Bt_Connecting_15MY" == popupState)) {
                   // do nothing
            } else {
                if(true == btDeleteMode) {
                    MOp.showPopup("popup_Bt_Deleting");
                } else if("popup_Bt_SSP_Add" == popupState) {
                    BtCoreCtrl.invokeStartAutoConnect();
                } else {
                    MOp.hidePopup();

                    if(0 < BtCoreCtrl.m_pairedDeviceCount) {
                        MOp.showPopup("popup_paired_list");
                    } else {
                        if(true == duringINI) {
                            // 최초 부팅 시 App시작을 준비하는 중인 상태
                            MOp.showPopup("popup_Bt_Ini");
                        } else if(false == parking) {
                            // UX변경 - 주행중 등록 불가 팝업
                            MOp.showPopup("popup_restrict_while_driving");
                            if(false == btPhoneEnter)
                            {
                                UIListener.invokeRequestSetLastEntrySetting();
                            }
                        } else {
                            BtCoreCtrl.invokeSetDiscoverableMode(true);
                            MOp.showPopup("popup_Bt_SSP_Add");
                        }
                    }
                }
            }

            MOp.returnFocus(15);
        }
    }

    /* DEPRECATED signals(확인필요함!!!)
     */
    Connections {
        target: UIListener

        onSigEventAppEntryPoint: {
            qml_debug("Signal onSigEventAppEntryPoint")
            focusOn = true
            inputMode = "jog"
            //focusOn = m_jogModeEnable;
        }

        onSigStopCallEndTimer: {
            qml_debug("Signal onSigStopCallEndTimer");

            // 신규기기 등록 팝업 -> Cancel을 통해 종료될 때 다이얼 화면이 화면에 나타남
            //switchScreen("BtDialMain", false, 183);

            //mainViewState = "Dial";
            //mainBand.forceActiveFocus();

            if("popup_Bt_Call_Connect_Fail" == popupState) {
                BtCoreCtrl.invokeHandsfreeCallEndedEventToUISH();
            }
        }
    }

    /* Private mode on/off signals
     */
/*DEPRECATED
    Connections {
        target: BtCoreCtrl

        onPrivateModeOn: {
            qml_debug("## Signal onPrivateModeOn");
            callPrivateMode = true;
        }

        onPrivateModeOff: {
            qml_debug("## Signal onPrivateModeOff")
            callPrivateMode = false;
        }
    }
DEPRECATED*/

    /* Driving restriction on/off
     */
    Connections {
        target: UIListener

        /* //주행 규제 모드 Test 코드
        target: idAppMain
        */

        onSigBluetoothDrivingRestrictionShow: {
            qml_debug("## onSigBluetoothDrivingRestrictionShow, parking is FALSE");
            parking = false;

            //__IQS_15MY_ Call End Modify
            if(1 < callType || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) {
                /* 통화 종료 후 이전화면을 확인하여 주행규제가 필요한 화면이라면
                 * 주행규제 팝업을 출력하도록 수정
                 */
                if("FOREGROUND" != callViewState
                    && (popupState != "Call_popup"
                    && popupState != "Call_3way_popup"
                    && popupState != "popup_restrict_while_driving"
                    && popupState != "popup_bluelink_popup")) {

                    if(false == parking &&
                            (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
                        if("BtContactSearchMain" == idAppMain.state
                            || "SettingsBtNameChange" == idAppMain.state
                            || "SettingsBtPINCodeChange" == idAppMain.state) {
                                MOp.showPopup("popup_search_while_driving");
                        }
                    }
                }
            } else {
                //DEPRECATED callDTMFDialInput = "";
                if("BtContactSearchMain" == idAppMain.state
                        && (1 == UIListener.invokeGetCountryVariant()
                        || 6 == UIListener.invokeGetCountryVariant())) {
                    MOp.showPopup("popup_search_while_driving");

                } else if(("SettingsBtNameChange" == idAppMain.state || "SettingsBtPINCodeChange" == idAppMain.state)
                    && (1 == UIListener.invokeGetCountryVariant()
                        || 6 == UIListener.invokeGetCountryVariant())
                ) {
                    // popScreen(205);
                    MOp.showPopup("popup_search_while_driving");
                }

                switch(popupState) {
                    case "popup_Bt_SSP_Add": {
                        // For IQS
                        BtCoreCtrl.invokeStartAutoConnect();
                        MOp.showPopup("popup_restrict_while_driving");
                        break;
                    }

                    case "popup_Bt_No_Device": {
                        MOp.showPopup("popup_restrict_while_driving");
                        break;
                    }

                    case "popup_Bt_Other_Device_Connect_Menu": {
                        MOp.showPopup("popup_restrict_while_driving");
                        break;
                    }

                    default:
                        break;
                }
            }
        }

        onSigBluetoothDrivingRestrictionHide: {
            qml_debug("## onSigBluetoothDrivingRestrictionHide, parking is TRUE");
            parking = true;

            // PhoneBook 검색 진입 후 후방 카메라 On/Off시 주행 관련 popup 사라지지 않음.
            if("popup_search_while_driving" == popupState)  {
                MOp.hidePopup()
            }

            // 테스트 불가한 내용이므로 일단 주행규제 팝업에만 Hide popup 적용.
            // For IQS
            if("popup_restrict_while_driving" == popupState) {
                if(false == btPhoneEnter) {
                    if(3 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                        || 7 /* CONNECT_STATE_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                        || 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */  == BtCoreCtrl.invokeGetConnectState()
                    ) {
                        MOp.showPopup("popup_Bt_Connecting");
                    } else {
                        MOp.hidePopup();
                    }
                } else {
                    //DEPRECATED MOp.postBackKey(567);
                    //DEPRECATED MOp.postPopupBackKey(567);
                    MOp.postPopupBackKey();
                }
            }
        }
    }

    /* Initializing
     */
    Connections {
        target: BtCoreCtrl

        //[ITS 0270396]
        onSigEventPopScreen: {
               popScreen();
        }

        onBluetoothEventDeviceLinkLoss: {
            MOp.showPopup("popup_Bt_Linkloss");
        }

        onSigInitializationOn: {
            duringINI = true;
        }

        onSigInitializationOff: {
            duringINI = false;
            if("popup_Bt_Ini" == popupState) {
                MOp.postPopupBackKey(1);
            }
        }

    }

    Connections {
        target: UIListener

        onSigHomeSettingsBtSettingsEnable: {
            console.log("#########################################################");
            console.log("## screen = " + idAppMain.state)
            console.log("## HomeSettingBtSettings = " + entryPoint);
            console.log("## UIListener.invokeGetScreenSize = " + UIListener.invokeGetScreenSize());
            console.log("## UIListener.invokeTopScreen = " + UIListener.invokeTopScreen());
            console.log("## popupState = " + popupState)
            console.log("## btPhoneEnter = " + btPhoneEnter)
            console.log("#########################################################");

            // 후방 카메라/disp/power 을 통한 재진입 시 메뉴 사라지도록 수정
            //__IQS_15MY_ Call End Modify
            if(true == iqs_15My) {
                if(1 > callType || (false == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) {
                    // "DELAYED_IDLE" --> "IDLE"
                    MOp.initCallView(4010);
                }
            } else { 
                if(2 > callType) {
                    // "DELAYED_IDLE" --> "IDLE"
                    MOp.initCallView(4010);
                }
            }

/*DEPRECATED
            if("DELAYED_IDLE" == callViewState ){
                callViewState  = "IDLE"
            }
DEPRECATED*/

            appEntryPoint = entryPoint;
            switch(entryPoint) {
                case 8:
                case 2: {
                    /* Settings로 시작
                     */
                    console.log("## onSigHomeSettingsBtSettingsEnable - Settings");
                    btPhoneEnter = false;
                    //btSettingsEnter = false;

                    if(8 == appEntryPoint) {
                        // appEntryPoint 8이면 후방카메라에서 복귀하는 경우이므로 마지막 화면을 유지해야함
                        if("popup_Bt_Ini" == popupState || "popup_Bt_No_Device" == popupState || "popup_paired_list" == popupState
                                || "popup_restrict_while_driving" == popupState || "connectSuccessA2DPOnlyPopup" == popupState
                                || "popup_Bt_Connect_Canceled" == popupState) {
                            //ITS 0272020: UIListener.invokeGetAppState() == true 일 경우 App이 FG이므로 FG일때 팝업 유지
                            if(true == UIListener.invokeGetAppState() && popupState == "popup_restrict_while_driving" && parking == false) {
                                UIListener.invokeDebugString("FROM CAMERA");
                            } else {
                                UIListener.invokeDebugString("FROM PHONE");
                                MOp.hidePopup();
                            }
                        }
                    } else {
                        idMenu.off();

                        if("popup_Bt_Ini" == popupState || "popup_Bt_No_Device" == popupState || "popup_paired_list" == popupState
                                || "popup_restrict_while_driving" == popupState || "connectSuccessA2DPOnlyPopup" == popupState
                                || "popup_Bt_Connect_Canceled" == popupState) {
                            if(false == UIListener.invokeGetAppState() && popupState == "popup_restrict_while_driving" && parking == false) {
                                UIListener.invokeDebugString("FROM CAMERA");
                            } else {
                                UIListener.invokeDebugString("FROM PHONE");
                                MOp.hidePopup();
                            }
                        }
                        // Temporal Mode인 경우는 화면을 유지하도록 함
                        if(false == UIListener.invokeRequestDispOrCamera()) {
                            settingCurrentIndex = 0;
                            MOp.clearScreen(777);
                        }
                    }
                    break;
                }

                case 3: {
                    /* Siri로 시작
                     */
                    console.log("## onSigHomeSettingsBtSettingsEnable - Siri");
                    if(false == UIListener.invokeGetAppState()
                       && true == UIListener.invokeRequestDisplayMode()
                       ) {
                        // TODO: OJ 주석
                        MOp.clearScreen(773);
                    }

                    MOp.showSiriView();
                    break;
                }

                default: {
                    /* Dial로 시작(확인필요)
                     */
                    console.log("## onSigHomeSettingsBtSettingsEnable - Dial");

                    console.log("invokeRequestDispOrCamera = " + UIListener.invokeRequestDispOrCamera());

                    // 후방카메라 2번 동작 시 Call 승인 안되는 문제점
                    if((false == UIListener.invokeRequestDispOrCamera())
                       && (popupState != "Call_popup")
                       && (popupState != "Call_3way_popup")
                       && (popupState != "popup_bluelink_popup")
                    ) {
                        // TODO: 0으로 초기화가 맞는지 확인
                        settingCurrentIndex = 0;
                        btPhoneEnter = true;

                        if(false == btSettingsEnter) {
                            if("SettingsBtNameChange" == idAppMain.state
                             || "SettingsBtPINCodeChange" == idAppMain.state
                             || "BtDeviceDelMain" == idAppMain.state) {
                                popScreen();
                             }

                            popScreen();
                            btSettingsEnter = true
                        }
                    }

                    if(9 == appEntryPoint) {
                        // 후방카메라에서 복귀, do nothing
                        MOp.returnFocus();
                    } else {
                        // 즐겨찾기 모드 유지되는 문제점 수정
                        gContactFromCall = false;

                        if(false == siriLastViewSave) {
                            // Temporal Mode == true & incoming call인 경우는 화면을 유지하도록 함
                            if(false == UIListener.invokeRequestDispOrCamera()
                               && 10 != BtCoreCtrl.m_ncallState) {
                                MOp.clearScreen(778);
                                favoriteAdd = "";
                            }
                        } else {

                        }

                        idMenu.off();

                        if(0 < callType) {
                            switch(callViewState) {
                                case "BACKGROUND": {
                                    /* 전화중에 콜 화면이 화면에 표시되지 않는 상태
                                     * (콜 화면에서 전화번호부를 선택하고 HOME으로 빠진 상태를 가정할 수 있음)
                                     */
                                    MOp.showCallView(7016);
                                    if(true == callShowMicVolume) {
                                        sigHideMicOff();
                                    }
                                    break;
                                }

                                case "FOREGROUND": {
                                    if(true == callShowMicVolume) {
                                        // 마이크 음량 켜진 상태에서 Home으로 이동 후 재진입 시 화면 겹치는 부분 수정
                                        sigHideMicOff();
                                        //DEPRECATED callShowMicVolume = false;
                                    }

                                    break;
                                }

                                default:
                                    break;
                            }
                        } else {
                            /* 전화 중이 아닐때 재진입하면 지금까지 화면을 모두 초기화함
                             * appEntryPoint 9이면 후방카메라에서 복귀하는 경우이므로 마지막 화면을 유지해야함. 그래서 이외의 경우만 화면 변경함.
                             */
                            if(9 == appEntryPoint) {
                                // do nothing
                            } else {
                                phoneNumInput = "";
                            }
                        }
                    }

                    break;
                }
            }

            if(popupState == "popup_text") {
                popupTextFocusSet();
            }

        } // end of onSigHomeSettingsBtSettingsEnable()

        /* FOREGROUND event handler */
        onSigEventRequestFg: {
            //add. [ISV100233]
            bgrequested = false;
            console.log("onSigEventRequestFg set bgrequested : " + bgrequested);
            //end.
            console.log("################################################");
            console.log("onSigEventRequestFg");
            console.log("################################################");
            console.log("btPhoneEnter = " + btPhoneEnter);
            console.log("btSettingsEnter = " + btSettingsEnter);
            console.log("settingCurrentIndex = " + settingCurrentIndex);
            console.log("appEntryPoint = " + appEntryPoint);

            if(false == btPhoneEnter) {
                // 세팅 화면 진입

                // 시리 종료후 화면 저장하는 변수 초기화
                siriLastViewSave = false
                //__IQS_15MY_ Call End Modify)
                if(1 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                    if(8 == appEntryPoint) {
                        // 후방카메라에서 복귀하는데 화면이 아무것도 없다면 강제로 설정화면을 복구
                        MOp.recoverScreen("SETTINGS");
                    } else {
                        // settingCurrentIndex에 따라 알맞는 화면을 로딩
                        switch(settingCurrentIndex) {
                            case 1: pushScreen("SettingsBtAutoConn", 950);     break;
                            case 2: pushScreen("SettingsBtAutoDown", 951);     break;
                            case 3: pushScreen("SettingsBtAudioStream", 952);  break;
                            case 4: pushScreen("SettingsBtDeviceName", 953);   break;
                            case 5: pushScreen("SettingsBtCustomer", 954);     break;

                            case 0:
                            default:
                                pushScreen("SettingsBtDeviceConnect", 955);
                                //idLoaderSettingsLeft.forceActiveFocus();

                                // 설정 화면에서 후방카메라 복귀 시 포커스 수정 
                                if("" != popupState) {
                                    MOp.returnFocus();
                                }

                                break;
                        }
                    }

                    if(10 != BtCoreCtrl.m_ncallState 
                      && (false == UIListener.invokeRequestDispOrCamera()
                         || (true == UIListener.invokeRequestDispOrCamera() && 0 != appEntryPoint && 9 != appEntryPoint))) {
                        // 통화중 통화중 진입 막음
                        if("Call_3way_popup" == popupState){
                        } else{
                        MOp.showPopup("popup_enter_setting_during_call");
                        // 통화중 setting 진입 popup 상태 설정
                        BtCoreCtrl.invokeSetEnterSettingDuringCall(true);
                        }
                    }
                } else {
                    if(8 == appEntryPoint) {
                        /* 설정 화면에서 PHONE HK, CALL로 아래 팝업이 뜨고 아니오 선택했을 때 팝업 남아있는 문제
                         * UISH로 부터 TemporalMode true넘어오고 entryPoint 설정으로 전달됨
                         * 설정 화면에서 연결 취소 중 PHONE HK, CALL로 화면 전환 후 취소 완료 팝업에서 3초 후 설정화면으로 돌아왔을 때 팝업 남아있는 문제
                         */
                        qml_debug("UIListener.invokeRequestDispOrCamera() = " + UIListener.invokeRequestDispOrCamera());
                        if(true == UIListener.invokeRequestDispOrCamera()
                            && (popupState == "popup_Bt_Disconnect_By_Phone" || popupState == "popup_Bt_No_Device"        || popupState == "popup_paired_list"
                             || popupState == "popup_Bt_SSP_Add"             || popupState == "popup_Bt_Connect_Canceled" || popupState == "popup_Bt_Max_Device"
                             || popupState == "popup_restrict_while_driving" || popupState == "popup_Bt_Connection_Auth_Fail_Ssp" || popupState == "popup_Bt_Initialized" || popupState == "popup_Bt_Deleted")
                        ) {
                            if(popupState == "popup_restrict_while_driving" && parking == false) {
                                /* ITS 0228864
                                 *후방카메라에서 진입 할 때, 현재 주행규제 팝업이 표시되고 주행 상태일때, 팝업 사라지지 않도록 수정
                                 */
                            } else {
                                MOp.hidePopup();
                            }
                        }

                        if(1 /* CONNECT_STATE_PAIRING */ == BtCoreCtrl.invokeGetConnectState()
                            && ("popup_Bt_Authentication_Wait_Btn" == popupState || "popup_Bt_Authentication_Wait" == popupState)) {
                            if("popup_Bt_Authentication_Wait_Btn" == popupState) {
                                MOp.showPopup("popup_Bt_Authentication_Wait");
                            }
                        }

                        // 후방카메라에서 복귀하는데 화면이 아무것도 없다면 강제로 설정화면을 복구
                        if(1 > UIListener.invokeGetScreenSize()) {
                            MOp.recoverScreen("SETTINGS");
                        } else {
                            // 키패드 설정 진입 이후 되돌아오는 경우 이름 설정 화면으로 이동하도록 조건 추가
                            MOp.recoverScreen("");
                        }
                    } else if(3 == appEntryPoint) {
                        // 이미 설정화면이고 Siri화면으로 진입했을 경우
                    } else {
                        if(1 /* CONNECT_STATE_PAIRING */ == BtCoreCtrl.invokeGetConnectState()
                            && ("popup_Bt_Authentication_Wait_Btn" == popupState || "popup_Bt_Authentication_Wait" == popupState)) {
                            if("popup_Bt_Authentication_Wait_Btn" == popupState) {
                                MOp.showPopup("popup_Bt_Authentication_Wait");
                            }
                        } else if(1 /* CONNECT_STATE_PAIRING */ == BtCoreCtrl.invokeGetConnectState() && popupState == "popup_Bt_SSP") {
                            // 5초 페어링 팝업 >> Home >> 설정 재진입 시 5초 페어링 팝업 유지하도록 처리
                        } else if(true == btDeleteMode) {
                            // 삭제 중인 상태
                            MOp.showPopup("popup_Bt_Deleting");
                        } else if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
                            // do nothing
                        } else {
                            if(1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant()) {
                                // 북미향지에서 동작(TTS때문에 구분해서 동작해야됨)
                                if("popup_Contact_Down_fail" == popupState || "popup_Contact_Down_fail_EU" == popupState) {
                                    // do nothing
                                } else if(true == UIListener.invokeRequestDispOrCamera()) {
                                    // do nothing(Temporal Mode인 경우는 이전 화면을 유지해야됨)
                                } else {
                                    if("popup_Bt_Connecting_15MY" != popupState){
                                        MOp.hidePopup();
                                    }
                                }
                            } else if(true == UIListener.invokeRequestDispOrCamera()) {
                                // do nothing(Temporal Mode인 경우는 이전 화면을 유지해야됨)
                            } else {
                                // 북미 외 향지에서 동작
                                //[ITS 0266896]전체향지 적용.
                                if("popup_Bt_Connecting_15MY" != popupState){
                                    MOp.hidePopup();
                                }
                            }
                        }

                        if((false == UIListener.invokeRequestDispOrCamera())
                            && ("SettingsBtNameChange" != idAppMain.state  && "SettingsBtPINCodeChange" != idAppMain.state && "BtDeviceDelMain" != idAppMain.state)
                        ) {
                            // settingCurrentIndex에 따라 알맞는 화면을 로딩
                            switch(settingCurrentIndex) {
                                case 1: pushScreen("SettingsBtAutoConn", 950);     break;
                                case 2: pushScreen("SettingsBtAutoDown", 951);     break;
                                case 3: pushScreen("SettingsBtAudioStream", 952);  break;
                                case 4: pushScreen("SettingsBtDeviceName", 953);   break;
                                case 5: pushScreen("SettingsBtCustomer", 954);     break;

                                case 0:
                                default:
                                pushScreen("SettingsBtDeviceConnect", 955);
                                //idLoaderSettingsLeft.forceActiveFocus();
                                break;
                            }
                        } else if(1 > UIListener.invokeGetScreenSize() && 2 == appEntryPoint) {
                            // 설정화면으로 돌아 갈 때, 배경에 화면이 없는경우 설정 기본화면 그리도록 수정
                            MOp.recoverScreen("SETTINGS");
                        }
                    }
                }

                if(popupState == "popup_text") {
                    popupTextFocusSet();
                }

            } else if(3 == appEntryPoint) {
                /* 3 == Siri
                 */
            } else {
                /* BT 화면(Dial) 진입
                 */
                qml_debug("parking = " + parking);
                qml_debug("BtCoreCtrl.m_pairedDeviceCount = " + BtCoreCtrl.m_pairedDeviceCount);
                qml_debug("BtCoreCtrl.invokeIsAnyConnected() = " + BtCoreCtrl.invokeIsAnyConnected());
                qml_debug("BtCoreCtrl.invokeGetConnectState() = " + BtCoreCtrl.invokeGetConnectState());
                qml_debug("popupState = " + popupState);

                if(true == duringINI) {
                    // 최초 부팅 시 App시작을 준비하는 중인 상태
                    MOp.showPopup("popup_Bt_Ini");
                } else {
                    /**************************************************************************
                     * [주의] 유사한 코드가 FG Handler(연결되었을때 처리코드)와 PHONE, CALL short/long HK 에 존재함
                     * (수정할 경우 함께 수정해야 함)
                     *************************************************************************/
                    if(12 /* CONNECT_STATE_CONNECTING_FAILED */ == BtCoreCtrl.invokeGetConnectState()) {
                        MOp.showPopup("popup_Bt_Connection_Fail_Re_Connect");
                    } else if(3 /* CONNECT_STATE_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                                && false == BtCoreCtrl.invokeIsHFPConnected()) {
                        BtCoreCtrl.invokeSetStartConnectingFromHU(true);
                        MOp.showPopup("popup_Bt_Connecting");
                    } else if(8 /* CONNECT_STATE_AUTOCONNECTING_PAIRED_FAILED */ == BtCoreCtrl.invokeGetConnectState()) {
                        qml_debug("Variant = " + UIListener.invokeGetCountryVariant());
                        qml_debug("popupState = " + popupState);
                        if(1 == UIListener.invokeGetCountryVariant()  || 6 == UIListener.invokeGetCountryVariant()) {
                            // 북미, 캐나다 향지에서는 TTS와 팝업이 동시에 출력되어야 하기 때문에 페어링 실패 팝업을 무조건 출력된다.
                        } else {
                            if(true == BtCoreCtrl.invokeGetStartConnectingFromHU()) {
                                // For IQS 페어링 실패 상태면 연결 중 팝업 출력
                                MOp.showPopup("popup_Bt_Connecting");
                            } else {
                                MOp.showPopup("popup_Bt_Connection_Auth_Fail_Ssp");
                            }
                        }
                    } else if(9 /* CONNECT_STATE_CONNECTING_CANCEL */ == BtCoreCtrl.invokeGetConnectState()) {
                        MOp.showPopup("popup_Bt_Connect_Cancelling");
                    } else if("popup_Bt_SSP" == popupState) {
                        // do nothing
                    } else if(7 /* CONNECT_STATE_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                        || 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                    ) {
                        if(false == BtCoreCtrl.invokeIsHFPConnected()) {
                            if(1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant()) {
                                if("popup_Bt_Connection_Auth_Fail_Ssp" == popupState) {
                                    // 북미, 캐나다 향지에서는 TTS와 팝업 둘다 출력되기 때문에 페어링 실패 팝업을 유지해야 함
                                } else {
                                    MOp.showPopup("popup_Bt_Connecting");
                                }
                            } else {
                                MOp.showPopup("popup_Bt_Connecting");
                            }
                        } else {
                            if(true == BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                                /*블루 링크 통화 중 일때 팝업 출력 부분
                                 */
                                if(BtCoreCtrl.m_ncallState == 10) {
                                    // incoming call로 들어온 상태이므로 Blue Link Incoming Calll 팝업을 띄움(BtCallMain.qml)
                                    MOp.showPopup("popup_bluelink_popup");
                                } else {
                                    MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                                }
                            } else {
                                if(9 == appEntryPoint) {
                                    MOp.recoverScreen("DIAL", 3003);
                                } else {
                                    //__IQS_15MY_ Call End Modify
                                    if(10 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                                        // Incoming call이 아닌 경우에만 팝업 Hide
                                        if(popupState != "Call_popup" && popupState != "Call_3way_popup" && popupState != "popup_bluelink_popup") {
                                            MOp.hidePopup();
                                        }

                                        // 통화중
                                        //pushScreen("BtDialMain", 9);
                                        MOp.showCallView(7001);
                                    } else if(10 == BtCoreCtrl.m_ncallState) {
                                        if(popupState == "popup_bluelink_popup")
                                        {
                                            MOp.showPopup("Call_popup");
                                        }
                                        // 통화수신 팝업 표시중, do nothing
                                    } else {
                                        /* 이전화면에서 띄운 팝업이 남아 있는 경우가 있음(e.g. 즐겨찾기 추가 팝업 등)
                                         * 추가 테스트 필요함!!!!!!
                                         */
                                        if("popup_bt_outgoing_calls_empty" == popupState
                                            || "popup_toast_outgoing_calls_empty" == popupState) {
                                            // do nothing
                                        } else {
                                            if(true == gNoOutgoing) {
                                                gNoOutgoing = false; // reset flag

                                                pushScreen("BtDialMain", 9);

                                                if(true == UIListener.invokeRequestDispOrCamera()) {
                                                    MOp.showPopup("popup_Bt_No_CallHistory");
                                                } else {
                                                    MOp.showPopup("popup_Bt_No_Outgoing_Call_Power_Off");
                                                }
                                            } else {
                                                MOp.hidePopup();
                                                pushScreen("BtDialMain", 9);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else if(5 /* CONNECT_STATE_DISCONNECTING */ == BtCoreCtrl.invokeGetConnectState()) {
                        if(false == btPhoneEnter) {
                            MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn");
                        } else {
                            MOp.showPopup("popup_Bt_Dis_Connecting");
                        }
                    } else if(13 /* CONNECT_STATE_RECONNECTION */ == BtCoreCtrl.invokeGetConnectState()) {
                        // do nothing
                    } else if(true == BtCoreCtrl.invokeIsAnyConnected()) {
                        /* 연결이 되어 있다면
                         */
                        if(false == BtCoreCtrl.invokeIsHFPConnected()) {
                            if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                                || 10 /* CONNECT_STATE_PBAP_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                                || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                            ) {
                                if("popup_Bt_AutoConnect_Device_A2DPOnly" == popupState) {
                                    // 최초 페어링인 경우 자동연결 우선순위 팝업 출력
                                } else {
                                    // HFP를 지원하지 않고 연결이 완료된 상태에서 Home > Phone 선택 시 Dial 진입을 못하도록 함.
                                    MOp.showPopup("popup_Bt_Not_Support_Bluetooth_Phone");
                                }
                            } else {
                                // For IQS
                                if(popupState != "popup_restrict_while_driving") {
                                    // 연결중인 상태에서 HFP가 붙지 않았을 경우 Dial화면 진입이 불가하기 때문에 연결중 팝업을 띄운다
                                    MOp.showPopup("popup_Bt_Connecting");
                                }
                            }
                        } else {
                            if(BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                                /*블루 링크 통화 중 일때 팝업 출력 부분
                                 */
                                if(BtCoreCtrl.m_ncallState == 10) {
                                    // incoming call로 들어온 상태이므로 Blue Link Incoming Calll 팝업을 띄움(BtCallMain.qml)
                                    MOp.showPopup("popup_bluelink_popup");
                                } else {
                                    setButtonFocus();
                                    MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                                }
                            } else {
                                if(9 == appEntryPoint) {
                                    /* Dial 화면상태 > 폰에서 연결 해제 > 재연결 팝업 > 후방 카메라 ON > 폰에서 연결 > 후방 카메라 OFF
                                     * 재연결 팝업 남아있는 문제 수정사항
                                     */
                                    if("popup_Bt_Disconnect_By_Phone" == popupState || "popup_Bt_No_Device" == popupState
                                        || "popup_paired_list" == popupState        || "popup_Bt_SSP_Add" == popupState
                                        || "popup_Bt_Connect_Canceled" == popupState) {
                                        MOp.hidePopup();
                                    }

                                    MOp.recoverScreen("DIAL", 8989);
                                } else {
                                    //__IQS_15MY_ Call End Modify
                                    if(10 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                                        // Incoming call이 아닌 경우에만 팝업 Hide
                                        if(popupState != "Call_popup"
                                           && popupState != "Call_3way_popup"
                                           && popupState != "popup_bluelink_popup"
                                           && popupState != "popup_Contact_Change"
                                           && MOp.getPopupState() != "popup_bt_not_transfer_call"
                                           && MOp.getPopupState() != "popup_during_bluelink_not_transfer"
                                           && MOp.getPopupState() != "popup_Dim_For_Call"
                                        ) {
                                            MOp.hidePopup();
                                        }
                                        //pushScreen("BtDialMain", 9);
                                        // 통화 중 진입 시 Call화면 표시
                                        MOp.showCallView(7001);
                                    } else if(10 == BtCoreCtrl.m_ncallState) {
                                        if(popupState == "popup_bluelink_popup")
                                        {
                                            MOp.showPopup("Call_popup");
                                        }
                                        // 통화수신 팝업 표시중
                                        MOp.returnFocus();
                                    } else {
                                        /* 이전화면에서 띄운 팝업이 남아 있는 경우가 있음(e.g. 즐겨찾기 추가 팝업 등)
                                         * 추가 테스트 필요함!!!!!!
                                         */
                                        if("popup_bt_outgoing_calls_empty" == popupState
                                            || "popup_bt_no_phonebook_on_phone" == popupState
                                            || "popup_toast_outgoing_calls_empty" == popupState
                                        ) {
                                            // do nothing
                                        } else {
                                            if(true == gNoOutgoing) {
                                                gNoOutgoing = false; // reset flag

                                                pushScreen("BtDialMain", 9);

                                                if(true == UIListener.invokeRequestDispOrCamera()) {
                                                    MOp.showPopup("popup_Bt_No_CallHistory");
                                                } else {
                                                    MOp.showPopup("popup_Bt_No_Outgoing_Call_Power_Off");
                                                }
                                            } else {
                                                if(true == iqs_15My || (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
                                                    // 북미향지에서 동작(TTS때문에 구분해서 동작해야됨)
                                                    if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
                                                        // do nothing
                                                        if(UIListener.invokeGetPopupFgRequestWhilePoweroff() == true){
                                                            BtCoreCtrl.invokeSetRequestForegroundTTSPopup(false);
                                                        } else if (UIListener.invokeGetNeedPostBackKey()) {
                                                             MOp.postPopupBackKey(9090);
                                                        }
                                                    } else {
                                                        if("popup_Contact_Down_fail" == popupState || "popup_Contact_Down_fail_EU" == popupState) {
                                                            BtCoreCtrl.invokeSetPhonebookState();
                                                        }
                                                        if("popup_Bt_AutoConnect_Device" != popupState)//[ITS 0272561]
                                                        {
                                                            MOp.hidePopup();
                                                        }
                                                    }
                                                } else {
                                                    // 북미 외 향지에서 동작
                                                    MOp.hidePopup();
                                                }

                                                if(false == siriLastViewSave && false == UIListener.invokeRequestDispOrCamera()) {
                                                		//ITS 0245409
                                                    if("popup_Bt_Request_Phonebook" != popupState){
                                                    		pushScreen("BtDialMain", 29);
                                                    }
                                                } else {
                                                    // 시리 화면에서 돌아올때 이전화면이 남아있어야 됨
                                                    MOp.recoverScreen("DIAL");
                                                    siriLastViewSave = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else if(1 /* CONNECT_STATE_PAIRING */ == BtCoreCtrl.invokeGetConnectState()
                        && ("popup_Bt_Authentication_Wait_Btn" == popupState || "popup_Bt_Authentication_Wait" == popupState)
                    ) {
                        if("popup_Bt_Authentication_Wait" == popupState) {
                            // Switch popup
                            if(false == btPhoneEnter) {
                                MOp.showPopup("popup_Bt_Authentication_Wait");
                            } else {
                                MOp.showPopup("popup_Bt_Authentication_Wait_Btn");
                            }

                            //MOp.showPopup("popup_Bt_Authentication_Wait_Btn");
                            MOp.returnFocus();
                        }
                    } else if(2 /* CONNECT_SATE_PAIRED */ == BtCoreCtrl.invokeGetConnectState()
                              && ("popup_Bt_Connecting" == popupState || "popup_Bt_Connecting_15MY" == popupState)) {
                        // do nothing
                    } else {
                        if("popup_Bt_Connection_Fail_Re_Connect" != popupState) {
                            if(true == btDeleteMode) {
                                MOp.showPopup("popup_Bt_Deleting");
                            } else {
                                if((popupState == "popup_restrict_while_driving" || popupState == "popup_Bt_No_Device")
                                    && false == UIListener.invokeRequestDisplayMode()
                                    && false == UIListener.invokeRequestCameraMode()
                                ) {
                                    // do nothing
                                } else {
                                    MOp.hidePopup();
                                }

                                if(0 < BtCoreCtrl.m_pairedDeviceCount) {
                                    if(popupState == "popup_restrict_while_driving") {

                                    } else {
                                        MOp.showPopup("popup_paired_list");
                                    }
                                } else {
                                    // UX변경 - 주행중 등록 불가 팝업
                                    if(false == parking) {
                                        MOp.showPopup("popup_restrict_while_driving");
                                    } else {
                                        BtCoreCtrl.invokeSetDiscoverableMode(true);
                                        MOp.showPopup("popup_Bt_SSP_Add");
                                    }
                                }
                            }
                        }
                    }
                }

                MOp.returnFocus(9081);
            }
        }

        /* BACKGROUND event handler */
        onSigEventRequestBg: {
            // 시리 종료후 화면 저장하는 변수 초기화
            siriLastViewSave = false;
            btnReleased();
            //add. [ISV100233]
            bgrequested = false;
            console.log("onSigEventRequestBg set bgrequested : " + bgrequested);
            //end.
            sigshowPopup()

            console.log("##############################");
            console.log("onSigEventRequestBg");
            console.log("##############################");
            idMenu.hide();

            console.log("close SiriView");
            MOp.closeSiriView();


            // TODO:
            phoneNumInput = ""

            // TODO:
            btPhoneEnter = true;
            btSettingsEnter = true;

            switch(popupState) {
                case "popup_Contact_Change":
                case "popup_enter_setting_during_call":
                case "popup_Bt_Ini":
                case "popup_Bt_No_Device":
                case "popup_Bt_Request_Phonebook":
                //DEPRECATEDcase "popup_Bt_No_Connection":
                case "popup_Bt_AutoConnect_Device":
                case "popup_Bt_Not_Support_Bluetooth_Phone":
                case "popup_Bt_AutoConnect_Device_A2DPOnly": {
                    /* 진입시점에 화면 대신 팝업이 뜨는 경우 Back key로 종료될 경우
                     * BG Event에서 팝업을 없애줘야 함
                     */
                    MOp.hidePopup();
                    break;
                }

                case "popup_Bt_Contacts_Update":
                case "popup_Bt_Contacts_Update_Search": {
                    if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
                        BtCoreCtrl.invokeSetRequestForegroundTTSPopup(false);
                    }

                    MOp.hidePopup();
                    break;
                }

                // case "popup_bluelink_popup":
                case "popup_bluelink_popup_Outgoing_Call": {
                    MOp.hidePopup();
                    break;
                }

                case "popup_Bt_Connection_Fail":
                case "popup_Bt_Connection_Fail_Re_Connect": {
                    BtCoreCtrl.invokeSetConnectingDeviceID(-1 /* BT_INVALID */);
                    BtCoreCtrl.invokeSetStartConnectingFromHU(false);
                    qml_debug("CONNECT_STATE_IDLE ##########");
                    BtCoreCtrl.invokeSetConnectState(0 /* CONNECT_STATE_IDLE */);
                    MOp.hidePopup();
                    break;
                }

                case "popup_Bt_Connection_Fail_15MY": {
                    MOp.hidePopup();
                    break;
                }

                case "popup_Bt_Disconnect_By_Phone": {
                    qml_debug("case popup_Bt_Disconnect_By_Phone:");
                    if(14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                        || 13 /* CONNECT_STATE_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                    ) {   // __IQS__
                        MOp.showPopup("popup_Bt_Connecting");
                    } else {
                        BtCoreCtrl.invokeSetConnectingDeviceID(-1 /* BT_INVALID */);
                        BtCoreCtrl.invokeSetStartConnectingFromHU(false);
                        qml_debug("CONNECT_STATE_IDLE ##########");
                        BtCoreCtrl.invokeSetConnectState(0 /* CONNECT_STATE_IDLE */);
                        MOp.hidePopup();
                    }
                    break;
                }

                case "popup_Bt_SSP_Add": {
                    /* SSP 팝업을 띄우면서 DiscoverableMode가 true인 상태에서 Home키를 눌렀을 때
                     * SSP 팝업을 Hide하고 DiscoverableMode를 false로 설정한다.
                     * For IQS(SSP 팝업에서 Home키를 눌렀을 때 자동연결을 실행
                     */
                    BtCoreCtrl.invokeSetDiscoverableMode(false);
                    MOp.hidePopup();

                    // For IQS
                    BtCoreCtrl.invokeStartAutoConnect();
                    break;
                }
                case "popup_Bt_Connection_Auth_Fail_Ssp": {
                    MOp.hidePopup();

                    // For IQS
                    BtCoreCtrl.invokeSetConnectState(0 /* CONNECT_STATE_IDLE */);
                    BtCoreCtrl.invokeStartAutoConnect();
                    break;
                }

                case "popup_Contact_Down_fail":
                case "popup_Contact_Down_fail_EU": {
                    /* 폰북 다운로드 실패팝업이 떠있는 상태에서 Home버튼을 눌렀을 때 팝업을 Hide하고
                     * 폰북 화면은 기존 데이타가 있으면 보이도록(Have State) 상태를 변경하도록 한다.
                     */
                    BtCoreCtrl.invokeSetPhonebookState();
                    MOp.hidePopup();
                    break;
                }

                case "popup_Bt_PBAP_Not_Support": {
                    /* BG 상태에서 FG요청으로 BT진입하여 해당 팝업이 출력되고
                     * 다시 BG로 빠질때 팝업을 Hide해야함
                     */
                    MOp.hidePopup();
                    break;
                }

                default:
                    break;
            }

            //mainViewState = "";

            //__IQS_15MY_ Call End Modify
            if(true == iqs_15My) {
                if(1 == callType && false == BtCoreCtrl.m_bIsCallEndViewState) {
                    /* 통화종료 중일때 back 키를 통해 밖으로 빠져나간 경우 바로 콜 화면을 초기화 함
                     * 통화종료 중일때 HOME -> 재진입 case에 콜화면을 다시 표시하는 로직과(onSigEventRequestFG)
                     * call type이 0으로 바뀌며 콜화면을 없애는 로직이 엉켜 콜 화면이 계속 표시되는 문제 발생함
                     *
                     * [주의] 같은 로직이 onSigEventRequestBG와 BtCallMain backKeyHandler() 2곳에 존재함
                     */
                    MOp.initCallView(4011);

                // 통화 중 BG로 이동시 이전에 저장된 LastView 초기화
                } else if (10 < callType || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) {
                    lastView = ""
                }                
            } else { 
                if(1 == callType) {
                    /* 통화종료 중일때 back 키를 통해 밖으로 빠져나간 경우 바로 콜 화면을 초기화 함
                     * 통화종료 중일때 HOME -> 재진입 case에 콜화면을 다시 표시하는 로직과(onSigEventRequestFG)
                     * call type이 0으로 바뀌며 콜화면을 없애는 로직이 엉켜 콜 화면이 계속 표시되는 문제 발생함
                     *
                     * [주의] 같은 로직이 onSigEventRequestBG와 BtCallMain backKeyHandler() 2곳에 존재함
                     */
                    MOp.initCallView(4011);

                // 통화 중 BG로 이동시 이전에 저장된 LastView 초기화
                } else if (10 < callType) {
                    lastView = ""
                }
            }

/*DEPRECATED
            //BG때 계속 유지하고, FG 받을때 DELAYED_IDLE이면 IDLE로 설정
            if("DELAYED_IDLE" == callViewState) {
                MOp.initCallView(4012);
            }
DEPRECATED*/

            // __NEW_FORD_PATENT__ start  포더 특허 변경 사양 적용.
            // BG시 포드특허 팝업 hide
            if(("popup_bt_switch_handfree"  == MOp.getPopupState())
                || ("popup_bt_switch_handfreeNavi"  == MOp.getPopupState())) {
                MOp.hidePopup();
            }
            // __NEW_FORD_PATENT__ end

            //__IQS_15MY_ Call End Modify
            if("popup_Dim_For_Call" == MOp.getPopupState()) {
                MOp.hidePopup();
            }
        }

        /* TEMPORARL BACKGROUND - 후방카메라, DISP 버튼을 눌렀을 때 Background 동작 */
        onSigEventRequestTemporalBg: {
            btnReleased();

            console.log("###########################################");
            console.log("onSigEventRequestTemporalBg");
            console.log("###########################################");
            qml_debug("onSigEventRequestTemporalBg");

            MOp.closeSiriView();

            /* 신규 기기등록 팝업 show(Discoverable Mode true) 상태이면
             * 팝업 hide(Discoverable Mode false)
             */
            if(popupState == "popup_Bt_SSP_Add") {
                //DEPRECATED For IQS MOp.hidePopup();
                BtCoreCtrl.invokeStartAutoConnect();
            }

            // __NEW_FORD_PATENT__ start  포더 특허 변경 사양 적용.
            // BG시 포드특허 팝업 hide
            if(("popup_bt_switch_handfree"  == MOp.getPopupState())
                || ("popup_bt_switch_handfreeNavi"  == MOp.getPopupState())) {
                MOp.hidePopup();
            }
            // __NEW_FORD_PATENT__ end

            //__IQS_15MY_ Call End Modify
            if("popup_Dim_For_Call" == MOp.getPopupState()) {
                MOp.hidePopup();
            }

            //__IQS_16MY_
            if("popup_Bt_AutoConnect_Device" == MOp.getPopupState() && true == UIListener.invokeRequestVR()) {
                MOp.hidePopup();
            }

        }
    }

    Connections {
        target: BtCoreCtrl

        onSigEventAutoConnectStart: {
            autoConnectStart = true;
        }

        onSigEventAutoConnectStop: {
            autoConnectStart = false;
        }

        onSigEventPairingFailed : {
            // Auth fail popup(Failed auth SSP)
            // For IQS
            if(popupState != "popup_restrict_while_driving") {
                MOp.showPopup("popup_Bt_Connection_Auth_Fail_Ssp");
            }
        }


        /* DOWNLOAD State Manager */
        /* Favorite download state
         */
        onSigFavoriteStateChanged: {
            console.log("# [SIGNAL] onSigFavoriteStateChanged() " + nState);
            switch(nState) {
                case 1: {   // HAVE
                    favoriteValue = 1;
                    if("Favorite" == mainViewState) {
                        switchScreen("BtFavoriteMain", false, 999);
                    }

                    break;
                }

                default: {  // EMPTY
                    favoriteValue = 0;
                    //infoState = "FavoritesNoList";

                    if("Favorite" == mainViewState) {
                        //switchScreen("BtInfoView", false, 998);
                        MOp.switchInfoViewScreen("FavoritesNoList");
                    }

                    break;
                }
            }

            favorite_nstate = nState;
        }
    }

    /* SIRI */
    Connections {
        target: BtCoreCtrl

        onSigEventSiriStart: {
            console.log("### onSigEventSiriStart");
            MOp.showSiriView();
        }

        onSigEventSiriStop: {
            console.log("### onSigEventSiriStop = " + switchScreen);
            MOp.hideSiriView(switchScreen);
        }

        onSigEventSiriClose: {
            console.log("### onSigEventSiriClose");
            MOp.closeSiriView();
        }
    }

    /* PROJECTION*/
    Connections {
        target: BtCoreCtrl

        onSigHiddenDeviceDeleteMode: {
            console.log("### onSigHiddenDeviceDeleteMode");
            btDeleteMode = true;
        }
    }
}
/* EOF */
