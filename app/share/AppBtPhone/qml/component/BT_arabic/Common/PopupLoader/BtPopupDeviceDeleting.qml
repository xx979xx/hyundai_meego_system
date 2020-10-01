/**
 * /BT_arabic/Common/PopupLoader/BtPopupDeviceDeleting.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp


MComp.MPopupTypeDimLoading
{
    id: idBtPopupDeviceDeleting

    firstText: stringInfo.str_Deleting

    black_opacity: (true == btPhoneEnter) ? false : true

    MouseArea {
        anchors.fill: parent
        onClicked: {}
        beepEnabled: false
    }
}
/* EOF */
