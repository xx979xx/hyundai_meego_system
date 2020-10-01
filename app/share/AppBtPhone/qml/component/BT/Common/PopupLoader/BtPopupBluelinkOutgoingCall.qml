/**
 * /BT/Common/PopupLoader/BtPopupBluelinkOutgoingCall.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupBluelinkOutgoingCall

    popupBtnCnt: 2
    popupLineCnt: 1
    black_opacity: false

    popupFirstText: {
        if(true == BtCoreCtrl.m_bIsCenterCallActivated) {
            stringInfo.str_CenterCall_OutgoingCall
        } else {
            (1 == UIListener.invokeGetVehicleVariant())? stringInfo.str_UVO_OutgoingCall : stringInfo.str_Bluelink_OutgoingCall
        }
    }

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No

    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        if("Short" == gSwrcInput) {
            BtCoreCtrl.sendMostHangupCall();
            pushScreen("BtDialMain", 77777);
        } else if("Long" == gSwrcInput) {
            BtCoreCtrl.sendMostHangupCall();
            BtCoreCtrl.HandleCallStart(BtCoreCtrl.invokeTrackerGetLastOutgoing());
        } else {
            console.log("###### gSwrcInput Value fail")
            console.log("###### gSwrcInput = " + gSwrcInput)
            /* Enter Phone by SK from HOME & Other App */
            if(true == BtCoreCtrl.invokeGetIsOutgoingCallFromApp())
            {
                BtCoreCtrl.sendMostHangupCall();
                BtCoreCtrl.HandleCallStart(BtCoreCtrl.invokeGetOutgoingCallNumber());
            }
            else
            {
                BtCoreCtrl.sendMostHangupCall();
            }
        }

        gSwrcInput = "";
        MOp.hidePopup();


        /* 블루링크 통화 중 블루투스 진입 시 배경화면이 없는 경우
         * Dial화면 표시 함
         */
        if(1 > UIListener.invokeGetScreenSize()) {
            BtCoreCtrl.sendMostHangupCall();
            pushScreen("BtDialMain");
            MOp.returnFocus();
        }
    }

    onPopupSecondBtnClicked: {
        MOp.postBackKey(7778);
        gSwrcInput = "";
    }

    onHardBackKeyClicked: {
        MOp.postBackKey(7778);
        gSwrcInput = "";
    }

    onVisibleChanged: {
        if(true == idBtPopupBluelinkOutgoingCall.visible) {
            /* Popup visible true */
            if( true == BtCoreCtrl.m_bIsCenterCallActivated) {
                /* Center Call */
                popupFirstText = stringInfo.str_CenterCall_OutgoingCall
            } else {
                /* Check UVO/BLUELINK */
                popupFirstText = (1 == UIListener.invokeGetVehicleVariant())? stringInfo.str_UVO_OutgoingCall : stringInfo.str_Bluelink_OutgoingCall
            }
        }
    }
}
/* EOF */
