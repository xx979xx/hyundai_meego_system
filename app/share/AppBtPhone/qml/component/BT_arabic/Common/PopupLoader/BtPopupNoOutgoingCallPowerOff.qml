/**
 * /BT_arabic/Common/PopupLoader/BtPopupNoOutgoingCallPowerOff.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText 
{
    id: idPopupNoOutgoingCallPowerOff

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: false
    
    popupFirstBtnText: stringInfo.str_Ok
    popupFirstText: stringInfo.str_No_Callhistory_Recent
    
    onPopupFirstBtnClicked: { MOp.postBackKey(333); }
}
/* EOF */
