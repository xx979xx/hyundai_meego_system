/**
 * /BT/Common/PopupLoader/BtPopupA2DPConnectSuccess.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupToastWithDeviceName
{
    id: idConnectSuccessA2DPOnlyPopup

    black_opacity: false
    ignoreTimer: true

    firstText: BtCoreCtrl.m_strConnectedDeviceName
    secondText: stringInfo.str_Connection_Suc


    /* INTERNAL functions */
    function connectSuccessA2DPOnlyPopupHandler() {
        btConnectAfterDisconnect = false;
        BtCoreCtrl.invokeSetStartConnectingFromHU(false);

        qml_debug("FirstConnect = " + BtCoreCtrl.invokeGetFirstConnect());
        qml_debug("ConnectState = " + BtCoreCtrl.invokeGetConnectState());

        // 연결 완료 팝업 출력 중 폰에서 연결 해제 할 수 있는 경우가 있음
        if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()) {
            // For IQS
            if(true == BtCoreCtrl.invokeGetFirstConnect() && popupState != "popup_restrict_while_driving") {
                /* 페어링 후 A2DP, AVRCP만 연결완료 시 자동 연결 우선순위 팝업
                 */
                if(false == UIListener.invokeGetAppState()) {
                    // 완료 팝업이 출력된 상태에서 BT가 Background로 전환되었을 때 처리
                    BtCoreCtrl.invokeSetAutoConnectMode(BtCoreCtrl.invokeGetConnectedDeviceID() + 1);
                    BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);
                } else {
                    MOp.showPopup("popup_Bt_AutoConnect_Device_A2DPOnly");
                }
            } else {
                /* A2DP, AVRCP만 연결완료 후 폰북 요청을 날리는 팝업(재요청이 아니기 때문에 reRequest, reDownload 모두 false)
                 * HFP를 지원하지 않기 때문에 Dial화면 진입을 안하고 홈화면으로 이동
                 */
                qml_debug("BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */) Call");
                BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);
                MOp.postPopupBackKey(6231);
            }
        }else{ //[ITS 0269922] AA연결 후 Phone HK 입력 시 BT '연결되었습니다'토스트팝업창 계속 유지함
            MOp.postPopupBackKey(6232);
        }
    }

    /* EVENT handlers */
    onShow: {}
    onHide: {}

    onTimerEnd:             { connectSuccessA2DPOnlyPopupHandler(); }
    onPopupClicked:         { connectSuccessA2DPOnlyPopupHandler(); }
    onHardBackKeyClicked:   { connectSuccessA2DPOnlyPopupHandler(); }
}
/* EOF*/
