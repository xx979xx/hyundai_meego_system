import QtQuick 1.0
import "../System" as MSystem
import "../Component" as MComp
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idUpdateMain
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property bool isLeftBgArrow: true
    property int selectedItem:0
    property alias updateList: idUpdateLeftList.menuList
    property alias backFocus: updateBand.backKeyButton
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property alias rightBg: idRightMenuBg


    function setRightMenuScreen(index, save){
        MOp.setRightUpdateMain(index, save)
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
        id:updateBand
        titleText: qsTr("Engineering Mode > S/W Update")
        KeyNavigation.down:idUpdateLeftList
//        subBtnFlag: true
//        subKeyText:"Execute"

//        onSubKeyClicked: {
//            UIListener.hideHomeStatusBar();
//            UIListener.executeAMOS();
//        }

        onBackKeyClicked: {
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
    Component.onCompleted:{

        //idUpdateMain.forceActiveFocus()
        setRightMenuScreen(0, true)
        idUpdateLeftList.forceActiveFocus()
    }
//    MComp.MCueBG_Main{
//        id:idCueUpdate
//        visible: true
//        property bool isLeftBg: true
//    }
    MComp.MVisualCue{
        menuVisualCue : false
        y:357-93
        x:566
    }
    Engineer_UpdateLeftList{
        id:idUpdateLeftList
        y:85
        x:43-9
        z:2
        focus:true
        width: 537; height:89*6-5
        //        KeyNavigation.right:{
        //            idUpdateRightList
        //          //  idUpdateRightList
        //        }
        Keys.onRightPressed:{
            idUpdateRightList.focus = true
            idUpdateRightList.forceActiveFocus()
            idUpdateRightList
            isLeftBgArrow = false
            //rightBg.visible = true
        }
        onVisibleChanged: {
            if(idAppMain.visible==true){

            }
        }
        onBackKeyPressed:{
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
        id:idUpdateRightList
        x:708
        y:85
        z:2
        width:systemInfo.lcdWidth-708
        height:systemInfo.lcdHeight-166

        Loader  {   id: idUpdateUSBLoader    }
        Loader  {   id: idUpdateiBoxLoader }
        Keys.onLeftPressed:{

            idUpdateLeftList.focus = true
            idUpdateLeftList.forceActiveFocus()
            idUpdateLeftList
            //rightBg.visible = false
            isLeftBgArrow = true
        }
        //KeyNavigation.left:idUpdateLeftList
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
          height: updateList.visibleArea.heightRatio * 350
          y: 350 * updateList.visibleArea.yPosition
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
        id: idLeftMenuBg
        visible:isLeftBgArrow
        source: imgFolderGeneral+"bg_menu_l_s.png"
    }
    Image{
        x:585
        y:73
        z: 0
        id: idRightMenuBg
        visible:!isLeftBgArrow
        source: imgFolderGeneral+"bg_menu_r_s.png"
    }
}

