import QtQuick 1.1
import Qt 4.7
import Qt.labs.gestures 2.0
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0
import QmlStatusBar 1.0

import "DHAVN_AppUserManual_Dimensions.js" as Dimensions
import "DHAVN_AppUserManual_Images.js" as Images

Item
{
    id: appUserManual

    width: Dimensions.const_AppUserManual_MainScreenWidth
    height: Dimensions.const_AppUserManual_MainScreenHeight

    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property string titleText: ""
    property string modeAreaPage: ""//modeAreaModelPDFScreen.mode_area_right_text
    property string modeAreaPageTmp: ""//modeAreaModelPDFScreen.mode_area_right_text
    property string modeAreaTitle: qsTranslate( "main", "STR_MANUAL_TITLE" )//modeAreaModelPDFList.text
    property string txt_notFound: qsTranslate( "main", "STR_MANUAL_OK" )

    property int curPage: -1
    property int totalPage: 0

//   property alias modeAreaText: modeAreaModelPDFScreen.mode_area_right_text
//    property alias modeAreaPDFTitle: modeAreaModelPDFScreen.text
//    property alias modeAreaTitle: modeAreaModelPDFList.text

    property string tempState: ""
    property string pageNumberEntered: ""
    property string tempModeAreaRightText: ""
    property string searchText: ""
    property bool okTextEnable: false
    property bool zoomEnable: false
    property bool minZoom: true
    property bool isJogBackKey: false
    property bool systemPopupVisible: false
    property bool systemTempPopupVisible: false
    property bool touchBtn: false
    property bool drsList: false

    property int focusIndex: Dimensions.const_AppUserManual_FocusNone
    property int tmpFocusIndex: Dimensions.const_AppUserManual_FocusNone
    property int drsFocusIndex:  Dimensions.const_AppUserManual_FocusNone
    property int modeAreaBeforeIndex: Dimensions.const_AppUserManual_FocusNone
    property int systemPopupFocusIndex: Dimensions.const_AppUserManual_FocusNone

    property int countryVariant: UIListener.GetCountryVariantFromQML() // EngineListener.getCountyVariant()
    property int langId: EngineListener.getLanguage()
    property int titleNum: 0
    property int btPage: 0
    property int vrPage: 0
    property int btIndex: 0
    property int vrIndex: 0

    property bool touchLock: false;
    property bool isPan: false
    property bool receivedTitles: false

    property bool visualcueDuration: false
    property bool modeareaDuration: false

    property bool lockoutMode: false
    property bool nowFG: false
    property bool changeLanguageBG: false
    property bool gotoPageBox: false
    property bool threadRunning: false
    property bool mainFullScreen: false
//    property bool entryBtVr: false
    property bool tempPopup: false

    property int pinchCnt: 0
    property bool pinchZoomIn: false
    property real previousScalingFactor: -1
    property bool showNotFoundPopup: false
    property bool showSearchEndPopUp: false
    property bool showPagePopUp: false
    property bool showWarningPopUp: false
    property bool helpModeIsBt: true // hyeonil.shin
    property bool restartThread: false


    function setForegroundEvent( )
    {
        console.log("Main.qml :: setForegroundEvent() ")
        popup_loader.source = "";
        popup_loader.visible = false
        lockoutMode = false
        changePdfPopUp.visible = false
        toast_searchview.visible = false
        warningPopUp.visible = false
        toast_popUp.visible = false
        searchEndPopUp.visible = false
        pagePopUp.visible = false
        statusBar.y = 0
        focusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
        if (pdfTitleList.source != "DHAVN_AppUserManual_TitleListScreen.qml")
            pdfTitleList.source = "DHAVN_AppUserManual_TitleListScreen.qml"
        if ( pdfChapterList.source != "DHAVN_AppUserManual_ChapterListScreen.qml" )
            pdfChapterList.source = "DHAVN_AppUserManual_ChapterListScreen.qml"
        if ( pdfList.source != "DHAVN_AppUserManual_PDFList.qml" )
            pdfList.source = "DHAVN_AppUserManual_PDFList.qml"
        if ( pdfScreen.source != "DHAVN_AppUserManual_PDF_Screen.qml" ) {
            pdfScreen.source = "DHAVN_AppUserManual_PDF_Screen.qml"
            receivedTitles = false
//            pdfScreen.item.setLanguage()
        }
        optionMenu.visible = false
        state = "pdfListView"
        activateMenuPane(true)
//        pdfScreen.item.updateTitle()
        if ( !receivedTitles ) pdfScreen.item.getTOC()
        pdfTitleList.item.setFG()
        pdfTitleList.item.focusImageChange( 0 )
        pdfList.visible = true
        pdfList.item.resetVisualCue()
        pdfScreen.item.setNumericKeyPad( false );
        if ( gotoPageBox ) setGotoPageBox( false )
        pdfScreen.item.setPopupVisible( false );
        searchOKTextEnable(false)
        pdfScreen.item.fullScreen(false)
        pdfScreen.item.stopTimer()
        modeAreaWidget.setFG()
        systemPopupVisible = false
        systemTempPopupVisible = false
        pdfScreen.item.resetSearchPage()
    }

    function setForegroundEventSystemPopup( )
    {
        console.log("Main.qml :: setForegroundEventSystemPopup() ")
        popup_loader.source = "";
        popup_loader.visible = false
        lockoutMode = false
        changePdfPopUp.visible = false
        toast_searchview.visible = false
        warningPopUp.visible = false
        searchEndPopUp.visible = false
        pagePopUp.visible = false
        statusBar.y = 0
        optionMenu.visible = false
        state = "pdfListView"
        activateMenuPane(true)
        if ( !receivedTitles ) pdfScreen.item.getTOC()
        pdfTitleList.item.setFG()
        pdfTitleList.item.focusImageChange( 0 )
        pdfList.visible = true
        pdfList.item.resetVisualCue()
        pdfScreen.item.setNumericKeyPad( false );
        if ( gotoPageBox ) setGotoPageBox( false )
        pdfScreen.item.setPopupVisible( false );
        searchOKTextEnable(false)
        pdfScreen.item.fullScreen(false)
        pdfScreen.item.stopTimer()
        modeAreaWidget.setFG()
        pdfScreen.item.resetSearchPage()
    }

    function stopAnimation()
    {
        pdfTitleList.item.stopAnimation()
        pdfChapterList.item.stopAnimation()
        pdfScreen.item.stopAnimation()
    }

    function setChapterFocusReset()
    {
        console.log("Main.qml :: setChapterFocusReset()")
        pdfChapterList.item.focusImageChange(0)
    }

    function setTotalPage(page)
    {
        console.log("Main.qml :: setTotalPage() - page: " , page )
        totalPage = page
    }

    function waitSearch()
    {
        console.log("Main.qml :: waitSearch()")
        pdfSearchView.item.waitSearch()
    }
    
    function searchTextNotFound()
    {
        console.log("Main.qml :: searchTextNotFound() tempState : ", tempState)
        if ( systemPopupVisible ) { // 시스템 팝업 출력 중일 경우, text found 인자만 설정해놓고, 시스템 팝업 hide 시 해당 팝업 출력
            showNotFoundPopup = true
        }
        else pdfSearchView.item.searchTextNotFound()
    }

    function exitSearchNotFound()           // not used... 검색 결과 없음 팝업 searchview에 display로 사양 변경
    {
        console.log("Main.qml :: exitSearchNotFound() ")
        state = tempState // "pdfListView"
        if ( nowFG && !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
    }

    function doubleTapZoom()
    {
        console.log("Main.qml :: doubleTapZoom() ")
        pdfScreen.item.doubleTapZoom( )
        minZoom = false
    }

    function searchTextFound()
    {
      //  appUserManual.tempState == "pdfScreenView"
        console.log("Main.qml :: searchTextFound() - tempState: " , tempState )
        focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
        pdfSearchView.item.searchTextFound()
        state =  "pdfScreenView"
        searchOKTextEnable( true )
        pdfScreen.item.lostFocus(false)
        if ( nowFG && !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
    }

    function threadIsRunning( running )
    {
        if ( lockoutMode ) return;
        console.log("Main.qml :: threadIsRunning() - running : " , running )
        threadRunning = running
    }

    function launchSearch( menuItemIndex )
    {
        console.log("Main.qml :: launchSearch() menuItemIndex : ", menuItemIndex)

        optionMenu.visible = false
//        setFullScreen( false )
        statusBar.y = 0
//        modeAreaWidget.y = Dimensions.const_AppUserManual_StatusBar_Height
//        modeAreaWidget.z = Dimensions.const_AppUserManual_Z_2
        pdfScreen.item.stopTimer()
        exitZoom()
        if( menuItemIndex === 2 )
        {
            visualcueDuration = true
            pdfScreen.item.launchKeyPad()
            visualcueDuration = false
        }
        else if( menuItemIndex === 1 )
        {
            if( pdfSearchView.source != "DHAVN_AppUserManual_SearchView.qml"  )
                pdfSearchView.source = "DHAVN_AppUserManual_SearchView.qml"
            pdfSearchView.visible = true
            pdfSearchView.item.clearSearchView()
//            tmpFocusIndex = focusIndex
            focusIndex = Dimensions.const_AppUserManual_Search_View_FocusIndex
//            if ( state == "pdfScreenView") EngineListener.savePage(curPage)
            tempState = appUserManual.state
            appUserManual.state = "pdfSearchView"
//            changeState())
            if ( nowFG && !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
            EngineListener.saveTempState( tempState )
//            EngineListener.setViewport( UIListener.getCurrentScreen() , false );
        }
    }

    function toastPopupVisible()
    {
        console.log("Main.qml :: toastPopupVisible() ")
        pdfSearchView.item.toastPopupVisible( false )
    }

    function changeState()
    {
        console.log("Main.qml :: changeState()")

        setFullScreen(false)
        modeAreaWidget.setFG()
        if( appUserManual.state != "pdfScreenView" )
        {
            pdfScreen.item.stopTimer()
//            pdfScreen.item.pdfVisualCueControls.y = ( Dimensions.const_AppUserManual_VisualCue_Y + 300 )
        }
//        if ( state == "pdfScreenView")
//            EngineListener.setViewport( UIListener.getCurrentScreen() , true );
//        else
//            EngineListener.setViewport( UIListener.getCurrentScreen() , false );
    }

    function launchPDFScreen()
    {
        console.log("Main.qml ::  launchPDFScreen()")
//        pdfSearchView.source = ""
        pdfScreen.item.clearPdfScreen();
        pdfScreen.item.setNumericKeyPad( false );
        if ( gotoPageBox ) setGotoPageBox( false )
        pdfScreen.item.updatePageNumbers();
        minZoom = true
        exitZoom()
        appUserManual.state = "pdfScreenView"
        focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
        modeareaDuration = true
        setFullScreen( false )
        modeareaDuration = false
        if ( nowFG && !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
    }

    function setFocus( highListMovement )
    {
        console.log("Main.qml :: setFocus(  ) highListMovement : ", highListMovement)
        if( highListMovement )
        {
            pdfTitleList.item.focusImageChange( 0 )
            pdfChapterList.item.focusImageChange( 1 )
        }
        else
        {
            pdfTitleList.item.focusImageChange( 1 )
            pdfChapterList.item.focusImageChange( 0 )
        }
    }

    function moveFocus( titleList, focusUpDown )
    {
        console.log("Main.qml ::  moveFocus(  ) titleList, focusUpDown : ", titleList, focusUpDown)
        if( titleList )
        {
            if( focusUpDown )
            {
                pdfTitleList.item.focusImageMovement( false )
            }
            else
            {
                pdfTitleList.item.focusImageMovement(true)
            }
        }
        else
        {
            if( focusUpDown )
            {
                pdfChapterList.item.focusImageMovement( false )
            }
            else
            {
                pdfChapterList.item.focusImageMovement( true )
            }
        }
    }

    function setChapterListPane()
    {
        console.log("Main.qml :: activateMenuPane(  ) ")
        pdfList.item.setChapterListPane( )
        pdfTitleList.item.setChapterListPane( )
    }

    function activateMenuPane( activeView )
    {
        console.log("Main.qml :: activateMenuPane(  ) activeView : ", activeView)
        pdfList.item.activateMenuPane( activeView )

        if (activeView)
            focusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
        else
            focusIndex = Dimensions.const_AppUserManual_PageNumList_FocusIndex
    }

    function menuHidden()
    {
        console.log("Main.qml :: menuHidden()")
        if( focusIndex == Dimensions.const_AppUserManual_TitleList_FocusIndex )
        {
            pdfTitleList.item.titleListFocus = true
            pdfTitleList.item.focusImageChange( 0 )
        }
        else if ( focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex )
        {
            pdfChapterList.focusImageChange( 0 )
        }
    }

    function handleBackKey( status , touch , front )        // status 만 쓰임...(option menu)
    {
        console.log("Main.qml :: handleBackKey() - state : " , state , ", tempState : " , tempState )
        if ( threadRunning ) {
            pdfScreen.item.threadQuit();
            threadRunning = false
        }
        if ( lockoutMode ) {
            console.log("Main.qml :: handleBackKey() - lockoutMode ")
            EngineListener.HandleBackKey( UIListener.getCurrentScreen() , touch, front )
            return;
        }
        if ( status ) {
            if ( focusIndex != Dimensions.const_AppUserManual_OptionMenu_FocusIndex ) return;
        }
        if ( focusIndex == Dimensions.const_AppUserManual_OptionMenu_FocusIndex )
        {
            optionMenuBackKey()
            return
        }
        if( appUserManual.state == "pdfListView" )
        {
            EngineListener.HandleBackKey( UIListener.getCurrentScreen() , touch, front )
            return
        }
        if( appUserManual.state == "pdfScreenView" )
        {
            screenViewBackKey()
        }
        else if( appUserManual.state == "pdfSearchView" )
        {
            searchViewBackKey()
        }
        if( state == "pdfListView" )
            tmpFocusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
        else if( state == "pdfScreenView" )
            tmpFocusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
        changeState()
        if ( state == "pdfListView") {
            pdfList.visible = true
            pdfTitleList.visible = true
            pdfChapterList.visible = true
            pdfScreen.visible = false
            pdfSearchView.visible = false
        } else if ( state == "pdfScreenView") {
            pdfList.visible = false
            pdfTitleList.visible = false
            pdfChapterList.visible = false
            pdfScreen.visible = true
            pdfSearchView.visible = false
        }
    }

    function optionMenuBackKey()
    {
        console.log(" Main.qml :: optionMenuBackKey() , state : ", state)
//        optionMenu.newHideSamePanFinished()
        optionMenu.hideMenu();
        focusIndex = tmpFocusIndex
        if ( state == "pdfListView")
        {
            /* 옵션메뉴 복귀 시 기본 포커스 사양일 경우
            appUserManual.activateMenuPane( true )
            focusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
            pdfTitleList.item.focusImageChange( 0 )
            pdfTitleList.item.setFG()
            pdfChapterList.item.setFG()
            if ( langId != 20 ) {
                pdfList.item.setVisualCue( true , false )
            }
            else {
                pdfList.item.setVisualCue( false , false )
            }
            */
            //* 옵션메뉴 복귀 시 이전 포커스로 복귀하는 사양일 경우
            if ( focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex )
            {
                console.log("Main.qml :: optionMenuBackKey() - page list")
                appUserManual.activateMenuPane( false )
                pdfChapterList.item.focusImageChange( 2 ) //0 )
                if ( langId != 20 ) {
                    pdfList.item.setVisualCue( false , false )
                }
                else {
                    pdfList.item.setVisualCue( true , false )
                }
            }
//            else if ( focusIndex == Dimensions.const_AppUserManual_ModeArea_FocusIndex )
//            {
//                console.log("Main.qml :: optionMenuBackKey() - modearea")
//                pdfChapterList.item.setFG()
//            }
            else
            {
                console.log("Main.qml :: optionMenuBackKey() - title list")
                appUserManual.activateMenuPane( true )
                focusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
                pdfTitleList.item.focusImageChange( 0 )
                pdfChapterList.item.setFG()
                if ( langId != 20 ) {
                    pdfList.item.setVisualCue( true , false )
                }
                else {
                    pdfList.item.setVisualCue( false , false )
                }
            }
        }
        else            // pdf screen
        {
            console.log("Main.qml :: optionMenuBackKey() - pdf screen ")
            focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//            pdfScreen.item.setFocus( false )
            pdfScreen.item.optionMenuBack()
        }
    }

    function screenViewBackKey()
    {
        console.log("Main.qml :: screenViewBackKey() - curPage: " , curPage )
        if ( pagePopUp.visible ) return;
        if ( !minZoom ) exitZoom()
        if ( !gotoPageBox ) {
            console.log("Main.qml :: screenViewBackKey() - 1")
            focusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
            appUserManual.activateMenuPane( false )
            if ( langId != 20 ) {
                pdfList.item.setVisualCue( false , false )
            }
            else {
                pdfList.item.setVisualCue( true , false )
            }

            var i = 0
            var tmpIndex = 0
            var tmpStartPage = 0
            var flag = true
            for ( ; i < startPageModel.count - 1; i++)
            {
                if ( curPage >= startPageModel.get(i).titleLabel && curPage < startPageModel.get(i+1).titleLabel )
                {
                    console.log("Main.qml :: screenViewBackKey() - flag false ")
                    flag = false
                    tmpIndex = i
                    tmpStartPage = startPageModel.get(i).titleLabel
                    break;
                }
            }
            if ( flag ) {
                console.log("Main.qml :: screenViewBackKey() - flag true ")
                tmpIndex = i
                tmpStartPage = startPageModel.get(tmpIndex).titleLabel
            }
            console.log("Main.qml :: screenViewBackKey() - index : " , tmpIndex , ", tmpStartPage: " , tmpStartPage , " , curPage: " , curPage )
            getPageNumbers( tmpIndex )
            pdfTitleList.item.setFocusId( tmpIndex )
            pdfChapterList.item.setFocusId( curPage - tmpStartPage )
            appUserManual.state = "pdfListView"
            searchOKTextEnable( false )
            clearSearchLocation()
            if ( nowFG && !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
        }
        pdfScreen.item.showKeyPad( false )
        setFullScreen( false )
    }

    function searchViewBackKey()
    {
        if ( pdfSearchView.item.getPopupVisible() ) {
            pdfSearchView.item.hidePopup()
            return;
        }
        pdfSearchView.item.focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
        console.log("Main.qml :: searchViewBackKey() - state : " , state , " , tempState : " , tempState )
        if (tempState != "pdfListView" && tempState != "pdfScreenView" ) tempState = "pdfListView";
        if ( tempState == "pdfListView" )
        {
            console.log("Main.qml :: searchViewBackKey() - state : " , state , " , tempState : " , tempState )
            focusIndex = tmpFocusIndex
            if ( focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex )
            {
                console.log("Main.qml :: searchViewBackKey() - page list")
                appUserManual.activateMenuPane( false )
                pdfChapterList.item.focusImageChange( 2 ) //0 )
                if ( langId != 20 ) {
                    pdfList.item.setVisualCue( false , false )
                }
                else {
                    pdfList.item.setVisualCue( true , false )
                }
            }
            else if ( focusIndex == Dimensions.const_AppUserManual_ModeArea_FocusIndex )
            {
                console.log("Main.qml :: searchViewBackKey() - modearea")
                pdfChapterList.item.setFG()
            }
            else
            {
                console.log("Main.qml :: searchViewBackKey() - title list")
                appUserManual.activateMenuPane( true )
                focusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
                pdfTitleList.item.focusImageChange( 0 )
                pdfChapterList.item.setFG()
                if ( langId != 20 ) {
                    pdfList.item.setVisualCue( true , false )
                }
                else {
                    pdfList.item.setVisualCue( false , false )
                }
            }
//                focusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
//                pdfTitleList.item.setFG()
//                setFocus( true )
//                if ( langId != 20 ) {
//                    pdfList.item.setVisualCue( true , false )
//                }
//                else {
//                    pdfList.item.setVisualCue( false , false )
//                }
//                appUserManual.activateMenuPane( true )
            appUserManual.state = "pdfListView"
        }
        else        // pdfScreenView
        {
            console.log("Main.qml :: searchViewBackKey()  - state : " , state , " , tempState : " , tempState , " , curPage : " , curPage , " , titleText: " , titleText)
            focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
            pdfScreen.item.setFocus( false )        // back 시 항상 pdf control cue에 focus
            appUserManual.state = tempState
            curPage = EngineListener.getPage()
            totalPage = EngineListener.getTotalPage()
            pdfScreen.item.gotoPageTemporalMode(curPage)
            showPageNumbers(curPage)
        }
        if ( nowFG && !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
    }

    function setFullScreenTimer( stop )
    {
        console.log("Main.qml :: setFullScreenTimer()")
        if ( stop ) pdfScreen.item.stopTimer()
        else pdfScreen.item.startTimer()
    }
    
    function exitSearch()
    {
        if( appUserManual.tempState == "pdfScreenView" )
        {
            console.log("Main.qml :: exitSearch() tempState: pdfScreenView ")
            return;
        }
        console.log("Main.qml :: exitSearch()")
        exitZoom()
        pdfScreen.item.setNumericKeyPad( false );
        setGotoPageBox( false )
        focusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
        setFocus( true )
        if ( langId != 20 ) {
            pdfList.item.setVisualCue( true , false )
        }
        else {
            pdfList.item.setVisualCue( false , false )
        }
        appUserManual.activateMenuPane( true )
        appUserManual.state = "pdfListView"
//        pdfSearchView.source = ""
        searchOKTextEnable( false )
        clearSearchLocation()
        setFullScreen( false )
        tmpFocusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
        if ( nowFG && !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
    }

    function setFullScreen(visibility)
    {
        console.log("Main.qml :: setFullScreen() visibility : ", visibility)
        mainFullScreen = visibility
        if( visibility && state == "pdfScreenView" )
        {
//            modeAreaWidget.y = Dimensions.const_AppUserManual_ModeArea_Y - 200
           statusBar.y = -Dimensions.const_AppUserManual_StatusBar_Height*2
//            modeAreaWidget.y = -Dimensions.const_AppUserManual_StatusBar_Height// Dimensions.const_AppUserManual_StatusBar_Height - 200
//            EngineListener.setFullScreen( true, UIListener.getCurrentScreen() )
            pdfScreen.item.fullScreen( true )
        }
        else if ( !visibility )
        {
            statusBar.y = 0
//            modeAreaWidget.y = Dimensions.const_AppUserManual_StatusBar_Height
//            modeAreaWidget.z = Dimensions.const_AppUserManual_Z_2
//            EngineListener.setFullScreen( false, UIListener.getCurrentScreen() )
            pdfScreen.item.fullScreen( false )
        }
    }

    function drsTouch()
    {
        console.log("Main.qml :: drsTouch()" )
        if ( mainFullScreen ) setFullScreen(false)
        else setFullScreen(true)
    }

    function showPageNumbers( currentPage )
    {
//        page = currentPage
        curPage = currentPage
//        modeAreaPage = countryVariant == 4 ?  qsTranslate("main", "  " + totalPages + "/" + currentPage) :   qsTranslate("main", currentPage + "/" + totalPages + " ")
        modeAreaPage = (langId == 20) ?  qsTranslate("main", "  " + totalPage + "/" + currentPage) :   qsTranslate("main", currentPage + "/" + totalPage + " ")

        console.log("Main.qml :: showPageNumbers()  curPage, totalPage : " , curPage, totalPage )
        console.log("Main.qml :: showPageNumbers()  modeAreaPage: " , modeAreaPage )

        var i = 0
        var flag = true
        for ( ; i < startPageModel.count - 1; i++)
        {
            if ( currentPage >= startPageModel.get(i).titleLabel && currentPage < startPageModel.get(i+1).titleLabel )
            {
                titleText = getListTitle( i )
                flag = false
                break;
            }
        }
        if ( flag )
        {
            titleText = getListTitle( i )
        }
        if ( nowFG && !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
        EngineListener.savePage(curPage)
//        EngineListener.saveTempState( tempState , curPage )
        console.log("Main.qml :: showPageNumbers() - titleText : " , titleText)
    }

    function showPDFTitle( pdfTitle )
    {
        console.log("Main.qml :: showPDFTitle(  ) pdfTitle : ", pdfTitle)
        modeAreaTitle = qsTranslate( "main", "STR_MANUAL_TITLE" )
    }


    function titlesReceived(titleList)          // title list
    {
        console.log("Main.qml :: titlesReceived()  titleList : ", titleList)
        receivedTitles = true
        pdfTitleList.item.titleReceived( titleList )
    }

    function titlePageNumReceived( titlePageNumList , totalPages)       // title start page list
    {
        console.log("Main.qml :: titlePageNumReceived(  ) titlePageNumList : ", titlePageNumList)
        console.log("Main.qml :: titlePageNumReceived(  ) totalPages : ", totalPages)
//        pdfChapterList.item.pageNumbersReceived( pageNumberList )
        startPageModel.clear()

        var i = 0;

        for( ; i < titlePageNumList.length; ++i )
        {
            startPageModel.append( {"titleLabel" : titlePageNumList[i]} )
        }

        totalPage = totalPages
    }

    function contentsReceived(contentsList)              // 우측 tagName 출력 시
    {
        console.log("Main.qml :: contentsReceived()  contentsList : ", contentsList)
        pdfChapterList.item.pageNumbersReceived( contentsList )
        pdfChapterList.item.setFG()
    }

    function pageNumbersReceived( pageNumberList )
    {
        console.log("Main.qml :: pageNumbersReceived(  ) pageNumberList : ", pageNumberList)
        pdfChapterList.item.pageNumbersReceived( pageNumberList )
        pdfChapterList.item.setFG()
    }

    function getActivePane()
    {
        return pdfList.item.getActivePane()
    }

    function getPageNumbers( index )
    {
        console.log("Main.qml :: getPageNumbers(  ) index : ", index)
        titleNum = index;
        pdfScreen.item.getPageNumbers( titleNum )
    }

    function gotoPageNum( pageNum )     // content 목록의 index 전달
    {
        console.log("Main.qml :: gotoPageNum(  ) pageNum : ", pageNum)
//        page = pageNum
//        setFullScreen(false)
        pdfScreen.item.gotoPageNum( pageNum )
    }

    function searchString( bFirst )
    {
        console.log(" Main.qml :: searchString( ) searchText : ", searchText , " , bFirst : " , bFirst )
        pdfScreen.item.searchString( searchText , bFirst )
    }

    function getfocusId( titleorChapter )
    {
        console.log("Main.qml ::  getfocusId(  ) titleorChapter : ", titleorChapter)
        if( titleorChapter )
            return pdfTitleList.item.getfocusId()
        else
            return pdfChapterList.item.getfocusId()
    }

    function getListTitle( num )
    {
        console.log("Main.qml ::  getListTitle( ) num: ", num)
        return pdfTitleList.item.getListTitle( num )
    }

    function searchOKTextEnable( okEnable )
    {
        console.log("Main.qml :: searchOKTextEnable() okEnable : ", okEnable )
        if( okEnable )
            okTextEnable = true
        else
        {
            okTextEnable = false
        }
    }

    function clearSearchLocation()
    {
        console.log("Main.qml :: clearSearchLocation()")
        pdfScreen.item.clearSearchLocation()
    }

//    function searchPDF( searchPDFTitle )
//    {
//        console.log("Main.qml :: searchPDF() searchPDFTitle : ", searchPDFTitle)
//        pdfScreen.item.searchPDF( searchPDFTitle )
//    }

    function searchPDFListReceived( searchPDFStringList )
    {
        console.log("Main.qml :: searchPDFListReceived() searchPDFStringList : ", searchPDFStringList)
        pdfSearchView.item.searchPDFListReceived( searchPDFStringList )
    }

    function showPDFEmptyPopUp()
    {
        console.log("Main.qml :: showPDFEmptyPopUp()")
        pdfSearchView.item.showPDFEmptyPopUp()
    }

    function setKeyboardFocus()
    {
        console.log("Main.qml :: setKeyboardFocus()")
        pdfScreen.item.setKeyboardFocus( true )
    }

    function launchTouchMenu()
    {
        console.log("Main.qml :: launchTouchMenu()")
        setFullScreen(false)
        if ( appUserManual.focusIndex == Dimensions.const_AppUserManual_TitleList_FocusIndex)
        {
            pdfTitleList.item.focusImageChange( 1 )
        }
        else if (  focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex)
        {
            pdfChapterList.item.focusImageChange( 1 )
        }
    }

    states: [
        State {
            name: "pdfListView"
//            PropertyChanges { target: modeAreaWidget; modeAreaModel: modeAreaModelPDFList }
//            PropertyChanges { target: modeAreaWidget; y: Dimensions.const_AppUserManual_StatusBar_Height }      // fix R5.21
            PropertyChanges { target: pdfList; visible: true }
            PropertyChanges { target: pdfTitleList; visible: true }
            PropertyChanges { target: pdfChapterList; visible: true}
            PropertyChanges { target: pdfScreen; visible: false;}
            PropertyChanges { target: statusBar; visible: true; z: 0 }
            PropertyChanges { target: pdfSearchView; visible: false }
            PropertyChanges { target: pdfScreenPinchArea; enabled: false }    // [ITS 257692] pdfscreen area로 pincharea 이동

        },
        State {
            name:  "pdfScreenView"
//            PropertyChanges { target: modeAreaWidget ; modeAreaModel: modeAreaModelPDFScreen }
//            PropertyChanges { target: modeAreaWidget; y: Dimensions.const_AppUserManual_StatusBar_Height }      // pdfscreen 진입 시 항상 보이기
            PropertyChanges { target: pdfList; visible: false }
            PropertyChanges { target: pdfTitleList; visible: false }
            PropertyChanges { target: pdfChapterList; visible: false }
            PropertyChanges { target: pdfScreen; visible: true; z: 0 }
            PropertyChanges { target: statusBar; visible: true; z: 10 }
            PropertyChanges { target: pdfSearchView; visible: false }
            PropertyChanges { target: pdfScreenPinchArea; enabled: true }    // [ITS 257692] pdfscreen area로 pincharea 이동
        },
        State {
            name: "pdfSearchView"
//            PropertyChanges {target: modeAreaWidget; visible: false }
//            PropertyChanges { target: modeAreaWidget; y: Dimensions.const_AppUserManual_StatusBar_Height }      // 진입 시 항상 보이기
            PropertyChanges { target: pdfList; visible: false }
            PropertyChanges { target: pdfTitleList; visible: false }
            PropertyChanges { target: pdfChapterList; visible: false}
            PropertyChanges { target: pdfScreen; visible: false; }
            PropertyChanges { target: statusBar; visible: true; z: 0 }
            PropertyChanges { target: pdfSearchView; visible: true }
            PropertyChanges { target: pdfScreenPinchArea; enabled: false }    // [ITS 257692] pdfscreen area로 pincharea 이동
        }
    ]

    function launchMenu( ) //toBeFocused )
    {
        console.log("Main.qml :: launchMenu() state : " , state )
        setFullScreen(false)
        statusBar.y = 0
        if ( state == "pdfScreenView") {
            pdfScreen.item.launchMenu()
            pdfScreen.item.lostFocus(true)
        }
        console.log("Main.qml :: launchMenu() ; tmpFocusIndex : ", tmpFocusIndex )
        if ( focusIndex == Dimensions.const_AppUserManual_ModeArea_FocusIndex )
            modeAreaBeforeIndex = tmpFocusIndex
        else tmpFocusIndex = focusIndex
        focusIndex = Dimensions.const_AppUserManual_OptionMenu_FocusIndex

        optionMenu.setFocus( 1 )

        if( appUserManual.state == "pdfListView" )
        {
            console.log("1")
            optionMenu.menuHandler(0)
        }
        else if( appUserManual.state == "pdfScreenView" )
        {
            if( okTextEnable ) {
                optionMenu.menuHandler( 2 )
            }
            else {
                optionMenu.menuHandler(1);
            }
        }
        optionMenu.visible = true
    }

    function setGotoPageBox( showGotoBox )
    {
        console.log("Main.qml :: setGotoPageBox - showGotoBox : ", showGotoBox )
        gotoPageBox = showGotoBox
        console.log("Main.qml :: setGotoPageBox - gotoPageBox : ", gotoPageBox , " ,  state : ", state)
//        if( !showGotoBox )
//        {
//            pdfScreen.item.updatePageNumbers()
//        }
    }

    function startTimer()
    {
        console.log("Main.qml :: startTimer()" )
        if ( appUserManual.state == "pdfScreenView" ) pdfScreen.item.startTimer()
    }

    function stopTimer()
    {
        console.log("Main.qml :: stopTimer()" )
        if ( appUserManual.state == "pdfScreenView" ) pdfScreen.item.stopTimer()
    }

    function setSos()
    {
        console.log("Main.qml :: setSos()" , UIListener.getCurrentScreen() )
        nowFG = false
        setForegroundEvent()
        popup_loader.visible = false
        lockoutMode = false
        gotoPageBox = false
        if ( threadRunning ) {
            pdfScreen.item.threadQuit();
            threadRunning = false
        }
        if ( tempPopup ) {
            exitSearchNotFound()
            tempPopup = false
        }
        EngineListener.saveState( state  ,  1 , totalPage , UIListener.getCurrentScreen() )
    }

    function clearAllPopup()            // disable_popup 제외
    {
        toast_searchview.visible = false
        warningPopUp.visible = false
        toast_popUp.visible = false
        searchEndPopUp.visible = false
        pagePopUp.visible = false
    }

    function showDRSPopup()
    {
        console.log("Main.qml :: showDRSPopup() - state: ", state )
        lockoutMode = true
        stopAnimation()     // 주행규제 시 애니메이션 stop
        if ( !changePdfTimer.running) {
            console.log("Main.qml :: showDRSPopup() - changePdfTimer ")
            changePdfPopUp.visible = false
        }
        clearAllPopup()
        if ( threadRunning ) {              // 검색 thread 취소
            console.log("Main.qml :: showDRSPopup() - threadRunning ")
            pdfScreen.item.threadQuit();
            threadRunning = false
        }
        state = EngineListener.getState(UIListener.getCurrentScreen() )
        if ( state == "") {
            console.log("Main.qml :: showDRSPopup() - state NULL")
            setForegroundEvent()
        }
        if ( state == "pdfScreenView" ) {
            console.log("Main.qml :: showDRSPopup() - pdfScreenView ")
            curPage = EngineListener.getPage()
            pdfScreen.item.gotoPageTemporalMode(curPage)
            setFullScreen( false )
            console.log("Main.qml :: showDRSPopup() - page: " , curPage )
            showPageNumbers( curPage )
        }
        if ( state == "pdfSearchView" ) {       // 검색 화면 > 주행규제 시 이전 화면으로 복귀
            console.log("Main.qml :: showDRSPopup() - pdfSearchView ")
            console.log("Main.qml :: showDRSPopup() 1")
            searchViewBackKey()
            //handleBackKey( false , false , false )
        }
        else if ( gotoPageBox ) {                   // 페이지 이동 동작 중일 경우 취소
            console.log("Main.qml :: showDRSPopup() - gotoPageBox ")
            pagePopUp.visible = false
            pdfScreen.item.showKeyPad( false )
            setFullScreen( false )
        }
        else if ( okTextEnable ) {          // PDF 화면에서 검색 중일 경우 검색 취소
            console.log("Main.qml :: showDRSPopup() - okTextEnable ")
            searchText = ""
            searchOKTextEnable( false )
            clearSearchLocation()
            setFullScreen( false )
        }
        modeAreaWidget.setFocusDrsMode()
        modeAreaWidget.setFG()
        if (optionMenu.visible) //if ( focusIndex == Dimensions.const_AppUserManual_OptionMenu_FocusIndex )  //hyeonil.shin ITS NA 0230963
        {
            console.log(" Main.qml :: showDRSPopup() - optionmenu hide " )
            focusIndex = tmpFocusIndex
            optionMenu.visible = false
        }
        pdfScreen.item.setFG(true)
        pdfScreen.item.showKeyPad( false )
        pdfSearchView.item.setDRS()
        exitZoom()
        setFullScreen( false )
        popup_loader.source = "DRSPopup.qml"
        popup_loader.visible = true
        pdfScreen.visible = false
        lockoutMode = true
    }

    function exitZoom()
    {
        console.log("Main.qml :: exitZoom()")
        minZoom = true
        pdfScreen.item.exitZoom()
    }

     Timer {
        id: loadSearch_timer
        interval: 500
        running: false
        onTriggered:
        {
            if( pdfSearchView.source != "DHAVN_AppUserManual_SearchView.qml"  ) {
                console.log("E-MANUAL Main.qml :: loadSearch_timer onTriggered - load searchview.qml")
                pdfSearchView.source = "DHAVN_AppUserManual_SearchView.qml"
                pdfSearchView.visible = true
            }
            else {
                console.log("E-MANUAL  Main.qml :: loadSearch_timer onTriggered - clear SearchView")
                pdfSearchView.clearSearchView()
            }
        }
     }
     GestureArea {
         id: pdfScreenPinchArea
         anchors.fill:  parent
         width: Dimensions.const_AppUserManual_MainScreenWidth
         height: Dimensions.const_AppUserManual_MainScreenHeight - ( Dimensions.const_AppUserManual_StatusBar_Height + Dimensions.const_AppUserManual_ModeArea_Height )
         enabled: appUserManual.state == "pdfScreenView" && pdfScreen.item.visible && !pdfScreen.item.getNumericVisible()
         property int centerPointX: -1
         property int centerPointY: -1
         property bool bPinchStart: false
         property bool bPanStart: false

         Pan {
             onStarted: {
                 if ( pdfScreenPinchArea.bPinchStart ) return;
                 EngineListener.logForQML("Pan onStarted "  )
                 pdfScreenPinchArea.bPanStart = true
             }
             onUpdated: {
                 EngineListener.logForQML("Pan onUpdated "  )
             }
             onFinished: {
                 EngineListener.logForQML("Pan onFinished "  )
                 if ( pdfScreenPinchArea.bPanStart && minZoom && !lockoutMode ) {
                     pdfScreenPinchArea.bPanStart = false
                     if (gesture.offset.x > 75 && Math.abs(gesture.offset.y) < 300) { //modified by aettie 20130522 for Master car QE issue
                         okTextEnable ? pdfScreen.item.nextPrevSearch(false) : pdfScreen.item.nextPrevPage(false)
                     } else if (gesture.offset.x < -75 && Math.abs(gesture.offset.y) < 300) { //modified by aettie 20130522 for Master car QE issue
                         okTextEnable ? pdfScreen.item.nextPrevSearch(true) : pdfScreen.item.nextPrevPage(true)
                     }
                 }
             }
         }

         Pinch {
             onStarted: {
                 EngineListener.logForQML("onStarted - previousScalingFactor: " +  gesture.totalScaleFactor )
                 pdfScreenPinchArea.bPinchStart = true;
                 previousScalingFactor = gesture.totalScaleFactor
//                 previousScalingFactor = mainImage.scale
                 pdfScreenPinchArea.centerPointX = gesture.centerPoint.x
                 pdfScreenPinchArea.centerPointY = gesture.centerPoint.y
             }
             onUpdated: {
                 var newScale =  gesture.totalScaleFactor //- previousScalingFactor// * previousScalingFactor
                 EngineListener.logForQML("onUpdated - previous: " + previousScalingFactor + ", new: " + gesture.totalScaleFactor +  " , new-prev: " +  newScale )
         //modified by aettie for Master Car QE issue 20130523
                 if ( newScale > 1.4 && newScale < 3  ) return
                 if ( newScale < 0.7 ) return;

                 pdfScreen.item.pinchZoomWidget( newScale )// , gesture.centerPoint.x , gesture.centerPoint.y )
                 previousScalingFactor = newScale
             }
             onFinished: {
                 EngineListener.logForQML("onFinished")
                pdfScreenPinchArea.bPinchStart = false
             }
         }
     }
/*
     PinchArea
     {
         y: Dimensions.const_AppUserManual_StatusBar_Height
         enabled: appUserManual.state == "pdfScreenView" && pdfScreen.item.visible && !pdfScreen.item.getNumericVisible()
         clip: true
         visible: ( appUserManual.state == "pdfScreenView" && pdfScreen.item.visible && !pdfScreen.item.getNumericVisible() ) ? true : false
         onPinchUpdated:
         {
             if ( lockoutMode ) {
                 console.log("Main.qml :: onPinchUpdated - lockoutMode")
                 return;
             }
             if ( pdfScreen.item.getNumericVisible() ) {
                 console.log("Main.qml :: onPinchUpdated - numeric keypad")
                 return;
             }
             pdfScreen.item.stopAnimation() // PDF Screen Drag animation stop
             var updateScale = pinch.scale - pinch.previousScale
             if( pinch.scale - pinch.previousScale == 0 || ( updateScale >= -0.015 && updateScale <= 0.015 ) )
             return;
             if ( pinchCnt == 0 ) {
                 if ( updateScale <0 ) pinchZoomIn = false
                 else pinchZoomIn = true
             }

             if ( updateScale < 0 )              // 축소
             {
                 if ( pinchZoomIn )  // 이전 동작이 확대
                 {
                     pinchCnt = 0
                     pinchZoomIn = false
                 }
                 pinchCnt++
                 if ( pinchCnt > 15) {
                     console.log("Main.qml :: onPinchUpdated - exit")
                     return;
                 }
                 if ( pinchCnt % 3 == 0 ) {
                     console.log("Main.qml :: onPinchUpdated - updateScale: " , updateScale)
                     pdfScreen.item.pinchZoomWidget( updateScale * 2 )
                 }
             }
             else            // 확대
             {
                 if ( !pinchZoomIn )      // 이전 동작이 축소
                 {
                     pinchCnt = 0
                     pinchZoomIn = true
                 }
                 pinchCnt++
                 if ( pinchCnt > 12) {
                     console.log("Main.qml :: onPinchUpdated - exit")
                     return;
                 }
                 if ( pinchCnt % 3 == 0 ) {
                     console.log("Main.qml :: onPinchUpdated - updateScale: " , updateScale)
                     pdfScreen.item.pinchZoomWidget( updateScale *2 )
                 }
             }
             if ( minZoom ) setFullScreen( false)
             else {
                 setFullScreen( true )
                 pdfScreen.item.fullScreen( false)
             }
             pdfScreen.item.fullScreen( false )
         }
         onPinchFinished:
         {
             console.log("Main.qml :: onPinchFinished")
             if  ( modeAreaWidget.getMenuBtnPressed() ) {
                 console.log("Main.qml :: onPinchFinished 1")
                 launchMenu()
                 modeAreaWidget.setFG()
             }
             if  ( modeAreaWidget.getBackBtnPressed() ) {
                 console.log("Main.qml :: onPinchFinished 2")
                 handleBackKey( false ,  true , true )
                 modeAreaWidget.setFG()
             }
             pinchCnt = 0
             EngineListener.playAudioBeep()
         }
     }
*/

    DHAVN_AppUserManual_Background
    {
        id: appUserManualBackground
        y: 0 //( Dimensions.const_AppUserManual_StatusBar_Height + Dimensions.const_AppUserManual_ModeArea_Height )
    }

    DHAVN_AppUserManual_Menu
    {
        id: optionMenu
        visible: false
        z: 1000

        onHandleFocusChange:
        {
            console.log(" Main.qml :: Menu :: onHandleFocusChange before focusIndex : ", focusIndex)
            focusIndex = tmpFocusIndex
            if ( focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex )
                pdfChapterList.item.focusImageChange( 2 )
            console.log(" Main.qml :: Menu :: onHandleFocusChange after focusIndex : ", focusIndex)
            tmpFocusIndex = Dimensions.const_AppUserManual_FocusNone
        }
        onVisibleChanged:
        {
            pdfList.item.setOpionMenuVisible(visible)
        }
    }

    Loader {
        id: popup_loader;       // 주행규제 전창 팝업
        visible: false
        onVisibleChanged:
        {
            if ( visible ) {
                console.log("Main.qml :: popup_loader - onVisibleChanged (true)")
                if ( pdfList.visible ) drsList = true
                else drsList = false
                pdfList.visible = false
                pdfTitleList.visible = false
                pdfChapterList.visible = false
                pdfScreen.visible = false
                pdfSearchView.visible = false
                startTimer()
            }
            else {
                console.log("Main.qml :: popup_loader - onVisibleChanged (false)")
                if ( drsList ) {
                    pdfList.visible = true
                    pdfTitleList.visible = true
                    pdfChapterList.visible = true
                }
                else {
                    pdfScreen.visible = true
                }
                pdfSearchView.visible = false
                drsList = false
            }
        }
    } //y: (Dimensions.const_AppUserManual_StatusBar_Height + Dimensions.const_AppUserManual_ModeArea_Height  - 1); z: 2000;}
   QmlStatusBar {
       id: statusBar
       x: 0; y: 0;
       width: Dimensions.const_AppUserManual_MainScreenWidth; height: Dimensions.const_AppUserManual_StatusBar_Height
       homeType: "button"
       middleEast: ( langId == 20 ) ? true : false
       onYChanged: {
           console.log("Main.qml :: statusBar - onYChanged : ", y)
           if ( y == 0 ) pdfScreen.item.sendToControllerFullScreen(false)
           else if ( y == -186 ) pdfScreen.item.sendToControllerFullScreen(true)
       }
       Behavior on y
       {
           PropertyAnimation {
               duration: modeareaDuration ? 0 : (appUserManual.state == "pdfScreenView" ? Dimensions.const_FULLSCREEN_DURATION_ANIMATION : 0)
           }
       }
       DHAVN_ModeArea
      {
          id: modeAreaWidget

    //        modeAreaModel: state == "pdfListView" ? modeAreaModelPDFList : modeAreaModelPDFScreen
          y: 93 // Dimensions.const_AppUserManual_StatusBar_Height
    //        z: Dimensions.const_AppUserManual_Z_1000

          Behavior on y
          {
              PropertyAnimation {
                  duration: modeareaDuration ? 0 : (appUserManual.state == "pdfScreenView" ? Dimensions.const_FULLSCREEN_DURATION_ANIMATION : 0)
              }
          }

          onLostFocus:
          {
              console.log( "Main.qml :: Lost Focus from Mode Area Received" )
              focusIndex = tmpFocusIndex
              console.log("Main.qml :: focusIndex : ", focusIndex)
              if( focusIndex == Dimensions.const_AppUserManual_TitleList_FocusIndex ||  focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex ) {
                  focusIndex = Dimensions.const_AppUserManual_PageNumList_FocusIndex
                  pdfChapterList.item.focusImageChange( 0 )
              }
              else if( focusIndex == Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
                  pdfScreen.item.setFocus(false)
              else
               {
                  console.log("Main.qml :: Lost Focus Mode Area else - modeAreaBeforeIndex : ", modeAreaBeforeIndex )
                  focusIndex = modeAreaBeforeIndex
                  if( focusIndex == Dimensions.const_AppUserManual_TitleList_FocusIndex )
                      pdfTitleList.item.focusImageChange( 0 )
                  else if( focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex )
                      pdfChapterList.item.focusImageChange( 2 ) //0 )
                  else if( focusIndex == Dimensions.const_AppUserManual_PDF_Screen_FocusIndex )
                      pdfScreen.item.setFocus(false)
              }

              tmpFocusIndex = Dimensions.const_AppUserManual_FocusNone
              modeAreaBeforeIndex = Dimensions.const_AppUserManual_FocusNone

              pdfList.item.updownSetVisualCue( false , true, true )
          }

          ListModel
          {
              id: startPageModel
          }

          Item        // numericKeypad
          {
              id: gotoPageNumberItem
    //            x: appUserManual.countryVariant == 4 ? Dimensions.const_AppUserManual_Goto_Search_Arab_X :  Dimensions.const_AppUserManual_Goto_Search_X -  47 //27
              x: langId == 20 ? 150  : 910 //  Dimensions.const_AppUserManual_Goto_Search_Arab_X : Dimensions.const_AppUserManual_Goto_Search_X -  47 //27
              y: Dimensions.const_AppUserManual_ModeArea_Y - 2
              width: Dimensions.const_AppUserManual_GoTo_Search_Width
              height: Dimensions.const_AppUserManual_GoTo_Search_Height
              visible: gotoPageBox &&  pdfScreen.item.visible && !lockoutMode // ( pdfScreen.item.visible && modeAreaPage == "" )

              Image
              {
                  id: gotoSearchBox
                  source: Images.const_AppUserManual_NumKeyPad_SearchBox
                  width: sourceSize.width; height: sourceSize.height //Dimensions.const_AppUserManual_GoTo_Search_Width - 73
                  // Dimensions.const_AppUserManual_GoTo_Search_Height
                  anchors.left: parent.left
    //                anchors.leftMargin: appUserManual.countryVariant == 4 ? 90 : 10
                  anchors.leftMargin: langId == 20 ? 90 : 10
                  anchors.top: parent.top; anchors.topMargin: 3
                  TextInput
                  {
                      id: text_input
                      property int cursor_pos: -1
                      anchors.top: parent.top
                      anchors.topMargin: Dimensions.const_AppUserManual_GoTo_TopMargin
                      anchors.left: parent.left
                      anchors.leftMargin: Dimensions.const_AppUserManual_TitleList_LeftMargin
                      anchors.right: parent.right
                      anchors.rightMargin: Dimensions.const_AppUserManual_TitleList_LeftMargin
                      color: Dimensions.const_AppUserManual_ListText_Color_Black
                      font.pixelSize: Dimensions.const_AppUserManual_Search_Font_Size_30
                      smooth: true
                      cursorPosition: 0
                      text: pageNumberEntered
                      selectByMouse: false
                      horizontalAlignment: langId == 20 ?  TextInput.AlignLeft :  TextInput.AlignRight
                      visible: false
                  }
                  Text
                  {
                      id: searchBoxText
                      anchors.top: parent.top
                      anchors.topMargin: 14
                      anchors.left: parent.left
                      anchors.leftMargin: 14
                      width: 96
                      text:  text_input.text.length == 0 ? curPage : text_input.text
                      //text:  text_input.text.length == 0 ? "1" : text_input.text
                      color: text_input.text.length == 0 ? Dimensions.const_AppUserManual_Search_Font_Color : Dimensions.const_AppUserManual_ListText_Color_Black
                      font.pixelSize: Dimensions.const_AppUserManual_Search_Font_Size_30
                      horizontalAlignment: langId == 20 ?  TextInput.AlignLeft :  TextInput.AlignRight
                  }
              }

              Text
              {
                  font.pixelSize: Dimensions.const_AppUserManual_Search_Font_Size_30
                  anchors.verticalCenter: parent.verticalCenter
    //                anchors.left: appUserManual.countryVariant == 4 ? parent.left : gotoSearchBox.right
                  anchors.left: langId == 20 ? parent.left : gotoSearchBox.right
                  anchors.leftMargin:10
                  color: Dimensions.const_AppUserManual_ListText_Color_BrightGrey // Dimensions.const_AppUserManual_GoTo_Text_Color
                  font.family: vehicleVariant == 1 ? "KH_HDB" : "DH_HDB"
                  text: langId == 20 ? totalPage + "/" :  "/" + totalPage
                  style: Text.Sunken
                  clip: true
                  visible: true
              }
          }
      }
   }

    Loader { id: pdfList ; parent: appUserManualBackground ; y:  ( Dimensions.const_AppUserManual_StatusBar_Height + Dimensions.const_AppUserManual_ModeArea_Height ); z: Dimensions.const_AppUserManual_Z_1 }
    Loader { id: pdfTitleList ; parent: appUserManualBackground; y:  ( Dimensions.const_AppUserManual_StatusBar_Height + Dimensions.const_AppUserManual_ModeArea_Height ) }
    Loader { id: pdfChapterList ; parent: appUserManualBackground; y:  ( Dimensions.const_AppUserManual_StatusBar_Height + Dimensions.const_AppUserManual_ModeArea_Height ) }
    Loader { id: pdfScreen ; visible: false }
    Loader { id: pdfSearchView ; visible: false  }


    /// Main Popup ///
    POPUPWIDGET.PopUpText
    {
        id: disable_popup
        z: Dimensions.const_AppUserManual_Z_1000
        visible: false

        message: ListModel {
            ListElement { msg: "This feature is not supported in the current language." } //QT_TR_NOOP("STR_VR_NOT_SUPPORT") }
        }

        buttons: ListModel {
            ListElement { msg: "OK" } //QT_TR_NOOP("STR_MANUAL_OK"); btn_id: 1 }
        }

        onBtnClicked:
        {
            if ( !disable_popup.visible ) return
            console.log("Main.qml :: disable_popup onBtnClicked")
            disable_popup.visible = false
            EngineListener.HandleBackKey( UIListener.getCurrentScreen() , false, true )
            EngineListener.HandleBackKey( UIListener.getCurrentScreen() , false, false )
        }
    }

    Timer {
       id: changePdfTimer
       interval: 1000
       running: false
       onTriggered:
       {
           console.log("Main.qml :: changePdfTimer onTriggered")
           receivedTitles = false
           pdfScreen.item.setLanguage()
           if ( systemPopupVisible ) {
               systemPopupFocusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
               focusIndex = Dimensions.const_AppUserManual_FocusNone
               setForegroundEventSystemPopup()
           }
           else if (!lockoutMode) { //hyeonil.shin (ITS DH_CHN 0230079)
            setForegroundEvent()
           }
           else {
               //DRS on
               changePdfPopUp.visible = false
               showDRSPopup();
           } //hyeonil.shin
           if ( !nowFG ) changeLanguageBG = true        // 언어 변경 완료 후 FG가 아니라면, changeLanguageBG를 true로 설정해 temporal mode 진입 시 목록화면으로 전환되도록.
       }
    }

    Loader {
        id: changePdfPopUp
        z: 1000
        visible: false
        Binding{
            id: changePdf_visibleBinding
            target: changePdfPopUp
            property: "visible"
            value: (changePdfPopUp.item == null) ? false : changePdfPopUp.item.visible
        }
        onVisibleChanged:
        {
            if ( visible ) {
                console.log("Main.qml :: changePdfPopUp - onVisibleChanged true")
                source = "DHAVN_AppUserManual_ChangePdfPopUp.qml"
            }
            else {
                console.log("Main.qml :: changePdfPopUp - onVisibleChanged false")
                source = ""
            }
        }
    }

    /// Search Popup ////
    POPUPWIDGET.PopUpText
    {
        id: toast_searchview
        z: Dimensions.const_AppUserManual_Z_1000
        visible: false
        message: toast_text_model
        icon_title: EPopUp.LOADING_ICON

        // hyeonil.shin [ITS DH_CHN 229944]
        Connections {
            target: EngineListener

            onPressedBackHK: {
                if (!toast_searchview.visible)
                    return;

                if ( threadRunning ) {
                    pdfScreen.item.threadQuit();
                    threadRunning = false
                }

                toast_searchview.visible = false;
                pdfSearchView.item.clearSearchView();
            }
        } ////////////// hyeonil.shin
    }
    ListModel
    {
        id: toast_text_model
        ListElement { msg: QT_TR_NOOP("STR_MANUAL_WAITING") }
    }
    Loader {
        id: warningPopUp
        z: 1000
        visible: false
        Binding{
            id: warning_visibleBinding
            target: warningPopUp
            property: "visible"
            value: (warningPopUp.item == null) ? false : warningPopUp.item.visible
        }
        onVisibleChanged:
        {
            if ( visible ) {
                console.log("Main.qml :: warningPopUp - onVisibleChanged true")
                source = "DHAVN_AppUserManual_WarningPopUp.qml"
            }
            else {
                console.log("Main.qml :: warningPopUp - onVisibleChanged false")
                source = ""
                warningPopUp.visible = false
                pdfSearchView.item.clearSearchView()       // 검색 결과 없음 팝업 close 시 searchview clear
            }
        }
    }

    /// PDF Screen Popup ///
    POPUPWIDGET.PopUpText
    {
        id: toast_popUp
        z: Dimensions.const_AppUserManual_Z_1000
        visible: false
        message: toast_text_model
        icon_title: EPopUp.LOADING_ICON
        onVisibleChanged: {
            if ( visible ) {
                pdfScreen.item.lostFocus(true)
            }
//            else {
//                pdfScreen.item.lostFocus(false)
//            }
        }
    }
    Loader {
        id: searchEndPopUp
        z: 1000
        visible: false
        Binding{
            id: searchEnd_visibleBinding
            target: searchEndPopUp
            property: "visible"
            value: (searchEndPopUp.item == null) ? false : searchEndPopUp.item.visible
        }
        onVisibleChanged:
        {
            if ( visible ) {
                console.log("Main.qml :: searchEndPopUp - onVisibleChanged true")
                source = "DHAVN_AppUserManual_SearchEndPopUp.qml"
                pdfScreen.item.lostFocus(true)
            }
            else {
                console.log("Main.qml :: searchEndPopUp - onVisibleChanged false")
                source = ""
                searchEndPopUp.visible = false
                searchText = ""
                searchOKTextEnable( false )
                pdfScreen.item.lostFocus(false)
            }
        }
    }
    Loader {
        id: pagePopUp
        z: 1000
        visible: false
        Binding{
            id: page_visibleBinding
            target: pagePopUp
            property: "visible"
            value: (pagePopUp.item == null) ? false : pagePopUp.item.visible
        }
        onVisibleChanged:
        {
            if ( visible ) {
                console.log("Main.qml :: pagePopUp - onVisibleChanged true")
                source = "DHAVN_AppUserManual_PagePopup.qml"
            }
            else {
                console.log("Main.qml :: pagePopUp - onVisibleChanged false")
                pageNumberEntered = ""
                if ( !systemPopupVisible ) pdfScreen.item.setKeyboardFocus( true )
                startTimer()
                source = ""
            }
        }
    }

    Connections
    {
        target: pdfTitleList.item

        onHandleFocusChange:
        {
            console.log("Main.qml :: pdfTitleList.item onHandleFocusChange - before focusIndex : ", focusIndex)
//            if( toFocusIndex === Dimensions.const_AppUserManual_ModeArea_FocusIndex )
//                modeAreaWidget.setDefaultFocus( UIListenerEnum.JOG_UP )
            tmpFocusIndex = fromFocusIndex
            focusIndex = toFocusIndex

            // title list touch로 인해 우측 영역으로 포커스 이동 시 focus list를 초기화해 scroll text 동작하도록 수정
            if ( focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex ) pdfChapterList.item.resetFocusIndex()
            console.log("Main.qml :: pdfTitleList.item onHandleFocusChange - after focusIndex : ", focusIndex)
        }
    }

    Connections
    {
        target: pdfChapterList.item

        onHandleFocusChange:
        {
            console.log("Main.qml :: pdfChapterList.item onHandleFocusChange- before focusIndex : ", focusIndex)
//            if( toFocusIndex === Dimensions.const_AppUserManual_ModeArea_FocusIndex )
//                modeAreaWidget.setDefaultFocus( UIListenerEnum.JOG_UP )
            tmpFocusIndex = fromFocusIndex
            focusIndex = toFocusIndex
            pdfTitleList.item.focusImageChange( 0 )
            console.log("Main.qml :: pdfChapterList.item onHandleFocusChange - after focusIndex : ", focusIndex)
        }
    }

    Connections
    {
        target: pdfScreen.item

        onHandleFocusChange:
        {
            console.log("Main.qml :: pdfScreen.item onHandleFocusChange- before focusIndex : ", focusIndex)
            tmpFocusIndex = fromFocusIndex
            focusIndex = toFocusIndex
            if( toFocusIndex == Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) modeAreaWidget.lostFocus()
            focusIndex = toFocusIndex
//                modeAreaWidget.setDefaultFocus( UIListenerEnum.JOG_UP )
            console.log("Main.qml :: pdfScreen.item onHandleFocusChange - after focusIndex : ", focusIndex)
        }
    }

    Connections
    {
        target: EngineListener

        onRetranslateUi:
        {
            console.log("Main.qml :: onRetranslateUi");
            if ( langId == lang ) {
                console.log("Main.qml :: onRetranslateUi - not change! return!")
                return;
            }
            LocTrigger.retrigger()
            showPDFTitle()
            langId = lang
            clearAllPopup()
            stopAnimation()
            if ( threadRunning ) {
               pdfScreen.item.threadQuit();
               threadRunning = false
           }
            if ( countryVariant == 0 ) {        // 정업 이후 해당 부분 제거 예정
                if ( lang == 2 ) {      // 내수, 한글일 경우
                    disable_popup.visible = false
                }
                else {          // 내수, 영어일 경우 지원불가 팝업 출력 후 return
                    disable_popup.visible = true
                    if ( focusIndex == Dimensions.const_AppUserManual_OptionMenu_FocusIndex )
                    {
                        console.log("Main.qml :: onRetranslateUi - optionMenu return")
                        handleBackKey( false , false , false )
                    }
                    else if ( state == "pdfSearchView") {
                        pdfSearchView.item.showDisablePopup()
                    }
                    else if ( state == "pdfScreenView" ) {
                        pdfScreen.item.showDisablePopup()
                    }
                }
                return;
            }
            if ( countryVariant != 0 ) {      // 내수가 아니면 pdf 변경(정업 전까지만 해당 조건 check)
                console.log("Main.qml :: onRetranslateUi - change PDF");
                changePdfPopUp.visible = true
                changePdfTimer.start()
            }
            if ( !nowFG )       // BG 상태에서 언어 변경 시
                changeLanguageBG = true
        }

        onShowDisablePopup:
        {
            console.log("Main.qml :: onShowDisablePopup - visible: ", visible );
            disable_popup.visible = visible
        }

        onSetTouchLock:
        {
            console.log("Main.qml :: onSetTouchLock")
            touchLock = lock;
            pdfScreen.item.setTouchLock(touchLock)
        }

        onBackgroundEvent:
        {
            if( screenId == UIListener.getCurrentScreen() )
            {
                console.log("Main.qml :: onBackgroundEvent")
                stopAnimation()     // BG 시 애니메이션 stop
                disable_popup.visible = false
                changePdfPopUp.visible = false
                if ( state == "pdfScreenView" ) pdfScreen.item.stopTimer()
                nowFG = false
                pdfScreen.item.clearTouch()

                // ITS 229908, BG일 경우 검색 stop, 이후 temporal mode로 진입 시 restartThread true일 경우 검색 restart
                if ( threadRunning ) {
                    pdfScreen.item.threadQuit();
                    threadRunning = false
                    restartThread = true
                }
                console.log("Main.qml :: onBackgroundEvent - state: " , state , " , tempState: " , tempState , " , curPage : " , curPage )
                if ( !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
                EngineListener.saveGotoPage( gotoPageBox )
//                EngineListener.saveTempState( tempState , curPage )
            }
        }

        onTemporalMode:
        {
            if( screenId != UIListener.getCurrentScreen() ) return;
            if ( disable_popup.visible ) return
            if ( !changePdfTimer.running) {
                changePdfPopUp.visible = false
            }
            if ( changeLanguageBG ) {       // BG 상태에서 언어 변경했을 경우 목록화면으로 복귀
                setForegroundEvent()
                changeLanguageBG = false
                nowFG = true
                return;
            }
            if ( state == "" )  setForegroundEvent()
            state = saveState
            tempState = saveTempState
            console.log("Main.qml :: TemporalMode Event Received. - state: " , state , " , saveState: " , saveState )
            if ( popup_loader.source != "" ) popup_loader.source = "";
            lockoutMode = false
            popup_loader.visible = false
            nowFG = true
//            setFullScreen( false )
            //optionMenu.setFG()
            if ( state == "pdfListView" ) {
                console.log("Main.qml :: TemporalMode  - state: " , state  )
                if ( focusIndex > 0 && focusIndex < 6 ) ;
                else setForegroundEvent()
            }
            else if ( saveState == "pdfScreenView" ) {
                console.log("Main.qml :: TemporalMode  - state: " , state  )
                if ( searchEndPopUp.visible || optionMenu.visible ) {
                }
                else if (toast_searchview.visible || restartThread ) {              // restartThread true면 검색 restart (검색중에 BG > temporalMode FG인 경우)
//                    pdfSearchView.item.toastPopupVisible( true )
                    searchString( true )
                    restartThread = false
                }
                else {
                    startTimer()
                    pdfScreen.item.setFG((appUserManual.focusIndex==Dimensions.const_AppUserManual_ModeArea_FocusIndex || appUserManual.focusIndex==Dimensions.const_AppUserManual_OptionMenu_FocusIndex)? false : true)
                }
                if ( curPage == EngineListener.getPage() ) {
                    showPageNumbers(curPage)
                    if (optionMenu.visible ) ;
                    else if ( gotoPage ) {
                        if ( !gotoPageBox ) pdfScreen.item.launchKeyPad(true)
                    }
                    else {
                        pdfScreen.item.launchKeyPad(false)
                        //setFullScreen( false )       // ITS 246203, fullscreen 전환할 필요없음(이전 상태 유지)
                    }
                    return;
                }
                curPage = EngineListener.getPage()
                totalPage = EngineListener.getTotalPage()
                pdfScreen.item.gotoPageTemporalMode(curPage)
                showPageNumbers(curPage)
                if (searchEndPopUp.visible || optionMenu.visible ) ;
                else if ( gotoPage ) {
                    if ( !gotoPageBox ) pdfScreen.item.launchKeyPad(true)
                }
                else {
                    pdfScreen.item.launchKeyPad(false)
                    //setFullScreen( false )        // ITS 246203, fullscreen 전환할 필요없음(이전 상태 유지)
                }
                console.log("Main.qml :: TemporalMode page : " ,  curPage , " / " , totalPage )
            }
            else if ( state == "pdfSearchView") {
                if( pdfSearchView.source != "DHAVN_AppUserManual_SearchView.qml"  )
                    pdfSearchView.source = "DHAVN_AppUserManual_SearchView.qml"
                pdfSearchView.visible = true
                tempState = saveTempState
                pdfSearchView.item.setKeypadDisable(false)
                focusIndex = Dimensions.const_AppUserManual_Search_View_FocusIndex
                setFullScreen( false )
                if ( state != "pdfSearchView" ) state = "pdfSearchView"
                pdfList.visible =  false
                pdfChapterList.visible =  false
                pdfTitleList.visible =  false
                pdfScreen.visible =  false
                statusBar.visible =  true
                pdfSearchView.visible =  true
                if ( restartThread ) {              // restartThread true면 검색 restart (검색중에 BG > temporalMode FG인 경우)
                    pdfSearchView.item.toastPopupVisible( true )
                    searchString( true )
                    restartThread = false
                }
            }
            if ( !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
        }

        onTemporalSettingMode:
        {
            if( screenId != UIListener.getCurrentScreen() ) return;
            if ( disable_popup.visible ) {
                if ( popup_loader.source != "" ) popup_loader.source = "";
                lockoutMode = false
                popup_loader.visible = false
                return
            }
            changePdfPopUp.visible = false
            if ( state == "" )  setForegroundEvent()
            state = ""
            state = saveState
            tempState = saveTempState
            console.log("Main.qml :: onTemporalSettingMode Event Received. - state: " , state , ", tempState : " , tempState )
            if ( lockoutMode && state == "pdfSearchView" ) {
                console.log("Main.qml :: onTempralSettingMode - here!!!")
                state = tempState
            }
            if ( popup_loader.source != "" ) popup_loader.source = "";
            lockoutMode = false
            popup_loader.visible = false
            nowFG = true
            modeareaDuration = true
            setFullScreen( false )
            modeareaDuration = false
            optionMenu.visible = false
            if ( state == "pdfScreenView" ) {
                console.log("Main.qml :: onTemporalSettingMode  - state: " , state  )
                exitZoom()
                pdfScreen.item.setFG(true);
                modeAreaWidget.lostFocus()
                modeAreaWidget.setFG()
                focusIndex =  Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
              /*  if ( curPage != EngineListener.getPage() )*/ {
                    curPage = EngineListener.getPage()
                    if ( curPage < 1 ) curPage = 1
                    totalPage = EngineListener.getTotalPage()
                    pdfScreen.item.gotoPageTemporalMode(curPage)
                    showPageNumbers(curPage)
                }
                if (searchEndPopUp.visible || optionMenu.visible ) ;
                else if ( gotoPage ) {
                    if ( !gotoPageBox ) pdfScreen.item.launchKeyPad(true)
                }
                else {
                    pdfScreen.item.launchKeyPad(false)
//                    setFullScreen( false )       // ITS 246203, fullscreen 전환할 필요없음(이전 상태 유지)
                }
                pdfList.visible = false
                pdfTitleList.visible = false
                pdfChapterList.visible = false
                pdfSearchView.visible = false
                pdfScreen.visible = true
                console.log("Main.qml :: onTemporalSettingMode page : " ,  curPage , " / " , totalPage )
            }
            else if ( state == "pdfSearchView") {
                if( pdfSearchView.source != "DHAVN_AppUserManual_SearchView.qml"  )
                    pdfSearchView.source = "DHAVN_AppUserManual_SearchView.qml"
                pdfSearchView.item.resetPress()
                pdfSearchView.item.setKeypadDisable(false)
                focusIndex = Dimensions.const_AppUserManual_Search_View_FocusIndex
                setFullScreen( false )
                if ( state != "pdfSearchView" ) state = "pdfSearchView"
                pdfList.visible =  false
                pdfChapterList.visible =  false
                pdfTitleList.visible =  false
                pdfScreen.visible =  false
                statusBar.visible =  true
                pdfSearchView.visible =  true
                if ( restartThread ) {              // restartThread true면 검색 restart (검색중에 BG > temporalMode FG인 경우)
                    pdfSearchView.item.toastPopupVisible( true )
                    searchString( true )
                    restartThread = false
                }
            }
            else {
                console.log("Main.qml :: onTemporalSettingMode  - state: " , state , " , focusIndex : " , focusIndex )
                state = "pdfListView"
                focusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex            // 주행규제 해제 시 목록화면 항상 초기화
                pdfTitleList.item.resetPress()
                pdfChapterList.item.resetPress()
                pdfTitleList.item.focusImageChange( 0 )
                pdfTitleList.item.setFG()
                if ( langId != 20 ) {
                    pdfList.item.setVisualCue( true , false )
                }
                else {
                    pdfList.item.setVisualCue( false , false )
                }
                appUserManual.activateMenuPane( true )
                pdfList.visible = true
                pdfTitleList.visible = true
                pdfChapterList.visible = true
                pdfScreen.visible = false
                pdfSearchView.visible = false
                drsList = false
            }
            if ( systemPopupVisible ) {
                systemPopupFocusIndex = focusIndex
                focusIndex = Dimensions.const_AppUserManual_FocusNone
            }
            if ( !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
        }

        onSetDefaultState:
        {
            if( screenId != UIListener.getCurrentScreen() ) return;
            if ( !nowFG ) state = "pdfListView"
            console.log("Main.qml ::  onSetDefaultState - state: ", state )
        }

        onHideDRSBtVrManual:
        {
            if( screenId != UIListener.getCurrentScreen() ) return;
            console.log("Main.qml ::  onSonHideDRSBtVrManualetDefaultState ")
            if ( popup_loader.source != "" ) popup_loader.source = "";
            lockoutMode = false
            popup_loader.visible = false
            state = "pdfScreenView"
            pdfScreen.item.setFG(true);
            modeAreaWidget.lostFocus()
            modeAreaWidget.setFG()
            focusIndex =  Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
          /*  if ( curPage != EngineListener.getPage() )*/ {
                curPage = (helpModeIsBt) ? btPage : vrPage // hyeonil.shin
                totalPage = EngineListener.getTotalPage()
                pdfScreen.item.gotoPageTemporalMode(curPage)
                showPageNumbers(curPage)
            }
            pdfList.visible = false
            pdfTitleList.visible = false
            pdfChapterList.visible = false
            pdfSearchView.visible = false
            pdfScreen.visible = true
        }

        onForegroundEvent:
        {
            if( screenId == UIListener.getCurrentScreen() )
            {
                console.log("Main.qml ::  onForegroundEvent")
                changePdfPopUp.visible = false
                disable_popup.visible = false
                changeLanguageBG = false
                restartThread = false
                setFullScreen(false)
              /*  if ( EngineListener.getDRSStatus() ) {
                    console.log("Main.qml ::  getDRSStatus() true")
                    return;
                }
                else*/ if ( nowFG ) {
                    console.log("Main.qml ::  nowFG true")
                    popup_loader.visible = false
                    if ( tempPopup ) {
                        exitSearchNotFound()
                        tempPopup = false
                    }
                    lockoutMode = false
                    if ( state == "pdfSearchView" ) {
//                        modeAreaWidget.visible = false
                        pdfSearchView.item.setKeypadDisable(false)
                    }
                    curPage = EngineListener.getPage()
                    EngineListener.savePage(curPage)
                    console.log("Main.qml ::  nowFG true - page: " , curPage )
                    if ( countryVariant == 0 && langId != 2 )     {       // 내수, 한글이 아닐 경우
                        disable_popup.visible = true
                    }
                    else disable_popup.visible = false
                    return;
                }
                if ( threadRunning ) {
                    pdfScreen.item.threadQuit();
                    threadRunning = false
                }
                nowFG = true
                setForegroundEvent()
                popup_loader.visible = false
                lockoutMode = false
                gotoPageBox = false
                if ( state == "pdfSearchView" ) {
//                    modeAreaWidget.visible = false
                    pdfSearchView.item.setKeypadDisable(false)
                }
                else {
                    pdfList.visible = true
                    pdfTitleList.visible = true
                    pdfChapterList.visible = true
                    pdfScreen.visible = false
                    pdfSearchView.visible = false
                }
                if ( countryVariant == 0 && langId != 2 )     {       // 내수, 한글이 아닐 경우
                    disable_popup.visible = true
                }
                else disable_popup.visible = false
//                loadSearch_timer.start()
            }
        }

        onSetSearchView:
        {
//            if( screenId != UIListener.getCurrentScreen() ) return
//            console.log("Main.qml ::  onSetSearchView")
//
//            if( pdfSearchView.source != "DHAVN_AppUserManual_SearchView.qml"  ) {
//                console.log("Main.qml :: onSetSearchView - load searchview.qml")
//                pdfSearchView.source = "DHAVN_AppUserManual_SearchView.qml"
//            }
//            else {
//                console.log("Main.qml :: onSetSearchView- clear SearchView")
//                pdfSearchView.clearSearchView()
//            }
        }
        onBtManual:
        {
            if( screenId != UIListener.getCurrentScreen() ) return
            disable_popup.visible = false
            console.log("Main.qml ::  onBtManual")
            if ( threadRunning ) {
                pdfScreen.item.threadQuit();
                threadRunning = false
            }
            clearAllPopup()
            if ( optionMenu.visible ) {
                optionMenu.visible = false
            }
            if ( !nowFG ) {
                setForegroundEvent()
            }
            nowFG = true
            popup_loader.visible = false
            lockoutMode = false
            searchOKTextEnable(false)       // 검색 종료
            pdfTitleList.item.setBtManual()     // title list focus BT에 설정
            btPage = startPageModel.get(btIndex).titleLabel
            helpModeIsBt = true // hyeonil.shin
            pdfScreen.item.btManual();
            launchPDFScreen()
//            entryBtVr = true
//            EngineListener.foregroundEventReceived( screenId )
        }
        onBtDRSManual:
        {
            if( screenId != UIListener.getCurrentScreen() ) return
            console.log("Main.qml ::  onBtDRSManual")
            disable_popup.visible = false
            /*** 순서 변경 안됨, showDRSPopup() 내부 state 및 page 정보 필요 ***/
            state = "pdfScreenView"
            btPage = startPageModel.get(btIndex).titleLabel
            helpModeIsBt = true // hyeonil.shin
            curPage = btPage
            EngineListener.savePage(curPage)
            EngineListener.saveState( "pdfScreenView"  ,  btPage , totalPage , UIListener.getCurrentScreen() )
            showDRSPopup()
            /*************************************************/
        }

        onVrManual:
        {
            if( screenId != UIListener.getCurrentScreen() ) return
            console.log("Main.qml :: onVrManual" )
            disable_popup.visible = false
            if ( threadRunning ) {
                pdfScreen.item.threadQuit();
                threadRunning = false
            }
            console.log("Main.qml ::  onVrManual")
            if ( optionMenu.visible ) {
                optionMenu.visible = false
            }
            if ( !nowFG ) {
                setForegroundEvent()
            }
            nowFG = true
            popup_loader.visible = false
            lockoutMode = false
            searchOKTextEnable(false)       // 검색 종료
            pdfTitleList.item.setVrManual()     // title list focus BT에 설정
            vrPage = startPageModel.get(vrIndex).titleLabel
            helpModeIsBt = false // hyeonil.shin
            pdfScreen.item.vrManual();
            launchPDFScreen()
//            entryBtVr = true
            console.log("Main.qml :: onVrManual - state: " , state , " , curPage : " , curPage )
            if ( nowFG && !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
//            EngineListener.foregroundEventReceived( screenId )
        }
        onVrDRSManual:
        {
            if( screenId != UIListener.getCurrentScreen() ) return
            console.log("Main.qml :: onVrDRSManual" )
            //disable_popup.visible = false     // ITS 266899
            /*** 순서 변경 안됨, showDRSPopup() 내부 state 및 page 정보 필요 ***/
            state = "pdfScreenView"
            vrPage = startPageModel.get(vrIndex).titleLabel
            helpModeIsBt = false // hyeonil.shin
            curPage = vrPage
            EngineListener.savePage(curPage)
            EngineListener.saveState( "pdfScreenView"  ,  vrPage , totalPage , UIListener.getCurrentScreen() )
            showDRSPopup()
            /*************************************************/
            console.log("Main.qml :: onVrDRSManual - saveState - page: ", vrPage )
//                return;
//            }
        }

        onSetVrStatePage:
        {
            state = "pdfScreenView"
            curPage = startPageModel.get(5).titleLabel + 1
            console.log("Main.qml :: onSetVrStatePage - state: " , state , " , curPage : " , curPage )
            if ( nowFG && !popup_loader.visible ) EngineListener.saveState( state  ,  curPage , totalPage , UIListener.getCurrentScreen() )
        }

        onBackkeyPressed:
        {
            if( screenId != UIListener.getCurrentScreen() ) return
            if ( disable_popup.visible ) {
                EngineListener.HandleBackKey( UIListener.getCurrentScreen() , false, true )
                EngineListener.HandleBackKey( UIListener.getCurrentScreen() , false, false )
                return
            }
            if ( toast_searchview.visible || toast_popUp.visible ) return

            console.log("Main.qml :: onBackkeyPressed")

            // 팝업 출력 상태일 경우 각각의 팝업 clear 동작
            if ( warningPopUp.visible ) {
                warningPopUp.visible = false
                return;
            }
            if ( searchEndPopUp.visible ) {
                searchEndPopUp.visible = false
                return;
            }
            if ( pagePopUp.visible ) {
                pagePopUp.visible  = false
                return;
            }
            if ( threadRunning ) {      // 검색중일 경우 back 불가
                console.log("Main.qml :: onBackkeyPressed - search thread running.... return....")
                return;
            }
            isJogBackKey = true
            handleBackKey( false , false , front )
        }

        onMenukeyPressed:
        {
            if ( disable_popup.visible ) return
            if ( toast_searchview.visible || warningPopUp.visible || toast_popUp.visible || searchEndPopUp.visible || pagePopUp.visible ) return
            if ( threadRunning ) return;
            if ( screenId != UIListener.getCurrentScreen()) return;
            if ( popup_loader.visible ) return;
//            if (warningPopUp.visible ) return;
            console.log("Main.qml :: Menu Key Pressed.")
            if( appUserManual.state == "pdfSearchView" )
            {
                console.log("Main.qml :: Menu Key Pressed - searchView return")
                return
            }
            if ( gotoPageBox ) {
                console.log("Main.qml :: Menu Key Pressed - gotoPageBox return")
                return
            }
            if ( focusIndex == Dimensions.const_AppUserManual_OptionMenu_FocusIndex )
            {
                console.log("Main.qml :: Menu Key Pressed - optionMenu return")
                //pdfTitleList.item.titleListFocus = false
//                pdfScreen.item.stopTimer()
                handleBackKey( false , false , false )
                return
                /*
                if ( tmpFocusIndex ==  Dimensions.const_AppUserManual_TitleList_FocusIndex )
                {
                    pdfTitleList.item.focusImageChange( 0 )
                    pdfTitleList.focus_visible = true
                    focusIndex == Dimensions.const_AppUserManual_TitleList_FocusIndex
                }
                else if ( tmpFocusIndex ==  Dimensions.const_AppUserManual_PageNumList_FocusIndex )
                {
                    pdfChapterList.focusImageChange( 0 )
                    focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex
                }
                */
            }

            if ( focusIndex == Dimensions.const_AppUserManual_TitleList_FocusIndex)
            {
                console.log(" Main.qml :: onMenukeyPressed - titleList")
                //pdfTitleList.item.titleListFocus = false
//                tmpFocusIndex = Dimensions.const_AppUserManual_TitleList_FocusIndex
                pdfTitleList.item.focusImageChange( 1 )
            }

            else if (  focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex)
            {
                console.log(" Main.qml :: onMenukeyPressed - chapterList")
                //pdfTitleList.item.titleListFocus = false
//                tmpFocusIndex = Dimensions.const_AppUserManual_PageNumList_FocusIndex
                pdfChapterList.item.focusImageChange( 1 )
            }
            else if ( statusBar.y != 0)
//            else if ( modeAreaWidget.y != Dimensions.const_AppUserManual_StatusBar_Height)       // full screen
            {
                modeareaDuration = true
                setFullScreen( false )
                modeareaDuration = false
            }
            if ( state == "pdfScreenView") pdfScreen.item.stopTimer()
            launchMenu( )// toBeFocused )
        }
        onPrevkeyPressed:
        {
            if ( disable_popup.visible ) return
            if ( threadRunning ) {
                return;
            }
            console.log("Main.qml :: Prev Key Pressed.")
            if( screenId === UIListener.getCurrentScreen() && appUserManual.state == "pdfScreenView" )
                    pdfScreen.item.nextPrevPage( false )
        }

        onNextkeyPressed:
        {
            if ( disable_popup.visible ) return
            if ( threadRunning ) {
                return;
            }
            console.log("Main.qml :: Next Key Pressed.")
            if( screenId === UIListener.getCurrentScreen() && appUserManual.state == "pdfScreenView" )
                pdfScreen.item.nextPrevPage( true )
        }

        onShowFullScreen:
        {
            if ( disable_popup.visible ) return
            console.log( "Main.qml :: onShowFullScreen" )
            if( appUserManual.state == "pdfScreenView" )
            {
                setFullScreen( false )
            }
        }
    }

    Connections
    {
        target: UIListener
        onSignalShowSystemPopup:
        {
            console.log("Main.qml :: onSignalShowSystemPopup")
            if ( systemPopupVisible ) return        // [ITS 254702] system popup 중복 check
            systemPopupVisible = true
            disable_popup.visible = false
            if ( searchEndPopUp.visible) {
                showSearchEndPopUp = true
                searchEndPopUp.visible = false
            }
            else if (pagePopUp.visible ) {
                showPagePopUp = true
                pagePopUp.visible = false
            }
            else if ( warningPopUp.visible ) {
                showWarningPopUp = true
                warningPopUp.visible = false;
            }
            if ( focusIndex == Dimensions.const_AppUserManual_OptionMenu_FocusIndex )
            {
                focusIndex = tmpFocusIndex
                optionMenu.visible = false
                if ( state == "pdfListView")
                {
                    if( focusIndex == Dimensions.const_AppUserManual_TitleList_FocusIndex )
                    {
                        pdfTitleList.item.titleListFocus = true
                        pdfTitleList.item.focusImageChange( 0 )
                    }
                    else if ( focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex )
                    {
                        pdfChapterList.item.focusImageChange( 2 ) //0 )
                    }
                }
                else if ( state == "pdfScreenView" ) {
                    pdfScreen.item.setFocus(false)
                    if ( !mainFullScreen ) pdfScreen.item.startTimer()
                }
            }
            systemPopupFocusIndex = focusIndex
            focusIndex = Dimensions.const_AppUserManual_FocusNone
        }
        onSignalHideSystemPopup:
        {
            console.log("Main.qml :: onSignalHideSystemPopup")
            systemPopupVisible = false
            focusIndex = systemPopupFocusIndex
            if ( showNotFoundPopup ) {
                showNotFoundPopup = false
                searchTextNotFound()
            }
            else if ( showSearchEndPopUp ) {
                showSearchEndPopUp = false
                searchText = ""
                searchOKTextEnable( false )
                startTimer()
            }
            else if ( showPagePopUp ) {
                showPagePopUp = false
                pdfScreen.item.setKeyboardFocus( true )
            }
            else if ( showWarningPopUp ) {
                showWarningPopUp = false
                pdfSearchView.item.clearSearchView()
            }
            else if ( state == "pdfScreenView" ) {
                if ( mainFullScreen )  {
                    focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
                }
                else pdfScreen.item.startTimer()
            }
            if ( countryVariant == 0 && langId != 2 )     {       // 내수, 한글이 아닐 경우
                console.log("Main.qml :: onSignalHideSystemPopup")
                EngineListener.HandleBackKey( UIListener.getCurrentScreen() , false, true )
                EngineListener.HandleBackKey( UIListener.getCurrentScreen() , false, false )
            }
        }
    }

    Component.onCompleted:
    {
        if (countryVariant==1) { //USA ( USA is not equal to NA. since NA = USA + CA.)
            btIndex = 23;
            vrIndex = 24;
        }
        else if (countryVariant==2) { //CN
            btIndex = 18;
            vrIndex = 0; //none
        }
        else if (countryVariant==4) { //ME
            btIndex = 19;
            vrIndex = 0; //none
        }
        else if (countryVariant==6) { //CA
            btIndex = 23;
            vrIndex = 24;
        }
        else { //EU,RUS, KR and so on.
            btIndex = 20;
            vrIndex = 21;
        }

        setForegroundEvent()
        pdfSearchView.source = "DHAVN_AppUserManual_SearchView.qml"
    }
}
