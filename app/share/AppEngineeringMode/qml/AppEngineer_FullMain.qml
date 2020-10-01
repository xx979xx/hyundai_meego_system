import Qt 4.7
import Qt.labs.gestures 2.0

import "./Component" as MComp
import "./System" as MSystem
import "./Operation/operation.js" as MOp

MComp.MAppMain {
    id: idFullAppMain
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+93
    x:0;y:0
    //focus:true

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string fullMainViewState : "FullMain"
    property int variantValue: VariantSetting.variantInfo
    property string variantString: ""
    property alias fullsoftButton: fullmainButtonSoftware;
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    //focus:true

    onFullMainViewStateChanged:{
        //if(fullMainViewState == "FullMain"){
        //  idFullMainView.forceActiveFocus();
        //}
    }
    //added for BGFG structure
    Connections{
        target: UIListener
        onHideGUI:{
            mainBg.visible = false
            mainButtonSimple.focus  = true;
            mainButtonSimple.forceActiveFocus()
            flagState = 0
            mainViewState = "Main"
            console.log("Current Flag State : " + flagState)
            setMainAppScreen("", true)

            //idFullMainView.visible = false
            //idMainView.visible = true
            idMainView.forceActiveFocus()
            mainBg.visible = true
        }
    }
    //added for BGFG structur
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
    Component.onCompleted:{

        UIListener.autoTest_athenaSendObject();
        console.debug("[QML] Current Country Code at Full ENG Menu : " + variantValue);
        if(variantValue == 0){
            variantString = "DynamicKo"
        }
        else if(variantValue == 1){
            variantString = "DynamicUS"
        }
        else if(variantValue == 5){
            variantString = "DynamicEU"
        }
        else if(variantValue == 6){
            variantString = "DynamicCA"
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

    }
    function setFullMainAppScreen(screenName, save){
        MOp.setFullMainScreen(screenName,save);
    }



    MComp.MComponent{
        id:idFullMainView
        visible: true
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        clip:true
        focus:true

        Image {
            source: "/app/share/images/AppEngineeringMode/img/general/bg_home_sub_l.png";
            width: systemInfo.lcdWidth
            height: systemInfo.lcdHeight+93
            y:-93
            //source: "/app/share/images/home/bg_home.png"
            ////x:209
            ////y:320-93
            //x:71 ; y:275 -93
        }
        MComp.MBand{
            id:idEngineerFullMainBand
            titleText: qsTr("Full Engineering Mode")

            onBackKeyClicked: {
                UIListener.HandleBackKey();
            }
            KeyNavigation.down:fullmainButtonSoftware
        }

        MComp.MMainButton{
            id:fullmainButtonSoftware
            //x:199-parent.x
            //y:210+49-parent.y-93
            //x:16+130-parent.x ; y:170+47-parent.y-93
            x:36+110; y:170+77-93
            focus:true
            bgImage: "/app/share/images/home/ico_engineering_software_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_software_p.png"
            bgImageFocus:"/app/share/images/home/ico_engineering_software_p.png"
            bgImageActive: "/app/share/images/home/ico_engineering_software_p.png"
            firstText:"Software"//stringInfo.str_Dial
            onClickOrKeySelected: {
                fullmainButtonSoftware.forceActiveFocus()
                //fullmainButtonSoftware.focus = true
                //mainViewState = "FullSoftware"
                //setMainAppScreen("FullSoftware", false)

                fullmainButtonSoftware.focus = true
                mainViewState = "Software"
                setMainAppScreen("Software", false)
                //idFullMainView.visible = false

            }
            KeyNavigation.up: {
                idEngineerFullMainBand.backKeyButton.forceActiveFocus()
                idEngineerFullMainBand
            }
            onWheelLeftKeyPressed: mainButtonSimple.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonHardware.forceActiveFocus()
        }
                MComp.MMainButton{
                    id:mainButtonHardware
                    //x:199+147+202-parent.x
                    //y:210-parent.y-93
                    //x:16+130+115+150-parent.x ; y:170-parent.y-93
                    x:36+110+126+130; y:170-93;
                    bgImage: "/app/share/images/home/ico_engineering_hardware_n.png"
                    bgImagePress: "/app/share/images/home/ico_engineering_hardware_p.png"
                    bgImageFocus: "/app/share/images/home/ico_engineering_hardware_p.png"
                    bgImageActive: "/app/share/images/home/ico_engineering_hardware_p.png"
                    firstText:"Hardware"
                    onClickOrKeySelected: {
                        mainButtonHardware.focus = true
                        mainButtonHardware.forceActiveFocus()
                        mainViewState = "Hardware"
                        setMainAppScreen("Hardware", false)
                        //idFullMainView.visible = false
                    }
                    KeyNavigation.up: {
                        idEngineerFullMainBand.backKeyButton.forceActiveFocus()
                        idEngineerFullMainBand
                    }
                    onWheelLeftKeyPressed: fullmainButtonSoftware.forceActiveFocus()
                    onWheelRightKeyPressed: mainButtonDynamics.forceActiveFocus()
                }
                MComp.MMainButton{
                    id:mainButtonDynamics
                    //x:199+147+202+200+147-parent.x
                    //y:210+49-parent.y-93
                    //x:16+130+115+150+136+126-parent.x ; y:170-parent.y-93
                    x:36+110+126+130+132+132; y:170-93
                    bgImage: "/app/share/images/home/ico_engineering_dynamics_n.png"
                    bgImagePress: "/app/share/images/home/ico_engineering_dynamics_p.png"
                    bgImageFocus: "/app/share/images/home/ico_engineering_dynamics_p.png"
                    bgImageActive: "/app/share/images/home/ico_engineering_dynamics_p.png"
                    firstText:"Dynamics"
                    onClickOrKeySelected: {
                        mainBg.visible = false
                        mainButtonDynamics.focus = true
                        mainButtonDynamics.forceActiveFocus()
                        mainViewState = "Dynamics"
                        setMainAppScreen(variantString, false)
                        mainBg.visible = true
                    }
                    KeyNavigation.up: {
                        idEngineerFullMainBand.backKeyButton.forceActiveFocus()
                        idEngineerFullMainBand
                    }
                    onWheelLeftKeyPressed: mainButtonHardware.forceActiveFocus()
                    onWheelRightKeyPressed: mainButtonUpdate.forceActiveFocus()
                }
                MComp.MMainButton{
                    id:mainButtonUpdate
                    //x:199+147+202+200-parent.x
                    //y:210+49+218-parent.y-93

                    //x:16+130+115+150+136+126+160+115-parent.x ; y:170+47-parent.y-93
                    x:36+110+126+130+132+132+130+126; y:170+77-93
                    bgImage: "/app/share/images/home/ico_engineering_sw_update_n.png"
                    bgImagePress: "/app/share/images/home/ico_engineering_sw_update_p.png"
                    bgImageFocus: "/app/share/images/home/ico_engineering_sw_update_p.png"
                    bgImageActive: "/app/share/images/home/ico_engineering_sw_update_p.png"
                    firstText:"S/W Update"
                    onClickOrKeySelected: {
                        mainButtonUpdate.focus = true
                        mainButtonUpdate.forceActiveFocus(0)
                        mainViewState = "Update"
                        setMainAppScreen("Update", false)
                        //idFullMainView.visible = false
                    }
                    KeyNavigation.up: {
                        idEngineerFullMainBand.backKeyButton.forceActiveFocus()
                        idEngineerFullMainBand
                    }
                    onWheelLeftKeyPressed: mainButtonDynamics.forceActiveFocus()
                    onWheelRightKeyPressed: mainButtonAcc.forceActiveFocus()
                }
                MComp.MMainButton{
                    id:mainButtonSimple
                    //fgImageY: 60/*40*/

                    //x:199+147-parent.x
                    //y:210+49+218-parent.y-93
                    //x:16+130+115+150+136+126+160+115+130-parent.x ; y:170+47+187-parent.y-93
                    x:36; y:170+77+240-93-123

                    bgImage: "/app/share/images/home/ico_engineering_simple_n.png"
                    bgImagePress: "/app/share/images/home/ico_engineering_simple_p.png"
                    bgImageFocus: "/app/share/images/home/ico_engineering_simple_p.png"
                    bgImageActive: "/app/share/images/home/ico_engineering_simple_p.png"

                    firstText: "Simple Mode"
                    firstTextHeight: 65

                    onClickOrKeySelected: {
                        mainBg.visible = false
                        mainButtonSimple.focus  = true;
                        mainButtonSimple.forceActiveFocus()
                        flagState = 0
                        mainViewState = "Main"
                        console.log("Current Flag State : " + flagState)
                        setMainAppScreen("", true)

                        //idFullMainView.visible = false
                        //idMainView.visible = true
                        idMainView.forceActiveFocus()
                        mainBg.visible = true

                    }
                    KeyNavigation.up: {
                        idEngineerFullMainBand.backKeyButton.forceActiveFocus()
                        idEngineerFullMainBand
                    }
                    onWheelLeftKeyPressed: mainButtonConfig.forceActiveFocus()
                    onWheelRightKeyPressed: fullmainButtonSoftware.forceActiveFocus()
                }

                MComp.MMainButton{
                    id:mainButtonAcc
                    //x:199+147-parent.x
                    //y:210+49+218-parent.y-93
                    //x:16+130+115+150+136+126+160-parent.x ; y:170+47+187+103-parent.y-93
                    x:36+110+126+130+132+132+130+126+110; y:170+77+240-93-93
                    bgImage: "/app/share/images/home/ico_home_system_n.png"
                    bgImagePress: "/app/share/images/home/ico_home_system_p.png"
                    bgImageFocus: "/app/share/images/home/ico_home_system_p.png"
                    bgImageActive: "/app/share/images/home/ico_home_system_p.png"
                    firstText: "Auto Test"


                    onClickOrKeySelected: {
                        SendDeckSignal.sendDeckSignal();
                        SystemInfo.releaseVersionRead();
                        SystemInfo.CompareVersion();
                        mainButtonHardware.focus = true
                        mainButtonAcc.forceActiveFocus()
                        mainViewState = "AutoTest"
                        setMainAppScreen("AutoTest", false)
                    }
                    KeyNavigation.up: {
                        idEngineerFullMainBand.backKeyButton.forceActiveFocus()
                        idEngineerFullMainBand
                    }
                    onWheelLeftKeyPressed: mainButtonUpdate.forceActiveFocus()
                    onWheelRightKeyPressed: mainButtonDiagnostic.forceActiveFocus()
                }

                MComp.MMainButton{
                    id:mainButtonDiagnostic
                    //x:199+147-parent.x
                    //y:210+49+218-parent.y-93
                    //x:16+130+115+150+136-parent.x ; y:170+47+187+103+24-parent.y-93
                    x:36+110+126+130+132+132+130; y:170+77+240+44-93-73
                    bgImage: "/app/share/images/home/ico_engineering_diagnostic_n.png"
                    bgImagePress: "/app/share/images/home/ico_engineering_diagnostic_p.png"
                    bgImageFocus: "/app/share/images/home/ico_engineering_diagnostic_p.png"
                    bgImageActive: "/app/share/images/home/ico_engineering_diagnostic_p.png"
                    firstText:"Diagnostic"
                    onClickOrKeySelected: {
                        CpuDegree.startGetDegree();
                        mainButtonDiagnostic.focus = true
                        mainButtonDiagnostic.forceActiveFocus()
                        mainViewState = "Diagnosis"
                        setMainAppScreen("Diagnosis", false)

                    }
                    KeyNavigation.up: {
                        idEngineerFullMainBand.backKeyButton.forceActiveFocus()
                        idEngineerFullMainBand
                    }
                    onWheelLeftKeyPressed: mainButtonAcc.forceActiveFocus()
                    onWheelRightKeyPressed: mainButtonVariant.forceActiveFocus()
                }

                MComp.MMainButton{
                    id:mainButtonVariant
                    //x:199+147-parent.x
                    //y:210+49+218-parent.y-93
                    //x:16+130+115-parent.x ; y:170+47+187+103-parent.y-93
                    x:36+110+126+130+132; y:170+77+240+44+44-93-73
                    bgImage: "/app/share/images/home/ico_engineering_variant_n.png"
                    bgImagePress: "/app/share/images/home/ico_engineering_variant_p.png"
                    bgImageFocus: "/app/share/images/home/ico_engineering_variant_p.png"
                    bgImageActive:"/app/share/images/home/ico_engineering_variant_p.png"
                    firstText:"Variant"
                    onClickOrKeySelected: {
                        mainButtonDynamics.focus = true
                        mainButtonVariant.forceActiveFocus()
                        mainViewState = "Variant"
                        setMainAppScreen("Variant", false)
                        //idMainView.visible = false
                    }
                    KeyNavigation.up: {
                        idEngineerFullMainBand.backKeyButton.forceActiveFocus()
                        idEngineerFullMainBand
                    }
                    onWheelLeftKeyPressed: mainButtonDiagnostic.forceActiveFocus()
                    onWheelRightKeyPressed: mainButtonConfig.forceActiveFocus()
                }

                MComp.MMainButton{
                    id:mainButtonConfig
                    //x:199+147-parent.x
                    //y:210+49+218-parent.y-93
                    //x:16 -parent.x; y:170+47+187-parent.y-93
                    x:36+110+126; y:170+77+240+44-93-73
                    bgImage: "/app/share/images/home/ico_engineering_config_n.png"
                    bgImagePress: "/app/share/images/home/ico_engineering_config_p.png"
                    bgImageFocus: "/app/share/images/home/ico_engineering_config_p.png"
                    bgImageActive: "/app/share/images/home/ico_engineering_config_p.png"


                    firstText: "System Config."

                    onClickOrKeySelected: {
                        mainButtonDynamics.focus = true
                        mainButtonConfig.forceActiveFocus()
                        mainViewState = "SystemConfig"
                        setMainAppScreen("SystemConfig", false)
                        //idMainView.visible = false
                    }
                    KeyNavigation.up: {
                        idEngineerFullMainBand.backKeyButton.forceActiveFocus()
                        idEngineerFullMainBand
                    }
                    onWheelLeftKeyPressed: mainButtonVariant.forceActiveFocus()
                    onWheelRightKeyPressed: mainButtonSimple.forceActiveFocus()
                }
                onBackKeyPressed: {
                    UIListener.HandleBackKey();
                }
                onHomeKeyPressed: {
                    UIListener.HandleHomeKey();
                }
    }
}
