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

XMDataFavoritesChangeRowSportsTemplate{
    id:idMyFavoriteList

    focus: true
    idListView.cacheBuffer: 0
    sectionProperty: "display"

    Component{
        id: idSportsListReorderDelegate
        XMDelegate.XMSportsMyFavoriteReorderDelegate {
            onChangeRow:{
                console.log(" ==> from:"+fromIndex + ", to:" + toIndex);
                sportsDataManager.movedMyFavorites(fromIndex, toIndex);
            }
            onChangeRowForReorderModel: {
                sportsDataManager.reorderDataModel(fromIndex, toIndex);
            }
        }
    }

    listModel: sportsReorder
    listDelegate: idSportsListReorderDelegate
    textWhenListIsEmpty: stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITE_LOCATION;
    rowPerPage: 6//[ITS 193372]

    function isHide()
    {
        if(idListView.isDragStarted)
        {
            idListView.isDragStarted = false;
            idListView.interactive = true;
            sportsDataManager.reorderDataModel(idListView.curIndex, idListView.insertedIndex);
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
