import QtQuick 1.0

GridView{
    id: idMGridView

    property bool upKeyLongPressed : idAppMain.upKeyLongPressed;
    property bool downKeyLongPressed : idAppMain.downKeyLongPressed;

    onUpKeyLongPressedChanged:{
        if(!activeFocus) return;
        if(idMGridView.focus == false) return;

        if(upKeyLongPressed){
            idPresetTimer.stop();
            idUpLongKeyTimer.running = true
        }
        else{
            idPresetTimer.restart();
            idUpLongKeyTimer.running = false
        }
    }

    onDownKeyLongPressedChanged:{
        if(!activeFocus) return;
        if(idMGridView.focus == false) return;

        if(downKeyLongPressed){
            idPresetTimer.stop();
            idDownLongKeyTimer.running = true
        }
        else{
            idPresetTimer.restart();
            idDownLongKeyTimer.running = false
        }
    }

    Timer {
        id: idUpLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {            
            idMGridView.moveCurrentIndexUp();
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
             idMGridView.moveCurrentIndexDown();
        }
        triggeredOnStart: true
    }
    onVisibleChanged: {
        if(!visible) {
            idUpLongKeyTimer.stop();
            idDownLongKeyTimer.stop();
            idAppMain.upKeyLongPressed = false;
            idAppMain.downKeyLongPressed = false;
        }
    }
}
