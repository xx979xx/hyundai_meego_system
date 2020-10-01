import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate

FocusScope{
    id:container
    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight-systemInfo.titleAreaHeight;
    focus: true;

    Image
    {
        x:0
        y:0
        width: parent.width
        height: parent.height
        source: imageInfo.imgFolderGeneral + "bg_main.png"
    }

    Component.onCompleted: {
        init();
    }

    function init()
    {
        weatherDataManager.copyListModelToAddFavoriteList();
        weatherDataManager.initIntelliKeyboardForCity();

//        weatherDataManager.searchPredicate = "^-";
    }

    onVisibleChanged: {
        if(container.visible==true){
            init();
        }
    }

    XMDelegate.XMWeatherSearchListDelegate{ id : idWeatherListDelegate }

    XMList.XMDataNormalList{
        id:idWeatherList
        x:0;y:0
        focus: true
        width: parent.width;
        height: parent.height;
        listModel: weatherCityListForSearch
        listDelegate: idWeatherListDelegate

        onCountChanged: {
            if(visible)
            {
                idMenuBar.foundItemCount = count;
                idMenuBar.imageSearchItemIcon = imageInfo.imgFolderXMData + "icon_loction.png"
            }
        }
        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_SPORTS_NO_SEARCH_RESULT
    }

    function onSelectItemForSearch(type, CityID)
    {
        weatherDataManager.bIsUserLocMode = true;
        if(type == 1)
            selectLocationSki(CityID);
        else
            selectLocationCity(CityID);
    }
}
