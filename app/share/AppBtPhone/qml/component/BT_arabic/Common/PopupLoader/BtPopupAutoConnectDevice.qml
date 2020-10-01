/**
 * /BT_arabic/Common/PopupLoader/BtPopupAutoConnectDevice.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupTextWithDeviceName
{
    id: idPopupAutoConnectDevice

    popupBtnCnt: 2
    //DEPRECATED popupLineCnt: 2
    black_opacity: (BtCoreCtrl.m_requestForegroundTTSPopup == true) ? false : true

    popupFirstText: BtCoreCtrl.m_strConnectedDeviceName
    popupSecondText: stringInfo.str_Auto_Connection_Device

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* INTERNAL functions */
    function autoConnectDevicePopupHandler(type) {
        console.log("type = " + type);
        if(1 == type) {
            qml_debug("[QML] invokeGetConnectedDevcieID = " + BtCoreCtrl.invokeGetConnectedDeviceID());
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
         */
        if(false == BtCoreCtrl.invokeGetPBAPNotSupport())
        {
            qml_debug("BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */) Call");
            BtCoreCtrl.invokeRequestPBAP(BtCoreCtrl.invokeGetConnectedDeviceID(), false, false, 3 /* PBAP_DOWNLOAD_REQUEST_DO_NOTHING */);
            if(false == BtCoreCtrl.invokeIsHFPConnected()) {
                MOp.hidePopup();
            }
        }
        else
        {
            //NotSupport Popup
            if(popupState != "popup_restrict_while_driving") {
                if(1 > callType) {
                    //ITS 0255901
                    /* Ipod NANO 연결 후 우선 순위 팝업에서 phone(HK) 눌렀을때 hidepopup함수때문에
                     * 팝업이 바로 닫히는 bug 수정
                     */
                    if("popup_Bt_Not_Support_Bluetooth_Phone" == popupState){
                        //do noting
                    } else {
                        MOp.showPopup("popup_Bt_PBAP_Not_Support");
                    }
                }
            }
        }

    }

    /* EVENT handlers */
    onHide: {
        if(true == clickCheck) {
            clickCheck = false;
        } else {
            autoConnectDevicePopupHandler(4);
        }
    }

    onPopupFirstBtnClicked: {
        clickCheck = true;
        autoConnectDevicePopupHandler(1);
    }

    onPopupSecondBtnClicked: {
        clickCheck = true
        autoConnectDevicePopupHandler(2);
    }

    onHardBackKeyClicked: {
        clickCheck = true;
        autoConnectDevicePopupHandler(3);
    }
}
/* EOF*/
