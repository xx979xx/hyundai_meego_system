/**
 * /BT/Common/PopupLoader/BtPopupDisconnectingWithClose.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeLoadingConnect
{
    id: idBtPopupDisConnectingWithClose

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: false

    popupFirstText: stringInfo.str_Device_Disconnect_Wait

    // 연결중인 상태에서 모듈리셋이 발생했을 때 DeviceName을 설정을 위한 조건
    popupSecondText: deviceName

    popupFirstBtnText: stringInfo.str_Close


    /* EVENT handlers */
    onShow: {
        deviceName = (true == (true == BtCoreCtrl.invokeGetModuleReset()
                        && (1 /**/ == BtCoreCtrl.invokeGetConnectState()
                         || 2 /**/ == BtCoreCtrl.invokeGetConnectState()
                         || 3 /**/ == BtCoreCtrl.invokeGetConnectState()
                         || 7 /**/ == BtCoreCtrl.invokeGetConnectState()
                         || 13/**/ == BtCoreCtrl.invokeGetConnectState()
                         || 14/**/ == BtCoreCtrl.invokeGetConnectState())
                      )) ? BtCoreCtrl.m_strConnectingDeviceName : BtCoreCtrl.m_strConnectedDeviceName;
    }
    onHide: {}

    onPopupFirstBtnClicked: {
        if(true == btPhoneEnter) {
            MOp.postPopupBackKey(5510);
        } else {
            MOp.hidePopup();
        }
    }

    onHardBackKeyClicked: {
        if(true == btPhoneEnter) {
            MOp.postPopupBackKey(5511);
        } else {
            MOp.hidePopup();
        }
    }

    //DEPRECATED onPopupBgClicked: {}
}
/* EOF */
