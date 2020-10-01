/**
 * FileName: SportsMyFavoritesDeleteTeam.qml
 * Author: David.Bae
 * Time: 2012-04-25 17:41
 *
 * - 2012-04-25 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./ListDelegate" as XMDelegate

XMDataFavoritesAddTemplate{
    id:container
    x: 0;y : 0
    width:systemInfo.lcdWidth;
    height: systemInfo.lcdHeight-systemInfo.titleAreaHeight;

    focus: true

    property int changeCount:0;

    onChangeCountChanged: {
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE;
        idMenuBar.textTitleForDeleteAll = "("+changeCount+")";
    }

    // List Delegate
    Component{
        id: idListDelegate
        XMDelegate.XMSportsListSelectDelegate {
            onCheckOn: {
                console.log("Delete Favorite index:" +index+" ON");
                sportsDataManager.setDeleteCheckToFavoriteList(index, true);
                changeCount = changeCount + 1;
            }
            onCheckOff: {
                console.log("Delete Favorite index:" +index+" OFF");
                sportsDataManager.setDeleteCheckToFavoriteList(index, false);
                changeCount = changeCount - 1;
            }
        }
    }
    listModel: sportsFavoriteTeamListModel;
    listDelegate: idListDelegate
    buttonNumber: 4
    buttonText1: stringInfo.sSTR_XMDATA_DELETE;
    buttonText2: stringInfo.sSTR_XMDATA_DELETE_ALL;
    buttonText3: stringInfo.sSTR_XMDATA_DESELECT;
    buttonText4: stringInfo.sSTR_XMDATA_CANCEL;

    buttonEnabled1: changeCount>0;
    buttonEnabled2: idDeleteFavorite.count != 0
    buttonEnabled3: changeCount>0;
    checkDRSVisible: idMenuBar.checkDRSVisible

//    textWhenListIsEmpty: stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITES_LEAGUE;

    signal showDeleteAllPopup();

    onInitialze: {
        sportsDataManager.updateListFavoriteRoleOfFavoriteList();
        changeCount = 0;
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE;
        idMenuBar.textTitleForDeleteAll = "("+changeCount+")";
    }
    onClickMenu1: {
        sportsDataManager.deleteCurrentCheckItemFromFavoriteList();
        reallyDeletedSuccessfully();
        close();
    }
    onClickMenu2: {
        //show Delete All? Dialog...
        changeCount = sportsDataManager.getFavoriteItemNumberForDeleteAll();
        showDeleteAllPopup();
    }
//    onDeleteAll: {
//        sportsDataManager.deleteAllFavoriteList();
//        showDeletedSuccessfully();
//        close();
//    }

    onClickMenu3: {
        sportsDataManager.updateListFavoriteRoleOfFavoriteList();
        changeCount = 0;
    }
    onClickMenu4: {
        close();
    }
    Connections{
        target: sportsDataManager
        onRollbackAllDeleteItems: {
            changeCount = sportsDataManager.getFavoriteItemNumberForDeleteAllAfterRollback();
        }
    }

    function close(){
        parent.hide();
    }
}//idDeleteFavorite
