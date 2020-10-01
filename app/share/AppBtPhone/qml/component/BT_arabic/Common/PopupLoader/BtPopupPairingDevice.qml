/**
 * /BT_arabic/Common/PopupLoader/BtPopupPairingDevice.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupPairingDevice

    popupBtnCnt: 2
    popupLineCnt: 1

    black_opacity: true

    popupFirstText: stringInfo.str_Change_Device

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        // DefaultProfileConnectNothing이벤트에서 연결 상태일 때 예외처리를 넘어가기 위한 설정값
        BtCoreCtrl.invokeStartReConnect();
        // 해제가 완료되면 연결 중 팝업 및 상태를 바꾸기 위한 Flag
        btConnectAfterDisconnect = true;

        BtCoreCtrl.invokeStartDisconnect(BtCoreCtrl.invokeGetConnectedDeviceID());

        if(false == btPhoneEnter) {
            MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn");
        } else {
            MOp.showPopup("popup_Bt_Dis_Connecting");
        }
    }

    onPopupSecondBtnClicked: {
        qml_debug("onPopupSecondBtnClicked: BtCoreCtrl.invokeSetConnectingDeviceID(-1)");
        BtCoreCtrl.invokeSetConnectingDeviceID(-1 /* BT_INVALID */);
        BtCoreCtrl.invokeSetConnectingDeviceName("");
        MOp.hidePopup();
    }

    onHardBackKeyClicked: {
        qml_debug("onHardBackKeyClicked: BtCoreCtrl.invokeSetConnectingDeviceID(-1)");
        BtCoreCtrl.invokeSetConnectingDeviceID(-1 /* BT_INVALID */);
        BtCoreCtrl.invokeSetConnectingDeviceName("");
        MOp.hidePopup();
    }
}
/* EOF */
