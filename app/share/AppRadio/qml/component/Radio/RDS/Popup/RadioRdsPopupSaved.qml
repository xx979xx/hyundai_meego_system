/**
 * FileName: RadioRdsPopupSaved.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 * - 2013.05.27 modificed by qutiguy.
 */

import Qt 4.7
import "../../../system/DH" as MSystem
import "../../../QML/DH" as MComp
import "../../../../component/Radio/RDS" as MRadio

MComp.MPopupTypeToast{
    id: idRdsRadioPopupSaved
    focus: true
    MRadio.RadioRdsStringInfo{ id: stringInfo }

    popupFirstText :  stringInfo.strRDSLabelSave
    popupLoadingFlag   : false
    popupLineCnt       : 1  //# count of line(1 or 2)

    onPopupClicked: {
        console.log("## Popup clicked ##")
        gotoBackScreen();
    }
    onHardBackKeyClicked:{
        console.log("## HardBackKey clicked ##")
        gotoBackScreen();
    }
    onVisibleChanged: {
        if(visible && (!popupLoadingFlag))
            timer.restart();
    }
    Timer{
        id:timer
        interval: 1000; running: false; repeat: false
        onTriggered: {
            if(idRdsRadioPopupSaved.visible)
                gotoBackScreen();
            setAppMainScreen( "AppRadioRdsMain" , false);
        }
    }
}
