/**
 * /BT_arabic/Common/PopupLoader/BtPopupBluelinkCall.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeBluelinkCall
{
    id: idBtPopupBluelinkCall

    popupFirstText: MOp.getCallerId(BtCoreCtrl.m_strPhoneName0, BtCoreCtrl.m_strPhoneNumber0)
    popupSecondText: MOp.checkPhoneNumber(BtCoreCtrl.m_strPhoneNumber0)
    popupThirdText: {
        if( true == BtCoreCtrl.m_bIsCenterCallActivated)
        {
            stringInfo.str_CenterCall_Popup
        }
        else
        {
            (1 == UIListener.invokeGetVehicleVariant())? stringInfo.str_UVO_Popup : stringInfo.str_Bluelink_Popup
        }
    }

    popupFirstBtnText: stringInfo.str_Ok
    popupSecondBtnText: stringInfo.str_Bt_Cancel


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        BtCoreCtrl.HandleAcceptCall();
        MOp.showCallView();
    }

    onPopupSecondBtnClicked: {
        BtCoreCtrl.HandleHangupCall();
        MOp.postBackKey(7777);

        //블루링크 통화 시 팝업이 바로 사라지는 현상 수정
        //DEPRECATED hidePopup();
    }

    onVisibleChanged: {
        console.log("onVisible Changed >> " + idBtPopupBluelinkCall.visible)
        if(true == idBtPopupBluelinkCall.visible) {
            /* Popup visible true */
            if( true == BtCoreCtrl.m_bIsCenterCallActivated) {
                /* Center Call */
                popupThirdText = stringInfo.str_CenterCall_Popup
            } else {
                /* Check UVO/BLUELINK */
                popupThirdText = (1 == UIListener.invokeGetVehicleVariant())? stringInfo.str_UVO_Popup : stringInfo.str_Bluelink_Popup
            }
        }
    }
}
/* EOF */
