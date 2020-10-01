import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.settings.variables 1.0
import com.settings.defines 1.0
import "DHAVN_AppSettings_General.js" as HM

DHAVN_AppSettings_FocusedItem{
    id: hyundayKeypadPopupMain

    x:0; y:0; width: 1280; height: 720

    property bool isGetListModel: false

    signal updateHyundayType()
    signal closePopUp(bool isYesPressed, int popup_type)

    default_x: 0
    default_y: 0
    name: "Keypad_RadioList"

    function getListModel()
    {
        switch(SettingsStorage.currentRegion)
        {
        case -1:
        case 0: //eCVKorea
        case 3: //eCVGeneral
        {
            return koreanModel
        }
        case 2: //eCVChina
        {
            return chinaModel
        }
        case 1: //eCVNorthAmerica
        case 6:
        {
            return englishModel
        }
        case 4: //eCVMiddleEast
        {
            return arabicModel
        }
        case 5://eCVEuropa
        {
            return europeModel
        }
        case 7:
        {
            return rusModel
        }
        default:
            return koreanModel
        }
    }

    function getDefaultFocusIndex()
    {
        var temp = SettingsStorage.hyunDaiKeypad
        var nCurIndex = 0

        if(popupSetType.listmodel.count == 1)
            return 0;

        for (var i = 0; i < popupSetType.listmodel.count; i++ )
        {
            if(popupSetType.listmodel.get(i).dbID == temp)
            {
                nCurIndex = i
                popupSetType.nCurIndex = i
            }
        }

        if(HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE == nCurIndex)
        {
            if(popupSetType.listmodel.count <= nCurIndex+1)
                return nCurIndex-1
            else
                return nCurIndex+1
        }
        else
            return HM.const_SETTINGS_GENERAL_KEYBOARD_POPUP_DEFAULT_VALUE
    }

    function getSelectedItemIndex()
    {
        for (var i = 0; i < popupSetType.listmodel.count; i++ )
        {
            if(popupSetType.listmodel.get(i).dbID == temp)
            {
                return i;
            }
        }
    }

    function setKeypadSettings(index)
    {
        SettingsStorage.hyunDaiKeypad = index
        SettingsStorage.SaveSetting( index, Settings.DB_KEY_HYUNDAY_KEYPAD )
        hyundayKeypadPopupMain.updateHyundayType()
        EngineListener.NotifyApplication( Settings.DB_KEY_HYUNDAY_KEYPAD, index, "", UIListener.getCurrentScreen())
    }

    PopUpRadioList{
        id: popupSetType
        z: 10000

        property int focus_x: 0
        property int focus_y: 0
        property string name: "PopUpRadioList"
        focus_id: 0
        listmodel: getListModel()
        nCurIndex: getSelectedItemIndex()
        default_list_index: getDefaultFocusIndex()

        buttons: ListModel { ListElement { msg: QT_TR_NOOP("STR_POPUP_CANCEL"); btn_id: 1 } }

        onBtnClicked:
        {
            hyundayKeypadPopupMain.closePopUp(false,-1)
        }

        onRadioBtnClicked:
        {
            setKeypadSettings(listmodel.get(index).dbID)
            hyundayKeypadPopupMain.closePopUp(false,-1)
        }
    }

    ListModel{
        id: koreanModel
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")
            dbID: Settings.SETTINGS_HYUNDAI_KOREAN
        }
    }

    ListModel{
        id: chinaModel
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_CHINA")
            dbID: Settings.SETTINGS_HYUNDAI_CHINA
        }
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")
            dbID: Settings.SETTINGS_HYUNDAI_KOREAN
        }
    }

    ListModel{
        id: englishModel
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_ENGLISH_LATIN")
            dbID: Settings.SETTINGS_HYUNDAI_ENGLISH_LATIN
        }
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")
            dbID: Settings.SETTINGS_HYUNDAI_KOREAN
        }
    }

    ListModel{
        id: arabicModel
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_ARABIC")
            dbID: Settings.SETTINGS_HYUNDAI_ARABIC
        }
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")
            dbID: Settings.SETTINGS_HYUNDAI_KOREAN
        }
    }

    ListModel{
        id: europeModel
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_EUROPE")
            dbID: Settings.SETTINGS_HYUNDAI_EUROPE
        }
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")
            dbID: Settings.SETTINGS_HYUNDAI_KOREAN
        }
    }

    ListModel{
        id: rusModel
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_CYRILIC_RUS")
            dbID: Settings.SETTINGS_HYUNDAI_EUROPE
        }
        ListElement {
            name:  QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")
            dbID: Settings.SETTINGS_HYUNDAI_KOREAN
        }
    }
}
