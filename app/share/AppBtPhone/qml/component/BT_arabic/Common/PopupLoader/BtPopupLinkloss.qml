/**
 * /BT_arabic/Common/PopupLoader/BtPopupLinkloss.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupLinklossContainer

    popupBtnCnt: 2
    popupLineCnt: 1
    black_opacity: true

    popupFirstText: stringInfo.str_Linkloss

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onShow: {}
    onHide: {}

    onPopupFirstBtnClicked: { MOp.hidePopup(); }
    onPopupSecondBtnClicked:{ MOp.postPopupBackKey(237); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
