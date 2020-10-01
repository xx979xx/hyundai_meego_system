/**
 * FileName: MOptionMenu.qml
 * Author: WSH
 * Time: 2012-02-08
 *
 * - 2012-02-08 Initial Crated by WSH
 * - 2012-04-19 Added signal, event 16~20 by WSH
 * - 2012-04-20 [Added Connection] Receive onVisualCueTimerStoped by WSH
 * - 2012-06-01 [Added Timer] Created Timer in OptionMenu by WSH
 * - 2012-06-01 [Added signal] Send optionMenuFinished() by WSH
 * - 2012-06-08 [Added prevent code] resetTimer() by WSH
 * - 2012-06-08 [Reverted revision 1800] by WSH
 * - 2012-07-25 Updated [DH Genesis_Guideline_General_PlanB_v1.2.1] by WSH
 * - 2013-01-02 Dim bg Image -> Dim bg Rectangle(80%)
 * - 2013-01-03 Updated Component (MComponent.qml) by WSH
 * - 2013-01-03 Modified property (menu#Dimmed -> menu#Enabled) by WSH
 *    : # (0 ~ 10)
 * - 2013-01-03 Modified property value (menu#Dimmed: false -> menu#Enabled: true) by WSH
 */
import QtQuick 1.0
import "../../system/DH" as MSystem

MComponent { // FocusScope { // # (for "onClickMenuKey" use) by HYANG #
    id: idMOptionMenu
    x: 0; y: 0; z: parent.z + 1
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight //720-93
    focus: true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo ; langId: idAppMain.generalMirrorMode ? 20 : idMOptionMenu.langID } // JSH 130715 modify

    property int langID

    property QtObject linkedModels ;
    property QtObject linkedDelegate : Component{MOptionMenuDelegate {}}
    property QtObject linkedCurrentItem ;
    property alias linkedCurrentIndex : idMOptionMenuList.lCurrentIndex  // JSH 120612
    property string menuDepth: "OneDepth" //"OneDepth" or "TwoDepth" # added by HYANG_20120228

    //--------------------- Timer Info(Property) #
    property int timerCount : 1;
    property int timerMaxCount : 5;
    signal optionMenuFinished()  // Send signal, after 5 sec # by WSH

    //--------------------- Image Path Info(Property) #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    //--------------------- RadioSeleted Info(Property) ##
    property int selectedRadioIndex: 0

    //--------------------- OptionMenu Info(Property) #
    property string opBgImg : imgFolderGeneral + "bg_optionmenu.png"
    property int opBgWidth: systemInfo.lcdWidth - 767  //menuDepth=="OneDepth"? systemInfo.lcdWidth - 767 : systemInfo.lcdWidth - 807
    property int opBgMenuX: (!bandMirrorMode) ? 767 : 0  //(menuDepth=="OneDepth"? 767 : 807) :0
    property int opLeftMargine: (!bandMirrorMode) ? 845-767 : 5+opScrollWidth   //(menuDepth=="OneDepth"? 845-767 : 885-807) : 5+opScrollWidth
    property string opViewImg: ""
    property int opViewImgWidth: 347
    property int opViewImgHeight: 199
    property int opViewRightMargin: (!bandMirrorMode) ? (systemInfo.lcdWidth-908)-opViewImgWidth  : 767  //(menuDepth=="OneDepth"? 767  : 807)
    property int opViewTopMargin: 429-systemInfo.statusBarHeight
    property bool opViewImgVisible: false

    //--------------------- Delegate Info(Property) #
    property int delegateWidth: listLeftMargine + opItemWidth

    //--------------------- Item Text Info(Property) ##
    property int opItemWidth: 385    //menuDepth=="OneDepth"? 385 : 345
    property int opItemHeight: 78
    property int opItemFontSize : 32
    property string opItemFontName: systemInfo.hdr // (langID >= 3 && langID <=5) ? "CHINESS_HDR" : systemInfo.hdr//"HDR" //"HDB" HWS => JSH 131028 modify

    //--------------------- List Info(Property) ##
    property int listAreaWidth: bandMirrorMode ? 416 : opBgWidth - opLeftMargine + (listLeftFocusMargine*2) // 435+6 : 395+6
    property int listLeftFocusMargine : 3
    property int listLeftMargine : 27//(!bandMirrorMode) ? 27 : 20 //2013.12.18 modified by qutiguy ITS 2159431

    //--------------------- Line Info(Property) ##
    property int opLineY: 80 // JSH 130808  77 -> 80 ->81 Modify //dg.jin 20140820 ITS 0243389 full focus issue 81->80  for KH
    property int opLineHeight: 2
    property string opLineImg: imgFolderGeneral + "line_optionmenu.png"   //menuDepth=="OneDepth"? imgFolderGeneral + "line_optionmenu.png" : imgFolderGeneral + "line_optionmenu_02.png"

    //--------------------- Scroll Info(Property) ##
    property int opScrollWidth: 13
    property int opScrollY: 5

    //--------------------- Icon Info(Property) ##
    property int opIconX: 356  // menuDepth=="OneDepth"? 356: 316

    //--------------------- Button Info(Property) #
    property string opBgImagePress : imgFolderGeneral + "bg_optionmenu_list_p.png"
    property string opBgImageFocusPress : imgFolderGeneral + "bg_optionmenu_list_fp.png"
    property string opBgImageFocus : imgFolderGeneral + "bg_optionmenu_list_f.png"

    // # We need width 355 , But [bg_optionmenu_list_02_p.png width] width is 300.
    //menuDepth=="OneDepth"? imgFolderGeneral + "bg_optionmenu_list_p.png" : imgFolderGeneral + "bg_optionmenu_list_02_p.png"
    //menuDepth=="OneDepth"? imgFolderGeneral + "bg_optionmenu_list_fp.png" : imgFolderGeneral + "bg_optionmenu_list_02_fp.png"
    // menuDepth=="OneDepth"? imgFolderGeneral + "bg_optionmenu_list_f.png" : imgFolderGeneral + "bg_optionmenu_list_02_f.png"

    property bool   menuAnimation : false // JSH 130418 added menuAnimation
    property bool   bandMirrorMode: false
    property int    startX  : 0
    property int    endX    : 0
    property int    tempX   : 0
    property bool   subMenuClose    : false // JSH 130627 added sub Menu Close

    //--------------------- Dim Info(Property) #
    property bool menu0Enabled: true
    property bool menu1Enabled: true
    property bool menu2Enabled: true
    property bool menu3Enabled: true
    property bool menu4Enabled: true
    property bool menu5Enabled: true
    property bool menu6Enabled: true
    property bool menu7Enabled: true
    property bool menu8Enabled: true
    property bool menu9Enabled: true
    property bool menu10Enabled: true
    property bool menu11Enabled: true
    property bool menu12Enabled: true
    property bool menu13Enabled: true
    property bool menu14Enabled: true
    property bool menu15Enabled: true
    property bool menu16Enabled: true
    property bool menu17Enabled: true
    property bool menu18Enabled: true
    property bool menu19Enabled: true
    property bool menu20Enabled: true

    //--------------------- Default Click Event(Signal) #
    signal menu0Click()
    signal menu1Click()
    signal menu2Click()
    signal menu3Click()
    signal menu4Click()
    signal menu5Click()
    signal menu6Click()
    signal menu7Click()
    signal menu8Click()
    signal menu9Click()
    signal menu10Click()
    signal menu11Click()
    signal menu12Click()
    signal menu13Click()
    signal menu14Click()
    signal menu15Click()
    signal menu16Click()
    signal menu17Click()
    signal menu18Click()
    signal menu19Click()
    signal menu20Click()

    //--------------------- Radio Click Event(Signal) #
    signal radio0Click()
    signal radio1Click()
    signal radio2Click()
    signal radio3Click()
    signal radio4Click()
    signal radio5Click()
    signal radio6Click()
    signal radio7Click()
    signal radio8Click()
    signal radio9Click()
    signal radio10Click()
    signal radio11Click()
    signal radio12Click()
    signal radio13Click()
    signal radio14Click()
    signal radio15Click()
    signal radio16Click()
    signal radio17Click()
    signal radio18Click()
    signal radio19Click()
    signal radio20Click()

    //--------------------- DimCheck Click Event(Signal) #
    signal dimCheck0Click()
    signal dimCheck1Click()
    signal dimCheck2Click()
    signal dimCheck3Click()
    signal dimCheck4Click()
    signal dimCheck5Click()
    signal dimCheck6Click()
    signal dimCheck7Click()
    signal dimCheck8Click()
    signal dimCheck9Click()
    signal dimCheck10Click()
    signal dimCheck11Click()
    signal dimCheck12Click()
    signal dimCheck13Click()
    signal dimCheck14Click()
    signal dimCheck15Click()
    signal dimCheck16Click()
    signal dimCheck17Click()
    signal dimCheck18Click()
    signal dimCheck19Click()
    signal dimCheck20Click()

    //--------------------- DimUncheck Click Event(Signal) #
    signal dimUncheck0Click()
    signal dimUncheck1Click()
    signal dimUncheck2Click()
    signal dimUncheck3Click()
    signal dimUncheck4Click()
    signal dimUncheck5Click()
    signal dimUncheck6Click()
    signal dimUncheck7Click()
    signal dimUncheck8Click()
    signal dimUncheck9Click()
    signal dimUncheck10Click()
    signal dimUncheck11Click()
    signal dimUncheck12Click()
    signal dimUncheck13Click()
    signal dimUncheck14Click()
    signal dimUncheck15Click()
    signal dimUncheck16Click()
    signal dimUncheck17Click()
    signal dimUncheck18Click()
    signal dimUncheck19Click()
    signal dimUncheck20Click()

    //--------------------- Default Click Event(Function) #
    function indexEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.menu0Click(); break; } // End case
        case 1:{ idMOptionMenu.menu1Click(); break; } // End case
        case 2:{ idMOptionMenu.menu2Click(); break; } // End case
        case 3:{ idMOptionMenu.menu3Click(); break; } // End case
        case 4:{ idMOptionMenu.menu4Click(); break; } // End case
        case 5:{ idMOptionMenu.menu5Click(); break; } // End case
        case 6:{ idMOptionMenu.menu6Click(); break; } // End case
        case 7:{ idMOptionMenu.menu7Click(); break; } // End case
        case 8:{ idMOptionMenu.menu8Click(); break; } // End case
        case 9:{ idMOptionMenu.menu9Click(); break; } // End case
        case 10:{ idMOptionMenu.menu10Click(); break; } // End case
        case 11:{ idMOptionMenu.menu11Click(); break; } // End case
        case 12:{ idMOptionMenu.menu12Click(); break; } // End case
        case 13:{ idMOptionMenu.menu13Click(); break; } // End case
        case 14:{ idMOptionMenu.menu14Click(); break; } // End case
        case 15:{ idMOptionMenu.menu15Click(); break; } // End case
        case 16:{ idMOptionMenu.menu16Click(); break; } // End case
        case 17:{ idMOptionMenu.menu17Click(); break; } // End case
        case 18:{ idMOptionMenu.menu18Click(); break; } // End case
        case 19:{ idMOptionMenu.menu19Click(); break; } // End case
        case 20:{ idMOptionMenu.menu20Click(); break; } // End case
        } // End switch
        //console.log(" [MOptionMenu] indexEvent(index) : ", index)
    } // End function

    //--------------------- Radio Click Event(Function) #
    function radioEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.radio0Click(); break; } // End case
        case 1:{ idMOptionMenu.radio1Click(); break; } // End case
        case 2:{ idMOptionMenu.radio2Click(); break; } // End case
        case 3:{ idMOptionMenu.radio3Click(); break; } // End case
        case 4:{ idMOptionMenu.radio4Click(); break; } // End case
        case 5:{ idMOptionMenu.radio5Click(); break; } // End case
        case 6:{ idMOptionMenu.radio6Click(); break; } // End case
        case 7:{ idMOptionMenu.radio7Click(); break; } // End case
        case 8:{ idMOptionMenu.radio8Click(); break; } // End case
        case 9:{ idMOptionMenu.radio9Click(); break; } // End case
        case 10:{ idMOptionMenu.radio10Click(); break; } // End case
        case 11:{ idMOptionMenu.radio11Click(); break; } // End case
        case 12:{ idMOptionMenu.radio12Click(); break; } // End case
        case 13:{ idMOptionMenu.radio13Click(); break; } // End case
        case 14:{ idMOptionMenu.radio14Click(); break; } // End case
        case 15:{ idMOptionMenu.radio15Click(); break; } // End case
        case 16:{ idMOptionMenu.radio16Click(); break; } // End case
        case 17:{ idMOptionMenu.radio17Click(); break; } // End case
        case 18:{ idMOptionMenu.radio18Click(); break; } // End case
        case 19:{ idMOptionMenu.radio19Click(); break; } // End case
        case 20:{ idMOptionMenu.radio20Click(); break; } // End case
        } // End switch
        idMOptionMenuTimer.restart();//resetTimer()
        //console.log(" [MOptionMenu] radioEvent(index) : ", index)
    } // End function

    //--------------------- DimCheck Click Event(Function) #
    function dimCheckEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.dimCheck0Click(); break; } // End case
        case 1:{ idMOptionMenu.dimCheck1Click(); break; } // End case
        case 2:{ idMOptionMenu.dimCheck2Click(); break; } // End case
        case 3:{ idMOptionMenu.dimCheck3Click(); break; } // End case
        case 4:{ idMOptionMenu.dimCheck4Click(); break; } // End case
        case 5:{ idMOptionMenu.dimCheck5Click(); break; } // End case
        case 6:{ idMOptionMenu.dimCheck6Click(); break; } // End case
        case 7:{ idMOptionMenu.dimCheck7Click(); break; } // End case
        case 8:{ idMOptionMenu.dimCheck8Click(); break; } // End case
        case 9:{ idMOptionMenu.dimCheck9Click(); break; } // End case
        case 10:{ idMOptionMenu.dimCheck10Click(); break; } // End case
        case 11:{ idMOptionMenu.dimCheck11Click(); break; } // End case
        case 12:{ idMOptionMenu.dimCheck12Click(); break; } // End case
        case 13:{ idMOptionMenu.dimCheck13Click(); break; } // End case
        case 14:{ idMOptionMenu.dimCheck14Click(); break; } // End case
        case 15:{ idMOptionMenu.dimCheck15Click(); break; } // End case
        case 16:{ idMOptionMenu.dimCheck16Click(); break; } // End case
        case 17:{ idMOptionMenu.dimCheck17Click(); break; } // End case
        case 18:{ idMOptionMenu.dimCheck18Click(); break; } // End case
        case 19:{ idMOptionMenu.dimCheck19Click(); break; } // End case
        case 20:{ idMOptionMenu.dimCheck20Click(); break; } // End case
        } // End switch
        idMOptionMenuTimer.restart()
        //console.log(" [MOptionMenu][dimCheckEvent]["+index+"] Off => On")
    } // End function

    //--------------------- DimUncheck Click Event(Function) #
    function dimUncheckEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.dimUncheck0Click(); break; } // End case
        case 1:{ idMOptionMenu.dimUncheck1Click(); break; } // End case
        case 2:{ idMOptionMenu.dimUncheck2Click(); break; } // End case
        case 3:{ idMOptionMenu.dimUncheck3Click(); break; } // End case
        case 4:{ idMOptionMenu.dimUncheck4Click(); break; } // End case
        case 5:{ idMOptionMenu.dimUncheck5Click(); break; } // End case
        case 6:{ idMOptionMenu.dimUncheck6Click(); break; } // End case
        case 7:{ idMOptionMenu.dimUncheck7Click(); break; } // End case
        case 8:{ idMOptionMenu.dimUncheck8Click(); break; } // End case
        case 9:{ idMOptionMenu.dimUncheck9Click(); break; } // End case
        case 10:{ idMOptionMenu.dimUncheck10Click(); break; } // End case
        case 11:{ idMOptionMenu.dimUncheck11Click(); break; } // End case
        case 12:{ idMOptionMenu.dimUncheck12Click(); break; } // End case
        case 13:{ idMOptionMenu.dimUncheck13Click(); break; } // End case
        case 14:{ idMOptionMenu.dimUncheck14Click(); break; } // End case
        case 15:{ idMOptionMenu.dimUncheck15Click(); break; } // End case
        case 16:{ idMOptionMenu.dimUncheck16Click(); break; } // End case
        case 17:{ idMOptionMenu.dimUncheck17Click(); break; } // End case
        case 18:{ idMOptionMenu.dimUncheck18Click(); break; } // End case
        case 19:{ idMOptionMenu.dimUncheck19Click(); break; } // End case
        case 20:{ idMOptionMenu.dimUncheck20Click(); break; } // End case
        } // End switch
        idMOptionMenuTimer.restart()
        //console.log(" [MOptionMenu][dimUncheckEvent]["+index+"] On => Off")
    } // End function


    /////////////////////////////////////////////////////////////////////////
    // JSH 130917 bug fixed
    onBandMirrorModeChanged:{
//// 2013.11.26 modified by qutiguy - MEA ITS - 0211042
//        console.log(" ========================>[MOptionMenu][onBandMirrorModeChanged] :: " + bandMirrorMode + " idOptionMenu.x = " + idOptionMenu.x)
//        if(!bandMirrorMode){
//            if(idOptionMenu.x == (-opBgWidth))
//                idOptionMenu.x = systemInfo.lcdWidth;
//        }else{
//            if(idOptionMenu.x == systemInfo.lcdWidth)
//                idOptionMenu.x = -opBgWidth
//        }
        if(!bandMirrorMode){
            if(idOptionMenu.x == (-opBgWidth))
                idOptionMenu.x = systemInfo.lcdWidth;
            else if(idOptionMenu.x == 0) // Option Menu is visible case, in General Mode.
                idOptionMenu.x = 767;
        }else{
            if(idOptionMenu.x == systemInfo.lcdWidth)
                idOptionMenu.x = -opBgWidth
            else if(idOptionMenu.x == 767) // Option Menu is visible case, in Mirror Mode.
                idOptionMenu.x = 0
        }
////

    }
    /////////////////////////////////////////////////////////////////////////


    Timer{
        id : idMOptionMenuTimer
        interval: 10000//5000 , JSH 130724 5000 -> 10000
        repeat: true;
        onTriggered: {
            idMOptionMenuTimer.stop();
            optionMenuFinished()
        }
    } // End Timer

    //--------------------- Dim Background Black 70% # => 130927 deleted
    //    Rectangle{
    //        id:bgDim
    //        x: 0; y: 0 //systemInfo.statusBarHeight
    //        width: systemInfo.lcdWidth
    //        height: systemInfo.subMainHeight+2
    //        color: colorInfo.black
    //        opacity:0
    //        Behavior on opacity{NumberAnimation{duration: 200;}}  // JSH 130418 added menuAnimation
    //    } // End Rectangle

    //--------------------- Send signal - optionMenuFinished()
    ///////////////////////////////////////////////////////
    // JSH 131102 Modify
    //    MouseArea{
    //        anchors.fill: parent
    //        onReleased: {//onClicked: {
    //            //console.log("===========================> MOptionMenu.qml -> MouseArea -> onReleased")
    //            idAppMain.playBeep();
    //            idMOptionMenuTimer.restart();
    //            optionMenuFinished();
    //        }
    //    }
    MouseArea{
        id:bgMouseArea
        anchors.fill: parent
        property int startX : 0
        property int startY : 0
        onPressed:{
            startX = mouseX
            startY = mouseY
        }
        onReleased: {//onClicked: {
            //console.log("===========================> MOptionMenu.qml -> MouseArea -> onReleased",bgMouseArea.startX , mouseX)
            //idAppMain.playBeep();
            idMOptionMenuTimer.restart();
            //optionMenuFinished();


            if(bgMouseArea.startX == mouseX){
                //UIListener.writeToLogFile("playBeep1");
                idAppMain.playBeep();
                optionMenuFinished();
            }
            /////////////////////////////////////////////////////////
            // JSH 131113 modify
            //else if(bgMouseArea.startX < mouseX){
            //     if(mouseX - bgMouseArea.startX > 100)
            //         optionMenuFinished();
            // }
            else { ////if(bgMouseArea.startX == mouseX){
//                console.log("===========================> bgMouseArea MOptionMenu.qml ",bgMouseArea.startX , bgMouseArea.startY,  mouseX, mouseY )
                //// 2013.12.24  modified by qutiguy resolve ME/ITS/0217086
                if(!bandMirrorMode){
                    if(bgMouseArea.startX < mouseX){
                        if(mouseX - bgMouseArea.startX > 100)
                        {
                            //optionMenuFinished();
                            //KSW 131118-1
                            //UIListener.writeToLogFile("playBeep2");
                            idAppMain.playBeep();   //dg.jin 20150213 beep add
                            idMOptionMenu.subMenuClose  = true;
                            idMOptionMenu.menuAnimation = false;
                        }
                        else if(bgMouseArea.startY < mouseY){
                            if(((mouseX - bgMouseArea.startX) < 15) && ((mouseY - bgMouseArea.startY) < 15)){
                                //UIListener.writeToLogFile("playBeep3");
                                idAppMain.playBeep();
                                optionMenuFinished();
                            }
                        }else{
                            if(((mouseX - bgMouseArea.startX) < 15) && ((bgMouseArea.startY -mouseY) < 15)){
                                //UIListener.writeToLogFile("playBeep4");
                                idAppMain.playBeep();
                                optionMenuFinished();
                            }
                        }
                    }else{ //if(bgMouseArea.startX < mouseX){
                        if(bgMouseArea.startY < mouseY){
                            if(((bgMouseArea.startX -mouseX) < 15) && ((mouseY - bgMouseArea.startY) < 15)){
                                //UIListener.writeToLogFile("playBeep5");
                                idAppMain.playBeep();
                                optionMenuFinished();
                            }
                        }else{
                            if(((bgMouseArea.startX -mouseX) < 15) && ((bgMouseArea.startY -mouseY) < 15)){
                                //UIListener.writeToLogFile("playBeep6");
                                idAppMain.playBeep();
                                optionMenuFinished();
                            }
                        }
                    } //if(bgMouseArea.startX < mouseX){
                }else{ // if(!bandMirrorMode){
                    if(bgMouseArea.startX > mouseX){
                        if(bgMouseArea.startX - mouseX > 100)
                        {
                            //optionMenuFinished();
                            //KSW 131118-1
                            //UIListener.writeToLogFile("playBeep7");
                            idAppMain.playBeep();   //dg.jin 20150213 beep add
                            idMOptionMenu.subMenuClose  = true;
                            idMOptionMenu.menuAnimation = false;
                        }
                        else if(bgMouseArea.startY < mouseY){
                            if(((bgMouseArea.startX - mouseX ) < 15) && ((mouseY - bgMouseArea.startY) < 15)){
                                idAppMain.playBeep();
                                optionMenuFinished();
                            }
                        }else{
                            if(((bgMouseArea.startX - mouseX ) < 15) && ((bgMouseArea.startY -mouseY) < 15)){
                                idAppMain.playBeep();
                                optionMenuFinished();
                            }
                        }
                    }else{ //if(bgMouseArea.startX > mouseX){
                        if(bgMouseArea.startY < mouseY){
                            if(((bgMouseArea.startX - mouseX) > 15) && ((mouseY - bgMouseArea.startY) < 15)){
                                idAppMain.playBeep();
                                optionMenuFinished();
                            }
                        }else{
                            if(((bgMouseArea.startX -mouseX) > 15) && ((bgMouseArea.startY -mouseY) < 15)){
                                idAppMain.playBeep();
                                optionMenuFinished();
                            }
                        }
                    } //if(bgMouseArea.startX > mouseX){
                } //if(!bandMirrorMode){
                ////
            } ////if(bgMouseArea.startX == mouseX){
            /////////////////////////////////////////////////////////
        } //onReleased: {
    } // MouseArea{
    ///////////////////////////////////////////////////////
    //--------------------- Option Menu #
    Item{
        id: idOptionMenu
        x: (!bandMirrorMode) ? systemInfo.lcdWidth : -opBgWidth  ;  y: 0
        width: opBgWidth ; height: systemInfo.lcdHeight

/////////////////////////////////////////////////////////////
//  JSH 130813 Modify [MouseArea deleted]
//        MouseArea{
//            anchors.fill: parent
//            drag.target: idFlickingHandleArea
//            drag.axis: Drag.XandYAxis
//            drag.minimumY: 0
//            drag.maximumY: idMOptionMenu.height
//            drag.minimumX: 0
//            drag.maximumX: idMOptionMenuList.width
//            drag.filterChildren: true

//            onPressed: {idMOptionMenu.startX =  mouseX; idMOptionMenuTimer.stop();}
//            onPressAndHold: {idMOptionMenu.startX =  mouseX;idMOptionMenuTimer.stop();}
//            onReleased: {
//                idMOptionMenuTimer.restart();
//                if(!bandMirrorMode){
//                    if(mouseX - idMOptionMenu.startX > 100)
//                        idMOptionMenu.menuAnimation = false;
//                }
//                else{
//                    if(idMOptionMenu.startX - mouseX> 100)
//                        idMOptionMenu.menuAnimation = false;
//                }
//            }
            Rectangle {
                id: idFlickingHandleArea
                anchors.fill: idMOptionMenuList
                visible: false
            }
            //--------------------- Background Image ##
            Image{
                id: imgBg
                width: opBgWidth
                source: opBgImg
                //x:  menuDepth == "OneDepth" ? 0 : 40
                //KSW 131227-2 ITS/217401
                MouseArea{
                    anchors.fill: parent;
                    onReleased: {
                        if(menuDepth == "TwoDepth"){
//                            console.log("imgBg menuDepth = "+ menuDepth);
                            //UIListener.writeToLogFile("playBeep8");
                            idAppMain.playBeep(); //dg.jin 20140923 ITS 248805 twodepth menu bg click beep play add.
                            idMOptionMenu.subMenuClose  = true;
                            idMOptionMenu.menuAnimation = false;
                        }else{
                            //UIListener.writeToLogFile("playBeep9");
                            idAppMain.playBeep(); //dg.jin 20140317 ITS 0229795
                            optionMenuFinished()
                        }
                    }
                }

            } // End Image

            MOptionMenuList{
                id: idMOptionMenuList
				  //2013.12.18 modified by qutiguy ITS 2159431
                x: (!bandMirrorMode) ? opLeftMargine+listLeftFocusMargine :opLeftMargine  ;y: idMOptionMenu.y
                width: listAreaWidth-(listLeftFocusMargine*2);
                height: idMOptionMenu.height < linkedModels.count * opItemHeight ? idMOptionMenu.height : linkedModels.count * opItemHeight+1
                /////////////////////////////////////////////////////////////////////////////////////////////
                // JSH 130828 Moved
                MouseArea{
                    /////////////////////////////////////////////////////////////////////////////////////////////
                    //// 20130807 added by qutiguy - to prevent close ITS-0183096 , JSH 130813 [x,width,onPressed,onReleased modify]
                    //x: (!bandMirrorMode) ? 0 : idMOptionMenuList.width
                    //width: (!bandMirrorMode) ? (idMOptionMenuList.x - parent.x) : parent.width - idMOptionMenuList.width
                    y : idMOptionMenuList.height;
                    width: (!bandMirrorMode)?idMOptionMenu.width : idMOptionMenuList.width; // 2013.12.24 modified by qutiguy - ITS 214377
                    height: idMOptionMenu.height
                    onPressed: {
                        idMOptionMenu.startX =  mouseX; idMOptionMenuTimer.stop();
                    }
                    onReleased: {
                        //KSW 131024 [ITS][195847][major] oneDepth menu closed before to do close twodepth menu.
                        if(menuDepth == "TwoDepth" && (idAppMain.state == "AppRadioRdsOptionMenuRegion"
                                                       || idAppMain.state == "AppRadioRdsOptionMenuSortBy"))
                            idAppMain.sigOptionMenuTimer();
                        else
                            idMOptionMenuTimer.restart();

                        if(!bandMirrorMode){
                            //console.log("===============================> option menu Background Image",idMOptionMenuList.x ,mouseX , parent.x)
                            if(idMOptionMenuList.x > mouseX && mouseX > parent.x){
                                if(menuDepth == "OneDepth")
                                {
                                    optionMenuFinished()
                                    //UIListener.writeToLogFile("playBeep Test1");
                                }
                                else{
                                    idMOptionMenu.subMenuClose  = true;
                                    idMOptionMenu.menuAnimation = false;
                                    //UIListener.writeToLogFile("playBeep Test2");
                                }
                            }else if(idMOptionMenuList.x < mouseX){
                                //// 2013.11.10 modified by qutiguy : EU ITS 0208031 - Check 1'st depth or 2'nd depth Optionmenu.
                                if(menuDepth == "OneDepth"){ //1 depth case
                                    if(mouseX - idMOptionMenu.startX > 100)
                                    {
                                        idAppMain.playBeep();   //dg.jin 20150213 beep add
                                        idMOptionMenu.menuAnimation = false;
                                        //UIListener.writeToLogFile("playBeep Test3");
                                    }
                                }else{ // 2 depth case
                                    if(mouseX - idMOptionMenu.startX > 100){
                                        idAppMain.playBeep();   //dg.jin 20150213 beep add
                                        idMOptionMenu.subMenuClose  = true;
                                        idMOptionMenu.menuAnimation = false;
                                        //UIListener.writeToLogFile("playBeep Test5");
                                    }
                                }
                                ////
                            }
                        }else{ //if(!bandMirrorMode){
                            //// 2013.12.24  modified by qutiguy resolve ME/ITS/0217086
                            if(idMOptionMenuList.width > mouseX && mouseX > parent.width ){
                                if(menuDepth == "OneDepth")
                                    optionMenuFinished()
                                else{
                                    idMOptionMenu.subMenuClose  = true;
                                    idMOptionMenu.menuAnimation = false;
                                }
                            }else if(idMOptionMenu.startX  > mouseX){ //if(idMOptionMenuList.width > mouseX && mouseX > parent.width ){
                                if(menuDepth == "OneDepth"){ //1 depth case
                                    if(idMOptionMenu.startX - mouseX > 100)
                                    {
                                        idAppMain.playBeep();   //dg.jin 20150213 beep add
                                        idMOptionMenu.menuAnimation = false;
                                    }
                                }else{ // 2 depth case
                                    if(idMOptionMenu.startX - mouseX > 100){
                                        idAppMain.playBeep();   //dg.jin 20150213 beep add
                                        idMOptionMenu.subMenuClose  = true;
                                        idMOptionMenu.menuAnimation = false;
                                    }
                                }
                            } //if(idMOptionMenuList.width > mouseX && mouseX > parent.width ){
                            ////
                        } //if(!bandMirrorMode){
                    } //onReleased: {
                } //MouseArea{
                /////////////////////////////////////////////////////////////////////////////////////////////
            } // End MOptionMenuList
//        } // End MouseArea
/////////////////////////////////////////////////////////////

        //--------------------- OptionMenu Preview Image ##
//        Image{
//            id: idMOptionMenuViewImg
//            source : opViewImg
//            visible: opViewImgVisible
//            anchors.right: parent.right
//            anchors.rightMargin: opViewRightMargin
//            anchors.top: parent.bottom
//            anchors.topMargin: opViewTopMargin
//        } // End Image
        Behavior on x { // JSH 130418 added menuAnimation
            NumberAnimation{
                duration: 200;
                onRunningChanged:{
                    //console.log(" [MOptionMenu][onRunningChanged]["+menuDepth+"] : "+ menuAnimation+running)
                     if(!bandMirrorMode){
                         if((!running) && idOptionMenu.x == systemInfo.lcdWidth && visible)
                             gotoBackScreen();
                     }
                     else{
                         if((!running) && idOptionMenu.x == (-opBgWidth) && visible)
                             gotoBackScreen();
                     }
                }
            }
        }
    }// End Item

    //onSeekPrevKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() } //Add Seek Prev/Next jyjeon_2012-09-28
    //onSeekNextKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() } //Add Seek Prev/Next jyjeon_2012-09-28
    //onTuneRightKeyPressed:{ idMOptionMenuTimer.stop(); optionMenuFinished() } //Add tune Right/left/Enter jyjeon_2012-10-10
    //onTuneLeftKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() } //Add tune Right/left/Enter jyjeon_2012-10-10
    //onTuneEnterKeyPressed:{ idMOptionMenuTimer.stop(); optionMenuFinished() } //Add tune Right/left/Enter jyjeon_2012-10-10
    onAnyKeyReleased:{ idMOptionMenuTimer.restart() }
    Component.onCompleted: {
        idMOptionMenuTimer.start()
    }
    onMenuAnimationChanged:{ // JSH 130418 added menuAnimation
        //console.log(" [MOptionMenu][onMenuAnimationChanged]["+menuDepth+"] : "+ menuAnimation)
        if(menuAnimation){
            //bgDim.opacity = menuDepth=="OneDepth" ? 0.6 : 0; // 0.8 -> 0.6
            idOptionMenu.x = (!bandMirrorMode) ? menuDepth=="OneDepth" ? idAppMain.state == "AppRadioRdsOptionMenuRegion" ? systemInfo.lcdWidth - opBgWidth - 40 : systemInfo.lcdWidth - opBgWidth : systemInfo.lcdWidth - opBgWidth : 0
            if((menuDepth == "TwoDepth")){
                var loaderCnt   = 0;
                var elementCnt  = 0;
                while(!loaderCnt){
                    if(idAppMain.children[elementCnt].objectName == "MainArea"){
                        loaderCnt = idAppMain.children[elementCnt].children.length
                        for(var i=0 ; loaderCnt > i ;i++){
                            var child = idAppMain.children[elementCnt].children[i+1];
                            //console.log("==================================KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK",child.visible , child.item.menuDepth)
                            if(child.visible && child.item.menuDepth == "OneDepth"){
                                child.item.children[7].x -= 41;
                                break;
                            }
                        }
                    }
                    elementCnt++;
                }
            }
        }
        else{
            //bgDim.opacity = 0 ;
            idOptionMenu.x = (!bandMirrorMode) ? systemInfo.lcdWidth : -opBgWidth
            if((menuDepth == "TwoDepth")){// &&(!idMOptionMenu.subMenuClose)){
                var loaderCnt   = 0;
                var elementCnt  = 0;
                while(!loaderCnt){
                    if(idAppMain.children[elementCnt].objectName == "MainArea"){
                        loaderCnt = idAppMain.children[elementCnt].children.length
                        for(var i=0 ; loaderCnt > i ;i++){
                            var child = idAppMain.children[elementCnt].children[i+1];
                            if(child.visible && child.item.menuAnimation){
                               if(!idMOptionMenu.subMenuClose)
                                   child.item.menuAnimation = false;
                               else
                                   child.item.children[7].x += 41;
                                break;
                            }
                        }
                    }
                    elementCnt++;
                }
            }
        }
        idMOptionMenu.subMenuClose = false
    }
    //--------------------- Visible change(Function) #
    onVisibleChanged: {
        //console.log(" [MOptionMenu][onVisibleChanged]["+menuDepth+"] : "+ idMOptionMenu.visible)
        if(visible) {
            menuAnimation = true; // JSH 130418 added menuAnimation
            idMOptionMenuTimer.start()
        }
        else {
            menuAnimation = false; // JSH 130418 added menuAnimation
            idMOptionMenuTimer.stop() //jyjeon_20120606
        } // End if
    }

    //--------------------- Focus change(Function) #
    onActiveFocusChanged: {
        //console.log(" [MOptionMenu][onActiveFocusChanged]["+menuDepth+"] : "+ idMOptionMenu.activeFocus)
        if(activeFocus) { idMOptionMenuTimer.start() }
        else { idMOptionMenuTimer.stop() } //jyjeon_20120606
    }

    Connections{
        target: UIListener
        onRetranslateUi: {
            idMOptionMenu.langID = languageId;
            imageInfo.langId     = languageId;                                              // JSH 130715
            //idOptionMenu.x =  (imageInfo.langId == 20) ?  -opBgWidth : systemInfo.lcdWidth    // JSH 130715 => JSH 130827 ITS[0186752]
        }
    }

    //KSW 131024 [ITS][195847][major] oneDepth menu closed before to do close twodepth menu.
    Connections{
        target: idAppMain
        onSigOptionMenuTimer : {
            console.log("KSW : sigOptionMenuTimer idAppMain.state= ",idAppMain.state)
                idMOptionMenuTimer.restart();
        }

        //20141017 dg.jin systempopup hide option menu
        onOptionMenuHide : {
            optionMenuFinished();
        }
    }
} // End MComponent
