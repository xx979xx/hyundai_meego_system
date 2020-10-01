/**
 * BtDeviceDeleteOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MOptionMenu
{
    id: idBtDeviceDeleteOption
    linkedModels: deviceListModel
    focus: true
    visible: true


    /* LISTMODEL */
    ListModel {
        id: deviceListModel

        ListElement { name:"";      opType: "" }
    }


    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            idBtDeviceDeleteOption.linkedModels.get(0).name = stringInfo.str_Cancel_Delete
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idBtDeviceDeleteOption.linkedModels.get(0).name = stringInfo.str_Cancel_Delete
    }

    onVisibleChanged: {
        if(true == idBtDeviceDeleteOption.visible) {
            idBtDeviceDeleteOption.linkedModels.get(0).name = stringInfo.str_Cancel_Delete
        }
    }

    onMenu0Click: {
        idMenu.off();
        deviceDeleteCancel();
    }

    onOptionMenuFinished: {
        if(true == visible) {
            idMenu.hide();
        }
    }

    onClickDimBG: {
        idMenu.hide();
    }
}
/* EOF */
