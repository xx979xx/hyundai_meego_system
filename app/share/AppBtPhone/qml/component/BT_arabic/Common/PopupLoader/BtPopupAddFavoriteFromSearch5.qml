/**
 * /BT_arabic/Common/PouppLoader/BtPopupAddFavoriteFromSeach5.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeListContactSearchAdd
{
    id: idBtPopupAddFavoriteFromSeach5

    popupBtnCnt: 1
    popupLineCnt: 4

    popupTitleText: phoneName
    popupFirstBtnText: stringInfo.str_Bt_Cancel


    /* EVENT handlers */
    onPopupFirstBtnClicked: { MOp.hidePopup(); }
    onBackKeyPressed:       { MOp.hidePopup(); }


    onBtnclicked2_1: {
        if("" == favoriteAdd) {
            BtCoreCtrl.HandleCallStart(phoneNum);
        } else {
            // 즐겨찾기 등록 부분
            BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name, contact_type_1, phoneNum);
        }
    }

    onBtnclicked2_2: {
        if("" == favoriteAdd) {
            BtCoreCtrl.HandleCallStart(homeNum);
        } else {
            // 즐겨찾기 등록 부분
            BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name, contact_type_2, homeNum);
        }
    }

    onBtnclicked3_1: {
        if("" == favoriteAdd) {
            BtCoreCtrl.HandleCallStart(phoneNum);
        } else {
            // 즐겨찾기 등록 부분
            BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name, contact_type_1, phoneNum);
        }
    }

    onBtnclicked3_2: {
        if("" == favoriteAdd) {
            BtCoreCtrl.HandleCallStart(homeNum)
        } else {
            // 즐겨찾기 등록 부분
            BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name, contact_type_2, homeNum)
        }
    }

    onBtnclicked3_3: {
        if("" == favoriteAdd) {
            BtCoreCtrl.HandleCallStart(officeNum)
        } else {
            // 즐겨찾기 등록 부분
            BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name, contact_type_3, officeNum)
        }
    }
}
/* EOF */
