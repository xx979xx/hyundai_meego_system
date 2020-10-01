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

    property int isChanged:0;

    onIsChangedChanged: {
        if(idDeleteFavorite.visible)
            idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE
            idMenuBar.textTitleForDeleteAll = "("+isChanged+")"
    }

    // List Delegate
    Component{
        id: idXMWeatherListWithStarDelegate
        XMDelegate.XMWeatherListSelectDelegate {
            onCheckOn: {
                console.log("Delete Favorite index:" +index+" ON");
                weatherDataManager.setDeleteCheckToFavoriteList(index, true);
                isChanged++;
            }
            onCheckOff: {
                console.log("Delete Favorite index:" +index+" OFF");
                weatherDataManager.setDeleteCheckToFavoriteList(index, false);
                isChanged--;
            }
        }
    }
    listModel: weatherFavoriteList
    listDelegate: idXMWeatherListWithStarDelegate
    buttonNumber: 4
    buttonText1: stringInfo.sSTR_XMDATA_DELETE;
    buttonText2: stringInfo.sSTR_XMDATA_DELETE_ALL;
    buttonText3: stringInfo.sSTR_XMDATA_DESELECT;
    buttonText4: stringInfo.sSTR_XMDATA_CANCEL;

    buttonEnabled1: isChanged == 0 ? false : true;
    buttonEnabled2: idDeleteFavorite.count != 0
    buttonEnabled3: isChanged == 0 ? false : true;

    textWhenListIsEmpty: stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITE_LOCATION;

    signal close();
    signal showDeleteAllPopup();

    onInitialze: {
        weatherDataManager.updateListFavoriteRoleOfFavoriteList();
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE
        idMenuBar.textTitleForDeleteAll = "("+isChanged+")"
    }
    onClickMenu1: {
        weatherDataManager.deleteCurrentCheckItemFromFavoriteList();
        reallyDeletedSuccessfully();
        close();
    }
    onClickMenu2: {
        //show Delete All? Dialog...
        isChanged = weatherDataManager.getFavoriteItemNumberForDeleteAll();
        showDeleteAllPopup();
    }
    onClickMenu3: {
        weatherDataManager.updateListFavoriteRoleOfFavoriteList();
        isChanged = 0;
    }
    onClickMenu4: {
        close();
    }

    Connections{
        target: weatherDataManager
        onRollbackAllDeleteItems: {
            isChanged = weatherDataManager.getFavoriteItemNumberForDeleteAllAfterRollback();
        }
    }

}//idDeleteFavorite
