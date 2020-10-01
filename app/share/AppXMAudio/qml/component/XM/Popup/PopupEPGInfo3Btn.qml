import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

FocusScope {
    id: idRadioPopupEPGInfo3BtnQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property int epgTimeCheck: 0
    property string epgInfoTitle : (EPGInfo.EpgLongName == "") ? EPGInfo.EpgShortName : EPGInfo.EpgLongName
    property string epgInfoStart : EPGInfo.EpgConvertStartTime
    property string epgInfoEnd : EPGInfo.EpgConvertEndTime
    property string epgInfoContents : EPGInfo.EpgSeriesDes
    property string epgInfoChnName : (EPGInfo.EpgLongName == "") ? EPGInfo.EpgShortName : EPGInfo.EpgLongName
    property string epgInfoCategory : ""
    property bool   epgInfoProgAlert : false

    property string epgInfoID : ""

    MComp.MPopupTypeXMEPG{
        id: idRadioPopupWarning

        popupBtnCnt: 2

        popupFirstText: epgInfoStart + " ~ " + epgInfoEnd
        popupSecondText: epgInfoCategory
        popupThirdText: epgInfoChnName
        popupFourthText: epgInfoContents

        popupFirstBtnText: (epgInfoProgAlert == false) ? stringInfo.sSTR_XMRADIO_SET_REMINDER: stringInfo.sSTR_XMRADIO_CANCEL_REMINDER
        popupSecondBtnText: stringInfo.sSTR_XMRADIO_CLOSE

        popupfirstTextWrapMode: true

        onPopupFirstBtnClicked: {
            console.log("## First Button clicked ##")
            epgTimeCheck = EPGInfo.handleEPGLastTimeCheck(gEPGProgramIndex);
            if(epgTimeCheck == 2) //Previous Time
            {
                idAppMain.gotoBackScreen(false);

                setAppMainScreen("PopupRadioWarning1Line", true);
                idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_PROGRAM_OFF_AIR);
                idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(true);
            }
            else if (epgTimeCheck == 1) //Current Time
            {
                idAppMain.gotoBackScreen(false);

                EPGInfo.handleSetAlreadyStartedPopup(gEPGProgramIndex);
            }
            else //Next Time
            {
                if(epgInfoProgAlert == true)
                {
                    EPGInfo.handleSetEpgProgAlertListDelete(EPGInfo.EpgProgID, EPGInfo.EpgStartTime);
                }
                else
                {
                    if(EPGInfo.handleGetEpgTotalAlertListSize() >= 32)
                    {
                        idAppMain.gotoBackScreen(false);

                        XMOperation.epgAlertListMax(1);
                        return;
                    }
                    else
                    {
                        var retValue = EPGInfo.handleGetEPGAlertTimeStatusCheck(EPGInfo.EpgStartTime);
                        console.log("############# EPG Alert Timer -> return value ################# "+ retValue);
                        if(retValue == 0)
                            EPGInfo.handleSetEpgProgAlertList(idAppMain.gEPGProgramIndex, true);
                        else
                        {
                            idAppMain.gotoBackScreen(false);

                            idAppMain.setAppMainScreen("PopupRadioEPGInfoPreservedProgram", true);
                            epgInfoID = EPGInfo.handleGetEPGAlertTimerEPGIDCheck(EPGInfo.EpgStartTime);
                            idRadioPopupEPGInfoPreservedProgram.item.onPopupPreserveProgramIDAndStartTime(1, retValue, idAppMain.gEPGProgramIndex, epgInfoID, EPGInfo.EpgProgID, EPGInfo.EpgStartTime);
                            return;
                        }
                    }
                }

                idAppMain.alertcheckimagesiganl(idAppMain.gEPGProgramIndex);
                idAppMain.gotoBackScreen(false);

                if(epgInfoProgAlert == true)
                {
                    idAppMain.setAppMainScreen("PopupRadioDim1Line", true);
                    idRadioPopupDim1Line.item.onPopupDim1LineFirst(stringInfo.sSTR_XMRADIO_PROGRAM_REMINDER_CANCEL);
                }
                else
                {
                    idAppMain.setAppMainScreen("PopupRadioDim1Line", true);
                    idRadioPopupDim1Line.item.onPopupDim1LineFirst(stringInfo.sSTR_XMRADIO_PROGRAM_REMINDER_SET);
                }
	    }
        }

        onPopupSecondBtnClicked: {
            console.log("## Third Button clicked ##")
            idAppMain.gotoBackScreen(false);
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupEPGInfo3Btn - BackKey Clicked");
            idAppMain.gotoBackScreen(false);
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupEPGInfo3Btn - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            UIListener.HandleHomeKey();
        }
    }

    function setEPGInfoProgAlert(b_status)
    {
        epgInfoProgAlert = b_status;
    }

    function setEPGInfo3CurrCategory(currCat)
    {
        epgInfoCategory = currCat;
    }
}
