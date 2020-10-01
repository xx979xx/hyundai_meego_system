/**
 * /BT/Common/PopupLoader/BtPopupConnecting.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeLoadingConnect
{
    id: idPopupConnecting

    popupBtnCnt: (false == btPhoneEnter) ? 1 : 2
    popupLineCnt: 1
    black_opacity: (false == btPhoneEnter) ? true : false

    popupFirstText: stringInfo.str_Wait_Device_Connection
    popupSecondText: BtCoreCtrl.m_strConnectingDeviceName
    popupFirstBtnText: stringInfo.str_Con_Cancel
    popupSecondBtnText: stringInfo.str_Close


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        qml_debug("[QML] IN popup_Bt_Connect_Cancelling DeviceID = " + BtCoreCtrl.invokeGetConnectedDeviceID());
        qml_debug("[QML] BtCoreCtrl.invokeGetStartConnectingFromHU() = " + BtCoreCtrl.invokeGetStartConnectingFromHU());
        qml_debug("[QML] autoConnectStart = " + autoConnectStart);

        /* 취소동작 시 연결 상태에서 다른 리스트 선택하여 해제 후 연결 중 취소했을 때를 알려주는 변수 초기화
         * DisconnectSuccess signal에서 해당 변수 참조
         */
        if(true == btConnectAfterDisconnect) {
            btConnectAfterDisconnect = false;
        }

        MOp.showPopup("popup_Bt_Connect_Cancelling");
        BtCoreCtrl.invokeCancelConnect(BtCoreCtrl.invokeGetConnectingDeviceID(), false);
    }

    onPopupSecondBtnClicked: {
        MOp.postPopupBackKey(232);
    }

    onShow: {}
    onHide: {}

    onHardBackKeyClicked: { MOp.postPopupBackKey(232); }
    //DEPRECATED onPopupBgClicked: {}
}
/* EOF*/
