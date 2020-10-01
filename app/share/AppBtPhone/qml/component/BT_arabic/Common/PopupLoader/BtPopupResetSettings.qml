/**
 * /BT_arabic/Common/PopupLoader/BtPopupResetSettings.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeSettingReset
{
    id: idBtPopupResetSettings

    /* INTERNAL functions */
    function setButton1Enable() {
        if(true == ini_paired_device || true == ini_bluetooth_setting) {
            button1Enabled = true;
        } else {
            button1Enabled = false;
        }
    }

    onPopupFirstBtnClicked: {
        if(true == ini_paired_device && true == BtCoreCtrl.invokeIsAnyConnected()) {
            blutooth_setting_initialize = ini_bluetooth_setting
            MOp.showPopup("popup_Bt_Disconect_Initialize");
        } else {
            if(false == ini_paired_device && false == ini_bluetooth_setting) {
                MOp.hidePopup();
            } else {
                MOp.showPopup("popup_Bt_Initialing");
                BtCoreCtrl.invokeResetSettings(ini_paired_device, ini_bluetooth_setting)
            }
        }
    }

    onShow: {
        ini_paired_device = false;
        ini_bluetooth_setting = false;

        BtCoreCtrl.invokeCheckResetSettings();
    }
    onHide: {}

    onPopupSecondBtnClicked:{ MOp.hidePopup(); }
    onBackKeyPressed:       { MOp.hidePopup(); }
}
/* EOF */
