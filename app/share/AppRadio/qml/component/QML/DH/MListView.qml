import QtQuick 1.0

ListView{
    id: idMListView

    property bool upKeyLongPressed : idAppMain.upKeyLongPressed;
    property bool downKeyLongPressed : idAppMain.downKeyLongPressed;

    signal upKeyLongPressedIsTrue();
    signal upKeyLongPressedIsFalse();
    signal downKeyLongPressedIsTrue();
    signal downKeyLongPressedIsFalse();

    onUpKeyLongPressedChanged:{
        if(!activeFocus) return;
        if(idMListView.focus == false) return;

        //if(firstSignalCheck() == true && playBeepOn && upKeyLongPressed){
        //    UIListener.playAudioBeep();
        //}

        if(upKeyLongPressed){
            console.debug("-----------[luna] onUpKeyLongPressedChanged: " + idMListView.currentIndex)
            idUpLongKeyTimer.running = true
            upKeyLongPressedIsTrue();
        }
        else{
            idUpLongKeyTimer.running = false
            upKeyLongPressedIsFalse();
        }
    }

    onDownKeyLongPressedChanged:{
        if(!activeFocus) return;
        if(idMListView.focus == false) return;

        //if(firstSignalCheck() == true && playBeepOn && downKeyLongPressed){
        //    UIListener.playAudioBeep();
        //}

        if(downKeyLongPressed){
            console.debug("-----------[luna] onDownKeyLongPressedChanged: " + idMListView.currentIndex)
            idDownLongKeyTimer.running = true
            downKeyLongPressedIsTrue();
        }
        else{
            idDownLongKeyTimer.running = false
            downKeyLongPressedIsFalse();
        }
    }

    Timer {
        id: idUpLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            // JSH 130911 modufy
            //idMListView.decrementCurrentIndex()
            if( idMListView.currentIndex ){
                for(var i=idMListView.currentIndex-1; idMListView.currentIndex >= 0 ;i--){
                    idMListView.currentIndex = i
                    if(!idMListView.currentItem.mEnabled)
                        continue;
                    else
                    break;
                }
            }
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
            // JSH 130911 modufy
            //idMListView.incrementCurrentIndex()
            if( idMListView.count-1 != idMListView.currentIndex ){
                for(var i=idMListView.currentIndex+1; idMListView.count > i ;i++){
                    idMListView.currentIndex = i
                    if(!idMListView.currentItem.mEnabled)
                        continue;
                    else
                        break;
                }
            }
        }
        triggeredOnStart: true
    }
    onVisibleChanged: {
        if(!visible) {
            idUpLongKeyTimer.stop();
            idDownLongKeyTimer.stop();
            idAppMain.upKeyLongPressed = false;
            idAppMain.downKeyLongPressed = false;
            idAppMain.downKeyLongPressedVisualCueFocus = false    //dg.jin 140530 Down Key Long Pressed VisualCueFocus
        }
    }
}
