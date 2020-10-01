import QtQuick 1.0
import QmlPopUpPlugin 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item{
    id: root
    x:0; y:0; width: 1280; height: 720
    PopUpText
    {
        id: searchEndPopUp
        z: Dimensions.const_AppUserManual_Z_1000
        visible: true
        message: ListModel {
            ListElement { msg: QT_TR_NOOP("STR_MANUAL_SEARCH_END") }
        }
        buttons: ListModel {
            ListElement { msg: QT_TR_NOOP("STR_MANUAL_OK"); btn_id: 1 }
        }
        onBtnClicked:
        {
            if ( lockoutMode ) return;
            console.log("Main.qml :: searchEndPopUp onBtnClicked")
            root.visible = false
        }
    }
}
