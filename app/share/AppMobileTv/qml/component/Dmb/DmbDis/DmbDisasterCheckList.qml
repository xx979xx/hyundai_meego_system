import Qt 4.7
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idDmbDisasterCheckList
    width: parent.width
    height: parent.height
    focus: true

    property QtObject disCheckView : idListDmbModeCk

    property bool focusChange : false;

    ListView{
        id: idListDmbModeCk
        opacity : 1
        clip: true
        focus: true
        anchors.fill: idDmbDisasterCheckList;
        model: DmbDisasterModel
        delegate: DmbDisasterCheckDelegate {}
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        snapMode: ListView.SnapToItem
        cacheBuffer: 99999

        property bool disCheckUpKeyLongPressed : EngineListener.m_bJogUpkeyLongPressed/*idAppMain.upKeyLongPressed*/;
        property bool disCheckDownKeyLongPressed : EngineListener.m_bJogDownkeyLongPressed/*idAppMain.downKeyLongPressed*/;

        onDisCheckUpKeyLongPressedChanged:{
            if(idAppMain.state != "AppDmbDisaterListEdit" || idListDmbModeCk.focus == false) return;
            if(idDmbDisasterEditBand.focus == true || idDisasterEditMode.focus == true) return;

            if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();

            if(upKeyLongPressed){
//                console.debug(" [QML] =====>> onUpKeyLongPressedChanged: " + idListDmbModeCk.currentIndex)
                idUpLongKeyTimer.start()
            }
            else{
                idUpLongKeyTimer.stop()
            }
        }

        onDisCheckDownKeyLongPressedChanged:{
            if(idAppMain.state != "AppDmbDisaterListEdit" || idListDmbModeCk.focus == false) return;
            if(idDmbDisasterEditBand.focus == true || idDisasterEditMode.focus == true) return;

            if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();

            if(downKeyLongPressed){
//                console.debug(" [QML] =====>> onDownKeyLongPressedChanged: " + idListDmbModeCk.currentIndex)
                idDownLongKeyTimer.start()
            }
            else{
                idDownLongKeyTimer.stop()
            }
        }

        Timer {
            id: idUpLongKeyTimer
            interval: 100
            repeat: true
            running: false
            onTriggered:
            {
                 if(idListDmbModeCk.currentIndex != 0)
                    idListDmbModeCk.decrementCurrentIndex()
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
                 if(idListDmbModeCk.currentIndex != idListDmbModeCk.count-1)
                    idListDmbModeCk.incrementCurrentIndex()
            }
            triggeredOnStart: true
        }

        onCurrentIndexChanged: {
            if(idAppMain.state == "AppDmbDisaterListEdit")
                EngineListener.setDisasterListIndex(idListDmbModeCk.currentIndex);
        }

        onMovementEnded:{
            var startIndex = idListDmbModeCk.indexAt( idListDmbModeCk.currentItem.x + 10, (contentY + (idListDmbModeCk.currentItem.height/2) + 10) );
            if(startIndex==-1)return;
            var endIndex = startIndex+4;
            if( !(idListDmbModeCk.currentIndex>=startIndex && idListDmbModeCk.currentIndex<=endIndex) ){
                idListDmbModeCk.currentIndex = startIndex;
            }
            if( idDmbDisasterCheckList.focus == false ){
                idDmbDisasterCheckList.focusChange = true;
                idDmbDisasterCheckList.focus = true;
            }
        }

    }

    onActiveFocusChanged: {
        if(idDmbDisasterCheckList.activeFocus == true)
            idDmbDisasterEdit.disasterEditLastFocusId = "idDmbDisasterCheckList";

        if(idListDmbModeCk.activeFocus == true){
            if(idDmbDisasterCheckList.focusChange == false){
                //idListDmbModeCk.positionViewAtIndex(idListDmbModeCk.currentIndex, ListView.Center);
            }else
                idDmbDisasterCheckList.focusChange = false;
        }
    }

    Connections{
        target:EngineListener
        onSetSyncDisasterListIndex:{
            if(idAppMain.state == "AppDmbDisaterListEdit" && idListDmbModeCk.currentIndex != disasterListIndexSync){
                idListDmbModeCk.currentIndex = disasterListIndexSync;
            }
        }

        onSendDrsShowHide:{
            if(idAppMain.state == "AppDmbDisaterListEdit"){
                idListDmbModeCk.currentIndex = EngineListener.getDisasterListIndex();
            }
        }
    }

    //--------------------- ScrollBar #
    MComp.MScroll {
        property int scrollWidth: 14
        property int scrollHeight: 523
        y: 181-systemInfo.headlineHeight; z:1
        scrollArea: idListDmbModeCk;
        height: scrollHeight; width: scrollWidth
        selectedScrollImage: imgFolderGeneral+"scroll_edit_bg.png"
        anchors.left: idListDmbModeCk.right
        visible: idListDmbModeCk.count > 5
    } //# End MScroll

} // End MComponent
