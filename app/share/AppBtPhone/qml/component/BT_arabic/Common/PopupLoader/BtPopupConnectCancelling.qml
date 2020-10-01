/**
 * /BT/Common/PopupLoader/BtPopupConnectCancelling.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
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
