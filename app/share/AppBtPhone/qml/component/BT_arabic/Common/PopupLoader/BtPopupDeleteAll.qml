/**
 * /BT_arabic/Common/PopupLoader/BtPopupDeleteAll.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupDeleteAllContainer

    popupBtnCnt: 2
    popupLineCnt: 1

    popupFirstText: stringInfo.str_Delete_All_Message
    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onShow: {}
    onHide: {
        //delete_type = "";
    }

    onPopupFirstBtnClicked: {
        /* 화면 빠진다음에 삭제완료 팝업이보여야 하므로, 먼저 화면을 pop 하고 삭제함(삭제실패 케이스 처리 필요함)
             * 삭제 완료후 화면 전환은 State 변경에 따라 자동으로 변경됨
             * (main.qml 참조, 디바이스 삭제는 SettingsDeviceConnect.qml 참조)
             */
        /*if("device" == delete_type) {
                // 디바이스 삭제
                popScreen(1003);
                BtCoreCtrl.invokeTrackerRemoveAllFavorite();
            } else*/

        if("recent" == delete_type) {
            // 최근통화 삭제
            BtCoreCtrl.invokeTrackerRemoveAllCallHistory(select_recent_call_type);
            popScreen(1004);
        } else if("favorite" == delete_type) {
            // 즐겨찾기 삭제
            popScreen(1005);
            BtCoreCtrl.invokeTrackerRemoveAllFavorite();
        } else {
            qml_debug("Delete_type > Null");
        }
    }

    onPopupSecondBtnClicked: {
        MOp.hidePopup();
    }

    onHardBackKeyClicked: {
        MOp.hidePopup();
    }
}
/* EOF */
