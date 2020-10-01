import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: languageMain
    name: "Language"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 699
    default_x: 0
    default_y: 0

    function init( )
    {
        languageArea.setRadiolistCurrentIndex()
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_area
        name: "Language-ContentArea"
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
                id: myListKoreanId

                ListElement{
                    title_of_radiobutton: "한국어"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_KO
                }

                ListElement{
                    title_of_radiobutton: "English"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_EN_US
                }
            }

            ListModel{
                id: myListNorthAmericaId

                ListElement{
                    title_of_radiobutton: "English"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_EN_US
                }
                ListElement{
                    title_of_radiobutton: "Español"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_ES_NA
                }
                ListElement{
                    title_of_radiobutton: "Français"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_FR_NA
                }
                ListElement{
                    title_of_radiobutton: "한국어"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_KO
                }
            }

            ListModel{
                id: myListChinaId

                ListElement{
                    title_of_radiobutton: "中文"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_ZH_MA
                }
                ListElement{
                    title_of_radiobutton: "English"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_EN_UK
                }
                ListElement{
                    title_of_radiobutton: "한국어"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_KO
                }
            }

            ListModel{
                id: myListGeneralId
                ListElement{
                    title_of_radiobutton: "English"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_EN_US
                }
                ListElement{
                    title_of_radiobutton: "한국어"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_KO
                }
            }

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

            ListModel{
                id: myListEuropaId

                ListElement{
                    title_of_radiobutton: "English"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_EN_UK
                }
                ListElement{
                    title_of_radiobutton: "Čeština"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_CS
                }
                ListElement{
                    title_of_radiobutton: "Dansk"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_DA
                }
                ListElement{
                    title_of_radiobutton: "Deutsch"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_DE
                }
                ListElement{
                    title_of_radiobutton: "Español"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_ES
                }
                ListElement{
                    title_of_radiobutton: "Français"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_FR
                }
                ListElement{
                    title_of_radiobutton: "Italiano"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_IT
                }
                ListElement{
                    title_of_radiobutton: "Nederlands"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_NL
                }
                ListElement{
                    title_of_radiobutton: "Polski"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_PL
                }
                ListElement{
                    title_of_radiobutton: "Português"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_PT
                }
                ListElement{
                    title_of_radiobutton: "Русский"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_RU
                }
                ListElement{
                    title_of_radiobutton: "Slovenčina"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_SK
                }
                ListElement{
                    title_of_radiobutton: "Svenska"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_SV
                }
                ListElement{
                    title_of_radiobutton: "Türkçe"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_TR
                }
                ListElement{
                    title_of_radiobutton: "한국어"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_KO
                }
            }

            ListModel{
                id: myListRussiaId

                ListElement{
                    title_of_radiobutton: "Русский"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_RU
                }
                ListElement{
                    title_of_radiobutton: "Čeština"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_CS
                }
                ListElement{
                    title_of_radiobutton: "Dansk"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_DA
                }
                ListElement{
                    title_of_radiobutton: "Deutsch"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_DE
                }
                ListElement{
                    title_of_radiobutton: "English"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_EN_UK
                }
                ListElement{
                    title_of_radiobutton: "Español"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_ES
                }
                ListElement{
                    title_of_radiobutton: "Français"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_FR
                }
                ListElement{
                    title_of_radiobutton: "Italiano"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_IT
                }
                ListElement{
                    title_of_radiobutton: "Nederlands"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_NL
                }
                ListElement{
                    title_of_radiobutton: "Polski"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_PL
                }
                ListElement{
                    title_of_radiobutton: "Português"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_PT
                }
                ListElement{
                    title_of_radiobutton: "Slovenčina"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_SK
                }
                ListElement{
                    title_of_radiobutton: "Svenska"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_SV
                }
                ListElement{
                    title_of_radiobutton: "Türkçe"
                    enable: true
                    item_id: Settings.SETTINGS_LANGUAGE_TR
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
                interval: 100 //added for ITS271868 Focus showing issue when show Language Change popup
                onTriggered:
                {
                    //added for ITS271868 Focus showing issue when show Language Change popup
                    SettingsStorage.showToastPopup(Settings.SETTINGS_TOAST_LANGUAGE_CHANGING)
                    SettingsStorage.isLanguageChanged = true
                    EngineListener.printLogMessage("[Language]SettingsStorage.isLanguageChanged : " + SettingsStorage.isLanguageChanged)

                    SettingsStorage.languageType = radiolist.currentLanguageType
                    SettingsStorage.SaveSetting( radiolist.currentLanguageType,
                                                Settings.DB_KEY_LANGUAGE_TYPE )
                    EngineListener.ChangeLanguage(radiolist.currentLanguageType)

                    // Apply to code [ITS 0214250: 1. 언어 변경/Default Keyboard 변경 시, 키보드 설정 및 문구 오류]
                    if( (SettingsStorage.currentRegion == 5 || SettingsStorage.currentRegion == 7)
                            && SettingsStorage.hyunDaiKeypad == Settings.SETTINGS_HYUNDAI_EUROPE )
                    {
                        var keypadIndex;
                        if(radiolist.currentLanguageType== Settings.SETTINGS_LANGUAGE_FR)
                            keypadIndex = 3
                        else if(radiolist.currentLanguageType== Settings.SETTINGS_LANGUAGE_DE)
                            keypadIndex = 2
                        else
                            keypadIndex = 0

                        SettingsStorage.europeKeypad = keypadIndex
                        SettingsStorage.SaveSetting( keypadIndex, Settings.DB_KEY_EUROPE_KEYPAD )
                        SettingsStorage.UpdateKeyboardData()
                        EngineListener.NotifyApplication( Settings.DB_KEY_EUROPE_KEYPAD, keypadIndex, "", UIListener.getCurrentScreen())
                    }

                    SettingsStorage.isLanguageChanged = false //added for ITS271868 Focus showing issue when show Language Change popup
                    //SettingsStorage.showToastPopup(Settings.SETTINGS_TOAST_LANGUAGE_CHANGING)
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
                defaultValueIndex: HM.const_SETTINGS_GENERAL_LANGUAGE_DEFAULT_VALUE
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
                        rootGeneral.setVisualCue(true, false, true, false)
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
                case -1://eCVKorea
                case 0://eCVKorea
                {
                    radiolist.radiomodel = myListKoreanId
                    switch ( SettingsStorage.languageType )
                    {
                    case Settings.SETTINGS_LANGUAGE_KO:
                    {
                        radiolist.currentindex = 0
                    }
                    break

                    case Settings.SETTINGS_LANGUAGE_EN:
                    case Settings.SETTINGS_LANGUAGE_EN_US:
                    {
                        radiolist.currentindex = 1
                    }
                    break
                    }
                    break
                }
                case 1://eCVNorthAmerica
                case 6:
                {
                    radiolist.radiomodel = myListNorthAmericaId
                    switch ( SettingsStorage.languageType )
                    {
                    case Settings.SETTINGS_LANGUAGE_EN:
                    case Settings.SETTINGS_LANGUAGE_EN_US:
                    {
                        radiolist.currentindex = 0
                    }
                    break

                    case Settings.SETTINGS_LANGUAGE_ES_NA:
                    {
                        radiolist.currentindex = 1
                    }
                    break

                    case Settings.SETTINGS_LANGUAGE_FR_NA:
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
                    break;
                }
                case 2://eCVChina
                {
                    radiolist.radiomodel = myListChinaId
                    switch ( SettingsStorage.languageType )
                    {
                    case Settings.SETTINGS_LANGUAGE_ZH_MA:
                    {
                        radiolist.currentindex = 0
                    }
                    break

                    case Settings.SETTINGS_LANGUAGE_EN_UK:
                    {
                        radiolist.currentindex = 1
                    }
                    break

                    case Settings.SETTINGS_LANGUAGE_KO:
                    {
                        radiolist.currentindex = 2
                    }
                    break
                    }
                    break;
                }
                case 3://eCVGeneral
                {
                    radiolist.radiomodel = myListGeneralId
                    switch ( SettingsStorage.languageType )
                    {
                    case Settings.SETTINGS_LANGUAGE_EN:
                    case Settings.SETTINGS_LANGUAGE_EN_US:
                    {
                        radiolist.currentindex = 0
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_KO:
                    {
                        radiolist.currentindex = 1
                    }
                    break
                    }
                    break
                }
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
                case 5://eCVEuropa
                {
                    radiolist.radiomodel = myListEuropaId
                    switch ( SettingsStorage.languageType )
                    {
                    case Settings.SETTINGS_LANGUAGE_EN_UK:
                    {
                        radiolist.currentindex = 0
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_CS:
                    {
                        radiolist.currentindex = 1
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_DA:
                    {
                        radiolist.currentindex = 2
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_DE:
                    {
                        radiolist.currentindex = 3
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_ES:
                    {
                        radiolist.currentindex = 4
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_FR:
                    {
                        radiolist.currentindex = 5
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_IT:
                    {
                        radiolist.currentindex = 6
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_NL:
                    {
                        radiolist.currentindex = 7
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_PL:
                    {
                        radiolist.currentindex = 8
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_PT:
                    {
                        radiolist.currentindex = 9
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_RU:
                    {
                        radiolist.currentindex = 10
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_SK:
                    {
                        radiolist.currentindex = 11
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_SV:
                    {
                        radiolist.currentindex = 12
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_TR:
                    {
                        radiolist.currentindex = 13
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_KO:
                    {
                        radiolist.currentindex = 14
                    }
                    break
                    }
                    break
                }
                case 7:
                {
                    radiolist.radiomodel = myListRussiaId
                    switch ( SettingsStorage.languageType )
                    {
                    case Settings.SETTINGS_LANGUAGE_RU:
                    {
                        radiolist.currentindex = 0
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_CS:
                    {
                        radiolist.currentindex = 1
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_DA:
                    {
                        radiolist.currentindex = 2
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_DE:
                    {
                        radiolist.currentindex = 3
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_EN_UK:
                    {
                        radiolist.currentindex = 4
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_ES:
                    {
                        radiolist.currentindex = 5
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_FR:
                    {
                        radiolist.currentindex = 6
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_IT:
                    {
                        radiolist.currentindex = 7
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_NL:
                    {
                        radiolist.currentindex = 8
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_PL:
                    {
                        radiolist.currentindex = 9
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_PT:
                    {
                        radiolist.currentindex = 10
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_SK:
                    {
                        radiolist.currentindex = 11
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_SV:
                    {
                        radiolist.currentindex = 12
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_TR:
                    {
                        radiolist.currentindex = 13
                    }
                    break
                    case Settings.SETTINGS_LANGUAGE_KO:
                    {
                        radiolist.currentindex = 14
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
