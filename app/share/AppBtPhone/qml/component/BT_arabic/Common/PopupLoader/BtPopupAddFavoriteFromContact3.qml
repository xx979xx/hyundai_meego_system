/**
 * /BT_arabic/Common/PopupLoader/BtPopupAddFavoriteFromContact3.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeListFavoriteAdd
{
    id: idBtPopupAddFavoriteFromContact3

    popupBtnCnt: 1
    popupLineCnt: 4

    popupTitleText: phoneName
    popupFirstBtnText: stringInfo.str_Bt_Cancel


    /* EVENT handlers */
    onPopupFirstBtnClicked: { MOp.hidePopup(); }
    onBackKeyPressed:       { MOp.hidePopup(); }
}
/* EOF */
