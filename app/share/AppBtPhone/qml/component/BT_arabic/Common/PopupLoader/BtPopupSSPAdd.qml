/**
 * /BT_arabic/Common/PopupLoader/BtPopupSSPAdd.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeBluetooth
{
    id: idPopupSSPAdd
    visible: true
    focus: true

    black_opacity: (false == btPhoneEnter || false == btSettingsEnter) ? true : false

    popupFirstText: stringInfo.str_Vehicle_Name_Popup + " : "
    popupFirstSubText: BtCoreCtrl.m_strBtLocalDeviceName
    popupSecondText: stringInfo.str_Passkey_Popup+ " : "
    popupSecondSubText: BtCoreCtrl.m_strPINcode
    popupThirdText: stringInfo.str_Pair_Search_Device

    popupFirstBtnText: stringInfo. str_Bt_Cancel
    popupSecondBtnText: stringInfo.str_Help


    // For IQS(Auto Connection Start)
    function autoConnectStart(button) {
        if(true == button) {
            // For IQS
            BtCoreCtrl.invokeStartAutoConnect();
        }
    }


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        qml_debug("popup_Bt_SSP_Add, onPopupFirstBtnClicked:");
        //DEPRECATED BtCoreCtrl.invokeSetDiscoverableMode(false);

        if(true == btPhoneEnter) {
            MOp.postPopupBackKey(1234);
            //add. [ISV100233]
            bgrequested = true;
            //end.
        } else {
            MOp.hidePopup();
        }

        // For IQS(버튼을 클릭했을 경우(cancel or backKey) 자동연결 실행)
        autoConnectStart(true);
    }

    onPopupSecondBtnClicked: {
            if(true == parking) {
                UIListener.invokePostLaunchHelp();
            } else {
                // 주행중일때 도움말 사용할 수 없도록 팝업띄움
                MOp.showPopup("popup_launch_help_in_driving");
            }
        }

    onHardBackKeyClicked: {
        qml_debug("popup_Bt_SSP_Add, onPopupFirstBtnClicked:");
        //DEPRECATED BtCoreCtrl.invokeSetDiscoverableMode(false);

        if(true == btPhoneEnter) {
            MOp.postPopupBackKey(1234);
            //add. [ISV100233]
            bgrequested = true;
            //end.
        } else {
            MOp.hidePopup();
        }

        // For IQS(버튼을 클릭했을 경우(cancel or backKey) 자동연결 실행)
        autoConnectStart(true);
    }

    onHide: {
        BtCoreCtrl.invokeSetDiscoverableMode(false);
    }
}
/* EOF*/
