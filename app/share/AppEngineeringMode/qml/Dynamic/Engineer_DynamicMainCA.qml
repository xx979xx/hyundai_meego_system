import Qt 4.7
import Qt.labs.gestures 2.0


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

        }
        onBackKeyPressed:{
            mainBg.visible = false
            console.log("Enter Dynamics  CA Main Back Key or Click==============")
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
            id:dynamicCABand
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
                    console.log("Enter Simple Main  :::")

                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main  :::")

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
            firstText:"Radio"
            onClickOrKeySelected: {
                mainButtonRadio.forceActiveFocus()
                UIListener.Dynamic_RADIO_FG();
            }
            KeyNavigation.up:{
                dynamicCABand.backKeyButton.forceActiveFocus()
                dynamicCABand
            }

            onWheelLeftKeyPressed: mainButtonNAVI.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonXM.forceActiveFocus()
        }

        MComp.MMainButton{
            id:mainButtonXM
            x:286+90+316; y:195-93
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
                dynamicCABand.backKeyButton.forceActiveFocus()
                dynamicCABand
            }


            onWheelLeftKeyPressed: mainButtonRadio.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonSOUND.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonSOUND

            x:286+90+316+90
            y:195+226-93
            bgImage: "/app/share/images/home/ico_home_sound_n.png"
            bgImagePress: "/app/share/images/home/ico_home_sound_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_sound_p.png"
            bgImageActive: "/app/share/images/home/ico_home_sound_p.png"

            firstText: "Sound"


            onClickOrKeySelected: {
                mainButtonSOUND.forceActiveFocus()
                mainViewState = "DynamicSound"
                setMainAppScreen("DynamicSound", true)
                UIListener.Dynamic_SOUND_FG(1)
            }
            KeyNavigation.up:{
                dynamicCABand.backKeyButton.forceActiveFocus()
                dynamicCABand
            }

            onWheelLeftKeyPressed: mainButtonXM.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonNAVI.forceActiveFocus()
        }

        MComp.MMainButton{
            id:mainButtonNAVI
            x:286; y:195+226-93
            bgImage: "/app/share/images/home/ico_home_navi_n.png"
            bgImagePress: "/app/share/images/home/ico_home_navi_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_navi_p.png"
            bgImageActive: "/app/share/images/home/ico_home_navi_p.png"
            firstText:"Navigation"
            onClickOrKeySelected: {
                mainButtonNAVI.forceActiveFocus();
                UIListener.Dynamic_NAVI_FG()
            }
            KeyNavigation.up:{
                dynamicCABand.backKeyButton.forceActiveFocus()
                dynamicCABand
            }

            onWheelLeftKeyPressed: mainButtonSOUND.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonRadio.forceActiveFocus()
        }



        onHomeKeyPressed: {
            UIListener.HandleHomeKey();
        }
    }
}
