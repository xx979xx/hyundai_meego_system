/**
 * /BT_arabic/Common/PopupLoader/BtPopupAuthenticationFail.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupAuthenticationFail

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: false

    popupFirstText: {
        switch(UIListener.invokeGetCountryVariant()) {
            case 0: // Korea
                //(내수 HMC) stringInfo.str_Web_Korea
                stringInfo.str_Authentication_Fail_Web + "\n" + stringInfo.url_KOREA;
                break;

            case 1: // NorthAmerica
                //(북미) stringInfo.str_Web_USA
                stringInfo.str_Authentication_Fail_Web + "\n" + stringInfo.url_USA;
                break;

            default:
                stringInfo.str_Authentication_Fail_Web;
                break;
        }
    }

    popupFirstBtnText: stringInfo.str_Ok


    /* EVENT handlers */
    Component.onCompleted: {
        //qml_debug("UIListener.invokeGetCountryVariant():" + UIListener.invokeGetCountryVariant())
    }

    onPopupFirstBtnClicked: { MOp.hidePopup(); }
    onHardBackKeyClicked: { MOp.postPopupBackKey(103); }

    //DEPRECATED onPopupClicked: {}
    //DEPRECATED onPopupBgClicked: {}
}
/* EOF */
