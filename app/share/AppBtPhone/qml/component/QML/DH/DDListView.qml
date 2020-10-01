/**
 * /QML/DH/DDListView.qml
 *
 */
import QtQuick 1.1


ListView
{
    id: idListViewContainer
    clip: true
    width: parent.width
    height: parent.height
    snapMode: idListViewContainer.moving ? ListView.SnapToItem : ListView.NoSnap // modified by Dmitry 27.07.13
    smooth: true
    highlightMoveDuration: 1
    highlightFollowsCurrentItem: true
    maximumFlickVelocity: 1000

    // PROPERTIES
    property bool longPressed: false
    property real prevContentY: -1
    property int pageRows: 5


    // Flicking 동작에 Keypad를 숨기기 위한 변수
    property bool hideByFlicking: false

    property bool updateOnLanguageChanged: true

    /* INTERNAL functions */
    function startDownScroll() {
        idDownScrollTimer.start();
    }

    function startUpScroll() {
        idUpScrollTimer.start();
    }

    function stopScroll() {
        longPressed = false;
        idDownScrollTimer.stop();
        idUpScrollTimer.stop();
    }

    function runningScroll() {
        if(true == idDownScrollTimer.running || true == idUpScrollTimer.running) {
            return true;
        } else {
            return false;
        }
    }

    function getStartIndex(posY) {
        var startIndex = -1;
        for(var i = 1; i < 10; i++) {
            startIndex = indexAt(100, posY + 50 * i);
            if(-1 < startIndex) {
                return startIndex
            }
        }

        return -1;
    }

    function getEndIndex(posY) {
        var endIndex = -1;
        for(var i = 1; i < 5; i++) {
            endIndex = indexAt(100, posY + (height - 10) - 50 * i);

            if(endIndex == indexAt(100, posY + (height - 10) - 5 * i)) {
                endIndex = indexAt(100, posY + (height - 10) - 5 * i)
            }

            if(-1 < endIndex) {
                return endIndex
            }
        }

        return -1;
    }

    function delegateWheelLeft() {
        if(false == idListViewContainer.flicking && false == idListViewContainer.moving) {
            stopScroll();
            longPressed = false;

            if(pageRows > count) {
                // 리스트가 하나의 화면에 표시되면 루핑되지 않아야 함(HMC)
                if(0 < currentIndex) {
                    decrementCurrentIndex();
                }

                return;
            }

            if(0 < currentIndex) {
                var startIndex = getStartIndex(contentY);
                if(-1 < startIndex) {
                    if(startIndex == currentIndex) {
                        decrementCurrentIndex();
                        positionViewAtIndex(currentIndex, ListView.End);
                    } else {
                        decrementCurrentIndex();
                    }
                }
            } else {
                if(("BtFavoriteMain" == idAppMain.state && 6 >= idListViewContainer.count)
                        || "BtDeviceDelMain" == idAppMain.state){
                    //즐겨 찾기 화면에서 한 페이지 내에 리스트가 표시 되는 경우로 루핑 금지
                    console.log("## Stop looping favoriteList.count = " + idListViewContainer.count)
                } else {
                    // 제일 처음에 있다만 루핑!
                    if("BtContactMain" == idAppMain.state) {
                        positionViewAtIndex(idListViewContainer.count - 1, ListView.End);
                    }
                    idListViewContainer.currentIndex = idListViewContainer.count - 1;
                }
            }
        }
    }

    function delegateWheelRight() {
        if(false == idListViewContainer.flicking && false == idListViewContainer.moving) {
            stopScroll();
            longPressed = false;

            if(pageRows > count) {
                // 리스트가 하나의 화면에 표시되면 루핑되지 않아야 함
                if(currentIndex < idListViewContainer.count - 1) {
                    incrementCurrentIndex();
                }

                return;
            }

            if(currentIndex < idListViewContainer.count - 1) {
                var endIndex = getEndIndex(contentY);
                if(-1 < endIndex) {
                    if(endIndex == currentIndex) {
                        positionViewAtIndex(currentIndex + 1, ListView.Beginning);
                        incrementCurrentIndex();
                        positionViewAtIndex(currentIndex, ListView.Beginning);
                    } else {
                        incrementCurrentIndex();
                    }
                }
            } else {
                if(("BtFavoriteMain" == idAppMain.state && 6 >= idListViewContainer.count)
                        || "BtDeviceDelMain" == idAppMain.state){
                    //즐겨 찾기 화면에서 한 페이지 내에 리스트가 표시 되는 경우로 루핑 금지
                    console.log("## Stop looping favoriteList.count = " + idListViewContainer.count)
                } else {
                    // 제일 마지막에 있다만 루핑!
                    idListViewContainer.currentIndex = 0;
                    positionViewAtIndex(currentIndex, ListView.Beginning);
                }
            }
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idListViewContainer.currentIndex = 0
    }

    Component.onDestruction: {
        stopScroll();
        longPressed = false;
    }

    // 초기 1회 진입 시 재정렬 하는 코드 추가
    onVisibleChanged: {
        if(true == idListViewContainer.visible) {
            if(true == updateOnLanguageChanged && true == gPhonebookReload) {
                if(true == iqs_15My && false == BtCoreCtrl.invokeGetBackgroundDownloadMode()) {
                    /* 수동 다운로드 중 언어 변경 후, 전화번호부->최근통화 탭 전환시 화면 오류
                     * 수동 다운로드 중 일 때, Reload하지 않도록 수정
                     */
                    if("ContactsDownLoadingMal" == contactState) {
                        //do nothing
                    } else {
                        BtCoreCtrl.invokeTrackerReloadPhonebook();
                        gPhonebookReload = false
                    }
                }
            }

            idListViewContainer.currentIndex = 0;
            idListViewContainer.positionViewAtIndex(idListViewContainer.currentIndex, ListView.Beginning);
        }
    }

    onMovementStarted: {
        prevContentY = contentY;
    }

    onMovementEnded: {
        if(false == idListViewContainer.visible) {
            return;
        }

        // Flicking 후 화면 상단에 포커스를 설정함
        var endIndex = getEndIndex(contentY);
        var flickingIndex = getStartIndex(contentY);

        if(endIndex >= currentIndex && flickingIndex < currentIndex){
            // onMovementEnded 시점에 포커스 이동하도록 수정 팝업이 있는 경우 포커스 전달 안하도록
            if(popupState == "" && menuOn == false) {
                idListViewContainer.forceActiveFocus();
            }
        } else if(prevContentY != contentY) {
            if(endIndex < count - 1) {
                if(-1 < flickingIndex) {
                    //positionViewAtIndex(flickingIndex, ListView.SnapPosition);  //ListView.Beginning);
                    currentIndex = flickingIndex;
                }
            } else {
                /* 리스트 최하단일 경우 Section에 의해 상단으로 끌어올려지는 경우가 발생하기 때문에
                 * 포커스 설정후(currentIndex 설정 후) 화면을 제일 아래로 끌어내림
                 */
                currentIndex = flickingIndex;
                positionViewAtEnd();
            }
        } else {
            //Do Nothing
        }

        // onMovementEnded 시점에 포커스 이동하도록 수정 팝업이 있는 경우 포커스 전달 안하도록
        if(popupState == "" && menuOn == false) {
            idListViewContainer.forceActiveFocus();
        }
    }

    /* KEY handelrs */
    Keys.onPressed: {
        longPressed = true
        if(Qt.Key_Down == event.key) {
            if(Qt.ShiftModifier == event.modifiers) {
                // Long-pressed
                startDownScroll();
            } else {
                event.accepted = true;
            }
        } else if(Qt.Key_Up == event.key) {
            if(Qt.ShiftModifier == event.modifiers) {
                // Long-pressed
                startUpScroll();
            } else {
                event.accepted = true;
            }
        }
    }

    Keys.onReleased: {
        if(Qt.Key_Down == event.key) {
            if(true == longPressed) {
                longPressed = false;
                stopScroll();
            }
        } else if(Qt.Key_Up == event.key) {
            if(true == longPressed) {
                longPressed = false;
                stopScroll();
            }
        }
    }


    /* TIMERS */
    Timer {
        id: idDownScrollTimer
        interval: 100
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var endIndex = idListViewContainer.getEndIndex(contentY);

            if(-1 < endIndex) {
                if(endIndex == idListViewContainer.currentIndex) {
                    idListViewContainer.incrementCurrentIndex();

                    if(endIndex != idListViewContainer.count - 1) {
                        idListViewContainer.positionViewAtIndex(idListViewContainer.currentIndex, ListView.Beginning);
                    }
                } else {
                    idListViewContainer.incrementCurrentIndex();
                }
            } else {
                idListViewContainer.currentIndex = count - 1;
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
            var startIndex = idListViewContainer.getStartIndex(contentY);

            if(-1 < startIndex) {
                if(startIndex == idListViewContainer.currentIndex) {
                    idListViewContainer.decrementCurrentIndex();
                    if(startIndex != 0) {
                        idListViewContainer.positionViewAtIndex(idListViewContainer.currentIndex, ListView.End);
                    }
                } else {
                    idListViewContainer.decrementCurrentIndex();
                }
            } else {
                idListViewContainer.currentIndex = 0;
                stop();
            }
        }
    }
}
/* EOF */
