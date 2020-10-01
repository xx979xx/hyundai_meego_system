/**
 * /BT/Common/PopupLoader/BtPopupRestructWhileDriving.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupRestrictWhileDriving

    black_opacity: true

    popupBtnCnt: 1

    //titleText: stringInfo.warning

    popupFirstText: stringInfo.str_Parking_Device_Add_2
    popupFirstBtnText: stringInfo.str_Ok


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        MOp.hidePopup();

        if("BtContactSearchMain" == idAppMain.state) {
                popScreen(203);

                if("FROM_SEARCH" == favoriteAdd){
                    favoriteAdd = "FROM_CONTACT";
                }
        } else if("SettingsBtNameChange" == idAppMain.state || "SettingsBtPINCodeChange" == idAppMain.state){
            popScreen(205);
        }
    }

    onHardBackKeyClicked: {
        MOp.hidePopup();

        if("BtContactSearchMain" == idAppMain.state) {
                popScreen(203);

                if("FROM_SEARCH" == favoriteAdd){
                    favoriteAdd = "FROM_CONTACT";
                }
        } else if("SettingsBtNameChange" == idAppMain.state || "SettingsBtPINCodeChange" == idAppMain.state){
            popScreen(205);
        }
    }

    onVisibleChanged: {
        /* 주행 모드에서 주행 규제 팝업이 빠져야 하는 상황 */
        if(false == idPopupRestrictWhileDriving.visible) {
            if(false == parking) {
                if(1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant()) {
                    if("BtContactSearchMain" == idAppMain.state
                        || "SettingsBtNameChange" == idAppMain.state
                        || "SettingsBtPINCodeChange" == idAppMain.state) {
                        popScreen(206);
                    }
                }
            }
        }
    }
}
/* EOF */
