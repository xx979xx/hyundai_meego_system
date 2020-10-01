import Qt 4.7
import Qt.labs.gestures 2.0

//import QmlStatusBarWidget 1.0
//import QmlQwertyKeypadWidget 1.0
//import QmlPopUpPlugin 1.0 as PopUps

import "../Component" as MComp
import "../System" as MSystem
import QmlStatusBar 1.0
MComp.MAppMain {
    id: idDynamicMainUS
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    focus:true
    property int variantValue: VariantSetting.variantInfo
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
        mainButtonRadio.forceActiveFocus()
    }
    QmlStatusBar{
        id: statusBar
        x: 0
        y: 0-93
        width: 1280
        height: 93
        homeType:"button"
        middleEast: false
        visible:true
    }
    Connections{
        target:UIListener
        onShowMainGUI:{
        //            console.log("Enter Software Main Back Key or Click==============")
        //            mainViewState="Main"
        //            setMainAppScreen("", true)
        //            if(flagState == 0){
        //                console.log("Enter Simple Main Software :::")
        //              //  idMainView.visible = true
        //                idMainView.forceActiveFocus()

        //            }
        //            else if(flagState == 9){
        //                  console.log("Enter Full Main Software :::")
        //                  //idFullMainView.visible = true
        //                  idFullMainView.forceActiveFocus()
        //            }
        }
    }
    MComp.MComponent{
        id:idDynamicMainViewUS
        visible: true
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        clip:true
        focus:true

        Image {
            source: "/app/share/images/AppEngineeringMode/img/general/bg_home_sub_s.png";
            width: systemInfo.lcdWidth
            height: systemInfo.lcdHeight+93
            y:-93
            //x:209
            //y:320-93
        }
        onBackKeyPressed:{
            mainBg.visible = false
            console.log("Enter Dynamics Main Back Key or Click==============")
            mainViewState="Main"
            setMainAppScreen("", true)
            if(flagState == 0){
                console.log("Enter Simple Main  :::")
                //  idMainView.visible = true
                idMainView.forceActiveFocus()

            }
            else if(flagState == 9){
                  console.log("Enter Full Main  :::")
                  //idFullMainView.visible = true
                  idFullMainView.forceActiveFocus()
            }
            mainBg.visible = true
        }


        MComp.MBand{
            id:dynamicUsBand
            titleText: qsTr("Engineering Mode > Dynamics")
            KeyNavigation.down:{
                mainButtonRadio
            }
            onBackKeyClicked: {
                mainBg.visible = false
                console.log("Enter Dynamics Main Back Key or Click==============")
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){
                    console.log("Enter Simple Main Software :::")
                    // idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main Software :::")
                      // idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
                mainBg.visible = true
            }
        }
        MComp.MMainButton{
            id:mainButtonRadio

            x:126+40; y:170+59-93
            focus:true
            bgImage: "/app/share/images/home/ico_home_radio_n.png"
            bgImagePress: "/app/share/images/home/ico_home_radio_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_radio_p.png"
            bgImageActive: "/app/share/images/home/ico_home_radio_p.png"
            firstText:"Radio"
            onClickOrKeySelected: {
                mainButtonRadio.forceActiveFocus()
                UIListener.Dynamic_RADIO_FG();
            }
            KeyNavigation.up:{
                dynamicUsBand.backKeyButton.forceActiveFocus()
                dynamicUsBand
            }

            onWheelLeftKeyPressed: mainButtonSOUND.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonHDRADIO.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonHDRADIO

            x:126+40+369; y:170-93
            bgImage: "/app/share/images/home/ico_home_radio_n.png"
            bgImagePress: "/app/share/images/home/ico_home_radio_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_radio_p.png"
            bgImageActive: "/app/share/images/home/ico_home_radio_p.png"
            firstText: "HD Radio"

            onClickOrKeySelected: {
                mainButtonHDRADIO.forceActiveFocus()
                UIListener.Dynamic_HDRADIO_FG();
            }
            KeyNavigation.up:{
                dynamicUsBand.backKeyButton.forceActiveFocus()
                dynamicUsBand
            }



            onWheelLeftKeyPressed: mainButtonRadio.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonXM.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonXM
            x:126+40+369+369
            y:170+59-systemInfo.statusBarHeight
            bgImage: "/app/share/images/home/ico_home_sxm_data_n.png"
            bgImagePress: "/app/share/images/home/ico_home_sxm_data_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_sxm_data_p.png"
            bgImageActive: "/app/share/images/home/ico_home_sxm_data_p.png"
            firstText: "XM"

            onClickOrKeySelected: {
                mainButtonXM.forceActiveFocus()
                UIListener.Dynamic_XM_FG()
            }
            KeyNavigation.up:{
                dynamicUsBand.backKeyButton.forceActiveFocus()
                dynamicUsBand
            }


            onWheelLeftKeyPressed: mainButtonHDRADIO.forceActiveFocus()
            onWheelRightKeyPressed: mainButtoniBox.forceActiveFocus()
        }

        MComp.MMainButton{
            id:mainButtoniBox

            x:126+40+369+369+40
            y:170+59+218-systemInfo.statusBarHeight
            //focus:true
            bgImage: "/app/share/images/home/ico_engineering_config_n.png"
            bgImagePress: "/app/share/images/home/ico_engineering_config_p.png"
            bgImageFocus: "/app/share/images/home/ico_engineering_config_p.png"
            bgImageActive: "/app/share/images/home/ico_engineering_config_p.png"
            firstText:"iBox"
            onClickOrKeySelected: {
                mainButtoniBox.forceActiveFocus()
                UIListener.Dynamic_iBox_FG();
            }
            KeyNavigation.up:{
                dynamicUsBand.backKeyButton.forceActiveFocus()
                dynamicUsBand
            }

            onWheelLeftKeyPressed: mainButtonXM.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonNAVI.forceActiveFocus()
        }


        MComp.MMainButton{
            id:mainButtonNAVI
            x:126+40+369
            y:170+59+218+84-systemInfo.statusBarHeight
            bgImage: "/app/share/images/home/ico_home_navi_n.png"
            bgImagePress: "/app/share/images/home/ico_home_navi_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_navi_p.png"
            bgImageActive: "/app/share/images/home/ico_home_navi_p.png"
            firstText:"Navigation"
            onClickOrKeySelected: {
                UIListener.Dynamic_NAVI_FG()
            }
            KeyNavigation.up:{
                dynamicUsBand.backKeyButton.forceActiveFocus()
                dynamicUsBand
            }

            onWheelLeftKeyPressed: mainButtoniBox.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonSOUND.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonSOUND

            x:126
            y:170+59+218 -systemInfo.statusBarHeight
            bgImage: "/app/share/images/home/ico_home_sound_n.png"
            bgImagePress: "/app/share/images/home/ico_home_sound_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_sound_p.png"
            bgImageActive: "/app/share/images/home/ico_home_sound_p.png"

            firstText: "Sound"


            onClickOrKeySelected: {
                mainButtonSound.forceActiveFocus()
                mainViewState = "DynamicSound"
                setMainAppScreen("DynamicSound", true)
                UIListener.Dynamic_SOUND_FG(1)
            }
            KeyNavigation.up:{
                dynamicUsBand.backKeyButton.forceActiveFocus()
                dynamicUsBand
            }

            onWheelLeftKeyPressed: mainButtonNAVI.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonRadio.forceActiveFocus()
        }

        //        MComp.MMainButton{
        //            id:mainButtonRadio

        //            x:46+141; y:100+49-43
        //            focus:true
        //            buttonImage: "/app/share/images/home/ico_home_radio_n.png"
        //            buttonImagePress:"/app/share/images/home/ico_home_radio_p.png"
        //             bgImageFocusPress: "/app/share/images/home/ico_home_radio_p.png"
        //            firstText:"Radio"
        //            onClickOrKeySelected: {
        //                UIListener.Dynamic_RADIO_FG();
        //            }
        //            KeyNavigation.up:{
        //                dynamicUsBand.backKeyButton.forceActiveFocus()
        //                dynamicUsBand
        //            }

        //            onWheelLeftKeyPressed: mainButtonNAVI.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonHDRADIO.forceActiveFocus()
        //        }
        //        MComp.MMainButton{
        //            id:mainButtonHDRADIO

        //            x:46+141+177+170; y:100-43
        //            buttonImage: "/app/share/images/home/ico_home_radio_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_home_radio_p.png"
        //            bgImageFocusPress: "/app/share/images/home/ico_home_radio_p.png"
        //            firstText: "HD Radio"

        //            onClickOrKeySelected: {
        //                    UIListener.Dynamic_HDRADIO_FG();
        //            }
        //            KeyNavigation.up:{
        //                dynamicUsBand.backKeyButton.forceActiveFocus()
        //                dynamicUsBand
        //            }

        //            KeyNavigation.down: mainButtonSOUND

        //            onWheelLeftKeyPressed: mainButtonRadio.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonXM.forceActiveFocus()
        //        }
        //        MComp.MMainButton{
        //            id:mainButtonXM
        //            x:46+141+177+170+170+177
        //            y:100+49-43
        //            buttonImage: "/app/share/images/home/ico_home_sxm_data_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_home_sxm_data_p.png"
        //            bgImageFocusPress: "/app/share/images/home/ico_home_sxm_data_p.png"
        //            firstText: "XM"

        //            onClickOrKeySelected: {
        //                UIListener.Dynamic_XM_FG()
        //            }
        //            KeyNavigation.up:{
        //                dynamicUsBand.backKeyButton.forceActiveFocus()
        //                dynamicUsBand
        //            }


        //            onWheelLeftKeyPressed: mainButtonHDRADIO.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtoniBox.forceActiveFocus()
        //        }


        //        MComp.MMainButton{
        //            id:mainButtonNAVI
        //            x:46
        //            y:100+49+203 -43
        //            buttonImage: "/app/share/images/home/ico_home_navi_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_home_navi_p.png"
        //            bgImageFocusPress: "/app/share/images/home/ico_home_navi_p.png"
        //            firstText:"Navigation"
        //            onClickOrKeySelected: {
        //                UIListener.Dynamic_NAVI_FG()
        //            }
        //            KeyNavigation.up:{
        //                dynamicUsBand.backKeyButton.forceActiveFocus()
        //                dynamicUsBand
        //            }

        //            onWheelLeftKeyPressed: mainButtonSOUND.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonRadio.forceActiveFocus()
        //        }
        //        MComp.MMainButton{
        //            id:mainButtonSOUND

        //            x:46+141+177
        //            y:100+49+203+98-43
        //            buttonImage: "/app/share/images/home/ico_home_sound_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_home_sound_p.png"
        //            bgImageFocusPress: "/app/share/images/home/ico_home_sound_p.png"

        //            firstText: "Sound"


        //            onClickOrKeySelected: {
        //                mainViewState = "DynamicSound"
        //                setMainAppScreen("DynamicSound", true)
        //                UIListener.Dynamic_SOUND_FG(1)
        //            }
        //            KeyNavigation.up:{
        //                dynamicUsBand.backKeyButton.forceActiveFocus()
        //                dynamicUsBand
        //            }

        //            onWheelLeftKeyPressed: mainButtonRDS.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonNAVI.forceActiveFocus()
        //        }

        //        MComp.MMainButton{
        //            id:mainButtonRDS

        //            x:46+141+177+170+170
        //            y:100+49+203+98-43
        //            buttonImage: "/app/share/images/home/ico_home_rds_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_home_rds_p.png"
        //            bgImageFocusPress:  "/app/share/images/home/ico_home_rds_p.png"

        //            firstText: "RDS"


        //            onClickOrKeySelected: {
        //                UIListener.Dynamic_RDS_FG()
        //            }
        //            KeyNavigation.up:{
        //                dynamicUsBand.backKeyButton.forceActiveFocus()
        //                dynamicUsBand
        //            }

        //            onWheelLeftKeyPressed: mainButtoniBox.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonSOUND.forceActiveFocus()
        //        }

        //        MComp.MMainButton{
        //            id:mainButtoniBox

        //            x:46+141+177+170+170+177+141
        //            y:100+49+203-43
        //            focus:true
        //            buttonImage:"/app/share/images/home/ico_engineering_config_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_engineering_config_p.png"
        //            bgImageFocusPress:"/app/share/images/home/ico_engineering_config_p.png"
        //            firstText:"iBox"
        //            onClickOrKeySelected: {
        //                UIListener.Dynamic_iBox_FG();
        //            }
        //            KeyNavigation.up:{
        //                dynamicUsBand.backKeyButton.forceActiveFocus()
        //                dynamicUsBand
        //            }

        //            onWheelLeftKeyPressed: mainButtonXM.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonRDS.forceActiveFocus()
        //        }



        onHomeKeyPressed: {
            UIListener.HandleHomeKey();
        }
    }
}
