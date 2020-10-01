/**
 * BtPopup3WayCall.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeBluetoothCall
{
    id: idBtPopup3WayCall

    popupBtnCnt: 3

    popupFirstText: {
        if(true == BtCoreCtrl.m_n3wayCallFirstIncoming) {
            MOp.getCallerId(BtCoreCtrl.m_strPhoneName0, BtCoreCtrl.m_strPhoneNumber0)
        } else {
            MOp.getCallerId(BtCoreCtrl.m_strPhoneName1, BtCoreCtrl.m_strPhoneNumber1)
        }
    }
    popupSecondText: {
        if(true == BtCoreCtrl.m_n3wayCallFirstIncoming) {
            MOp.getCallerNumber(BtCoreCtrl.m_strPhoneNumber0)
        } else {
            MOp.getCallerNumber(BtCoreCtrl.m_strPhoneNumber1)
        }
    }

    popupFirstBtnText:  stringInfo.str_First_Hold_Call
    popupSecondBtnText: stringInfo.str_First_End_Call
    popupThirdBtnText:  stringInfo.str_Reject

    secondTextVisible: {
        if(true == BtCoreCtrl.m_n3wayCallFirstIncoming) {
            ("" != BtCoreCtrl.m_strPhoneName0) ? true : false
        } else {
            ("" != BtCoreCtrl.m_strPhoneName1) ? true : false
        }
    }

    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        BtCoreCtrl.HandleAcceptCall();
        MOp.showCallView();
    }

    onPopupSecondBtnClicked: {
        BtCoreCtrl.HandleReleaseCurrentCall();

        // TODO: ddingddong 아래 초기화는 왜?
/*DEPRECATED 
        phoneName = "";
        phoneNum = "";
DEPRECATED*/         
    }

    onPopupThirdBtnClicked: {
        BtCoreCtrl.HandleRejectWaitingCall();
    }
}
/* EOF*/
