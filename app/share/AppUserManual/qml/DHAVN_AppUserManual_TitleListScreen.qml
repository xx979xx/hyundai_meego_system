import Qt 4.7
import Qt.labs.gestures 2.0
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0

import "DHAVN_AppUserManual_Images.js" as Images
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item
{
    id: pdfTitleList

    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property int focus_id: Dimensions.const_AppUserManual_TitleList_FocusIndex
    property bool focus_visible: ( appUserManual.focusIndex == focus_id && appUserManual.nowFG && !systemPopupVisible && !disable_popup.visible )
    property int listFocusId: -1 // 최초 -1  // 최초 진입시 list focus 첫번째로 이동
    property int tmpFocusId: -1
    property int titleCount: 0
    property bool titleListFocus: true
    property bool centerPress: false
    property bool upLongPressed: false
    property bool downLongPressed: false
    property int currentTopIndex: 0

    signal focusImageChange( int focusChange );
    signal focusImageMovement( int focusMove );
    signal handleFocusChange( int fromFocusIndex, int toFocusIndex )

//    x: appUserManual.countryVariant == 4 ? 637 : 0// Dimensions.const_AppUserManual_TitleList_X
    x: appUserManual.langId == 20 ? 637 : 0// Dimensions.const_AppUserManual_TitleList_X
    y: Dimensions.const_AppUserManual_TitleList_Y
    width: 610

    Image
    {
            id: menuL
            smooth: true
//            source: appUserManual.countryVariant == 4 ? Images.const_AppUserManual_BG_Menu_LS_ME :  Images.const_AppUserManual_BG_Menu_LS
//            x: appUserManual.countryVariant == 4 ? 618 : 0
            source: appUserManual.langId == 20 ? Images.const_AppUserManual_BG_Menu_L_ME :  Images.const_AppUserManual_BG_Menu_L
            x: appUserManual.langId == 20 ? -637 :  0;
            visible: appUserManual.getActivePane() == Dimensions.const_AppUserManual_LeftMenu_Pane
    }

    function __LOG( logText )
    {
        console.log( "TitleListScreen.qml :: " + logText )
    }

    function stopAnimation()
    {
        console.log( "TitleListScreen.qml :: stopAnimation()" )
        down_long_press_timer.stop()
        up_long_press_timer.stop()
        resetPress()
    }

    function resetPress()
    {
        __LOG(" :: resetPress()")
        centerPress = false
        upLongPressed = false
        downLongPressed = false
    }

    function setFG()
    {
        __LOG("setFG()  ")
        /* FG 시 titlelist 첫번째 index text scrolling 위해서 추가*/
        titleListFocus = true
        listFocusId = -1;
        /****************************************/
        listFocusId = 0;
        currentTopIndex = 0
        appUserManual.getPageNumbers( listFocusId )
        pdf_PartList.positionViewAtIndex(0, ListView.Beginning)
    }

    function setChapterListPane()
    {
        __LOG("setChapterListPane(  ) ")
        handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_PageNumList_FocusIndex )
        titleListFocus = false
    }

    function setBtManual()
    {
        __LOG("setBtManual()  ")
        listFocusId = appUserManual.btIndex
        pdf_PartList.currentIndex = listFocusId
        if ( listFocusId <= pdf_PartList.count - 6 )  currentTopIndex = listFocusId
        else currentTopIndex = pdf_PartList.count - 6
        appUserManual.getPageNumbers( listFocusId )
    }

    function setVrManual()
    {
        __LOG("setVrManual()  ")
        listFocusId = appUserManual.vrIndex
        pdf_PartList.currentIndex = listFocusId
        if ( listFocusId <= pdf_PartList.count - 6 )  currentTopIndex = listFocusId
        else currentTopIndex = pdf_PartList.count - 6
        appUserManual.getPageNumbers( listFocusId )
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
        console.log("TitleListScreen.qml :: setCurrentTopIndex() - currentTopIndex:" , currentTopIndex )
    }

    function setJogFocusPosition()
    {
        console.log("TitleListScreen.qml :: setJogFocusPosition() listFocusId: " , listFocusId , " ,  currentTopIndex: " , currentTopIndex )
        var tmpVar = listFocusId - currentTopIndex
        if ( listFocusId == 0 ) {
            currentTopIndex = 0
        }
        else if ( listFocusId == pdf_PartList.count -1 ) {
            currentTopIndex = pdf_PartList.count - 6
        }
        else if ( tmpVar < 0 ) {
            currentTopIndex -= 6
            if ( currentTopIndex < 0 ) currentTopIndex = 0
        }
        else if ( tmpVar > 5 ) {
            if ( listFocusId > pdf_PartList.count - 6 ) {
                currentTopIndex = pdf_PartList.count - 5
            }
            else {
                currentTopIndex = listFocusId
            }
        }
        pdf_PartList.positionViewAtIndex(currentTopIndex, ListView.Beginning)
        console.log("TitleListScreen.qml :: setJogFocusPosition()  currentTopIndex : ", currentTopIndex)
    }

    function changeListViewPosition(index) {
        console.log("TitleListScreen.qml :: changeListViewPosition()  index : ", index)
        if(index <= 5)
            pdf_PartList.positionViewAtIndex(0, ListView.Beginning)
        else if ( index > pdf_PartList.count - 5 ) {
            if ( index - currentTopIndex > 5 ) {
                currentTopIndex = pdf_PartList.count-5
                pdf_PartList.positionViewAtIndex(currentTopIndex, ListView.Beginning)
            }
        }
        else {
            if ( index % 6 != 0 ) {
                pdf_PartList.positionViewAtIndex( index - index%6, ListView.Beginning)
            }
            else {
                pdf_PartList.positionViewAtIndex(index, ListView.Beginning)
            }
        }
    }

    function titleReceived( titleList )
    {
        console.log("TitleListScreen.qml :: titleReceived() titleList.length : ", titleList.length , ", titleList: " , titleList )
        leftListModel.clear()

        var i = 0;
        titleCount = titleList.length

        for( ; i < titleList.length; ++i )
        {
            leftListModel.append( {"titleLabel" : titleList[i]} )
        }
    }

    function resetFocus()
    {
        __LOG("resetFocus() " )
        pdf_PartList.currentIndex = 0
        pdf_PartList.positionViewAtIndex(0, ListView.Beginning)
        listFocusId = -1
        currentTopIndex = 0
        appUserManual.getPageNumbers( listFocusId )
    }

    function getfocusId()
    {
        console.log("TitleListScreen.qml :: getfocusId() listFocusId : ", listFocusId)
        return listFocusId
    }

    function setFocusId( index )            // PDF > List back 시에만 사용
    {
        console.log("TitleListScreen.qml :: setFocusId() index : ", index )
        listFocusId = index
        pdf_PartList.currentIndex = listFocusId
        if(listFocusId <= 5)
            currentTopIndex = 0
        else if ( listFocusId > pdf_PartList.count - 5 ) {
            if ( listFocusId - currentTopIndex > 5 ) {
                currentTopIndex = pdf_PartList.count-5
            }
        }
        else {
            if ( listFocusId % 6 != 0 ) {
                currentTopIndex = listFocusId - listFocusId%6
            }
            else {
                currentTopIndex = listFocusId
            }
        }
        changeListViewPosition(index)
        appUserManual.getPageNumbers( listFocusId )
    }

    function getListTitle( num )
    {
        console.log("TitleListScreen.qml :: getListTitle() num : ", num)
//        if (listFocusId < 0 )
//            listFocusId = 0
        return  leftListModel.get(num).titleLabel
    }

    function getTitle()
    {
        console.log("TitleListScreen.qml :: getTitle() listFocusID : ", listFocusId)
        if (listFocusId < 0 ) {
            listFocusId = 0
            currentTopIndex = 0
        }
        return  leftListModel.get(listFocusId).titleLabel
    }

    function listAccelerate( event )
    {
        console.log("TitleListScreen.qml :: listAccelerate() event : ", event)
        switch ( event )
        {
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                if( pdf_PartList.currentIndex == 0 )
                {
                    return;
                }
                console.log("TitleListScreen.qml :: listAccelerate() 1" )
                upLongPressed = true
                pdf_PartList.currentIndex = --listFocusId
            }
            break
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
                if(  pdf_PartList.currentIndex == (titleCount - 1) )
                return;

                console.log("TitleListScreen.qml :: listAccelerate() 2 " )
                pdf_PartList.currentIndex = ++listFocusId
                pdfList.item.updownSetVisualCue( false , true, true )
            }
            break
        }
        setJogFocusPosition()
        menuSelectTimer.restart();
    }

    ListView
    {
        id: pdf_PartList
        width: 630 //Dimensions.const_AppUserManual_Page_Title_List_Width
        height: Dimensions.const_AppUserManual_Page_Title_List_Height
        anchors.left: parent.left

        delegate: listDelegate
        model: leftListModel
        focus: true
//        orientation: ListView.Vertical
        clip: true
//        interactive: ( leftListModel.count > 6 ) ? true : false
//        preferredHighlightBegin: 0
//        preferredHighlightEnd: Dimensions.const_AppUserManual_Page_Title_List_Height
        ///
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000
//        boundsBehavior: Flickable.StopAtBounds
//        onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)
        onCurrentIndexChanged:
        {
            console.log("TitleList.qml onCurrentIndexChanged ", currentIndex)
//            setJogFocusPosition();
            positionViewAtIndex(currentIndex, ListView.Contain)
//            menuSelectTimer.restart();
        }

        onMovementEnded: {
            console.log("TitleList.qml onMovementEnded - state:  " , appUserManual.state )
            if ( appUserManual.state != "pdfListView" ) {
//                positionViewAtIndex( currentIndex, ListView.Beginning)
//                currentTopIndex = currentIndex
                return;
            }
            if ( appUserManual.focusIndex == Dimensions.const_AppUserManual_TitleList_FocusIndex ) {
            }
            currentIndex = indexAt( 200, contentY )
            console.log("TitleList.qml :: onMovementEnded - currentIndex : " , currentIndex )
            menuSelectTimer.restart();
            if ( currentIndex - listFocusId  >= -5 && currentIndex - listFocusId  <= 0 ) {
                currentTopIndex = currentIndex
                currentIndex = listFocusId
                console.log("TitleList.qml :: onMovementEnded11 - currentIndex : " , currentIndex )
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
                console.log("TitleList.qml :: onMovementEnded22  - currentIndex : " , currentIndex )
                positionViewAtIndex( currentIndex, ListView.Beginning)
                setCurrentTopIndex()
            }
            if ( optionMenu.visible ) return
            if( appUserManual.langId != 20 ) {
                pdfList.item.setVisualCue( true , false )
                appUserManual.activateMenuPane( true )
            }
            else {
                pdfList.item.setVisualCue( false , false )
                appUserManual.activateMenuPane( true )
            }
            handleFocusChange( Dimensions.const_AppUserManual_PageNumList_FocusIndex, Dimensions.const_AppUserManual_TitleList_FocusIndex )

//            flickStartTimer.restart()
        }
       Image
       {
//           x: appUserManual.countryVariant == 4 ?  13 : Dimensions.const_AppUserManual_Title_ScrollBar_X + 43
           x: appUserManual.langId == 20 ?  13 : Dimensions.const_AppUserManual_Title_ScrollBar_X + 43
          y: Dimensions.const_AppUserManual_Title_ScrollBar_Y
          z: Dimensions.const_AppUserManual_Z_1

//          source: appUserManual.countryVariant == 4 ?  Images.const_AppUserManual_Scroll_Menu_BG_ME : Images.const_AppUserManual_Scroll_Menu_BG
          source: appUserManual.langId == 20 ?  Images.const_AppUserManual_Scroll_Menu_BG_ME : Images.const_AppUserManual_Scroll_Menu_BG
          visible: ( leftListModel.count > Dimensions.const_AppUserManual_Scroll_Count ) ? true : false
          Item
          {
              height: pdf_PartList.visibleArea.heightRatio * 478
             y: 478 * pdf_PartList.visibleArea.yPosition
             Image
             {
                y: -parent.y
//                source: appUserManual.countryVariant == 4 ?  Images.const_AppUserManual_Scroll_Menu_ME : Images.const_AppUserManual_Scroll_Menu
                source: appUserManual.langId == 20 ?  Images.const_AppUserManual_Scroll_Menu_ME : Images.const_AppUserManual_Scroll_Menu
             }
             width: parent.width
             clip: true
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

    Timer {
        id: titleList_select_timer          // touch
        repeat: false
        interval: 150
        onTriggered: {
            appUserManual.getPageNumbers( listFocusId )
            if(appUserManual.langId != 20 ) {
                pdfList.item.setVisualCue( false, false )
                appUserManual.activateMenuPane( false )
                handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_PageNumList_FocusIndex )
            }
            if(appUserManual.langId == 20) {
                pdfList.item.setVisualCue( true , false )
                appUserManual.activateMenuPane( false )
                handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_PageNumList_FocusIndex )
            }
            appUserManual.setChapterFocusReset()
        }
    }

    Timer {
        id: menuSelectTimer     // jog

        repeat: false
        interval: 200
//        onTriggered: root.currentIndexChanged(list_view.currentIndex)
        onTriggered: appUserManual.getPageNumbers( listFocusId )
    }

    Timer{
        id:flickStartTimer
        interval: 5000; running: true; repeat: false
        onTriggered:{
            console.log("TitleLIstScreen.qml :: flickStartTimer onTriggered  ")
            console.log("TitleLIstScreen.qml :: flickStartTimer onTriggered - listFocusId : ", listFocusId )
            console.log("TitleLIstScreen.qml :: flickStartTimer onTriggered - pdf_PartList.currentIndex : ", pdf_PartList.currentIndex )
//            if(listFocusId != pdf_PartList.currentIndex)
//                return;
            changeListViewPosition(listFocusId);
        }
    }

    Component
    {
        id: listDelegate

        Rectangle
        {
            id: rectangle_Delegate
            width : Dimensions.const_AppUserManual_ListDelegate_Width
            height: Dimensions.const_AppUserManual_ListDelegate_Height
            color: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
            anchors.left:  parent.left // appUserManual.countryVariant == 4 ?  744 - 637 - 20 : 43
            anchors.leftMargin: appUserManual.langId == 20 ? 80 : 43
            z: 10
//            anchors.leftMargin: appUserManual.countryVariant == 4 ?  80 : 43

//            Image
//            {
//                source: Images.const_AppUserManual_BG_Menu_Tab_F
//                visible: listFocusId == index
//            }

            Image
            {
                id: focusImage
                anchors.left: parent.left
                anchors.leftMargin: -9
                anchors.top: line_id.top
                anchors.topMargin: -90
                width: 535
//                anchors.fill: parent
                source: centerPress ? Images.const_AppUserManual_BG_Menu_Tab_P : Images.const_AppUserManual_BG_Menu_Tab_F
//                source: focusImageMA.pressed ? Images.const_AppUserManual_BG_Menu_Tab_FP : Images.const_AppUserManual_BG_Menu_Tab_F
                visible: focus_visible && listFocusId === index  &&  titleListFocus && !optionMenu.focus_visible //&& focusImageMA.pressed

                Behavior on y
                {
                    SpringAnimation
                    {
                        spring: 2
                        damping: 0.2
                    }
                }

                Connections
                {
                    target: pdfTitleList

                    onFocusImageChange:
                    {
                        console.log("TitleLIstScreen.qml :: onFocusImageChange - focusChange: " , focusChange  )
                        if( focusChange === 0 ) titleListFocus = true
                        else titleListFocus = false
                    }
                }
            }
            Image
            {
                id: pressImage
                anchors.left: parent.left
                anchors.leftMargin: -9
                anchors.top: line_id.top
                anchors.topMargin: -90
                width: 535
//                anchors.fill: parent
                source:  Images.const_AppUserManual_BG_Menu_Tab_P
//                source: focusImageMA.pressed ? Images.const_AppUserManual_BG_Menu_Tab_FP : Images.const_AppUserManual_BG_Menu_Tab_F
                visible: focusImageMA.pressed  && !optionMenu.focus_visible //&& focusImageMA.pressed
            }


            DHAVN_AppUserManual_ScrollText {
                id: scrollingTicker
                anchors.left: parent.left
                anchors.leftMargin: 15
                height: 90
                width: 479
                scrollingTextMargin: 120        // 꼬리물기로 들어올 Text간 간격
                isScrolling: appUserManual.state == "pdfListView" && appUserManual.nowFG && focus_visible && listFocusId === index && titleListFocus // Focus 되었을 때, Scroll
                fontPointSize:  Dimensions.const_AppUserManual_Font_Size_40
                clip: true
                fontFamily: vehicleVariant == 1 ? (listFocusId === index && !focus_visible) ?  "KH_HDB" : "KH_HDR"
                            : (listFocusId === index && !focus_visible) ?  "DH_HDB" : "DH_HDR"
                fontColor: vehicleVariant == 1 ? listFocusId === index ? ( focus_visible ? Dimensions.const_AppUserManual_ListText_Color_BrightGrey
                                                                                                                            : Dimensions.const_AppUserManual_ListText_Color_Select)
                                                                                                : Dimensions.const_AppUserManual_ListText_Color_CommonGrey
                            : listFocusId === index && !focus_visible ?  Dimensions.const_AppUserManual_ListText_Color_Select
                                                                                    : Dimensions.const_AppUserManual_ListText_Color_BrightGrey
                text: leftListModel.get(index).titleLabel // titleLabel
                fontBold: listFocusId === index && !focus_visible
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
                id: focusImageMA
                anchors.fill: parent
                enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
                onPressed:
                {
                    console.log("TitleLIstScreen.qml :: MouseArea onPressed  ")
                }
                onReleased:
                {
                    if ( optionMenu.focus_visible ) return
                    console.log("TitleLIstScreen.qml :: MouseArea onReleased  ")
                    listFocusId = index;
                    titleList_select_timer.restart()       //appUserManual.getPageNumbers( index )
                }
            }
        }
    }

    ListModel
    {
        id: leftListModel
    }

    Connections
    {
        target: pdfTitleList

        onFocusImageMovement:
        {
            console.log("TitleLIstScreen.qml :: onFocusImageMovement")
            if( focusMove )
            {
                pdf_PartList.currentIndex = ++listFocusId
                appUserManual.getPageNumbers( listFocusId )
            }
            else
            {
                if( listFocusId >= 0 )
                {
                    pdf_PartList.currentIndex = --listFocusId
                    appUserManual.getPageNumbers( listFocusId )
                }
            }
        }
    }

    Connections
    {
        target: ( pdfTitleList.focus_visible && !optionMenu.focus_visible && !disable_popup.visible ) ? UIListener : null
        onSignalJogNavigation:
        {
            if ( appUserManual.lockoutMode ) return
            console.log("TitleListScreen.qml :: onSignalJogNavigation")
            switch( arrow )
            {
            case UIListenerEnum.JOG_CENTER:
            {
                if( status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
                    centerPress = true
//                    pdfList.item.setVisualCue(true)
//                    appUserManual.activateMenuPane( false )
//                    handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_PageNumList_FocusIndex )
                }
//                else if( status === UIListenerEnum.KEY_STATUS_CLICKED )
//                {
//                    pdfList.item.setVisualCue(false)
//                    appUserManual.activateMenuPane( false )
//                    handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_PageNumList_FocusIndex )
//                }
                else if ( status ==  UIListenerEnum.KEY_STATUS_RELEASED )
                {
                    pdfList.item.activateMenuPane( false )
//                    pdfList.item.setVisualCue(false)
//                    appUserManual.activateMenuPane( false )
                    /*if( centerPress )*/ {
                        if(appUserManual.langId != 20 ) {
//                        if(appUserManual.countryVariant != 4) {
                            pdfList.item.setVisualCue( false, false )
                        }
                        else {
                            pdfList.item.setVisualCue( true, false )
                        }
                        appUserManual.focusIndex = Dimensions.const_AppUserManual_PageNumList_FocusIndex
                        handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_PageNumList_FocusIndex )
                        centerPress = false
                    }
                }
                else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                    console.log("TitleListScreen.qml :: KEY_STATUS_CANCELED")
                    centerPress = false
                }
            }
                break;
            case UIListenerEnum.JOG_RIGHT:
            {
                if( status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
                    if(appUserManual.langId != 20 ) {
//                    if(appUserManual.countryVariant != 4) {
                        pdfList.item.setVisualCue( false, true )
                        appUserManual.activateMenuPane( false )
                        handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_PageNumList_FocusIndex )
                    }
                }
                else if( status === UIListenerEnum.KEY_STATUS_RELEASED )
                {
                    pdfList.item.setVisualCue( false, false )
//                    if( appUserManual.countryVariant != 4)
//                    {
//                        appUserManual.activateMenuPane( false )
//                        handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_PageNumList_FocusIndex )
//                    }
                }
            }
            break;
            case UIListenerEnum.JOG_LEFT:
            {
                if( status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
//                    if(appUserManual.countryVariant == 4) {
                    if(appUserManual.langId == 20) {
                        pdfList.item.setVisualCue( true , true )
                        appUserManual.activateMenuPane( false )
                        handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_PageNumList_FocusIndex )
                    }
                }
                else if( status === UIListenerEnum.KEY_STATUS_RELEASED )
                {
                    pdfList.item.setVisualCue( true , false )
//                    if( appUserManual.countryVariant == 4)
//                    {
//                        pdfList.item.setVisualCue( true , false )
////                        appUserManual.activateMenuPane( false )
////                        handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_PageNumList_FocusIndex )
//                    }
//                    else {
//                        pdfList.item.setVisualCue( true , false )
//                    }
                }
            }
            break;
            case UIListenerEnum.JOG_UP:
            {
                if( status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
                    console.log("TitleListScreen.qml :: jog_up pressed")
                    pdfList.item.updownSetVisualCue( true, true, false )
                }
                /*if( status == UIListenerEnum.KEY_STATUS_CLICKED)
                {
                    console.log("TitleListScreen.qml :: jog_up clicked")
//                    pdfList.item.updownSetVisualCue( true, true )
//                    pdfList.item.setVisualCuePressedMode( true )
//                    pdfList.item.setVisualCueMode(true)
                    handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_ModeArea_FocusIndex )
                    pdfTitleList.focusImageChange( 1 )
                }
                else*/ if( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
                {
                    console.log("TitleListScreen.qml :: jog_up long pressed")
                    up_long_press_timer.restart()
                }
                else if( status === UIListenerEnum.KEY_STATUS_RELEASED )
                {
                    console.log("TitleListScreen.qml :: jog_up released")
                    up_long_press_timer.stop()
                    if ( upLongPressed ) {
                        upLongPressed = false
                        pdfList.item.updownSetVisualCue( true, false, false )
                    }
                    else {
//                        pdfList.item.setVisualCuePressedMode( true )
//                        pdfList.item.setVisualCueMode(true)
                        pdfList.item.updownSetVisualCue( true, false, true)
                        handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_ModeArea_FocusIndex )
                        pdfTitleList.focusImageChange( 1 )
                    }
//                    pdf_PartList.currentIndex = listFocusId
//                    pdfList.item.setVisualCueMode(true)
//                    handleFocusChange( Dimensions.const_AppUserManual_TitleList_FocusIndex, Dimensions.const_AppUserManual_ModeArea_FocusIndex )
//                    pdfTitleList.focusImageChange( 1 )
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
                    console.log("TitleListScreen.qml :: jog_down pressed")
                    downLongPressed = true
                }
                if ( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
                {
                    console.log("TitleListScreen.qml :: jog_down long pressed")
                    down_long_press_timer.restart()
                }
                if ( status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                    console.log("TitleListScreen.qml :: jog_down released")
                    downLongPressed = false
                    down_long_press_timer.stop()
                    down_long_press_timer.interval = 100
                    pdfList.item.updownSetVisualCue( false , false, true )
                }
                if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                    console.log("TitleListScreen.qml :: jog_down KEY_STATUS_CANCELED")
                    down_long_press_timer.stop()
                    downLongPressed = false
                    pdfList.item.updownSetVisualCue( false , false, true )
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
                            pdf_PartList.currentIndex = --listFocusId
                        }
                        else {
                            listFocusId = pdf_PartList.count-1
                            pdf_PartList.currentIndex = listFocusId
                        }
                    }
                    else {
                        if( listFocusId != ( titleCount - 1 ) )
                        {
                            pdf_PartList.currentIndex = ++listFocusId
                        }
                        else {
                            listFocusId = 0
                            pdf_PartList.currentIndex = listFocusId
                        }
                    }
                    setJogFocusPosition()
                    menuSelectTimer.restart();
                }
            }
                break;
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
                if( status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
                    if ( appUserManual.langId != 20 ) {
                        if( listFocusId != ( titleCount - 1 ) )
                        {
                            pdf_PartList.currentIndex = ++listFocusId
                        }
                        else {
                            listFocusId = 0
                            pdf_PartList.currentIndex = listFocusId
                        }
                    }
                    else {
                        if( listFocusId > 0 )
                        {
                            pdf_PartList.currentIndex = --listFocusId
                        }
                        else {
                            listFocusId = pdf_PartList.count-1
                            pdf_PartList.currentIndex = listFocusId
                        }
                    }
                    setJogFocusPosition()
                    menuSelectTimer.restart();
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

