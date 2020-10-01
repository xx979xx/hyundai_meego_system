import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/Operation.js" as MOperation

FocusScope {
    id: idRadioPopupAdvisory1LineQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property string adv1LineFirst : ""

    MComp.MPopupTypeToast{
        id: idRadioPopupAdv

        popupLineCnt : 1  //# count of line(1 or 2)
        popupLoadingFlag: false   //# loading Image On/Off
        popupFirstText: adv1LineFirst

        onPopupBgClicked: {
            console.log("## Popup clicked ##")
            idAppMain.gotoBackScreen(false);
            setPopupAdv1LineClose();
        }

        onPopupClicked: {
            console.log("## Popup clicked ##")
            idAppMain.gotoBackScreen(false);
            setPopupAdv1LineClose();
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupDim1Line - BackKey Clicked");
            idAppMain.gotoBackScreen(false);
            setPopupAdv1LineClose();
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupDim1Line - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            setPopupAdv1LineClose();
            UIListener.HandleHomeKey();
        }
        onClickMenuKey: {
            idAppMain.gotoBackScreen(false);
            setPopupAdv1LineClose();
            MOperation.setPopupOptionMenu();
        }

        onPrevKeyClicked: {
            idAppMain.gotoBackScreen(false);
            setPopupAdv1LineClose();
        }
        onNextKeyClicked: {
            idAppMain.gotoBackScreen(false);
            setPopupAdv1LineClose();
        }
    }

    function setPopupAdv1LineClose()
    {
        idRadioPopupAdvisory1Timer.stop();
    }

    function onPopupAdv1LineFirst(firsttext)
    {
        adv1LineFirst = firsttext
    }

    Timer {
        id: idRadioPopupAdvisory1Timer
        interval: 4000
        running: true
        repeat: false
        onTriggered:
        {
            setPopupAdv1LineClose();
            idAppMain.gotoBackScreen(false);
        }
    }

    onVisibleChanged: {
        console.log("idRadioPopupAdvisory1Line.visible - 1line!"+idRadioPopupAdvisory1Line.visible)
        if(idRadioPopupAdvisory1Line.visible == true)
        {
            idRadioPopupAdvisory1Timer.start();
        }
        else
        {
            idRadioPopupAdvisory1Timer.stop();
        }
    }
}
