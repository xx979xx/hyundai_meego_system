import Qt 4.7
import "../Component" as MComp
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
MComp.MComponent{
    id: idVerCompMain
    x:0; y:0
    width:  1280
    height:  640
    focus:  true
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
        versionCompBand.backKeyButton.forceActiveFocus()


    }
    onBackKeyPressed: {
        mainViewState="Main"
        setMainAppScreen("", true)
        mainViewState = "AutoTest"
        setMainAppScreen("AutoTest", false)
    }

    MComp.MBand{
        id:versionCompBand
        y:0
        titleText: qsTr("Engineering Mode > Version ComPare")
        subBtnFlag:  true
        subKeyText: "Refresh"
        onSubKeyClicked: {
            sendRequest.SendReqSignal();
            sendBTRequest.SendBTReqSignal();
            SendDeckSignal.sendDeckSignal();
            reqVersion.SendReqVer();
            CanDataConnect.RequestCANData()
            VariantSetting.reqGPSVersion();
            SystemInfo.getBiosVersion();
            idRefreshVerCompare.visible = true
            UIListener.clearVersionCompareModel();
        }
        onBackKeyClicked: {
            mainViewState="Main"
            setMainAppScreen("", true)
            mainViewState = "AutoTest"
            setMainAppScreen("AutoTest", false)
        }
        onWheelLeftKeyPressed: {
            if(versionCompBand.backKeyButton.focus == true)
                versionCompBand.bandSubButton.forceActiveFocus()
            else
                versionCompBand.backKeyButton.forceActiveFocus()
        }
        onWheelRightKeyPressed: {
            if(versionCompBand.backKeyButton.focus == true)
                versionCompBand.bandSubButton.forceActiveFocus()
            else
                versionCompBand.backKeyButton.forceActiveFocus()
        }
    }

    Engineer_VersionCompareListView{
        id: idENGModeListView
        x:20/*80*/; y:100
        width: 1260/*1200*/; height: 520
        visible: true
        Component.onCompleted:{

        }
    }

    Connections{
        target:UIListener
        onShowMainGUI:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                //added for BGFG structure
            }
            else
            {
                console.log("Enter Software Main Back Key or Click==============")
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){
                    console.log("Enter Simple Main Software :::")
                  //  idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main Software :::")
                      //idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
            }


        }
    }

    MComp.DimPopUp{
        id:idRefreshVerCompare
        textLineCount: 1
        loadingFlag: true
        firstText: "Request Version Information ..."
        visible: false
        z:100
        onVisibleChanged: {
            if(visible){

                idTimerRefreshVerCompare.start()
            }
        }

    }
    MComp.DimPopUp{
        id:idRefreshVerCompareEnd
        textLineCount: 1
        loadingFlag: false
        firstText: "Version Information Refresh END."
        visible: false
        z:100
        onVisibleChanged: { if(visible)idTimerVerCompareEnd.start()   }

    }
    Timer{
        id:idTimerRefreshVerCompare
        interval: 3000
        repeat:false
        onTriggered:
        {
            SystemInfo.CompareVersion();
            idRefreshVerCompare.visible = false
            idRefreshVerCompareEnd.visible = true
        }
    }
    Timer{
        id:idTimerVerCompareEnd
        interval: 2000
        repeat:false
        onTriggered:
        {
            idRefreshVerCompareEnd.visible =false
            UIListener.reqRefreshVersionCompare();
        }
    }
}
