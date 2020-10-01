/**
 * /BT/Common/PopupLoader/BtPopupSSP.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeBluetoothSSP
{
    id: idPopupSSP
    
    black_opacity: (false == btPhoneEnter || false == btSettingsEnter) ? true : false

    popupFirstText:     stringInfo.str_Passkey_Popup
    popupFirstSubText:  sspOk

    popupSecondText:    stringInfo.str_Device_Name_Popup
    popupSecondSubText: sspDeviceName

    popupThirdText:     stringInfo.str_Device_Ssp

    popupFourthText :   stringInfo.str_Ssp_Auto_Accept + ": " + countDownSSP + " " + stringInfo.str_Bt_Second

    popupFirstBtnText:  stringInfo.str_Bt_Cancel
    popupBtnCount: 1


    /* EVENT handlers */
/*DEPRECATED
    onPopupFirstBtnClicked: {
        BtCoreCtrl.invokeStartPairingBySSP(sspDeviceId, true, sspDeviceIdType);

        if(false == btPhoneEnter) {
            MOp.showPopup("popup_Bt_Authentication_Wait");
        } else {
            MOp.showPopup("popup_Bt_Authentication_Wait_Btn");
        }
    }
DEPRECATED*/

    onPopupFirstBtnClicked: {
        BtCoreCtrl.invokeStartPairingBySSP(sspDeviceId, false, sspDeviceIdType);
    }

    onTimerEnd: {
        BtCoreCtrl.invokeStartPairingBySSP(sspDeviceId, true, sspDeviceIdType);

        if(false == btPhoneEnter) {
            MOp.showPopup("popup_Bt_Authentication_Wait");
        } else {
            MOp.showPopup("popup_Bt_Authentication_Wait_Btn");
        }
    }

    onShow: {
        qml_debug("[QML] sspDeviceName = " + sspDeviceName);
        qml_debug("[QML] BtCoreCtrl.m_strSSPDeviceName = " + BtCoreCtrl.invokeGetSSPDeviceName());
    }
    onHide: {}

    onHardBackKeyClicked: {
        BtCoreCtrl.invokeStartPairingBySSP(sspDeviceId, false, sspDeviceIdType);
    }
}
/* EOF*/
