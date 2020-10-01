import Qt 4.7

import "../ListElement" as XMListElement

// Because Loader is a focus scope, converted from FocusScope to Item.
FocusScope {
    id: idMainMenuListList
    width: parent.width
    height: parent.height
    clip: true
    focus: true

    property alias listModel: idListView.listModel
    property alias listDelegate: idListView.listDelegate
    property QtObject delegateItemInfo : XMListElement.XMDataMainMenuElement{}
    signal checkNeyNavigation();

    property int e_WEATHER  : 0
    property int e_TRAFFIC  : 1
    property int e_STOCK    : 2
    property int e_SPORTS   : 3
    property int e_FUEL     : 4
    property int e_MOVIE    : 5

    property bool enableWeather: delegateItemInfo.isEnable(e_WEATHER)
    property bool enableTraffic: delegateItemInfo.isEnable(e_TRAFFIC)
    property bool enableStock: delegateItemInfo.isEnable(e_STOCK)
    property bool enableSports: delegateItemInfo.isEnable(e_SPORTS)
    property bool enableFuel: delegateItemInfo.isEnable(e_FUEL)
    property bool enableMovie: delegateItemInfo.isEnable(e_MOVIE)

    XMDataNormalList {
        id: idListView
        width: parent.width;
        height: parent.height;
        listView.cacheBuffer: 99999
        rowPerPage: 3
        focus: true

        property int depth: 0

        Connections{
            target: UIListener
            onSetMainFocusWeather: {
                idListView.currentIndex = 0;
                idListView.listView.positionViewAtIndex(0, ListView.Beginning);
                idListView.forceActiveFocus();
            }
        }
    }
}
