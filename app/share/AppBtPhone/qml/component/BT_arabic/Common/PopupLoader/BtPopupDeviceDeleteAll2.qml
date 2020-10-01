/**
 * /BT_arabic/Common/PopupLoader/BtPopupDeviceDeleteAll2.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupDeviceDeleteAll2

    popupBtnCnt: 2
    popupLineCnt: 1

    popupFirstText: stringInfo.str_Device_Delete_All

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No

    // 뒷배경 투명도 설정
    black_opacity: true


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        // 삭제 완료 시점에 화면이 빠지기 때문에 popScreen을 완료 팝업으로 옮김
        btDeleteMode = true;
        deleteAllMode = true;

        // 삭제 중인 상태에서는 연결을 할 수 없도록 처리
        BtCoreCtrl.invokeControlConnectableMode(false);

        if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
            || 10 /* CONNECT_STATE_PBAP_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
            || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()) {
            BtCoreCtrl.invokeStartDisconnect(BtCoreCtrl.invokeGetConnectedDeviceID());

            if(false == btPhoneEnter) {
                MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn");
            } else {
                MOp.showPopup("popup_Bt_Dis_Connecting");
            }
        } else {
            BtCoreCtrl.invokeRemoveAllPairedDevice();
        }
    }

    onPopupSecondBtnClicked:{ MOp.hidePopup(); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
