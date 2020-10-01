import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

FocusScope {
    id: idRadioPopupIRWarning2LineQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property string warning2LineFirst : ""
    property string warning2LineSecond : ""
    property string warning3LineThird : ""

    MComp.MPopupTypeText{
        id: idRadioPopupWarning

        popupLineCnt : 3
        popupFirstText: warning2LineFirst
        popupSecondText: warning2LineSecond
        popupThirdText: warning3LineThird

        popupBtnCnt: 2
        popupFirstBtnText: stringInfo.sSTR_XMRADIO_PLAY
        popupSecondBtnText: stringInfo.sSTR_XMRADIO_LIVE_MODE

        onPopupFirstBtnClicked: {
            console.log("## First Button clicked ##")
            setPopupIRWarning2LineClose();

            idAppMain.gotoBackScreen(false);
            XMOperation.onPlay();
        }
        onPopupSecondBtnClicked: {
            console.log("## Second Button clicked ##")
            setPopupIRWarning2LineClose();
            XMOperation.onNowPlay(true);
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupIRWarning2Line - BackKey Clicked");
            idAppMain.gotoBackScreen(false);
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupIRWarning2Line - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            UIListener.HandleHomeKey();
        }
    }

    function setPopupIRWarning2LineClose()
    {
        idRadioPopupIRWarning2Line.visible = false;
    }

    function onPopupWarning2LineFirst(firsttext)
    {
        warning2LineFirst = firsttext;
    }

    function onPopupWarning2LineSecond(secondtext)
    {
        warning2LineSecond = secondtext;
    }

    function onPopupWarning2LineThird(thirdtext)
    {
        warning3LineThird = thirdtext;
    }
}
