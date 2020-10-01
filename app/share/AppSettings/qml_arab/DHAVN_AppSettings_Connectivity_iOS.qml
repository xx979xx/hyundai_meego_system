import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import "Components/ScrollingTicker"
import AppEngineQMLConstants 1.0

DHAVN_AppSettings_FocusedItem{
    id: iOSConnectivity

    state: ""
    name: "Connectivity_iOS"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 34//699

    default_x: 0
    default_y: 0

    property bool isFirstSelect: false
    property bool isCarPlayPopUpOn: false



    property bool menuCheckStates: (SettingsStorage.iOSSetting == 0) ? true: false
    function init()
    {


    }

    function getCurrentIndex()
    {

        return 0;
    }

    function setState(index)
    {


    }

    function selectMenu()
    {

        SettingsStorage.iOSSetting = 1
        SettingsStorage.SaveSetting( 1, Settings.DB_KEY_IOS_SETTING )
        EngineListener.NotifyApplication(Settings.DB_KEY_IOS_SETTING, 1, "", UIListener.getCurrentScreen())

        EngineListener.printLogMessage("Carplay: setCarPlaySettingValue() : strat --> ")
        SettingsStorage.setCarPlaySettingValue();
        EngineListener.printLogMessage("Carplay: setCarPlaySettingValue()")

    }


    DHAVN_AppSettings_FocusedItem{
        id: content_area
        width: 560
        height: 552

        default_x: 0
        default_y:0
        focus_x: 0
        focus_y: 0

        DHAVN_AppSettings_FocusedItem{
            id: checkboxitem
            width: 560
            height: 90//552

            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12

            focus_x: 0
            focus_y: 0

            property bool pressed: false
            property bool checked: menuCheckStates

            Image{
                id: line_image
                x:9; y:89
                source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
            }

            Image{
                id:checkbox_f_id
                anchors.top: line_image.top
                anchors.topMargin: -90
                anchors.left: line_image.left
                anchors.leftMargin: -9
                source: RES.const_URL_IMG_SETTINGS_B_BG_MENU_TAB_R_FOCUSED
                visible: checkboxitem.focus_visible && !checkboxitem.pressed && !checkbox_p_id.visible
            }

            Image{
                id:checkbox_p_id
                anchors.top: line_image.top
                anchors.topMargin: -90
                anchors.left: line_image.left
                anchors.leftMargin: -9
                source: RES.const_URL_IMG_SETTINGS_B_BG_MENU_TAB_R_PRESSED
                visible: checkboxitem.pressed
            }

            ScrollingTicker {
                id: scrollingTicker
                clip: true
                width: 443
                height: 89
                scrollingTextMargin: 120
                anchors.verticalCenter: line_image.top
                anchors.verticalCenterOffset: -45
                anchors.left: line_image.left
                anchors.leftMargin: 14
                isScrolling: checkboxitem.focus_visible && isParkingMode
                fontPointSize: 40
                fontFamily: EngineListener.getFont(false)
                text: qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY")) + LocTrigger.empty
                fontStyle: Text.Sunken
                fontColor: HM.const_COLOR_BRIGHT_GREY
            }

            Image{
                id: checkboxImage
                anchors.top: line_image.top
                anchors.topMargin: -68
                anchors.left: line_image.left
                anchors.leftMargin: 473
                source: checkboxitem.checked ? RES.const_URL_IMG_SETTINGS_B_CHECKED_S_URL : RES.const_URL_IMG_SETTINGS_B_CHECKED_N_URL
            }

            MouseArea{
                id: mouse_area1
                //anchors.fill: checkboxitem
                //enabled: EngineListener.isAccStatusOn
                x:0
                y:0
                width: 560
                height: 90

                onPressed:
                {
                    checkboxitem.pressed = true
                }

                onReleased:
                {
                    if(checkboxitem.pressed)
                    {
                        checkboxitem.pressed = false

                        parent.hideFocus()
                        parent.setFocusHandle(0,0)
                        parent.showFocus()

                        if(SettingsStorage.iOSSetting == 1)
                        {
                            EngineListener.showPopapInMainArea(Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP, UIListener.getCurrentScreen())
                            isCarPlayPopUpOn = true;


                        }
                        else
                        {
                            selectMenu()

                        }

                    }
                }

                onExited:
                {
                    checkboxitem.pressed = false
                }
            }

            onJogSelected:
            {
                switch( status )
                {
                case UIListenerEnum.KEY_STATUS_PRESSED:
                {
                    checkboxitem.pressed = true
                }
                break
                case UIListenerEnum.KEY_STATUS_RELEASED:
                {
                    if(checkboxitem.pressed)
                    {
                        checkboxitem.pressed = false

                        parent.hideFocus()
                        parent.setFocusHandle(0,0)
                        parent.showFocus()

                        if(SettingsStorage.iOSSetting == 1)
                        {
                            EngineListener.showPopapInMainArea(Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP, UIListener.getCurrentScreen())
                            isCarPlayPopUpOn = true;


                        }
                        else
                        {
                            selectMenu()
                            SettingsStorage.iOSSetting = 1

                        }
                    }
                }
                break

                case UIListenerEnum.KEY_STATUS_CANCELED:
                {
                     checkboxitem.pressed = false
                }
                break
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                    rootConnectivity.setVisualCue(true, false, false, true)
            }
        }



    Text{
        id: appText1
        width: 510
        anchors.verticalCenter: parent.top

        anchors.verticalCenterOffset: 310/*367*/
        anchors.left: parent.left
        anchors.leftMargin: 14//60/*14*/
        visible : true
        text: {
            qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY_INFO_1"))+ "\n"
            + qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY_INFO_2"))+ "\n"
            + qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_VR"))+ "\n"
            + qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY_INFO_3"))
            + LocTrigger.empty
        }
        color: APP.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 24
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }





    states: [
        State{
            name: APP.const_APP_SETTINGS_CONNECTIVITY_ANDROID_ONOFF
        }
    ]

    Connections{
        target:SettingsStorage

        onIOSSettingChanged:
        {
            //console.log("called onvolumeRatioChanged :"+SettingsStorage.volumeRatio)
            init()
        }
    }

    Connections{
        target:EngineListener

        onSigConnectedCarMounted:
        {
            EngineListener.printLogMessage("Carplay: onSigConnectedCarMounted:  " + iOSConnectivity.visible )
            if(iOSConnectivity.visible)
            {
                if(isCarPlayPopUpOn)
                {
                    root.backButtonHandler(0)
                }
                root.backButtonHandler(0)
                isCarPlayPopUpOn = false
            }

        }

        onSigConnectedCarPluged:
        {
            EngineListener.printLogMessage("Carplay: onSigConnectedCarPluged:  " + iOSConnectivity.visible )
            if(iOSConnectivity.visible)
            {
                if(isCarPlayPopUpOn)
                {
                    root.backButtonHandler(0)
                }
                root.backButtonHandler(0)
                isCarPlayPopUpOn = false
            }
        }
    }


    Connections{
            target:rootPopUpLoader
            onIsYesCarPlay:
            {
                EngineListener.printLogMessage("Carplay: onIsYesCarPlay ")
                isFirstSelect = false
                var ratioVal = 0
                SettingsStorage.iOSSetting = ratioVal
                SettingsStorage.SaveSetting( ratioVal, Settings.DB_KEY_IOS_SETTING )
                EngineListener.NotifyApplication(Settings.DB_KEY_IOS_SETTING, ratioVal, "", UIListener.getCurrentScreen())
                EngineListener.printLogMessage("Carplay: setCarPlaySettingValue() : strat --> ")
                SettingsStorage.setCarPlaySettingValue();
                EngineListener.printLogMessage("Carplay: setCarPlaySettingValue() : end <-- ")

                EngineListener.setConnectivityPopUpOnOff(false)
                isCarPlayPopUpOn = false
            }
            onIsNoCarPlay:
            {
                EngineListener.printLogMessage("Carplay: onIsNoCarPlay ")
                isFirstSelect = false
                EngineListener.setConnectivityPopUpOnOff(false)
                isCarPlayPopUpOn = false
            }
        }


    }


}


