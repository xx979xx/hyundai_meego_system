import QtQuick 1.1
import com.settings.variables 1.0
import AppEngineQMLConstants 1.0
import com.settings.defines 1.0
import "Components/ResetButton"
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Resources.js" as RES
import "DHAVN_AppSettings_Default_Values.js" as HD


DHAVN_AppSettings_FocusedItem{
    id: main

    property string textVal: "Louder Volume for Navigation"

    anchors.top: parent.top
    anchors.topMargin: HM.const_APP_SETTINGS_B_STANDART_SIMPLE_SCREEN_CONTENTAREA_Y
    anchors.left: parent.left
    anchors.leftMargin: HM.const_APP_SETTINGS_B_STANDART_SIMPLE_SCREEN_CONTENTAREA_X
    width: HM.const_APP_SETTINGS_B_STANDART_SIMPLE_SCREEN_CONTENTAREA_WIDTH
    height:HM.const_APP_SETTINGS_B_STANDART_SIMPLE_SCREEN_CONTENTAREA_HEIGHT

    default_x: 0
    default_y: 0



    Text{
        id:textbutton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: HM.const_APP_SETTINGS_SOUND__RESET_ALL_TEXT_TOP_MARGIN
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("Initialize all of the general settings")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: HM.const_APP_SETTINGS_FONT_SIZE_TEXT_28PT
    }

    DHAVN_AppSettings_ResetButton{
        id: resetbutton_tones
        anchors.top: textbutton.bottom
        anchors.topMargin:HM.const_APP_SETTINGS_SOUND__RESET_ALL_BTN_TOP_MARGIN_FROM_TEXT
        anchors.left:parent.left
        anchors.leftMargin:HM.const_APP_SETTINGS_B_STANDART_RESET_BUTTON_LEFT_MARGIN


        focus_x: 0
        focus_y: 0

        function reset()
        {
            EngineListener.showPopapInMainArea(Settings.SETTINGS_RESET_GENERAL_SETTINGS, UIListener.getCurrentScreen())
        }

        onResetButtonClicked:
        {
            reset()
        }

        onResetButtonReleased: {
            reset()
        }
    }
}

