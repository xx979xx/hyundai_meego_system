import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../List" as XMList
import "../ListDelegate" as Test

FocusScope {
    id: idOtherCityList
    y: systemInfo.titleAreaHeight + 15
    width: systemInfo.lcdWidth;
    height: systemInfo.lcdHeight - (systemInfo.titleAreaHeight) - 15
    focus: true

    property alias listModel: idListView.listModel
    property alias listDelegate: idListView.listDelegate
    property alias noticeWhenListEmpty:idListView.noticeWhenListEmpty;
    property bool showEditItem: false
    property alias count: idListView.count
    property alias showSearchButtonWhenListEmpty: idListView.showSearchButtonWhenListEmpty

    property alias listView: idListView

    signal itemClicked(string stockName)
    signal itemInitWidth()
    signal itemMoved(int selectedIndex, bool isUp)

    signal doSearch()

    XMList.XMDataNormalList {
        id: idListView
        focus: true
        width: parent.width;
        height: parent.height;
        selectedIndex: -1;

        sectionShow:false;

        onSearchButton: {
            doSearch();
        }

        KeyNavigation.up: idMenuBar.idBandTop
    }

}
