import Qt 4.7
import Qt.labs.gestures 2.0

import "./Component" as MComp
import "./System" as MSystem
import "./Operation/operation.js" as MOp
import com.engineer.data 1.0
import QmlStatusBar 1.0
MComp.MAppMain {
    id: idAppMain
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+93
    //x:0;y:46
    x:0; y:0
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }

    property string mainViewState : "Main"
    property int flagState: 0
    property int variantValue: VariantSetting.variantInfo
    property string variantString: ""
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property alias stateStatusBar: statusBar
    property alias fullSoftButton: idFullMainView;
    property alias mainBg: bgImgEngineerMain
    property bool isLogCopying : false
    property bool isMapCareMain: false
    property bool isMapCareEx:true //added for BGFG structure


    signal mouseAreaExit();

    focus:true
    QmlStatusBar{
        id: statusBar
        x: 0
        y: 0
        z:1
        width: 1280
        height: 93
        homeType:"button"
        middleEast: false
        visible:true
    }
    Connections{
        target: VariantSetting
        onVariantInfoChanged:
        {
            console.debug("[QML] Receive Country Code Value ====" + currentVariant )
            if(currentVariant == 0){
                variantString = "DynamicKo"
            }
            else if(currentVariant == 1){
                variantString = "DynamicUS"
            }
            else if(currentVariant == 5){
                variantString = "DynamicEU"
            }
            else if(currentVariant == 6){
                variantString = "DynamicCA"
            }
            else if(currentVariant == 7)
            {
                variantString = "DynamicRUS"
            }

            //added for Australia variant
            else if(currentVariant == 0xA0){
                console.debug("[QML] Australia variant -----")
                variantString = "DynamicAUS"
            }

            else{
                variantString = "DynamicGE"
            }
        }

    }
    Connections{
        target:UIListener
        onFactoryResetFromQml:{
            console.log("[QML] Factory Reset : AUTO TEST, ACC Mode, Cursor, FAN Ctrl ----------")
            AutoTest.AgentOff();

            UIListener.NotifyApplication( 73 ,0 , "2 Pattern", 0)
            UIListener.voicePhoneBookPattern = 0
            UIListener.SaveSystemConfig(0, EngineerData.DB_PHONEBOOK_PATTERN);

            UIListener.SaveSystemConfig(0 ,EngineerData.DB_QEDEBUG_MSG_STATE)
            UIListener.mouseCursorEnDisable(false);
            UIListener.keyboardEnDisable(false);
            UIListener.SaveSystemConfig(0 ,EngineerData.DB_CURSOR_STATE)
            SystemControl.fanControl(0)
            UIListener.SaveSystemConfig(0 ,EngineerData.DB_FAN_CONTROL_STATE)
            MPMode.setMPMode( 0 )
            MPMode.setSteerWheelMode(0);
            UIListener.SaveSystemConfig(0 ,EngineerData.DB_ACCMODE_STATE)
            IPInfo.handleExecuteScriptOff(); //added fot DQMS Factory Reset Console Off Issue
            UpgradeVerInfo.clearLogFile()
        }
        //added for BGFG structure
        onShowMapCareGUI:{
            stateStatusBar.visible = true;
            if(variantValue == 5 || variantValue == 7 )
            {
                isMapCareEx = false
                isMapCareMain = true
                UIListener.printLogMessage("[QML] show MapCare GUI --");
                //console.log("[QML] show MapCare GUI --");
                mainViewState = "MapCareMain"
                setMainAppScreen("MapCareMain", false)
            }
            else
            {
                isMapCareEx = true
                isMapCareMain = true
                UIListener.printLogMessage("[QML] show MapCareEx GUI --");
                //console.log("[QML] show MapCareEx GUI --");
                mainViewState = "MapCareMainEx"
                setMainAppScreen("MapCareMainEx", false)
            }

        }
        //added for BGFG structure

        onShowMainGUI:{
            stateStatusBar.visible = true;
        }
    }

    onMainViewStateChanged:{
        if(mainViewState=="Main"&& flagState == 0){
            idMainView.forceActiveFocus();

        }else if(mainViewState=="Main"&& flagState == 9){
            idFullMainView.forceActiveFocus();
        }
        console.log ("[QML][file : ENGMain] mainView State : " + mainViewState +"  flagState: "+ flagState)
    }
    Component.onCompleted:{

        UIListener.autoTest_athenaSendObject();
        console.log("[QML] Current Country Code at Simple ENG Menu : " + variantValue);
        idMainView.forceActiveFocus();
        if(variantValue == 0){
            variantString = "DynamicKo"
        }
        else if(variantValue == 1){
            variantString = "DynamicUS"
        }
        else if(variantValue == 5){
            variantString = "DynamicEU"
        }
        else if(variantValue == 7)
        {
            variantString = "DynamicRUS"
        }

        //added for Australia variant
        else if(variantValue == 0xA0){
            console.debug("[QML] Australia variant -----")
            variantString = "DynamicAUS"
        }

        else{
            variantString = "DynamicGE"
        }

        mainButtonSoftware.focus = true
        mainButtonSoftware.forceActiveFocus();
    }
    function setMainAppScreen(screenName, save){
        MOp.setMainScreen(screenName,save);
    }



    //**************************************** Background
    Image{
        id:bgImgEngineerMain
        //y:10 //added for BGFG structure
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight+93
        source: imgFolderGeneral + "bg_type_b.png"
    }

    MComp.MComponent{

        id:idMainView
        visible: mainViewState=="Main"&& flagState == 0
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight+93
        clip:true
        focus:mainViewState=="Main"&& flagState == 0
        x:0; y:93
        Image {
            source:"/app/share/images/AppEngineeringMode/img/general/bg_home_sub_l.png"; /*"/app/share/images/home/bg_home_sub_s.png"*/
            width: systemInfo.lcdWidth
            height: systemInfo.lcdHeight+93
            x:0; y:-93
        }
        MComp.MBand{
            id:idEngineerMainBand
            //x:0; y:93
            titleText: qsTr("Engineering Mode")
            onBackKeyClicked: {
                UIListener.HandleBackKey();
            }
            KeyNavigation.down:{
                mainButtonSoftware
            }
        }

        MComp.MMainButton{
            id:mainButtonSoftware
            x: 120+96
            y: 165+46-93
            //x:166
            //y:221-93
            focus:true
            //buttonImage: "/app/share/images/home/ico_engineering_software_n.png"
            //buttonImagePress:"/app/share/images/home/ico_engineering_software_p.png"
            bgImage: "/app/share/images/home/ico_engineering_software_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_software_p.png"
            bgImageFocus:"/app/share/images/home/ico_engineering_software_p.png"
            bgImageActive: "/app/share/images/home/ico_engineering_software_p.png"
            firstText:"Software"
            onClickOrKeySelected: {
                mainButtonSoftware.forceActiveFocus()
                //mainButtonSoftware.focus = true
                mainViewState = "Software"
                //setMainAppScreen("Software", false)
               setMainAppScreen("Password", false)

            }

            KeyNavigation.up: {
                idEngineerMainBand.backKeyButton.forceActiveFocus()
                idEngineerMainBand
            }
            onWheelLeftKeyPressed: mainButtonUpdate.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonHardware.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonHardware
            x:96+120+156+163
            y: 165-93
            //x:126+40+369
            //y:185-93
            bgImage: "/app/share/images/home/ico_engineering_hardware_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_hardware_p.png"
            bgImageFocus: "/app/share/images/home/ico_engineering_hardware_p.png"
            bgImageActive:"/app/share/images/home/ico_engineering_hardware_p.png"
            firstText:"Hardware"
            onClickOrKeySelected: {
                mainButtonHardware.forceActiveFocus()
                //mainButtonHardware.focus = true
                mainViewState = "Hardware"
                //setMainAppScreen("Hardware", false)
                setMainAppScreen("Password", false)
            }
            KeyNavigation.up: {
                idEngineerMainBand.backKeyButton.forceActiveFocus()
                idEngineerMainBand
            }

            onWheelLeftKeyPressed: mainButtonSoftware.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonDynamics.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonDynamics
            x:96+120+156+163+161+156
            y:165+46-93
            //x:126+40+369+369
            //y:185+36-93
            bgImage: "/app/share/images/home/ico_engineering_dynamics_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_dynamics_p.png"
            bgImageFocus: "/app/share/images/home/ico_engineering_dynamics_p.png"
            bgImageActive: "/app/share/images/home/ico_engineering_dynamics_p.png"
            firstText:"Dynamics"
            onClickOrKeySelected: {
                mainButtonDynamics.forceActiveFocus()
                //mainBg.visible = false
                //mainButtonDynamics.focus = true
                mainViewState = "Dynamics"
                //setMainAppScreen(variantString, false)
                //mainBg.visible = true
                setMainAppScreen("Password", false)
            }
            KeyNavigation.up: {
                idEngineerMainBand.backKeyButton.forceActiveFocus()
                idEngineerMainBand
            }
            onWheelLeftKeyPressed: mainButtonHardware.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonFullENG.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonUpdate
            x:96
            y:165+46+180-93
            //x:126
            //y:185+36+200-93
            bgImage: "/app/share/images/home/ico_engineering_sw_update_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_sw_update_p.png"
            bgImageFocus: "/app/share/images/home/ico_engineering_sw_update_p.png"
            bgImageActive: "/app/share/images/home/ico_engineering_sw_update_p.png"
            firstText:"S/W Update"

            onClickOrKeySelected: {
                mainButtonUpdate.forceActiveFocus()
                //mainButtonUpdate.focus = true
                mainViewState = "Update"
                //setMainAppScreen("Update", false)
                setMainAppScreen("Password", false)

            }
            KeyNavigation.up: {
                idEngineerMainBand.backKeyButton.forceActiveFocus()
                idEngineerMainBand
            }
            onWheelLeftKeyPressed: mainButtonLogSystem.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonSoftware.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonLogSystem
            x:96+120+156
            y:165+46+180+96-93
            //x:126+40+369
            //y:185+36+200+76-93
            bgImage: "/app/share/images/home/ico_home_system_n.png"
            bgImagePress: "/app/share/images/home/ico_home_system_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_system_p.png"
            bgImageActive: "/app/share/images/home/ico_home_system_p.png"
            firstText:"Log System"

            onClickOrKeySelected: {
                mainButtonLogSystem.forceActiveFocus()
                UpgradeVerInfo.getFileSystemSize(2)
                mainViewState = "LogSetting"
                //setMainAppScreen("LogSetting", true)
                setMainAppScreen("Password", false)
            }
            KeyNavigation.up: {
                idEngineerMainBand.backKeyButton.forceActiveFocus()
                idEngineerMainBand
            }
            onWheelLeftKeyPressed: mainButtonEtcMenu.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonUpdate.forceActiveFocus()
        }

        MComp.MMainButton{
            id:mainButtonEtcMenu
            x:96+120+156+163+161
            y:165+46+180+96-93
            //x:126+40+369
            //y:185+36+200+76-93
            bgImage: "/app/share/images/home/ico_home_system_n.png"
            bgImagePress: "/app/share/images/home/ico_home_system_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_system_p.png"
            bgImageActive: "/app/share/images/home/ico_home_system_p.png"
            firstText:"ETC Menu"

            onClickOrKeySelected: {
                mainButtonEtcMenu.forceActiveFocus()
                SendDeckSignal.sendDeckSignal();
                SystemInfo.releaseVersionRead();
                SystemInfo.CompareVersion();
                mainViewState = "AutoTest"
                //setMainAppScreen("AutoTest", false)
                setMainAppScreen("Password", false)
            }
            KeyNavigation.up: {
                idEngineerMainBand.backKeyButton.forceActiveFocus()
                idEngineerMainBand
            }
            onWheelLeftKeyPressed: mainButtonFullENG.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonLogSystem.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonFullENG
            x:96+120+156+163+161+156+120
            y: 165+46+180-93
            //x:126+40+369+369+40
            //y:185+36+200-93
            bgImage: "/app/share/images/home/ico_engineering_full_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_full_p.png"
            bgImageFocus: "/app/share/images/home/ico_engineering_full_p.png"
            bgImageActive: "/app/share/images/home/ico_engineering_full_p.png"
            firstText:"Full ENG mode"
            //firstTextSize: 25
            onClickOrKeySelected: {
                mainButtonFullENG.forceActiveFocus()
                console.debug("Press or Click FULL ENG Button")
                mainButtonFullENG.focus = true
                mainViewState = "Password"
                setMainAppScreen("Password", false)
                SendDeckSignal.sendDeckSignal();
                SystemInfo.releaseVersionRead();
                SystemInfo.CompareVersion();
           }
            KeyNavigation.up: {
                idEngineerMainBand.backKeyButton.forceActiveFocus()
                idEngineerMainBand
            }
            onWheelLeftKeyPressed: mainButtonDynamics.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonEtcMenu.forceActiveFocus()
        }
        onBackKeyPressed: {
                UIListener.HandleBackKey();
        }
        onHomeKeyPressed: {
                UIListener.HandleBackKey();

        }
    }

       AppEngineer_FullMain{
           x:0; y:93
           id:idFullMainView
           visible: mainViewState=="Main" && flagState == 9
           width: systemInfo.lcdWidth
           height: systemInfo.lcdHeight +93
           clip:true
           focus:mainViewState=="Main" && flagState == 9
       }

    MComp.MComponent{
        id:idMainViewLoader
        x:0; y:93
        Loader{ id:idSoftwareMain;   }
        Loader{ id:idHardwareMain;   }
        Loader{ id:idDynamicsMain;  }
        Loader{ id:idUpdateMain;  }
        Loader{ id:idSystemConfigMain; }
        Loader{ id:idVariantMain;   }
        Loader{ id:idDiagnosisMain; }
        Loader{ id:idFullENGMain;   }
        Loader{ id:idPassWordMain; }
        Loader{ id:idDTCListMain;   }
        Loader{ id:idMostRBDMain;}
        Loader{ id:idAutoTestMain;  }
        Loader{ id:idAutoTestPage2Main;}
        Loader{ id:idIpConfigMain;  }
        Loader{ id:idVerCompareMain;}
        Loader{ id:idDynamicsSoundMain;  }
        Loader{ id:idLogSettingMain;  }
        Loader{ id:idRandomKeyTestMain; }
        Loader{ id:idTouchTestMain;}
        Loader{ id:idMapCareMain; } //added for BGFG structure


    }
    ///////Debug
    Rectangle{
        id:debugInfo
        width:300
        height:400
        x:systemInfo.lcdWidth-300
        y:systemInfo.lcdHeight-400
        color: "Black"
        opacity: 0.5
        visible: false
        //        Column{
        //            Text {
        //                text: "1. Country Code >>>> "+variantValue0
        //                color:"Yellow"
        //            }
        //            Text {
        //                text: "2. System Value 0 >>>> "+variantValue1
        //                color:"Yellow"
        //            }
        //            Text {
        //                text: "3. System Value 1 >>>> "+variantValue2
        //                color:"Yellow"
        //            }
        //            Text {
        //                text: "4. System Value 2 >>>> "+variantValue3
        //                color:"Yellow"
        //            }
        //            Text {
        //                text: "5. System Value 3 >>>> "+variantValue4
        //                color:"Yellow"
        //            }
        //            Text {
        //                text: "6. DVD Region Value >>>> "+variantValue5
        //                color:"Yellow"
        //            }
        //            Text {
        //                text: "7. DVD Menu Value 0 >>>> "+variantValue6
        //                color:"Yellow"
        //            }
        //            Text {
        //                text: "8. DVD Menu Value 1 >>>> "+variantValue7
        //                color:"Yellow"
        //            }
        //        }
    }

    MouseArea{
        width:20
        height:20
        x:systemInfo.lcdWidth-20
        y:systemInfo.lcdHeight-20
        onPressAndHold: {
            if(debugInfo.visible==false){
                debugInfo.visible=true
            }
            else{
                debugInfo.visible=false
            }
        }
    }

}
