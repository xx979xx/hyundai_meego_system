/**
 * /BT_arabic/Common/PopupLoader/BtPopupNoConnection.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupNoConnection

    popupBtnCnt: 3
    popupLineCnt: 4
    black_opacity: false

    popupFirstText: stringInfo.str_Bt_No_Connect_Re_Connect

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No
    popupThirdBtnText: stringInfo.str_Help


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        MOp.showPopup("popup_paired_list");

        /*if(true == parking) {
            MOp.showPopup("popup_paired_list");
        } else {
            qml_debug("## parking = false");
            MOp.showPopup("popup_restrict_while_driving");
        }*/
    }

    onPopupSecondBtnClicked: {
        MOp.postPopupBackKey(12);
    }

    onPopupThirdBtnClicked: {
        /* 도움말 연동
         */
        if(true == parking) {
            UIListener.invokePostLaunchHelp();
        } else {
            // 주행중일때 도움말 사용할 수 없도록 팝업띄움
            MOp.showPopup("popup_launch_help_in_driving");
        }
    }

    onHardBackKeyClicked: {
        MOp.postPopupBackKey(13);
    }
}
/* EOF*/
