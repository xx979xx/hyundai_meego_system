/**
 * /BT_arabic/Common/PopupLoader/BtPopupA2DPOnlyConnect.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupTextWithDeviceName
{
    id: idConnectA2DPOnlyPopup

    popupBtnCnt: 2
    //DEPRECATED popupLineCnt: 1
    black_opacity: (true == btPhoneEnter) ? false : true

    popupFirstText: BtCoreCtrl.m_strConnectedDeviceName
    popupSecondText: stringInfo.str_Auto_Connection_Device

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* INTERNAL functions */
    function autoConnectDeviceA2DPOnlyPopupHandler(type) {
        console.log("type = " + type);
        if(1 == type) {
            clickCheck = true;
            BtCoreCtrl.invokeSetAutoConnectMode(BtCoreCtrl.invokeGetConnectedDeviceID() + 1);
        } else {
            /* 우선 순위 팝업에서 '예' 버튼을 누르지 않은 상황에서
             * 리스트는 하나만 있는 상태면 "선택 폰 없음"으로 설정
             */
            if(1 == BtCoreCtrl.m_pairedDeviceCount) {
                BtCoreCtrl.invokeSetAutoConnectMode(0);
            }
        }

        /* 연결 완료 후 자동연결 우선 순위 팝업에서 폰북 요청을 날리는 팝업
         * 재요청이 아니기 때문에 reRequest, reDownload == false
         * HFP를 지원하지 않기 때문에 Dial화면 진입을 안하고 홈화면으로 이동
         */
        qml_debug("BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */) Call");
        BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);

        if(false == btPhoneEnter) {
            MOp.hidePopup(6655);
        } else {
            MOp.postPopupBackKey(6655);
        }
    }


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        clickCheck = true;
        autoConnectDeviceA2DPOnlyPopupHandler(1);
    }

    onPopupSecondBtnClicked: {
        clickCheck = true;
        autoConnectDeviceA2DPOnlyPopupHandler(2);
    }

    onHardBackKeyClicked: {
        clickCheck = true;
        autoConnectDeviceA2DPOnlyPopupHandler(3);
    }

    onHide: {
        if(true == clickCheck) {
            clickCheck = false;
        } else {
            autoConnectDeviceA2DPOnlyPopupHandler(4);
        }
    }
}
/* EOF*/
