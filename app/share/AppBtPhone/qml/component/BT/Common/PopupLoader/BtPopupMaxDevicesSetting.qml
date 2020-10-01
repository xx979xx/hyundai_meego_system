/**
 * /BT/Common/PopupLoader/BtPopupMaxDeviceSetting.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupMaxDevice

    popupBtnCnt: 2
    popupLineCnt: 1
    black_opacity: true

    popupFirstText: stringInfo.str_Max_Device
    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No

    property bool bIsFirstBtnClicked: false;

    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        bIsFirstBtnClicked = true;
        deviceSelectInt = 0;

        MOp.hidePopup();
        selectUnAll();
        delete_type = "device"
        pushScreen("BtDeviceDelMain", 518);
    }

    onPopupSecondBtnClicked: {
        MOp.hidePopup();
        //IQS Pre Audit issue. when closing the Max Device popup must start auto connection.
        BtCoreCtrl.invokeStartAutoConnect();
    }

    onHardBackKeyClicked: {
        MOp.hidePopup();
        //IQS Pre Audit issue. when closing the Max Device popup must start auto connection.
        BtCoreCtrl.invokeStartAutoConnect();
    }
    onHide: {
        if(false == bIsFirstBtnClicked){
            //IQS Pre Audit issue. when closing the Max Device popup must start auto connection.
            BtCoreCtrl.invokeStartAutoConnect();
        }
        bIsFirstBtnClicked = false;
    }
}
/* EOF */
