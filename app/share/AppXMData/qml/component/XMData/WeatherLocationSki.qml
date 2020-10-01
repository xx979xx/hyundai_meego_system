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

    focus: true;

    XMDelegate.XMOtherCityListDelegate { id: idOtherCityListDelegate }

    XMList.XMNormalListWithoutKeyNavigationForWeather {
        id: idWeatherCitySkiList
        focus: true
        width: parent.width;
        height: parent.height;
        listModel: WEATHERSkiList
        listDelegate: idOtherCityListDelegate

        function keyDown() {
                return idWeatherCitySkiList;
        }

        KeyNavigation.down: keyDown();
    }
}
