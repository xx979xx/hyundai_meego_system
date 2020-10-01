import Qt 4.7
import "../../QML/DH" as MComp
//import "../../../javascript/XMAudioOperation.js" as XMOperation

FocusScope {
    id: idRadioPopupWarning2LineQml
    focus: true

    property string warning2LineFirst : ""
    property string warning2LineSecond : ""
    property bool warning2secondBtnUsed: false

    MComp.MPopupTypeTextForAntSig{
        id: idRadioPopupWarning
        y: 0
        height: systemInfo.lcdHeight+systemInfo.statusBarHeight

        popupLineCnt: 2
        popupBtnCnt: (warning2secondBtnUsed === true) ? 2 : 1
        popupFirstText: warning2LineFirst
        popupSecondText: warning2LineSecond

        popupFirstBtnText: (warning2secondBtnUsed === true) ? stringInfo.sSTR_XMRADIO_PLAY : stringInfo.sSTR_XMDATA_OK
        popupSecondBtnText: (warning2secondBtnUsed === true) ? (stringInfo.sSTR_XMRADIO_LIVE+" "+stringInfo.sSTR_XMRADIO_MODE) : ""

        onPopupFirstBtnClicked: {
            console.log("## First Button clicked ##")
            setPopupWarning2LineClose();
        }
        onPopupSecondBtnClicked: {
            console.log("## Second Button clicked ##")
            if(warning2secondBtnUsed == true)
            {
                setPopupWarning2LineClose();
            }
        }

        onPopupClicked: {
            console.log("## Popup clicked ##")
        }
        onHardBackKeyClicked:{
            console.log("## HardBackKey clicked ##")
            setPopupWarning2LineClose();
        }
    }


    function setPopupWarning2LineClose()
    {
        idRadioPopupWarning2LineTimer.running = false;
        idRadioPopupWarning2Line.visible = false;
        idMainFocusScope.forceActiveFocus();
        idAppMain.statusAntSig = false;
    }

    function onPopupWarning2LineFirst(firsttext)
    {
        warning2LineFirst = firsttext;
    }

    function onPopupWarning2LineSecond(secondtext)
    {
        warning2LineSecond = secondtext;
    }

    function onPopupWarning2LineSecondBtnUsed(secondBtnUsed)
    {
        warning2secondBtnUsed = secondBtnUsed;
    }

    function onBack()
    {
        return true;
    }

    Timer {
        id: idRadioPopupWarning2LineTimer
        interval: 3000
        running: true
        repeat: false
        onTriggered:
        {
            setPopupWarning2LineClose();
        }
    }

    onVisibleChanged: {
        if(idRadioPopupWarning.visible == true){
            idRadioPopupWarning2LineTimer.running = true;
        }
        else
            idRadioPopupWarning2LineTimer.running = false;
    }

    Connections{
        target:UIListener
        onTemporalModeMaintain:{
            if(!mbTemporalmode)
            {
                if(visible)
                {
                    setPopupWarning2LineClose();
                }
            }
        }

        onSignalShowSystemPopup:{
            console.log("onSignalShowSystemPopup")
            if(visible)
            {
                setPopupWarning2LineClose();
            }
        }
    }

}
