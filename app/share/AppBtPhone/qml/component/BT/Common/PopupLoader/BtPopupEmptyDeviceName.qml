/**
 * /BT/Common/PopupLoader/BtPopupEmptyDeviceName.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupEmptyDeviceName

    popupBtnCnt: 1
    popupLineCnt: 1

    popupFirstText: stringInfo.str_Bt_Null_Name
    popupFirstBtnText: stringInfo.str_Ok


    /* EVENT handlers */
    onPopupFirstBtnClicked: { MOp.hidePopup(); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
