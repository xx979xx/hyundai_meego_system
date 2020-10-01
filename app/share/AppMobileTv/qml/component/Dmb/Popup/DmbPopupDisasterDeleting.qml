import QtQuick 1.0
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MProgressPopup {
    id: idPopupDisasterDeleting
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    progressFirstText: stringInfo.strPOPUP_Deleting1
    progressSecondText: persent + stringInfo.strPOPUP_Deleting2
    delCnt: popupDelCnt

    property int popupDelCnt : 0

    onCancelClicked:{
        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
        }
        else
        {
            EngineListener.selectOptionMenuByIndex(6/*Back */);
        }
    }

    Component.onCompleted:{
         //console.log(" #[PopupDisasterDeleting] popupDelCnt : ", popupDelCnt)
         idPopupDisasterDeleting.totalCnt = MDmbOperation.CmdReqAMASMessageRowCount()
    }

    onSeekPrevKeyReleased:  { idAppMain.dmbSeekPrevKeyPressed()  }
    onSeekNextKeyReleased:  { idAppMain.dmbSeekNextKeyPressed()  }
    onTuneLeftKeyPressed:  { idAppMain.dmbTuneLeftKeyPressed()  }
    onTuneRightKeyPressed: { idAppMain.dmbTuneRightKeyPressed() }

    Connections{
        target: idAppMain
        onDisasterListCountChanged:{
            popupDelCnt = count
            //console.log(" # [PopupDisasterDeleting][onDisasterListCountChanged] delCnt: " + delCnt +", persent: " + persent);

            if(delCnt == 0){ // persent == 100
                setAppMainScreen("PopupDeleted", false)
            }
        }
    }
}
