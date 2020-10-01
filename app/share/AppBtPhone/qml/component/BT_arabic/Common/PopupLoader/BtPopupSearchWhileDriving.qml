/**
 * /BT_arabic/Common/PopupLoader/BtPopupSearchWhileDriving.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupRestrictWhileDriving

    black_opacity: true

    //titleText: stringInfo.warning

    popupBtnCnt: 1

    popupFirstText: stringInfo.str_Parking_Device_Add_2
    popupFirstBtnText: stringInfo.str_Ok


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        MOp.hidePopup();
    }

    onHardBackKeyClicked: {
        MOp.hidePopup();
    }
}
/* EOF */
