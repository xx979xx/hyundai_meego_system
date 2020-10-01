/**
 * /QML/DH_arabic/MOptionMenuList.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/Javascript/operation.js" as MOp

FocusScope
{
    focus: true

    /* INTERNAL functions */
    function firstfocus() {
        listOptionMenu.forceActiveFocus();

        if(false == menu0Dimmed) {
            listOptionMenu.currentIndex = 0;
        } else if(false == menu1Dimmed) {
            listOptionMenu.currentIndex = 1;
        } else if(false == menu2Dimmed) {
            listOptionMenu.currentIndex = 2;
        } else if(false == menu3Dimmed) {
            listOptionMenu.currentIndex = 3;
        } else {
            listOptionMenu.currentIndex = 4;
        }
    }

    function isDimmed(index) {
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


    /* EVENT handlers */
    Component.onCompleted: {
        firstfocus();
    }

    onVisibleChanged: {
        if(true == visible){
            firstfocus();
        }
    }

    MouseArea {
        anchors.fill: parent
    }


    MouseArea {
        id: idRoofContainer
        x: 0
        y: 0
        width: parent.width
        height: 700

        /* WIDGETS */
        DDListView {
            id: listOptionMenu
            width: delegateWidth
            height: 720
            focus: true
            model: linkedModels
            orientation : ListView.Vertical
            highlightMoveSpeed: 9999999
            snapMode: ListView.SnapToItem
            boundsBehavior: Flickable.DragAndOvershootBounds
            currentIndex: idMOptionMenu.linkedCurrentIndex
            interactive: true
            clip: true

            property bool longPressed: false

            onMovementStarted: {
                idFlickingTimer.restart();
                idMOptionMenuTimer.stop();
            }

            onMovementEnded: {
                idFlickingTimer.stop();
                idMOptionMenuTimer.restart();
            }

            delegate: MOptionMenuDelegate {
                id: idDelegate

                onWheelRightKeyPressed: {
                    if(false == listOptionMenu.flicking && false == listOptionMenu.moving) {
                        /* 모두 다 Dimm된 상태는 없다고 가정함 */
                        // FROM current index - 1 TO 0
                        for(var i = listOptionMenu.currentIndex - 1; i >= 0; i--) {
                            if(false == isDimmed(i)) {
                                listOptionMenu.currentIndex = i;
                                return;
                            }
                        }
                    }
                }

                onWheelLeftKeyPressed: {
                    if(false == listOptionMenu.flicking && false == listOptionMenu.moving) {
                        /* 모두 다 Dimm된 상태는 없다고 가정함 */
                        // FROM current index + 1 TO count - 1
                        for(var i = listOptionMenu.currentIndex + 1; i < listOptionMenu.count; i++) {
                            if(false == isDimmed(i)) {
                                listOptionMenu.currentIndex = i;
                                return;
                            }
                        }
                    }
                }

                Keys.onPressed: {
                    idMOptionMenuTimer.stop();
                    if(Qt.Key_Down == event.key) {
                        if(Qt.ShiftModifier == event.modifiers) {
                            // Long-pressed
                            listOptionMenu.longPressed = true;
                            idDownScrollTimer.start();
                        } else {
                            event.accepted = true;
                        }
                    } else if(Qt.Key_Up == event.key) {
                        if(Qt.ShiftModifier == event.modifiers) {
                            // Long-pressed
                            listOptionMenu.longPressed = true;
                            idUpScrollTimer.start();
                        } else {
                            event.accepted = true;
                        }
                    }
                }

                Keys.onReleased: {
                    idMOptionMenuTimer.restart();
                    if(Qt.Key_Down == event.key) {
                        if(true == listOptionMenu.longPressed) {
                            listOptionMenu.longPressed = false;
                            idUpScrollTimer.stop();
                            idDownScrollTimer.stop();
                            if(listOptionMenu.currentIndex < listOptionMenu.count - 1) {
                                // Propagate to ListView
                            } else {
                                // 더이상 밑으로 내려갈 수 없을때 Release도 전달되지 않도록 막아야 함
                                listOptionMenu.longPressed = false;
                                event.accepted = true;
                            }
                        } else {
                            // Set focus to "ListView"
                            event.accepted = true;
                        }
                    } else if(Qt.Key_Up == event.key) {
                        if(true == listOptionMenu.longPressed) {
                            listOptionMenu.longPressed = false;
                            idUpScrollTimer.stop();
                            idDownScrollTimer.stop();
                            if(0 < listOptionMenu.currentIndex) {
                                // Propagate to ListView
                            } else {
                                // 더이상 위로 올라갈 수 없을때 Release도 전달되지 않도록 막아야 함
                                listOptionMenu.longPressed = false;
                                event.accepted = true;
                            }
                        } else {
                            // Set focus to "Search Button"
                            event.accepted = true;
                        }
                    }
                }
            }


            Timer {
                id: idDownScrollTimer
                interval: 200
                repeat: true

                onTriggered: {
                    if(listOptionMenu.currentIndex < listOptionMenu.count - 1) {
                        listOptionMenu.forceActiveFocus();

                        if(listOptionMenu.count < 3) {
                            if(false == isDimmed(listOptionMenu.currentIndex + 1)) {
                                listOptionMenu.currentIndex += 1;
                            }
                        } else if(listOptionMenu.count < 4) {
                            if(false == isDimmed(listOptionMenu.currentIndex + 1)) {
                                listOptionMenu.currentIndex += 1;
                            } else if(false == isDimmed(listOptionMenu.currentIndex + 2)) {
                                listOptionMenu.currentIndex += 2;
                            }
                        }  else if(listOptionMenu.count < 5) {
                            if(false == isDimmed(listOptionMenu.currentIndex + 1)) {
                                listOptionMenu.currentIndex += 1;
                            } else if(false == isDimmed(listOptionMenu.currentIndex + 2)) {
                                listOptionMenu.currentIndex += 2;
                            } else if(false == isDimmed(listOptionMenu.currentIndex + 3)) {
                                listOptionMenu.currentIndex += 3;
                            }
                        }
                    }
                }
            }


            Timer {
                id: idUpScrollTimer
                interval: 200
                repeat: true

                onTriggered: {
                    if(0 != listOptionMenu.currentIndex) {
                        if(listOptionMenu.count < 3) {
                            if(false == isDimmed(listOptionMenu.currentIndex - 1)) {
                                listOptionMenu.currentIndex -= 1;
                            }
                        } else if(listOptionMenu.count < 4) {
                            if(false == isDimmed(listOptionMenu.currentIndex - 1)) {
                                listOptionMenu.currentIndex -= 1;
                            } else if(false == isDimmed(listOptionMenu.currentIndex - 2)) {
                                listOptionMenu.currentIndex -= 2;
                            }
                        }  else if(listOptionMenu.count < 5) {
                            if(false == isDimmed(listOptionMenu.currentIndex - 1)) {
                                listOptionMenu.currentIndex -= 1;
                            } else if(false == isDimmed(listOptionMenu.currentIndex - 2)) {
                                listOptionMenu.currentIndex -= 2;
                            } else if(false == isDimmed(listOptionMenu.currentIndex - 3)) {
                                listOptionMenu.currentIndex -= 3;
                            }
                        }

                        console.log("listOptionMenu.currentIndex  > " + listOptionMenu.currentIndex)
                    } else {
                        listOptionMenu.currentIndex = 0;
                        stop();
                    }
                }
            }

            function stopScroll() {
                if(true == idDownScrollTimer.running) {
                    idDownScrollTimer.stop();
                } else if(true == idUpScrollTimer.running) {
                    idUpScrollTimer.stop();
                }
            }

            function runningScroll() {
                if(true == idDownScrollTimer.running || true == idUpScrollTimer.running) {
                    return true;
                } else {
                    return false;
                }
            }

            onCurrentIndexChanged: {
                linkedCurrentItem = listOptionMenu.currentItem
            }
        }

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
            idFlickingTimer.stop();
            idMOptionMenuTimer.restart();

            useX = startX - mouseX; // reverse

            if((mouseY - startY) > 0) {
                useY = mouseY - startY;
            }
            else {
                useY = startY - mouseY;
            }

            if((useX > 100) && (useY < (useX / 2))){
                menuOn = false
                console.log("## ~ Play Beep Sound(MOptionMenuList) ~ ##")
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
}
/* EOF */
