import Qt 4.7
import Qt.labs.gestures 2.0

import "../Component" as MComp
import "../System" as MSystem
import QmlStatusBar 1.0
MComp.MAppMain {
    id:idDynamicMainKo
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    property bool enterDynamic: false
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

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    focus:true
    property int variantValue: VariantSetting.variantInfo
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
        mainButtonRadio.forceActiveFocus()
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
        onBlockBackKeyAtDynamic:
        {
            //console.debug("[QML] Enter Dynamic Menu : " +isOn )
            //idDynamicMainKo.enterDynamic = isOn;
        }
    }

    MComp.MComponent{
        id:idDynamicMainView
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
            //x:209
            //y:320-93
        }
        onBackKeyPressed:{
            if(idDynamicMainKo.enterDynamic == false)
            {
                console.log("[QML] idDynamicMainKo.enterDynamic == false ==============")
                mainBg.visible = false
                console.log("[QML1] Enter Dynamics Main Back Key or Click==============")
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){
                    console.log("Enter Simple Main Software :::")
                    //idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main Software :::")
                      //idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
                mainBg.visible = true
            }

    }


        MComp.MBand{
            id:dynamicKoBand
            titleText: qsTr("Engineering Mode > Dynamics")
            KeyNavigation.down:{
                mainButtonRadio
            }

            onBackKeyClicked: {
                    mainBg.visible = false
                    console.log("[QML2]Enter Dynamics Main Back Key or Click==============")
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
                dynamicKoBand.backKeyButton.forceActiveFocus()
                dynamicKoBand
            }

            onWheelLeftKeyPressed: mainButtonSound.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonDmb.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonDmb
            x:126+40+369; y:170-93

            bgImage: "/app/share/images/home/ico_home_dmb_n.png"
            bgImagePress: "/app/share/images/home/ico_home_dmb_p.png"
            bgImageFocus:  "/app/share/images/home/ico_home_dmb_p.png"
            bgImageActive:  "/app/share/images/home/ico_home_dmb_p.png"
            firstText:"DMB"
            onClickOrKeySelected: {
                mainButtonDmb.forceActiveFocus()
                UIListener.Dynamic_DMB_FG();

            }
            KeyNavigation.up:{
                dynamicKoBand.backKeyButton.forceActiveFocus()
                dynamicKoBand
            }

            onWheelLeftKeyPressed: mainButtonRadio.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonDisc.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonDisc

            x:126+40+369+369
            y:170+59-systemInfo.statusBarHeight
            //focus:true
            bgImage:"/app/share/images/home/ico_home_disc_n.png"
            bgImagePress: "/app/share/images/home/ico_home_disc_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_disc_p.png"
            bgImageActive: "/app/share/images/home/ico_home_disc_p.png"
            firstText:"DISC"
            onClickOrKeySelected: {
                mainButtonDisc.forceActiveFocus()
                UIListener.Dynamic_Disc_FG();
            }
            KeyNavigation.up:{
                dynamicKoBand.backKeyButton.forceActiveFocus()
                dynamicKoBand
            }

            onWheelLeftKeyPressed: mainButtonDmb.forceActiveFocus()
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
                dynamicKoBand.backKeyButton.forceActiveFocus()
                dynamicKoBand
            }

            onWheelLeftKeyPressed: mainButtonDisc.forceActiveFocus()
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
                dynamicKoBand.backKeyButton.forceActiveFocus()
                dynamicKoBand
            }

            onWheelLeftKeyPressed: mainButtoniBox.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonSound.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonSound
            x:126
            y:170+59+218 - systemInfo.statusBarHeight

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
                dynamicKoBand.backKeyButton.forceActiveFocus()
                dynamicKoBand
            }

            onWheelLeftKeyPressed: mainButtonNavi.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonRadio.forceActiveFocus()
        }



        onHomeKeyPressed: {
            UIListener.HandleHomeKey();
        }
    }
}
