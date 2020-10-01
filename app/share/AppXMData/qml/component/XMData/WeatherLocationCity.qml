import Qt 4.7

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate

FocusScope {
    property string szListMode : "normal"

    x: idLeftMenuFocusScope.x + idLeftMenuFocusScope.width
    y: idLeftMenuFocusScope.y
    height:idLeftMenuFocusScope.height
    width:systemInfo.lcdWidth - idLeftMenuFocusScope.width
    focus : true

    XMDelegate.XMOtherCityListDelegate { id: idOtherCityListDelegate }

    XMList.XMNormalListWithoutKeyNavigationForWeather {
        id: idWeatherCityList
        y: 0
        focus: true
        width: parent.width;
        height: parent.height;
        listModel: WEATHERCityList
        listDelegate: idOtherCityListDelegate
        selectedIndex: -1;

        function keyDown() {
            return idWeatherCityList;
        }

        KeyNavigation.down: keyDown();
    }
}
