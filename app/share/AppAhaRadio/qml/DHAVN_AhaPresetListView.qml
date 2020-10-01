import Qt  4.7
//UNUSED    import QmlModeAreaWidget 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES
import QmlSimpleItems 1.0
import AhaMenuItems 1.0
import QmlOptionMenu 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET


Item {
    id: ahaPresetListView
    visible: true

    width: parent.width;
    height: parent.height;
    //QML Properties Declaration
    property int counter: PR.const_AHA_TIMER_COUNTER_MIN_VAL
    property int count: 0
    property int focus_index: -1
    property variant activeList:null
    property bool hideMenu: true
    property bool focus_visible: false
    property bool isWaitpopupVisible : waitpopup.visible
    property int nTotalCount: 0 //wsuk.kim station_jog
    property bool isDRSTextScroll: UIListener.getDRSTextScrollState()    //wsuk.kim text_scroll
    property bool isPlayingAnimation: true
    property bool isCenterPressed: false    //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
    property bool isTouchPressed: false    //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
    property bool isPresetListEmpty: false    //wsuk.kim 131029 preset list empty, handling focus in preset list.
    property bool isMoving: false    // added 2014.03.05 drag performance

    signal handlePresetSelectionEvent()
    signal handlePresetContentSelectionEvent(int contentIndex)
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    signal handlePresetBackRequest()
    signal handlePlayPreset() //hsryu_0524_select_same_content
    signal showLoadingPopup()
    signal hideLoadingPopup()

    //hsryu_0423_block_play_btcall
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    signal handleShowBtBlockPopup(int jogCenter)

    signal presetLostFocus(int arrow, int status);
    signal handlePresetFocusAfterFlicking();    //wsuk.kim 131122 ITS_210529 focus move on list after flicking.

    function showPopup(text)
    {
        waitpopup.showPopup(text);
    }

    /***************************************************************************/
    /**************************** Aha Qt connections START *****************/
    /***************************************************************************/

    Connections
    {
        target:ahaStationList

        onModelPresetReady:
        {
            hideLoadingPopup();
//wsuk.kim 130724 ITS_0181039 focus flicking
            if(model_index === -1)
            {
                presetItemListView.currentIndex = 0;
            }
            else
//wsuk.kim 130724 ITS_0181039 focus flicking
            {
                presetItemListView.currentIndex = model_index;
            }
            presetItemListView.positionViewAtIndex(model_index, presetItemListView./*Center*/Contain)   //wsuk.kim 130724 ITS_0181039 focus flicking
//wsuk.kim 131023 ITS_197367 exception no focus in station list.            stateFocusVisible();

            if(nStationCount === 0)   //wsuk.kim 131029 preset list empty, handling focus in preset list.
            {
                isPresetListEmpty = true;
            }
            else
            {
                isPresetListEmpty = false;
                nTotalCount = nStationCount;
            }
        }
    }

    Connections
    {
        //hsryu_0423_block_play_btcall
        target: (ahaPresetListView.focus_visible && ahaPresetListView.visible /*&& !btBlockPopupVisible*/ &&!networkErrorPopupVisible /*&&!isShiftErrPopupVisible*/ &&!popUpTextVisible) ? UIListener:null

        //hsryu_0423_block_play_btcall
        //hsryu_0502_jog_control
//        onSignalJogCenterClicked:
//        {
//            handleCenterKey();
//        }

        onSignalJogNavigation:
        {
            if(popupVisible || isLoadingPopupVisible)
            {
                return;
            }

            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }
//wsuk.kim 130903 menu hide to change jog left from press to releas.
//            if(isHideMenuLeft)
//            {
//                isHideMenuLeft = false;
//                return;
//            }

            if((qmlProperty.getFocusArea() === PR.const_STATION_LIST_PRESET_LIST_FOCUS) &&
               (status === UIListenerEnum.KEY_STATUS_PRESSED //hsryu_0502_jog_control
                /*0428|| arrow === UIListenerEnum.JOG_WHEEL_LEFT
                || arrow === UIListenerEnum.JOG_WHEEL_RIGHT*/))
            {
                if(arrow === UIListenerEnum.JOG_CENTER) //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
                {
                    handleCenterKeyPressed();
                }
                else if(arrow === UIListenerEnum.JOG_WHEEL_LEFT || arrow === UIListenerEnum.JOG_WHEEL_RIGHT)    //wsuk.kim 131001 HK JOG Relesed, work to JogEvent.
                {
                    handleJogEvent(arrow,status);
                }
            }
            else if((qmlProperty.getFocusArea() === PR.const_STATION_LIST_PRESET_LIST_FOCUS) &&
                (status === UIListenerEnum.KEY_STATUS_LONG_PRESSED))  //wsuk.kim 131001 Press&Hold JOG up/down, fast scrolling.
            {
                if(arrow === UIListenerEnum.JOG_UP || arrow === UIListenerEnum.JOG_DOWN)
                {
                    pressHoldJOGUpDown.lastPressed = arrow;
                    pressHoldJOGUpDown.start();
                }
            }
            else if((qmlProperty.getFocusArea() === PR.const_STATION_LIST_PRESET_LIST_FOCUS) &&
               (status === UIListenerEnum.KEY_STATUS_RELEASED)) //hsryu_0502_jog_control
            {
                if(pressHoldJOGUpDown.running)  //wsuk.kim 131001 Press&Hold JOG up/down, fast scrolling.
                {
                    pressHoldJOGUpDown.lastPressed = -1;
                    pressHoldJOGUpDown.stop();
                    return;
                }

                if(arrow === UIListenerEnum.JOG_CENTER)
                {
                    handleCenterKey();
                }
                else if(arrow === UIListenerEnum.JOG_LEFT || arrow === UIListenerEnum.JOG_UP)    //wsuk.kim 131001 HK JOG Relesed, work to JogEvent.
                {
                    handleJogEvent(arrow,status);
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
            isPlayingAnimation = isPlayAnimation;
        }
    }

    Connections
    {
        target: ahaMenus
        onMenuDataChanged:
        {
            optMenu.menumodel = ahaMenus.optListMenuModel
        }
    }

//TEST    Connections
//    {
//        target: listModeAreaWidget.focus_visible?UIListener:null
//        onSignalJogCenterPressed:
//        {
//            isJogEventinModeArea = true;
//        }

//        onSignalJogNavigation:
//        {
//            if(status === UIListenerEnum.KEY_STATUS_PRESSED)
//            isJogEventinModeArea = true;
//        }
//    }

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
//wsuk.kim station_jog

    Component.onCompleted: {
        activePresetJogDial = ahaPresetListView;
//        handleForegroundEvent();
    }

    onVisibleChanged:   //wsuk.kim 131224 ITS_217070 Press hold when disp change from on to off.
    {
        if(ahaPresetListView.visible)
        {
            isCenterPressed = false;
        }
    }

    Connections
    {
        target: ahaController

        onBackground:
        {
            isTouchPressed = false;
            isCenterPressed = false;
        }
    }

//wsuk.kim station_jog TEST
//    Connections{
//        target: ahaController
//        onIsDialUIChanged: {
//            if(!isDialUI)
//            {
//                ahaPresetListView.focus_visible = false;    //wsuk.kim station_jog_touch
//            }
//            else
//            {
//                ahaPresetListView.focus_visible = true;    //wsuk.kim station_jog_touch
//            }
//        }
//    }
//wsuk.kim station_jog TEST

    Component
    {
        id: listItemDelegate
        Column
        {
            id:presetItemColumn
            Rectangle
            {
                id:id_border
                x:0
                height: PR.const_AHA_PRESET_LIST_VIEW_ROW_HEIGHT_WITHBORDER
                width: PR.const_AHA_PRESET_LIST_VIEW_WIDTH
                visible: true
                color: PR.const_AHA_STATION_LIST_VIEW_COLUMN_COLOR

                Image{
                    id: bg
                    height: PR.const_AHA_PRESET_LIST_VIEW_ROW_HEIGHT_WITHBORDER_FOCUS
                    width: PR.const_AHA_PRESET_LIST_VIEW_BORDER_WIDTH
                    source: ""
                }

//wsuk.kim station_jog
                BorderImage {
                    id: borderImage
                    source: isCenterPressed? PR_RES.const_APP_AHA_LIST_VIEW_ITEM_RELEASED : (isTouchPressed? "" : PR_RES.const_APP_AHA_LIST_VIEW_ITEM_BORDER_IMAGE)    //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
                    height: PR.const_AHA_PRESET_LIST_VIEW_ROW_HEIGHT_WITHBORDER_FOCUS
                    width: PR.const_AHA_PRESET_LIST_VIEW_BORDER_WIDTH
                    visible: focus_visible && (focus_index === index)
                }
//wsuk.kim station_jog
                //hsryu_0201
                AnimatedImage
                {
                    id: icon_current_playing
                    source: PR_RES.const_APP_AHA_TRACK_PLAY;
                    anchors.right: quickMixImage.left
                    //hsryu_0313_fix_animation_pos
                    //anchors.top: quickMixImage.top
                    //anchors.topMargin: PR.const_AHA_STATION_LIST_VIEW_CURRENTPLAYING_IMAGE_TOPMARGIN
                    anchors.verticalCenter: parent.verticalCenter
                    width: PR.const_AHA_STATION_LIST_VIEW_CURRENTPLAYING_IMAGE_WIDTH
                    //playing: (isSelectStatus && isPlayStatus && isPlayingAnimation && !isMoving)  // modified 2014.03.05
                    playing: (ahaTrack.TrackStatus() === 1 && !isMoving)    //ITS_0226514, 0225964
                    visible: (isSelectStatus)
                }

                Image{
                    id: quickMixImage
                    width: PR.const_AHA_STATION_LIST_VIEW_THUMBNAIL_IMAGE_WIDTH
                    height: PR.const_AHA_STATION_LIST_VIEW_THUMBNAIL_IMAGE_HEIGHT
                    visible: (ahaController.state === "ahaStationListView") ? true: false //wsuk.kim list_view
                    //hsryu_0312_cahnge_bg_station
                    //fillMode: Image.PreserveAspectCrop
                    // asynchronous : true
                    //clip:true

                    //hsryu_0312_cahnge_bg_station
                    sourceSize.width: PR.const_AHA_STATION_LIST_VIEW_THUMBNAIL_IMAGE_WIDTH
                    sourceSize.height: PR.const_AHA_STATION_LIST_VIEW_THUMBNAIL_IMAGE_HEIGHT
                    source: (imagePath === "null") ? PR_RES.const_APP_AHA_LIST_VIEW_ICON_STATION_IMG : imagePath
                    anchors.left: parent.left
                    anchors.leftMargin: PR.const_AHA_STATION_LIST_TRACK_QUICKMIX_IMAGE_LFET_MARGIN
                    anchors.verticalCenter: parent.verticalCenter

                    onStatusChanged:
                    {
                        if(status === Image.Error)
                        {
                            source = PR_RES.const_APP_AHA_LIST_VIEW_ICON_STATION_IMG;
                        }
                    }
                }

//wsuk.kim text_scroll
                DHAVN_AhaTextScroll
                {
                    text: name

                    fontSize: PR.const_AHA_STATION_LIST_VIEW_TRACKITEM_TEXT_FONT_POINTSZIE
                    fontFamily: (isSelectStatus) ? PR.const_AHA_FONT_FAMILY_HDB: PR.const_AHA_FONT_FAMILY_HDR   //wsuk.kim 130930 selected item, change from HDR to HDB.
//                    horizontalAlignment: Text.AlignLeft
                    color: ((focus_index !== index && isSelectStatus) ||
                              (focus_index === index && !focus_visible && isSelectStatus)) ? PR.const_AHA_COLOR_TEXT_CURR_STATION: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY  //modified ITS 224194 //wsuk.kim 131203 ITS_212562 selected-focus color change bright grey.
                    anchors.verticalCenter: parent.verticalCenter

                    x: (quickMixImage.visible === true) ? PR.const_AHA_STATION_LIST_VIEW_TRACKITEM_TEXT_X : PR.const_AHA_STATION_LIST_VIEW_TRACK_IMAGE_LFET_MARGIN
                    width: PR.const_AHA_PRESET_LIST_VIEW_TRACKITEM_TEXT_WIDTH
                    scrollingTicker: (focus_index === index && isDRSTextScroll && focus_visible)? true: false   //wsuk.kim 131016 focus visible is false, remain text scroll.
                }
//wsuk.kim text_scroll                Text
//                {
//                    id: id_text
//                    text: name
//                    elide: Text.ElideRight
//                    font.pixelSize: PR.const_AHA_STATION_LIST_VIEW_TRACKITEM_TEXT_FONT_POINTSZIE
//                    font.family: PR.const_AHA_FONT_FAMILY_HDR //hsryu_0315_change_text_format
//                    horizontalAlignment: Text.AlignLeft
//                    color: (isSelectStatus) ? PR.const_AHA_COLOR_TEXT_CURR_STATION: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY
////wsuk.kim list_view
//                    anchors.verticalCenter: parent.verticalCenter // quickMixImage.verticalCenter
//                    x: (quickMixImage.visible === true) ? PR.const_AHA_STATION_LIST_VIEW_TRACKITEM_TEXT_X : PR.const_AHA_STATION_LIST_VIEW_TRACK_IMAGE_LFET_MARGIN
////wsuk.kim list_view
//                    width: PR.const_AHA_PRESET_LIST_VIEW_TRACKITEM_TEXT_WIDTH;
//                }

                Image  // modified ITS 228397
                {
                    id:listline
                    source: PR_RES.const_APP_AHA_LIST_VIEW_ITEM_LIST_LINE
                    visible: true
                    anchors.top: parent.bottom
                    anchors.left: parent.left
                    width: PR.const_AHA_PRESET_LIST_VIEW_BORDER_WIDTH
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
                        //activeList.mouseStarty = mouse.y;
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
                        //hsryu_0423_block_play_btcall
                        if(UIListener.IsCallingSameDevice())
                        {
                            UIListener.OSDInfoCannotPlayBTCall();
                            return;
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//                            if(isSelectStatus)
//                            {
//                                handlePresetBackRequest();
//                            }
//                            else
//                            {
//                                handleShowBtBlockPopup(0);
//                                return;
//                            }
                        }

                        //ITS_0222266
                        if(isLoadingPopupVisible || networkErrorPopupVisible) return;   //wsuk.kim 131108 ITS_207360 popup unity, change to toast popup.

                        presetItemListView.currentIndex = index;

                        //hsryu_0305_trackview_top
                        ahaController.noActiveStation = false;
                        if(!isSelectStatus)
                        {
                            //hsryu_0326_like_dislike
                            ahaTrack.ClearCurrentLikeDislike();
                            showLoadingPopup();
                            ahaStationList.selectPresetID(appID);
                            handlePresetSelectionEvent();
                        }
                        else
                        {
                            // On selection of active station, simply switch the view
                            if(ahaController.listViewIsTopMost)
                            {
                                handlePresetSelectionEvent();
                            }
                            else
                            {
                                handlePlayPreset(); //hsryu_0524_select_same_content
                                //handlePresetBackRequest();
                            }
                        }
                    }

                    onCanceled:
                    {
                        if(borderImage.visible) //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
                        {
                            isTouchPressed = false;
                        }
                        bg.source = ""// PR_RES.const_APP_AHA_LIST_VIEW_ITEM_RELEASED
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

    //hsryu_0121
    ListView
    {
        id: presetItemListView

        model: modelPreset
        delegate: listItemDelegate
        visible: isPresetListEmpty? false: true //wsuk.kim 131029 preset list empty, handling focus in preset list.
        anchors.fill: parent
        anchors.left: parent.left

//wsuk.kim 130724 ITS_0181039 focus flicking
        currentIndex: 0
        clip: true
        snapMode: isMoving ? ListView.SnapToItem : ListView.NoSnap // modified 2014.03.05
        highlightMoveDuration: 1
//wsuk.kim 130724 ITS_0181039 focus flicking

        Component.onCompleted:
        {
            if(ahaStationList.getPresetIndex() === -1)
            {
                //wsuk.kim 130724 ITS_0181039 focus flicking   presetItemListView.currentIndex = ahaStationList.getPresetIndex();
                //wsuk.kim 130724 ITS_0181039 focus flicking   focus_index = 0;
                presetItemListView.currentIndex = focus_index = 0;  //wsuk.kim 130724 ITS_0181039 focus flicking
            }
            else
            {
                presetItemListView.currentIndex = focus_index = ahaStationList.getPresetIndex();
            }
            presetItemListView.positionViewAtIndex(presetItemListView.currentIndex, presetItemListView./*Center*/Contain);  //wsuk.kim 130724 ITS_0181039 focus flicking
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
//wsuk.kim 130724 ITS_0181039 focus flicking
        onMovementEnded:
        {
            handlePresetFocusAfterFlicking();   //wsuk.kim 131122 ITS_210529 focus move on list after flicking.
            isMoving = false; // added 2014.03.05 drag performance
            currentIndex = indexAt ( 10, Math.floor(contentY + 10) );
        }
        onMovementStarted:  // added 2014.03.05 drag performance
        {
            isMoving = true;
        }
        onCurrentIndexChanged:
        {
            if(focus_index +1 <= currentIndex)  //if(focus_index +1 === currentIndex)
            {
                flickCurrentFocusIndex.restart();
            }
            else if(focus_index - currentIndex >= 6)   //else if((focus_index - currentIndex === 6) && (currentIndex%6 === focus_index%6))
            {
                flickCurrentFocusIndex.restart();
            }
        }
//wsuk.kim 130724 ITS_0181039 focus flicking

    }

//wsuk.kim 131029 preset list empty, handling focus in preset list.
    Text
    {
        id: noPresetList
        y: PR.const_AHA_CONNECTING_WAIT_TEXT2_Y_OFFSET
        color: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: PR.const_AHA_PRESET_LIST_VIEW_WIDTH

        text: qsTranslate("main", "STR_AHA_STATION_LIST_EMPTY");
        font.pixelSize: PR.const_AHA_FONT_SIZE_TEXT_HDR_40_FONT
        font.family: PR.const_AHA_FONT_FAMILY_HDR
        visible: isPresetListEmpty? true: false
    }
//wsuk.kim 131029 preset list empty, handling focus in preset list.

    /***************************************************************************/
    /**************************** Private functions START **********************/
    /***************************************************************************/

    // handles foreground event
    function handleForegroundEvent ()
    {
        showLoadingPopup();
    }

    function stateFocusVisible()
    {
        focus_visible = false;

        if(qmlProperty.getFocusArea() === PR.const_STATION_LIST_PRESET_LIST_FOCUS)
        {
            focus_visible = true;
        }
    }

    function hideFocus()
    {
//        focus_visible = false
    }

    function showFocus()
    {
//        focus_visible = true;
    }

    function showWaitNote()
    {
//        ahaPresetListView.focus_visible = false;
        alphabeticList.visible = false;
        activeList.visible = false;
        showLoadingPopup();
    }

    function handleJogEvent( arrow, status )
    {
        if(isDialUI)
        {
            switch(arrow)
            {
//wsuk.kim jog_group            case PR.const_AHA_JOG_EVENT_ARROW_DOWN:
            case PR.const_AHA_JOG_EVENT_WHEEL_RIGHT:
                focusNext(PR.const_AHA_JOG_EVENT_ARROW_DOWN);
                break;
            case PR.const_AHA_JOG_EVENT_ARROW_UP:
                ahaPresetListView.presetLostFocus(arrow, status);   //wsuk.kim jog_group
                stateFocusVisible();
                break;
            case PR.const_AHA_JOG_EVENT_WHEEL_LEFT:
                focusPrev(PR.const_AHA_JOG_EVENT_ARROW_UP); //wsuk.kim jog_group
//                if(!focusPrev(PR.const_AHA_JOG_EVENT_ARROW_UP))
//                {
//                    ahaPresetListView.presetLostFocus(arrow, status);
//                    stateFocusVisible();
//                }
                break;
//hsryu_0423_block_play_btcall
//            case PR.const_AHA_JOG_EVENT_CENTER:
//                handleCenterKey();
//                break;
//wsuk.kim station_jog
            case PR.const_AHA_JOG_EVENT_ARROW_LEFT:
                ahaPresetListView.presetLostFocus(arrow, status);
                stateFocusVisible();
                break;
//wsuk.kim station_jog
            }
        }
        else
        {
            isDialUI = true;
//            focus_index = ahaStationList.getPresetIndex();
//            presetItemListView.positionViewAtIndex(focus_index,ListView.Contain);
        }
    }

    function focusNext( arrow )
    {
        var eventHandled = false;
        if(presetItemListView.flicking) return; //wsuk.kim 131122 ITS_210551 to move focus at CCP wheeling during flicking.
//wsuk.kim TUNE_LOOP
        if(focus_index < nTotalCount -1)
        {
            //modified ITS 225406
            if(focus_index == presetItemListView.indexAt ( 10, Math.floor(presetItemListView.contentY + 500) ))
            {
                presetItemListView.positionViewAtIndex(focus_index + 1, ListView.Beginning);
            }
            else
            {
                presetItemListView.positionViewAtIndex(focus_index + 1, ListView.Contain);
            }
            focus_index += 1;
            eventHandled = true;
        }
        else
        {
            if(nTotalCount > PR.const_AHA_STATION_LIST_LOOPING_HOLD)  //wsuk.kim 130902 ISV_90201 hold on looping that under 1 page.
            {
                if(pressHoldJOGUpDown.lastPressed !== UIListenerEnum.JOG_DOWN) //wsuk.kim 131001 Press&Hold JOG up/down, fast scrolling.
                {
                    focus_index = 0;
                    eventHandled = true;
                    presetItemListView.positionViewAtIndex(focus_index,ListView.Contain);
                }
            }
        }
        ahaStationList.setStationListFocusIndex(focus_index);  //wsuk.kim TUNE
//wsuk.kim TUNE_LOOP
//            else
//            {
//                if(ahaStationList.IsNextItemExist())
//                {
//                    showLoadingPopup();
//                    ahaStationList.GetNextStationList(ListReqType.ENEXTLIST);
//                    focus_index++;
//                }
//                else
//                {
//                    if(ahaStationList.GetTotalStationsCount() === nTotalCount)
//                    {
//                        focus_index = 0;
////                        activeList.positionViewAtIndex(focus_index,ListView.Contain);
//                        presetItemListView.positionViewAtIndex(focus_index,ListView.Contain);
//                        eventHandled = true;
//                    }
//                }
//            }
        return eventHandled;
    }

    function focusPrev( arrow )
    {
        var eventHandled = false;
        if(presetItemListView.flicking) return; //wsuk.kim 131122 ITS_210551 to move focus at CCP wheeling during flicking.
//wsuk.kim TUNE_LOOP
        if(focus_index > 0)
        {
            //modified ITS 225406
            if(focus_index == presetItemListView.indexAt ( 10, Math.floor(presetItemListView.contentY + 10) ))
            {
                presetItemListView.positionViewAtIndex(focus_index - 1, ListView.End);
            }
            else
            {
                presetItemListView.positionViewAtIndex(focus_index - 1, ListView.Contain);
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
                    presetItemListView.positionViewAtIndex(focus_index,ListView.Contain);
                }
            }
        }
        ahaStationList.setStationListFocusIndex(focus_index);  //wsuk.kim TUNE
//wsuk.kim TUNE_LOOP
        return eventHandled;
    }

    function handleCenterKey()
    {
        isCenterPressed = false;    //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
        //hsryu_0423_block_play_btcall
        if(UIListener.IsCallingSameDevice())
        {
            UIListener.OSDInfoCannotPlayBTCall();
            return;
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//            if(ahaStationList.getPresetIndex() === focus_index)  //wsuk.kim 130724 ITS_0181039 focus flicking   if(presetItemListView.currentIndex === focus_index)
//            {
//                handlePresetBackRequest();
//            }
//            else
//            {
//                handleShowBtBlockPopup(1);
//                return;
//            }
        }

        ahaController.noActiveStation = false;

        if(ahaStationList.getPresetIndex() !== focus_index)  //wsuk.kim 130724 ITS_0181039 focus flicking   if(presetItemListView.currentIndex !== focus_index)
        {
            //hsryu_0326_like_dislike
            ahaTrack.ClearCurrentLikeDislike();
            showLoadingPopup();
            ahaStationList.selectPresetIndex(focus_index);
            handlePresetSelectionEvent();
        }
        else
        {
            if(UIListener.IsRunningInBG() && ahaStationList.checkSameStationId(ahaStationList.getPresetIndex())) //wsuk.kim 131104 displayed at OSD control by tune.
            {
                UIListener.OSDTrackInfo();
                return;
            }

            if(ahaController.listViewIsTopMost)
            {
                handlePresetSelectionEvent();
            }
            else
            {
                handlePlayPreset(); //hsryu_0524_select_same_content
                //handlePresetBackRequest();
            }
        }
    }

    function handleCenterKeyPressed()   //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
    {
        isCenterPressed = true;
    }

//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//    //hsryu_0423_block_play_btcall
//    function handleTuneCenterKeyForBT()
//    {
//        UIListener.OSDInfoCannotPlayBTCall();
//        if(ahaStationList.getPresetIndex() === focus_index)  //wsuk.kim 130724 ITS_0181039 focus flicking   if(presetItemListView.currentIndex === focus_index)
//        {
//            handlePresetBackRequest();
//        }
//        else
//        {
//            handleShowBtBlockPopup(0);
//        }
//    }

    /***************************************************************************/
    /**************************** Private functions END **********************/
    /***************************************************************************/

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

//wsuk.kim 130724 ITS_0181039 focus flicking
    Timer
    {
      id: flickCurrentFocusIndex
      interval: 100
      running: false

      onTriggered:
      {
          if(focus_index !== presetItemListView.currentIndex)
          {
              focus_index = presetItemListView.currentIndex;
              presetItemListView.positionViewAtIndex(focus_index, ListView.Contain);
          }
      }
    }
//wsuk.kim 130724 ITS_0181039 focus flicking

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
