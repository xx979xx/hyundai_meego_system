import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import "Components/ScrollingTicker"
import AppEngineQMLConstants 1.0

DHAVN_AppSettings_FocusedItem{
    id: androidConnectivity

    state: ""
    name: "Connectivity_Android"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 699//649/*699*/

    default_x: 0
    default_y: 0

    property bool isFirstSelect: false
    property bool isAndroidAutoPopUpOn: false

    Connections{
        target:EngineListener

        onSigConnectedCarMounted:
        {
            EngineListener.printLogMessage("AndroidAuto: onSigConnectedCarMounted:  " + androidConnectivity.visible )
            if(androidConnectivity.visible)
            {
                if(isAndroidAutoPopUpOn)
                {
                    root.backButtonHandler(0)
                }

                root.backButtonHandler(0)
                isAndroidAutoPopUpOn = false

            }

        }

        onSigConnectedCarPluged:
        {
            EngineListener.printLogMessage("AndroidAuto: onSigConnectedCarPluged:  " + androidConnectivity.visible )
            if(androidConnectivity.visible)
            {
                if(isAndroidAutoPopUpOn)
                {
                    root.backButtonHandler(0)
                }
                root.backButtonHandler(0)
                isAndroidAutoPopUpOn = false
            }
        }
    }

    property bool menuCheckStates: (SettingsStorage.androidSetting == 1) ? true: false
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

    function selectmenu()
    {
        SettingsStorage.androidSetting = 0
        SettingsStorage.SaveSetting( 0, Settings.DB_KEY_ANDROID_SETTING )
        EngineListener.NotifyApplication(Settings.DB_KEY_ANDROID_SETTING, 0, "", UIListener.getCurrentScreen())
        SettingsStorage.setCarPlaySettingValue();
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {

            var ratioVal = SettingsStorage.androidSetting

            SettingsStorage.SaveSetting( ratioVal, Settings.DB_KEY_ANDROID_SETTING )
            EngineListener.NotifyApplication(Settings.DB_KEY_ANDROID_SETTING, ratioVal, "", UIListener.getCurrentScreen())
            SettingsStorage.setCarPlaySettingValue();
        }
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
                text: qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_ANDROID_MENU")) + LocTrigger.empty
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

                        if(SettingsStorage.androidSetting == 0)
                        {
                            EngineListener.showPopapInMainArea(Settings.SETTINGS_CONNECTIVITY_ANDROID_POPUP, UIListener.getCurrentScreen())
                            isAndroidAutoPopUpOn = true;

                        }
                        else
                        {
                            androidConnectivity.selectmenu()


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

                        if(SettingsStorage.androidSetting == 0)
                        {
                            EngineListener.showPopapInMainArea(Settings.SETTINGS_CONNECTIVITY_ANDROID_POPUP, UIListener.getCurrentScreen())
                            isAndroidAutoPopUpOn = true;

                        }
                        else
                        {
                            androidConnectivity.selectmenu()

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
                    rootConnectivity.setVisualCue(true, false, true, false)
            }
        }


    Text{
        id: appText1
        width: 560//510
        anchors.verticalCenter: parent.top

        anchors.verticalCenterOffset: 310/*367*/
        anchors.left: parent.left
        anchors.leftMargin: 14//60/*14*/
        visible : true
        text: {
            qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_ANDROIDAUTO_INFO_1"))+ "\n"
            + qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_ANDROIDAUTO_INFO_2"))+ "\n"
            + qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_VR"))+ "\n"
            + qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_ANDROIDAUTO_INFO_3"))
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
            target:rootPopUpLoader
            onIsYesAndroidAuto:
            {
                EngineListener.printLogMessage("Android Auto: onIsYesCarPlay ")
                isFirstSelect = false
                var ratioVal = 1
                SettingsStorage.androidSetting = ratioVal
                SettingsStorage.SaveSetting( ratioVal, Settings.DB_KEY_ANDROID_SETTING )
                EngineListener.NotifyApplication(Settings.DB_KEY_ANDROID_SETTING, ratioVal, "", UIListener.getCurrentScreen())
                EngineListener.printLogMessage("Android Auto: setCarPlaySettingValue() : strat --> ")
                SettingsStorage.setCarPlaySettingValue();
                EngineListener.printLogMessage("Android Auto: setCarPlaySettingValue() : end <-- ")

                EngineListener.setConnectivityPopUpOnOff(false)
                isAndroidAutoPopUpOn = false
            }
            onIsNoAndroidAuto:
            {
                EngineListener.printLogMessage("Android Auto: onIsNoCarPlay ")
                isFirstSelect = false
                EngineListener.setConnectivityPopUpOnOff(false)
                isAndroidAutoPopUpOn = false
            }
        }


    }

}












