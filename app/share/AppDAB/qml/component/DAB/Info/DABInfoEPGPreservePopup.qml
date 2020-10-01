/**
 * FileName: DABInfoEPGPreservePopup.qml
 * Author: DaeHyungE
 * Time: 2012-07-25
 *
 * - 2012-07-25 Initial Crated by HyungE
 */


import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation


MComp.MPopupTypeToast {
    id : idDabInfoEPGPreservePopup
    focus : true

    function initialize()
    {
        idDimPopupTimer.running = true
    }
    popupLineCnt: 1
    popupFirstText: (m_bIsPreserve == true) ? stringInfo.strEPGPopup_ThisProgramispreserved : stringInfo.strEPGPopup_ThisProgramiscanceled

    onPopupClicked: {
        idDimPopupTimer.running = false
        console.log("[QML] DABInfoEPGPreservePopup.qml : onPopupClicked")
        gotoBackScreen();
    }

    onClickOrKeySelected: {
        idDimPopupTimer.running = false
        console.log("[QML] DABInfoEPGPreservePopup.qml : onClickOrKeySelected")
        gotoBackScreen();
    }

    onHardBackKeyClicked:{
        idDimPopupTimer.running = false
        console.log("[QML] DABInfoEPGPreservePopup.qml : onHardBackKeyClicked")
        gotoBackScreen();
    }

    onVisibleChanged: {
        if(!visible)
            idDimPopupTimer.running = false
    }

    Timer {
        id: idDimPopupTimer
        interval: 3000
        running: true
        repeat: false
        onTriggered:
        {
            console.log("[QML] DABInfoEPGPreservePopup.qml : idDimPopupTimer")
            gotoBackScreen()
        }
    }
}
