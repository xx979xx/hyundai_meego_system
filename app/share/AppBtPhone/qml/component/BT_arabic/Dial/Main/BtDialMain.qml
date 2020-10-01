/**
 * BtDialMain.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
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
        id: bgImageLeft
        source: ImagePath.imgFolderGeneral + "bg_menu_l.png"
        y: 1
        visible: false

        Image {
            x: 613
            source: ImagePath.imgFolderGeneral + "bg_menu_l_s.png"
        }
    }

    Image {
        id: bgImageRight
        source: ImagePath.imgFolderGeneral + "bg_menu_r.png"
        y: 1
        visible: true

        Image {
            source: ImagePath.imgFolderGeneral + "bg_menu_r_s.png"
        }
    }

    // 다이얼 번호 입력
    Image {
        x: 711
        y: 16
        width: 524
        height: 84
        source: ImagePath.imgFolderBt_phone + "dial_inputbox_n.png"

        Item {
            id: itemPhoneNum
            width: 500
            height: 80

            Text {
                text: stringInfo.str_Input_Number
                x: 18
                y: 22
                width: 492
                height: 40
                visible: (phoneNumInput == "") ? true : false
                font.pointSize: (itemPhoneNum_hidenText.paintedWidth > 492)? 29 : 36
                color: colorInfo.dimmedGrey
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideRight
            }

            /* 버튼의 범위를 넘어가는 문구의 폰트사이즈 조절하기 위한 hidden text
              */
            Text {
                id: itemPhoneNum_hidenText
                text: stringInfo.str_Input_Number
                font.pointSize: 36
                font.family: stringInfo.fontFamilyRegular
                visible: false
            }

            Text {
                id: idPhoneNum
                text: MOp.checkPhoneNumber(phoneNumInput)
                x: 19
                y: 15   //42 - 27
                width: 492
                height: 54
                font.pointSize: idPhoneNumSize
                color: colorInfo.buttonGrey
                font.family: stringInfo.fontFamilyBold    //"HDB"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideLeft

                onTextChanged: {
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

    // 입력된 번호 없는 화면
    Item {
        id: idBtDialDefault
        x: 711
        y: 0
        width: 502
        height: 60
        // 전화번호 검색 결과 없을 경우 리스트 보이지 않게 수정
        visible: ("" == phoneNumInput || 0 == idBtDialListView.count)

        Image {
            source: ImagePath.imgFolderBt_phone + "ico_dial_bt.png"
            x: 167
            y: 160
        }

        Text {
            id: text_device_name_view
            text: BtCoreCtrl.m_strConnectedDeviceName
            x: -18
            y: 432
            width: (1 == UIListener.invokeGetVehicleVariant())? 525 : 520
            height: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            font.pointSize: 40
            color: colorInfo.subTextGrey
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WrapAnywhere
            lineHeight: BtCoreCtrl.m_strConnectedDeviceName.length >= 20 ? 0.9 : 1

            /*onTextChanged: {
                // 연결 중 다른 Device 연결 시 전화번호 남아있는 문제 수정
                phoneNumInput = ""
            }*/
        }
    }

    // Candidate List
    MComp.DDListView {
        id: idBtDialListView
        x: 710
        y: 100
        width: 620
        height: 440
        visible: !idBtDialDefault.visible // phoneNumInput != "" ? false : true
        model: SearchResultContactList
        updateOnLanguageChanged: false;

        // 스크롤 영역은 "시작시점(0) ~ (스크롤바 끝 지점 -  스크롤바 높이)"
        property double ratio: (idMRoundScroll.bottomPosition / idBtDialListView.count)   //(idContactLeftList.height / idContactLeftList.count);

        onActiveFocusChanged: {
            if(true == idBtDialListView.activeFocus) {
                // focus -> the listview
                idBtDialMain.leftFocus();
                idVisualCue.setVisualCue(true, false, false, true);
                visualCueDownActive = true
            } else {
                visualCueDownActive = false
                idBtDialListView.stopScroll();
                longPressed = false;
            }
        }

        onContentYChanged: {
            idMRoundScroll.heightRatio = height / contentHeight;
        }

        delegate: BtDialListDelegate {
            onWheelRightKeyPressed: {
                if(false == timerActive) {
                    timerActive = true
                    idWheeltimer.start()
                    idBtDialListView.delegateWheelLeft();
                }
            }

            onWheelLeftKeyPressed: {
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
           if("Dial" == mainViewState) {
               idBtDialListView.currentIndex = 0
               dial_list_count = idBtDialListView.count
               overContentCount = 0
               idBtDialListView.positionViewAtIndex(0, ListView.top)

               if(0 == idBtDialListView.count) {
                   if("" == popupState){
                       idBtDialKeypad.forceActiveFocus()
                   }
               }
           }
       }

        KeyNavigation.left: idBtDialKeypad
    }

    MComp.MDialRoundScroll {
        id: idMRoundScroll
        x: 652
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

    BtDialKeypad {
        id: idBtDialKeypad
        x: 39
        y: 19
        focus: true

        KeyNavigation.right: idBtDialListView.visible ? idBtDialListView : idBtDialKeypad

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
