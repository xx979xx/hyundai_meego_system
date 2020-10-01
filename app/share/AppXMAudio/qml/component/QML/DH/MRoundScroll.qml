/**
 * FileName: MRoundScroll.qml
 * Author: HYANG
 * Time: 2012-02-14
 *
 * - 2012-02-14 Initial Crated by HYANG
 * - 2012-07-26 added list number property of screen
 */

import QtQuick 1.1

Item {
    id: idMRoundScroll
    x: 0; y: 0; z: 1
    width: scrollWidth; height: scrollHeight

    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    property string scrollBgImage: imgFolderGeneral+"scroll_menu_bg.png"
    property string scrollBarImage: imgFolderGeneral+"scroll_menu.png"
    property int scrollWidth: 46
    property int scrollHeight: 491

    property int moveBarPosition
    property int listCount
    property int listCountOfScreen: 6
    property int moveBarHeight: ((scrollHeight / listCount) * listCountOfScreen) > 40 ? ((scrollHeight / listCount) * listCountOfScreen) : 40

    Image { source: scrollBgImage }

    Item{
        x: 0; y: moveBarPosition
        width: scrollWidth; height: moveBarHeight
        clip: true

        Image{
            smooth: true
            x: 0; y: -parent.y
            width: scrollWidth; height: scrollHeight;
            source: scrollBarImage
        }
    }
}

