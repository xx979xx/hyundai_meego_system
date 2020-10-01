/**
 * /BT/Common/PopupLoader/BtPopupSwitchHandfree.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
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
        idPopupTextContainer.buttonFocusPos = 1;//[ITS 0271897]
        BtCoreCtrl.HandleFordModeChange(true);
    }

    onPopupSecondBtnClicked:{
        idPopupTextContainer.buttonFocusPos = 1;
        BtCoreCtrl.invokeCallFordPatentPopup(false); 
    }

    onHardBackKeyClicked:   {
        idPopupTextContainer.buttonFocusPos = 1;
        BtCoreCtrl.invokeCallFordPatentPopup(false);
    }

    //[ITS 0271897] --------------------------------------------------------------------
    onVisibleChanged: {
        if(true == idPopupTextContainer.visible) {
            if(idPopupTextContainer.buttonFocusPos == 2)
                idPopupTextContainer.chageBtnFocus = !idPopupTextContainer.chageBtnFocus;
        }
    }
    onWheelLeftKeyPressed: {
        idPopupTextContainer.buttonFocusPos = 1;
    }
    onWheelRightKeyPressed: {
        idPopupTextContainer.buttonFocusPos = 2;
    }
    //---------------------------------------------------------------------------------
}
/* EOF */
