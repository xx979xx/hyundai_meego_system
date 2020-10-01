
/**
 * FileName: MScroll.qml
 * Author: HYANG
 * Time: 2012-11
 *
 * - 2012-11 Initial Created by HYANG
 */

import Qt 4.7
import "../../system/DH" as MSystem

Item {
    id: idMScroll

    property variant scrollArea
    property variant orientation: Qt.Vertical

    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string scrollBarImage: imgFolderGeneral + "scroll.png"
    property string selectedScrollImage: imgFolderGeneral+"scroll_option_bg.png"

    //****************************** # Scroll Background Image #
    Image{
        id: imgScrollBg
        anchors.fill: parent
        source: selectedScrollImage
    } // End ScrollBg Image

    //****************************** # ScrollBar Move Image #
    BorderImage {
        id: imgScroll
        source: scrollBarImage

        property double scrollAreaYPosistion : scrollArea.visibleArea.yPosition
        property int poxY: scrollArea.visibleArea.yPosition * idMScroll.height
        property int poxHeight: scrollArea.visibleArea.heightRatio * idMScroll.height

        border { left: 2; right: 2; top: 8; bottom: 8 }
        y: poxY
        height: poxHeight
        // blacktip : for exceed bounce animation
        onScrollAreaYPosistionChanged: {
            // y
            if(scrollAreaYPosistion < 0) // up
            {
                poxY = 0;
                poxHeight = (scrollArea.visibleArea.heightRatio * idMScroll.height) + (scrollArea.visibleArea.yPosition * idMScroll.height);
            }else if(scrollAreaYPosistion > (1 - scrollArea.visibleArea.heightRatio)) // down
            {
                poxY = scrollArea.visibleArea.yPosition * idMScroll.height;
                poxHeight = (scrollArea.visibleArea.heightRatio * idMScroll.height) - (idMScroll.height* (scrollArea.visibleArea.yPosition - (1- scrollArea.visibleArea.heightRatio)))
            }else
            {
                poxY = scrollArea.visibleArea.yPosition * idMScroll.height;
                poxHeight = scrollArea.visibleArea.heightRatio * idMScroll.height;
            }
        }

    } // End BorderImage
} // End Item
