import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idLogDataLoader
    x:-1; y:261-89-166+5
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea

    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
        amosOnButton.forceActiveFocus();
    }
    Text {
        id: idAmosEnableOnOff
        text: "AMOS  ON/OFF"
        x: 10; y: 20;
        width:200; height:70
        font.pixelSize: 25; color:colorInfo.brightGrey
    }


    MComp.MButtonTouch {
        id :amosOnButton
        x: 220; y: 0
        width:130; height:70
        focus: true
        firstText: "On"
        firstTextX: 40
        firstTextY: 40
        firstTextWidth: 150
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""
        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            systemConfigBand
        }
        //KeyNavigation.left:sspOnButton
        KeyNavigation.down: idlogDataMain.forceActiveFocus()

        onWheelLeftKeyPressed: amosOffButton.forceActiveFocus()
        onWheelRightKeyPressed: amosOffButton.forceActiveFocus()

      onClickOrKeySelected: {
          amosOnButton.forceActiveFocus()
            UIListener.amosUxlaunchEnDisable(true);
        }
    }
    MComp.MButtonTouch {
        id :amosOffButton
        x: 360; y: 0
        width:130; height:70
        focus: true
        firstText: "Off"
        firstTextX: 40
        firstTextY: 40
        firstTextWidth: 150
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
       fgImage: ""
       fgImageActive: ""
        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            systemConfigBand
        }
        KeyNavigation.left:amosOnButton
        KeyNavigation.down: idlogDataMain.forceActiveFocus()

        onWheelLeftKeyPressed: amosOnButton.forceActiveFocus()
        onWheelRightKeyPressed: idlogDataMain.forceActiveFocus()

      onClickOrKeySelected: {
          amosOffButton.forceActiveFocus()
            UIListener.amosUxlaunchEnDisable(false);
        }
    }
    Image{
        x:10
        y:75
        width: systemInfo.lcdWidth-750
        source: imgFolderGeneral+"line_menu_list.png"
    }
    FocusScope{

        id: idlogDataMain
        x: 0; y: 90
        width: systemInfo.lcdWidth
//        height: systemInfo.subMainHeight - y
        height:systemInfo.lcdHeight-166 - 90

        focus: true


        ListModel{
            id:headunitData
            ListElement{ name:"AMOS"    }
            ListElement {   name:"Blueetooth"   }
            ListElement {   name:   "XM"    }
        }
        ListView{
            id:idHeadUnitView
            opacity : 1
            clip: true
            focus: true

            anchors.fill: parent;
            model: headunitData
            delegate: Engineer_SystemConfigRightDelegateReception{
                onWheelLeftKeyPressed:idHeadUnitView.decrementCurrentIndex()
                onWheelRightKeyPressed:idHeadUnitView.incrementCurrentIndex()

            }
            orientation : ListView.Vertical
            snapMode: ListView.SnapToItem
            cacheBuffer: 10000
            highlightMoveSpeed: 9999999
            boundsBehavior: Flickable.StopAtBounds

        }
    }




}

