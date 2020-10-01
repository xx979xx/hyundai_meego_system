import Qt 4.7
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioPopupWarning1LineQml
    focus: true

    property string warning1LineFirst : ""

    MComp.MPopupTypeTextForAntSig{
        id: idRadioPopupWarning
        y: 0
        height: systemInfo.lcdHeight+systemInfo.statusBarHeight

        popupLineCnt: 1
        popupBtnCnt: 1

        popupFirstText: warning1LineFirst
        popupFirstBtnText : stringInfo.sSTR_XMDATA_OK

        onPopupFirstBtnClicked: {
            console.log("## Button clicked ##")
            setPopupWarning1LineClose();
        }
        onPopupClicked: {
            console.log("## Popup clicked ##")
        }
        onHardBackKeyClicked:{
            console.log("## HardBackKey clicked ##")
            setPopupWarning1LineClose();
        }
    }

    function setPopupWarning1LineClose()
    {
        idRadioPopupWarning1LineTimer.running = false;
        idRadioPopupWarning1Line.visible = false;
        idMainFocusScope.forceActiveFocus();
        idAppMain.statusAntSig = false;
    }

    function onPopupWarning1LineFirst(firsttext)
    {
        warning1LineFirst = firsttext
    }

    function onBack()
    {
        return true;
    }

    Timer {
        id: idRadioPopupWarning1LineTimer
        interval: 3000
        running: true
        repeat: false
        onTriggered:
        {
            setPopupWarning1LineClose();
        }
    }

    onVisibleChanged: {
        if(idRadioPopupWarning.visible == true){
            idRadioPopupWarning1LineTimer.running = true;
        }
        else
            idRadioPopupWarning1LineTimer.running = false;
    }
    Connections{
        target:UIListener
        onTemporalModeMaintain:{
            if(!mbTemporalmode)
            {
                if(visible)
                {
                    setPopupWarning1LineClose();
                }
            }
        }

        onSignalShowSystemPopup:{
            console.log("onSignalShowSystemPopup")
            if(visible)
            {
                setPopupWarning1LineClose();
            }
        }
    }

}
