/**
 * FileName: DABInfoEPGPreserveFullPopup.qml
 * Author: HYANG
 * Time: 2013-1
 *
 * - 2013-01-07 Initial Created by HYANG
 */


import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation


MComp.MPopupTypeText {
    id : idDabInfoEPGPreserveFullPopup
    objectName: "EPGFullPopup"

    focus : true
    popupBtnCnt: 2

    popupFirstBtnText: stringInfo.strEPGPopup_Yes
    popupSecondBtnText: stringInfo.strEPGPopup_No
    popupFirstText: stringInfo.strEPGPopup_AlreadyReservedTimer

    onPopupFirstBtnClicked :
    {
        console.log("[QML] DABInfoEPGPreserveFullPopup.qml : onPopupFirstBtnClicked : m_sProgramServiceID =" + m_sProgramServiceID + ", m_sProgramTitle = " + m_sProgramTitle);
        console.log("[QML] DABInfoEPGPreserveFullPopup.qml : onPopupFirstBtnClicked : m_iHour =" + m_iHour + ", m_iMinute = " + m_iMinute + ", m_iSecond = " + m_iSecond + ", m_iDuration = " + m_iDuration);
        MDabOperation.CmdAddRemoveEPGReservation(m_xCurrentDate, m_sProgramServiceName, m_sProgramServiceID,m_sProgramTitle,m_sProgramdDscription,m_iHour,m_iMinute,m_iSecond,m_iDuration)
    }

    onPopupSecondBtnClicked : {
        console.log("[QML] DABInfoEPGPreserveFullPopup.qml : onPopupSecondBtnClicked")
        gotoBackScreen();
    }

    onHardBackKeyClicked : {        
        console.log("[QML] DABInfoEPGPreserveFullPopup.qml : onHardBackKeyClicked")
        gotoBackScreen();
    }

    Connections {
        target: AppUIListener
        onCloseEPGFullPopup:{
            console.log("[QML] ==> Connections : DABInfoEPGPreserveFullPopup.qml : AppUIListener::onCloseEPGFullPopup ");
            gotoBackScreen();
        }
    }
}
