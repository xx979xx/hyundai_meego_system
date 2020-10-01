/**
 * FileName: MOptionMenu.qml
 * Author: WSH
 * Time: 2012-02-08
 *
 * - 2012-02-08 Initial Crated by WSH
 * - 2013-06-05 All modify by HYANG
 */

import QtQuick 1.1

MComponent {
    id: idMOptionMenu
    x: 0; y: 0; z: parent.z + 1
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight //720-93
    focus: true

    property QtObject linkedModels

    property string menuDepth: "OneDepth" //"OneDepth" or "TwoDepth" # added by HYANG_20120228

    //--------------------- Image Path Info(Property) #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string sImgBg_OptionMenu:  imgFolderGeneral + "bg_optionmenu.png"
    property string sImgLine_OptionMenu: imgFolderGeneral + "line_optionmenu.png"
    property string sImgBg_OptionMenuListP : imgFolderGeneral + "bg_optionmenu_list_p.png"
    property string sImgBg_OptionMenuListF : imgFolderGeneral + "bg_optionmenu_list_f.png"
    property string sImgIco_OptionMenuArrow: imgFolderGeneral + "ico_optionmenu_arrow.png"

    //--------------------- OptionMenu Info(Property) #
    //property real rDimBlackOpacity: 0.6
    property int iMenuBgX: 767  //767 or 727
    property int iMenuBgWidth: 513
    property int iMenuAreaX: (menuDepth == "OneDepth") ? 78 : 78+41    //845 - 767
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

    //--------------------- SXM Radio - property #
    property bool   gArtistSongAlert : false
    property bool   gUnsubscribedChannel : false

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

    function timerRestart()
    {
        idMOptionMenuTimer.restart();
    }

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
        }
    }

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
        }
        idMOptionMenuTimer.restart();
    }

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
        }
        idMOptionMenuTimer.restart()
    }

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
        }
        idMOptionMenuTimer.restart()
    }

    //--------------------- Dim Background Black 60% #
    //    Rectangle{
    //        id: idDimBg
    //        x: 0;
    //        y: 0;
    //        width: systemInfo.lcdWidth
    //        height: systemInfo.lcdHeight
    //        color: colorInfo.black
    //        opacity: (menuDepth == "OneDepth") ? rDimBlackOpacity : 0
    //    } // End Rectangle

    //--------------------- Send signal - optionMenuFinished()
    MouseArea{
        anchors.fill: parent

        onPressed: {
            startX = mouseX;
        }
        onReleased: {
            if(mouseX == startX)
            {
                idAppMain.playBeep();
                idMOptionMenuTimer.stop();
                optionMenuFinished();
            }
            if(mouseX - startX > 100)
            {
                idAppMain.playBeep();
                idMOptionMenuTimer.stop();
                if(menuDepth == "OneDepth")
                    optionMenuFinished();
                else
                    idAppMain.optionMenuSubClose();
            }
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
                if(mouseX - startX > 100)
                {
                    idAppMain.playBeep();
                    if(menuDepth == "OneDepth")
                        idMOptionMenu.hideOptionMenu();
                    else
                        idAppMain.optionMenuSubClose();
                }
            }

            Image{
                x:  (menuDepth == "OneDepth") ? 0 : 40
                source: sImgBg_OptionMenu
                MouseArea{
                    anchors.fill: parent
                    onReleased: {
                        if(menuDepth == "OneDepth")
                        {
                            idAppMain.playBeep();
                            optionMenuFinished()
                        }
                        else
                        {
                            idAppMain.playBeep();
                            idAppMain.optionMenuSubClose();
                        }
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

    onSeekPrevKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() } //Add Seek Prev/Next
    onSeekNextKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() } //Add Seek Prev/Next
    onTuneRightKeyPressed:{ idMOptionMenuTimer.stop(); optionMenuFinished() } //Add tune Right/left/Enter
    onTuneLeftKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() } //Add tune Right/left/Enter
    //onTuneEnterKeyPressed:{ idMOptionMenuTimer.stop(); optionMenuFinished() } //Add tune Right/left/Enter
    onSWRCSeekPrevKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() } //Add Swrc Prev/Next
    onSWRCSeekNextKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() } //Add Swrc Prev/Next
    onSeekPrevLongKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() } //Add Long Seek Prev/Next
    onSeekNextLongKeyPressed: { idMOptionMenuTimer.stop(); optionMenuFinished() } //Add Long Seek Prev/Next
    onAnyKeyReleased:{ idMOptionMenuTimer.restart() }

    Component.onCompleted: {
        showOptionMenu()
        idMOptionMenuTimer.start()
    }

    //--------------------- Visible change(Function) #
    onVisibleChanged: {
        //console.log(" [MOptionMenu][onVisibleChanged]["+menuDepth+"] : "+ idMOptionMenu.visible)
        if(visible) { showOptionMenu() }
        else { idMOptionMenuTimer.stop() }
    }

    //--------------------- Option Menu Animation #
    states: [
        State {
            name: "show";
            PropertyChanges { target: idMenu; x: iMenuBgX }
        },
        State {
            name: "showSub";
            PropertyChanges { target: idMenu; x: iMenuBgX-40 }
        },
        State {
            name: "hide";
            PropertyChanges { target: idMenu; x: iMenuBgX + iMenuAreaWidth }
        },
        State {
            name: "hideSub";
            PropertyChanges { target: idMenu; x: (menuDepth == "OneDepth") ? iMenuBgX : iMenuBgX + iMenuAreaWidth}
        }
    ]
    transitions:[
        Transition {
            NumberAnimation {  target: idMenu; properties: "x"; duration: 100;  }
        }
    ]

    function showOptionMenu()
    {
        //console.log("[0]-------------------> showOptionMenu : "+idAppMain.state)
        if(idAppMain.state == "AppRadioOptionMenuSub")
        {
            //One or Two depth MENU Timer stop
            if(idOptionMenuHideTimer.running == true)
                idOptionMenuHideTimer.stop();
            if(idOptionMenuSubHideTimer.running == true)
                idOptionMenuSubHideTimer.stop();

            idMOptionMenu.state = "showSub";
        }
        else
            idMOptionMenu.state = "show";

        idMOptionMenuTimer.start();
    }
    function hideOptionMenu()
    {
        //console.log("[0]-------------------> hideOptionMenu : "+idAppMain.state)
        idMOptionMenu.state = "hide";
        idOptionMenuHideTimer.start();
    }
    function offOptionMenu()
    {
        //console.log("[0]-------------------> offOptionMenu : "+idAppMain.state)
        idMOptionMenu.state = "hide";
        gotoBackScreen(false);
    }

    Connections {
        target: idAppMain
        onOptionMenuSubOpen:
        {
            //console.log("[0]-------------------> onOptionMenuSubOpen : "+idAppMain.state)
            if(idAppMain.state == "AppRadioOptionMenuSub")
            {
                //One or Two depth MENU Timer stop
                if(idOptionMenuHideTimer.running == true)
                    idOptionMenuHideTimer.stop();
                if(idOptionMenuSubHideTimer.running == true)
                    idOptionMenuSubHideTimer.stop();

                idMOptionMenu.state = "showSub";
            }
        }
        onOptionMenuSubClose:{
            //console.log("[0]-------------------> onOptionMenuSubClose : "+idAppMain.state)
            //One-depth MENU Timer stop
            if(idOptionMenuHideTimer.running == true)
                idOptionMenuHideTimer.stop();

            idMOptionMenu.state = "hideSub";
            idOptionMenuSubHideTimer.start();
        }
        onOptionMenuAllHide:
        {
            //console.log("[0]-------------------> onOptionMenuAllHide : "+idAppMain.state)
            idMOptionMenu.state = "hide";
            idOptionMenuHideTimer.start();
        }
        onOptionMenuAllOff:{
            //console.log("[0]-------------------> onOptionMenuAllOff : "+idAppMain.state)
            idMOptionMenu.state = "hide";
            if(idAppMain.state == "AppRadioOptionMenu" || idAppMain.state == "AppRadioOptionMenuSub")
                gotoBackScreen(false);
        }
    }

    //--------------------- OptionMenu Timer
    Timer{
        id: idOptionMenuHideTimer
        interval: 100;
        onTriggered: {
            //console.log("[0]-------------------> idOptionMenuHideTimer.onTriggered : "+idAppMain.state)
            idOptionMenuHideTimer.stop();
            if(idAppMain.state == "AppRadioOptionMenu" || idAppMain.state == "AppRadioOptionMenuSub" || idAppMain.state == "AppRadioFavDeleteMenu" || idAppMain.state == "AppRadioFavCancelMenu" || idAppMain.state == "AppRadioListMenu" || idAppMain.state == "AppRadioEPGMenu")
                gotoBackScreen(false);
        }
    }
    Timer{
        id: idOptionMenuSubHideTimer
        interval: 100;
        onTriggered: {
            //console.log("[0]-------------------> idOptionMenuSubHideTimer.onTriggered : "+idAppMain.state)
            idOptionMenuSubHideTimer.stop();
            if(idAppMain.state == "AppRadioOptionMenuSub")
                gotoBackScreen(false);
        }
    }
    Timer{
        id : idMOptionMenuTimer
        interval: 10000
        repeat: true;
        onTriggered: {
            if((idAppMain.state == "AppRadioOptionMenu" && idRadioOptionMenu.activeFocus) ||
                    (idAppMain.state == "AppRadioFavDeleteMenu" && idMDeleteMenu.activeFocus) ||
                    (idAppMain.state == "AppRadioFavCancelMenu" && idMCancelMenu.activeFocus) ||
                    (idAppMain.state == "AppRadioListMenu" && idMListMenu.activeFocus) ||
                    (idAppMain.state == "AppRadioEPGMenu" && idMEpgMenu.activeFocus))
            {
                //console.log("[0]-------------------> idMOptionMenuTimer.onTriggered : "+idAppMain.state)
                idMOptionMenuTimer.stop();
                optionMenuFinished();
                return;
            }
            if(idAppMain.state == "AppRadioOptionMenuSub" && idMOptionMenu.activeFocus && idRadioOptionMenuSub.activeFocus)
            {
                //console.log("[1]-------------------> idMOptionMenuTimer.onTriggered : "+idAppMain.state)
                idMOptionMenuTimer.stop();
                optionMenuFinished();
                return;
            }
        }
    }
}
