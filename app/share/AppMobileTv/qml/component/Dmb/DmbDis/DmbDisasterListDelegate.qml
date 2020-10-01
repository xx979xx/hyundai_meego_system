import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MButton {
    id: idDmbDisasterListDelegate
    width: (49*2)+firstTextWidth; height: 110
    buttonWidth: idDmbDisasterListDelegate.width; buttonHeight: idDmbDisasterListDelegate.height
    //focus: true                               //# focus:true delete - KEH (20130312)
    active: showFocus && idDmbDisasterListDelegate.activeFocus   //# active(selected) item - KEH (20130312)

    bgImagePress: imgFolderDmb+"tab_list_p.png"
    bgImageFocus: imgFolderDmb+"tab_list_f.png"

    //firstText: MDmbOperation.getAlarmPriority(AlarmPriority) + Qt.formatDateTime(EmergencyTime, "yyyy-MM-dd")
    firstText: MDmbOperation.getAlarmPriority(AlarmPriority) + "["+ Qt.formatDate(EmergencyTime, "yyyy-MM-dd")+"  "+ Qt.formatDateTime(EmergencyTime, "hh:mm")+"]["+EmergencyAreaText+"]"
    firstTextX: 49; firstTextY: 37
    firstTextWidth: 880
    firstTextSize: 32
    firstTextStyle: idAppMain.fontsR
    firstTextHorizontalAlies: "Left"
    firstTextColor: colorInfo.brightGrey
    firstTextElide: "Right"
    firstTextScrollEnable: ( (idDmbDisasterListDelegate.firstTextOverPaintedWidth == true) && (idDmbDisasterListDelegate.activeFocus == true)
                              && (idAppMain.drivingRestriction == false) ) ? true : false

    secondText: DisasterMessage
    secondTextX: 49; secondTextY: firstTextY + 44
    secondTextWidth: 880
    secondTextSize: 24
    secondTextStyle: idAppMain.fontsR
    secondTextHorizontalAlies: "Left"
    secondTextVerticalAlies: "Top"
    secondTextColor: colorInfo.dimmedGrey
    secondTextElide: "Right"
//    secondTextScrollSpacing: 150+120
    secondTextScrollEnable: ( (idDmbDisasterListDelegate.secondTextOverPaintedWidth == true) && (idDmbDisasterListDelegate.activeFocus == true)
                              && (idAppMain.drivingRestriction == false) ) ? true : false

    property string popupTitle : ""

    //--------------------- Line Image #
    Image{
        y: 111
        source: imgFolderMusic+"tab_list_line.png"
    }

    onWheelLeftKeyPressed: {
        if(idDmbDisasterListDelegate.ListView.view.count == 0) return;
        if(idDmbDisasterListDelegate.ListView.view.flicking || idDmbDisasterListDelegate.ListView.view.moving) return;

        if( idDmbDisasterListDelegate.ListView.view.currentIndex ){
            idDmbDisasterListDelegate.ListView.view.decrementCurrentIndex();
        }else{
            if(idDmbDisasterListDelegate.ListView.view.count>5){
                idDmbDisasterListDelegate.ListView.view.positionViewAtIndex(idDmbDisasterListDelegate.ListView.view.count-1, ListView.Visible);
                idDmbDisasterListDelegate.ListView.view.currentIndex = idDmbDisasterListDelegate.ListView.view.count-1;
            }else{
                return;
            }
        } // End if
    }

    onWheelRightKeyPressed: {
        if(idDmbDisasterListDelegate.ListView.view.count == 0) return;
        if(idDmbDisasterListDelegate.ListView.view.flicking || idDmbDisasterListDelegate.ListView.view.moving) return;

        if( idDmbDisasterListDelegate.ListView.view.count-1 != idDmbDisasterListDelegate.ListView.view.currentIndex ){
            idDmbDisasterListDelegate.ListView.view.incrementCurrentIndex();
        }else{
             if(idDmbDisasterListDelegate.ListView.view.count>5){
                 idDmbDisasterListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                 idDmbDisasterListDelegate.ListView.view.currentIndex = 0;
             }else{
                 return;
             }
        } // End if
    }

    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            //        console.debug("[QML] DmbDisasterListDelegate:: onClickOrKeySelected ")

            if(EngineListener.getDRSShowStatus() == false)
            {
                idDmbDisasterListDelegate.ListView.view.currentIndex = index
                idDmbDisasterListDelegate.ListView.view.focus = true
                idDmbDisasterListDelegate.ListView.view.forceActiveFocus()
                setAppMainScreen("PopupDisasterInfomation", true)

                popupTitle =
                        //                EmergencyType + "\n" +
                        MDmbOperation.getAlarmPriority(AlarmPriority)+"\n" +
                        //                EmergencyArea+"\n" +
                        "["+Qt.formatDate(EmergencyTime, "yyyy-MM-dd")+"  "+ Qt.formatTime(EmergencyTime, "hh:mm")+"]"

                showDisasterMessage(popupTitle, DisasterMessage);
                //        showDisasterMessage(Qt.formatDateTime(EmergencyTime, CommParser.m_sTimeDateFormat), DisasterMessage);

                idDmbDisasterListDelegate.ListView.view.positionViewAtIndex (disInfoView.currentIndex, ListView.Center)
            }
            else
            {
                EngineListener.selectDiasterListPopup(index, disInfoView.currentIndex, AlarmPriority, EmergencyTime, DisasterMessage, EmergencyAreaText);
            }
        }
    }

    onClickReleased: {
        if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
    }

    Keys.onUpPressed: {
        event.accepted = true;
    }

    Keys.onDownPressed: {
        event.accepted = true;
    }

    onUpKeyReleased: {
        if(idAppMain.upKeyReleased == true)
        {
            idDmbDisasterBand.focus = true;
            idDmbDisasterListDelegate.state="keyRelease"
        }
        idAppMain.upKeyReleased = false;
    }

    Connections{
        target: CommParser
        onTimeDateFormatChanged:{
            firstText = MDmbOperation.getAlarmPriority(AlarmPriority) + "["+ Qt.formatDate(EmergencyTime, "yyyy-MM-dd") +"  "+ Qt.formatDateTime(EmergencyTime, "hh:mm")+"]"
        }
    }
}

