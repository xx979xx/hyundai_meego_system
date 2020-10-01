/**
 * /BT/Common/PopupLoader/BtPopupDeleteAllRecents.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupDeleteAllRecents

    popupBtnCnt: 2
    popupLineCnt: 1

    popupFirstText: stringInfo.str_Delete_All_Message

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        /* select_recent_call_type
         *   - incoming: 2
         *   - outgoing: 1
         *   - missed: 3
         *   - all: 4
         */
        select_recent_call_type = 2
        BtCoreCtrl.invokeTrackerRemoveAllCallHistory(4);
    }

    onPopupSecondBtnClicked:{ MOp.hidePopup(); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
