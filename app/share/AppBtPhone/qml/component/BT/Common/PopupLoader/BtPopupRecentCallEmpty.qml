/**
 * /BT/Common/PopupLoader/BtPopupRecentCallEmpty.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeDim
{
    id: idBtPopupRecentCallEmpty

    black_opacity: false

    firstText: stringInfo.str_No_Callhistory


    /* EVENT handlers */
    onShow: {}
    onHide: { MOp.postBackKey(333); }

    onPopupClicked:         { MOp.postBackKey(334); }
    onHardBackKeyClicked:   { MOp.postBackKey(335); }
}
/* EOF */
