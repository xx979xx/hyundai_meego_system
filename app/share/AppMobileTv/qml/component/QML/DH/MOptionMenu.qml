/**
 * FileName: MOptionMenu.qml
 * Author: WSH
 * Time: 2012-02-08
 *
 * - 2012-02-08 Initial Crated by WSH
 * - 2012-04-19 Added signal, event 16~20 by WSH
 * - 2012-04-20 [Added Connection] Receive onVisualCueTimerStoped by WSH
 * - 2012-06-01 [Added Timer] Created Timer in OptionMenu by WSH
 * - 2012-06-08 [Added prevent code] restart() by WSH
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
    x: 0; y: 0;
    z: parent.z + 1
    width: systemInfo.lcdWidth;
    height: systemInfo.lcdHeight //720-93
    focus: true
    state: "hide"

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    signal pressedForFlickableEnded();

    property QtObject linkedModels
    property QtObject linkedDelegate     : Component{MOptionMenuDelegate {}}
    property QtObject linkedCurrentItem
    property int      linkedCurrentIndex : 0


    property bool leftKeyPressed : idAppMain.leftKeyPressed;

    // # Flickable Info
    property int startX: 0

    // # Image Path Info
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    // # OptionMenu Info
    property string opBgImg : imgFolderGeneral + "bg_optionmenu.png"
    property int opBgX: 767
    property int opBgWidth: systemInfo.lcdWidth - opBgX
    property int opLeftMargine: 845 - opBgX
    property real opBgOpacity: 0.6

    // # Delegate Info
    property int delegateWidth: opItemWidth

    // # Item Text Info
    property int opItemX: 845
    property int opItemWidth: 416
    property int opItemHeight: 79
    property int opItemFontSize : 32
    property string opItemFontName: idAppMain.fontsR

    // # List Info
    property int listAreaWidth: opBgWidth - opLeftMargine + (listLeftFocusMargine*2) // 435+6 : 395+6
    property int listLeftFocusMargine : 3
    property int listLeftMargine : 27

    // # Line Info
    property int opLineY: 81
    //property int opLineHeight: 2
    property string opLineImg: imgFolderGeneral + "line_optionmenu.png"

    // # Scroll Info
    property int opScrollWidth: 14
    property int opScrollHeight: 608
    property int opScrollY: 5

    // # Button Info
    property string opBgImagePress : imgFolderGeneral + "bg_optionmenu_list_p.png"
    property string opBgImageFocus : imgFolderGeneral + "bg_optionmenu_list_f.png"

    // # Dim Info
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

    // # Default Click Event(Signal) #
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

    // # Default Click Event(Function) #
    function indexEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.menu0Click(); offOptionMenu(); break; } // End case
        case 1:{ idMOptionMenu.menu1Click(); offOptionMenu(); break; } // End case
        case 2:{ idMOptionMenu.menu2Click(); offOptionMenu(); break; } // End case
        case 3:{ idMOptionMenu.menu3Click(); offOptionMenu(); break; } // End case
        case 4:{ idMOptionMenu.menu4Click(); break; } // End case
        case 5:{ idMOptionMenu.menu5Click(); break; } // End case
        case 6:{ idMOptionMenu.menu6Click(); offOptionMenu(); break; } // End case
//        case 7:{ idMOptionMenu.menu7Click(); break; } // End case
//        case 8:{ idMOptionMenu.menu8Click(); break; } // End case
//        case 9:{ idMOptionMenu.menu9Click(); break; } // End case
//        case 10:{ idMOptionMenu.menu10Click(); break; } // End case
        } // End switch
        //offOptionMenu();
        //console.log(" [MOptionMenu] indexEvent(index) : ", index)
    } // End function

    function hkEventSignal(){
        offOptionMenu();
    }
    function showOptionMenu(){
        if(idMOptionMenuTimer.running == false)
            idMOptionMenuTimer.start();

        idMOptionMenu.state = "show";
    }
    function hideOptionMenu(){
        if(idMOptionMenuTimer.running == true)
            idMOptionMenuTimer.stop();

        idMOptionMenu.state = "hide";
        idMOptionMenuBackTimer.start();
    }
    function offOptionMenu(){
        if(idMOptionMenuTimer.running == true)
            idMOptionMenuTimer.stop();

        idMOptionMenu.state = "off";
        //idMOptionMenuBackTimer.start();
    }

    Timer{
        id: idMOptionMenuBackTimer
        interval: 200

        onTriggered:{
            //console.debug(" [BackTimer]:: idMOptionMenu.state:"+idMOptionMenu.state)
            if(idMOptionMenu.state == "show") return;

            if(idAppMain.state != "PopupSearching" && (idAppMain.state == "AppDmbPlayerOptionMenu" || idAppMain.state == "AppDmbDisasterOptionMenu" || idAppMain.state == "AppDmbDisasterEditOptionMenu"))
            {
                idAppMain.gotoBackScreen();
            }
        }
    }

    Timer{
        id : idMOptionMenuTimer
        interval: 10000
        repeat: true;
        onTriggered: {
            hideOptionMenu();
            //idMOptionMenuTimer.stop();
        }
    } // End Timer

    // # Dim Background Black 60% #
//    Rectangle{
//        id:idDimBgImg
//        x: 0
//        y: 0 //systemInfo.statusBarHeight
//        width: systemInfo.lcdWidth
//        height: systemInfo.subMainHeight
//        color: colorInfo.black
//        opacity: opBgOpacity
//    } // End Rectangle

    // # Dim Black Clicked #
    MouseArea{
        anchors.fill: parent
//        onReleased: {
//            if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
//            hideOptionMenu();
//        }

        onPressed: {
            startX =  mouseX;
        }

        onPressAndHold: {
            startX =  mouseX;
        }

        onReleased: {
            if(idAppMain.isDrag == true)
            {
                if(mouseX - startX > 100) {
                    idMOptionMenu.hideOptionMenu();
                }
            }
            else
            {
                if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
                idMOptionMenu.hideOptionMenu();
            }
        }
    }

    // # Background Image #
    Image{
        id: idOptionMenu
        x: opBgX
        width: opBgWidth
        source: opBgImg

        MouseArea{
            anchors.fill: parent
            drag.target: idFlickingHandleArea
            drag.axis: Drag.XandYAxis
            drag.minimumY: 0
            drag.maximumY: idMOptionMenu.height
            drag.minimumX: 0
            drag.maximumX: opBgWidth
            drag.filterChildren: true

            onPressed: {
                startX =  mouseX;
//                if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
                idMOptionMenuTimer.stop();
            }

            onPressAndHold: {
                startX =  mouseX;
                idMOptionMenuTimer.stop();
            }

            onReleased: {
                idMOptionMenuTimer.restart();

                if(idAppMain.isDrag == true)
                {
                    if(mouseX - startX > 100) {
                        idMOptionMenu.hideOptionMenu();
                    }
                }
//                else
//                {
//                    if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
//                }
            }

            onCanceled: {
                idMOptionMenuTimer.restart();
            }

            Image{
                x: 0
                source: opBgImg
                MouseArea{
                    anchors.fill: parent
                    onReleased: {
                        if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
                        idMOptionMenu.hideOptionMenu();
                    }
                }
            }

            MOptionMenuList{
                id: idMOptionMenuList
                x: opLeftMargine+listLeftFocusMargine
                y: idMOptionMenu.y
                width: listAreaWidth - (listLeftFocusMargine*2)
                height: idMOptionMenu.height
            }

            Rectangle {
                id: idFlickingHandleArea
                anchors.fill: idMOptionMenuList
                visible: false
                opacity: 0.3
            }
        }
    }

//    onSeekPrevKeyReleased: { hkEventSignal(); }
//    onSeekNextKeyReleased: { hkEventSignal(); }
//    onTuneRightKeyPressed:{ hkEventSignal(); }
//    onTuneLeftKeyPressed: { hkEventSignal(); }
//    onTuneEnterKeyPressed:{ hkEventSignal(); }
    onAnyKeyReleased:{ idMOptionMenuTimer.restart() }
    Component.onCompleted: { showOptionMenu(); }

    onLeftKeyPressedChanged:{

        if(idAppMain.leftKeyPressed == false && idMOptionMenu.state == "show")
        {
            console.log(" [MOptionMenu][onLeftKeyPressedChanged]")
            hideOptionMenu();
        }
    }

    // # Visible change(Function) #
    onVisibleChanged: {
        if(idMOptionMenu.visible == true) {
            showOptionMenu();
        } else {
            idMOptionMenuTimer.stop();
        }
    }

    // # Focus change(Function) #
    onActiveFocusChanged: {
        //console.log(" [MOptionMenu][onActiveFocusChanged]["+activeFocus+"] : "+ idMOptionMenu.activeFocus)
        if(idMOptionMenu.activeFocus == true) { idMOptionMenuTimer.start() }
        else { idMOptionMenuTimer.stop() }
    }

    states: [
        State {
            name: "show";
//            PropertyChanges { target: idDimBgImg;      opacity: opBgOpacity; }
            PropertyChanges { target: idOptionMenu;    x: opBgX; }
        },
        State {
            name: "hide";
//            PropertyChanges { target: idDimBgImg;      opacity: 0; }
            PropertyChanges { target: idOptionMenu;    x: systemInfo.lcdWidth; }
        },
        State {
            name: "off";
//            PropertyChanges { target: idDimBgImg;      opacity: 0; }
            PropertyChanges { target: idOptionMenu;    x: systemInfo.lcdWidth; }
        }
    ]

    transitions:[
        Transition {
//            NumberAnimation { target: idDimBgImg;      properties: "opacity";  duration: 200 }
            NumberAnimation { target: idOptionMenu;    properties: "x";        duration: 200 }
        }
    ]

    Connections{
        target: EngineListener

        onDmbReqBackground:{

            if(idMOptionMenu.state == "show")
            {
                if(idMOptionMenuTimer.running == true)
                    idMOptionMenuTimer.stop();

                idMOptionMenu.state = "off";
            }

            idAppMain.isSettings = false;
        }
    }
} // End MComponent
