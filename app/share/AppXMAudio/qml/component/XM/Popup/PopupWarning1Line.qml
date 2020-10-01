import Qt 4.7
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioPopupWarning1LineQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property string warning1LineFirst : ""
    property bool   warning1LineWrap : false
    property bool   warning1LineWidthExtension : false

    MComp.MPopupTypeText{
        id: idRadioPopupWarning

        popupLineWidthExtension: warning1LineWidthExtension
        popupLineWrap: warning1LineWrap
        popupBtnCnt: 1
        popupLineCnt: 1
        popupFirstText: warning1LineFirst

        popupFirstBtnText: stringInfo.sSTR_XMRADIO_OK

        onPopupFirstBtnClicked: {
            console.log("## Button clicked ##")
            idAppMain.gotoBackScreen(false);
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupWarning1Line - BackKey Clicked");
            idAppMain.gotoBackScreen(false);
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupWarning1Line - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            UIListener.HandleHomeKey();
        }

        //        onTuneEnterKeyPressed: {
        //            if(idAppMain.preMainScreen == "AppRadioList")
        //            {
        //                console.log("[LIST] Tune knob Enter Pressed !!!!!!!!!!!!!!!!!!!!!! "+idAppMain.preMainScreen);
        //                idRadioList.item.setListTuneEnter();
        //            }
        //        }
        //        onTuneLeftKeyPressed: {
        //            if(idAppMain.preMainScreen == "AppRadioList")
        //            {
        //                console.log("[LIST] Tune knob Left Key Pressed !!!!!!!!!!!!!!!!!!!!!! "+idAppMain.preMainScreen);
        //                idRadioList.item.setListTuneLeft();
        //            }
        //        }
        //        onTuneRightKeyPressed: {
        //            if(idAppMain.preMainScreen == "AppRadioList")
        //            {
        //                console.log("[LIST] Tune knob Right Key Pressed !!!!!!!!!!!!!!!!!!!!!! "+idAppMain.preMainScreen);
        //                idRadioList.item.setListTuneRight();
        //            }
        //        }
    }

    function onPopupWarning1LineFirst(firsttext)
    {
        warning1LineFirst = firsttext
    }

    function onPopupWarning1LineWrap(bStatus)
    {
        warning1LineWrap = bStatus;
    }

    function onPopupWarning1LineWidthExtension(bStatus)
    {
        warning1LineWidthExtension = bStatus;
    }
}
