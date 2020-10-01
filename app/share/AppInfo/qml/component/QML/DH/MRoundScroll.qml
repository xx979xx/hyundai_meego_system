/**
 * FileName: MRoundScroll.qml
 * Author: HYANG
 * Time: 2012-02-14
 *
 * - 2012-02-14 Initial Crated by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

Item {
    id: idMRoundScroll
    x: 0; y: 0; z: 1
    width: 44; height: 489

    MSystem.ColorInfo {id:colorInfo}
    MSystem.ImageInfo {id:imageInfo}
    MSystem.SystemInfo {id:systemInfo}

    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property int moveBarPosition
    property int listCount
    property int moveBarHeight: (489/listCount)*6

    Image {
        source: imgFolderGeneral+"scroll_menu_bg.png"
    }

    Item{
        x: 0; y: moveBarPosition
        width: 44; height: moveBarHeight
        clip: true
        Image{
            x: 0; y: -parent.y
            height: 489; width: 44
            source: imgFolderGeneral+"scroll_menu.png"
        }
    }
}

