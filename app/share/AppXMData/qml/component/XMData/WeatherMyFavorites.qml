import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Label Import
import "./Common" as XMCommon
import "./List" as XMList
import "./ListDelegate" as XMDelegate
//import "../../component/XMData/Common" as XMCommon

// Because Loader is a focus scope, converted from FocusScope to Item.
FocusScope {
    x: idLeftMenuFocusScope.x + idLeftMenuFocusScope.width
    y: idLeftMenuFocusScope.y
    height:idLeftMenuFocusScope.height
    width:systemInfo.lcdWidth - idLeftMenuFocusScope.width
    focus: true;
//    width: parent.width;
//    height: parent.height;
    //XMCommon.StringInfo { id: stringInfo }
    property alias listModel: idWeatherList.listModel
    property alias listCount: idWeatherList.count

    Component{
        id: idWeatherListDelegate
        XMDelegate.XMWeatherListDelegate {}
    }

    XMList.XMMyFavoritesList{
        id: idWeatherList
        x:0;y:0;
        focus: true
        width: parent.width;
        height: parent.height;
        listDelegate: idWeatherListDelegate
        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITE_LOCATION
        showSearchButtonWhenListEmpty: true

        onDoSearch: {
            idWeatherSearchForCity.show();
            UIListener.autoTest_athenaSendObject();
        }

        Connections{
            target : weatherDataManager
            onCheckForFocus:{
                if(visible)
                {
                    idWeatherList.listView.listView.positionViewAtIndex(0, ListView.Visible);
                    idWeatherList.listView.listView.currentIndex = 0;
                    if(isToastPopupVisible() == false)
                    {
                        idWeatherList.forceActiveFocus();
                    }
                }
            }
        }
    }

    function onSelectItem(cityID, itemType)
    {
        weatherDataManager.bIsUserLocMode = true;
        if(itemType == 0)
            selectLocationCity(cityID);
        else if(itemType == 1)
            selectLocationSki(cityID);
    }
}
