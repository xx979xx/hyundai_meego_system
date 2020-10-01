/**
 * BtImageFocusRight.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


Image
{
    id: idImageFocusRight
    y: 1
    source: ImagePath.imgFolderGeneral + "bg_menu_r.png"

    Image {
        x: 589
        source: ImagePath.imgFolderGeneral + "bg_menu_r_s.png"
    }
}
/* EOF */    
