import Qt 4.7

// System Import
import "../../QML/DH" as MComp

// Local Import
import "../ListDelegate" as XMDelegate

FocusScope {
    y: 0//systemInfo.titleAreaHeight /*+ 15*/
    width: systemInfo.lcdWidth;
    height: systemInfo.lcdHeight - (systemInfo.titleAreaHeight) - 15

    property alias listModel: idListView.model
    property alias listDelegate: idListView.delegate

    property alias count: idListView.count;
    property alias listView  :idListView
    property int sectionX: 0;
    property bool sectionShow: false;
    property string sectionProperty: "cityName";
    property bool sectionCriteriaFirstCharecter: false;
    property int rowPerPage: 6

    signal itemClicked(string itemTitle);

    Component {
        id: sectionHeading
        Image {
            id: idSection
            x: sectionX
            height:45;
            source: imageInfo.imgFolderMusic + "tab_list_index.png"

            Text {
                id: idCurrLocTxt
                x: parent.x + 26; y: parent.height/18
                width: idListView.width
                clip: true
                text: (section == "1")?"Football":(section == "2")?"Baseball":(section == "3")?"Basketball":(section == "4")?"Ice Hockey":(section == "5")?"MotorSport":(section == "6")?"Golf":"Soccer" //"<font>" + section + "</font>"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 30
                color: colorInfo.bandBlue // Qt.rgba( 124/255, 189/255, 255/255, 1) // ITS[219706]
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    Component {
        id:noneComp
        Rectangle{color:"transparent";}
    }

    MComp.MListView {
        id: idListView
        focus: true
        anchors.fill: parent
        snapMode : ListView.SnapToItem
        clip: true
        flickDeceleration: 3000
        highlightMoveSpeed :9999

        property bool isLoaded: false

        property int insertedIndex: -1
        property bool isUp: false

        section.property: sectionProperty
        section.delegate: (sectionShow)?sectionHeading:noneComp
        section.criteria: ViewSection.FullString
    }

    MComp.MScroll {
        x:idListView.x + idListView.width - 28; y: 33// z:1
        scrollArea: idListView;
        height: parent.height-33-44//474;
        width: 13
        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"
        visible:idListView.contentHeight > idListView.height;
    }
}
