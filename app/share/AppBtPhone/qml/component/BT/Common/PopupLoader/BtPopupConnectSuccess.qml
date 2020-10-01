/**
 * /BT/Common/PopupLoader/BtPopupConnectSuccess.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupToastWithDeviceName
{
    id: idConnectSuccessPopup

    firstText: BtCoreCtrl.m_strConnectedDeviceName
    secondText: stringInfo.str_Connection_Suc


    /* EVENT handlers */
    onShow: {
        // 다른 Device 연결 시 전화번호 남아있는 문제점 수정 
        //Move to onDeviceHFPConnectSuccess.
      
    }
    
    onHide: {
        btConnectAfterDisconnect = false;
        BtCoreCtrl.invokeSetStartConnectingFromHU(false);

        if(false == btPhoneEnter && "SettingsBtDeviceConnect" == idAppMain.state) {
            /* 설정 화면에서 연결 완료가 되었을 때 화면갱신을 위함
             * 타 화면에서 연결 완료 후 설정 진입 시에는 갱신됨
             */
            switchScreen("SettingsBtDeviceConnect", true, 109);
        }

        qml_debug("BtCoreCtrl.invokeGetFirstConnect() = " + BtCoreCtrl.invokeGetFirstConnect());
        qml_debug("ConnectState = " + BtCoreCtrl.invokeGetConnectState());

        // For IQS
        // 연결 완료 팝업이 출력 중 폰에서 연결 해제 할 수 있는 경우가 있음
        if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()) {
            if(true == BtCoreCtrl.invokeGetFirstConnect() && popupState != "popup_restrict_while_driving") {
                /* 페어링 후 연결완료 시 자동 연결 우선순위 팝업
                 */
                if(1 > BtCoreCtrl.m_ncallState
                    && false == BtCoreCtrl.invokeSiriGetState()
                    && false == BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                    if(false == UIListener.invokeGetAppState()
                         && false == UIListener.invokeRequestCameraMode()) {
                        // 완료 팝업이 출력된 상태에서 BT가 Background로 전환되었을 때 처리
                        BtCoreCtrl.invokeSetAutoConnectMode(BtCoreCtrl.invokeGetConnectedDeviceID() + 1);
                        BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);
                    } else {
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
                    }
                } else {
                    BtCoreCtrl.invokeSetAutoConnectMode(BtCoreCtrl.invokeGetConnectedDeviceID() + 1);
                    BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);
                }
            } else {
                /* 연결 완료 후 폰북 요청을 날리는 팝업(재요청이 아니기 때문에 reRequest, reDownload 모두 false)
                 */
                qml_debug("BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */) Call");
                BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);
            }
        } else {
            // do nothing
        }
    }

    onHardBackKeyClicked: {
        MOp.returnFocus();
    }
}
/* EOF */
