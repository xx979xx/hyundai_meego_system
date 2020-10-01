/**
 * /BT/Common/PopupLoader/BtPopupNoDevice.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupNoDevice

    popupBtnCnt: 3
    popupLineCnt: 4
    black_opacity: false

    popupFirstText: stringInfo.str_Device_Add

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No
    popupThirdBtnText: stringInfo.str_Help


    button3Enable : (0 == UIListener.invokeGetVehicleVariant() && 0 == UIListener.invokeGetCountryVariant() && 7 == gLanguage) ? false : true

    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        if(true == parking) {
            // 정차상태
            if(BtCoreCtrl.m_pairedDeviceCount < 5) {
                if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                    || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()) {
                    MOp.showPopup("popup_Bt_Other_Device_Connect_Menu");
                } else {
                    // 페어링되어있는 디바이스가 없는 경우 신규 기기등록
                    BtCoreCtrl.invokeSetDiscoverableMode(true);
                    MOp.showPopup("popup_Bt_SSP_Add");
                }
            } else {
                // 페어링되어있는 디바이스가 5개인 경우 등록 불가
                MOp.showPopup("popup_Bt_Max_Device");
            }
        } else {
            // 주행상태
            qml_debug("## parking = false");
            MOp.showPopup("popup_restrict_while_driving");
        }
    }

    onPopupSecondBtnClicked: {
        MOp.postPopupBackKey(10);
    }

    onPopupThirdBtnClicked: {
        /* 도움말 연동
         */
        if(true == parking) {
            UIListener.invokePostLaunchHelp();
        } else {
            // 주행중일때 도움말 사용할 수 없도록 팝업띄움
            MOp.showPopup("popup_launch_help_in_driving");
        }
    }

    onHardBackKeyClicked: {
        MOp.postPopupBackKey(11);
    }
}
/* EOF*/
