/**
 * FileName: MOptionMenuList.qml
 * Author: WSH
 * Time: 2012-02-08
 *
 * - 2012-02-08 Initial Crated by WSH
 */
import QtQuick 1.0

//--------------------- OptionMenu ListView #
Item {
    MListView {
        id: listOptionMenu       
        anchors.fill: parent
        cacheBuffer: listOptionMenu.count - 8
        opacity : 1
        // clip: true
        focus: true    
        model: linkedModels
        delegate: MOptionMenuDelegate {}
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.DragAndOvershootBounds

        property int saveCurrentIndex: 0
        onMovementEnded: {
            idMOptionMenuTimer.restart();
            if( saveCurrentIndex < 2 ){
                for(var i=2; listOptionMenu.count > i ;i++){
                    listOptionMenu.currentIndex = i
                    if(!listOptionMenu.currentItem.mEnabled){ continue; }
                    else { break; }
                }
            }

	    //autofocus after flickable / firstItem focus after visible false
            if(visibleCheck == false){ listOptionMenu.currentIndex = 0; }
            else{ visibleCheck = false; }
        }
        onMovementStarted: {
            visibleCheck = true;
            saveCurrentIndex = listOptionMenu.currentIndex;
        }

        onUpKeyLongPressedIsTrue: idMOptionMenuTimer.stop();
        onUpKeyLongPressedIsFalse: idMOptionMenuTimer.restart();
        onDownKeyLongPressedIsTrue: idMOptionMenuTimer.stop();
        onDownKeyLongPressedIsFalse: idMOptionMenuTimer.restart();

        onVisibleChanged: {if(visible && (contentY != 0)) contentY = 0;}
    } // End ListView

    Connections{
        target: DABController
        onMenuEnableInitialized:{
            console.log("[QML] ==> Connections : MOptionMenuList.qml :: onMenuEnableInitialized ::   listOptionMenu.currentIndex : ", listOptionMenu.currentIndex);
            if( listOptionMenu.currentIndex == 2 || listOptionMenu.currentIndex == 3 || listOptionMenu.currentIndex == 4){
                listOptionMenu.currentIndex = 0
                idOptionMenuDelegate.focus = true;
            }
        }
    }

    //--------------------- ScrollBar #
    MScroll {
        x: iMenuScrollX
        y: iMenuScrollY
        height: 608
        width: 14
        visible: listOptionMenu.count > 8
        scrollArea: listOptionMenu
    } // End MScroll
} // End Item
