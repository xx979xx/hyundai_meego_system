/**
 * MPopupTypeList.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MPopup
{
    id: idMPopupTypeList
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    property alias button1Enabled: idButton1.mEnabled

    // SIGNALS
    //DEPRECATED signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idMPopupTypeList.visible) {
            ini_paired_device = false
            ini_bluetooth_setting = true

            if(0 < BtCoreCtrl.m_pairedDeviceCount) {
                ini_paired_device = true
                idDeleteBtn.mEnabled = true
                idDeleteBtn.forceActiveFocus();
            } else {
                ini_paired_device = false
                idDeleteBtn.mEnabled = false
                idResetBtn.forceActiveFocus();
            }

            setButton1Enable();
        }

        popupBackGroundBlack = true
    }


    onVisibleChanged: {
        if(true == idMPopupTypeList.visible) {
	//[START] ITS 0264854
            //before popup
            if(true == initialize_after_disconnecting_popup_check){
                if(true == initialize_after_disconnecting_state){
                	ini_bluetooth_setting = true
                }else{
                    ini_bluetooth_setting = false
                }
                initialize_after_disconnecting_popup_check = false
            }
            //init
            else{
                ini_bluetooth_setting = true
                initialize_after_disconnecting_state = true
            }
	//[END] ITS 0264854
            ini_paired_device = false

            if(0 < BtCoreCtrl.m_pairedDeviceCount) {
                ini_paired_device = true
                idDeleteBtn.mEnabled = true
                idDeleteBtn.forceActiveFocus();
            } else {
                ini_paired_device = false
                idDeleteBtn.mEnabled = false
                idResetBtn.forceActiveFocus();
            }

            setButton1Enable();
            popupBackGroundBlack = true
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: "Black"
        opacity: 0.6
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_a.png"
        x: 93
        y: 208 - systemInfo.statusBarHeight
        width: 1093
        height: 304
        focus: true

        FocusScope {
            id: idListDelegate

            MButtonHaveTicker {
                id: idDeleteBtn
                x: 26
                y: 69
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
                focus: mEnabled

                firstText: stringInfo.str_Delete_All_Device
                firstTextX: 43
                firstTextY: 26
                firstTextWidth: 610
                firstTextHeight: 32
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey

                tickerEnable: true

                lineImage: ImagePath.imgFolderPopup + "list_line.png"
                lineImageX: 10
                lineImageY: 82

                onClickOrKeySelected: {
                    idDeleteBtn.forceActiveFocus();

                    if(true == ini_paired_device) {
                        ini_paired_device = false
                    } else {
                        ini_paired_device = true
                    }

                    setButton1Enable();
                }


                Image {
                    source: false == idDeleteBtn.mEnabled? ImagePath.imgFolderPopup + "checkbox_d.png" : (true == ini_paired_device ? ImagePath.imgFolderPopup + "checkbox_s.png" : ImagePath.imgFolderPopup + "checkbox_n.png")
                    x: 671
                    y: 15
                    z: 1
                    width: 51
                    height: 52
                }

                onWheelRightKeyPressed: {
                    idResetBtn.forceActiveFocus();
                }

                KeyNavigation.right: popupBtn//false == idButton1.mEnabled ? idButton2 : idButton1
            }

            MButtonHaveTicker {
                id: idResetBtn
                x: 26
                y: 69 + 85
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
                focus: !idDeleteBtn.focus

                firstText: stringInfo.str_Bt_Setting_Ini
                firstTextX: 43
                firstTextY: 26
                firstTextWidth: 610
                firstTextHeight: 32
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey

                tickerEnable: true

                onClickOrKeySelected: {
                    idResetBtn.forceActiveFocus();

                    if(true == ini_bluetooth_setting) {
                        ini_bluetooth_setting = false
                    } else {
                        ini_bluetooth_setting = true
                    }
		    //[START] ITS 0264854
                    initialize_after_disconnecting_state = ini_bluetooth_setting
		    //[END] ITS 0264854
                    setButton1Enable();
                }


                Image {
                    source: true == ini_bluetooth_setting ? ImagePath.imgFolderPopup + "checkbox_s.png" : ImagePath.imgFolderPopup + "checkbox_n.png"
                    x: 671
                    y: 15
                    z: 1
                    width: 51
                    height: 52
                }

                onWheelLeftKeyPressed: {
                    if(false == idDeleteBtn.mEnabled) {

                    } else {
                        idDeleteBtn.forceActiveFocus();
                    }
                }

                KeyNavigation.right: popupBtn//false == idButton1.mEnabled ? idButton2 : idButton1
            }
        }

        FocusScope {
            id: popupBtn

            MButton {
                id: idButton1
                x: 780
                y: 18
                width: 295
                height: 134
                focus: mEnabled
                mEnabled: false
                visible: true

                bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png"
                bgImagePress:   ImagePath.imgFolderPopup + "btn_type_a_02_p.png"
                bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_a_02_f.png"

                fgImage: ImagePath.imgFolderPopup + "light.png"
                fgImageX: -6
                fgImageY: 32
                fgImageWidth: 69
                fgImageHeight: 69
                fgImageVisible: true == idButton1.activeFocus

                onWheelRightKeyPressed: idButton2.forceActiveFocus()

                firstText: stringInfo.str_Ok
                firstTextX: 52
                firstTextY:49
                firstTextWidth: 210
                firstTextHeight: 36
                firstTextSize: 36
                firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
                firstTextAlies: "Center"
                firstTextColor: colorInfo.brightGrey

                onClickOrKeySelected: {
                    popupFirstBtnClicked();
                }

                onMEnabledChanged: {
                    if(false == idButton1.mEnabled) {
                        if(true == idButton1.acticveFocus) {
                            idButton1.focus = false;
                            idButton2.focus = true;
                        }
                    }
                }

                KeyNavigation.left: idListDelegate//false == idDeleteBtn.mEnabled ? idResetBtn : idDeleteBtn
            }

            MButton {
                id: idButton2
                x: 780
                y: 152
                width: 295
                height: 134
                focus: !idButton1.focus
                visible: true

                bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_03_n.png"
                bgImagePress:   ImagePath.imgFolderPopup + "btn_type_a_03_p.png"
                bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_a_03_f.png"

                fgImage: ImagePath.imgFolderPopup + "light.png"
                fgImageX: -6
                fgImageY: 32
                fgImageWidth: 69
                fgImageHeight: 69
                fgImageVisible: true == idButton2.activeFocus

                onWheelLeftKeyPressed: {
                    if(true == idButton1.mEnabled) {
                        idButton1.forceActiveFocus()
                    } else {
                        // do nothing
                    }
                }

                firstText: stringInfo.str_Bt_Cancel
                firstTextX: 832 - 780
                firstTextY: 49
                firstTextWidth: 210
                firstTextHeight: 36
                firstTextSize: 36
                firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
                firstTextAlies: "Center"
                firstTextColor: colorInfo.brightGrey

                onClickOrKeySelected: {
                    popupSecondBtnClicked();
                }

                KeyNavigation.left: idListDelegate//false == idDeleteBtn.mEnabled ? idResetBtn : idDeleteBtn
            }
        }
    }
}
/* EOF */
