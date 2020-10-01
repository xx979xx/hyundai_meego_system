/**
 * BtFaviriteDeleteOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MOptionMenu
{
    id: idBtFavoriteDeleteOption
    linkedModels: favoriteListModel
    focus: true
    visible: true


    /* LISTMODEL */
    ListModel {
        id: favoriteListModel

        ListElement { name:"";      opType: "" }
    }


    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            idBtFavoriteDeleteOption.linkedModels.get(0).name = stringInfo.str_Cancel_Delete
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idBtFavoriteDeleteOption.linkedModels.get(0).name = stringInfo.str_Cancel_Delete
    }

    onVisibleChanged: {
        if(true == idBtFavoriteDeleteOption.visible) {
            idBtFavoriteDeleteOption.linkedModels.get(0).name = stringInfo.str_Cancel_Delete
        }
    }

    onMenu0Click: {
        idMenu.off();
        favoriteDeleteCancel();
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
