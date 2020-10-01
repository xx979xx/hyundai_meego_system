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
    width: scrollWidth; height: scrollHeight

    MSystem.ColorInfo {id:colorInfo}
    MSystem.ImageInfo {id:imageInfo}
    MSystem.SystemInfo {id:systemInfo}

    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    property string scrollBgImage: imgFolderGeneral+"scroll_menu_bg.png"
    property string scrollBarImage: imgFolderGeneral+"scroll_menu.png"
    property int scrollWidth: 46
    property int scrollHeight: 491

    property int moveBarPosition
    property int listCount
    property int listCountOfScreen: 6
    property int moveBarHeight: parseInt((scrollHeight / listCount) * listCountOfScreen);

    Image { source: scrollBgImage }

    Item{
        x: 0;
        y: ((scrollHeight-moveBarPosition)<=80)?(scrollHeight-80):moveBarPosition; //moveBarPosition
        width: scrollWidth; height: (moveBarHeight<=80)?80:moveBarHeight;  //moveBarHeight
        clip: true

        Image{
            smooth: true
            x: 0; y: -parent.y
            width: scrollWidth; height: scrollHeight;
            source: scrollBarImage
        }
    }
}

