/**
 * /QML/DDRadioBox.qml
 *
 */
import QtQuick 1.1


import QtQuick 1.1
import "../BT/Common/System/DH/ImageInfo.js" as ImagePath


DDAbstractBox
{
    id: idRadioBoxContainer
    x: 0
    y: 0
    focus: false


    // PROPERTIES
    imageUncheck: ImagePath.imgFolderSettings + "btn_radio_n.png"
    imageCheck: ImagePath.imgFolderSettings + "btn_radio_s.png"
}
/* EOF */
