/**
 * /BT_arabic/Contacts/Search/BtContactSearchMain.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MComp.MComponent
{
    id: idBtContactSearch
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property int listCount: 0
    property bool searchResult: false
    property bool backButtonPressed: false
    property bool keypadUpPressed: false


    /* INTERNAL functions */
    function calculateMarkerPosition(mouseX) {
        // 마우스 X좌표를 전달 받아 선택된 문자의 커서 값을 전달(단, 커서의 위치는 변경되지 않음)
        var rect = idTextInputSearch.positionToRectangle(idTextInputSearch.cursorPosition);
        return rect.x;
    }

    Connections {
        target: idAppMain

        onKeypadChange: {
            if(0 == idTextInputSearch.text.length) {
                idQwertyKeypad.disableDeleteButton();
                idQwertyKeypad.disableSpaceButton();
            } else {
                idQwertyKeypad.enableDeleteButton();
                idQwertyKeypad.enableSpaceButton();
            }

            if(false == idButtonSearch.mEnabled) {
                idQwertyKeypad.disableSearchButton("done")
            } else {
                idQwertyKeypad.enableSearchButton("done")
            }
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idQwertyKeypad.outputText = idTextInputSearch.text

        idQwertyKeypad.showQwertyKeypad();
        idTextInputSearch.cursorDelegate = idDelegateCursor
        idQwertyKeypad.forceActiveFocus();

        BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)

        if(0 == idTextInputSearch.text.length) {
            idQwertyKeypad.disableDeleteButton();
            idQwertyKeypad.disableSpaceButton();
        } else {
            idQwertyKeypad.enableDeleteButton();
            idQwertyKeypad.enableSpaceButton();
        }
    }

    Component.onDestruction: {
        idDownScrollTimer.stop();
        idUpScrollTimer.stop();
    }

    onVisibleChanged: {
        if(true == idBtContactSearch.visible) {
            if(true == idQwertyKeypad.isHide()) {
                idQwertyKeypad.showQwertyKeypad();
                idTextInputSearch.cursorDelegate = idDelegateCursor
                idQwertyKeypad.forceActiveFocus();
            }

            if(0 == idTextInputSearch.text.length) {
                idQwertyKeypad.disableDeleteButton();
                idQwertyKeypad.disableSpaceButton();
            } else {
                idQwertyKeypad.enableDeleteButton();
                idQwertyKeypad.enableSpaceButton();
            }
        }
    }

    onBackKeyPressed: {
        // [주의] Backkey pressed와 Back button pressed를 동시에 처리해야 함
        //setMainAppScreen("BtContactMain", false);
        popScreen(203);

        if("FROM_SEARCH" == favoriteAdd){
            favoriteAdd = "FROM_CONTACT";
        }
    }


    /* WIDGETS */
    MouseArea {
        anchors.fill: parent
        beepEnabled: false
    }

    Rectangle {
        color: "Black"
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        x: 0
        y: 0
        visible: (false == idBtContactSearchListView.visible) ? true : false

        // 검색결과가 있으면 Listview, 없으면 아래 문구("검색결과가 없습니다.") 표시
        Text {
            text: stringInfo.str_Bt_No_List
            x: 150
            y: 294
            width: 980
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDB"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }
    }

    /* Widgets */
    Image {
        source: ImagePath.imgFolderGeneral + "bg_title.png"
        x: 0;
        y: 0;
    }

    Image {
        id: idImageSearchBar
        source: ImagePath.imgFolderKeypad + "bg_search_m.png"
        x: 282
        z: 100
        width: 992
        height: 69

        MouseArea {
            anchors.fill: parent

            onClicked: {
                // 입력창 선택 시 키패드 보여짐
                idQwertyKeypad.showQwertyKeypad();

                if(0 == idTextInputSearch.text.length) {
                    return;
                }

                // 터치된 위치로 커서를 옮기고 Marker를 표시함
                idTextInputSearch.cursorPosition = idTextInputSearch.positionAt(mouseX, TextInput.CursorOnCharacter);
                idTextInputSearchHide.show();
                idTextInputSearch.cursorDelegate = idDelegateFocusCursor
                idTextInputSearch.forceActiveFocus();
                idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition
            }

            //DEPRECATED KeyNavigation.left: {}
            KeyNavigation.down: idQwertyKeypad
        }

        // Search text input
        TextInput {
            id: idTextInputSearch
            text: contactSearchInput
            y: 9
            anchors.right: parent.right
            anchors.rightMargin: 50
            width: 847 - 44 - idTextResult.paintedWidth    //897 - 24 - 26 - idTextSearchResult.paintedWidth

            color: colorInfo.buttonGrey;
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            cursorVisible: true
            cursorPosition: idTextInputSearch.text.length
            cursorDelegate: idDelegateCursor
            horizontalAlignment: Text.AlignRight
            //visible: idTextInputSearch.text.length != 0

            property string keyCompensation: "";


            Text {
                id: idSearchText
                x: 5
                width: 847 - idTextResult.paintedWidth
                text: stringInfo.str_Search_Phonebook_Text
                color: colorInfo.dimmedGrey
                font.pointSize: 32
                font.family: stringInfo.fontFamilyBold    //"HDR"
                horizontalAlignment: Text.AlignRight
                anchors.verticalCenter: parent.verticalCenter
                visible: idTextInputSearch.text.length == 0
            }

//            Image {
//                id: idDelegateCursorImage
//                source: UIListener.m_sImageRoot + "keypad/cursor_n.png";


//                SequentialAnimation {
//                    running: idDelegateCursorImage.visible
//                    loops: Animation.Infinite;

//                    NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 1; duration: 100 }
//                    PauseAnimation  { duration: 500 }
//                    NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 0; duration: 100 }
//                }
//            }


            onTextChanged: {
                if(true == backButtonPressed) {
                    /* Back Key가 눌린경우 1글자가 지워지므로 복원함(복원하지 않을 경우 1글자가 지워지며 Home으로 빠짐)
                     */
                    idTextInputSearch.text = idQwertyKeypad.outputText;
                    backButtonPressed = false;
                }

                idTextInputSearch.cursorPosition = 0
                idTextInputSearch.cursorPosition = idTextInputSearch.text.length

                if(idQwertyKeypad.pinyin != "HANDWRITING") {
                    if(0 == idTextInputSearch.text.length) {
                        idQwertyKeypad.disableDeleteButton();
                    } else {
                        idQwertyKeypad.enableDeleteButton();
                    }
                }

                BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
            }

            onCursorPositionChanged: {
                if("LEFT" == keyCompensation) {
                    cursorPosition++;
                    keyCompensation = "";
                } else if("RIGHT" == keyCompensation) {
                    cursorPosition--;
                    keyCompensation = "";
                } else {
                    // do nothing
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    // 입력창 선택 시 키패드 보여짐
                    idQwertyKeypad.showQwertyKeypad();

                    if(0 == idTextInputSearch.text.length) {
                        idQwertyKeypad.forceActiveFocus();
                        return;
                    }

                    idTextInputSearch.cursorDelegate = idDelegateFocusCursor
                    idTextInputSearch.forceActiveFocus();
                    // 터치된 위치로 커서를 옮기고 Marker를 표시함
                    idTextInputSearch.cursorPosition = idTextInputSearch.positionAt(mouseX, TextInput.CursorOnCharacter);
                    idTextInputSearchHide.cursorPosition = idTextInputSearch.cursorPosition
                    idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition
                    idTextInputSearchHide.show();
                }

                //DEPRECATED KeyNavigation.left: {}
                KeyNavigation.down: idQwertyKeypad
            }

            Keys.onPressed: {
                // MComponent를 이용하지 않고 직접 키 처리
                switch(event.key) {
                    case Qt.Key_Return:
                    case Qt.Key_Enter: {
                        idTextInputSearchHide.hide();
                        idQwertyKeypad.forceActiveFocus();
                        idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition;
                        idTextInputSearchHide.cursorPosition = idTextInputSearch.cursorPosition;
                        idTextInputSearch.cursorDelegate = idDelegateCursor
                        break;
                    }

                    case Qt.Key_Semicolon: {
                        if(0 < cursorPosition) {
                            cursorPosition--;
                        } else {
                            //cursorPosition = idTextInputSearch.text.length;
                        }

                        idTextInputSearchHide.hide();
                        idTextInputSearch.cursorDelegate = idDelegateFocusCursor
                        idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition;
                        idTextInputSearchHide.cursorPosition = idTextInputSearch.cursorPosition;
                        idQwertyKeypad.clearAutomata();
                        break;
                    }

                    case Qt.Key_Apostrophe: {
                        if(idTextInputSearch.text.length > cursorPosition) {
                            cursorPosition++;
                        } else {
                            //cursorPosition = 0;
                        }

                        idTextInputSearchHide.hide();
                        idTextInputSearch.cursorDelegate = idDelegateFocusCursor
                        idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition;
                        idTextInputSearchHide.cursorPosition = idTextInputSearch.cursorPosition;
                        idQwertyKeypad.clearAutomata();
                        break;
                    }

                    case Qt.Key_Backspace:
                    case Qt.Key_J:
                    case Qt.Key_Comma: {
                        console.log("## Keys.onPressed(BACK)");
                        /* Back Key가 눌린경우 1글자가 지워지므로 복원함(복원하지 않을 경우 1글자가 지워지며 Home으로 빠짐)
                         */
                        backButtonPressed = true;
                        popScreen(6578);
                        break;
                    }

                    case Qt.Key_Down: {
                       if(idBtContactSearchListView.visible
                                && idBtContactSearchListView.count > 0) {
                            idQwertyKeypad.hideQwertyKeypad();
                            idBtContactSearchListView.forceActiveFocus();
                            idBtContactSearchListView.longPressed = true
                        } else {
                            idQwertyKeypad.forceActiveFocus();
                        }

                       idTextInputSearch.cursorDelegate = idDelegateCursor
                       idTextInputSearchHide.hide();
                       idTextInputSearch.cursorPosition = 0
                       idTextInputSearch.cursorPosition = idTextInputSearchHide.cursorPosition;

                        event.accepted = true;
                        break;
                    }

                    case Qt.Key_Right: {
                        console.log("##  Keys.onPressed(RIGHT)");
                        /* TextInput에서 Left key에 의해 cursor가 좌측으로 이동되므로 강제로 +1 해서 제자리에 위치한것처럼 처리함
                         */
                        console.log("cursorPosition = " + cursorPosition);
                        console.log("idTextInputSearch.text.length = " + idTextInputSearch.text.length);
                        if(idTextInputSearch.text.length > cursorPosition) {
                            cursorPosition--;
                        } else {
                            //cursorPosition = idTextInputSearch.text.length + 1;
                            keyCompensation = "Right";
                        }
                        break;
                    }

                    case Qt.Key_Left: {
                        console.log("##  Keys.onPressed(LEFT)");
                        /* TextInput에서 Right key에 의해 Cursor가 우측으로 이동되므로 강제로 +1 해서 제자리에 위치한것처럼 처리함
                         */
                        if(0 < cursorPosition) {
                            cursorPosition ++;
                        } else {
                            /* 우측으로 +1 만큼 이동하는 현상이 발생
                             */
                            //cursorPosition = 0;
                            keyCompensation = "Left";
                        }

                        if(true == idButtonSearch.mEnabled) {
                            idButtonSearch.forceActiveFocus();
                        } else {
                            idButtonBack.forceActiveFocus();
                        }

                        idTextInputSearchHide.hide();
                        idTextInputSearch.cursorDelegate = idDelegateCursor
                        idTextInputSearch.cursorPosition = 0
                        idTextInputSearch.cursorPosition = idTextInputSearchHide.cursorPosition;

                        break;
                    }

                    default:
                        break;
                }
            }
        }

        // Search text input
        TextInput {
            id: idTextInputSearchHide
            text: idTextInputSearch.text
            y: 70
            z: 100
            anchors.right: parent.right
            anchors.rightMargin: 50

            width: idTextInputSearch.width     //897 - 24 - 26 - idTextSearchResult.paintedWidth

            color: colorInfo.transparent;
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            cursorVisible: true
            cursorPosition: idTextInputSearch.text.length
            cursorDelegate: idMarker
            horizontalAlignment: Text.AlignRight
            //visible: idTextInputSearch.text.length != 0

            property string keyCompensation: "";

            state: "HIDE"

            MouseArea {
                anchors.fill: parent

                onPositionChanged: {
                    // 터치된 위치로 커서를 옮기고 Marker를 표시함
                    idTextInputSearch.forceActiveFocus();
                    idTextInputSearchHide.cursorPosition = idTextInputSearch.positionAt(mouseX, TextInput.CursorOnCharacter);
                    idTextInputSearch.cursorPosition = idTextInputSearchHide.cursorPosition
                    idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition
                }
            }

            function show() {
                idTextInputSearchHide.state = "SHOW";
                idMarkerTimer.restart();
            }

            function hide() {
                idTextInputSearchHide.state = "HIDE";
                idMarkerTimer.stop();
            }

            Timer {
                id: idMarkerTimer
                interval: 5000
                running: false
                repeat: false

                onTriggered: {
                    idTextInputSearchHide.hide();
                }
            }

            states: [
                 State {
                    name: "SHOW";
                    PropertyChanges { target: idTextInputSearchHide;   opacity: 1; }
                }
                , State {
                    name: "HIDE";
                    PropertyChanges { target: idTextInputSearchHide;   opacity: 0; }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation { target: idTextInputSearchHide;   properties: "opacity";  duration: 500 }
                }
            ]
        }

        // Cursor delegate
        Component {
            id: idDelegateCursor

            Item {
                y: 3
                width: 4
                height: 47

                Image {
                    id: idDelegateCursorImage
                    source: UIListener.m_sImageRoot + "keypad/cursor_n.png";

                    SequentialAnimation {
                        running: idDelegateCursorImage.visible
                        loops: Animation.Infinite;

                        NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 1; duration: 100 }
                        PauseAnimation  { duration: 500 }
                        NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 0; duration: 100 }
                    }
                }
            }
        }

        Component {
            id: idDelegateFocusCursor

            Item {
                y: 3
                width: 4
                height: 47

                Image {
                    id: idDelegateCursorFocusImage
                    source: UIListener.m_sImageRoot + "keypad/cursor_f.png";

                    SequentialAnimation {
                        running: idDelegateCursorFocusImage.visible
                        loops: Animation.Infinite;

                        NumberAnimation { target: idDelegateCursorFocusImage; property: "opacity"; to: 1; duration: 100 }
                        PauseAnimation  { duration: 500 }
                        NumberAnimation { target: idDelegateCursorFocusImage; property: "opacity"; to: 0; duration: 100 }
                    }
                }
            }
        }

        Component {
            id: idMarker

            Rectangle {
                Image {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: -18
                    source: ImagePath.imgFolderKeypad + "ico_marker.png"
                }
            }
        }

        // "Search Result: 0"
        Text {
            id: idTextResult
            text: idBtContactSearchListView.count
            y: 0
            height: 30
            font.family: stringInfo.fontFamilyBold    //"HDB"
            font.pointSize: 30
            color: colorInfo.disableGrey

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            visible: (0 < idTextInputSearch.text.length) ? true : false

            anchors.left: parent.left
            anchors.leftMargin: 27
            anchors.verticalCenter: parent.verticalCenter

            onVisibleChanged: {
                if(true == idTextResult.visible) {
                    idTextInputSearch.width = 847 - idTextResult.paintedWidth;
                }
            }

            onTextChanged: {
                idTextInputSearch.width = 847 - idTextResult.paintedWidth;
            }
        }

        // 검색결과가 있을때 표시되는 사람 아이콘
        Image {
            source: ImagePath.imgFolderKeypad + "ico_search_result.png"
            y: 14
            anchors.left: idTextResult.right
            anchors.verticalCenter: idTextResult.verticalCenter
            visible: idTextResult.visible
        }
    }

    // Search key button
    MComp.MButton {
        id: idButtonSearch
        x: 141
        y: 0
        width: 141
        height: 72

        bgImage: ImagePath.imgFolderGeneral + "btn_title_sub_n.png"
        bgImagePress: ImagePath.imgFolderGeneral + "btn_title_sub_p.png"
        bgImageFocus: ImagePath.imgFolderGeneral + "btn_title_sub_f.png"

        fgImage: true == idButtonSearch.mEnabled ? ImagePath.imgFolderKeypad + "icon_title_search_n.png" : ImagePath.imgFolderKeypad + "icon_title_search_d.png"

        fgImageX: 41
        fgImageY: 6
        fgImageWidth: 60
        fgImageHeight: 60
        mEnabled: 0 != idTextInputSearch.text.length//(false == idBtContactSearchListView.visible) ? false : true

        property bool longPressed: false

        // 검색 버튼 비활성화 시 키패드 내부 검색 버튼 비활성화 하는 코드 추가
        onMEnabledChanged: {
            if(false == idButtonSearch.mEnabled) {
                idQwertyKeypad.disableSearchButton("done")
                idQwertyKeypad.disableSpaceButton();
            } else {
                idQwertyKeypad.enableSearchButton("done")
                idQwertyKeypad.enableSpaceButton();
            }
        }

        onClickOrKeySelected: {
            // UX 변경
            idQwertyKeypad.hideQwertyKeypad();
            idButtonSearch.forceActiveFocus();
            idTextInputSearchHide.hide();
            idTextInputSearch.cursorDelegate = idDelegateCursor

            if(false == idButtonSearch.mEnabled) {
                idButtonBack.forceActiveFocus();
            } else {
                idButtonSearch.forceActiveFocus();
            }
        }

        Keys.onPressed: {
            /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
             * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
             */
            if(Qt.Key_Down == event.key) {
                if(Qt.ShiftModifier == event.modifiers) {
                    // Long-pressed
                    idButtonSearch.longPressed = true;
                    event.accepted = true;
                } else {
                    // Short pressed
                    event.accepted = true;
                }
            } else if(Qt.Key_Right == event.key) {
                if(0 != idTextInputSearch.text.length) {
                    idTextInputSearch.forceActiveFocus();
                    idTextInputSearch.cursorDelegate = idDelegateFocusCursor
                    idTextInputSearchHide.show();
                    idTextInputSearch.cursorPosition = 0
                    idTextInputSearch.cursorPosition = idTextInputSearchHide.cursorPosition;
                } else {

                }
            }

            // 키패드 내부 조그 동작 수정 - ISV 조그 동작 동기화 문제점
            if(Qt.Key_Down == event.key) {
                if(idBtContactSearchListView.visible
                        && idQwertyKeypad.isHide()
                        && idBtContactSearchListView.count > 0) {
                    idBtContactSearchListView.forceActiveFocus();
                    idBtContactSearchListView.longPressed = true
                } else {
                    idQwertyKeypad.showQwertyKeypad();
                    idQwertyKeypad.forceActiveFocus();
                }
                event.accepted = true;
            }
        }

        onWheelLeftKeyPressed: {
            idButtonBack.forceActiveFocus();
        }
    }

    // Back key button
    MComp.MButton {
        id: idButtonBack
        x: 0
        y: 0
        width: 141
        height: 72

        bgImage: ImagePath.imgFolderGeneral + "btn_title_back_n.png"
        bgImagePress: ImagePath.imgFolderGeneral + "btn_title_back_p.png"
        bgImageFocus: ImagePath.imgFolderGeneral + "btn_title_back_f.png"

        property bool longPressed: false

        /* [주의] Backkey pressed와 Back button pressed를 동시에 처리해야 함
         */
        onClickOrKeySelected: {
            idTextInputSearchHide.hide();
            idTextInputSearch.cursorDelegate = idDelegateCursor
            qml_debug("idBackKey Back Press");
            //setMainAppScreen("BtContactMain",false);
            popScreen(204);

            if("FROM_SEARCH" == favoriteAdd) {
                favoriteAdd = "FROM_CONTACT"
            }
        }

        Keys.onPressed: {
            /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
             * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
             */
            if(Qt.Key_Down == event.key) {
                if(Qt.ShiftModifier == event.modifiers) {
                    // Long-pressed
                    idButtonBack.longPressed = true;
                    event.accepted = true;
                } else {
                    // Short pressed
                    event.accepted = true;
                }
            } else if(Qt.Key_Right == event.key) {
                if(0 != idTextInputSearch.text.length) {
                    idTextInputSearch.forceActiveFocus();
                    idTextInputSearch.cursorDelegate = idDelegateFocusCursor
                    idTextInputSearchHide.show();
                    idTextInputSearch.cursorPosition = 0
                    idTextInputSearch.cursorPosition = idTextInputSearchHide.cursorPosition;
                } else {

                }
            }

            // 키패드 내부 조그 동작 수정 - ISV 조그 동작 동기화 문제점
            if(Qt.Key_Down == event.key) {
                if(idBtContactSearchListView.visible
                        && idQwertyKeypad.isHide()
                        && idBtContactSearchListView.count > 0) {
                    idBtContactSearchListView.forceActiveFocus();
                    idBtContactSearchListView.longPressed = true
                } else {
                    idQwertyKeypad.showQwertyKeypad();
                    idQwertyKeypad.forceActiveFocus();
                }
                event.accepted = true;
            }
        }

        /*Keys.onReleased: {
            if(Qt.Key_Down == event.key) {
                if(true == idButtonBack.longPressed) {
                    idButtonBack.longPressed = false;
                    event.accepted = true;
                } else {
                    // Set focus to "ListView"
                    if(idBtContactSearchListView.visible
                            && idQwertyKeypad.isHide()
                            && idBtContactSearchListView.count > 0) {
                        idBtContactSearchListView.forceActiveFocus();
                    } else {
                        idQwertyKeypad.forceActiveFocus();
                    }
                    event.accepted = true;
                }
            }
        }*/

        onWheelRightKeyPressed: {
            if(false == idButtonSearch.mEnabled) {
                idButtonBack.forceActiveFocus();
            } else {
                idButtonSearch.forceActiveFocus();
            }
        }
    }

    // Search result listview
    ListView {
        id: idBtContactSearchListView
        y: 73
        width: systemInfo.lcdWidth
        height: 540
        visible: idBtContactSearchListView.count != 0 && idTextInputSearch.text != ""
        snapMode: idBtContactSearchListView.moving ? ListView.SnapToItem : ListView.NoSnap // modified by Dmitry 27.07.13
        highlightMoveDuration: 1
        highlightFollowsCurrentItem: true
        model: contactExactSearchProxy 
        // 검색화면은 리스트의 수가 동적으로 변경되므로 cacheBuffer를 적용하면 오히려 속도가 저하되어 제거함
        //DEPRECATED cacheBuffer: 1000
        clip: true
        focus: true

        property bool longPressed: false

        // 바운스 효과 추가
        // boundsBehavior: Flickable.StopAtBounds

        function getStartIndex(posY) {
            var startIndex = -1;
            for(var i = 1; i < 10; i++) {
                startIndex = indexAt(100, posY + 50 * i);
                if(-1 < startIndex) {
                    break;
                }
            }

            return startIndex;
        }

        function getEndIndex(posY) {
             var endIndex = -1;
             for(var i = 0; i < 5; i++) {
                 endIndex = indexAt(100, posY + (height - 10) - 50 * i);

                 if(-1 < endIndex) {
                     return endIndex
                 }
             }

             return -1;
        }

        onMovementStarted: {
            if(idQwertyKeypad.isHide() == false) {
                idQwertyKeypad.hideQwertyKeypad();
            }
        }

        onMovementEnded: {
            if(false == idBtContactSearchListView.visible) {
                return;
            }

            if("" == popupState && menuOn == false) {
                idBtContactSearchListView.forceActiveFocus();
            }

            idTextInputSearchHide.hide();
            idTextInputSearch.cursorDelegate = idDelegateCursor

            var flickingIndex = getStartIndex(contentY);
            if(-1 != flickingIndex) {
                positionViewAtIndex(flickingIndex, ListView.Beginning);
                currentIndex = flickingIndex;
            }
        }

        onCountChanged: {
            idBtContactSearchListView.currentIndex = 0;
            listCount = idBtContactSearchListView.count;
            idBtContactSearchListView.positionViewAtIndex( 0, ListView.Beginning);
        }

        delegate: BtContactSearchDelegate {
            onWheelRightKeyPressed:  {
                if(false == idBtContactSearchListView.flicking && false == idBtContactSearchListView.moving) {
                    var startIndex = idBtContactSearchListView.getStartIndex(idBtContactSearchListView.contentY);

                    if(index > 0) {
                        if(startIndex == idBtContactSearchListView.currentIndex) {
                            idBtContactSearchListView.positionViewAtIndex(idBtContactSearchListView.currentIndex - 1, ListView.End);
                        }

                        idBtContactSearchListView.decrementCurrentIndex();
                    } else {
                        // 리스트가 하나의 화면에 표시 되면 루핑 되지 않도록 수정(HMC)
                        if(6 < idBtContactSearchListView.count) {
                            idBtContactSearchListView.currentIndex = idBtContactSearchListView.count - 1;
                        } else {
                            //DEPRECATED console.log("### Stop looping idBtContactSearchListView.count = " + idBtContactSearchListView.count)
                        }
                    }
                }
            }
            
            onWheelLeftKeyPressed: {
                if(false == idBtContactSearchListView.flicking && false == idBtContactSearchListView.moving) {
                    var endIndex = idBtContactSearchListView.getEndIndex(idBtContactSearchListView.contentY);

                    if(index < idBtContactSearchListView.count - 1) {
                        if(endIndex == idBtContactSearchListView.currentIndex) {
                            idBtContactSearchListView.positionViewAtIndex(idBtContactSearchListView.currentIndex + 1, ListView.Beginning);
                        }

                        idBtContactSearchListView.incrementCurrentIndex();
                    } else {
                        // 리스트가 하나의 화면에 표시 되면 루핑 되지 않도록 수정(HMC)
                        if(6 < idBtContactSearchListView.count) {
                            idBtContactSearchListView.currentIndex = 0;
                        } else {
                            //DEPRECATED console.log("### Stop looping idBtContactSearchListView.count = " + idBtContactSearchListView.count)
                        }
                    }
                }
            }

            Keys.onPressed: {
                /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
                 * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
                 */
                /*if(Qt.Key_Down == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        idBtContactSearchListView.longPressed = true;

                        if(idBtContactSearchListView.currentIndex < idBtContactSearchListView.count - 1) {
                            // Propagate to ListView
                            idBtContactSearchListView.longPressed = true;
                        } else {
                            // 더이상 밑으로 내려갈 수 없을때
                            event.accepted = true;
                        }
                    } else {
                        // Short pressed
                        event.accepted = true;
                    }
                } else */if(Qt.Key_Up == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        idBtContactSearchListView.longPressed = true;

                        if(0 < idBtContactSearchListView.currentIndex) {
                            // Propagate to ListView
                        } else {
                            // 더이상 위로 올라갈 수 없을때
                            event.accepted = true;
                        }
                    } else {
                        // Short pressed
                        event.accepted = true;
                    }
                }
            }

            Keys.onReleased: {
                idBtContactSearchListView.stopScroll();
                // 키패드 내부 조그 동작 수정 - ISV 조그 동작 동기화 문제점 (Long Key 동작 무시)
                if(true == idBtContactSearchListView.longPressed){
                    idBtContactSearchListView.longPressed = false
                    return;
                }

                if(true == keypadUpPressed) {
                    keypadUpPressed = false;
                    event.accepted = true;
                    return;
                }

                /*if(Qt.Key_Down == event.key) {
                    if(true == idBtContactSearchListView.longPressed) {
                        if(idBtContactSearchListView.currentIndex < idBtContactSearchListView.count - 1) {
                            // Propagate to ListView
                        } else {
                            // 더이상 밑으로 내려갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            idBtContactSearchListView.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        // Set focus to "ListView"
                        idQwertyKeypad.forceActiveFocus();
                        event.accepted = true;
                    }
                } else*/ if(Qt.Key_Up == event.key) {
                    if(true == idBtContactSearchListView.longPressed) {
                        if(0 < idBtContactSearchListView.currentIndex) {
                            // Propagate to ListView
                        } else {
                            // 더이상 위로 올라갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            idBtContactSearchListView.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        // Set focus to "Search Button"
                        idQwertyKeypad.showQwertyKeypad();
                        idTextInputSearch.forceActiveFocus();
                        idTextInputSearch.cursorDelegate = idDelegateFocusCursor
                        idTextInputSearchHide.show();
                        idTextInputSearch.cursorPosition = 0
                        idTextInputSearch.cursorPosition = idTextInputSearchHide.cursorPosition;
                        // idButtonSearch.forceActiveFocus();
                        event.accepted = true;
                    }
                }
            }
        }

        function startDownScroll() {
            idDownScrollTimer.start();
        }

        function startUpScroll() {
            idUpScrollTimer.start();
        }

        function stopScroll() {
            if(true == idDownScrollTimer.running) {
                idDownScrollTimer.stop();
            } else if(true == idUpScrollTimer.running) {
                idUpScrollTimer.stop();
            }
        }

        function runningScroll() {
            if(true == idDownScrollTimer.running || true == idUpScrollTimer.running) {
                return true;
            } else {
                return false;
            }
        }

        Keys.onPressed: {
            if(Qt.Key_Down == event.key) {
                if(Qt.ShiftModifier == event.modifiers) {
                    // Long-pressed
                    idBtContactSearchListView.longPressed = true
                    idBtContactSearchListView.startDownScroll();
                    idBtContactSearchListView.positionViewAtIndex(idBtContactSearchListView.currentIndex, ListView.End);
                } else {
                    event.accepted = true;
                }
            } else if(Qt.Key_Up == event.key) {
                if(Qt.ShiftModifier == event.modifiers) {
                    // Long-pressed
                    idBtContactSearchListView.longPressed = true
                    idBtContactSearchListView.startUpScroll();
                    idBtContactSearchListView.positionViewAtIndex(idBtContactSearchListView.currentIndex, ListView.Beginning);
                } else {
                    event.accepted = true;
                }
            }
        }

        Keys.onReleased: {
            if(Qt.Key_Down == event.key) {
                if(true == idBtContactSearchListView.longPressed) {
                    idBtContactSearchListView.longPressed = false;
                    idBtContactSearchListView.stopScroll();
                }
            } else if(Qt.Key_Up == event.key) {
                if(true == idBtContactSearchListView.longPressed) {
                    idBtContactSearchListView.longPressed = false;
                    idBtContactSearchListView.stopScroll();
                }
            }
        }
    }

    // Scroll
    MComp.MScroll {
        id: idContactSearchListScroll
        x: 1257
        y: 199 - systemInfo.headlineHeight + systemInfo.titleAreaHeight
        height: 476
        width: 14

        // 6개 이상인 경우 스크롤바 표시
        visible: (idBtContactSearchListView.count > 6 && idTextInputSearch.text.length > 0)
        scrollArea: idBtContactSearchListView
    }

    // Keypad
    MComp.QwertyKeypad {
        id: idQwertyKeypad
        //y: 243
        y: -93
        focus: true

        doneType: "Search"
        currentCursor: idTextInputSearch.cursorPosition

        function cutOff(deviceName) {
            return deviceName.substring(0, 160);
        }

        function checkLength(deviceName) {
            return deviceName.length;
        }

        function update(empty) {
            if(true == empty) {
                idTextInputSearch.color = colorInfo.disableGrey;
                idTextInputSearch.maximumLength = 30;

                // Set default text.
                idTextInputSearch.text = ""

                // Set cursor position.
                idTextInputSearch.cursorPosition = 0;
            } else {
                idTextInputSearch.color = colorInfo.buttonGrey;
                idTextInputSearch.maximumLength = 160

                // Set input text.
                idTextInputSearch.text = idQwertyKeypad.outputText;
                // Set cursor position.
                if(idQwertyKeypad.currentCursor > idTextInputSearch.text.length) {
                    idQwertyKeypad.currentCursor = idTextInputSearch.text.length;
                }

                idTextInputSearch.cursorPosition = idQwertyKeypad.currentCursor;
                idTextInputSearch.cursorDelegate = idDelegateCursor
                idTextInputSearchHide.cursorPosition = idQwertyKeypad.currentCursor;
                idTextInputSearchHide.hide();
            }
        }

        function truncate() {
            // 제일 뒤 문자 1개 삭제
            if(1 > idQwertyKeypad.outputText.length - 1) {
                // 삭제 뒤 Length가 0가 된 경우
                idQwertyKeypad.outputText = "";
                update(true);
            } else {
                if(idQwertyKeypad.currentCursor < idQwertyKeypad.outputText.length) {
                    // 중간에 삽입된 경우
                    idQwertyKeypad.outputText = idQwertyKeypad.outputText.substring(0, idQwertyKeypad.currentCursor - 1)
                            + idQwertyKeypad.outputText.substring(idQwertyKeypad.currentCursor);
                    idQwertyKeypad.currentCursor = idQwertyKeypad.currentCursor - 1;
                } else {
                    // 제일 뒤에 추가된 경우
                    idQwertyKeypad.outputText = idQwertyKeypad.outputText.substr(0, idQwertyKeypad.outputText.length - 1);
                }

                update(false);
            }
        }

        onOutputTextChanged: {
            if(false == idQwertyKeypad.focus) {
                idQwertyKeypad.forceActiveFocus();
            }

            idTextInputSearchHide.hide();
            idTextInputSearch.cursorDelegate = idDelegateCursor

            // 키패드 입력 되는 시점에 키패드로 먼저 포커스 이동 시킴
            idQwertyKeypad.forceActiveFocus();

            if(1 > idQwertyKeypad.outputText.length) {
                update(true);
            } else if(160 < idQwertyKeypad.outputText.length) {
                /* Limited characters */
                //update(false);
                truncate();
            } else {
                update(false);
            }

            if(1 > idTextInputSearch.text.length) {
                searchResult = false;
            }
        }

        onActiveFocusChanged: {
            if(true == idQwertyKeypad.activeFocus && true == idQwertyKeypad.isHide()) {
                idQwertyKeypad.showQwertyKeypad();
            }
        }

        onSigLostFocus: {
            /* 키패드 내부 키패드 숨김 버튼 선택 시 Release 2번 발생되는 문제점 수정
             */
            if(0 != idTextInputSearch.text.length) {
                idTextInputSearchHide.hide();
                idTextInputSearch.cursorDelegate = idDelegateCursor
                gIgnoreReleased = 2;
                idTextInputSearch.forceActiveFocus();
                idTextInputSearch.cursorDelegate = idDelegateFocusCursor
                idTextInputSearchHide.show();
                idTextInputSearch.cursorPosition = 0
                idTextInputSearch.cursorPosition = idTextInputSearchHide.cursorPosition;
            } else {
                if(false == idButtonSearch.mEnabled) {
                    idButtonBack.forceActiveFocus();
                } else {
                    idButtonSearch.forceActiveFocus();
                }
            }
        }

        onKeyOKClicked: {
            idQwertyKeypad.hideQwertyKeypad();

            if(1 > idBtContactSearchListView.count) {
                if(idButtonSearch.mEnabled == true) {
                } else {
                    idButtonBack.forceActiveFocus();
                }
            } else {
                idTextInputSearchHide.hide();
                idTextInputSearch.cursorDelegate = idDelegateCursor
                idBtContactSearchListView.currentIndex = 0;
                idBtContactSearchListView.forceActiveFocus();
            }
        }
    }

    /* TIMERS */
    Timer {
        id: idDownScrollTimer
        interval: 100
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var endIndex = idBtContactSearchListView.getEndIndex(idBtContactSearchListView.contentY);

            if(idBtContactSearchListView.currentIndex + 1 < idBtContactSearchListView.count) {
                if(endIndex == idBtContactSearchListView.currentIndex) {
                    idBtContactSearchListView.positionViewAtIndex(idBtContactSearchListView.currentIndex + 1, ListView.Beginning);
                }

                idBtContactSearchListView.currentIndex += 1;
            } else {
                idBtContactSearchListView.currentIndex = idBtContactSearchListView.count - 1;
                stop();
            }
        }
    }

    Timer {
        id: idUpScrollTimer
        interval: 100
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var startIndex = idBtContactSearchListView.getStartIndex(idBtContactSearchListView.contentY);

            if(0 < idBtContactSearchListView.currentIndex - 1) {
                if(startIndex == idBtContactSearchListView.currentIndex) {
                    idBtContactSearchListView.positionViewAtIndex(idBtContactSearchListView.currentIndex - 1, ListView.End);
                }
                idBtContactSearchListView.currentIndex -= 1;
            } else {
                idBtContactSearchListView.currentIndex = 0;
                stop();
            }
        }
    }
}
/* EOF */
