/**
 * /QML/DH/MOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


FocusScope
{
    id: idMOptionMenu
    x: 0
    y: 0
    z: parent.z + 1
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property QtObject linkedModels
    property QtObject linkedDelegate: Component{ MOptionMenuDelegate {} }
    property QtObject linkedCurrentItem
    property int      linkedCurrentIndex : 0
    property string menuDepth: "OneDepth" //"OneDepth" or "TwoDepth" # added by HYANG_20120228

    property int opBgWidth: menuDepth == "OneDepth"? systemInfo.lcdWidth - 767 : systemInfo.lcdWidth - 807
    property int opLeftMargine: menuDepth == "OneDepth"? 845-767 : 885-807

    property int delegateWidth: 412

    property int opItemWidth: 375

    property int listAreaWidth: opBgWidth - opLeftMargine + (listLeftFocusMargine * 2) // 435+6 : 395+6
    property int listLeftFocusMargine : 3
    property int listLeftMargine: 27

    property int opLineY: 77
    property int opLineHeight: 2

    property bool menu0Dimmed: false
    property bool menu1Dimmed: false
    property bool menu2Dimmed: false
    property bool menu3Dimmed: false
    property bool menu4Dimmed: false
    property bool menu5Dimmed: false
    property bool menu6Dimmed: false
    property bool menu7Dimmed: false
    property bool menu8Dimmed: false
    property bool menu9Dimmed: false
    property bool menu10Dimmed: false

    property int startX: 0
    property int startY: 0
    property int useY: 0
    property int useX: 0

    /* CarPlay */
    property string menu0TextColor: colorInfo.subTextGrey
    property string menu1TextColor: colorInfo.subTextGrey
    property string menu2TextColor: colorInfo.subTextGrey
    property string menu3TextColor: colorInfo.subTextGrey

    // SIGNALS
    signal optionMenuFinished();

    signal clickDimBG();

    signal menu0Click();
    signal menu1Click();
    signal menu2Click();
    signal menu3Click();
    signal menu4Click();
    signal menu5Click();
    signal menu6Click();
    signal menu7Click();
    signal menu8Click();
    signal menu9Click();
    signal menu10Click();


    /* INTERNAL functions */
    function indexEvent(index) {
        switch(index){
        case 0: idMOptionMenu.menu0Click(); break;
        case 1: idMOptionMenu.menu1Click(); break;
        case 2: idMOptionMenu.menu2Click(); break;
        case 3: idMOptionMenu.menu3Click(); break;
        case 4: idMOptionMenu.menu4Click(); break;
        case 5: idMOptionMenu.menu5Click(); break;
        case 6: idMOptionMenu.menu6Click(); break;
        case 7: idMOptionMenu.menu7Click(); break;
        case 8: idMOptionMenu.menu8Click(); break;
        case 9: idMOptionMenu.menu9Click(); break;
        case 10: idMOptionMenu.menu10Click(); break;

        default:
            break;
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idMOptionMenuTimer.restart();
    }

    Component.onDestruction: {
        idMOptionMenuTimer.stop();
    }

    onVisibleChanged: {
        if(true == idMOptionMenu.visible) {
            idMOptionMenuList.firstfocus();
        }
    }

    onActiveFocusChanged: {
        if(true == activeFocus) {
            idMOptionMenuTimer.restart();
        } else {
            idMOptionMenuTimer.stop();
        }
    }

    /* WIDGETS */
    MouseArea {
        id: idRoofContainer
        x: systemInfo.lcdWidth - 513
        width: 513
        height: 720

        // 메뉴 버튼 선택 시 Beep 2번 발생하는 문제점 수정
        beepEnabled: false

        drag.target:idHandle
        drag.axis: Drag.XandYAxis//Drag.XAxis
        drag.minimumY: 0
        drag.maximumY: idMOptionMenu.height
        drag.minimumX: 0
        drag.maximumX: systemInfo.lcdWidth
        drag.filterChildren: true

        onPressed: {
            startX = mouseX;
            startY = mouseY;
            idFlickingTimer.restart();
            idMOptionMenuTimer.stop();
        }

        onReleased: {
            console.log("Start X = " + startX)
            console.log("Start Y = " + startY)
            console.log("mouseX X = " + mouseX)
            console.log("mouseY Y = " + mouseY)

            idFlickingTimer.stop();
            idMOptionMenuTimer.restart();

            useX = mouseX - startX;

            if((mouseY - startY) > 0) {
                useY = mouseY - startY;
            }
            else {
                useY = startY - mouseY;
            }

            console.log("USE X = " + useX)
            console.log("USE Y = " + useY)

            if(((useX > 100) && (useY < (useX / 2))) || ((useY < 15) && (useX > -15 && useX < 15))){
                menuOn = false
                console.log("## ~ Play Beep Sound(MOptionMenu) ~ ##")
                UIListener.ManualBeep();
                idMenuContainer.state = "STATE_HIDE"
                idHandle.x = 0;
                idHandle.y = 0;
                startX = 0;
                menuOffFocus();
                MOp.returnFocus();
            }
        }

        Rectangle {
            id: idHandle
            x: 0
            y: 0
            width: 200
            height: idMOptionMenu.height
            visible: false
        }
    }


    MouseArea {
        x: 0
        y: 0
        width: systemInfo.lcdWidth - 513
        height: 720

        onPressAndHold: {
            idFlickingTimer.stop();
            idMOptionMenuTimer.restart();
        }

        onClicked: {
            menuOn = false
            console.log("## ~ Play Beep Sound(MOptionMenu) ~ ##")
            UIListener.ManualBeep();
            idMenuContainer.state = "STATE_HIDE"
            idHandle.x = 0;
            idHandle.y = 0;
            startX = 0;
            menuOffFocus();
            MOp.returnFocus();
        }
    }

    FocusScope {
        id: idOptionMenu
        x: systemInfo.lcdWidth - 513
        width: 513
        height: 720
        focus: true

        Image {
            id: imgBg
            x: 0
            y: 0
            width: opBgWidth
            source: ImagePath.imgFolderGeneral + "bg_optionmenu.png"
        }

        MOptionMenuList {
            id: idMOptionMenuList
            x: 80
            y: 1
            width: listAreaWidth - (listLeftFocusMargine * 2)
            height: 720
            focus: true
        }

        onActiveFocusChanged: {
            // Disable visual cue
            if(true == idMOptionMenuList.activeFocus) {
                idVisualCue.setVisualCue(false, false, false, false);
            }
        }
    }


    /* TIMERS */
    Timer {
        id : idMOptionMenuTimer
        interval: 10000
        repeat: false

        onTriggered: {
            optionMenuFinished();
        }
    }

    Timer {
        id: idFlickingTimer
        interval: 500
        repeat: false

        onTriggered: {
            //startX = 0;
        }
    }
}
/* EOF */
