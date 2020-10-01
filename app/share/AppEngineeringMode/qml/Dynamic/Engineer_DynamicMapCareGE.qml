import Qt 4.7
import Qt.labs.gestures 2.0
import com.engineer.data 1.0
import "../Component" as MComp
import "../System" as MSystem
import QmlStatusBar 1.0
MComp.MAppMain {
    id: idDynamicMapCare
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
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
    property string imgFolderGeneral: imageInfo.imgFolderGeneral


    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
        mainButtonRadio.forceActiveFocus();
    }

    Connections{
        target:UIListener
        onShowMainGUI:{

        }
    }
    MComp.MComponent{
        id:idDynamicMapCareView
        visible: true
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        clip:true
        focus: true

        Image {
            source: "/app/share/images/AppEngineeringMode/img/general/bg_home_sub_s.png";
            width: systemInfo.lcdWidth
            height: systemInfo.lcdHeight+93
            y:-93
            visible:  idDynamicMapCareView.visible
        }
        onBackKeyPressed:{
            //added for BGFG structure
            if(isMapCareEx)
            {
                console.log("[QML] Software  : onBackKeyClicked -----------")
                mainViewState = "MapCareMainEx"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            else
            {
                console.log("[QML] Software  : onBackKeyClicked -----------")
                mainViewState = "MapCareMain"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            //added for BGFG structure
        }

        MComp.MBand{
            id:dynamicMapCareBand
            titleText: qsTr("Dealer Mode > Dynamics")
            KeyNavigation.down:{
                mainButtonRadio
            }
            onBackKeyClicked: {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    console.log("[QML] Software  : onBackKeyClicked -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    console.log("[QML] Software  : onBackKeyClicked -----------")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                //added for BGFG structure
            }
        }

        MComp.MMainButton{
            id:mainButtonRadio

            x:286+90; y:195-93
            focus:true
            bgImage: "/app/share/images/home/ico_home_radio_n.png"
            bgImagePress: "/app/share/images/home/ico_home_radio_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_radio_p.png"
            bgImageActive: "/app/share/images/home/ico_home_radio_p.png"
            firstText:"Radio"
            onClickOrKeySelected: {
                mainButtonRadio.forceActiveFocus()
                UIListener.MapCareDynamicMenu(EngineerData.Dynamic_MapCare_RDS);
            }
            KeyNavigation.up:{
                dynamicMapCareBand.backKeyButton.forceActiveFocus()
                dynamicMapCareBand
            }

            onWheelLeftKeyPressed: mainButtonSound.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonNavi.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonNavi
            x:286+90+316; y:195-93

            bgImage: "/app/share/images/home/ico_home_navi_n.png"
            bgImagePress: "/app/share/images/home/ico_home_navi_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_navi_p.png"
            bgImageActive: "/app/share/images/home/ico_home_navi_p.png"

            firstText: "Navigation"

            onClickOrKeySelected: {
                mainButtonNavi.forceActiveFocus()
                UIListener.MapCareDynamicMenu(EngineerData.Dynamic_MapCare_Navi);
            }
            KeyNavigation.up:{
                dynamicMapCareBand.backKeyButton.forceActiveFocus()
                dynamicMapCareBand
            }

            onWheelLeftKeyPressed: mainButtonRadio.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonSound.forceActiveFocus()
        }



        MComp.MMainButton{
            id:mainButtonSound
            x:286 +200 + 30; y:195+226-93

            bgImage: "/app/share/images/home/ico_home_sound_n.png"
            bgImagePress: "/app/share/images/home/ico_home_sound_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_sound_p.png"
            bgImageActive: "/app/share/images/home/ico_home_sound_p.png"
            firstText:"Sound"
            onClickOrKeySelected: {
                mainButtonSound.forceActiveFocus()
                mainViewState = "MapCareDynamicSound"
                setMapCareUIScreen("MapCareDynamicSound", true)
                UIListener.Dynamic_SOUND_FG(1)

            }
            KeyNavigation.up:{
                dynamicMapCareBand.backKeyButton.forceActiveFocus()
                dynamicMapCareBand
            }

            onWheelLeftKeyPressed: mainButtonNavi.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonRadio.forceActiveFocus()
        }


        onHomeKeyPressed: {
            //added for BGFG structure
            if(isMapCareEx)
            {
                console.log("[QML]Return HOME Screen :: At MapCare Software")
                mainViewState = "MapCareMainEx"
                setMapCareUIScreen("", true)
                //idMapCareMainView.forceActiveFocus()
                mainViewState="Main"
                setMainAppScreen("", true)
            }
            else
            {
                console.log("[QML]Return HOME Screen :: At MapCare Software")
                mainViewState = "MapCareMain"
                setMapCareUIScreen("", true)
                //idMapCareMainView.forceActiveFocus()
                mainViewState="Main"
                setMainAppScreen("", true)
            }
            isMapCareMain = false
            //added for BGFG structure
            UIListener.HandleHomeKey();
        }
    }


}
