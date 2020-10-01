import QtQuick 1.0

ListView{
    id: idMListView

    property bool upKeyLongPressed : idAppMain.upKeyLongPressed;
    property bool downKeyLongPressed : idAppMain.downKeyLongPressed;
    property int criticalPoint : currentItem.height - 5;

    signal upKeyLongPressedIsTrue();
    signal upKeyLongPressedIsFalse();
    signal downKeyLongPressedIsTrue();
    signal downKeyLongPressedIsFalse();
    signal upKeyLongRunning();
    signal downKeyLongRunning();

    onUpKeyLongPressedChanged:{
        if(!activeFocus){ return; }
        if(idMListView.focus == false){ return; }

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
            // idMListView.decrementCurrentIndex()
            if( idMListView.currentIndex ){
                for(var i=idMListView.currentIndex-1; idMListView.currentIndex >= 0 ;i--){
                    idMListView.currentIndex = i
                    if(!idMListView.currentItem.mEnabled)
                        continue;
                    else
                    break;
                }
                upKeyLongRunning();
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
            // idMListView.incrementCurrentIndex()
            if( idMListView.count-1 != idMListView.currentIndex ){
                for(var i=idMListView.currentIndex+1; idMListView.count > i ;i++){
                    idMListView.currentIndex = i
                    if(!idMListView.currentItem.mEnabled)
                        continue;
                    else
                    break;
                }
                downKeyLongRunning()
            }
        }
        triggeredOnStart: true
    }

    //Focus move as auto when flick scrolling
    onMovementEnded: {
            var point = mapFromItem(currentItem, 0, 0);
            if(point.y + criticalPoint < 0 || point.y + criticalPoint > idMListView.height)
                currentIndex = indexAt(300, contentY + criticalPoint);
    }

    //# End item check of ListView
    function getEndIndex(posY) {
        var endIndex = -1;
        for(var i = 0; i < 5; i++) {
            endIndex = indexAt(100, posY + (height - 10) - 50 * i);
            if(-1 < endIndex) {  return endIndex }
        }
        return -1;
    }
    //# Start item check of ListView
    function getStartIndex(posY) {
        var startIndex = -1;
        for(var i = 1; i < 10; i++) {
            startIndex = indexAt(100, posY + 50 * i);
            if(-1 < startIndex) { return startIndex }
        }
        return -1;
    }
}
