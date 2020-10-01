/**
 * BtImageFocusLeft.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


Image
{
    id: idImageFocusLeft
    y: 1
    source: ImagePath.imgFolderGeneral + "bg_menu_l.png"

    Image {
        source: ImagePath.imgFolderGeneral + "bg_menu_l_s.png"
    }
}
/* EOF */ 
