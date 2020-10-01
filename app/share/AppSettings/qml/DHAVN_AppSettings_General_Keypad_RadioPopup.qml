import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.settings.variables 1.0
import com.settings.defines 1.0
import "DHAVN_AppSettings_General.js" as HM

DHAVN_AppSettings_FocusedItem{
    id: root

    x:0; y:0; width: 1280; height: 720

    //visible: false
    property bool isGetListModel: false
    property int dbKey: Settings.DB_KEY_ENGLISH_KEYPAD
    //property string popupTitle: ""
    //property bool backbutton:backpressed()

    signal updateCurrentType(int type)
    signal closePopUp(bool isYesPressed, int popup_type)

    default_x: 0
    default_y: 0
    name: "Keypad_RadioList"

    function showPopUp( keypad_type )
    {
        var nCurrentIndex = 0
        //root.visible = true
        dbKey = keypad_type
        switch ( dbKey )
        {
        case Settings.DB_KEY_ENGLISH_KEYPAD:
            popupSetType.listmodel = englishModel;

            nCurrentIndex = SettingsStorage.englishKeypad
            popupSetType.nCurIndex = nCurrentIndex

            if(HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE == nCurrentIndex)
            {
                if(englishModel.count <= nCurrentIndex+1)
                    popupSetType.default_list_index = nCurrentIndex-1
                else
                    popupSetType.default_list_index = nCurrentIndex+1
            }
            else
                popupSetType.default_list_index = HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE

            break;
        case Settings.DB_KEY_KOREAN_KEYPAD:
            popupSetType.listmodel = koreanModel;

            nCurrentIndex = SettingsStorage.koreanKeypad
            popupSetType.nCurIndex = nCurrentIndex

            if(HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE == nCurrentIndex)
            {
                if(koreanModel.count <= nCurrentIndex+1)
                    popupSetType.default_list_index = nCurrentIndex-1
                else
                    popupSetType.default_list_index = nCurrentIndex+1
            }
            else
                popupSetType.default_list_index = HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE

            break;
        case Settings.DB_KEY_CHINA_KEYPAD:
            popupSetType.listmodel = chinaModel;

            nCurrentIndex = SettingsStorage.chinaKeypad
            popupSetType.nCurIndex = nCurrentIndex

            if(HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE == nCurrentIndex)
            {
                if(chinaModel.count <= nCurrentIndex+1)
                    popupSetType.default_list_index = nCurrentIndex-1
                else
                    popupSetType.default_list_index = nCurrentIndex+1
            }
            else
                popupSetType.default_list_index = HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE

            break;
        case Settings.DB_KEY_EUROPE_KEYPAD:
            popupSetType.listmodel = europeModel;

            nCurrentIndex = SettingsStorage.europeKeypad
            popupSetType.nCurIndex = nCurrentIndex

            if(HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE == nCurrentIndex)
            {
                if(europeModel.count <= nCurrentIndex+1)
                    popupSetType.default_list_index = nCurrentIndex-1
                else
                    popupSetType.default_list_index = nCurrentIndex+1
            }
            else
                popupSetType.default_list_index = HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE

            break;

        case Settings.DB_KEY_ARABIC_KEYPAD:
            popupSetType.listmodel = arabicModel;

            nCurrentIndex = SettingsStorage.arabicKeypad
            popupSetType.nCurIndex = nCurrentIndex

            if(HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE == nCurrentIndex)
            {
                if(arabicModel.count <= nCurrentIndex+1)
                    popupSetType.default_list_index = nCurrentIndex-1
                else
                    popupSetType.default_list_index = nCurrentIndex+1
            }
            else
                popupSetType.default_list_index = HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE

            break;

        case Settings.DB_KEY_RUSSIAN_KEYPAD:
            popupSetType.listmodel = cyryllicModel_Rus;

            nCurrentIndex = SettingsStorage.russianKeypad
            popupSetType.nCurIndex = nCurrentIndex

            if(HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE == nCurrentIndex)
            {
                if(cyryllicModel.count <= nCurrentIndex+1)
                    popupSetType.default_list_index = nCurrentIndex-1
                else
                    popupSetType.default_list_index = nCurrentIndex+1
            }
            else
                popupSetType.default_list_index = HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE

            break;

        }
        //popupSetType.nCurIndex = SettingsStorage.LoadSetting( dbKey )

        isGetListModel = true
    }

    function setKeypadSettings(index)
    {
        switch ( dbKey )
        {
        case Settings.DB_KEY_ENGLISH_KEYPAD:
            SettingsStorage.englishKeypad = index
            break;
        case Settings.DB_KEY_KOREAN_KEYPAD:
            SettingsStorage.koreanKeypad = index
            break;
        case Settings.DB_KEY_CHINA_KEYPAD:
            SettingsStorage.chinaKeypad = index
            break;
        case Settings.DB_KEY_EUROPE_KEYPAD:
            SettingsStorage.europeKeypad = index
            break;
        case Settings.DB_KEY_ARABIC_KEYPAD:
            SettingsStorage.arabicKeypad = index
            break;
        case Settings.DB_KEY_RUSSIAN_KEYPAD:
            SettingsStorage.russianKeypad = index
            break;
        }

        SettingsStorage.SaveSetting( index, dbKey )
        root.updateCurrentType(dbKey)
        SettingsStorage.UpdateKeyboardData()
        EngineListener.NotifyApplication( dbKey, index, "", UIListener.getCurrentScreen())
    }

    MouseArea{
        anchors.fill: parent
    }

    PopUpRadioList{
        id: popupSetType

        property int focus_x: 0
        property int focus_y: 0
        z: 10000
        focus_id: 0
        visible: isGetListModel

        property string name: "PopUpRadioList"

        //title: popupTitle
        listmodel: englishModel
        nCurIndex: SettingsStorage.LoadSetting( dbKey )
        default_list_index: 0

        buttons: buttonModel

        onBtnClicked:
        {
            //root.visible = false
            root.closePopUp(false,-1)
        }

        onRadioBtnClicked:
        {
            setKeypadSettings(index)
            root.closePopUp(false,-1)
        }
    }

    ListModel { id: buttonModel
        ListElement { msg: QT_TR_NOOP("STR_POPUP_CANCEL"); btn_id: 1 }
    }

    ListModel{
        id: koreanModel
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYBOARD_2SET") }
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYBOARD_KOR") }
    }

    ListModel{
        id: chinaModel
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_CHINESE_PINYIN") }
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_CHINESE_VOCAL_SOUND") }
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_CHINESE_HAND_WRITING") }
    }

    ListModel{
        id: englishModel
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTY") }
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ABCD") }
    }

    ListModel{
        id: europeModel
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTY") }
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ABCD") }
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTZ") }
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_AZERTY") }
    }

    ListModel{
        id: arabicModel
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_TYPE1") }
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_TYPE2") }
    }

    ListModel{
        id: cyryllicModel
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTY") }
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ABCD") }
    }
    ListModel{
        id: cyryllicModel_Rus
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_QWERTY_RUS") }
        ListElement { name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ABCD_RUS") }
    }

}
