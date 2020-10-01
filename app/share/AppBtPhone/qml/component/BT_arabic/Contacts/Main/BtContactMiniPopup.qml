/**
 * /BT/Contacts/Main/BtContactMiniPopup.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath


Item
{
    id: idContactMiniPopupContainer
    visible: false

    /* PROPERTIES */
    property alias miniPopupText: idMiniPopupText.text


    /* INTERNAL functions */
    function start() {
        idMiniPopupTimer.start();
    }

    function stop() {
        idMiniPopupTimer.stop();
    }

    function restart() {
        idMiniPopupTimer.restart()
    }


    function show(letter) {
        if("" != letter) {
            idMiniPopupText.text = letter;
        }

        idContactMiniPopupContainer.visible = true;
        idMiniPopupTimer.restart();
    }

    function hide() {
        idContactMiniPopupContainer.visible = false;
        idMiniPopupTimer.stop()
    }


    /* EVENT handlers */
    Component.onCompleted: {
    }

    Component.onDestruction: {
        idMiniPopupTimer.stop();
    }


    /* WIDGETS */
    Image {
        id: idMiniPopup
        source: ImagePath.imgFolderBt_phone + "bg_popup_quickscroll.png"
        x: 0
        y: 0
        width: 203
        height: 149

        Text {
            id: idMiniPopupText
            x: 17
            y: 25
            width: 170
            height: 100
            font.pointSize: 100
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
        }
    }


    /* TIMERS */
    Timer {
        id: idMiniPopupTimer
        interval: 1000
        running: false
        repeat: false

        onTriggered: {
            idContactMiniPopupContainer.visible = false;
        }
    }
}
/* EOF */
