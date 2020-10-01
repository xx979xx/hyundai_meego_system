/**
 * /BT/Common/PopupLoader/BtPopupRestrictWhileDriving.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupRestrictWhileDriving

    black_opacity: (false == btPhoneEnter) ? true : false;

    // titleText: stringInfo.warning

    popupBtnCnt: 1

    popupFirstText: stringInfo.str_Parking_Device_Add_2
    popupFirstBtnText: stringInfo.str_Ok


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        if(false == btPhoneEnter) {
            if(2 /* CONNECT_STATE_PAIRED */ == BtCoreCtrl.invokeGetConnectState()
                || 3 /* CONNECT_STATE_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                || 7 /* CONNECT_STATE_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                || 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
            ) {
                MOp.showPopup("popup_Bt_Connecting");
            } else {
                MOp.hidePopup();
            }
        } else {
            //269242
            MOp.hidePopup();
            MOp.postPopupBackKey(558);
        }

        if("BtContactSearchMain" == idAppMain.state) {
                popScreen(203);

                if("FROM_SEARCH" == favoriteAdd){
                    favoriteAdd = "FROM_CONTACT";
                }
        } else if("SettingsBtNameChange" == idAppMain.state || "SettingsBtPINCodeChange" == idAppMain.state){
            if(4 == UIListener.invokeGetCountryVariant()){
                MOp.hidePopup();
            } else {
                popScreen(205);
            }
        }

    }

    onHardBackKeyClicked: {
        if(false == btPhoneEnter) {
            if(2 /* CONNECT_STATE_PAIRED */ == BtCoreCtrl.invokeGetConnectState()
                || 3 /* CONNECT_STATE_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                || 7 /* CONNECT_STATE_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
                || 14 /* CONNECT_STATE_LINKLOSS_AUTOCONNECTING */ == BtCoreCtrl.invokeGetConnectState()
            ) {
                MOp.showPopup("popup_Bt_Connecting");
            } else {
                MOp.hidePopup();
            }
        } else {
            MOp.postPopupBackKey(559);
        }
    }
}
/* EOF */
