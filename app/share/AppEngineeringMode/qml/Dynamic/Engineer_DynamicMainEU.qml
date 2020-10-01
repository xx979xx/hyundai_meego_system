import Qt 4.7
import Qt.labs.gestures 2.0


import "../Component" as MComp
import "../System" as MSystem
import QmlStatusBar 1.0
MComp.MAppMain {
    id: idDynamicMainEU
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
        id:idDynamicMainViewEU
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
            id:dynamicEuBand
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
                dynamicEuBand.backKeyButton.forceActiveFocus()
                dynamicEuBand
            }

            onWheelLeftKeyPressed: mainButtonSound.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonRds.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonRds

            x:126+40+369; y:170-93
            bgImage: "/app/share/images/home/ico_home_rds_n.png"
            bgImagePress: "/app/share/images/home/ico_home_rds_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_rds_p.png"
            bgImageActive: "/app/share/images/home/ico_home_rds_p.png"
            firstText: "RDS"

            onClickOrKeySelected: {
                    mainButtonRds.forceActiveFocus()
                    UIListener.Dynamic_RDS_FG();
            }
            KeyNavigation.up:{
                dynamicEuBand.backKeyButton.forceActiveFocus()
                dynamicEuBand
            }
            onWheelLeftKeyPressed: mainButtonRadio.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonDAB.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonDAB

            x:126+40+369+369
            y:170+59-systemInfo.statusBarHeight
            bgImage: "/app/share/images/home/ico_home_dab_n.png"
            bgImagePress: "/app/share/images/home/ico_home_dab_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_dab_p.png"
            firstText: "DAB"

            onClickOrKeySelected: {
                mainButtonDAB.forceActiveFocus()
                UIListener.Dynamic_DAB_FG()
            }
            KeyNavigation.up:{
                dynamicEuBand.backKeyButton.forceActiveFocus()
                dynamicEuBand
            }

            onWheelLeftKeyPressed: mainButtonRds.forceActiveFocus()
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
                dynamicEuBand.backKeyButton.forceActiveFocus()
                dynamicEuBand
            }

            onWheelLeftKeyPressed: mainButtonDAB.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonNavi.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonNavi
            x:126+40+369
            y:170+59+218+84-systemInfo.statusBarHeight
            bgImage: "/app/share/images/home/ico_home_navi_n.png"
            bgImagePress: "/app/share/images/home/ico_home_navi_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_navi_p.png"
            bgImageActive: "/app/share/images/home/ico_home_navi_p.png"

            firstText: "Navigation"


            onClickOrKeySelected: {
                mainButtonNavi.forceActiveFocus()
                UIListener.Dynamic_NAVI_FG()
            }
            KeyNavigation.up:{
                dynamicEuBand.backKeyButton.forceActiveFocus()
                dynamicEuBand
            }

            onWheelLeftKeyPressed: mainButtoniBox.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonSound.forceActiveFocus()
        }

        MComp.MMainButton{
            id:mainButtonSound
            x:126
            y:170+59+218 -systemInfo.statusBarHeight
            bgImage: "/app/share/images/home/ico_home_sound_n.png"
            bgImagePress: "/app/share/images/home/ico_home_sound_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_sound_p.png"
            bgImageActive: "/app/share/images/home/ico_home_sound_p.png"
            firstText:"Sound"
            onClickOrKeySelected: {
                mainButtonSound.forceActiveFocus()
                mainViewState = "DynamicSound"
                setMainAppScreen("DynamicSound", true)
                UIListener.Dynamic_SOUND_FG(1)
            }
            KeyNavigation.up:{
                mainButtonSound.forceActiveFocus()
                dynamicEuBand.backKeyButton.forceActiveFocus()
                dynamicEuBand
            }

            onWheelLeftKeyPressed: mainButtonNavi.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonRadio.forceActiveFocus()
        }


        //        MComp.MMainButton{
        //            id:mainButtonRadio

        //            //x:126+40; y:170+59-93
        //            x:46+141; y:100+49-43
        //            focus:true
        //            buttonImage: "/app/share/images/home/ico_home_radio_n.png"
        //            buttonImagePress:"/app/share/images/home/ico_home_radio_p.png"
        //            bgImageFocusPress:"/app/share/images/home/ico_home_radio_p.png"
        //            firstText:"Radio"
        //            onClickOrKeySelected: {
        //                UIListener.Dynamic_RADIO_FG();
        //            }
        //            KeyNavigation.up:{
        //                dynamicEuBand.backKeyButton.forceActiveFocus()
        //                dynamicEuBand
        //            }

        //            onWheelLeftKeyPressed: mainButtonSound.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonRds.forceActiveFocus()
        //        }
        //        MComp.MMainButton{
        //            id:mainButtonRds

        //            //x:126+40+369; y:170-93
        //            x:46+141+177+170; y:100-43
        //            buttonImage: "/app/share/images/home/ico_home_rds_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_home_rds_p.png"
        //            bgImageFocusPress:"/app/share/images/home/ico_home_rds_p.png"
        //            firstText: "RDS"

        //            onClickOrKeySelected: {
        //                    UIListener.Dynamic_RDS_FG();
        //            }
        //            KeyNavigation.up:{
        //                dynamicEuBand.backKeyButton.forceActiveFocus()
        //                dynamicEuBand
        //            }
        //            onWheelLeftKeyPressed: mainButtonRadio.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonDAB.forceActiveFocus()
        //        }
        //        MComp.MMainButton{
        //            id:mainButtonDAB

        //            //x:126+40+369+369
        //             //y:170+59-systemInfo.statusBarHeight
        //            x:46+141+177+170+170+177
        //            y:100+49-43
        //            buttonImage:"/app/share/images/home/ico_home_dab_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_home_dab_p.png"
        //            bgImageFocusPress:"/app/share/images/home/ico_home_dab_p.png"
        //            firstText: "DAB"

        //            onClickOrKeySelected: {
        //                UIListener.Dynamic_DAB_FG()
        //            }
        //            KeyNavigation.up:{
        //                dynamicEuBand.backKeyButton.forceActiveFocus()
        //                dynamicEuBand
        //            }

        //            onWheelLeftKeyPressed: mainButtonRds.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonMapCare.forceActiveFocus()
        //        }

        //        MComp.MMainButton{
        //            id:mainButtonSound
        //            x:46
        //            y:100+49+203 -43
        //            //x:126
        //           // y:170+59+218 -systemInfo.statusBarHeight
        //            buttonImage: "/app/share/images/home/ico_home_sound_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_home_sound_p.png"
        //            bgImageFocusPress:"/app/share/images/home/ico_home_sound_p.png"
        //            firstText:"Sound"
        //            onClickOrKeySelected: {
        //                mainViewState = "DynamicSound"
        //                setMainAppScreen("DynamicSound", true)
        //                UIListener.Dynamic_SOUND_FG(1)
        //            }
        //            KeyNavigation.up:{
        //                dynamicEuBand.backKeyButton.forceActiveFocus()
        //                dynamicEuBand
        //            }

        //            onWheelLeftKeyPressed: mainButtonNavi.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonRadio.forceActiveFocus()
        //        }
        //        MComp.MMainButton{
        //            id:mainButtonNavi
        //            x:46+141+177
        //            y:100+49+203+98-43
        //            //x:126+40+369
        //            //y:170+59+218+84-systemInfo.statusBarHeight
        //            buttonImage: "/app/share/images/home/ico_home_navi_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_home_navi_p.png"
        //            bgImageFocusPress: "/app/share/images/home/ico_home_navi_p.png"

        //            firstText: "Navigation"


        //            onClickOrKeySelected: {
        //                UIListener.Dynamic_NAVI_FG()
        //            }
        //            KeyNavigation.up:{
        //                dynamicEuBand.backKeyButton.forceActiveFocus()
        //                dynamicEuBand
        //            }

        //            onWheelLeftKeyPressed: mainButtoniBox.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonSound.forceActiveFocus()
        //        }

        //        MComp.MMainButton{
        //            id:mainButtoniBox
        //            x:46+141+177+170+170
        //            y:100+49+203+98-43
        //            //x:126+40+369+369+40
        //            //y:170+59+218-systemInfo.statusBarHeight
        //            focus:true
        //            buttonImage:"/app/share/images/home/ico_engineering_config_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_engineering_config_p.png"
        //            bgImageFocusPress:"/app/share/images/home/ico_engineering_config_p.png"
        //            firstText:"iBox"
        //            onClickOrKeySelected: {
        //                UIListener.Dynamic_iBox_FG();
        //            }
        //            KeyNavigation.up:{
        //                dynamicEuBand.backKeyButton.forceActiveFocus()
        //                dynamicEuBand
        //            }

        //            onWheelLeftKeyPressed: mainButtonMapCare.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtonNavi.forceActiveFocus()
        //        }

        //        MComp.MMainButton{
        //            id:mainButtonMapCare
        //            x:46+141+177+170+170+177+141
        //            y:100+49+203-43
        //            //x:126+40+369+369+40
        //            //y:170+59+218-systemInfo.statusBarHeight
        //            focus:true
        //            buttonImage:"/app/share/images/home/ico_engineering_config_n.png"
        //            buttonImagePress: "/app/share/images/home/ico_engineering_config_p.png"
        //            bgImageFocusPress:"/app/share/images/home/ico_engineering_config_p.png"
        //            firstText:"Map Care"
        //            onClickOrKeySelected: {
        //                    UIListener.Dynamic_MapCare_FG()
        //            }
        //            KeyNavigation.up:{
        //                dynamicEuBand.backKeyButton.forceActiveFocus()
        //                dynamicEuBand
        //            }
        //            onWheelLeftKeyPressed: mainButtonDAB.forceActiveFocus()
        //            onWheelRightKeyPressed: mainButtoniBox.forceActiveFocus()
        //        }

        onHomeKeyPressed: {
            UIListener.HandleHomeKey();
        }

    }
}
