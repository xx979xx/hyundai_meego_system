import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MButton {
    id: idDmbDisasterCheckDelegate
    x: 14
    width: 992; height: 110
    buttonWidth: idDmbDisasterCheckDelegate.width; buttonHeight: idDmbDisasterCheckDelegate.height
    //focus: true                               //# focus:true delete - KEH (20130312)
    active: showFocus && idDmbDisasterCheckDelegate.activeFocus   //# active(selected) item - KEH (20130312)

    bgImagePress: imgFolderGeneral+"edit_list_02_p.png"
    bgImageFocus: imgFolderGeneral+"edit_list_02_f.png"

    //firstText: MDmbOperation.getAlarmPriority(AlarmPriority) + Qt.formatDateTime(EmergencyTime, "yyyy-MM-dd")
    firstText: MDmbOperation.getAlarmPriority(AlarmPriority) + "["+ Qt.formatDate(EmergencyTime, "yyyy-MM-dd")+"  "+ Qt.formatDateTime(EmergencyTime, "hh:mm")+"]["+EmergencyAreaText+"]"
    firstTextX: 101-parent.x; firstTextY: 110-(44+29)
    firstTextWidth: 829 //939-(firstTextX*2)
    firstTextSize: 32
    firstTextStyle: idAppMain.fontsR
    firstTextHorizontalAlies: "Left"
    firstTextColor: colorInfo.brightGrey
    firstTextElide: "Right"
    firstTextScrollEnable: ( (idDmbDisasterCheckDelegate.firstTextOverPaintedWidth == true) && (idDmbDisasterCheckDelegate.activeFocus == true)
                              && (idAppMain.drivingRestriction == false) ) ? true : false

    secondText: DisasterMessage
    secondTextX: firstTextX; secondTextY: 110-29
    secondTextWidth: firstTextWidth
    secondTextSize: 24
    secondTextStyle: idAppMain.fontsR
    secondTextHorizontalAlies: "Left"
    secondTextVerticalAlies: "Top"
    secondTextColor: colorInfo.dimmedGrey
    secondTextElide: "Right"
//    secondTextScrollSpacing: 150+120
    secondTextScrollEnable: ( (idDmbDisasterCheckDelegate.secondTextOverPaintedWidth == true) && (idDmbDisasterCheckDelegate.activeFocus == true)
                              && (idAppMain.drivingRestriction == false) ) ? true : false

    property bool backupcheckstate : false;

    //--------------------- CheckBox Image of List #
//    MComp.MCheckBox{
//        id: idDmbDisasterCkList
//        x: 939;
//        state: (check==true)?"on":"off"
//        anchors.verticalCenter: parent.verticalCenter
//    } // End MComp.CheckBox

    //-------------------- View the background
    Item {
        id: idCheckBoxImage
        x: 939;
        anchors.verticalCenter: parent.verticalCenter
        width: background.width;
        height: background.height
        property bool checkstate : false;
        Image {
            id: background
            source: imgFolderGeneral+"checkbox_uncheck.png"
        }
        //-------------------- View the check
        Image {
            id: idcheck
            source: imgFolderGeneral+"checkbox_check.png"
            visible: (idCheckBoxImage.checkstate == true)? true : false

            Component.onCompleted: {
//                console.debug("[QML] DmbDisasterCheckDelegate:: onCompleted:  visible= "+ visible + " checkstate = "+ idCheckBoxImage.checkstate + " check="+ check + " index="+ index)
                if(check == true)
                {
                    idCheckBoxImage.checkstate = true;
                }
            }
        }
    }

    //--------------------- Line Image #
    Image{
        y: 111
        source: imgFolderGeneral+"edit_list_line.png"
    }

    onWheelLeftKeyPressed: {
        if(idDmbDisasterCheckDelegate.ListView.view.count == 0) return;
        if(idDmbDisasterCheckDelegate.ListView.view.flicking || idDmbDisasterCheckDelegate.ListView.view.moving) return;

        if( idDmbDisasterCheckDelegate.ListView.view.currentIndex ){
            idDmbDisasterCheckDelegate.ListView.view.decrementCurrentIndex();
        }else{
            if(idDmbDisasterCheckDelegate.ListView.view.count>5){
                idDmbDisasterCheckDelegate.ListView.view.positionViewAtIndex(idDmbDisasterCheckDelegate.ListView.view.count-1, ListView.Visible);
                idDmbDisasterCheckDelegate.ListView.view.currentIndex = idDmbDisasterCheckDelegate.ListView.view.count-1;
            }else{
                return;
            }
        } // End if
    }

    onWheelRightKeyPressed: {
        if(idDmbDisasterCheckDelegate.ListView.view.count == 0) return;
        if(idDmbDisasterCheckDelegate.ListView.view.flicking || idDmbDisasterCheckDelegate.ListView.view.moving) return;

        if( idDmbDisasterCheckDelegate.ListView.view.count-1 != idDmbDisasterCheckDelegate.ListView.view.currentIndex ){
            idDmbDisasterCheckDelegate.ListView.view.incrementCurrentIndex();
        }else{
            if(idDmbDisasterCheckDelegate.ListView.view.count>5){
                idDmbDisasterCheckDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                idDmbDisasterCheckDelegate.ListView.view.currentIndex = 0;
            }else{
                return;
            }
        } // End if
    }

    onClickOrKeySelected:{
        if(pressAndHoldFlag == false){

//            idDmbDisasterCheckDelegate.ListView.view.currentIndex = index
//            console.debug("[QML] DmbDisasterCheckDelegate:: onClickOrKeySelected:  index= "+ index+" check="+ check)

            var ewsMessageId = EmergencyAreaText + DisasterMessage;

            if(idCheckBoxImage.checkstate == true)
            {
                //MDmbOperation.CmdReqAMASMessageUnselete(secondText)
                MDmbOperation.CmdReqAMASMessageUnselete(ewsMessageId)
            }
            else
            {
                //MDmbOperation.CmdReqAMASMessageSelete(secondText)
                MDmbOperation.CmdReqAMASMessageSelete(ewsMessageId)
            }

            EngineListener.selectDisasterListChekbox(index);
//            //console.debug("[QML] DmbDisasterCheckDelegate:: onClickOrKeySelected ")
//            idDmbDisasterCheckDelegate.ListView.view.currentIndex = index
//            if(idDmbDisasterCkList.state==="on") {
//                idDmbDisasterCkList.state="off"
//                MDmbOperation.CmdReqAMASMessageUnselete(secondText)

//                //# Focus position as DeleteAllButton - KEH (20130305)
//                if(CommParser.m_bIsAMASUnseleteAll){ idDisasterEditMode.focusPosition(); }
//            }
//            else {
//                idDmbDisasterCkList.state="on"
//                MDmbOperation.CmdReqAMASMessageSelete(secondText)
//            }
        }
    }

    onClickReleased:{
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
            idDmbDisasterEditBand.focus = true;
            idDmbDisasterEditBand.focusMenuBtn();
            idDmbDisasterCheckDelegate.state="keyRelease"
        }
        idAppMain.upKeyReleased = false;
    }

    //--------------------- Connections #
//    Connections{
//        target: idDmbDisasterCkList
//        onCheckBoxChecked:{
//            //console.debug("=========================================== onCheckBoxChecked : " + secondText)
//            idDmbDisasterCheckDelegate.ListView.view.currentIndex = index
//            MDmbOperation.CmdReqAMASMessageSelete(secondText)
//        }

//        onCheckBoxUnchecked:{
//            //console.debug("=========================================== onCheckBoxUnchecked : " + secondText)
//            idDmbDisasterCheckDelegate.ListView.view.currentIndex = index
//            MDmbOperation.CmdReqAMASMessageUnselete(secondText)
//        }
//    }

//    Connections{
//        target: idAppMain

//        onDisasterMsgSelectAll: {
//            //console.debug("##### onDisasterMsgSelectAll :" + index)
//            idDmbDisasterCkList.state="on"
//        }
//        onDisasterMsgUnselectAll: {
//            //console.debug("##### onDisasterMsgUnselectAll:" + index)
//            idDmbDisasterCkList.state="off"
//        }
//    }

    Connections{
        target: CommParser
        onTimeDateFormatChanged:{
            firstText = MDmbOperation.getAlarmPriority(AlarmPriority) + "["+Qt.formatDate(EmergencyTime, "yyyy-MM-dd")+"  "+ Qt.formatDateTime(EmergencyTime, "hh:mm")+"]"
        }
        onIsAMASSeleteAllChanged:{
            if(CommParser.m_bIsAMASSeleteAll == true)
            {
                idCheckBoxImage.checkstate = true;
            }
        }

        onIsAMASUnseleteAllChanged:{
            if(CommParser.m_bIsAMASUnseleteAll == true)
            {
                idCheckBoxImage.checkstate = false;
                idDmbDisasterCheckDelegate.backupcheckstate = false;
            }
        }

        onSetAMASCancelDeleteAll:{
            if(idDmbDisasterCheckDelegate.backupcheckstate == false)
                idCheckBoxImage.checkstate = false;

        }

        onSetDisasterListCheckboxRestore:{

//            if(index == signal_index){
//                if(idDmbDisasterCheckDelegate.backupcheckstate != bIschecked)
//                    idDmbDisasterCheckDelegate.backupcheckstate = bIschecked;
//            }

            idCheckBoxImage.checkstate = idDmbDisasterCheckDelegate.backupcheckstate;
        }
    }

    Connections{
        target:EngineListener

        onSetDisasterListChekbox:{

            if(index == signal_index)
            {
                if(idCheckBoxImage.checkstate == true)
                {
                    if(CommParser.m_bIsAMASSeleteAll == false)
                    {
                        idCheckBoxImage.checkstate = false;
                        //if(idDmbDisasterCheckDelegate.backupcheckstate == true)
                        idDmbDisasterCheckDelegate.backupcheckstate = false;
                    }
                }
                else
                {
                    if(CommParser.m_bIsAMASUnseleteAll == false)
                    {
                        idCheckBoxImage.checkstate = true;
                        //if(idDmbDisasterCheckDelegate.backupcheckstate == false)
                        idDmbDisasterCheckDelegate.backupcheckstate = true;
                    }
                }
            }

            idDmbDisasterCheckDelegate.ListView.view.currentIndex = signal_index;
        }
    }

}
