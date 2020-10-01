/**
 * /BT_arabic/Common/PopupLoader/BtPopupConnectDeviceDelete.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupConnectDeviceDelete

    popupBtnCnt: 2
    popupLineCnt: 1

    popupFirstText: stringInfo.str_Connect_Device_Delete

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        // 삭제 완료 시점에 화면이 빠지기 때문에 popScreen을 완료 팝업으로 옮김
        btDeleteMode = true

        // 삭제 중인 상태에서는 연결을 할 수 없도록 처리
        BtCoreCtrl.invokeControlConnectableMode(false);

        qml_debug("BtCoreCtrl.invokeGetConnectState() = " + BtCoreCtrl.invokeGetConnectState());
        if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                || 10 /* CONNECT_STATE_PBAP_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()) {
            // IQS3차(연결된 기기 삭제 후 페어링 된 기기가 남아있을 때 자동연결 시작을 위한 값
            btConnectDeviceDelete = true;

            BtCoreCtrl.invokeStartDisconnect(BtCoreCtrl.invokeGetConnectedDeviceID());

            if(false == btPhoneEnter) {
                MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn");
            } else {
                MOp.showPopup("popup_Bt_Dis_Connecting");
            }
        } else {
            if(5 > deviceSelectInt) {
                BtCoreCtrl.invokeRemovePairedDevice();
            } else {
                deleteAllMode = true;
                BtCoreCtrl.invokeRemoveAllPairedDevice();
            }
        }
    }

    onPopupSecondBtnClicked:{ MOp.hidePopup(); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
