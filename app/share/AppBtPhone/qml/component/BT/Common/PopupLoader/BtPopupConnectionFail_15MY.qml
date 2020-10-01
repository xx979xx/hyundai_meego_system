/**
 * /BT/Common/PopupLoader/BtPopupConnectionFail_15MY.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.DDPopupTextWithDeviceName_15MY
{
    id: popup_Bt_Connection_Fail

    black_opacity: (true == btPhoneEnter) ? false : true

    popupFirstText: {
        if(1 == UIListener.invokeGetVehicleVariant()) { // KH
            switch(UIListener.invokeGetCountryVariant()) {
                case 1: // US_ENG
                    stringInfo.str_Bt_Connect_Error_For_US
                    break;
                case 6: // CANADA
                    stringInfo.str_Bt_Connect_Error_For_CA
                    break;
                case 0: // KOREA
                case 5: // EU
                case 7: // RUSSIA
                    stringInfo.str_Bt_Connect_Error_For_KR
                    break;
                default:
                    stringInfo.str_Bt_Connect_Error_For_COMMON
                    break;
            }
        } else { // DH, VI
            switch(UIListener.invokeGetCountryVariant()) {
                case 1: // US_ENG
                case 0: // KOREA
                    stringInfo.str_Bt_Connect_Error_For_US
                    break;
                case 6: // CANADA
                    stringInfo.str_Bt_Connect_Error_For_CA
                    break;
                default:
                    stringInfo.str_Bt_Connect_Error_For_COMMON
                    break;
            }
        }
    }

    popupFirstBtnText: stringInfo.str_Ok


    /* INTERNAL functions */
    function connectionFailHandler(clickedHandler) {
        if(true == clickedHandler) {
            clicked = true;
            
            // 팝업 터치 또는 Timeout했을 때 처리
            if(true == btPhoneEnter) {
                MOp.postPopupBackKey(5555);
            } else {
                MOp.showPopup("popup_Bt_Connecting_15MY");
            }
        } else {
            // Background로 전환 시
        }

        BtCoreCtrl.invokeStartAutoConnect();
    }

    /* EVENT handlers */
    onShow: {}
    onHide: {
        if(true == clicked) {
            clicked = false;
        } else {
            // Home button 또는 타모드로 전환 시 처리
            connectionFailHandler(false);
        }
    }

    onPopupFirstBtnClicked: { connectionFailHandler(true); }
    onHardBackKeyClicked:   { connectionFailHandler(true); }
    onTimerEnd:             { connectionFailHandler(false); }
}
/* EOF*/
