/**
 * /BT/Common/PopupLoader/BtPopupPairingAntherDevice.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupPairingAntherDevice

    popupBtnCnt: 2
    popupLineCnt: 1

    popupFirstText: stringInfo.str_Change_Device_New

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        // DefaultProfileConnectNothing이벤트에서 연결 상태일 때 예외처리를 넘어가기 위한 설정값
        BtCoreCtrl.invokeStartReConnect();
        // 해제가 완료되고 SSP Add 팝업을 띄우기 위한 Flag
        btDisconnectAfterSSPAdd = true;
        BtCoreCtrl.invokeStartDisconnect(BtCoreCtrl.invokeGetConnectedDeviceID());

        if(false == btPhoneEnter) {
            MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn");
        } else {
            MOp.showPopup("popup_Bt_Dis_Connecting");
        }
    }

    onPopupSecondBtnClicked:{ MOp.hidePopup(); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
