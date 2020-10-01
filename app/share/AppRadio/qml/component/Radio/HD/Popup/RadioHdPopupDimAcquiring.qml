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
import "../../../../component/Radio/HD" as MRadio

MComp.MPopupTypeToast{//MDimPopup{
    id: idRadioHdPopupDimAcquiring
    focus: true
    MRadio.RadioHdStringInfo{ id: stringInfo }

    popupLineCnt  : idAppMain.toastMessageSecondText == "" ? 1 : 2 //# count of line(1 or 2)
    popupFirstText      : idAppMain.toastMessage// stringInfo.strHDPopupAcquiring "Acquiring Signal..."
    popupSecondText     : idAppMain.toastMessageSecondText
    //popupLoadingFlag    : (idAppMain.toastMessage == stringInfo.strHDPopupAcquiring) || (idAppMain.toastMessage == stringInfo.strHDPopupLinking) ? true :false // JSH 130522 [does not use popupLoadingFlag]

    onPopupBgClicked:{ // JSH 131016
        console.log("## Popup Bg Clicked ##")
        gotoBackScreen();
    }
    onPopupClicked: {
        console.log("## Popup clicked ##")
        //QmlController.acquireStop();

        ///////////////////////////////////////////////////
        // JSH 130522 [does not use popupLoadingFlag]
        // Analog Radio change
        //        if(popupLoadingFlag){
        //            if(idAppMain.globalSelectedBand == "FM1" || idAppMain.globalSelectedBand == "FM2")
        //                QmlController.setRadioFreq(globalSelectedFmFrequency);
        //             else if(idAppMain.globalSelectedBand == "AM")
        //                QmlController.setRadioFreq(globalSelectedAmFrequency);
        //        }
        gotoBackScreen();
    }
    onHardBackKeyClicked:{
        console.log("## HardBackKey clicked ##")
        gotoBackScreen();
    }
    onVisibleChanged: {
        if(visible)
            timer.restart();
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
        onTriggered:{
            if(idRadioHdPopupDimAcquiring.visible)
                idAppMain.gotoBackScreen();

            //idAppMain.toastMessage              = ""
            //idAppMain.toastMessageSecondText    = ""
        }
    }
}
