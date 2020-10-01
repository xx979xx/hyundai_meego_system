import Qt  4.7
import QmlModeAreaWidget 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import QmlSimpleItems 1.0
import PandoraMenuItems 1.0
import QmlOptionMenu 1.0
import PandoraSortTypes 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PandoraListReqType 1.0
//{ modified by yongkyun.lee 2014-02-18 for : 
import POPUPEnums 1.0
//} modified by yongkyun.lee 2014-02-18 

import CQMLLogUtil 1.0



Item {
    id: pndrListView
    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    height: PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT
    y: PR.const_PANDORA_ALL_SCREENS_TOP_OFFSET
    anchors.bottomMargin: PR.const_PANDORA_ALL_SCREEN_BOTTOM_MARGIN
    //visible: true
    //QML Properties Declaration
    property int counter: PR.const_PANDORA_TIMER_COUNTER_MIN_VAL
    property int count: 0    
    property bool focus_visible: true//false
    property variant activeList: null
    property int currPlayIndex: -1 // a function need to update it while track update
    property bool hideMenu: true;
    property bool isFromErrorView: false
    property alias isOptionsMenuVisible: optMenu.visible
    property string currIndexChar;
    property bool jogCenterPressed: false
    //property bool isJogEventinModeArea: false;
    property bool isPlaying: pndrTrack.IsPlaying()? true:false;// added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
    //property int previous_focus_index : 0
    property bool scrollingTicker:UIListener.scrollingTicker;
    property bool isJogUpLongPressed: false; //added by esjang 2013.08.16 for ITS #182990
    property bool isInsufficientLIST: false;
    property bool swKeyPress: false; //{ modified by yongkyun.lee 2014-03-07 for : ITS 228305
    property bool isSystemPopup : false;//{ modified by yongkyun.lee 2014-03-21 for : ITS 229140

    signal getNextListItems(int num)
    signal getFirstListItems(int num)
    signal getIndexListItems(int num)
    signal handlestationSelectionEvent(int stationIndex);
    signal handleSearchViewEvent();
    //signal handleBackRequest();
    signal handleBackRequest(bool isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
    // signal lostFocus(int arrow, int status);
    property bool reqIsOn: false
    property bool focusIsDown: false //added by esjang 2013.08.16 for ITS #182990
    property string loadtext: qsTranslate("main","STR_PANDORA_LOADING"); //QT_TR_NOOP("STR_PANDORA_LOADING")    //{ modified by yongkyun.lee 2014-03-28 for : List update
    property bool isBtPandora : UIListener.IsBTPandora()// modified by yongkyun.lee 2014-06-03 for :  ITS 238641

    property string logString :""

    //{ modified by yongkyun.lee 2014-03-11 for : ITS 228237
    function setInsufficient(isIns)
    {
        (isInsufficientLIST = isIns);
    }
    //} modified by yongkyun.lee 2014-03-11

    function getWaitIndicatorStatus()
    {
        return waitIndicator.visible;
    }

    //{ modified by yongkyun.lee 2014-09-30 for : ITS 249293
    function checkCurrentstation()
    {
        if(pndrStationList.StationListCount() > 0)
        {
            count         = pndrStationList.StationListCount();
        }
        if( pndrStationList.GetCurrentActiveIndex())
        {
            currPlayIndex = pndrStationList.GetCurrentActiveIndex()
        }

         if(UIListener.IsCalling()){ //modified by wonseok.heo for ITS 269343 2015.10.05
             listModeAreaWidget.is_lockoutMode= true;

         }

        __LOG("checkCurrentstation count=" + count +" , currPlayIndex ="+currPlayIndex , LogSysID.LOW_LOG );
    }
    //} modified by yongkyun.lee 2014-09-30 


    function handleMenuKey(/*isJogMenuKey*/)
    {
        //{ modified by yongkyun.lee 2014-04-30 for :  ITS 236250
        if(swKeyPress )
        {
            sendTouchCleanUpForApps();
        }
        //} modified by yongkyun.lee 2014-04-30 
        
        if(UIListener.IsCalling()){
            // modified by jyjeon 2014.01.06 for ITS 217984
            //pndrNotifier.UpdateOSDOnCallingState();
            popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE, false);
            return;
        }
        //{ modified by yongkyun.lee 2014-05-15 for : 
        if(popupVisible)
        {
             return;
        }
        //} modified by yongkyun.lee 2014-05-15 

        if( pndrListView !== null && pndrListView.visible)
        {
            if(!popupLoading.visible)
            {
                __LOG("Toggling the menu" , LogSysID.LOW_LOG );
                if(optMenu.visible) // from true to false
                {
                    optMenu.hide();
                    UIListener.SetOptionMenuVisibilty( false);
                }
                else // from false  to true
                {
                    //                    optMenu.visible = true;
                    optMenu.showMenu();
                    listModeAreaWidget.hideFocus();
                    pndrListView.hideFocus();
                    optMenu.showFocus();
                    optMenu.setDefaultFocus(0);
                    UIListener.SetOptionMenuVisibilty( true);
                }
            }
            else
            {
                // removed by esjang 2013.12.17 for ITS # 215639
                //waitpopup.showPopup(qsTranslate("main","STR_PANDORA_OPERATION_INPROGRESS"));
            }
        }
    }

    //{ modified by yongkyun.lee 2014-03-28 for : List update
    function updateList()
    {
        var inType;
        inType        = pndrStationList.StationListSortType();
        count         = pndrStationList.StationListCount();
        currPlayIndex = pndrStationList.GetCurrentActiveIndex()
        if(count <= currPlayIndex)
            currPlayIndex = 0;
        
        __LOG("updateList: count=" + count + " , currPlayIndex" + currPlayIndex , LogSysID.LOW_LOG );
        
        if(popupLoading.visible)
            popupLoading.visible = false  
        if(inType === SortType.SORT_BY_ALPHA)
        {
            if(pndrListView.state !== "SortByAlphabateState")
            {
                state ="SortByAlphabateState"
            }
            pandoraMenus.SetSortListMenuModel(MenuItems.Alphabet);
            alphabeticList.visible = true;
        }
        else
        {
            if(pndrListView.state !== "SortByDateState")
            {
                state ="SortByDateState"
            }
            pandoraMenus.SetSortListMenuModel(MenuItems.Date);
            alphabeticList.visible = false;
        }
    
        albumModel.clear();
        for (var i =  0 ; i < count ; i ++)
        {
    
            var letter = "";
            var st        = pndrStationList.StationName((i));
            var albumPath = pndrStationList.IsStationArtPresent((i));
            var shared    = pndrStationList.IsSharedStation((i)); // added by jyjeon 2013.12.09 for UX Update
            if(albumPath.length <= 0){
                albumPath=PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_STATION_IMG;
            }
            //__LOG("currPlayIndex= " + currPlayIndex+i  , LogSysID.LOW_LOG );

            if(inType === SortType.SORT_BY_ALPHA  &&  i != 0 )
            {
                letter = pndrStationList.Key(st , isBtPandora);// modified by yongkyun.lee 2014-06-03 for :  ITS 238641
                //__LOG("SORT_BY_ALPHA : " + letter + ", stv =" + st  , LogSysID.LOW_LOG  );
                albumModel.append({"name": (st=="")?  loadtext: st,
                                "letter": letter,
                                "stationartpath": albumPath,
                                "shared": (st=="")?  false:shared }) 
            }
            else
            {
                //__LOG("SORT_BY_DATE :" + letter + ", stv =" + st   , LogSysID.LOW_LOG  );
                albumModel.append({"name": (st=="")?  loadtext: st,
                               "stationartpath": albumPath,
                               "shared": (st=="")?  false:shared }) 
            }
    
        }


        {
            //__LOG("currPlayIndex : " + currPlayIndex , LogSysID.LOW_LOG );
            pndrStationList.ResetListReqType();
            pndrListView.showFocus();
        
        
            if( currPlayIndex > 0 )
            {
                activeList.currentIndex = currPlayIndex
                activeList.positionViewAtIndex(currPlayIndex,ListView.Center);
            }
            else
            {
                activeList.currentIndex = 0
                activeList.positionViewAtIndex(0,ListView.Beginning);
            }
        }
       
      
        if(waitpopup.visible === true)
        {
            if(popupLoading.visible === false || reqIsOn == false )
            {
                waitpopup.visible = false;
            }
        }
        pndrListView.focus_visible = true;
    }
    //} modified by yongkyun.lee 2014-03-28 

    //{ modified by yongkyun.lee 2014-12-12 for : ITS 254472
    function isToastPopup()
    {
        return popupLoading.visible ;
    }    
    //} modified by yongkyun.lee 2014-12-12 

    //{ modified by yongkyun.lee 2014-08-22 for : ITS 246133
    function closeToastPopup()
    {
        if(popupLoading.visible) // if dissmisable toast pop up is visible , then make it false
        {
            popupLoading.visible = false;
        }
        return true;
    }
    //} modified by yongkyun.lee 2014-08-22 

    /***************************************************************************/
    /**************************** Pandora Qt connections START *****************/
    /***************************************************************************/

    Connections
    {
        target:pndrStationList

        onRequestFail:
        {
            popupLoading.visible = false
            //UIListener.SetLoadingPopupVisibilty(popupLoading.visible);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
        }

        onStationToken:
        {
            __LOG( "count :" + inListCount , LogSysID.LOW_LOG  );

            //{ modified by yongkyun.lee 2014-03-28 for :  List update
            // albumModel.clear();
            // count =  0;           
            // activeList = null
            // currPlayIndex = -1 // a functio            
            // 
            // for (var i =0 ; i < inListCount ; i++)
            // {
            //  albumModel.append({"name": "",
            //                    "letter": "",
            //                    "stationartpath": "",
            //                    "shared": ""}) // added by jyjeon 2013.12.09 for UX Update
            // }
            //} modified by yongkyun.lee 2014-03-28 
        }

        //{ modified by yongkyun.lee 2014-03-28 for : List update
        onPreFetchingStart:
        {
        }

        onPreFetchingCompleted:
        {
            __LOG("onPreFetchingCompleted" , LogSysID.LOW_LOG );
            updateList();
            pndrTrack.onBrandingImageStart();//{ modified by yongkyun.lee 2014-10-08 for : Branding - Middleware
        }
        //} modified by yongkyun.lee 2014-03-28 

        onStationListReceived:
        {
            __LOG("station List received count : " + inCount , LogSysID.LOW_LOG );

            if(inCount <= 0)//{ modified by yongkyun.lee 2014-03-28 for : List update
            {
                __LOG("CRITICAL : No album model set yet " , LogSysID.LOW_LOG );
                return;
            }

            count = inCount //inStationList.length;
            if(albumModel.count === 0 )
            {
                currPlayIndex = -1
            }


            if(inType === SortType.SORT_BY_ALPHA)
            {
                if(pndrListView.state !== "SortByAlphabateState")
                {
                    state ="SortByAlphabateState"
                }
                pandoraMenus.SetSortListMenuModel(MenuItems.Alphabet);
                alphabeticList.visible = true;
            }
            else
            {
                if(pndrListView.state !== "SortByDateState")
                {
                    state ="SortByDateState"
                }
                pandoraMenus.SetSortListMenuModel(MenuItems.Date);
                alphabeticList.visible = false;
            }


            albumModel.clear();//{ modified by yongkyun.lee 2014-03-28 for : List update
            __LOG(" Station start index : [" + inStartIndex + "] inCount["+ inCount + "]" , LogSysID.LOW_LOG );
            for (var i =  0 ; i < inCount /*inStationList.length*/ ; i ++)
            {
                // __LOG(" Station Name : " + inStationList[i] , LogSysID.LOW_LOG )

                var letter = "";
                var st = pndrStationList.StationName((i));
                var albumPath = pndrStationList.IsStationArtPresent((i));
                var shared = pndrStationList.IsSharedStation((i)); // added by jyjeon 2013.12.09 for UX Update
                if(albumPath.length <= 0){
                    albumPath=PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_STATION_IMG;
                }

                if(inType === SortType.SORT_BY_ALPHA  &&  i != 0 )
                {
                    letter = pndrStationList.Key(st , isBtPandora);// modified by yongkyun.lee 2014-06-03 for :  ITS 238641
                    //{ modified by yongkyun.lee 2014-03-28 for : List update
                    albumModel.append({"name": (st=="")?  loadtext: st,
                                    "letter": letter,
                                    "stationartpath": albumPath,
                                    "shared": (st=="")?  false:shared }) // added by jyjeon 2013.12.09 for UX Update

                    //albumModel.set((inStartIndex+i),{"name": st/*inStationList[i]*/,
                    //               "letter": letter,
                    //               "stationartpath": albumPath,
                    //               "shared": shared} ) // added by jyjeon 2013.12.09 for UX Update
                    //} modified by yongkyun.lee 2014-03-28 
                }
                else
                {
                    //{ modified by yongkyun.lee 2014-03-28 for : List update
                    albumModel.append({"name": (st=="")?  loadtext: st,
                                   "stationartpath": albumPath,
                                   "shared": (st=="")?  false:shared }) // added by jyjeon 2013.12.09 for UX Update
                    //albumModel.set((inStartIndex+i),{"name": st/*inStationList[i]*/,
                    //               "stationartpath": albumPath,
                    //               "shared": shared} ) // added by jyjeon 2013.12.09 for UX Update
                    //} modified by yongkyun.lee 2014-03-28 
                }

                //albumModel.sync();//{ modified by yongkyun.lee 2014-03-28 for : List update
            }

            currPlayIndex = inCurrPlayIndex;
            if(inReqType & ListReqType.EFIRSTLIST)
            {
                __LOG(" currPlayIndex : " + currPlayIndex , LogSysID.LOW_LOG );
                pndrStationList.ResetListReqType();
                pndrListView.showFocus();


                if( currPlayIndex > 0 )
                {
                    activeList.currentIndex = currPlayIndex
                    activeList.positionViewAtIndex(currPlayIndex,ListView.Center);
                }
                else
                {
                    activeList.currentIndex = 0
                    activeList.positionViewAtIndex(0,ListView.Beginning);
                }

                if(pndrStationList.IsPendingRequest() > 0)
                    reqIsOn = ((inReqType & ListReqType.EQUICKLIST))  || false;
                else
                    reqIsOn = false;

                popupLoading.visible = reqIsOn
                //UIListener.SetLoadingPopupVisibilty(reqIsOn);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615

            }
            else if(inReqType & ListReqType.EQUICKLIST)
            {
                var sortIndex = pndrStationList.GetIndexForAlphabet(currIndexChar , isBtPandora);// modified by yongkyun.lee 2014-06-03 for :  ITS 238641
                __LOG("StationInfo Received ,  Item idex is: " + sortIndex , LogSysID.LOW_LOG  );
                if(sortIndex !== -1)
                {                    
                    activeList.currentIndex = sortIndex
                    activeList.positionViewAtIndex(sortIndex,ListView.Beginning);
                    pndrStationList.ResetListReqType(ListReqType.EQUICKLIST)
                    reqIsOn = false
                    popupLoading.visible = false;
                    //UIListener.SetLoadingPopupVisibilty(popupLoading.visible);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
                }
            }
            else if(inReqType & ListReqType.ENEXTLIST)
            {
                pndrStationList.ResetListReqType(ListReqType.ENEXTLIST);
                if(pndrStationList.IsPendingRequest() > 0)
                    //popupLoading.visible = ((inReqType & ListReqType.EQUICKLIST))  || false;
                    reqIsOn = ((inReqType & ListReqType.EQUICKLIST))  || false;
                else
                    //popupLoading.visible = false;
                    reqIsOn = false

                //UIListener.SetLoadingPopupVisibilty(reqIsOn);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
            }
            else if(inReqType & ListReqType.EPREVLIST)
            {
                pndrStationList.ResetListReqType(ListReqType.EPREVLIST);
                if(pndrStationList.IsPendingRequest() > 0)
                    // popupLoading.visible = ((inReqType & ListReqType.EQUICKLIST))  || false;
                    reqIsOn = ((inReqType & ListReqType.EQUICKLIST))  || false;
                else
                    /*popupLoading.visible*/ reqIsOn = false;
                //UIListener.SetLoadingPopupVisibilty(reqIsOn);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
            }

            if(waitpopup.visible === true)
            {
                if(popupLoading.visible === false || reqIsOn == false )
                {
                    waitpopup.visible = false;
                }
            }
            pndrListView.focus_visible = true;
        }

        onStationArtReceived:
        {
            albumModel.set(inStationArtIndex,{"stationartpath" : inStationArtPath})
        }

        onStationDeleted:
        {
            albumModel.remove(inIndex)
        }

        onStationInserted:
        {
            albumModel.insert(inIndex,inStation)
        }
    }

    Connections
    {
        target: ( !popupVisible && pndrListView.visible) ? UIListener : null
        onMenuKeyPressed:
        {
            handleMenuKey(isJogMenuKey);
        }

        onTuneKeyDialed: //isForward
        {
            if(focus_visible === true)
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
                if(listModeAreaWidget.focus_visible){
                    listModeAreaWidget.hideFocus();
                    pndrListView.showFocus();
                }
                else if(optMenu.visible){
                    listModeAreaWidget.hideFocus();
                    pndrListView.showFocus();
                    optMenu.hideFocus(); //added by esjang 2013.08.10 for sanity 
                    optMenu.quickHide(); //added by esjang 2013.08.10 for sanity 
                    optMenu.visible = false
                }
            }
        }

        //modified by jyjeon 2014.01.20 for ITS 218714
        onTuneCenterPressed:
        {
            jogCenterPressed = true;
        }

        onTuneCenterReleased: //onTuneCenterPressed:
        {
            handleCenterKey();
            jogCenterPressed = false;
        }
        //modified by jyjeon 2014.01.20 for ITS 218714
    }
    Connections
    {
        target:UIListener

        onCallingState:
        {
            listModeAreaWidget.is_lockoutMode= incallingState; //modified by wonseok.heo for ITS 269343 2015.10.05
        }

        onTickerChanged:
        {
            pndrListView.scrollingTicker = inScrollingTicker;
        }

        //added by jyjeon 2014.01.14 for ITS 218723
        onHandleSkipEvent:{
            if(pressAndHoldTimer.running)
            {
                isJogUpLongPressed = false
                pressAndHoldTimer.stop();
            }
        }

        onHandleRewindEvent:{
            if(pressAndHoldTimer.running)
            {
                isJogUpLongPressed = false
                pressAndHoldTimer.stop();
            }
        }
        //added by jyjeon 2014.01.14 for ITS 218723
        
        //{ added by cheolhwan 2014-02-24. ITS 226700
        onSkipNextLongKeyPressed:
        {
            __LOG("onSkipNextLongKeyPressed" , LogSysID.LOW_LOG  );
           popup.showPopup(PopupIDPnd.POPUP_PANDORA_CANNOT_BE_MANIPULATED , false);
        }
        //} added by cheolhwan 2014-02-24. ITS 226700
    }

    // Note: this connection is usefull when any thing changed in ListMenuModel.
    // But as of now nothing is changed from qml in ListMenu.
    // So its not in use, we can ignore it if needed.
    Connections
    {
        target: pandoraMenus
        onMenuDataChanged:
        {
            optMenu.menumodel = pandoraMenus.optListMenuModel
        }
    }
    
    //{ added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
    ///*
    Connections{
        target: pndrTrack;
        onPlayStarted:
        {
            isPlaying = true;
        }

        onPauseDone:
        {
            isPlaying = false;
        }
    }
    //*/
    //} added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)

    /***************************************************************************/
    /**************************** Pandora Qt connections END ****************/
    /***************************************************************************/

    /***************************************************************************/
    /**************************** Pandora QML connections START ****************/
    /***************************************************************************/

    Component.onCompleted: {
        activeView = pndrListView;
        //        albumModel.clear();
        //        handleForegroundEvent();
        //{ modified by yongkyun.lee 2014-03-28 for : List update
        if(pndrListView.state =="")
            pndrListView.state = "SortByAlphabateState"
        //{ modified by yongkyun.lee 2014-03-28
        __LOG("onCompleted" , LogSysID.LOW_LOG );
    }

    onVisibleChanged:
    {
        if(EngineListener.isFrontLCD() && pndrListView.visible === false){
            hideOptionsMenu();
            optMenu.quickHide();            
        }
    }

    /***************************************************************************/
    /**************************** Pandora QML connections END ****************/
    /***************************************************************************/

    Component
    {
        id: sectionHeadingDelegate

        Image
        {
            height: 45

            source:PR_RES.const_APP_PANDORA_LIST_VIEW_ITEM_HEADING_BACKGROUND
            // anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 1

            /* Section Backgorund */
            Text
            {
                id:sectionHeadingtText
                anchors.left: parent.left
                anchors.leftMargin: PR.const_PANDORA_STATION_LIST_VIEW_SECTION_HEADING_TEXT_LEFTMARGIN
                anchors.verticalCenter: parent.verticalCenter
                width: PR.const_PANDORA_STATION_LIST_VIEW_SECTION_HEADING_TEXT_WIDTH

                text: section
                font.pointSize: PR.const_PANDORA_STATION_LIST_VIEW_SECTION_HEADING_TEXT_FONT_POINTSZIE
                font.family: PR.const_PANDORA_FONT_FAMILY_HDR
                
                color: PR.const_PANDORA_COLOR_TEXT_CURR_STATION //PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY  // modified by jyjeon 2014.02.03 for ITS 223503
            }
        }
    }


    Component
    {
        id: listItemDelegate

        Item
        {
            id:id_border
            visible:  !popupLoading.visible   //{ modified by yongkyun.lee 2014-02-07 for : ITS 223521
            height: PR.const_PANDORA_STATION_LIST_VIEW_ROW_HEIGHT_WITHBORDER
            width: PR.const_PANDORA_ALL_SCREEN_WIDTH - 14/*SCROLL_WIDTH*/ - 38/*QUICK_SCROLL_WIDTH*/ //modified by jyjeon 2014.01.10 for 218724

            //modified by jyjeon 2014.01.19 for ITS 218726
            Image {
                id: highligtItem
                x:PR.const_APP_PANDORA_LIST_VIEW_SECTION_HEADING_X
                source: PR_RES.const_APP_PANDORA_LIST_VIEW_ITEM_BORDER_IMAGE;
                width: alphabeticList.visible ? PR.const_APP_PANDORA_LISTITEM_WITH_QUICKSCROOL_HIGHLIGHT_WIDTH :
                PR.const_APP_PANDORA_LISTITEM_WITHOUT_QUICKSCROOL_HIGHLIGHT_WIDTH
                height: 96
                visible: focus_visible  && (activeList ? activeList.currentIndex == index : false) && (index > -1) && !popupVisible && !isSystemPopup  //modified by jyjeon 2014-03-21 for ITS 230186
                y: pressedImage.y -2
            }
            //modified by jyjeon 2014.01.19 for ITS 218726

            Image
            {
                id: pressedImage

                x:PR.const_APP_PANDORA_LIST_VIEW_SECTION_HEADING_X
                source: PR_RES.const_APP_PANDORA_LIST_VIEW_ITEM_BACKGROUND
                width: alphabeticList.visible ? PR.const_APP_PANDORA_LISTITEM_WITH_QUICKSCROOL_HIGHLIGHT_WIDTH :
                PR.const_APP_PANDORA_LISTITEM_WITHOUT_QUICKSCROOL_HIGHLIGHT_WIDTH
                height: 96
                anchors.left: parent.left
                anchors.leftMargin:  1
                visible: mouse_area.pressed || (jogCenterPressed && activeList.currentIndex === index)
            }

            //{ added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
            Item
            {
                id: icon_curr_playing
                height: stationMarked.height
                anchors.right: quickMixImage.left
                anchors.top: quickMixImage.top
                anchors.topMargin: PR.const_PANDORA_STATION_LIST_VIEW_CURRENTPLAYING_IMAGE_TOPMARGIN
                width: PR.const_PANDORA_STATION_LIST_VIEW_CURRENTPLAYING_IMAGE_WIDTH

                AnimatedImage
                {
                    id: stationMarked

                    source: "/app/share/images/video/icon_play.gif";
                    //{ modified by yongkyun.lee 2014-09-15 for : ITS 248463
                    playing: isPlaying ? true : false 
                    //playing: (isPlaying && (activeList ? !(activeList.flicking || activeList.moving ) : true)) ? true : false //added by jyjeon 2014-03-26 for ITS 231476
                    //} modified by yongkyun.lee 2014-09-15 
                    visible: (currPlayIndex == index)
                }
            }
            //} added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)

            //{ added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
            Image {
                id: station_bg
                width: PR.const_PANDORA_STATION_LIST_VIEW_BG_THUMBNAIL_IMAGE_SIZE
                height: PR.const_PANDORA_STATION_LIST_VIEW_BG_THUMBNAIL_IMAGE_SIZE
                source:  PR_RES.const_APP_PANDORA_LIST_VIEW_BG_STATION_LIST_IMG // modified by esjang for Default Image
                anchors.left: parent.left
                anchors.leftMargin: PR.const_PANDORA_STATION_LIST_VIEW_TRACK_IMAGE_LFET_MARGIN -1
                anchors.verticalCenter: parent.verticalCenter
                visible: index !== 0// modified by esjang 2013.05.03 for shuffle image
            }
            //} added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)

            Image{
                id: quickMixImage
                width: PR.const_PANDORA_STATION_LIST_VIEW_THUMBNAIL_IMAGE_SIZE
                height: PR.const_PANDORA_STATION_LIST_VIEW_THUMBNAIL_IMAGE_SIZE
                //TODO: The image should come in the List Model need to assign here
                source: ( (name.toLowerCase() === "Shuffle".toLowerCase()) ||  (name.toLowerCase() === "QuickMix".toLowerCase()) )
                        ? PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_QUICKMIX: stationartpath
                anchors.left: parent.left
                anchors.leftMargin: PR.const_PANDORA_STATION_LIST_VIEW_TRACK_IMAGE_LFET_MARGIN
                anchors.verticalCenter: parent.verticalCenter
                //modified by jyjeon 2014-03-28 for Galaxy Note2
                visible: stationartpath === PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_STATION_IMG
                         ? (( (name.toLowerCase() === "Shuffle".toLowerCase()) ||  (name.toLowerCase() === "QuickMix".toLowerCase()) ) ? true : false )
                          : true
                //modified by jyjeon 2014-03-28 for Galaxy Note2
                onStatusChanged: {
                    if(status === Image.Error)
                    {
                        source = PR_RES.const_APP_PANDORA_LIST_VIEW_BG_STATION_LIST_IMG//PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_STATION_IMG; // modified by esjang for Default Image
                    }
                }
            }

            DHAVN_MarqueeText
            {
                id: alphabetwise

                text: name
                scrollingTicker:activeList ? ( pndrListView.scrollingTicker && (pndrListView.focus_visible === true) &&
                                              index == activeList.currentIndex &&
                                              (UIListener.getStringWidth(albumModel.get(activeList.currentIndex).name , PR.const_PANDORA_FONT_FAMILY_HDR ,
                                                                         PR.const_PANDORA_STATION_LIST_VIEW_TRACKITEM_TEXT_FONT_POINTSZIE) > PR.const_PANDORA_STATION_LIST_VIEW_TRACKITEM_TEXT_WIDTH)):false
                //modified by jyjeon 2014.01.14 for ITS 218722
                color: (index == currPlayIndex)
                       ? (index == activeList.currentIndex && (focus_visible || mouse_area.pressed)) ? PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY: PR.const_PANDORA_COLOR_TEXT_CURR_STATION //modified by jyjeon 2014.02.03 for ITS 223467
                : (((index == activeList.currentIndex && focus_visible )|| (mouse_area.pressed )) ? PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY : PR.const_PANDORA_COLOR_COMMON_GREY ) //modified by wonseok.heo for ITS 239959
                //modified by jyjeon 2014.01.14 for ITS 218722
                anchors.verticalCenter: parent.verticalCenter

                fontSize: PR.const_PANDORA_STATION_LIST_VIEW_TRACKITEM_TEXT_FONT_POINTSZIE
                //{ added by cheolhwan 2014-03-22. ITS 230506.
                //fontFamily: PR.const_PANDORA_FONT_FAMILY_HDR
                fontFamily: (index == currPlayIndex)
                       ? (index == activeList.currentIndex && focus_visible) ? PR.const_PANDORA_FONT_FAMILY_HDB: PR.const_PANDORA_FONT_FAMILY_HDB
                : PR.const_PANDORA_FONT_FAMILY_HDR
                //{ added by cheolhwan 2014-03-22. ITS 230506.
                x: PR.const_PANDORA_STATION_LIST_VIEW_TRACKITEM_TEXT_X;
                width: PR.const_PANDORA_STATION_LIST_VIEW_TRACKITEM_TEXT_WIDTH;
            }

            // added by jyjeon 2013.12.09 for UX Update
            Image {
                id: icon_shared
                source: PR_RES.const_APP_PANDORA_TRACK_VIEW_SHARE_STATION //modified by wonseok.heo for shared icon 2015.05.07
                visible: shared
                anchors.top:  alphabetwise.top
                anchors.topMargin: PR.const_PANDORA_STATION_LIST_VIEW_SHARED_IMAGE_TOPMARGIN
                x: PR.const_PANDORA_STATION_LIST_VIEW_SHARED_IMAGE_X;
                width: PR.const_PANDORA_STATION_LIST_VIEW_SHARED_IMAGE_WIDTH
            }
            // added by jyjeon 2013.12.09 for UX Update

            Image
            {
                id:listline
                source:PR_RES.const_APP_PANDORA_LIST_VIEW_ITEM_LIST_LINE
                anchors.bottom: parent.bottom
            }

            MouseArea
            {
                id: mouse_area
                anchors.fill: parent
                beepEnabled: false

                //{ modified by yongkyun.lee 2014-03-07 for : ITS 228305
                onPressed:
                {
                    __LOG("Clicked on index: " , LogSysID.LOW_LOG );
                    swKeyPress = mouse_area.pressed;
                }

                onReleased:
                {
                    __LOG("Clicked on index: "  , LogSysID.LOW_LOG );
                    swKeyPress = mouse_area.pressed;
                }
                onCanceled:
                {
                    swKeyPress = mouse_area.pressed;
                }

                onExited:
                {

                    __LOG("Clicked on index: "  , LogSysID.LOW_LOG );
                    swKeyPress = mouse_area.pressed;
                }
                //} modified by yongkyun.lee 2014-03-07

                onClicked:
                {
                    __LOG("Clicked on index: " + index , LogSysID.LOW_LOG );
                    UIListener.ManualBeep();

                    if(UIListener.IsCalling()){
                        // modified by jyjeon 2014.01.06 for ITS 217984
                        //pndrNotifier.UpdateOSDOnCallingState();
                        popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE, false);
                        return;
                    }

                    if(index !== currPlayIndex)
                    {
                        handlestationSelectionEvent(index);
                    }
                    else
                    {
                        handleBackRequest(false);
                    }
                }
            }
        }
    }

    //removed by jyjeon 2014.01.19 for ITS 218726
    //    Component
    //    {
    //        id: highlighItem

    //        Image {
    //            id: highligtItem
    //            x:PR.const_APP_PANDORA_LIST_VIEW_SECTION_HEADING_X
    //            source: PR_RES.const_APP_PANDORA_LIST_VIEW_ITEM_BORDER_IMAGE;
    //            width: alphabeticList.visible ? PR.const_APP_PANDORA_LISTITEM_WITH_QUICKSCROOL_HIGHLIGHT_WIDTH :
    //                    PR.const_APP_PANDORA_LISTITEM_WITHOUT_QUICKSCROOL_HIGHLIGHT_WIDTH
    ////            height: alphabeticList.visible ? PR.const_APP_PANDORA_LISTITEM_WITH_QUICKSCROOL_HIGHLIGHT_HEIGHT :
    ////                    PR.const_APP_PANDORA_LISTITEM_WITHOUT_QUICKSCROOL_HIGHLIGHT_HEIGHT
    //            height: 96
    //            visible: focus_visible  /*&& (activeList.currentIndex == index)*/
    //            y: (activeList != null) ? (activeList.currentItem.y - 2 ) : 0

    //        }
    //    }
    //removed by jyjeon 2014.01.19 for ITS 218726

    ListModel
    {
        id: albumModel
        //{ modified by yongkyun.lee 2014-03-28 for : List update
        ListElement {
            name: ""
            letter: ""
            stationartpath: ""
            shared: false
        }
        //{ modified by yongkyun.lee 2014-03-28
    }

    OptionMenu{
        id: optMenu
        menumodel: pandoraMenus.optListMenuModel
        z: 1000
        //y: 0 - PR.const_PANDORA_ALL_SCREENS_TOP_OFFSET
        y: 0 // modified by esjang 2013.04.16 for hotfix menu position.
        visible: false;

        onBeep: UIListener.ManualBeep(); // added by esjang for ITS # 217173

        autoHiding: true
        autoHideInterval: 10000
        anchors.fill:parent
        enabled:true

        function showMenu()
        {
            //added by jyjeon 2014.01.14 for ITS 219783
            __LOG(  "[jyjeon] optMenu : isNoStationExists ==" +  isNoStationExists +", isNoActiveStation ==" + isNoActiveStation  , LogSysID.LOW_LOG );
            if( isNoStationExists || isNoActiveStation )
                pandoraMenus.optListMenuModel.itemEnabled(MenuItems.NowListening, false)
            else
                pandoraMenus.optListMenuModel.itemEnabled(MenuItems.NowListening, true)
            //added by jyjeon 2014.01.14 for ITS 219783

            optMenu.visible = true
            optMenu.show()
        } // added by Sergey 02.08.2103 for ITS#181512

        onIsHidden:
        {
            listModeAreaWidget.hideFocus();
            pndrListView.showFocus();
            if(activeList != null && activeList.currentIndex === -1)
            {
                activeList.currentIndex = 0
                activeList.positionViewAtIndex(0,ListView.Beginning);
            }
            optMenu.visible = false
        }

        onTextItemSelect:
        {
            __LOG(  "onTextItemSelect: "  +  itemId  , LogSysID.LOW_LOG );
            optMenu.disableMenu();
            handleMenuItemEvent(itemId);
        }
        onRadioBtnSelect:
        {
            __LOG(  "onRadioBtnSelect: "  +  itemId , LogSysID.LOW_LOG );
            if(itemId === MenuItems.Alphabet)
            {
                pandoraMenus.optListMenuModel.radioButtonSelected(0);
            }
            else
            {
                pandoraMenus.optListMenuModel.radioButtonSelected(1);
            }
            handleMenuItemEvent(itemId);
        }
    }

    ListView
    {
        id: alphaitemListView
        snapMode:moving ? ListView.SnapToItem : ListView.NoSnap
        delegate: listItemDelegate
        model: albumModel

        section.property: "letter"
        section.criteria: ViewSection.FirstCharacter
        section.delegate: sectionHeadingDelegate
        maximumFlickVelocity: 10000 //added by jyjeon 2014-03-06 for list move speed

        anchors.fill: parent
        anchors.topMargin:listModeAreaWidget.height 
        anchors.left: parent.left

        //highlight:highlighItem //removed by jyjeon 2014.01.19 for ITS 218726
        highlightMoveDuration: 1
        //highlightFollowsCurrentItem: false //removed by jyjeon 2014.01.19 for ITS 218726
        interactive : !popupLoading.visible
        currentIndex : -1

        clip: true
        focus: true
        smooth: true //added by jyjeon 2014-03-06 for list move speed

        // boundsBehavior: ListView.StopAtBounds

        property int mouseStarty: -1
        property int mouseEndy: -1
        property int direction: PR.const_LIST_VIEW_MOVING_NONE

        onMovementStarted:{
            mouseStarty = contentY;
            __LOG(" Position mouseStarty :  " + mouseStarty , LogSysID.LOW_LOG )
        }

        onContentYChanged:{
            mouseEndy = contentY
            __LOG(" onContentYChanged: Position mouseEndy[" + mouseEndy + "]  mouseStarty[" + mouseStarty + "]" , LogSysID.LOW_LOG )

            if(mouseEndy - (mouseStarty) > 80)
            {
                direction = PR.const_LIST_VIEW_MOVING_UP
                fetchList();
            }
            else if(mouseEndy - (mouseStarty) < -80)
            {
                direction = PR.const_LIST_VIEW_MOVING_DOWN
                fetchList();
            }
            else
            {
                direction = PR.const_LIST_VIEW_MOVING_NONE
            }
        }
        function fetchList()
        {
            if(popupLoading.visible || reqIsOn)
            {
                __LOG("List fetching in progress, so return " , LogSysID.LOW_LOG );
                return;
            }

            if(alphaitemListView.direction === PR.const_LIST_VIEW_MOVING_DOWN)
            {
                if( pndrStationList.IsPrevItemExist())
                {
                    __LOG("Moving down so prev list" , LogSysID.LOW_LOG );
                    //                    popupLoading.visible = true;
                    reqIsOn = true;
                    //UIListener.SetLoadingPopupVisibilty(/*popupLoading.visible*/ true);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
                    pndrStationList.GetNextStationList(ListReqType.EPREVLIST);
                }
            }
            else if(alphaitemListView.direction === PR.const_LIST_VIEW_MOVING_UP)
            {
                if(pndrStationList.IsNextItemExist())
                {
                    __LOG("Moving up so next list" , LogSysID.LOW_LOG );
                    // popupLoading.visible = true;
                    reqIsOn = true;
                    //UIListener.SetLoadingPopupVisibilty(/*popupLoading.visible*/ true); //{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
                    pndrStationList.GetNextStationList(ListReqType.ENEXTLIST);
                }
            }
        }

        function showLastItem()
        {
            // Work around to show at exact position .
            if(alphalistbar.visible){
                currentIndex = albumModel.count -2;
                positionViewAtIndex(currentIndex, ListView.Center) //modified by jyjeon 2014-03-13 for ITS 229041
                currentIndex = albumModel.count -1
                positionViewAtIndex(currentIndex, ListView.End)
            }
        }

        function showFirstItem()
        {
            if(alphalistbar.visible){
                currentIndex = 0
                alphaitemListView.positionViewAtIndex(0,ListView.Beginning);
                //currentIndex = 0;
            }
        }

        onMovementEnded: {
            __LOG("onMovementEnded: movement ended[" + alphaitemListView.direction + "]  alphaitemListView.focus_visible[" + focus_visible + "]" , LogSysID.LOW_LOG )
            //{ added by cheolhwan 2014-1-3. for ITS 217703.
            if(listModeAreaWidget.focus_visible === true && optMenu.visible === false)
            {
                listModeAreaWidget.hideFocus();
                pndrListView.showFocus();
            }
            //} added by cheolhwan 2014-1-3. for ITS 217703.
            
            if(currentItem != null /* && focus_visible //deleted by cheolhwan 2014-1-3 for ITS 217409. */)
            {
                //__LOG("esjang 131022 1 mouseStarty: " + mouseStarty + " mouseEndy: " + mouseEndy , LogSysID.LOW_LOG ); //added by esjang 2013.10.22 for test list view issue.
                var topIndex  = indexAt(10 , contentY + currentItem.height/2 + 10 )
                var focusIndex = currentItem.y - 2

                //added by jyjeon 2014.02.012 for ITS 224126
                if(topIndex == -1){
                    topIndex  = indexAt(10 , contentY + currentItem.height/2 + 10 + 45/*Alphabet height*/)
                }
                //added by jyjeon 2014.02.012 for ITS 224126
                
                //__LOG("esjang 131022 current index: " + currentIndex + " topIndex : " + topIndex , LogSysID.LOW_LOG );// added by esjang 2013.10.22 for test 
                __LOG("focusIndex : " + focusIndex + " contentY : " + contentY  , LogSysID.LOW_LOG ); //added by esjang 2013.10.22 
                if(topIndex >= 0 &&  topIndex < albumModel.count && ( ( (focusIndex - contentY)< 0 )||( (focusIndex - contentY - 461) > 0 )  ) ) // modified by esjang 2014.01.11
                {
                    __LOG("index will be changed from : " + currentIndex + " to : " + topIndex , LogSysID.LOW_LOG );
                    currentIndex = topIndex
                }
                else
                {
                    __LOG("index will not be changed! currentIndex: " + currentIndex + " contentY : " + contentY  , LogSysID.LOW_LOG ); //added by esjang for test
                }
            }

            fetchList();
        }
        //{ addeed by esjang 2013.05.21 for ux issues
        VerticalScrollBar  
        {
            id: alphalistbar
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 34
            anchors.rightMargin: 8
            height: 465
            position: parent.visibleArea.yPosition
            pageSize: parent.visibleArea.heightRatio
            visible: ( pageSize < 1 )
        }  
        //} addeed by esjang 2013.05.21 for ux issues

    }

    ListView
    {
        id: dateitemListView
        snapMode:moving ? ListView.SnapToItem : ListView.NoSnap
        delegate: listItemDelegate
        model: albumModel
        anchors.fill: parent
        anchors.topMargin:listModeAreaWidget.height
        anchors.left: parent.left

        //highlight:highlighItem //removed by jyjeon 2014.01.19 for ITS 218726
        highlightMoveDuration: 1
        //highlightFollowsCurrentItem: false //removed by jyjeon 2014.01.19 for ITS 218726
        interactive : !popupLoading.visible
        currentIndex : -1

        clip: true
        focus: true
        //smooth: true

        // boundsBehavior: ListView.StopAtBounds

        property int mouseStarty: -1
        property int mouseEndy: -1
        property int direction: PR.const_LIST_VIEW_MOVING_NONE

        onMovementStarted:{
            mouseStarty = contentY;
            __LOG(" Position mouseStarty :  " + mouseStarty , LogSysID.LOW_LOG )
        }

        onContentYChanged:{
            mouseEndy = contentY
            __LOG("onContentYChanged: Position mouseEndy :  " + mouseEndy , LogSysID.LOW_LOG )
            
            if(mouseEndy - (mouseStarty) > 80)
            {
                direction = PR.const_LIST_VIEW_MOVING_UP
                fetchList();
            }
            else if(mouseEndy - (mouseStarty) < -80)
            {
                direction = PR.const_LIST_VIEW_MOVING_DOWN
                fetchList();
            }
            else
            {
                direction = PR.const_LIST_VIEW_MOVING_NONE
            }
        }
        function fetchList()
        {
            if(popupLoading.visible || reqIsOn)
            {
                __LOG("List fetching in progress, so return " , LogSysID.LOW_LOG );
                return;
            }

            if(dateitemListView.direction === PR.const_LIST_VIEW_MOVING_DOWN)
            {
                if( pndrStationList.IsPrevItemExist())
                {
                    __LOG("Moving down so prev list" , LogSysID.LOW_LOG );
                    //                    popupLoading.visible = true;
                    reqIsOn = true;
                    //UIListener.SetLoadingPopupVisibilty(/*popupLoading.visible*/ true);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
                    pndrStationList.GetNextStationList(ListReqType.EPREVLIST);
                }
            }
            else if(dateitemListView.direction === PR.const_LIST_VIEW_MOVING_UP)
            {
                if(pndrStationList.IsNextItemExist())
                {
                    __LOG("Moving up so next list" , LogSysID.LOW_LOG );
                    // popupLoading.visible = true;
                    reqIsOn = true;
                    //UIListener.SetLoadingPopupVisibilty(/*popupLoading.visible*/ true); //{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
                    pndrStationList.GetNextStationList(ListReqType.ENEXTLIST);
                }
            }
        }

        function showLastItem()
        {
            // Work around to show at exact position .
            if(datelistbar.visible){
                currentIndex = albumModel.count -2;
                currentIndex++;
                positionViewAtIndex(currentIndex, ListView.End)
            }
        }

        function showFirstItem()
        {
            if(datelistbar.visible){
                currentIndex = 0
                dateitemListView.positionViewAtIndex(0,ListView.Beginning);
            }
        }

        onMovementEnded: {
            //{ added by cheolhwan 2014-1-3. for ITS 217703.
            if(listModeAreaWidget.focus_visible === true && optMenu.visible === false)
            {
                listModeAreaWidget.hideFocus();
                pndrListView.showFocus();
            }
            //} added by cheolhwan 2014-1-3. for ITS 217703.
            
            if(currentItem != null /* && focus_visible //deleted by cheolhwan 2014-1-3 for ITS 217409. */){
                var topIndex  = indexAt(10 , contentY + currentItem.height/2 + 10)
                if(topIndex >= 0 &&  topIndex < albumModel.count){
                    //__LOG("esjang 131022 topIndex : " + topIndex + " current Index: " + currentIndex , LogSysID.LOW_LOG );
                    if(topIndex > currentIndex || topIndex <=currentIndex -6)  //added by esjang 2014.01.11 for ITS # 218693
                        currentIndex = topIndex
                }
            }

            fetchList();
        }
        //{ addeed by esjang 2013.05.21 for ux issues
        VerticalScrollBar
        {
            id: datelistbar
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 34
            anchors.rightMargin: 8
            height: 465
            position: parent.visibleArea.yPosition
            pageSize: parent.visibleArea.heightRatio
            visible: ( pageSize < 1 )
        }
        //} addeed by esjang 2013.05.21 for ux issues
    }

    // define various states and its effect
    states: [
        State
        {
            name: "SortByAlphabateState"
            PropertyChanges { target:alphabeticList; visible: true}
            PropertyChanges { target:alphaitemListView;  visible:true}
            PropertyChanges { target:dateitemListView;  visible:false}
            PropertyChanges { target:pndrListView;  activeList:alphaitemListView}
            PropertyChanges { target:alphaitemListView;  currentIndex: -1}

        },

        State
        {
            name: "SortByDateState"
            PropertyChanges { target:alphabeticList; visible: false}
            PropertyChanges { target:alphaitemListView;  visible:false}
            PropertyChanges { target:dateitemListView;  visible:true}
            PropertyChanges { target:pndrListView;  activeList:dateitemListView}
            PropertyChanges { target:dateitemListView;  currentIndex: -1}
        }
    ]

    /***************************************************************************/
    /**************************** Private functions START **********************/
    /***************************************************************************/

    function __LOG( textLog , level)
    {
       logString = "ListView.qml::" + textLog ;
       logUtil.log(logString , level);
    }

    // TODO check if this way of capturing slot for another qml is fine.
    function onScrollTo(index)
    {
        // logic for scrolling
    }

    // handles foreground event
    function handleForegroundEvent()
    {
        pndrListView.visible = visibleStatus;
        albumModel.clear();
        __LOG("for audit isInsufficientLIST : " + isInsufficientLIST , LogSysID.LOW_LOG );
        if(!isInsufficientLIST)// added by esjang 2013.11.08 for audit issue
            popupLoading.visible = true;
        //UIListener.SetLoadingPopupVisibilty(popupLoading.visible); //{ modified by yongkyun.lee 2014-03-07 for : ITS 228615

        __LOG("in HandleForeGroundEvent" , LogSysID.LOW_LOG );
        pndrStationList.FetchStationArt();

        if(!reqTimer.running)reqTimer.start()
        //pndrStationList.GetFirstStationListSlot(10,currentActiveStationToken);
    }
    //{ added by esjang 2013.11.08 for audit issue
    function handleLoadingPopup(isInsufficient)
    {
        isInsufficientLIST = isInsufficient;
    }
    //} added by esjang 2013.11.08 for audit issue

    // handle retranlateUI event
    function handleRetranslateUI(languageId)
    {
        LocTrigger.retrigger()
        listModeAreaWidget.retranslateUI(PR.const_PANDORA_LANGCONTEXT);
    }

    function hideFocus()
    {
        focus_visible = false
    }

    function showFocus()
    {
        focus_visible = true;
    }
    function showWaitNote()
    {
        __LOG("showWaitNote-Start" , LogSysID.LOW_LOG );
        pndrListView.focus_visible = false;
        alphabeticList.visible = false;
        activeList.visible = false;
        popupLoading.visible = true;
        //UIListener.SetLoadingPopupVisibilty(popupLoading.visible);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
    }

    function isJogListenState()
    {
        var ret = true;

        if(waitIndicator.visible || optMenu.visible || waitpopup.visible ||
                isInsufficientLIST || /*{ modified by yongkyun.lee 2014-03-11 for :  ITS 228237 */
                popupLoading.visible || listModeAreaModel.focus_visible || reqIsOn)
        {
            ret = false;
        }
        return ret;
    }

    function handleJogKey( arrow, status )
    {
        __LOG("handlejogkey -> arrow : " + arrow + " , status : "+status , LogSysID.LOW_LOG );
        if(status == UIListenerEnum.KEY_STATUS_PRESSED 
                || status == UIListenerEnum.KEY_STATUS_PRESSED_CRITICAL )
        {
            switch(arrow)
            {

            case UIListenerEnum.JOG_CENTER:
                if(focus_visible)
                    jogCenterPressed = true;
                break;
                //added by esjang 2013.08.16 for ITS #182990
            case UIListenerEnum.JOG_DOWN: //It should not come here
                //__LOG("esjang 0815 jog down pressed" , LogSysID.LOW_LOG );
                break;
            case UIListenerEnum.JOG_UP:
                //__LOG("esjang 0815 jog up pressed" , LogSysID.LOW_LOG );
                isJogUpLongPressed = false;
                break;
            default:
                break;
            }
        }
        else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
        {
            switch(arrow)
            {
            case UIListenerEnum.JOG_WHEEL_RIGHT:
                if(focus_visible)
                    focusNext();
                break;
            case UIListenerEnum.JOG_WHEEL_LEFT:
                if(focus_visible)
                    focusPrev();
                break;
            case UIListenerEnum.JOG_CENTER:
                //jogCenterPressed = false;
                if(focus_visible)
                {
                    handleCenterKey();
                }
                jogCenterPressed = false; //modified by jyjeon 2014.01.20 for ITS 218714
                break;
            case UIListenerEnum.JOG_UP:
                //added by esjang 2013.08.16 for ITS #182990
                if(isJogUpLongPressed)
                {
                    pressAndHoldTimer.stop();
                }
                else
                {
                    pndrListView.hideFocus();
                    listModeAreaWidget.showFocus();
                    listModeAreaWidget.setDefaultFocus(arrow);
                }
                break;
            case UIListenerEnum.JOG_DOWN: //It should not come here
                //__LOG ("esjang 0815 releaed" , LogSysID.LOW_LOG );
                //added by esjang 2013.08.16 for ITS #182990
                pressAndHoldTimer.stop();

                break;
            }
        }
        //{ added by esjang 2013.08.16 for ITS #182990
        else if (status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
            // || status == UIListenerEnum.KEY_STATUS_PRESSED_CRITICAL
            // || status == UIListenerEnum.KEY_STATUS_CANCEL )
        {
            switch(arrow)
            {
            case UIListenerEnum.JOG_DOWN:
            case UIListenerEnum.JOG_UP:
                if(arrow == UIListenerEnum.JOG_UP)
                {
                    __LOG("pressed long" , LogSysID.LOW_LOG )
                    isJogUpLongPressed = true;
                }
                if(status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
                {
                    __LOG("pressed long" , LogSysID.LOW_LOG )

                    focusIsDown = false;

                    if(arrow == UIListenerEnum.JOG_DOWN)
                    {
                        focusIsDown = true;
                    }

                    if(focus_visible)
                    {
                        __LOG("timer start" , LogSysID.LOW_LOG );
                        pressAndHoldTimer.start();
                    }
                }
                break;
            }
        }
        else if (status == UIListenerEnum.KEY_STATUS_CANCELED)
        {
            if(pressAndHoldTimer.running)
            {
                isJogUpLongPressed = false
                pressAndHoldTimer.stop();
            }

            //added by jyjeon 2014.01.20 for ITS 218714
            if(jogCenterPressed)
            {
                jogCenterPressed = false;
            }
            //added by jyjeon 2014.01.20 for ITS 218714
        }
    }
    //} added by esjang 2013.08.16 for ITS #182990

    function focusNext( /*arrow*/ )
    {

        if(activeList.flicking || activeList.moving) return; //added by esjang 2013.10.29 for CCP dial and bouncing issue        

        //added by jyjeon 2014.01.20 for ITS 218714
        if(jogCenterPressed)
            handleJogKey(UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_CANCELED);
        //added by jyjeon 2014.01.20 for ITS 218714

        //{ modified by yongkyun.lee 2014-03-14 for :  ITS 229248
        if(UIListener.IsCalling()){
            popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE, false);
            return;
        }
        //} modified by yongkyun.lee 2014-03-14 


        var index = activeList.currentIndex;
        if((index + 1) < albumModel.count){
            if(albumModel.get(index + 1).name.length > 0)
            {
                //modified by jyjeon 2014.01.24 for ITS 222064
                if (index == activeList.indexAt(activeList.width / 2, activeList.contentY + activeList.height - activeList.currentItem.height/2 - 10))
                    activeList.positionViewAtIndex(index == activeList.count - 1 ? 0 : index + 1, ListView.Beginning)
                //modified by jyjeon 2014.01.24 for ITS 222064
                activeList.incrementCurrentIndex();
            }
            else{
                //                popupLoading.visible = true;
                reqIsOn = true ;
                //UIListener.SetLoadingPopupVisibilty(/*popupLoading.visible*/ reqIsOn);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
                pndrStationList.GetNextStationList(ListReqType.ENEXTLIST);
            }
        }
        else{
            if(pndrStationList.GetTotalStationsCount() === albumModel.count)
                if(albumModel.get(0).name.length > 0)
                    activeList.showFirstItem();// activeList.currentIndex = 0;
        }
    }

    function focusPrev( /*arrow*/ )
    {
        //added by jyjeon 2014.01.20 for ITS 218714        
        if(jogCenterPressed)
            handleJogKey(UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_CANCELED);
        //added by jyjeon 2014.01.20 for ITS 218714

        if(activeList.flicking || activeList.moving) return; //added by esjang 2013.10.29 for CCP dial and bouncing issue        

        //{ modified by yongkyun.lee 2014-03-14 for :  ITS 229248
        if(UIListener.IsCalling()){
            popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE, false);
            return;
        }
        //} modified by yongkyun.lee 2014-03-14 
        
        var index = activeList.currentIndex;
        if( (index - 1) >= 0)
        {
            if( albumModel.get(index - 1).name.length <= 0){
                //                popupLoading.visible = true;
                reqIsOn = true ;
                //UIListener.SetLoadingPopupVisibilty(/*popupLoading.visible*/reqIsOn);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
                pndrStationList.GetNextStationList(ListReqType.EPREVLIST);
            }
            else
            {
                //modified by jyjeon 2014.01.24 for ITS 222064	    
                if (index == activeList.indexAt(width / 2, activeList.contentY + activeList.currentItem.height/2 + 10))
                    activeList.positionViewAtIndex(index == 0 ? activeList.count - 1 : index - 1, ListView.End)
                //modified by jyjeon 2014.01.24 for ITS 222064
                activeList.decrementCurrentIndex();
            }
        }
        else
        {
            //if( albumModel.get(albumModel.count - 1).name.length > 0)
            if(albumModel.count - 1 > 0) //modified by jyjeon 2014-03-05 for ITS 227479
            {
                //activeList.currentIndex = albumModel.count - 1 ;
                activeList.showLastItem();
            }
        }
    }

    function handleCenterKey()
    {
        if(UIListener.IsCalling()){
            // modified by jyjeon 2014.01.06 for ITS 217984
            //pndrNotifier.UpdateOSDOnCallingState();
            popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE , false);
            return;
        }

        if(!jogCenterPressed) return;  //added by jyjeon 2014.01.20 for ITS 218714

        var index = activeList.currentIndex;
        if(index >= 0 && index < activeList.count){
            //popupLoading.visible = true;//{ modified by yongkyun.lee 2014-03-12 for : ITS 229113
            //UIListener.SetLoadingPopupVisibilty(popupLoading.visible);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
            if(index == currPlayIndex)
                handleBackRequest(true);
            else
                handlestationSelectionEvent(index);
        }
    }

    function handleMenuItemEvent(menuItemId)
    {
        pndrListView.hideMenu = true;
        switch(parseInt(menuItemId))
        {
        case MenuItems.NowListening: // "Now Listening"
        {
            pndrListView.handleBackRequest(true); //modified by esjang 2013.06.21 for Touch BackKey
            break;
        }

        case MenuItems.Alphabet: // Sort by
        {
            __LOG("get station list sortbyalpha" , LogSysID.LOW_LOG );
            if(state!== "SortByAlphabateState")
            {
                //activeList = null
                activeList.visible = false;
                showWaitNote();
                albumModel.clear();
                currPlayIndex = -1;
                pndrStationList.GetSortedStationList(SortType.SORT_BY_ALPHA, currentActiveStationToken);
            }
            break;
        }
        case MenuItems.Date:
        {
            __LOG("get station list sortbydate" , LogSysID.LOW_LOG );
            if(state !== "SortByDateState")
            {
                //activeList = null
                activeList.visible = false;
                showWaitNote();
                albumModel.clear();
                reqIsOn = false ;
                currPlayIndex = -1;
                pndrStationList.GetSortedStationList(SortType.SORT_BY_DATE, currentActiveStationToken);
            }
            break;
        }

        case MenuItems.Search: // Search
        {
            pndrListView.handleSearchViewEvent();
            break;
        }
        case MenuItems.SoundSetting: // Sound Setting
        {
            //pndrListView.hideMenu = false; //removed by jyjeon 2014.01.09 for ITS 218629
            UIListener.LaunchSoundSetting();
            break;
        }
        default:
        {
            __LOG("MyLog: No menu item matched" , LogSysID.LOW_LOG );
            break;
        }
        }
        if(pndrListView.hideMenu === true){
            optMenu.visible = !pndrListView.hideMenu;
            optMenu.hideFocus();
            optMenu.quickHide(); //added by esjang 2013.08.10 for Sanity
            optMenu.visible = false; //added by esjang 2013.08.10 for Sanity
        }
        pndrListView.hideMenu = true;
    }

    function hideOptionsMenu()
    {
        optMenu.hideFocus();
    }

    function hideSubMenu()
    {
        optMenu.backLevel();
    }

    function trim(str)
    {
        for(var l = 0; l < str.length;)
        {
            if(str[l] === ' ' || str[l] === '\t')
                l++;
            else
                break;
        }
        return str.substring(l, str.length);
    }

    function manageFocusOnPopUp(status)
    {
        __LOG(" manageFocusOnPopUp(status) -> " + status , LogSysID.LOW_LOG );

        if(status)
        {
            optMenu.hideFocus();
            //            optMenu.visible = false;
            optMenu.quickHide()
            listModeAreaWidget.hideFocus();
            pndrListView.hideFocus();
            isSystemPopup = true//{ modified by yongkyun.lee 2014-03-21 for : ITS 229140
        }
        else
        {
            isSystemPopup = false//{ modified by yongkyun.lee 2014-03-21 for : ITS 229140
            pndrListView.showFocus();
        }
    }

    /***************************************************************************/
    /**************************** Private functions END **********************/
    /***************************************************************************/

    DHAVN_PandoraAlphaListMenu
    {
        id: alphabeticList
        anchors.top: parent.top
        anchors.topMargin:PR.const_PANDORA_ALPHABETIC_MENU_TOP_MARGIN
        anchors.left: parent.left
        anchors.leftMargin: PR.const_PANDORA_ALPHABETIC_MENU_LEFT_MARGIN
        visible: false
        icon_search_left_margin: PR.const_PANDORA_ALPHABETIC_USB_ICON_SEARCH_LEFT_MARGIN
        icon_index_left_margin: PR.const_PANDORA_ALPHABETIC_USB_ICON_INDEX_LEFT_MARGIN
        item_width: PR.const_PANDORA_ALPHABETIC_USB_ITEM_WIDTH
        item_height_top_part:PR.const_PANDORA_ALPHABETIC_USB_ITEM_HEIGHT_TOP_PART
        item_height_bottom_part: PR.const_PANDORA_ALPHABETIC_USB_ITEM_HEIGHT_BOTTOM_PART

        MouseArea
        {
            id: mouseArea
            anchors.fill: parent
            beepEnabled: false
            enabled : !popupLoading.visible
            onPressed:
            {
                //handleQuickScrollEvent(alphabeticList.listInner.indexAt(mouseX,mouseY), UIListenerEnum.KEY_STATUS_PRESSED)
                handleQuickScrollEvent(alphabeticList.hiddenListInner.indexAt(15,mouseY), UIListenerEnum.KEY_STATUS_PRESSED) // modified by esjang for ITS # 223522
            }
            onClicked:
            {
                UIListener.ManualBeep();
            }            
            
            onPositionChanged:
            {
                //handleQuickScrollEvent(alphabeticList.listInner.indexAt(mouseX,mouseY), UIListenerEnum.KEY_STATUS_PRESSED)
                handleQuickScrollEvent(alphabeticList.hiddenListInner.indexAt(15,mouseY), UIListenerEnum.KEY_STATUS_PRESSED) // modified by esjang for ITS # 223522
            }
            onReleased:
            {
                //handleQuickScrollEvent(alphabeticList.listInner.indexAt(mouseX,mouseY), UIListenerEnum.KEY_STATUS_RELEASED)
                handleQuickScrollEvent(alphabeticList.hiddenListInner.indexAt(15,mouseY), UIListenerEnum.KEY_STATUS_RELEASED) // modified by esjang for ITS # 223522
            }

        }
    }

    function handleQuickScrollEvent(popupIndex, status)
    {
        //if(popupIndex > -1 && popupIndex < alphabeticList.listInner.count)
        if(popupIndex > -1 && popupIndex < alphabeticList.hiddenListInner.count) // added by esjang 2014.02.07 for ITS # 223522
        {
            var indexChar = alphabeticList.hiddenListTextInner.get(popupIndex).letter // modified by esjang for ITS # 223522
            if(status == UIListenerEnum.KEY_STATUS_PRESSED)
            {
                //{ added by esjang for ITS # 223522
                if(indexChar == '#' || indexChar == 'A' ||indexChar == 'D' ||indexChar == 'G' ||indexChar == 'J' 
                        || indexChar == 'M' || indexChar == 'P' || indexChar == 'S' || indexChar == 'V' ) //} added by esjang for ITS # 223522
                    quickPopup(indexChar)
                //{ added by esjang 2014.01.11 for ITS # 219050
                if(popupLoading.visible === true ){
                    return ;
                }
                var sortIndex = pndrStationList.GetIndexForAlphabet(indexChar , isBtPandora );// modified by yongkyun.lee 2014-06-03 for :  ITS 238641
                if(sortIndex >= 0  && sortIndex < albumModel.count && albumModel.get(sortIndex).name.length > 0)
                {

                    activeList.positionViewAtIndex(sortIndex,ListView.Beginning);
                    activeList.currentIndex = sortIndex ;
                }
                //} added by esjang 2014.01.11 for ITS # 219050
            }
            else if (status == UIListenerEnum.KEY_STATUS_RELEASED)
            {
                //{ added by esjang for ITS # 223522
                if(indexChar == '#' || indexChar == 'A' ||indexChar == 'D' ||indexChar == 'G' ||indexChar == 'J' 
                        || indexChar == 'M' || indexChar == 'P' || indexChar == 'S' || indexChar == 'V' ) //} added by esjang for ITS # 223522
                    quickPopup(indexChar)
                if(popupLoading.visible === true ){
                    return ;
                }
                currIndexChar = indexChar;
                popupLoading.visible = true;
                //UIListener.SetLoadingPopupVisibilty(popupLoading.visible);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
                var sortIndex = pndrStationList.GetIndexForAlphabet(indexChar , isBtPandora);// modified by yongkyun.lee 2014-06-03 for :  ITS 238641
                if(sortIndex >= 0  && sortIndex < albumModel.count && albumModel.get(sortIndex).name.length > 0)
                {
                    popupLoading.visible = false;
                    //UIListener.SetLoadingPopupVisibilty(false);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
                    activeList.positionViewAtIndex(sortIndex,ListView.Beginning);
                    activeList.currentIndex = sortIndex ;
                    //activeList.positionViewAtIndex(currentIndex, ListView.Beginning)
                }
            }
        }
    }

    function quickPopup(text)
    {
        popupQuickScroll.visible = true;
        textid.text = text;
        quicktim.restart();
    }
    Image{
        id: popupQuickScroll
	//{ modified by yongkyun.lee 2014-03-21 for : ITS 230348
        anchors.centerIn: pndrListView
            
        source: PR_RES.const_APP_PANDORA_LIST_VIEW_POPUP_QUICKSCROLL_BG
        //{ modified by wonseok.heo 2014.06.02 for ITS 239001
        x:0
        y:0
        width:203
        height:149
        //opacity: 1.0
        visible : false;

        // property string popupQuickScrollText: "A" //TODO: This should be assigned by the letter on quickscroll alphabets
        Text{
            id : textid
            //text: popupQuickScroll.popupQuickScrollText
            x:17
            y:25
            width:170
            height:100
            //anchors.centerIn: popupQuickScroll
            font.pointSize: PR.const_PANDORA_POPUP_QUICKSCROLL_TEXT_FONT_POINTSIZE
            font.family: PR.const_PANDORA_FONT_FAMILY_HDB
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: PR.const_PANDORA_COLOR_SUB_TEXT_GREY
            style: Text.Outline;
            styleColor: PR.const_PANDORA_COLOR_SUB_TEXT_GREY
        }
	//} modified by yongkyun.lee 2014-03-21 for : ITS 230348

        //        Behavior on popupQuickScrollText{
        //            SequentialAnimation{
        //                NumberAnimation{target:popupQuickScroll; property: "opacity"; to: 1.0; duration: 500}
        //                NumberAnimation{target:popupQuickScroll; property: "opacity"; to: 0.0; duration: 1500}
        //            }
        //        }
    }
    Timer
    {
        id : quicktim
        interval: 1000; running: false; repeat: false
        onTriggered: popupQuickScroll.visible = false;
    }
    Rectangle{
        height: listModeAreaWidget.height
        width: PR.const_PANDORA_ALL_SCREEN_WIDTH
        color: PR.const_PANDORA_COLOR_BLACK

    }

    //  MODE AREA
    QmlModeAreaWidget
    {
        id: listModeAreaWidget
        bAutoBeep: false
        modeAreaModel: listModeAreaModel
        search_visible: false
        parent: pndrListView
        anchors.top: parent.top
        onBeep: UIListener.ManualBeep(); // added by esjang for ITS # 217173  //deleted by cheolhwan 2014-01-09. ITS 218630.

        onModeArea_BackBtn:
        {
            __LOG("onModeArea_BackBtn" , LogSysID.LOW_LOG );
            //pndrListView.handleBackRequest();
            pndrListView.handleBackRequest(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
        }

        onModeArea_MenuBtn:
        {
            __LOG ("onModeArea_MenuBtn" , LogSysID.LOW_LOG );
            handleMenuKey();
        }

        onLostFocus:
        {
            switch(arrow)
            {
            case UIListenerEnum.JOG_DOWN:
            {
                __LOG ("QmlModeAreaWidget: onLostFocus " , LogSysID.LOW_LOG );
                listModeAreaWidget.hideFocus();
                pndrListView.showFocus();
                break;
            }
            }
        }

        ListModel
        {
            id: listModeAreaModel
            property string text: QT_TR_NOOP("STR_PANDORA_STATIONLIST")

            property string mb_text: QT_TR_NOOP("STR_PANDORA_MENU");
            property bool mb_visible: true;
        }
    }

    DHAVN_PandoraWaitView{
        id: waitIndicator
        visible: false
        onVisibleChanged: {
            if(!visible)
            {
                waitpopup.visible = visible;
            }
        }
    }
    POPUPWIDGET.PopUpText
    {
        id: waitpopup;
        z: 1
        y: 0
        visible: false;
        message: errorModel
        function showPopup(text)
        {
            if(!visible)
            {
                if(UIListener.IsSystemPopupVisible()) // added by esjang 2013.08.07 for ITS # 182095
                {
                    UIListener.CloseSystemPopup();
                }
                errorModel.set(0,{msg:text})
                visible = true;
                timeOutTimer.start();
            }
        }
    }
    Timer{
        id: timeOutTimer
        running: false
        repeat: false
        interval: 3000
        onTriggered:{
            waitpopup.visible = false;
        }
    }
    // added by esjang 2013.08.16 for ITS #182990
    Timer{
        id: pressAndHoldTimer
        running: false
        repeat: true
        interval: 100
        onTriggered:{
            //console.log("esjang 0815 presseAndHoldTimer  focusIsDown:" + focusIsDown);
            var index = activeList.currentIndex; // modified by esjang 2013.08.26 for ITS #186180
            if(focusIsDown)
            {
                if((index + 1) < albumModel.count) // modified by esjang 2013.08.26 for ITS #186180
                    focusNext();
            }
            else
            {
                if( (index - 1) >= 0) // modified by esjang 2013.08.26 for ITS #186180
                    focusPrev();
            }
        }
    }
    // added by esjang 2013.08.16 for ITS #182990

    ListModel
    {
        id: errorModel
        ListElement
        {
            msg: ""
        }
    }

    DHAVN_ToastPopup
    {
        id:popupLoading
        visible:false;

        onVisibleChanged:
        {
            UIListener.SetLoadingPopupVisibilty(visible);//{ modified by yongkyun.lee 2014-03-07 for : ITS 228615
            if(visible === true && (!isInsufficientLIST)){ //added by esjang
                __LOG("for list view loading" , LogSysID.LOW_LOG );
                popupLoading.sText = QT_TR_NOOP("STR_PANDORA_LOADING");
                stopTimer();
            }
        }
    }

    Timer{
        id: reqTimer
        running: false
        repeat: false
        interval: 30
        onTriggered:{
            __LOG(" reqTimer timeout  : " , LogSysID.LOW_LOG );
            pndrStationList.GetFirstStationListSlot(10,currentActiveStationToken);
       }
   }
}
