
import Qt 4.7
import QmlSimpleItems 1.0
import com.engineer.data 1.0


import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
MComp.MComponent
{
    id:idLogmain
    x: 0; y: 0
    width: 1280
    height: 720

    focus: true

    property int stateStartEndLog: UIListener.LoadSystemConfig(EngineerData.DB_START_END_LOG)
    property int stateDynamicLog: UIListener.LoadSystemConfig(EngineerData.DB_DYNAMIC_LOG)
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral

    property alias logCopyBtn : idSaveLogButton;
    property alias naviLogCopyBtn : idStartButton
    //property alias enableBtn : idEnableLogButton
    //property alias disableBtn : idDisableLogButton
    //property alias aflogcopyBtn: idLogSystemBand.bandLogSaveKey
    //property alias applyLogBtn: idLogSystemBand.bandSub2Button
    property bool isSystemLogCopy : false
    property bool isNaviLogCopy: false
    property bool isEnableLog : false
    property bool isDisableLog: false
    property bool isAfLog: false
    property bool isApplyLogLevel: false

    function setRightMenuScreen(index, save){
        MOp.setLogMain(index, save)
    }
    Component.onCompleted:{

        console.debug("Current StateDynamicLog Value ::::" + stateDynamicLog)
        //LogSettingData.Initilize(); //delete for ITS 249868 Log System UI Enter delay Issue
        //setRightMenuScreen(0, true)
        idSaveLogButton.focus =true
        idSaveLogButton.forceActiveFocus();
        //UIListener.LogToUART(false); //delete for ITS 249868 Log System UI Enter delay Issue

    }
    Connections{
        target:UIListener
        onShowMainGUI:{
            if(isMapCareMain)
            {
                if(isMapCareEx)
                {
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }

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
        //added for BGFG structure
        onHideGUI:{
            if(isMapCareMain)
            {
                if(isMapCareEx)
                {
                    console.log("[QML] LogSystem : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                }
                else
                {
                    console.log("[QML] LogSystem : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                }


            }

            console.log("[QML] LogSystem : onHideGUI --");
            isMapCareMain = false
            mainViewState="Main"
            setMainAppScreen("", true)
        }
        //added for BGFG structure
    }
    Connections{
        target: UpgradeVerInfo

        onShowHideLogLevelGUI:{
            if(state == 1){
                console.log("[QML] Show Log Level Setting GUI ------------");
                //idLogSystemList.visible = true;
            }
            else if(state == 0){
                console.log("[QML] Hide Log Level Setting GUI ------------");
                //idLogSystemList.visible = false;
            }

        }

    }

    MComp.MBand{
        id: idLogSystemBand
        y:parent.y
        titleText: qsTr("Dealer Mode > Log Setting")
        KeyNavigation.down: idSaveLogButton
        onWheelRightKeyPressed: {
            //if(idLogSystemBand.backKeyButton.focus == true){
            //    idLogSystemBand.bandLogSaveKey.forceActiveFocus()
            //}
            //else if(idLogSystemBand.bandLogSaveKey.focus == true){
            //    idLogSystemBand.backKeyButton.forceActiveFocus()
            //}

        }
        onWheelLeftKeyPressed: {
            //if(idLogSystemBand.backKeyButton.focus == true){
            //    idLogSystemBand.bandLogSaveKey.forceActiveFocus()
            //}
            //else if(idLogSystemBand.bandLogSaveKey.focus == true){
            //    idLogSystemBand.backKeyButton.forceActiveFocus()
            //}
        }

        onBackKeyClicked: {
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    console.log("[QML] Dealer Mode -> LogSystem: onBackKeyClicked -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    console.log("[QML] Dealer Mode -> LogSystem: onBackKeyClicked -----------")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                //added for BGFG structure
            }
            else
            {
                console.log("Enter LogSystem Main Back Key or Click==============")
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){
                    console.log("Enter Simple Main  :::")
                   // idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main  :::")
                     // idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
            }



        }
        subBtnFlag: false
        subBtnFlag1: false
        subBtnFlag2: false
        logSaveBtnFlag: false/*true*/
        //subKeyText: "Apply Log Level"
        //subKey2Text: "Apply Log Level";/*"Disable Log"*/
        subKey1Text: "App List 1"
        logSaveKeyText: "AF Log Copy"
        bandSubButtonWidth: 200
        bandSub1ButtonWidth: 150
        bandSub2ButtonWidth: 200
        bandSubButtonTextSize: 23
        bandSub1ButtonTextSize: 23
        bandSub2ButtonTextSize: 23
        bandSubButtonfirstTextX: 0
        bandSubButtonfirstTextWidth: 200
        bandSub2ButtonfirstTextWidth:200
        onSubKeyClicked: {

            //LogSettingData.ApplyLogLevel()
        }
        onSubKey1Clicked: {

        }
        onSubKey2Clicked: {

            //LogSettingData.ApplyLogLevel()

        }
        onLogSaveKeyClicked: {
                UpgradeVerInfo.startAFLogCopyPopUp();

        }
    }
    onBackKeyPressed: {
        if(isMapCareMain)
        {
            //added for BGFG structure
            if(isMapCareEx)
            {
                console.log("[QML] Dealer Mode -> LogSystem: onBackKeyClicked -----------")
                mainViewState = "MapCareMainEx"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            else
            {
                console.log("[QML] Dealer Mode -> LogSystem: onBackKeyClicked -----------")
                mainViewState = "MapCareMain"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            //added for BGFG structure
        }
        else
        {
            console.log("Enter LogSystem Main Back Key or Click==============")
            mainViewState="Main"
            setMainAppScreen("", true)
            if(flagState == 0){
                console.log("Enter Simple Main  :::")
               // idMainView.visible = true
                idMainView.forceActiveFocus()

            }
            else if(flagState == 9){
                  console.log("Enter Full Main  :::")
                 // idFullMainView.visible = true
                  idFullMainView.forceActiveFocus()
            }
        }


    }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo{ id : colorInfo }

    Rectangle{
        id:idBorderLogSystem
        x:10; y:80
        width:/*460*/220
        height:140
        color:colorInfo.transparent
        border.color : colorInfo.buttonGrey
        border.width : 4

        Text{
            id:logSystem_text
            height:50
            x: 10 ; y:0
            font.family: UIListener.getFont(false) //"Calibri"
            font.pixelSize: 20
            color:colorInfo.brightGrey
            text: qsTr("Log System")
            verticalAlignment: Text.AlignVCenter
        }
        MComp.MButtonTouch {
            id:idSaveLogButton
            x: 10; y: 55
            width:150; height:80
            focus: true
            firstText: "Copy Log"
            firstTextX: 20
            firstTextY: 30//40
            firstTextWidth: 150
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 25
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.right:{
                //idLogSystemList.focus = true
                //idLogSystemList.forceActiveFocus()
                //idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idStartButton.forceActiveFocus()
            onWheelRightKeyPressed: idClearLogButton.forceActiveFocus();/* idClearLogButton.forceActiveFocus()*/

            onClickOrKeySelected: {
                idSaveLogButton.forceActiveFocus()
                UpgradeVerInfo.startLogPopUp();
                isSystemLogCopy = true;

            }
        }
    }



    Rectangle{
        id:idBorderClearLog
        x:10; y:230
        width:220
        height:140
        color:colorInfo.transparent
        border.color : colorInfo.buttonGrey
        border.width : 4

        Text{
            id:clearLog_text
            height:50
            x: 10 ; y:0
            font.family: UIListener.getFont(false) //"Calibri"
            font.pixelSize: 20
            color:colorInfo.brightGrey
            text: qsTr("Clear Log")
            verticalAlignment: Text.AlignVCenter
        }

        MComp.MButtonTouch {
            id:idClearLogButton
            x: 10; y: 55
            width:150; height:80
            firstText: "Clear Log"
            firstTextX: 20/*10*/
            firstTextY: 30//40
            firstTextWidth: 150
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 25
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"

            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""

            KeyNavigation.right:{
                //idLogSystemList.focus = true
                //idLogSystemList.forceActiveFocus()
                //idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idSaveLogButton.forceActiveFocus()
            onWheelRightKeyPressed: idStartButton.forceActiveFocus()

            onClickOrKeySelected: {
                idClearLogButton.forceActiveFocus()
                  if(stateDynamicLog != 1)
                        UpgradeVerInfo.clearLogFile()
            }
        }


    }
    Rectangle{
        id:idBorderStartEndLog
        x:240; y:230
        width:220
        height:140
        color:colorInfo.transparent
        border.color : colorInfo.buttonGrey
        border.width : 4

        Text{
            id:startEndLog_text
            height:50
            x: 10 ; y:0
            font.family: UIListener.getFont(false) //"Calibri"
            font.pixelSize: 20
            color:colorInfo.brightGrey
            text: qsTr("Copy Navi Log")
            verticalAlignment: Text.AlignVCenter
        }
        MComp.MButtonTouch {
            id:idStartButton
            x: 10; y: 55
            width:150; height:80
            firstText:"Copy" /*stateStartEndLog ? "End": "Start"*/
            firstTextX: 40/*20*/
            firstTextY: 30//40
            firstTextWidth: 150
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 25
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"

            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""

            KeyNavigation.right:{
                //idLogSystemList.focus = true
                //idLogSystemList.forceActiveFocus()
                //idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }

            onWheelLeftKeyPressed: idClearLogButton.forceActiveFocus()
            onWheelRightKeyPressed: idSaveLogButton.forceActiveFocus()

            onClickOrKeySelected: {
                idStartButton.forceActiveFocus()
                UpgradeVerInfo.startNaviLogPopUp();
                isNaviLogCopy = true

            }
        }
    }



  Engineer_LogSavePopUp{
      id:idENGSaveLogPopUp
      y:0; z:100
      visible: false

      onVisibleChanged: {


      }

  }

}








