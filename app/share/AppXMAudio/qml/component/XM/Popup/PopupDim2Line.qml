import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/Operation.js" as MOperation

FocusScope {
    id: idRadioPopupDim2LineQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property string dim2LineFirst : ""
    property string dim2LineSecond : ""

    MComp.MPopupTypeToast{
        id: idRadioPopupDim

        popupLineCnt: 2  //# count of line(1 or 2)
        popupLoadingFlag: false   //# loading Image On/Off
        popupFirstText: dim2LineFirst
        popupSecondText: dim2LineSecond

        onPopupBgClicked: {
            console.log("## Popup clicked ##")
            idAppMain.gotoBackScreen(false);
            setPopupDim2LineClose();
        }

        onPopupClicked: {
            console.log("## Popup clicked ##")
            idAppMain.gotoBackScreen(false);
            setPopupDim2LineClose();
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupDim2Line - BackKey Clicked");
            idAppMain.gotoBackScreen(false);
            setPopupDim2LineClose();
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupDim2Line - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            setPopupDim2LineClose();
            UIListener.HandleHomeKey();
        }
        onClickMenuKey: {
            idAppMain.gotoBackScreen(false);
            setPopupDim2LineClose();
            MOperation.setPopupOptionMenu();
        }

        onPrevKeyClicked: {
            idAppMain.gotoBackScreen(false);
            setPopupDim2LineClose();
        }
        onNextKeyClicked: {
            idAppMain.gotoBackScreen(false);
            setPopupDim2LineClose();
        }
        //        onWheel8DirectionClicked: {
        //            idAppMain.gotoBackScreen(false);
        //            setPopupDim2LineClose();
        //        }
    }

    function setPopupDim2LineClose()
    {
        idRadioPopupDimmed2Timer.stop();
    }

    function onPopupDim2LineFirst(firsttext)
    {
        dim2LineFirst = firsttext;
    }

    function onPopupDim2LineSecond(secondtext)
    {
        dim2LineSecond = secondtext;
    }

    Timer {
        id: idRadioPopupDimmed2Timer
        interval: 3000
        running: true
        repeat: false
        onTriggered:
        {
            setPopupDim2LineClose();
            idAppMain.gotoBackScreen(false);
        }
    }

    onVisibleChanged: {
        console.log("idRadioPopupDim2Line.visible - 2line!"+idRadioPopupDim2Line.visible)
        if(idRadioPopupDim2Line.visible == true){
            idRadioPopupDimmed2Timer.start();
        }
        else
        {
            idRadioPopupDimmed2Timer.stop();
        }
    }
}
