/**
 * /QML/DDCheckBox.qml
 *
 */
import QtQuick 1.1
import "../BT/Common/System/DH/ImageInfo.js" as ImagePath


DDAbstractBox
{
    id: idCheckBoxContainer
    x: 0
    y: 0
    focus: false


    // PROPERTIES
    imageUncheck: ImagePath.imgFolderSettings + "ico_check_n.png"
    imageCheck: ImagePath.imgFolderSettings + "ico_check_s.png"
}
/* EOF */
