import QtQuick 1.1
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import com.settings.variables 1.0
import Qt.labs.gestures 2.0
import AppEngineQMLConstants 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0
import QmlStatusBar 1.0

DHAVN_AppSettings_FocusedTransparency{
    id: root

    property bool __is_main: true
    property Loader loader;
    focus: true

    name: "Root"
    default_x: 0
    default_y: 0

    width: 1280
    height: APP.const_APP_SETTINGS_MAIN_SCREEN_HEIGHT

    state: ""

    property bool isMovementOn: false //added for ITS 217683 List stuck in time zone
    property alias mainMenuState : root.state //added for ITS 217683 List stuck in time zone
    property bool isFirstSystemPopUp: true; //added for ITS 218952 First Map/Voice Key input and Settings Focus not hide
    property bool isAgreement10: EngineListener.isAgree10Variant() //added for NA/CH Agreement Spec Modify(time 10, default on)
    signal backFromListSignal()
    signal visualCue( int event, int status )

    signal setDefaultFocusLanguageChanged(); //added for ITS271869 VisualCue issue

    onMainMenuStateChanged:
    {
        EngineListener.printLogMessage("onMainMenuStateChanged: " + mainMenuState)
    }

    // playing video in background
    property bool isVideoMode: false

    // Apply Effect(ex:font-outline(On), bright-image(Off)) When Screen's opacity is 0.0(Showing video screen)
    property bool isBrightEffectShow: true

    // DRS On/Off
    property bool isParkingMode: true

    property bool isShowSystemPopup: false
    property bool bEnableLaunchMapCare: false

    property bool isTouchLock: false

    property bool isJukeBoxFormatCP:false
    //added for ITS 247055 two Focus Issue When show Reset PopUp//ITS261652
    function getPopUpState()
    {
        if(rootPopUpLoader.visible)
        {
            //EngineListener.printLogMessage("[Main]getPopUpState(): visible : true ")
            return true;
        }
        else
        {
            //EngineListener.printLogMessage("[Main]getPopUpState(): visible : false ")
            return false;
        }
    }
    function isShowJukeboxPopup()
    {
        EngineListener.printLogMessage("isShowJukeboxPopup" + rootToastPopUpLoader.visible + rootToastPopUpLoader.nPopup_type )
        if(rootToastPopUpLoader.visible && (rootToastPopUpLoader.nPopup_type == Settings.SETTINGS_TOAST_FORMAT_START
                    || rootToastPopUpLoader.nPopup_type == Settings.SETTINGS_TOAST_FORMAT_COMPLETE
                    || rootToastPopUpLoader.nPopup_type == Settings.SETTINGS_TOAST_RESET_START
                    || rootToastPopUpLoader.nPopup_type == Settings.SETTINGS_TOAST_RESET_COMPLETE))
            return true
        else
            return false
    }
    function backButtonHandler(eventTarget)
    {
        EngineListener.printLogMessage("backButtonHandler ..1")
        if(rootToastPopUpLoader.visible)
        {
            if( isJukeBoxFormatCP == false && rootToastPopUpLoader.nPopup_type == Settings.SETTINGS_TOAST_RESET_START ||
                    ( isJukeBoxFormatCP == false && rootToastPopUpLoader.nPopup_type == Settings.SETTINGS_TOAST_FORMAT_START) ||
                    rootToastPopUpLoader.nPopup_type == Settings.SETTINGS_TOAST_LANGUAGE_CHANGING )
                return
            else
            {
                if( isJukeBoxFormatCP == false)
                {
                	rootToastPopUpLoader.visible = false
                	return
                }
            }
        }
        if(pageManager.count() == 1)
        {
            EngineListener.printLogMessage("backButtonHandler ..2")
            EngineListener.HandleBackKey( eventTarget );
        }
        else if(pageManager.count() == 2)
        {
            EngineListener.printLogMessage("backButtonHandler ..3")
            var lastPageIndex = pageManager.getLastItemIndex()

            // Reset Loader Source
            resetLoaderSource(lastPageIndex)

            // Delete Data in StackList
            pageManager.pop()

            lastPageIndex = pageManager.getLastItemIndex()

            //console.log("[QML][Main]backButtonHandler() : lastPageIndex:"+lastPageIndex)

            if(lastPageIndex == 0)
            {
                var rootState = pageManager.getRootState(lastPageIndex)
                var nestedState = pageManager.getNestedState(lastPageIndex)

                // Change root's state
                root.state = rootState
                root.recheckFocusHandle()

                EngineListener.printLogMessage("backButtonHandler : root.state: " + root.state)

                // Get state's Loader
                loader = pageManager.getLoaderByStateName(rootState)

                // Request Change Nested-State
                loader.item.requestChangeNestedState(nestedState)
            }
        }
        /*
        else
        {
            console.log("[QML][Main]backButtonHandler() : Error!! : pageManager.count:"+pageManager.count())
        }
        */
    }

    function backHome()
    {
        var lastPageIndex = pageManager.getLastItemIndex()
        var rootState = pageManager.getRootState(lastPageIndex)

        if(rootState == APP.const_APP_SETTINGS_MAIN_STATE_VOICE)
        {
            switch(SettingsStorage.currentRegion)
            {
            case 0: // Korea
            {
                if(SettingsStorage.languageType != Settings.SETTINGS_LANGUAGE_KO)
                {
                    EngineListener.HandleBackKey( UIListener.getCurrentScreen() );
                }
            }
            break
            case 1: // NA & Canada
            case 6:
            {
                if(SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_KO)
                {
                    EngineListener.HandleBackKey( UIListener.getCurrentScreen() );
                }
            }
            break
            case 4: // ME
            {
                if(SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_KO || SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_EN_UK)
                {
                    EngineListener.HandleBackKey( UIListener.getCurrentScreen() );
                }
            }
            break
            case 5: // Europe && Russia
            case 7:
            {
                if(SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_KO || SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_SK)
                {
                    EngineListener.HandleBackKey( UIListener.getCurrentScreen() );
                }
            }
            break
            }
        }
    }


    function resetLoaderSource(index)
    {
        var rootState = pageManager.getRootState(index)
        loader = pageManager.getLoaderByStateName(rootState)

        loader.source = ""
    }

    function requestChangePage(rootState, nestedState)
    {
        //console.log("[QML][Main]requestChangePage(rootState, nestedState)rootState:"+rootState, nestedState+", nestedState"+nestedState)
        if(rootState != "")
        {
            // Change root's state
            root.state = rootState

            // Get state's Loader
            loader = pageManager.getLoaderByStateName(rootState)

            if(nestedState != "")
            {
                loader.item.requestChangeNestedState(nestedState)
            }
        }
    }

    function clearScreen()
    {
        var firstRootState = ""

        if(pageManager.count() > 0)
        {
            if(rootPopUpLoader.source != "" && rootPopUpLoader.item.visible)
            {
                rootPopUpLoader.item.closePopUp(false, 0)
            }

            root.state = APP.const_APP_SETTINGS_GENERAL_STATE_WAITING

            firstRootState = pageManager.getRootState(0)
            for(var i=0; i<pageManager.count(); i++)
            {
                var lastItemIndex = pageManager.getLastItemIndex()
                //console.log("[QML]Main:onResetScreen: if(pageManager.count() > 0): LastPageIndex:" + pageManager.getLastItemIndex())
                var rootState = pageManager.getRootState(i)
                loader = pageManager.getLoaderByStateName(rootState)
                loader.source = ""
            }

            pageManager.clearAll()

            root.state = firstRootState
        }
    }

    Connections{
        target: SettingsStorage

        onIsArabicLanguageChanged:
        {
            clearScreen()
        }
    }

    Image {
        id: bg
        x:0; y:0
        source: "/app/share/images/AppSettings/general/bg_main.png"
    }

    ParallelAnimation {
        id: bgHideAni

        running: false; loops: 1
        NumberAnimation { target: bg; property: "opacity"; to: 0.0; duration: 250 }
        PropertyAction { target: root; property: "isBrightEffectShow"; value: false }
    }

    ParallelAnimation {
        id: bgShowAni

        running: false; loops: 1
        NumberAnimation { target: bg; property: "opacity"; to: 1; duration: 250 }
        PropertyAction { target: root; property: "isBrightEffectShow"; value: true }
    }

    QmlStatusBar {
        id: statusBar
        x: 0; y: 0; width: 1280; height: 93
        homeType: "button"
        middleEast: (SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_AR) ? true : false
    }

    DHAVN_AppSettings_PageStack
    {
        id: pageManager
    }

    MouseArea
    {
        id: touchLockArea
        anchors.fill: parent
        z: 1000
        beepEnabled: false
        enabled: isTouchLock
        //added for ITS 218952 First Map/Voice Key input and Settings Focus not hide
        function hideFocus()
        {
            console.log("[QML] touchLockArea :: hideFocus ---->")
            if(isFirstSystemPopUp){
                isFirstSystemPopUp = false;
                main_container.hideFocus()
            }
        }
        //added for ITS 218952 First Map/Voice Key input and Settings Focus not hide
    }

    DHAVN_AppSettings_FocusedItem{
        id: main_container
        anchors.top: parent.top
        anchors.topMargin: 93
        anchors.left: parent.left

        default_x: 0
        default_y: 0
        focus_x: 0
        focus_y: 0
        name: "main container"

        Connections{
            target: EngineListener
            onRetranslateUi:
            {
                LocTrigger.retrigger()
            }

            onVideoStatusChanged:
            {
                if(targetScreen == UIListener.getCurrentScreen())
                {
                    if(enable)
                    {
                        if(bgShowAni.running) bgShowAni.running = false
                        isVideoMode = true
                        bg.opacity = 0.0
                        isBrightEffectShow = false
                    }
                    else
                    {
                        if(bgHideAni.running) bgHideAni.running = false
                        isVideoMode = false
                        bg.opacity = 1
                        isBrightEffectShow = true
                    }
                }
            }

            onSetTouchLock:
            {
                //console.log("[QML]onSetTouchLock: bTouchLock:"+bTouchLock)
                if(isTouchLock != bTouchLock)
                    isTouchLock = bTouchLock
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: audio_loader

            visible: root.state == APP.const_APP_SETTINGS_MAIN_STATE_SOUND
            anchors.fill:parent

            name: "AudioLoader"
            focus_x: 0
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(pageManager.count() < 1)
                        pageManager.push(APP.const_APP_SETTINGS_MAIN_STATE_SOUND, "")

                    if( status != Loader.Ready )
                    {
                        switch(SettingsStorage.languageType)
                        {
                        case Settings.SETTINGS_LANGUAGE_AR:
                        {
                            source = "../qml_arab/DHAVN_AppSettings_Sound.qml"
                        }
                        break
                        default:
                        {
                            source = "DHAVN_AppSettings_Sound.qml"
                        }
                        break
                        }
                    }
                }
                else
                {
                    hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: screen_loader

            visible: root.state == APP.const_APP_SETTINGS_MAIN_STATE_SCREEN

            name: "ScreenLoader"
            focus_x: 0
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(pageManager.count() < 1)
                        pageManager.push(APP.const_APP_SETTINGS_MAIN_STATE_SCREEN, "")

                    if( status != Loader.Ready )
                    {
                        switch(SettingsStorage.languageType)
                        {
                        case Settings.SETTINGS_LANGUAGE_AR:
                        {
                            source = "../qml_arab/DHAVN_AppSettings_Screen.qml"
                        }
                        break
                        default:
                        {
                            source = "DHAVN_AppSettings_Screen.qml"
                        }
                        break
                        }
                    }
                }
                else
                {
                    hideFocus()
                }
            }
        }

        //added for DH PE DRS
        DHAVN_AppSettings_FocusedLoader{
            id: screenDRS_loader

            visible: root.state == APP.const_APP_SETTINGS_MAIN_STATE_SCREEN_DRS
            z:10

            name: "ScreenDRSLoader"
            focus_x: 0
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(pageManager.count() < 1)
                        pageManager.push(APP.const_APP_SETTINGS_MAIN_STATE_SCREEN_DRS, "")

                    if( status != Loader.Ready )
                    {
                        switch(SettingsStorage.languageType)
                        {
                        case Settings.SETTINGS_LANGUAGE_AR:
                        {
                            source = "../qml_arab/DHAVN_AppSettings_Screen_DRS.qml"
                        }
                        break
                        default:
                        {
                            source = "DHAVN_AppSettings_Screen_DRS.qml"
                        }
                        break
                        }
                    }
                }
                else
                {
                    hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: voice_loader

            visible: root.state == APP.const_APP_SETTINGS_MAIN_STATE_VOICE

            name: "VoiceLoader"
            focus_x: 0
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(pageManager.count() < 1)
                        pageManager.push(APP.const_APP_SETTINGS_MAIN_STATE_VOICE, "")

                    if( status != Loader.Ready )
                    {
                        switch(SettingsStorage.languageType)
                        {
                        case Settings.SETTINGS_LANGUAGE_AR:
                        {
                            source = "../qml_arab/DHAVN_AppSettings_Voice.qml"
                        }
                        break
                        default:
                        {
                            source = "DHAVN_AppSettings_Voice.qml"
                        }
                        break
                        }
                    }
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: keypad_loader

            visible: root.state == APP.const_APP_SETTINGS_MAIN_STATE_KEYPAD

            name: "KeypadLoader"
            focus_x: 0
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(pageManager.count() < 1)
                        pageManager.push(APP.const_APP_SETTINGS_MAIN_STATE_KEYPAD, "")

                    if( status != Loader.Ready )
                    {
                        switch(SettingsStorage.languageType)
                        {
                        case Settings.SETTINGS_LANGUAGE_AR:
                        {
                            source = "../qml_arab/DHAVN_AppSettings_OnlyKeypad.qml"
                        }
                        break
                        default:
                        {
                            source = "DHAVN_AppSettings_OnlyKeypad.qml"
                        }
                        break
                        }
                    }
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: clock_loader

            visible: root.state == APP.const_APP_SETTINGS_MAIN_STATE_CLOCK

            name: "KeypadLoader"
            focus_x: 0
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(pageManager.count() < 1)
                        pageManager.push(APP.const_APP_SETTINGS_GENERAL_STATE_CLOCK, "")

                    if(status != Loader.Ready )
                    {
                        switch(SettingsStorage.languageType)
                        {
                        case Settings.SETTINGS_LANGUAGE_AR:
                        {
                            source = "../qml_arab/DHAVN_AppSettings_Clock.qml"
                        }
                        break
                        default:
                        {
                            source = "DHAVN_AppSettings_Clock.qml"
                        }
                        break
                        }
                    }
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: system_loader

            visible: root.state == APP.const_APP_SETTINGS_MAIN_STATE_SYSTEM

            name: "SystemLoader"
            focus_x: 0
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(pageManager.count() < 1)
                        pageManager.push(APP.const_APP_SETTINGS_MAIN_STATE_SYSTEM, "")

                    if( status != Loader.Ready )
                    {
                        switch(SettingsStorage.languageType)
                        {
                        case Settings.SETTINGS_LANGUAGE_AR:
                        {
                            source = "../qml_arab/DHAVN_AppSettings_System.qml"
                        }
                        break
                        default:
                        {
                            source = "DHAVN_AppSettings_System.qml"
                        }
                        break
                        }
                    }
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: general_loader

            visible: root.state == APP.const_APP_SETTINGS_MAIN_STATE_GENERAL
            anchors.fill:parent

            name: "GeneralLoader"
            focus_x: 0
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(pageManager.count() < 1)
                        pageManager.push(APP.const_APP_SETTINGS_MAIN_STATE_GENERAL, "")

                    if( status != Loader.Ready )
                    {
                        switch(SettingsStorage.languageType)
                        {
                        case Settings.SETTINGS_LANGUAGE_AR:
                        {
                            source = "../qml_arab/DHAVN_AppSettings_General.qml"
                        }
                        break
                        default:
                        {
                            source = "DHAVN_AppSettings_General.qml"
                        }
                        break
                        }
                    }
                }
            }
        }

        //added for AA/CP Setting
        DHAVN_AppSettings_FocusedLoader{
            id: connectivity_loader

            visible: root.state == APP.const_APP_SETTINGS_MAIN_STATE_CONNECTIVITY
            anchors.fill:parent

            name: "ConnectivityLoader"
            focus_x: 0
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(pageManager.count() < 1)
                        pageManager.push(APP.const_APP_SETTINGS_MAIN_STATE_CONNECTIVITY, "")

                    if( status != Loader.Ready )
                    {
                        switch(SettingsStorage.languageType)
                        {
                        case Settings.SETTINGS_LANGUAGE_AR:
                        {
                            source = "../qml_arab/DHAVN_AppSettings_Connectivity.qml"
                        }
                        break
                        default:
                        {
                            source = "DHAVN_AppSettings_Connectivity.qml"
                        }
                        break
                        }
                    }
                }
            }
        }
        //added for AA/CP Setting

        DHAVN_AppSettings_VisualCueNew{
            id: visualCue
            anchors.top: parent.top
            anchors.topMargin: APP.const_APP_SETTINGS_MENU_TOP_MARGIN
        }

        /*
        DHAVN_AppSettings_FocusedLoader{
            id: popinfo_loader
            property string popup_type: ""
            source: ""
        }*/
    }

    /////////////// popup  ////////////////////////////////

    DHAVN_AppSettings_PopUpLoader{
        id: rootPopUpLoader
        z: 10
        focus_z: 1

        anchors.fill: parent

        focus_x: 0
        focus_y: 0

        onVisibleChanged: {
            if (visible)
            {
                //console.log("[QML][Main][rootPopUpLoader]onVisibleChanged: visible: true")
                rootPopUpLoader.showFocus()
            }
            else
            {
                //console.log("[QML][Main][rootPopUpLoader]onVisibleChanged: visible: false")
                if(!isShowSystemPopup)
                {
                    backHome()
                    root.showFocus()
                }
            }
        }

        onStatusChanged:
        {
            if( status == Loader.Ready )
                root.hideFocus()
        }
    }

    DHAVN_AppSettings_ToastPopUpLoader{
        id: rootToastPopUpLoader
        anchors.fill: parent
        z:5
        focus_x: 0
        focus_y: 0
        focus_z: 1

        onVisibleChanged: {
            if (visible)
            {
                root.hideFocus()
            }
            else
            {
                if(!isShowSystemPopup)
                    root.showFocus()
            }
        }

        onStatusChanged:
        {
            if( status == Loader.Ready )
                root.hideFocus()
        }
    }

    /////////////// popup  ////////////////////////////////

    Connections{
        target: EngineListener
        /*
        onSetStateLCD:
        {
            if ( targetScreen != UIListener.getCurrentScreen() )
                return;

            screen_loader.item.state = APP.const_APP_SETTINGS_SCREEN_SET_NON_VIDEO_MODE;
        }
        */

        onSetStartState:
        {
            if ( targetScreen != UIListener.getCurrentScreen() )
                return;

            //close all popup
            rootPopUpLoader.visible = false

            switch ( mainState )
            {
            case APP.const_APP_SETTINGS_MAIN_STATE_KEYPAD:
            {
                if ( keypad_loader.status != Loader.Ready )
                {
                    switch(SettingsStorage.languageType)
                    {
                    case Settings.SETTINGS_LANGUAGE_AR:
                    {
                        keypad_loader.source = "../qml_arab/DHAVN_AppSettings_OnlyKeypad.qml"
                    }
                    break
                    default:
                    {
                        keypad_loader.source = "DHAVN_AppSettings_OnlyKeypad.qml"
                    }
                    break
                    }
                }
            }
            break;

            case APP.const_APP_SETTINGS_MAIN_STATE_CLOCK:
            {
                if ( clock_loader.status != Loader.Ready )
                {
                    switch(SettingsStorage.languageType)
                    {
                    case Settings.SETTINGS_LANGUAGE_AR:
                    {
                        clock_loader.source = "../qml_arab/DHAVN_AppSettings_Clock.qml"
                    }
                    break
                    default:
                    {
                        clock_loader.source = "DHAVN_AppSettings_Clock.qml"
                    }
                    break
                    }
                }
            }
            break;

            case APP.const_APP_SETTINGS_MAIN_STATE_SYSTEM:
            {
                if ( system_loader.status != Loader.Ready )
                {
                    switch(SettingsStorage.languageType)
                    {
                    case Settings.SETTINGS_LANGUAGE_AR:
                    {
                        system_loader.source = "../qml_arab/DHAVN_AppSettings_System.qml"
                    }
                    break
                    default:
                    {
                        system_loader.source = "DHAVN_AppSettings_System.qml"
                    }
                    break
                    }
                }
            }
            break;

            case APP.const_APP_SETTINGS_MAIN_STATE_SOUND:
            {
                if ( audio_loader.status != Loader.Ready )
                {
                    switch(SettingsStorage.languageType)
                    {
                    case Settings.SETTINGS_LANGUAGE_AR:
                    {
                        audio_loader.source = "../qml_arab/DHAVN_AppSettings_Sound.qml"
                    }
                    break
                    default:
                    {
                        audio_loader.source = "DHAVN_AppSettings_Sound.qml"
                    }
                    break
                    }
                }
            }
            break;

            case APP.const_APP_SETTINGS_MAIN_STATE_SCREEN:
            {
                if ( screen_loader.status != Loader.Ready )
                {
                    switch(SettingsStorage.languageType)
                    {
                    case Settings.SETTINGS_LANGUAGE_AR:
                    {
                        screen_loader.source = "../qml_arab/DHAVN_AppSettings_Screen.qml"
                    }
                    break
                    default:
                    {
                        screen_loader.source = "DHAVN_AppSettings_Screen.qml"
                    }
                    break
                    }
                }

                root.width = APP.const_APP_SETTINGS_MAIN_SCREEN_WIDTH - 1
                root.height = APP.const_APP_SETTINGS_MAIN_SCREEN_HEIGHT -1

                if(EngineListener.NotifyVideoMode(targetScreen))
                {
                    screen_loader.item.changeVideoMode()
                }
                root.Update()

            }
            break;

            //added for DH PE DRS
            case APP.const_APP_SETTINGS_MAIN_STATE_SCREEN_DRS:
            {
                if ( screenDRS_loader.status != Loader.Ready )
                {
                    switch(SettingsStorage.languageType)
                    {
                    case Settings.SETTINGS_LANGUAGE_AR:
                    {
                        screenDRS_loader.source = "../qml_arab/DHAVN_AppSettings_Screen_DRS.qml"
                    }
                    break
                    default:
                    {
                        screenDRS_loader.source = "DHAVN_AppSettings_Screen_DRS.qml"
                    }
                    break
                    }
                }

                root.width = APP.const_APP_SETTINGS_MAIN_SCREEN_WIDTH - 1
                root.height = APP.const_APP_SETTINGS_MAIN_SCREEN_HEIGHT -1

                //if(EngineListener.NotifyVideoMode(targetScreen))
                //{
                //    screen_loader.item.changeVideoMode()
                //}
                root.Update()

            }
            break;


            case APP.const_APP_SETTINGS_MAIN_STATE_VOICE:
            {
                if ( voice_loader.status != Loader.Ready )
                {
                    switch(SettingsStorage.languageType)
                    {
                    case Settings.SETTINGS_LANGUAGE_AR:
                    {
                        voice_loader.source = "../qml_arab/DHAVN_AppSettings_Voice.qml"
                    }
                    break
                    default:
                    {
                        voice_loader.source = "DHAVN_AppSettings_Voice.qml"
                    }
                    break
                    }
                }
            }
            break;

            case APP.const_APP_SETTINGS_MAIN_STATE_GENERAL:
            {
                if ( general_loader.status != Loader.Ready )
                {
                    switch(SettingsStorage.languageType)
                    {
                    case Settings.SETTINGS_LANGUAGE_AR:
                    {
                        general_loader.source = "../qml_arab/DHAVN_AppSettings_General.qml"
                    }
                    break
                    default:
                    {
                        general_loader.source = "DHAVN_AppSettings_General.qml"
                    }
                    break
                    }
                }
            }
            break;

            //added for AA/CP Setting
            case APP.const_APP_SETTINGS_MAIN_STATE_CONNECTIVITY:
            {
                if ( connectivity_loader.status != Loader.Ready )
                {
                    switch(SettingsStorage.languageType)
                    {
                    case Settings.SETTINGS_LANGUAGE_AR:
                    {
                        connectivity_loader.source = "../qml_arab/DHAVN_AppSettings_Connectivity.qml"
                    }
                    break
                    default:
                    {
                        connectivity_loader.source = "DHAVN_AppSettings_Connectivity.qml"
                    }
                    break
                    }
                }
            }
            break;
            //added for AA/CP Setting

            }

            root.state = mainState
        }

        /*
        onShowPopUpInfo:
        {
            if ( targetScreen != UIListener.getCurrentScreen() )
                return;
            popinfo_loader.source = popupFileName
            popinfo_loader.item.showPopUp()
        }
        */

        onKeyEvent:
        {
            if ( targetScreen != UIListener.getCurrentScreen() )
                return;

            if( nEventKey == Settings.SETTINGS_EVT_KEY_BACK && nStatus == Settings.SETTINGS_EVT_KEY_STATUS_PRESSED )
            {
                if(rootPopUpLoader.source != "" && rootPopUpLoader.item.visible == true)
                {
                    if (rootPopUpLoader.source == "file:///app/share/AppSettings/qml/DHAVN_AppSettings_Clock_TimePickerPopUp.qml" ||
                            rootPopUpLoader.source == "file:///app/share/AppSettings/qml_arab/DHAVN_AppSettings_Clock_TimePickerPopUp.qml" )
                    {
                        EngineListener.setTimePickerPopupStatus(false)
                    }

                    //added for AA/CP Setting
                    EngineListener.printLogMessage("[Main]onKeyEvent: EVT_KEY_BACK: source!=null ")
                    if(rootPopUpLoader.source == "file:///app/share/AppSettings/qml/DHAVN_AppSettings_Connectivity_CarplayPopUp.qml")
                    {
                        rootPopUpLoader.item.closePopUp(false, Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP)
                    }
                    else
                        rootPopUpLoader.item.closePopUp(false, 0)

                    root.handleJogEvent(UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_PRESSED)
                }
                else
                {
                    //console.log("root.backButtonHandler() :: ")

                    root.backButtonHandler(eventTarget)
                }
            }
        }

        /*
        onShowListDVISearchSetting:
        {
            video_control_search.visible = true
        }
        */

        onSelectionDoneFromSearch:
        {
            root.backButtonHandler();
        }
    }

    Connections {
        target: UIListener

        onSignalShowSystemPopup: {
            //console.log("target: UIListener: onSignalShowSystemPopup")
            isShowSystemPopup = true
            root.hideFocus()

            if(rootPopUpLoader.source != "" && rootPopUpLoader.item.visible == true)
            {
                rootPopUpLoader.item.closePopUp(false, 0)
            }

            //close all popup
            rootPopUpLoader.visible = false
        }

        onSignalHideSystemPopup: {
            //console.log("target: UIListener: onSignalHideSystemPopup")
            isShowSystemPopup = false
            root.showFocus()
            backHome()
        }
    }

    Connections{
        target: ( (rootPopUpLoader.visible) || (rootToastPopUpLoader.visible) ) ? null : UIListener

        onSignalJogNavigation:
        {
            switch ( arrow )
            {
            case UIListenerEnum.JOG_UP:
            case UIListenerEnum.JOG_RIGHT:
            case UIListenerEnum.JOG_DOWN:
            case UIListenerEnum.JOG_LEFT:
            case UIListenerEnum.JOG_CENTER:
            {
                root.visualCue(arrow, status);
                root.handleJogEvent( arrow, status, bRRC );
                break;
            }

            case UIListenerEnum.JOG_WHEEL_RIGHT:
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                root.handleJogEvent( arrow, status, bRRC );
                break;
            }
            }
        }
    }

    Connections{
        target: EngineListener

        onShowStartFocus:
        {
            if ( targetScreen != UIListener.getCurrentScreen() )
                return;

            root.hideFocus()
            root.setDefaultFocus( UIListenerEnum.JOG_DOWN )
            root.showFocus()
        }

        /*
        onHideFocus:
        {
            if ( targetScreen != UIListener.getCurrentScreen() )
                return;
            //root.hideFocus()
        }
        */

        onResetScreen: {
            if ( targetScreen != UIListener.getCurrentScreen() )
                return;

            root.state = ""

            if(pageManager.count() > 0)
            {
                for(var i=0; i<pageManager.count(); i++)
                {
                    var lastItemIndex = pageManager.getLastItemIndex()
                    //console.log("[QML]Main:onResetScreen: if(pageManager.count() > 0): LastPageIndex:" + pageManager.getLastItemIndex())
                    var rootState = pageManager.getRootState(i)
                    loader = pageManager.getLoaderByStateName(rootState)
                    loader.source = ""
                }
            }

            pageManager.clearAll()
        }

        onIsParkingModeChanged:
        {
            //console.log("[QML][Main]onIsParkingModeChanged: isParking = " + isParking)
            if ( targetScreen != UIListener.getCurrentScreen() )
                return;

            root.isParkingMode = isParking
        }

        /*
        onDcSwapChanged:
        {
            console.log("[QML][Main]onDcSwapChanged: EngineListener.dcSwapped = "+EngineListener.dcSwapped)
        }
        */
    }

    states:
        [
        State{
            name: APP.const_APP_SETTINGS_MAIN_STATE_SOUND
        },
        State{
            name: APP.const_APP_SETTINGS_MAIN_STATE_SCREEN
        }, //added for DH PE DRS
        State{
            name: APP.const_APP_SETTINGS_MAIN_STATE_SCREEN_DRS
        },
        State{
            name: APP.const_APP_SETTINGS_MAIN_STATE_VOICE
        },
        State{
            name: APP.const_APP_SETTINGS_MAIN_STATE_SYSTEM
        },
        State{
            name: APP.const_APP_SETTINGS_MAIN_STATE_CLOCK
        },
        State{
            name: APP.const_APP_SETTINGS_MAIN_STATE_GENERAL
        },
        State{
            name: APP.const_APP_SETTINGS_MAIN_STATE_KEYPAD
        }, //added for AA/CP Setting
        State{
            name: APP.const_APP_SETTINGS_MAIN_STATE_CONNECTIVITY
        },
        State{
            name: APP.const_APP_SETTINGS_GENERAL_STATE_WAITING
            PropertyChanges{target: visualCue; visible: false}
        }
    ]

    /*
    //Detective JukeBox Image for Waiting Screen
    Image{
        source: SettingsStorage.photoPath
        visible: false

        onStatusChanged: {
            if(status == Image.Null)
            {
                SettingsStorage.SetDefaultWatingImage()
            }

            else if (status == Image.Error)
            {
                SettingsStorage.SetDefaultWatingImage()
            }
        }
    }
    */

    onStateChanged:
    {
        root.hideFocus()
        root.setDefaultFocus( UIListenerEnum.JOG_DOWN )
        root.showFocus()
    }
}
