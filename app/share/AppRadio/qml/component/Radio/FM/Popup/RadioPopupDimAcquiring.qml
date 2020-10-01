/**
 * FileName: RadioRdsPopupDimAcquiring.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */

import Qt 4.7
import "../../../system/DH" as MSystem
import "../../../QML/DH" as MComp
//import "../../../../component/Radio/FM" as MRadio

MComp.MPopupTypeToast{//MDimPopup{
    id: idRadioPopupDimAcquiring
    focus: true
    //MRadio.RadioStringInfo{ id: stringInfo }

    popupFirstText     : idAppMain.toastMessage
    popupLoadingFlag   : false
    popupLineCnt       : 1  //# count of line(1 or 2)

    onPopupBgClicked:{ // JSH 131016
        console.log("## Popup Bg Clicked ##")
        gotoBackScreen();
    }
    onPopupClicked: {
        console.log("## Popup clicked ##")
        gotoBackScreen();
    }
    onHardBackKeyClicked:{
        console.log("## HardBackKey clicked ##")
        gotoBackScreen();
    }
    onVisibleChanged: {
        if(visible && (!popupLoadingFlag)){
            timer.restart();
        }
        //// 20130607 added by qutiguy - ITS - 0172533.
        if(visible)
            idAppMain.blockCueMovement = true
        else
            idAppMain.blockCueMovement = false
        ////
    }
    Timer{
        id:timer
        interval: 2000; running: false; repeat: false
        onTriggered: {
            if(idRadioPopupDimAcquiring.visible)
                idAppMain.gotoBackScreen();
        }
    }
}
