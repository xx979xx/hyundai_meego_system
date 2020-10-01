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

MComponent { // FocusScope { // # (for "onClickMenuKey" use) by HYANG #
    id: idMOptionMenu
    x: 0; y: 0; z: parent.z + 1
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight //720-93
    focus: true

    property QtObject linkedModels
    property QtObject linkedDelegate     : Component{MOptionMenuDelegate {}}
    property QtObject linkedCurrentItem
    property int      linkedCurrentIndex : 0
    property string menuDepth: "OneDepth" //"OneDepth" or "TwoDepth" # added by HYANG_20120228
    property bool isTimerClose: false
    property Item parentOptionMenu: null
    property alias imgBGForSub: imgBg
    property bool isOnAnimation: idFadeInAnimation.running || idFadeOutAnimation.running || idFadeInAnimationForSub.running || idFadeOutAnimationForSub.running

    //--------------------- Timer Info(Property) #
    signal optionMenuFinished()  // Send signal, after 5 sec # by WSH
    signal optionFinishForSubMenu()
    property int disappearInterval: 200

    //--------------------- Image Path Info(Property) #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    //--------------------- RadioSeleted Info(Property) ##
    property int selectedRadioIndex: 0

    //--------------------- OptionMenu Info(Property) #
    property string opBgImg : imgFolderGeneral + "bg_optionmenu.png"
    property int opBgWidth: systemInfo.lcdWidth - 767
    property int opBgMenuX: 767
    property int opLeftMargine: 845-767

    property string opViewImg: ""
    property int opViewImgWidth: 347
    property int opViewImgHeight: 199
    property int opViewRightMargin: (systemInfo.lcdWidth-908)-opViewImgWidth
    property int opViewTopMargin: 429-systemInfo.statusBarHeight
    property bool opViewImgVisible: false

    //--------------------- Delegate Info(Property) #
    property int delegateWidth: listLeftMargine + opItemWidth

    //--------------------- Item Text Info(Property) ##
    property int opItemWidth: 385
    property int opItemHeight: 81
    property int opItemFontSize : 32
    property string opItemFontName: systemInfo.font_NewHDR

    //--------------------- List Info(Property) ##
    property int listAreaWidth: opBgWidth - opLeftMargine + (listLeftFocusMargine*2) // 435+6 : 395+6
    property int listLeftFocusMargine : 3
    property int listLeftMargine : 27

    //--------------------- Line Info(Property) ##
    property int opLineY: opItemHeight-1
    property int opLineHeight: 2
    property string opLineImg: imgFolderGeneral + "line_optionmenu.png"

    //--------------------- Scroll Info(Property) ##
    property int opScrollWidth: 13
    property int opScrollY: 5

    //--------------------- Icon Info(Property) ##
    property int opIconX: 356

    property int startX: 0

    //--------------------- Button Info(Property) #
    property string opBgImagePress : imgFolderGeneral + "bg_optionmenu_list_p.png"
    property string opBgImageFocusPress : imgFolderGeneral + "bg_optionmenu_list_fp.png"
    property string opBgImageFocus : imgFolderGeneral + "bg_optionmenu_list_f.png"

    //--------------------- Dim Info(Property) #
    property bool menu0Enabled: true
    property bool menu1Enabled: true
    property bool menu2Enabled: true
    property bool menu3Enabled: true
    property bool menu4Enabled: true
    property bool menu5Enabled: true


    //--------------------- Default Click Event(Signal) #
    signal menu0Click()
    signal menu1Click()
    signal menu2Click()
    signal menu3Click()
    signal menu4Click()
    signal menu5Click()

    //--------------------- Radio Click Event(Signal) #
    signal radio0Click()
    signal radio1Click()
    signal radio2Click()
    signal radio3Click()
    signal radio4Click()
    signal radio5Click()

    //--------------------- DimCheck Click Event(Signal) #
    signal dimCheck0Click()
    signal dimCheck1Click()
    signal dimCheck2Click()
    signal dimCheck3Click()
    signal dimCheck4Click()
    signal dimCheck5Click()

    //--------------------- DimUncheck Click Event(Signal) #
    signal dimUncheck0Click()
    signal dimUncheck1Click()
    signal dimUncheck2Click()
    signal dimUncheck3Click()
    signal dimUncheck4Click()
    signal dimUncheck5Click()

    //--------------------- Default Click Event(Function) #
    function indexEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.menu0Click(); break; } // End case
        case 1:{ idMOptionMenu.menu1Click(); break; } // End case
        case 2:{ idMOptionMenu.menu2Click(); break; } // End case
        case 3:{ idMOptionMenu.menu3Click(); break; } // End case
        case 4:{ idMOptionMenu.menu4Click(); break; } // End case
        case 5:{ idMOptionMenu.menu5Click(); break; } // End case
        } // End switch
        idMOptionMenu.visible = false;
    } // End function

    //--------------------- Default Click Event(Function) #
    function subMenuIndexEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.menu0Click(); break; } // End case
        case 1:{ idMOptionMenu.menu1Click(); break; } // End case
        case 2:{ idMOptionMenu.menu2Click(); break; } // End case
        case 3:{ idMOptionMenu.menu3Click(); break; } // End case
        case 4:{ idMOptionMenu.menu4Click(); break; } // End case
        case 5:{ idMOptionMenu.menu5Click(); break; } // End case
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
        } // End switch
        idMOptionMenuTimer.stopTimer()
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
        } // End switch
        idMOptionMenuTimer.resetTimer()
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
        } // End switch
        idMOptionMenuTimer.resetTimer()
        //console.log(" [MOptionMenu][dimUncheckEvent]["+index+"] On => Off")
    } // End function

    Timer{
        id : idMOptionMenuTimer
        interval: 10000
        repeat: false;

        onTriggered:{
            //console.debug(" [MOptionMenu][onTriggered]["+menuDepth+"]:" + timerCount);
            isTimerClose = true;
            finishTimer();
            optionMenuFinished();//[ITS 190685]
        }
        function startTimer()
        {
            idMOptionMenuTimer.restart()
            //console.debug(" [MOptionMenu][startTimer] , menuDepth: ", menuDepth)
        }
        function finishTimer()
        {
            idMOptionMenuTimer.stop()
            hideMenu();
            console.debug(" [MOptionMenu]["+menuDepth+"] , Send optionMenuFinished()")
        }
        function resetTimer(){
            idMOptionMenuTimer.restart();
        }
        function stopTimer(){
            idMOptionMenuTimer.stop();
        }
    } // End Timer

    //--------------------- Dim Background Black 70% #
/*    Rectangle{
        id:bgDim
        x: 0; y: 0 //systemInfo.statusBarHeight
        width: systemInfo.lcdWidth  //# KEH
        //width: systemInfo.lcdWidth-delegateWidth
        height: systemInfo.subMainHeight
        color: colorInfo.black
        opacity: 0
    }*/ // End Rectangle

    //--------------------- Send signal - optionMenuFinished()
    MouseArea{
        anchors.fill: parent
        anchors.rightMargin: opViewImgWidth;//[ITS 191999]
        onPressed: {
            startX = mouseX;
            idMOptionMenuTimer.stop();
        }
        onPressAndHold: {
            startX = mouseX;
            idMOptionMenuTimer.stop();
        }
        onReleased: {
            if(isOnAnimation)
                return;

            UIListener.playAudioBeep();
            //[ITS 209553]
            if((mouseX - startX > 100) && (menuDepth == "TwoDepth")) {
                idMOptionMenuTimer.restart();
                optionFinishForSubMenu();
            }
            else
            {
                if((mouseX - startX > 100) || (mouseX == startX))
                {
                    idMOptionMenuTimer.stop();
                    optionMenuFinished();
                }
            }
        }
        enabled: idMOptionMenu.state == "show"
    }

    //--------------------- Background Image ##
    Image{
        id: imgBg
        x: opBgMenuX + opBgWidth
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
                startX = mouseX;
                idMOptionMenuTimer.stop();
            }

            onPressAndHold: {
                startX = mouseX;
                idMOptionMenuTimer.stop();
            }

            onReleased: {
                idMOptionMenuTimer.restart();
                if(mouseX - startX > 100) {
                    UIListener.playAudioBeep();
                    if(menuDepth == "OneDepth")  optionMenuFinished();
                    else  optionFinishForSubMenu();
                }
            }
            onCanceled:{
                idMOptionMenuTimer.restart();
                if(mouseX - startX > 100) {
                    if(menuDepth == "OneDepth")  optionMenuFinished();
                    else  optionFinishForSubMenu();
                }
            }

        //--------------------- OptionMenu List ##
            MOptionMenuList{
                id: idMOptionMenuList
                x: opLeftMargine+listLeftFocusMargine;
                y: idMOptionMenu.y
                width: listAreaWidth-(listLeftFocusMargine*2); height: idMOptionMenu.height

                MouseArea{
                    anchors.fill: parent
                    enabled: isOnAnimation
                }
            } // End MOptionMenuList

            Rectangle {
                id: idFlickingHandleArea
                anchors.fill: idMOptionMenuList
                visible: false
                opacity: 0.3
                color: "green"
            }
            Rectangle{
                anchors.fill: parent
                visible: false
                opacity: 0.3
                color: "red"
            }
            MouseArea{
                x: 0; y: 0
                width: idMOptionMenuList.x; height: parent.height
                enabled: menuDepth == "TwoDepth"
                onClicked: {
                    UIListener.playAudioBeep();
                    optionFinishForSubMenu();
                }
                Rectangle{
                    anchors.fill: parent
                    visible: false
                    opacity: 0.3
                    color: "blue"
                }
            }
        }
    } // End Image

    onAnyKeyReleased:{ idMOptionMenuTimer.resetTimer() }

    //--------------------- Visible change(Function) #
//    onVisibleChanged: {
//        if(visible) {
//            idMOptionMenu.focus = true
//            idMOptionMenu.state = "show"
//            idMOptionMenuTimer.startTimer()
//    }
//        else {
//            idMOptionMenuTimer.stop() //jyjeon_20120606
//        } // End if
//    }

    //--------------------- Focus change(Function) #
    onActiveFocusChanged: {
        if(activeFocus) { idMOptionMenuTimer.startTimer() }
        else { idMOptionMenuTimer.stop() } //jyjeon_20120606
    }

    //******************************# Option Menu Animation 
    SequentialAnimation{
        id: idFadeInAnimation
        running: false
        ParallelAnimation {
            SmoothedAnimation {target: imgBg; property: "x"; to: opBgMenuX; duration: disappearInterval;/* velocity:200*/}
//            PropertyAnimation{target: bgDim; property: "opacity"; to:  menuDepth=="OneDepth" ? 0.8 : 0; duration: disappearInterval;}
        }
    }

    SequentialAnimation{
        id: idFadeOutAnimation
        running: false
        ParallelAnimation {
            SmoothedAnimation {target: imgBg; property: "x"; to: opBgMenuX + opBgWidth; duration: disappearInterval;/*velocity:200*/}
//            PropertyAnimation{target: bgDim; property: "opacity"; to:  0; duration: disappearInterval;}
        }
        onCompleted: {
            if(state == "hide")
            {
                if(menuDepth == "OneDepth" || isTimerClose)
                    optionMenuFinished();
                idMOptionMenu.visible = false;
                linkedCurrentIndex = 0
            }
        }
    }

    SequentialAnimation{
        id: idFadeInAnimationForSub
        running: false
        ParallelAnimation {
            SmoothedAnimation {target: imgBg; property: "x"; to: opBgMenuX; duration: disappearInterval; /*velocity:200*/}
//            SmoothedAnimation {target: bgDim; property: "opacity"; to: menuDepth=="OneDepth" ? 0.8 : 0; duration: disappearInterval;/*velocity:200*/}
            SmoothedAnimation {target: parentOptionMenu; property: "x"; to: opBgMenuX-40; duration: disappearInterval; /*velocity:200*/}
        }
    }

    SequentialAnimation{
        id: idFadeOutAnimationForSub
        running: false
        ParallelAnimation {
            SmoothedAnimation {target: imgBg; property: "x"; to: opBgMenuX + opBgWidth; duration: disappearInterval;/*velocity:200*/}
//            SmoothedAnimation {target: bgDim; property: "opacity"; to: 0; duration: disappearInterval;/*velocity:200*/}
            SmoothedAnimation {target: parentOptionMenu; property: "x"; to: opBgMenuX; duration: disappearInterval;/* velocity:200*/}
        }
        onCompleted: {
            if(state == "hide")
            {
                if(menuDepth == "OneDepth" || isTimerClose)
                    optionMenuFinished();
                idMOptionMenu.visible = false;
                linkedCurrentIndex = 0
            }
        }
    }

    onStateChanged: {
        switch(state)
        {
            case "show":
            {
                if(menuDepth == "OneDepth")
                {
                    idFadeOutAnimation.stop();
                    idFadeInAnimation.stop();
                    idFadeInAnimation.start();
                }else
                {
                    idFadeOutAnimationForSub.stop();
                    idFadeInAnimationForSub.stop();
                    idFadeInAnimationForSub.start();
                }
                break;
            }
            case "hide":
            {
                if(menuDepth == "OneDepth")
                {
                    idFadeInAnimation.stop();
                    idFadeOutAnimation.stop();
                    idFadeOutAnimation.start();
                }else
                {
                    idFadeInAnimationForSub.stop();
                    idFadeOutAnimationForSub.stop();
                    idFadeOutAnimationForSub.start();
                }
                break;
            }
            case "off":
            {
                if(menuDepth == "OneDepth")
                {
                    idFadeOutAnimation.start();
                }else
                {
                    idFadeOutAnimationForSub.start();
                }
                break;
            }
        }
    }

    //No Animation in GUI Guideline
    //Behavior on x { NumberAnimation { duration: 200 } }
    function showOrHide()
    {
        if(isHided()){
            showMenu();
        }else {
            hideMenu();
        }
    }
    function showMenu()
    {
        console.log(" [MOptionMenu] "+menuDepth+" showMenu [focus] : "+ focus)
        isTimerClose = false;
        x = 0;
        visible = true;
        focus = true;
        idMOptionMenu.state = "show"
        console.log(" [MOptionMenu] "+menuDepth+" showMenu [focus] : "+ focus)
    }
    function hideMenu()
    {
        focus = false;
        idMOptionMenu.state = "hide"
    }

    function isShowed(){ return x==0 && visible === true; }
    function isHided() { return x==systemInfo.lcdWidth && visible === false; }


    Connections{
        target:UIListener
        onTemporalModeMaintain:{
            if(!mbTemporalmode)
            {
                idMOptionMenuTimer.stop();
                optionMenuFinished();
            }
        }

        onSignalShowSystemPopup:{
            if(visible)
            {
                idMOptionMenuTimer.stop();
                optionMenuFinished();
            }
        }
    }
} // End MComponent
