import QtQuick 1.0
import QmlPopUpPlugin 1.0
import PopUpConstants 1.0
import QmlStatusBar 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item{
    id: root
    x:0; y:0; width: 1280; height: 720
    Rectangle {
        id: bg_color
        anchors.fill: parent
        color: "#000000"
    }
    PopUpText
    {
        id: warningPopUp
        z: Dimensions.const_AppUserManual_Z_1000
        visible: true
        message: toast_text_model
        icon_title: EPopUp.LOADING_ICON
    }
    ListModel
    {
        id: toast_text_model
        ListElement { msg: QT_TR_NOOP("STR_SETTINGS_CHANGE_LANGUAGE") }
    }
    QmlStatusBar {
        id: statusbar
        x: 0; y: 0;
        width: Dimensions.const_AppUserManual_MainScreenWidth; height: Dimensions.const_AppUserManual_StatusBar_Height
        homeType: "button"
        middleEast: ( langId == 20 ) ? true : false
    }
}
