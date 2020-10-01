/**
 * /BT/Common/PopupLoader/BtPopupDeviceDeleting.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp


MComp.MPopupTypeDimLoading
{
    id: idBtPopupDeviceDeleting

    firstText: stringInfo.str_Deleting

    black_opacity: (true == btPhoneEnter) ? false : true

    /*ITS 0240856 Beep 음 출력 이슈*/
    MouseArea {
        anchors.fill: parent
        onClicked: {}
        beepEnabled: false
    }
}
/* EOF */
