import QtQuick 1.1
import com.settings.variables 1.0
import com.settings.defines 1.0
import "DHAVN_AppSettings_General.js" as APP

DHAVN_AppSettings_FocusedLoader{
    id: toastPopupMain
    name: "ToastPopUpLoader"
    anchors.fill: parent
    visible: false

    property int nPopup_type: -1

    property bool resetingSound: false
    property bool resetingScreen: false
    property bool resetingAll: false
    property bool isChangeDaylightTime : false //added for ITS 217706 daylight savings time not sync
    property bool isChangeLanguage: false //added for ITS271869 VisualCue issue

    // Toast Popup Show 함수
    function showToastPopup(popupType)
    {
        /**
         * 1. 팝업, 토스트 팝업 Loader의 visible이 false일 경우, Jog-Controll이 가능(in Main QML)하므로,
         * 2. 초기화 팝업(사운드, 화면, 전체)의 경우, 팝업 Loader의 visible을 false로 변경하지 않고, 참조하고 있는 item의 visible을 false로 변경
         * 3. 토스트 팝업의 Loader visible이 true가 되었을 때, 팝업 Loader의 visible을 false로 변경
         * 4. 위와 같이 수정한 이유는, 팝업이 사라지고 토스트 팝업이 출력되는 사이에 Jog-Center Press시, 동작되는 문제를 방지.
         **/
        if(rootPopUpLoader.visible)
            rootPopUpLoader.item.visible = false

        nPopup_type = popupType

        switch(popupType)
        {
        case Settings.SETTINGS_TOAST_RESET_START:
        {
            source = "DHAVN_AppSettings_ToastPopup_ResetStart.qml"
            visible = true
        }
        break

        case Settings.SETTINGS_TOAST_RESET_COMPLETE:
        {
            source = "DHAVN_AppSettings_ToastPopup_ResetComplete.qml"
            visible = true
            toastCloseTimer.running = true
        }
        break

        case Settings.SETTINGS_TOAST_FORMAT_START:
        {
            source = "DHAVN_AppSettings_ToastPopup_FormatInProgress.qml"
            visible = true
        }
        break

        case Settings.SETTINGS_TOAST_FORMAT_COMPLETE:
        {
            source = "DHAVN_AppSettings_ToastPopup_FormatComplete.qml"
            visible = true
            toastCloseTimer.running = true
        }
        break

        case Settings.SETTINGS_TOAST_LANGUAGE_CHANGING:
        {
            source = "DHAVN_AppSettings_ToastPopup_LanguageChanged.qml"
            isChangeLanguage = true; //added for ITS271869 VisualCue issue
            visible = true
            toastCloseTimer.running = true
        }
        break

        case Settings.SETTINGS_TOAST_TIME_SETTING_COMPLETE:
        {
            source = "DHAVN_AppSettings_ToastPopup_TimeSetting.qml"
            visible = true
            toastCloseTimer.running = true
        }
        break

        //added for ITS 217706 daylight savings time not sync
        case Settings.SETTINGS_TOAST_DAYLIGHT_SAVINGS_TIME_CHANGING:
        {
            isChangeDaylightTime = true;
            source = "DHAVN_AppSettings_ToastPopup_LanguageChanged.qml"
            visible = true
            toastCloseTimer.running = true
        }
        break
        //added for ITS 217706 daylight savings time not sync
        }

        if(rootPopUpLoader.visible)
            rootPopUpLoader.visible = false
    }

    Timer{
        id: toastCloseTimer

        interval: 3000
        running: false

        onTriggered:
        {
            if(isChangeDaylightTime)
            {
                console.log("[QML] Disable Daylight saving PopUp Text ::")
                isChangeDaylightTime = false
            }
            //added for ITS271869 VisualCue issue
            if(isChangeLanguage){
                setDefaultFocusLanguageChanged();
                isChangeLanguage = false;
            }

            toastPopupMain.visible = false
        }
    }

    // Toast Popup Source으로부터 Tab/Jog 동작에 대한 이벤트가 발생시 closePopup signal을 발생.
    Connections{
        target: (status == Loader.Ready) ? item : null
        onClosePopUp:
        {
            //console.log("[QML][ToastPopupLoader]onClosePopUp:isReceivedEvent=>"+isReceivedEvent)
            if( isReceivedEvent )
                toastPopupMain.visible = false
        }
    }

    // When loader is hied, 참조했던 source는 unLoad 시킨다.
    onVisibleChanged:
    {
        if(!visible)
        {
            toastCloseTimer.running = false
            source = ""
        }
    }

    /////////////////////////////// Reset START////////////////////////////////////////////////
    Timer{
        id: resetStartTimer
        property int type: -1
        property int preSelectType: -1
        interval: 200
        repeat: false
        onTriggered:
        {
            switch(type)
            {
            case 0:
            {
                preSelectType = type
                SettingsStorage.ResetSoundSettings(true);
            }
            break
            case 1:
            {
                preSelectType = type
                SettingsStorage.StartResetScreenSetting()
            }
            break
            case 2:
            {
                preSelectType = type
                SettingsStorage.StartResetAllSetting()
            }
            break
            }

            type = -1
        }
    }

    // Reset Start Popup Show
    Connections{
        target: EngineListener

        onShowToastPopup :{
            switch(type) {
            case Settings.SETTINGS_RESET_SOUND_SETTINGS:
            {
                // different screen
                if ( screen != UIListener.getCurrentScreen() )
                {
                    if(pageManager.count() > 0)
                    {
                        if(pageManager.getRootState(0) != APP.const_APP_SETTINGS_MAIN_STATE_SOUND)
                        {
                            return;
                        }
                    }
                }

                toastPopupMain.showToastPopup(Settings.SETTINGS_TOAST_RESET_START)

                if ( screen == UIListener.getCurrentScreen() )
                {
                    resetStartTimer.type = 0
                    resetStartTimer.running = true
                }

                resetingSound = true
                toastCloseTimer.stop()

                //clearScreen()
            }
            break

            case Settings.SETTINGS_RESET_SCREEN_SETTINGS:
            {
                // different screen
                if ( screen != UIListener.getCurrentScreen() )
                {
                    if(pageManager.count() > 0)
                    {
                        if(pageManager.getRootState(0) != APP.const_APP_SETTINGS_MAIN_STATE_SCREEN)
                        {
                            return;
                        }
                    }
                }

                toastPopupMain.showToastPopup(Settings.SETTINGS_TOAST_RESET_START)

                if ( screen == UIListener.getCurrentScreen() )
                {
                    resetStartTimer.type = 1
                    resetStartTimer.running = true
                }

                //clearScreen()

                resetingScreen = true
                toastCloseTimer.stop()
            }
            break

            case Settings.SETTINGS_RESET_GENERAL_SETTINGS:
            {
                toastPopupMain.showToastPopup(Settings.SETTINGS_TOAST_RESET_START)

                if ( screen == UIListener.getCurrentScreen() )
                {
                    resetStartTimer.type = 2
                    resetStartTimer.running = true
                }

                resetingSound = false
                resetingScreen = false

                resetingAll = true
                toastCloseTimer.stop()
            }
            break
            }
        }
    }

    Connections
    {
        target: SettingsStorage

        onResetSoundCompleted:
        {
            if (resetingSound)
            {
                if (toastPopupMain.visible) {
                    resetStartTimer.running = false
                    toastPopupMain.showToastPopup(Settings.SETTINGS_TOAST_RESET_COMPLETE)
                }
                resetingSound = false
            }
        }

        onResetScreenCompleted:
        {
            if (resetingScreen)
            {
                if (toastPopupMain.visible) {
                    resetStartTimer.running = false
                    toastPopupMain.showToastPopup(Settings.SETTINGS_TOAST_RESET_COMPLETE)
                }
                resetingScreen = false
            }
        }

        onResetGeneralCompleted:
        {
            if (resetingAll)
            {
                if (toastPopupMain.visible) {
                    resetStartTimer.running = false
                    toastPopupMain.showToastPopup(Settings.SETTINGS_TOAST_RESET_COMPLETE)
                }
                resetingAll = false
            }
        }

        onShowLanguageChangingToastPopup:
        {
            if(pageManager.count() > 0)
            {
                if(pageManager.getRootState(0) != APP.const_APP_SETTINGS_MAIN_STATE_GENERAL)
                {
                    return;
                }
            }

            toastPopupMain.showToastPopup(Settings.SETTINGS_TOAST_LANGUAGE_CHANGING)
        }
        //added for ITS 217706 daylight savings time not sync
        onShowDaylightTimeChangingToastPopup:
        {
            toastPopupMain.showToastPopup(Settings.SETTINGS_TOAST_DAYLIGHT_SAVINGS_TIME_CHANGING)
        }
        //added for ITS 217706 daylight savings time not sync
    }
    /////////////////////////////// Reset END ///////////////////////////////////////////////

    /////////////////////////////// Format Start ////////////////////////////////////////////
    // 포맷 관련 Toast Popup Show
    Connections{
        target: JukeBoxInfo

        // 포맷이 시작되었다는 시그널을 받을 때, 포맷시작 토스트 팝업을 띄워준다.
        onFormattingStarted:
        {
            if ( screen != UIListener.getCurrentScreen() )
                return;

            showToastPopup(Settings.SETTINGS_TOAST_FORMAT_START)
        }

        // 포맷이 완료되었다는 시그널을 받을 때, 포맷완료 토스트 팝업으로 변경하여 준다.
        onFormatComplete:
        {
            if (toastPopupMain.visible) {
                showToastPopup(Settings.SETTINGS_TOAST_FORMAT_COMPLETE)
                EngineListener.NotifyAppsFormatCompleted()
                //SettingsStorage.SetDefaultWatingImage()
            }
        }
    }
    /////////////////////////////// Format End ////////////////////////////////////////////

    onStatusChanged:
    {
        if(status == Loader.Ready)
        {
            switch(nPopup_type)
            {
            case Settings.SETTINGS_TOAST_RESET_START:
            case Settings.SETTINGS_TOAST_RESET_COMPLETE:
            case Settings.SETTINGS_TOAST_FORMAT_START:
            case Settings.SETTINGS_TOAST_FORMAT_COMPLETE:
            case Settings.SETTINGS_TOAST_LANGUAGE_CHANGING:
            case Settings.SETTINGS_TOAST_TIME_SETTING_COMPLETE:
            case Settings.SETTINGS_TOAST_DAYLIGHT_SAVINGS_TIME_CHANGING: //added for ITS 217706 daylight savings time not sync
            {
                item.showPopUp();
            }
            break
            }
        }
    }
}
