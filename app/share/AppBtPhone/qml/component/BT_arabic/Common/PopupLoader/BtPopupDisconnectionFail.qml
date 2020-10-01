/**
 * /BT_arabic/Common/PopupLoader/BtPopupDisconnectionFail.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupTextWithDeviceName
{
    id: idPopupDisconnectionFail

    popupBtnCnt: 1

    popupFirstText: BtCoreCtrl.m_strConnectedDeviceName
    popupSecondText: stringInfo.disconnect_fail

    popupFirstBtnText: stringInfo.str_Ok


    /* EVENT handlers */
    onShow: {}
    onHide: {}

    onPopupFirstBtnClicked: { MOp.hidePopup(); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
