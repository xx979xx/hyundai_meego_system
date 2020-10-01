import QtQuick 1.1
import com.settings.variables 1.0
import com.settings.defines 1.0
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Resources.js" as RES
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: photoFrameMain
    name: "Photo_Frame"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 699

    default_x: 0
    default_y: 0


    //added for DH PE
    function setCurrentIndex()
    {
        var retValue;
        if(SettingsStorage.photoFrame == 0)
        {
            retValue = 2
        }
        else
        {
            if(SettingsStorage.clockType == 1)
            {
                retValue = 0
            }
            else if(SettingsStorage.clockType == 0)
            {
               retValue = 1
            }
        }
        return retValue;

    }

    function setState(index)
    {
        switch(index)
        {
        case 0:
            photoFrameMain.state = HM.const_APP_SETTINGS_GENERAL_STATE_PE_DIGITAL_CLOCK
            break;
        case 1:
            photoFrameMain.state = HM.const_APP_SETTINGS_GENERAL_STATE_PE_ANALOG_CLOCK
            break;
        case 2:
            photoFrameMain.state = HM.const_APP_SETTINGS_GENERAL_STATE_PE_NONE
            break;
        }
    }

    function init( )
    {

        //added for DH PE
        if(SettingsStorage.photoFrame == 0)
        {
            radiolist.currentindex = 2
        }
        else
        {
            if(SettingsStorage.clockType == 1)
            {
                radiolist.currentindex = 0
            }
            else if(SettingsStorage.clockType == 0)
            {
               radiolist.currentindex = 1
            }
        }

    }

    function setVisualCue()
    {
        if(focus_visible)
        {
            rootGeneral.setVisualCue(true, false, true, false)
        }
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 100
        onTriggered:
        {
            // set Settings variable

            //added for DH PE
            if(radiolist.currentindex == 0)
            {
                //case DIGITAL
                SettingsStorage.clockType = 1
                SettingsStorage.photoFrame = 1
                EngineListener.NotifyApplication(Settings.DB_KEY_CLOCK_TYPE, 1, "", UIListener.getCurrentScreen())
                EngineListener.NotifyApplication(Settings.DB_KEY_PHOTO_FRAME, 1, "Clock", UIListener.getCurrentScreen())
                SettingsStorage.SaveSetting( 1, Settings.DB_KEY_CLOCK_TYPE )
                SettingsStorage.SaveSetting( 1, Settings.DB_KEY_PHOTO_FRAME )

            }
            else if(radiolist.currentindex == 1)
            {

                //case ANALOG
                SettingsStorage.clockType = 0
                SettingsStorage.photoFrame = 1
                EngineListener.NotifyApplication(Settings.DB_KEY_CLOCK_TYPE, 0, "", UIListener.getCurrentScreen())
                EngineListener.NotifyApplication(Settings.DB_KEY_PHOTO_FRAME, 1, "Clock", UIListener.getCurrentScreen())
                SettingsStorage.SaveSetting( 0,  Settings.DB_KEY_CLOCK_TYPE )
                SettingsStorage.SaveSetting( 1, Settings.DB_KEY_PHOTO_FRAME )

            }
            else if(radiolist.currentindex == 2)
            {

                SettingsStorage.photoFrame = 0
                EngineListener.NotifyApplication(Settings.DB_KEY_PHOTO_FRAME, 0, "Off", UIListener.getCurrentScreen())
                SettingsStorage.SaveSetting( 0, Settings.DB_KEY_PHOTO_FRAME )

            }

            //switch(radiolist.currentindex)
            //{
            //case 0: radiolist.textVal = "Off"; break;
            //case 1: radiolist.textVal = "Clock"; break;
            //}

        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: contentArea
        name: "PhotoContentArea"

        anchors.top:parent.top
        anchors.left:parent.left
        width: parent.width
        height: parent.height

        default_x: 0
        default_y: 0
        focus_x: 0
        focus_y: 0

        DHAVN_AppSettings_SI_RadioList{
            id: radiolist

            property string textVal: QT_TR_NOOP("STR_SETTING_GENERAL_PHOTO_FRAME_OFF")
            property string name: "PhotoFrameRadioList"
            property int default_x: 0
            property int default_y: 0
            property int focus_x: 0
            property int focus_y: 0

            anchors.top: parent.top
            anchors.left: parent.left
            width:560
            height:552

            currentindex: setCurrentIndex() //added for DH PE
            radiomodel: myListModelId
            focus_id: 0
            bInteractive: false
            defaultValueIndex: HM.const_SETTINGS_GENERAL_PHOTO_FRAME_DEFAULT_VALUE
            onIndexSelected:
            {
                var value

                switch ( radiolist.currentindex )
                {
                case 0:
                    value = SettingsDef.SCREEN_SAVER_MODE_CLOCK //added for DH PE

                    break
                case 1:
                    value = SettingsDef.SCREEN_SAVER_MODE_CLOCK
                    break

                case 2:
                    value = SettingsDef.SCREEN_SAVER_MODE_OFF //added for DH PE
                    break
                }

                if(!isJog)
                {
                    contentArea.hideFocus()
                    contentArea.setFocusHandle(0,0)
                    focus_index = nIndex
                    contentArea.showFocus()
                }

                if(menuSelectTimer.running)
                    menuSelectTimer.restart()
                else
                    menuSelectTimer.start()

                setVisualCue()
            }

            onFocus_indexChanged:
            {
                setVisualCue()
                if(radiolist.focus_index >=0 && radiolist.focus_visible ) //added for DH PE
                {
                    photoFrameMain.setState( radiolist.focus_index )
                }
            }

            onFocus_visibleChanged:
            {
                //added for DH PE
                if(radiolist.focus_visible) 
                {
                    setVisualCue()
                    photoFrameMain.setState(radiolist.focus_index)
                }
                else
                {
                    photoFrameMain.setState(radiolist.currentindex)
                }


            }

            onMovementEnded:
            {
                if(!focus_visible)
                {
                    contentArea.hideFocus()
                    contentArea.setFocusHandle(0,0)

                    if(defaultValueIndex == currentindex)
                        focus_index = defaultValueIndex + 1
                    else
                        focus_index = defaultValueIndex

                    if(isShowSystemPopup == false)
                    {
                        contentArea.showFocus()
                    }
                }
            }
            //added for DH PE
            Component.onCompleted:
            {
                photoFrameMain.setState(radiolist.currentindex)
            }
        }
    }
    //added for DH PE

    Text{
        id: appText1
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset:  408
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : ( photoFrameMain.state == HM.const_APP_SETTINGS_GENERAL_STATE_PE_DIGITAL_CLOCK
                   ||  photoFrameMain.state == HM.const_APP_SETTINGS_GENERAL_STATE_PE_ANALOG_CLOCK )
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_PE_CLOCK_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }

    Text{
        id: appText2
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 408
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : photoFrameMain.state == HM.const_APP_SETTINGS_GENERAL_STATE_PE_NONE
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_PE_CLOCK_NONE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }

    states: [
        State{
            name: HM.const_APP_SETTINGS_GENERAL_STATE_PE_DIGITAL_CLOCK
        },
        State{
            name: HM.const_APP_SETTINGS_GENERAL_STATE_PE_ANALOG_CLOCK
        },
        State{
            name: HM.const_APP_SETTINGS_GENERAL_STATE_PE_NONE_CLOCK
        }
    ]

    ListModel{
        id: myListModelId

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_DIGITAL")
            enable: true
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_ANALOG")
            enable: true
        }
        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_PHOTO_FRAME_OFF")
            enable: true
        }
    }

    Connections{
        target:SettingsStorage

        onPhotoFrameChanged:
        {
            init()
        }
    }
}
