/**
 * /BT/Common/PopupLoader/BtPopupAuthenticationWaitWithButton.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupSSPWait
{
    id: idPopupAuthenticationWaitWithButton

    popupBtnCount: 1
    popupFirstBtnText: stringInfo.str_Close
    black_opacity: false

    popupFirstText: stringInfo.str_Passkey_Popup + " : "
    popupFirstSubText: sspOk
    popupSecondText: stringInfo.str_Device_Name_Popup + " : " + sspDeviceName
    popupThirdText: stringInfo.str_Device_Ssp_Wait


    /* EVENT handlers */
    onPopupFirstBtnClicked: { MOp.postPopupBackKey(6); }
    onHardBackKeyClicked:   { MOp.postPopupBackKey(7); }

    //DEPRECATED onPopupBgClicked: {}
}
/* EOF */
