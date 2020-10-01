/**
 * /BT/Common/PopupLoader/BtPopupPBAPNotSupported.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupPBAPNotSupported

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: (BtCoreCtrl.m_requestForegroundTTSPopup == true) ? false : true

    popupFirstBtnText: stringInfo.str_Close
    popupFirstText: {
        switch(UIListener.invokeGetCountryVariant()) {
            case 0: // Korea
                //(내수 HMC) stringInfo.str_Web_Korea
                stringInfo.str_Nosup_Phonebook + "\n" + stringInfo.url_KOREA
                break;

            default:
                stringInfo.str_Nosup_Phonebook
                break;
        }
    }

    function pbapNotSupportedHandler() {
    // ITS 233154
        if("popup_Bt_Dis_Connecting" == popupState) {
            /* do nothing
             * 해제중 팝업 인경우 해제 완료 후 화면 천이가 됨
             */
        } else {
            if(false == BtCoreCtrl.invokeIsAnyConnected()) {
                qml_debug("[QML] IN idBtPopupPBAPNotSupported btSettingsEnter = " + btSettingsEnter)
                BtCoreCtrl.invokeSetConnectState(0 /* CONNECT_STATE_IDLE */)
                if(true == btPhoneEnter) {
                    if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
                        BtCoreCtrl.invokeSetRequestForegroundTTSPopup(false);
                    }
                    MOp.postPopupBackKey(240);
                } else {
                    MOp.hidePopup();
                }
            } else {
                if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
                    BtCoreCtrl.invokeSetRequestForegroundTTSPopup(false);
                    MOp.postPopupBackKey(240);
                } else {
                    MOp.hidePopup();
                }
            }
        }
    }

    /* EVENT handlers */
    onHide: {
        if(true == clickCheck) {
            clickCheck = false;
        } else {
            pbapNotSupportedHandler();
        }
    }

    onPopupFirstBtnClicked: {
        clickCheck = true;
        pbapNotSupportedHandler();
    }

    onHardBackKeyClicked: {
        clickCheck = true;
        pbapNotSupportedHandler();
    }
}
/* EOF */
