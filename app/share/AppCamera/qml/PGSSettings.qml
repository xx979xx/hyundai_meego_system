import QtQuick 1.1

import QmlStatusBar 1.0

import "system" as MSystem
import "component" as MComp
import "system/operation.js" as MOp

FocusScope {
    MSystem.SystemInfo { id:systemInfo }
    MSystem.ColorInfo { id:colorInfo }
    MSystem.StringInfo {id:stringInfo}

    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight

    //New StatusBar Test
    QmlStatusBar {
        id: statusBar
        x:0; y:0
        width: systemInfo.lcdWidth; height: systemInfo.statusBarHeight
        homeType: "none"
        middleEast: (cppToqml.IsArab)? true : false
        z: 10
    }

    MComp.MCompoForListView {
        id: idPGSSettingMain
        x:0; y: systemInfo.statusBarHeight
        width: systemInfo.lcdWidth; height: systemInfo.lcdHeight - systemInfo.statusBarHeight
        enableClick: false;
        focus: true
        lCount: (canDB.IsDisplayGuideLine)? 3 : 2

        property alias backFocus: idModeArea.backKeyButton

        Image {
            id: bgImg
            x: 0; y: 0
            width: systemInfo.lcdWidth; height: systemInfo.lcdHeight-systemInfo.statusBarHeight
            source: systemInfo.imageInternal+"bg_main.png"
        }

        MComp.MBand{
            id: idModeArea
            x: 0; y: 0//systemInfo.statusBarHeight
            z: 10
            titleText: stringInfo.setModeAreaTxt
            onBackKeyClicked: {
                canCon.changePGSMenu(8); //send "previous" signal to PGS module
                bISGoToMainWithBG = false;
            }

            KeyNavigation.down: listView
        }

        Component.onCompleted:{
            //console.log("idPGSSettingMain Component.onCompleted: -> listModel.count:"+ listModel.count);
            //For AutoTest
            UIListener.SendAutoTestSignal()
        }

        ListModel {
            id: listModel

            Component.onCompleted:{
                listModel.append({name: QT_TR_NOOP("STR_CAMERA_PGSSETMENU1")})
                listModel.append({name: QT_TR_NOOP("STR_CAMERA_PGSSETMENU2")})
                listModel.append({name: QT_TR_NOOP("STR_CAMERA_PGSSETMENU3")})
                listView.currentIndex = 0;
                listView.currentItem.forceActiveFocus();
            }
        }

        Component {
            id: listDelegate

            MComp.MButton {
                height: 90; width: systemInfo.lcdWidth
                bgImagePress: systemInfo.imageInternal+"list_p.png"
                bgImageActive: systemInfo.imageInternal+"list_p.png"
                bgImageFocus: systemInfo.imageInternal+"list_f.png"

                enableClick: {
                    if (index==2) { (canDB.IsDisplayGuideLine)? true : false}
                    else { true }
                }

                MComp.CheckItem {
                    width: parent.width// - 50
                    anchors.verticalCenter: parent.verticalCenter
                    y:0; x:10
                    txt: qsTranslate("StringInfo", listView.model.get(index).name) + LocTrigger.empty
                    txtLeftMargin : 102;
                    txtAreaWidth: 1074
                    isChecked: {
                        if (index==0) canDB.IsVRParkingGuide ? true: false
                        else if (index==1) canDB.IsDisplayGuideLine ? true: false
                        else if (index==2) canDB.IsEnableGuideLineAngle ? true: false
                    }

                    state: {
                        if (index==2) canDB.IsDisplayGuideLine ? "normal": "dimmed"
                    }
                }

                Image{
                    anchors.bottom: parent.bottom
                    height: 3; width: idPGSSettingMain.width-20
                    source: systemInfo.imageInternal+ "line_menu_list.png"
                }

                onClickOrKeySelected: {
                    //console.log("onClickOrKeySelected menu list -> index:"+ index);
                    listView.currentIndex = index;
                    canCon.changePGSSet(index+1);
                }

                KeyNavigation.up: listView
                KeyNavigation.down: listView

                onWheelLeftKeyPressed: {
                    //console.log("onWheelLeftKeyPressed menu list -> index:"+ index);
                    if (cppToqml.IsArab) {
                        if (index==1) { if (canDB.IsDisplayGuideLine) listView.incrementCurrentIndex()}
                        else {
                            listView.incrementCurrentIndex()
                        }
                    }
                    else { listView.decrementCurrentIndex() }
                }
                onWheelRightKeyPressed: {
                    //console.log("onWheelRightKeyPressed menu list -> index:"+ index);
                    if (cppToqml.IsArab) { listView.decrementCurrentIndex() }
                    else {
                        if (index==1) { if (canDB.IsDisplayGuideLine) listView.incrementCurrentIndex()}
                        else {
                            listView.incrementCurrentIndex()
                        }
                    }
                }

            }
        }

        ListView {
            id: listView
            focus: true
            spacing: -3

            anchors.top: parent.top
            anchors.topMargin: systemInfo.modeAreaHeight-4//+systemInfo.statusBarHeight-4
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            interactive: true
            boundsBehavior: Flickable.DragAndOvershootBounds

            model: listModel
            delegate: listDelegate
            clip: true
            snapMode: ListView.SnapToItem
            cacheBuffer: 10000

            onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)
        }

        onBackKeyPressed: {
            //console.log("A back key is pressed..");
            canCon.changePGSMenu(8); //send 'previous' signal
            bISGoToMainWithBG = false;
        }

    }

}
