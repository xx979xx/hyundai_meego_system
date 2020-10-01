import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: languageMain
    name: "Language"
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 34
    default_x: 0
    default_y: 0

    function init( )
    {
        languageArea.setRadiolistCurrentIndex()
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_area
        name: "Language-ContentArea"
        anchors.top: parent.top
        anchors.left: parent.left
        width: 560
        height: 552

        default_x: 0
        default_y: 0
        focus_x: 0
        focus_y: 0

        DHAVN_AppSettings_FocusedItem{
            id: languageArea
            anchors.top: parent.top
            anchors.left:parent.left
            width:parent.width
            height:parent.height

            default_x:0
            default_y:0
            focus_x: 0
            focus_y: 0

            ListModel{
                id: myListMiddleEastId
                ListElement{
                    title_of_radiobutton: "العربية"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_AR
                }
                ListElement{
                    title_of_radiobutton: "English"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_EN_UK
                }
                ListElement{
                    title_of_radiobutton: "Français"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_FR
                }
                ListElement{
                    title_of_radiobutton: "한국어"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_KO
                }
            }
            Timer {
                id: menuSelectTimer
                running: false
                repeat: false
                interval: 300
                onTriggered:
                {

                    SettingsStorage.languageType = radiolist.currentLanguageType
                    SettingsStorage.SaveSetting( radiolist.currentLanguageType,
                                                Settings.DB_KEY_LANGUAGE_TYPE )
                    EngineListener.ChangeLanguage(radiolist.currentLanguageType)
                    SettingsStorage.showToastPopup(Settings.SETTINGS_TOAST_LANGUAGE_CHANGING)
                }
            }
            DHAVN_AppSettings_SI_RadioList{
                id: radiolist

                property string name: "RadioList"
                property int focus_x: 0
                property int focus_y: 0
                property int currentLanguageType:0
                anchors.top: parent.top
                anchors.left: parent.left
                height: 552
                countDispalyedItems: 6

                focus_id: 0
                //radiomodel: myListModelId
                defaultValueIndex: getDefaultIndex()
                onIndexSelected:
                {
                    if(!isJog)
                    {
                        //languageArea.hideFocus()
                        languageArea.setFocusHandle(0,0)
                        focus_index= nIndex
                        languageArea.showFocus()
                    }
                    currentLanguageType = radiomodel.get(radiolist.currentindex).item_id
                    if(SettingsStorage.languageType != currentLanguageType)
                    {
                        if(menuSelectTimer.running)
                            menuSelectTimer.restart()
                        else
                            menuSelectTimer.start()
                    }
                }

                onFocus_visibleChanged:
                {
                    if(focus_visible)
                        rootGeneral.setVisualCue(true, false, false, true)
                    else
                        isFocusedByFlicking = false
                }

                onMovementEnded:
                {
                    if(!focus_visible)
                    {
                        languageMain.hideFocus()
                        languageMain.setFocusHandle(0,0)

                        if(radiolist.radiomodel.count <= 6)
                        {
                            if(defaultValueIndex == currentindex)
                                focus_index = defaultValueIndex + 1
                            else
                                focus_index = defaultValueIndex
                        }
                        else
                        {
                            if(defaultValueIndex >= currentTopIndex && defaultValueIndex < currentTopIndex+6)
                                focus_index = defaultValueIndex
                            else
                                focus_index = currentTopIndex
                        }

                        isFocusedByFlicking = true
                        if(isShowSystemPopup == false)
                        {
                            languageMain.showFocus()
                        }
                    }
                }
            }

            function setRadiolistCurrentIndex()
            {
                switch(SettingsStorage.currentRegion)
                {
                case 4://eCVMiddleEast
                {
                    radiolist.radiomodel = myListMiddleEastId
                    switch ( SettingsStorage.languageType )
                    {
                    case Settings.SETTINGS_LANGUAGE_AR:
                    {
                        radiolist.currentindex = 0
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_EN_UK:
                    {
                        radiolist.currentindex = 1
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_FR:
                    {
                        radiolist.currentindex = 2
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_KO:
                    {
                        radiolist.currentindex = 3
                    }
                    break
                    }
                    break
                }
                }
            }
        }
    }


    Connections{
        target:SettingsStorage

        onLanguageTypeChanged:
        {
            //console.log("called onLanguageTypeChanged :"+SettingsStorage.languageType)
            init()
        }
    }
}
