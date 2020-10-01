/**
 * /BT/Common/PopupLoader/BtPopupConnectCancelling.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeLoadingConnect
{
    id: idPopupConnectCancelling

    popupBtnCnt: (false == btPhoneEnter) ? 0 : 1
    popupLineCnt: 1
    black_opacity: (false == btPhoneEnter) ? true : false

    popupFirstText: stringInfo.str_Device_Connect_Cancel_Wait
    popupSecondText: BtCoreCtrl.m_strConnectingDeviceName
    popupFirstBtnText: stringInfo.str_Close

    popupLineHeight: ((gLanguage == 21 || gLanguage == 22 || gLanguage == 18) && popupBtnCnt != 0) ? 0.75 : 1

    /* INTERNAL functions */
    function cancelingHandler() {
        if(true == btPhoneEnter) {
            MOp.postPopupBackKey(231);
        }
    }

    /* EVENT handlers */
    onPopupFirstBtnClicked: { cancelingHandler(); }
    onHardBackKeyClicked:   { cancelingHandler(); }
    //DEPRECATED onPopupBgClicked: {}
}
/* EOF*/
