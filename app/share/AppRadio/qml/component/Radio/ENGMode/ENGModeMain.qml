import Qt 4.7
import "../../QML/DH" as MComp
import "../../system/DH" as MSystem

////Dmb EngineerMode 
MComp.MComponent {
//FocusScope {
    id:idRadioENGModeMain
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderRadio : imageInfo.imgFolderRadio
    property int engineerModeSelected : -1
    property int prevEngineerModeSelected : -1
    property int modeType :0      // 0: eng mode , 1: tune alignment
    property int cmd      :0      // tune alignment command
    property bool rdsPage  : QmlController.isRdsEngMode //KSW 140220
    property int engModePage : QmlController.engModePage//KSW 140220

    property int delegatefontSize       : 0
    property int delegateCellWidth      : 0
    property int delegateCellHeight     : 0
    property int delegateWidth          : 0

    property int    antMode  : 0 // -1
    property int    st : 1 // -1
    property int    bg : 1 // -1
    property int    af :  1 // -1
    property int    tmc : 1 //-1
    property int    split : -1
    property int    currentPage : -1
    property int    erase  : 0
    property int    aflog  : -1 // JSH 130508 added
    property bool   dealerMode : false // JSH 131101
    property int   page : -1 //KSW 140220
    property bool   engInfoRequest : false //dg.jin 140414
    property int    dspWtd : 1 //KSW 140515

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id : colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    //**************************************** Ch Mgt background
    Image {
        y:-(systemInfo.statusBarHeight)
        id: backGruond
        source: imgFolderGeneral+"bg.png"
    }

    //**************************************** Band
    FocusScope {
        id:idENGModeBand
        x:0; y:0
        width:systemInfo.lcdWidth; height: systemInfo.statusBarHeight
        MouseArea{ // Band button pressed  , exception handling
            anchors.fill: parent
            onClicked: {}
        }
        // Band Title
        Text{
            id:idTitleLavle
            x: 24; y:8
            text: modeType ? "Tuner Alignement" : (!idRadioENGModeMain.dealerMode) ? "Engineering Mode" : "Dealer Mode"
            font.family: systemInfo.hdb
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment : Text.AlignHCenter; //Default Center
            verticalAlignment : Text.AlignLeft;
        }

       MComp.MButton{
            id: idBackKey
            x: 1139; y: 0
            width: 141; height: 72
            bgImage: imgFolderGeneral+"btn_title_back_n.png"
            bgImagePress: imgFolderGeneral+"btn_title_back_p.png"
            bgImageFocusPress: imgFolderGeneral+"btn_title_back_fp.png"
            bgImageFocus: imgFolderGeneral+"btn_title_back_f.png"

            onClickOrKeySelected: {
                idBackKey.forceActiveFocus()
                if(modeType == 0) //KSW 140220
                {
                    console.debug(">> onClickOrKeySelected");
                    QmlController.diagnosticInfoRequest(engineerModeSelected, 0x00); // JSH 130717
                }
                engInfoRequest = false;//dg.jin 140414
                engineerMode = 0//!engineerMode
                //idFmMode2Main.forceActiveFocus();
                if(engineerModeSelected < 0)
                    return;

                //QmlController.diagnosticInfoRequest(engineerModeSelected,0x00);
                currentPage             = -1;
                engineerModeSelected    = -1; // JSH 130609
                tuneAlignmentViewInit(); //dg.jin 140414
                //console.log("onClickOrKeySelected=======================>",engineerModeSelected);
                UIListener.HandleBackKey(idAppMain.enterType);//UIListener.HandleBackKey(); , JSH 130527 modify
            }
            onWheelLeftKeyPressed: {
                if(false ==idRadioENGModeMain.dealerMode) { //dg.jin 140414
                    idAlignmentViewONOFF.focus = true
                    idAlignmentViewONOFF.forceActiveFocus()
                }
            } //# End onWheelLeftKeyPressed

            Keys.onReleased:{
                if(false ==idRadioENGModeMain.dealerMode) { //dg.jin 140414
                    if(Qt.Key_Down == event.key){
                        if(!modeType){
                            if(rdsPage == true) //KSW 140417
                            {
                            }
                            else
                            {
                                idENDModeListView.focus = true;
                                idENDModeListView.forceActiveFocus();
                            }
                        }
                        else{
                            idEngAlignmentView.focus = true;
                            idEngAlignmentView.forceActiveFocus();
                        }
                    }
                }
            }
        }
       MComp.MButton{
           id: idAlignmentViewONOFF
           x: 998 ; y: 0 //x: 1038-10; y: 0
           width: 141; height: 72
           visible: !idRadioENGModeMain.dealerMode // JSH 131101
           focus: true
           firstText:"Align OFF"
           firstTextStyle: systemInfo.hdb
           firstTextAlies: "Center"
           firstTextSize: 25

           firstTextX: 0; firstTextY: idAlignmentViewONOFF.y +30
           firstTextWidth: idAlignmentViewONOFF.width//149

           firstTextColor: colorInfo.subTextGrey
           firstTextPressColor: colorInfo.subTextGrey
           firstTextFocusPressColor: colorInfo.brightGrey
           firstTextSelectedColor: colorInfo.subTextGrey

           bgImage: imageInfo.imgFolderGeneral+"btn_title_sub_n.png"
           //bgImageActive: imageInfo.imgFolderGeneral+"btn_title_sub_fp.png"
           bgImagePress: imageInfo.imgFolderGeneral+"btn_title_sub_p.png"
           bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_title_sub_fp.png"
           bgImageFocus: imageInfo.imgFolderGeneral+"btn_title_sub_f.png"

           //dg.jin 140414
           onVisibleChanged: {
               if(!visible) {
                   idBackKey.focus = true;
                   idBackKey.forceActiveFocus();
               }
           }

           onClickOrKeySelected:{
               if(idAlignmentViewONOFF.firstText == "Align OFF"){
                   idAlignmentViewONOFF.firstText = "Align ON"
                   idRadioENGModeMain.modeType = 1
                   idEngAlignmentView.focus = true;
                   idEngAlignmentView.forceActiveFocus();  //dg.jin 140414
               }
               else{
                   idAlignmentViewONOFF.firstText = "Align OFF"
                   idRadioENGModeMain.modeType = 0
                   if(rdsPage == true)
                   {
                       //KSW 140220
                        console.debug(">>  "+QmlController.engModePage);
                       switch(QmlController.getEngModePage())
                       {
                       case 0: //RadioInfo
                           page = 5;
                           break;
                       case 1: //RDS
                           page = 1;
                           break;
                       case 2:
                           page = 4; //TMC
                           break;
                       default:
                           page = 0;
                           break;

                       }
                       console.debug(">> Align OFF onClickOrKeySelected");
                       QmlController.diagnosticInfoRequest(page,0x01);
                       return;
                   }
                   console.debug(">> Align OFF onClickOrKeySelected");
                   engInfoRequest = true; //dg.jin 140414
                   QmlController.diagnosticInfoRequest(prevEngineerModeSelected,0x01); //engineerModeSelected,0x01); // diagnosticInfoRequest start
                   idENDModeListView.focus = true;
                   idENDModeListView.forceActiveFocus(); //dg.jin 140414
               }
           }
           onWheelRightKeyPressed: {
               idBackKey.focus = true;
               idBackKey.forceActiveFocus();
           } //# End onWheelRightKeyPressed
           Keys.onReleased:{
               if(Qt.Key_Down == event.key){
                   if(!modeType){
                       if(rdsPage == true) //KSW 140417
                       {
                       }
                       else
                       {
                           idENDModeListView.focus = true;
                           idENDModeListView.forceActiveFocus();
                       }
                   }
                   else{
                       idEngAlignmentView.focus = true;
                       idEngAlignmentView.forceActiveFocus();
                   }
               }
           }

       } // End Button
    }

    //KSW 140220
    ENGModeRadioReception{
        x:0; y:86
        id: idENGModeContents
        visible: (modeType == 0) && (rdsPage == true) && (QmlController.engModePage == 0) ? true : false;
        onVisibleChanged: {
            console.log(">> ENGModeRadioReception " + QmlController.engModePage);
            if(visible) engineerModeSelected = 5; //5 radio info, 1: rds info, 4: tmc
        }
    }
    ENGModeRDSAF{
        x:0; y:86
        id: idENGModeContents2
        visible: (modeType == 0) && (rdsPage == true) && (QmlController.engModePage == 1) ? true : false;
        onVisibleChanged: {
            console.log(">> ENGModeRDSAF " + QmlController.engModePage);
            if(visible) engineerModeSelected = 1; //5 radio info, 1: rds info, 4: tmc
        }
    }
    ENGModeTMC{
        x:0; y:86
        id: idENGModeContents3
        visible: (modeType == 0) && (rdsPage == true) && (QmlController.engModePage == 2) ? true : false;
        onVisibleChanged: {
            console.log(">> ENGModeTMC " + QmlController.engModePage);
            if(visible) engineerModeSelected = 4; //5 radio info, 1: rds info, 4: tmc
        }
    }

    ENGModeListView{
        id: idENDModeListView
        x:10; y:86
        width: systemInfo.lcdWidth - (x*2); height: 90*6 //deleget.height * Item  //systemInfo.subMainHeight-83
        visible: (modeType == 0) && (!rdsPage) //KSW 140220 modify
        Component.onCompleted:{
            delegateCellWidth  = idENDModeListView.width/2
            delegateCellHeight = 72
        }
    }

    ENGModeTuneAlignmentView{ // JSH 120216
        id:idEngAlignmentView
        x:10; y:86
        width: systemInfo.lcdWidth - (x*2); height: 90*6 //deleget.height * Item  //systemInfo.subMainHeight-83
        //focus: true
        visible: modeType == 1
        onVisibleChanged: {
            if(visible == true){
                if(cmd == 0){
                    console.debug(">> ENGModeTuneAlignment onVisibleChanged");
//                    QmlController.diagnosticInfoRequest(engineerModeSelected,0x00); // diagnosticInfoRequest stop //KSW 140220
                    cmd = 0x01;
                    QmlController.tuneAlignmentCmd(cmd);
                    message1 = "Radio Alignment Ready(Tuner1_Sub)";
                    message3 = "SSG Tune 97.7MHz 200uV";
                }
            }
            else{
                cmd = 0x00;
                message1 = "";
                message3 = "";
                nextButton = "Next";

                idENGModeBand.focus = true;
                idENGModeBand.forceActiveFocus();
                QmlController.setEngModePage(0);
            }
        }
        Keys.onReleased:{
            if(Qt.Key_Up == event.key){
                idENGModeBand.focus = true;
                idENGModeBand.forceActiveFocus();
            }
        }
    }

    onVisibleChanged: {
        if(!visible){
            //engineerMode = 0//!engineerMode
            engInfoRequest = false; //dg.jin 140414
            if(engineerModeSelected < 0)
                return;

            if(modeType == 0) //KSW 140220
            {
                console.debug(">> ENGModeMain onVisibleChanged");
                QmlController.diagnosticInfoRequest(engineerModeSelected,0x00);
            }
            currentPage             = -1
            engineerModeSelected    = -1;
            tuneAlignmentViewInit(); //dg.jin 140414
            idRadioENGModeMain.dealerMode = false;
        }
    }

    ///////////////////////////////////////////////////////////////////
    // JSH 130513 Popup on/off
    Timer{
        id:idTimerSaveLogFinish
        interval: 2000 ; repeat:false
        onTriggered:{idDlgSaveLogFin.visible = false;}
    }
    MComp.MPopupTypeToast{
        id:idDlgSaveLogFin
        popupLineCnt: 1
        popupLoadingFlag: false
        popupFirstText: "Finished Copying Log File To USB."
        visible: false
        onVisibleChanged: { if(visible)idTimerSaveLogFinish.start()}

        onPopupClicked:{idDlgSaveLogFin.visible = false}
        onPopupBgClicked:{idDlgSaveLogFin.visible = false}
        onHardBackKeyClicked:{idDlgSaveLogFin.visible = false}
    }
    Connections{
        target: QmlController
        onCopyToUSB:{idDlgSaveLogFin.visible = true}
        //dg.jin 140414
        onEngModeDisPlay:{
            if(true == engModeOnOff) {
                engInfoRequest = true;
            }
        }
    }
    ///////////////////////////////////////////////////////////////////
    onBackKeyPressed:{ // JSH 130527 added
        console.debug(">> onBackKeyPressed");         //KSW 140220
        var cnt = QmlController.getEngModePage();
        if(rdsPage == true)
            QmlController.setEngModePage(0); //KSW 140220
        else if(cnt)
            QmlController.setEngModePage(--cnt);

        QmlController.diagnosticInfoRequest(engineerModeSelected,0x00); //dg.jin 140414
        engInfoRequest = false; //dg.jin 140414
        engineerMode = 0//!engineerMode
        if(engineerModeSelected < 0)
            return;
        currentPage             = -1
        engineerModeSelected    = -1;
        tuneAlignmentViewInit(); //dg.jin 140414
        //idRadioENGModeMain.dealerMode = false; //dg.jin 140414

        UIListener.HandleBackKey(idAppMain.enterType);
    }
    //KSW 140220
    onModeTypeChanged:{
        console.log(">> onModeTypeChanged ", modeType);
        if(modeType == 0) //KSW 140220
        {
            console.debug(">> onModeTypeChanged 1");
//            QmlController.diagnosticInfoRequest(engineerModeSelected,0x01);
        }
        else
        {
            console.debug(">> onModeTypeChanged 0");
            QmlController.diagnosticInfoRequest(engineerModeSelected,0x00);
        }
        QmlController.setEngModeType(modeType);
    }

    function tuneAlignmentViewInit(){
        idAlignmentViewONOFF.firstText = "Align OFF"
        idRadioENGModeMain.modeType = 0
    }
}
