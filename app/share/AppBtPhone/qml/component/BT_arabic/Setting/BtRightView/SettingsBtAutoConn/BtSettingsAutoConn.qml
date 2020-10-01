/**
 * /BT_arabic/Setting/BtSettingsAutoConn.qml
 *
 */
import QtQuick 1.1
import "../../../../QML" as DDComp
import "../../../../QML/DH_arabic" as MComp
import "../../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idDevicePriorityContainer
    x: 15
    y: 3
    height: 534 - 3
    focus: true
    clip: true

    // PROPERTIES
    property int autoConnect: 0
    property int scrollMargin: 5
    property int scrollBottom: 0

    onActiveFocusChanged: {
        if(false == idDevicePriorityContainer.activeFocus) {
            if(BtCoreCtrl.m_autoConnectMode == 0) {
                device_auto_device_no_connect.focus = false
                id_auto_device_connect_list.focus = true
                id_auto_device_connect_list.currentIndex = 0
            } else {
                device_auto_device_no_connect.focus = true
                id_auto_device_connect_list.focus = false
            }
        } else {
            idDevicePriorityFlickable.contentY = 0;
        }
    }

    /* INTERNAL functions */
    function calculateContentHeight() {
//        console.log("# idDevicePriorityFlickable.height = " + idDevicePriorityFlickable.height);
//        console.log("# idDevicePriorityFlickable.contentHeight = " + idDevicePriorityFlickable.contentHeight);
//        console.log("# idDevicePriorityHelp.height = " + idDevicePriorityHelp.height);
//        console.log("# idDevicePriorityHelp.paintedHeight = " + idDevicePriorityHelp.paintedHeight);
//        console.log("# id_auto_device_connect_list.count = " + id_auto_device_connect_list.count);

        var tempMargin = idDevicePriorityHelp.paintedHeight - idDevicePriorityHelp.height
        scrollBottom = 20;
        do {
            tempMargin -= scrollMargin
            scrollBottom += scrollMargin
        } while(0 < tempMargin);

        idDevicePriorityFlickable.contentHeight = (89 * (id_auto_device_connect_list.count + 1))
                                                  + (MOp.greaterThan(idDevicePriorityHelp.height, idDevicePriorityHelp.paintedHeight)
                                                  ? idDevicePriorityHelp.height : idDevicePriorityHelp.height + scrollBottom);
    }


    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            // 후석에서 언어변경할 경우 높이가 달라져야 하므로 재설정함
            calculateContentHeight();

            if(idDevicePriorityFlickable.contentY > scrollBottom) {
                idDevicePriorityFlickable.contentY = scrollBottom;
            }
        }
    }


    /* WIDGETS */
    Flickable {
        id: idDevicePriorityFlickable
        width: parent.width
        height: 535     //parent.height - 30
        focus: true
        clip: true

        property int preContentY: 0

        contentWidth: parent.width
        //DEPRECATED contentHeight: device_auto_device_no_connect.height + autoconncolumn.height + 380
        contentHeight: (89 * (id_auto_device_connect_list.count + 1))
                            + MOp.greaterThan(idDevicePriorityHelp.height, idDevicePriorityHelp.paintedHeight) < 535
                            ? idDevicePriorityHelp.height : idDevicePriorityHelp.height + scrollMargin

        boundsBehavior: true == id_device_connect_scroll.visible ? Flickable.DragOverBounds : Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick

        Component.onCompleted: {
            idDevicePriorityFlickable.contentY = 0;
        }

        onVisibleChanged: {
            idDevicePriorityFlickable.contentY = 0;
            id_auto_device_connect_list.model = ""
            id_auto_device_connect_list.model = PairedDeviceList
        }

        onMovementStarted: {
            preContentY = idDevicePriorityFlickable.contentY
        }

        onMovementEnded: {
            if(false == idDevicePriorityFlickable.visible) {
                return;
            }

            if(true == id_device_connect_scroll.visible) {
                if(0 > (preContentY - idDevicePriorityFlickable.contentY)){
                        if ((true == device_auto_device_no_connect.focus)) {
                            if (89 > idDevicePriorityFlickable.contentY) {
                                id_auto_device_connect_list.currentIndex = 0
                                id_auto_device_connect_list.forceActiveFocus()
                            } else if ((89 * 2 > idDevicePriorityFlickable.contentY) && (idDevicePriorityFlickable.contentY > 89)) {
                                id_auto_device_connect_list.currentIndex = 1
                                id_auto_device_connect_list.forceActiveFocus()
                            } else if ((89 * 3 > idDevicePriorityFlickable.contentY) && (idDevicePriorityFlickable.contentY > 89 * 2)) {
                                id_auto_device_connect_list.currentIndex = 2
                                id_auto_device_connect_list.forceActiveFocus()
                            } else if ((89 * 4 > idDevicePriorityFlickable.contentY) && (idDevicePriorityFlickable.contentY > 89 * 3)) {
                                id_auto_device_connect_list.currentIndex = 3
                                id_auto_device_connect_list.forceActiveFocus()
                            } else if ((89 * 5 > idDevicePriorityFlickable.contentY) && (idDevicePriorityFlickable.contentY > 89 * 4)) {
                                id_auto_device_connect_list.currentIndex = 4
                                id_auto_device_connect_list.forceActiveFocus()
                            }
                        } else if ((1 > id_auto_device_connect_list.currentIndex) && (89 * 2 > idDevicePriorityFlickable.contentY) && (idDevicePriorityFlickable.contentY > 89)) {
                            id_auto_device_connect_list.currentIndex = 1
                            id_auto_device_connect_list.forceActiveFocus()
                        } else if ((2 > id_auto_device_connect_list.currentIndex) && (89 * 3 > idDevicePriorityFlickable.contentY) && (idDevicePriorityFlickable.contentY > 89 * 2)) {
                            id_auto_device_connect_list.currentIndex = 2
                            id_auto_device_connect_list.forceActiveFocus()
                        } else if ((3 > id_auto_device_connect_list.currentIndex) && (89 * 4 > idDevicePriorityFlickable.contentY) && (idDevicePriorityFlickable.contentY > 89 * 3)) {
                            id_auto_device_connect_list.currentIndex = 3
                            id_auto_device_connect_list.forceActiveFocus()
                        } else if ((4 > id_auto_device_connect_list.currentIndex) && (89 * 5 > idDevicePriorityFlickable.contentY) && (idDevicePriorityFlickable.contentY > 89 * 4)) {
                            id_auto_device_connect_list.currentIndex = 4
                            id_auto_device_connect_list.forceActiveFocus()
                        }
                } else {
                    if(true === idNoSelectedRadioBox.activeFocus){
                        if(id_auto_device_connect_list.count > 2){
                           id_auto_device_connect_list.currentIndex = id_auto_device_connect_list.count - 2
                       }else{
                           id_auto_device_connect_list.currentIndex = 0
                       }
                        id_auto_device_connect_list.forceActiveFocus()
                    } else {
                        //device_auto_device_no_connect.forceActiveFocus()
                    }
                }
            }
        }

        MComp.MButtonHaveTicker {
            id: device_auto_device_no_connect
            y: 0
            width: 547
            height: 89
            focus: true

            bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_p.png"
            bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_l_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 547
            bgImageHeight: 95

            /* Ticker Enable! */
            tickerEnable: true

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: 9
            lineImageY: 89

            DDComp.DDRadioBox {
                id: idNoSelectedRadioBox
                x: 30
                width: 51
                height: parent.height
                checkCondition: (BtCoreCtrl.m_autoConnectMode == 0)
            }

            firstText: stringInfo.str_Nosel_Phone
            firstTextWidth: 443
            firstTextX: 75
            firstTextY: 25      //90 - 45 - 20
            firstTextHeight: 40
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            firstTextElide: "Left"
            firstTextAlies: "Right"

            onClickOrKeySelected: {
                device_auto_device_no_connect.forceActiveFocus();
                /* index 0 is "No select"
                 */
                //UIListener.invokeSettingsAutoConnPriority(0)
                BtCoreCtrl.invokeSetAutoConnectMode(0)
            }

            onWheelRightKeyPressed: {
                if(false == idDevicePriorityFlickable.flicking && false == idDevicePriorityFlickable.moving) {
                    idDevicePriorityFlickable.contentY = 0;
                }
            }

            onWheelLeftKeyPressed: {
                if(false == idDevicePriorityFlickable.flicking && false == idDevicePriorityFlickable.moving) {
                    idDevicePriorityFlickable.contentY = 0;

                    if(true == id_auto_device_connect_list.visible) {
                        id_auto_device_connect_list.forceActiveFocus();
                        id_auto_device_connect_list.currentIndex = 0;
                    }
                }
            }

            onActiveFocusChanged: {
                if(true == device_auto_device_no_connect.activeFocus) {
                    // focus -> botton on the listview
                    idVisualCue.setVisualCue(true, true, false, false);
                }
            }
        }

        ListView {
            //Repeater {
            id: id_auto_device_connect_list
            y: 89
            width: 547
            height: 89 * id_auto_device_connect_list.count
            model: PairedDeviceList
            interactive: false
            anchors.top: device_auto_device_no_connect.bottom

            property bool longPressed: false

            Component.onCompleted: {
                calculateContentHeight();
            }

            onVisibleChanged: {
                if(true == id_auto_device_connect_list.visible) {
                    calculateContentHeight();
                }
            }

            delegate: BTSettingsAutoConnDelegate {
                onWheelRightKeyPressed: {
                    if(false == idDevicePriorityFlickable.flicking && false == idDevicePriorityFlickable.moving) {
                        if(true == MOp.greaterThan(idDevicePriorityHelp.paintedHeight, idDevicePriorityHelp.height)) {
                            // ScrollBar가 표시되고 있다면 ContentY 조정
                            var beforeIndex = id_auto_device_connect_list.currentIndex;
                            if(0 < id_auto_device_connect_list.currentIndex) {
                                id_auto_device_connect_list.currentIndex = id_auto_device_connect_list.currentIndex - 1;
                            } else {
                                //DEPRECATED id_auto_device_connect_list.currentIndex = id_auto_device_connect_list.count;
                                id_auto_device_connect_list.currentIndex = 0;
                                device_auto_device_no_connect.forceActiveFocus();
                            }

                            // 2번 Device에 포커스 잇는 경우 항상 상단 버튼에 포커스 던지는 동작에 의해 VIT에서 잡힌 문제점
                            // 0 인 경우 상단 버튼으로, 1부터 count 까지는 Delegate로 포커스를 이동함
                            /*if(0 < beforeIndex) {
                           if(0 == id_auto_device_connect_list.currentIndex) {
                                device_auto_device_no_connect.forceActiveFocus();
                            }
                        } else {
                            if(0 < id_auto_device_connect_list.currentIndex) {
                                id_auto_device_connect_list.forceActiveFocus();
                            }
                        }*/

                            idDevicePriorityFlickable.contentY = 0;
                        } else {
                            // ScrollBar가 없다면 index만 이동
                            if(0 < id_auto_device_connect_list.currentIndex) {
                                id_auto_device_connect_list.currentIndex = id_auto_device_connect_list.currentIndex - 1;
                            } else {
                                //DEPRECATED id_auto_device_connect_list.currentIndex = id_auto_device_connect_list.count;
                                id_auto_device_connect_list.currentIndex = 0;
                                device_auto_device_no_connect.forceActiveFocus();
                            }
                        }
                    }
                }

                onWheelLeftKeyPressed: {
                    if(false == idDevicePriorityFlickable.flicking && false == idDevicePriorityFlickable.moving) {
                        if(true == MOp.greaterThan(idDevicePriorityHelp.paintedHeight, idDevicePriorityHelp.height)) {
                            // ScrollBar가 표시되고 있다면 ContentY 조정
                            var beforeIndex = id_auto_device_connect_list.currentIndex;
                            if(id_auto_device_connect_list.count > id_auto_device_connect_list.currentIndex + 1) {
                                id_auto_device_connect_list.currentIndex = id_auto_device_connect_list.currentIndex + 1;
                                idDevicePriorityFlickable.contentY = 0;
                            } else {
                                if(idDevicePriorityFlickable.contentY < scrollBottom) {
                                    idDevicePriorityFlickable.contentY = scrollBottom;
                                }

                                //idDevicePriorityFlickable.contentY = scrollMargin * (i - 1);    //(id_auto_device_connect_list.count - 1);
                            }

                            // 0 인 경우 상단 버튼으로, 1부터 count 까지는 Delegate로 포커스를 이동함
                            /*if(0 < beforeIndex) {
                                if(0 == id_auto_device_connect_list.currentIndex) {
                                    id_auto_device_connect_list.forceActiveFocus();
                                }
                            } else {
                                if(0 < id_auto_device_connect_list.currentIndex) {
                                    id_auto_device_connect_list.forceActiveFocus();
                                }
                            }*/
                        } else {
                            // ScrollBar가 없다면 index만 이동
                            if(id_auto_device_connect_list.count > id_auto_device_connect_list.currentIndex) {
                                id_auto_device_connect_list.currentIndex = id_auto_device_connect_list.currentIndex + 1;
                            }
                        }
                    }
                }
            }
        }


     Text {
            id: idDevicePriorityHelp
            text: stringInfo.str_Power_On_Connection
            x: 14
            y: 0
            width: 525
            height: idDevicePriorityFlickable.height - (id_auto_device_connect_list.count + 1) * 89      //89 + (89 * (id_auto_device_connect_list.count))
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            // Text가 넘치면 상단 정렬, 안넘치면 가운데 정렬
            verticalAlignment: (idDevicePriorityHelp.height < idDevicePriorityHelp.paintedHeight) ? Text.AlignTop : Text.AlignVCenter//(idDevicePriorityHelp.height < idDevicePriorityHelp.paintedHeight) ? Text.AlignTop : Text.AlignVCenter
            color: colorInfo.dimmedGrey
            horizontalAlignment: Text.AlignRight
            lineHeight: 0.8
            wrapMode: Text.WordWrap
            clip: false

            anchors.top: id_auto_device_connect_list.bottom
            //anchors.topMargin: 10
        }
	
        Keys.onPressed: {
            /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
             * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
             */
            if(Qt.Key_Down == event.key) {
                if(Qt.ShiftModifier == event.modifiers) {
                    // Long-pressed
                    id_auto_device_connect_list.longPressed = true;
                    idDownScrollTimer.start();
                    event.accepted = true;
                } else {
                    event.accepted = true;
                }
            } else if(Qt.Key_Up == event.key) {
                if(true == device_auto_device_no_connect.activeFocus) {
                    settingBandFocus();
                    event.accepted = true;
                }
                if(Qt.ShiftModifier == event.modifiers) {
                    // Long-pressed
                    id_auto_device_connect_list.longPressed = true;
                    idDevicePriorityFlickable.contentY = 0
                    idUpScrollTimer.start();
                    event.accepted = true;
                } else {
                    event.accepted = true;
                }
            }
        }

        Keys.onReleased: {
            if(Qt.Key_Down == event.key) {
                idDownScrollTimer.stop();
                event.accepted = true;
                id_auto_device_connect_list.longPressed = false
            } else if(Qt.Key_Up == event.key) {
                idUpScrollTimer.stop();
                if(false == id_auto_device_connect_list.longPressed) {
                    settingBandFocus();
                    event.accepted = true;
                } else {
                    id_auto_device_connect_list.longPressed = false
                }
            }
        }
    } // end of Flickable

    MComp.MScroll {
        id: id_device_connect_scroll
        x: -20
        y: 199 - systemInfo.headlineHeight
        height: 476
        width: 14

        visible: MOp.greaterThan(idDevicePriorityHelp.paintedHeight, idDevicePriorityHelp.height)
        scrollArea: idDevicePriorityFlickable

        Component.onCompleted: {
            idDevicePriorityFlickable.contentY = 0;
            // Repeater 적용으로 visibleArea의 ratio가 비정상적으로 설정됨 --> 강제로 ratio 계산/적용
            id_device_connect_scroll.heightRatio = idDevicePriorityFlickable.height / idDevicePriorityFlickable.contentHeight;
        }
    }

    /* TIMERS */
    Timer {
        id: idDownScrollTimer
        interval: 100
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if(true == device_auto_device_no_connect.activeFocus) {
                id_auto_device_connect_list.forceActiveFocus()
                id_auto_device_connect_list.currentIndex = 0
            }  else if(id_auto_device_connect_list.currentIndex == id_auto_device_connect_list.count + 1) {
                stop()
            } else {
                id_auto_device_connect_list.incrementCurrentIndex()
            }
        }
    }

    Timer {
        id: idUpScrollTimer
        interval: 100
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if(true == device_auto_device_no_connect.activeFocus) {
                stop()
            }  else if(id_auto_device_connect_list.currentIndex == 0) {
                device_auto_device_no_connect.forceActiveFocus()
            } else {
                id_auto_device_connect_list.decrementCurrentIndex()
            }
        }
    }
}
/* EOF */
