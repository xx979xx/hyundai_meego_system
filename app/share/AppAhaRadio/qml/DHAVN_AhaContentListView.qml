import Qt  4.7
import QmlModeAreaWidget 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES
import QmlSimpleItems 1.0
import AhaMenuItems 1.0
import QmlOptionMenu 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET

Item {
    id: ahaContentListView
    width: PR.const_AHA_ALL_SCREEN_WIDTH
    height: PR.const_AHA_CONNECTING_SCREEN_HEIGHT
    y: PR.const_AHA_ALL_SCREENS_TOP_OFFSET
    anchors.bottomMargin: PR.const_AHA_ALL_SCREEN_BOTTOM_MARGIN
    visible: true
    //QML Properties Declaration
    property int focus_index: -1
    property int nTuneStationIndex : 0 //wsuk.kim TUNE
    property int nTotalCount: 0 //wsuk.kim content_jog
    property int nFocusPosition: 0  //wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
    property alias isOptionsMenuVisible: optMenu.visible
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml    property alias isLoadingPopupVisible: popupLoading.visible
    property bool focus_visible: false
    property bool hideMenu: true
    property bool isSelectContent : false //hsryu_0226
    property bool isJogEventinModeArea: false //wsuk.kim content_jog
    property bool isDRSTextScroll: UIListener.getDRSTextScrollState()    //wsuk.kim text_scroll
    property bool isPlayingAnimation: true
    property bool isCenterPressed: false    //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
    property bool isTouchPressed: false    //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
    property bool isFlickingRunning: flickCurrentFocusIndex.running    //wsuk.kim 130808 ITS_0181039 focus flicking
    property bool isSeekTrackPressed: false    //wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml    property bool isStartListView: false    //wsuk.kim 130911 to return view(list or track) change after loading fail.
//wsuk.kim 131105 shift error popup move to AhaRadio.qml    property bool isShiftErrVisible: shiftErrPopup.visible //wsuk.kim 131002 ITS_192102 overlap repeat buffering popup and other popup.
    property bool isMoving: false    // added 2014.03.05 drag performance
    //hsryu_0329_system_popup
    property bool contentsNowLoading : false

    signal handlecontentSelectionEvent();
    signal handleBackRequest();
    signal handleSelectionEvent();  //wsuk.kim 131104 displayed at OSD control by tune.
    signal handlePlayContent();        //hsryu_0524_select_same_content
    signal lostFocus(int arrow, int status);    //wsuk.kim content_jog
    signal handleShowErrorPopup(int reason);  //wsuk.kim 131105 shift error popup move to AhaRadio.qml

    //hsryu_0423_block_play_btcall
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    signal showBtBlockPopup(int jogCenter);

    function handleMenuKey(isJogMenuKey)
    {
//wsuk.kim 130815 Remove isDialUI        isDialUI = isJogMenuKey;
        if( ahaContentListView !== null && ahaContentListView.visible)
        {
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            if(!isLoadingPopupVisible && !isLoadingFailPopupVisible)
            {
                //optMenu.visible = !optMenu.visible;
                if(!optMenu.visible)
                    optMenu.showMenu();
                else
                    optMenu.quickHide();


                UIListener.SetOptionMenuVisibilty( optMenu.visible);
                if(!optMenu.visible)
                {
                    optMenu.hideFocus();
                    for(var i = 0; i < ahaMenus.optListMenuModel.levelMenu; i++)
                    {
                        ahaMenus.optListMenuModel.backLevel();
                    }

                    listModeAreaWidget.hideFocus();
                    ahaContentListView.showFocus();
                    if(focus_index === -1)
                    {
                        focus_index = 0;
                        contentItemListView.positionViewAtIndex(focus_index, ListView.Beginning);
                    }
                }
                else
                {
                    listModeAreaWidget.hideFocus();
                    ahaContentListView.hideFocus();

                    optMenu.showFocus();
                    optMenu.setDefaultFocus(0);
                }
            }
//wsuk.kim 131108 ITS_207360 popup unity, change to toast popup.
//            else
//            {
//                waitpopup.showPopup(qsTranslate("main","STR_AHA_OPERATION_INPROGRESS"));
//            }
        }
    }

    function refreshlistModeAreaModel() // added for ITS 222579
    {
       // listModeAreaModel.text = qmlProperty.getActiveStationName();  // ITS 0254425
        refreshStationNameTimer.start();
    }
    Timer{
        id: refreshStationNameTimer
        running: false
        repeat: false
        interval: 1000
        onTriggered: {
            listModeAreaModel.text = qmlProperty.getActiveStationName();
        }
    }

    /***************************************************************************/
    /**************************** Aha Qt connections START *****************/
    /***************************************************************************/

    Connections
    {
        target:ahaStationList

        onModelContentReady:
        {
            UIListener.printQMLDebugString("@@@@@@ onModelContentScroll...... 11111111111111 \n");
            UIListener.printQMLDebugString("cur:"+contentItemListView.currentIndex+", model_index:"+model_index);
            //hsryu_0226
            if(isSelectContent)
                return;
            ahaContentListView.showFocus(); //wsuk.kim content_jog

            // ITS 227354
            if (model_index < 0 && nContentCount > 0)
            {
                contentItemListView.currentIndex = 0;
            }
            else
            {
                contentItemListView.currentIndex = model_index;
            }
            //hsryu_0206
            if(model_index>5)
            {
                var tempGap = model_index%6;
                var tempIndex = model_index - tempGap;
                contentItemListView.positionViewAtIndex(tempIndex, contentItemListView./*Beginning*/Contain);
                UIListener.printQMLDebugString("hsryu onCompleted ===> " + tempIndex + "\n");
            }

            focus_index = model_index; //wsuk.kim content_jog
            nTotalCount = nContentCount;
            /*popupLoading.visible*/isLoadingPopupVisible = false;
            isStartListView = false;   //wsuk.kim 130911 to return view(list or track) change after loading fail.
            //hsryu_0405_system_popup
            contentsNowLoading = false;

            //hsryu_0226
            isSelectContent = false;

            refreshlistModeAreaModel(); // added for ITS 222579
        }

        onModelContentScroll:
        {
            UIListener.printQMLDebugString("@@@@@@ onModelContentScroll...... 11111111111111 \n");
            if(isSeekTrackPressed) //wsuk.kim 130905 current focus change when to press only SEEK/TRACK.  if(!isFlickingRunning)
            {
                UIListener.printQMLDebugString("hsryu onModelContentScroll \n");
                isSeekTrackPressed = false;
                listModeAreaWidget.hideFocus();
                ahaContentListView.showFocus();

                focus_index = contentItemListView.currentIndex = model_index;   //wsuk.kim 130808 ITS_0181039 focus flicking
                //hsryu_0206
                if(model_index>0 && model_index%6 === 0)
                {
                    contentItemListView.positionViewAtIndex(model_index, contentItemListView.Contain);
                }
            }
        }
    }

    Connections
    {
        //hsryu_0423_block_play_btcall
        target: (!popupVisible && !isLoadingPopupVisible && /*!shiftErrPopup.visible && !btBlockPopupVisible*/!popUpTextVisible && !networkErrorPopupVisible && !isLoadingFailPopupVisible)?UIListener:null
        onMenuKeyPressed:
        {
            handleMenuKey(isJogMenuKey);
        }

        //hsryu_0423_block_play_btcall
        //hsryu_0502_jog_control
//        onSignalJogCenterClicked:
//        {
//            handleCenterKey();
//        }

        onSignalJogNavigation:
        {
            UIListener.printQMLDebugString("@@onSignalJogNavigation ...");
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            if(status === UIListenerEnum.KEY_STATUS_PRESSED)
            {
//wsuk.kim 130903 menu hide to change jog left from press to releas.
//                if(optMenu.visible)
//                {
//                    if(arrow === PR.const_AHA_JOG_EVENT_ARROW_LEFT)
//                    {
//                        //optMenu.visible = false;
//                        optMenu.quickHide();
//                        optMenu.hideFocus();
//                        listModeAreaWidget.hideFocus();
//                        for(var i = 0; i < ahaMenus.optListMenuModel.levelMenu; i++)
//                        {
//                            ahaMenus.optListMenuModel.backLevel();
//                        }
////wsuk.kim 130815 Remove isDialUI                       if(isDialUI)
//                        {
//                            ahaContentListView.showFocus();
//                        }
//                    }
//                    else
//                    {
//                        listModeAreaWidget.hideFocus();
//                        ahaContentListView.hideFocus();
//                        if(!optMenu.focus_visible)
//                        {
//                            optMenu.showFocus();
////wsuk.kim 130815 Remove isDialUI                            if(isDialUI)
//                            {
//                                optMenu.setDefaultFocus(0);
//                            }
//                        }
//                    }
//                }
//                else
                if(!optMenu.visible)
                {
                    if(arrow=== UIListenerEnum.JOG_WHEEL_LEFT || arrow === UIListenerEnum.JOG_WHEEL_RIGHT /*|| arrow=== UIListenerEnum.JOG_UP*/)    //0428
                    {
                        handleJogEvent(arrow,status);
                    }
                    else if(arrow === UIListenerEnum.JOG_CENTER)    //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
                    {
                        handleTuneCenterPressed();
                    }
                }
            }
            else if(status === UIListenerEnum.KEY_STATUS_LONG_PRESSED)  //wsuk.kim 131001 Press&Hold JOG up/down, fast scrolling.
            {
                if(arrow === UIListenerEnum.JOG_UP || arrow === UIListenerEnum.JOG_DOWN)
                {
                    pressHoldJOGUpDown.lastPressed = arrow;
                    pressHoldJOGUpDown.start();
                }
            }
            else if(status === UIListenerEnum.KEY_STATUS_RELEASED) //hsryu_0502_jog_control
            {
                if(pressHoldJOGUpDown.running)  //wsuk.kim 131001 Press&Hold JOG up/down, fast scrolling.
                {
                    pressHoldJOGUpDown.lastPressed = -1;
                    pressHoldJOGUpDown.stop();
                    return;
                }

//wsuk.kim 130903 menu hide to change jog left from press to releas.
                if(optMenu.visible)
                {
//wsuk.kim 131210 ITS_214306 duplicating hide option menu.
//                    if(arrow === UIListenerEnum.LEFT)
//                    {
//                        //optMenu.visible = false;
//                        optMenu.quickHide();
//                        optMenu.hideFocus();
//                        listModeAreaWidget.hideFocus();
//                        for(var i = 0; i < ahaMenus.optListMenuModel.levelMenu; i++)
//                        {
//                            ahaMenus.optListMenuModel.backLevel();
//                        }
////wsuk.kim 130815 Remove isDialUI                       if(isDialUI)
//                        {
//                            ahaContentListView.showFocus();
//                        }
//                    }
//                    else
//                    {
//                        listModeAreaWidget.hideFocus();
//                        ahaContentListView.hideFocus();
//                        if(!optMenu.focus_visible)
//                        {
//                            optMenu.showFocus();
////wsuk.kim 130815 Remove isDialUI                            if(isDialUI)
//                            {
//                                optMenu.setDefaultFocus(0);
//                            }
//                        }
//                    }
                }
//wsuk.kim 130903 menu hide to change jog left from press to releas.
                else
                {
                    if(arrow === UIListenerEnum.JOG_CENTER)
                    {
                        handleCenterKey();
                    }
                    else if(arrow === UIListenerEnum.JOG_UP)    //wsuk.kim 131001 HK JOG Relesed, work to JogEvent.
                    {
                        handleJogEvent(arrow,status);
                    }
                }
            }
        }

//wsuk.kim text_scroll
        onHandleTextScrollState:
        {
            isDRSTextScroll = isTextScrolling;
        }
//wsuk.kim text_scroll

        onHandlePlayAnimationState:
        {
            UIListener.printQMLDebugString("@@isSelectStatus :"+isSelectStatus+" @@isPlayStatus :"+isPlayStatus+" @@isPlayingAnimation:"+isPlayingAnimation);
            isPlayingAnimation = isPlayAnimation;
        }

        onHandleListViewPosition:        // add by Ryu 20130911
        {
            //ITS_0226203
            UIListener.printQMLDebugString("@@ onHandleListViewPosition index:"+focus_index);
            refreshlistModeAreaModel();
            contentItemListView.positionViewAtIndex(focus_index, ListView.Contain);
         }
    }

//wsuk.kim content_jog
    Connections
    {
        target: ahaMenus
        onMenuDataChanged:
        {
            optMenu.menumodel = ahaMenus.optListMenuModel
        }
    }

    Connections
    {
        target: listModeAreaWidget.focus_visible?UIListener:null
        onSignalJogCenterPressed:
        {
            isJogEventinModeArea = true;
        }

        onSignalJogNavigation:
        {
            if(status === UIListenerEnum.KEY_STATUS_PRESSED)
                isJogEventinModeArea = true;
        }
    }

//wsuk.kim content_jog

    // Nte: this connection is usefull when any thing changed in ListMenuModel.
    // But as of now nothing is changed from qml in ListMenu.
    // So its not in use, we can ignore it if needed.
    Connections
    {
        target: ahaMenus
        onMenuDataChanged:
        {
            optMenu.menumodel = ahaMenus.optListMenuModel
        }
    }

    /***************************************************************************/
    /**************************** Aha Qt connections END ****************/
    /***************************************************************************/

    /***************************************************************************/
    /**************************** Aha QML connections START ****************/
    /***************************************************************************/

    Component.onCompleted: {
        isSelectContent = false ; //hsryu_0226
        activeView = ahaContentListView;
        qmlProperty.setFocusArea(PR.const_STATION_LIST_CONTENT_LIST_FOCUS);

        ahaMenus.optListMenuModel.itemEnabled(MenuItems.NowListening, true);
//wsuk.kim TUNE
        nTuneStationIndex = ahaStationList.getStationIndexUsedfromStationIdTune();
        ahaStationList.setContentListTuneIndex(nTuneStationIndex);
//wsuk.kim TUNE
        //hsryu_0131
        //handleForegroundEvent();

         listModeAreaModel.text = "";       // ITS 0254425
    }

    onVisibleChanged:   //wsuk.kim 131224 ITS_217070 Press hold when disp change from on to off.
    {
        if(ahaContentListView.visible === true)
        {
            isCenterPressed = false;
        }
    }

    Connections{
        target: ahaController

        //hsryu_0329_system_popup
        onHandleCloseContentsPopup:
        {
            if(optMenu.visible === true)
            {
                //optMenu.visible = false;
                optMenu.quickHide();
            }

            if(waitpopup.visible === true)
            {
                waitpopup.visible = false;
            }

            if(/*popupLoading.visible*/ isLoadingPopupVisible === true)
            {
                //hsryu_0405_system_popup
                contentsNowLoading = true;
                /*popupLoading.visible*/isLoadingPopupVisible = false;
            }

            if(isLoadingFailPopupVisible)
            {
                isLoadingFailPopupVisible = false;
            }

//wsuk.kim 131105 shift error popup move to AhaRadio.qml
//            if(shiftErrPopup.visible === true)
//            {
//                //functionalTimer.stop();   // by Ryu : ITS 0187776
//                shiftErrPopup.visible = false;
//            }

           ahaContentListView.handleTempHideFocus();    //wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
        }
        onHandleRestoreContentsPopup:
        {
            ahaContentListView.handleRestoreShowFocus();    //wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
            //hsryu_0405_system_popup
            if(contentsNowLoading)
            {
               /*popupLoading.visible*/isLoadingPopupVisible = true;
            }
            contentsNowLoading = false;
        }

        onBackground:
        {
            isTouchPressed = false;
            isCenterPressed = false;
        }
		//hsryu_0329_system_popup

//wsuk.kim 130815 Remove isDialUI
//        onIsDialUIChanged:
//        {
//            UIListener.printQMLDebugString("ContentListView : onIsDialUIChanged "\n");
//
//            if(!isDialUI)
//            {
//                optMenu.hideFocus();
//                listModeAreaWidget.hideFocus();
//                ahaContentListView.hideFocus();
//            }
//            else
//            {
//                if(optMenu.visible)
//                {
//                    optMenu.setDefaultFocus(0);
//                }
//                else
//                {
//                    ahaContentListView.showFocus(); //wsuk.kim content_jog
//                }
//            }
//        }
//wsuk.kim 130815 Remove isDialUI

    }

//wsuk.kim content_jog
    onLostFocus: {
        if(arrow === UIListenerEnum.JOG_UP)
        {
            listModeAreaWidget.showFocus();
            ahaContentListView.hideFocus();
            if(listModeAreaWidget.focus_index === -1)
            {
                listModeAreaWidget.setDefaultFocus(arrow);
            }
        }
    }
//wsuk.kim content_jog
    /***************************************************************************/
    /**************************** Aha QML connections END ****************/
    /***************************************************************************/

    Component
    {
        id: listItemDelegate
        Column
        {
            Rectangle
            {
                id:id_border
                visible: true
                height:PR.const_AHA_PRESET_LIST_VIEW_ROW_HEIGHT_WITHBORDER
                width:PR.const_AHA_ALL_SCREEN_WIDTH
                color:PR.const_AHA_STATION_LIST_VIEW_COLUMN_COLOR

                Image{
                    id: bg
                    x : 30
                    height: PR.const_AHA_PRESET_LIST_VIEW_ROW_HEIGHT_WITHBORDER_FOCUS
                    width : PR.const_AHA_ALL_SCREEN_WIDTH - 80
                    source: ""//PR_RES.const_APP_AHA_LIST_VIEW_ITEM_BACKGROUND
                    //anchors.fill: parent
                }

                BorderImage {
                    id: borderImage
                    source: isCenterPressed? PR_RES.const_APP_AHA_LIST_VIEW_ITEM_RELEASED : (isTouchPressed? "" : PR_RES.const_APP_AHA_LIST_VIEW_ITEM_BORDER_IMAGE)    //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
                    height: PR.const_AHA_PRESET_LIST_VIEW_ROW_HEIGHT_WITHBORDER_FOCUS
                    width: PR.const_AHA_CONTENT_LIST_VIEW_TRACKITEM_BORDER_WIDTH
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    visible: focus_visible && (focus_index === index)
                }

                //hsryu_0206
                AnimatedImage
                {
                    id: icon_current_playing
                    source: PR_RES.const_APP_AHA_TRACK_PLAY
                    anchors.right: id_text.left
                    anchors.rightMargin: 20
                    //hsryu_0313_fix_animation_pos
                    //anchors.top: id_text.top
                    //anchors.topMargin: PR.const_AHA_STATION_LIST_VIEW_CURRENTPLAYING_IMAGE_TOPMARGIN
                    anchors.verticalCenter: parent.verticalCenter
                    width: PR.const_AHA_STATION_LIST_VIEW_CURRENTPLAYING_IMAGE_WIDTH
                    //playing: (isSelectStatus && isPlayStatus && isPlayingAnimation && !isMoving)  // modified 2014.03.05
                    playing: (ahaTrack.TrackStatus() === 1 && !isMoving)    //ITS_0226514, 0225964
                    visible: isSelectStatus
                }

//                NumberAnimation { target: icon_current_playing; property: "opacity"; to: 1;
//                    running: isSelectStatus; duration: 1500 }

//wsuk.kim text_scroll
                DHAVN_AhaTextScroll
                {
                    id: id_text
                    text: name

                    fontSize: PR.const_AHA_STATION_LIST_VIEW_TRACKITEM_TEXT_FONT_POINTSZIE
                    fontFamily: isSelectStatus? PR.const_AHA_FONT_FAMILY_HDB: PR.const_AHA_FONT_FAMILY_HDR  //wsuk.kim 130930 selected item, change from HDR to HDB.
//                    horizontalAlignment: Text.AlignLeft
                    color: ((focus_index !== index && isSelectStatus) ||
                              (focus_index === index && !focus_visible && isSelectStatus)) ? PR.const_AHA_COLOR_TEXT_CURR_STATION: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY  // modified ITS 224194  //wsuk.kim 131203 ITS_212562 selected-focus color change bright grey.
                    anchors.left: parent.left
                    anchors.leftMargin: 100
                    anchors.verticalCenter: parent.verticalCenter
                    width: PR.const_AHA_STATION_LIST_VIEW_TRACKITEM_TEXT_WIDTH;
                    scrollingTicker: (focus_index === index && isDRSTextScroll && ahaContentListView.focus_visible)? true: false   // Ryu : ITS 0221725 Text ticker issue was resolved
                }
//wsuk.kim text_scroll
//                Text
//                {
//                    id: id_text
//                    text: name
//                    elide: Text.ElideRight
//                    font.pixelSize: PR.const_AHA_STATION_LIST_VIEW_TRACKITEM_TEXT_FONT_POINTSZIE
//                    font.family: PR.const_AHA_FONT_FAMILY_HDR //hsryu_0315_change_text_format
//                    horizontalAlignment: Text.AlignLeft
//                    color: (isSelectStatus) ? PR.const_AHA_COLOR_TEXT_CURR_STATION: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY


//                    anchors.left: parent.left
//                    anchors.leftMargin: 100
//                    anchors.verticalCenter: parent.verticalCenter
//                    width: PR.const_AHA_STATION_LIST_VIEW_TRACKITEM_TEXT_WIDTH;
//                }

                Image  // modified ITS 228397
                {
                    id:listline
                    width: PR.const_AHA_ALL_SCREEN_WIDTH
                    source: PR_RES.const_APP_AHA_LIST_VIEW_ITEM_LIST_LINE
                    visible: true
                    anchors.top: parent.bottom
                }

                MouseArea
                {
                    anchors.fill: parent
                    onPressed: {
                        if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                        {
                            toastPopupVisible = false;
                        }

                        if(borderImage.visible) //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
                        {
                            isTouchPressed = true;
                        }
                        bg.source = PR_RES.const_APP_AHA_LIST_VIEW_ITEM_RELEASED
                    }

                    onReleased: {
                        if(borderImage.visible) //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
                        {
                            isTouchPressed = false;
                        }
                        bg.source = ""// PR_RES.const_APP_AHA_LIST_VIEW_ITEM_RELEASED;
                    }

                    onClicked:
                    {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//                        //hsryu_0423_block_play_btcall
//                        if(UIListener.IsCallingSameDevice())
//                        {
//                            if(isSelectStatus)
//                            {
//                                handleBackRequest();
//                            }
//                            else
//                            {
//                                //clBTBlockPopup.showPopup(qsTranslate("main", "STR_AHA_FEATURE_NOT_AVAILABLE_DURING_CALL"));
//                                showBtBlockPopup(0);
//                                return;
//                            }
//                        }
//wsuk.kim 131108 ITS_207360 popup unity, change to toast popup.
                        if(isLoadingPopupVisible) return;
                        if(isLoadingFailPopupVisible) return;
//wsuk.kim 131108 ITS_207360 popup unity, change to toast popup.
                        //hsryu_0329_aha_skip_limitation
                        if(((contentItemListView.currentIndex < index) &&(InTrackInfo.allowSkip == false))
                            || ((contentItemListView.currentIndex > index) &&(InTrackInfo.allowSkipBack == false)) )
                        {
                            handleShowErrorPopup(PR.const_AHA_SKIP_NOT_AVAILABLE);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml   shiftErrPopup.showPopup(qsTranslate("main", "STR_AHA_SKIP_NOT_AVAILABLE"), false);
                            return;
                        }

                        contentItemListView.currentIndex = index;
                        if(!isSelectStatus)
                        {
                            ahaTrack.Pause();   //wsuk.kim 130822 ITS_0182104 exception loading popup.
                            //hsryu_0326_like_dislike
//wsuk.kim 130910 ITS_0188998 like/dislike didnot display after loading fail.                           ahaTrack.ClearCurrentLikeDislike();
                            //hsryu_0226
                            isSelectContent = true;
                            /*popupLoading.visible*/isLoadingPopupVisible = true;
                            ahaStationList.selectContentID(appID);
                            handlecontentSelectionEvent();
                        }
                        else
                        {
                            // On selection of active station, simply switch the view
                            handlePlayContent(); //hsryu_0524_select_same_content
                            //handleBackRequest();
                        }
                    }

                    onCanceled:
                    {
                        if(borderImage.visible) //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
                        {
                            isTouchPressed = false;
                        }
                        bg.source = ""//PR_RES.const_APP_AHA_LIST_VIEW_ITEM_RELEASED
                    }

                    onExited:
                    {
                        if(borderImage.visible) //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
                        {
                            isTouchPressed = false;
                        }
                        bg.source = ""//PR_RES.const_APP_AHA_LIST_VIEW_ITEM_RELEASED
                    }
                }
            }
        }
    }

    OptionMenu{
        id: optMenu
        menumodel: ahaMenus.optListMenuModel
        z: 1000
        y: 0
        visible: false;
        autoHiding: true
        autoHideInterval: 10000
        scrollingTicker: isDRSTextScroll    //wsuk.kim 130909 Menu text scllor ticker

        onIsHidden:
        {
            optMenu.hideFocus();
            visible = false;
            for(var i = 0; i < ahaMenus.optListMenuModel.levelMenu; i++)
            {
                ahaMenus.optListMenuModel.backLevel();
            }

            listModeAreaWidget.hideFocus();
            ahaContentListView.showFocus();
        }

        onBeep: UIListener.ManualBeep(); //added by honggi.shin, 2014.01.28, Beep enable

        onTextItemSelect:
        {
            //hsryu_0417_sound_setting
            if(ahaController.blaunchSoundSetting) return;

            handleMenuItemEvent(itemId);
        }
        function showMenu()
        {
            optMenu.visible = true;
            optMenu.show();
        } // added by Sergey 02.08.2103 for ITS#181512
    }

    ListView
    {
        id: contentItemListView
        delegate: listItemDelegate
        model: modelContent
        anchors.fill: parent
        anchors.topMargin: listModeAreaWidget.height
        anchors.left: parent.left

//wsuk.kim 130808 ITS_0181039 focus flicking
        currentIndex: 0
        clip: true
        snapMode: isMoving ? ListView.SnapToItem : ListView.NoSnap // modified 2014.03.05
        highlightMoveDuration: 1
//        orientation : ListView.Vertical
        //hsryu_0206
//        preferredHighlightBegin: 0; preferredHighlightEnd: 552

//        highlightMoveSpeed: 600
//        highlightMoveDuration: 400
//        highlightRangeMode: ListView.NoHighlightRange
//        highlightFollowsCurrentItem: true

//        maximumFlickVelocity: 1000

//        //cacheBuffer: 3000

//        clip: true
//        focus: true
//        //snapMode: ListView.SnapToItem

//        flickableDirection: Flickable.VerticalFlick
//        flickDeceleration: 1000
//wsuk.kim touch_focus        pressDelay : 150

        //boundsBehavior: ListView.StopAtBounds
//wsuk.kim 130808 ITS_0181039 focus flicking

        property int mouseStarty: 0
        property int mouseEndy: 0
        property int direction: PR.const_LIST_VIEW_MOVING_NONE

        Component.onCompleted:
        {
            //hsryu_0131
            /*popupLoading.visible*/isLoadingPopupVisible = true;
            isStartListView = true;   //wsuk.kim 130911 to return view(list or track) change after loading fail.
        }

        VerticalScrollBar
        {
           anchors.top: parent.top
           anchors.right: parent.right
           anchors.topMargin: 34
           anchors.rightMargin:8
           height: 465
           position: parent.visibleArea.yPosition
           pageSize: parent.visibleArea.heightRatio
           visible: ( pageSize < 1 )
        }
//wsuk.kim 130808 ITS_0181039 focus flicking
        onMovementEnded:
        {
            isMoving = false; // added 2014.03.05 drag performance
            currentIndex = indexAt ( 10, Math.floor(contentY + 10) );
        }
        onMovementStarted:  // added 2014.03.05 drag performance
        {
            isMoving = true;
        }
        onCurrentIndexChanged:
        {
            UIListener.printQMLDebugString("@@onCurrentIndexChanged focus:"+focus_index+",current:"+currentIndex);
            if(focus_index +1 <= currentIndex)  //if(focus_index +1 === currentIndex)
            {
                flickCurrentFocusIndex.restart();
            }
            else if(focus_index - currentIndex >= 6)   //else if((focus_index - currentIndex === 6) && (currentIndex%6 === focus_index%6))
            {
                flickCurrentFocusIndex.restart();
            }
        }
//wsuk.kim 130808 ITS_0181039 focus flicking
    }

    /***************************************************************************/
    /**************************** Private functions START **********************/
    /***************************************************************************/

    function handleForegroundEvent()
    {
        /*popupLoading.visible*/isLoadingPopupVisible = true;
    }

    // handle retranlateUI event
    function handleRetranslateUI(languageId)
    {
       listModeAreaWidget.retranslateUI(PR.const_AHA_LANGCONTEXT);
    }

    // Logic for highlighting the item based on jog key events
    function setHighlightedItem(inKeyId)
    {
//wsuk.kim 130815 Remove isDialUI        isDialUI = true;
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
        ahaContentListView.focus_visible = false;
        /*popupLoading.visible*/isLoadingPopupVisible = true;
    }

    function handleJogEvent( arrow, status )
    {
//wsuk.kim 130815 Remove isDialUI        if(isDialUI)
        {
            UIListener.printQMLDebugString("@@handleJogEvent arrow:"+arrow+",status:"+status);
            switch(arrow)
            {
            case PR.const_AHA_JOG_EVENT_WHEEL_RIGHT:
                focusNext(PR.const_AHA_JOG_EVENT_ARROW_DOWN);
                break;
            case PR.const_AHA_JOG_EVENT_ARROW_UP:
                ahaContentListView.lostFocus(arrow, status);
                break;
            case PR.const_AHA_JOG_EVENT_WHEEL_LEFT:
                focusPrev(PR.const_AHA_JOG_EVENT_ARROW_UP);
                break;
//hsryu_0423_block_play_btcall
//            case PR.const_AHA_JOG_EVENT_CENTER:
//                handleCenterKey();
//                break;
            }
        }
//wsuk.kim 130815 Remove isDialUI        else
//        {
//            isDialUI = true;
//            focus_index = ahaStationList.getContentIndex();
//            contentItemListView.positionViewAtIndex(focus_index, ListView.Contain);
//        }
    }

    function focusNext( arrow )
    {
        var eventHandled = false;
        if(contentItemListView.flicking) return; //wsuk.kim 131122 ITS_210551 to move focus at CCP wheeling during flicking.

        if(focus_visible)
        {
            if(focus_index < nTotalCount -1)
            {
                //modified ITS 225406
                if(focus_index == contentItemListView.indexAt ( 10, Math.floor(contentItemListView.contentY + 500) ))
                {
                    contentItemListView.positionViewAtIndex(focus_index + 1, ListView.Beginning);
                }
                else
                {
                    contentItemListView.positionViewAtIndex(focus_index + 1, ListView.Contain);
                }
                focus_index += 1
                eventHandled = true;
            }
            else// if(focus_index + 1 == nTotalCount )
            {
                if(nTotalCount > PR.const_AHA_STATION_LIST_LOOPING_HOLD)  //wsuk.kim 130902 ISV_90201 hold on looping that under 1 page.
                {
                    if(pressHoldJOGUpDown.lastPressed !== UIListenerEnum.JOG_DOWN) //wsuk.kim 131001 Press&Hold JOG up/down, fast scrolling.
                    {
                        focus_index = 0;
                        eventHandled = true;
                        contentItemListView.positionViewAtIndex(focus_index, ListView.Contain);
                    }
                }
            }
        }
        return eventHandled;
    }

    function focusPrev( arrow )
    {
        var eventHandled = false;
        if(contentItemListView.flicking) return; //wsuk.kim 131122 ITS_210551 to move focus at CCP wheeling during flicking.

        if(focus_visible)
        {
            if(focus_index > 0)
            {
                //modified ITS 225406
                if(focus_index == contentItemListView.indexAt ( 10, Math.floor(contentItemListView.contentY + 10) ))
                {
                    contentItemListView.positionViewAtIndex(focus_index - 1, ListView.End);
                }
                else
                {
                    contentItemListView.positionViewAtIndex(focus_index - 1, ListView.Contain);
                }
                focus_index -= 1;
                eventHandled = true;
            }
            else
            {
                if(nTotalCount > PR.const_AHA_STATION_LIST_LOOPING_HOLD)  //wsuk.kim 130902 ISV_90201 hold on looping that under 1 page.
                {
                    if(pressHoldJOGUpDown.lastPressed !== UIListenerEnum.JOG_UP) //wsuk.kim 131001 Press&Hold JOG up/down, fast scrolling.
                    {
                        focus_index = nTotalCount - 1;
                        eventHandled = true;
                        contentItemListView.positionViewAtIndex(focus_index, ListView.Contain);
                    }
                }
            }
        }
        return eventHandled;
    }
//wsuk.kim content_jog

    function handleCenterKey()
    {
        isCenterPressed = false;    //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
        if(focus_visible)
        {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//            //hsryu_0423_block_play_btcall
//            if(UIListener.IsCallingSameDevice())
//            {
//                if(ahaStationList.getContentIndex() === focus_index)    //wsuk.kim 130808 ITS_0181039 focus flicking   if(contentItemListView.currentIndex === focus_index)
//                {
//                    handleBackRequest();
//                }
//                else
//                {
//                    UIListener.printQMLDebugString("++++hsryu contents handleCenterKey ++++\n");
//                    showBtBlockPopup(1);
//                    return;
//                }
//            }

            //hsryu_0329_aha_skip_limitation
            if(((contentItemListView.currentIndex < focus_index) &&(InTrackInfo.allowSkip == false))
                || ((contentItemListView.currentIndex > focus_index) &&(InTrackInfo.allowSkipBack == false)) )
            {
                handleShowErrorPopup(PR.const_AHA_SKIP_NOT_AVAILABLE);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml   shiftErrPopup.showPopup(qsTranslate("main", "STR_AHA_SKIP_NOT_AVAILABLE"), false);
                return;
            }

            if(focus_index >=0 && focus_index < nTotalCount)
            {
//wsuk.kim content_jog
                if(ahaStationList.getContentIndex() !== focus_index)    //wsuk.kim 130808 ITS_0181039 focus flicking   if(contentItemListView.currentIndex !== focus_index)
                {
                    ahaTrack.Pause();    //wsuk.kim 130822 ITS_0182104 exception loading popup.
                    //hsryu_0326_like_dislike
//wsuk.kim 130910 ITS_0188998 like/dislike didnot display after loading fail.                    ahaTrack.ClearCurrentLikeDislike();
                    //hsryu_0226
                    isSelectContent = true;
                    /*popupLoading.visible*/isLoadingPopupVisible = true;
                    ahaStationList.selectContentIndex(focus_index);
                    handlecontentSelectionEvent();
                }
                else
//wsuk.kim content_jog
                {
                    handlePlayContent(); //hsryu_0524_select_same_content
                    //handleBackRequest();
                }
            }
        }
    }

    function handleTuneCenterPressed()  //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
    {
        if(!isLoadingPopupVisible && !isOptionsMenuVisible /*&& !btBlockPopupVisible*/ && !networkErrorPopupVisible && !isLoadingFailPopupVisible)
        {
            isCenterPressed = true;
        }
    }

    function handleMenuItemEvent(menuItemId)
    {
        ahaContentListView.hideMenu = true;

        switch(parseInt(menuItemId))
        {
            case MenuItems.NowListening: // "Now Listening"
            {
                ahaContentListView.handleBackRequest();
                break;
            }
            case MenuItems.SoundSetting: // Sound Setting
            {
                //hsryu_0417_sound_setting
                ahaController.blaunchSoundSetting = true;
                UIListener.LaunchSoundSetting();
                break;
            }
            default:
            {
                break;
            }
        }
//hsryu_0417_sound_setting
//hsryu_0319_control_opt_sound_setting
//        if(parseInt(menuItemId) === MenuItems.SoundSetting)
//        {
//            ;
//        }
//        else
//        {
//        	optMenu.visible = !ahaContentListView.hideMenu;
//            optMenu.hideFocus();
//        }

        //optMenu.hideFocus();
    }

//hsryu_0319_control_opt_sound_setting
//    Timer{
//        id: optContetntTransitionTimer
//        running: false
//        repeat: false
//        interval: 500
//        onTriggered: {
//            optMenu.visible = false;
//        }
//    }

    function hideOptionsMenu()
    {
        UIListener.printQMLDebugString("AhaContentListView : hideOptionsMenu \n");

        //optMenu.visible = false;
        optMenu.quickHide();
        optMenu.hideFocus();
        for(var i = 0; i < ahaMenus.optListMenuModel.levelMenu; i++)
        {
            ahaMenus.optListMenuModel.backLevel();
        }

        listModeAreaWidget.hideFocus();
        ahaContentListView.showFocus();
    }

    function handlePopupNoSkipBack()
    {
//wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
        listModeAreaWidget.hideFocus();
        ahaContentListView.showFocus();
//wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_SKIP_BACK);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml       shiftErrPopup.showPopup(qsTranslate("main", "STR_NO_SUPPORT_SKIP_BACK"), true);
    }

    function handlePopupNoSkip()
    {
//wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
        listModeAreaWidget.hideFocus();
        ahaContentListView.showFocus();
//wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_SKIP);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftErrPopup.showPopup(qsTranslate("main", "STR_NO_SUPPORT_SKIP"), true);
    }

    function handlePopupNoREW15()
    {
//wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
        listModeAreaWidget.hideFocus();
        ahaContentListView.showFocus();
//wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_REW15);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftErrPopup.showPopup(qsTranslate("main", "STR_AHA_NO_SUPPORT_REW15"), true);
    }

    function handlePopupNoFW30()
    {
//wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
        listModeAreaWidget.hideFocus();
        ahaContentListView.showFocus();
//wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_FW30);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftErrPopup.showPopup(qsTranslate("main", "STR_AHA_NO_SUPPORT_FW30"), true);
    }

//wsuk.kim TUNE
    function handleFocusTuneUp(arrow)
    {
        if(!isLoadingPopupVisible && !isOptionsMenuVisible && !networkErrorPopupVisible && !isLoadingFailPopupVisible)
        {
//wsuk.kim 130815 Remove isDialUI            isDialUI = true;
            listModeAreaWidget.hideFocus();
            ahaContentListView.showFocus();

            focusPrev(arrow);
        }
    }

    function handleFocusTuneDown(arrow)
    {
        if(!isLoadingPopupVisible && !isOptionsMenuVisible && !networkErrorPopupVisible && !isLoadingFailPopupVisible)
        {
//wsuk.kim 130815 Remove isDialUI            isDialUI = true;
            listModeAreaWidget.hideFocus();
            ahaContentListView.showFocus();

            focusNext(arrow);
        }
    }

    function handleFocusTuneCenter()
    {
        //hsryu_0423_block_play_btcall
        if(!isLoadingPopupVisible && !isOptionsMenuVisible /*&& !btBlockPopupVisible*/ && !networkErrorPopupVisible && !isLoadingFailPopupVisible)
        {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//            if(UIListener.IsCallingSameDevice())
//            {
//                isCenterPressed = false;    //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
//                if(ahaStationList.getContentIndex() === focus_index)    //wsuk.kim 130808 ITS_0181039 focus flicking   if(contentItemListView.currentIndex === focus_index)
//                {
//                    handlePlayContent(); //hsryu_0524_select_same_content
//                    //handleBackRequest();
//                }
//                else
//                {
//                    showBtBlockPopup(0);
//                }
//            }
//            else
            handleCenterKey();
        }
    }

    function handleStationTuneCenter()  //wsuk.kim 131104 displayed at OSD control by tune.
    {
        //hsryu_0423_block_play_btcall
        if(UIListener.IsCallingSameDevice())
        {
            UIListener.OSDInfoCannotPlayBTCall();
            return;
        }

        if(ahaStationList.checkSameStationId(ahaStationList.getContentListTuneIndex()))
        {
            UIListener.OSDTrackInfo();
            return;
        }

        if(ahaStationList.getStationIdTune() === 1 /*STATION_PRESET*/)
            ahaStationList.selectPresetIndex(ahaStationList.getContentListTuneIndex());
        else if(ahaStationList.getStationIdTune() === 2 /*STATION_LBS*/)
            ahaStationList.selectLBSIndex(ahaStationList.getContentListTuneIndex());

        showWaitNote();
        ahaContentListView.handleSelectionEvent();
    }
//wsuk.kim TUNE

    function handleSeekTrackPressedFocus()  //wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
    {
        isSeekTrackPressed = true;
    }

//wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
    function handleTempHideFocus()
    {
        if(listModeAreaWidget.focus_visible)
            nFocusPosition = 1;
        else //if(ahaContentListView.focus_visible)
            nFocusPosition = 2;

        listModeAreaWidget.hideFocus();
        ahaContentListView.hideFocus();
    }

    function handleRestoreShowFocus()
    {
        if(nFocusPosition === 1)
            listModeAreaWidget.showFocus();
        else //if(nFocusPosition === 2)
            ahaContentListView.showFocus();
    }
//wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
    /***************************************************************************/
    /**************************** Private functions END **********************/
    /***************************************************************************/


   //  MODE AREA
   QmlModeAreaWidget
   {
       id: listModeAreaWidget
       modeAreaModel: listModeAreaModel
       search_visible: false
       parent: ahaContentListView
       anchors.top: parent.top

       onModeArea_BackBtn:
       {
//wsuk.kim 130815 Remove isDialUI           isDialUI = isJogEventinModeArea;
           if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
           {
               toastPopupVisible = false;
           }

           ahaContentListView.handleBackRequest();
           isJogEventinModeArea = false;
       }

       onModeArea_MenuBtn:
       {
//wsuk.kim 130815 Remove isDialUI           isDialUI = isJogEventinModeArea;
           handleMenuKey(isJogEventinModeArea);
           isJogEventinModeArea = false;
       }

//wsuk.kim content_jog
       onLostFocus:
       {
           isJogEventinModeArea = false;
           switch(arrow)
           {
               case UIListenerEnum.JOG_DOWN:
               {
                   listModeAreaWidget.hideFocus();
                   ahaContentListView.focus_visible = true;
                   break;
               }
           }
       }
//wsuk.kim content_jog


       Image {
           id: ahaLogo
           source: PR_RES.const_APP_AHA_TRACK_VIEW_AHALOGO_IMAGE
           x: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_X_OFFSET
   //wsuk.kim 130717 to change front/rear title position
           //anchors.left: front_back_indicator_text.right
           //anchors.leftMargin: UIListener.GetVariantRearUSB()? 32 : 0  //wsuk.kim 130807 ISV_86633 variant RearUSB
           anchors.bottom: front_back_indicator_text.bottom
           anchors.bottomMargin: 13
   //        x: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_X_OFFSET
   //        y: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_Y_OFFSET
   //wsuk.kim 130717 to change front/rear title position
           z: 1000
           MouseArea{
               anchors.fill: parent
               beepEnabled: false  //wsuk.kim 131015 ITS_195759 beep sound off on TrackView info.
           }
       }

       //hsryu_0618_device_text
       Text
       {
           id: front_back_indicator_text
   //wsuk.kim 130717 to change front/rear title position
           //x: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_X_OFFSET
           anchors.left: ahaLogo.right
           anchors.verticalCenter: listModeAreaWidget.verticalCenter
   //        anchors.left: ahaLogo.right
   //        anchors.leftMargin: 10
   //        anchors.bottom: ahaLogo.bottom
   //        anchors.bottomMargin: -9
   //wsuk.kim 130717 to change front/rear title position
           z: 1000
           text: " " + qmlProperty.getActiveStationName();
           color: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY
           font.pointSize: PR.const_AHA_FONT_SIZE_TEXT_HDR_40_FONT
           font.family: PR.const_AHA_FONT_FAMILY_HDB
       }

       ListModel
       {
           id: listModeAreaModel
           //property string text: qmlProperty.getActiveStationName();// QT_TR_NOOP("STR_AHA_CONTENTSLIST");

           property string mb_text: QT_TR_NOOP("STR_AHA_MENU");
           property bool mb_visible: true;
       }
   }

    ListModel
    {
       id: errorModel
    }

   POPUPWIDGET.PopUpDimmed
   {
       id: waitpopup;
       visible: false;
       message: errorModel

       function showPopup(text)
       {
           if(!visible)
           {
               errorModel.clear();
               errorModel.append({msg:text})
               visible = true;
               timeOutTimer.start();
           }
       }

       Timer{
           id: timeOutTimer
           running: false
           repeat: false
           interval: 3000
           onTriggered: {
               waitpopup.visible = false
           }
       }
   }

//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml
//   ListModel
//   {
//       id: popupLoadingMsg
//       ListElement{
//           msg: QT_TR_NOOP("STR_AHA_LOADING")
//       }
//   }
//   //hsryu_0131
//   DHAVN_AhaPopup_Loading
//   {
//       id: popupLoading
////wsuk.kim 131101 status bar dimming during to display popup.       y: 153 //hsryu_0523_change_loading_pos
//       opacity: 0.9 //hsryu_0523_change_loading_pos
//       visible: false;
//       message: popupLoadingMsg

////wsuk.kim 130822 ITS_0182104 exception loading popup.
//       Timer{
//           id: popupLoadingTimer
//           running: popupLoading.visible
//           repeat: false
//           interval: 10000
//           onTriggered:{
//               popupLoading.visible = false;
//               popupLoadingFail.visible = true;
//           }
//       }
////wsuk.kim 130822 ITS_0182104 exception loading popup.
//   }

//wsuk.kim 130822 ITS_0182104 exception loading popup.
//   ListModel
//   {
//       id: popupLoadingFailMsg
//       ListElement{
//           msg: QT_TR_NOOP("STR_AHA_LOADING_FAIL")
//       }
//   }

//   DHAVN_AhaPopup_Loading
//   {
//       id: popupLoadingFail
////wsuk.kim 131101 status bar dimming during to display popup.       y: 153
//       opacity: 0.9
//       visible: false;
//       message: popupLoadingFailMsg

//       Timer{
//           id: popupLoadingFailTimer
//           running: popupLoadingFail.visible
//           repeat: false
//           interval: 3000
//           onTriggered:{
//               popupLoadingFail.visible = false;
//               if(isStartListView === true) //wsuk.kim 130911 to return view(list or track) change after loading fail.
//               {
//                   isStartListView = false;
//                   handlePlayContent();
//               }
//           }
//       }
//   }
//wsuk.kim 130822 ITS_0182104 exception loading popup.

//wsuk.kim 131105 shift error popup move to AhaRadio.qml
//   POPUPWIDGET.PopUpText
//   {
//       id: shiftErrPopup
//       z: 1000
//       y: -PR.const_AHA_ALL_SCREENS_TOP_OFFSET //hsryu_change_new_popup_pos
//       icon_title: EPopUp.WARNING_ICON
//       visible: false
//       message: shiftErrorModel
//       buttons: btnmodel
//       focus_visible: /*isDialUI &&*/ shiftErrPopup.visible//wsuk.kim 130815 Remove isDialUI
//       property bool showErrorView;

//       function showPopup(text, errorView)
//       {
//           shiftErrPopup.showErrorView = errorView;
//           if(!visible)
//           {
//               shiftErrorModel.set(0,{msg:text})

//               visible = true;
//               //functionalTimer.start(); // by Ryu : ITS 0187776
//               shiftErrPopup.setDefaultFocus(0);
//           }
//       }

//       function hidePopup()
//       {
//           visible = false;
//           //functionalTimer.stop();  // by Ryu : ITS 0187776
//       }

//       onBtnClicked:
//       {
//           switch ( btnId )
//           {
//               case "OK":
//               {
//                   //functionalTimer.stop();    // by Ryu : ITS 0187776
//                   shiftErrPopup.visible = false
//               }
//               break;
//           }
//       }
//   }

//   ListModel
//   {
//       id: shiftErrorModel
//       ListElement
//       {
//           msg: ""
//       }
//   }

//   Timer{
//    id: functionalTimer
//    running: false
//    repeat: false
//    interval: 3000
//       onTriggered:{
//           shiftErrPopup.visible = false;
//             if(shiftErrPopup.showErrorView && ahaController.state !== "ahaContentListView")
//             {
//              ahaController.state = "ahaContentListView"
//             }
//       }
//   }
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml

//wsuk.kim 130808 ITS_0181039 focus flicking
   Timer
   {
       id: flickCurrentFocusIndex
       interval: 100
       running: false

       onTriggered:
       {
           if(focus_index !== contentItemListView.currentIndex)
           {
               focus_index = contentItemListView.currentIndex;
               contentItemListView.positionViewAtIndex(focus_index, ListView.Contain);
           }
       }
   }
//wsuk.kim 130808 ITS_0181039 focus flicking

//wsuk.kim 131001 Press&Hold JOG up/down, fast scrolling.
   Timer
   {
       id: pressHoldJOGUpDown
       interval: 20
       running: false
       repeat: true
       triggeredOnStart: true
       property int lastPressed: -1

       onTriggered:
       {
           if(lastPressed === UIListenerEnum.JOG_UP)
               focusPrev(PR.const_AHA_JOG_EVENT_ARROW_UP);
           else if(lastPressed === UIListenerEnum.JOG_DOWN)
               focusNext(PR.const_AHA_JOG_EVENT_ARROW_DOWN);
       }
   }
//wsuk.kim 131001 Press&Hold JOG up/down, fast scrolling.
}
