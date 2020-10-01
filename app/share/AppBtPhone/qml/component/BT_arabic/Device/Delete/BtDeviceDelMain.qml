/**
 * BtDeviceDelMain.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idBtDeviceDelMain
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.contentAreaHeight
    focus: true

    /* PROPERTIES */
    property bool timerActive: false
    property bool clickBtn3: false

    function backKeyHandler() {
        // BAND에서 Back 버튼, EditMode에서 취소 그리고 Back Key(HKEY)를 통해 화면전환 가능
        deviceSelectUnAll();
        popScreen(302);
        delete_type = "";
    }

    Connections {
        target: idAppMain
        onMenuOffFocus: {
            /* Menu off 동작 시 focus */
            if(true == idBtDeviceDelMain.visible) {
                idBtConnectDelListView.forceActiveFocus();
            }
        }

        onDeviceDeleteCancel: {
            backKeyHandler();
        }

        onDeviceSelectUnAll: {
            if(true == clickBtn3) {
                clickBtn3 = false
            } else {
                idBtConnectDelListView.currentIndex = 0
            }
            deviceSelectInt = 0
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        deviceSelectUnAll();
        idBtConnectDelListView.forceActiveFocus();
    }

    Component.onDestruction: {
        idBtConnectDelListView.stopScroll();
    }

    onClickMenuKey: {
        idMenu.show();
    }

    onVisibleChanged: {
        if(true == idBtDeviceDelMain.visible) {
            deviceSelectUnAll();
            idBtConnectDelListView.forceActiveFocus();
        } else {
            deviceSelectUnAll();
            idBtConnectDelListView.stopScroll();
        }
        // ITS 206867 Siri 화면 진입 이후 Check 동작 초기화 수정 코드
        /*if(false == idBtDeviceDelMain.visible) {
            idBtConnectDelListView.focus = true;
        }*/
    }

    onBackKeyPressed: {
        backKeyHandler();
    }


    /* WIDGETS */
    Image {
        /* 현재 Delete화면이 발생 하면 뒤쪽 화면이 보이지 않아야하는데,
         * Delete화면 자체적으로 배경을 깔아서 배경이 보이지 않도록 수정
         */
        y: -93
        source: ImagePath.imgFolderGeneral + "bg_main.png"
    }

    MComp.DDSimpleBand {
        id: deviceDeleteBand
        titleText: stringInfo.str_Delete_Band
        menuBtnText: stringInfo.str_Menu
        menuBtnFlag: true
        subTitleText: {
            if("popup_bt_paired_device_delete_all" == popupState
                    || "popup_bt_conn_paired_device_all" == popupState) {
                idBtConnectDelListView.count
            } else {
                deviceSelectInt
            }
        }

        onBackBtnClicked: {
            backKeyHandler();
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
                idBtConnectDelListView.focus = true
                editMenu.focus = false
                idBtConnectDelListView.stopScroll();
                idBtConnectDelListView.longPressed = false;
            }
        }

        MComp.DDListView {
            id: idBtConnectDelListView
            x: 274
            y: 0
            width: 1280
            height: 540
            focus: true
            model: PairedDeviceList

            onCountChanged: {
                if(0 == BtCoreCtrl.m_pairedDeviceCount) {
                    backKeyHandler();
                }
            }

            delegate: BtDeviceDelListDelegate {
                onWheelRightKeyPressed: {
                    if(false == timerActive) {
                        timerActive = true
                        idWheeltimer.start()
                        idBtConnectDelListView.delegateWheelLeft();
                    }
                }

                onWheelLeftKeyPressed: {
                    if(false == timerActive) {
                        timerActive = true
                        idWheeltimer.start()
                        idBtConnectDelListView.delegateWheelRight();
                    }
                }

                Keys.onPressed: {
                    /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
                     * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
                     */
                    if(Qt.Key_Down == event.key) {
                        if(Qt.ShiftModifier == event.modifiers) {
                            // Long-pressed
                            idBtConnectDelListView.longPressed = true;

                            if(idBtConnectDelListView.currentIndex < idBtConnectDelListView.count - 1) {
                                // Propagate to ListView
                                idBtConnectDelListView.longPressed = true;
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
                            idBtConnectDelListView.longPressed = true;

                            if(0 < idBtConnectDelListView.currentIndex) {
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
                        if(true == idBtConnectDelListView.longPressed) {
                            if(idBtConnectDelListView.currentIndex < idBtConnectDelListView.count - 1) {
                                // Propagate to ListView
                            } else {
                                // 더이상 밑으로 내려갈 수 없을때 Release도 전달되지 않도록 막아야 함
                                idBtConnectDelListView.longPressed = false;
                                event.accepted = true;
                            }
                        } else {
                            // Set focus to "ListView"
                            idBtConnectDelListView.forceActiveFocus();
                            event.accepted = true;
                        }
                    } else if(Qt.Key_Up == event.key) {
                        if(true == idBtConnectDelListView.longPressed) {
                            if(0 < idBtConnectDelListView.currentIndex) {
                                // Propagate to ListView
                            } else {
                                // 더이상 위로 올라갈 수 없을때 Release도 전달되지 않도록 막아야 함
                                idBtConnectDelListView.longPressed = false;
                                event.accepted = true;
                            }
                        } else {
                            // Set focus to "Search Button"
                            deviceDeleteBand.forceActiveFocus();
                            event.accepted = true;
                        }
                    }
                    idBtConnectDelListView.stopScroll();
                }
                KeyNavigation.left:    editMenu
            }
        }

        MComp.MEditMode {
            id: editMenu
            y: -93

            buttonText1: stringInfo.str_Delete_Btn
            buttonText2: stringInfo.str_Bt_Delete_All
            buttonText3: stringInfo.str_Deselect
            buttonText4: stringInfo.str_Bt_Delete_Cancel

            buttonEnabled1: (0 != deviceSelectInt) ? true : false
            buttonEnabled3: (0 != deviceSelectInt) ? true : false

            onClickButton1: {
                // 선택삭제 - 삭제 버튼을 눌렀을 때 연결된 Device가 있는지 판단
                if(true == BtCoreCtrl.invokeCheckConnectDevice()) {
                    MOp.showPopup("popup_bt_conn_paired_device_delete");
                } else {
                    MOp.showPopup("popup_bt_paired_device_delete");
                }
            }

            onClickButton2: {
                // 전체삭제
                if(true == BtCoreCtrl.invokeIsAnyConnected()) {
                    MOp.showPopup("popup_bt_conn_paired_device_all");
                } else {
                    MOp.showPopup("popup_bt_paired_device_delete_all");
                }
            }

            onClickButton3: {
                // Unmark All
                clickBtn3 = true;
                deviceSelectUnAll();
                idBtConnectDelListView.forceActiveFocus();
            }

            onClickButton4: {
                // 취소
                backKeyHandler();
            }
        }

        KeyNavigation.right: idBtConnectDelListView
        KeyNavigation.up: deviceDeleteBand
    }

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
