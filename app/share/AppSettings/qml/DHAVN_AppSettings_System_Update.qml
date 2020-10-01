import QtQuick 1.1
import com.settings.variables 1.0
import AppEngineQMLConstants 1.0
import "Components/UsbUpgradeButton"
import "DHAVN_AppSettings_General.js" as APP

DHAVN_AppSettings_FocusedItem {
    id: content
    name: "UpgradeByUSB"
    anchors.top: parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 710

    width: 510
    height: 554

    default_x: 0
    default_y: 0

    Text {
        id: updateInfoTxt
        width: 510
        anchors.bottom: upgradebutton.top
        anchors.bottomMargin: 30
        anchors.left: parent.left
        horizontalAlignment: Text.AlignHCenter

        text: qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SYSTEM_UPDATE_INFO_SD")) + LocTrigger.empty

        color: APP.const_COLOR_TEXT_BRIGHT_GREY

        font.family: EngineListener.getFont(false)
        font.pointSize: 32
        wrapMode: Text.WordWrap

    }

    DHAVN_AppSettings_UpgradeByUSB{
        id: upgradebutton
        width: parent.width;
        anchors.top: parent.top
        anchors.topMargin : 315
        anchors.left: parent.left
        anchors.leftMargin: 64
        active: EngineListener.usbUpdatePresent

        focus_x: 0
        focus_y: 0

        function launchUpgradeViaUSB()
        {
            EngineListener.LaunchUpgradeViaUSB()
        }

        onUpgradeButtonClicked:
        {
            if(EngineListener.usbUpdatePresent)
                launchUpgradeViaUSB()
        }

        onUpgradeButtonReleased:
        {
            if(EngineListener.usbUpdatePresent)
                launchUpgradeViaUSB()
        }

        onFocus_visibleChanged:
        {
            if (focus_visible)
            {
                rootSystem.setVisualCue(true, false, true, false)
            }
        }
    }
}
