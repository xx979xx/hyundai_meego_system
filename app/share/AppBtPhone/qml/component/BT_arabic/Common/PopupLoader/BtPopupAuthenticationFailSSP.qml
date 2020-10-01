/**
 * /BT_arabic/Common/PopupLoader/BtPopupAuthenticationFailSSP.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupAuthenticationFailSSP

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: (false == btPhoneEnter) ? true : false

    popupFirstText: {
        switch(UIListener.invokeGetCountryVariant()) {
            case 0: // Korea
                //(내수 HMC) stringInfo.str_Web_Korea
                stringInfo.str_Authentication_Fail_Message + "\n" + stringInfo.url_KOREA
                break;

            case 1: // NorthAmerica
                //(북미) stringInfo.str_Web_USA
                stringInfo.str_Authentication_Fail_Message + "\n" + stringInfo.url_USA
                break;

            default:
                stringInfo.str_Authentication_Fail
                break;
        }
    }

    popupFirstBtnText: stringInfo.str_Ok


    function autheticationFailPopupKeyHandler() {
        clickCheck = true;
        if(false == BtCoreCtrl.invokeIsAnyConnected()) {
            qml_debug("[QML] IN Popup_Bt_Connection_Auth_Fail_Ssp btSettingsEnter = " + btSettingsEnter)
            qml_debug("btPhoneEnter = " + btPhoneEnter);
            qml_debug("ConnectState = " + BtCoreCtrl.invokeGetConnectState());

            if(true == btPhoneEnter) {
                //DEPRECATED For IQS BtCoreCtrl.invokeSetConnectState(0 /* CONNECT_STATE_IDLE */)
                MOp.postPopupBackKey(100);
            } else {
                // For IQS 페어링 실패 후 자동 연결중 팝업 출력
                if(8 /* CONNECT_STATE_AUTOCONNECTING_PAIRED_FAILED */ == BtCoreCtrl.invokeGetConnectState()) {
                    if(true == BtCoreCtrl.invokeGetStartConnectingFromHU()) {
                        // DefaultProfileConnectNothing 이벤트를 받고 자동연결이 시작됨
                        MOp.showPopup("popup_Bt_Connecting");
                    } else {
                        MOp.hidePopup();
                    }
                } else {
                    MOp.hidePopup();
                }
            }

            if(8 /* CONNECT_STATE_AUTOCONNECTING_PAIRED_FAILED */ != BtCoreCtrl.invokeGetConnectState()) {
                BtCoreCtrl.invokeStartAutoConnect();
            } else {
                if(false == BtCoreCtrl.invokeGetStartConnectingFromHU()
                    || 7 /* CONNECT_STATE_AUTOCONNECTING */ != BtCoreCtrl.invokeGetConnectState()) {
                    // 폰에서 페어링 실행 후 실패 했을 때만 초기화
                    BtCoreCtrl.invokeSetConnectState(0 /* CONNECT_STATE_IDLE */);
                }
            }
        } else {
            MOp.hidePopup();
        }
    }

    /* EVENT handlers */
    onPopupFirstBtnClicked: { autheticationFailPopupKeyHandler(); }
    onHardBackKeyClicked:   { autheticationFailPopupKeyHandler(); }
}
/* EOF */
