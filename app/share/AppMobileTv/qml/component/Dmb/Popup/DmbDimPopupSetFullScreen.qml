import Qt 4.7
import "../../QML/DH" as MComp

MComp.MPopupTypeToast{
    id: idDimPopupSetFullScreen
    y: 0-systemInfo.statusBarHeight
    height: systemInfo.lcdHeight_VEXT
    popupFirstText: stringInfo.strPOPUP_SetFullscreen
    popupFirstTextHAlignment: "Center"//"Left"

    onPopupClicked: {
        idDimPopupTimer.stop()
        EngineListener.moveGoToBackScreen()
    }
    onHardBackKeyClicked:{
        idDimPopupTimer.stop()
        EngineListener.moveGoToBackScreen()
    }

    Timer {
        id: idDimPopupTimer
        interval: 1000
        running: true
        repeat: false
        onTriggered:
        {
            if(idAppMain.state == "PopupSetFullScreen")
            {
                EngineListener.moveGoToBackScreen()
            }
        }
    }

    onVisibleChanged: {
        //console.log("[QML][idDimPopupSetFullScreen][onVisibleChanged] visible : " + visible)
        var logMsg = "[QML][idDimPopupSetFullScreen][onVisibleChanged] visible : " + visible;

        EngineListener.printLogMessge(logMsg);

        if(idDimPopupSetFullScreen.visible == true){
            idDimPopupTimer.start()
        }else{
            if(idDimPopupTimer.running)
                idDimPopupTimer.stop();
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

//    onTuneEnterKeyPressed: {
//        if(idDimPopupTimer.running == true)
//            idDimPopupTimer.stop()

//        EngineListener.moveGoToBackScreen()
//    }

    onClickMenuKey:{
        idDimPopupTimer.stop()
        EngineListener.moveGoToBackScreen()

        if(CommParser.m_bIsFullScreen == true)
        {
            CommParser.m_bIsFullScreen = false;
        }

        setAppMainScreen("AppDmbPlayerOptionMenu", true);

    }

    Connections{
        target: idAppMain
        onSignalAllTimerOff: {
            if(idDimPopupTimer.running == true)
            {
                idDimPopupTimer.stop()
                EngineListener.moveGoToBackScreen()
            }
        }
    }
}
