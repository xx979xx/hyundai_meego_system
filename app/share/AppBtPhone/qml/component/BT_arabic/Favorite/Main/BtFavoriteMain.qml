/**
 * BtFavoriteMain.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idBtFavoriteMain
    x: 0
    y: -1
    width: systemInfo.lcdWidth
    height: systemInfo.contentAreaHeight
    focus: true

    /* Property */
    property bool timerActive: false

    /* Connections */
    Connections {
        target: idAppMain

        onPhonebookModelChanged: {
            /* 전화번호부 항목 변경 */
            idBtFavoriteListView.currentIndex = 0
            MOp.returnFocus();
        }

        onMenuOffFocus: {
            /* Menu off 동작 시 focus */
            if(true == idBtFavoriteMain.visible) {
                idBtFavoriteListView.forceActiveFocus();
            }
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        favoriteAdd =  "";
    }

    Component.onDestruction: {
        idDownScrollTimer.stop();
        idUpScrollTimer.stop();
    }

    onVisibleChanged: {
        idBtFavoriteListView.currentIndex = 0
        if(true == idBtFavoriteMain.visible) {
            favoriteAdd =  "";
            idBtFavoriteMain.forceActiveFocus();
        } else {
            idBtFavoriteListView.currentIndex = 0
            idDownScrollTimer.stop();
            idUpScrollTimer.stop();
        }
    }

    onClickMenuKey: {
        idMenu.show();
    }

    onBackKeyPressed: {
        popScreen(8501);
    }


    /* WIDGETS */
    MComp.DDListView {
        id: idBtFavoriteListView
        x: 27
        width: 1253
        height: 540
        focus: true
        model: FavoriteContactList


        delegate: BtFavoriteDelegate {
            onWheelRightKeyPressed: {
                timerActive = true
                idWheeltimer.start()
                idBtFavoriteListView.delegateWheelLeft();
            }

            onWheelLeftKeyPressed: {
                timerActive = true
                idWheeltimer.start()
                idBtFavoriteListView.delegateWheelRight();
            }

            Keys.onPressed: {
                /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
                 * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
                 */
                if(Qt.Key_Down == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        idBtFavoriteListView.longPressed = true;

                        if(idBtFavoriteListView.currentIndex < idBtFavoriteListView.count - 1) {
                            // Propagate to ListView
                            idBtFavoriteListView.longPressed = true;
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
                        idBtFavoriteListView.longPressed = true;

                        if(0 < idBtFavoriteListView.currentIndex) {
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
                    if(true == idBtFavoriteListView.longPressed) {
                        if(idBtFavoriteListView.currentIndex < idBtFavoriteListView.count - 1) {
                            // Propagate to ListView
                        } else {
                            // 더이상 밑으로 내려갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            idBtFavoriteListView.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        // Set focus to "ListView"
                        idBtFavoriteListView.forceActiveFocus();
                        event.accepted = true;
                    }
                } else if(Qt.Key_Up == event.key) {
                    if(true == idBtFavoriteListView.longPressed) {
                        if(0 < idBtFavoriteListView.currentIndex) {
                            // Propagate to ListView
                        } else {
                            // 더이상 위로 올라갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            idBtFavoriteListView.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        // Set focus to "Search Button"
                        idLoaderMainBand.forceActiveFocus();
                        event.accepted = true;
                    }
                }
            }
        }

        onCountChanged: {
            qml_debug("idBtFavoriteListView.currentIndex : " + idBtFavoriteListView.currentIndex)
            //DEPRECATED favorite_list_count = idBtFavoriteListView.count
        }
    }

    /* Scroll */
    MComp.MScroll {
        id: idBtFavoriteListViewScroll
        x: 9
        y: 199 - systemInfo.headlineHeight
        height: 476
        width: 14
        // 6개 이상인 경우 스크롤 나타남
        visible: idBtFavoriteListView.count > 6
        scrollArea: idBtFavoriteListView
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
