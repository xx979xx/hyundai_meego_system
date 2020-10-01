/**
 * /BT_arabic/Common/PopupLoader/BtPopupSwitchHandfreeNavi.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText 
{
    id: idPopupTextContainer

    popupBtnCnt: 2
    popupFirstText: stringInfo.sSTR_BT_SWITCH_HANDFREE_NAVI;
    popupFirstBtnText: stringInfo.str_Yes;
    popupSecondBtnText: stringInfo.str_Bt_No;

    black_opacity: false

    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        BtCoreCtrl.HandleFordModeChange(true);
    }

    onPopupSecondBtnClicked:{
        BtCoreCtrl.invokeCallFordPatentPopup(false); 
    }

    onHardBackKeyClicked:   {
        BtCoreCtrl.invokeCallFordPatentPopup(false);
    }
}
/* EOF */
