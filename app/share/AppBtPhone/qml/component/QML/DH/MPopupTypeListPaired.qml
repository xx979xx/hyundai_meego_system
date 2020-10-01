/**
 * /QML/DH/MPopupTypeListPaired.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePathArab
import "../../BT/Common/Javascript/operation.js" as MOp


MPopup
{
    id: idMPopupTypeListTitle
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property string popupName: ""

    property string popupTitleText: ""
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property QtObject idListModel
    property string listFirstItem

    property int selectedItemIndex: 0           //# indexNumber of selectedItem
    property int popupLineCnt: idListView.count //# 1 ~ use input
    property int overContentCount

    property bool black_opacity: true


    // SIGNALS
    signal popupClicked();
    //DEPRECATED signal popupBgClicked();
    signal popuplistItemClicked(int selectedItemIndex);
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeListTitle.visible) {
            idListView.currentIndex = 0;
            idListView.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

/*DEPRECATED
    onClickOrKeySelected: {
        //DEPRECATED popupBgClicked();
    }
DEPRECATED*/

    onVisibleChanged: {
        if(true == idMPopupTypeListTitle.visible) {
            idListView.currentIndex = 0;
            idListView.forceActiveFocus();
        } else {
        }
        popupBackGroundBlack = black_opacity
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: black_opacity ? 0.6 : 1
    }

    Image {
        source: idListView.count > 3 ? ImagePath.imgFolderPopup + "bg_type_e.png" : ImagePath.imgFolderPopup + "bg_type_d.png"
        x: 94
        y: idListView.count > 3 ? 131 - systemInfo.statusBarHeight : 168 - systemInfo.statusBarHeight;
        width: 1093
        height: idListView.count > 3 ? 459 : 384;

        Text {
            id: idTitle
            text: popupTitleText
            x: 55
            y: 37
            width: 983
            height: 44
            font.pointSize: 44
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: 20 == gLanguage ? Text.ElideLeft : Text.ElideRight
        }

        FocusScope {
            id: idList
            x: 20 == gLanguage ? 327 : 26
            y: idListView.count == 1 ? 190 : idListView.count == 2 ? 149 : idListView.count == 3 ? 108 : 104
            width: 740
            height: 328
            focus: true
            KeyNavigation.left: 20 == gLanguage ? idButton1 : idList
            KeyNavigation.right: 20 == gLanguage ? idList : idButton1

            ListView {
                id: idListView
                clip: true
                focus: true
                anchors.fill: parent
                orientation: ListView.Vertical
                boundsBehavior: idListView.count < 4 ? Flickable.StopAtBounds : Flickable.DragAndOvershootBounds
                highlightMoveSpeed: 99999
                model: PairedDeviceList
                delegate: idListDelegate

                onContentYChanged: {
                    overContentCount = contentY / (contentHeight / count)
                }

                function getStartIndex(posY) {
                    var startIndex = -1;
                    for(var i = 1; i < 10; i++) {
                        startIndex = indexAt(100, posY + 50 * i);
                        if(-1 < startIndex) {
                            break;
                        }
                    }

                    return startIndex;
                }

                onMovementStarted: {
                }

                onMovementEnded: {
                    if(false == idList.visible) {
                        return;
                    }

                    if("" == popupState && menuOn == false) {
                        idListView.forceActiveFocus();
                    }

                    var flickingIndex = getStartIndex(contentY);
                    if(-1 != flickingIndex) {
                        positionViewAtIndex(flickingIndex, ListView.Beginning);
                        currentIndex = flickingIndex;
                    }
                }
            }

            MRoundScroll {
                x: 20 == gLanguage ? -35 : 741
                y: 13       //37 - 24
                scrollWidth: 39
                scrollHeight: 306
                scrollBgImage: idListView.count > 4 ? 20 == gLanguage ? ImagePathArab.imgFolderPopup + "scroll_bg.png" : ImagePath.imgFolderPopup + "scroll_bg.png" : ""
                scrollBarImage: idListView.count > 4 ? 20 == gLanguage ? ImagePathArab.imgFolderPopup + "scroll.png" : ImagePath.imgFolderPopup + "scroll.png" : ""
                listCountOfScreen: 4
                moveBarPosition: idListView.height/idListView.count*overContentCount
                listCount: idListView.count
                visible: (idListView.count > 4) ? true : false
            }

            Component {
                id: idListDelegate

                MButton {
                    id: idItemDelegate
                    x: 0
                    y: 0
                    width: 740
                    height: 82
                    focus: idListView.currentIndex == index

                    bgImagePress: 20 == gLanguage ? ImagePathArab.imgFolderPopup + "list_p.png" : ImagePath.imgFolderPopup + "list_p.png"
                    bgImageFocus: 20 == gLanguage ? ImagePathArab.imgFolderPopup + "list_f.png" : ImagePath.imgFolderPopup + "list_f.png"
                    bgImageX: 0
                    bgImageY: 0
                    bgImageWidth: 740
                    bgImageHeight: 85

                    lineImage: ImagePath.imgFolderPopup + "list_line.png"
                    lineImageX: 10
                    lineImageY: 82
                    lineVisible: idListView.count > 1 && index != idListView.count - 1

                    firstText: deviceName
                    firstTextX: 69 - 26
                    firstTextY: 82 - 54
                    firstTextWidth: 677 //654 가이드 상의 넓이 임의의 넓이 677
                    firstTextHeight: 32
                    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                    firstTextSize: 32
                    firstTextAlies: 20 == gLanguage ? "Right" : "Left"
                    firstTextColor: idItemDelegate.activeFocus? colorInfo.brightGrey : colorInfo.commonGrey

                    onClickOrKeySelected: {
                        idListView.currentIndex = index;
                        if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                                || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()) {
                            if(true == downloadContact) {
                                MOp.showPopup("popup_Bt_Phonebook_Downloading_Dis_Connect");
                            } else if(true == downloadCallHistory) {
                                MOp.showPopup("popup_Bt_Callhistory_Downloading_Dis_Connect");
                            } else {
                                MOp.showPopup("popup_Bt_Dis_Connection");
                            }
                        } else {
                            // Connect start
                            BtCoreCtrl.invokeSetStartConnectingFromHU(true);

                            if(true == BtCoreCtrl.invokeIsAnyConnected()) {
                                qml_debug("[QML] Popup_Bt_Other_Device_Connect call");
                                MOp.showPopup("popup_Bt_Other_Device_Connect");
                            } else {
                                connectingDeviceId = deviceId;
                                BtCoreCtrl.invokeSetConnectingDeviceID(deviceId);
                                BtCoreCtrl.invokeStartConnect(deviceId);
                                //DEPRECATED BtCoreCtrl.m_bConnectingDevice = true;
                                MOp.showPopup("popup_Bt_Connecting");
                            }
                        }
                    }
                    KeyNavigation.up: idItemDelegate
                    KeyNavigation.down: idItemDelegate

                    onWheelLeftKeyPressed: {
                        if(20 == gLanguage) {
                            if(5 > idListView.count) {
                                // 리스트 내부의 항목이 4개 이하인 경우 looping 되지 않도록 적용
                                idListView.incrementCurrentIndex();
                            } else {
                                // 리스트의 항목이 5개 인경우
                                if(4 == idListView.currentIndex) {
                                    // 마지막 항목 일 때, 루핑 하도록 수정
                                    idListView.currentIndex = 0
                                } else {
                                    idListView.incrementCurrentIndex();
                                }
                            }
                        } else {
                            if(5 > idListView.count) {
                                // 리스트 내부의 항목이 4개 이하인 경우 looping 되지 않도록 적용
                                idListView.decrementCurrentIndex();
                            } else {
                                // 리스트의 항목이 5개 인경우
                                if(0 == idListView.currentIndex) {
                                    // 마지막 항목 일 때, 루핑 하도록 수정
                                    idListView.currentIndex = idListView.count - 1
                                } else {
                                    idListView.currentIndex -= 1
                                }
                            }
                        }
                    }

                    onWheelRightKeyPressed: {
                        if(20 == gLanguage) {
                            if(5 > idListView.count) {
                                // 리스트 내부의 항목이 4개 이하인 경우 looping 되지 않도록 적용
                                idListView.decrementCurrentIndex();
                            } else {
                                // 리스트의 항목이 5개 인경우
                                if(0 == idListView.currentIndex) {
                                    // 마지막 항목 일 때, 루핑 하도록 수정
                                    idListView.currentIndex = idListView.count - 1
                                } else {
                                    idListView.currentIndex -= 1
                                }
                            }
                        } else {
                            if(5 > idListView.count) {
                                // 리스트 내부의 항목이 4개 이하인 경우 looping 되지 않도록 적용
                                idListView.incrementCurrentIndex();
                            } else {
                                // 리스트의 항목이 5개 인경우
                                if(4 == idListView.currentIndex) {
                                    // 마지막 항목 일 때, 루핑 하도록 수정
                                    idListView.currentIndex = 0
                                } else {
                                    idListView.incrementCurrentIndex();
                                }
                            }
                        }
                    }
                }
            }
        }

        MButton {
            id: idButton1
            x: 20 == gLanguage ? 18 : 780
            y: 98
            width: 295
            height: idListView.count > 3 ? 171 : 134

            bgImage: idListView.count > 3 ?
                         20 == gLanguage ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_b_02_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_02_n.png" :
                         20 == gLanguage ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_a_02_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png"
            bgImagePress: idListView.count > 3 ?
                              20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_b_02_p.png" : ImagePath.imgFolderPopup + "btn_type_b_02_p.png" :
                              20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_a_02_p.png" : ImagePath.imgFolderPopup + "btn_type_a_02_p.png"
            bgImageFocus: idListView.count > 3 ?
                              20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_b_02_f.png" : ImagePath.imgFolderPopup + "btn_type_b_02_f.png" :
                              20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_a_02_f.png" : ImagePath.imgFolderPopup + "btn_type_a_02_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: idListView.count > 3 ?
                            20 == gLanguage ? 233 : -6 :
                            20 == gLanguage ? 233 : -7
            fgImageY: idListView.count > 3 ? 47 : 25
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            Text {
                text: popupFirstBtnText
                x: 20 == gLanguage ? 26 : 52
                y: idListView.count > 3 ? 53 : 33
                width: 210
                height: (8 == gLanguage || 11 == gLanguage || 12 == gLanguage || 20 == gLanguage || 21 == gLanguage || 22 == gLanguage) ? 32 : 36
                font.pointSize: (8 == gLanguage || 11 == gLanguage || 12 == gLanguage || 20 == gLanguage || 21 == gLanguage || 22 == gLanguage) ? 32 : 36
                font.family: stringInfo.fontFamilyBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                lineHeight: idListView.count > 3 ? 0.7 : 0.5
                color: colorInfo.brightGrey
            }

            KeyNavigation.left: 20 == gLanguage ? idButton1 : idList;
            KeyNavigation.right: 20 == gLanguage ? idList : idButton1;


            onWheelLeftKeyPressed: 20 == gLanguage ? idButton2.forceActiveFocus() : idButton1 ;
            onWheelRightKeyPressed: 20 == gLanguage ? idButton1 : idButton2.forceActiveFocus();

            onClickOrKeySelected: {
                popupFirstBtnClicked()
            }
        }

        MButton {
            id: idButton2
            x: 20 == gLanguage ? 18 : 780
            y: (idListView.count > 3) ? 269 : 232
            width: 295
            height: idListView.count > 3 ? 172 : 134

            bgImage: idListView.count > 3 ?
                         20 == gLanguage ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_b_03_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_03_n.png" :
                         20 == gLanguage ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_a_03_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup+"btn_type_a_03_n.png"
            bgImagePress: idListView.count > 3 ?
                              20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_b_03_p.png" : ImagePath.imgFolderPopup + "btn_type_b_03_p.png" :
                              20 == gLanguage ? ImagePathArab.imgFolderPopup+"btn_type_a_03_p.png" : ImagePath.imgFolderPopup+"btn_type_a_03_p.png"
            bgImageFocus: idListView.count > 3 ?
                              20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_b_03_f.png" : ImagePath.imgFolderPopup + "btn_type_b_03_f.png" :
                              20 == gLanguage ? ImagePathArab.imgFolderPopup+"btn_type_a_03_f.png" : ImagePath.imgFolderPopup+"btn_type_a_03_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: idListView.count > 3 ?
                          20 == gLanguage ? 233 : -6 :
                          20 == gLanguage ? 233 : -7
            fgImageY: idListView.count > 3 ? 47 : 25
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton2.activeFocus

            firstText: popupSecondBtnText
            firstTextX: 20 == gLanguage ? 26 : 52
            firstTextY: idListView.count > 3 ? 62 : 42
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextWrap: Text.WordWrap
            firstTextElide: Text.ElideNone

            KeyNavigation.left: 20 == gLanguage ? idButton2 : idList;
            KeyNavigation.right: 20 == gLanguage ? idList : idButton2;

            onWheelLeftKeyPressed: 20 == gLanguage ? idButton2 : idButton1.forceActiveFocus()
            onWheelRightKeyPressed: 20 == gLanguage ? idButton1.forceActiveFocus() : idButton2

            onClickOrKeySelected: {
                popupSecondBtnClicked();
            }
        }
    }
}
/* EOF */
