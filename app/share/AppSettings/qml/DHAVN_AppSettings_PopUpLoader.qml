import QtQuick 1.1
import com.settings.variables 1.0
import com.settings.defines 1.0
import "DHAVN_AppSettings_General.js" as APP

DHAVN_AppSettings_FocusedLoader{
    id: popupMain
    name: "PopUpLoader"
    property int nPopup_type: -1
    property bool isYesBtnPressed: false

    function showPopupDirectly(sourcePath)
    {
        source = sourcePath
        visible = true
    }
    signal isYesCarPlay(); //added for AA/CP Setting
    signal isNoCarPlay();  //added for AA/CP Setting
    signal isYesAndroidAuto(); //added for Android Auto Setting
    signal isNoAndroidAuto();  //added for Android Auto Setting

    signal isYesBtnState(bool isOk) //added for ITS 218729 GPS remain Check State and Focus Issue
    Timer{
        id: startResetTimer
        interval: 100
        repeat: false
        onTriggered:
        {
            startReset()
        }
    }

    function startReset()
    {
        if (isYesBtnPressed)
        {
            switch(nPopup_type)
            {
            case Settings.SETTINGS_RESET_SOUND_SETTINGS:
            case Settings.SETTINGS_RESET_SCREEN_SETTINGS:
            case Settings.SETTINGS_RESET_GENERAL_SETTINGS:
            {
                EngineListener.PopupHandler(nPopup_type, UIListener.getCurrentScreen())
            }
            break
            case Settings.SETTINGS_CONFIRM_FORMAT_POPUP:
            {
                EngineListener.PopupHandler(nPopup_type, UIListener.getCurrentScreen())
            }
            break
            case Settings.SETTINGS_VR_NOT_SUPPORT_POPUP:
            {
                EngineListener.HandleBackKey( UIListener.getCurrentScreen() );
            }
            break
            case Settings.SETTINGS_TIME_PICKER_POPUP:
            {
                rootToastPopUpLoader.showToastPopup(Settings.SETTINGS_TOAST_TIME_SETTING_COMPLETE)
            }
            break
            //added for AA/CP Setting
            case Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP:
            {
                isYesCarPlay();
            }
            break

            case Settings.SETTINGS_CONNECTIVITY_ANDROID_POPUP:
            {
                isYesAndroidAuto();
            }
            break;
            }

            nPopup_type = -1
            isYesBtnPressed = false
        }
        else
        {
            EngineListener.printLogMessage("[PopUpLoader]startReset: else")
            switch(nPopup_type)
            {
                case Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP:
                {
                    isNoCarPlay();
                    source = ""
                }
                break

                case Settings.SETTINGS_CONNECTIVITY_ANDROID_POPUP:
                {
                    isNoAndroidAuto();
                    source = ""
                }
                break;


            }
            nPopup_type = -1
            isYesBtnPressed = false

        }
    }

    onVisibleChanged:
    {
        if(!visible)
        {
            source = ""
        }
    }

    anchors.fill: parent
    visible: false

    Connections{
        target: (status == Loader.Ready) ? item : null
        onClosePopUp:
        {
            /**
             * 1. 팝업, 토스트 팝업 Loader의 visible이 false일 경우, Jog-Controll이 가능(in Main QML)하므로,
             * 2. 초기화 팝업(사운드, 화면, 전체)의 경우, 팝업 Loader의 visible을 false로 변경하지 않고, 참조하고 있는 item의 visible을 false로 변경
             * 3. 토스트 팝업의 Loader visible이 true가 되었을 때, 팝업 Loader의 visible을 false로 변경
             * 4. 위와 같이 수정한 이유는, 팝업이 사라지고 토스트 팝업이 출력되는 사이에 Jog-Center Press시, 동작되는 문제를 방지.
             **/
            if(isYesPressed)
            {
                isYesBtnState(true); //added for ITS 218729 GPS remain Check State and Focus Issue
                if( popup_type == Settings.SETTINGS_RESET_SOUND_SETTINGS ||
                        popup_type == Settings.SETTINGS_RESET_SCREEN_SETTINGS ||
                        popup_type == Settings.SETTINGS_RESET_GENERAL_SETTINGS)
                    item.visible = false
                else
                    visible = false
            }
            else{
                isYesBtnState(false); //added for ITS 218729 GPS remain Check State and Focus Issue
                visible = false
            }
            isYesBtnPressed = isYesPressed
            nPopup_type = popup_type

            startResetTimer.running = true
        }
    }

    Connections{
        target: EngineListener

        onShowPopup:
        {
            if ( screen != UIListener.getCurrentScreen() )
            {
                return;
            }

            source = ""

            switch ( type )
            {
            case Settings.SETTINGS_RESET_SOUND_SETTINGS:
            {
                source = "DHAVN_AppSettings_ResetAllSoundPopUp.qml"
            }
            break

            case Settings.SETTINGS_RESET_SCREEN_SETTINGS:
            {
                source = "DHAVN_AppSettings_ResetAllScreenPopUp.qml"
            }
            break

            case Settings.SETTINGS_RESET_GENERAL_SETTINGS:
            {
                source = "DHAVN_AppSettings_ResetAllInitPopUp.qml"
            }
            break

            case Settings.SETTINGS_CONFIRM_FORMAT_POPUP:
            {
                source = "DHAVN_AppSettings_System_FormatRequestPopUp.qml"
            }
            break

            case Settings.SETTINGS_TIME_PICKER_POPUP:
            {
                source = "DHAVN_AppSettings_Clock_TimePickerPopUp.qml"
            }
            break;

            case Settings.SETTINGS_VR_NOT_SUPPORT_POPUP:
            {
                source = "DHAVN_AppSettings_Voice_VR_Not_Support_PopUp.qml"
            }
            break;
            //added for AA/CP Setting
            case Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP:
            {
                source = "DHAVN_AppSettings_Connectivity_CarplayPopUp.qml"
            }
            break;
            //added for Android Auto Setting
            case Settings.SETTINGS_CONNECTIVITY_ANDROID_POPUP:
            {
                source = "DHAVN_AppSettings_Connectivity_AndroidPopUp.qml"
            }
            break;
            }

            nPopup_type = type
            visible = true
        }

        onHidePopup:
        {
            if ( screen != UIListener.getCurrentScreen() )
                return;

            if(visible)
                visible = false
        }
    }

}
