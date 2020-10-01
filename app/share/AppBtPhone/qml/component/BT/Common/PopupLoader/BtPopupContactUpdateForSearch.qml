/**
 * /BT/Common/PopupLoader/BtPopupContactUpdateForSearch.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeLoading
{
    id: idPopupContactUpdateForSearch

    popupBtnCnt: 0
    popupLineCnt: 1
    black_opacity: true

    popupFirstText: stringInfo.str_Bt_Updating
    popupFirstBtnText: stringInfo.str_Close


    /* EVENT handlers */
    onPopupFirstBtnClicked: { }

    onShow: { }
    onHide: { }

    onHardBackKeyClicked: { }
}
/* EOF*/
