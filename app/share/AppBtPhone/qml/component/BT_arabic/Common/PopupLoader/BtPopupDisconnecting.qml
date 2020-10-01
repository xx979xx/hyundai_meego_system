/**
 * /BT_arabic/Common/PopupLoader/BtPopupDisconnecting.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp


MComp.MPopupTypeLoadingConnect
{
    id: popup_Bt_Dis_Connecting_No_Btn

    popupBtnCnt: 0
    popupLineCnt: 1
    black_opacity: true

    popupFirstText: stringInfo.str_Device_Disconnect_Wait

    // 연결중인 상태에서 모듈리셋이 발생했을 때 DeviceName을 설정을 위한 조건
    popupSecondText: deviceName


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
}
/* EOF */
