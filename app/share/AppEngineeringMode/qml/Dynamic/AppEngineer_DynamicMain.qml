import Qt 4.7
import Qt.labs.gestures 2.0

//import QmlStatusBarWidget 1.0
//import QmlQwertyKeypadWidget 1.0
//import QmlPopUpPlugin 1.0 as PopUps

import "../Component" as MComp
import "../System" as MSystem

MComp.MAppMain {
    id: idAppMain
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    focus:true
    property int variantValue: VariantSetting.variantInfo
    //    //**************************************** Background
    //    Image{
    //        id:bgImg
    //        //id:bgImgBtRecentDeleteCall
    //        width: systemInfo.lcdWidth
    //        height: systemInfo.lcdHeight +93
    //        source:"/app/share/images/general/bg.png"
    //    }
    Connections{
        target:UIListener
        onShowMainGUI:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
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
    }

    MComp.MComponent{
        id:idMainView
        visible: true
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        clip:true
        focus:true

        Image {
            source: "/app/share/images/AppEngineeringMode/img/general/bg_home_sub_s.png";
            x:71 ; y:275 -93
        }
        onBackKeyPressed:{
        console.log("Enter Dynamics Main Back Key or Click==============")
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


        MComp.MBand{
            titleText: qsTr("Engineering Mode > Dynamics")
            onBackKeyClicked: {
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
            }
        }

        MComp.MMainButton{
            id:mainButtonRadio

            x:16+130-parent.x ; y:170+47-parent.y-93
            focus:true
            bgImage: "/app/share/images/home/ico_home_radio_n.png"
            bgImagePress:"/app/share/images/home/ico_home_radio_p.png"
            bgImageFocus:"/app/share/images/home/ico_home_radio_p.png"
            bgImageActive:"/app/share/images/home/ico_home_radio_p.png"
            firstText:"Radio"//stringInfo.str_Dial
            onClickOrKeySelected: {
                mainButtonRadio.forceActiveFocus();
            }
            KeyNavigation.down:mainButtonLog
            KeyNavigation.right:mainButtonDmb
            onWheelLeftKeyPressed: mainButtonLog.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonDmb.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonDmb
            x:16+130+115+150-parent.x ; y:170-parent.y-93
            bgImage: "/app/share/images/home/ico_home_dmb_n.png"
            bgImagePress: "/app/share/images/home/ico_home_dmb_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_dmb_p.png"
            bgImageActive: "/app/share/images/home/ico_home_dmb_p.png"
            firstText:"DMB"
            onClickOrKeySelected: {
                //mainButtoncallhistory.focus=true
                mainButtonDmb.forceActiveFocus();

            }
            KeyNavigation.left:mainButtonRadio
            KeyNavigation.right:mainButtonXm
            KeyNavigation.down:mainButtonAuto
            onWheelLeftKeyPressed: mainButtonRadio.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonXm.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonXm

            x:16+130+115+150+136+126-parent.x ; y:170-parent.y-93
            bgImage: "/app/share/images/home/ico_home_sxm_data_n.png"
            bgImagePress: "/app/share/images/home/ico_home_sxm_data_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_sxm_data_p.png"
            bgImageActive: "/app/share/images/home/ico_home_sxm_data_p.png"

            firstText: "XM"

            onClickOrKeySelected: {


            }
            KeyNavigation.left:mainButtonDmb
            KeyNavigation.right:mainButtonSound
            KeyNavigation.down:mainButtonIP
            onWheelLeftKeyPressed: mainButtonDmb.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonSound.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonSound
             x:16+130+115+150+136+126+160+115-parent.x ; y:170+47-parent.y-93
            bgImage: "/app/share/images/home/ico_home_sound_n.png"
            bgImagePress: "/app/share/images/home/ico_home_sound_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_sound_p.png"
            bgImageActive: "/app/share/images/home/ico_home_sound_p.png"
            firstText:"Sound"
            onClickOrKeySelected: {
//                        mainButtonFavorite.focus=true
//                        mainViewState="Favorite"
//                        if(BtCoreCtrl.m_nCountFavoriteContactsList>0){
//                            //                if(favoriteValue == 7){
//                            setMainAppScreen("BtFavoriteMain",false)
//                        }
//                        else{
//                            setMainAppScreen("BtInfoView",false);
//                            infoState="FavoritesNoList"
//                        }
            }
            KeyNavigation.left:mainButtonXm
            KeyNavigation.down:mainButtonNavi
            onWheelLeftKeyPressed: mainButtonXm.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonNavi.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonNavi
//                    x:199+147-parent.x
//                    y:210+49+218-parent.y-93
            x:16+130+115+150+136+126+160+115+130-parent.x ; y:170+47+187-parent.y-93
            bgImage: "/app/share/images/home/ico_home_navi_n.png"
            bgImageFocus: "/app/share/images/home/ico_home_navi_p.png"
            bgImagePress: "/app/share/images/home/ico_home_navi_p.png"
            bgImageActive: "/app/share/images/home/ico_home_navi_p.png"


            firstText: "네비게이션"


            onClickOrKeySelected: {
//                        mainButtonSettings.focus=true
//                        mainViewState="Settings"
//                        if(BtCoreCtrl.m_nPairedDevCount > 0){
//                            setMainAppScreen("BtDeviceList",false)
//                        }
//                        else if(BtCoreCtrl.m_nPairedDevCount < 1){
//                            setMainAppScreen("BtDeviceNoDevice",false)
//                        }
            }
            KeyNavigation.left:mainButtonRds
            KeyNavigation.up:mainButtonSound
            onWheelLeftKeyPressed: mainButtonSound.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonRds.forceActiveFocus()
        }

        MComp.MMainButton{
            id:mainButtonRds
            x:16+130+115+150+136+126+160-parent.x ; y:170+47+187+103-parent.y-93
            bgImage: "/app/share/images/home/ico_home_rds_n.png"
            bgImagePress: "/app/share/images/home/ico_home_rds_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_rds_p.png"
            bgImageActive: "/app/share/images/home/ico_home_rds_p.png"


            firstText: "RDS"

            onClickOrKeySelected: {
//                        mainButtonSettings.focus=true
//                        mainViewState="Settings"
//                        if(BtCoreCtrl.m_nPairedDevCount > 0){
//                            setMainAppScreen("BtDeviceList",false)
//                        }
//                        else if(BtCoreCtrl.m_nPairedDevCount < 1){
//                            setMainAppScreen("BtDeviceNoDevice",false)
//                        }
            }
            KeyNavigation.right:mainButtonNavi
            KeyNavigation.left:mainButtonIP
            KeyNavigation.up:mainButtonXm
            onWheelLeftKeyPressed: mainButtonNavi.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonIP.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonIP
            x:16+130+115+150+136-parent.x ; y:170+47+187+103+24-parent.y-93
            bgImage: "/app/share/images/home/ico_home_internet_n.png"
            bgImagePress: "/app/share/images/home/ico_home_internet_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_internet_p.png"
            bgImageActive: "/app/share/images/home/ico_home_internet_p.png"


            firstText: "Ip configration"

            onClickOrKeySelected: {
//                        mainButtonSettings.focus=true
//                        mainViewState="Settings"
//                        if(BtCoreCtrl.m_nPairedDevCount > 0){
//                            setMainAppScreen("BtDeviceList",false)
//                        }
//                        else if(BtCoreCtrl.m_nPairedDevCount < 1){
//                            setMainAppScreen("BtDeviceNoDevice",false)
//                        }
            }
            KeyNavigation.right:mainButtonRds
            KeyNavigation.left:mainButtonAuto
            KeyNavigation.up:mainButtonXm
            onWheelLeftKeyPressed: mainButtonRds.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonAuto.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonAuto
//                    x:199+147-parent.x
//                    y:210+49+218-parent.y-93
            x:16+130+115-parent.x ; y:170+47+187+103-parent.y-93
            bgImage: "/app/share/images/home/ico_home_general_n.png"
            bgImagePress: "/app/share/images/home/ico_home_general_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_general_p.png"
            bgImageActive: "/app/share/images/home/ico_home_general_p.png"


            firstText: "Auto Test"

            onClickOrKeySelected: {
//                        mainButtonSettings.focus=true
//                        mainViewState="Settings"
//                        if(BtCoreCtrl.m_nPairedDevCount > 0){
//                            setMainAppScreen("BtDeviceList",false)
//                        }
//                        else if(BtCoreCtrl.m_nPairedDevCount < 1){
//                            setMainAppScreen("BtDeviceNoDevice",false)
//                        }
            }
            KeyNavigation.right:mainButtonIP
            KeyNavigation.left:mainButtonLog
            KeyNavigation.up:mainButtonDmb
            onWheelLeftKeyPressed: mainButtonIP.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonLog.forceActiveFocus()
        }
        MComp.MMainButton{
            id:mainButtonLog

            x:16 -parent.x; y:170+47+187-parent.y-93
            bgImage: "/app/share/images/home/ico_home_screen_n.png"
            bgImagePress: "/app/share/images/home/ico_home_screen_p.png"
            bgImageFocus: "/app/share/images/home/ico_home_screen_p.png"
            bgImageActive: "/app/share/images/home/ico_home_screen_p.png"


            firstText: "Log System"

            onClickOrKeySelected: {


            }
            KeyNavigation.right:mainButtonAuto
            KeyNavigation.up:mainButtonRadio
            onWheelLeftKeyPressed: mainButtonAuto.forceActiveFocus()
            onWheelRightKeyPressed: mainButtonRadio.forceActiveFocus()
        }


        onHomeKeyPressed: {
            UIListener.HandleHomeKey();
        }

    }
}
