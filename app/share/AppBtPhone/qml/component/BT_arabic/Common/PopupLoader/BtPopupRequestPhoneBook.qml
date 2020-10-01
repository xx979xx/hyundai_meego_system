/**
 * /BT/Common/PopupLoader/BtPopupRequestPhoneBook.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupTextContainer

    popupBtnCnt: 1
    popupFirstText: stringInfo.str_Req_Down_Phonebook + ' ' + stringInfo.str_Accept_Phone_Popup;
    popupFirstBtnText: stringInfo.str_Close;

    black_opacity: (BtCoreCtrl.m_requestForegroundTTSPopup == true) ? false : true

    function requestPhoneBookHandler() {
        console.log("popupName = ", popupName);
        console.log("popupState = ", popupState);
        if("popup_Contact_Down_fail" != popupState
                && "popup_Bt_PBAP_Not_Support" != popupState
                && "Call_popup" != popupState
                && "popup_Bt_Dis_Connecting" != popupState
                && "popup_Contact_Change" != popupState
                && "popup_Contact_Down_fail_EU" != popupState) {

            if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
                if(true == setBtDialScreen){
                    MOp.hidePopup();
                } else {
                    MOp.postPopupBackKey(481);
                }
                /* ITS 231445 전화번호부 요청 팝업에서 Backkey 동작시 Home 화면으로 전환 */
            } else {
                MOp.hidePopup();
            }
            BtCoreCtrl.invokeSetRequestForegroundTTSPopup(false);
            setBtDialScreen = false
        }
    }

    Connections {
        target: BtCoreCtrl

        //ISV 114480, 114469
        onSigPBAPrequestPopupHide: {
            // close only Requesting PBAP pop-up
            if("popup_Bt_Request_Phonebook" == popupState) {
                clickCheck = true;
                requestPhoneBookHandler();
            }
        }
    }

    /* EVENT handlers */
    onHide: {
        console.log("RequestPhoneBook onHide");
        console.log("clickCheck = ", clickCheck);
        if(true == clickCheck) {
            clickCheck = false;
        } else {
            requestPhoneBookHandler();
        }
        BtCoreCtrl.invokeSetRequestForegroundTTSPopup(false);
    }

    onPopupFirstBtnClicked: {
        clickCheck = true;
        requestPhoneBookHandler();
    }

    onHardBackKeyClicked: {
        clickCheck = true;
        requestPhoneBookHandler();
    }
}
/* EOF */
