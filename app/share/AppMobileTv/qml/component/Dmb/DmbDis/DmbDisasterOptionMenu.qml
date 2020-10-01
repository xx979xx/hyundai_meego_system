import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

//**************************************** Dmb Player OptionMenu
MComp.MOptionMenu{
    id:idDmbDisasterOptionMenu
    focus: true

    linkedModels: ListModel{
        id: idMenuListModel
        ListElement{ name: "Delete"; opType: ""}
    }
    onMenu0Click:{ //"Delete"
        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen();
            setAppMainScreen("AppDmbDisaterListEdit", true)
        }
        else
        {
            EngineListener.selectDisasterEvent(2/*List - OptionMenu*/)
        }

    }

    onClickMenuKey: idDmbDisasterOptionMenu.hideOptionMenu();
    onBackKeyPressed: idDmbDisasterOptionMenu.hideOptionMenu();
//    onLeftKeyReleased: idDmbDisasterOptionMenu.hideOptionMenu();

    function setModelString(){
        var i;
        for(i = 0; i < idMenuListModel.count; i++)
        {
            //console.log("["+i+"]:" + idMenuListModel.get(i).name);
            switch(i){
            case 0:{
                idMenuListModel.get(i).name = stringInfo.strDmbDis_Option_Delete
                break;
            }
            default:
                break;
            }
        }
    }

    function chkDisasterInfoListCount(){
        if(MDmbOperation.CmdReqAMASMessageRowCount() > 0)
        {
            idDmbDisasterOptionMenu.menu0Enabled = true
        }
        else
        {
            idDmbDisasterOptionMenu.menu0Enabled = false
        }
    }

//    onSeekPrevKeyReleased:  { gotoBackScreen(); idAppMain.dmbSeekPrevKeyPressed()  }
//    onSeekNextKeyReleased:  { gotoBackScreen(); idAppMain.dmbSeekNextKeyPressed()  }
//    onTuneLeftKeyPressed:  { gotoBackScreen(); idAppMain.dmbTuneLeftKeyPressed()  }
//    onTuneRightKeyPressed: { gotoBackScreen(); idAppMain.dmbTuneRightKeyPressed() }

    onSeekPrevKeyReleased:  {  idAppMain.dmbSeekPrevKeyPressed()  }
    onSeekNextKeyReleased:  {  idAppMain.dmbSeekNextKeyPressed()  }
    onTuneLeftKeyPressed:  {  idAppMain.dmbTuneLeftKeyPressed()  }
    onTuneRightKeyPressed: {  idAppMain.dmbTuneRightKeyPressed() }

    onTuneEnterKeyPressed:{

        if(idAppMain.state != "AppDmbDisasterOptionMenu") return;

        //if(EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == true && EngineListener.m_ScreentSettingMode == true))
        if( EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == false && EngineListener.getShowOSDFrontRear() == true) )
        {
            EngineListener.SetExternal()
            return;
        }
    }

    onVisibleChanged: {
        if(idDmbDisasterOptionMenu.visible == true){
            chkDisasterInfoListCount()
        }
    }

    // Loading Completed!!
    Component.onCompleted:
    {
        setModelString()
        chkDisasterInfoListCount()
    }
    Connections{
        target: EngineListener
        onRetranslateUi: setModelString()
    }

    Connections{
        target: idAppMain
        onDisasterListCountChanged:{
            chkDisasterInfoListCount()
        }

        onSignalHideOptionMenu:{
            if(idAppMain.state == "AppDmbDisasterOptionMenu"){
                idDmbDisasterOptionMenu.hideOptionMenu();
            }
        }
    }
}
