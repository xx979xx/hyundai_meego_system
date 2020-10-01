/**
 * /BT/Common/PopupLoader/BtPopupDisconnect.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupDisconnect

    popupBtnCnt: 2
    popupLineCnt: 1
    popupFirstText: stringInfo.str_Disconnect_Device

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        qml_debug("####### Connect State" + BtCoreCtrl.invokeGetConnectState());
        BtCoreCtrl.invokeStartDisconnect(BtCoreCtrl.invokeGetConnectedDeviceID())

        qml_debug("[QML] btPhoneEnter = " + btPhoneEnter);
        if(false == btPhoneEnter) {
            MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn");
        } else {
            MOp.showPopup("popup_Bt_Dis_Connecting");
        }
    }

    onPopupSecondBtnClicked: { MOp.hidePopup(); }
    onHardBackKeyClicked: { MOp.hidePopup(); }
}
/* EOF*/
