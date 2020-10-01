/**
 * /BT_arabic/Common/PopupLoader/BtPopupContactDownloadFailed.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeContactsFail
{
    id: idBtPopupContactDownloadFailed

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No

    black_opacity: (BtCoreCtrl.m_requestForegroundTTSPopup == true) ? false : true

    /* EVENT handlers */
    onShow: {}
    onHide: {
        console.log("popup_Contact_Down_fail onHide()");
        console.log("clickCheck = " + clickCheck);
        if(true == clickCheck) {
            clickCheck = false;
        } else {
            BtCoreCtrl.invokeSetPhonebookState();
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
            BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), true, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);
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
    }

    onHardBackKeyClicked: {
        BtCoreCtrl.invokeSetPhonebookState();
        clickCheck = true;
        if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
            MOp.postPopupBackKey(113)
        } else {
            MOp.hidePopup();
        }
    }
}
/* EOF */
