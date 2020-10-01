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
    x: 0; y : 0

    focus: true

    property bool deleteListShow : true;
    // List Delegate
    XMDelegate.XMStockListDeleteDelegate { id: idStockListDeleteDelegate }

    listModel: stockMyFavoriteDataModel
    listDelegate: idStockListDeleteDelegate
    buttonNumber: 4
    buttonText1: stringInfo.sSTR_XMDATA_DELETE;
    buttonText2: stringInfo.sSTR_XMDATA_DELETE_ALL;
    buttonText3: stringInfo.sSTR_XMDATA_DESELECT;
    buttonText4: stringInfo.sSTR_XMDATA_CANCEL;

    buttonEnabled1: stockDataManager.countDeleteFavorites() > 0 ? true : false;
    buttonEnabled3: stockDataManager.countDeleteFavorites() > 0 ? true : false;

    textWhenListIsEmpty: stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITES_STOCK;
    checkDRSVisible: idMenuBar.checkDRSVisible

    signal close();
    signal showDeleteAllPopup();

    onInitialze: {
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE;
        idMenuBar.textTitleForDeleteAll = "("+stockDataManager.countDeleteFavorites()+")";
    }
    onClickMenu1: {
        deleteListShow = false;
        stockDataManager.executeDeleteFavorites();
//        interfaceManager.executeStockFavorite();
        reallyDeletedSuccessfully();
        close();
    }
    onClickMenu2: {
        //show Delete All? Dialog...
        stockDataManager.selectAllDeleteFavorites();
        showDeleteAllPopup();
    }
//    onDeleteAll: {
//        stockDataManager.executeDeleteFavorites();
//        interfaceManager.executeStockFavorite();
//        showDeletedSuccessfully();
//        close();
//    }

    onClickMenu3: {
        stockDataManager.deselectAllDeleteFavorites();
    }
    onClickMenu4: {
        close();
    }


    function onChangeCount()
    {
        idDeleteFavorite.buttonEnabled1 = stockDataManager.countDeleteFavorites() > 0 ? true : false;
        idDeleteFavorite.buttonEnabled3 = idDeleteFavorite.buttonEnabled1;
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE;
        idMenuBar.textTitleForDeleteAll = "("+stockDataManager.countDeleteFavorites()+")";
    }

    Connections {
        target: stockDataManager
        onSelectAllOccured: {
            onChangeCount();
        }
        onDeselectAllOccured: {
            onChangeCount();
        }
        onRollbackAllOccured: {
            onChangeCount();
        }
    }

}//idDeleteFavorite
