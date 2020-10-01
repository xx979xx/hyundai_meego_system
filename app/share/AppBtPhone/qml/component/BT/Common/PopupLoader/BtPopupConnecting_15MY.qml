/**
 * /BT/Common/PopupLoader/BtPopupConnecting.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeLoadingConnect_15MY
{
    id: idPopupConnecting

    popupBtnCnt: (false == btPhoneEnter) ? 2 : 3
    popupLineCnt: 1
    black_opacity: (false == btPhoneEnter) ? true : false

    popupFirstText: stringInfo.str_Wait_Device_Connection_15MY
    popupSecondText: (true == BtCoreCtrl.m_bDisplayWaitInDeviceName)? stringInfo.str_Bt_Name_Device_Wait : BtCoreCtrl.m_strConnectingDeviceName

    popupFirstBtnText: stringInfo.str_Con_Cancel
    popupSecondBtnText: stringInfo.str_New_Device_Popup
    popupThirdBtnText: stringInfo.str_Close

    /* INTERNAL functions */
    function buttonClickHandler(buttonClick) {
        qml_debug("[QML] IN popup_Bt_Connect_Cancelling DeviceID     = " + BtCoreCtrl.invokeGetConnectedDeviceID());
        qml_debug("[QML] BtCoreCtrl.invokeGetStartConnectingFromHU() = " + BtCoreCtrl.invokeGetStartConnectingFromHU());
        qml_debug("[QML] autoConnectStart   = " + autoConnectStart);
        qml_debug("[QML] buttonClick        = " + buttonClick);

        switch(buttonClick) {
            case 1:
            case 2: {
                /* 취소동작 시 연결 상태에서 다른 리스트 선택하여 해제 후 연결 중 취소했을 때를 알려주는 변수 초기화
                 * DisconnectSuccess signal에서 해당 변수 참조
                 */
                if(true == btConnectAfterDisconnect) {
                    btConnectAfterDisconnect = false;
                }

                if(2 == buttonClick) {
                    // Add New 선택 했을 때 취소 완료 후 팝업 출력을 위한 설정
                    connectingPopupAddNewClick = true;
                }

                MOp.showPopup("popup_Bt_Connect_Cancelling");
                BtCoreCtrl.invokeCancelConnect(BtCoreCtrl.invokeGetConnectingDeviceID(), connectingPopupAddNewClick);
                break;
            }

            case 3: {
                MOp.postPopupBackKey(232);
                break;
            }

            default:
                qml_debug("Button click error");
                break;
        }
    }

    /* EVENT handlers */
    onShow: { connectingPopupAddNewClick = false; }
    onHide: {}

    onPopupFirstBtnClicked:     { buttonClickHandler(1); } /* Cancel  */
    onPopupSecondBtnClicked:    { buttonClickHandler(2); } /* AddNew  */
    onPopupThirdBtnClicked:     { buttonClickHandler(3); } /* Close   */
    onHardBackKeyClicked:       { buttonClickHandler(3); } /* BackKey */
}
/* EOF*/
