import QtQuick 1.1
import AppEngineQMLConstants 1.0
import "../system" as MSystem

FocusScope {
    id: menuItem_frontInit
    x:0; y:0
    MSystem.SystemInfo { id:systemInfo }
    MSystem.ColorInfo { id:colorInfo }
    MSystem.StringInfo {id:stringInfo}

    focus: true

    property int btnWidth : systemInfo.righMenuItemButtonWidth
    property int rowSpace : 0
    property int offsetForLine : 2

    width: btnWidth+30; height:systemInfo.righMenuItemButtonHeight*4//systemInfo.lcdHeight-systemInfo.statusBarHeight-systemInfo.modeAreaHeight

    property bool upKeyLongPressed : false
    property bool downKeyLongPressed : false

    Connections {
        target: UIListener

        onSignalJogNavigation:
        {
            //console.log("onSignalJogNavigation -> arrow:"+ arrow);
            switch( arrow )
            {
                case UIListenerEnum.JOG_UP:
                {
                    //console.log("JOG_UP, status:"+ status);
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED) {
                        //console.log("JOG_UP, KEY_STATUS_PRESSED:");

                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED) {
                        //console.log("JOG_UP, KEY_STATUS_LONG_PRESSED:");
                        upKeyLongPressed = true;
                        idUpLongKeyFVTimer.start();
                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_RELEASED) {
                        //console.log("JOG_UP, KEY_STATUS_RELEASED:");
                        if (upKeyLongPressed) {
                            idUpLongKeyFVTimer.stop();
                            upKeyLongPressed = false;
                        }
                        else {
                            backFocus.forceActiveFocus();
                            idModeArea
                        }
                    }
                    else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        if (upKeyLongPressed) {
                            idUpLongKeyFVTimer.stop();
                            upKeyLongPressed = false;
                        }
                    }
                }
                break;
                case UIListenerEnum.JOG_DOWN:
                {
                    //console.log("JOG_DOWN, status:"+ status);
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED) {
                        //console.log("JOG_DOWN, KEY_STATUS_PRESSED:");
                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED) {
                        //console.log("JOG_DOWN, KEY_STATUS_LONG_PRESSED:");
                        downKeyLongPressed = true;
                        idDownLongKeyFVTimer.start();
                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_RELEASED) {
                        //console.log("JOG_DOWN, KEY_STATUS_RELEASED:");
                        if (downKeyLongPressed) {
                            idDownLongKeyFVTimer.stop();
                            downKeyLongPressed = false;
                        }
                    }
                    else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        if (downKeyLongPressed) {
                            idDownLongKeyFVTimer.stop();
                            downKeyLongPressed = false;
                        }
                    }
                }
                break;
            }
        }
    } // End Connections

    Timer {
        id: idUpLongKeyFVTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            //console.debug("---------- idUpLongKeyFVTimer onTriggered, listView_frontInit.currentIndex:" + listView_frontInit.currentIndex)
             if(listView_frontInit.currentIndex != 0) listView_frontInit.currentIndex--;
             else idUpLongKeyFVTimer.stop;
        }
        //triggeredOnStart: true
    }
    Timer {
        id: idDownLongKeyFVTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            //console.debug("---------- idDownLongKeyFVTimer onTriggered, listView_frontInit.currentIndex:" + listView_frontInit.currentIndex)
             if(listView_frontInit.currentIndex != listView_frontInit.count-1) listView_frontInit.currentIndex++;
             else idDownLongKeyFVTimer.stop;
        }
        //triggeredOnStart: true
    }

    Component.onCompleted: {
        //For AutoTest
        UIListener.SendAutoTestSignal()
    }

    onVisibleChanged: {
        if (visible) z = 1
        else z = 0;
    }

    ListModel {
        id: listModel_frontInit

        Component.onCompleted:{
            listModel_frontInit.append({name: QT_TR_NOOP("STR_CAMERA_SETFVIEW1")})
            listModel_frontInit.append({name: QT_TR_NOOP("STR_CAMERA_SETFVIEW4")})
            listModel_frontInit.append({name: QT_TR_NOOP("STR_CAMERA_SETFVIEW2")})
            listModel_frontInit.append({name: QT_TR_NOOP("STR_CAMERA_SETFVIEW3")})

            //listView_frontInit.currentIndex = 0;
        }
    }

    Component {
        id: listDelegate_frontInit

        MButton {
            height: systemInfo.righMenuItemButtonHeight
            width: btnWidth
            bgImagePress: systemInfo.imageInternal+"bg_menu_tab_r_p.png"
            bgImageActive: bgImagePress
            bgImageFocus: systemInfo.imageInternal+"bg_menu_tab_r_f.png"

            Row {
                z:3
                anchors.verticalCenter: parent.verticalCenter
                spacing: rowSpace
                layoutDirection: (cppToqml.IsArab)? Qt.RightToLeft : Qt.LeftToRight

                Item {
                    width: 10; height: parent.height
                }

                // ico_car_view
                Image {
                    source: {
                        if (index==0) systemInfo.imageInternal+"ico_car_view_01.png"
                        else if (index==1) systemInfo.imageInternal+"ico_car_view_04.png"
                        else if (index==2) systemInfo.imageInternal+"ico_car_view_02.png"
                        else if (index==3) systemInfo.imageInternal+"ico_car_view_03.png"
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    width: 25; height: parent.height
                }

                //init view mode text
                MText {
                    text: qsTranslate("StringInfo", listView_frontInit.model.get(index).name) + LocTrigger.empty
                    width: 345
                    font.pointSize : (cppToqml.IsPolishForSetView)? systemInfo.listNumberFontSize : systemInfo.normalFontSize
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    width: 10; height: parent.height
                }

                // radio button image
                Image {
                    source: {
                        if (index==0) (canDB.AVM_FrontView_Option==1)? systemInfo.imageInternal+"ico_radio_s.png" : systemInfo.imageInternal+"ico_radio_n.png"
                        else if (index==1) (canDB.AVM_FrontView_Option==4)? systemInfo.imageInternal+"ico_radio_s.png" : systemInfo.imageInternal+"ico_radio_n.png"
                        else if (index==2) (canDB.AVM_FrontView_Option==2)? systemInfo.imageInternal+"ico_radio_s.png" : systemInfo.imageInternal+"ico_radio_n.png"
                        else if (index==3) (canDB.AVM_FrontView_Option==3)? systemInfo.imageInternal+"ico_radio_s.png" : systemInfo.imageInternal+"ico_radio_n.png"
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    width: 45; height: 45
                }

                Item {
                    width: 10; height: parent.height
                }
            }

            // line_menu_list.png
            Image {
                y:parent.height-offsetForLine
                anchors.horizontalCenter: parent.horizontalCenter
                source: systemInfo.imageInternal+"line_menu_list.png"
                height: 3; width: parent.width-20
            }

            onClickOrKeySelected: {
                //console.log("frontInit:: onClickOrKeySelected menu list -> index:"+ index);
                listView_frontInit.currentIndex = index;
                if (index==0) canCon.changeAVMViewSettings(3);
                else if (index==1) canCon.changeAVMViewSettings(2);
                else if (index==2) canCon.changeAVMViewSettings(1);
                else if (index==3) canCon.changeAVMViewSettings(0);
            }

            KeyNavigation.up: listView_frontInit
            KeyNavigation.down: listView_frontInit

            onWheelLeftKeyPressed: {
                (cppToqml.IsArab)? listView_frontInit.incrementCurrentIndex() : listView_frontInit.decrementCurrentIndex()
            }
            onWheelRightKeyPressed: {
                (cppToqml.IsArab)? listView_frontInit.decrementCurrentIndex() : listView_frontInit.incrementCurrentIndex()
            }

        } // End MButton

    } //End list Delegate

    ListView {
        id: listView_frontInit
        focus: true
        //spacing: -7

        anchors.top: parent.top
        anchors.topMargin: 0//3
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.leftMargin: (cppToqml.IsArab)? 30 : 10
        anchors.rightMargin: 0//(cppToqml.IsArab)? 10 : 0

        interactive: true
        boundsBehavior: Flickable.DragAndOvershootBounds

        model: listModel_frontInit
        delegate: listDelegate_frontInit
        clip: true
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000

        onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

        onActiveFocusChanged: {
            //if (activeFocus) console.log("listView_frontInit got activeFocus!!");
            //if (!activeFocus) {
                //console.log("listView_frontInit lost activeFocus...");
                if (canDB.AVM_FrontView_Option==1) listView_frontInit.currentIndex = 1;
                else listView_frontInit.currentIndex = 0;
            //}
        }

    }

}
