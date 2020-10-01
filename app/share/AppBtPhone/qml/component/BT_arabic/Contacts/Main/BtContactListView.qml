/**
 * /BT_arabic/Contacts/Main/BtContactListView.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


FocusScope {
    id: idBtContactList

    // PROPERTIES
    property int position : 0
    property int overContentCount

    property bool timerActive: false


    /* CONNECTIONS */
    Connections {
        target: BtCoreCtrl

        onSigSetSelectedAlphaOnTop: {
            if(0 > i || idContactLeftList.count - 1 < i) {
                return;
            }

            // onContentYChanged()에 의해 Scroll Bar 위치가 변경될 수 있도록 미리 설정
            //idContactLeftList.quickScrollIndex = i;


            idContactLeftList.positionViewAtIndex(i, ListView.Beginning);
            idContactLeftList.currentIndex = i;

            //idContactLeftList.forceActiveFocus();
        }

        onPhonebookDownloadCompleted: {
            // 전화 번호부 다운로드 완료 Signal
            if(true == btPhoneEnter) {
                if(1 > callType
                    || ("FOREGROUND" != callViewState && (popupState != "Call_popup" && popupState != "Call_3way_popup" && popupState != "popup_bluelink_popup"))) {
                    idContactLeftList.currentIndex = 0
                    idContactLeftList.positionViewAtIndex(idContactLeftList.currentIndex, ListView.Beginning);
                }
            }
        }
    }

    Connections {
        target: idAppMain

        onPhonebookModelChanged: {
            /* 전화번호부 항목 변경 */
            idContactLeftList.model = ""
            idContactLeftList.model = PhonebookContactList
            idContactLeftList.currentIndex = 0

            if(idAppMain.state == "BtContactMain") {
                idContactLeftList.forceActiveFocus();
                idContactLeftList.positionViewAtIndex(0, ListView.Beginning);

                /* 통화 화면에서 언어 변경 시 포커스 사라지는 현상 수정 */
                MOp.returnFocus();
            }
        }

        onPhonebookSearch: {
            /* 폰북의 특정위치로 이동을 위해 사용(최근통화에서 폰북으로 이동) */
            idContactLeftList.currentIndex = index;
            idContactLeftList.positionViewAtIndex(index, ListView.Beginning);
            position = index;

            if(idContactLeftList.currentIndex == idContactLeftList.count - 1) {
                idContactLeftList.positionViewAtIndex(index, ListView.End);
            }
        }

        onPressContacts: {
            /* 통화 화면에서 전화번호부 버튼 선택 시 발생 */
            idContactLeftList.currentIndex = 0
            idContactLeftList.forceActiveFocus();
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        contact_list_count = idContactLeftList.count;
    }

    Component.onDestruction: { }


    /* WIDGETS */
    MComp.DDListView {
        id: idContactLeftList
        x: 0
        width: 547
        height: 415
        focus: true
        model: PhonebookContactList

        pageRows: 5

        property int tempIndex: 0
        property int quickScrollIndex: -1

        onActiveFocusChanged: {
            if(true == idContactLeftList.activeFocus) {
                // focus -> the listview
                idVisualCue.setVisualCue(true, false, false, true);
                //DEPRECATED idContactLeftList.positionViewAtIndex(idContactLeftList.currentIndex, ListView.Beginning);
            } else {
                idContactLeftList.stopScroll();
                longPressed = false;
            }
        }

        delegate: BtContactListDelegate {
            onWheelRightKeyPressed: {
                if(false == timerActive) {
                    timerActive = true
                    idWheeltimer.start()
                    idContactLeftList.delegateWheelLeft();
                }
            }

            onWheelLeftKeyPressed: {
                if(false == timerActive) {
                    timerActive = true
                    idWheeltimer.start()
                    idContactLeftList.delegateWheelRight();
                }
            }

            onClickOrKeySelected: {
                idContactLeftList.currentIndex = index;
            }

            /* KeyNavigation은 Pressed/Released를 구분할 수 없어 직접 Keys.onPressed/onReleased로 처리함
             */
            //DEPRECATED KeyNavigation.up: imgBtContactInfoLeftSearch
            //DEPRECATED KeyNavigation.down: idContactLeftList

            Keys.onPressed: {
                /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
                 * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
                 */
                if(Qt.Key_Down == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        idContactLeftList.longPressed = true;

                        if(idContactLeftList.currentIndex < idContactLeftList.count - 1) {
                            // Propagate to ListView
                            idContactLeftList.longPressed = true;
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
                        idContactLeftList.longPressed = true;

                        if(0 < idContactLeftList.currentIndex) {
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
                    if(true == idContactLeftList.longPressed) {
                        if(idContactLeftList.currentIndex < idContactLeftList.count - 1) {
                            // Propagate to ListView
                        } else {
                            // 더이상 밑으로 내려갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            idContactLeftList.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        // Set focus to "ListView"
                        idContactLeftList.forceActiveFocus();
                        event.accepted = true;
                    }
                } else if(Qt.Key_Up == event.key) {
                    if(true == idContactLeftList.longPressed) {
                        if(0 < idContactLeftList.currentIndex) {
                            // Propagate to ListView
                        } else {
                            // 더이상 위로 올라갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            idContactLeftList.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        // Set focus to "Search Button"
                        imgBtContactInfoLeftSearch.forceActiveFocus();
                        event.accepted = true;
                    }
                }
                idContactLeftList.stopScroll();
            }
        }

        onCountChanged: {
            idContactLeftList.currentIndex = 0;
            contact_list_count = idContactLeftList.count;

            //idContactLeftListRoundScroll.moveBarPosition = 0;

            // 폰북 리로딩에 의해 개수가 변경될때(XX개 --> 0개 --> XX개) 포커스를 재설정함
            if(true == idBtContactList.activeFocus) {
                idContactLeftList.positionViewAtIndex(index, ListView.Beginning);
            }
            MOp.returnFocus()
        }

        section.property: "chosung"
        section.criteria: "FirstCharacter"
        section.delegate: Item {
            height: 62
            width: 480
            x:35

            Image {
                source: ImagePath.imgFolderBt_phone + "contacts_list_index.png"
                x: 13
                y: 24
                width: 480
                height: 38

                Text {
                    text: section
                    y: -10
                    x: 428
                    width: 45
                    height: 38
                    font.pointSize: 28
                    color: (1 == UIListener.invokeGetVehicleVariant()) ? colorInfo.dimmedGrey : colorInfo.bandBlue
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                }
            }
        }
    }

    // Round scroll
    MComp.MContactRoundScroll {
        id: idContactLeftListRoundScroll
        x: -58
        y: 205 - systemInfo.upperAreaHeight - 104
        width: 46
        height: 491
        //visible: phoneNumInput == "" ? false : true
        visible: (false == idContactLeftList.visible) ? false : (idContactLeftList.height > idContactLeftList.contentHeight) ? false : true
        scrollArea: idContactLeftList
        //listCountOfScreen: 5
        //moveBarPosition: idBtDialListView.height / idBtDialListView.count * overContentCount
        //listCount: idContactLeftList.count
    }

    Timer {
        id: idWheeltimer
        interval: 30
        repeat: false
        running: false

        onTriggered: {
            timerActive = false;
        }
    }
}
/* EOF */
