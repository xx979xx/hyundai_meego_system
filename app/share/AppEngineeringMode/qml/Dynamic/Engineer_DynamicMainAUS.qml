import Qt 4.7
import Qt.labs.gestures 2.0

//import QmlStatusBarWidget 1.0
//import QmlQwertyKeypadWidget 1.0
//import QmlPopUpPlugin 1.0 as PopUps

import "../Component" as MComp
import "../System" as MSystem
import QmlStatusBar 1.0
MComp.MAppMain {
    id: idDynamicMainAUS
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

        }
    }
    MComp.MComponent{
        id:idDynamicMainViewAUS
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
                console.log("Enter Simple Main Software :::")
                idMainView.forceActiveFocus()

            }
            else if(flagState == 9){
                  console.log("Enter Full Main Software :::")
                  idFullMainView.forceActiveFocus()
            }
            mainBg.visible = true
    }


        MComp.MBand{
            id:dynamicGeBand
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
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main Software :::")
                      idFullMainView.forceActiveFocus()
                }
                mainBg.visible = true
            }
        }

        MComp.MMainButton{
            id:mainButtonRadio

            x:286+90; y:195-93
            focus:true
            bgImage: "/app/share/images/home/ico_home_radio_n.png"
            bgImagePress:"/app/share/images/home/ico_home_radio_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_radio_p.png"
            bgImageActive: "/app/share/images/home/ico_home_radio_p.png"
            firstText:"Radio"//stringInfo.str_Dial
            onClickOrKeySelected: {
                mainButtonRadio.forceActiveFocus()
                UIListener.Dynamic_RADIO_FG();
            }
            KeyNavigation.up:{
                dynamicGeBand.backKeyButton.forceActiveFocus()
                dynamicGeBand
            }

            onWheelLeftKeyPressed: mainButtonSound.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonRds.forceActiveFocus()
        }

        MComp.MMainButton{
            id:mainButtonRds

            x:286+90+316; y:195-93
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
                dynamicGeBand.backKeyButton.forceActiveFocus()
                dynamicGeBand
            }


            onWheelLeftKeyPressed: mainButtonRadio.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonNavi.forceActiveFocus()
        }

        MComp.MMainButton{
            id:mainButtonSound

            x:286; y:195+226-93
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
                dynamicGeBand.backKeyButton.forceActiveFocus()
                dynamicGeBand
            }


            onWheelLeftKeyPressed: mainButtonNavi.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonRadio.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonNavi

            x:286+90+316+90
            y:195+226-93
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
                dynamicGeBand.backKeyButton.forceActiveFocus()
                dynamicGeBand
            }

            onWheelLeftKeyPressed: mainButtonRds.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonSound.forceActiveFocus()
        }



        onHomeKeyPressed: {
            UIListener.HandleHomeKey();
        }
    }
}
