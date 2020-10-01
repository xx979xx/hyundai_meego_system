import Qt 4.7

// System Import
import "../../QML/DH" as MComp

FocusScope {
    height: parent.height

    property alias listModel: idListView.model
    property alias listDelegate: idListView.delegate
    property alias count: idListView.count;
    property alias selectedIndex: idListView.selectedIndex;

    property int listCount: idListView.count;
    property int rowPerPage: 5

    signal itemClicked(string itemTitle)

    Component {
        id: sectionHeading
        BorderImage {
            id: idSection
            x: 0; //y: + 23
            width: parent.width - 72
            source: imageInfo.imgFolderMusic + "tab_list_index.png"

            border{left: 50; right: 50; top: 0; bottom: 0}

            Text {
                id: idCurrLocTxt
                x: 6 + 26; y: 0//parent.height/18;
                width: 30
                height: parent.height
                clip: true
                text: section
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 30
                color: colorInfo.bandBlue // Qt.rgba( 124/255, 189/255, 255/255, 1) // ITS[219706]
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    MComp.MListView {
        id: idListView
        focus: true
        anchors.fill: parent

        snapMode : ListView.SnapToItem
        clip: true
        flickDeceleration: 3000
        highlightMoveSpeed :9999

        section.property: "CityName"
        section.criteria: ViewSection.FirstCharacter
        section.delegate: sectionHeading


        property bool isLoaded: false
        property int selectedIndex: 0;
        onCountChanged: {
            if(visible)
            {
                idSectionScroller.doReload();
            }
        }
        Connections{
            target : weatherDataManager
            onCheckForFocus:{
                if(idListView.visible)
                {
                    if(idListView.count == 0)
                    {
                        leftFocusAndLock(true);
                    }else
                    {
                        leftFocusAndLock(false);
                        idListView.positionViewAtIndex(0, ListView.Visible);
                        idListView.currentIndex = 0;
                        if(isLeftMenuEvent)
                            idListView.forceActiveFocus();
                    }
                }
            }
        }
    }

    SectionScroller{
        id: idSectionScroller
        y:9
        listViewForQuickScroll: idListView;
    }

    MComp.MScroll {
        x:idListView.x + idListView.width - 19; y: 33// z:1
        scrollArea: idListView;
        height: parent.height-33-44//474;
        width: 13
        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"
    }
}
