import Qt 4.7

// System Import
import "../../QML/DH" as MComp

// Local Import
import "../ListDelegate" as XMDelegate

FocusScope {
    property alias listModel: idListView.model
    property alias listDelegate: idListView.delegate

    property alias count: idListView.count;
    property alias listView  :idListView;
    property alias currentIndex: idListView.currentIndex;

    property alias noticeWhenListEmpty:idEmptyLabel.text;

    signal itemClicked(string itemTitle);

    property int rowPerPage: 6

    //property alias count: idListView.count;

    MComp.MListView {
        id: idListView
        x: 15
        width: 1257-15
        focus: true
        anchors.fill: parent
        snapMode : ListView.SnapToItem
        clip: true
        flickDeceleration: 3000
        highlightMoveSpeed :9999

        property bool isLoaded: false

        property int insertedIndex: -1
        property bool isUp: false
    }

    Text {
        id:idEmptyLabel;
        anchors.fill:parent
        text:"No information"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 40
        color: colorInfo.brightGrey
        visible: idListView.count == 0;
    }

    MComp.MScroll {
        x:1257; y: 33// z:1
        scrollArea: idListView;
        height: parent.height-33-44//474;
        width: 13
        anchors.right: idListView.right
        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"

        visible:idListView.contentHeight > idListView.height && idListView.count > 0;
    }
}
