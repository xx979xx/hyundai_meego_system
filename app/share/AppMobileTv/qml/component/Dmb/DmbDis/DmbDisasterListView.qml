import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation


MComp.MComponent {
    id: idDmbDisasterList
    width: parent.width
    height: parent.height

    property QtObject disInfoView : idListDmbDisaster

    property bool focusChange : false;

    ListView{
        id: idListDmbDisaster
        opacity : 1
        width: parent.width
        height: systemInfo.contentAreaHeigh
        clip: true
        focus: true
        anchors.fill: idDmbDisasterList;
        model: DmbDisasterModel
        delegate: DmbDisasterListDelegate {}
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        snapMode: ListView.SnapToItem

        property bool disUpKeyLongPressed : EngineListener.m_bJogUpkeyLongPressed/*idAppMain.upKeyLongPressed*/;
        property bool disDownKeyLongPressed : EngineListener.m_bJogDownkeyLongPressed/*idAppMain.downKeyLongPressed*/;

        onDisUpKeyLongPressedChanged:{
            //console.debug(" WSH # [QML] =====>> idAppMain.state: " + idAppMain.state)
            //console.debug(" WSH 3 [QML] =====>> idListDmbDisaster.focus: " + idListDmbDisaster.focus+", idDmbDisasterBand.focus: "+idDmbDisasterBand.focus+", idDmbDisasterTabView.foucs: "+idDmbDisasterTabView.focus)
            if(idAppMain.state != "AppDmbDisaterList" || idListDmbDisaster.focus == false) return;
            if(idDmbDisasterBand.focus == true || idDmbDisasterTabView.focus == true) return;

//            if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();

            if(upKeyLongPressed){
//                if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
//                console.debug(" [QML] =====>> onUpKeyLongPressedChanged: " + idListDmbDisaster.currentIndex)
                idUpLongKeyTimer.start()
            }
            else{

                idUpLongKeyTimer.stop()
            }
        }

        onDisDownKeyLongPressedChanged:{
            //console.debug(" WSH # [QML] =====>> idAppMain.state: " + idAppMain.state)
            //console.debug(" WSH 4 [QML] =====>> idListDmbDisaster.focus: " + idListDmbDisaster.focus+", idDmbDisasterBand.focus: "+idDmbDisasterBand.focus+", idDmbDisasterTabView.foucs: "+idDmbDisasterTabView.focus)
            if(idAppMain.state != "AppDmbDisaterList" || idListDmbDisaster.focus == false) return;
            if(idDmbDisasterBand.focus == true || idDmbDisasterTabView.focus == true) return;

//            if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();

            if(downKeyLongPressed){
//                if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
//                console.debug(" [QML] =====>> onDownKeyLongPressedChanged: " + idListDmbDisaster.currentIndex)
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
                if(idListDmbDisaster.currentIndex != 0)
                   idListDmbDisaster.decrementCurrentIndex()
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
                if(idListDmbDisaster.currentIndex != idListDmbDisaster.count-1)
                    idListDmbDisaster.incrementCurrentIndex()
            }
            triggeredOnStart: true
        }

        onCurrentIndexChanged: {
            if(idAppMain.state == "AppDmbDisaterList")
                EngineListener.setDisasterListIndex(idListDmbDisaster.currentIndex);

        }

        onCountChanged: {
            idListDmbDisaster.currentIndex = 0;
            idListDmbDisaster.positionViewAtIndex (idListDmbDisaster.currentIndex, ListView.Beginning);
            disasterListCountChanged(count)
        }

        onMovementEnded:{
            var startIndex = idListDmbDisaster.indexAt( contentX, (contentY + (idListDmbDisaster.currentItem.height/2) + 10) );
            if(startIndex==-1)return;
            var endIndex = startIndex+4;

            if( !(idListDmbDisaster.currentIndex>=startIndex && idListDmbDisaster.currentIndex<=endIndex) ){
//                console.log("bongzi[QML] MOVE!!!!!")
                idListDmbDisaster.currentIndex = startIndex;
            }
//            else{
//                console.log("bongzi[QML] NO MOVE!!!!!")
//            }
            if( idDmbDisasterList.focus == false ){
                idDmbDisasterList.focusChange = true;
                idDmbDisasterList.focus = true;
            }
        }

        Connections{
            target:EngineListener

            onSetSorttDisasterMenu:{

                if(idListDmbDisaster.count > 0)
                {
                    idListDmbDisaster.currentIndex = 0;
                    idListDmbDisaster.focus = true
                    idListDmbDisaster.forceActiveFocus()
                    idListDmbDisaster.positionViewAtIndex (idListDmbDisaster.currentIndex, ListView.Beginning)
                }
            }

            onSetSyncDisasterListIndex:{
                if(idAppMain.state == "AppDmbDisaterList" && idListDmbDisaster.currentIndex != disasterListIndexSync){
                    idListDmbDisaster.currentIndex = disasterListIndexSync;
                }
            }

            onSendDrsShowHide:{
                if(idAppMain.state == "AppDmbDisaterList"){
                    idListDmbDisaster.currentIndex = EngineListener.getDisasterListIndex();
                }
            }

            onSetDiasterListPopup:{

                var popupTitle;
                var popupPriority;
                var popupMessage;
                var popupId;

                idListDmbDisaster.currentIndex = signal_index
                idListDmbDisaster.focus = true
                idListDmbDisaster.forceActiveFocus()

                setAppMainScreen("PopupDisasterInfomation", true)

//                popupTitle =
//                        //                EmergencyType + "\n" +
//                        MDmbOperation.getAlarmPriority(signal_AlarmPriority)+"\n" +
//                        //                EmergencyArea+"\n" +
//                        "["+Qt.formatDate(signal_EmergencyTime, "yyyy-MM-dd")+"  "+ Qt.formatDateTime(signal_EmergencyTime, "hh:mm")+"]\n"+"["+signal_AreaText+"]"

                popupPriority = signal_AlarmPriority;
                popupTitle = "["+Qt.formatDate(signal_EmergencyTime, "yyyy-MM-dd")+"  "+ Qt.formatDateTime(signal_EmergencyTime, "hh:mm")+"]\n"+"["+signal_AreaText+"]";
                popupMessage = signal_DisasterMessage;
                popupId = signal_AreaText + signal_DisasterMessage;

//                showDisasterMessage(popupTitle, signal_DisasterMessage);
                idAppMain.showDisasterMessage(popupPriority, popupTitle, popupMessage, popupId);
                //        showDisasterMessage(Qt.formatDateTime(EmergencyTime, CommParser.m_sTimeDateFormat), DisasterMessage);

                //idListDmbDisaster.positionViewAtIndex (signal_infoviewCurrentIndex, ListView.Center)

            }
        }
    }

    onActiveFocusChanged: {
        if(idDmbDisasterList.activeFocus == true)
            idDmbDisasterMain.disasterMainLastFocusId = "idDmbDisasterList";

        if(idListDmbDisaster.activeFocus == true){
            if(idDmbDisasterList.focusChange == false){
                //idListDmbDisaster.positionViewAtIndex(idListDmbDisaster.currentIndex, ListView.Center);
            }else
                idDmbDisasterList.focusChange = false;
        }
    }

    //--------------------- ScrollBar #
    MComp.MScroll {
        property int  scrollWidth: 13
        property int scrollHeight: 522
        y: 181-systemInfo.headlineHeight; z:1
        scrollArea: idListDmbDisaster;
        height: scrollHeight; width: scrollWidth
        selectedScrollImage: imgFolderGeneral+"scroll_edit_bg.png"
        anchors.right: idListDmbDisaster.right
        visible: idListDmbDisaster.count > 5
    } //# End MScroll

} // End FocusScope
