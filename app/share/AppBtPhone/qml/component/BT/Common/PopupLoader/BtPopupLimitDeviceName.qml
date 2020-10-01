/**
 * /BT/Common/PopupLoader/BtPopupLimitDeviceName.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupLimitDeviceName

    popupBtnCnt: 1
    popupFirstText: stringInfo.str_Bt_Limite_Char
    popupFirstBtnText: stringInfo.str_Ok

    black_opacity: true

    /* EVENT handlers */
    onPopupFirstBtnClicked: { MOp.hidePopup(); }

    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
