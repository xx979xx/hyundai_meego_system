import Qt 4.7
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioPopupWarning2LineQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property string warning2LineFirst : ""
    property string warning2LineSecond : ""
    property bool   warning2LineWrap : false

    MComp.MPopupTypeText{
        id: idRadioPopupWarning

        popupLineWrap: warning2LineWrap
        popupLineCnt: 2
        popupFirstText: warning2LineFirst
        popupSecondText: warning2LineSecond

        popupBtnCnt: 1
        popupFirstBtnText: stringInfo.sSTR_XMRADIO_OK

        onPopupFirstBtnClicked: {
            console.log("## First Button clicked ##")
            UIListener.HandlePopupClose();
            idAppMain.gotoBackScreen(false);
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupWarning2Line - BackKey Clicked");
            UIListener.HandlePopupClose();
            idAppMain.gotoBackScreen(false);
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupWarning2Line - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            UIListener.HandlePopupClose();
            UIListener.HandleHomeKey();
        }
    }

    function onPopupWarning2LineFirst(firsttext)
    {
        warning2LineFirst = firsttext;
    }

    function onPopupWarning2LineSecond(secondtext)
    {
        warning2LineSecond = secondtext;
    }

    function onPopupWarning2LineWrap(bStatus)
    {
        warning2LineWrap = bStatus;
    }
}
