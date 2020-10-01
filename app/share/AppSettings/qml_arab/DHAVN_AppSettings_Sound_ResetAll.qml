import QtQuick 1.1
import com.settings.variables 1.0
import com.settings.defines 1.0
import AppEngineQMLConstants 1.0
import "Components/ResetButton"
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Default_Values.js" as HD

DHAVN_AppSettings_FocusedItem {
    id: soundResetMain

    anchors.top: parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 60
    width: 510; height: 554

    default_x: 0
    default_y: 0

    Text {
        id: appText1

        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignHCenter
        horizontalAlignment: Text.AlignHCenter


        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_RESET_SOUND_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_BRIGHT_GREY

        font.family: EngineListener.getFont(false)
        font.pointSize: 32
        wrapMode: Text.WordWrap
    }
}
