/**
 * /BT/Common/PopupLoader/BtPopupPreventDuringCall.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupPreventDuringCall

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: false;

    popupFirstText: stringInfo.str_During_Call
    popupFirstBtnText: stringInfo.str_Ok


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        MOp.postBackKey(206);
        if(false == btPhoneEnter) {
            MOp.clearScreen(3333);
        }
    }

    onHardBackKeyClicked: {
        MOp.postBackKey(207);

        if(false == btPhoneEnter) {
            MOp.clearScreen(3333);
        }
    }
}
/* EOF */
