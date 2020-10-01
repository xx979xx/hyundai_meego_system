/**
 * FileName: FuelPriceMyFavoritesDeleteStore.qml
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
    id:idDeleteFavorite
    x: 0;y : 0
    focus: true;


    property int changeCount:0;

    onChangeCountChanged: {
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE;
        idMenuBar.textTitleForDeleteAll = "("+changeCount+")";
    }

    // List Delegate
    Component{
        id: idXMFuelPricesListWithStarDelegate
        XMDelegate.XMFuelPricesListSelectDelegate {
            onCheckOn: {
                console.log("Delete Favorite index:" +index+" ON");
                fuelPriceDataManager.setDeleteCheckToFavoriteList(locationID, true);
                changeCount = changeCount + 1;
            }
            onCheckOff: {
                console.log("Delete Favorite index:" +index+" OFF");
                fuelPriceDataManager.setDeleteCheckToFavoriteList(locationID, false);
                changeCount = changeCount - 1;
            }
        }
    }

    listModel: fuelFavoriteList
    listDelegate: idXMFuelPricesListWithStarDelegate
    buttonNumber: 4
    rowPerPage: 4
    buttonText1: stringInfo.sSTR_XMDATA_DELETE;
    buttonText2: stringInfo.sSTR_XMDATA_DELETE_ALL;
    buttonText3: stringInfo.sSTR_XMDATA_DESELECT;
    buttonText4: stringInfo.sSTR_XMDATA_CANCEL;

    buttonEnabled1: changeCount != 0;
    buttonEnabled2: idDeleteFavorite.count != 0
    buttonEnabled3: changeCount != 0;

    textWhenListIsEmpty: stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITES_STORES;

    signal close();
    signal showDeleteAllPopup();

    onInitialze: {
        fuelPriceDataManager.updateListFavoriteRoleOfFavoriteList();
        changeCount = 0;
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE;
        idMenuBar.textTitleForDeleteAll = "("+changeCount+")";
    }
    onClickMenu1: {
        fuelPriceDataManager.deleteCurrentCheckItemFromFavoriteList();
        reallyDeletedSuccessfully();
        close();
    }
    onClickMenu2: {
        //show Delete All? Dialog...
        changeCount = fuelPriceDataManager.getFavoriteItemNumberForDeleteAll();
        showDeleteAllPopup();
    }
//    onDeleteAll: {
//        fuelPriceDataManager.deleteAllFavoriteList();
//        showDeletedSuccessfully();
//        close();
//    }

    onClickMenu3: {
        fuelPriceDataManager.updateListFavoriteRoleOfFavoriteList();
        changeCount = 0;
    }
    onClickMenu4: {
        close();
    }
    Connections{
        target: fuelPriceDataManager
        onRollbackAllDeleteItems: {
            changeCount = fuelPriceDataManager.getFavoriteItemNumberForDeleteAllAfterRollback();
        }
    }
}//idDeleteFavorite
