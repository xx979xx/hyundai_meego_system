/**
 * FileName: MOptionMenuList.qml
 * Author: WSH
 * Time: 2012-02-08
 *
 * - 2012-02-08 Initial Crated by WSH
 * - 2013-06-05 Modify by HYANG
 */

import QtQuick 1.1
import "../../QML/DH" as MComp

//--------------------- OptionMenu ListView #
Item{
    property alias menuListModel : listOptionMenu

    MComp.MListView {
        id: listOptionMenu
        anchors.fill: parent
        cacheBuffer: 99999
        opacity : 1
        clip: true
        focus: true
        model: linkedModels
        delegate: MOptionMenuDelegate {}
        orientation : ListView.Vertical
        highlightMoveSpeed: 99999
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.DragAndOvershootBounds
        optionMenuNoBand: true

        onVisibleChanged: {
            if (visible)
            {
                //# Focus skip when Disable
                var curIndex=0, totalCount=0;
                totalCount = menuListModel.count;
                while(curIndex != totalCount)
                {
                    if(getEnabled(curIndex) == true)
                    {
                        menuListModel.currentIndex = curIndex;
                        break;
                    }
                    curIndex++;
                }
            }
        }
        onMovementEnded: { idMOptionMenuTimer.restart(); }
    }

    //--------------------- ScrollBar #
    MScroll {
        x: iMenuScrollX
        y: iMenuScrollY
        height: 608
        width: 14
        visible: listOptionMenu.count > 8
        scrollArea: listOptionMenu
    }


    function getEnabled(index){
        switch(index){
        case 0: return menu0Enabled;
        case 1: return menu1Enabled;
        case 2: return menu2Enabled;
        case 3: return menu3Enabled;
        case 4: return menu4Enabled;
        case 5: return menu5Enabled;
        case 6: return menu6Enabled;
        case 7: return menu7Enabled;
        case 8: return menu8Enabled;
        default: return true;
        }
    } // End function
} // End Item
