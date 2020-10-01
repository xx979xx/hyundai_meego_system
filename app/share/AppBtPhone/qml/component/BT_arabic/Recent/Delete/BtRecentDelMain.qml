/**
 * BtRecentDelListDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idBtRecentDelMain
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.contentAreaHeight
    focus: true


    /* INTERNAL functions */
    function backKeyHandler() {
        /*  [주의] Backkey pressed, Back button pressed(자체 Band), 그리고 Cancel button을 모두 처리해야 함 */
        popScreen(304);

        /* 삭제화면에서 되돌아 가는 경우 포커스 위치가 초기 위치가 다름*/
        deleteBackKeyPress();
    }

    /* Connections*/
    Connections {
        target: idAppMain
        onMenuOffFocus: {
            /* Menu off 동작 시 focus */
            if(true == idBtRecentDelMain.visible) {
                idBtRecentCallListView.forceActiveFocus();
            }
        }

        onRecentDeleteCancel: {
            /* 메뉴 내부에서 삭제 취소 버튼 선택 동작 */
            idBtRecentDelMain.backKeyHandler();
        }
    }

    /* EVENT handlers */
    onVisibleChanged: {
        if(true == idBtRecentDelMain.visible) {
            qml_debug("[Qml] recent Call Delete main view visible change")

            // Set model
            switch(select_recent_call_type) {
                case 1:
                    idBtRecentCallListView.model = OutgoingCallHistoryList;
                    idBtRecentCallListView.currentIndex = 0;
                    break;

                case 3:
                    idBtRecentCallListView.model = MissedCallHistoryList;
                    idBtRecentCallListView.currentIndex = 0;
                    break;

                case 2:
                default:
                    idBtRecentCallListView.model = IncomingCallHistoryList;
                    idBtRecentCallListView.currentIndex = 0;
                    break;
            }

            // 선택된 아이템 초기화
            recentSelectInt = 0;

            idBtRecentCallListView.forceActiveFocus();
            BtCoreCtrl.invokeSetCallHistorySelectAll(select_recent_call_type, false);

            MOp.returnFocus()
        } else {
            idBtRecentCallListView.currentIndex = 0;
            idDownScrollTimer.stop();
            idUpScrollTimer.stop();
        }
    }

    onClickMenuKey: {
        idMenu.show();
    }

    onBackKeyPressed: {
        idBtRecentDelMain.backKeyHandler();
    }


    /* WIDGETS */
    MComp.DDSimpleBand {
        id: recentDeleteBand
        titleText: stringInfo.str_Delete_Band
        menuBtnText: stringInfo.str_Menu
        menuBtnFlag: true
        subTitleText:"popup_delete_all" == popupState
                     ? idBtRecentCallListView.count
                     : recentSelectInt

        onBackBtnClicked: {
            idBtRecentDelMain.backKeyHandler();
        }

        KeyNavigation.down: deleteMain
    }

    MComp.MComponent {
        id: deleteMain
        x: 0
        y: 73
        width: 1280
        height: 554
        focus: true

        onActiveFocusChanged: {
            if(false == deleteMain.activeFocus) {
                idBtRecentCallListView.focus = true
                editMenu.focus = false
            }
        }

        ListView {
            id: idBtRecentCallListView
            x: 274
            y: 0
            width: 1280
            height: 540
            clip: true
            focus: true
            model: IncomingCallHistoryList
            snapMode: idBtRecentCallListView.moving ? ListView.SnapToItem : ListView.NoSnap // modified by Dmitry 27.07.13
            highlightMoveDuration: 1
            highlightFollowsCurrentItem: true

            // 바운스 효과 추가
            //DEPRECATED boundsBehavior: Flickable.StopAtBounds

            property bool longPressed: false
            property real prevContentY: -1

            function getStartIndex(posY) {
                var startIndex = -1;
                for(var i = 1; i < 10; i++) {
                    //startIndex = indexAt(10, posY + 50 * i);
                    startIndex = indexAt(100, posY + 50 * i);
                    if(-1 < startIndex) {
                        break;
                    }
                }

                return startIndex;
            }

            function getEndIndex(posY) {
                 var endIndex = -1;
                 for(var i = 0; i < 5; i++) {
                     endIndex = indexAt(100, posY + (height - 10) - 50 * i);

                     if(-1 < endIndex) {
                         return endIndex
                     }
                 }

                 return -1;
             }

            function startDownScroll() {
                idDownScrollTimer.start();
            }

            function startUpScroll() {
                idUpScrollTimer.start();
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


            delegate: BtRecentDelListDelegate {
                onWheelRightKeyPressed: {
                    if(false == idBtRecentCallListView.flicking && false == idBtRecentCallListView.moving) {
                        var startIndex = idBtRecentCallListView.getStartIndex(idBtRecentCallListView.contentY);

                        if(index > 0) {
                            if(startIndex == idBtRecentCallListView.currentIndex) {
                                idBtRecentCallListView.positionViewAtIndex(idBtRecentCallListView.currentIndex - 1, ListView.End);
                            }

                            idBtRecentCallListView.decrementCurrentIndex();
                        } else {
                            // 리스트가 하나의 화면에 표시 되면 루핑 되지 않도록 수정(HMC)
                            if(6 < idBtRecentCallListView.count) {
                                idBtRecentCallListView.currentIndex = idBtRecentCallListView.count - 1;
                            } else {
                                console.log("## Stop looping idBtRecentCallListView.count = " + idBtRecentCallListView.count)
                            }
                        }
                    }
                }

                onWheelLeftKeyPressed: {
                    if(false == idBtRecentCallListView.flicking && false == idBtRecentCallListView.moving) {
                        var endIndex = idBtRecentCallListView.getEndIndex(idBtRecentCallListView.contentY);

                        if(index < idBtRecentCallListView.count - 1) {
                            if(endIndex == idBtRecentCallListView.currentIndex) {
                                idBtRecentCallListView.positionViewAtIndex(idBtRecentCallListView.currentIndex + 1, ListView.Beginning);
                            }

                            idBtRecentCallListView.incrementCurrentIndex();
                        } else {
                            // 리스트가 하나의 화면에 표시 되면 루핑 되지 않도록 수정(HMC)
                            if(6 < idBtRecentCallListView.count) {
                                idBtRecentCallListView.currentIndex = 0;
                            } else {
                                console.log("## Stop looping idBtRecentCallListView.count = " + idBtRecentCallListView.count)
                            }
                        }
                    }
                }

                Keys.onPressed: {
                    /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
                     * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
                     */
                    if(Qt.Key_Down == event.key) {
                        if(Qt.ShiftModifier == event.modifiers) {
                            // Long-pressed
                            idBtRecentCallListView.longPressed = true;

                            if(idBtRecentCallListView.currentIndex < idBtRecentCallListView.count - 1) {
                                // Propagate to ListView
                                idBtRecentCallListView.longPressed = true;
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
                            idBtRecentCallListView.longPressed = true;

                            if(0 < idBtRecentCallListView.currentIndex) {
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
                        if(true == idBtRecentCallListView.longPressed) {
                            if(idBtRecentCallListView.currentIndex < idBtRecentCallListView.count - 1) {
                                // Propagate to ListView
                            } else {
                                // 더이상 밑으로 내려갈 수 없을때 Release도 전달되지 않도록 막아야 함
                                idBtRecentCallListView.longPressed = false;
                                event.accepted = true;
                            }
                        } else {
                            // Set focus to "ListView"
                            idBtRecentCallListView.forceActiveFocus();
                            event.accepted = true;
                        }
                    } else if(Qt.Key_Up == event.key) {
                        if(true == idBtRecentCallListView.longPressed) {
                            if(0 < idBtRecentCallListView.currentIndex) {
                                // Propagate to ListView
                            } else {
                                // 더이상 위로 올라갈 수 없을때 Release도 전달되지 않도록 막아야 함
                                idBtRecentCallListView.longPressed = false;
                                event.accepted = true;
                            }
                        } else {
                            // Set focus to "Search Button"
                            recentDeleteBand.forceActiveFocus();
                            event.accepted = true;
                        }
                    }
                }

                KeyNavigation.left: editMenu
            }

            onMovementStarted: {
                prevContentY = contentY;
            }

            onMovementEnded: {
                if(false == idBtRecentCallListView.visible) {
                    return;
                }

                // Flicking 후 화면 상단에 포커스를 설정함
                var endIndex = getEndIndex(contentY);
                var flickingIndex = getStartIndex(contentY);

                if(endIndex > currentIndex && flickingIndex < currentIndex){
                    // onMovementEnded 시점에 포커스 이동하도록 수정 팝업이 있는 경우 포커스 전달 안하도록
                    if(popupState == "" && menuOn == false) {
                        idBtRecentCallListView.forceActiveFocus();
                    }
                } else if(prevContentY != contentY) {
                    if(endIndex < count - 1) {
                        if(-1 < flickingIndex) {
                            positionViewAtIndex(flickingIndex, ListView.SnapPosition);  //ListView.Beginning);
                            currentIndex = flickingIndex;
                        }
                    } else {
                        /* 리스트 최하단일 경우 Section에 의해 상단으로 끌어올려지는 경우가 발생하기 때문에
                         * 포커스 설정후(currentIndex 설정 후) 화면을 제일 아래로 끌어내림
                         */
                        currentIndex = flickingIndex;
                        positionViewAtEnd();
                    }

                    // onMovementEnded 시점에 포커스 이동하도록 수정 팝업이 있는 경우 포커스 전달 안하도록
                    if(popupState == "" && menuOn == false) {
                        idBtRecentCallListView.forceActiveFocus();
                    }
                }
            }

            Keys.onPressed: {
                if(Qt.Key_Down == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        idBtRecentCallListView.startDownScroll();
                        positionViewAtIndex(currentIndex, ListView.End);
                    } else {
                        event.accepted = true;
                    }
                } else if(Qt.Key_Up == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        idBtRecentCallListView.startUpScroll();
                        positionViewAtIndex(currentIndex, ListView.Beginning);
                    } else {
                        event.accepted = true;
                    }
                }
            }

            Keys.onReleased: {
                if(Qt.Key_Down == event.key) {
                    if(true == idBtRecentCallListView.longPressed) {
                        idBtRecentCallListView.longPressed = false;
                        idBtRecentCallListView.stopScroll();
                    }
                } else if(Qt.Key_Up == event.key) {
                    if(true == idBtRecentCallListView.longPressed) {
                        idBtRecentCallListView.longPressed = false;
                        idBtRecentCallListView.stopScroll();
                    }
                }
            }
        }

        MComp.MScroll {
            id: idBtRecentCallListViewScroll
            bgImage: ImagePath.imgFolderGeneral + "scroll_edit_bg.png"
            x: 260
            y: 181 - systemInfo.headlineHeight
            height: 523
            width: 14
            scrollArea: idBtRecentCallListView

            // 6개 이상인 경우 스크롤바 나옴
            visible: idBtRecentCallListView.count > 6
        }

        MComp.MEditMode {
            id: editMenu

            buttonText1: stringInfo.str_Delete_Btn
            buttonText2: stringInfo.str_Bt_Delete_All
            buttonText3: stringInfo.str_Deselect
            buttonText4: stringInfo.str_Bt_Delete_Cancel

            buttonEnabled1: recentSelectInt != 0
            buttonEnabled3: recentSelectInt != 0

            // EditMode에서 Band로 포커스를 이동시키기 위해 설정함
            editModeBand: recentDeleteBand

            onClickButton1: {
                if(recent_list_count == recentSelectInt) {
                    BtCoreCtrl.invokeTrackerRemoveAllCallHistory(select_recent_call_type);
                } else {
                    BtCoreCtrl.invokeTrackerRemoveCallHistory(select_recent_call_type);
                }

                // UX 변경: 선택삭제 팝업 제거
                // 삭제 이후 화면 전환 하도록 수정
                popScreen(1011);
/*DEPRECATED
                delete_type = "recent"
                MOp.showPopup("popup_delete_select");
DEPRECATED*/
            }

            onClickButton2: {
                // 전체삭제
                delete_type = "recent"
                MOp.showPopup("popup_delete_all");
            }

            onClickButton3: {
                // Unmark All
                recentSelectInt = 0;
                //recentSelectUnAll();
                BtCoreCtrl.invokeSetCallHistorySelectAll(select_recent_call_type, false);
            }

            onClickButton4: {
                // 취소
                idBtRecentDelMain.backKeyHandler();
            }

            KeyNavigation.up:  recentDeleteBand
            KeyNavigation.right: idBtRecentCallListView
        }
    }

    Timer {
        id: idDownScrollTimer
        interval: 100
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var endIndex = idBtRecentCallListView.getEndIndex(idBtRecentCallListView.contentY);

            if(idBtRecentCallListView.currentIndex + 1 < idBtRecentCallListView.count) {
                if(endIndex == idBtRecentCallListView.currentIndex) {
                    idBtRecentCallListView.positionViewAtIndex(idBtRecentCallListView.currentIndex + 1, ListView.Beginning);
                }

                idBtRecentCallListView.currentIndex += 1;
            } else {
                idBtRecentCallListView.currentIndex = idBtRecentCallListView.count - 1;
                stop();
            }
        }
    }

    Timer {
        id: idUpScrollTimer
        interval: 100
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var startIndex = idBtRecentCallListView.getStartIndex(idBtRecentCallListView.contentY);

            if(0 < idBtRecentCallListView.currentIndex - 1) {
                if(startIndex == idBtRecentCallListView.currentIndex) {
                    idBtRecentCallListView.positionViewAtIndex(idBtRecentCallListView.currentIndex - 1, ListView.End);
                }

                idBtRecentCallListView.currentIndex -= 1;
            } else {
                idBtRecentCallListView.currentIndex = 0;
                stop();
            }
        }
    }
}
/* EOF */
