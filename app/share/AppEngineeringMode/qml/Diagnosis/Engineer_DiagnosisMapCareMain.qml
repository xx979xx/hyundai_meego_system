import QtQuick 1.0
import "../System" as MSystem
import "../Component" as MComp
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idDiagnosisMainMenu
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property bool isLeftBgArrow: true
    property int selectedItem:0
    property alias diagnosisList : idDiagnosisLeftList.menuList
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property alias backFocus: diagnosisBand.backKeyButton
    property alias rightBg: idRightMenuBg
    function setPopUpScreen(index, save){
        MOp.setDiagnosisPopUp(index, save)
    }

    function setRightMenuScreen(index, save){
        MOp.setDiagnosisMapCareRightMain(index, save)
    }
    Connections{
        target:UIListener
        onShowMainGUI:{
            if(isMapCareMain)
            {
                if(isMapCareEx){
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else{
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }


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
                    console.log("[QML] Diagnosis : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                }
                else
                {
                    console.log("[QML] Diagnosis : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                }


            }

            console.log("[QML] Diagnosis : onHideGUI --");
            isMapCareMain = false
            mainViewState="Main"
            setMainAppScreen("", true)
        }
        //added for BGFG structure
    }
    Engineer_DeleteDTC_PopUp
     {
         id:idENGDeletePopUp
         y:0; z:100
         visible:false

         onVisibleChanged: {
             if(visible){
                 idENGDeletePopUp.focus =true;
             }
             else if(visible == false){
                 idDiagnosisRightList .focus = true
                 idDiagnosisRightList.forceActiveFocus()
                 idDiagnosisRightList
             }
        }
     }
    Engineer_Diagnosis_MostResetPopUp{
        id:idENGMostResetPopUp
        y:0; z:100
        visible:false
        onVisibleChanged: {
            if(visible){
                idENGMostResetPopUp.focus =true;
            }
            else if(visible == false){
                idDiagnosisRightList .focus = true
                idDiagnosisRightList.forceActiveFocus()
                idDiagnosisRightList
            }

        }

    }
    Engineer_Diagnosis_DeleteNaviPopUp{
        id:idENGDelNaviPopUp
        y:0; z:100
        visible:false
        onVisibleChanged: {
            if(visible){
                idENGDelNaviPopUp.focus = true
            }
            else if(visible == false){
                idDiagnosisRightList .focus = true
                 idDiagnosisRightList.forceActiveFocus()
                idDiagnosisRightList
            }

        }

    }
    Engineer_Diagnosis_SetDeliveryPopUp{
        id:idENGSetDelPopUp
        y:0; z:100
        visible:false
        onVisibleChanged: {
            if(visible){
                idENGSetDelPopUp.focus = true
            }
            else if(visible == false){
                idDiagnosisRightList .focus = true
                idDiagnosisRightList.forceActiveFocus()
                idDiagnosisRightList
            }

        }

    }


    MComp.MBand{
        id:diagnosisBand
        titleText: qsTr("Dealer Mode > Diagnosis")
        KeyNavigation.down: {

            idDiagnosisLeftList
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
                ///CpuDegree.stopGetDegree();
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){

                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      idFullMainView.forceActiveFocus()
                }

            }


        }
    }
    Component.onCompleted:{

        setRightMenuScreen(0, true)
        idDiagnosisLeftList.forceActiveFocus()
    }
    onVisibleChanged:
    {
        console.log("[QML]Software main onVisibleChanged ----")
        //setRightMenuScreen(0, true)
        idDiagnosisLeftList.forceActiveFocus()
        isLeftBgArrow = true

    }

    MComp.MVisualCue{
        menuVisualCue : false
        y:357-93
        x:566
    }

    Engineer_DiagnosisLeftList{
        id:idDiagnosisLeftList
        y:85
        x:43-9
        z:2
        focus:true


        width: 537; height:89*6-5

        Keys.onRightPressed:{

            idDiagnosisRightList.focus = true
            idDiagnosisRightList.forceActiveFocus()
            idDiagnosisRightList
            isLeftBgArrow = false
            //rightBg.visible = true
        }
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
                    console.log("[QML]Return HOME Screen :: At MapCare Diagnosis")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }
                else
                {
                    console.log("[QML]Return HOME Screen :: At MapCare Diagnosis")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }


            }
            else
            {
                console.log("[QML]Return HOME Screen :: At Diagnosis")
                mainViewState="Main"
                setMainAppScreen("", true)
            }
            isMapCareMain = false
            //added for BGFG structure
            //CpuDegree.stopGetDegree();
            UIListener.HandleHomeKey();
        }
    }
    MComp.MComponent{
        id:idDiagnosisPopUpLoader
        y:0
        Loader  {   id:idDeletePopUp;   }
        Loader  {   id:idMostRBDPopUp;  }
        Loader  {   id:idDeleteNaviPopUp;   }

    }

    MComp.MComponent{
        id:idDiagnosisRightList
        x:708
        y:85
        z:2
        width:systemInfo.lcdWidth-708
        height:systemInfo.lcdHeight-166

        Loader  {   id: idDTCMapCareLoader    }
        Loader  {   id: idMOSTMapCareLoader }
        Loader  {   id: idCommandMapCareLoader   }
        //Loader  {   id:idHULoader    }
        //Loader  {   id:idDTCResponseLoader  }
        //Loader  {   id:idModuleResetLoader  }
        Keys.onLeftPressed:{
            idDiagnosisLeftList.focus = true
            idDiagnosisLeftList.forceActiveFocus()
            idDiagnosisLeftList
            rightBg.visible = false
            isLeftBgArrow = true
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
                //CpuDegree.stopGetDegree();
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){

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
                    console.log("[QML]Return HOME Screen :: At MapCare Diagnosis")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }
                else
                {
                    console.log("[QML]Return HOME Screen :: At MapCare Diagnosis")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    //idMapCareMainView.forceActiveFocus()
                    mainViewState="Main"
                    setMainAppScreen("", true)
                }


            }
            else
            {
                console.log("[QML]Return HOME Screen :: At Diagnosis")
                mainViewState="Main"
                setMainAppScreen("", true)
            }
            isMapCareMain = false
            //added for BGFG structure
            //CpuDegree.stopGetDegree();
            UIListener.HandleHomeKey();
        }

    }



    //visual Cue BG
    Image
    {
        y:92

        x: 588
        source: "/app/share/images/AppEngineeringMode/img/general/scroll_menu_bg.png"
        visible: false //( list_view.count > 6 )
       Item
       {
          height: diagnosisList.visibleArea.heightRatio * 350
          y: 350 * diagnosisList.visibleArea.yPosition
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
