/**
 * /BT_arabic/Common/PopupLoader/BtPopupMaxDevice.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupMaxDevice

    popupBtnCnt: 2
    popupLineCnt: 1
    black_opacity: false//(false == btPhoneEnter) ? true : false

    popupFirstText: stringInfo.str_Max_Device
    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        if(false == btPhoneEnter) {
            /* Device개수가 5개 인경우 발생하는 팝업으로 확인 버튼 이후 팝업만 사라지도록 수정
             */
            MOp.hidePopup();
        } else {
            //메인에서 진입 했을 경우 Home 확인 버튼을 누를 시 Home 으로 이동될 수 있도록 수정
            //MOp.postPopupBackKey(213);
            btPhoneEnter = false;
            btSettingsEnter = false;
            MOp.clearScreen(278);
            MOp.hidePopup();
            UIListener. invokePostSettingsMain();
            pushScreen("SettingsBtDeviceConnect");
            delete_type = "device"
            pushScreen("BtDeviceDelMain");
        }
    }

    onPopupSecondBtnClicked: {
        if(false == btPhoneEnter) {
            /* Device개수가 5개 인경우 발생하는 팝업으로 확인 버튼 이후 팝업만 사라지도록 수정
             */
            MOp.hidePopup();
        } else {
            popScreen(266)
        }
        //IQS Pre Audit issue. when closing the Max Device popup must start auto connection.
        BtCoreCtrl.invokeStartAutoConnect();
    }

    onHardBackKeyClicked: {
        if(false == btPhoneEnter) {
            /* Device개수가 5개 인경우 발생하는 팝업으로 확인 버튼 이후 팝업만 사라지도록 수정
             */
            MOp.hidePopup();
        } else {
            popScreen(266)
        }
        //IQS Pre Audit issue. when closing the Max Device popup must start auto connection.
        BtCoreCtrl.invokeStartAutoConnect();
    }
}
/* EOF */
