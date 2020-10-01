/**
 * /BT_arabic/Common/PopupLoader/BtPopupDisconnectWithRecentsDownloading.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupDisconnectWithRecentDownloading

    popupBtnCnt: 2
    popupLineCnt: 1
    black_opacity: true

    popupFirstText: stringInfo.str_Callhistory_Downloading_Dis_Connect

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
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
