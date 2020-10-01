/**
 * /BT_arabic/Common/PopupLoader/BtPopupAuthenticationWait.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupSSPWait
{
    id: idPopupAuthenticationWait

    popupBtnCount: 0
    //DEPRECATED popupFirstBtnText:  stringInfo.str_Close

    // 설정 화면에서 기기 등록 확인 대기중 팝업 발생시 popup 외 화면 Dim처리
    black_opacity: (false == btPhoneEnter || false == btSettingsEnter) ? true : false

    popupFirstText:     stringInfo.str_Passkey_Popup + " : " + sspOk
    popupSecondText:    stringInfo.str_Device_Name_Popup + " : " + sspDeviceName
    popupThirdText:     stringInfo.str_Device_Ssp_Wait


    /* EVENT handlers */
    //DEPRECATED onPopupBgClicked: {}
}
/* EOF */
