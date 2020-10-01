import Qt 4.7
import "../../QML/DH" as MComp

MComp.MPopupTypeToast{
    id: idDimPopupDeleted
    popupFirstText : stringInfo.strPOPUP_Deleted

    onPopupClicked: {
        if(EngineListener.getDRSShowStatus() == false)
        {
            idDimPopupTimer.stop()
            gotoBackScreen()
        }
        else
        {
            EngineListener.moveGoToBackScreen()
        }
    }

    onHardBackKeyClicked:{
        if(EngineListener.getDRSShowStatus() == false)
        {
            idDimPopupTimer.stop()
            gotoBackScreen()
        }
        else
        {
            EngineListener.moveGoToBackScreen()
        }
    }

    onVisibleChanged: {
        if(idDimPopupDeleted.visible == true)
        {
            idDimPopupTimer.start()
        }
        else
        {
            if(idAppMain.isMainDeletedPopup == true)
                idAppMain.isMainDeletedPopup = false

            if(idDimPopupTimer.running == true)
                idDimPopupTimer.stop()
        }
    }

    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            idDimPopupTimer.stop()
            EngineListener.moveGoToBackScreen()
        }
    }

    onClickReleased: {
        if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
    }

    onWheelLeftKeyPressed: {
        EngineListener.moveGoToBackScreen()

        if(idAppMain.isMainDeletedPopup == true)
        {
            idAppMain.isMainDeletedPopup = false
        }
    }
    onWheelRightKeyPressed: {
        EngineListener.moveGoToBackScreen()

        if(idAppMain.isMainDeletedPopup == true)
        {
            idAppMain.isMainDeletedPopup = false
        }
    }
    onSeekPrevKeyReleased: {
        idAppMain.dmbSeekPrevKeyPressed()

        if(idAppMain.isMainDeletedPopup == true)
        {
//            EngineListener.moveGoToBackScreen()
            idAppMain.isMainDeletedPopup = false
        }
    }
    onSeekNextKeyReleased: {
        idAppMain.dmbSeekNextKeyPressed()

        if(idAppMain.isMainDeletedPopup == true)
        {
//            EngineListener.moveGoToBackScreen()
            idAppMain.isMainDeletedPopup = false
        }
    }
    onTuneLeftKeyPressed: {
        idAppMain.dmbTuneLeftKeyPressed()

        if(idAppMain.isMainDeletedPopup == true)
        {
//            EngineListener.moveGoToBackScreen()
            idAppMain.isMainDeletedPopup = false
        }
    }
    onTuneRightKeyPressed: {
        idAppMain.dmbTuneRightKeyPressed()

        if(idAppMain.isMainDeletedPopup == true)
        {
//            EngineListener.moveGoToBackScreen()
            idAppMain.isMainDeletedPopup = false
        }
    }

    Timer {
        id: idDimPopupTimer
        interval: 3000
        running: true
        repeat: false
        onTriggered:
        {
            if(idAppMain.state == "PopupDeleted" && idAppMain.lastMainScreen != "PopupDeleted")
            {
//                if(CommParser.m_bIsSystemPopUpShow == false)
                {
                    EngineListener.moveGoToBackScreen()
                }
            }
        }
    }

    Connections{
        target: idAppMain
        onSignalAllTimerOff: {
            if(idDimPopupTimer.running == true)
            {
                idDimPopupTimer.stop()
            }
        }
    }
}
