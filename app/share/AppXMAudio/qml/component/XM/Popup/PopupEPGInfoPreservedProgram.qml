/**
 * FileName: PopupEPGInfoPreservedProgram.qml
 * Author: HYANG
 * Time: 2013-7
 *
 * - 2013-07 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp

FocusScope{
    id: idRadioPopupEPGInfoPreservedProgramQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property int nCStatus : 0
    property int nSStatus : 0
    property int nEPGIndex : 0
    property string szSavedEPGID : ""
    property string szPreserveEPGID : ""
    property string szStartTime : ""

    MComp.MPopupTypeText {
        id : idRadioPopupEPGInfoPreservedProgram
        focus : true
        popupBtnCnt: 2
        popupLineCnt: 1

        popupFirstBtnText: stringInfo.sSTR_XMRADIO_YES
        popupSecondBtnText: stringInfo.sSTR_XMRADIO_NO
        popupFirstText: stringInfo.sSTR_XMRADIO_ALREADY_PRESERVE_PROGRAM

        onPopupFirstBtnClicked : {
            if(nCStatus == 1) //Set Single Reminder
            {
                if(nSStatus == 1)
                {
                    EPGInfo.handleSetEpgProgAlertListDelete(szSavedEPGID, szStartTime);
                }
                EPGInfo.handleSetEpgProgAlertList(nEPGIndex, true);
            }

            idAppMain.alertcheckimagesiganl(gEPGProgramIndex);
            idAppMain.gotoBackScreen(false);
        }

        onPopupSecondBtnClicked : {
            idAppMain.gotoBackScreen(false);
        }

        onHardBackKeyClicked : {
            idAppMain.gotoBackScreen(false);
        }
        onHomeKeyPressed: {
            idAppMain.gotoBackScreen(false);
            UIListener.HandleHomeKey();
        }
    }

    function onPopupPreserveProgramIDAndStartTime(n_CStatus, n_SStatus, n_EPGIndex, sz_SavedEPGID, sz_PreserveEPGID, sz_StartTime)
    {
        console.log("Translation Information CStatus = "+n_CStatus+" SStatus"+n_SStatus+"Index = "+n_EPGIndex+"Saved EPG ID = "+sz_SavedEPGID+"Preserve EPG ID = "+sz_PreserveEPGID+" StartTime = "+sz_StartTime)

        nCStatus = n_CStatus;
        nSStatus = n_SStatus;
        nEPGIndex = n_EPGIndex;
        szSavedEPGID = sz_SavedEPGID;
        szPreserveEPGID = sz_PreserveEPGID;
        szStartTime = sz_StartTime;
    }
}
