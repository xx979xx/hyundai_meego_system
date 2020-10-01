/**
 * /BT/Common/PopupLoader/BtPopupConnectCanceled.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupToastWithDeviceName
{
    id: idPopupConnectCanceled

    firstText: BtCoreCtrl.m_strConnectingDeviceName
    secondText: stringInfo.str_Cancel_Ok

    black_opacity: (true == btPhoneEnter) ? false : true
    ignoreTimer: true


    /* INTERNAL functions */
    function popupBtConnectCanceledHandler() {
        if(true == btPhoneEnter) {
            MOp.postPopupBackKey(210);
        } else {
            MOp.hidePopup();
        }

        BtCoreCtrl.invokeSetStartConnectingFromHU(false);
        BtCoreCtrl.invokeSetConnectState(0 /* CONNECT_STATE_IDLE */);
        BtCoreCtrl.invokeSetConnectingDeviceID(-1 /* BT_INVALID */);

        if(true == BtCoreCtrl.invokeGetModuleReset()) {
            // 모듈 초기화로 팝업이 출력되었을 대 모듈 초기화를 나타내는 변수 초기화
            BtCoreCtrl.invokeSetModuleReset(false);
        }
    }


    /* EVENT handlers */
    onShow: {}
    onHide: {}

    onTimerEnd:             { popupBtConnectCanceledHandler(); }
    onPopupClicked:         { popupBtConnectCanceledHandler(); }
    onHardBackKeyClicked:   { popupBtConnectCanceledHandler(); }
}
/* EOF */
