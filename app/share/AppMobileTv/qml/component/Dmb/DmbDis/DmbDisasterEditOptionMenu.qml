import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

//**************************************** Dmb Player OptionMenu
MComp.MOptionMenu{
    id:idDmbDisasterEditOptionMenu
    focus: true

    linkedModels: ListModel{
        id: idMenuListModel
        ListElement{ name: "Cancel"; opType: ""}
    }
    onMenu0Click:{
        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen();
            //gotoBackScreen();
        }
        else
        {
            gotoBackScreen();
            EngineListener.selectDisasterEvent(3/*Ck List - OptionMenu*/)
        }

    }

    onClickMenuKey: idDmbDisasterEditOptionMenu.hideOptionMenu();
    onBackKeyPressed: idDmbDisasterEditOptionMenu.hideOptionMenu();
//    onLeftKeyReleased: idDmbDisasterEditOptionMenu.hideOptionMenu();

    function setModelString(){
        var i;
        for(i = 0; i < idMenuListModel.count; i++)
        {
            //console.log("["+i+"]:" + idMenuListModel.get(i).name);
            switch(i){
            case 0:{
                idMenuListModel.get(i).name = stringInfo.strDmbDis_Option_Cancel
                break;
            }
            default:
                break;
            }
        }
    }

    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: EngineListener
        onRetranslateUi: setModelString()
    }

//    onSeekPrevKeyReleased:  { gotoBackScreen(); idAppMain.dmbSeekPrevKeyPressed()  }
//    onSeekNextKeyReleased:  { gotoBackScreen(); idAppMain.dmbSeekNextKeyPressed()  }
//    onTuneLeftKeyPressed:  { gotoBackScreen(); idAppMain.dmbTuneLeftKeyPressed()  }
//    onTuneRightKeyPressed: { gotoBackScreen(); idAppMain.dmbTuneRightKeyPressed() }

    onSeekPrevKeyReleased:  { idAppMain.dmbSeekPrevKeyPressed()  }
    onSeekNextKeyReleased:  { idAppMain.dmbSeekNextKeyPressed()  }
    onTuneLeftKeyPressed:  { idAppMain.dmbTuneLeftKeyPressed()  }
    onTuneRightKeyPressed: { idAppMain.dmbTuneRightKeyPressed() }

    onTuneEnterKeyPressed:{

        if(idAppMain.state != "AppDmbDisasterEditOptionMenu") return;

        //if(EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == true && EngineListener.m_ScreentSettingMode == true))
        if( EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == false && EngineListener.getShowOSDFrontRear() == true) )
        {
            EngineListener.SetExternal()
            return;
        }
    }

    Connections{
        target: idAppMain
        onSignalHideOptionMenu:{
            if(idAppMain.state == "AppDmbDisasterEditOptionMenu"){
                idDmbDisasterEditOptionMenu.hideOptionMenu();
            }
        }
    }

}
