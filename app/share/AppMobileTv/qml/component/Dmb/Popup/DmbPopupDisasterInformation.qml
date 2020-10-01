import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MPopupTypeTextScroll{
    id: idPopupDisasterInformation
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight  
    focus: true

    // Msg Info
    //popupFirstText: Qt.formatDateTime(EmergencyTime, CommParser.m_sTimeDateFormat) + "\n" + DisasterMessage

    // Btn Info
    popupBtnCnt: 2
    popupFirstBtnText: stringInfo.strPOPUP_BUTTON_OK
    popupSecondBtnText: stringInfo.strPOPUP_BUTTON_Delete

    property int popupAlarmPriority: 0;
    property string popupDisasterInfo: "";
    property string popupDisasterMessage: "";

    // onBtn0Click
    onPopupFirstBtnClicked: {
        //console.debug("Disaster Info : OK")
        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
        }
        else
        {
            EngineListener.selectOptionMenuByIndex(6/*Back */);
        }
    }
    // onBtn1Click
    onPopupSecondBtnClicked: {
        //console.debug("Disaster Info : Delete")
        if(EngineListener.getDRSShowStatus() == false)
        {
            setAppMainScreen("PopupDisasterDeleteConfirm", false)
            showDisasterMessage("",deleteKey);
        }
        else
        {
            EngineListener.selectDisasterPopupDelete(deleteKey);
        }

        //showDisasterMessage(titleText, msgString);
    }

    //onPopupBgClicked : gotoBackScreen()
    onBackKeyPressed:{

        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
        }
        else
        {
            EngineListener.selectOptionMenuByIndex(6/*Back */);
        }
    }
    onHomeKeyPressed: EngineListener.HandleHomeKey();

    onSeekPrevKeyReleased:  { idAppMain.dmbSeekPrevKeyPressed()  }
    onSeekNextKeyReleased:  { idAppMain.dmbSeekNextKeyPressed()  }
    onTuneLeftKeyPressed:  { idAppMain.dmbTuneLeftKeyPressed()  }
    onTuneRightKeyPressed: { idAppMain.dmbTuneRightKeyPressed() }

    Connections{
        target:EngineListener
        onSetDisasterPopupDelete:{
            setAppMainScreen("PopupDisasterDeleteConfirm", false)
//            showDisasterMessage("",signal_deleteKey);
            showDisasterMessage(0, "", "", signal_deleteKey);
        }

        onRetranslateUi:{
            if(idAppMain.state == "PopupDisasterInfomation"){
                popupFirstText = MDmbOperation.getAlarmPriority(popupAlarmPriority) + "\n" +popupDisasterInfo + "\n" + popupDisasterMessage;
            }
        }
    }


    property string deleteKey : ""
    Connections{
        target: idAppMain
        onShowDisasterMessage:{

            deleteKey = "";
            popupAlarmPriority = 0;
            popupDisasterInfo = "";
            popupDisasterMessage = "";

            deleteKey = disasterId;

            popupAlarmPriority = alarmPriority;
            popupDisasterInfo = disasterInfo;
            popupDisasterMessage = disasterMessage;

            popupFirstText = MDmbOperation.getAlarmPriority(alarmPriority) + "\n" +popupDisasterInfo + "\n" + popupDisasterMessage;
            //popupFirstText = Qt.formatDateTime(EmergencyTime, CommParser.m_sTimeDateFormat) + "\n" + DisasterMessage
            //popupFirstText = disasterInfo + "\n" + disasterMessage;
        }
    }
}
