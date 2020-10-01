/**
 * /BT/Common/PopupLoader/BtPopupLanguageChanged.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeLoading
{
    id: idBtPopupLanguageChanged

    popupBtnCnt: 0
    popupLineCnt: 0
    black_opacity: true

    popupFirstText: stringInfo.str_Settings_Change_Language

    onActiveFocusChanged: {
        if(true == checkedpopup){
            return;
        } else {
            if(true == idBtPopupLanguageChanged.activeFocus){
                checkedpopup = true;
                idChangedLanguageTimer.start();
            }
        }
    }

    Timer {
        id: idChangedLanguageTimer
        interval: 2700
        running: false
        onTriggered:
        {
            MOp.hidePopup(7122);
            checkedpopup = false;
            stop();
        }
    }
}
/* EOF */
