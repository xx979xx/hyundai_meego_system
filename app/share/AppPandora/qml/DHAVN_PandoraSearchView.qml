import Qt  4.7

import AppEngineQMLConstants 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import QmlSimpleItems 1.0
//import QmlOptionMenu 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import CQMLLogUtil 1.0


Item {
    id: pndrSearchView

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
       logString = "SearchView.qml::" + textLog ;
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
        noResultsText.text = qsTranslate("main", "STR_PANDORA_NO_SEARCH_RESULTS_FOUND");
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
            searchResultsModel.clear();
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
                noResultsText.visible = !count;
                for (i=0; i< count && inSearchResultList[i].length > 0 ; i++)
                {
                    searchResultsModel.append({"name": inSearchResultList[i]})
                    searchItemListView.enabled = true;
                }

                if(keypadWidget && keypadWidget.isHide)
                {
                    manageFocus();
                }
                //{ modified by yongkyun.lee 2014-03-06 for : ITS 228304
                else if(pndrSearchView.searchListFocused)
                {
                    pndrSearchView.searchListFocused = false;
                }
                //} modified by yongkyun.lee 2014-03-06 
            }
            //{ modified by yongkyun.lee 2014-02-14 for : ITS 223311
            else
            {
                pndrSearchView.count = 0;           
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
            searchResultsModel.clear();
            for (i=0; i< count; i++){
                searchResultsModel.append({"name": inSearchResultList[i]})
            }
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
                if(keypadWidget.keyDeleteRunning())
                    return        
                //} modified by yongkyun.lee 2014-09-03 
            
                searchResultsModel.clear();
                noResultsText.visible = false;
                showWaitNote();

                //added by jyjeon 2014-02-13 for key delay
                keyDelayTimer.restart();
                //pndrSearch.SearchAutoComplete(pndrSearch.sSearchString);
                //added by jyjeon 2014-02-13 for key delay

//                if(pndrKeyPadLoader.status == Loader.Ready) // added by cheolhwan 2014-01-21. removed warning. //removed by jyjeon 2014-04-22 for ITS 227698
                    keypadWidget.enableDone_DeleteButton();
                    keypadWidget.enableHideButton(); // modified by wonseok.heo for ITS 255426

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
                    keypadWidget.disableDone_DeleteButton();
                keypadWidget.disableHideButton(); // modified by wonseok.heo for ITS 255426
                searchResultsModel.clear();
                pndrSearchView.count = 0; // modified by yongkyun.lee 2014-02-14 for : ITS 223311
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
            pndrSearchView.scrollingTicker = inScrollingTicker;            
            //added jyjeon 2014-05-21 for ITS 237937
            if(inScrollingTicker == false)
                keypadWidget.sendJogCanceled();
            //added jyjeon 2014-05-21 for ITS 237937
        }
        onUpdateKeypad: //added by wonseok.heo for ITS 271134 271132
        {
            __LOG("keypadWidget.setUpdate " , LogSysID.LOW_LOG );
            keypadWidget.setUpdate();

        }
    }

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
            pndrSearchView.manageFocus();
        }

        onStartSearch:{
            pndrSearchView.__startSearch();
        }

        onFocusLost:{
            if(waitIndicator.visible || popupLoading.visible) return;

            if(pndrSearchView.searchListFocused || pndrSearchView.modeAreaFocused) return;

            if(searchResultsModel.count > 0)
            {
                idCursorMarker.hide();
                pndrSearchView.searchListFocused = true;
                //pndrSearchView.focusIndex = 0;
                pndrSearchView.modeAreaFocused = false;
                //{ deleted by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
                searchItemListView.currentIndex = 0; // added by cheolhwan 2014-01-17. ITS 220415.
                //} deleted by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
                searchItemListView.positionViewAtIndex(searchItemListView.currentIndex,ListView.Beginning);
            }
            else
            {                
                idCursorMarker.show(calculateMarkerPosition(idTextInputSearch.cursorPosition));
                pndrSearchView.searchListFocused = false;
                pndrSearchView.mode_area_focus_index = 0;
                pndrSearchView.modeAreaFocused = true;
            }

            keypadWidget.hideQwertyKeypad();
        }
        
        //{ modified by yongkyun.lee 2014-12-30 for : ITS 255280
        onKeyCallPopup:
        {
            __LOG("[leeyk1]onKeyCallPopup ");
            searchCallPopup();
        }
        //} modified by yongkyun.lee 2014-12-30 
        
    }

    //added by jyjeon 2014-04-22 for ITS 227698
    Connections
    {
        target: pndrController

        onStateChanged:{
            __LOG("State changed to = " + pndrController.state , LogSysID.LOW_LOG);

            keypadWidget.setDefaultKeyPad(); //added by wonseok.heo for ITS  257323
            if(pndrController.state != "pndrSearchView")
            {
                pndrSearchView.searchListFocused = false; // add by wonseok.heo 2015.01.15 for 256193  256192
                jogCenterPressed = false;

                if(popupLoading.visible)
                popupLoading.visible = false;
            }
        }
    }
    //added by jyjeon 2014-04-22 for ITS 227698
    
/* keep for future Spec change
    Connections
    {
        target: ( !popupVisible && searchItemListView.visible) ? UIListener : null

        onTuneKeyDialed: //isForward
        {
            if(searchListFocused === true)
            {
                if(isForward)
                {
                    handleJogKey( UIListenerEnum.JOG_WHEEL_RIGHT, UIListenerEnum.KEY_STATUS_RELEASED );
                }
                else
                {
                    handleJogKey( UIListenerEnum.JOG_WHEEL_LEFT, UIListenerEnum.KEY_STATUS_RELEASED );
                }
            }
            else
            {
               if(searchResultsModel.count > 0)
                {
                   if(!keypadWidget.isHide)
                   {
                       keypadWidget.hideQwertyKeypad();
                       keypadWidget.hideFocus();
                       keypadWidget.focus_visible = false;
                   }
                    idCursorMarker.hide();
                    pndrSearchView.modeAreaFocused = false;
                    pndrSearchView.searchListFocused = true;
                    //pndrSearchView.focusIndex = 0;
                    searchItemListView.currentIndex = 0;
                    searchItemListView.positionViewAtIndex(searchItemListView.currentIndex,ListView.Beginning);
                }
            }
        }
        onTuneCenterReleased:
        {
           handleCenterKey();
        }
    }
*/
    function isJogListenState()
    {
        var ret = true;
        if(/*waitIndicator.visible ||*/ popupLoading.visible ||
            isInsufficientSV || /* { modified by yongkyun.lee 2014-03-11 for : ITS 228237*/
                keypadWidget.focus_visible) //modified by cheolhwan 2014-02-11. ITS 223321_223519.
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
                     if(pndrSearchView.searchListFocused)
                     {
                         jogCenterPressed = true;
                         //borderImage.source = PR_RES.const_APP_PANDORA_LIST_VIEW_ITEM_PRESSED
                     }
                     //added by jyjeon 2014-03-07 for ITS 228509
                     else if(pndrSearchView.modeAreaFocused)
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
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                    if(pndrSearchView.modeAreaFocused)
                    {
                        if( pndrSearchView.mode_area_focus_index == 0){
                            if(idTextInputSearch.cursorPosition + 1 <=
                                    idTextInputSearch.text.length )
                            {
                                idTextInputSearch.cursorPosition++;
                            }
                            else
                                idTextInputSearch.cursorPosition = 0;
                                idCursorMarker.show(calculateMarkerPosition
                                                    (idTextInputSearch.cursorPosition));
                        }
                        else if(pndrSearchView.mode_area_focus_index == 1)
                            pndrSearchView.mode_area_focus_index = 2;
                       // else if(pndrSearchView.mode_area_focus_index == 2 && !m_btn.bDisabled) // added by wonseok.heo for ITS 266706
                       //     pndrSearchView.mode_area_focus_index = 1;
                        else
                        {}
                    }
                    else if(pndrSearchView.searchListFocused)
                    {
                        pndrSearchView.focusNext();
                    }
                    break;
                    break;
                case UIListenerEnum.JOG_WHEEL_LEFT:
                    if(pndrSearchView.modeAreaFocused)
                    {
                        button_pressed = false ;
                        if(pndrSearchView.mode_area_focus_index == 0){
                            if(idTextInputSearch.cursorPosition - 1 >=0 )
                            {
                                idTextInputSearch.cursorPosition--;
                            }
                            else
                                idTextInputSearch.cursorPosition = idTextInputSearch.text.length
                            idCursorMarker.show(calculateMarkerPosition
                                                (idTextInputSearch.cursorPosition));
                        }
                      //  else if( pndrSearchView.mode_area_focus_index == 1) // added by wonseok.heo for ITS 266706
                       //     pndrSearchView.mode_area_focus_index = 2;
                        else if(pndrSearchView.mode_area_focus_index == 2){
                         if(!m_btn.bDisabled)
                            pndrSearchView.mode_area_focus_index = 1;
                        }
                        else
                        {}
                    }
                    else if(pndrSearchView.searchListFocused)
                    {
                        pndrSearchView.focusPrev();
                    }
                    break;
                case UIListenerEnum.JOG_CENTER:

                    if(pndrSearchView.searchListFocused && jogCenterPressed ==true) // add by wonseok.heo 2015.01.15 for 256193  256192
                    {                        
                        handleCenterKey();
                        jogCenterPressed = false;
                    }
                    else
                    {
                        jogCenterPressed = false;
                        if(pndrSearchView.modeAreaFocused)
                        {
                            button_pressed = false ; //added by jyjeon 2014-03-07 for ITS 228509
                            if(pndrSearchView.mode_area_focus_index == 0)
                                pndrSearchView.searchTextBoxClicked(true);
                            else if(pndrSearchView.mode_area_focus_index == 1)
                                pndrSearchView.__startSearch();
                            else if(pndrSearchView.mode_area_focus_index == 2)
                                pndrSearchView.handleBackRequest(true);
                            else
                            {}
                        }
                    }
                    break;
                case UIListenerEnum.JOG_UP:
                    //{ modified by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
                    if(pressAndHoldTimer.running)
                    {
                        isJogUpLongPressed = false;
                        pressAndHoldTimer.stop();
                    }
                    else if(pndrSearchView.searchListFocused)
                    {
                        pndrSearchView.searchTextBoxClicked(false);
                    }
                    else
                    {
                        pndrSearchView.searchListFocused = false;
                        pndrSearchView.modeAreaFocused = true;
                        pndrSearchView.mode_area_focus_index = 0;
                        //idTextInputSearch.cursorPosition = idTextInputSearch.text.length; //modified by wonseok.heo for ITS 233156
                        idCursorMarker.show(calculateMarkerPosition(idTextInputSearch.cursorPosition));
                        //added by jyjeon 2014-03-07 for ITS 228574
                        if(keypadWidget.isHide)
                        {
                            keypadWidget.showQwertyKeypad();
                        }
                        //added by jyjeon 2014-03-07 for ITS 228574			
                    }
                    //} modified by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
                    break;
                 case UIListenerEnum.JOG_DOWN:
                     if(waitIndicator.visible) return; // added by cheolhwan 2014-02-11. ITS 223321_223519.
                     if(pressAndHoldTimer.running)
                     {
                         pressAndHoldTimer.stop();
                     }
                     else if(pndrSearchView.modeAreaFocused)
                     {
                         //{ modified by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
                         if(searchResultsModel.count > 0)
                         {
                            searchListClicked(searchItemListView.currentIndex); // modified by cheolhwan 2014-01-21. ITS 220415.
                         }
                          //{ modified by wonseok.heo 2014.03.28 NOCR for focus
                          //removed by jyjeon 2014.02.03 for ITS 223505
                         else
                         {
                            pndrSearchView.searchListFocused = false;
                            pndrSearchView.modeAreaFocused = false;
//                            idTextInputSearch.cursorDelegate = idDelegateCursor; //removed by jyjeon 2014-04-22 for ITS 227698
                            idCursorMarker.show(calculateMarkerPosition(idTextInputSearch.cursorPosition));
                            pndrSearchView.searchTextBoxClicked(true);
                         }
                          //removed by jyjeon 2014.02.03 for ITS 223505
                         // } modified by wonseok.heo 2014.03.28 NOCR for focus
                         //} modified by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
                     }
                     break;
                     case UIListenerEnum.JOG_RIGHT:
                         console.log("UIListenerEnum.JOG_RIGHT");
                         if(pndrSearchView.modeAreaFocused)
                         {
                             if(pndrSearchView.mode_area_focus_index == 0){
                                 idCursorMarker.hide();
                                 if(!m_btn.bDisabled)
                                    pndrSearchView.mode_area_focus_index = 1;
                                 else
                                    pndrSearchView.mode_area_focus_index = 2;
                             }
                         }
                     break;
                     case UIListenerEnum.JOG_LEFT:
                         console.log("UIListenerEnum.JOG_LEFT");

                         if(pndrSearchView.modeAreaFocused == true)
                         {
                             if(pndrSearchView.mode_area_focus_index == 1 ||
                                     pndrSearchView.mode_area_focus_index == 2){
                                    pndrSearchView.mode_area_focus_index = 0
                                    idCursorMarker.show(calculateMarkerPosition(idTextInputSearch.cursorPosition));
                                 }
                         }
                     break;
            }
        }

        else if (status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
        {
                switch(arrow)
                {
                    case UIListenerEnum.JOG_DOWN:                        
                        if(searchListFocused)
                        {
                            isJogUpLongPressed = false;
                            pressAndHoldTimer.start();
                        }
                    break;
                    case UIListenerEnum.JOG_UP:                        
                        if(searchListFocused)
                        {
                            isJogUpLongPressed = true;
                            pressAndHoldTimer.start();
                        }
                    break;
                }
        }//{ add by wonseok.heo 2015.01.15 for 256193  256192
        else if (status == UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED)
        {
            switch(arrow)
            {
                case UIListenerEnum.JOG_CENTER:
                    if(pndrSearchView.searchListFocused)
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
    
    function focusNext( )
    {
        if(searchItemListView.flicking || searchItemListView.moving) return; //added by esjang 2013.10.29 for CCP dial and bouncing issue 

        var index = searchItemListView.currentIndex;
        if((index + 1) < searchResultsModel.count)
        {
            //modified by jyjeon 2014.01.24 for ITS 222064
            if (index == searchItemListView.indexAt(searchItemListView.width / 2, searchItemListView.contentY + searchItemListView.height - searchItemListView.currentItem.height/2 - 10))
                searchItemListView.positionViewAtIndex(index == searchItemListView.count - 1 ? 0 : index + 1, ListView.Beginning)
            //modified by jyjeon 2014.01.24 for ITS 222064
            searchItemListView.incrementCurrentIndex();
        }
        else
        //{ modified by yongkyun.lee 2014-04-06 for : ITS 233636
        {
            if( searchScrollBar.visible)               
            searchItemListView.currentIndex = 0;
        }
        //} modified by yongkyun.lee 2014-04-06 

    }

    function focusPrev( )
    {
        if(searchItemListView.flicking || searchItemListView.moving) return; //added by esjang 2013.10.29 for CCP dial and bouncing issue 

        var index = searchItemListView.currentIndex;
        if((index - 1) >= 0)
        {
            //modified by jyjeon 2014.01.24 for ITS 222064
            if (index == searchItemListView.indexAt(width / 2, searchItemListView.contentY + searchItemListView.currentItem.height/2 + 10))
                searchItemListView.positionViewAtIndex(index == 0 ? searchItemListView.count - 1 : index - 1, ListView.End)
            //modified by jyjeon 2014.01.24 for ITS 222064

            searchItemListView.decrementCurrentIndex();
        }
        else
        //{ modified by yongkyun.lee 2014-04-06 for : ITS 233636
        {
            if( searchScrollBar.visible)                          
            searchItemListView.currentIndex = searchResultsModel.count - 1;
        }
        //} modified by yongkyun.lee 2014-04-06 
    }

    function handleCenterKey()
    {
        //modified by cheolhwan 2013.11.28 Modified the condition. for ITS 211659.
        //if(searchListFocused && 0 <= searchItemListView.currentIndex < searchResultsModel.count )
        if(searchListFocused && (0 <= searchItemListView.currentIndex && searchItemListView.currentIndex < searchResultsModel.count) )
        {
            popupLoading.visible = true;
            keypadWidget.hideQwertyKeypad();
            handleStationSelectionEvent(searchItemListView.currentIndex);
        }
    }


    function searchTextBoxClicked(jogKey)
    {
        if(keypadWidget.isHide)
        {
            keypadWidget.showQwertyKeypad();
        }
        pndrSearchView.searchListFocused = false;
        if(jogKey){
            idCursorMarker.hide();
            pndrSearchView.modeAreaFocused = false ;
            keypadWidget.currentFocusIndex = 0;
            keypadWidget.showFocus();
            __LOG("searchTextBoxClicked "  , LogSysID.LOW_LOG);
            keypadWidget.clearAutomata();
        }
        else
        {
            keypadWidget.hideFocus();
            keypadWidget.focus_visible = false;
            pndrSearchView.modeAreaFocused = true ;
            pndrSearchView.mode_area_focus_index = 0;
            //{ added by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
            idTextInputSearch.cursorPosition = idTextInputSearch.text.length;
            //} added by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
            idCursorMarker.show(calculateMarkerPosition(idTextInputSearch.cursorPosition));
        }
    }

    //{ added by cheolhwan 2014-01-21. ITS 220415.
    function searchListClicked(sIndex)
    {
        __LOG("searchListClicked() : searchResultsModel.count[" + searchResultsModel.count + "]" , LogSysID.LOW_LOG );
        if(searchResultsModel.count < 1) return;
        
        idCursorMarker.hide();
        pndrSearchView.searchListFocused = true;
        pndrSearchView.modeAreaFocused = false;
        searchItemListView.currentIndex = sIndex;
        if(searchItemListView.currentIndex == -1)
        {
            __LOG("searchListClicked() : (searchItemListView.currentIndex == -1) " , LogSysID.LOW_LOG );
            searchItemListView.currentIndex = 0;
        }
        searchItemListView.positionViewAtIndex( searchItemListView.currentIndex,ListView.Beginning);
        keypadWidget.hideQwertyKeypad();
        keypadWidget.hideFocus();
        keypadWidget.focus_visible = false;
    }
    //} added by cheolhwan 2014-01-21. ITS 220415.

    function __startSearch()
    {
        //{ modified by yongkyun.lee 2014-09-03 for : 
        if(keypadWidget.keyDeleteRunning())
            return        
        //} modified by yongkyun.lee 2014-09-03 
        if(!keypadWidget.isHide)
        {
            keypadWidget.hideQwertyKeypad();
            keypadWidget.hideFocus();
            keypadWidget.focus_visible = false;
        }

        if(pndrSearch.sSearchString !== "" && searchResultsModel.count <= 0)
        {
            noResultsText.visible = false;
            showWaitNote();

            //added by jyjeon 2014-02-13 for key delay
            keyDelayTimer.restart();
            //pndrSearch.SearchAutoComplete(pndrSearch.sSearchString);
            //added by jyjeon 2014-02-13 for key delay
        }
        else
        {
           manageFocus();

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
        pndrSearchView.enabled = true;
        waitIndicator.visible = false;
        searchItemListView.visible = true;
    }

    function getWaitIndicatorStatus()
    {
        return waitIndicator.visible;
    }

    function manageFocus()
    {

        if(!keypadWidget.isHide)
        {
            keypadWidget.hideQwertyKeypad();
            keypadWidget.hideFocus();
            keypadWidget.focus_visible = false;
        }

//        keypadWidget.hideQwertyKeypad();
        if(searchResultsModel.count > 0)
        {
            idCursorMarker.hide();
            pndrSearchView.searchListFocused = true;
            pndrSearchView.modeAreaFocused = false;
           //pndrSearchView.focusIndex = 0;
            searchItemListView.currentIndex = 0;
            searchItemListView.positionViewAtIndex(searchItemListView.currentIndex,ListView.Beginning);
        }
        else
        {
            pndrSearchView.searchListFocused = false;
            pndrSearchView.mode_area_focus_index = 0;
            pndrSearchView.modeAreaFocused = true;
            idCursorMarker.show(calculateMarkerPosition(idTextInputSearch.cursorPosition));
        }
    }

    function manageFocusOnPopUp(status)
    {
        __LOG(" manageFocusOnPopUp(status) -> " + status , LogSysID.LOW_LOG );
        
        if(popupLoading.visible)
            popupLoading.visible = false;

        if(status)
        {
            if(!keypadWidget.isHide)
            {
                keypadWidget.hideFocus();
                keypadWidget.focus_visible = false;
            }
            jogCenterPressed = false; // add by wonseok.heo 2015.01.15 for 256193  256192
            idCursorMarker.hide(); //added by jyjeon 2014-03-14 for ITS 229391
            pndrSearchView.searchListFocused = false;//{ modified by yongkyun.lee 2014-03-12 for : 229140
            pndrSearchView.modeAreaFocused = false; //added by jyjeon 2014.02.03 for ITS 223607
            pressAndHoldTimer.stop(); //added by wonseok.heo 2015.02.09 for ITS 257836
        }
        else
        {
            if(!keypadWidget.isHide)
            {
                idCursorMarker.hide();
                pndrSearchView.searchListFocused = false;
                pndrSearchView.modeAreaFocused = false;
                keypadWidget.focus_visible = true;
                keypadWidget.showFocus();
            }
            //added by jyjeon 2014-03-14 for ITS 229391
            else
            {
                if(searchResultsModel.count > 0)
                {
                    pndrSearchView.searchListFocused = true;
                }
                else
                {
                    pndrSearchView.modeAreaFocused = true;
                }
            }
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
                keypadWidget.currentCursor = idTextInputSearch.curPos
                idTextInputSearch.cursorPosition = idTextInputSearch.curPos
                }
                else
                {
                    keypadWidget.currentCursor = keypadWidget.currentCursor -1;
                    keypadWidget.currentCursor = keypadWidget.currentCursor ;
                }
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
            keypadWidget.currentCursor = idTextInputSearch.curPos
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
                keypadWidget.currentCursor = idTextInputSearch.curPos
                idTextInputSearch.cursorPosition = idTextInputSearch.curPos
            } 
            else 
            {
            }
        }
        keypadWidget.showFocus();
        pndrSearchView.modeAreaFocused = false;

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
        keypadWidget.showQwertyKeypad();
        pndrSearchView.searchListFocused = false;
        keypadWidget.currentFocusIndex = 0;
        pndrSearchView.modeAreaFocused = false;
        keypadWidget.showFocus();
        keypadWidget.clearAutomata();

    }
    //==============================================================

    Component.onCompleted: {
        activeView = pndrSearchView;
        isFirstLoad = true; // added by cheolhwan 2014-01-27. ITS 222951.
        //pndrSearch.sSearchString = "";

    }

    //added by jyjeon 2014-04-22 for ITS 227698
    onVisibleChanged:{
        if(visible)
        {
            activeView = pndrSearchView;
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
        pndrSearchView.searchListFocused = false;
        pndrSearchView.modeAreaFocused = false;
        keypadWidget.showQwertyKeypad();
        keypadWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
        keypadWidget.focus_visible = true;
        keypadWidget.showFocus();
        keypadWidget.disableDone_DeleteButton();
        keypadWidget.disableHideButton(); // modified by wonseok.heo for ITS 255426

        pndrSearchView.visible = visibleStatus;
        searchScrollBar.visible = false; //added by esjang for test 
        noResultsText.visible = false;
        //modified by jyjeon 2014-04-22 for ITS 227698
    }

    //added by jyjeon 2014-04-22 for ITS 227698
    DHAVN_KeyPad{
        id: keypadWidget
        visible: true
    }
    //added by jyjeon 2014-04-22 for ITS 227698    

    /* INTERNAL functions */
    function calculateMarkerPosition(mouseX) {
        var rect = idTextInputSearch.positionToRectangle(idTextInputSearch.cursorPosition);
        return rect.x;
    }

    ListView
    {
        id: searchItemListView

        snapMode: ListView.SnapToItem
        delegate: searchlistItemDelegate
        model: searchResultsModel
        anchors.fill: parent
        anchors.top: parent.top
        anchors.topMargin: 72
        anchors.left: parent.left
        clip: true
        focus: true
        highlight:highlighItem
        highlightMoveDuration: 1

        //boundsBehavior: ListView.StopAtBounds
        interactive : !popupLoading.visible
        currentIndex : -1
        visible: false


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

        onMovementStarted: {
            //{ added by cheolhwan 2014-02-12. ITS 223476.
            if(searchResultsModel.count < 1) return;
            if(!keypadWidget.isHide)//{ modified by yongkyun.lee 2014-03-06 for :  ITS 228304
            {
                keypadWidget.hideQwertyKeypad();
                keypadWidget.hideFocus();
                keypadWidget.focus_visible = false
            }
            //} added by cheolhwan 2014-02-12. ITS 223476.
        }

        onMovementEnded: 
        {
            __LOG("onMovementEnded" , LogSysID.LOW_LOG );

            //{ modified by yongkyun.lee 2014-02-26 for : ITS 226286
            if(searchResultsModel.count > 0)
            {
                var startIndex = -1
                pndrSearchView.searchListFocused = true
                pndrSearchView.modeAreaFocused   = false
                idCursorMarker.hide();
                
                if(searchItemListView.currentItem == null)
                    startIndex = 0;
                else
                    startIndex = indexAt(width / 2, (contentY + searchItemListView.currentItem.height/2 + 10))

                if(startIndex == -1)
                {
                    startIndex = 0;
                }
                //{ modified by yongkyun.lee 2014-03-06 for : ITS 228306
                if(currentIndex >= startIndex && currentIndex <= startIndex + 6)
                {
                    __LOG("onMovementEnded3" , LogSysID.LOW_LOG );
                    currentIndex = startIndex; //added by wonseok.heo for ITS 272236 2016.04.10
                    // current position
                }
                else
                //} modified by yongkyun.lee 2014-03-06 
                {
                    __LOG("onMovementEnded4" , LogSysID.LOW_LOG );
                    currentIndex = startIndex;
                    positionViewAtIndex( currentIndex , ListView.Beginning);
                }
            }
            //{ modified by yongkyun.lee 2014-03-19 for : ITS 230057
            // else
            // {
            //     pndrSearchView.searchListFocused = false;
            //     pndrSearchView.mode_area_focus_index = 0;
            //     pndrSearchView.modeAreaFocused = true;
            //     idCursorMarker.show(calculateMarkerPosition(idTextInputSearch.cursorPosition));
            // }
            //} modified by yongkyun.lee 2014-03-19 
            //} modified by yongkyun.lee 2014-02-26 
        }

        VerticalScrollBar
        {
            id: searchScrollBar
            //anchors.top: parent.top
            //anchors.right: parent.right
            anchors.top: searchItemListView.top
            anchors.right: searchItemListView.right
            anchors.topMargin: 34
            anchors.rightMargin: 8
            //parent: null
            height: 465
            //{ added by cheolhwan 2-14-01-09. ITS 218626.
            position: searchItemListView.visibleArea.yPosition
            //} added by cheolhwan 2-14-01-09. ITS 218626.
            //pageSize: parent.visibleArea.heightRatio
            //{ Modified by LYK 2014-02-12. ITS 223527.
            //pageSize: (PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT - listModeAreaWidget.height - 45 )/(90 * count) //flick.visibleArea.heightRatio
            pageSize: (PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT - listModeAreaWidget.height )/(90 * count) //flick.visibleArea.heightRatio
            //} Modified by LYK 2014-02-12. ITS 223527.
	    //visible: ((PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT - listModeAreaWidget.height - 45 )/(90 * inSearchResultList.length)<1)//( pageSize < 1 || pageSize == 1 )
            visible: ( pageSize < 1 || pageSize == 1 )
        }
    }

    Component
    {
        id: highlighItem
        Item
        {
            Image {
                id: highligtItem
                x: 15
                y: -2
                width: 1238
                height: 96
                source: PR_RES.const_APP_PANDORA_LIST_VIEW_ITEM_BORDER_IMAGE;
                visible: (searchListFocused && !popupVisible) //modified by jyjeon 2014-04-02 for ITS 233098
            }
        }
    }

    Component
    {
        id: searchlistItemDelegate
            Item
            {

                    id:id_border
                    visible:  true
                    x: 0
                    y: 0
                    width: 1238
                    height: 90

                    Image
                    {
                      id: pressedImage
                      source: PR_RES.const_APP_PANDORA_LIST_VIEW_ITEM_BACKGROUND
                      //{ modified by cheolhwan 2013.12.05 for ITS 213019.
                      //width: PR.const_PANDORA_STATION_LIST_VIEW_TRACKITEM_TEXT_WIDTH;
                      width: PR.const_APP_PANDORA_LISTITEM_WITHOUT_QUICKSCROOL_HIGHLIGHT_WIDTH
                      //} modified by cheolhwan 2013.12.05 for ITS 213019.
                      height: PR.const_PANDORA_STATION_LIST_VIEW_ROW_HEIGHT_WITHBORDER
                      anchors.left: parent.left
                      anchors.leftMargin:  1
                      visible: mouse_area.pressed || (jogCenterPressed && searchItemListView.currentIndex === index)
                    }
//                BorderImage {
//                    id: borderImage
//                    source: PR_RES.const_APP_PANDORA_LIST_VIEW_ITEM_BORDER_IMAGE
//                    width: PR.const_PANDORA_ALL_SCREEN_WIDTH - 70;
//                    height: PR.const_PANDORA_STATION_LIST_VIEW_ROW_HEIGHT
//                    border.left: 5; border.top: 5
//                    border.right: 5; border.bottom: 5
//                    visible: searchListFocused && (focusIndex == index)
//                }

//                Text
//                {
//                    id: id_text
//                    text: name
//                    font.pointSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT
//                    font.family: PR.const_PANDORA_FONT_FAMILY_HDR //added by esjang 2013.08.21
//                    color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY//PR.const_PANDORA_COLOR_TEXT_PROGRESS_BLUE
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.left: parent.left
//                    anchors.leftMargin: 20
//                }

                DHAVN_MarqueeText
                 {
                    id: id_text

                    text: name
                    scrollingTicker:pndrSearchView.scrollingTicker && (searchListFocused === true) &&
                                     index == searchItemListView.currentIndex &&
                                     (UIListener.getStringWidth(searchResultsModel.get(searchItemListView.currentIndex).name , PR.const_PANDORA_FONT_FAMILY_HDR ,
                                                                PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT) > (PR.const_PANDORA_STATION_LIST_VIEW_TRACKITEM_TEXT_WIDTH + 100 ))
                    fontSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT
                    fontFamily: PR.const_PANDORA_FONT_FAMILY_HDR //added by esjang 2013.08.21
                    color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY//PR.const_PANDORA_COLOR_TEXT_PROGRESS_
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 101
                    width: PR.const_PANDORA_STATION_LIST_VIEW_TRACKITEM_TEXT_WIDTH + 100 ;
                 }

                Image
                {
                    id:listline
                    source:PR_RES.const_APP_PANDORA_LIST_VIEW_LIST_LINE
                    x : 0
                    y: 90
                }

                MouseArea
                {
                    id: mouse_area
                    beepEnabled: false
                    anchors.fill: parent
                    enabled : !popupLoading.visible // added by jyjeon 20140104 for ITS 217562

                    onClicked:
                    {
                        UIListener.ManualBeep();
                        popupLoading.visible = true;
                        keypadWidget.hideQwertyKeypad();
                        handleStationSelectionEvent(index);
                    }
                }

            }
    }

    ListModel
    {
       id: searchResultsModel
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
            cursorDelegate: (pndrSearchView.modeAreaFocused && pndrSearchView.mode_area_focus_index == 0 )?  idDelegateFocusCursor : idDelegateCursor; //modified by jyjeon 2014-04-30 for ITS 228574
            horizontalAlignment: Text.AlignLeft
            property string keyCompensation: "";
            property int curPos: -1


            onTextChanged: {

                //{ modified by yongkyun.lee 2014-02-25 for : ITS 226613
                //  if(keypadWidget)
                //      idTextInputSearch.cursorPosition =  keypadWidget.currentCursor
                //} modified by yongkyun.lee 2014-02-25 

                if(false == keypadWidget.focus) {
                    keypadWidget.forceActiveFocus();
                }

                idCursorMarker.hide();

                keypadWidget.forceActiveFocus();


                if(0 == idTextInputSearch.text.length) {
                    keypadWidget.disableDone_DeleteButton();
                    keypadWidget.disableHideButton(); // modified by wonseok.heo for ITS 255426
                } else {
                    keypadWidget.enableDone_DeleteButton();
                    keypadWidget.enableHideButton(); // modified by wonseok.heo for ITS 255426
                }
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
                    UIListener.ManualBeep();
                    if(keypadWidget.isHide)
                        pndrSearchView.searchTextBoxClicked(false)
                    else {
                        var position = idTextInputSearch.positionAt(mouseX, TextInput.CursorOnCharacter);
                        //{ added by cheolhwan 201-01-17. ITS 220797.
                        keypadWidget.hideFocus();
                        keypadWidget.focus_visible = false;
                        pndrSearchView.searchListFocused = false;
                        pndrSearchView.modeAreaFocused = true;
                        pndrSearchView.mode_area_focus_index = 0;
                        //} added by cheolhwan 201-01-17. ITS 220797.
                        if(position != idTextInputSearch.cursorPosition){
                            __LOG("onClicked "  , LogSysID.LOW_LOG);
                            idTextInputSearch.cursorPosition =position;
                            keypadWidget.clearAutomata();
                        }
                        // { modified by wonseok.heo for ITS 233156
                        if(0 != idTextInputSearch.text.length)
                        idCursorMarker.show(calculateMarkerPosition(mouseX));
                        // } modified by wonseok.heo for ITS 233156
                    }
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
        bFocused: ( pndrSearchView.mode_area_focus_index == 1 ) && modeAreaFocused
        visible: true
        bFocusAble: (pndrSearch.sSearchString.length > 0)
        bDisabled : (pndrSearch.sSearchString.length <= 0)
        onBDisabledChanged:
        {
            if(bDisabled === true){
                searchButton = PR_RES.const_WIDGET_SB_IMG_D
                if(keypadWidget != null)
                    keypadWidget.disableDone_DeleteButton();
                keypadWidget.disableHideButton(); // modified by wonseok.heo for ITS 255426
            }
            else{
                if(keypadWidget != null )
                    keypadWidget.enableDone_DeleteButton();
                keypadWidget.enableHideButton(); // modified by wonseok.heo for ITS 255426
                searchButton = PR_RES.const_WIDGET_SB_IMG_N
            }

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
            pndrSearchView.handleBackRequest(false);
        }
        bFocused: ( pndrSearchView.mode_area_focus_index == 2 ) && modeAreaFocused
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
            keypadWidget.currentCursor = idTextInputSearch.cursorPosition;
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
                keypadWidget.currentCursor = idTextInputSearch.cursorPosition;
                console.log("# idTextInputSearch.cursorPosition = " + idTextInputSearch.cursorPosition);
                console.log("# keypadWidget.currentCursor = " + keypadWidget.currentCursor);
            }
        }

        onSigMarkerPositionRelease: {
            var cursorPosition = idTextInputSearch.positionAt(position, TextInput.CursorOnCharacter);
            if(cursorPosition != idTextInputSearch.cursorPosition) {
                idTextInputSearch.cursorPosition = cursorPosition;

                keypadWidget.currentCursor = idTextInputSearch.cursorPosition;
            }

            // Sync position
            idCursorMarker.syncPosition(calculateMarkerPosition(position));
        }

        onSigMarkerPositionSync: {
            keypadWidget.currentCursor = position;
        }
    }


     DHAVN_PandoraWaitView{
         id: waitIndicator
         //{ add by cheolhwan 2013.12.04 for ITS 212559 (by GUI guideline).
         //y: -53
         y: (keypadWidget && keypadWidget.isHide) ? 120 : -80 //modified by jyjeon 2014.01.15 for ITS 218791
         //} add by cheolhwan 2013.12.04 for ITS 212559 (by GUI guideline).
         visible: false
     }

     Text {
        id: noResultsText
        text: qsTranslate("main", "STR_PANDORA_NO_SEARCH_RESULTS_FOUND")
        visible: false
        x: 150
        y: (keypadWidget && keypadWidget.isHide) ? 294 : 124 //modified by jyjeon 2014.01.15 for ITS 218791
        width: 980
        height: 40
        z: 10
        font.pointSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT
        font.family: PR.const_PANDORA_FONT_FAMILY_HDR
        color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
        horizontalAlignment: "AlignHCenter"
        wrapMode: Text.WordWrap

     }

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

    Timer{
        id: pressAndHoldTimer
        running: false
        repeat: true
        interval: 100
        onTriggered:{
            var index = searchItemListView.currentIndex; // modified by esjang 2013.08.26 for ITS #191192
            //console.log("esjang 131007 index: " + index) 
            if(isJogUpLongPressed)
            {
                if( (index - 1) >= 0) // modified by esjang 2013.08.26 for ITS #191192
                    focusPrev();
            }
            else
            {
                if((index + 1) < searchResultsModel.count) // modified by esjang 2013.08.26 for ITS #191182
                    focusNext();
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
