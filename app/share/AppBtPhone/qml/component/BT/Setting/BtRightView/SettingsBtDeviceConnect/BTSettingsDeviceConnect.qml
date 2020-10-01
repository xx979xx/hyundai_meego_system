/**
 * BTSettingsDeviceConnect.qml
 *
 */
import QtQuick 1.1
import "../../../../QML/DH" as MComp
import "../../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idSettingsDeviceConnectMain
    y: 3
    focus: true

    // PROPERTIES
    property int pairedDeviceCount: BtCoreCtrl.m_pairedDeviceCount

    onActiveFocusChanged: {
        if(false == idSettingsDeviceConnectMain.activeFocus) {
            setDeviceConnectView();
        }
    }

    // Menu off 동작 시 focus
    Connections {
        target: idAppMain
        onMenuOffFocus: {
            if(true == idBtDeviceNoList.visible) {
                idBtDeviceNoList.forceActiveFocus();
            } else {
                id_paired_device.forceActiveFocus();
            }
        }
    }

    /* INTERNAL functions */
    function setDeviceConnectView() {
        // 디바이스 개수에 따라 메뉴버튼 넣는부분
        if(0 < BtCoreCtrl.m_pairedDeviceCount) {
            idBtDeviceList.visible = true;
            idBtDeviceList.focus = true;
            id_paired_device.focus = true;

            idBtDeviceNoList.visible = false;
            idBtDeviceNoList.focus = false;

            /* 블루투스 연결 설정 화면 메뉴 항상 표시 하도록 UX변경
             * 자바스크립트에서 화면 표시 시에 메뉴 source 관리 하도록 수정
             */
            //idMenu.source = "BTSettingsDeviceConnectOptionMenu.qml";
        } else {
            idBtDeviceList.visible = false;
            idBtDeviceList.focus = false;

            idBtDeviceNoList.visible = true;
            idBtDeviceNoList.focus = true;

            /* 블루투스 연결 설정 화면 메뉴 항상 표시 하도록 UX변경
             * 자바스크립트에서 화면 표시 시에 메뉴 source 관리 하도록 수정
             */
            //idMenu.source = "";
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        // 초기 진입 시 메뉴 버튼 유/무를 확인 하는 코드
        checkedCallViewStateChange = 0;
        setDeviceConnectView();
    }

    onVisibleChanged: {
        if(true == idSettingsDeviceConnectMain.visible) {
            checkedCallViewStateChange = 0;
            setDeviceConnectView();
        }
    }

    onPairedDeviceCountChanged: {
        setDeviceConnectView();
    }


    /* WIDGETS */
    MComp.MComponent {
        id: idBtDeviceList
        x: -9
        y: 0
        width: 577
        height: systemInfo.lcdHeight - systemInfo.statusBarHeight
        clip: true

        onVisibleChanged: {
            id_paired_device.model = ""
            id_paired_device.model = PairedDeviceList
            id_paired_device.currentIndex = 0
        }

        ListView {
            id: id_paired_device
            clip: true
            focus: true
            anchors.fill: parent
            model: PairedDeviceList
            orientation : ListView.Vertical
            highlightMoveSpeed: 9999999
            boundsBehavior: Flickable.StopAtBounds

            delegate: BTSettingsDelegate {
                onWheelLeftKeyPressed: {
                    id_paired_device.decrementCurrentIndex()
                }

                onWheelRightKeyPressed: {
                    id_paired_device.incrementCurrentIndex()
                }

                KeyNavigation.up: idLoaderSettingsBand
                KeyNavigation.down: false == btn_setting_device_list_add.mEnabled ? id_paired_device  :btn_setting_device_list_add
            }
        }

        MComp.MButton2 {
            id: btn_setting_device_list_add
            x: 75
            y: 449
            width: 372
            height: 71

            bgImage:        ImagePath.imgFolderSettings + "btn_ini_l_n.png"
            bgImagePress:   ImagePath.imgFolderSettings + "btn_ini_l_p.png"
            bgImageFocus:   ImagePath.imgFolderSettings + "btn_ini_l_f.png"

            firstText: stringInfo.str_New_Registration_Btn
            firstTextX: 14
            firstTextY: 33 - 16
            firstTextWidth: 344
            firstTextSize: (btn_setting_device_list_add_hidenText.paintedWidth > 344)? 23 : 32
            firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            firstTextColor: colorInfo.brightGrey
            firstTextAlies: "Center"

            //주행 중 버튼 비활성화 삭제 버튼 활성화 되고 버튼 선택 시 팝업 출력
            // mEnabled: (true == parking) ? true : false

            /* 버튼의 범위를 넘어가는 문구의 폰트사이즈 조절하기 위한 hidden text
              */
            Text {
                id: btn_setting_device_list_add_hidenText
                text: stringInfo.str_New_Registration_Btn
                font.pointSize: 32
                font.family: stringInfo.fontFamilyRegular
                visible: false
            }

            onClickOrKeySelected: {
                qml_debug("PairedDeviceCount = " + BtCoreCtrl.m_pairedDeviceCount);
                qml_debug("BtCoreCtrl.invokeIsAnyConnected() = " + BtCoreCtrl.invokeIsAnyConnected());
                qml_debug("parking = " + parking);

                /* 주행규제를 제일 먼저 검사하도록 수정
                 */
                if(false == parking) {
                    MOp.showPopup("popup_restrict_while_driving");
                } else {
                    if(5 > BtCoreCtrl.m_pairedDeviceCount) {
                        if(true == BtCoreCtrl.invokeIsAnyConnected()) {
                            MOp.showPopup("popup_Bt_Other_Device_Connect_Menu");
                        } else {
                            qml_debug("First Device new Registration parking == true")
                            BtCoreCtrl.invokeSetDiscoverableMode(true)
                            MOp.showPopup("popup_Bt_SSP_Add");
                        }
                    } else {
                        MOp.showPopup("popup_Bt_Max_Device_Setting");
                    }
                }
            }

            onActiveFocusChanged: {
                if(btn_setting_device_list_add.activeFocus == true) {
                    idVisualCue.setVisualCue(true, false, false, true);
                    visualCueDownActive = false
                } else {
                    visualCueDownActive = true
                }
            }

            onMEnabledChanged: {
                if(false == btn_setting_device_list_add.mEnabled && true == btn_setting_device_list_add.activeFocus) {
                    id_paired_device.focus = true;
                    idLoaderSettingsLeft.forceActiveFocus();
                }
            }

            KeyNavigation.up: id_paired_device
        }
    }

    // No paired device
    BTSettingsNoDevice {
        id: idBtDeviceNoList
    }
}
/* EOF */
