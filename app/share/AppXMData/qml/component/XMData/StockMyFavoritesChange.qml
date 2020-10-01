import Qt 4.7

// System Import
import "../QML/DH" as MComp
import "./ListDelegate" as XMDelegate



XMDataFavoritesChangeRowTemplate{
    id:idMyFavoriteList

    focus: true
    idListView.cacheBuffer: 99999
    sectionProperty: "display"

    Component{
        id: idStockListChangeDelegate
        XMDelegate.XMStockListChangeRowDelegate {
            onChangeRow:{
                console.log(" ==> from:"+fromIndex + ", to:" + toIndex);
                stockDataManager.movedMyFavorites(fromIndex, toIndex);
            }
            onChangeRowForReorderModel: {
                stockDataManager.reorderDataModel(fromIndex, toIndex);
            }
        }
    }

    listModel: stockMyFavoriteCahngeModel/*weatherFavoriteList*///stockMyFavoriteCahngeModel
    listDelegate: idStockListChangeDelegate
    textWhenListIsEmpty: stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITE_LOCATION;
    rowPerPage: 6//[ITS 193372]

    function isHide()
    {
        if(idListView.isDragStarted)
        {
            idListView.isDragStarted = false;
            idListView.interactive = true;
            stockDataManager.reorderDataModel(idListView.curIndex, idListView.insertedIndex);
            idListView.currentIndex = idListView.insertedIndex;
            idListView.insertedIndex = -1;
            idListView.curIndex = -1;
            return false;
        }else
        {
            return true;
        }
    }

    signal close();
}//idChangeRow
