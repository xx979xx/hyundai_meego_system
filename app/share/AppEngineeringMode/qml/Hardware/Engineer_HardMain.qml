import QtQuick 1.0
import "../System" as MSystem
import "../Component" as MComp
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idHardwareMain
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property bool isLeftBgArrow: true
    property int selectedItem:0
    property alias hardtList : idHardwareLeftList.menuList
    property alias backFocus: hardwareBand.backKeyButton
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    function setRightMenuScreen(index, save){
        MOp. setHardwareRightMain(index, save)
    }
    Connections{
        target:UIListener
        onShowMainGUI:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
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
        //added for BGFG structure
        onHideGUI:{
            if(isMapCareMain)
            {
                if(isMapCareEx)
                {
                    console.log("[QML] HardwareMain : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                }
                else
                {
                    console.log("[QML] HardwareMain : isMapCareMain: onHideGUI --");
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
    }

    MComp.MBand{
        id:hardwareBand
        titleText: (isMapCareMain) ? qsTr("Dealer Mode > Hardware") : qsTr("Engineering Mode > Hardware")
        subBtnFlag : true

        subKeyText:"Request"
        KeyNavigation.down:{
            idHardwareLeftList
        }
        onWheelRightKeyPressed: {
            if(hardwareBand.backKeyButton.focus == true)
                hardwareBand.bandSubButton.forceActiveFocus()
            else
                hardwareBand.backKeyButton.forceActiveFocus()
        }
        onWheelLeftKeyPressed: {
            if(hardwareBand.backKeyButton.focus == true)
                hardwareBand.bandSubButton.forceActiveFocus()
            else
                hardwareBand.backKeyButton.forceActiveFocus()
        }
        //        KeyNavigation.right:{

        //            backKeyButton
        //        }
        //        KeyNavigation.left:{
        //            bandSubButton
        //        }

        onSubKeyClicked:{
            hardwareBand.bandSubButton.forceActiveFocus()
            UIListener.RequestConnectivity();
            SendDeckSignal.sendDeckSignal();
            CanDataConnect.RequestCANData()
            SystemInfo.releaseVersionRead()
        }
        onBackKeyClicked: {

            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                //added for BGFG structure
            }
            else
            {
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
    }
    Component.onCompleted:{
        SendDeckSignal.sendDeckSignal();
        setRightMenuScreen(0, true)
        idHardwareLeftList.forceActiveFocus()
    }

    onVisibleChanged:
    {
        console.log("[QML]Software main onVisibleChanged ----")
        //setRightMenuScreen(0, true)
        idHardwareLeftList.forceActiveFocus()
        isLeftBgArrow = true

    }
    //    MComp.MCueBG_Main{
    //        id:idCueHardware
    //        visible: true
    //        property bool isLeftBg: true
    //    }
    MComp.MVisualCue{
        menuVisualCue : false
        y:357-93
        x:566
    }

    Engineer_HardwareLeftList{
        id:idHardwareLeftList
        y:85
        x:43-9
        z:2
        focus:true


        width: 537; height:89*6-5
        Keys.onRightPressed:{

            idHardwareRightList.focus = true
            idHardwareRightList.forceActiveFocus()
            idHardwareRightList
            isLeftBgArrow = false
        }
        //        KeyNavigation.right:{
        //            idHardwareRightList
        //          //  idSoftwareRightList
        //        }
        onVisibleChanged: {
        //            if(idAppMain.visible==true){

        //            }
        }
        onBackKeyPressed:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
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
        onHomeKeyPressed: {
            //added for BGFG structure
            if(isMapCareMain)
            {
                if(isMapCareEx)
                {
                    console.log("[QML]Return HOME Screen :: At MapCare Hardware")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }
                else
                {
                    console.log("[QML]Return HOME Screen :: At MapCare Hardware")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }


            }
            else
            {
                console.log("[QML]Return HOME Screen :: At Hardware")
                mainViewState="Main"
                setMainAppScreen("", true)
            }
            isMapCareMain = false
            //added for BGFG structure
            UIListener.HandleHomeKey();
        }
    }
    MComp.MComponent{
        id:idHardwareRightList
        x:708
        y:85
        z:2
        width:systemInfo.lcdWidth-708
        height:systemInfo.lcdHeight-166

       // playBeepOn:false

        Loader  {   id: idVersionLoader    }
        Loader  {   id: idConnectivityLoader }
        Loader  {   id: idDeckLoader   }

        Keys.onLeftPressed:{
            idHardwareLeftList.focus = true
            idHardwareLeftList.forceActiveFocus()
            idHardwareLeftList
             isLeftBgArrow = true
        }

        onBackKeyPressed: {
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    console.log("[QML] Software  : RightList: onBackKeyClicked -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    console.log("[QML] Software  : RightList: onBackKeyClicked -----------")
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
                    //idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main Software :::")

                      //idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
            }

        }
        onHomeKeyPressed: {
            //added for BGFG structure
            if(isMapCareMain)
            {
                if(isMapCareEx)
                {
                    console.log("[QML]Return HOME Screen :: At MapCare Hardware")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }
                else
                {
                    console.log("[QML]Return HOME Screen :: At MapCare Hardware")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)

                }


            }
            else
            {
                console.log("[QML]Return HOME Screen :: At Hardware")
                mainViewState="Main"
                setMainAppScreen("", true)
            }
            isMapCareMain = false
            //added for BGFG structure
            UIListener.HandleHomeKey();
        }

    }



    //visual Cue BG
    Image
    {
        y:92
        //y: 32
       x: 588
        source: "/app/share/images/AppEngineeringMode/img/general/scroll_menu_bg.png"
       visible: false //( list_view.count > 6 )
       Item
       {
          // y:parent.y
           height: hardtList.visibleArea.heightRatio * 350
           y:350 * hardtList.visibleArea.yPosition
          //height: idMenuListView.visibleArea.heightRatio * 478
          //y: 478 * idMenuListView.visibleArea.yPosition
           visible:true
          Image
          {
             y: -parent.y
             source: "/app/share/images/AppEngineeringMode/img/general/scroll_menu.png"
          }
          width: parent.width
          clip: true
       }
    }
    Image{
        x:0
        y:73
        visible:isLeftBgArrow
        source: imgFolderGeneral+"bg_menu_l_s.png"
    }
    Image{
        x:585
        y:73
        z:0
        visible:!isLeftBgArrow
        source: imgFolderGeneral+"bg_menu_r_s.png"
    }

//    Image
//    {
//       id: visual_cue_bg
//       source: "/app/share/images/general/menu_visual_cue_bg.png"
//       x: 560
////       y: 191
//       y:251
//       Image
//       {
//          x: 28
//          y: 65
//          source: isLeftBgArrow ? "/app/share/images/general/menu_visual_cue_arrow_l_n.png" :
//                                      "/app/share/images/general/menu_visual_cue_arrow_l_p.png"
//       }
//       Image
//       {
//          x: 93
//          y: 65
//          source: /*list_model[ctrl.selected_index][Const.ID_ITEM_RIGHT_CONTENT] &&*/
//                  isLeftBgArrow ?
//                      "/app/share/images/general/menu_visual_cue_arrow_r_p.png" :
//                      "/app/share/images/general/menu_visual_cue_arrow_r_n.png"
//       }
//    }

    onBackKeyPressed: {
        if(isMapCareMain)
        {
            //added for BGFG structure
            if(isMapCareEx)
            {
                console.log("[QML] Hardware  : AtBottomLine: onBackKeyPressed -----------")
                mainViewState = "MapCareMainEx"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            else
            {
                console.log("[QML] Hardware  : AtBottomLine: onBackKeyPressed -----------")
                mainViewState = "MapCareMain"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            //added for BGFG structure
        }
        else
        {
            mainViewState="Main"
            setMainAppScreen("", true)
        }

    }
}
