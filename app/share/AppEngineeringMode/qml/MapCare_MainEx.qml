
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
    x:0; y:0
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }

    //property string mainViewState : "MapCareMain" //added for BGFG structure
    property alias mainBg: bgImgMapCareMain
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property bool isMapCareOn: false

    property int variantValue: VariantSetting.variantInfo
    //property bool isMapCareMain: true //added for BGFG structure
    function setMapCareUIScreen(screenName, save){
        MOp.setMapCareScreen(screenName, save);
    }

    signal mouseAreaExit();

    Connections{
        target:UIListener
        onBlockBackKeyAtDynamic:{
            console.debug("[QML] MapCare -> ENG Mode UI : Unblock Back Key");
            isMapCareOn = false;
        }

        //added for ITS 251370 Empty GUI Issue
        //added for BGFG structure
        onHideGUI:{
            if(isMapCareMain)
            {
                if(isMapCareEx)
                {
                    //console.log("[QML] HardwareMain : isMapCareMain: onHideGUI --");
                    UIListener.printLogMessage("[MapCare_MainEx] hideGUI")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                }
                else
                {
                    //console.log("[QML] HardwareMain : isMapCareMain: onHideGUI --");
                    UIListener.printLogMessage("[MapCare_MainEx] hideGUI: else")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                }

            }
            console.log("[QML] HardwareMain : onHideGUI --");
            isMapCareMain = false
            mainViewState="Main"
            setMainAppScreen("", true)

        }
        //added for BGFG structure
        //added for ITS 251370 Empty GUI Issue

        //added for BGFG structure
        //onHideGUI:{
        //    console.log("[QML] MapCareMain : onHideGUI --");
        //    isMapCareMain = false
        //    mainViewState="Main"
        //    setMainAppScreen("", true)
        //}
        //added for BGFG structure
    }

    focus:true
    /* //added for BGFG structure
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
    */ //added for BGFG structure

    /* //added for BGFG structure
    onMainViewStateChanged:{
        if(mainViewState == "MapCareMain")
        {
            idMapCareMainView.forceActiveFocus();
        }
    }
    */ //added for BGFG structure
    Component.onCompleted:{
        isMapCareMain = true; //added for BGFG structure
        UIListener.autoTest_athenaSendObject();
        idMapCareMainView.forceActiveFocus();
        mainButtonSoftware.focus = true
        mainButtonSoftware.forceActiveFocus();
        console.debug("[QML] Receive Country Code Value ====" + currentVariant )
    }

    //**************************************** Background
    Image{
        id:bgImgMapCareMain
        //y:10 //added for BGFG structure
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight+93
        source: imgFolderGeneral + "bg_type_b.png"
        visible: mainViewState == "MapCareMainEx" //added for BGFG structure
    }

    MComp.MComponent
    {
        id:idMapCareMainView
        visible: mainViewState=="MapCareMainEx" //added for BGFG structure
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight+93
        clip:true
        focus:  mainViewState=="MapCareMainEx" //added for BGFG structure
        //x:0; y:93 //added for BGFG structure
        x:0; y:0 //added for BGFG structure
        Image {
            source:"/app/share/images/AppEngineeringMode/img/general/bg_home_sub_l.png";
            width: systemInfo.lcdWidth
            height: systemInfo.lcdHeight+93
            x:0; y:-93
        }
        MComp.MBand{
            id:idMapCareMainBand
            titleText: qsTr("Dealer Mode")
            onBackKeyClicked: {
                if(!isMapCareOn){
                    isMapCareMain = false //added for BGFG structure
                    UIListener.DealerModeBackKey();
                }
            }
            KeyNavigation.down:{
                mainButtonSoftware
            }
        }



        MComp.MMainButton{
            id:mainButtonSoftware
            x:126+40; y:170+59-93
            focus:true
            bgImage: "/app/share/images/home/ico_engineering_software_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_software_p.png"
            bgImageFocus: "/app/share/images/home/ico_engineering_software_p.png"
            firstText:"Software"
            onClickOrKeySelected: {
                mainButtonSoftware.forceActiveFocus()
                mainViewState = "Software"
                setMapCareUIScreen("Password", false)
                //setMapCareUIScreen("Software", false)

            }
            KeyNavigation.up: {
                idMapCareMainBand.backKeyButton.forceActiveFocus()
                idMapCareMainBand
            }

            onWheelLeftKeyPressed: mainButtonLogSystem.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonHardware.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonHardware
            x:126+40+369; y:170-93

            bgImage: "/app/share/images/home/ico_engineering_hardware_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_hardware_p.png"
            bgImageFocus: "/app/share/images/home/ico_engineering_hardware_p.png"
            firstText:"Hardware"
            onClickOrKeySelected: {
                mainButtonHardware.forceActiveFocus()
                mainViewState = "Hardware"
                setMapCareUIScreen("Password", false)
                //setMapCareUIScreen("Hardware", false)
            }
            KeyNavigation.up: {
                idMapCareMainBand.backKeyButton.forceActiveFocus()
                idMapCareMainBand
            }
            onWheelLeftKeyPressed: mainButtonSoftware.forceActiveFocus()
            onWheelRightKeyPressed: idButtonDynamic.forceActiveFocus()
        }
        MComp.MMainButton{
            id:idButtonDynamic
            x:126+40+369+369
            y:170+59-systemInfo.statusBarHeight

            bgImage: "/app/share/images/home/ico_engineering_dynamics_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_dynamics_p.png"
            bgImageFocus: "/app/share/images/home/ico_engineering_dynamics_p.png"
            firstText:"Dynamic"
            onClickOrKeySelected: {
                idButtonDynamic.forceActiveFocus()
                //mainBg.visible = false
                //idButtonDynamic.focus = true

                mainViewState = "Dynamics"
                setMapCareUIScreen("Password", false)
                //setMapCareUIScreen("Dynamics", false)

                //mainBg.visible = true

            }
            KeyNavigation.up: {
                idMapCareMainBand.backKeyButton.forceActiveFocus()
                idMapCareMainBand
            }
            onWheelLeftKeyPressed: mainButtonHardware.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonVariant.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonVariant
            x:126+40+369+369+40
            y:170+59+218-systemInfo.statusBarHeight

            bgImage: "/app/share/images/home/ico_engineering_variant_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_variant_p.png"
            bgImageFocus: "/app/share/images/home/ico_engineering_variant_p.png"
            firstText:"Variant"
            onClickOrKeySelected: {
                mainButtonVariant.forceActiveFocus()
                mainViewState = "Variant"
                setMapCareUIScreen("Password", false)

            }
            KeyNavigation.up: {
                idMapCareMainBand.backKeyButton.forceActiveFocus()
                idMapCareMainBand
            }
            onWheelLeftKeyPressed: idButtonDynamic.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonDiagnostic.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonDiagnostic
            x:126+40+369
            y:170+59+218+84-systemInfo.statusBarHeight

            bgImage: "/app/share/images/home/ico_engineering_diagnostic_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_diagnostic_p.png"
            bgImageFocus:"/app/share/images/home/ico_engineering_diagnostic_p.png"
            firstText:"Diagnostic"
            onClickOrKeySelected: {
                mainButtonDiagnostic.forceActiveFocus()
                //CpuDegree.startGetDegree();
                mainButtonDiagnostic.focus = true
                mainViewState = "Diagnosis"
                setMapCareUIScreen("Password", false)
                //setMapCareUIScreen("Diagnosis", false)

            }
            KeyNavigation.up: {
                idMapCareMainBand.backKeyButton.forceActiveFocus()
                idMapCareMainBand
            }
            onWheelLeftKeyPressed: mainButtonVariant.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonLogSystem.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonLogSystem
            x:126
            y:170+59+218 -systemInfo.statusBarHeight

            bgImage: "/app/share/images/home/ico_home_system_n.png"
            bgImagePress: "/app/share/images/home/ico_home_system_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_system_p.png"
            firstText:"Log System"

            onClickOrKeySelected: {
                mainButtonLogSystem.forceActiveFocus()
                UpgradeVerInfo.getFileSystemSize(2)
                mainViewState = "LogSetting"

                setMapCareUIScreen("Password", false)
            }
            KeyNavigation.up: {
                idMapCareMainBand.backKeyButton.forceActiveFocus()
                idMapCareMainBand
            }
            onWheelLeftKeyPressed: mainButtonDiagnostic.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonSoftware.forceActiveFocus()
        }



        onBackKeyPressed: {
            if(!isMapCareOn){
                isMapCareMain = false //added for BGFG structure
                UIListener.DealerModeBackKey();
            }
        }
        onHomeKeyPressed: {
            isMapCareMain = false //added for BGFG structure
            UIListener.DealerModeBackKey();
        }
    }

    MComp.MComponent{
        id:idMapCareMainViewLoader
        //x:0; y:93 //added for BGFG structure
        x:0; y:0 //added for BGFG structure
        Loader{ id:idDynamicsMainMapCare;   }
        Loader{ id:idDynamicsSoundMainMapCare;  }
        Loader{ id:idSoftwareMainMapCare;   }
        Loader{ id:idHardwareMainMapCare;   }
        Loader{ id:idVariantMainMapCare;   }
        Loader{ id:idDiagnosisMainMapCare; }
        Loader  { id:idLogSettingMainMapCare;  }
        Loader{ id:idPassWordMainMapCare; }
        Loader{ id: idMostRBDMainMapCare; }
        Loader{ id: idDTCListMainMapCare; }

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

    }


}

