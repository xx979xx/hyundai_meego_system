/**
 * /BT/Common/PopupLoader/BtPopupAddFavorite.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeDim
{
    id: idBtPopupAddFavorite

    firstText: stringInfo.str_Favorite_Save
    secondText: BtCoreCtrl.m_nCountFavoriteContactsList + " / 10"


    /* EVENT handlers */
    onShow: {
        if("FROM_CONTACT" == favoriteAdd) {
            // 즐겨찾기에서 즐겨찾기 추가인 경우
            popScreen(104);
        } else if("FROM_SEARCH" == favoriteAdd) {
            // 즐겨찾기 -> 폰북 -> 폰북검색 -> 즐겨찾기 추가 한 경우로 2개의 화면을 빼야함
            popScreen(105);
            popScreen(106);
        } else {
            // 최근통화 또는 폰북 자체에서 즐겨찾기 추가인 경우, do nothing
        }

        favoriteAdd = "";
    }
    onHide: {}

    onHardBackKeyClicked:   { MOp.hidePopup(); }
    onPopupClicked:         { MOp.hidePopup(); }
}
/* EOF */
