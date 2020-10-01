/**
 * /BT_arabic/Common/PopupLoader/BtPopupSwitchHandfree.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText 
{
    id: idPopupTextContainer

    popupBtnCnt: 2
    popupFirstText: stringInfo.str_Swith_Handfree;
    popupFirstBtnText: stringInfo.str_Yes;
    popupSecondBtnText: stringInfo.str_Bt_No;

    black_opacity: true

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
