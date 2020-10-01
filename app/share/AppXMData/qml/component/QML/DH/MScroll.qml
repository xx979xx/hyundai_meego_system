
/**
 * FileName: MScroll.qml
 * Author: HYANG
 * Time: 2012-11
 *
 * - 2012-11 Initial Created by HYANG
 */

import Qt 4.7

Item {
    id: idMScroll

    property variant scrollArea
    property int orientation: Qt.Vertical

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
        border { left: 2; right: 2; top: 8; bottom: 8 }
        y: poxY
        height: scrollAreaHeightRatio * idMScroll.height < 40 ? 40 : scrollAreaHeightRatio * idMScroll.height

        property double scrollAreaYPosistion : scrollArea.visibleArea.yPosition
        property int poxY: scrollAreaYPosistion * idMScroll.height
        property double scrollAreaHeightRatio: scrollArea.visibleArea.heightRatio
        property int scrollAreaHeight: scrollArea.height

        onScrollAreaHeightChanged: {
            calculateScrollPox();
        }

        onScrollAreaHeightRatioChanged: {
            calculateScrollPox();
        }

        // blacktip : for exceed bounce animation
        onScrollAreaYPosistionChanged: {
            calculateScrollPox();
        }

        Component.onCompleted: {
            calculateScrollPox();
        }

        onVisibleChanged: {
            if(visible)
                calculateScrollPox();
        }

        function calculateScrollPox(){
            var tempRatio = scrollArea.visibleArea.heightRatio;
            var tempMScrollHeight = idMScroll.height;
            var isOverSize = false;

            var tempHeight, tempPoxY;


            if((tempRatio * idMScroll.height) < 40)
            {
                tempRatio = 40 / idMScroll.height;
                tempMScrollHeight = tempMScrollHeight - 40 + (scrollAreaHeightRatio * idMScroll.height)
                isOverSize = true;
            }

            var aValue = parseInt(scrollAreaYPosistion*tempMScrollHeight);
            var bValue = (parseFloat(tempMScrollHeight) - (scrollAreaHeightRatio * (idMScroll.height)));

            if(scrollAreaYPosistion < 0) // up
            {
                tempHeight = (tempRatio * tempMScrollHeight) + (scrollAreaYPosistion * tempMScrollHeight);
                tempPoxY = 0;

            }else if(isOverSize == false && scrollAreaYPosistion > (1 - tempRatio))
            {
                tempHeight = (tempRatio * tempMScrollHeight) - (tempMScrollHeight* (scrollAreaYPosistion - (1- tempRatio)))
                tempPoxY = tempMScrollHeight - parseInt(tempHeight, 10);
            }else if(isOverSize = true &&  aValue >= bValue)
            {
                tempHeight = (tempRatio * idMScroll.height);
                tempPoxY = bValue;
            }
            else
            {
                tempHeight = (tempRatio * idMScroll.height);
                tempPoxY = scrollAreaYPosistion * tempMScrollHeight;
            }

            if(tempHeight < 40)
            {
                tempHeight = 40;
                if(tempPoxY+tempHeight <= idMScroll.height)
                {
                    height = tempHeight;
                    poxY = tempPoxY;
                }
            }else
            {
                height = tempHeight;
                poxY = tempPoxY;
            }
        }
    } // End BorderImage
} // End Item
