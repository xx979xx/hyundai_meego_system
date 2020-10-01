import Qt 4.7
import Qt.labs.gestures 2.0
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0

import "DHAVN_AppUserManual_Images.js" as Images
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item
{
    id: pdfChapterList

    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property int focus_id: Dimensions.const_AppUserManual_PageNumList_FocusIndex
    property bool focus_visible: ( appUserManual.focusIndex == focus_id  && !systemPopupVisible && !disable_popup.visible )
    property int listFocusId: -1
    property int tmpFocusId: -1
    property int chapterCount: -1
    property bool upLongPressed: false
    property bool downPressed: false
    property bool centerPress: false
    property int currentTopIndex: 0


    signal focusImageChange( int focusChange );
    signal focusImageMovement( int focusMove );
    signal handleFocusChange( int fromFocusIndex, int toFocusIndex )

//    x: appUserManual.countryVariant == 4 ? 0 : Dimensions.const_AppUserManual_PageNumList_X
    x: appUserManual.langId == 20 ? 0 : Dimensions.const_AppUserManual_PageNumList_X
    y: Dimensions.const_AppUserManual_TitleList_Y

    Image
    {
        id: menuR
        smooth: true
        source: appUserManual.langId == 20 ? Images.const_AppUserManual_BG_Menu_R_ME :  Images.const_AppUserManual_BG_Menu_R
        x: appUserManual.langId == 20 ? 0 :  -Dimensions.const_AppUserManual_PageNumList_X;
        visible: appUserManual.getActivePane() == Dimensions.const_AppUserManual_RightMenu_Pane
    }

    function __LOG( logText )
    {
        console.log( "ChapterList.qml" + logText )
    }

    function setFG()
    {
        __LOG(" :: setFG()")
        listFocusId = -1
        listFocusId = 0
        currentTopIndex = 0
        pdfChaptersList.positionViewAtIndex(0, ListView.Beginning)
    }

    function stopAnimation()
    {
        down_long_press_timer.stop()
        up_long_press_timer.stop()
        resetPress()
    }

    function resetPress()
    {
        __LOG(" :: resetPress()")
        centerPress = false
        downPressed = false
        upLongPressed = false
    }

    // title list select로 인해 chapterlist로 focus 시 listfocus를 초기화했다 원래 list focus로 다시 변경해 scroll text 정상 동작하도록 수정
    function resetFocusIndex()
    {
        __LOG(" :: resetFocusIndex()")
        resetPress()
        var tmpIndex = listFocusId
        listFocusId = -1
        listFocusId = tmpIndex
    }

    function setCurrentTopIndex()
    {
        __LOG("setCurrentTopIndex()  ")
        var tmpVar = listFocusId - currentTopIndex
        if ( tmpVar >= 0 && tmpVar <= 5 ) {
            // do nothing
        }
        else {
            currentTopIndex = listFocusId
        }
        pdf_PartList.positionViewAtIndex(currentTopIndex, ListView.Beginning)
        console.log("ChapterListScreen.qml :: setCurrentTopIndex() - currentTopIndex:" , currentTopIndex )
    }

    function setJogFocusPosition() //focusIndexPosition()
    {
        __LOG(" :: setJogFocusPosition()")
        var tmpVar = listFocusId - currentTopIndex
        if ( listFocusId == 0 ) {
            currentTopIndex = 0
        }
        else if ( listFocusId == pdfChaptersList.count -1 ) {
            currentTopIndex = pdfChaptersList.count - 6
        }
        else if ( tmpVar < 0 ) {
            currentTopIndex -= 6
            if ( currentTopIndex < 0 ) currentTopIndex = 0
        }
        else if ( tmpVar > 5 ) {
            if ( listFocusId > pdfChaptersList.count - 6 ) {
                currentTopIndex = pdfChaptersList.count - 6
            }
            else {
                currentTopIndex = listFocusId
            }
        }
        pdfChaptersList.positionViewAtIndex(currentTopIndex, ListView.Beginning)
        console.log("ChapterListScreen.qml :: setJogFocusPosition() - currentTopIndex: " , currentTopIndex  , ", listFocusId: " , listFocusId )
//        if ( listFocusId < currentTopIndex ) {
//            if ( listFocusId > 5 ) {
//                currentTopIndex = listFocusId - 5
//            }
//            else {
//                currentTopIndex = 0
//            }
//        }
//        else {
//            if ( listFocusId > currentTopIndex + 5 ) {
//                if ( listFocusId +  5 >= pdfChaptersList.count ) {
//                    currentTopIndex = pdfChaptersList.count - 6
//                }
//                else {
//                    currentTopIndex = listFocusId
//                }
//            }
//        }
//        pdfChaptersList.positionViewAtIndex( currentTopIndex, ListView.Beginning)
    }

    function changeListViewPosition(index){
        console.log("ChapterListScreen.qml :: changeListViewPosition()  index : ", index)
        if(index <= 5)
            pdfChaptersList.positionViewAtIndex(0, ListView.Beginning)
        else if ( index > pdfChaptersList.count - 5 ) {
            if ( index - currentTopIndex > 5 ) {
                currentTopIndex = pdfChaptersList.count-5
                pdfChaptersList.positionViewAtIndex(currentTopIndex, ListView.Beginning)
            }
        }
        else {
            if ( index % 6 != 0 ) {
                pdfChaptersList.positionViewAtIndex( index - index%6, ListView.Beginning)
            }
            else {
                pdfChaptersList.positionViewAtIndex(index, ListView.Beginning)
            }
        }
    }

    function pageNumbersReceived( pageNumberList )
    {
        console.log("ChapterList.qml :: pageNumbersReceived() - pageNumberList : ", pageNumberList)
        rightListModel.clear()

        var i = 0;
        chapterCount = pageNumberList.length

        for( ; i < pageNumberList.length; ++i )
        {
            rightListModel.append( { "titleLabel" : pageNumberList[i] } )
        }
    }

    function getfocusId()
    {
        console.log("ChapterList.qml ::  getfocusId() listFocusId : ", listFocusId)
        return listFocusId
    }

    function setFocusId( index )       // screen view > list view 시 last page로 focus id 수정
    {
        console.log("ChapterList.qml ::  setFocusId() listFocusId : ", index)
        listFocusId = index
        changeListViewPosition(index)
    }

    function listAccelerate( event )
    {
        console.log("ChapterList.qml :: listAccelerate() event : ", event)
        switch ( event )
        {
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                if( pdfChaptersList.currentIndex == 0 )
                {
                    return;
                }
//                if(  rightListModel.count  < 6 )
//                return;
                __LOG(" :: listAccelerate() 1" )
                upLongPressed = true
                pdfChaptersList.currentIndex = --listFocusId
//                if ( up_long_press_timer.interval > 30 )
//                    up_long_press_timer.interval -= 20
            }
            break
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
                if(  pdfChaptersList.currentIndex == (rightListModel.count - 1) )
                return;
//                if(  rightListModel.count  < 6 || pdfChaptersList.currentIndex == (rightListModel.count - 1) )
//                return;

                console.log(" :: listAccelerate() 2 " )
                pdfChaptersList.currentIndex = ++listFocusId
                pdfList.item.updownSetVisualCue( false , true, true )
//                if ( down_long_press_timer.interval > 30 )
//                    down_long_press_timer.interval -= 20
            }
            break
        }
        setJogFocusPosition();
    }

    ListView
    {
        id: pdfChaptersList
        width: Dimensions.const_AppUserManual_Page_Title_List_Width
        height: Dimensions.const_AppUserManual_Page_Title_List_Height

        delegate: listDelegate
        model: rightListModel
        focus: true
//        orientation: ListView.Vertical
        clip: true
//        interactive: ( rightListModel.count > 6 ? true : false )
//        preferredHighlightBegin: 0
//        preferredHighlightEnd: Dimensions.const_AppUserManual_Page_Title_List_Height
        /////////////////////
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000
//        boundsBehavior: Flickable.StopAtBounds
        onCurrentIndexChanged:
        {
            console.log("ChapterList.qml :: onCurrentIndexChanged - index: ", currentIndex)
            positionViewAtIndex(currentIndex, ListView.Contain)
//            if ( currentIndex % Dimensions.const_AppUserManual_Scroll_Count == 0 || currentIndex == 0 )
//                positionViewAtIndex( currentIndex , ListView.Beginning )
//            else
//                setJogFocusPosition();
//                positionViewAtIndex(currentIndex, ListView.Contain)
        }

        onMovementEnded: {
//        onFlickEnded: {
            if ( appUserManual.state != "pdfListView" ) {
                if ( listFocusId - currentIndex  < 6 && listFocusId - currentIndex  >= 0 ) {
                    currentIndex = listFocusId
                    console.log("ChapterList.qml :: onMovementEnded11 - currentIndex : " , currentIndex )
                }
                else {
                    listFocusId = currentIndex
                    console.log("ChapterList.qml :: onMovementEnded22  - currentIndex : " , currentIndex )
                    positionViewAtIndex( currentIndex, ListView.Beginning)
                }
                return;
            }
            if ( optionMenu.visible ) return
            console.log("ChapterList.qml :: onMovementEnded - focusIndex : " , appUserManual.focusIndex )
            if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PageNumList_FocusIndex ) {
                if(appUserManual.langId != 20 ) {
                    pdfList.item.setVisualCue( false, false )
                }
                else {
                    pdfList.item.setVisualCue( true, false )
                }
                if ( appUserManual.focusIndex == Dimensions.const_AppUserManual_OptionMenu_FocusIndex ) {
                    appUserManual.tmpFocusIndex = Dimensions.const_AppUserManual_PageNumList_FocusIndex
                }
                else {
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PageNumList_FocusIndex
                    appUserManual.setChapterListPane()
                }
//                appUserManual.activateMenuPane( false )
            }
//            currentIndex = indexAt( contentX, contentY )
            if ( appUserManual.langId == 20 ) currentIndex = indexAt( 200, contentY )
            else currentIndex = indexAt( contentX, contentY )
            console.log("ChapterList.qml :: onMovementEnded - currentIndex : " , currentIndex )

            if ( currentIndex - listFocusId  >= -5 && currentIndex - listFocusId  <= 0 ) {
                currentTopIndex = currentIndex
                currentIndex = listFocusId
                console.log("ChapterList.qml :: onMovementEnded11 - currentIndex : " , currentIndex )
            }
            else if ( currentIndex > currentTopIndex ) {
                currentTopIndex = currentIndex
                listFocusId = currentIndex
                positionViewAtIndex( currentTopIndex, ListView.Beginning)
                if ( listFocusId - currentTopIndex > 5 )  {
                }
            }
            else {
                listFocusId = currentIndex
                console.log("ChapterList.qml :: onMovementEnded22  - currentIndex : " , currentIndex )
                positionViewAtIndex( currentIndex, ListView.Beginning)
                setCurrentTopIndex()
            }

//            if ( listFocusId - currentIndex  < 6 && listFocusId - currentIndex  >= 0 ) {
//                currentIndex = listFocusId
//                console.log("ChapterList.qml :: onMovementEnded11 - currentIndex : " , currentIndex )
//            }
//            else {
//                listFocusId = currentIndex
//                console.log("ChapterList.qml :: onMovementEnded22  - currentIndex : " , currentIndex )
//                positionViewAtIndex( currentIndex, ListView.Beginning)
//            }
            tmpFocusId = listFocusId
            if (systemPopupVisible ) {
                systemPopupFocusIndex =  Dimensions.const_AppUserManual_PageNumList_FocusIndex
            }
        }

        onContentYChanged : {
            console.log("ChapterList.qml :: onContentYChanged - contentY : " , contentY , ", contentX : " , contentX )
        }
        ////////////////////
        Item
        {
//            x: appUserManual.countryVariant == 4 ? 20 : Dimensions.const_AppUserManual_Title_ScrollBar_X
            x: appUserManual.langId == 20 ? 20 : Dimensions.const_AppUserManual_Title_ScrollBar_X
            y: Dimensions.const_AppUserManual_Title_ScrollBar_Y
            z: rightListModel.count > Dimensions.const_AppUserManual_Scroll_Count ? -1 : 1
            width: scrollBar.width
            height: parent.height - 25
            clip: true
            visible: ( rightListModel.count > Dimensions.const_AppUserManual_Scroll_Count ? true : false )

            VerticalScrollBar
            {
                id: scrollBar
                height: parent.height - 25
                anchors.left: parent.left
                position: pdfChaptersList.visibleArea.yPosition
                pageSize: pdfChaptersList.visibleArea.heightRatio
            }
        }
    }

    Timer {
        id: down_long_press_timer

        repeat: true
        interval: 100

        onTriggered: listAccelerate(UIListenerEnum.JOG_WHEEL_RIGHT ) // , DEFINE.DO_NOT_WRAPPING_AROUND)
    }

    Timer {
        id: up_long_press_timer

        repeat: true
        interval: 100

        onTriggered: listAccelerate(UIListenerEnum.JOG_WHEEL_LEFT ) // , DEFINE.DO_NOT_WRAPPING_AROUND)
    }

    Component
    {
        id: listDelegate

        Rectangle
        {
            width : Dimensions.const_AppUserManual_ListDelegate_Width
            height: Dimensions.const_AppUserManual_ListDelegate_Height
            color: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
            anchors.left:  parent.left
//            anchors.leftMargin:  appUserManual.countryVariant == 4 ? 35 : 0
            anchors.leftMargin:  appUserManual.langId == 20 ? 35 : 0

            Image
            {
                id: focusImage
                anchors.top: line_id.top
                anchors.topMargin: -90
                width: 535
                source:  centerPress ?  Images.const_AppUserManual_BG_Menu_Tab_P :  Images.const_AppUserManual_BG_Menu_Tab_F
//                source: focusMA.pressed ? Images.const_AppUserManual_BG_Menu_Tab_FP : Images.const_AppUserManual_BG_Menu_Tab_F
                visible: focus_visible && listFocusId === index && !optionMenu.focus_visible;
            }
            Image
            {
                id: pressImage
                anchors.top: line_id.top
                anchors.topMargin: -90
                width: 535
                source:  Images.const_AppUserManual_BG_Menu_Tab_P
                visible:  !optionMenu.focus_visible && ( focusMA.pressed || ( centerPress && listFocusId === index && focus_visible ) )
            }
            
            DHAVN_AppUserManual_ScrollText {
                id: scrollingTicker
                x: focusImage.x+23
//                anchors.left: parent.left
//                anchors.leftMargin: 15
                height: 90
                width: 479 // appUserManual.langId == 20 ? 460 : 479
                scrollingTextMargin: 120        // 꼬리물기로 들어올 Text간 간격
                isScrolling: appUserManual.state == "pdfListView" && appUserManual.nowFG && focus_visible && listFocusId === index // Focus 되었을 때, Scroll
                fontPointSize:  Dimensions.const_AppUserManual_Font_Size_40
                clip: true
                fontFamily: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
                fontColor: vehicleVariant == 1 ? listFocusId === index && focus_visible ? Dimensions.const_AppUserManual_ListText_Color_BrightGrey : Dimensions.const_AppUserManual_ListText_Color_CommonGrey
                        : Dimensions.const_AppUserManual_ListText_Color_BrightGrey
                text: titleLabel// leftListModel.get(index).titleLabel // titleLabel
                fontBold: false
            }

            Image
            {
                id: line_id
                y: 89
//                anchors.bottom: parent.bottom
                source: Images.const_AppUserManual_list_Menu_list
            }

            MouseArea
            {
                id: focusMA
                anchors.fill: parent
                enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
                onPressed:
                {
                    console.log("ChapterList.qml :: MouseArea onPressed  ")
                }
                onReleased:
                {
                    if ( optionMenu.focus_visible ) return
//                    if( appUserManual.countryVariant != 4 ) {
                    if( appUserManual.langId != 20 ) {
                        pdfList.item.setVisualCue( false, false)
                    }
                    else {
                        pdfList.item.setVisualCue( true , false)
                    }
                    appUserManual.activateMenuPane( false )
                    listFocusId = index;
                    tmpFocusId = listFocusId
                    handleFocusChange( Dimensions.const_AppUserManual_PageNumList_FocusIndex, Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
                    appUserManual.gotoPageNum( listFocusId )    // content 목록의 index 전달
//                    appUserManual.activateMenuPane( false )
                    appUserManual.launchPDFScreen()
                }
                onClicked:
                {
                }
            }
        }
    }

    ListModel
    {
        id: rightListModel
    }

    Connections
    {
        target: pdfChapterList

        onFocusImageChange:
        {
            if( focusChange === 0 )
            {
                console.log("ChapterList.qml :: onFocusImageChange 0")
                listFocusId = 0;
                changeListViewPosition(listFocusId)
                currentTopIndex = 0
            }
            else if( focusChange == 1)
            {
                console.log("ChapterList.qml :: onFocusImageChange 1  listFocusId : ", listFocusId )
                tmpFocusId = listFocusId
                listFocusId = -1;
            }
            else
            {
                console.log("ChapterList.qml :: onFocusImageChange 2 listFocusId : " , listFocusId )
                listFocusId = tmpFocusId
                pdfChaptersList.currentIndex = listFocusId
                changeListViewPosition(listFocusId)
            }
        }

        onFocusImageMovement:
        {
            if( focusMove )
            {
                pdfChaptersList.currentIndex = ++listFocusId;
            }
            else
            {
                pdfChaptersList.currentIndex = --listFocusId;
            }
        }
    }

    Connections
    {
        target: ( pdfChapterList.focus_visible && !optionMenu.focus_visible && !disable_popup.visible) ? UIListener : null

        onSignalJogNavigation:
        {
            if ( appUserManual.lockoutMode ) return
            console.log("ChapterListScreen.qml :: onSignalJogNavigation")
                switch( arrow )
                {
                case UIListenerEnum.JOG_LEFT:
                {
                    if( status == UIListenerEnum.KEY_STATUS_PRESSED) {
//                        if( appUserManual.countryVariant != 4 ) {
                        if( appUserManual.langId != 20 ) {
                            pdfList.item.setVisualCue( true , true )
                            appUserManual.activateMenuPane( true )
                            handleFocusChange( Dimensions.const_AppUserManual_PageNumList_FocusIndex, Dimensions.const_AppUserManual_TitleList_FocusIndex )
                        }
                    }
                    else if( status === UIListenerEnum.KEY_STATUS_RELEASED ) {
//                        if( appUserManual.countryVariant == 4 )
                        if( appUserManual.langId == 20 )
                        {
                            pdfList.item.setVisualCue( true, false )
                        }
//                            appUserManual.activateMenuPane( true )
//                            handleFocusChange( Dimensions.const_AppUserManual_PageNumList_FocusIndex, Dimensions.const_AppUserManual_TitleList_FocusIndex )
//                        }
                    }
                }
                break;
                case UIListenerEnum.JOG_RIGHT:
                {
                    if( status == UIListenerEnum.KEY_STATUS_PRESSED) {
//                        if( appUserManual.countryVariant == 4 ) {
                        if( appUserManual.langId == 20 ) {
                            pdfList.item.setVisualCue( false , true )
                            appUserManual.activateMenuPane( true )
                            handleFocusChange( Dimensions.const_AppUserManual_PageNumList_FocusIndex, Dimensions.const_AppUserManual_TitleList_FocusIndex )
                        }
                    }
                    else if( status === UIListenerEnum.KEY_STATUS_RELEASED ) {
//                        if( appUserManual.countryVariant != 4 )
                        if( appUserManual.langId != 20 )
                        {
                            pdfList.item.setVisualCue( false, false )
//                            appUserManual.activateMenuPane( true )
//                            handleFocusChange( Dimensions.const_AppUserManual_PageNumList_FocusIndex, Dimensions.const_AppUserManual_TitleList_FocusIndex )
                        }
                    }
                }
                break;
                case UIListenerEnum.JOG_UP:
                {
                    if( status == UIListenerEnum.KEY_STATUS_PRESSED) {
                        __LOG(" -  jog_up  pressed ")
                        pdfList.item.updownSetVisualCue( true, true, false )
                    }
         /*           if( status == UIListenerEnum.KEY_STATUS_CLICKED)
                    {
                        __LOG(" -  jog_up  clicked ")
//                        pdfChaptersList.currentIndex = listFocusId
//                        handleFocusChange( Dimensions.const_AppUserManual_PageNumList_FocusIndex, Dimensions.const_AppUserManual_ModeArea_FocusIndex )
//                        pdfChapterList.focusImageChange( 1 )
                    }
                    else*/ if( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
                    {
                        __LOG(" -  jog_up long pressed ")
                        up_long_press_timer.restart()
                    }
                    else if( status === UIListenerEnum.KEY_STATUS_RELEASED ) {
                        __LOG(" -  jog_up long released ")
                        up_long_press_timer.stop()
                        if ( upLongPressed ) {
                            upLongPressed = false
                            pdfList.item.updownSetVisualCue( true, false, false )
                        }
                        else {
    //                        pdfList.item.setVisualCuePressedMode( true )
    //                        pdfList.item.setVisualCueMode(true)
                            pdfList.item.updownSetVisualCue( true, false, true)
                            handleFocusChange( Dimensions.const_AppUserManual_PageNumList_FocusIndex, Dimensions.const_AppUserManual_ModeArea_FocusIndex )
                            pdfChapterList.focusImageChange( 1 )
                        }
//                        pdfChaptersList.currentIndex = listFocusId
//                        handleFocusChange( Dimensions.const_AppUserManual_PageNumList_FocusIndex, Dimensions.const_AppUserManual_ModeArea_FocusIndex )
//                        pdfChapterList.focusImageChange( 1 )
//
//                        pdfList.item.setVisualCueMode(true)
                    }
                    else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        console.log("TitleListScreen.qml :: jog_up KEY_STATUS_CANCELED")
                        up_long_press_timer.stop()
                        upLongPressed = false
                        pdfList.item.updownSetVisualCue( true, false, false )
                    }
                }
                break;
                case UIListenerEnum.JOG_DOWN:
                {
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        console.log("ChapterListScreen.qml :: jog_down pressed")
                        downPressed = true
                    }
                    if ( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
                    {
                        console.log("ChapterListScreen.qml :: jog_down long pressed")
                        if ( downPressed ) {
                            down_long_press_timer.restart()
                        }
                    }
                    if ( status == UIListenerEnum.KEY_STATUS_RELEASED)
                    {
                        console.log("ChapterListScreen.qml :: jog_down released")
//                        if ( !downPressed ) {
//                            pdfChapterList.focusImageChange( 2 )
//                        }
                        downPressed = false
                        down_long_press_timer.stop()
                        down_long_press_timer.interval = 100
                        pdfList.item.updownSetVisualCue( false , false, true )
                    }
                    else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        console.log("TitleListScreen.qml :: jog_down KEY_STATUS_CANCELED")
                        down_long_press_timer.stop()
                        downPressed = false
                        down_long_press_timer.interval = 100
                        pdfList.item.updownSetVisualCue( false , false, true )
                    }
                }
                break;
                case UIListenerEnum.JOG_CENTER:
                {
                    if( status == UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        centerPress = true
                    }
                    else if( status == UIListenerEnum.KEY_STATUS_RELEASED ) {
                        centerPress = false
                        appUserManual.gotoPageNum( listFocusId )        // content 목록의 index 전달
                        appUserManual.launchPDFScreen()
                        tmpFocusId = listFocusId
                        handleFocusChange( Dimensions.const_AppUserManual_PageNumList_FocusIndex, Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
                    }
                    else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        console.log("TitleListScreen.qml :: KEY_STATUS_CANCELED")
                        centerPress = false
                    }
                }
                    break;
                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    if( status == UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        if ( appUserManual.langId != 20 ) {
                            if( listFocusId > 0 )
                            {
                                pdfChaptersList.currentIndex = --listFocusId;
                            }
                            else if ( pdfChaptersList.count > 6 ) {
                                listFocusId = pdfChaptersList.count  - 1
                                pdfChaptersList.currentIndex = listFocusId
                            }
                        }
                        else {
                            if( listFocusId != ( chapterCount - 1 ) )
                                pdfChaptersList.currentIndex = ++listFocusId;
                            else if ( pdfChaptersList.count > 6 ) {
                                listFocusId = 0
                                pdfChaptersList.currentIndex = listFocusId
                            }
                        }
                        setJogFocusPosition();
                    }
                }
                    break;
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    if( status == UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        if ( appUserManual.langId != 20 ) {
                            if( listFocusId != ( chapterCount - 1 ) )
                                pdfChaptersList.currentIndex = ++listFocusId;
                            else if ( pdfChaptersList.count > 6 ) {
                                listFocusId = 0
                                pdfChaptersList.currentIndex = listFocusId
                            }
                        }
                        else {
                            if( listFocusId > 0 )
                            {
                                pdfChaptersList.currentIndex = --listFocusId;
                            }
                            else if ( pdfChaptersList.count > 6 ) {
                                listFocusId = pdfChaptersList.count  - 1
                                pdfChaptersList.currentIndex = listFocusId
                            }
                        }
                        setJogFocusPosition();
                    }
                }
                    break;
            }
        }
    }

    Component.onCompleted:
    {
    }
}
