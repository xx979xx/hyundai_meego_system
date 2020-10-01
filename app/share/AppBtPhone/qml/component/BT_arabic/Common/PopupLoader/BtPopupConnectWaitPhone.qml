/**
 * /BT_arabic/Common/PopupLoader/BtPopupConnectWaitPhone.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupConnectWaitPhone

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: true

    popupFirstText: stringInfo.str_Bt_No_Connect_Re_Connect

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
/*DEPRECATED
    onPopupClicked: {
        MOp.postPopupBackKey(14);
    }
DEPRECATED*/

    onPopupFirstBtnClicked: { MOp.postPopupBackKey(16); }
    onHardBackKeyClicked:   { MOp.postPopupBackKey(17); }
    //DEPRECATED onPopupBgClicked: {}
}
/* EOF */
