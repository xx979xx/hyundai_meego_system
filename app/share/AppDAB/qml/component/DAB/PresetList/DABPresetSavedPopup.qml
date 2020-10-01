/**
 * FileName: DABPresetSavedPopup.qml
 * Author: HYANG
 * Time: 2013-1-29
 *
 * - 2013-01-29 Initial Created by HYANG
 */


import Qt 4.7
import "../../../component/QML/DH" as MComp

MComp.MPopupTypeToast{
    id : idDabPresetSavedPopup
    focus : true
    popupLineCnt: 1
    popupFirstText : stringInfo.strPresetPopup_Saved

    onHardBackKeyClicked: {
        console.log("[QML] DABPresetSavedPopup.qml : onHardBackKeyClicked")
        gotoBackScreen();
    }

    Timer {
        id: idToastPopupTimer
        interval: 1000
        running: true
        repeat: false
        onTriggered:
        {
            gotoMainScreen();
        }
    }

    function initialize()
    {
        idToastPopupTimer.running = true
    }
}

