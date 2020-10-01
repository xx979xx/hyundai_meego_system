/**
 * /BT/Common/PopupLoader/BtPopupPhoneRequestConnectDevice.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeLoading
{
    id: idPopupBtPhoneRequestConnectDevice

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: (false == btPhoneEnter) ? true : false

    popupFirstText: stringInfo.str_Add_Device_To_Phone
    popupFirstBtnText: stringInfo.str_Close


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        qml_debug("IN Popup_Bt_Phone_Request_Connect_Device");
        MOp.postPopupBackKey(233);
    }

    onShow: {}
    onHide: {
        // Request SSP
        sspOk = BtCoreCtrl.invokeGetSSPcode();

        qml_debug("sspDeviceName =  " + sspDeviceName);
        qml_debug("BtCoreCtrl.invokeGetSSPDeviceName() =  " + BtCoreCtrl.invokeGetSSPDeviceName());
        sspDeviceName = BtCoreCtrl.invokeGetSSPDeviceName();
        MOp.showPopup("popup_Bt_SSP");
    }

    onHardBackKeyClicked: { MOp.hidePopup(); }
    //DEPRECATED onPopupClicked: {}
    //DEPRECATED onPopupBgClicked: {}
}
/* EOF*/
