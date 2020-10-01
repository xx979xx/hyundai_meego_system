/**
 * /BT/Common/PopupLoader/BtPopupContactChange.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupContactsUpdate

    popupBtnCnt: 2
    popupLineCnt: 1
    black_opacity: (true == BtCoreCtrl.m_requestForegroundTTSPopup) ? false : true

    popupFirstText: (true == UIListener.invokeGetVRSupported()) ? stringInfo.str_Bt_Contact_Update_Call : stringInfo.str_Bt_Contact_Update
    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onShow: {}
    onHide: {
        if(true == clickCheck) {
            clickCheck = false;
        } else {
            console.log("ConnectState = " + BtCoreCtrl.invokeGetConnectState());
            if(5/* CONNECT_STATE_DISCONNECTING */ != BtCoreCtrl.invokeGetConnectState()) {
                BtCoreCtrl.invokeContactUpdate(true);
            }
        }

        BtCoreCtrl.invokeSetRequestForegroundTTSPopup(false);
    }

    onPopupFirstBtnClicked: {
        clickCheck = true;

        if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
            MOp.postPopupBackKey(555);
        } else {
            MOp.hidePopup();
            if("BtContactSearchMain" == idAppMain.state) {
                // 업데이트중 화면으로 전환
                popScreen(207);
            }
        }

        // 다운로드 받은 폰북으로 업데이트 시작
        BtCoreCtrl.invokeContactUpdate(true);
    }

    onPopupSecondBtnClicked: {

        BtCoreCtrl.invokeContactUpdate(false);
        clickCheck = true;
        if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
            MOp.postPopupBackKey(555);
        } else {
            MOp.hidePopup();
        }
    }

    onHardBackKeyClicked: {
        BtCoreCtrl.invokeContactUpdate(false);
        clickCheck = true;
        if(true == BtCoreCtrl.m_requestForegroundTTSPopup) {
            MOp.postPopupBackKey(555);
        } else {
            MOp.hidePopup();
        }
    }
}
/* EOF */
