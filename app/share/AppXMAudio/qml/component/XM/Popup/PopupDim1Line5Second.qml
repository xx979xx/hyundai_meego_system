import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/Operation.js" as MOperation

FocusScope {
    id: idRadioPopupDim1Line5SecondQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property string dim1LineFirst : ""

    MComp.MPopupTypeToast{
        id: idRadioPopupDim

        popupLineCnt : 1  //# count of line(1 or 2)
        popupLoadingFlag: false   //# loading Image On/Off
        popupFirstText: dim1LineFirst

        onPopupBgClicked: {
            console.log("## Popup clicked ##")
            idAppMain.gotoBackScreen(false);
            setPopupDim1LineClose();
        }

        onPopupClicked: {
            console.log("## Popup clicked ##")
            idAppMain.gotoBackScreen(false);
            setPopupDim1LineClose();
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupDim1Line - BackKey Clicked");
            idAppMain.gotoBackScreen(false);
            setPopupDim1LineClose();
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupDim1Line - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            setPopupDim1LineClose();
            UIListener.HandleHomeKey();
        }
        onClickMenuKey: {
            idAppMain.gotoBackScreen(false);
            setPopupDim1LineClose();
            MOperation.setPopupOptionMenu();
        }

        onPrevKeyClicked: {
            idAppMain.gotoBackScreen(false);
            setPopupDim1LineClose();
        }
        onNextKeyClicked: {
            idAppMain.gotoBackScreen(false);
            setPopupDim1LineClose();
        }
    }

    function setPopupDim1LineClose()
    {
        idRadioPopupDimmed1Timer.stop();
    }

    function onPopupDim1LineFirst(firsttext)
    {
        dim1LineFirst = firsttext
    }

    Timer {
        id: idRadioPopupDimmed1Timer
        interval: 5000
        running: true
        repeat: false
        onTriggered:
        {
            setPopupDim1LineClose();
            idAppMain.gotoBackScreen(false);
        }
    }

    onVisibleChanged: {
        console.log("idRadioPopupDim1Line5Second.visible - 1line!"+idRadioPopupDim1Line5Second.visible)
        if(idRadioPopupDim1Line5Second.visible == true)
        {
            idRadioPopupDimmed1Timer.start();
        }
        else
        {
            idRadioPopupDimmed1Timer.stop();
        }
    }
}
