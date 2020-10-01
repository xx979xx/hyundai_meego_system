/**
 * /BT/Common/PopupLoader/BtPopupToast.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeDim
{
    id: idPopupDimContainer

    firstText: idPopupLoaderToast.text


    /* EVENT handlers */
    onShow: {}
    onHide: {}

    onPopupClicked:         { MOp.hidePopup(); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
