import QtQuick 1.1
import QmlPopUpPlugin 1.0 as PopUps
import com.settings.variables 1.0
import com.settings.defines 1.0
import PopUpConstants 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES

DHAVN_AppSettings_FocusedItem{
    id: rootClockMain

    //property bool isGPSTimeSettingsOn
    //property int isGpsSettings
    property bool isDomestic: (SettingsStorage.currentRegion == 0) ? true : false
    property bool isNa: (SettingsStorage.currentRegion == 1) ? true : false
    property bool isCanada: (SettingsStorage.currentRegion == 6) ? true : false
    property bool ischina:(SettingsStorage.currentRegion == 2) ? true : false
    property bool isGeneral:(SettingsStorage.currentRegion == 3) ? true : false
    property int clockType
    property int timeType

    property bool isShowTimeSettingPopup:false

    property bool bCalendarOn
    property int calendarType
    //property bool isSummerTimeOn: summertimevalue()

    x: 0; y: 0; width: 1280; height: 554

    name: "rootClockMain"
    focus_x: 0
    focus_y: 0
    default_x: 0
    default_y: 0

    function getItemIndex(itemNumber)
    {
        var retVal = -1
        for(var i=0; i<list_model.count;i++)
        {
            if(list_model.get(i).itemNum == itemNumber)
            {
                retVal = i
                return retVal
            }
        }
        return retVal
    }

    function setRootState( index )
    {
        //console.log("[QML][Clock]setRootState():list_model.get(index).nameOfState:"+list_model.get(index).nameOfState)
        rootClockMain.state = list_model.get(index).nameOfState
    }

    function setVisualCue(up, down, left, right)
    {
        visualCue.upArrow = up
        visualCue.downArrow = down
        visualCue.leftArrow = left
        visualCue.rightArrow = right
    }

    function setVisualCueOnMenu( index )
    {
        switch (list_model.get(index).itemNum)
        {
        case APP.const_SETTINGS_CLOCK_GPS_TIME        : setVisualCue(true, false, false, false); visualCue.longkey_other = true; break
        case APP.const_SETTINGS_CLOCK_TIME_SETTING    : setVisualCue(true, false, false, false); visualCue.longkey_other = true; break
        case APP.const_SETTINGS_CLOCK_DAYLIGHT_SAVING : setVisualCue(true, false, false, false); visualCue.longkey_other = true; break
        case APP.const_SETTINGS_CLOCK_TIME_ZONE       : setVisualCue(true, false, false, true); visualCue.longkey_other = true;  break
        case APP.const_SETTINGS_CLOCK_CLOCK_TYPE      : setVisualCue(true, false, false, true); visualCue.longkey_other = true;  break
        case APP.const_SETTINGS_CLOCK_TIME_FORMAT     : setVisualCue(true, false, false, true); visualCue.longkey_other = true;  break
        }
    }

    function init()
    {
        timeType = SettingsStorage.timeType
        clockType = SettingsStorage.clockType

        content_clock.hideFocus()
        content_clock.setFocusHandle(0,0)
        content_clock.showFocus()
    }

    function checkUncheckGPS()
    {
        if ( SettingsStorage.gpsTime )
        {
            SettingsStorage.gpsTime = false
            SettingsStorage.SettingsModeChange(false);
            SettingsStorage.SaveSetting( 0, Settings.DB_KEY_GPS_TIME_SETTINGS )
            EngineListener.NotifyApplication( Settings.DB_KEY_GPS_TIME_SETTINGS, 0, "", UIListener.getCurrentScreen())
        }
        else
        {
            SettingsStorage.gpsTime = true
            SettingsStorage.SettingsModeChange(true);
            SettingsStorage.SaveSetting( 1, Settings.DB_KEY_GPS_TIME_SETTINGS )
            EngineListener.NotifyApplication( Settings.DB_KEY_GPS_TIME_SETTINGS, 1, "", UIListener.getCurrentScreen())
        }

        if (isNa || isCanada)
        {
            list_model.setItems()
        }
    }

    function checkUncheck_SummerTime()
    {

        if (SettingsStorage.summerTime)
        {
            //SettingsStorage.summerTime = false
            SettingsStorage.SaveSetting( 1, Settings.DB_KEY_SUMMER_TIME )

            SettingsStorage.summerTimeSet = true
            SettingsStorage.SaveSetting( 1, Settings.DB_KEY_SUMMER_TIME_SET )
            SettingsStorage.updateTimeZoneToSystem(false)
            EngineListener.NotifyApplication(Settings.DB_KEY_SUMMER_TIME, 1, "", UIListener.getCurrentScreen() )
        }
        else
        {
            //SettingsStorage.summerTime = true
            SettingsStorage.SaveSetting( 0, Settings.DB_KEY_SUMMER_TIME )

            SettingsStorage.summerTimeSet = true
            SettingsStorage.SaveSetting( 1, Settings.DB_KEY_SUMMER_TIME_SET )
            SettingsStorage.updateTimeZoneToSystem(false)
            EngineListener.NotifyApplication( Settings.DB_KEY_SUMMER_TIME, 0, "", UIListener.getCurrentScreen() )
        }
    }

    function summertimevalue()
    {
        if( !SettingsStorage.summerTimeSet )
        {
            if ((isDomestic || isGeneral || ischina))
            {
                SettingsStorage.summerTime = 0
                SettingsStorage.summerTimeSet = 1
                SettingsStorage.SaveSetting(0, Settings.DB_KEY_SUMMER_TIME )
                SettingsStorage.SaveSetting(1, Settings.DB_KEY_SUMMER_TIME_SET)
            }
            else
            {
                SettingsStorage.summerTime = 1
                SettingsStorage.summerTimeSet = 1
                SettingsStorage.SaveSetting( 1, Settings.DB_KEY_SUMMER_TIME );
                SettingsStorage.SaveSetting( 1, Settings.DB_KEY_SUMMER_TIME_SET);
            }
        }
    }

    function setFocusCurrentMenu()
    {
        content_clock.__current_x = 0
        content_clock.__current_y = 0

        var index = content_clock.searchIndex( content_clock.__current_x, content_clock.__current_y)
        content_clock.__current_index = index

        content_clock.setFocus(content_clock.focus_x, content_clock.focus_y)
    }

    function setFocusByDimmed(index)
    {
        if(list_model.get(index).isDimmed)
        {
            for(var i=0; i<list_model.count; i++)
            {
                if(!list_model.get(i).isDimmed)
                {
                    rootClockMain.setRootState(i)
                    return
                }
            }
        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_clock
        name: "content clock"
        focus_x: 0
        focus_y: 0
        default_x: 0
        default_y: 0

        onFocus_visibleChanged:
        {
            if(focus_visible)
            {
                if(is_focused_BackButton)
                    menu.moveFocus(1,0)

                is_focused_BackButton = false
            }
        }

        // Bg Border
        DHAVN_AppSettings_Cue_Bg_Main{
            id: idCueSettings
            property bool isRightBg:false
            z:1
        }

        Image{
            anchors.top: idCueSettings.top
            anchors.topMargin:73
            anchors.left: idCueSettings.left
            visible: (!idCueSettings.isRightBg) && (isBrightEffectShow)
            source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_L_BRIGHT
        }

        Image{
            anchors.top: idCueSettings.top
            anchors.topMargin:73
            anchors.left: idCueSettings.left
            visible: idCueSettings.isRightBg && (isBrightEffectShow)
            source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_R_BRIGHT
        }

        DHAVN_AppSettings_Menu{
            id: menu
            x: 0; y: 73

            menu_model: list_model

            focus_x: 0
            focus_y: 0

            onSelectItem:
            {
                //console.log("[QML][Clock]onSelectItem:")
                if(!bJog)
                {
                    content_clock.hideFocus()
                    setFocusCurrentMenu()
                }

                rootClockMain.setRootState(item)

                switch(list_model.get(item).itemNum)
                {
                case APP.const_SETTINGS_CLOCK_TIME_SETTING:
                {
                    if(SettingsStorage.isNaviVariant && SettingsStorage.naviSDCard)
                    {
                        if(!SettingsStorage.gpsTime)
                        {
                            rootPopUpLoader.showPopupDirectly("DHAVN_AppSettings_Clock_TimePickerPopUp.qml")
                            rootPopUpLoader.item.showPopUp()
                            isShowTimeSettingPopup = true
                        }
                    }
                    else
                    {
                        rootPopUpLoader.showPopupDirectly("DHAVN_AppSettings_Clock_TimePickerPopUp.qml")
                        rootPopUpLoader.item.showPopUp()
                        isShowTimeSettingPopup = true
                    }
                }
                break
                case APP.const_SETTINGS_CLOCK_GPS_TIME:
                {
                    checkUncheckGPS()
                }
                break
                case APP.const_SETTINGS_CLOCK_DAYLIGHT_SAVING:
                {
                    SettingsStorage.showToastPopup(Settings.SETTINGS_TOAST_DAYLIGHT_SAVINGS_TIME_CHANGING) //added for ITS 217706 daylight savings time not sync
                    //checkUncheck_SummerTime()
                    if (SettingsStorage.summerTime)
                    {
                        SettingsStorage.summerTime = false
                    }
                    else
                    {
                        SettingsStorage.summerTime = true
                    }

                    summerTimeSetTimer.restart()
                    console.log("[QML]show loading popup -------->");

                }
                break
                }

                if(!bJog)
                {
                    moveFocus(1,0)

                    //modified for ITS 258699 Daylight Savings Time PopUp Focus Issue//ITS262131
                    if(list_model.get(item).itemNum != APP.const_SETTINGS_CLOCK_TIME_SETTING
                            && list_model.get(item).itemNum != APP.const_SETTINGS_CLOCK_DAYLIGHT_SAVING)
                        content_clock.showFocus()
                }
            }

            onCurrentIndexChanged:
            {
                //console.log("[QML][Clock]onCurrentIndexChanged:")
                rootClockMain.setRootState(currentIndex)

                if (focus_visible)
                    rootClockMain.setVisualCueOnMenu(currentIndex)

                if(currentIndex >= 0) menu.selected_item = currentIndex
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    idCueSettings.isRightBg = false
                    setVisualCueOnMenu(menu.selected_item)
                }
            }

            onMovementEnded:
            {
                if(!focus_visible)
                {
                    content_clock.hideFocus()
                    content_clock.setFocusHandle(0,0)
                    if(isShowSystemPopup == false)
                    {
                        content_clock.showFocus()
                    }
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: gpsReceptionLoader

            focus_x: 1
            focus_y: 0

            visible: rootClockMain.state == "set_gps_reception"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(status != Loader.Ready)
                    {
                        source = "DHAVN_AppSettings_Clock_GPS_Reception.qml"
                    }
                }
                else
                {
                    hideFocus()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = gpsReceptionLoader.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: clockTimeSettingLoader

            focus_x: 1
            focus_y: 0

            visible: rootClockMain.state == "set_time_setting"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                    {
                        source = "DHAVN_AppSettings_Clock_Time_Setting.qml"
                    }
                }
                else
                {
                    hideFocus()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = clockTimeSettingLoader.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: daylightSavingLoader

            focus_x: 1
            focus_y: 0

            visible: rootClockMain.state == "set_daylight_saving"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Clock_Daylight_Saving.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = daylightSavingLoader.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: timeZoneLoader

            focus_x: 1
            focus_y: 0

            visible: rootClockMain.state == "set_time_zone"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if ( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Clock_TimeZone.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = timeZoneLoader.focus_visible
                    menu.hideFocus()
                }
            }

            onStatusChanged:
            {
                if(status == Loader.Ready)
                    timeZoneLoader.item.init()
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: clockTypeLoader

            focus_x: 1
            focus_y: 0

            visible: rootClockMain.state == "set_clock_type"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if ( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Clock_ClockType.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = clockTypeLoader.focus_visible
                    menu.hideFocus()
                }
            }

            onStatusChanged:
            {
                if(status == Loader.Ready)
                    clockTypeLoader.item.init()
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: clockTimeFormatLoader

            focus_x: 1
            focus_y: 0

            visible: rootClockMain.state == "set_time_format"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if ( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Clock_Time_Format.qml"

                    clockTimeFormatLoader.item.init()
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    clockTimeFormatLoader.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = clockTimeFormatLoader.focus_visible
                    menu.hideFocus()
                }
            }
        }

    }

    ListModel{
        id: list_model

        function setItems()
        {
            //init
            list_model.clear()

            //if(SettingsStorage.isNaviVariant && SettingsStorage.naviSDCard)
            if(SettingsStorage.isNaviVariant)
            {
                list_model.append({"itemNum":APP.const_SETTINGS_CLOCK_GPS_TIME ,"isCheckNA": true,  "isChekedState": SettingsStorage.gpsTime,
                                      "isDimmed": !SettingsStorage.naviSDCard, "isPopupItem":false, "dbID": Settings.DB_KEY_GPS_TIME_SETTINGS,
                                      name: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_SET_GPS"),
                                      nameOfState: "set_gps_reception"})
            }

            list_model.append({"itemNum":APP.const_SETTINGS_CLOCK_TIME_SETTING, "isCheckNA": false,  "isChekedState": false,
                                  "isDimmed": (SettingsStorage.isNaviVariant && SettingsStorage.naviSDCard) ? SettingsStorage.gpsTime : false,
                                  "isPopupItem":true, "dbID": 0, name: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_TIME_SETTINGS"),
                                   nameOfState: "set_time_setting"})

            if(!(isDomestic || isGeneral))
            {
                list_model.append({"itemNum":APP.const_SETTINGS_CLOCK_DAYLIGHT_SAVING, "isCheckNA": true,  "isChekedState": SettingsStorage.summerTime,
                                      "isDimmed": false, "isPopupItem":false, "dbID": Settings.DB_KEY_SUMMER_TIME,
                                      name: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_SUMMER_TIME"),
                                      nameOfState: "set_daylight_saving"})
            }

            if( (isNa || isCanada) && ( !SettingsStorage.gpsTime || !SettingsStorage.isNaviVariant || !SettingsStorage.naviSDCard) )
            {
                list_model.append({"itemNum":APP.const_SETTINGS_CLOCK_TIME_ZONE, "isCheckNA": false, "isChekedState": false, "isDimmed": false, "isPopupItem":false, "dbID": 0,
                                      name: QT_TR_NOOP("STR_SETTING_CLOCK_TIMEZONE"),
                                      nameOfState: "set_time_zone"})
            }
            //added for DH PE
            //list_model.append({"itemNum":APP.const_SETTINGS_CLOCK_CLOCK_TYPE, "isCheckNA": false,  "isChekedState": false, "isDimmed": false, "isPopupItem":false, "dbID": 0,
            //                      name: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_TYPE"),
            //                      nameOfState: "set_clock_type"})

            list_model.append({"itemNum":APP.const_SETTINGS_CLOCK_TIME_FORMAT, "isCheckNA": false, "isChekedState": false, "isDimmed": false, "isPopupItem":false, "dbID": 0,
                                  name: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_TIME_TYPE"),
                                  nameOfState: "set_time_format"})

            rootClockMain.hideFocus()
            rootClockMain.setFocusHandle(0,0)
            rootClockMain.showFocus()

        }

        Component.onCompleted:
        {
            setItems()
        }
    }

    Connections {
        target: EngineListener

        onSigNaviSdcardRemoved:
        {
            console.log("[QML][CLOCK]onSigNaviSdcardRemoved: If Current Region is NA, Changed List-Model")

            //SettingsStorage.gpsTime = false //modify for GPS checkBox 13/12/27
            //SettingsStorage.SettingsModeChange(false); //delete for GPS Time CAN Date Issue

            list_model.setItems()
            menu.menu_model = list_model

            rootClockMain.state = "set_time_setting"

            // Move Focus
            //content_clock.hideFocus()
            //setFocusCurrentMenu()
            //rootClockMain.state = "set_time_setting"
            //content_clock.showFocus()
        }
    }

    Connections{
        target:SettingsStorage

        onGpsTimeChanged:
        {
            console.log("clock_main.qml :: onGpsTimeChanged :: " + SettingsStorage.gpsTime)

            var index = -1
            index = getItemIndex(APP.const_SETTINGS_CLOCK_GPS_TIME)

            if(index != -1)
                list_model.setProperty(index,"isChekedState", SettingsStorage.gpsTime)

            index = -1
            index = getItemIndex(APP.const_SETTINGS_CLOCK_TIME_SETTING)

            if(index != -1)
            {
                list_model.setProperty(index,"isDimmed", SettingsStorage.gpsTime)

                if(SettingsStorage.gpsTime)
                {
                    if(menu.selected_item == index)
                        setFocusByDimmed(menu.selected_item)
                }
            }

            if(SettingsStorage.gpsTime)
            {
                if(rootPopUpLoader.visible)
                {
                    rootPopUpLoader.item.closePopUp(false, Settings.SETTINGS_TIME_PICKER_POPUP)
                    rootPopUpLoader.visible = false
                }
            }
        }

        onSummerTimeChanged:
        {
            var index = -1
            index = getItemIndex(APP.const_SETTINGS_CLOCK_DAYLIGHT_SAVING)

            if(!isDomestic)
            {
                if(index != -1)
                    list_model.setProperty(index,"isChekedState", SettingsStorage.summerTime)
            }
        }

        onNaviSDCardChanged:
        {
            if(SettingsStorage.naviSDCard)
            {
                list_model.setItems()
                menu.menu_model = list_model

                if(SettingsStorage.gpsTime && rootClockMain.state == "set_time_setting")
                {
                    rootClockMain.state = "set_gps_reception"
                }
            }
        }
    }

    Connections{
        target:rootPopUpLoader
        //added for ITS 218729 GPS remain Check State and Focus Issue
        onIsYesBtnState:
        {
            console.log("[QML][Clock]onIsYesBtnState:"+isOk)
            if(isOk){
                SettingsStorage.gpsTime = false;
                SettingsStorage.SettingsModeChange(false); //added for GPS Time CAN Date Issue
            }
        }
        //added for ITS 218729 GPS remain Check State and Focus Issue
        onVisibleChanged:
        {
            //console.log("[QML][Clock]rootPopUpLoader.onVisibleChanged:"+rootPopUpLoader.visible)
            if(!(rootPopUpLoader.visible))
            {
                //console.log("[QML][Clock]rootPopUpLoader.isShowTimeSettingPopup:"+rootClockMain.isShowTimeSettingPopup)

                if(rootClockMain.isShowTimeSettingPopup)
                {
                    //console.log("[QML][Clock]rootPopUpLoader.SettingsStorage.gpsTime:"+SettingsStorage.gpsTime)

                    if(SettingsStorage.gpsTime)
                    {
                        if( rootClockMain.state == "set_time_setting" && SettingsStorage.naviSDCard) //added for ITS 218729 GPS remain Check State and Focus Issue
                        {
                            //console.log("[QML][Clock]rootClockMain.state == set_time_setting")
                            content_clock.hideFocus()
                            setFocusCurrentMenu()

                            rootClockMain.state = "set_gps_reception"

                            content_clock.showFocus()
                        }
                    }

                    isShowTimeSettingPopup = false
                }
            }
        }
    }

    states:
        [
        State{
            name: "set_gps_reception"
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_CLOCK_GPS_TIME) }
        },
        State{
            name: "set_time_setting"
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_CLOCK_TIME_SETTING) }
        },
        State{
            name: "set_daylight_saving"
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_CLOCK_DAYLIGHT_SAVING) }
        },
        State{
            name: "set_time_zone"
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_CLOCK_TIME_ZONE) }
        },
        State{
            name: "set_clock_type"
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_CLOCK_CLOCK_TYPE) }
        },
        State{
            name: "set_time_format"
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_CLOCK_TIME_FORMAT) }
        }
    ]

    Timer {
        id: summerTimeSetTimer

        interval: 500

        repeat: false

        onTriggered: checkUncheck_SummerTime()
    }
}
