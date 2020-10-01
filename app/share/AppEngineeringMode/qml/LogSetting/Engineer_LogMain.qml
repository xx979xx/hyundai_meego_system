
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
    //clip:true
    focus: true

    property int stateStartEndLog: UIListener.LoadSystemConfig(EngineerData.DB_START_END_LOG)
    property int stateDynamicLog: UIListener.LoadSystemConfig(EngineerData.DB_DYNAMIC_LOG)
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral

    property alias logCopyBtn : idSaveLogButton;
    property alias naviLogCopyBtn : idStartButton
    property alias enableBtn : idEnableLogButton
    property alias disableBtn : idDisableLogButton
    property alias aflogcopyBtn: idLogSystemBand.bandLogSaveKey
    property alias applyLogBtn: idLogSystemBand.bandSub2Button
    property bool isSystemLogCopy : false
    property bool isNaviLogCopy: false
    property bool isEnableLog : false
    property bool isDisableLog: false
    property bool isAfLog: false
    property bool isApplyLogLevel: false

    function setRightMenuScreen(index, save){
        MOp. setLogMain(index, save)
    }
    Component.onCompleted:{
        //console.debug("Current StateStartEndLog Value :::: " + stateStartEndLog)
        console.debug("Current StateDynamicLog Value ::::" + stateDynamicLog)
        LogSettingData.Initilize();
        setRightMenuScreen(0, true)
        idSaveLogButton.focus =true
        idSaveLogButton.forceActiveFocus();
        //UIListener.LogToUART(false); //delete for ITS 249868 Log System UI Enter delay Issue

    }
    Connections{
        target:UIListener
        onShowMainGUI:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    //console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    //console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
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
                idLogSystemList.visible = true;
            }
            else if(state == 0){
                console.log("[QML] Hide Log Level Setting GUI ------------");
                idLogSystemList.visible = false;
            }

        }

    }

    MComp.MBand{
        id: idLogSystemBand
        y:parent.y
        titleText: qsTr("Engineering Mode > Log Setting")
        KeyNavigation.down: idSaveLogButton
        onWheelRightKeyPressed: {
            if(idLogSystemBand.backKeyButton.focus == true){
                idLogSystemBand.bandLogSaveKey.forceActiveFocus()
            }
            else if(idLogSystemBand.bandSub2Button.focus == true){
                idLogSystemBand.backKeyButton.forceActiveFocus()
            }
            else if(idLogSystemBand.bandLogSaveKey.focus == true){
                idLogSystemBand.bandSub2Button.forceActiveFocus()
            }

        }
        onWheelLeftKeyPressed: {
            if(idLogSystemBand.backKeyButton.focus == true){
                idLogSystemBand.bandSub2Button.forceActiveFocus()
            }
            else if(idLogSystemBand.bandSub2Button.focus == true){
                idLogSystemBand.bandLogSaveKey.forceActiveFocus()
            }
            else if(idLogSystemBand.bandLogSaveKey.focus == true){
                idLogSystemBand.backKeyButton.forceActiveFocus()
            }
        }

        onBackKeyClicked: {
            if(isMapCareMain)
            {
                //added for BGFG structure
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
                //added for BGFG structure
            }
            else
            {
                console.log("Enter LogSystem Main Back Key or Click==============")
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){
                    console.log("Enter Simple Main  :::")
                    //idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main  :::")
                        //idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
            }



        }
        subBtnFlag: false
        subBtnFlag1: false
        subBtnFlag2: true
        logSaveBtnFlag: true
        subKeyText: "Apply Log Level"
        subKey2Text: "Apply Log Level";/*"Disable Log"*/
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
            //setRightMenuScreen(2, true)
            //LogSettingData.EnableAllLog()
            //setLogLevelPopUp = true;
            isApplyLogLevel = true
            LogSettingData.ApplyLogLevel()
        }
        onSubKey1Clicked: {
            //setRightMenuScreen(0, true)
        }
        onSubKey2Clicked: {
            //setRightMenuScreen(1, true)
            isApplyLogLevel = true
            LogSettingData.ApplyLogLevel()
            //LogSettingData.DisableAllLog();
        }
        onLogSaveKeyClicked: {
            isAfLog = true
            UpgradeVerInfo.startAFLogCopyPopUp();
            //UpgradeVerInfo.readUpgradeInfo();

        }
    }
    onBackKeyPressed: {
        if(isMapCareMain)
        {
            //added for BGFG structure
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
            //added for BGFG structure
        }
        else
        {
            console.log("Enter LogSystem Main Back Key or Click==============")
            mainViewState="Main"
            setMainAppScreen("", true)
            if(flagState == 0){
                console.log("Enter Simple Main  :::")
               //idMainView.visible = true
                idMainView.forceActiveFocus()

            }
            else if(flagState == 9){
                  console.log("Enter Full Main  :::")
                 //idFullMainView.visible = true
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
            firstTextY: 30/*40*/
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idAppList8Button.forceActiveFocus()
            onWheelRightKeyPressed: idEnableLogButton.forceActiveFocus();/* idClearLogButton.forceActiveFocus()*/

            onClickOrKeySelected: {
                    idSaveLogButton.forceActiveFocus()
                    UpgradeVerInfo.startLogPopUp();
                    isSystemLogCopy = true;

            }
        }
    }
    // { delete Log To UART Function 13.11.14

    //    Rectangle{
    //        id:idBorderDynamicLog
    //        x:240; y:80
    //        width:230
    //        height:140
    //        color:colorInfo.transparent
    //        border.color : colorInfo.buttonGrey
    //        border.width : 4
    //        Text{
    //            id:dynamicLog_text
    //            height:50
    //            x: 10 ; y:0
    //            font.family: UIListener.getFont(false) //"Calibri"
    //            font.pixelSize: 20
    //            color:colorInfo.brightGrey
    //            text: qsTr("Log to UART")
    //            verticalAlignment: Text.AlignVCenter
    //        }
    //        MComp.MButtonTouch {
    //            id:idLogtoUSBEnDisButton
    //            x: 10; y: 55
    //            width:150; height:80
    //            firstText: ""
    //            firstTextX: 30
    //            firstTextY: 40
    //            firstTextWidth: 150
    //            firstTextColor: colorInfo.brightGrey
    //            firstTextSelectedColor: colorInfo.brightGrey
    //            firstTextSize: 25
    //            firstTextStyle: "HDB"

    //             bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    //             bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"

    //            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    //            fgImage: ""
    //            fgImageActive: ""

    //            KeyNavigation.right:{
    //                idLogSystemList.focus = true
    //                idLogSystemList.forceActiveFocus()
    //                idLogSystemList
    //            }

    //            KeyNavigation.up:{
    //                idLogSystemBand.backKeyButton.forceActiveFocus()
    //                idLogSystemBand
    //            }
    //            onWheelLeftKeyPressed: idSaveLogButton.forceActiveFocus()
    //            onWheelRightKeyPressed: idClearLogButton.forceActiveFocus()

    //            onClickOrKeySelected: {
    //                //case Enable Dynamic Log
    //                if(stateDynamicLog == 0){
    //                    stateDynamicLog =1;
    //                     UIListener.SaveSystemConfig(1 ,EngineerData.DB_DYNAMIC_LOG)
    //                     idLogtoUSBEnDisButton.firstText = "Disable"
    //                    idSaveLogButton.firstTextColor = colorInfo.grey
    //                    idSaveLogButton.bgImagePress = imgFolderNewGeneral + "btn_title_sub_n.png"
    ////                    idClearLogButton.firstTextColor = colorInfo.grey
    ////                    idClearLogButton.bgImagePress = imgFolderNewGeneral + "btn_title_sub_n.png"
    //                    UIListener.LogToUART(true);
    //                }
    //                //case Disable Dynamic Log
    //                else if(stateDynamicLog == 1){
    //                    stateDynamicLog =0;
    //                     UIListener.SaveSystemConfig(0 ,EngineerData.DB_DYNAMIC_LOG)
    //                    idLogtoUSBEnDisButton.firstText = "Enable"
    //                   idSaveLogButton.firstTextColor = colorInfo.brightGrey
    //                   idSaveLogButton.bgImagePress =imgFolderNewGeneral + "btn_title_sub_p.png"
    ////                   idClearLogButton.firstTextColor = colorInfo.brightGrey
    ////                   idClearLogButton.bgImagePress = imgFolderNewGeneral + "btn_title_sub_p.png"
    //                    UIListener.LogToUART(false);
    //                }

    //            }
    //        }
    //    }

    // } delete Log To UART Function 13.11.14

        Rectangle{
            id:idBorderDynamicLog
            x:240; y:80
            width:220
            height:140
            color:colorInfo.transparent
            border.color : colorInfo.buttonGrey
            border.width : 4

            MComp.MButtonTouch {
                id:idEnableLogButton
                x: 10; y: 5
                width:180; height:60
                firstText: "Enable Log"
                firstTextX: 20
                firstTextY: 20/*30*/
                firstTextWidth: 180
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
                    idLogSystemList.focus = true
                    idLogSystemList.forceActiveFocus()
                    idLogSystemList
                }

                KeyNavigation.up:{
                    idLogSystemBand.backKeyButton.forceActiveFocus()
                    idLogSystemBand
                }
                onWheelLeftKeyPressed: idSaveLogButton.forceActiveFocus();
                onWheelRightKeyPressed: idDisableLogButton.forceActiveFocus();

                onClickOrKeySelected: {
                    isEnableLog = true
                    idEnableLogButton.forceActiveFocus()
                    LogSettingData.EnableAllLog()
                }
            }

            MComp.MButtonTouch {
                id:idDisableLogButton
                x: 10; y: 75
                width:180; height:60
                firstText: "Disable Log"
                firstTextX: 20
                firstTextY: 20/*30*/
                firstTextWidth: 180
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
                    idLogSystemList.focus = true
                    idLogSystemList.forceActiveFocus()
                    idLogSystemList
                }

                KeyNavigation.up:{
                    idLogSystemBand.backKeyButton.forceActiveFocus()
                    idLogSystemBand
                }
                onWheelLeftKeyPressed: idEnableLogButton.forceActiveFocus();
                onWheelRightKeyPressed: idClearLogButton.forceActiveFocus();

                onClickOrKeySelected: {
                    isDisableLog = true
                    idDisableLogButton.forceActiveFocus()
                    LogSettingData.DisableAllLog()
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
            firstTextX: 10
            firstTextY: 30/*40*/
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idDisableLogButton.forceActiveFocus()
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
            firstTextX: 40
            firstTextY: 30/*40*/
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }

            onWheelLeftKeyPressed: idClearLogButton.forceActiveFocus()
            onWheelRightKeyPressed: idAppList1Button.forceActiveFocus()

            onClickOrKeySelected: {
                isNaviLogCopy = true
                idStartButton.forceActiveFocus()
                UpgradeVerInfo.startNaviLogPopUp();

                //                //case Start Log
                //                if(stateStartEndLog == 0){
                //                    stateStartEndLog  = 1;
                //                    UIListener.SaveSystemConfig(1 ,EngineerData.DB_START_END_LOG)
                //                    idStartButton.firstText = "END"
                //                }
                //                //case End Log
                //                else if(stateStartEndLog == 1){
                //                    stateStartEndLog  = 0;
                //                    UIListener.SaveSystemConfig(0 ,EngineerData.DB_START_END_LOG)
                //                    idStartButton.firstText = "Start"
                //                }

            }
        }
    }

  Rectangle{
        id:idBorderLogList
        x:10; y:380
        width:450
        height:240
        color:colorInfo.transparent
        border.color : colorInfo.buttonGrey
        border.width : 4

        Text{
            id:applicationList_text
            height:50
            x: 10 ; y:0
            font.family: UIListener.getFont(false) //"Calibri"
            font.pixelSize: 20
            color:colorInfo.brightGrey
            text: qsTr("Log Level Setting(Application List)")
            verticalAlignment: Text.AlignVCenter
        }
        MComp.MButtonTouch {
            id:idAppList1Button
            x: 10; y: 55
            width:90; height:80
            firstText: "List1"
            firstTextX: 10
            firstTextY: 30//40
            firstTextWidth: 90
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idStartButton.forceActiveFocus()
            onWheelRightKeyPressed: idAppList2Button.forceActiveFocus()

            onClickOrKeySelected: {
                idAppList1Button.forceActiveFocus()
                setRightMenuScreen(0, true)
            }
        }
        MComp.MButtonTouch {
            id:idAppList2Button
            x: 110; y: 55
            width:90; height:80
            firstText: "List2"
            firstTextX: 10
            firstTextY: 30//40
            firstTextWidth: 90
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idAppList1Button.forceActiveFocus()
            onWheelRightKeyPressed: idAppList3Button.forceActiveFocus()

            onClickOrKeySelected: {
                idAppList2Button.forceActiveFocus()
                setRightMenuScreen(1, true)
            }
        }
        MComp.MButtonTouch {
            id:idAppList3Button
            x: 210; y: 55
            width:90; height:80
            firstText: "List3"
            firstTextX: 10
            firstTextY: 30//40
            firstTextWidth: 90
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idAppList2Button.forceActiveFocus()
            onWheelRightKeyPressed: idAppList4Button.forceActiveFocus()

            onClickOrKeySelected: {
                idAppList3Button.forceActiveFocus()
                setRightMenuScreen(2, true)
            }
        }
        MComp.MButtonTouch {
            id:idAppList4Button
            x: 310; y: 55
            width:90; height:80
            firstText: "List4"
            firstTextX: 10
            firstTextY: 30//40
            firstTextWidth: 90
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idAppList3Button.forceActiveFocus()
            onWheelRightKeyPressed: idAppList5Button.forceActiveFocus()

            onClickOrKeySelected: {
                idAppList4Button.forceActiveFocus()
                setRightMenuScreen(3, true)
            }
        }
        Image{
            x:20
            y:140
            width:430
            source: imgFolderGeneral+"line_menu_list.png"
        }
        MComp.MButtonTouch {
            id:idAppList5Button
            x: 10; y: 150
            width:90; height:80
            firstText: "List5"
            firstTextX: 10
            firstTextY: 30//40
            firstTextWidth: 90
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idAppList4Button.forceActiveFocus()
            onWheelRightKeyPressed: idAppList6Button.forceActiveFocus()

            onClickOrKeySelected: {
                idAppList5Button.forceActiveFocus()
                setRightMenuScreen(4, true)
            }
        }
        MComp.MButtonTouch {
            id:idAppList6Button
            x: 110; y: 150
            width:90; height:80
            firstText: "List6"
            firstTextX: 10
            firstTextY: 30//40
            firstTextWidth: 90
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idAppList5Button.forceActiveFocus()
            onWheelRightKeyPressed: idAppList7Button.forceActiveFocus()

            onClickOrKeySelected: {
                idAppList6Button.forceActiveFocus()
                setRightMenuScreen(5, true)
            }
        }
        MComp.MButtonTouch {
            id:idAppList7Button
            x: 210; y: 150
            width:90; height:80
            firstText: "List7"
            firstTextX: 10
            firstTextY: 30//40
            firstTextWidth: 90
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idAppList6Button.forceActiveFocus()
            onWheelRightKeyPressed: idAppList8Button.forceActiveFocus()

            onClickOrKeySelected: {
                idAppList7Button.forceActiveFocus()
                setRightMenuScreen(6, true)
            }
        }
        MComp.MButtonTouch {
            id:idAppList8Button
            x: 310; y: 150
            width:90; height:80
            firstText: "List8"
            firstTextX: 10
            firstTextY: 30//40
            firstTextWidth: 90
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
                idLogSystemList.focus = true
                idLogSystemList.forceActiveFocus()
                idLogSystemList
            }

            KeyNavigation.up:{
                idLogSystemBand.backKeyButton.forceActiveFocus()
                idLogSystemBand
            }
            onWheelLeftKeyPressed: idAppList7Button.forceActiveFocus()
            onWheelRightKeyPressed: idSaveLogButton.forceActiveFocus()

            onClickOrKeySelected: {
                idAppList8Button.forceActiveFocus()
                setRightMenuScreen(7, true)
            }
        }

    }
  MComp.MComponent{
      id:idLogSystemList
      x: 480
      y:69
      focus: false

      Keys.onLeftPressed:{
          idSaveLogButton.focus = true
          idSaveLogButton.forceActiveFocus()
          idSaveLogButton
      }
      Keys.onUpPressed:{
          idLogSystemBand.backKeyButton.forceActiveFocus()
          idLogSystemBand
      }

      Rectangle{
          id:idBorderDataName
          x:0; y:10
          width:1280 -490
          height:540
          color:colorInfo.transparent
          border.color : colorInfo.buttonGrey
          border.width : 7
      }
      Loader{ id:idAppList1Loader   }
      Loader{   id:idAppList2Loader }
      Loader{   id:idAppList3Loader }
      Loader{   id:idAppList4Loader }
      Loader{   id:idAppList5Loader }
      Loader{   id:idAppList6Loader }
      Loader{    id:idAppList7Loader}
      Loader{   id:idAppList8Loader}
      Loader{   id:idAppListStartLoader}

  }
  Engineer_LogSavePopUp{
      id:idENGSaveLogPopUp
      y:0; z:100
      visible: false

      onVisibleChanged: {


      }

  }

}








