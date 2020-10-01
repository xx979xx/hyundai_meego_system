import QtQuick 1.0
import "../System" as MSystem
import "../Component" as MComp
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idSysConfigMain
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property bool isLeftBgArrow: true
    property int selectedItem:0
    property alias systemlist: idSystemConfigLeftList.menuList
    property alias backFocus: systemConfigBand.backKeyButton
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property alias rightBg: idRightMenuBg

    function setRightMenuScreen(index, save){
        MOp. setSystemConfigRightMain(index, save)
    }
    Connections{
        target:UIListener
        onShowMainGUI:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    //console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    //console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
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

    MComp.MBand{
        id:systemConfigBand
        titleText: qsTr("Engineering Mode > System Config")
        onBackKeyClicked: {
            mainViewState="Main"
            idMainView.forceActiveFocus()
            setMainAppScreen("", true)

        }
        KeyNavigation.down:idSystemConfigLeftList
    }
    Component.onCompleted:{
        setRightMenuScreen(0, true)
        idSystemConfigLeftList.forceActiveFocus()

    }
    onVisibleChanged:
    {
        console.log("[QML]Software main onVisibleChanged ----")
        //setRightMenuScreen(0, true)
        idSystemConfigLeftList.forceActiveFocus()
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

    Engineer_SystemConfigLeftList{
        id:idSystemConfigLeftList
        y:85
        x:43-9
        z:2
        focus:true


        width: 537; height:89*6-5
        //        KeyNavigation.right:{
        //            idSystemConfigRightList
        //          //  idSoftwareRightList
        //        }
        Keys.onRightPressed:{
            idSystemConfigRightList.focus = true
            idSystemConfigRightList.forceActiveFocus()
            idSystemConfigRightList
            isLeftBgArrow = false
            //rightBg.visible = true
        }
        onVisibleChanged: {
            if(idAppMain.visible==true){

            }
        }
        onBackKeyPressed:{
            console.log("press Backkey > idSettingsLeftList")
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
        onHomeKeyPressed: {
         UIListener.HandleHomeKey();
        }
    }
    MComp.MComponent{
        id:idSystemConfigRightList
        x:708
        y:85
        z:2
        width:systemInfo.lcdWidth-708
        height:systemInfo.lcdHeight-166

        Loader  {   id: idSystemLoader    }
        Loader  {   id: idLogDataLoader }
        Loader  {   id: idSoundLoader   }
        //KeyNavigation.left:idSystemConfigLeftList
        Keys.onLeftPressed:{

            idSystemConfigLeftList.focus = true
            idSystemConfigLeftList.forceActiveFocus()
            idSystemConfigLeftList
            //rightBg.visible = false
            isLeftBgArrow = true
        }
        onBackKeyPressed: {
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
        onHomeKeyPressed: {
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
          height: systemlist.visibleArea.heightRatio * 350
          y: 350 * systemlist.visibleArea.yPosition
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
        mainViewState="Main"
        setMainAppScreen("", true)
    }

}
