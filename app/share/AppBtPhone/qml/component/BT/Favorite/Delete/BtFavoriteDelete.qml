/**
 * BtFavoriteDelete.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idBtFavoriteDelMain
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.contentAreaHeight
    focus: true

    /* PROPERTIES */
    property bool timerActive: false


    /* INTERNAL functions */
    function backKeyHandler() {
        // BAND에서 Back 버튼, EditMode에서 취소 그리고 Back Key(HKEY)를 통해 화면전환 가능
        //favoriteSelectInt = 0;
        favoriteSelectUnAll();
        mainViewState = "Favorite";
        popScreen(303);
    }

    Connections {
        target: idAppMain
        onFavoriteDeleteCancel: {
            idBtFavoriteDelMain.backKeyHandler();
        }

        onPhonebookModelChanged: {
            idBtFavoriteDelListView.currentIndex = 0
            MOp.returnFocus();
        }

        // Menu off 동작 시 focus
        onMenuOffFocus: {
            if(true == idBtFavoriteDelMain.visible) {
                idBtFavoriteDelListView.forceActiveFocus();
            }
        }

        onFavoriteSelectUnAll: {
            idBtFavoriteDelListView.currentIndex = 0
            favoriteSelectInt = 0
            BtCoreCtrl.invokeSetFavoriteSelectAll(false);
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        // 삭제선택 초기화
        favoriteSelectUnAll();
    }

    Component.onDestruction: {
        idBtFavoriteDelListView.stopScroll();
    }

    onVisibleChanged: {
        if(true ==idBtFavoriteDelMain.visible) {
            favoriteSelectUnAll();
            idBtFavoriteDelListView.forceActiveFocus();
        } else {
            idBtFavoriteDelListView.currentIndex = 0
            idBtFavoriteDelListView.stopScroll();
        }
    }

    onClickMenuKey: {
        idMenu.show();
    }

    onBackKeyPressed: {
        backKeyHandler();
    }


    /* WIDGETS */
    MComp.DDSimpleBand {
        id: favoriteDel
        titleText: stringInfo.str_Delete_Band
        menuBtnText: stringInfo.str_Menu
        menuBtnFlag: true
        subTitleText: ("popup_delete_all" == popupState)
                      ? idBtFavoriteDelListView.count : favoriteSelectInt

        onBackBtnClicked: {
            backKeyHandler();
        }

        KeyNavigation.down: favoriteMainView
    }

    MComp.MComponent {
        id: favoriteMainView
        x: 0
        y: 73
        width: 1280
        height: 554
        focus: true

        onActiveFocusChanged: {
            if(false == favoriteMainView.activeFocus) {
                idBtFavoriteDelListView.focus = true
                favoriteEditMenu.focus = false
                idBtFavoriteDelListView.stopScroll();
                idBtFavoriteDelListView.longPressed = false;
            }
        }

        MComp.DDListView {
            id: idBtFavoriteDelListView
            x: 0
            y: 0
            width: 1280
            height: 540
            focus: true
            model: FavoriteContactList

            delegate: BtFavoriteDeleteDelegate {
                onWheelLeftKeyPressed:{
                    if(false == timerActive) {
                        timerActive = true
                        idWheeltimer.start()
                        idBtFavoriteDelListView.delegateWheelLeft();
                    }
                }

                onWheelRightKeyPressed: {
                    if(false == timerActive) {
                        timerActive = true
                        idWheeltimer.start()
                        idBtFavoriteDelListView.delegateWheelRight();
                    }
                }

                Keys.onPressed: {
                    /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
                     * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
                     */
                    if(Qt.Key_Down == event.key) {
                        if(Qt.ShiftModifier == event.modifiers) {
                            // Long-pressed
                            idBtFavoriteDelListView.longPressed = true;

                            if(idBtFavoriteDelListView.currentIndex < idBtFavoriteDelListView.count - 1) {
                                // Propagate to ListView
                                idBtFavoriteDelListView.longPressed = true;
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
                            idBtFavoriteDelListView.longPressed = true;

                            if(0 < idBtFavoriteDelListView.currentIndex) {
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
                        if(true == idBtFavoriteDelListView.longPressed) {
                            if(idBtFavoriteDelListView.currentIndex < idBtFavoriteDelListView.count - 1) {
                                // Propagate to ListView
                            } else {
                                // 더이상 밑으로 내려갈 수 없을때 Release도 전달되지 않도록 막아야 함
                                idBtFavoriteDelListView.longPressed = false;
                                event.accepted = true;
                            }
                        } else {
                            // Set focus to "ListView"
                            idBtFavoriteDelListView.forceActiveFocus();
                            event.accepted = true;
                        }
                    } else if(Qt.Key_Up == event.key) {
                        if(true == idBtFavoriteDelListView.longPressed) {
                            if(0 < idBtFavoriteDelListView.currentIndex) {
                                // Propagate to ListView
                            } else {
                                // 더이상 위로 올라갈 수 없을때 Release도 전달되지 않도록 막아야 함
                                idBtFavoriteDelListView.longPressed = false;
                                event.accepted = true;
                            }
                        } else {
                            // Set focus to "Search Button"
                            favoriteDel.forceActiveFocus();
                            event.accepted = true;
                        }
                    }
                    idBtFavoriteDelListView.stopScroll();
                }
                KeyNavigation.right: favoriteEditMenu
            }
        }

        // Scroll
        MComp.MScroll {
            id: favoriteMainViewScroll
            scrollArea: idBtFavoriteDelListView
            x: 1006
            y: 181 - systemInfo.headlineHeight
            height: 523
            width: 14
            visible: (idBtFavoriteDelListView.count > 6) ? true : false
        }

        MComp.MEditMode {
            id: favoriteEditMenu
            buttonText1: stringInfo.str_Delete_Btn
            buttonText2: stringInfo.str_Bt_Delete_All
            buttonText3: stringInfo.str_Deselect
            buttonText4: stringInfo.str_Bt_Delete_Cancel

            buttonEnabled1: (favoriteSelectInt != 0) ? true : false
            buttonEnabled3: (favoriteSelectInt != 0) ? true : false

            // EditMode에서 Band로 포커스를 이동시키기 위해 설정함
            editModeBand: favoriteDel

            onClickButton1: {
                // UX변경: 선택삭제 팝업 제거
                popScreen(1010);
                if(BtCoreCtrl.m_nCountFavoriteContactsList == favoriteSelectInt) {
                    BtCoreCtrl.invokeTrackerRemoveAllFavorite();
                } else {
                    BtCoreCtrl.invokeTrackerRemoveFavorite();
                }

                delete_type = "favorite"

                /*DEPRECATED
                delete_type = "favorite"
                MOp.showPopup("popup_delete_select");
DEPRECATED*/
            }

            onClickButton2: {
                // 전체삭제
                delete_type = "favorite"
                MOp.showPopup("popup_delete_all");
            }

            onClickButton3: {
                favoriteSelectUnAll();
                idBtFavoriteDelListView.forceActiveFocus();
            }

            onClickButton4: {
                // 취소
                backKeyHandler();
            }
        }

        KeyNavigation.left: idBtFavoriteDelListView
        KeyNavigation.up: favoriteDel
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
