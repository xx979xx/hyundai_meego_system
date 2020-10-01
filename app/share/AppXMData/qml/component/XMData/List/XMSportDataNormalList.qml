import Qt 4.7

// System Import
import "../../QML/DH" as MComp

FocusScope {
    id:container
//    y: 0//systemInfo.titleAreaHeight /*+ 15*/
//    width: systemInfo.lcdWidth;
//    height: systemInfo.lcdHeight - (systemInfo.titleAreaHeight) - 15
    width: parent.width;
    height: parent.height

    property alias listModel: idListView.model
    property alias listDelegate: idListView.delegate
    property alias count: idListView.count;
    property alias selectedIndex: idListView.selectedIndex;
    property alias listView: idListView;

    property alias noticeWhenListEmpty:idEmptyLabel.text;

    property int sectionX: 0;
    property bool sectionShow: false;
    property string sectionProperty: "cityName";
    property bool sectionCriteriaFirstCharecter: false;
    property int rowPerPage: 2//6
    property bool sportKeyLongProperty: false;

    signal itemClicked(string itemTitle);

    Component {
        id: sectionHeading

        Item{
            id: idSection
            x: sectionX; y: 0
            width: container.width;
            height: 62+17
            property string date: getDate()
            function getDate()
            {
                var strArray;
                var strTarget = section;
                strArray = strTarget.split(';sep;');
                return strArray[1] ? strArray[1] : strArray[0];
            }
            Text {
                id: idLeft
                x: parent.x + 26+39; y: (parent.height-30)/2
                width: parent.width - 26 -26
                text: date
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 30
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
/*
            property string leftText: getLeftText()
            property string rightText: getRightText()

            function getLeftText()
            {
                var strArray;
                var strTarget = section;

                strArray = strTarget.split(';sep;');
                return strArray[1] ? strArray[0] : "";
            }
            function getRightText()
            {
                var strArray;
                var strTarget = section;

                strArray = strTarget.split(';sep;');
                return strArray[1] ? strArray[1] : strArray[0];
            }
            Text {
                id: idLeft
                x: parent.x + 26; y: (parent.height-30)/2
                width: parent.width - 26 -26
                text: leftText
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 30
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                id: idRight
                x: 985; y: (parent.height-30)/2
                width: 220
                text: rightText
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 30
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
*/
        }
    }

    Component {
        id:noneComp
        Rectangle{color:"transparent";}
    }

    MComp.MListView {
        id: idListView
        //width:parent.width;
        focus: true
        anchors.fill: parent
        snapMode : ListView.SnapToItem
        clip: true
        flickDeceleration: 3000
        highlightMoveSpeed :9999
        cacheBuffer: height*10
        sportKeyLongMoveOnPage : sportKeyLongProperty

        //property bool isLoaded: false
        //property int selectedIndex: 0;

        //This is used for Change Row
        property int insertedIndex: -1
        property int selectedIndex:-1;
        property int curIndex:-1;
        property bool isDragStarted: false;

        section.property: sectionProperty
        section.delegate: (sectionShow)?sectionHeading:noneComp
        section.criteria: ViewSection.FullString//(sectionCriteriaFirstCharecter)?ViewSection.FirstCharacter:ViewSection.FullString

        signal itemInitWidth()
        signal itemMoved(int selectedIndex, bool isUp)

        Keys.onDownPressed: {
            if(idMenuBar.visibleSearchTextInput)
            {
                idMenuBar.contentItem.KeyNavigation.down.forceActiveFocus();
                event.accepted = true;
            }else
            {
                event.accepted = false;
            }
        }
        Keys.onUpPressed: {
            if(idMenuBar.visibleSearchTextInput)
            {
                idMenuBar.contentItem.KeyNavigation.up.forceActiveFocus();
                event.accepted = true;
            }else
            {
                event.accepted = false;
            }
        }
    }

    Text {
        id:idEmptyLabel;
        anchors.fill:parent
        text:"Check back later."
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: systemInfo.font_NewHDB
        font.pixelSize: 40
        color: colorInfo.brightGrey
        visible: idListView.count == 0;
    }

    MComp.MScroll {
        x:idListView.x + idListView.width - 28;
        y: 33// z:1
        scrollArea: idListView;
        height: idListView.height-y-y//474;
        width: 14
        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"
        visible: idListView.contentHeight > idListView.height//idListView.count > rowPerPage
    }
    //For Debuggging
    Text {
        x:5; y:-12; id:idFileName
        text:"XMSportDataNormalList.qml";
        color : "white";
        visible:isDebugMode();
    }
}
