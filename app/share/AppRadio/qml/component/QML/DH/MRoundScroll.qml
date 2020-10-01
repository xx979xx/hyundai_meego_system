/**
 * FileName: MRoundScroll.qml
 * Author: HYANG
 * Time: 2012-02-14
 *
 * - 2012-02-14 Initial Crated by HYANG
 * - 2012-07-26 added list number property of screen
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

Item {
    id: idMRoundScroll
    x: 0; y: 0; z: 1
    width: 46; height: 491//489

    MSystem.ColorInfo {id:colorInfo}
    MSystem.ImageInfo {id:imageInfo}
    MSystem.SystemInfo {id:systemInfo}

    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property int moveBarPosition
    property int listCount
    property int listCountOfScreen: 6
    property int moveBarHeight: (491/listCount)*listCountOfScreen

    Image {
        source: imgFolderGeneral+"scroll_menu_bg.png"
    }

    Item{
        x: 0; y: moveBarPosition
        width: 46; height: moveBarHeight
        clip: true
        Image{
            x: 0; y: -parent.y
            height: 491; width: 44
            smooth: true;
            source: imgFolderGeneral+"scroll_menu.png"
        }
    }
}

