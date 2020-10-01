/**
 * BtDialMain.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idBtDialMain
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    /* PROPERTIES */
    property int overContentCount
    property int idPhoneNumSize: 54
    property bool timerActive: false

    /* SIGNALS */
    signal sigSetDialFocus();

    /* INTERNAL functions */
    function leftFocus() {
        bgImageLeft.visible = true
        bgImageRight.visible = false
    }

    function rightFocus() {
        bgImageLeft.visible = false
        bgImageRight.visible = true
    }

    /* Connections*/
    Connections {
        target: idAppMain

        onMenuOffFocus: {
            /* Menu off 동작 시 focus */
            if(true == idBtDialMain.visible) {
                idBtDialKeypad.forceActiveFocus();
            }
        }
    }

    /* EVENT handlers */
    onVisibleChanged: {
        if(true == idBtDialMain.visible) {
            dial_list_count = idBtDialListView.count;
            // 다이얼 화면이 보여질 때, 포커스 "1"버튼으로 초기화 하는 코드
            callEndEvent();
            idBtDialKeypad.forceActiveFocus();
        } else {
            idDownScrollTimer.stop();
            idUpScrollTimer.stop();
        }
    }

    onClickMenuKey: {
        idMenu.show();
    }

    onBackKeyPressed: {
        popScreen(9763);
    }


    /* WIDGETS */
    MouseArea {
        anchors.fill: parent
        beepEnabled: false
    }

    Image {
        id: bgImageRight
        y: 1
        source: ImagePath.imgFolderGeneral + "bg_menu_r.png"
        visible: true

        Image {
            x: 589
            source: ImagePath.imgFolderGeneral + "bg_menu_r_s.png"
        }
    }

    Image {
        id: bgImageLeft
        y: 1
        source: ImagePath.imgFolderGeneral + "bg_menu_l.png"
        visible: false

        Image {
            source: ImagePath.imgFolderGeneral + "bg_menu_l_s.png"
        }
    }

    /* 입력창 Image */
    Image {
        x: 45
        y: 17
        width: 524
        height: 84
        source: ImagePath.imgFolderBt_phone + "dial_inputbox_n.png"

        Item {
            id: itemPhoneNum
            width: 500
            height: 80

            /* 입력된 문자가 없을 때 표시되는 Text (번호 입력) */
            Text {
                text: stringInfo.str_Input_Number
                x: 19
                y: 22
                width: 492
                height: 40
                visible: (phoneNumInput == "") ? true : false
                font.pointSize: (itemPhoneNum_hidenText.paintedWidth > 492)? 29 : 36
                color: colorInfo.dimmedGrey
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                elide: gLanguage == 1 ? Text.ElideNone : Text.ElideRight
            }

            /* 다국어 문구에서 특정 문구가 입력창을 벗어나는 경우를 확인 하기 위한 Hidden Text */
            Text {
                id: itemPhoneNum_hidenText
                text: stringInfo.str_Input_Number
                font.pointSize: 36
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                visible: false
            }

            /* Dial 키패드로 입력된 숫자 출력 부분 */
            Text {
                id: idPhoneNum
                text: MOp.checkPhoneNumber(phoneNumInput)
                x: 19
                y: 15
                width: 492
                height: 54
                font.pointSize: idPhoneNumSize
                color: colorInfo.buttonGrey
                font.family: stringInfo.fontFamilyBold    //"HDB"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideLeft

                onTextChanged: {
                    /* 일정 숫자 이상 입력 시 Text Size변경이 필요한 부분 */
                    if(phoneNumInput.length < 13) {
                        if(0 == phoneNumInput.length) {
                            idBtDialListView.focus = false;
                            idBtDialKeypad.focus = true;
                        } else {
                            idPhoneNumSize = 54;
                        }
                    } else if(phoneNumInput.length == 13) {
                        idPhoneNumSize = 51
                    } else if(phoneNumInput.length == 14) {
                        idPhoneNumSize = 48
                    } else if(phoneNumInput.length == 15) {
                        idPhoneNumSize = 45
                    } else if(phoneNumInput.length == 16) {
                        idPhoneNumSize = 42
                    } else {
                        idPhoneNumSize = 40
                    }

                    if("" == phoneNumInput) {
                        BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput);
                    }
                }
            }
        }
    }

    /* 입력된 번호 없는 화면 */
    Item {
        id: idBtDialDefault
        x: 66
        width: 502
        height: 60
        // 전화번호 검색 결과 없을 경우 리스트 보이지 않게 수정
        visible: ("" == phoneNumInput || 0 == idBtDialListView.count)

        /* 블루투스 Image */
        Image {
            source: ImagePath.imgFolderBt_phone + "ico_dial_bt.png"
            x: 166
            y: 161
        }

        /* 연결된 기기명 표시 부분*/
        Text {
            id: text_device_name_view
            text: BtCoreCtrl.m_strConnectedDeviceName
            x: -18
            y: 423
            width: (1 == UIListener.invokeGetVehicleVariant())? 525 : 520
            height: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            font.pointSize: 40
            color: colorInfo.subTextGrey
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WrapAnywhere
            lineHeight: BtCoreCtrl.m_strConnectedDeviceName.length >= 20 ? 0.9 : 1
        }
    }

    /* 검색 결과 표시 List */
    MComp.DDListView {
        id: idBtDialListView
        x: 44
        y: 100
        width: 620
        height: 440
        visible: !idBtDialDefault.visible
        model: SearchResultContactList
        updateOnLanguageChanged: false;

        // 스크롤 영역은 "시작시점(0) ~ (스크롤바 끝 지점 -  스크롤바 높이)"
        property double ratio: (idMRoundScroll.bottomPosition / idBtDialListView.count)   //(idContactLeftList.height / idContactLeftList.count);

        onActiveFocusChanged: {
            if(true == idBtDialListView.activeFocus) {
                // focus -> the listview
                idBtDialMain.leftFocus();
                idVisualCue.setVisualCue(true, true, false, false);
                visualCueDownActive = true
            } else {
                visualCueDownActive = false
                idBtDialListView.stopScroll();
                longPressed = false;
            }
        }

        onContentYChanged: {
            /* Flicking  될때 변경되는 Y값 */
            idMRoundScroll.heightRatio = height / contentHeight;
        }

        delegate: BtDialListDelegate {
            onWheelLeftKeyPressed: {
                if(false == timerActive) {
                    timerActive = true
                    idWheeltimer.start()
                    idBtDialListView.delegateWheelLeft();
                }
            }

            onWheelRightKeyPressed: {
                if(false == timerActive) {
                    timerActive = true
                    idWheeltimer.start()
                    idBtDialListView.delegateWheelRight();
                }
            }

            onClickOrKeySelected: {
                idBtDialListView.currentIndex = 0
            }

            /* KeyNavigation은 Pressed/Released를 구분할 수 없어 직접 Keys.onPressed/onReleased로 처리함
             */
            //DEPRECATED KeyNavigation.up: mainBand
            //DEPRECATED KeyNavigation.down: idBtDialListView

            Keys.onPressed: {
                /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
                 * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
                 */
                if(Qt.Key_Down == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        idBtDialListView.longPressed = true;

                        if(idBtDialListView.currentIndex < idBtDialListView.count - 1) {
                            // Propagate to ListView
                            idBtDialListView.longPressed = true;
                        } else {
                            // 더이상 밑으로 내려갈 수 없을때
                            event.accepted = true;
                        }
                    } else {
                        // Short pressed
                        event.accepted = true;
                    }
                } else if(Qt.Key_Up == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        idBtDialListView.longPressed = true;

                        if(0 < idBtDialListView.currentIndex) {
                            // Propagate to ListView
                        } else {
                            // 더이상 위로 올라갈 수 없을때
                            event.accepted = true;
                        }
                    } else {
                        // Short pressed
                        event.accepted = true;
                    }
                }
            }

            Keys.onReleased: {
                if(Qt.Key_Down == event.key) {
                    if(true == idBtDialListView.longPressed) {
                        if(idBtDialListView.currentIndex < idBtDialListView.count - 1) {
                            // Propagate to ListView
                        } else {
                            // 더이상 밑으로 내려갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            idBtDialListView.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        // Set focus to "ListView"
                        idBtDialListView.forceActiveFocus();
                        event.accepted = true;
                    }
                } else if(Qt.Key_Up == event.key) {
                    if(true == idBtDialListView.longPressed) {
                        if(0 < idBtDialListView.currentIndex) {
                            // Propagate to ListView
                        } else {
                            // 더이상 위로 올라갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            idBtDialListView.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        // Set focus to "Search Button"
                        idLoaderMainBand.forceActiveFocus();
                        event.accepted = true;
                    }
                }
                idBtDialListView.stopScroll();
            }
        }

        onCountChanged: {
            idMRoundScroll.heightRatio = height / contentHeight;
            if("BtDialMain" == idAppMain.state) {
                idBtDialListView.currentIndex = 0
                dial_list_count = idBtDialListView.count
                overContentCount = 0
                idBtDialListView.positionViewAtIndex(0, ListView.top)

                // 리스트 검색 개수가 0일 경우 keypad로 포커스 이동
                if(0 == idBtDialListView.count) {
                    if("" == popupState){
                        idBtDialKeypad.forceActiveFocus()
                    }
                }
            }
        }

        KeyNavigation.right: idBtDialKeypad
    }

    /* 우측 Round Scroll */
    MComp.MDialRoundScroll {
        id: idMRoundScroll
        x: 582
        y: 205 - systemInfo.upperAreaHeight
        width: 46
        height: 491

        // Input이 없거나 검색결과가 3개 이하인 경우 스크롤바를 표시하지 않음
        visible: {
            if(false == idBtDialListView.visible) {
                false;
            } else {
                if(5 > idBtDialListView.count) {
                    false;
                } else {
                    true;
                }
            }
        }

        scrollArea: idBtDialListView
    }

    /* Dial Keypad 부분 */
    BtDialKeypad {
        id: idBtDialKeypad
        x: 718
        y: 19
        focus: true

        KeyNavigation.left: idBtDialListView.visible ? idBtDialListView : idBtDialKeypad

        onActiveFocusChanged: {
            if(true == idBtDialKeypad.activeFocus) {
                idBtDialMain.rightFocus();
            }
        }
    }

    /* TIMERS */
    Timer {
        id: idWheeltimer
        interval: 100
        repeat: true
        running: false

        onTriggered: {
            timerActive = false;
        }
    }
}
/* EOF */
