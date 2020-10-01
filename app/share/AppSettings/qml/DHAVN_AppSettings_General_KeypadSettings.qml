import QtQuick 1.1
import QmlPopUpPlugin 1.0
import com.settings.variables 1.0
import com.settings.defines 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Resources.js" as RES
import "Components/ScrollingTicker"

DHAVN_AppSettings_FocusedItem{
    id: keypadSettingMain //content
    name: "KeypadSettings"

    anchors.top:parent.top
    anchors.topMargin: 82
    anchors.left: parent.left
    anchors.leftMargin: 699

    width: 581
    height: 554

    signal itemSelect(int itemIndex, int itemTypeNumber, bool isJog)

    default_x: 0
    default_y: 0

    Connections{
        target: LocTrigger
        onRetrigger: keypadSettingMain.init()
    }

    property bool isFocusMovableToLeft: true
    property string englishKeypad : ""
    property string koreanKeypad : ""
    property string arabicKeypad : ""
    property string keypadType : ""
    property string chinaKeypad : ""
    property string europeKeypad : ""
    property string hyundaiKeyboard : ""
    property string cyrillicKeypad: ""

    property string hyundaiKeyboardShotName: sliceHyundaiKeyboard(hyundaiKeyboard)

    function sliceHyundaiKeyboard(tmp)
    {
        return hyundaiKeyboard.slice(0,15) + "..."
    }

    function init()
    {
        getHyundayKeypad()
        switch(SettingsStorage.currentRegion)
        {
        case 0: //eCVKorea
        case -1:
        case 3: //eCVGeneral
        case 1: //eCVNorthAmerica
        case 6:
            getEnglishKeypad()
            getKoreanKeypad()
            break

        case 2: //eCVChina
            getChinaKeypad()
            getEnglishKeypad()
            getKoreanKeypad()
            break

        case 4: //eCVMiddleEast
            getArabicKeypad()
            getEnglishKeypad()
            getKoreanKeypad()
            break
        case 5://eCVEuropa
            getEuropeKeypad()
            getKoreanKeypad()
            getCyrillicKeypad()
            break;
        case 7:
            getEuropeKeypad()
            getKoreanKeypad()
            getRusCyrillicKeypad()
            break

        default:
            break
        }
    }

    function getIsPopEnable(itemIndex)
    {
        switch(itemIndex)
        {
        case 6:
        {
            if(!(SettingsStorage.currentRegion == 0 || SettingsStorage.currentRegion == 3)) return true
            else return false
        }
        default: return true
        }
    }

    function getSecondText(itemIndex)
    {
        switch(itemIndex)
        {
        case 0: return keypadSettingMain.koreanKeypad       // Korean   : 0
        case 1: return keypadSettingMain.englishKeypad      // English  : 1
        case 2: return keypadSettingMain.chinaKeypad        // Chinese  : 2
        case 3: return keypadSettingMain.arabicKeypad       // Arabic   : 3
        case 4: return keypadSettingMain.europeKeypad       // Europe   : 4
        case 5: return keypadSettingMain.cyrillicKeypad     // Cyrillic : 5
        case 6: return keypadSettingMain.hyundaiKeyboard    // Hyundai  : 6
        }
    }

    function getKeypadModel()
    {
        switch(SettingsStorage.hyunDaiKeypad)
        {
        case 0: return list_model_Domestic_General  // SETTINGS_HYUNDAI_KOREAN = 0
        case 1: return list_model_NA                // SETTINGS_HYUNDAI_ENGLISH_LATIN = 1
        case 2: return list_model_Arabic            // SETTINGS_HYUNDAI_ARABIC = 2
        case 3: return list_model_China             // SETTINGS_HYUNDAI_CHINA = 3
        case 4: return list_model_europe            // SETTINGS_HYUNDAI_EUROPE = 4
        default:
            return list_model_Domestic_General;
        }
    }

    function getHyundayKeypad()
    {
        switch ( SettingsStorage.hyunDaiKeypad )
        {
        case Settings.SETTINGS_HYUNDAI_KOREAN:
            hyundaiKeyboard = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")) + LocTrigger.empty
            break
        case Settings.SETTINGS_HYUNDAI_ENGLISH_LATIN:
            hyundaiKeyboard = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_ENGLISH_LATIN")) + LocTrigger.empty
            break
        case Settings.SETTINGS_HYUNDAI_ARABIC:
            hyundaiKeyboard = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_ARABIC")) + LocTrigger.empty
            break
        case Settings.SETTINGS_HYUNDAI_CHINA:
            hyundaiKeyboard = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_CHINA")) + LocTrigger.empty
            break
        case Settings.SETTINGS_HYUNDAI_EUROPE:
            if(SettingsStorage.currentRegion == 7)
                hyundaiKeyboard = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_CYRILIC_RUS")) + LocTrigger.empty
            else
                hyundaiKeyboard = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_EUROPE")) + LocTrigger.empty

            break
        }
    }

    function getEnglishKeypad()
    {
        switch ( SettingsStorage.englishKeypad )
        {
        case Settings.SETTINGS_ENGLISH_KEYPAD_QWERTY:
            englishKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTY")) + LocTrigger.empty
            break;
        case Settings.SETTINGS_ENGLISH_KEYPAD_ABCD:
            englishKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ABCD")) + LocTrigger.empty
            break;
        }
    }

    function getKoreanKeypad()
    {
        switch ( SettingsStorage.koreanKeypad )
        {
        case Settings.SETTINGS_KOREAN_KEYPAD_QWERTY:
            koreanKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYBOARD_2SET")) + LocTrigger.empty
            break;
        case Settings.SETTINGS_KOREAN_KEYPAD_LETTER:
            koreanKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYBOARD_KOR")) + LocTrigger.empty
            break;
        }
    }

    function getArabicKeypad()
    {
        switch ( SettingsStorage.arabicKeypad )
        {
        case Settings.SETTINGS_ARABIC_QWERTY:
            arabicKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_TYPE1")) + LocTrigger.empty
            break;
        case Settings.SETTINGS_ARABIC_TYPE2:
            arabicKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_TYPE2")) + LocTrigger.empty
            break;
        }
    }

    function getCyrillicKeypad()
    {
        switch ( SettingsStorage.russianKeypad )
        {
        case Settings.SETTINGS_RUSSIAN_CYRILLIC_QWERTY:
            if(SettingsStorage.currentRegion == 7)
                cyrillicKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTY_RUS")) + LocTrigger.empty
            else
                cyrillicKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTY")) + LocTrigger.empty
            break;
        case Settings.SETTINGS_RUSSIAN_CYRILLIC_ABC:
            if(SettingsStorage.currentRegion == 7)
                cyrillicKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ABCD_RUS")) + LocTrigger.empty
            else
                cyrillicKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ABCD")) + LocTrigger.empty
            break;
        }
    }
    function getRusCyrillicKeypad()
    {
        switch ( SettingsStorage.russianKeypad )
        {
        case Settings.SETTINGS_RUSSIAN_CYRILLIC_QWERTY:
            cyrillicKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTY_RUS")) + LocTrigger.empty
            break;
        case Settings.SETTINGS_RUSSIAN_CYRILLIC_ABC:
            cyrillicKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ABCD_RUS")) + LocTrigger.empty
            break;
        }
    }

    function getChinaKeypad()
    {
        switch ( SettingsStorage.chinaKeypad )
        {
        case Settings.SETTINGS_CHINA_PINYIN:
            chinaKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_CHINESE_PINYIN")) + LocTrigger.empty
            break;
        case Settings.SETTINGS_CHINA_VOCAL_SOUND:
            chinaKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_CHINESE_VOCAL_SOUND")) + LocTrigger.empty
            break;
        case Settings.SETTINGS_CHINA_HAND_WRITING:
            chinaKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_CHINESE_HAND_WRITING")) + LocTrigger.empty
            break;
        }
    }

    function getEuropeKeypad()
    {
        switch ( SettingsStorage.europeKeypad )
        {
        case Settings.SETTINGS_EUROPE_ENGLISH_QWERTY:
            europeKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTY")) + LocTrigger.empty
            break;
        case Settings.SETTINGS_EUROPE_ENGLISH_ABC:
            europeKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ABCD")) + LocTrigger.empty
            break;
        case Settings.SETTINGS_EUROPE_QWERTZ:
            europeKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTZ")) + LocTrigger.empty
            break;
        case Settings.SETTINGS_EUROPE_AZERTY:
            europeKeypad = qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_AZERTY")) + LocTrigger.empty
            break;
        default:
            europeKeypad = SettingsStorage.europeKeypad
            break;
        }
    }

    /** itemTypeNumber
      * Korean   : 0
      * English  : 1
      * Chinese  : 2
      * Arabic   : 3
      * Europe   : 4
      * Cyrillic : 5
      * Hyundai  : 6
      */
    // China
    ListModel{
        id: list_model_China
        /*
        ListElement{
            itemType: "china_keypad"
            itemTypeNumber: 2
            itemText: "STR_SETTING_GENERAL_KEYPAD_CHINESE_KEYPAD"
        }
*/
        ListElement{
            itemType: "english_keypad"
            itemTypeNumber: 1
            itemText: "STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD"
        }

        ListElement{
            itemType: "hyundai_keypad"
            itemTypeNumber: 6
            itemText: "STR_SETTING_GENERAL_KEYPAD_DEFAULT"
        }
    }

    // North America
    ListModel{
        id: list_model_NA

        ListElement{
            itemType: "english_keypad"
            itemTypeNumber: 1
            itemText: "STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD"
        }

        ListElement{
            itemType: "hyundai_keypad"
            itemTypeNumber: 6
            itemText: "STR_SETTING_GENERAL_KEYPAD_DEFAULT"
        }
    }

    // Mid East
    ListModel{
        id: list_model_Arabic

        ListElement{
            itemType: "arabic_keypad"
            itemTypeNumber: 3
            itemText: "STR_SETTING_GENERAL_KEYPAD_ARABIC_KEYPAD"
        }

        ListElement{
            itemType: "english_keypad"
            itemTypeNumber: 1
            itemText: "STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD"
        }

        ListElement{
            itemType: "hyundai_keypad"
            itemTypeNumber: 6
            itemText: "STR_SETTING_GENERAL_KEYPAD_DEFAULT"
        }
    }

    ListModel{
        id: list_model_europe
        ListElement{
            itemType: "europe_keypad"
            itemTypeNumber: 4
            itemText: "STR_SETTING_GENERAL_KEYPAD_TYPE"
        }

        ListElement{
            itemType: "cyrillic_keypad"
            itemTypeNumber: 5
            itemText: "STR_SETTING_GENERAL_KEYPAD_CYRILIC"
        }

        ListElement{
            itemType: "hyundai_keypad"
            itemTypeNumber: 6
            itemText: "STR_SETTING_GENERAL_KEYPAD_DEFAULT"
        }
    }

    ListModel{
        id: list_model_Domestic_General

        ListElement{
            itemType: "korean_keypad"
            itemTypeNumber: 0
            itemText: "STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN"
        }
        ListElement{
            itemType: "english_keypad"
            itemTypeNumber: 1
            itemText: "STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD"
        }
        ListElement{
            itemType: "hyundai_keypad"
            itemTypeNumber: 6
            itemText: "STR_SETTING_GENERAL_KEYPAD_DEFAULT"
        }
    }

    Component{
        id: item_delegate

        DHAVN_AppSettings_FocusedItem{
            id: item_keypad
            width: 581
            height: 109

            name: "ItemDelegate"

            property bool pressed: false
            property bool isPopEnable: getIsPopEnable(itemTypeNumber)
            is_focusMovable: isPopEnable

            Image{
                id: focusImage
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -4
                anchors.left: parent.left
                source: RES.const_URL_IMG_SETTINGS_SETTING_SLIDER_FOCUSED
                visible: item_keypad.focus_visible && !(mouse_area1.pressed) && !(item_keypad.pressed)
            }

            Image{
                id: pressImage
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -4
                anchors.left: parent.left
                source: RES.const_URL_IMG_SETTINGS_SETTING_SLIDER_PRESSED
                visible: (item_keypad.pressed || mouse_area1.pressed) && isPopEnable
            }

            Image{
                id: lineList
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -2
                anchors.left:parent.left
                anchors.leftMargin: 9
                source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
                visible: isPopEnable
            }

            ScrollingTicker {
                id: scrollingTicker
                height:parent.height
                width: 449
                scrollingTextMargin: 120
                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -73
                anchors.left: parent.left
                anchors.leftMargin:23
                isScrolling: item_keypad.focus_visible && isParkingMode
                fontPointSize: 40
                clip: true
                fontFamily: EngineListener.getFont(false)
                text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP(itemText)) + LocTrigger.empty
                fontColor: (isPopEnable) ? HM.const_COLOR_TEXT_BRIGHT_GREY : HM.const_COLOR_TEXT_DISABLE_GREY
                visible: isPopEnable
            }

            Text{
                id: item_second_text;

                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -21
                anchors.left: parent.left
                anchors.leftMargin:23

                text: getSecondText(itemTypeNumber)
                color: item_keypad.focus_visible ? HM.const_COLOR_TEXT_BRIGHT_GREY : HM.const_APP_SETTINGS_MENU_ITEM_SELECTED_TEXT_COLOR
                font.pointSize: 20
                font.family: EngineListener.getFont(false)
                visible: isPopEnable
            }


            Image{
                id: playButton;
                source: (isPopEnable) ? RES.const_URL_IMG_SETTINGS_B_KEYPAD_ARROW_DOWN_N : RES.const_URL_IMG_SETTINGS_B_KEYPAD_ARROW_DOWN_D
                anchors.left:parent.left
                anchors.leftMargin:481
                anchors.verticalCenter: parent.verticalCenter
                visible: isPopEnable
            }

            MouseArea{
                id: mouse_area1
                anchors.fill: parent
                beepEnabled: false

                onClicked:
                {
                    SettingsStorage.callAudioBeepCommand()
                    if(isPopEnable)
                        itemSelect(index, itemTypeNumber, false)
                }
            }

            onJogSelected:
            {
                switch( status )
                {
                case UIListenerEnum.KEY_STATUS_PRESSED:
                {
                    if(isPopEnable) item_keypad.pressed = true
                }
                break

                case UIListenerEnum.KEY_STATUS_RELEASED:
                {
                    item_keypad.pressed = false

                    if(isPopEnable) itemSelect(index, itemTypeNumber, true)
                }
                break

                case UIListenerEnum.KEY_STATUS_CANCELED:
                {
                    item_keypad.pressed = false
                }
                break
                }
            }

            Component.onCompleted:
            {
                switch(itemTypeNumber)
                {
                case 0:     // Korean
                {
                    keypadSettingMain.getKoreanKeypad()
                    break;
                }
                case 1:     // English
                {
                    keypadSettingMain.getEnglishKeypad()
                    break;
                }
                case 2:     // Chinese
                {
                    keypadSettingMain.getChinaKeypad()
                    break;
                }
                case 3:     // Arabic
                {
                    keypadSettingMain.getArabicKeypad()
                    break;
                }
                case 4:     // Europe
                {
                    keypadSettingMain.getEuropeKeypad()
                    break;
                }
                case 5:     // Russian
                {
                    keypadSettingMain.getRusCyrillicKeypad()
                    break;
                }
                case 6:     // Hyundai
                {
                    if (SettingsStorage.currentRegion == 0 || SettingsStorage.currentRegion== 3)
                    {
                        if ( SettingsStorage.hyunDaiKeypad != Settings.SETTINGS_HYUNDAI_KOREAN)
                        {
                            SettingsStorage.hyunDaiKeypad = Settings.SETTINGS_HYUNDAI_KOREAN
                            SettingsStorage.SaveSetting( Settings.SETTINGS_HYUNDAI_KOREAN, Settings.DB_KEY_HYUNDAY_KEYPAD )
                            EngineListener.NotifyApplication( Settings.DB_KEY_HYUNDAY_KEYPAD, index, "", UIListener.getCurrentScreen())
                        }
                    }

                    keypadSettingMain.getHyundayKeypad()
                    break;
                }
                }
            }
        }
    }

    DHAVN_AppSettings_FocusedList{
        id: listOfSettings
        anchors.fill: keypadSettingMain
        model: keypadSettingMain.getKeypadModel()
        orientation: ListView.Vertical
        delegate:  item_delegate
        clip: true
        cacheBuffer: 100
        interactive:true
        isMenuListView: false

        property bool initModel: false

        name: "KeypadList"

        focus_x: 0
        focus_y: 0

        function connectLostFocus()
        {
            for (var i = 0; i < listOfSettings.model.count; i++ )
            {
                addedElement( i )
            }
        }

        onModelChanged:
        {
            if(!initModel)
            {
                initModel = true
            }
            else
            {
                keypadSettingMain.setFocusHandle(0,0)
                listOfSettings.hideFocus()
                listOfSettings.currentIndex = 0
                listOfSettings.__current_index = 0
                listOfSettings.showFocus()
                connectLostFocus()
            }
        }

        onJogSelected:
        {
            switch ( status )
            {
            case UIListenerEnum.KEY_STATUS_PRESSED:
            {
                listOfSettings.currentItem.pressed = true
            }
            break

            case UIListenerEnum.KEY_STATUS_RELEASED:
            {
                listOfSettings.currentItem.pressed = false
            }
            break

            case UIListenerEnum.KEY_STATUS_CANCELED:
            {
                listOfSettings.currentItem.pressed = false
            }
            break
            }
        }

        onMovementEnded:
        {
            if(!focus_visible)
            {
                listOfSettings.hideFocus()
                keypadSettingMain.setFocusHandle(0,0)
                listOfSettings.currentIndex = 0
                if(isShowSystemPopup == false)
                {
                    listOfSettings.showFocus()
                }
            }
        }

        Component.onCompleted:
        {
            connectLostFocus()
        }
    }

    Connections{
        target: rootPopUpLoader.item
        onUpdateCurrentType:
        {
            switch(type)
            {
            case Settings.DB_KEY_ENGLISH_KEYPAD:
                getEnglishKeypad()
                break;
            case Settings.DB_KEY_KOREAN_KEYPAD:
                getKoreanKeypad()
                break;
            case Settings.DB_KEY_ARABIC_KEYPAD:
                getArabicKeypad()
                break;
            case Settings.DB_KEY_CHINA_KEYPAD:
                getChinaKeypad()
                break;
            case Settings.DB_KEY_EUROPE_KEYPAD:
                getEuropeKeypad()
                break;
            case Settings.DB_KEY_RUSSIAN_KEYPAD:
                getRusCyrillicKeypad()
                break;
            }
        }
    }

    Connections{
        target: rootPopUpLoader.item
        onUpdateHyundayType:
        {
            getHyundayKeypad()
        }
    }

    Connections{
        target: SettingsStorage

        onChangeKeypadSettings:
        {
            init()
        }

        onHyunDaiKeypadChanged:
        {
            //console.log("[QML][KeypadSetting]called onHyunDaiKeypadChanged :"+SettingsStorage.hyunDaiKeypad)
            listOfSettings.model = getKeypadModel()
            getHyundayKeypad()
        }

        onEnglishKeypadChanged:
        {
            //console.log("[QML][KeypadSetting]called onEnglishKeypadChanged :"+SettingsStorage.englishKeypad)
            getEnglishKeypad()
        }

        onKoreanKeypadChanged:
        {
            //console.log("[QML][KeypadSetting]called onKoreanKeypadChanged :"+SettingsStorage.koreanKeypad)
            getKoreanKeypad()
        }

        onChinaKeypadChanged:
        {
            //console.log("[QML][KeypadSetting]called onChinaKeypadChanged :"+SettingsStorage.chinaKeypad)
            getChinaKeypad()
        }

        onEuropeKeypadChanged:
        {
            //console.log("[QML][KeypadSetting]called onEuropeKeypadChanged :"+SettingsStorage.europeKeypad)
            getEuropeKeypad()
        }

        onArabicKeypadChanged:
        {
            //console.log("[QML][KeypadSetting]called onArabicKeypadChanged :"+SettingsStorage.arabicKeypad)
            getArabicKeypad()
        }

        onRussianKeypadChanged:
        {
            //console.log("[QML][KeypadSetting]called onRussianKeypadChanged :"+SettingsStorage.russianKeypad)
            getRusCyrillicKeypad()
        }
    }

    onItemSelect:
    {
        if(!isJog)
        {
            keypadSettingMain.setFocusHandle(0,0)
            listOfSettings.hideFocus()
            listOfSettings.currentIndex = itemIndex
        }

        switch(itemTypeNumber)
        {
        case 0:     // Korean
        {
            rootPopUpLoader.showPopupDirectly("DHAVN_AppSettings_General_Keypad_RadioPopup.qml")
            rootPopUpLoader.item.showPopUp( Settings.DB_KEY_KOREAN_KEYPAD )
            break;
        }
        case 1:     // English
        {
            rootPopUpLoader.showPopupDirectly("DHAVN_AppSettings_General_Keypad_RadioPopup.qml")
            rootPopUpLoader.item.showPopUp( Settings.DB_KEY_ENGLISH_KEYPAD )
            break;
        }
        case 2:     // Chinese
        {
            rootPopUpLoader.showPopupDirectly("DHAVN_AppSettings_General_Keypad_RadioPopup.qml")
            rootPopUpLoader.item.showPopUp( Settings.DB_KEY_CHINA_KEYPAD )
            break;
        }
        case 3:     // Arabic
        {
            rootPopUpLoader.showPopupDirectly("DHAVN_AppSettings_General_Keypad_RadioPopup.qml")
            rootPopUpLoader.item.showPopUp( Settings.DB_KEY_ARABIC_KEYPAD )
            break;
        }
        case 4:     // Europe
        {
            rootPopUpLoader.showPopupDirectly("DHAVN_AppSettings_General_Keypad_RadioPopup.qml")
            rootPopUpLoader.item.showPopUp( Settings.DB_KEY_EUROPE_KEYPAD )
            break;
        }
        case 5:     // Russian
        {
            rootPopUpLoader.showPopupDirectly("DHAVN_AppSettings_General_Keypad_RadioPopup.qml")
            rootPopUpLoader.item.showPopUp( Settings.DB_KEY_RUSSIAN_KEYPAD )
            break;
        }
        case 6:     // Hyundai
        {
            rootPopUpLoader.showPopupDirectly("DHAVN_AppSettings_General_Keypad_Hyunday_RadioPopup.qml")
            break;
        }
        }
    }

    onFocus_visibleChanged:
    {
        if(focus_visible)
        {
            if(isFocusMovableToLeft)
            {
                setVisualCue(true, false, true, false)
            }
            else
            {
                setVisualCue(true, false, false, false)
            }
        }
        else
            listOfSettings.currentIndex = 0
    }
}
