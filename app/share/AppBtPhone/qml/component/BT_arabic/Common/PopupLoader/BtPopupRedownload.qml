/**
 * /BT_arabic/Common/PopupLoader/BtPopupRedownload.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupRedownloadContainer

    popupBtnCnt: 2
    popupLineCnt: 1

    popupFirstText: stringInfo.str_Callhistory_Delete_Download

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        if("RecentCall" == mainViewState) {
            //gInfoViewState = recentCallState;
            recentCallState = "RecentDownLoadingMal";
            MOp.switchInfoViewScreen(recentCallState);

            BtCoreCtrl.invokeTrackerDownloadCallHistory();
            
            // ITS 0241987 최근 통화 목록 다운로드 완료 시 All 탭으로 포커스 이동하도록 수정
            if(false == iqs_15My) {
                select_recent_call_type = 2
            } else {
                select_recent_call_type = 5
            }

        }  else {
            //if(mainViewState == "Phonebook") {
            //gInfoViewState = contactState;
            contactState = "ContactsDownLoadingMal";
            MOp.switchInfoViewScreen(contactState);

            BtCoreCtrl.invokeTrackerDownloadPhonebook();
        }

        //DEPRECATED switchScreen("BtInfoView", false, 103);
        MOp.hidePopup();

        /* 다운로딩 화면은 버튼이 없어서 상단 밴드쪽으로 포커스 가도록 하는 코드
         * 자바스크립트에서 처리 할수 있도록 수정 필요
         */
        sigSetFocusToMainBand();
        //DEPRECATED idLoaderMaindBand.forceActiveFocus();
    }

    onPopupSecondBtnClicked:{ MOp.hidePopup(); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
