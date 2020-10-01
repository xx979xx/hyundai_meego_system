/**
 * /BT_arabic/Common/PopupLoader/BtPopupNotSupportBluetoothPhone.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idpopupNotSupportHandsfree

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: (false == btPhoneEnter) ? true : false;

    popupFirstText: stringInfo.str_Bt_Not_Sup_HFP
    popupFirstBtnText: stringInfo.str_Ok


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        if(false == btPhoneEnter) {
            MOp.hidePopup();
        } else {
            MOp.postPopupBackKey(558);
        }
    }

    onHardBackKeyClicked: {
        if(false == btPhoneEnter) {
            MOp.hidePopup();
        } else {
            MOp.postPopupBackKey(559);
        }
    }
}
/*EOF*/
