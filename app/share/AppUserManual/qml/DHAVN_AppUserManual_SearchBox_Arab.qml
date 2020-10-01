import Qt 4.7

import "DHAVN_AppUserManual_Images.js" as Images
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item
{
    property bool markerVisible: false
    property string searchManual: qsTranslate("main", "STR_MANUAL_SEARCH_MANUAL")
    signal handleSearchBoxClickEvent();
    signal clearAutomata();

    Timer{
        id: marker_timer
        interval: 5000; running: true; repeat: false
        onTriggered:{
            console.log("SearchBox_Arab.qml :: marker_timer onTriggered")
            hideMarker()
        }
    }

    Image
    {
        id: appUserManualSearchBox
        source: Images.const_AppUserManual_Search_Box
        anchors.left: parent.left
        anchors.top: parent.top
        width: 982
        height: 70

        TextInput
        {
            id: text_input
            property int cursor_pos: 0
            anchors.top: parent.top; anchors.topMargin: 10
            anchors.right: parent.right; anchors.rightMargin: 30
            width: 960
            color: Dimensions.const_AppUserManual_ListText_Color_Black
//            selectedTextColor: Dimensions.const_AppUserManual_Color_White
//            selectionColor: Dimensions.const_AppUserManual_GoTo_Text_Color
            font.pixelSize: Dimensions.const_AppUserManual_Search_Font_Size_32
            font.family: "DH_HDB"
            smooth: true
            horizontalAlignment: Text.AlignRight
            cursorPosition: 0
            cursorDelegate: (appUserManual.searchText.length == 0 ) ? cursor0_delegate
                : appUserManualSearchView.focus_index == Dimensions.const_AppUserManual_Focus_SearchBar ? cursorF_delegate : cursorN_delegate
            text: appUserManual.searchText //This is our string to be searched.
            selectByMouse: true
            onCursorPositionChanged:
            {
                console.log("SearchBox.qml :: onCursorPositionChanged")
                if( cursor_pos >= 0 )
                    cursorPosition = cursor_pos
                cursor_pos = -1
                marker_input.cursorPosition = cursorPosition
                if (marker_input.visible) {
                    marker_timer.restart()
                }
//                clearAutomata()
            }
            Image
            {
                id: cursor0F
                anchors.top: parent.top; anchors.topMargin: 5
                anchors.right: parent.right; anchors.rightMargin: 0
                visible: appUserManual.searchText.length == 0
                source: appUserManualSearchView.focus_index == Dimensions.const_AppUserManual_Focus_SearchBar
                    ? Images.const_AppUserManual_Search_Cursor_F : Images.const_AppUserManual_Search_Cursor_N
                SequentialAnimation {
                      running: cursor0F.visible
                      loops: Animation.Infinite;
                      NumberAnimation { target: cursor0F; property: "opacity"; to: 1; duration: 100 }
                      PauseAnimation  { duration: 500 }
                      NumberAnimation { target: cursor0F; property: "opacity"; to: 0; duration: 100 }
              }
            }
            Text
            {
                id: searchBoxText
                text: searchManual //qsTranslate("main", "STR_MANUAL_SEARCH_MANUAL")
                anchors.right: parent.right; anchors.rightMargin: 3
//                anchors.top: parent.top;
//                anchors.right: parent.right;
                anchors.fill: parent
                horizontalAlignment: Text.AlignRight
                width: 960
                color: Dimensions.const_AppUserManual_Search_Font_Color
                font.pixelSize: 32 ///Dimensions.const_AppUserManual_Search_Font_Size_30
                font.family: "DH_HDB"
                visible: ( text_input.text.length == 0 ) // this should be true only when the text_input's text lenght is 0
            }

            MouseArea
            {
                anchors.fill: parent
                enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
                onClicked:
                {
                    console.log("SearchBox.qml :: text_input onClicked : ", text_input.positionAt(mouseX, TextInput.CursorOnCharacter) )
                    appUserManualSearchView.focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                    text_input.cursorPosition = text_input.positionAt(mouseX, TextInput.CursorOnCharacter);
                    showMarker()
                    clearAutomata()
                }
            }
        }

        Component
        {
            id: cursor0_delegate

            Rectangle
            {
                color: "transparent"
            }
        }
        Component
        {
            id: cursorF_delegate

            Rectangle
            {
                Image
                {
                    id: ico_cursor
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    source: Images.const_AppUserManual_Search_Cursor_F
                    SequentialAnimation {
                          running: ico_cursor.visible
                          loops: Animation.Infinite;
                          NumberAnimation { target: ico_cursor; property: "opacity"; to: 1; duration: 100 }
                          PauseAnimation  { duration: 500 }
                          NumberAnimation { target: ico_cursor; property: "opacity"; to: 0; duration: 100 }
                  }
                }
            }
        }
        Component
        {
            id: cursorN_delegate

            Rectangle
            {
                Image
                {
                    id: ico_cursorN
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    source: Images.const_AppUserManual_Search_Cursor_N
                    SequentialAnimation {
                          running: ico_cursorN.visible
                          loops: Animation.Infinite;
                          NumberAnimation { target: ico_cursorN; property: "opacity"; to: 1; duration: 100 }
                          PauseAnimation  { duration: 500 }
                          NumberAnimation { target: ico_cursorN; property: "opacity"; to: 0; duration: 100 }
                  }
                }
            }
        }
    }

    TextInput
    {
        id: marker_input
        anchors.top: parent.top; anchors.topMargin:  70// 35 - height/2
        anchors.right: parent.right; anchors.rightMargin: 37
        width: 960; height: 90
        visible: false
        color: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
        selectedTextColor: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
        selectionColor: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
        font.pixelSize: Dimensions.const_AppUserManual_Search_Font_Size_32
        font.family: "DH_HDB"
        smooth: true
        cursorPosition: 0
        cursorDelegate: marker2_delegate
        text: text_input.text
        selectByMouse: true
        horizontalAlignment: Text.AlignRight
//        cursorVisible: markerVisible && text_input.text.length > 0

        onCursorPositionChanged:
        {
            console.log("SearchBox.qml :: onCursorPositionChanged")
            if ( text_input.cursorPosition != cursorPosition ) {
                text_input.cursorPosition = cursorPosition
                clearAutomata()
            }
        }
    }
    Component
    {
        id: marker2_delegate

        Rectangle
        {
            Image
            {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: -20
                source: Images.const_AppUserManual_Search_Ico_Marker// "/app/share/images/AppBtPhone/keypad/ico_marker.png"
            }
        }
    }

    function markerPositionRelease( position )
    {
        var cursorPosition = text_input.positionAt(position, TextInput.CursorOnCharacter);
        text_input.cursorPosition = cursorPosition;
    }

    function showMarker()
    {
        console.log("SearchBox.qml :: showMarker()")
        if ( text_input.text.length == 0 ) return
        marker_input.visible = true
        var tmpCursorPos = text_input.cursorPosition
        text_input.cursorPosition = 0
        text_input.cursorPosition = tmpCursorPos
        marker_timer.restart()
    }

    function hideMarker()
    {
        console.log("SearchBox.qml :: hideMarker()")
        marker_input.visible = false
        marker_timer.stop()
        var tmpCursorPos = text_input.cursorPosition
        text_input.cursorPosition = 0
        text_input.cursorPosition = tmpCursorPos
        console.log("SearchBox_Arab.qml :: hideMarker() - ", text_input.cursorPosition )
    }

    function moveFocusF()
    {
        text_input.cursorPosition++
        console.log("SearchBox_Arab.qml :: moveFocusF() - ", text_input.cursorPosition )
    }

    function moveFocusB()
    {
        text_input.cursorPosition--
        console.log("SearchBox_Arab.qml :: moveFocusB() - ", text_input.cursorPosition )
    }

//    function deleteAll ( key, label, state )
    function deleteAll ( )
    {
//        console.log("SearchBox.qml :: deleteAll() key, label, state : ", key, label, state )
        console.log("SearchBox.qml :: deleteAll()")
//        var nPos = text_input.cursorPosition-1;
        appUserManual.searchText = "";
        text_input.cursorPosition = 0;
        clearAutomata()
    }

    function input ( key, label, state )
    {
        console.log("SearchBox.qml :: input() key, label, state : ", key, label, state )
        if ( 0xFF > key )
        {
            var nPos = text_input.cursorPosition;
            var TextForAdding = label
            var offset = 0
            if(state) offset = 1;

//            if ( state )
//            if( state && appUserManualSearchView.moveFocus)
            {
                appUserManual.searchText = text_input.text.substring( 0, nPos-offset ) +  TextForAdding + text_input.text.substring( nPos );
                text_input.cursorPosition = nPos+TextForAdding.length - offset;
            }
//            else
//            {
//                if(nPos == 0 )
//                    appUserManual.searchText = TextForAdding  ;
//                else
//                    appUserManual.searchText = text_input.text.substring( 0, nPos-offset ) +  TextForAdding + text_input.text.substring( nPos );
//                console.log("SearchBox.qml :: textforAdding", TextForAdding )
//                console.log("SearchBox.qml :: <after> text_input.text", text_input.text)
//
//                text_input.cursorPosition = nPos+TextForAdding.length;
//            }

        }
        else if ( Qt.Key_Back == key )
        {
            var nPos = text_input.cursorPosition-1;
            appUserManual.searchText = text_input.text.substring( 0, nPos ) + text_input.text.substring( nPos+1 );
            text_input.cursorPosition = nPos;
            keyPadWidget.clearState()
        }
    }

    function retranslateUI()
    {
        searchManual= qsTranslate("main", "STR_MANUAL_SEARCH_MANUAL")
//        console.log("Numeric.qml :: textNumDel : ", textNumDel)
//        console.log("Numeric.qml :: textNumGo : ", textNumGo)
    }

    Component.onCompleted:
    {
    }

    Connections
    {
        target: EngineListener

        onRetranslateUi:
        {
            console.log("SearchBox.qml :: RetranslateUi Called.")
            retranslateUI()
        }
    }
}
