import QtQuick 1.1
import QmlPopUpPlugin 1.0
import qwertyKeypadUtility 1.0

Item{
    id: root

    anchors.fill: parent

    property bool isGetListModel: false

    function showPopUp( )
    {
        console.log("ChineseKeypadPopup.qml :: showPopUp() ")
        root.visible = true
        popupSetType.listmodel = chinaModel;
        popupSetType.nCurIndex = appUserManualSearchView.getChineseKeypadType()
//        popupSetType.nCurIndex = keyPadWidget.setChineseKeypadType;

        if ( appUserManualSearchView.getChineseKeypadType() == 0 ) popupSetType.default_list_index = 1
//        if(keyPadWidget.setChineseKeypadType == 0)
//            popupSetType.default_list_index = 1
        else
            popupSetType.default_list_index = 0

        isGetListModel = true
    }

    function hidePopUp()
    {
        console.log("ChineseKeypadPopup.qml :: hidePopUp() ")
        root.visible = false
        isGetListModel = false
        appUserManualSearchView.setKeypadSettings(-1)
    }

    function setKeypadSettings(index)
    {
        switch(index)
        {
            case 0: // Pinyin
            {
                appUserManualSearchView.setKeypadSettings(index)
    //            keyPadWidget.setChineseKeypadType = 0
    //            keyPadWidget.chineseKeypadChanged( 0 )
            }
            break
            case 1: // HAND_WRITING (Need to update by ListModel)
            {
                appUserManualSearchView.setKeypadSettings(2)
//                keyPadWidget.setChineseKeypadType = 2
//                keyPadWidget.chineseKeypadChanged( 2 )
            }
            break
        }
    }

    MouseArea{
        anchors.fill: parent
        beepEnabled: false
        enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
    }

    PopUpRadioList{
        id: popupSetType
        listmodel: chinaModel
        nCurIndex:  appUserManualSearchView.getChineseKeypadType()//keyPadWidget.setChineseKeypadType
        default_list_index: 0
        buttons: buttonModel
        visible: isGetListModel

        onBtnClicked:
        {
            root.visible = false
            isGetListModel = false
            appUserManualSearchView.setKeypadSettings(-1)
        }
        onRadioBtnClicked:
        {
            if(nCurIndex != index)
            {
                nCurIndex = index
                setKeypadSettings(index)
            }

            root.visible = false
            isGetListModel = false
        }

        Component.onCompleted:
        {
            buttonModel.setProperty(0, "msg", qsTranslate("main", "STR_POPUP_CANCEL" ))
            chinaModel.setProperty(0, "name", qsTranslate( "main",  "STR_KEYPAD_CHINESE_PINYIN"))
            //chinaModel.setProperty(1, "name", qsTranslate( "main",  "STR_KEYPAD_CHINESE_VOCAL_SOUND"))
            chinaModel.setProperty(1, "name", qsTranslate( "main",  "STR_KEYPAD_CHINESE_HAND_WRITING"))
        }
    }

    ListModel {
        id: buttonModel
        ListElement { msg: "STR_POPUP_CANCEL"; btn_id: 1 }
    }

    ListModel {
        id: chinaModel
        ListElement { name: "STR_KEYPAD_CHINESE_PINYIN" }
        //ListElement { name: "STR_KEYPAD_CHINESE_VOCAL_SOUND" }
        ListElement { name: "STR_KEYPAD_CHINESE_HAND_WRITING" }
    }

    Connections{
        target: EngineListener

        onRetranslateUi:
        {
            console.log("ChineseKeypadPopup.qml :: RetranslateUi Called.");
            buttonModel.setProperty(0, "msg", qsTranslate( "main", "STR_POPUP_CANCEL"))
            chinaModel.setProperty(0, "name", qsTranslate( "main",  "STR_KEYPAD_CHINESE_PINYIN"))
            //chinaModel.setProperty(1, "name", qsTranslate( "main",  "STR_KEYPAD_CHINESE_VOCAL_SOUND"))
            chinaModel.setProperty(1, "name", qsTranslate( "main",  "STR_KEYPAD_CHINESE_HAND_WRITING"))
        }
    }
}
