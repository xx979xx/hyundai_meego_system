/**
 * /BT_arabic/Common/PopupLoader/BtPopupInitializeAfterDisconnecting.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupInitializeAfterDisconnecting

    popupBtnCnt: 2
    popupLineCnt: 1
    black_opacity: true

    popupFirstText: stringInfo.str_Ini_Connect_Device

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        // 연결해제 후 패어링 기기 초기화시 사용
        //DEPRECATED btDisconnectAfterInitialize = true;
        //DEPRECATED BtCoreCtrl.invokeStartDisconnect(BtCoreCtrl.invokeGetConnectedDeviceID());
        BtCoreCtrl.invokeDisconnectInitialize(ini_paired_device, blutooth_setting_initialize);

        if(false == btPhoneEnter) {
            MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn");
        } else {
            MOp.showPopup("popup_Bt_Dis_Connecting");
        }
    }

    onPopupSecondBtnClicked:    { 
		//ITS 0264854
		initialize_after_disconnecting_popup_check = true;
		MOp.showPopup("popup_bt_checkbox_ini");
	}
    onHardBackKeyClicked:       { MOp.hidePopup(); }
}
/* EOF */
