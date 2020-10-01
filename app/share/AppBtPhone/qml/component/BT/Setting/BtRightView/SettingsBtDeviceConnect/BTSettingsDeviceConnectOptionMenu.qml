/**
 * BTSettingsDeviceConnectOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../../../QML/DH" as MComp
import "../../../../BT/Common/Javascript/operation.js" as MOp


MComp.MOptionMenu
{
    id: idDeviceMenuContainer
    linkedModels: deviceListModel
    focus: true;
    visible: true;


    // 주행 중 버튼 비활성화 삭제 버튼 활성화 되고 버튼 선택 시 팝업 출력
    // menu0Dimmed: (true == parking) ? false : true
    menu1Dimmed: (0 < BtCoreCtrl.m_pairedDeviceCount) ? false : true

    ListModel {
        id: deviceListModel
        ListElement { name: "New Registration"; opType: "" }
        ListElement { name: "Delete";           opType: "" }
    }

    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            idDeviceMenuContainer.linkedModels.get(0).name = stringInfo.str_New_Registration_Menu
            idDeviceMenuContainer.linkedModels.get(1).name = stringInfo.str_Delete_Menu
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idDeviceMenuContainer.linkedModels.get(0).name = stringInfo.str_New_Registration_Menu
        idDeviceMenuContainer.linkedModels.get(1).name = stringInfo.str_Delete_Menu
    }

    onVisibleChanged: {
        if(true == idDeviceMenuContainer.visible) {
            idDeviceMenuContainer.linkedModels.get(0).name = stringInfo.str_New_Registration_Menu
            idDeviceMenuContainer.linkedModels.get(1).name = stringInfo.str_Delete_Menu
        }
    }

    onMenu0Click: {
        idMenu.off();

        if(false == parking) {
            qml_debug("## parking = false");
            MOp.showPopup("popup_restrict_while_driving");
        } else {
            if(5 > BtCoreCtrl.m_pairedDeviceCount) {
                if(true == BtCoreCtrl.invokeIsAnyConnected()) {
                    MOp.showPopup("popup_Bt_Other_Device_Connect_Menu");
                } else {
                    qml_debug("Device new Registration parking == true")
                    BtCoreCtrl.invokeSetDiscoverableMode(true)
                    MOp.showPopup("popup_Bt_SSP_Add");
                }
            } else {
                MOp.showPopup("popup_Bt_Max_Device_Setting");
            }
        }
    }

    onMenu1Click: {
        // 연결설정 --> 삭제
        qml_debug("Settings Device Connect Delete");
        selectUnAll()
        deviceSelectInt = 0;
        idMenu.off();

        delete_type = "device"
        pushScreen("BtDeviceDelMain", 518);
    }

    onClickDimBG: {
        idMenu.hide();
        idLoaderSettingsLeft.forceActiveFocus();
    }

    onOptionMenuFinished: {
        if(true == visible) {
            idMenu.hide();
        }
    }
}
/* EOF */
