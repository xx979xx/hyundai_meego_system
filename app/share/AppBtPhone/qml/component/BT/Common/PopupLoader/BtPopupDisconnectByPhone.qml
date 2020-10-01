/**
 * /BT/Common/PopupLoader/BtPopupDisconnectByPhone.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupToastWithDeviceName
{
    id: idBtPopupDisconnectByPhone

    firstText: deviceName
    secondText: stringInfo.str_Disconnection_Suc
    ignoreTimer: true
    black_opacity: (true == btPhoneEnter) ? false : true


    function disconnectByPhonePopupKeyHandler(clickedHandler) {
        clicked = clickedHandler;
        if(true == clickedHandler) {
            if(false == autoConnectStart) {
                if(1 /* CONNECT_STATE_PAIRING */ == BtCoreCtrl.invokeGetConnectState()) {
                    // 해제 완료 후 폰에서 페어링 요청이 왔을 경우 자동연결을 실행하지 못하도록 함
                    BtCoreCtrl.invokeSetStartConnectingFromHU(false);
                } else {
                    if(false == btPhoneEnter) {
                        MOp.hidePopup();
                    } else {
                        MOp.postPopupBackKey(113);
                        //add.
                        bgrequested = true;
                        console.log("disconnectByPhonePopupKeyHandler : set bgrequested " + bgrequested);
                        //end.
                    }

                    // 재연결 팝업에서 연결을 하는 경우에 대비해 Connecting device ID 를 갖고 있었으나,
                    // 연결하지 않고 아니오 및 Back 을 누르는 경우 ID 를 초기화한다.
                    BtCoreCtrl.invokeSetConnectingDeviceID(-1 /* BT_INVALID */);
                    BtCoreCtrl.invokeSetStartConnectingFromHU(false);
                    BtCoreCtrl.invokeSetConnectState(0 /* CONNECT_STATE_IDLE */);
                }
            } else {
                // Linkloss발생으로 자동연결이 Background로 진행중인 상태
                if(false == btPhoneEnter) {
                    MOp.showPopup("popup_Bt_Connecting");
                } else {
                    MOp.postPopupBackKey(112);
                }
            }

            if(true == BtCoreCtrl.invokeGetModuleReset()) {
                // 모듈 초기화로 팝업이 출력되었을 대 모듈 초기화를 나타내는 변수 초기화
                BtCoreCtrl.invokeSetModuleReset(false);

                /* For IQS 모듈 초기화 이후 자동 연결 실행
                 * 페어링 중이 아니면 자동연결을 하지못하도록 invokeStartAutoConnect(startAutoConnect)함수에서 예외처리 추가
                 * -> 자동연결 명령을 수행해도 Controller로 전달하지 않음
                 */
                BtCoreCtrl.invokeStartAutoConnect();
            } else {
                if(14 /*CONNECT_STATE_LINKLOSS_AUTOCONNECTING*/ != BtCoreCtrl.invokeGetConnectState()) {
                    /* For IQS (링크로스가 아니고 폰에서 연결 해제 했을 경우 자동연결 실행)
                     * 페어링 중이 아니면 자동연결을 하지못하도록 invokeStartAutoConnect(startAutoConnect)함수에서 예외처리 추가
                     * -> 자동연결 명령을 수행해도 Controller로 전달하지 않음
                     */
                    BtCoreCtrl.invokeStartAutoConnect();
                }
            }
        }
    }

    onShow: {
        clicked = false;
        deviceName = (true == BtCoreCtrl.invokeGetModuleReset()) ? BtCoreCtrl.m_strConnectingDeviceName : BtCoreCtrl.m_strConnectedDeviceName;
    }

    onHide: {
        if(false == clicked) {
            disconnectByPhonePopupKeyHandler(true);
        } else {
            clicked = false;
        }
    }

    /* EVENT handlers */
    onTimerEnd:             { disconnectByPhonePopupKeyHandler(true); }
    onPopupClicked:         { disconnectByPhonePopupKeyHandler(true); }
    onHardBackKeyClicked:   { disconnectByPhonePopupKeyHandler(true); }
    onPopupBgClicked:       { disconnectByPhonePopupKeyHandler(true); }
}
/* EOF */
