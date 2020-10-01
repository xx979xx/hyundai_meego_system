/**
 * /BT_arabic/Common/PopupLoader/BtPopupPairedList.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeListPaired
{
    id: idPopupPairedList

    popupTitleText: stringInfo.str_Con_Popup_Setting
    black_opacity: false

    popupLineCnt: 4

    popupFirstBtnText:  stringInfo.str_New_Device_Popup
    popupSecondBtnText: stringInfo.str_Bt_Cancel


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        // 신규등록
        if(false == parking) {
            // 주행상태
            qml_debug("## parking = false");
            MOp.showPopup("popup_restrict_while_driving");
        } else {
            if(5 > BtCoreCtrl.m_pairedDeviceCount) {
                BtCoreCtrl.invokeSetDiscoverableMode(true);
                MOp.showPopup("popup_Bt_SSP_Add");
            } else {
                BtCoreCtrl.invokeSetDiscoverableMode(false);
                MOp.showPopup("popup_Bt_Max_Device");
            }
        }
    }

    onPopupSecondBtnClicked: {
        // 취소
        BtCoreCtrl.invokeSetDiscoverableMode(false);
        MOp.postPopupBackKey(240);
    }

    onHardBackKeyClicked: {
        if(true == idPopupPairedList.visible) {
            BtCoreCtrl.invokeSetDiscoverableMode(false);
        }

        MOp.postPopupBackKey(240);
    }
}
/* EOF*/
