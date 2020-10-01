/**
 * FileName: MOptionMenuList.qml
 * Author: WSH
 * Time: 2012-02-08
 *
 * - 2012-02-08 Initial Crated by WSH
 * - 2012-12-27 Applied positionViewAtIndex by WSH
 */
import QtQuick 1.0

//--------------------- OptionMenu ListView #
Item{

    id: idMOptionMenuList
    property bool optionMenuUpKeyLongPressed : /*EngineListener.m_bJogUpkeyLongPressed*/idAppMain.upKeyLongPressed;
    property bool optionMenuDownKeyLongPressed : /*EngineListener.m_bJogDownkeyLongPressed*/idAppMain.downKeyLongPressed;

    ListView {
        id: listOptionMenu
        width: delegateWidth
        height: systemInfo.subMainHeight
        opacity : 1
        focus: true
        anchors.fill: parent;
        model: linkedModels
        delegate: linkedDelegate
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        cacheBuffer: 8
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.DragAndOvershootBounds
        clip: true;
        currentIndex: idMOptionMenu.linkedCurrentIndex
        onCurrentIndexChanged:linkedCurrentItem = listOptionMenu.currentItem
//        onMovementEnded: {
//            idMOptionMenuTimer.restart();
//            if(mouseX - startX > 100) {
//                idMOptionMenu.hideOptionMenu();
//            }
//        }

        Component.onCompleted: {
            listOptionMenu.currentIndex = 0
        }

        onVisibleChanged: {
            if(visible == true){
                listOptionMenu.currentIndex = 0
                if(contentY != 0)
                {
                    contentY = 0;
                }
            }
        }
    } // End ListView

    onOptionMenuUpKeyLongPressedChanged:{
        if(idAppMain.state == "AppDmbPlayerOptionMenu")
        {
//            if( EngineListener.m_bOptionMenuOpen == false ) return;

//            if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();

            if(optionMenuUpKeyLongPressed){
                idMOptionMenuTimer.stop();
                idUpLongKeyOptionMenuTimer.start()
            }
            else{
                EngineListener.m_bOptionMenuOpen = false;
                idUpLongKeyOptionMenuTimer.stop()
                idMOptionMenuTimer.restart();
            }
        }
    }

    onOptionMenuDownKeyLongPressedChanged:{
        if(idAppMain.state == "AppDmbPlayerOptionMenu")
        {
//            if( EngineListener.m_bOptionMenuOpen == false ) return;

//            if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();

            if(optionMenuDownKeyLongPressed){
                idMOptionMenuTimer.stop();
                idDownLongKeyOptionMenuTimer.start()
            }
            else{
                EngineListener.m_bOptionMenuOpen = false;
                idDownLongKeyOptionMenuTimer.stop()
                idMOptionMenuTimer.restart();
            }
        }
    }

    Timer {
        id: idUpLongKeyOptionMenuTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            if( listOptionMenu.currentIndex ){
                for(var i=listOptionMenu.currentIndex-1; listOptionMenu.currentIndex >= 0 ;i--){
                    listOptionMenu.currentIndex = i
                    if(!listOptionMenu.currentItem.mEnabled)
                        continue;
                    else
                    break;
                }
            }

        }
        triggeredOnStart: true
    }

    Timer {
        id: idDownLongKeyOptionMenuTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            if( listOptionMenu.count-1 != listOptionMenu.currentIndex ){
                for(var i=listOptionMenu.currentIndex+1; listOptionMenu.count > i ;i++){
                    listOptionMenu.currentIndex = i
                    if(!listOptionMenu.currentItem.mEnabled)
                        continue;
                    else
                        break;
                }
            }
        }
        triggeredOnStart: true
    }

    //--------------------- ScrollBar #
    MScroll {
        //x:parent.x+parent.width-opScrollWidth; y:listOptionMenu.y+opScrollY; z:1
        scrollArea: listOptionMenu;
        height: opScrollHeight; width: opScrollWidth
        anchors.right: listOptionMenu.right
        anchors.verticalCenter: parent.verticalCenter
        visible: listOptionMenu.count > 8
    } // End MScroll

    Connections{
        target: EngineListener

        onModeDRSChanged:
        {
            if(EngineListener.m_DRSmode && EngineListener.IsShowDRSMode(UIListener.getCurrentScreen()))
            {

                if( (idAppMain.state == "AppDmbPlayerOptionMenu") && (listOptionMenu.currentIndex == 4) )
                {
                    listOptionMenu.currentIndex  = 0
                    idMOptionMenuTimer.start();
                }
            }
        }
    }
} // End Item
