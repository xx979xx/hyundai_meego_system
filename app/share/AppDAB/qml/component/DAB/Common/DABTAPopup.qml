import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation

MComp.MPopupTypeText {
    id : idDabTAPopup

    property bool onOff : false
    property string strHTML1 : "<center><span style='font-size:50pt'; style='color:#FAFAFA'>"
    property string strHTML2 : "</span><span style='font-size:36pt';style='color:#D4D4D4'><br>"
    property string strHTML3 : stringInfo.strTAPopup_TrafficAnnouncement + "</span></center>";
    property string strHTML4 : stringInfo.strPty_Alarm + "</span></center>";
    property string strTAMessage : strHTML1 + m_sAnnouncementServiceName + strHTML2 + strHTML3;
    property string stAlarmrMessage : strHTML1 + m_sAnnouncementServiceName + strHTML2 + strHTML4;

    focus           : true
    popupBtnCnt     : (m_sAnnouncementFlags == 2)? 2 : 1

    popupFirstBtnText: stringInfo.strEPGPopup_Cancel
    popupSecondBtnText: (m_sAnnouncementFlags == 2)? stringInfo.strTAPopup_TA_OFF : ""
    popupFirstText: (m_sAnnouncementFlags == 2)? strTAMessage : stAlarmrMessage

    onPopupFirstBtnClicked :{
        console.log("[QML] DABTAPopup.qml : onPopupFirstBtnClicked :");
        gotoBackScreen();
        onOff = false;
        MDabOperation.CmdReqAnnouncementStop(m_sAnnouncementFlags, onOff);
    }

    onPopupSecondBtnClicked :{
        console.log("[QML] DABTAPopup.qml : onPopupSecondBtnClicked :");
        onOff = true;
        gotoBackScreen();
        MDabOperation.CmdReqAnnouncementStop(m_sAnnouncementFlags, onOff);
    }

    onHardBackKeyClicked :{
        console.log("[QML] DABTAPopup.qml : onHardBackKeyClicked :");
        gotoBackScreen();
    }

    onVisibleChanged: {
        idDabTAPopup.giveFocus(1);
    }
}
