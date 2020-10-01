/**
 * /BT/Common/PopupLoader/BtPopupConnectionFail.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupTextWithDeviceName
{
    id: popup_Bt_Connection_Fail

    popupBtnCnt: 1
    //DEPRECATED popupLineCnt: 1
    black_opacity: (true == btPhoneEnter) ? false : true

    popupFirstText: BtCoreCtrl.m_strConnectingDeviceName
    popupSecondText: stringInfo.str_Connect_Fail

    popupFirstBtnText: stringInfo.str_Ok


    /* INTERNAL functions */
    function connectionFailHandler() {
        BtCoreCtrl.invokeSetStartConnectingFromHU(false);
        BtCoreCtrl.invokeSetConnectState(0 /* CONNECT_STATE_IDLE */);
        BtCoreCtrl.invokeSetConnectingDeviceID(-1 /* BT_INVALID */);

        if(true == btPhoneEnter) {
            MOp.postPopupBackKey(5555);
        } else {
            MOp.hidePopup();
        }
    }


    /* EVENT handlers */
    onShow: {}
    onHide: {}

    onPopupFirstBtnClicked: { connectionFailHandler(); }
    onHardBackKeyClicked:   { connectionFailHandler(); }
}
/* EOF*/
