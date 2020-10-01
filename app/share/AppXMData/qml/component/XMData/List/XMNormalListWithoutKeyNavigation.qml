import Qt 4.7

// System Import
import "../../QML/DH" as MComp

FocusScope {
    //width: parent.width - x;
    height: parent.height

    property alias listModel: idListView.model
    property alias listDelegate: idListView.delegate
    property alias count: idListView.count;
    property alias selectedIndex: idListView.selectedIndex;

    property int listCount: idListView.count;

    signal itemClicked(string itemTitle)

    ListView {
        id: idListView
        focus: true
        anchors.fill: parent
        snapMode : ListView.SnapToItem
        clip: true
        flickDeceleration: 3000
        highlightMoveSpeed :9999
        //verticalVelocity: 3000

        property bool isLoaded: false
        property int selectedIndex: 0;

        Rectangle{
            width:parent.width
            height:parent.height
            border.color: "green"
            border.width: 1
            color:"transparent"
            visible:isDebugMode();
            Text{text: "List Count : " + idListView.count; color: "white"; }
        }
    }

//    MComp.VScrollBar {
//        //x: parent.width - width - 5 - parent.x
//        x:idListView.x + idListView.width - 20
//        y: 10
//        //anchors.right: idListView.Right-16
//        scrollArea: idListView;
//        height: idListView.height-20; width: 8
//        visible:false;
//    }
    MComp.MScroll {
        x:idListView.x + idListView.width - 19; y: 33// z:1
        scrollArea: idListView;
        height: parent.height-33-44//474;
        width: 13
        anchors.right: idListView.right
        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"

        Rectangle{
            anchors.fill:parent
            border.color: "green"
            border.width: 1
            color:"transparent"
            visible:isDebugMode();
        }
    }

    //For Debuggging
    Text {
        x:5; y:-12; id:idFileName
        text:"XMNormalListWithoutKeyNavigation.qml";
        color : "white";
        visible:isDebugMode();
    }
}
