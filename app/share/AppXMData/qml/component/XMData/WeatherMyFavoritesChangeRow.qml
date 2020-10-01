/**
 * FileName: FuelPriceMyFavoritesChangeRow.qml
 * Author: David.Bae
 * Time: 2012-04-26 13:35
 *
 * - 2012-04-26 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./ListDelegate" as XMDelegate

XMDataFavoritesChangeRowTemplate{
    id:idChangeRow
    x: 0;y : 0
    focus: true;
    sectionProperty: "cityName"

    Component{
        id: idXMWeatherListChangeRowDelegate
        XMDelegate.XMWeatherFavoriteChangeRowListDelegate {
            onChangeRow:{
                weatherDataManager.changeFavoriteRow(fromIndex, toIndex);
            }
            onChangeRowForReorderModel: {
                console.log(" onChangeRowForReorderModel ==> from:"+fromIndex + ", to:" + toIndex);
                weatherDataManager.reorderDataModel(fromIndex, toIndex);
            }
        }
    }

    listModel: weatherReorder
    listDelegate: idXMWeatherListChangeRowDelegate
    textWhenListIsEmpty: stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITE_LOCATION;
    rowPerPage: 6//[ITS 193372]

    function isHide()
    {
        if(idListView.isDragStarted)
        {
            idListView.isDragStarted = false;
            idListView.interactive = true;
            weatherDataManager.reorderDataModel(idListView.curIndex, idListView.insertedIndex);
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
