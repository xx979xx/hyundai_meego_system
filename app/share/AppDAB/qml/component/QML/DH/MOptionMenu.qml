/**
 * FileName: MOptionMenu.qml
 * Author: WSH
 * Time: 2012-02-08
 *
 * - 2012-02-08 Initial Crated by WSH
 * - 2013-05-10 All modify by HYANG
 */
import QtQuick 1.0
import "../../system/DH" as MSystem

MComponent {
    id: idMOptionMenu
    x: 0; y: 0; z: parent.z + 1
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight //720-93
    focus: true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    property QtObject linkedModels

    property bool seekPrevLongKeyPressed : idAppMain.seekPrevLongKeyPressed;
    property bool seekNextLongKeyPressed : idAppMain.seekNextLongKeyPressed;
    property bool visibleCheck: false;

    //--------------------- Image Path Info(Property) #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string sImgBg_OptionMenu:  imgFolderGeneral + "bg_optionmenu.png"
    property string sImgLine_OptionMenu: imgFolderGeneral + "line_optionmenu.png"
    property string sImgBg_OptionMenuListP : imgFolderGeneral + "bg_optionmenu_list_p.png"
    property string sImgBg_OptionMenuListF : imgFolderGeneral + "bg_optionmenu_list_f.png"
    property string sImgIco_OptionMenuArrow: imgFolderGeneral + "ico_optionmenu_arrow.png"

    property string menuDepth: "OneDepth" //"OneDepth" or "TwoDepth" # added by HYANG_20120228
    property real rDimBlackOpacity: 0.6
    property int iMenuBgX: 767  //767 or 727
    property int iMenuBgWidth: 513
    property int iMenuAreaX: menuDepth == "OneDepth" ? 78 : 78+41    //845 - 767
    property int iMenuAreaY: 0
    property int iMenuAreaWidth: 422

    property int iMenuListBgX: 1                                //845+1-iMenuBgX-iMenuAreaX : 845+1+40-iMenuBgX-iMenuAreaX
    property int iMenuListBgY: -2                               //iMenuLineY-81
    property int iMenuListBgHeight: 78
    property int iMenuLineX: 0                                  //845 - 767 - iMenuAreaX
    property int iMenuLineY: 79                                 //172-systemInfo.statusBarHeight
    property int iMenuTextX: 28                                 //1+27
    property int iMenuTextY: 42                                 //81-39
    property int iMenuTextWidth: 375
    property int iMenuIconX: 357                                //1+27+324+5
    property int iMenuIconY: 18                                 //81-24-39
    property int iMenuScrollX: 416
    property int iMenuScrollY: 6                                //98-systemInfo.statusBarHeight   
    property int selectedRadioIndex: 0
    property int startX: 0

    signal optionMenuFinished()
    signal rightKeySubMenuOpen();
    signal leftKeyMenuClose();

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
        } // End switch
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
        } // End switch
        idMOptionMenuTimer.restart();
    } // End function

    //--------------------- Dim Background Black 60% #
    //    Rectangle{
    //        id: idDimBg
    //        x: 0;
    //        y: 0;
    //        width: systemInfo.lcdWidth
    //        height: systemInfo.lcdHeight
    //        color: colorInfo.black
    //        opacity: menuDepth=="OneDepth" ? rDimBlackOpacity : 0
    //    } // End Rectangle

    //--------------------- Dim Black Clicked #
    MouseArea{
        anchors.fill: parent
        onReleased: {
          //  idMOptionMenuTimer.restart();
            if(mouseX - startX > 100) {
                if(menuDepth == "OneDepth")  idMOptionMenu.hideOptionMenu();
                else  idAppMain.optionMenuSubClose();
            }
            else if(mouseX - startX == 0)
            {
            //    idMOptionMenuTimer.stop();
                optionMenuFinished()
            }
        }

        onPressed: {
            startX =  mouseX;
            //           idMOptionMenuTimer.stop();
        }

        onPressAndHold: {
            startX =  mouseX;
            //         idMOptionMenuTimer.stop();
        }
    }

    //--------------------- Menu List #
    Item{
        id: idMenu
        x: iMenuBgX + iMenuBgWidth
        y: 0
        width: iMenuBgWidth
        height: systemInfo.lcdHeight

        MouseArea{
            anchors.fill: parent
            drag.target: idFlickingHandleArea
            drag.axis: Drag.XandYAxis
            drag.minimumY: 0
            drag.maximumY: idMOptionMenu.height
            drag.minimumX: 0
            drag.maximumX: iMenuBgWidth
            drag.filterChildren: true

            onPressed: {                
                startX =  mouseX;        
                idMOptionMenuTimer.stop();
            }

            onPressAndHold: {
                startX =  mouseX;
                idMOptionMenuTimer.stop();
            }

            onReleased: {                
                idMOptionMenuTimer.restart();
                if(mouseX - startX > 100) {               
                    if(menuDepth == "OneDepth")  idMOptionMenu.hideOptionMenu();
                    else  idAppMain.optionMenuSubClose();
                }
            }           

            Image{
                x:  menuDepth == "OneDepth" ? 0 : 40
                source: sImgBg_OptionMenu
                MouseArea{
                    anchors.fill: parent
                    onReleased: {
                        if(menuDepth == "OneDepth")
                            optionMenuFinished()
                        else
                            idAppMain.optionMenuSubClose();
                    }
                }
            }

            MOptionMenuList{
                id:idMOptionMenuList
                x: iMenuAreaX;
                y: iMenuAreaY
                width: iMenuAreaWidth;
                height: systemInfo.lcdHeight
            }

            Rectangle {
                id: idFlickingHandleArea
                anchors.fill: idMOptionMenuList
                visible: false
                opacity: 0.3
                color: "green"
            }
        }
    }


    Component.onCompleted: {
        showOptionMenu()
        idMOptionMenuTimer.start()
    }

    //--------------------- Visible change(Function) #
    onVisibleChanged: {
        //console.log(" [MOptionMenu][onVisibleChanged]["+menuDepth+"] : "+ idMOptionMenu.visible)
        if(visible) {
            showOptionMenu()
        }
        else {
            visibleCheck = false;
            idMOptionMenuTimer.stop()
        }
    }

    //--------------------- Focus change(Function) #
    onActiveFocusChanged: {
        //console.log(" [MOptionMenu][onActiveFocusChanged]["+menuDepth+"] : "+ idMOptionMenu.activeFocus)
        if(activeFocus) { idMOptionMenuTimer.start() }
        else { idMOptionMenuTimer.stop() }
    }

    onSeekPrevKeyReleased: { idMOptionMenuTimer.stop(); optionMenuFinished() }  //Add Seek Prev/Next
    onSeekNextKeyReleased: { idMOptionMenuTimer.stop(); optionMenuFinished() }  //Add Seek Prev/Next
    onTuneRightKeyPressed:{ idMOptionMenuTimer.stop(); optionMenuFinished() }   //Add tune Right/left/Enter
    onTuneLeftKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() }   //Add tune Right/left/Enter
    onTuneEnterKeyPressed:{ idMOptionMenuTimer.stop(); optionMenuFinished() }   //Add tune Right/left/Enter    
    onSeekPrevLongKeyPressedChanged: {
        if(idAppMain.seekPrevLongKeyPressed){
            idMOptionMenuTimer.stop(); optionMenuFinished()
        }
    }
    onSeekNextLongKeyPressedChanged: {
        if(idAppMain.seekNextLongKeyPressed){
            idMOptionMenuTimer.stop(); optionMenuFinished()
        }
    }

    onAnyKeyPressed:{ idMOptionMenuTimer.restart() }

    //--------------------- Option Menu Animation #
    states: [
        State {
            name: "show";
            PropertyChanges { target: idMenu; x: iMenuBgX }
            //   PropertyChanges { target: idDimBg; opacity: menuDepth=="OneDepth" ? rDimBlackOpacity : 0}
        },
        State {
            name: "showSub";
            PropertyChanges { target: idMenu; x: iMenuBgX-40 }
        },
        State {
            name: "hide";
            PropertyChanges { target: idMenu; x: iMenuBgX + iMenuAreaWidth }
            // PropertyChanges { target: idDimBg; opacity: 0}
        },
        State {
            name: "hideSub";
            PropertyChanges { target: idMenu; x: menuDepth=="OneDepth" ? iMenuBgX : iMenuBgX + iMenuAreaWidth}
            // PropertyChanges { target: idDimBg; opacity: menuDepth=="OneDepth" ? rDimBlackOpacity : 0}
        }
    ]
    transitions:[
        Transition {
            NumberAnimation {  target: idMenu; properties: "x"; duration: 165;  }
            // NumberAnimation {  target: idDimBg; properties: "opacity"; duration: 100; }
        }
    ]

    function showOptionMenu(){
        if(idAppMain.state == "DabStationListSubMenu")
            idMOptionMenu.state = "showSub"
        else{
            idMOptionMenu.state = "show"           
        }
        idMOptionMenuTimer.start();
    }
    function hideOptionMenu(){
        idMOptionMenu.state = "hide"
        idOptionMenuHideTimer.start();
    }
    function offOptionMenu(){
        idMOptionMenu.state = "hide"
        console.log("[QML] MOptionMenu.qml : offOptionMenu")
        gotoBackScreen();
    }

    Timer{
        id : idMOptionMenuTimer
        interval: 10000
        repeat: true;
        onTriggered: {
            idMOptionMenuTimer.stop();
            optionMenuFinished()
        }
    }

    Timer{
        id: idOptionMenuHideTimer
        interval: 165;
        onTriggered: {
            idOptionMenuHideTimer.stop();
            console.log("[QML] MOptionMenu.qml : idOptionMenuHideTimer")
            if(idAppMain.state == "DabStationListMainMenu" || idAppMain.state == "DabPlayerOptionMenu" || idAppMain.state == "DabStationListSubMenu")
                gotoBackScreen();
        }
    }

    Timer{
        id: idOptionMenuSubHideTimer
        interval: 165;
        onTriggered: {
            idOptionMenuSubHideTimer.stop();
            console.log("[QML] MOptionMenu.qml : idOptionMenuSubHideTimer")
            if(idAppMain.state == "DabStationListSubMenu"){
                gotoBackScreen();
            }
        }
    }

    Connections {
        target: idAppMain
        onOptionMenuAllHide:
        {
            idMOptionMenu.state = "hide"
            idOptionMenuHideTimer.start();
        }
        onOptionMenuSubOpen:
        {
            if(idAppMain.state == "DabStationListSubMenu")
                idMOptionMenu.state = "showSub"
        }
        onOptionMenuSubClose:{
            idMOptionMenu.state = "hideSub"
            idOptionMenuSubHideTimer.start();
        }
    }
} // End MComponent
