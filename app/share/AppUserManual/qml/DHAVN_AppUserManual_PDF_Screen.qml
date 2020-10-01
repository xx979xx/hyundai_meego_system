import Qt 4.7
import Qt.labs.gestures 2.0
import QmlModeAreaWidget 1.0
import AppUserManual_PDFController 1.0
import AppEngineQMLConstants 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0

import "DHAVN_AppUserManual_Dimensions.js" as Dimensions
import "DHAVN_AppUserManual_Images.js" as Images

Item
{
    id: appUserManualPdfScreen

    width: Dimensions.const_AppUserManual_MainScreenWidth
    height: Dimensions.const_AppUserManual_MainScreen_Height

    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property int focus_id: Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
    property bool focus_visible: appUserManual.state == "pdfScreenView" && !toast_popUp.visible && !searchEndPopUp.visible && !disable_popup.visible && !systemPopupVisible && appUserManual.focusIndex == focus_id
//    property int totalPagesPresent: 0
    property int defaultPageWidth: 1046
    property int wheel_focusIndex:  Dimensions.const_AppUserManual_Cue_Focus_Wheel
    property int cue_focusIndex: Dimensions.const_AppUserManual_Cue_Focus_VisualCue
    property int cue_tempFocusIndex: -1
    property int dragWidgetX: 0
    property int dragWidgetY: 0
    property bool numericVisible: false
    property bool numericCenter: false
    property int nextprevCnt: 0
    property bool jogPressed: false
    property bool jogCenterPressed: false
    property bool maxZoom: false
    property int tmpInt: 0
    property string txt_searchOkText: qsTranslate( "main", "STR_MANUAL_OK" )
    property string txt_searchEnd: qsTranslate( "main", "STR_MANUAL_SEARCH_END" )
    property bool backSearchMAPress: false
    property bool backSearchMAExit: false
    property bool nextSearchMAPress: false
    property bool nextSearchMAExit: false
    property bool previousMAPress: false
    property bool previousMAExit: false
    property bool nextMAPress: false
    property bool nextMAExit: false
    property bool visualCueMApressed: false
    property bool searchForward: true
    property bool tmpSearchEndPopUp: false
    property bool tmpWarningPopUp: false

    signal handleFocusChange( int fromFocusIndex, int toFocusIndex )

    Rectangle {
        x: 0;y:0
        width: Dimensions.const_AppUserManual_MainScreenWidth
        height: Dimensions.const_AppUserManual_MainScreen_Height
        color: "black"
        PdfViewerItem
        {
            id: pdfController
        }
    }

    function __LOG( logText )
    {
        console.log( "PDF_Screen.qml" + logText )
    }
    
    function stopAnimation()
    {
        timerPressedAndHold.running = false
    }

    function setLanguage()      // 언어 변경, pdf 변경
    {
        __LOG(" :: setLanguage()")
        pdfController.setLanguage( appUserManual.langId );
    }

    function resetSearchPage()
    {
        __LOG(" :: resetSearchPage()")
        pdfController.resetSearchPage()
    }

    // 언어 변경 return 팝업 출력 시
    function showDisablePopup()
    {
        __LOG(" :: showDisablePopup()  ")
        
        // search end reset
        searchEndPopUp.visible = false
        appUserManual.searchText = ""
        appUserManual.searchOKTextEnable( false )

        // goto reset
        pagePopUp.visible = false
        appUserManual.pageNumberEntered = ""

        // toast popup
        toast_popUp.visible = false
    }

    function threadQuit()
    {
        __LOG(" :: threadQuit()  ")
        pdfController.threadQuit();
    }

    function setTouchLock( lock )
    {
        console.log( "PDF_Screen.qml :: setTouchLock() : " , lock )
        pdfController.setTouchLock(lock);
    }

    function setFG(hasFocus)
    {
        __LOG(" :: setFG()  ")
        clearTouch()
        cue_focusIndex = (hasFocus)? Dimensions.const_AppUserManual_Cue_Focus_VisualCue : -1
        numeric_KeyPad.setFG()
        timerPressedAndHold.running = false
    }

    function clearTouch()
    {
        jogCenterPressed = false
        backSearchMAPress =  false
        nextSearchMAPress = false
        previousMAPress = false
        nextMAPress = false
        visualCueMApressed = false
    }

    function setDRSPopup()      // not used... 주행규제 시 pdf 화면 항상 초기화
    {
        __LOG(" :: setDRSPopup()  ")
        if ( searchEndPopUp.visible ) {
            searchEndPopUp.visible = false
            tmpSearchEndPopUp = true
        }
        if ( pagePopUp.visible ) {
            __LOG(" :: setDRSPopup() - pagePopUp ")
            pagePopUp.visible = false
            tmpWarningPopUp = true
        }
    }

    function getPagePopUp()
    {
        __LOG(" :: getPagePopUp()  ")
        return pagePopUp.visible
    }

    function resetDRSPopup()      // not used... 주행규제 시 pdf 화면 항상 초기화
    {
        __LOG(" :: resetDRSPopup()  ")
        if ( tmpSearchEndPopUp ) {
            searchEndPopUp.visible = true
            tmpSearchEndPopUp = false
        }
        if ( tmpWarningPopUp ) {
            pagePopUp.visible = true
            tmpWarningPopUp = false
        }
    }

    function lostFocus( focus )
    {
        __LOG(" :: lostFocus() : " , focus )
        if ( focus )  cue_focusIndex =  -1
        else  cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
    }

    function clearPdfScreen()
    {
        __LOG(" :: clearPdfScreen()  ")
        jogCenterPressed = false
        visualCueMApressed = false
        searchEndPopUp.visible = false
        pagePopUp.visible = false
        toast_popUp.visible = false
        tmpSearchEndPopUp = false
        tmpWarningPopUp = false
        pdfController.clearZoomStatus()
        pdfController.exitSearch()
        timerPressedAndHold.running = false
        minZoom = true
        maxZoom = false
        cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
    }

    function retranslateUI()
    {
        txt_searchOkText = qsTranslate( "main", "STR_MANUAL_OK" )
        txt_searchEnd = qsTranslate( "main", "STR_MANUAL_SEARCH_END" )
    }
    
    function setPopupVisible ( visible )
    {
        if ( visible )
        {
            __LOG(" :: setPopupVisible() true ")
            pagePopUp.visible = true
            cue_focusIndex = -1
        }
        else
        {
            __LOG(" :: setPopupVisible() false ")
            pagePopUp.visible = false
            cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
        }
    }

    function setNumericKeyPad( visible )
    {
        pdfScreenPinchArea.visible = !visible
        numericVisible = visible
        if ( visible )
        {
            __LOG(" :: setNumericKeyPad() true ")
            numeric_KeyPad.y = Dimensions.const_AppUserManual_NumericKeyPad_Y
        }
        else
        {
            __LOG(" :: setNumericKeyPad() false ")
            numeric_KeyPad.y = Dimensions.const_AppUserManual_NumericKeyPad_Y + 300
        }
        pdfController.setNumericKeypad(numericVisible)
    }

    function getNumericVisible()
    {
        return numericVisible
    }

    function updateTitle()
    {
        __LOG(" :: updateTitle()")
        pdfController.updateTitle()
    }

    function updatePageNumbers()
    {
        __LOG(" :: updatePageNumbers()")
        pdfController.updatePageNumbers()
    }

    function getTOC()
    {
        __LOG(" :: getTOC()")
        pdfController.getTOC()
    }

    function nextPrevPage( next )
    {
        __LOG(" ::  nextPrevPage(  ) next : ", next)
        if ( !numericVisible ) {
            if ( next )
                pdfController.showNextPage()
            else
                pdfController.showPrevPage()
        }
        appUserManual.minZoom = true
    }

    function nextPrevSearch(next)
    {
        toast_popUp.visible = true;
        searchForward = next;
        searchStart_timer.restart()
    }

    function launchKeyPad()
    {
        __LOG(" :: launchKeyPad()")
        stopTimer()
        appUserManual.pageNumberEntered = ""
        pdfVisualCueControls.y = ( Dimensions.const_AppUserManual_VisualCue_Y + 300 )
        showKeyPad( true )
//        appUserManual.setGotoPageBox( true )
//        setNumericKeyPad( true )
        //numeric_KeyPad.y = Dimensions.const_AppUserManual_NumericKeyPad_Y
    }

    function launchMenu()
    {
        __LOG(" :: launchMenu()")
        stopTimer()
        pdfVisualCueControls.y = Dimensions.const_AppUserManual_VisualCue_Y
        timerPressedAndHold.running = false
    }

    function showKeyPad( state)
    {
        __LOG(" :: showKeyPad()")
        setGotoPageBox( state )
//        numeric_KeyPad.y = ( Dimensions.const_AppUserManual_NumericKeyPad_Y + 300 )
        setNumericKeyPad( state )
    }

    function btManual()
    {
        __LOG(" :: btManual()")
        pdfController.gotoPage( appUserManual.btPage )
        appUserManual.setFullScreen( false )
    }

    function vrManual()
    {
        __LOG(" :: vrManual()")
        pdfController.gotoPage( appUserManual.vrPage )
        appUserManual.setFullScreen( false )
    }

    function gotoPageTemporalMode( page )
    {
        __LOG(" :: gotoPageTemporalMode() - page : " , page )
        pdfController.gotoPage( page )
        appUserManual.setFullScreen( false )
        if ( searchEndPopUp.visible || pagePopUp.visible || toast_popUp.visible ) stopTimer()
        if ( appUserManual.focusIndex ==  Dimensions.const_AppUserManual_ModeArea_FocusIndex ) cue_focusIndex = -1
    }

    function gotoPageNumber()
    {
        __LOG(" :: gotoPageNumber() - appUserManual.pageNumberEntered : " , appUserManual.pageNumberEntered )
        if( appUserManual.pageNumberEntered == 0 || appUserManual.pageNumberEntered > appUserManual.totalPage )
        {
            stopTimer()
            pagePopUp.visible = true
            cue_focusIndex = -1
            numeric_KeyPad.setKeyboardFocus( false )
        }
        else
        {
            showKeyPad( false )
            pdfVisualCueControls.y = Dimensions.const_AppUserManual_VisualCue_Y
            pdfController.gotoPage( appUserManual.pageNumberEntered )
            appUserManual.showPageNumbers( appUserManual.pageNumberEntered)
//            pdfController.updatePageNumbers()
            appUserManual.setFullScreen( false )
            cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
        }
        EngineListener.savePage(curPage)
    }

    function getPageNumbers( indexPN )      // 좌측 선택한 index에 해당하는 우측 contents 목록 요청
    {
        __LOG(" :: getPageNumbers(  ) indexPN : ", indexPN)
        console.log( "getPageNumber for the Index value" + indexPN )
        pdfController.getPageNumbers( indexPN )
    }

    function gotoPageNum( pageNum )     // content 목록의 index 전달
    {
        __LOG(" ::  gotoPageNum(  )  pageNum : ", pageNum)
        pdfController.gotoPageNum( pageNum )
    }

    function optionMenuBack()
    {
        __LOG(" :: optionMenuBack()" )
        cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
        startTimer()
    }

    function setFocus( modeArea )
    {
        if ( modeArea )
        {
            __LOG(" :: setFocus(  ) :: modeArea " )
            cue_focusIndex = -1
            handleFocusChange( Dimensions.const_AppUserManual_PDF_Screen_FocusIndex, Dimensions.const_AppUserManual_ModeArea_FocusIndex )
        }
        else
        {
            if ( numericVisible ) {
                numeric_KeyPad.setKeyboardFocus( true )
                return;
            }
            __LOG(" :: setFocus(  ) :: visual cue " )
//            handleFocusChange( Dimensions.const_AppUserManual_ModeArea_FocusIndex , Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
            cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
        }
    }

    function setFocusCue( imageSource )
    {
        __LOG(" :: setFocusCue(  )  imageSource : ", imageSource)
        if(imageSource)
            visualCue.source = Images.const_AppUserManual_Cue_F
        else
            visualCue.source = Images.const_AppUserManual_Cue_N
    }

    function searchString( searchText , bFirst )
    {
        __LOG(" ::  searchString(  )  searchText : ", searchText , " , bFirst : " , bFirst )
        pdfController.searchForward( searchText , bFirst )
    }

    function checkSearching()
    {
        __LOG(" ::  checkSearching() "  )
        if ( pdfController.checkSearching() ) {
            return true;
        }
        return false;
    }

    function input ( label )
    {
        __LOG(" ::  input (  )   label  : ", label)
        if ( appUserManual.pageNumberEntered.length > 2 ) return;
//        if ( text_input.cursorPosition > 2)
//            return;
        var selectStart = text_input.cursorPosition
        var selectEnd = text_input.cursorPosition

        if( text_input.selectedText )
        {
            selectEnd = text_input.selectionEnd
            selectionStart = text_input.selectionStart
            text_input.cursor_pos = selectStart
            text_input.select( 0, 0 )
        }

        text_input.cursor_pos = text_input.cursorPosition + 1

        /** our search string = */
        appUserManual.pageNumberEntered = text_input.text.substring( 0, selectStart ) + label + text_input.text.substring( selectEnd );

    }

    function startTimer()
    {
        __LOG(" :: startTimer")
        if ( optionMenu.focus_visible ) return;
        if ( appUserManual.state == "pdfScreenView" )
            fullScreenTimer.restart()
    }

    function stopTimer()
    {
        __LOG(" :: stopTimer")
        fullScreenTimer.stop()
    }

    function clearSearchLocation()
    {
        __LOG(" :: clearSearchLocation ")
        pdfController.clearSearchLocation()
    }

    function tapScreen()
    {
        console.log("PDF_Screen.qml :: tapScreen");
        if ( appUserManual.mainFullScreen )
        {
//            fullScreen( false )
//            EngineListener.setFullScreen( false, UIListener.getCurrentScreen() )
           appUserManual.setFullScreen( false )
        }
        else
        {
//            fullScreen( true )
//            EngineListener.setFullScreen( true, UIListener.getCurrentScreen() )
           appUserManual.setFullScreen( true )
        }
    }

    function sendToControllerFullScreen( fullScreen )
    {
        console.log("PDF_Screen.qml :: sendToControllerFullScreen - fullScreen: " , fullScreen);
        pdfController.isFullScreen( fullScreen )
    }

    function fullScreen( value )
    {
        __LOG(" :: fullScreen")
        if ( appUserManual.state != "pdfScreenView") {
            return
        }
        if( value )
        {
            fullScreenTimer.stop()
            pdfVisualCueControls.y = (Dimensions.const_AppUserManual_VisualCue_Y+300)
            if( numericVisible )
            {
                showKeyPad( false )
            }
        }
        else
        {
            timerPressedAndHold.running = false
            if ( !pagePopUp.visible ) startTimer()
            cue_focusIndex = numericVisible ? -1 : Dimensions.const_AppUserManual_Cue_Focus_VisualCue
            if( !numericVisible )
                pdfVisualCueControls.y = Dimensions.const_AppUserManual_VisualCue_Y
        }
        appUserManual.focusIndex = focus_id
    }

    function dragWidget( deltaX, deltaY )
    {
        __LOG(" :: dragWidget( deltaX, deltaY ) : ", deltaX, deltaY )
        if( !numericVisible )
//        if( numeric_KeyPad.y != Dimensions.const_AppUserManual_NumericKeyPad_Y )
            pdfController.dragWidgetJog( deltaX, deltaY )
    }

    function zoomWidget( zoomCnt )
    {
        __LOG(" :: zoomWidget(  ) zoomCnt : ", zoomCnt)

        if ( cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Left || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Right ) {
            __LOG(" :: zoomWidget() cue_focusIndex is left of right cue")
            return;
        }
        // 원본 사이즈에서 wheel_left(축소) 동작 시 확대/축소 동작 안함
        if ( minZoom && zoomCnt < 0 ) {
            appUserManual.minZoom = true
            return;
        }
//        if ( !appUserManual.zoomEnable && !zoomIn) {
//            return;
//        }

        if( !numericVisible )
//        if( numeric_KeyPad.y != Dimensions.const_AppUserManual_NumericKeyPad_Y )
        {
            tmpInt = pdfController.zoomWidget( zoomCnt )
            switch ( tmpInt )
            {
                case 1:{
                    maxZoom = true
                    minZoom = false
                    appUserManual.minZoom = false
                    break;
                }
                case 2: {
                    maxZoom = false
                    minZoom = true
                    appUserManual.minZoom = true
                    timerPressedAndHold.running = false
                    break;
                }
                case 0:
                default:
                {
                    maxZoom = false
                    minZoom = false
                    appUserManual.minZoom = false
                    break;
                }
            }
        }
    }

    function pinchZoomWidget( scale )
    {
        __LOG(" :: pinchZoomWidget(  ) - scale :  ", scale )
        EngineListener.logForQML("pinchZoomWidget")
        pdfController.pinchZoomWidget( scale )
    }

    function getMinZoom()
    {
        __LOG(" :: getMinZoom(  ) - minZoom :  ", minZoom )
        return minZoom
    }

    function doubleTapZoom(  )
    {
        __LOG(" :: doubleTapZoom(  ) " )
        if( !numericVisible ) {
//        if( numeric_KeyPad.y != Dimensions.const_AppUserManual_NumericKeyPad_Y )
            pdfController.doubleTapZoom(  )
            minZoom = false
            maxZoom = false
        }
    }

    function numericKeypagYCoord()
    {
        __LOG(" :: numericKeypagYCoord")
        return numeric_KeyPad.y
    }

    function exitZoom()
    {
        __LOG(" :: exitZoom")
        pdfController.clearZoomStatus()
        pdfController.exitZoom()
        minZoom = true
        maxZoom = false
    }

//    function searchPDF( searchPDFTitle )
//    {
//        __LOG(" :: searchPDF(  )   searchPDFTitle : ", searchPDFTitle)
//        pdfController.searchPDF( searchPDFTitle )
//    }

    function setKeyboardFocus( visible )
    {
        __LOG(" :: setKeyboardFocus")
        numeric_KeyPad.setKeyboardFocus( visible )
    }


    DHAVN_AppUserManual_NumericKeyPad
    {
        id: numeric_KeyPad
        x: Dimensions.const_AppUserManual_SearchBox_X
        y: Dimensions.const_AppUserManual_NumericKeyPad_Y + 300
        z: Dimensions.const_AppUserManual_Z_2

        visible: true

        onDisplayText:
        {
            input( text )
        }

        onGotoPage:
        {
            appUserManual.setFullScreen( false )
            if( appUserManual.pageNumberEntered.length != 0 ) gotoPageNumber()
//            numeric_KeyPad.y = Dimensions.const_AppUserManual_NumericKeyPad_Y + 300
//            appUserManual.setGotoPageBox( false )
//            setNumericKeyPad( false )
        }

        onDeletePageNumber:
        {
            console.log("SearchView.qml :: onDeletePageNumber")
            var length =  appUserManual.pageNumberEntered.length
            appUserManual.pageNumberEntered = text_input.text.substring( 0, length-1)
        }

//        onSetFocus:
//        {
//            console.log("PDF_Screen.qml :: onSetFocus - focusIndex: "  ,  appUserManual.focusIndex )
//            if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
//                console.log("PDF_Screen.qml :: onSetFocus")
//                setFocus( false );
//                handleFocusChange( Dimensions.const_AppUserManual_ModeArea_FocusIndex, Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
//            }
//        }
    }

    Item
    {
        id: pdfVisualCueControls
        x: Dimensions.const_AppUserManual_Prev_X - 40       // 터치감도 개선을 위해 터치 영역 40 확대
        y: Dimensions.const_AppUserManual_VisualCue_Y
        width: Dimensions.const_AppUserManual_PDFControls_Width + 40 + 40
        height: Dimensions.const_AppUserManual_PDFControls_Height
        visible: true
        
        Image
        {
            id: visualCue
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.centerIn: parent.Center
            z: Dimensions.const_AppUserManual_Z_1
            smooth: true
//            source: ( visualCueFocus == Dimensions.const_AppUserManual_VisualCue_FocusIndex && cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_VisualCue) ? Images.const_AppUserManual_Cue_F : Images.const_AppUserManual_Cue_N
            source: ( cue_focusIndex != -1 && focus_visible) ? Images.const_AppUserManual_Cue_F : Images.const_AppUserManual_Cue_N
            visible: true

            MouseArea
            {
                id: visualCueMA
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" &&  !appUserManual.lockoutMode && !appUserManual.touchLock

                onPressed:
                {
                    console.log("PDF_Screen.qml :: visualCueMA onPressed ")
                    visualCueMApressed = true
                    pdfScreenPinchArea.visible = false
                    stopTimer()
                }
                onExited:
                {
                    visualCueMApressed = false
                }
                onReleased:
                {
                    startTimer()
                }
                onClicked:
                {
                    if ( optionMenu.focus_visible ) return;
                    console.log("PDF_Screen.qml :: visualCueMA onReleased ")
                    pdfScreenPinchArea.visible = true
                    appUserManual.touchBtn = true
                    startTimer()
                    if ( appUserManual.okTextEnable ) {
                        if ( searchOkText.visible ) {       // "OK" text가 보이는 상태 > 검색 종료
                            console.log("PDF_Screen.qml :: visualCueMA - okTextEnable")
                            appUserManual.searchText = ""
                            appUserManual.searchOKTextEnable( false )
                            pdfController.clearSearchLocation()
                            appUserManual.setFullScreen( false )
                            appUserManual.exitSearch()
                        }
                        else {          // "OK" text가 보이지 않는다 = 확대 상태   > full screen 해제
                            appUserManual.setFullScreen( false )
                        }
                    }
//                    else if( !minZoom ) // appUserManual.zoomEnable )
//                    {
//                        console.log("PDF_Screen.qml :: searchOkText 2")
//                        appUserManual.exitZoom()
//                    }
                    else {
                        if ( cue_focusIndex != Dimensions.const_AppUserManual_Cue_Focus_VisualCue ) {
                            setFocus( false );
                            handleFocusChange( Dimensions.const_AppUserManual_ModeArea_FocusIndex, Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
                        }
                        if ( appUserManual.mainFullScreen ) appUserManual.setFullScreen( false )
                        else appUserManual.setFullScreen( true )
                        if ( !minZoom ) fullScreen(false)
                    }
                }
            }

            Image
            {
                id: visualCuePress
                anchors.fill: parent
                source: Images.const_AppUserManual_Cue_P
                visible: !optionMenu.focus_visible && ( visualCueMApressed || (cue_focusIndex ==Dimensions.const_AppUserManual_Cue_Focus_VisualCue && jogCenterPressed ) )
            }

            Image
            {
                id: leftZoom
                anchors.top: parent.top
                anchors.topMargin: Dimensions.const_AppUserManual_LeftZoom_TopMargin
                anchors.left: parent.left
                anchors.leftMargin: Dimensions.const_AppUserManual_LeftZoom_LeftMargin
                smooth: true
                visible: !appUserManual.okTextEnable || ( appUserManual.okTextEnable && topDrag.visible )
//                visible: !minZoom || !appUserManual.okTextEnable
                source: minZoom ?  Images.const_AppUserManual_Zoom_L_N : Images.const_AppUserManual_Zoom_L_F
//                source: leftZoomMA.pressed ||  (  wheel_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Wheel_Left) ? Images.const_AppUserManual_Zoom_L_F : Images.const_AppUserManual_Zoom_L_N
                //source: leftZoomMA.pressed ||  ( appUserManual.zoomEnable && wheel_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Wheel_Left) ? Images.const_AppUserManual_Zoom_L_F : Images.const_AppUserManual_Zoom_L_N
            }

            Image
            {
                id:rightZoom
                anchors.top: parent.top
                anchors.topMargin: Dimensions.const_AppUserManual_LeftZoom_TopMargin
                anchors.right: parent.right
                anchors.rightMargin: Dimensions.const_AppUserManual_LeftZoom_LeftMargin
                smooth: true
                visible: !appUserManual.okTextEnable || ( appUserManual.okTextEnable && topDrag.visible )
                source: maxZoom ?  Images.const_AppUserManual_Zoom_R_N : Images.const_AppUserManual_Zoom_R_F // appUserManual.zoomEnable ?  Images.const_AppUserManual_Zoom_R_F : Images.const_AppUserManual_Zoom_R_N
//                source: rightZoomMA.pressed || (  wheel_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Wheel_Right ) ? Images.const_AppUserManual_Zoom_R_F : Images.const_AppUserManual_Zoom_R_N
                //source: rightZoomMA.pressed || ( appUserManual.zoomEnable &&  wheel_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Wheel_Right ) ? Images.const_AppUserManual_Zoom_R_F : Images.const_AppUserManual_Zoom_R_N
            }

            Text
            {
                id: searchOkText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: txt_searchOkText // qsTranslate( "main", "STR_MANUAL_OK" )
                font.pixelSize: 32
                font.family: vehicleVariant == 1 ? "KH_HDB" : "DH_HDB"
                color: Dimensions.const_AppUserManual_ListText_Color_BrightGrey
                visible: appUserManual.okTextEnable && ( minZoom || !topDrag.visible )

//                MouseArea
//                {
//                    id: searchOkTextMA
//                    anchors.fill: parent
//                    enabled: appUserManual.state == "pdfScreenView" &&  !appUserManual.lockoutMode && !appUserManual.touchLock
//
//    //                onClicked:
//                    onPressed:
//                    {
//                        pdfScreenPinchArea.visible = false
//                        stopTimer()
//                    }
//                    onReleased:
//                    {
//                        if ( optionMenu.focus_visible ) return;
//                        console.log("PDF_Screen.qml :: searchOkText")
//                        pdfScreenPinchArea.visible = true
//                        appUserManual.touchBtn = true
//                        startTimer()
//                        if( minZoom ) // appUserManual.okTextEnable )
//                        {
//                            console.log("PDF_Screen.qml :: searchOkText - minZoom")
//                            appUserManual.searchText = ""
//                            appUserManual.searchOKTextEnable( false )
//                            pdfController.clearSearchLocation()
//                            appUserManual.setFullScreen( false )
//                            appUserManual.exitSearch()
//                        }
//                        else if( !minZoom ) //  appUserManual.zoomEnable )
//                        {
//                            console.log("PDF_Screen.qml :: searchOkText - !minZoom")
//                            appUserManual.exitZoom()
//                        }
//                    }
//                }
            }
        }
        Rectangle //Image
        {
            id: previous
            anchors.left: parent.left
            anchors.top: parent.top
            width: 90+40+20; height: 81+40+40
//            anchors.topMargin: 41
            z: Dimensions.const_AppUserManual_Z_1
            color: "transparent"
            smooth: true
            visible: !appUserManual.okTextEnable && ( minZoom || !appUserManual.mainFullScreen )  //  !appUserManual.zoomEnable

            Image
            {
                anchors.left: parent.left; anchors.leftMargin: 40
                anchors.top: parent.top; anchors.topMargin: 40
                source: ( !optionMenu.focus_visible && previousMAPress && !previousMAExit ) || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Left ? Images.const_AppUserManual_Prev_F : Images.const_AppUserManual_Prev_N
            }
            MouseArea
            {
                id: previousMA
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" &&  !appUserManual.lockoutMode && !appUserManual.touchLock

//                onClicked:
                onPressed:
                {
                    __LOG(" :: previousMA.pressed")
                    doubleTap_timer.running = false
                    doubleTap_timer.stop()
                    pdfScreenPinchArea.visible = false
                    stopTimer()
                    previousMAPress = true
                    previousMAExit = false
                    if ( cue_focusIndex != Dimensions.const_AppUserManual_Cue_Focus_VisualCue ) {
                        setFocus( false );
                        handleFocusChange( Dimensions.const_AppUserManual_ModeArea_FocusIndex, Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
                    }
                }
                onReleased:
                {
                    if ( optionMenu.focus_visible )  {
                        previousMAPress = false
                        return;
                    }
                    console.log("PDF_Screen.qml :: previous")
                    pdfScreenPinchArea.visible = true
                    appUserManual.touchBtn = true
                    previousMAPress = false
                    startTimer()
                    if ( !previousMAExit ) {
//                        pdfController.showPrevPageThread()
                        nextprevCnt--
                        nextprevTimer.restart()
                    }
                }
                onExited: {
                    previousMAExit = true
                }
            }
        }

        Rectangle //Image
        {
            id: next
            anchors.right: parent.right
            anchors.top: parent.top
            width: 90+40+20; height: 81+40+40
//            anchors.topMargin: 41
            z: Dimensions.const_AppUserManual_Z_1
            color: "transparent"
            smooth: true
            visible: previous.visible // !appUserManual.okTextEnable && ( minZoom || !appUserManual.mainFullScreen )  //  !appUserManual.zoomEnable

            Image
            {
                anchors.right: parent.right; anchors.rightMargin: 40
                anchors.top: parent.top; anchors.topMargin: 40
                source: ( !optionMenu.focus_visible && nextMAPress && !nextMAExit ) ||  cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Right ? Images.const_AppUserManual_Next_F : Images.const_AppUserManual_Next_N
            }

            MouseArea
            {
                id: nextMA
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" &&  !appUserManual.lockoutMode && !appUserManual.touchLock

//                onClicked:
                onPressed:
                {
                    __LOG(" :: nextMA.pressed")
                    doubleTap_timer.running = false
                    doubleTap_timer.stop()
                    pdfScreenPinchArea.visible = false
                    stopTimer()
                    nextMAPress = true
                    nextMAExit = false
                    if ( cue_focusIndex != Dimensions.const_AppUserManual_Cue_Focus_VisualCue ) {
                        setFocus( false );
                        handleFocusChange( Dimensions.const_AppUserManual_ModeArea_FocusIndex, Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
                    }
                }

                onReleased:
                {
                    if ( optionMenu.focus_visible )  {
                        nextMAPress = false
                        return;
                    }
                    __LOG(" :: nextMA.released")
                    pdfScreenPinchArea.visible = true
                    appUserManual.touchBtn = true
                    console.log("PDF_Screen.qml :: next")
                    nextMAPress = false
                    startTimer()
                    if ( !nextMAExit ) {
//                        pdfController.showNextPageThread()
                        nextprevCnt++
                        nextprevTimer.restart()
                    }
                }
                onExited: {
                    __LOG(" :: nextMA.exited")
                    nextMAExit = true
                }
            }
        }
        
        Image
        {
            id: backSearch
            anchors.left: parent.left
            anchors.leftMargin: 41 + 40
            anchors.top: parent.top
            anchors.topMargin: 41
            z: Dimensions.const_AppUserManual_Z_1
            smooth: true
            source: (!optionMenu.focus_visible && backSearchMAPress && !backSearchMAExit) || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Left ? Images.const_AppUserManual_Icon_Prev_Search_P : Images.const_AppUserManual_Icon_Prev_Search_N
            visible: appUserManual.okTextEnable && !topDrag.visible

            MouseArea
            {
                id: backSearchMA
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" &&  !appUserManual.lockoutMode && !appUserManual.touchLock
                onPressed:
                {
                    handleFocusChange(Dimensions.const_AppUserManual_ModeArea_FocusIndex,Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
                    doubleTap_timer.running = false
                    doubleTap_timer.stop()
                    pdfScreenPinchArea.visible = false
                    stopTimer()
                    backSearchMAPress = true
                    backSearchMAExit = false
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
                }
                onReleased:
                {
                    if ( optionMenu.focus_visible ) {
                        backSearchMAPress = false
                        return;
                    }
                    pdfScreenPinchArea.visible = true
                    appUserManual.touchBtn = true
                    backSearchMAPress = false
                    appUserManual.exitZoom()
//                    startTimer()
                    if( !backSearchMAExit && appUserManual.searchText.length != 0 ) {
                        toast_popUp.visible = true;
                        searchForward = false
                        searchStart_timer.restart()
//                        pdfController.searchBackward( appUserManual.searchText  , false )
                    }
                }
                onExited: {
                    backSearchMAExit = true
                }
            }
        }

        Image
        {
            id: nextSearch
            anchors.right: parent.right
            anchors.rightMargin: 41 + 40
            anchors.top: parent.top
            anchors.topMargin: 41
            z: Dimensions.const_AppUserManual_Z_1
            smooth: true
            source: (!optionMenu.focus_visible && nextSearchMAPress && !nextSearchMAExit ) || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Right ? Images.const_AppUserManual_Icon_Next_Search_P : Images.const_AppUserManual_Icon_Next_Search_N
            visible: appUserManual.okTextEnable && !topDrag.visible

            MouseArea
            {
                id: nextSearchMA
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" &&  !appUserManual.lockoutMode && !appUserManual.touchLock
                onPressed:
                {
                    handleFocusChange(Dimensions.const_AppUserManual_ModeArea_FocusIndex,Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
                    doubleTap_timer.running = false
                    doubleTap_timer.stop()
                    pdfScreenPinchArea.visible = false
                    stopTimer()
                    nextSearchMAPress = true
                    nextSearchMAExit = false
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
                }

                onReleased:
                {
                    if ( optionMenu.focus_visible )
                    {
                        nextSearchMAPress = false
                        return;
                    }
                    console.log(" PDF_Screen.qml :: nextSearch")
                    pdfScreenPinchArea.visible = true
                    console.log(" PDF_Screen.qml :: nextSearch - string length : ", appUserManual.searchText.length)
                    appUserManual.touchBtn = true
                    nextSearchMAPress = false
                    appUserManual.exitZoom()
//                    startTimer()
                    if( !nextSearchMAExit && appUserManual.searchText.length != 0 ) {
                        toast_popUp.visible = true;
                        searchForward = true
                        searchStart_timer.restart()
                        //searchString( appUserManual.searchText , false );
                    }
                }
                onExited: {
                    nextSearchMAExit = true
                }
            }
        }

        Image
        {
            id: topDrag
//            x: 497+101; y: 403
            anchors.top: parent.top
            anchors.topMargin: -41
            anchors.left: parent.left
            anchors.leftMargin: 130 + 40
            z: Dimensions.const_AppUserManual_Z_1
            smooth: true
            source: (!optionMenu.focus_visible && topDragMA.pressed ) || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Up || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Top_Right || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Top_Left
                ? Images.const_AppUserManual_Icon_Top_Drag_F : Images.const_AppUserManual_Icon_Top_Drag_N
            visible: !minZoom && appUserManual.mainFullScreen //  appUserManual.zoomEnable

            MouseArea
            {
                id: topDragMA
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" &&  !appUserManual.lockoutMode && !appUserManual.touchLock

//                onClicked:
                onPressed:
                {
                    console.log("PDFScreen.qml :: topDrag onPressed")
                    doubleTap_timer.running = false
                    doubleTap_timer.stop()
                    pdfScreenPinchArea.visible = false
                    stopTimer()
                    timerPressedAndHold.running = true
                    dragWidgetX = 0
                    dragWidgetY = 10
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
                }

                onReleased:
                {
                    timerPressedAndHold.running = false
                    if ( optionMenu.focus_visible ) return;
                    console.log("PDFScreen.qml :: topDrag onReleased")
                    pdfScreenPinchArea.visible = true
                    appUserManual.touchBtn = true
                    startTimer()
                }

                onExited:
                {
                    console.log("PDFScreen.qml :: topDrag onExited")
                    pdfScreenPinchArea.visible = true
                    appUserManual.touchBtn = true
                    startTimer()
                    timerPressedAndHold.running = false
                }
            }
        }

        Image
        {
            id: bottomDrag
//            x: 497+101; y: 403+106+117
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -51
            anchors.left: parent.left
            anchors.leftMargin: 130 + 40
            z: Dimensions.const_AppUserManual_Z_1
            smooth: true
            source: (!optionMenu.focus_visible && bottomDragMA.pressed ) || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Down || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Bottom_Left || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Bottom_Right
                ? Images.const_AppUserManual_Icon_Bottom_Drag_F : Images.const_AppUserManual_Icon_Bottom_Drag_N
            visible: !minZoom && appUserManual.mainFullScreen //appUserManual.zoomEnable

            MouseArea
            {
                id: bottomDragMA
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" &&  !appUserManual.lockoutMode && !appUserManual.touchLock

//                onClicked:
                onPressed:
                {
                    console.log("PDFScreen.qml :: bottomDrag onPressed")
                    doubleTap_timer.running = false
                    doubleTap_timer.stop()
                    pdfScreenPinchArea.visible = false
                    stopTimer()
                    timerPressedAndHold.running = true
                    dragWidgetX = 0
                    dragWidgetY = -10
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
                }

                onReleased:
                {
                    timerPressedAndHold.running = false
                    if ( optionMenu.focus_visible ) return;
                    console.log("PDFScreen.qml :: bottomDrag onReleased")
                    pdfScreenPinchArea.visible = true
                    appUserManual.touchBtn = true
                    startTimer()
                }
            }
        }

        Image
        {
            id: leftDrag
//            x: 497; y: 403+106
            anchors.left: parent.left
            anchors.leftMargin: 41 + 40
            anchors.top: parent.top
            anchors.topMargin: 41
            z: Dimensions.const_AppUserManual_Z_1
            smooth: true
            source: (!optionMenu.focus_visible && leftDragMA.pressed ) || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Left || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Top_Left || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Bottom_Left
                ? Images.const_AppUserManual_Icon_Left_Drag_F : Images.const_AppUserManual_Icon_Left_Drag_N
            visible: !minZoom && appUserManual.mainFullScreen// appUserManual.zoomEnable

            MouseArea
            {
                id: leftDragMA
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" &&  !appUserManual.lockoutMode && !appUserManual.touchLock

//                onClicked:
                onPressed:
                {
                    console.log("PDFScreen.qml :: leftDrag onPressed")
                    doubleTap_timer.running = false
                    doubleTap_timer.stop()
                    pdfScreenPinchArea.visible = false
                    stopTimer()
                    timerPressedAndHold.running = true
                    dragWidgetX = 10
                    dragWidgetY = 0
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
                }

                onReleased:
                {
                    if ( optionMenu.focus_visible ) return;
                    console.log("PDFScreen.qml :: leftDrag onReleased")
                    pdfScreenPinchArea.visible = true
                    appUserManual.touchBtn = true
                    startTimer()
                    timerPressedAndHold.running = false
                }
            }
        }

        Image
        {
            id: rightDrag
//            x: 497+101+122; y: 403+106
            anchors.right: parent.right
            anchors.rightMargin: 40 + 40
            anchors.top: parent.top
            anchors.topMargin: 41
            z: Dimensions.const_AppUserManual_Z_1
            smooth: true
            source: (!optionMenu.focus_visible && rightDragMA.pressed )|| cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Right  || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Top_Right || cue_focusIndex == Dimensions.const_AppUserManual_Cue_Focus_Bottom_Right
                ? Images.const_AppUserManual_Icon_Right_Drag_F : Images.const_AppUserManual_Icon_Right_Drag_N
            visible: !minZoom && appUserManual.mainFullScreen

            MouseArea
            {
                id: rightDragMA
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" &&  !appUserManual.lockoutMode && !appUserManual.touchLock

//                onClicked:
                onPressed:
                {
                    console.log("PDFScreen.qml :: rightDrag onPressed")
                    doubleTap_timer.running = false
                    doubleTap_timer.stop()
                    pdfScreenPinchArea.visible = false
                    stopTimer()
                    timerPressedAndHold.running = true
                    dragWidgetX = -10
                    dragWidgetY = 0
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
                }

                onReleased:
                {
                    if ( optionMenu.focus_visible ) return;
                    console.log("PDFScreen.qml :: rightDrag onReleased")
                    pdfScreenPinchArea.visible = true
                    appUserManual.touchBtn = true
                    startTimer()
                    timerPressedAndHold.running = false
                }
            }
        }

        Behavior on y
        {
         //   PropertyAnimation { duration:  Dimensions.const_AppUserManual_Animation_Duration }
            PropertyAnimation { duration:  appUserManual.visualcueDuration ? 0: appUserManual.modeareaDuration ? 0 : Dimensions.const_FULLSCREEN_DURATION_ANIMATION}
        }
    }

 /*  PopUp Code */

    Timer
    {
        id: searchStart_timer

        interval: 500
        repeat: false

        onTriggered:
        {
            if ( searchForward ) pdfController.searchForward( appUserManual.searchText , false )
            else pdfController.searchBackward( appUserManual.searchText) //  searchBackward는 항상 bFirst가 false
        }
    }

//    Timer
//    {
//        id: zoomWidget_timer
//
//        interval: 300
//        repeat: false
//
//        onTriggered:
//        {
//            zoomWidget( zoomCnt )
//            if ( !minZoom ) fullScreen( false )
//            else appUserManual.setFullScreen( false )
//            zoomCnt = 0
//        }
//    }

    Timer
    {
        id: fullScreenTimer

        interval: 5000
        running: true // false
        repeat: false

        onTriggered:
        {
            console.log("PDF_Screen.qml :: Timer on Triggered")
            if ( !numericVisible && !appUserManual.mainFullScreen ) //minZoom ) // && !appUserManual.lockoutMode )
            //if( numeric_KeyPad.y != Dimensions.const_AppUserManual_NumericKeyPad_Y )
            {
//                fullScreen( true )
                if ( appUserManual.state == "pdfScreenView")
                    appUserManual.setFullScreen( true )
                    if ( !minZoom ) fullScreen(false)
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
            }
        }
    }

    Timer
    {
        id: nextprevTimer

        interval: 300
        repeat: false

        onTriggered:
        {
            console.log("PDF_Screen.qml :: nextprevTimer onTriggered ")
            if ( !minZoom ) exitZoom()
            appUserManual.minZoom = true
            appUserManual.curPage += nextprevCnt
            if ( appUserManual.curPage > appUserManual.totalPage )
                appUserManual.curPage -= appUserManual.totalPage
            else if ( appUserManual.curPage < 1 )
                appUserManual.curPage += appUserManual.totalPage

            pdfController.gotoPage( appUserManual.curPage )
            pdfController.updatePageNumbers()
            if ( !appUserManual.mainFullScreen && !optionMenu.focus_visible )
                appUserManual.setFullScreen( false )

            nextprevCnt = 0
        }
    }

    Timer {
       id: doubleTap_timer
       interval: Dimensions.const_DOUBLE_TAP_MAX_TIME_DELTA
       running: false
       onTriggered:
       {
           console.log("PDF_Screen.qml ::  doubleTap_timer onTriggered ")
           doubleTap_timer.running = false
           doubleTap_timer.stop()
           if ( optionMenu.focus_visible ) return;
           if ( appUserManual.mainFullScreen ) {
               appUserManual.setFullScreen( false )
           }
           else if ( !minZoom ) {
               console.log("PDF_Screen.qml ::  doubleTap_timer onTriggered 1")
               appUserManual.setFullScreen( true)
               fullScreen(false)
           }
           else {
               console.log("PDF_Screen.qml ::  doubleTap_timer onTriggered 11")
               appUserManual.setFullScreen( true)
           }
       }
    }

    Timer {
       id: popup_timer
       interval: 50
       running: false
       onTriggered:
       {
           console.log("PDF_Screen.qml ::  popup_timer onTriggered ")
           toast_popUp.visible = false;
       }
    }

    Connections
    {
        target: pdfController
        
        onThreadIsRunning:
        {
            console.log("PDF_Screen.qml :: onThreadIsRunning - running : " , running );
            appUserManual.threadIsRunning( running );
        }

        onSetZoomStatus:
        {
            console.log("PDF_Screen.qml :: onSetZoomStatus - status : " , status );
            switch ( status )
            {
                case 1:{
                    maxZoom = true
                    minZoom = false
                    appUserManual.minZoom = false
                    appUserManual.setFullScreen( true )
                    fullScreen( false )
                    break;
                }
                case 2: {
                    maxZoom = false
                    minZoom = true
                    appUserManual.minZoom = true
                    timerPressedAndHold.running = false
                    appUserManual.setFullScreen( false )
                    break;
                }
                case 0:
                default:
                {
                    maxZoom = false
                    minZoom = false
                    appUserManual.minZoom = false
                    appUserManual.setFullScreen( true )
                    fullScreen( false )
                    break;
                }
            }
        }

        onSetPDFSearchPopupVisible:
        {
            console.log("PDF_Screen.qml :: onSetPDFSearchPopupVisible " );
//            popup_timer.restart()
            toast_popUp.visible = false;
        }

        onSetSearchPopupVisible:
        {
            console.log("PDF_Screen.qml :: onSetSearchPopupVisible " );
            appUserManual.toastPopupVisible(  )
        }

        onCallSearchForward:
        {
            toast_popUp.visible = true;
            searchForward = forward
            searchStart_timer.restart()
//            if ( forward ) pdfController.searchForward( appUserManual.searchText , false )
//            else pdfController.searchBackward( appUserManual.searchText  , false )
        }

        onResetFullScreenTimer:
        {
            console.log("PDF_Screen.qml :: onResetFullScreenTimer ");
            startTimer()
        }

        onStopFullscreenTimer:
        {
            console.log("PDF_Screen.qml :: onStopFullscreenTimer ");
            fullScreenTimer.stop();
        }

        onPlayAudioBeep:      // mouse release 시 beep 출력
        {
            if ( numericVisible ) {
                console.log("PDF_Screen.qml :: onPlayAudioBeep - numericVisible return ");
                return;
            }
            console.log("PDF_Screen.qml :: onPlayAudioBeep ");
            EngineListener.playAudioBeep()
        }

        onShowFullScreen:
        {
//            if ( appUserManual.lockoutMode ) return;
            console.log("PDF_Screen.qml :: onShowFullScreen ");
            if ( appUserManual.lockoutMode ) {          // 주행규제 화면일 경우, 전체화면 전환만 가능
                if ( appUserManual.mainFullScreen ) appUserManual.setFullScreen( false )
                else  appUserManual.setFullScreen( true )
                return;
            }
            if (statusbar && !appUserManual.mainFullScreen /*&& minZoom*/ ) {      // minZoom 조건은 필요없음. stausbar 영역(y<190)이고, fullScreen이 아닐 경우(statusbar가 보일 경우) startTimer()
                startTimer()
            }
            else {
                if ( doubleTap_timer.running )
                {
                    console.log("PDF_Screen.qml :: Tap 2nd")
                    doubleTap_timer.running = false
                    doubleTap_timer.stop()
                    if ( !minZoom )
                    {
                        console.log("PDF_Screen.qml :: doubleTap exitZoom")
                        appUserManual.exitZoom()
                        appUserManual.setFullScreen( false )
                    }
                    else
                    {
                        console.log("PDF_Screen.qml :: doubleTap doubleTapZoom")
                        appUserManual.setFullScreen( true )
                        doubleTapZoom()
                        fullScreen( false )
                    }
                }
                else
                {
                    console.log("PDF_Screen.qml :: Tap 1st")
                    doubleTap_timer.running = true
                    doubleTap_timer.restart()
                }
            }
        }

        onShowPageNumber:
        {
            console.log("PDF_Screen.qml :: onShowPageNumber Event Received.");
            appUserManual.showPageNumbers(currentPage)
        }

        onShowPDFTitle:
        {
            console.log("PDF_Screen.qml :: onShowPDFTitle Event Received.");
            appUserManual.showPDFTitle(pdfTitle)
        }

        onTitlesReceived:
        {
            console.log("PDF_Screen.qml :: onTitlesReceived Event Received.");
            appUserManual.titlesReceived(titleList)
        }

        onTitlePageNumReceived:
        {
            console.log("PDF_Screen.qml :: onTitlePageNumReceived Event Received.");
            appUserManual.titlePageNumReceived( titlePageNum , totalPages )
        }

        onContentsReceived:     // 우측 tagName 출력 시
        {
            console.log("PDF_Screen.qml :: onContentsReceived")
            appUserManual.contentsReceived(contentsList);
        }

        onPageNumbersReceived:
        {
            console.log("PDF_Screen.qml :: onPageNumbersReceived Event Received.");
            appUserManual.pageNumbersReceived( pageNumberList )
        }

        onSearchPDFListEmpty:
        {
            console.log("PDF_Screen.qml :: onSearchPDFListEmpty Event Received.");
            appUserManual.showPDFEmptyPopUp()
        }

        onLaunchPDFScreen:
        {
            console.log("PDF_Screen.qml :: onLaunchPDFScreen Event Received.");
            appUserManual.handleBackKey( false , false , false )
            appUserManual.launchPDFScreen()
        }

        onSearchPDFListReceived:
        {
            console.log("PDF_Screen.qml :: onSearchPDFListReceived Event Received.");
            appUserManual.searchPDFListReceived( searchPDFStringList )
        }
        onSearchTextEnd:
        {
            if ( appUserManual.lockoutMode ) return;
            console.log("PDF_Screen.qml :: onSearchTextEnd Event Received.");
            searchEndPopUp.visible = true
        }
        onSearchTextNotFound:
        {
            if ( appUserManual.lockoutMode ) return;
            console.log("PDF_Screen.qml :: onSearchTextNotFound Event Received.");
            appUserManual.searchTextNotFound()
        }
        onSearchTextFound:
        {
            if ( appUserManual.lockoutMode ) return;
            console.log("PDF_Screen.qml :: onSearchTextFound Event Received.");
            appUserManual.searchTextFound()
            focus_visible = true
            startTimer()
        }
        onSetCurrentPage:
        {
            console.log("PDF_Screen.qml :: onSetCurrentPage Event Received.");
            console.log(" PDF_Screen.qml :: onSetCurrentPage - page : ", page)
            pdfController.gotoPage( setCurrentPage )
            pdfController.updatePageNumbers()
        }
    }

    Timer {
       id: timerPressedAndHold
       interval: 50
       repeat: true
       property string lastPressed: ""
       onTriggered:
       {
           pdfController.dragWidgetJog( dragWidgetX, dragWidgetY )
       }
       onRunningChanged:
       {
           console.log("Pdf_Screen.qml :: onRunningChanged")
           pdfController.setTouchLock(running);
       }
    }

    Connections
    {
//        target: ( appUserManualPdfScreen.focus_visible && !optionMenu.focus_visible ) ? UIListener : null
        target: ( appUserManual.state == "pdfScreenView" && !optionMenu.focus_visible && appUserManual.focusIndex ==  Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) ? UIListener : null

        onSignalJogNavigation:
        {
            if( disable_popup.visible || pagePopUp.visible  || searchEndPopUp.visible || toast_popUp.visible  || appUserManual.lockoutMode) {
                return;
            }
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                console.log("PDF_Screen.qml :: onSignalJogNavigation KEY_STATUS_PRESSED")
                jogPressed = true
                wheel_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Wheel
                switch( arrow )
                {
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                    {
                        if ( numericVisible )
                        {
                            __LOG(" :: UIListenerEnum.JOG_WHEEL_RIGHT numeric_KeyPad")
                            numeric_KeyPad.incrementFocus( arrow )
                        }
                        else
                        {
                            __LOG(" :: UIListenerEnum.JOG_WHEEL_RIGHT zoomWidget")
                            wheel_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Wheel_Right
                        /* if ( minZoom )*/
                        if ( !appUserManual.mainFullScreen ) appUserManual.setFullScreen( true )
                            zoomWidget( true )
                            fullScreen( false )
                        }
                    }
                        break;
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                    {
                        if ( numericVisible )
                        {
                            __LOG(" :: UIListenerEnum.JOG_WHEEL_LEFT numeric_KeyPad")
                            numeric_KeyPad.decrementFocus( arrow )
                        }
                        else
                        {
                            __LOG(" :: UIListenerEnum.JOG_WHEEL_LEFT zoomWidget")
                            wheel_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Wheel_Left
                            if ( !appUserManual.mainFullScreen && !minZoom ) appUserManual.setFullScreen( true )
                            zoomWidget( false )
                            if ( minZoom ) appUserManual.setFullScreen( false )
                            else fullScreen( false )
                        }
                        startTimer()
                    }
                        break;
                case UIListenerEnum.JOG_DOWN:
                {
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Down
                    if( !minZoom && appUserManual.mainFullScreen )
                    {
                        __LOG(" :: UIListenerEnum.JOG_DOWN Pressed !minZoom")
                        dragWidgetX = 0
                        dragWidgetY = -10
                        timerPressedAndHold.running = true
                    }
                    else if ( numericVisible )
                    {
                        __LOG(" :: UIListenerEnum.JOG_DOWN Pressed numeric_KeyPad")
                        numeric_KeyPad.incrementFocus( arrow )
                    }
                }
                    break;
                case UIListenerEnum.JOG_UP:
                {
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Up
                    if( !minZoom && appUserManual.mainFullScreen )
                    {
                        __LOG(" :: UIListenerEnum.JOG_UP Pressed !minZoom")
                        dragWidgetX = 0
                        dragWidgetY = 10
                        timerPressedAndHold.running = true
                    }
                    else if ( numericVisible )
                    {
                        __LOG(" :: UIListenerEnum.JOG_UP Pressed numeric_KeyPad")
                            var result = numeric_KeyPad.decrementFocus( arrow )
                            if ( result )
                                setFocus ( true )
                    }
                    else
                    {
                        __LOG(" :: UIListenerEnum.JOG_UP Pressed else")
                            if ( !appUserManual.mainFullScreen )
                            {
                                setFocus ( true )
                            }
                    }

                }
                    break;
                case UIListenerEnum.JOG_BOTTOM_RIGHT:
                {
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Bottom_Right
                    if( !minZoom )
                    {
                        __LOG(" :: UIListenerEnum.JOG_BOTTOM_RIGHT Pressed !minZoom")
                        if ( !appUserManual.mainFullScreen ) {
                            appUserManual.setFullScreen( true )
                            if ( minZoom ) appUserManual.setFullScreen( false )
                            else fullScreen( false )
                        }
                        dragWidgetX = -10
                        dragWidgetY = -10
                        cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Bottom_Right     // [ITS 254017] 대각선 이동 시 포커스 출력
                        timerPressedAndHold.running = true
                    }
                }
                    break;
                case UIListenerEnum.JOG_TOP_RIGHT:
                {
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Top_Right
                    if( !minZoom )
                    {
                        __LOG(" :: UIListenerEnum. JOG_TOP_RIGHT Pressed !minZoom")
                        if ( !appUserManual.mainFullScreen ) {
                            appUserManual.setFullScreen( true )
                            if ( minZoom ) appUserManual.setFullScreen( false )
                            else fullScreen( false )
                        }
                        dragWidgetX = -10
                        dragWidgetY = 10
                        cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Top_Right     // [ITS 254017] 대각선 이동 시 포커스 출력
                        timerPressedAndHold.running = true
                    }
                }
                break;
                case UIListenerEnum.JOG_RIGHT:
                {
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Right
                    if( !minZoom && appUserManual.mainFullScreen )
                    {
                        __LOG(" :: UIListenerEnum.JOG_RIGHT Pressed !minZoom")
                        dragWidgetX = -10
                        dragWidgetY = 0
                        timerPressedAndHold.running = true
                    }
                }
                    break;
                    case UIListenerEnum.JOG_BOTTOM_LEFT:
                    {
                        cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Bottom_Left
                        if( !minZoom )
                        {
                            __LOG(" :: UIListenerEnum.JOG_BOTTOM_LEFT Pressed !minZoom")
                            if ( !appUserManual.mainFullScreen ) {
                                appUserManual.setFullScreen( true )
                                if ( minZoom ) appUserManual.setFullScreen( false )
                                else fullScreen( false )
                            }
                            dragWidgetX = 10
                            dragWidgetY = -10
                            timerPressedAndHold.running = true
                            cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Bottom_Left       // [ITS 268793] 대각선 이동 시 포커스 출력
                        }
                    }
                        break;
                    case UIListenerEnum.JOG_TOP_LEFT:
                    {
                        cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Top_Left
                        if( !minZoom )
                        {
                            __LOG(" :: UIListenerEnum. JOG_TOP_LEFT Pressed !minZoom")
                            if ( !appUserManual.mainFullScreen ) {
                                appUserManual.setFullScreen( true )
                                if ( minZoom ) appUserManual.setFullScreen( false )
                                else fullScreen( false )
                            }
                            dragWidgetX = 10
                            dragWidgetY = 10
                            timerPressedAndHold.running = true
                            cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Top_Left             // [ITS 268793] 대각선 이동 시 포커스 출력
                        }
                    }
                    break;
                case UIListenerEnum.JOG_LEFT:
                {
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_Left
                    if( !minZoom && appUserManual.mainFullScreen )
                    {
                        __LOG(" :: UIListenerEnum.JOG_LEFT Pressed !minZoom")
                        dragWidgetX = 10
                        dragWidgetY = 0

                        timerPressedAndHold.running = true
                    }
                }
                    break;
                case UIListenerEnum.JOG_CENTER:
                {
                    jogCenterPressed = true
                    if ( numericVisible )
                    {
                        __LOG(" :: UIListenerEnum.JOG_CENTER numeric_KeyPad")
                        numericCenter = true
                        numeric_KeyPad.updateTextBox(numericCenter)
                    }
                }
                break;
                default:
                    __LOG( "Unhandled Event" + arrow )
                    break;
                }
                if ( !appUserManual.mainFullScreen ) stopTimer()
            }
            else if (status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
                if ( !jogPressed ) return;
                jogPressed = false
                console.log("PDF_Screen.qml :: onSignalJogNavigation KEY_STATUS_RELEASED")
               if ( appUserManual.focusIndex == Dimensions.const_AppUserManual_ModeArea_FocusIndex )
                    cue_focusIndex = -1
                else
                    cue_focusIndex = Dimensions.const_AppUserManual_Cue_Focus_VisualCue
                switch( arrow )
                {
                    case UIListenerEnum.JOG_UP:
                    {
                        if ( numericVisible )
                        {
                            __LOG(" :: UIListenerEnum.JOG_UP released numeric_KeyPad")
                        }
                        else if( !minZoom && appUserManual.mainFullScreen )
                        {
                            __LOG(" :: UIListenerEnum. JOG_UP released !minZoom")
                            timerPressedAndHold.running = false
                            startTimer()
                        }
                        else
                        {
                            __LOG(" :: UIListenerEnum.JOG_UP released else")
                            if ( minZoom )
                                appUserManual.setFullScreen( false )
                        }
                    }
                    break;
                    case UIListenerEnum.JOG_DOWN:
                    {
                        if ( numericVisible )
                        {
                            __LOG(" :: UIListenerEnum.JOG_DOWN released numeric_KeyPad")
//                            numeric_KeyPad.incrementFocus( arrow )
                        }
                        else if( !minZoom && appUserManual.mainFullScreen )
                        {
                            __LOG(" :: UIListenerEnum. JOG_DOWN released !minZoom")
                            timerPressedAndHold.running = false
                            startTimer()
                        }
                        else
                        {
                            __LOG(" :: UIListenerEnum.JOG_DOWN else")
                            if ( minZoom )
                                appUserManual.setFullScreen( false )
                        }
                    }
                    break;
                    case UIListenerEnum.JOG_RIGHT:
                    {
                        if( !minZoom && appUserManual.mainFullScreen )
                        {
                            __LOG(" :: UIListenerEnum. JOG_RIGHT released !minZoom")
                            timerPressedAndHold.running = false
                            startTimer()
                        }
                        else if( appUserManual.okTextEnable )
                        {
                            __LOG(" :: UIListenerEnum.JOG_RIGHT okTextEnable")
                            appUserManual.exitZoom()
                            toast_popUp.visible = true;
                            searchForward = true
                            searchStart_timer.restart()
                               //pdfController.searchForward( appUserManual.searchText , false )
                        }
                        else if ( numericVisible )
                            numeric_KeyPad.incrementFocus( arrow )
                        else
                        {
                            __LOG(" :: UIListenerEnum.JOG_RIGHT else")
//                            pdfController.showNextPageThread()
                            nextprevCnt++
                            __LOG(" :: UIListenerEnum.JOG_RIGHT else - nextprevCnt : ", nextprevCnt )
                            nextprevTimer.restart()
                        }
                    }
                    break;
                    case UIListenerEnum.JOG_BOTTOM_RIGHT:
                    case UIListenerEnum.JOG_TOP_RIGHT:
                    case UIListenerEnum.JOG_BOTTOM_LEFT:
                    case UIListenerEnum.JOG_TOP_LEFT:
                    {
                        if( !minZoom && appUserManual.mainFullScreen )
                        {
                            __LOG(" :: UIListenerEnum. JOG_BOTTOM_LEFT/RIGHT , JOG_TOP_LEFT/RIGHT released !minZoom")
                            timerPressedAndHold.running = false
                            startTimer()
                        }
                    }
                    break;
                    case UIListenerEnum.JOG_LEFT:
                    {
                        if ( numericVisible )
                        {
                            __LOG(" :: UIListenerEnum.JOG_LEFT released numeric_KeyPad")
                            numeric_KeyPad.decrementFocus( arrow )
                        }
                        else if( !minZoom && appUserManual.mainFullScreen )
                        {
                            __LOG(" :: UIListenerEnum. JOG_LEFT released !minZoom")
                            timerPressedAndHold.running = false
                            startTimer()
                        }
                        else if( appUserManual.okTextEnable )
                        {
                            __LOG(" :: UIListenerEnum.JOG_LEFT okTextEnable")
                            appUserManual.exitZoom()
                            toast_popUp.visible = true;
                            searchForward = false
                            searchStart_timer.restart()
                               //pdfController.searchBackward( appUserManual.searchText  , false )
                        }
                        else
                        {
                            __LOG(" :: UIListenerEnum.JOG_LEFT else")
//                            pdfController.showPrevPageThread()
                            nextprevCnt--
                            nextprevTimer.restart()
                        }
                    }
                    break;
                    case UIListenerEnum.JOG_CENTER:
                    {
                        jogCenterPressed = false
                        if ( appUserManual.okTextEnable ) {     // 검색 결과 화면
                            if ( searchOkText.visible &&  !appUserManual.mainFullScreen) {       // "OK" text가 보이는 상태 > 검색 종료
                                __LOG(" :: UIListenerEnum.JOG_CENTER okTextEnable")
                                appUserManual.searchText = ""
                                appUserManual.searchOKTextEnable( false )
                                pdfController.clearSearchLocation()
                                appUserManual.setFullScreen( false )
                                appUserManual.exitSearch()
                            }
                            else {          // "OK" text가 보이지 않는다 == 확대 상태   > full screen 해제
                                appUserManual.setFullScreen( false )
                                fullScreen(false)
                            }
                        }
                        else if( !minZoom )     // 확대 상태
                        {
                            __LOG(" :: UIListenerEnum.JOG_CENTER minZoom")
                            if ( appUserManual.mainFullScreen ) {
                                appUserManual.setFullScreen( false )
                            }
                            else {
                                appUserManual.setFullScreen( true)      // titlearea는 hide
                                fullScreen(false)                   // controlcue는 show
                            }
                        }
                        else if ( numericVisible )
                        {
                            __LOG(" :: UIListenerEnum.JOG_CENTER numeric_KeyPad")
                            if ( numericCenter )
                            {
                                numericCenter = false
                                numeric_KeyPad.updateTextBox(numericCenter)
                            }
                        }
                        else
                        {
                            __LOG(" :: UIListenerEnum.JOG_CENTER pdf screen")
                            if ( appUserManual.mainFullScreen ) {
                                appUserManual.setFullScreen( false )
                            }
                            else if ( !minZoom ) {
                                appUserManual.setFullScreen( true)
                                fullScreen(false)
                            }
                            else {
                                appUserManual.setFullScreen( true )
                            }
                        }
                    }
                        break;
                    default:
                    {
                        __LOG(" :: UIListenerEnum. jog released default")
                        startTimer()
                    }
                }
            }
            else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_CENTER:
                    {
                        jogCenterPressed = false
                        if ( numericVisible )
                        {
                            __LOG(" :: UIListenerEnum.JOG_CENTER numeric_KeyPad")
                            numericCenter = false
                            numeric_KeyPad.centerCanceled()
                        }
                        break;
                    }
//                    case UIListenerEnum.JOG_LEFT:
//                    case UIListenerEnum.JOG_RIGHT:
//                    case UIListenerEnum.JOG_DOWN:
//                    case UIListenerEnum.JOG_UP:
//                    case UIListenerEnum.JOG_BOTTOM_RIGHT:
//                    case UIListenerEnum.JOG_TOP_RIGHT:
//                    case UIListenerEnum.JOG_BOTTOM_LEFT:
//                    case UIListenerEnum.JOG_TOP_LEFT:
                    default:
                    {
                        setFG(true)
                        break;
                    }
                }
            }
        }
    }

    Component.onCompleted:
    {
        pdfController.getTOC()
    }

    Connections
    {
        target: EngineListener

        onSetDrs:
        {
            console.log("PDF_Screen.qml :: onSetDrs")
            pdfController.setDrs(status);
        }
        
        onJog8Dir:
        {
            if ( numericVisible && ( appUserManual.state == "pdfScreenView" && !optionMenu.focus_visible && appUserManual.focusIndex ==  Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )   ) {
                switch ( dir )
                {
                case Dimensions.JOG_TOP_LEFT:
                    numeric_KeyPad.decrementFocus( Dimensions.JOG_TOP_LEFT )
                    break;
                case Dimensions.JOG_TOP_RIGHT:
                    numeric_KeyPad.decrementFocus( Dimensions.JOG_TOP_RIGHT )
                    break;
                case Dimensions.JOG_BOTTOM_LEFT:
                    numeric_KeyPad.incrementFocus( Dimensions.JOG_BOTTOM_LEFT )
                    break;
                case Dimensions.JOG_BOTTOM_RIGHT:
                    numeric_KeyPad.incrementFocus( Dimensions.JOG_BOTTOM_RIGHT )
                    break;
                }
            }
        }

        onRetranslateUi:
        {
            console.log("PDF_Screen.qml :: RetranslateUi Called.")
            retranslateUI()
        }
    }
}
