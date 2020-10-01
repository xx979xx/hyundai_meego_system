/**
 * FileName: MovieTimesMyFavoritesDeleteTheaters.qml
 * Author: David.Bae
 * Time: 2012-05-11 15:58
 *
 * - 2012-05-11 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./ListDelegate" as XMDelegate
import "../XMData/Popup" as MPopup


XMDataFavoritesAddTemplate{
    id:idDeleteFavarite
    x: 0; y : 0
    focus: true

    property int changeCount:0;

    onChangeCountChanged: {
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE;
        idMenuBar.textTitleForDeleteAll = "("+changeCount+")";
    }

    //List Delegate
    Component{
        id: idDelegate
        XMDelegate.XMMovieTimesListSelectDelegate {
            //isAddFavorite: true;
            onCheckOn: {
                //console.log("Add Favorite index:" +index+" ON");
                movieTimesDataManager.setDeleteCheckToFavoriteList(locID, true);
                changeCount = changeCount +1;
            }
            onCheckOff: {
                //console.log("Add Favorite index:" +index+" OFF");
                movieTimesDataManager.setDeleteCheckToFavoriteList(locID, false);
                changeCount = changeCount -1;
            }
        }
    }

    listModel: favoriteList
    listDelegate: idDelegate
    buttonNumber: 4
    buttonText1: stringInfo.sSTR_XMDATA_DELETE;
    buttonText2: stringInfo.sSTR_XMDATA_DELETE_ALL;
    buttonText3: stringInfo.sSTR_XMDATA_DESELECT;
    buttonText4: stringInfo.sSTR_XMDATA_CANCEL;

    buttonEnabled1: changeCount != 0;
    buttonEnabled2: idDeleteFavarite.count != 0
    buttonEnabled3: changeCount != 0;

    textWhenListIsEmpty: stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITES_THEATERS
    checkDRSVisible: idMenuBar.checkDRSVisible

    signal close();

    onInitialze: {
        movieTimesDataManager.updateListFavoriteRoleOfFavoriteList();
        changeCount = 0;
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE;
        idMenuBar.textTitleForDeleteAll = "("+changeCount+")";
    }

    onClose: {
        callItWhenClose();
    }

    onClickMenu1: { // "Delete"
        movieTimesDataManager.deleteCurrentCheckItemFromFavoriteList();
        reallyDeletedSuccessfully();
        close();
    }
    onClickMenu2: {
        changeCount = movieTimesDataManager.getFavoriteItemNumberForDeleteAll();
        idPopupCaseD.show();
    }
    onClickMenu3: {
        //clickedDeselectedAllButton();
        movieTimesDataManager.updateListFavoriteRoleOfFavoriteList();
        //close();//Do not close when select 'deselect all' button
        changeCount = 0;
    }
    onClickMenu4: {
        close();
    }
    Connections{
        target: movieTimesDataManager
        onRollbackAllDeleteItems: {
            changeCount = movieTimesDataManager.getFavoriteItemNumberForDeleteAllAfterRollback();
        }
    }

    function callItWhenClose(){
        parent.hide();
    }
}//idDeleteFavarite
