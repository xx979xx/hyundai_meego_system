/**
 * /BT/Common/PopupLoader/BtPopupReconnect.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupReConnect

    popupBtnCnt: 2
    popupLineCnt: 1
    black_opacity: false

    popupFirstText: BtCoreCtrl.m_strConnectingDeviceName + "\n" + stringInfo.str_Connect_Fail_Re_Connect

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        BtCoreCtrl.invokeSetStartConnectingFromHU(true);
        BtCoreCtrl.invokeStartConnect(BtCoreCtrl.invokeGetConnectingDeviceID());
        MOp.showPopup("popup_Bt_Connecting");
    }

    onPopupSecondBtnClicked: {
        BtCoreCtrl.invokeSetConnectingDeviceID(-1 /* BT_INVALID */);
        BtCoreCtrl.invokeSetConnectingDeviceName("");
        MOp.postPopupBackKey(110);
    }

    onHardBackKeyClicked: {
        BtCoreCtrl.invokeSetConnectingDeviceID(-1 /* BT_INVALID */);
        BtCoreCtrl.invokeSetConnectingDeviceName("");
        MOp.postPopupBackKey(111);
    }

    //DEPRECATED onPopupClicked: {}
    //DEPRECATED onPopupBgClicked: {}
}
/*EOF*/
