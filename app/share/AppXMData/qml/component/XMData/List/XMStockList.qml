import Qt 4.7

// System Import
import "../../QML/DH" as MComp

FocusScope {
    id: idOtherCityList
    y: systemInfo.titleAreaHeight + 15
    width: systemInfo.lcdWidth;
    height: systemInfo.lcdHeight - (systemInfo.titleAreaHeight) - 15

    property alias listModel: idListView.model
    property alias listDelegate: idListView.delegate
    property bool showEditItem: false

    signal itemClicked(string stockName)

    ListView {
        id: idListView
        focus: true
        anchors.fill: parent
        clip: true
        flickDeceleration: 3000
        highlightMoveSpeed :9999

        KeyNavigation.up: idMenuBar
    }

    MComp.VScrollBar {
        x: systemInfo.lcdWidth - width - 15
        scrollArea: idListView;
        height: idListView.height; width: 8
    }
}
