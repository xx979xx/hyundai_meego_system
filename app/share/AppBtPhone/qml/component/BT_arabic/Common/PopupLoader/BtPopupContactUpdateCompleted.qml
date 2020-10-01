/**
 * /BT/Common/PopupLoader/BtPopupContactUpdateCompleted.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeDim
{
    id: idPopupContactUpdateCompleted

    black_opacity: true
    ignoreTimer: true

    firstText: "Contacts update complete."

    function popupContactUpdateCompletedHandler(clickHandler) {
        clickCheck = clickHandler
        if(true == clickHandler) {
            MOp.hidePopup();
        }
    }

    /* EVENT handlers */
    onShow: { }
    onHide: {
        if(false == clickCheck) {
            MOp.hidePopup();
        } else {
            clickCheck = false;
        }
    }

    onTimerEnd: {
        clickCheck = true;
        MOp.hidePopup();
    }

    onHardBackKeyClicked: {
        clickCheck = true;
        MOp.hidePopup();
    }

    onPopupClicked: {
        clickCheck = true;
        MOp.hidePopup();
    }
}
/* EOF */
