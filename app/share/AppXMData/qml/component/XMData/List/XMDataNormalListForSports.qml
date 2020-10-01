import Qt 4.7

// System Import
import "../../QML/DH" as MComp

FocusScope {
    id:container
    width: parent.width;
    height: parent.height

    property alias listModel: idListView.model
    property alias listDelegate: idListView.delegate
    property alias count: idListView.count;
//    property alias selectedIndex: idListView.selectedIndex;
    property alias listView: idListView;

    property alias noticeWhenListEmpty:idEmptyLabel.text;
    property int rowPerPage: 3

//    property int sectionX: 0;
//    property bool sectionShow: false;
//    property string sectionProperty: "cityName";
//    property bool sectionCriteriaFirstCharecter: false;

    signal itemClicked(string itemTitle);

//    Component {
//        id: sectionHeading
//        Image {
//            id: idSection
//            x: sectionX + 6; //y: + 23
//            height:45;
//            source: imageInfo.imgFolderMusic + "tab_list_index.png"

//            Text {
//                id: idCurrLocTxt
//                x: parent.x + 26; y: parent.height/18
//                width: idListView.width
//                clip: true
//                text: "<font>" + section + "</font>"
//                font.family: systemInfo.font_NewHDB
//                font.pixelSize: 30
//                color: colorInfo.brightGrey
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//            }
//        }
//    }
//    Component {
//        id:noneComp
//        Rectangle{color:"transparent";}
//    }

    MComp.MListView {
        id: idListView
        //width:parent.width;
        focus: true
        anchors.fill: parent
        snapMode : ListView.SnapToItem
        clip: true
        flickDeceleration: 3000
        highlightMoveSpeed :9999

        //property bool isLoaded: false
        //property int selectedIndex: 0;

        //This is used for Change Row
        property int insertedIndex: -1
        property int selectedIndex:-1;
        property int curIndex:-1;

//        section.property: sectionProperty
//        section.delegate: (sectionShow)?sectionHeading:noneComp
//        section.criteria: ViewSection.FullString//(sectionCriteriaFirstCharecter)?ViewSection.FirstCharacter:ViewSection.FullString

        signal itemInitWidth()
        signal itemMoved(int selectedIndex, bool isUp)
    }

    Text {
        id:idEmptyLabel;
        anchors.fill:parent
        text:"Check back later."
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 40
        color: colorInfo.brightGrey
        elide: Text.ElideRight
        visible: idListView.count == 0;
    }

    MComp.MScroll {
        x:idListView.x + idListView.width - 19; y: 33// z:1
        scrollArea: idListView;
        height: parent.height-33-44//474;
        width: 13
        anchors.right: idListView.right
        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"
        visible:idListView.contentHeight > idListView.height
    }
    //For Debuggging
    Text {
        x:5; y:-12; id:idFileName
        text:"XMDataNormalList.qml";
        color : "white";
        visible:isDebugMode();
    }
}
