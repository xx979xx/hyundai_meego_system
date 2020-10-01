/**
 * /BT_arabic/Common/PopupLoader/BtPopupDimCallFail.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupCallFail

    popupBtnCnt: 1
    popupFirstText: stringInfo.str_Bt_Toast_Popup_Call_Fail
    popupFirstBtnText: stringInfo.str_Ok

    black_opacity: true


    /* EVENT handlers */
    onPopupFirstBtnClicked: { MOp.hidePopup(); }

    onHardBackKeyClicked: { MOp.postPopupBackKey(103); }
}
/* EOF */
