/**
 * /BT/Common/PopupLoader/PopupDuringInitialization.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupDuringInitialization

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: false

    popupFirstText: stringInfo.str_Inializing
    popupFirstBtnText: stringInfo.str_Ok


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        UIListener.invokePostPopupBackKey();
    }

    onHardBackKeyClicked: {
        UIListener.invokePostPopupBackKey();
    }
}
/* EOF*/
