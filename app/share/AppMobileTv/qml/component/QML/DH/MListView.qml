import QtQuick 1.0

ListView{
    id: idMListView

    property bool upKeyLongPressed : EngineListener.m_bJogUpkeyLongPressed/*idAppMain.upKeyLongPressed*/;
    property bool downKeyLongPressed : EngineListener.m_bJogDownkeyLongPressed/*idAppMain.downKeyLongPressed*/;
    property int flickingStartContentY: 0
    onUpKeyLongPressedChanged:{
        if(idAppMain.state != "AppDmbPlayer" || idMListView.focus == false) return;
        if(idAppMain.state == "AppDmbPlayerOptionMenu" || idAppMain.isDragItemSelect == true ||/*idAppMain.presetEditEnabled == true || */idDmbPlayerBand.focus == true || CommParser.m_bIsFullScreen == true) return;

        if(EngineListener.m_bOptionMenuOpen == true)
        {
            return;
        }

//        if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();

        if(upKeyLongPressed){
//            console.debug("-----------[luna] onUpKeyLongPressedChanged: " + idMListView.currentIndex)
//            if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
            idUpLongKeyTimer.start()
            if(idLongKeyTimer.running == true)
                idLongKeyTimer.stop();
        }
        else{
            idAppMain.isPopUpShow == false;
            idUpLongKeyTimer.stop()
            if(idAppMain.presetEditEnabled == false)
            {
                idLongKeyTimer.start();
            }
        }
    }

    onDownKeyLongPressedChanged:{
        if(idAppMain.state != "AppDmbPlayer" || idMListView.focus == false) return;
        if(idAppMain.state == "AppDmbPlayerOptionMenu" || idAppMain.isDragItemSelect == true ||/*idAppMain.presetEditEnabled == true || */idDmbPlayerBand.focus == true || CommParser.m_bIsFullScreen == true) return;

        if(EngineListener.m_bOptionMenuOpen == true)
        {
            return;
        }
//        if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();

        if(downKeyLongPressed){
//            console.debug("-----------[luna] onDownKeyLongPressedChanged: " + idMListView.currentIndex)
//            if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
            idDownLongKeyTimer.start()
            if(idLongKeyTimer.running == true)
                idLongKeyTimer.stop();

        }
        else{
            idAppMain.isPopUpShow == false;
            idDownLongKeyTimer.stop()
            if(idAppMain.presetEditEnabled == false)
            {
                idLongKeyTimer.start();
            }
        }
    }

    onMovementEnded: {
        if(idAppMain.isENGMode == true && CommParser.m_iPresetListIndex < 0) return;
//console.debug("-----------[JSY] onMovementEnded: " + idMListView.contentY)
        flickStartTimer.restart();
        idAppMain.isOnclickedByTouch = true;
    }

    onMovementStarted: {
//        console.debug("-----------[JSY] onMovementStarted: " + idMListView.contentY)
        //if(flickStartTimer.running == false)
        {
            flickingStartContentY = idMListView.contentY;
        }
    }

    Timer{
           id: flickStartTimer
           interval: 5000; running: true; repeat: false
           onTriggered:{
//               console.debug("-----------[JSY] onTriggered: flickingStartContentY="+ flickingStartContentY + "  idMListView.contentY=" + idMListView.contentY)
               if(idMListView.flicking || idMListView.moving)   return;
               if(idMListView.currentItem.isDragItem == true || idAppMain.isOnclickedByTouch == false)
               {
                   return;
               }
               idAppMain.isOnclickedByTouch = false;

               var startIndex = idMListView.indexAt( contentX + 10, (idMListView.contentY + 10) );
               if(startIndex==-1)return;
               var endIndex = startIndex+5;

               if( idMListView.currentIndex<startIndex || idMListView.currentIndex>endIndex ){
                   var tempIndex = idMListView.indexAt( contentX + 10, (flickingStartContentY+ 10) );

                   if(tempIndex < idMListView.currentIndex-5 || tempIndex > idMListView.currentIndex){
                       idAppMain.dmbListPageInit(idMListView.currentIndex);
                   }else{
                       idMListView.contentY = flickingStartContentY;
                   }
               }

//               idAppMain.dmbListPageInit(idMListView.currentIndex)
           }
    }

/* remove 2012-12-07
    Keys.onUpPressed:{
        if(event.modifiers == Qt.ShiftModifier){
            console.debug("-----------[luna] onUpLongPressed: " + idMListView.currentIndex)
            idUpLongKeyTimer.start()
        }
        else{
            event.accepted = false
        }
    }
    Keys.onDownPressed:{
        if(event.modifiers == Qt.ShiftModifier){
            console.debug("-----------[luna] onDownLongPressed: " + idMListView.currentIndex)
            idDownLongKeyTimer.start()
        }
        else{
            event.accepted = false
        }
    }
    Keys.onReleased:{
        if(idUpLongKeyTimer.running == true) idUpLongKeyTimer.stop()
        if(idDownLongKeyTimer.running == true) idDownLongKeyTimer.stop()
    }
*/
    Timer {
        id: idUpLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            //if(idMListView.currentIndex == 0)
            //    idMListView.currentIndex = idPresetChList.count - 1;
            //else
            //idMListView.decrementCurrentIndex()

             if(idMListView.currentIndex != 0)
                idMListView.currentIndex--;
        }
        triggeredOnStart: true
    }
    Timer {
        id: idDownLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            //if(idMListView.currentIndex == idPresetChList.count-1)
            //    idMListView.currentIndex = 0
            //else
            //idMListView.incrementCurrentIndex()

             if(idMListView.currentIndex != idPresetChList.count-1)
                idMListView.currentIndex++;
        }
        triggeredOnStart: true
    }

    Timer{
        id : idLongKeyTimer
        interval: 500
        repeat: false;

        onTriggered:{
            finishLongKeyTimer();
        }

        function finishLongKeyTimer()
        {
            if(idMListView.currentIndex != CommParser.m_iPresetListIndex )
            {
                CommParser.onChannelSelectedByIndex(idMListView.currentIndex, false, false);
            }
            idLongKeyTimer.stop();
//            console.debug("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! idLongKeyTimer finishTimer()")
        }
    }

    Connections{
        //target: idDmbPlayerMain
        target: idAppMain
        onSignalKeyTimerOff: {
            if(idUpLongKeyTimer.running == true)
            {
                idUpLongKeyTimer.stop()
            }
            if(idDownLongKeyTimer.running == true)
            {
                idDownLongKeyTimer.stop()
            }
            if(idLongKeyTimer.running == true)
            {
                idLongKeyTimer.stop()
            }
        }
    }

}
