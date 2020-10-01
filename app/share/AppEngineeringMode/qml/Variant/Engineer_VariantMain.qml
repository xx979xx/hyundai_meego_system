import QtQuick 1.0
import "../System" as MSystem
import "../Component" as MComp
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idVariantMain
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property bool isLeftBgArrow: true
    property int selectedItem:0
    property alias variantList: idVariantLeftList.menuList
    property int navigation:  variant.ParkingAssist1
    property alias backFocus: variantBand.backKeyButton
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property alias rightBg: idRightMenuBg

    function setRightMenuScreen(index, save){
        MOp.setVariantRightMain(index, save)
    }

    MComp.MBand{
        id:variantBand
        titleText: (isMapCareMain) ? qsTr("Dealer Mode > Variant") :qsTr("Engineering Mode > Variant")
        subBtnFlag: true
        subKeyText: "Send"
        KeyNavigation.down:{

            idVariantLeftList

        }
        onWheelRightKeyPressed: {
            if(variantBand.backKeyButton.focus == true)
                variantBand.bandSubButton.forceActiveFocus()
            else
                variantBand.backKeyButton.forceActiveFocus()
        }
        onWheelLeftKeyPressed: {
            if(variantBand.backKeyButton.focus == true)
                variantBand.bandSubButton.forceActiveFocus()
            else
                variantBand.backKeyButton.forceActiveFocus()
        }
        //        KeyNavigation.right:backKeyButton
        //        KeyNavigation.left:bandSubButton
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
                    //idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      idFullMainView.forceActiveFocus()
                }
            }



        }
        onSubKeyClicked: {
            variantBand.bandSubButton.forceActiveFocus()
            VariantSetting.Send_Variant_Data();
        }
    }
    Component.onCompleted:{
        //idVariantMain.forceActiveFocus()
        setRightMenuScreen(0, true)
        idVariantLeftList.forceActiveFocus()
    }
    onVisibleChanged:
    {
        console.log("[QML]Variant main onVisibleChanged ----")
        //setRightMenuScreen(0, true)
        idVariantLeftList.forceActiveFocus()
        isLeftBgArrow = true

    }

    MComp.MVisualCue{
        menuVisualCue : false
        y:357-93
        x:566
    }
    Engineer_VariantLeftList{
        id:idVariantLeftList
        y:85
        x:43-9
        z:2
        focus:true


        width: 537; height:89*6-5
        Keys.onRightPressed:{
            idVariantRightList.focus = true
            idVariantRightList.forceActiveFocus()
            idVariantRightList
            isLeftBgArrow = false
            //rightBg.visible = true
        }

        //        KeyNavigation.right:{
        //            idVariantRightList
        //          //  idVariantRightList
        //        }
        onVisibleChanged: {
            if(idAppMain.visible==true){

            }
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
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){
                    //idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
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
                    console.log("[QML]Return HOME Screen :: At MapCare Variant")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }
                else
                {
                    console.log("[QML]Return HOME Screen :: At MapCare Variant")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }


            }
            else
            {
                console.log("[QML]Return HOME Screen :: At Variant")
                mainViewState="Main"
                setMainAppScreen("", true)
            }
            isMapCareMain = false
            //added for BGFG structure
            UIListener.HandleHomeKey();
        }
    }
    MComp.MComponent{
        id:idVariantRightList
        x:708
        y:85
        z:2
        width:systemInfo.lcdWidth-708
        height:systemInfo.lcdHeight-166

        Loader  {   id: idVehicleLoader    }
        Loader  {   id: idCountryLoader }
        Loader  {   id: idVariantSystemLoader   }
        Loader  {   id:idDVDRegionLoader    }
        Keys.onLeftPressed:{
            idVariantLeftList.focus = true
            idVariantLeftList.forceActiveFocus()
            idVariantLeftList
            //rightBg.visible = false
            isLeftBgArrow = true
        }

        //KeyNavigation.left:idVariantLeftList
        onBackKeyPressed: {
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
                    //idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
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
                    console.log("[QML]Return HOME Screen :: At MapCare Variant")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }
                else
                {
                    console.log("[QML]Return HOME Screen :: At MapCare Variant")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }


            }
            else
            {
                console.log("[QML]Return HOME Screen :: At Variant")
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
          height: variantList.visibleArea.heightRatio * 350
          y: 350 * variantList.visibleArea.yPosition
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
        id: idRightMenuBg
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
        }

    }
}

