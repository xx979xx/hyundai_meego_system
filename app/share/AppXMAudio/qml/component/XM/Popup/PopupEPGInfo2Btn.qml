import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

FocusScope {
    id: idRadioPopupEPGInfo2BtnQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property int epgTimeCheck: 0
    property string epgInfoTitle : (EPGInfo.EpgLongName == "") ? EPGInfo.EpgShortName : EPGInfo.EpgLongName
    property string epgInfoStart : EPGInfo.EpgConvertStartTime
    property string epgInfoEnd : EPGInfo.EpgConvertEndTime
    property string epgInfoChnName : (EPGInfo.EpgLongName == "") ? EPGInfo.EpgShortName : EPGInfo.EpgLongName
    property string epgInfoCategory : ""
    property string epgInfoContents : EPGInfo.EpgSeriesDes

    MComp.MPopupTypeXMEPG{
        id: idRadioPopupWarning

        popupBtnCnt: 2

        popupFirstText: epgInfoStart + " ~ " + epgInfoEnd
        popupSecondText: epgInfoCategory
        popupThirdText: epgInfoChnName
        popupFourthText: epgInfoContents

        popupFirstBtnText: stringInfo.sSTR_XMRADIO_LISTEN
        popupSecondBtnText: stringInfo.sSTR_XMRADIO_CLOSE

        popupfirstTextWrapMode: false

        onPopupFirstBtnClicked: {
            console.log("## First Button clicked ##")
            epgTimeCheck = EPGInfo.handleEPGLastTimeCheck(gEPGProgramIndex);
            if (epgTimeCheck == 2) //Previous Time
            {
                idAppMain.gotoBackScreen(false);

                setAppMainScreen("PopupRadioWarning1Line", true);
                idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_PROGRAM_OFF_AIR);
                idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(true);
            }
            else
            {
                XMOperation.setPreviousScanStop();
                idAppMain.gotoBackScreen(false);

                idAppMain.gotoFirstScreen();
            	EPGInfo.handleEPGChannelSelect();
	    }
        }
        onPopupSecondBtnClicked: {
            console.log("## Second Button clicked ##")
            idAppMain.gotoBackScreen(false);
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupEPGInfo2Btn - BackKey Clicked");
            idAppMain.gotoBackScreen(false);
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupEPGInfo2Btn - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            UIListener.HandleHomeKey();
        }
    }

    function setEPGInfo2CurrCategory(currCat)
    {
        epgInfoCategory = currCat;
    }
}
