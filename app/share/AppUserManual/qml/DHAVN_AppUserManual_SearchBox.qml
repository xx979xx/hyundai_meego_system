import Qt 4.7

import "DHAVN_AppUserManual_Images.js" as Images
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item
{
    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property bool markerVisible: false
    property string searchManual: qsTranslate("main", "STR_MANUAL_SEARCH_MANUAL")
    property string typePinyin: qsTranslate("main", "STR_MANUAL_CHINESE_PIYIN")
    property string pinyinType: "NONE"              // "NONE", "PINYIN", "SOUND", "HANDWRITING"
    signal handleSearchBoxClickEvent();
    signal clearAutomata();

    Timer{
        id:marker_timer
        interval: 5000; running: true; repeat: false
        onTriggered:{
            console.log("SearchBox.qml :: marker_timer onTriggered")
            hideMarker()
        }
    }

    Image
    {
        id: appUserManualSearchBox
        source: Images.const_AppUserManual_Search_Box
        anchors.left: parent.left
        anchors.top: parent.top
        height: 70
//        Image {
//            id: ico_search
//            source: Images.const_AppUserManual_Search_Ico
//            anchors.top:  parent.top
//            anchors.topMargin: 106-93
//            anchors.left: parent.left
//            anchors.leftMargin: appUserManual.langId == 20 ? 1186+16-281 : 34-7
//        }
        TextInput
        {
            id: text_input
            property int cursor_pos: -1
            anchors.top: parent.top; anchors.topMargin:  10 // 35 - height/2
            anchors.left: parent.left
            anchors.leftMargin: 33 //appUserManual.langId == 20 ? 20 : 34+59 // Dimensions.const_AppUserManual_TextInput_LeftMargin
            width: 920 //950
            color: Dimensions.const_AppUserManual_ListText_Color_Black
//            selectedTextColor: Dimensions.const_AppUserManual_ListText_Color_BrightGrey
//            selectionColor: Dimensions.const_AppUserManual_GoTo_Text_Color
            font.pixelSize: Dimensions.const_AppUserManual_Search_Font_Size_32
            font.family: vehicleVariant == 1 ? "KH_HDB" : "DH_HDB"
            smooth: true
            cursorPosition: 0
            cursorDelegate: appUserManual.searchText.length == 0 && langId == 20 ? cursor0_delegate
                    : appUserManualSearchView.focus_index == Dimensions.const_AppUserManual_Focus_SearchBar && appUserManualSearchView.focus_visible ? cursorF_delegate
                    : cursorN_delegate
            text: appUserManual.searchText //This is our string to be searched.
            selectByMouse: true
            onCursorDelegateChanged: {
                console.log("SearchBox.qml :: onCursorDelegateChanged")
                var tmpCurPos = cursorPosition
                var tmpText =  appUserManual.searchText
                appUserManual.searchText = tmpText + "a"
                appUserManual.searchText = tmpText
                cursorPosition = tmpCurPos
            }
//            horizontalAlignment: Text.AlignLeft

            Text
            {
                id: searchBoxText
                text: countryVariant == 2 ? // ( appUserManual.langId > 2 && appUserManual.langId < 5 ) ?       // 중국향지일 경우
                    (pinyinType == "PINYIN" ? searchManual + typePinyin : searchManual )        // 병음일 경우 가이드 텍스트 추가
                    : searchManual
//                text: searchManual //qsTranslate("main", "STR_MANUAL_SEARCH_MANUAL")
                anchors.left: parent.left; anchors.leftMargin: 5
                width: 910
                color: Dimensions.const_AppUserManual_ListText_Color_DimmedGrey
                font.pixelSize: Dimensions.const_AppUserManual_Search_Font_Size_32
                font.family: vehicleVariant == 1 ? "KH_HDB" : "DH_HDB"
                horizontalAlignment: langId == 20 ? Text.AlignRight : Text.AlignLeft
                visible: ( text_input.text.length == 0 ) // this should be true only when the text_input's text lenght is 0
            }

            onCursorPositionChanged:
            {
                console.log("SearchBox.qml :: onCursorPositionChanged")
                if( cursor_pos >= 0 )
                    cursorPosition = cursor_pos
                cursor_pos = -1
                marker_input.cursorPosition = cursorPosition
                if (marker_input.state == "SHOW" ) {
                    marker_timer.restart()
                }
//                clearAutomata()
            }
            Image
            {
                id: cursor0F
                anchors.top: parent.top; anchors.topMargin: 5
                anchors.right: parent.right; anchors.rightMargin: 0
                visible: appUserManual.searchText.length == 0 && langId == 20
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
            MouseArea
            {
                anchors.fill: parent
                enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
                onClicked:
                {
                    console.log("SearchBox.qml :: text_input onClicked : ", text_input.positionAt(mouseX, TextInput.CursorOnCharacter) )
                    selectedTextToInputText()
                    appUserManualSearchView.focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                    text_input.cursorPosition = text_input.positionAt(mouseX, TextInput.CursorOnCharacter);
                    appUserManualSearchView.clearLastPinYinPosition()
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
                    id: ico_cursor
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    source: Images.const_AppUserManual_Search_Cursor_N
                    SequentialAnimation {
                    running: ico_cursor.visible
                          loops: Animation.Infinite;
                          NumberAnimation { target: ico_cursor; property: "opacity"; to: 1; duration: 100 }
                          PauseAnimation  { duration: 500 }
                          NumberAnimation { target: ico_cursor; property: "opacity"; to: 0; duration: 100 }
                      }

//                    SequentialAnimation {
//                        running: ico_cursor.visible
//                        loops: Animation.Infinite;
//
//                        NumberAnimation { target: ico_cursor; property: "opacity"; to: 1; duration: 200 }
//                        PauseAnimation  { duration: 500 }
//                        NumberAnimation { target: ico_cursor; property: "opacity"; to: 0; duration: 200 }
//                    }
                }
            }
        }
    }

    TextInput
    {
        id: marker_input
        anchors.top: parent.top
        anchors.topMargin:  70// 35 - height/2
        anchors.left: parent.left
        anchors.leftMargin: 33 //appUserManual.langId == 20 ? 20 : 34+59 // Dimensions.const_AppUserManual_TextInput_LeftMargin
        width: 920// 950
        height: 90
        visible: true
        color: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
        selectedTextColor: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
        selectionColor: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
        font.pixelSize: Dimensions.const_AppUserManual_Search_Font_Size_32
        font.family: vehicleVariant == 1 ? "KH_HDB" : "DH_HDB"
        smooth: true
        cursorPosition: 0
        cursorDelegate: marker2_delegate
        text: text_input.text
        selectByMouse: true
//        horizontalAlignment: Text.AlignLeft
//        cursorVisible: markerVisible && text_input.text.length > 0

        onCursorPositionChanged:
        {
            console.log("SearchBox.qml :: marker_input - onCursorPositionChanged")
            if ( text_input.cursorPosition != cursorPosition ) {
                text_input.cursorPosition = cursorPosition
                clearAutomata()
            }
        }
        state: "HIDE"
        states: [
             State {
                name: "SHOW";
                PropertyChanges { target: marker_input;   opacity: 1; }
            }
            , State {
                name: "HIDE";
                PropertyChanges { target: marker_input;   opacity: 0; }
            }
        ]
        transitions: [
            Transition {
                NumberAnimation { target: marker_input;   properties: "opacity";  duration: 500 }
            }
        ]
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
                anchors.leftMargin: -18
                source: Images.const_AppUserManual_Search_Ico_Marker
            }
        }
    }

    function setCursorFocus(status)
    {
        console.log("SearchBox.qml :: setCursorFocus(" , status , ")")
        cursorF = status
    }

    function setChineseKeypad( pinyin )
    {
        console.log("SearchBox.qml :: setChineseKeypad(" , pinyin , ")")
        pinyinType = pinyin
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
        marker_input.state = "SHOW"
        var tmpCursorPos = text_input.cursorPosition
        text_input.cursorPosition = 0
        text_input.cursorPosition = tmpCursorPos
        marker_timer.restart()
    }

    function hideMarker_chinesePopup()
    {
        console.log("SearchBox.qml :: hideMarker_chinesePopup()" )

        marker_input.state = "HIDE"
        marker_timer.stop()
    }

    function hideMarker()
    {
        console.log("SearchBox.qml :: hideMarker()" )
        
        marker_input.state = "HIDE"
        marker_timer.stop()
        var tmpCursorPos = text_input.cursorPosition
        text_input.cursorPosition = 0
        text_input.cursorPosition = tmpCursorPos
    }

    function moveFocusF()
    {
        console.log("SearchBox.qml :: moveFocusF()" )
        showMarker()
        text_input.cursorPosition++
    }

    function moveFocusB()
    {
        showMarker()
        text_input.cursorPosition--
    }

//    function deleteAll ( key, label, state )
    function deleteAll ( )
    {
//        console.log("SearchBox.qml :: deleteAll() key, label, state : ", key, label, state )
        console.log("SearchBox.qml :: deleteAll()")
//        var nPos = text_input.cursorPosition-1;

        /* 아랍어 커서 오류 수정을 위해 추가... */
        appUserManual.searchText = "";
        appUserManual.searchText = "a";
        /* ************************** */
        
        appUserManual.searchText = "";
        text_input.cursorPosition = 0;
        if ( appUserManual.countryVariant != 2 ) clearAutomata()
        hideMarker()
    }

    function deleteCurPosition ( )
    {
        console.log("SearchBox.qml :: deleteCurPosition() text_input.cursorPosition: ", text_input.cursorPosition )

        appUserManual.searchText = text_input.text.substring(text_input.cursorPosition, appUserManual.searchText.length )
        text_input.cursorPosition = 0;
        if ( appUserManual.countryVariant != 2 ) clearAutomata()
        hideMarker()
    }

    function searchChinesePinyin()
    {
        console.log("SearchBox.qml :: searchChinesePinyin() text_input.selectedText: ", text_input.selectedText )
        keyPadWidget.searchChinesePinyin( text_input.selectedText )
    }

    function setPinyinColor ( lastPinYinPosition )
    {
        if ( pinyinType == "NONE" ) return;
        text_input.select( text_input.cursorPosition-lastPinYinPosition , text_input.cursorPosition );
        console.log("SearchBox.qml :: setPinyinColor() text_input.cursorPosition, lastPinYinPosition, selectedText: ", text_input.cursorPosition, lastPinYinPosition, text_input.selectedText )
//        text_input.select( text_input.text.length - lastPinYinPosition, text_input.text.length);      // select text는 항상 입력 문자열의 마지막에만 위치할 경우
    }

    function deleteSelectedText()
    {
        console.log("SearchBox.qml :: deleteSelectedText() text_input.selectedText: ", text_input.selectedText )
        var selectionStart = text_input.selectionStart
        appUserManual.searchText = text_input.text.substring( 0, selectionStart ) + text_input.text.substring( text_input.selectionEnd );
        text_input.cursorPosition = selectionStart
        console.log("SearchBox.qml :: deleteSelectedText() appUserManual.searchText: ", appUserManual.searchText )
    }

    function selectedTextToInputText()      // 중국향 select text 입력 상태에서 searchBar로 focus 이동 시 selected text를 input text로 변환
    {
        console.log("SearchBox.qml :: selectedTextToInputText() - text_input.selectedText: ", text_input.selectedText
                , ", text_input.selectionStart: " , text_input.selectionStart
                , ", text_input.selectionEnd: " , text_input.selectionEnd )
        if( text_input.selectionStart != text_input.selectionEnd )
        {
            var selectEnd = text_input.selectionEnd
            var selectionStart = text_input.selectionStart
            var splitArray = [""]
            var tmpStr;
            splitArray = text_input.selectedText.split("'")
            if(splitArray.length > 0)
            {
                tmpStr = ""
                for(var i=0; i < splitArray.length; i++)
                {
                    tmpStr += splitArray[i]
                }
            }
            text_input.select( 0, 0 )
            appUserManual.searchText = text_input.text.substring( 0, selectionStart ) + tmpStr + text_input.text.substring( selectEnd );
            pinyinComplete = true;
            text_input.cursorPosition = selectEnd - splitArray.length+1//  selectionStart + splitArray.length + 1
            keyPadWidget.clearState()
        }
        if ( appUserManual.searchText.length > 0 ) {
            keyPadWidget.setEnableButton("done")
            appUserManualSearchBar.setSearchIcon(true)
        }
    }

    function getSelectTextLength()
    {
        var splitArray = [""]
        splitArray = text_input.selectedText.split("'")
        var selectedStr = ""
        for ( var i = 0; i < splitArray.length; i++) {
            selectedStr += splitArray[i]
        }
        console.log("SearchBox.qml :: getSelectTextLength() : ", selectedStr.length )
        return selectedStr.length
    }

    function pinyInput( position , label )
    {
        console.log("SearchBox.qml :: pinyInput() position, label, lastPinYinPosition: ", position, label, lastPinYinPosition  )
        var selectEnd = text_input.selectionEnd
        var selectStart = text_input.selectionStart
        var splitArray = [""]
        splitArray = text_input.selectedText.split("'")
        if ( label.length < splitArray.length ) {  // 선택된 병음이 입력한 병음 구분자 수보다 작을 경우
            var selectedStr = ""
            var notSelectedStr = ""
            for ( var i = 0; i < splitArray.length; i++) {
                if ( i < label.length ) {
                    selectedStr += splitArray[i]         // 치환된 병음 별도 저장
                }
                else {
                    notSelectedStr += splitArray[i]         // 남아있는 입력 병음 별도 저장
                    if ( i != splitArray.length-1 ) notSelectedStr += "'"
                }
            }
            appUserManual.searchText = text_input.text.substring( 0, selectStart )      // selectedText 이전 string
                                                        + label                                                    // 치환된 병음 한자
                                                        + text_input.text.substring( selectStart+selectedStr.length+label.length )      // selectedText 시작 위치 + 치환된 selectedText length + 구분자 수
            console.log("SearchBox.qml :: notSelectedStr: ", notSelectedStr , ", " , selectStart+label.length , " , ", notSelectedStr.length )
            text_input.select( selectStart+label.length, selectStart+label.length+notSelectedStr.length )
            console.log("SearchBox.qml :: new selectedText: " , text_input.selectedText , ", start, end: " , text_input.selectionStart , text_input.selectionEnd )
            if ( text_input.selectionStart == text_input.selectionEnd ) {     // 구분자를 수동으로 입력하고, 해당 구분자가 마지막 글자일 경우
                pinyinComplete = true
                lastPinYinPosition = 0
            }
            else {
                pinyinComplete = false;
                lastPinYinPosition = notSelectedStr.length
            }
            text_input.cursorPosition = text_input.selectionEnd
        }
        else {
            appUserManual.searchText = text_input.text.substring( 0, selectStart )
                                                        + label
                                                        + text_input.text.substring( selectEnd )
            text_input.select( 0, 0 )
            text_input.cursorPosition = selectStart+label.length
            pinyinComplete = true;
            lastPinYinPosition = 0
            keyPadWidget.searchChinesePrediction(appUserManual.searchText)
        }
//        appUserManual.searchText = text_input.text.substring( 0, text_input.text.length - position ) + label;
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
            {
                appUserManual.searchText = text_input.text.substring( 0, nPos-offset ) +  TextForAdding + text_input.text.substring( nPos );
                text_input.cursorPosition = nPos+TextForAdding.length - offset;
            }
        }
        else if ( Qt.Key_Launch4 == key && label == "" ) {
            var nPos = text_input.cursorPosition-1;
            appUserManual.searchText = text_input.text.substring( 0, nPos ) + text_input.text.substring( nPos+1 );
            text_input.cursorPosition = nPos;
            if ( appUserManual.countryVariant != 2 ) keyPadWidget.clearState()
        }
        else if ( Qt.Key_Back == key )
        {
            var nPos = text_input.cursorPosition-1;
            appUserManual.searchText = text_input.text.substring( 0, nPos ) + text_input.text.substring( nPos+1 );
            text_input.cursorPosition = nPos;
            if ( appUserManual.countryVariant != 2 ) keyPadWidget.clearState()
        }
    }

    function retranslateUI()
    {
        searchManual = qsTranslate("main", "STR_MANUAL_SEARCH_MANUAL")
        typePinyin = qsTranslate("main", "STR_MANUAL_CHINESE_PIYIN")
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
