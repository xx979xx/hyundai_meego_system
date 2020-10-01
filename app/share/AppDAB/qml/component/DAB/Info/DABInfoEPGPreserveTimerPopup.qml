/**
 * FileName: DABInfoEPGPreserveTimerPopup.qml
 * Author: DaeHyungE
 * Time: 2012-07-25
 *
 * - 2012-07-25 Initial Crated by HyungE
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation


MComp.MPreservedPopup {
    id : idDabInfoEPGPreserveTimerPopup
    focus : true

    property string title     : stringInfo.strDABPopup_Timer
    property string descText1 : stringInfo.strEPG_ReservedProgram
    property string descText3 : stringInfo.strEPG_IsNowPlaying
    property string listen    : stringInfo.strEPGPopup_Listen
    property string cancel    : stringInfo.strEPGPopup_Cancel

    programTitleText : title
    programDescText1 : descText1
    programDescText2 : m_sPreservedProgramTitle
    programDescText3 : descText3
    firstBtnText     : listen
    secondBtnText    : cancel

    onFirstBtnClicked : {
        console.log("[QML] DABInfoEPGPreserveTimerPopup.qml : onFirstBtnClicked : m_iPreservedServiceID = " + m_iPreservedServiceID);
        MDabOperation.CmdSetCurrentChannelInfo(m_iPreservedServiceID);
        gotoMainScreen();
    }

    onSecondBtnClicked : {
        console.log("[QML] DABInfoEPGPreserveTimerPopup.qml : onSecondBtnClicked");
        gotoBackScreen();
    }

    onHardBackKeyClicked : {
        console.log("[QML] DABInfoEPGPreserveTimerPopup.qml : onBackKeyClicked");
    }
}
