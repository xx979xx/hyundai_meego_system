import QtQuick 1.0
import "../System" as MSystem
import "../Component" as MComp
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idSoftwareMain
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property bool isLeftBgArrow: true
    property int selectedItem:0
    property alias softList : idSoftwareLeftList.menuList
    property alias backFocus: softwareBand.backKeyButton
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    function setRightMenuScreen(index, save){
        MOp.setRightMain(index, save)
    }
    MComp.DimPopUp{
        id:idRefreshSoftVersion
        textLineCount: 1
        loadingFlag: true
        firstText: "Request Version Information ..."
        visible: false
        z:100
        onVisibleChanged: {
            if(visible){
                idRefreshSoftVersion.forceActiveFocus()
                idTimerRefreshSoftVer.start()
            }
        }

    }
    MComp.DimPopUp{
        id:idRefreshSoftVerEnd
        textLineCount: 1
        loadingFlag: false
        firstText: "Version Information Refresh END."
        visible: false
        z:100
        onVisibleChanged: { if(visible)idTimerSoftVerEnd.start()   }

    }
    Timer{
        id:idTimerRefreshSoftVer
        interval: 3000
        repeat:false
        onTriggered:
        {
            idRefreshSoftVersion.forceActiveFocus()
            //SystemInfo.CompareVersion();
            idRefreshSoftVersion.visible = false
            idRefreshSoftVerEnd.visible = true
            idRefreshSoftVerEnd.forceActiveFocus()
        }
    }
    Timer{
        id:idTimerSoftVerEnd
        interval: 2000
        repeat:false
        onTriggered:
        {
            idRefreshSoftVerEnd.visible = false
            UIListener.reqRefreshSoftVersion();
            softwareBand.bandSubButton.forceActiveFocus()
        }
    }

    MComp.MBand{
        id:softwareBand
        titleText: (isMapCareMain) ? qsTr("Dealer Mode > Software") : qsTr("Engineering Mode > Software")
        subBtnFlag: true
        subKeyText:"Request"
        KeyNavigation.down:{

            idSoftwareLeftList

        }
        onWheelRightKeyPressed: {
            if(softwareBand.backKeyButton.focus == true)
                softwareBand.bandSubButton.forceActiveFocus()
            else
                softwareBand.backKeyButton.forceActiveFocus()
        }
        onWheelLeftKeyPressed: {
            if(softwareBand.backKeyButton.focus == true)
                softwareBand.bandSubButton.forceActiveFocus()
            else
                softwareBand.backKeyButton.forceActiveFocus()
        }

        onBackKeyClicked: {
            if(isMapCareMain)
            {
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
            else
            {
                console.log("Enter Software Main Back Key or Click==============")
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){
                    console.log("Enter Simple Main Software :::")
                   // idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main Software :::")
                      //idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
            }


        }
        onSubKeyClicked: {
            sendRequest.SendReqSignal();
            sendBTRequest.SendBTReqSignal();
            SendDeckSignal.sendDeckSignal();
            reqVersion.SendReqVer();
            CanDataConnect.RequestCANData()
            VariantSetting.reqGPSVersion();
            SystemInfo.getBiosVersion();
            idRefreshSoftVersion.visible = true
            UIListener.clearSoftVersionModel();
        }
    }
    Component.onCompleted:{
        //VariantSetting.reqGPSVersion();
        SendDeckSignal.sendDeckSignal();
        CanDataConnect.RequestCANData();
        setRightMenuScreen(0, true)
        idSoftwareLeftList.forceActiveFocus()
    }
    onVisibleChanged:
    {
        console.log("[QML]Software main onVisibleChanged ----")
        //setRightMenuScreen(0, true)
        idSoftwareLeftList.forceActiveFocus()
        isLeftBgArrow = true

    }
    MComp.MVisualCue{
        menuVisualCue : false
        y:357-93
        x:566
    }

    Engineer_SoftwareLeftList{
        id:idSoftwareLeftList
        y:85
        x:43-9
        z:2
        focus:true

        width: 537; height:89*6-5
        Keys.onRightPressed:{

            idSoftwareRightList.focus = true
            idSoftwareRightList.forceActiveFocus()
            idSoftwareRightList
            isLeftBgArrow = false
        }

        onVisibleChanged: {

        }
        onBackKeyPressed:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    console.log("[QML] Software  : LeftList: onBackKeyClicked -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    console.log("[QML] Software  : LeftList: onBackKeyClicked -----------")
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


            }
            else
            {
                console.log("[QML]Return HOME Screen :: At Software")
                mainViewState="Main"
                setMainAppScreen("", true)
            }
            isMapCareMain = false
            //added for BGFG structure
            UIListener.HandleHomeKey();
        }
    }
    MComp.MComponent{
        id:idSoftwareRightList
        x:708
        y:85
        z:2
        width:systemInfo.lcdWidth-708
        height:systemInfo.lcdHeight-166


        Loader  {   id: idHeadUnitLoader    }
        Loader  {   id: idPeripheralsLoader }
        Loader  {   id: idBluetoothLoader   }
        Loader  {   id: idCANDBLoader    }
        Loader  {   id: idPhoneBookPatternLoader } //added for PhoneBook Pattern Setting
        Loader  {   id: idASDLoader }
        Keys.onLeftPressed:{
            idSoftwareLeftList.focus = true
            idSoftwareLeftList.forceActiveFocus()
            idSoftwareLeftList
            isLeftBgArrow = true
        }
        Keys.onUpPressed:{
            softwareBand.backKeyButton.forceActiveFocus()
            softwareBand
        }

        //        KeyNavigation.left:{
        //            idSoftwareLeftList
        //        }
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


            }
            else
            {
                console.log("[QML]Return HOME Screen :: At Software")
                mainViewState="Main"
                setMainAppScreen("", true)
            }
            isMapCareMain = false
            //added for BGFG structure
            UIListener.HandleHomeKey();
        }

    }
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
        //added for BGFG structure
        onHideGUI:{
            if(isMapCareMain)
            {
                if(isMapCareEx)
                {
                    console.log("[QML] SoftwareMain : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                }
                else
                {
                    console.log("[QML] SoftwareMain : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                }


            }

            console.log("[QML] SoftwareMain : onHideGUI --");
            isMapCareMain = false
            mainViewState="Main"
            setMainAppScreen("", true)
        }
        //added for BGFG structure
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
           height: softList.visibleArea.heightRatio * 350
           y:350 * softList.visibleArea.yPosition
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

    onBackKeyPressed: {
        if(isMapCareMain)
        {
            //added for BGFG structure
            if(isMapCareEx)
            {
                console.log("[QML] Software  : AtBottomLine: onBackKeyPressed -----------")
                mainViewState = "MapCareMainEx"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            else
            {
                console.log("[QML] Software  : AtBottomLine: onBackKeyPressed -----------")
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
