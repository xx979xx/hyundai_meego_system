import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem


MComp.MComponent{
    id:idBluetoothLoader
    x:-1; y:261-89-166+5
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    //clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
        if(isMapCareMain)
        {
            idblueToothViewMain.forceActiveFocus()
        }
        else
        {
            sspOnButton.forceActiveFocus()
        }


    }
    Text {
        id: idsspOnOffTxt
        text: "SSP ON / OFF"
        x: 10; y: 20;
        width:200; height:70
        font.pixelSize: 25; color:colorInfo.brightGrey
        visible : (isMapCareMain) ? false : true
    }

        MComp.MButton {
            id :sspOnButton
            x: 220; y: 0
            width:130; height:70
            focus: true
            firstText: "On"
            firstTextX: 40
            firstTextY: 20/*40*/
            firstTextWidth: 150
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 25
            firstTextStyle: "HDB"
            visible : (isMapCareMain) ? false : true

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            bgImageActive:imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                backFocus.forceActiveFocus()
                softwareBand
            }
            onWheelRightKeyPressed: sspOffButton.forceActiveFocus()

            onClickOrKeySelected: {
                sspOnButton.forceActiveFocus()
                sendBTRequest.SetSSPOnOff(1);
            }
        }
        MComp.MButton {
            id :sspOffButton
            x: 360; y: 0
            width:130; height:70
            focus: true
            firstText: "Off"
            firstTextX: 40
            firstTextY: 20/*40*/
            firstTextWidth: 150
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 25
            firstTextStyle: "HDB"
            visible : (isMapCareMain) ? false : true

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            bgImageActive:imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                backFocus.forceActiveFocus()
                softwareBand
            }
            onWheelLeftKeyPressed: sspOnButton.forceActiveFocus()
            onWheelRightKeyPressed: btModuleResetButton.forceActiveFocus()

            onClickOrKeySelected: {
                sspOffButton.forceActiveFocus();
                sendBTRequest.SetSSPOnOff(0);
            }
        }
        Image{
            x:10
            y:75
            width: systemInfo.lcdWidth-750
            source: imgFolderGeneral+"line_menu_list.png"
            visible : (isMapCareMain) ? false : true
        }

        Text {
            id: idBtModuleReset
            text: "BT Module Reset"
            x: 10; y: 100;
            width:200; height:70
            font.pixelSize: 25; color:colorInfo.brightGrey
            visible : (isMapCareMain) ? false : true
        }
        MComp.MButton {
            id :btModuleResetButton
            x: 360; y: 90
            width:130; height:70
            focus: true
            firstText: "Reset"
            firstTextX: 20
            firstTextY: 20/*40*/
            firstTextWidth: 150
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 25
            firstTextStyle: "HDB"
            visible : (isMapCareMain) ? false : true

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            bgImageActive:imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            //fgImageActive: ""
            KeyNavigation.up:{
                backFocus.forceActiveFocus()
                softwareBand
            }

            //KeyNavigation.down: idblueToothViewMain.forceActiveFocus()
            onWheelLeftKeyPressed: sspOffButton.forceActiveFocus()
            onWheelRightKeyPressed: dutOnButton.forceActiveFocus()

            onClickOrKeySelected: {
                btModuleResetButton.forceActiveFocus();
                sendBTRequest.ReqBTModuleReset();
            }
        }
        Image{
            x:10
            y:165
            width: systemInfo.lcdWidth-750
            source: imgFolderGeneral+"line_menu_list.png"
            visible : (isMapCareMain) ? false : true
        }
        Text {
            id: idDutOnOffTxt
            text: "DUT ON / OFF"
            x: 10; y: 190;
            width:200; height:70
            font.pixelSize: 25; color:colorInfo.brightGrey
            visible : (isMapCareMain) ? false : true
        }

        MComp.MButton {
            id :dutOnButton
            x: 220; y: 180
            width:130; height:70
            focus: true
            firstText: "On"
            firstTextX: 40
            firstTextY: 20/*40*/
            firstTextWidth: 150
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 25
            firstTextStyle: "HDB"
            visible : (isMapCareMain) ? false : true

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            bgImageActive:imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                backFocus.forceActiveFocus()
                softwareBand
            }
            onWheelLeftKeyPressed: btModuleResetButton.forceActiveFocus()
            onWheelRightKeyPressed: dutOffButton.forceActiveFocus()

            onClickOrKeySelected: {
                dutOnButton.forceActiveFocus()
                sendBTRequest.SetDutOnOff(1);
            }
        }
        MComp.MButton {
            id :dutOffButton
            x: 360; y: 180
            width:130; height:70
            focus: true
            firstText: "Off"
            firstTextX: 40
            firstTextY: 20/*40*/
            firstTextWidth: 150
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 25
            firstTextStyle: "HDB"
            visible : (isMapCareMain) ? false : true

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            bgImageActive:imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                backFocus.forceActiveFocus()
                softwareBand
            }
            KeyNavigation.down: idblueToothViewMain.forceActiveFocus()
            onWheelLeftKeyPressed: dutOnButton.forceActiveFocus()
            onWheelRightKeyPressed: idblueToothViewMain.forceActiveFocus()

            onClickOrKeySelected: {
                dutOffButton.forceActiveFocus()
                sendBTRequest.SetDutOnOff(0);
            }
        }
        Image{
            x:10
            y:165 + 90
            width: systemInfo.lcdWidth-750
            source: imgFolderGeneral+"line_menu_list.png"
            visible : (isMapCareMain) ? false : true
        }
        FocusScope{

        id: idblueToothViewMain
        x: 0; y: (isMapCareMain) ? 0 : 90 + 90 + 90
        width: systemInfo.lcdWidth

        height:(isMapCareMain) ? systemInfo.lcdHeight : systemInfo.lcdHeight-166 - 90 - 90 - 90

        focus: true


            ListModel{
                id:bluetoothData
                ListElement {   name:"Fw Version" ; }
                //ListElement {   name:"SW Controller Ver" ;   }
                ListElement {   name:"SW Version" ; }
                ListElement {   name:"Status" ; }
                ListElement {   name:"Profile : GAP ";}
                ListElement {   name:"Profile : HFP ";}
                ListElement {   name:"Profile : PBAP ";}
                ListElement {   name:"Profile : AVRCP ";}
                ListElement {   name:"Profile : A2DP ";}
                ListElement {   name:"Profile : SPP ";}

            }
            ListView{

                id:idBluetoothView
                //opacity : 1
                clip: true
                focus: true
                anchors.fill: parent;
                model: bluetoothData
                delegate: Engineer_SoftwareBlueDelegate{
                    onWheelLeftKeyPressed:idBluetoothView.decrementCurrentIndex()
                    onWheelRightKeyPressed:idBluetoothView.incrementCurrentIndex()
                }
                orientation : ListView.Vertical
                snapMode: ListView.SnapToItem
                cacheBuffer: 10000
                highlightMoveSpeed: 99999
                boundsBehavior: Flickable.StopAtBounds

            }
        }
        //--------------------- ScrollBar #
        MComp.MScroll {
            property int  scrollWidth: 13
            property int  scrollY: 5
            x:systemInfo.lcdWidth-708 -30;
            y: (isMapCareMain) ? 0 : 180 + 90;
            z:1
            scrollArea: idBluetoothView;
            height: idBluetoothView.height-(scrollY*2)-8; width: scrollWidth

            visible: true
        } //# End MScroll



    }

