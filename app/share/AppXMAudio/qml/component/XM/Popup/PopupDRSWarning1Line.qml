import Qt 4.7
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioPopupDRSWarning1LineQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property bool   warning1LineWrap : false
    property bool   warning1LineWidthExtension : false

    MComp.MPopupTypeText{
        id: idRadioPopupWarning

        popupLineWidthExtension: warning1LineWidthExtension
        popupLineWrap: warning1LineWrap
        popupBtnCnt: 1
        popupLineCnt: 1
        popupFirstText: stringInfo.sSTR_XMRADIO_DRS_WARNING
        popupFirstBtnText: stringInfo.sSTR_XMRADIO_OK

        onPopupFirstBtnClicked: {
            console.log("## Button clicked ##")
            idAppMain.gotoFirstScreen();
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupWarning1Line - BackKey Clicked");
            idAppMain.gotoFirstScreen();
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupWarning1Line - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            UIListener.HandleHomeKey();
        }
    }

    function onPopupDRSWarning1LineWrap(bStatus)
    {
        warning1LineWrap = bStatus;
    }

    function onPopupWarning1LineWidthExtension(bStatus)
    {
        warning1LineWidthExtension = bStatus;
    }
}
