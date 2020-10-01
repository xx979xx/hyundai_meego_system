import QtQuick 1.0
import QmlPopUpPlugin 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item{
    id: root
    x:0; y:0; width: 1280; height: 720
    PopUpText
    {
        id: pagePopUp
        z: Dimensions.const_AppUserManual_Z_1000
        visible: true
        message: ListModel {
            ListElement { msg: QT_TR_NOOP("STR_MANUAL_PAGELIMIT_WARNING") }
        }
        buttons: buttonModel /* ListModel {
            ListElement { msg: QT_TR_NOOP("STR_MANUAL_OK")  }
        }*/
        onBtnClicked:
        {
            if ( lockoutMode ) return;
            console.log("Main.qml :: pagePopUp onBtnClicked")
            root.visible = false
        }
        Component.onCompleted:
        {
            buttonModel.setProperty(0, "msg", qsTranslate("main", "STR_MANUAL_OK" ))
        }
    }
    ListModel {
        id: buttonModel
        ListElement { msg: "STR_MANUAL_OK"; btn_id: 1 }
    }
}
