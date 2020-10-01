/**
 * /BT/Common/PopupLoader/BtPopupDisconnectSuccess.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupToastWithDeviceName
{
    id: disconnectSuccessPopup

    // 모듈리셋이 발생했을 때 DeviceName을 설정을 위한 조건
    firstText: deviceName
    secondText: stringInfo.str_Disconnection_Suc
    ignoreTimer: true
    black_opacity: (true == btPhoneEnter) ? false : true


    /* INTERNAL functions */
    function disconnectSuccessHandler() {
        BtCoreCtrl.invokeSetStartConnectingFromHU(false);

        //DEPRECATED console.log("btSettingsEnter = " + btSettingsEnter);
        //DEPRECATED console.log("btPhoneEnter" + btPhoneEnter);
        if(false == btSettingsEnter || false == btPhoneEnter) {
            if(true == autoConnectStart) {
                qml_debug("B. autoConnectStart = " + autoConnectStart);
                MOp.showPopup("popup_Bt_Connecting");
            } else {
                qml_debug("C. autoConnectStart = " + autoConnectStart);
                MOp.hidePopup();
            }
        } else {
            if(true == btConnectAfterDisconnect) {
                qml_debug("A. btConnectAfterDisconnect = " + btConnectAfterDisconnect);
                MOp.hidePopup();
                btConnectAfterDisconnect = false;
            } else {
                qml_debug("B. btConnectAfterDisconnect = " + btConnectAfterDisconnect);
                MOp.postBackKey(202);
            }
        }

        BtCoreCtrl.invokeSetConnectedDeviceID(-1);
        //DEPRECATED BtCoreCtrl.invokeSetConnectedDeviceName("");

        if(true == BtCoreCtrl.invokeGetModuleReset()) {
            // 모듈 초기화로 팝업이 출력되었을 대 모듈 초기화를 나타내는 변수 초기화
            BtCoreCtrl.invokeSetModuleReset(false);
        }
    }

    onShow: {
        deviceName = (true == BtCoreCtrl.invokeGetModuleReset()) ? BtCoreCtrl.m_strConnectingDeviceName : BtCoreCtrl.m_strConnectedDeviceName;
    }


    /* EVENT handlers */
    onTimerEnd:             { disconnectSuccessHandler(); }
    onPopupClicked:         { disconnectSuccessHandler(); }
    onHardBackKeyClicked:   { disconnectSuccessHandler(); }
    onPopupBgClicked:       { disconnectSuccessHandler(); }
}
/* EOF */
