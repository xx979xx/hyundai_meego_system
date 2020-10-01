/**
 * FileName: DABInfoEPGDescPopup.qml
 * Author: DaeHyungE
 * Time: 2012-07-16
 *
 * - 2012-07-16 Initial Created by HyungE
 * - 2013-01-08 Added Duplicate reservation check Popup
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation


MComp.MPopupTypeEPG {
    id : idDabInfoEPGDescPopup
    focus : true
    objectName: "EPGDescPopup"

    popupFirstText: m_sProgramTime
    popupSecondText : m_sProgramTitle
    popupThirdText : m_sProgramdDscription

    popupFirstBtnText: m_sButtonName == stringInfo.strEPGPopup_Cancel? stringInfo.strEPGPopup_CancelTimer : m_sButtonName //stringInfo.strEPGPopup_Cancel : m_sButtonName
    popupSecondBtnText:  stringInfo.strEPGPopup_Close

    onPopupFirstBtnClicked:{
        console.log("[QML] DABInfoEPGDescPopup.qml : onFirstBtnClicked : ButtonName = " + m_sButtonName);
        if(m_sButtonName == stringInfo.strEPGPopup_Listen) // listen to current Program
        {
            if( false == isCurrentCheckTime(m_iHour, m_iMinute, m_iSecond, m_iDuration)){
                gotoBackScreen();
                setAppMainScreen("DabInfoEPGPreserveOffAirPopup", true);
            }
            else {
                MDabOperation.CmdSetCurrentChannelInfo(m_sProgramServiceID);
                gotoMainScreen();
            }
        }
        else if(m_sButtonName == stringInfo.strEPGPopup_Cancel)
        {
            MDabOperation.CmdCancelEPGReservation(m_sProgramServiceID)
        }
        else if(m_sButtonName == stringInfo.strEPGPopup_Timer) // This program is preserve
        {
            MDabOperation.CmdAddEPGReservation(m_xCurrentDate, m_sProgramServiceName, m_sProgramServiceID,m_sProgramTitle,m_sProgramdDscription,m_iHour,m_iMinute,m_iSecond, m_iDuration)
        }
    }

    onPopupSecondBtnClicked : {
        console.log("[QML] DABInfoEPGDescPopup.qml : onSecondBtnClicked");
        gotoBackScreen();
    }

    onHardBackKeyClicked : {
        console.log("[QML] DABInfoEPGDescPopup.qml : onHardBackKeyClicked");
        gotoBackScreen();
    }

    function isCurrentCheckTime(hour, minute, second, duration)
    {
        //current time....
        var sTime = new Date(0,0,0,hour, minute, second);
        var startTime = Qt.formatTime(sTime, "hhmmss")
        var eTime = new Date(0,0,0,hour, minute, parseInt(second)+parseInt(duration));
        var stopTime =  Qt.formatTime(eTime, "hhmmss")
        var temp = new Date(0,0,0,0,0,0);
        var tempTime =  Qt.formatTime(temp, "hhmmss")
        console.log(" [isCurrentCheckTime] start:   " +startTime + " - " + stopTime);

        var nowDate = new Date();
        var cTime = Qt.formatTime(nowDate, "hhmmss")

        if(stopTime == tempTime)
        {
            eTime = new Date(0,0,0,23,59,59);
            var stopTime =  Qt.formatTime(eTime, "hhmmss")
        }

        if(cTime > startTime && cTime <= stopTime)
        {
            console.log(" [isCurrentCheckTime] cTime: " + cTime + " OnAir!!!!!!!")
            return true;
        }
        console.log(" [isCurrentCheckTime] cTime: " + cTime)
        return false;
    }

    Connections {
        target: DABController
        onCmdReservationCountFull:{
            console.log("[QML] ==> Connections : DABInfoEPGDescPopup.qml : onReservationCountFull : ");
            gotoBackScreen();
            setAppMainScreen("DabInfoEPGPreserveFullPopup", true);
        }      
    }

    Connections {
        target: AppUIListener
        onCloseEPGDescPopup:{
            console.log("[QML] ==> Connections : DABInfoEPGDescPopup.qml : AppUIListener::onCloseEPGDescPopup ");
            gotoBackScreen();
        }
    } 
}
