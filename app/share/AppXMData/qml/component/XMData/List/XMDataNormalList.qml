import Qt 4.7
import QtQuick 1.1

// System Import
import "../../QML/DH" as MComp

FocusScope {
    id:container
    width: parent.width;
    height: parent.height

    property alias listModel: idListView.model
    property alias listDelegate: idListView.delegate
    property alias count: idListView.count;
    property alias selectedIndex: idListView.selectedIndex;
    property alias listView: idListView;

    property alias noticeWhenListEmpty:idEmptyLabel.text;
    property bool showSearchButtonWhenListEmpty: false;
    property bool searchButtonEnable: true;
    property bool showSearchCacheBuffer: true;

    property int sectionX: 0;
    property bool sectionShow: false;
    property string sectionProperty: "cityName";
    property bool sectionCriteriaFirstCharecter: false;
    property int rowPerPage: 6;
    property bool bDeleteScroll: false;

    property alias upFocusItem: idListView.upFocusItemForReleaseUpKeyWithoutLongPress

    property alias currentIndex: idListView.currentIndex;//[ITS 185394]

    signal itemClicked(string itemTitle);

    signal searchButton();

    Component {
        id: sectionHeading
        BorderImage {
            id: idSection
            x: sectionX + 6; //y: + 23
            width : 1210
            source: imageInfo.imgFolderMusic + "tab_list_index.png"
            border { left: 40; right: 40;/* top: 8; bottom: 8*/ }

            Text {
                id: idCurrLocTxt
                x: parent.x + 26; y: parent.height/18-5
                width: idListView.width
                clip: true
                text: "<font>" + section + "</font>"
                font.family: systemInfo.font_NewHDB
                font.pixelSize: 30
                color: colorInfo.bandBlue
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
        //width:parent.width;
        focus: visible
        anchors.fill: parent
        snapMode : ListView.SnapToItem
        clip: true
        boundsBehavior: isDragAndBounds ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
        flickDeceleration: 3000
        highlightMoveSpeed :9999
        cacheBuffer: showSearchCacheBuffer ? height*2 : 0
        visible: count > 0

        //property bool isLoaded: false
        //property int selectedIndex: 0;

        //This is used for Change Row
        property int insertedIndex: -1;
        property int selectedIndex:-1;
        property int curIndex:-1;
        property int rowPerPage:6;
        property int nScroll: (bDeleteScroll)?11 : 28

        section.property: sectionProperty
        section.delegate: (sectionShow)?sectionHeading:noneComp
        section.criteria: ViewSection.FullString//(sectionCriteriaFirstCharecter)?ViewSection.FirstCharacter:ViewSection.FullString

        signal itemInitWidth()
        signal itemMoved(int selectedIndex, bool isUp)
    }

    Item{
        id:idShowTextAndButtonWhenListIsEmpty
        width:parent.width
        height:parent.height;
        visible: idListView.count === 0 && idEmptyLabel.text != "";
        onVisibleChanged: {
            if(visible)
                idEditButton.focus = true;
            else
                idListView.focus = true;
        }

        //Show Text
        Text {
            id:idEmptyLabel;
            x: 0; y: 0
            width: parent.width
            height: parent.height - (showSearchButtonWhenListEmpty ? font.pixelSize *2 + font.pixelSize/2 : font.pixelSize/2)
            text: ""
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            wrapMode: Text.Wrap
            lineHeight: 0.75
            color: colorInfo.brightGrey
        }
        // Search Button/
        MComp.MButton{
            id:idEditButton
            focus: visible
            x: (parent.width - width)/2
            y: (parent.height - height)/2 + 80
            width: 462; height: 85
            visible: idShowTextAndButtonWhenListIsEmpty.visible == true && showSearchButtonWhenListEmpty == true;
            mEnabled: searchButtonEnable

            bgImage:            imageInfo.imgFolderAha_radio + "btn_ok_n.png"
            bgImagePress:       imageInfo.imgFolderAha_radio + "btn_ok_p.png"
            bgImageFocus:       imageInfo.imgFolderAha_radio + "btn_ok_f.png"

            firstText: stringInfo.sSTR_XMDATA_SEARCH
//            firstTextWidth: 422
            firstTextX: 20
//            firstTextY: 42
            firstTextSize:32
            firstTextColor: searchButtonEnable == true ? colorInfo.brightGrey : colorInfo.grey
            firstTextStyle: systemInfo.font_NewHDB
//            firstTextAlies: "Center"

            onClickOrKeySelected: {
                console.log("search Team button clicked")
                //Search Team
                searchButton();
            }

            Keys.onPressed:
            {
                if(event.key == Qt.Key_Up && event.modifiers == Qt.NoModifier)
                {
                    idMenuBar.focusInitLeft();
                }
            }
        }
//        XMRectangleForDebug{}
    }

    MComp.MScroll {
        x:idListView.x + idListView.width - idListView.nScroll;
        y: 33// z:1
        scrollArea: idListView;
        height: idListView.height-y-y//474;
        width: 14
        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"
        visible: idListView.contentHeight > idListView.height && idListView.count > 0
    }
    //For Debuggging
    Text {
        x:5; y:-12; id:idFileName
        text:"XMDataNormalList.qml";
        color : "white";
        visible:isDebugMode();
    }
}
