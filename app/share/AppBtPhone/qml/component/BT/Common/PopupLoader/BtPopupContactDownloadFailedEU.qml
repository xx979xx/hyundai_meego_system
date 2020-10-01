/**
 * /BT/Common/PopupLoader/BtPopupConnectWaitPhone.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupConnectWaitPhone

    popupBtnCnt: 2
    popupLineCnt: 1
    black_opacity: (BtCoreCtrl.m_requestForegroundTTSPopup == true) ? false : true

    popupFirstText: stringInfo.str_Help_Phonebook_Down_Message_EU

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    onHide: {
        console.log("popup_Contact_Down_fail onHide()");
        console.log("clickCheck = " + clickCheck);
        if(true == clickCheck) {
            clickCheck = false;
        } else {
            BtCoreCtrl.invokeSetPhonebookState();
            BtCoreCtrl.invokeSetForceAutoDownloadOff();
        }

        BtCoreCtrl.invokeSetRequestForegroundTTSPopup(false);
    }

    onPopupFirstBtnClicked: {
        qml_debug("DownloadRequestState = " + BtCoreCtrl.invokeGetDownloadRequestState());
        if(true == BtCoreCtrl.invokeGetDownloadRequestState()) {
            /* 폰에서 폰북 요청을 거절한 후 재요청 시도 팝업 "YES" 선택한 상황.
             * 이 때는 재요청 이후 폰에서 승낙했을 때 DB에 Data가 있을 경우 재다운로드를 하지 않기때문에
             * reDownload == false
             */
            qml_debug("BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), true, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */) Call");
            //__IQS_16_MY
//            BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), true, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);
            BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);
        } else {
            qml_debug("BtCoreCtrl.invokeTrackerDownloadPhonebook()");
            BtCoreCtrl.invokeTrackerDownloadPhonebook();
        }

        BtCoreCtrl.invokeSetDownloadRequestState(false);
        clickCheck = true;
        if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
            MOp.postPopupBackKey(113)
        } else {
            MOp.hidePopup();
        }
    }

    onPopupSecondBtnClicked: {
        BtCoreCtrl.invokeSetPhonebookState();
        clickCheck = true;
        if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
            MOp.postPopupBackKey(113)
        } else {
            MOp.hidePopup();
        }
        BtCoreCtrl.invokeSetForceAutoDownloadOff();
    }

    onHardBackKeyClicked: {
        BtCoreCtrl.invokeSetPhonebookState();
        clickCheck = true;
        if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
            MOp.postPopupBackKey(113)
        } else {
            MOp.hidePopup();
        }
        BtCoreCtrl.invokeSetForceAutoDownloadOff();
    }
    //DEPRECATED onPopupBgClicked: {}
}
/* EOF */
