/**
 * /BT_arabic/Common/PopupLoader/BtPopupAddFavoriteFromSearch3.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeListContactSearch
{
    id: idBtPopupAddFavoriteFromSeach3

    popupBtnCnt: 1
    popupLineCnt: 4
    black_opacity: true

    popupTitleText: phoneName
    popupFirstBtnText: stringInfo.str_Bt_Cancel


    /* EVENT handlers */
    /* 팝업에서 정보가 4개 인 경우는 화면상 4개의 버튼으로 적용되어있어 각 버튼 들 마다 동작 Signal이 있음
      * 그리고 5개인 경우는 리스트로 적용이 되어있어 Delegate 안에 동작 추가
      */
    onBtnclicked4_1: {
        if("" == favoriteAdd) {
            BtCoreCtrl.HandleCallStart(phoneNum)
        } else {
            // 즐겨찾기 등록 부분
            BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name, contact_type_1, phoneNum)
        }
    }

    onBtnclicked4_2: {
        if("" == favoriteAdd) {
            BtCoreCtrl.HandleCallStart(homeNum)
        } else {
            // 즐겨찾기 등록 부분
            BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name, contact_type_2, homeNum)
        }
    }

    onBtnclicked4_3: {
        if("" == favoriteAdd) {
            BtCoreCtrl.HandleCallStart(officeNum)
        } else {
            // 즐겨찾기 등록 부분
            BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name, contact_type_3, officeNum)
        }
    }

    onBtnclicked4_4: {
        if("" == favoriteAdd) {
            BtCoreCtrl.HandleCallStart(otherNum)
        } else {
            // 즐겨찾기 등록 부분
            BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name, contact_type_4, otherNum)
        }
    }

    onPopupFirstBtnClicked: { MOp.hidePopup(); }
    onBackKeyPressed: { MOp.hidePopup(); }
}
/* EOF */
