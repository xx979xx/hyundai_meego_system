import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: speed_PE

    state: ""
    name: "SpeedDependent_PE"

    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 34

    default_x: 0
    default_y: 0

    function init()
    {
        radioList.currentindex = SettingsStorage.sdvPE


        if(!focus_visible)
            setState(radioList.currentindex)
    }

    function getCurrentIndex()
    {
        return SettingsStorage.sdvPE

    }

    function setState(index)
    {

        switch(index)
        {
        case 0 : speed_PE.state = HM.const_APP_SETTINGS_SOUND_SDV_LOW
            break;
        case 1 : speed_PE.state = HM.const_APP_SETTINGS_SOUND_SDV_MID
            break;
        case 2 : speed_PE.state = HM.const_APP_SETTINGS_SOUND_SDV_HIGH
            break;
        case 3 : speed_PE.state = HM.const_APP_SETTINGS_SOUND_SDV_OFF
            break;
        }


    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            SettingsStorage.sdvPE = radioList.currentindex
            SettingsStorage.SaveSettings( radioList.currentindex, Settings.DB_KEY_SOUND_SPEED_DEPENDENT_PE )
            EngineListener.NotifyApplication( Settings.DB_KEY_SOUND_SPEED_DEPENDENT_PE, radioList.currentindex, "", UIListener.getCurrentScreen() )
        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_area
        width: 560
        height: 552

        anchors.top: parent.top
        anchors.left: parent.left

        default_x: 0
        default_y:0
        focus_x: 0
        focus_y: 0

        DHAVN_AppSettings_FocusedItem{
            id: radiolistarea
            anchors.top: parent.top
            anchors.left:parent.left
            width:parent.width
            height:parent.height

            default_x:0
            default_y:0
            focus_x: 0
            focus_y: 0


            ListModel{
                id: domesticModel

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_SPEED_LOW")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_SPEED_MID")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_SPEED_HIGH")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_SPEED_OFF")
                    enable: true
                }
            }

            DHAVN_AppSettings_SI_RadioList{
                id: radioList

                property string name: "RadioList"
                property int focus_x: 0
                property int focus_y: 0

                width: 560
                height: 552

                anchors.top: parent.top
                anchors.left: parent.left
                currentindex: getCurrentIndex()
                radiomodel: domesticModel
                focus_id: 0
                bInteractive: false
                defaultValueIndex: HM.const_SETTINGS_SOUND_SDV_DEFAULT_VALUE
                onIndexSelected:
                {
                    if(!isJog)
                    {
                        radiolistarea.hideFocus()
                        radiolistarea.setFocusHandle(0,0)
                        focus_index= nIndex
                        radiolistarea.showFocus()
                    }

                    if(menuSelectTimer.running)
                        menuSelectTimer.restart()
                    else
                        menuSelectTimer.start()
                }

                onFocus_indexChanged:
                {

                    speed_PE.setState(radioList.focus_index)

                }

                onFocus_visibleChanged:
                {
                    if(radioList.focus_visible)
                    {
                        rootSound.setVisualCue(true, false, false, true)
                        speed_PE.setState(radioList.focus_index)
                    }
                    else
                    {
                        speed_PE.setState(radioList.currentindex)
                    }
                }

                Component.onCompleted:
                {
                    speed_PE.setState(radioList.currentindex)
                }
            }
        }
    }

    Text{
        id: appText1
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset:  458//408
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : true
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_SDV_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.WordWrap
    }

    states: [
        State{
            name: HM.const_APP_SETTINGS_SOUND_SDV_LOW
        },
        State{
            name: HM.const_APP_SETTINGS_SOUND_SDV_MID
        },
        State{
            name: HM.const_APP_SETTINGS_SOUND_SDV_HIGH
        },
        State{
            name: HM.const_APP_SETTINGS_SOUND_SDV_OFF
        }
    ]

    Connections{
        target:SettingsStorage

        onSdvPEChanged:
        {
            //console.log("called onvolumeRatioChanged :"+SettingsStorage.volumeRatio)
            init()
        }
    }
}


