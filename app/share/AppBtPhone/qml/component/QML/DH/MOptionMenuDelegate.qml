/**
 * /QML/DH/MOptionMenuDelegate.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MButtonHaveTickerNoActiveFocus
{
    id: idOptionMenuDelegate
    x: 0
    y: 0
    width: 412
    height: 78

    property int delegateStartX : 0
    property int delegateStartY : 0
    property bool dragMenu: false

    dimmed: {
        if(0 == index) {
            menu0Dimmed
        } else if(1 == index) {
            menu1Dimmed
        } else if(2 == index) {
            menu2Dimmed
        } else if(3 == index) {
            menu3Dimmed
        } else if(4 == index) {
            menu4Dimmed
        } else if(5 == index) {
            menu5Dimmed
        } else if(6 == index) {
            menu6Dimmed
        } else if(7 == index) {
            menu7Dimmed
        } else if(8 == index) {
            menu8Dimmed
        } else if(9 == index) {
            menu9Dimmed
        } else if(10 == index) {
            menu10Dimmed
        } else {
            false
        }
    }

    /* INTERNAL functions */
/*DEPRECATED
    function getDimmed() {
        switch(index) {
            case 0:     return menu0Dimmed;
            case 1:     return menu1Dimmed;
            case 2:     return menu2Dimmed;
            case 3:     return menu3Dimmed;
            case 4:     return menu4Dimmed;
            case 5:     return menu5Dimmed;
            case 6:     return menu6Dimmed;
            case 7:     return menu7Dimmed;
            case 8:     return menu8Dimmed;
            case 9:     return menu9Dimmed;
            case 10:    return menu10Dimmed;

            default:
                return false;
        }
    }
DEPRECATED*/

    function opTypeEvent(index) {
        if(!idOptionMenuDelegate.dimmed) {
            indexEvent(index)
        }
    }

    Connections {
        target: idAppMain
        onMouseAreaExit: {
            if(true == idOptionMenuDelegate.visible) {
                if(!idOptionMenuDelegate.mEnabled) return;
                idOptionMenuDelegate.state = "keyRelease"
                /* ITS 0239280
                 * 옵션 메뉴의 빈 공간 드래그 시, 메뉴 리스트 움직이지 않는 이슈
                 */
                //listOptionMenu.interactive = true
            }
        }
    }

    Connections {
        target: idAppMain
        onMouseAreaExit: {
            idFlickingTimer.stop();
            idMOptionMenuTimer.restart();
        }
    }

    onPressed: {
        delegateStartX = x;
        delegateStartY = y;
        idFlickingTimer.restart();
        idMOptionMenuTimer.stop();
        console.log("Mouse X = " + x)
        /*if(false == idOptionMenuDelegate.dimmed) {
            idOptionMenuDelegate.state = "STATE_PRESSED"
        }*/

        /* ITS 0239280
         * 옵션 메뉴의 빈 공간 드래그 시, 메뉴 리스트 움직이지 않는 이슈
         */
        //listOptionMenu.interactive = false
    }

    onReleased: {
        console.log("Mouse X = " + x)
        console.log("delegateStartX X = " + delegateStartX)
        idFlickingTimer.stop();
        idMOptionMenuTimer.restart();

        if(true == idOptionMenuDelegate.dimmed) {
            idOptionMenuDelegate.state = "STATE_RELEASED"
            return;
        }

        //[ITS 0270627]
        //console.log("## ~ Play Beep Sound(MOptionMenuDelegate) ~ ##")
        //UIListener.ManualBeep();

        if(x - delegateStartX > 100) {
            menuOn = false
            idMenuContainer.state = "STATE_HIDE"
            dragMenu = true
            idHandle.x = 0;
            idHandle.y = 0;
            delegateStartX = 0;
            menuOffFocus();
            MOp.returnFocus();
        } else if(x - delegateStartX < -1) {

        } 
        // 클릭 동작 2번 발생
        /*else {
            opTypeEvent(index);
        }*/

        /* ITS 0239280
         * 옵션 메뉴의 빈 공간 드래그 시, 메뉴 리스트 움직이지 않는 이슈
         */
        //listOptionMenu.interactive = true
    }


    /* EVENT handlers */
    onClickOrKeySelected: {
        if(true == idOptionMenuDelegate.dimmed) {
            idOptionMenuDelegate.state = "STATE_RELEASED"
        } else {
            menuOn = false
            idMenuContainer.state = "STATE_HIDE"
            idHandle.x = 0;
            idHandle.y = 0;
            delegateStartX = 0;
            menuOffFocus();
            MOp.returnFocus();

            if(false == dragMenu) {
                opTypeEvent(index);
            }

            dragMenu = false
        }
    }

    onLeftKeyReleased: {
        optionMenuFinished()
    }

    onActiveFocusChanged: {
        // Disable visual cue
        if(true == idOptionMenuDelegate.activeFocus) {
            idVisualCue.setVisualCue(false, false, false, false);
        }
    }

    onSelectKeyPressed: {
        idMOptionMenuTimer.stop();
    }

    onAnyKeyReleased: {
        idMOptionMenuTimer.restart();
    }

    /* Ticker Enable! */
    tickerEnable: true

    /* WIDGETS */
    bgImage: ""
    bgImagePress: ImagePath.imgFolderGeneral + "bg_optionmenu_list_p.png"
    bgImageFocus: ImagePath.imgFolderGeneral + "bg_optionmenu_list_f.png"
    bgImageX: 0
    bgImageY: -3
    bgImageWidth: 412
    bgImageHeight: 86

    lineImage: ImagePath.imgFolderGeneral + "line_optionmenu.png"
    lineImageX: -1
    lineImageY: 78

    firstText: name
    firstTextX: listLeftMargine
    firstTextY : 27
    firstTextSize: 32
    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    firstTextWidth: 375
    firstTextAlies: "Left"
    firstTextElide : "Right"

    // 메뉴 비활성화에 따라 동적으로 색상이 변경되지 않아 수동으로 변경함
    firstTextColor: {
        /* CarPlay */
        if(true == dimmed){
            colorInfo.disableGrey
        } else {
            if(0 == index) {
                menu0TextColor
            } else if(1 == index) {
                menu1TextColor
            } else if(2 == index) {
                menu2TextColor
            } else if(3 == index) {
                menu3TextColor
            } else {
                colorInfo.subTextGrey
            }
        }
    }
    firstTextPressColor: colorInfo.brightGrey
    firstTextFocusPressColor: colorInfo.brightGrey
    firstDimmedTextColor: colorInfo.disableGrey
    firstTextEnabled: !dimmed
    firstTextClip: false

    KeyNavigation.up: idOptionMenuDelegate
    KeyNavigation.right: idOptionMenuDelegate
    KeyNavigation.down: idOptionMenuDelegate

    /* MouseArea {
        anchors.fill: idOptionMenuDelegate

        // 메뉴 버튼 선택 시 Beep 2번 발생하는 문제점 수정
        // beepEnabled: false

        drag.target:idHandle
        drag.axis: Drag.XandYAxis//Drag.XAxis
        drag.minimumY: 0
        drag.maximumY: 78
        drag.minimumX: 0
        drag.maximumX: idOptionMenuDelegate.width
        drag.filterChildren: true

        onExited: {
            mouseAreaExit();
        }

        Rectangle {
            id: idHandle
            x: 0
            y: 0
            width: 200
            height: idMOptionMenu.height
            visible: false
        }
    }*/
}
/* EOF */
