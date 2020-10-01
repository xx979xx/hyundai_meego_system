import QtQuick 1.1
import com.settings.variables 1.0
import AppEngineQMLConstants 1.0
import com.settings.defines 1.0
import "Components/FormatButton"
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import "DHAVN_AppSettings_Default_Values.js" as HD
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: content

    signal formatStart()
    property double usedJukeBoxMbSize: 0 // fix for ITS 242784
    property double maxJukeBoxMbSize: 0 // fix for ITS 242784

    property bool bShowRedImage: false

    name: "JukeBoxInfo"
    anchors.top: parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 87

    width: 510
    height: 554

    default_x: 0
    default_y: 0

    DHAVN_AppSettings_FocusedItem{
        id: content_item

        anchors.top: parent.top
        anchors.left: parent.left
        focus_x: 0
        focus_y: 0
        default_x: 0
        default_y: 0

        Text{
            id: jukeBoxUsageTxt
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 148
            anchors.left: parent.left
            anchors.leftMargin: 1
            horizontalAlignment: Text.AlignRight

            width: 457

            text: qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, "STR_SETTING_SYSTEM_JUKEBOX_USAGE") + LocTrigger.empty
            font.pointSize: 32
            font.family: EngineListener.getFont(false)
            color: APP.const_COLOR_TEXT_BRIGHT_GREY
        }

        Item{
            id: progressBarItem

            anchors.top: parent.top
            anchors.topMargin:184
            anchors.left: parent.left
            width: APP.const_APP_SETTINGS_JUKE_BOX_INFO_PROGRESSBAR_ITEM_WIDTH
            height: APP.const_APP_SETTINGS_JUKE_BOX_INFO_PROGRESSBAR_ITEM_HEIGHT

            DHAVN_AppSettings_SI_ProgressBar{
                id: progressBar
            }

            Component.onCompleted:
            {
                progressBar.nMaxValue = JukeBoxInfo.GetJukeBoxMaxScaleSize()
                progressBar.nCurrentValue = JukeBoxInfo.GetUsedJukeBoxScaleSize()

                progressBar.bg = RES.const_URL_IMG_SETTINGS_JUKEBI_BG

                if(bShowRedImage)
                    progressBar.fg = RES.const_URL_IMG_SETTINGS_JUKEBI_BAR_RED
                else
                    progressBar.fg = RES.const_URL_IMG_SETTINGS_JUKEBI_BAR_BLUE
            }
        }

        Text{
            id: usageTxt;

            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset:  238//198
            anchors.left: parent.left
            anchors.leftMargin: 1

            width: 457
            text: ""
            font.pointSize: 24
            font.family: EngineListener.getFont(false)

            color: APP.const_COLOR_TEXT_DIMMED_GREY

            horizontalAlignment: Text.AlignRight

        }

        DHAVN_AppSettings_FormatButton{
            id: changeButton
            anchors.top: parent.top
            anchors.topMargin:315
            anchors.left: parent.left
            anchors.leftMargin: 47
            active: content.usedJukeBoxMbSize == 0.0 ? false : true // fix for ITS 242784
            is_focusMovable: content.usedJukeBoxMbSize == 0.0 ? false : true // fix for ITS 242784
            focus_x: 0
            focus_y: 0

            function launchFormat()
            {
                formatStart()
                EngineListener.showPopapInMainArea(Settings.SETTINGS_CONFIRM_FORMAT_POPUP, UIListener.getCurrentScreen())
            }

            onChangeButtonClicked:
            {
                content_item.hideFocus()
                content_item.setFocusHandle(0,0)

                launchFormat()
            }

            onChangeButtonReleased:
            {
                launchFormat()
            }

            onIs_focusMovableChanged:
            {
                content.is_focusMovable = changeButton.is_focusMovable
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    rootSystem.setVisualCue(true, false, false, true)
                }
            }

            onActiveChanged:
            {
                if(!active)
                    focus_visible = false
            }
        }
    }

    function convertUnit(bUsedInfo, megabyte)
    {
        var retVal = 0
        if(megabyte >=1024)
        {
            retVal = parseFloat(megabyte / 1024).toFixed(2)

            if(bUsedInfo)
            {
                if(retVal >= 24.24)
                    bShowRedImage = true
                else
                    bShowRedImage = false
            }

            return retVal
        }
        else
        {
            if(bUsedInfo)
            {
                bShowRedImage = false
            }

            return megabyte.toFixed(2)
        }
    }

    function convertMB2GB(megabyte)
    {
        if(megabyte >=1024)
            return qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, "STR_SETTING_JUKEBOX_GB") + LocTrigger.empty
        else
            return qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, "STR_SETTING_JUKEBOX_MB") + LocTrigger.empty
    }

    Connections{
        target: JukeBoxInfo

        //void JukeBoxInfoUpdated(int maxMb, int usedMb, int usedScale);
        onJukeBoxInfoUpdated:
        {
            usageTxt.text =  convertUnit(true, usedMb) + convertMB2GB(usedMb) + " / " + convertUnit(false, maxMb) + convertMB2GB(maxMb)
            progressBar.nCurrentValue = usedScale
            usedJukeBoxMbSize = usedMb
            maxJukeBoxMbSize = maxMb
        }
    }

    onBShowRedImageChanged:
    {
        if(bShowRedImage)
            progressBar.fg = RES.const_URL_IMG_SETTINGS_JUKEBI_BAR_RED
        else
            progressBar.fg = RES.const_URL_IMG_SETTINGS_JUKEBI_BAR_BLUE
    }
}
