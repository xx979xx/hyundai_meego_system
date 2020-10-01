/**
 * BtRecentDeleteOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MOptionMenu
{
    id: idBtRecentDeleteOption
    linkedModels: recentListModel
    focus: true
    visible: true


    /* LISTMODEL */
    ListModel {
        id: recentListModel

        ListElement { name:"";      opType: "" }
    }


    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            idBtRecentDeleteOption.linkedModels.get(0).name = stringInfo.str_Cancel_Delete
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idBtRecentDeleteOption.linkedModels.get(0).name = stringInfo.str_Cancel_Delete
    }

    onVisibleChanged: {
        if(true == idBtRecentDeleteOption.visible) {
            idBtRecentDeleteOption.linkedModels.get(0).name = stringInfo.str_Cancel_Delete
        }
    }

    onMenu0Click: {
        idMenu.off();
        recentDeleteCancel();
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
