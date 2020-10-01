/**
 * BtImageFocusLeft.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


Image
{
    id: idImageFocusLeft
    y: 1
    source: ImagePath.imgFolderGeneral + "bg_menu_l.png"

    Image {
        x: 613
        source: ImagePath.imgFolderGeneral + "bg_menu_l_s.png"
    }
}
/* EOF */ 
