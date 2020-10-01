/**
 * /BT/Common/PopupLoader/BtPopupContactUpdate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeLoading
{
    id: idPopupContactUpdate

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: (false == btPhoneEnter) ? true : false

    popupFirstText: stringInfo.str_Bt_Updating
    popupFirstBtnText: stringInfo.str_Close


    /* EVENT handlers */
    onShow: { }
    onHide: {
        if(true == clickCheck) {
            clickCheck = false
        } else {
            MOp.hidePopup();
        }
    }

    onPopupFirstBtnClicked: {
        clickCheck = true;
        MOp.hidePopup();
    }

    onHardBackKeyClicked: {
        clickCheck = true;
        MOp.hidePopup();
    }
}
/* EOF*/
