import Qt 4.7

// System Import
import "../../QML/DH" as MComp

FocusScope {
    y: systemInfo.titleAreaHeight + 15
    width: systemInfo.lcdWidth;
    height: systemInfo.lcdHeight - (systemInfo.titleAreaHeight) - 15

    property alias listModel: idListView.model
    property alias listDelegate: idListView.delegate

    property alias count: idListView.count;
    property alias listView  :idListView

    signal itemClicked(string itemTitle);

    //property alias count: idListView.count;

    Component {
        id: sectionHeading
        Image {
            id: idSection
            x: 29; //y: + 23
            source: imageInfo.imgFolderMusic + "tab_list_index.png"

            Text {
                id: idCurrLocTxt
                x: 6 + 26; y: 0 //parent.height/18
                width: 23
                height: parent.height
                clip: true
                text: section
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 30
                color: colorInfo.bandBlue
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    /*ListView*/MComp.MListView {
        id: idListView
        focus: true
        anchors.fill: parent
        clip: true
        flickDeceleration: 3000
        highlightMoveSpeed :9999

        property bool isLoaded: false
        property int rowPerPage: 5

        property int insertedIndex: -1
        property bool isUp: false

        section.property: "cityName"
        section.delegate: sectionHeading
        section.criteria: ViewSection.FirstCharacter

//        Rectangle{
//            width:parent.width
//            height:parent.height
//            border.color: "green"
//            border.width: 1
//            color:"transparent"
//            visible: isDebugMode();
//        }
    }

    MComp.MScroll {
        x:idListView.x + idListView.width - 19; y: 33// z:1
        scrollArea: idListView;
        height: parent.height-33-44//474;
        width: 13
        anchors.right: idListView.right
        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"
//        Rectangle{
//            anchors.fill:parent
//            border.color: "green"
//            border.width: 1
//            color:"transparent"
//            visible:isDebugMode();
//        }
        visible:idListView.contentHeight > idListView.height
    }
//    MComp.VScrollBar {
//        x: systemInfo.lcdWidth - width - 15
//        scrollArea: idListView;
//        height: idListView.height; width: 8
//    }
}
