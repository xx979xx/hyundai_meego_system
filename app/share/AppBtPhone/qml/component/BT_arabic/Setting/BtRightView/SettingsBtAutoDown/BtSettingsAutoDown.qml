/**
 * /BT_arabic/Setting/BtRightView/SettingsBtAutoDown/BtSettingsAutoDown.qml
 *
 */
import QtQuick 1.1
import "../../../../QML" as DDComp
import "../../../../QML/DH_arabic" as MComp
import "../../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../../BT/Common/Javascript/operation.js" as MOp


FocusScope
{
    id: idAutoDownloadContainer
    x: 0
    y: 0
    width: 547
    height: systemInfo.contentAreaHeight
    focus: true

    // PROPERTIES
    property int scrollMargin: 79
    property int scrollBottom: 0


    /* INTERNAL functions */
    function calculateContentHeight() {
        idAutoDownloadFlickable.contentHeight = 95 + 95
        + (MOp.greaterThan(idAutoDownloadHelp.height, idAutoDownloadHelp.paintedHeight)
        ? idAutoDownloadHelp.height : idAutoDownloadHelp.height + scrollMargin)

        scrollBottom = (true == MOp.greaterThan(idAutoDownloadHelp.height, idAutoDownloadHelp.paintedHeight)) ? 0 : 79;
    }


    onActiveFocusChanged: {
        if(false == idAutoDownloadContainer.activeFocus) {
            btn_auto_download_phonebook.focus = false
            btn_auto_download_callhistroy.focus = true
        }
    }

    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            // 후석에서 언어변경할 경우 높이가 달라져야 하므로 재설정함
            calculateContentHeight();

            if(idAutoDownloadFlickable.contentY > scrollBottom) {
                idAutoDownloadFlickable.contentY = 0;
            }
        }
    }

    /* WIDGETS */
    Flickable {
        id: idAutoDownloadFlickable
        x: 0
        y: 0
        width: parent.width
        height: 535
        focus: true
        clip: true

        contentWidth: parent.width
        //contentHeight: device_auto_device_no_connect.height + autoconncolumn.height + 380

        /* 스크롤을 아래로 내리면 79(scrollMagin)만큼 아래로 contentY를 조정하므로
         * contentHeight를 계산할때 95 * 2 + idAutoDownloadHelp.paintedHeight를 사용하면
         * 스크롤을 위/아래로 이동할때 스크롤바 상/하단 빈공간의 차이가 발생할 수 있음
         * (프랑스어만 한줄 더 필요하므로 79만 사용해도 무방함)
         */
        contentHeight: 95 + 95
                       + (MOp.greaterThan(idAutoDownloadHelp.height, idAutoDownloadHelp.paintedHeight)
                            ? idAutoDownloadHelp.height : idAutoDownloadHelp.height + scrollMargin)

        boundsBehavior: MOp.greaterThan(idAutoDownloadHelp.paintedHeight, idAutoDownloadHelp.height) ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick


        Component.onCompleted: {
            idAutoDownloadFlickable.contentY = 0;
            calculateContentHeight();
        }

        onMovementEnded: {
            if(false == idAutoDownloadScroll.visible) {
                return;
            }

            if(89 - 45 > idAutoDownloadFlickable.contentY) {
                btn_auto_download_callhistroy.forceActiveFocus();
            } else if (89 * 2 - 60 > idAutoDownloadFlickable.contentY) {
                btn_auto_download_phonebook.forceActiveFocus()
            }
        }


        MComp.MButton {
            id: btn_auto_download_callhistroy
            width: 547
            height: 95
            //DEPRECATED active: BtCoreCtrl.m_autoDownloadCallHistory        //btAutoDownRecent == "on"
            focus: true

            bgImage: ""
            bgImagePress: ImagePath.imgFolderGeneral + "bg_menu_tab_r_02_p.png"
            bgImageFocus: ImagePath.imgFolderGeneral + "bg_menu_tab_r_02_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 547
            bgImageHeight: 95

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: 9
            lineImageY: 89

            DDComp.DDCheckBox {
                id: idRecentsCheckBox
                x: 30
                y: 0
                width: 51
                height: parent.height

                checkCondition: BtCoreCtrl.m_autoDownloadCallHistory

                visible: {
                    if(contact_nstate == 9
                        || contact_nstate == 10
                        || contact_nstate == 11
                        || contact_nstate == 13
                        || recent_nstate == 9
                        || recent_nstate == 10
                        || recent_nstate == 11
                        || recent_nstate == 13) {
                        false
                     } else {
                        true
                     }
                }
            }

            firstText: stringInfo.str_Callhistory_Auto_Download
            firstTextX: 75
            firstTextY: 25
            firstTextWidth: 443
            firstTextHeight: 40
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            firstTextAlies: "Right"
            firstTextElide: "Left"

            onClickOrKeySelected: {
                if(true == idRecentsCheckBox.visible) {
                    qml_debug("BtCoreCtrl.m_autoDownloadCallHistory = " + BtCoreCtrl.m_autoDownloadCallHistory);
                    if(true == BtCoreCtrl.m_autoDownloadCallHistory) {
                        BtCoreCtrl.invokeSetAutoDownloadCallHistory(false);
                    } else {
                        BtCoreCtrl.invokeSetAutoDownloadCallHistory(true);
                    }
                } else {
                    qml_debug("downloading callhistotry")
                }
                btn_auto_download_callhistroy.forceActiveFocus();
            }

            onWheelRightKeyPressed:  {
                //btn_auto_download_phonebook.forceActiveFocus();
            }

            onWheelLeftKeyPressed: {
                btn_auto_download_phonebook.forceActiveFocus();
            }

            onActiveFocusChanged: {
                if(true == btn_auto_download_callhistroy.activeFocus) {
                    idVisualCue.setVisualCue(true, true, false, false);
                }
            }

            // "실행중" TEXT -> ICON 변경
            Image {
                source: ImagePath.imgFolderBt_phone + "ico_phone_down_01.png"
                x: 30
                y: 20
                visible: (false == idRecentsCheckBox.visible) ? true : false
            }
        }

        MComp.MButton {
            id: btn_auto_download_phonebook
            y: 89
            width: 547
            height: 95

            bgImage: ""
            bgImagePress: ImagePath.imgFolderGeneral + "bg_menu_tab_r_02_p.png"
            bgImageFocus: ImagePath.imgFolderGeneral + "bg_menu_tab_r_02_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 547
            bgImageHeight: 95

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: 9
            lineImageY: 89

            DDComp.DDCheckBox {
                id: idContactsCheckBox
                x: 30
                y: 0
                width: 51
                height: parent.height

                checkCondition: BtCoreCtrl.m_autoDownloadPhonebook

                visible: {
                    if(contact_nstate == 9
                        || contact_nstate == 10
                        || contact_nstate == 11
                        || contact_nstate == 13
                        || recent_nstate == 9
                        || recent_nstate == 10
                        || recent_nstate == 11
                        || recent_nstate == 13){
                        false
                     } else {
                        true
                     }
                }
            }

            firstText: stringInfo.str_Phonebook_Auto_Download
            firstTextX: 75
            firstTextY: 25      //90 - 45 - 20
            firstTextWidth: 443
            firstTextHeight: 40
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            firstTextAlies: "Right"
            firstTextElide: "Left"

            onClickOrKeySelected: {
                if(true == idContactsCheckBox.visible) {
                    qml_debug("BtCoreCtrl.m_autoDownloadPhonebook = " + BtCoreCtrl.m_autoDownloadPhonebook);
                    if(true == BtCoreCtrl.m_autoDownloadPhonebook) {
                        BtCoreCtrl.invokeSetAutoDownloadPhonebook(false);
                    } else {
                        BtCoreCtrl.invokeSetAutoDownloadPhonebook(true);
                    }
                } else {
                    qml_debug("downloading callhistotry")
                }
                btn_auto_download_phonebook.forceActiveFocus();
            }

            onWheelRightKeyPressed:  {
                btn_auto_download_callhistroy.forceActiveFocus();

                if(idAutoDownloadHelp.height < idAutoDownloadHelp.paintedHeight) {
                    idAutoDownloadFlickable.contentY = 0;
                }
            }

            onWheelLeftKeyPressed: {
                if(idAutoDownloadHelp.height < idAutoDownloadHelp.paintedHeight) {
                    // Scroll이 표시되고 있다면
                    idAutoDownloadFlickable.contentY = scrollBottom;
                }
            }

            // "실행중" TEXT > ICON 변경
            Image {
                source: ImagePath.imgFolderBt_phone + "ico_phone_down_02.png"
                x: 30
                y: 20
                visible: (false == idContactsCheckBox.visible) ? true : false
            }

            onActiveFocusChanged: {
                if(true == btn_auto_download_phonebook.activeFocus) {
                    idVisualCue.setVisualCue(true, true, false, false);
                }
            }
        }

        Text {
            id: idAutoDownloadHelp
            text: stringInfo.str_Phonebook_Auto_Download_Message
            y: 0
            x: 19
            width: 520
            height: 345
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            // Text가 넘치면 상단 정렬, 안넘치면 가운데 정렬
            verticalAlignment: (idAutoDownloadHelp.height < idAutoDownloadHelp.paintedHeight) ? Text.AlignTop : Text.AlignVCenter
            color: colorInfo.dimmedGrey
            wrapMode: Text.WordWrap
            lineHeight: 0.8
            clip: false
            anchors.top: btn_auto_download_phonebook.bottom
        }
    } // end of Flickable

    MComp.MScroll {
        id: idAutoDownloadScroll
        x: 546
        y: 199 - systemInfo.headlineHeight
        height: 476
        width: 14

        visible: MOp.greaterThan(idAutoDownloadHelp.paintedHeight, idAutoDownloadHelp.height)
        scrollArea: idAutoDownloadFlickable

        Component.onCompleted: {
            idAutoDownloadFlickable.contentY = 0;
            idAutoDownloadScroll.heightRatio = idAutoDownloadFlickable.height / idAutoDownloadFlickable.contentHeight;
        }
    }
}
/* EOF */
