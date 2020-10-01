import Qt  4.7

import AppEngineQMLConstants 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import QmlSimpleItems 1.0
//import QmlOptionMenu 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import CQMLLogUtil 1.0


Item {
    id: pndrSearchDRView

    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    height:  PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT
    y: PR.const_PANDORA_ALL_SCREENS_TOP_OFFSET
    //anchors.bottomMargin: PR.const_PANDORA_ALL_SCREEN_BOTTOM_MARGIN
//    property variant keypadWidget : null //removed by jyjeon 2014-04-22 for ITS 227698
    visible: true

    property int count: 0
    property bool button_pressed: false

    property bool modeAreaFocused : false
    property bool searchListFocused : false

    //property int focusIndex: -1;
    property int mode_area_focus_index: -1

    property bool isFromErrorView: false
    property bool jogCenterPressed: false
    property bool isJogUpLongPressed: false;
    property bool isFirstLoad: false; // added by cheolhwan 2014-01-27. ITS 222951.
    property bool isInsufficientSV: false;

    property string logString :""

    signal handleSearchBoxClickEvent();
    signal sigResetSearch()
    signal handleBackRequest(bool isJogDial)
    signal handleStationSelectionEvent(int index);
    signal searchCallPopup();//{ modified by yongkyun.lee 2014-12-30 for : ITS 255280

    property bool scrollingTicker:UIListener.scrollingTicker; // added by esjang 2013.08.14 for ITS #183734

//    Loader { id: pndrKeyPadLoader; z: 1000} //removed by jyjeon 2014-04-22 for ITS 227698

    /***************************************************************************/
    /**************************** Private functions START **********************/
    /***************************************************************************/
    function __LOG( textLog , level)
    {
       logString = "SearchViewDR.qml::" + textLog ;
       logUtil.log(logString , level);
    }

    //{ modified by yongkyun.lee 2014-03-11 for : ITS 228237
    function setInsufficient(isIns)
    {
        (isInsufficientSV = isIns);
    }
    //} modified by yongkyun.lee 2014-03-11


    function handleRetranslateUI(languageId)
    {
        LocTrigger.retrigger()
       //pndrSearchBar.retranslateUI(PR.const_PANDORA_LANGCONTEXT);
        //added by jyjeon 2014-07-01 for ITS 239919
        //noResultsText.text = qsTranslate("main", "STR_PANDORA_NO_SEARCH_RESULTS_FOUND");
        waitIndicator.handleRetranslateUI(languageId);
        //added by jyjeon 2014-07-01 for ITS 239919
    }

    // Logic for highlighting the item based on jog key events
    function setHighlightedItem(inKeyId)
    {
        isDialUI = true;
    }

//============================================

    Connections
    {
        target: pndrSearch
        onAutoSearchCompleted:
        {
            __LOG("onAutoSearchCompleted : " + inSearchResultList.length , LogSysID.LOW_LOG );
            //__LOG("onAutoSearchCompleted : "  + (PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT - listModeAreaWidget.height - 45 )/(90 * inSearchResultList.length) , LogSysID.LOW_LOG );
            //{ Modified by LYK 2014-02-12. ITS 223527.
            //searchScrollBar.pageSize = (PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT - listModeAreaWidget.height - 45 )/(90 * inSearchResultList.length);
            searchScrollBar.pageSize = (PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT - listModeAreaWidget.height )/(90 * inSearchResultList.length);
            //} Modified by LYK 2014-02-12. ITS 223527.
            ///* added by esjang for ITS # 217069
            // Modified by LYK 2014-02-12. ITS 223527.
            //if((PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT - listModeAreaWidget.height - 45 )/(90 * inSearchResultList.length)<1)
            if((PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT - listModeAreaWidget.height )/(90 * inSearchResultList.length)<1)
            {
                searchScrollBar.visible = true;
            }
            else
            {
                searchScrollBar.visible = false;
            }
            //*/ added by esjang for ITS # 217069
            if(pndrSearch.sSearchString !== "")
            {
                var i = 0;
                count = inSearchResultList.length;
               // noResultsText.visible = !count;

//                if(keypadWidget && keypadWidget.isHide)
//                {
//                    manageFocus();
//                }

            }
            //{ modified by yongkyun.lee 2014-02-14 for : ITS 223311
            else
            {
                pndrSearchDRView.count = 0;
                searchScrollBar.visible = false;
            }
            //} modified by yongkyun.lee 2014-02-14
            hideWaitNote();
        }
        onExtendedSearchCompleted:
        {
            __LOG("onExtendedSearchCompleted : " + inSearchResultList.length , LogSysID.LOW_LOG );
            var i = 0;
            count = inSearchResultList.length;

            hideWaitNote();
        }
        onHandleError:
        {
             __LOG("onHandleError in search view: " , LogSysID.LOW_LOG );
             hideWaitNote();
        }

        onUpdateSearchString:
        {
            __LOG("Search string is updated :["+pndrSearch.sSearchString+"] isFirstLoad["+isFirstLoad+"]" , LogSysID.LOW_LOG );
            if(pndrSearch.sSearchString !== "")
            {
                //{ modified by yongkyun.lee 2014-09-03 for :
//                if(keypadWidget.keyDeleteRunning())
//                    return
                //} modified by yongkyun.lee 2014-09-03

               // noResultsText.visible = false;
                showWaitNote();

                //added by jyjeon 2014-02-13 for key delay
                keyDelayTimer.restart();
                //pndrSearch.SearchAutoComplete(pndrSearch.sSearchString);
                //added by jyjeon 2014-02-13 for key delay

//                if(pndrKeyPadLoader.status == Loader.Ready) // added by cheolhwan 2014-01-21. removed warning. //removed by jyjeon 2014-04-22 for ITS 227698
//                    keypadWidget.enableDone_DeleteButton();
//                    keypadWidget.enableHideButton(); // modified by wonseok.heo for ITS 255426

            }
            else
            {
                idTextInputSearch.text = ""
                if(isFirstLoad == true) //{ added by cheolhwan 2014-01-27. ITS 222951.
                {
                    isFirstLoad = false;
                }
//                else
//                {
//                    UIListener.ManualBeep();
//                }
//                if(pndrKeyPadLoader.status == Loader.Ready) // added by cheolhwan 2014-01-21. removed warning. //removed by jyjeon 2014-04-22 for ITS 227698
//                    keypadWidget.disableDone_DeleteButton();
//                keypadWidget.disableHideButton(); // modified by wonseok.heo for ITS 255426

                pndrSearchDRView.count = 0; // modified by yongkyun.lee 2014-02-14 for : ITS 223311
                searchScrollBar.visible = false; // added by esjang for ITS # 217069
                hideWaitNote();
            }
        }
    }
    // added by esjang 2013.08.14 for ITS #183734
    Connections
    {
        target:UIListener

        onTickerChanged:
        {
            pndrSearchDRView.scrollingTicker = inScrollingTicker;

        }
    }
/*
    Connections
    {
        target : keypadWidget //pndrKeyPadLoader.item //modified by jyjeon 2014-04-22 for ITS 227698

        //{ modified by yongkyun.lee 2014-03-04 for : ITS 226613
        onUpdateString:
        {
            idTextInputSearch.text = pndrSearch.sSearchString
            idTextInputSearch.cursorPosition = 0;
            __LOG("onUpdateString "  , LogSysID.LOW_LOG);
            keypadWidget.clearAutomata();
        }
        //} modified by yongkyun.lee 2014-03-04

        onManageFocus:{
            pndrSearchDRView.manageFocus();
        }

        onStartSearch:{
            pndrSearchDRView.__startSearch();
        }

        onFocusLost:{
            if(waitIndicator.visible || popupLoading.visible) return;

            if(pndrSearchDRView.searchListFocused || pndrSearchDRView.modeAreaFocused) return;


                idCursorMarker.show(calculateMarkerPosition(idTextInputSearch.cursorPosition));
                pndrSearchDRView.searchListFocused = false;
                pndrSearchDRView.mode_area_focus_index = 0;
                pndrSearchDRView.modeAreaFocused = true;


            keypadWidget.hideQwertyKeypad();
        }

        //{ modified by yongkyun.lee 2014-12-30 for : ITS 255280
        onKeyCallPopup:
        {
            __LOG("[leeyk1]onKeyCallPopup ");
            searchCallPopup();
        }
        //} modified by yongkyun.lee 2014-12-30

    }*/

    //added by jyjeon 2014-04-22 for ITS 227698
    Connections
    {
        target: pndrController

        onStateChanged:{
            __LOG("State changed to = " + pndrController.state , LogSysID.LOW_LOG);

            //keypadWidget.setDefaultKeyPad(); //added by wonseok.heo for ITS  257323
            if(pndrController.state != "pndrSearchDRView")
            {
                pndrSearchDRView.searchListFocused = false; // add by wonseok.heo 2015.01.15 for 256193  256192
                jogCenterPressed = false;

                if(popupLoading.visible)
                popupLoading.visible = false;
            }
        }
    }
    //added by jyjeon 2014-04-22 for ITS 227698
    function isJogListenState()
    {
        var ret = true;
        if(/*waitIndicator.visible ||*/ popupLoading.visible ||
            isInsufficientSV ) //|| /* { modified by yongkyun.lee 2014-03-11 for : ITS 228237*/
                //keypadWidget.focus_visible) //modified by cheolhwan 2014-02-11. ITS 223321_223519.
        {
            ret = false;
        }
        return ret;
    }

    function handleJogKey( arrow, status )
    {
         __LOG("handlejogkey -> arrow : " + arrow + " , status : "+status , LogSysID.LOW_LOG );
        //{ modified by yongkyun.lee 2014-12-30 for : ITS 255280
        if(UIListener.IsCalling())
        {
            searchCallPopup();
            return;
        }
        //} modified by yongkyun.lee 2014-12-30
        if(status == UIListenerEnum.KEY_STATUS_PRESSED
                || status == UIListenerEnum.KEY_STATUS_PRESSED_CRITICAL)
        {
            switch(arrow)
            {
                 case UIListenerEnum.JOG_CENTER:
                     if(pndrSearchDRView.searchListFocused)
                     {
                         jogCenterPressed = true;
                         //borderImage.source = PR_RES.const_APP_PANDORA_LIST_VIEW_ITEM_PRESSED
                     }
                     //added by jyjeon 2014-03-07 for ITS 228509
                     else if(pndrSearchDRView.modeAreaFocused)
                     {
                         button_pressed = true ;
                     }
                     //added by jyjeon 2014-03-07 for ITS 228509
                     break;
            }
        }
        else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
        {
            switch(arrow)
            {

                case UIListenerEnum.JOG_CENTER:

                    if(pndrSearchDRView.searchListFocused && jogCenterPressed ==true) // add by wonseok.heo 2015.01.15 for 256193  256192
                    {
                        handleCenterKey();
                        jogCenterPressed = false;
                    }
                    else
                    {
                        jogCenterPressed = false;
                        if(pndrSearchDRView.modeAreaFocused)
                        {
                            button_pressed = false ; //added by jyjeon 2014-03-07 for ITS 228509
                            if(pndrSearchDRView.mode_area_focus_index == 0)
                                pndrSearchDRView.searchTextBoxClicked(true);
                            else if(pndrSearchDRView.mode_area_focus_index == 1)
                                pndrSearchDRView.__startSearch();
                            else if(pndrSearchDRView.mode_area_focus_index == 2)
                                pndrSearchDRView.handleBackRequest(true);
                            else
                            {}
                        }
                    }
                    break;

            }
        }


        else if (status == UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED)
        {
            switch(arrow)
            {
                case UIListenerEnum.JOG_CENTER:
                    if(pndrSearchDRView.searchListFocused)
                    {
                        jogCenterPressed = false;
                    }
                    break;
            }

        }// }add by wonseok.heo 2015.01.15 for 256193  256192

        else if (status == UIListenerEnum.KEY_STATUS_CANCELED)
        {
            if(pressAndHoldTimer.running)
            {
                isJogUpLongPressed = false
                pressAndHoldTimer.stop();
            }
        }
    }




    function showWaitNote()
    {
        waitIndicator.visible = true;
        searchItemListView.visible = false;
    }

    function hideWaitNote()
    {
        popupLoading.visible = false;
        pndrSearchDRView.enabled = true;
        waitIndicator.visible = false;
        searchItemListView.visible = true;
    }

    function getWaitIndicatorStatus()
    {
        return waitIndicator.visible;
    }

    function manageFocus()
    {

//        if(!keypadWidget.isHide)
//        {
//            keypadWidget.hideQwertyKeypad();
//            keypadWidget.hideFocus();
//            keypadWidget.focus_visible = false;
//        }


            pndrSearchDRView.searchListFocused = false;
            pndrSearchDRView.mode_area_focus_index = 0;
            pndrSearchDRView.modeAreaFocused = true;
            idCursorMarker.show(calculateMarkerPosition(idTextInputSearch.cursorPosition));

    }

    function manageFocusOnPopUp(status)
    {
        __LOG(" manageFocusOnPopUp(status) -> " + status , LogSysID.LOW_LOG );

        if(popupLoading.visible)
            popupLoading.visible = false;

        if(status)
        {
//            if(!keypadWidget.isHide)
//            {
//                keypadWidget.hideFocus();
//                keypadWidget.focus_visible = false;
//            }
            jogCenterPressed = false; // add by wonseok.heo 2015.01.15 for 256193  256192
            idCursorMarker.hide(); //added by jyjeon 2014-03-14 for ITS 229391
            pndrSearchDRView.searchListFocused = false;//{ modified by yongkyun.lee 2014-03-12 for : 229140
            pndrSearchDRView.modeAreaFocused = false; //added by jyjeon 2014.02.03 for ITS 223607
            pressAndHoldTimer.stop(); //added by wonseok.heo 2015.02.09 for ITS 257836
        }
        else
        {
//            if(!keypadWidget.isHide)
//            {
//                idCursorMarker.hide();
//                pndrSearchDRView.searchListFocused = false;
//                pndrSearchDRView.modeAreaFocused = false;
//                keypadWidget.focus_visible = true;
//                keypadWidget.showFocus();
//            }
//            //added by jyjeon 2014-03-14 for ITS 229391
//            else
//            {

                    pndrSearchDRView.modeAreaFocused = true;
//            }
            //added by jyjeon 2014-03-14 for ITS 229391
        }
    }

    //{ modified by yongkyun.lee 2014-03-04 for : ITS 226613
    function currentPos()
    {
        return idTextInputSearch.cursorPosition;
    }
    //} modified by yongkyun.lee 2014-03-04

    function textToDisplayOnsearchBox( key, label, state )
    {
        //__LOG("input(key, label, state) = " + key + ", " + label + ", " + state, LogSysID.LOW_LOG);

        //modified by jyjeon 2014-02-12 for ITS 223851
        if( Qt.Key_Launch4 && label == "")
        {
            if( Qt.Key_Shift != key){ // added by wonseok.heo 2015.04.06 for 261149

                //{ modified by yongkyun.lee 2014-02-25 for : ITS 226613
                if( Qt.Key_Back != key)
                {
                var position = idTextInputSearch.cursorPosition - 1;
                idTextInputSearch.text = idTextInputSearch.text.substring(0, position) +  label + idTextInputSearch.text.substring(position + 1);
                pndrSearch.sSearchString = idTextInputSearch.text
                //keypadWidget.currentCursor = idTextInputSearch.curPos
                idTextInputSearch.cursorPosition = idTextInputSearch.curPos
                }
//                else
//                {
//                    keypadWidget.currentCursor = keypadWidget.currentCursor -1;
//                    keypadWidget.currentCursor = keypadWidget.currentCursor ;
//                }
                 //} modified by yongkyun.lee 2014-02-25

            }


        }
        //modified by jyjeon 2014-02-12 for ITS 223851

        if(0xFF/* SEARCH_BOX_MAX_KEY_CODE */ > key) {

            var position = idTextInputSearch.cursorPosition //keypadWidget.currentCursor;

            var offset = 0;
            if(true == state)
            {
                offset = 1;
            }

            // __LOG("## label         = " + label        , LogSysID.LOW_LOG);
            // __LOG("## length        = " + label.length , LogSysID.LOW_LOG);
            // __LOG("## offset        = " + offset       , LogSysID.LOW_LOG);
            // __LOG("## outputText    = " + idTextInputSearch.text    , LogSysID.LOW_LOG);
            // __LOG("## currentCursor = " + keypadWidget.currentCursor, LogSysID.LOW_LOG);
            // __LOG("## outputText.substring(currentCursor)             = " + idTextInputSearch.text.substring(position)            , LogSysID.LOW_LOG);
            // __LOG("## outputText.substring(0, length - currentCursor) = " + idTextInputSearch.text.substring(0, position - offset), LogSysID.LOW_LOG);

            idTextInputSearch.curPos = position + label.length - offset;
            idTextInputSearch.text =  idTextInputSearch.text.substring(0, position - offset) + label + idTextInputSearch.text.substring(position);
            pndrSearch.sSearchString = idTextInputSearch.text

        }
        else if(Qt.Key_Back == key)
        {
            if(0 < idTextInputSearch.cursorPosition)
            {
                var position = idTextInputSearch.cursorPosition - 1;

                if("" != label)
                {
                    idTextInputSearch.text = idTextInputSearch.text.substring(0, position) +  label + idTextInputSearch.text.substring(position + 1);
                }
                else
                {
                    idTextInputSearch.curPos = idTextInputSearch.cursorPosition - 1
                    idTextInputSearch.text = idTextInputSearch.text.substring(0, position) +  idTextInputSearch.text.substring(position+1);
                }
                pndrSearch.sSearchString = idTextInputSearch.text

                idTextInputSearch.cursorPosition = idTextInputSearch.curPos
            }
            else
            {
            }
        }

        pndrSearchDRView.modeAreaFocused = false;

    }


    //{ modified by yongkyun.lee 2014-03-19 for : ITS 230058
    onModeAreaFocusedChanged:
    {
         if(modeAreaFocused == false )
         {
             if(b_btn.state != "disable")
                 b_btn.state="normal";
             if(m_btn.state != "disable")
                 m_btn.state="normal";
             button_pressed = false;
         }
    }
    //} modified by yongkyun.lee 2014-03-19

    onSigResetSearch:
    {
        __LOG("onSigResetSearch" , LogSysID.LOW_LOG );

        pndrSearchDRView.searchListFocused = false;

        pndrSearchDRView.modeAreaFocused = false;


    }
    //==============================================================

    Component.onCompleted: {
        activeView = pndrSearchDRView;
        isFirstLoad = true; // added by cheolhwan 2014-01-27. ITS 222951.
        //pndrSearch.sSearchString = "";

    }

    //added by jyjeon 2014-04-22 for ITS 227698
    onVisibleChanged:{
        if(visible)
        {
            activeView = pndrSearchDRView;
        }

    }
    //added by jyjeon 2014-04-22 for ITS 227698

    function handleForegroundEvent()
    {
        //modified by jyjeon 2014-04-22 for ITS 227698
        pndrSearch.sSearchString = "";
        //        pndrKeyPadLoader.source = "DHAVN_KeyPad.qml"
        //        pndrKeyPadLoader.item.visible = true;
        idCursorMarker.hide();
        pndrSearchDRView.searchListFocused = false;
        pndrSearchDRView.modeAreaFocused = true;
        pndrSearchDRView.mode_area_focus_index = 2;
        pndrSearchDRView.visible = visibleStatus;

    }

    Rectangle
    {
       id: lockoutRect

       //visible: true//video_model.lockoutMode
       anchors.fill:parent

       color: "black"

       Image
       {

           id: lockoutImg
           anchors.left: parent.left
           anchors.leftMargin: 562
           y: 289 - 93 //( video_model.progressBarMode == "AUX" )? CONST.const_NO_PBCUE_LOCKOUT_ICON_TOP_OFFSET:CONST.const_LOCKOUT_ICON_TOP_OFFSET // modified by lssanh 2013.05.24 ISV84099
           source: PR_RES.const_APP_PANDORA_URL_IMG_LOCKOUT_ICON
       }

       Text
       {

           width: parent.width
           horizontalAlignment:Text.AlignHCenter
           anchors.top : lockoutImg.bottom
           text: qsTranslate("main", "STR_PANDORA_DRIVING_RESTRICTION"); //QT_TR_NOOP("STR_PANDORA_DRIVING_RESTRICTION");
           font.pointSize: 32//36//modified by edo.lee 2013.05.24
           color: "white"
       }

    }

    /* INTERNAL functions */
    function calculateMarkerPosition(mouseX) {
        var rect = idTextInputSearch.positionToRectangle(idTextInputSearch.cursorPosition);
        return rect.x;
    }




    Image {
        id: listModeAreaWidget
        source: "/app/share/images/general/bg_title.png"
        width: 1280
        height: 72
    }


    Image {
        id: idImageSearchBar
        source: PR_RES.const_APP_PANDORA_SEARCH_BOX
        x: 7
        width: 992
        height: 69
        // Search text input
        TextInput {
            id: idTextInputSearch
            text: pndrSearch.sSearchString
            x: 33
            y: 12
            width: 992 - 7 - 33 // modified by cheolhwan 2014-01-09. ITS 218627. (847 -44) ->  (992 - 7 - 33)

            color: PR.const_PANDORA_COLOR_TEXT_BUTTON_GREY
            font.pointSize: 32
            font.family: PR.const_PANDORA_FONT_FAMILY_HDB
            cursorVisible: true
            cursorPosition: 0 ; //idTextInputSearch.text.length
            cursorDelegate: (pndrSearchDRView.modeAreaFocused && pndrSearchDRView.mode_area_focus_index == 0 )?  idDelegateFocusCursor : idDelegateCursor; //modified by jyjeon 2014-04-30 for ITS 228574
            horizontalAlignment: Text.AlignLeft
            property string keyCompensation: "";
            property int curPos: -1


            onTextChanged: {

                //{ modified by yongkyun.lee 2014-02-25 for : ITS 226613
                //  if(keypadWidget)
                //      idTextInputSearch.cursorPosition =  keypadWidget.currentCursor
                //} modified by yongkyun.lee 2014-02-25

//                if(false == keypadWidget.focus) {
//                    keypadWidget.forceActiveFocus();
//                }

                idCursorMarker.hide();

                //keypadWidget.forceActiveFocus();


//                if(0 == idTextInputSearch.text.length) {
//                    keypadWidget.disableDone_DeleteButton();
//                    keypadWidget.disableHideButton(); // modified by wonseok.heo for ITS 255426
//                } else {
//                    keypadWidget.enableDone_DeleteButton();
//                    keypadWidget.enableHideButton(); // modified by wonseok.heo for ITS 255426
//                }
            }

            onCursorPositionChanged: {

                if ( curPos >= 0 )
                   cursorPosition = curPos
                else
                {
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

                curPos = -1;
            }

            onActiveFocusChanged: {
                if(false == idTextInputSearch.activeFocus) {
                    idCursorMarker.hide();
                }
            }

            MouseArea {
                anchors.fill: parent
                beepEnabled: false

                onClicked:
                {
                    //{ modified by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
//                    UIListener.ManualBeep();
//                    if(keypadWidget.isHide)
//                        pndrSearchDRView.searchTextBoxClicked(false)
//                    else {
//                        var position = idTextInputSearch.positionAt(mouseX, TextInput.CursorOnCharacter);
//                        //{ added by cheolhwan 201-01-17. ITS 220797.
//                        keypadWidget.hideFocus();
//                        keypadWidget.focus_visible = false;
//                        pndrSearchDRView.searchListFocused = false;
//                        pndrSearchDRView.modeAreaFocused = true;
//                        pndrSearchDRView.mode_area_focus_index = 0;
//                        //} added by cheolhwan 201-01-17. ITS 220797.
//                        if(position != idTextInputSearch.cursorPosition){
//                            __LOG("onClicked "  , LogSysID.LOW_LOG);
//                            idTextInputSearch.cursorPosition =position;
//                            keypadWidget.clearAutomata();
//                        }
//                        // { modified by wonseok.heo for ITS 233156
//                        if(0 != idTextInputSearch.text.length)
//                        idCursorMarker.show(calculateMarkerPosition(mouseX));
//                        // } modified by wonseok.heo for ITS 233156
//                    }
                    //} modified by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
                }
            }
        }
        // Cursor delegate
        Component {
            id: idDelegateCursor

            Image {
                id: idDelegateCursorImage
                //{ modified by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
                //source: PR_RES.const_CURSOR;
                source: PR_RES.const_CURSOR_N;
                //} modified by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
                width: 4
                height: 47

                SequentialAnimation {
                    running: idDelegateCursorImage.visible
                    loops: Animation.Infinite;

                    NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 1; duration: 100 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 0; duration: 100 }
                }
            }
        }

        //{ added by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
        Component {
            id: idDelegateFocusCursor

            Image {
                id: idDelegateCursorFocusImage
                source: PR_RES.const_CURSOR_F;
                width: 4
                height: 47

                SequentialAnimation {
                    running: idDelegateCursorFocusImage.visible
                    loops: Animation.Infinite;

                    NumberAnimation { target: idDelegateCursorFocusImage; property: "opacity"; to: 1; duration: 100 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { target: idDelegateCursorFocusImage; property: "opacity"; to: 0; duration: 100 }
                }
            }
        }
        //} added by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
    }

    DHAVN_PandoraSearchBar
    {
        id: m_btn
        x: 998
        y: 0
        width: 141
        height: 72
        bg_img_n: PR_RES.const_WIDGET_MB_IMG_NORMAL
        bg_img_p: PR_RES.const_WIDGET_MB_IMG_PRESSED
        bg_img_f: PR_RES.const_WIDGET_MB_FOCUS_IMG
        searchButton:PR_RES.const_WIDGET_SB_IMG_D
        onBtnClicked: {
            manageFocus();
        }
        bFocused: ( pndrSearchDRView.mode_area_focus_index == 1 ) && modeAreaFocused
        visible: true
        bFocusAble: (pndrSearch.sSearchString.length > 0)
        bDisabled : (pndrSearch.sSearchString.length <= 0)
        onBDisabledChanged:
        {
//            if(bDisabled === true){
//                searchButton = PR_RES.const_WIDGET_SB_IMG_D
//                if(keypadWidget != null)
//                    keypadWidget.disableDone_DeleteButton();
//                keypadWidget.disableHideButton(); // modified by wonseok.heo for ITS 255426
//            }
//            else{
//                if(keypadWidget != null )
//                    keypadWidget.enableDone_DeleteButton();
//                keypadWidget.enableHideButton(); // modified by wonseok.heo for ITS 255426
//                searchButton = PR_RES.const_WIDGET_SB_IMG_N
//            }

        }
    }


    DHAVN_PandoraSearchBar
    {
        id: b_btn
        x: 1139
        y: 0
        width: 141
        height: 72
        bg_img_n: PR_RES.const_WIDGET_BB_IMG_NORMAL
        bg_img_p: PR_RES.const_WIDGET_BB_IMG_PRESSED
        bg_img_f: PR_RES.const_WIDGET_BB_IMG_FOCUS // for displaying focus on back button
        searchButton:""
        onBtnClicked: {
            pndrSearchDRView.handleBackRequest(false);
        }
        bFocused: ( pndrSearchDRView.mode_area_focus_index == 2 ) && modeAreaFocused
        visible: true
        bFocusAble: true;
        bDisabled : false
        textColor:"#FAFAFA"
    }

    Cursor_Marker{
        id: idCursorMarker
        x: 0
        y: 61
        width: 42
        height: 117

        hiddenHeight: 46
        hiddenFontSize: 32

        dragRangeMarginLeft: 33 - 12
        //{  modified by wonseok.heo for ITS 233156
        //{ modified by yongkyun.lee 2014-02-26 for : ITS 226613 ,  ISV : 228829
        dragRangeMarginRight:if ((UIListener.getStringWidth(idTextInputSearch.text , PR.const_PANDORA_FONT_FAMILY_HDB , 32 ) + 21) > 972){ // modified by wonseok.heo for ITS 255498
                                 977
                             }else{
                                 UIListener.getStringWidth(idTextInputSearch.text , PR.const_PANDORA_FONT_FAMILY_HDB , 32 ) + 21
                             }

            //UIListener.getStringWidth(idTextInputSearch.text , PR.const_PANDORA_FONT_FAMILY_HDB , 32 ) + 21 // idTextInputSearch.width
        //dragRangeMarginRight: 129
        //} modified by yongkyun.lee 2014-02-26
        //} modified by wonseok.heo for ITS 233156
        dragRangeLimit: 129 + idTextInputSearch.width //- 44

        onSigMarkerPositionInit: {
            //keypadWidget.currentCursor = idTextInputSearch.cursorPosition;
        }

        onSigMarkerPositionChange: {
                    var longText  =  UIListener.getStringWidth(idTextInputSearch.text , PR.const_PANDORA_FONT_FAMILY_HDB , 32 ) + 21;
                    var cursorPosition = idTextInputSearch.cursorPosition;
                 //   __LOG("onSigMarkerPositionChange   cursorPosition " +cursorPosition +" idTextInputSearch.text.length "+ idTextInputSearch.text.length +"longText " +longText +" idTextInputSearch.width" +idTextInputSearch.width , LogSysID.LOW_LOG );

                    if(30 > position) {
                        if(1 < cursorPosition) {
                          //  __LOG(" onSigMarkerPositionChange1 " , LogSysID.LOW_LOG );

                            idTextInputSearch.cursorPosition -= 2;
                            idTextInputSearch.cursorPosition++;

                        } else {
                          //  __LOG("onSigMarkerPositionChange2" , LogSysID.LOW_LOG );
                            idTextInputSearch.cursorPosition = 0;
                        }
                    } else if(position > dragRangeLimit - 1) {
                     //   __LOG("onSigMarkerPositionChange3" , LogSysID.LOW_LOG );
                        //if(cursorPosition < idTextInputSearch.text.length) {
                            idTextInputSearch.cursorPosition++;
                       // }

                    } else {
                       var cursorPositionab =  idTextInputSearch.positionAt(position, TextInput.CursorOnCharacter);
                    // __LOG("onSigMarkerPositionChange4 " +cursorPositionab + " position " + position, LogSysID.LOW_LOG );

                        //idTextInputSearch.cursorPosition++;
                        if ( longText > idTextInputSearch.width ){

                            if (idTextInputSearch.text.length > cursorPosition && position > idTextInputSearch.width){
                                //idTextInputSearch.cursorPosition++;

                                idTextInputSearch.cursorPosition = idTextInputSearch.text.length;


                            }else {


                                idTextInputSearch.cursorPosition = idTextInputSearch.positionAt(position, TextInput.CursorOnCharacter);

                            }
                           // idTextInputSearch.cursorPosition = idTextInputSearch.text.length

                        }else {

                        idTextInputSearch.cursorPosition = idTextInputSearch.positionAt(position, TextInput.CursorOnCharacter);
                        }
                    }

           // if(cursorPosition != idTextInputSearch.cursorPosition)
            {
                // Update cursor position
                //keypadWidget.currentCursor = idTextInputSearch.cursorPosition;
              //  console.log("# idTextInputSearch.cursorPosition = " + idTextInputSearch.cursorPosition);
             //   console.log("# keypadWidget.currentCursor = " + keypadWidget.currentCursor);
            }
        }

        onSigMarkerPositionRelease: {
            var cursorPosition = idTextInputSearch.positionAt(position, TextInput.CursorOnCharacter);
            if(cursorPosition != idTextInputSearch.cursorPosition) {
                idTextInputSearch.cursorPosition = cursorPosition;

                //keypadWidget.currentCursor = idTextInputSearch.cursorPosition;
            }

            // Sync position
            idCursorMarker.syncPosition(calculateMarkerPosition(position));
        }

        onSigMarkerPositionSync: {
            //keypadWidget.currentCursor = position;
        }
    }


     DHAVN_PandoraWaitView{
         id: waitIndicator
         //{ add by cheolhwan 2013.12.04 for ITS 212559 (by GUI guideline).
         //y: -53
         y:  120 //modified by jyjeon 2014.01.15 for ITS 218791
         //} add by cheolhwan 2013.12.04 for ITS 212559 (by GUI guideline).
         visible: false
     }

//     Text {
//        id: noResultsText
//        text: qsTranslate("main", "STR_PANDORA_NO_SEARCH_RESULTS_FOUND")
//        visible: false
//        x: 150
//        y: (keypadWidget && keypadWidget.isHide) ? 294 : 124 //modified by jyjeon 2014.01.15 for ITS 218791
//        width: 980
//        height: 40
//        z: 10
//        font.pointSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT
//        font.family: PR.const_PANDORA_FONT_FAMILY_HDR
//        color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
//        horizontalAlignment: "AlignHCenter"
//        wrapMode: Text.WordWrap

//     }

    DHAVN_ToastPopup
    {
        id:popupLoading
        visible:false;
        dismiss:false;

        onVisibleChanged:
        {
             if(visible === true){
                 popupLoading.sText = QT_TR_NOOP("STR_PANDORA_LOADING");
             }
        }
    }



    //added by jyjeon 2014-02-13 for key delay
    Timer{
        id: keyDelayTimer
        running: false
        repeat: false
        interval: 1000
        onTriggered:{
            __LOG(" keyDelayTimer timeout  : " , LogSysID.LOW_LOG );
            pndrSearch.SearchAutoComplete(pndrSearch.sSearchString);
        }
    }
    //added by jyjeon 2014-02-13 for key delay
}
