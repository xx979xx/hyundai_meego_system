import Qt 4.7
import QmlModeAreaWidget 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES
import QmlSimpleItems 1.0
import AhaMenuItems 1.0
import QmlOptionMenu 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET

// Because Loader is a focus scope, converted from FocusScope to Item.
Item {
    id: ahaStationListView
    width: PR.const_AHA_ALL_SCREEN_WIDTH
    height: PR.const_AHA_CONNECTING_SCREEN_HEIGHT
    y: PR.const_AHA_ALL_SCREENS_TOP_OFFSET
    anchors.bottomMargin: PR.const_AHA_ALL_SCREEN_BOTTOM_MARGIN
    visible: true

    //SportsLabelDefinition {id: sportsLabel }
    property string selectedList:"Preset"
    property string szSelectMode:"Preset"
    property int level: 0
    property int nFocusPosition: 0  //wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
//wsuk.kim 130917 ITS_190542 jog focus movement at left menu group.    property int leftMenuBtn1Focused: 0       //wsuk.kim leftmenu_jog
    property bool isJogEventinModeArea: false //wsuk.kim station_jog
    property bool hideMenu: true
    property bool loadStaion: false //hsryu_0613_fail_load_station
    property bool isDRSTextScroll: UIListener.getDRSTextScrollState()    //wsuk.kim 130909 Menu text scllor ticker
    property alias isOptionsMenuVisible: optMenu.visible
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml    property alias isLoadingPopupVisible: popupLoading.visible
    property alias leftMenuButton1Focus : idLeftMenuFocusScope.button1FocusVisible
    property alias leftMenuButton2Focus : idLeftMenuFocusScope.button2FocusVisible
//wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob
    property alias leftMenuButton1Press : idLeftMenuFocusScope.button1Press
    property alias leftMenuButton2Press : idLeftMenuFocusScope.button2Press
//wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob

//TEST    property alias  presetTotal : idPreset.nTotalCount  //wsuk.kim TOTAL_COUNT

    property bool isHideMenuLeft: false

    //hsryu_0329_system_popup
    property bool stationNowLoading : false
//wsuk.kim 131105 shift error popup move to AhaRadio.qml    property bool isShiftErrPopupVisible: shiftErrPopup.visible //wsuk.kim 130930 ITS_191996 SEEK/TRACK

    signal handleSelectionEvent();
    signal handleBackRequest();
    signal handlePlayStation();  //hsryu_0524_select_same_content
    signal leftLostFocus(int arrow, int status);    //wsuk.kim leftmenu_jog
    signal handlShowFailLoadStationList(); //hsryu_0613_fail_load_station
    signal handleShowErrorPopup(int reason);  //wsuk.kim 131105 shift error popup move to AhaRadio.qml

    //hsryu_0423_block_play_btcall
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    signal showBtBlockPopup(int jogCenter);

    function handleMenuKey(isJogMenuKey)
    {
        isDialUI = isJogMenuKey;
        qmlProperty.setFocusArea(PR.const_STATION_LIST_TITLE_FOCUS);

        if( ahaStationListView !== null && ahaStationListView.visible)
        {
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            if(!isLoadingPopupVisible/*!popupLoading.visible*/)
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

                    stationModeAreaWidget.hideFocus();  //wsuk.kim station_jog
//                        ahaStationListView.showFocus();
                    if(focus_index === -1)
                    {
                        focus_index = 0;
                        activeList.positionViewAtIndex(focus_index,ListView.Beginning);
                    }
                }
                else
                {
                    stationModeAreaWidget.hideFocus();  //wsuk.kim station_jog
                    ahaStationListView.hideFocus();
                    ahaStationListView.stateLeftMenuBtnFocus();

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

    Connections
    {
        target:ahaStationList

        onModelStationNowListenning:
        {
            ahaMenus.optListMenuModel.itemEnabled(MenuItems.NowListening, isPlay);
        }
    }

    FocusScope{
        id:idCenterFocusScope
        y:0;
        width:parent.width;
        height: parent.height-y;

        FocusScope{
            id:idMainMenuAndListFocusScope
            y:PR.const_AHA_MODE_ITEM_HEIGHT - 10;
            width:parent.width;
            height: parent.height-y;

            DHAVN_AhaStationLeftMenuGroup{
                id:idLeftMenuFocusScope
                x:0; y:0;
                countOfButton: 2;

                button1Text: qsTranslate("main","STR_AHA_PRESET");
                button1Active: szSelectMode === "Preset"
                onButton1Clicked: {
                    if(!isLoadingPopupVisible)
                    {
                        if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                        {
                            toastPopupVisible = false;
                        }
                        selectPreset();
                        stationModeAreaWidget.hideFocus();  //wsuk.kim station_touch
//wsuk.kim 131115 ITS_209347 after click left menu, focus move to list.
                        qmlProperty.setFocusArea(PR.const_STATION_LIST_PRESET_LIST_FOCUS);
                        ahaStationListView.showFocus();
//                        qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS); //wsuk.kim focus_remain
//                        ahaStationListView.hideFocus(); //wsuk.kim focus_remain
//wsuk.kim 131115 ITS_209347 after click left menu, focus move to list.
                        ahaStationListView.stateLeftMenuBtnFocus();
                    }
                }

                //hsryu_0522_change_LBS_Nearby
                button2Text: qsTranslate("main","STR_AHA_NEARBY");
                button2Active: szSelectMode === "LBS"
                onButton2Clicked: {
                    if(!isLoadingPopupVisible)
                    {
                        if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                        {
                            toastPopupVisible = false;
                        }
                        selectLBS();
                        stationModeAreaWidget.hideFocus();  //wsuk.kim station_touch
//wsuk.kim 131115 ITS_209347 after click left menu, focus move to list.
                        qmlProperty.setFocusArea(PR.const_STATION_LIST_LBS_LIST_FOCUS);
                        ahaStationListView.showFocus();
//                        qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS); //wsuk.kim focus_remain
//                        ahaStationListView.hideFocus(); //wsuk.kim focus_remain
//wsuk.kim 131115 ITS_209347 after click left menu, focus move to list.
                        ahaStationListView.stateLeftMenuBtnFocus();
                    }
                }
            }
            //Main Menu Right List
            FocusScope{
                id:idStationListArea
                x:idLeftMenuFocusScope.width;
                width:parent.width - idLeftMenuFocusScope.width
                height:parent.height;

                DHAVN_AhaPresetListView{
                    id:idPreset
                    x:0
                    y:0
                    width:parent.width
                    height:parent.height;
                    visible:szSelectMode === "Preset";

                    onPresetLostFocus:
                    {
                        if(arrow === UIListenerEnum.JOG_LEFT)
                        {
                            qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS);
                            stationModeAreaWidget.hideFocus();
                            ahaStationListView.stateLeftMenuBtnFocus();
                        }
                        else if(arrow === UIListenerEnum.JOG_UP)
                        {
                            qmlProperty.setFocusArea(PR.const_STATION_LIST_TITLE_FOCUS);
                            stationModeAreaWidget.showFocus();
                            if(stationModeAreaWidget.focus_index === -1)
                            {
                                stationModeAreaWidget.setDefaultFocus(arrow);
                            }
                        }
                    }
//wsuk.kim station_jog
                    function show(){
                        idMainMenuAndListFocusScope.focus = true;
                        idStationListArea.focus = true;
                    }
                }

                DHAVN_AhaLBSListView{
                    id:idLBS
                    x:0
                    y:0
                    width:parent.width
                    height:parent.height;
                    visible:szSelectMode === "LBS";

//wsuk.kim station_jog
                    onLbsLostFocus:
                    {
                        if(arrow === UIListenerEnum.JOG_LEFT)
                        {
                            qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS);
                            stationModeAreaWidget.hideFocus();
                            ahaStationListView.stateLeftMenuBtnFocus();
                        }
                        if(arrow === UIListenerEnum.JOG_UP)
                        {
                            qmlProperty.setFocusArea(PR.const_STATION_LIST_TITLE_FOCUS);
                            stationModeAreaWidget.showFocus();
                            if(stationModeAreaWidget.focus_index === -1)
                            {
                                stationModeAreaWidget.setDefaultFocus(arrow);
                            }
                        }
                    }
//wsuk.kim station_jog
                    function show(){
                        idMainMenuAndListFocusScope.focus = true;
                        idStationListArea.focus = true;
                    }
                }

                Component.onCompleted:
                {
                    loadStaion=true; //hsryu_0613_fail_load_station
                    showLoadingPopup();
                    activeView = ahaStationListView;    //wsuk.kim station_back
                    ahaStationList.requestStationList();
                    if(ahaStationList.getLastSelectedStation() === "PRESET")
                    {
                        selectPreset();
                    }
                    else if(ahaStationList.getLastSelectedStation() === "LBS")
                    {
                        selectLBS();
                    }
                    ahaStationListView.showFocus(); //wsuk.kim 131023 ITS_197367 exception no focus in station list.
                }

                onVisibleChanged:   //wsuk.kim 131224 ITS_217070 Press hold when disp change from on to off.
                {
                    if(ahaStationListView.visible)
                    {
                        leftMenuButton1Press = false;
                        leftMenuButton2Press = false;
                    }
                }
            }
        } //idMainMenuAndListFocusScope
    }

    /***************************************************************************/
    /**************************** Aha QML connections START ********************/
    /***************************************************************************/
    Connections{
        target: (!popupVisible && !isLoadingPopupVisible/*!popupLoading.visible*/ && !networkErrorPopupVisible /*&&!isShiftErrPopupVisible*/ && !popUpTextVisible) ? UIListener:null

        onMenuKeyPressed:
        {
            handleMenuKey(isJogMenuKey);
        }

        onSignalJogNavigation:
        {
            if(status === UIListenerEnum.KEY_STATUS_PRESSED &&
                (arrow === UIListenerEnum.JOG_WHEEL_LEFT || arrow === UIListenerEnum.JOG_WHEEL_RIGHT || arrow === PR.const_AHA_JOG_EVENT_CENTER))
            {
//wsuk.kim 130903 menu hide to change jog left from press to releas.
//                if((optMenu.visible)&&(qmlProperty.getFocusArea() === PR.const_STATION_LIST_TITLE_FOCUS))
//                {
//                    if(arrow === PR.const_AHA_JOG_EVENT_ARROW_LEFT)
//                    {
//                        //optMenu.visible = false;
//                        optMenu.quickHide();
//                        optMenu.hideFocus();
//                        for(var i = 0; i < ahaMenus.optListMenuModel.levelMenu; i++)
//                        {
//                            ahaMenus.optListMenuModel.backLevel();
//                        }
//                        if(isDialUI)
//                        {
//                            stationModeAreaWidget.hideFocus();
//                            ahaStationListView.showFocus();
//                            isHideMenuLeft = true;
//                        }
//                    }
//                    else
//                    {
//                        ahaStationListView.hideFocus();
//                        if(!optMenu.focus_visible)
//                        {
//                            optMenu.showFocus();
//                            if(isDialUI)
//                            {
//                                optMenu.setDefaultFocus(0);
//                            }
//                        }
//                    }
//                }
//                else
                if(!optMenu.visible)
                {
                    if((qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS) || (qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS))
                    {
                        handleJogEvent(arrow,status);
                    }
                }
            }
//wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob
            else if(/*arrow === PR.const_AHA_JOG_EVENT_CENTER && */status === UIListenerEnum.KEY_STATUS_RELEASED)
            {
                if(arrow === UIListenerEnum.JOG_CENTER)
                {
                    if((qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS) || (qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS))
                    {
                        leftMenuButton1Press = false;
                        leftMenuButton2Press = false;

                        if(leftMenuButton1Focus === true)
                        {
                            selectPreset();
//wsuk.kim 131115 ITS_209347 after click left menu, focus move to list.
                            qmlProperty.setFocusArea(PR.const_STATION_LIST_PRESET_LIST_FOCUS);
                            ahaStationListView.showFocus();
                            ahaStationListView.stateLeftMenuBtnFocus();
//                            qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS);
//wsuk.kim 131115 ITS_209347 after click left menu, focus move to list.
                        }
                        else if(leftMenuButton2Focus === true)
                        {
                            selectLBS();
//wsuk.kim 131115 ITS_209347 after click left menu, focus move to list.
                            qmlProperty.setFocusArea(PR.const_STATION_LIST_LBS_LIST_FOCUS);
                            ahaStationListView.showFocus();
                            ahaStationListView.stateLeftMenuBtnFocus();
//                            qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS);
//wsuk.kim 131115 ITS_209347 after click left menu, focus move to list.
                        }
                    }
                }
//wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob

//wsuk.kim 131210 ITS_214306 duplicating hide option menu.
////wsuk.kim 130903 menu hide to change jog left from press to releas.
//                else if(arrow === UIListenerEnum.JOG_LEFT)
//                {
//                    if((optMenu.visible)&&(qmlProperty.getFocusArea() === PR.const_STATION_LIST_TITLE_FOCUS))
//                    {
//                        //optMenu.visible = false;
//                        optMenu.quickHide();
//                        optMenu.hideFocus();
//                        for(var i = 0; i < ahaMenus.optListMenuModel.levelMenu; i++)
//                        {
//                            ahaMenus.optListMenuModel.backLevel();
//                        }
//                        if(isDialUI)
//                        {
//                            stationModeAreaWidget.hideFocus();
//                            ahaStationListView.showFocus();
//                            isHideMenuLeft = true;
//                        }
//                    }
////wsuk.kim 131001 HK JOG Relesed, work to JogEvent.
////                    else
////                    {
////                        ahaStationListView.hideFocus();
////                        if(!optMenu.focus_visible)
////                        {
////                            optMenu.showFocus();
////                            if(isDialUI)
////                            {
////                                optMenu.setDefaultFocus(0);
////                            }
////                        }
////                    }
//                }
////wsuk.kim 130903 menu hide to change jog left from press to releas.

//wsuk.kim 131001 HK JOG Relesed, work to JogEvent.
                else if(arrow === UIListenerEnum.JOG_UP)
                {
                    if(!optMenu.visible &&
                        ((qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS) || (qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS)))
                    {
                        handleJogEvent(arrow,status);
                    }
                }
                else if(arrow === UIListenerEnum.JOG_RIGHT)
                {
                    if(!optMenu.visible &&
                        ((qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS) || (qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS)))
                    {
                        handleJogEvent(arrow,status);
                    }
                }
//wsuk.kim 131001 HK JOG Relesed, work to JogEvent.
            }
        }
    }

    Connections{
            target : idPreset
            onHandlePresetSelectionEvent:
            {
                handleSelectionEvent();
            }
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//            onHandlePresetBackRequest:
//            {
//                handleBackRequest();
//            }

            //hsryu_0524_select_same_content
            onHandlePlayPreset:
            {
                handlePlayStation();
            }

            onShowLoadingPopup:
            {
                /*popupLoading.visible*/isLoadingPopupVisible = true;
            }

            onHideLoadingPopup:
            {
                /*popupLoading.visible*/isLoadingPopupVisible = false;
                //hsryu_0329_system_popup
                stationNowLoading = false; //ready complete

                loadStaion=false; //hsryu_0613_fail_load_station
            }

            onHandlePresetFocusAfterFlicking:   //wsuk.kim 131122 ITS_210529 focus move on list after flicking.
            {
                stationModeAreaWidget.hideFocus();
                ahaStationListView.showFocus();
                ahaStationListView.stateLeftMenuBtnFocus();
            }

//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//            //hsryu_0423_block_play_btcall
//            onHandleShowBtBlockPopup:
//            {
//                showBtBlockPopup(jogCenter);
//            }
        }

        Connections{
            target : idLBS
            onHandleLBSSelectionEvent:
            {
                handleSelectionEvent();
            }
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//            onHandleLBSBackRequest:
//            {
//                handleBackRequest();
//            }

            //hsryu_0524_select_same_content
            onHandlePlayLBS:
            {
                handlePlayStation();
            }

            onShowLoadingPopup:
            {
                /*popupLoading.visible*/isLoadingPopupVisible = true;
            }

            onHideLoadingPopup:
            {
                /*popupLoading.visible*/isLoadingPopupVisible = false;
                //hsryu_0329_system_popup
                stationNowLoading = false; //ready complete

                loadStaion=false; //hsryu_0613_fail_load_station
            }

            onHandleLBSFocusAfterFlicking: //wsuk.kim 131122 ITS_210529 focus move on list after flicking.
            {
                stationModeAreaWidget.hideFocus();
                ahaStationListView.showFocus();
                ahaStationListView.stateLeftMenuBtnFocus();
            }

//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//            //hsryu_0423_block_play_btcall
//            onHandleShowBtBlockPopup:
//            {
//                showBtBlockPopup(jogCenter);
//            }
        }

    Connections{
        target: ahaMenus
        onMenuDataChanged:
        {
            optMenu.menumodel = ahaMenus.optListMenuModel
        }
    }

    Connections{
        target: stationModeAreaWidget.focus_visible?UIListener:null
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

    Connections{
        target: ahaController

        //hsryu_0329_system_popup
        onHandleCloseStationPopup:
        {
            UIListener.printQMLDebugString("onHandleCloseStationPopup "+ stationNowLoading +" \n");
            if(optMenu.visible === true)
            {
                //optMenu.visible = false;
                optMenu.quickHide();
            }

            if(waitpopup.visible === true)
            {
                waitpopup.visible = false;
            }

            if(/*popupLoading.visible*/isLoadingPopupVisible === true)
            {
                stationNowLoading = true;
                /*popupLoading.visible*/isLoadingPopupVisible = false;
            }
//wsuk.kim 131105 shift error popup move to AhaRadio.qml
//            if(shiftErrPopup.visible === true)  //wsuk.kim 131002 BG aha, shiftErrPopup hide in Station List.
//            {
//                shiftErrPopup.hidePopup();
//            }

            ahaStationListView.handleTempHideFocus(); //wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
        }

        onHandleRestoreStationPopup:
        {
            UIListener.printQMLDebugString("onHandleRestoreStationPopup \n");

            ahaStationListView.handleRestoreShowFocus(); //wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.

            if(stationNowLoading)
            {
               /*popupLoading.visible*/isLoadingPopupVisible = true;
            }
            stationNowLoading = false;
        }
        //hsryu_0329_system_popup

        onIsDialUIChanged:
        {
            UIListener.printQMLDebugString("AhaStationListView : onIsDialUIChanged \n");

            if(!isDialUI)
            {
                optMenu.hideFocus();
                stationModeAreaWidget.hideFocus();
            }
            else
            {
                if(optMenu.visible)
                {
                    optMenu.setDefaultFocus(0);
                }
                else
                {
                    if((qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS) || (qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS))
                    { ; }
                    else
                    {
                        ahaStationListView.showFocus();
                    }
                }
            }
        }
    }

    /***************************************************************************/
    /**************************** Aha QML connections End **********************/
    /***************************************************************************/

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
//wsuk.kim 131210 ITS_214306 duplicating hide option menu.            if(isDialUI)
            {
                stationModeAreaWidget.hideFocus();
            }
            ahaStationListView.showFocus(); //wsukim station_jog
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

    //  MODE AREA
    QmlModeAreaWidget
    {
        id: stationModeAreaWidget
        modeAreaModel: stationModeAreaModel
        search_visible: false
        parent: ahaStationListView
        anchors.top: parent.top
//TEST        mode_area_counter_total: presetTotal    //wsuk.kim TOTAL_COUNT
//TEST        mode_area_counter_number: 0 //wsuk.kim TOTAL_COUNT

//wsuk.kim station_jog
        onLostFocus:
        {
           isJogEventinModeArea = false;

           switch(arrow)
           {
               case UIListenerEnum.JOG_DOWN:
               {
                   stationModeAreaWidget.hideFocus();
//wsuk.kim 130917 ITS_190542 jog focus movement at left menu group.
//                   if(leftMenuBtn1Focused === 1)
//                   {
//                       qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS);
//                       ahaStationListView.stateLeftMenuBtnFocus();
//                       leftMenuBtn1Focused = 0;
//                   }
//                   else
//                   {
//                        ahaStationListView.showFocus();
//                   }
                   ahaStationListView.showFocus();
                   break;
                }
           }
        }
//wsuk.kim station_jog
        onModeArea_BackBtn:
        {
            isDialUI = false;
            ahaStationListView.handleBackRequest();
        }

        onModeArea_MenuBtn:
        {
//            if(UIListener.IsCallingSameDevice())    //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//            {
//                UIListener.OSDInfoCannotPlayBTCall();
//                return;
//            }
            isDialUI = isJogEventinModeArea;
            handleMenuKey(isJogEventinModeArea);
            isJogEventinModeArea = false;
        }

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
            anchors.verticalCenter: stationModeAreaWidget.verticalCenter
    //        anchors.left: ahaLogo.right
    //        anchors.leftMargin: 10
    //        anchors.bottom: ahaLogo.bottom
    //        anchors.bottomMargin: -9
    //wsuk.kim 130717 to change front/rear title position
            z: 1000
            text: " " + qsTranslate("main", "STR_AHA_STATIONLIST");
            color: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY
            font.pointSize: PR.const_AHA_FONT_SIZE_TEXT_HDR_40_FONT
            font.family: PR.const_AHA_FONT_FAMILY_HDB
        }

        ListModel
        {
            id: stationModeAreaModel
            //property string text: QT_TR_NOOP("STR_AHA_STATIONLIST")

            property string mb_text: QT_TR_NOOP("STR_AHA_MENU");
            property bool mb_visible: true;
        }

    }

//wsuk.kim station_jog
    function setHighlightedItem(inKeyId)
    {
        isDialUI = true;
    }

    function handleJogEvent( arrow, status )
    {
        switch(arrow)
        {
            case PR.const_AHA_JOG_EVENT_ARROW_UP:
                ahaStationListView.leftLostFocus(arrow, status);    //wsuk.kim 130917 ITS_190542 jog focus movement at left menu group.
                break;

            case PR.const_AHA_JOG_EVENT_WHEEL_LEFT:
//wsuk.kim 130917 ITS_190542 jog focus movement at left menu group.
//                if(!leftMenuFocusUp(arrow))
//                {
//                    ahaStationListView.leftLostFocus(arrow, status); //wsuk.kim leftmenu_jog
//                }
                if(leftMenuButton2Focus === true)
                {
                    qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS);
                    ahaStationListView.stateLeftMenuBtnFocus();
                }
                break;

//wsuk.kim 130917 ITS_190542 jog focus movement at left menu group.            case PR.const_AHA_JOG_EVENT_ARROW_DOWN:
            case PR.const_AHA_JOG_EVENT_WHEEL_RIGHT:
                if(leftMenuButton1Focus === true)
                {
                    qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS);
                    ahaStationListView.stateLeftMenuBtnFocus();
                }
                break;

            case PR.const_AHA_JOG_EVENT_ARROW_RIGHT:
                stationModeAreaWidget.hideFocus();

                if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_PRESET_FOCUS_SCREEN && ahaStationList.getPresetCount() > 0)  //wsuk.kim 131029 preset list empty, handling focus in preset list.
                {
                    qmlProperty.setFocusArea(PR.const_STATION_LIST_PRESET_LIST_FOCUS);
                    idPreset.stateFocusVisible();
                }
                else if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_LBS_FOCUS_SCREEN)
                {
                    qmlProperty.setFocusArea(PR.const_STATION_LIST_LBS_LIST_FOCUS);
                    idLBS.stateFocusVisible();
                }
                ahaStationListView.stateLeftMenuBtnFocus();
                break;

            case PR.const_AHA_JOG_EVENT_CENTER:
                handleCenterKey();
                break;
        }
    }

    function handleCenterKey()
    {
        if(!isLoadingPopupVisible)
        {
            idPreset.stateFocusVisible();   //wsuk.kim leftTab_list_focus_hide
            idLBS.stateFocusVisible();      //wsuk.kim leftTab_list_focus_hide
            if(leftMenuButton1Focus === true)
            {
                leftMenuButton1Press = true;    //wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob
//                selectPreset();
//                qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS);
            }
            else if(leftMenuButton2Focus === true)
            {
                leftMenuButton2Press = true;    //wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob
//                selectLBS();
//                qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS);
            }
        }
    }

//wsuk.kim leftmenu_jog
    function leftMenuFocusUp(arrow)
    {
        var eventHandled = false;

        if(leftMenuButton2Focus === true)
        {
            qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS);
            ahaStationListView.stateLeftMenuBtnFocus();
            eventHandled = true;
        }
        else if(leftMenuButton1Focus === true)
        {
            if(arrow === PR.const_AHA_JOG_EVENT_WHEEL_LEFT)
            {
                eventHandled = true;
            }
//            else
//            {
//                leftMenuButton1Focus = false;
//                leftMenuButton2Focus = false;
//            }
        }
        return eventHandled;
    }
//wsuk.kim leftmenu_jog

    function selectPreset()
    {
        szSelectMode = "Preset";
        qmlProperty.setFocusScreen(PR.const_STATION_LIST_PRESET_FOCUS_SCREEN);
    }

    function selectLBS()
    {
        szSelectMode = "LBS";
        qmlProperty.setFocusScreen(PR.const_STATION_LIST_LBS_FOCUS_SCREEN);
    }

    function showLoadingPopup()
    {
        /*popupLoading.visible*/isLoadingPopupVisible = true;
    }

    function hideLoadingPopup()
    {
        /*popupLoading.visible*/isLoadingPopupVisible = false;
    }

    // handle retranlateUI event
    function handleRetranslateUI(languageId)
    {
       stationModeAreaWidget.retranslateUI(PR.const_AHA_LANGCONTEXT);
    }

    function hideFocus()
    {
        idPreset.stateFocusVisible();
        idLBS.stateFocusVisible();
    }

    function showFocus()
    {
        if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_PRESET_FOCUS_SCREEN)
        {
            if(ahaStationList.getPresetCount() <= 0) //wsuk.kim 131029 preset list empty, handling focus in preset list.
            {
                qmlProperty.setFocusArea(PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS);
                ahaStationListView.stateLeftMenuBtnFocus();
            }
            else
            {
                qmlProperty.setFocusArea(PR.const_STATION_LIST_PRESET_LIST_FOCUS);
                idPreset.stateFocusVisible();
            }
        }
        else if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_LBS_FOCUS_SCREEN)
        {
            qmlProperty.setFocusArea(PR.const_STATION_LIST_LBS_LIST_FOCUS);
            idLBS.stateFocusVisible();
        }
    }

    function handleMenuItemEvent(menuItemId)
    {
        ahaStationListView.hideMenu = true;
        switch(parseInt(menuItemId))
        {
            case MenuItems.NowListening: // "Now Listening"
            {
                //hsryu_0125 topmost station fix
                if(ahaController.listViewIsTopMost)
                {
                    showLoadPopup();
                    handleSelectionEvent();
                }
                else
                {
                    handleBackRequest();
                }

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
                break;
        }
//hsryu_0417_sound_setting
//hsryu_0319_control_opt_sound_setting
//        if(parseInt(menuItemId) === MenuItems.SoundSetting)
//        {
//            ;
//        }
//        else
//        {
//        	optMenu.visible = !ahaStationListView.hideMenu;
//            optMenu.hideFocus();
//        }

        //optMenu.hideFocus();
    }

//hsryu_0319_control_opt_sound_setting
//    Timer{
//        id: optStationTransitionTimer
//        running: false
//        repeat: false
//        interval: 500
//        onTriggered: {
//            optMenu.visible = false;
//        }
//    }

    function hideOptionsMenu()
    {
        UIListener.printQMLDebugString("AhaStationListView : hideOptionsMenu \n");

        //optMenu.visible = false;
        optMenu.quickHide();
        optMenu.hideFocus();

        for(var i = 0; i < ahaMenus.optListMenuModel.levelMenu; i++)
        {
            ahaMenus.optListMenuModel.backLevel();
        }

        stationModeAreaWidget.hideFocus();
        ahaStationListView.showFocus();
    }

    function stateLeftMenuBtnFocus()
    {
        leftMenuButton1Focus = false;
        leftMenuButton2Focus = false;

        if(qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS)
        {
            leftMenuButton1Focus = true;
        }
        else if(qmlProperty.getFocusArea() === PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS)
        {
            leftMenuButton2Focus = true;
        }
    }

//wsuk.kim TUNE
    function handleFocusTuneUp(arrow)
    {
        if(!isLoadingPopupVisible && !isOptionsMenuVisible && !networkErrorPopupVisible /*&&!isShiftErrPopupVisible*/)
        {
            isDialUI = true;
            stationModeAreaWidget.hideFocus();
            ahaStationListView.showFocus();
            ahaStationListView.stateLeftMenuBtnFocus();

            if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_PRESET_FOCUS_SCREEN)
            {
                idPreset.focusPrev(arrow);
            }
            else if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_LBS_FOCUS_SCREEN)
            {
                idLBS.focusPrev(arrow);
            }
        }
    }

    function handleFocusTuneDown(arrow)
    {
        if(!isLoadingPopupVisible && !isOptionsMenuVisible && !networkErrorPopupVisible /*&&!isShiftErrPopupVisible*/)
        {
            isDialUI = true;
            stationModeAreaWidget.hideFocus();
            ahaStationListView.showFocus();
            ahaStationListView.stateLeftMenuBtnFocus();

            if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_PRESET_FOCUS_SCREEN)
            {
                idPreset.focusNext(arrow);
            }
            else if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_LBS_FOCUS_SCREEN)
            {
                idLBS.focusNext(arrow);
            }
        }
    }

    function handleFocusTuneCenter()
    {
        //hsryu_0423_block_play_btcall
        if(!isLoadingPopupVisible && !isOptionsMenuVisible && !networkErrorPopupVisible /*&&!isShiftErrPopupVisible*/)
        {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//            if(UIListener.IsCallingSameDevice())
//            {
//                if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_PRESET_FOCUS_SCREEN)
//                {
//                    idPreset.handleTuneCenterKeyForBT();
//                }
//                else if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_LBS_FOCUS_SCREEN)
//                {
//                    idLBS.handleTuneCenterKeyForBT();
//                }
//                return;
//            }
            if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_PRESET_FOCUS_SCREEN && qmlProperty.getFocusArea() === PR.const_STATION_LIST_PRESET_LIST_FOCUS)
            {
                idPreset.handleCenterKey();
            }
            else if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_LBS_FOCUS_SCREEN && qmlProperty.getFocusArea() === PR.const_STATION_LIST_LBS_LIST_FOCUS)
            {
                idLBS.handleCenterKey();
            }
        }
    }

    function handleTuneCenterPressed()  //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
    {
        if(!isLoadingPopupVisible && !isOptionsMenuVisible && !networkErrorPopupVisible /*&&!isShiftErrPopupVisible*/)
        {
            if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_PRESET_FOCUS_SCREEN && qmlProperty.getFocusArea() === PR.const_STATION_LIST_PRESET_LIST_FOCUS)
            {
                idPreset.handleCenterKeyPressed();
            }
            else if(qmlProperty.getFocusScreen() === PR.const_STATION_LIST_LBS_FOCUS_SCREEN && qmlProperty.getFocusArea() === PR.const_STATION_LIST_LBS_LIST_FOCUS)
            {
                idLBS.handleCenterKeyPressed();
            }
        }
    }
//wsuk.kim TUNE

//wsuk.kim 130930 ITS_191996 SEEK/TRACK
    function handleSeekTrackPressedFocus()
    {
//        stationModeAreaWidget.hideFocus();
//        ahaStationListView.showFocus();
//        ahaStationListView.stateLeftMenuBtnFocus();
    }

    function handlePopupNoSkipBack()
    {
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_SKIP_BACK);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftErrPopup.showPopup(qsTranslate("main", "STR_NO_SUPPORT_SKIP_BACK"), true);
    }

    function handlePopupNoSkip()
    {
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_SKIP);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftErrPopup.showPopup(qsTranslate("main", "STR_NO_SUPPORT_SKIP"), true);
    }

    function handlePopupNoREW15()
    {
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_REW15);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftErrPopup.showPopup(qsTranslate("main", "STR_AHA_NO_SUPPORT_REW15"), true);
    }

    function handlePopupNoFW30()
    {
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_FW30);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftErrPopup.showPopup(qsTranslate("main", "STR_AHA_NO_SUPPORT_FW30"), true);
    }
//wsuk.kim 130930 ITS_191996 SEEK/TRACK

//wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
    function handleTempHideFocus()
    {
        nFocusPosition = qmlProperty.getFocusArea();
        qmlProperty.setFocusArea(0);
        stationModeAreaWidget.hideFocus();
        ahaStationListView.hideFocus();
        ahaStationListView.stateLeftMenuBtnFocus();
    }

    function handleRestoreShowFocus()
    {
        if (nFocusPosition > 0) // ITS 228253 229032 229033
            qmlProperty.setFocusArea(nFocusPosition);

        switch (qmlProperty.getFocusArea())
        {
            case PR.const_STATION_LIST_LEFT_MENU_PRESET_FOCUS:
            case PR.const_STATION_LIST_LEFT_MENU_LBS_FOCUS :
                ahaStationListView.stateLeftMenuBtnFocus();
                break;

            case PR.const_STATION_LIST_TITLE_FOCUS:
                stationModeAreaWidget.showFocus();
                break;

            case PR.const_STATION_LIST_PRESET_LIST_FOCUS:
                idPreset.stateFocusVisible();
                break;

            case PR.const_STATION_LIST_LBS_LIST_FOCUS :
                idLBS.stateFocusVisible();
                break;
        }
    }
//wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.

//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml
//    ListModel
//    {
//        id: popupLoadingMsg
//        ListElement{
//            msg: QT_TR_NOOP("STR_AHA_LOADING")
//        }
//    }

////hsryu_0131
//    //POPUPWIDGET.PopUp_Loading
//    DHAVN_AhaPopup_Loading
//    {
//        id: popupLoading
////wsuk.kim 131101 status bar dimming during to display popup.        y: 153 //hsryu_0523_change_loading_pos
//        opacity: 0.9 //hsryu_0523_change_loading_pos
//        visible: false;
//        message: popupLoadingMsg
//    }
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml

    ListModel
    {
        id: errorModel
    }

    POPUPWIDGET.PopUpDimmed
    {
        id: waitpopup
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
//hsryu_0131

//wsuk.kim leftmenu_jog
    onLeftLostFocus: {
        if(arrow === UIListenerEnum.JOG_UP)
        {
            qmlProperty.setFocusArea(PR.const_STATION_LIST_TITLE_FOCUS);
            ahaStationListView.stateLeftMenuBtnFocus();
            stationModeAreaWidget.showFocus();
            if(stationModeAreaWidget.focus_index === -1)
            {
                stationModeAreaWidget.setDefaultFocus(arrow);
            }
//wsuk.kim 130917 ITS_190542 jog focus movement at left menu group.            leftMenuBtn1Focused = 1;
        }
    }
//wsuk.kim leftmenu_jog

    //hsryu_0613_fail_load_station
    Timer{
        id: loadingStationTimer
        running: loadStaion
        repeat: false
        interval: 10000
        onTriggered:{
            if(loadStaion === true)
            {
                /*popupLoading.visible*/isLoadingPopupVisible = false;
                loadStaion = false;
                handlShowFailLoadStationList();
            }
        }
    }

//wsuk.kim 130930 ITS_191996 SEEK/TRACK
//wsuk.kim 131105 shift error popup move to AhaRadio.qml
//    POPUPWIDGET.PopUpText
//    {
//        id: shiftErrPopup
//        z: 1000
//        y: -PR.const_AHA_ALL_SCREENS_TOP_OFFSET
//        icon_title: EPopUp.WARNING_ICON
//        visible: false
//        message: shiftErrorModel
//        buttons: btnmodel
//        focus_visible: shiftErrPopup.visible
//        property bool showErrorView;

//        function showPopup(text, errorView)
//        {
//            shiftErrPopup.showErrorView = errorView;
//            if(!visible)
//            {
//                shiftErrorModel.set(0,{msg:text})

//                visible = true;
//                shiftErrPopup.setDefaultFocus(0);
//            }
//        }

//        function hidePopup()
//        {
//            visible = false;
//        }

//        onBtnClicked:
//        {
//            switch ( btnId )
//            {
//                case "OK":
//                {
//                    shiftErrPopup.visible = false
//                }
//                break;
//            }
//        }
//    }

//    ListModel
//    {
//        id: shiftErrorModel
//        ListElement
//        {
//            msg: ""
//        }
//    }
//wsuk.kim 130930 ITS_191996 SEEK/TRACK
}
