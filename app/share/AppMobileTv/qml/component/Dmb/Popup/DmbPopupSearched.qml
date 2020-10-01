import Qt 4.7
import "../../QML/DH" as MComp

MComp.MPopupTypeToast{
    id: idPopupSearched
    popupFirstText: stringInfo.strPOPUP_SearchComplete + "\n" + stringInfo.strPOPUP_SearchTVChannel + CommParser.iChSearchTVIndex + stringInfo.strPOPUP_SearchChannelCount
                            + "\n" + stringInfo.strPOPUP_SearchRadioChannel + CommParser.iChSearchRadioIndex + stringInfo.strPOPUP_SearchChannelCount

    function setModelString(){
        if(idPopupSearched.visible == true){
            popupFirstText = stringInfo.strPOPUP_SearchComplete + "\n" + stringInfo.strPOPUP_SearchTVChannel + CommParser.iChSearchTVIndex + stringInfo.strPOPUP_SearchChannelCount
                    + "\n" + stringInfo.strPOPUP_SearchRadioChannel + CommParser.iChSearchRadioIndex + stringInfo.strPOPUP_SearchChannelCount
        }
    }

    onPopupClicked: {
        idSearchedPopupTimer.stop()
        EngineListener.moveGoToBackScreen()
    }
    onHardBackKeyClicked:{
        idSearchedPopupTimer.stop()
        EngineListener.moveGoToBackScreen()
    }

    Timer {
        id: idSearchedPopupTimer
        interval: 3000
        running: true
        repeat: false
        onTriggered:
        {
            if(idAppMain.state == "PopupSearched" && idAppMain.lastMainScreen != "PopupSearched")
            {
//                if(CommParser.m_bIsSystemPopUpShow == false)
                {
                    EngineListener.moveGoToBackScreen()
                }
            }
        }
    }

    onVisibleChanged: {
        if(idPopupSearched.visible == true){
            idSearchedPopupTimer.start()
        }else{
            idSearchedPopupTimer.stop()
        }
    }

    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            idSearchedPopupTimer.stop()
            EngineListener.moveGoToBackScreen()
        }
    }

    onClickReleased: {
        if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
    }

    onWheelLeftKeyPressed: { EngineListener.moveGoToBackScreen() }
    onWheelRightKeyPressed: { EngineListener.moveGoToBackScreen() }

    onSeekPrevKeyReleased: {
        EngineListener.moveGoToBackScreen()
        idAppMain.dmbSeekPrevKeyPressed()
    }

    onSeekNextKeyReleased: {
        EngineListener.moveGoToBackScreen()
        idAppMain.dmbSeekNextKeyPressed()
    }

    onTuneLeftKeyPressed: {
        EngineListener.moveGoToBackScreen()
        idAppMain.dmbTuneLeftKeyPressed()
    }

    onTuneRightKeyPressed: {
        EngineListener.moveGoToBackScreen()
        idAppMain.dmbTuneRightKeyPressed()
    }

    onTuneEnterKeyPressed: {
        if(idSearchedPopupTimer.running == true)
            idSearchedPopupTimer.stop()

        EngineListener.moveGoToBackScreen()
    }

    Connections{
        target: idAppMain
        onSignalAllTimerOff: {
            if(idSearchedPopupTimer.running == true)
            {
                idSearchedPopupTimer.stop()
                EngineListener.moveGoToBackScreen()
            }
        }
    }

}
