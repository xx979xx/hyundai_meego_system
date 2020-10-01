import QtQuick 1.1
import AppEngineQMLConstants 1.0
import "../system" as MSystem

FocusScope {
    id: menuItem_rearInit
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
                        idUpLongKeyRVTimer.start();
                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_RELEASED) {
                        //console.log("JOG_UP, KEY_STATUS_RELEASED:");
                        if (upKeyLongPressed) {
                            idUpLongKeyRVTimer.stop();
                            upKeyLongPressed = false;
                        }
                        else {
                            backFocus.forceActiveFocus();
                            idModeArea
                        }
                    }
                    else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        if (upKeyLongPressed) {
                            idUpLongKeyRVTimer.stop();
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
                        idDownLongKeyRVTimer.start();
                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_RELEASED) {
                        //console.log("JOG_DOWN, KEY_STATUS_RELEASED:");
                        if (downKeyLongPressed) {
                            idDownLongKeyRVTimer.stop();
                            downKeyLongPressed = false;
                        }
                    }
                    else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        if (downKeyLongPressed) {
                            idDownLongKeyRVTimer.stop();
                            downKeyLongPressed = false;
                        }
                    }
                }
                break;
            }
        }
    } // End Connections

    Timer {
        id: idUpLongKeyRVTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            //console.debug("---------- idUpLongKeyRVTimer onTriggered, listView_rearInit.currentIndex:" + listView_rearInit.currentIndex)
             if(listView_rearInit.currentIndex != 0) listView_rearInit.currentIndex--;
             else idUpLongKeyRVTimer.stop;
        }
        //triggeredOnStart: true
    }
    Timer {
        id: idDownLongKeyRVTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            //console.debug("---------- idDownLongKeyRVTimer onTriggered, listView_rearInit.currentIndex:" + listView_rearInit.currentIndex)
             if(listView_rearInit.currentIndex != listView_rearInit.count-1) listView_rearInit.currentIndex++;
             else idDownLongKeyRVTimer.stop;
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
        id: listModel_rearInit

        Component.onCompleted:{
            listModel_rearInit.append({name: QT_TR_NOOP("STR_CAMERA_SETFVIEW1")}) //STR_CAMERA_SETRVIEW5 is same string.
            listModel_rearInit.append({name: QT_TR_NOOP("STR_CAMERA_SETRVIEW8")})
            listModel_rearInit.append({name: QT_TR_NOOP("STR_CAMERA_SETRVIEW6")})
            listModel_rearInit.append({name: QT_TR_NOOP("STR_CAMERA_SETRVIEW7")})

            //listView_rearInit.currentIndex = 0;
        }
    }

    Component {
        id: listDelegate_rearInit

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
                        else if (index==1) systemInfo.imageInternal+"ico_car_view_06.png"
                        else if (index==2) systemInfo.imageInternal+"ico_car_view_08.png"
                        else if (index==3) systemInfo.imageInternal+"ico_car_view_07.png"
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    width: 25; height: parent.height
                }

                //init view mode text
                MText {
                    text: qsTranslate("StringInfo", listView_rearInit.model.get(index).name) + LocTrigger.empty
                    width: 345
                    font.pointSize : systemInfo.normalFontSize
                    //font.pointSize : (cppToqml.IsPolishForSetView)? systemInfo.listNumberFontSize : systemInfo.normalFontSize
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    width: 10; height: parent.height
                }

                // radio button image
                Image {
                    source: {
                        if (index==0) (canDB.AVM_RearView_Option==1)? systemInfo.imageInternal+"ico_radio_s.png" : systemInfo.imageInternal+"ico_radio_n.png"
                        else if (index==1) (canDB.AVM_RearView_Option==4)? systemInfo.imageInternal+"ico_radio_s.png" : systemInfo.imageInternal+"ico_radio_n.png"
                        else if (index==2) (canDB.AVM_RearView_Option==2)? systemInfo.imageInternal+"ico_radio_s.png" : systemInfo.imageInternal+"ico_radio_n.png"
                        else if (index==3) (canDB.AVM_RearView_Option==3)? systemInfo.imageInternal+"ico_radio_s.png" : systemInfo.imageInternal+"ico_radio_n.png"
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
                //console.log("rearInit:: onClickOrKeySelected menu list -> index:"+ index);
                listView_rearInit.currentIndex = index;
                if (index==0) canCon.changeAVMViewSettings(7);
                else if (index==1) canCon.changeAVMViewSettings(6);
                else if (index==2) canCon.changeAVMViewSettings(5);
                else if (index==3) canCon.changeAVMViewSettings(4);
            }

            KeyNavigation.up: listView_rearInit
            KeyNavigation.down: listView_rearInit

            onWheelLeftKeyPressed: {
                (cppToqml.IsArab)? listView_rearInit.incrementCurrentIndex() : listView_rearInit.decrementCurrentIndex()
            }
            onWheelRightKeyPressed: {
                (cppToqml.IsArab)? listView_rearInit.decrementCurrentIndex() : listView_rearInit.incrementCurrentIndex()
            }

        } // End MButton

    } //End list Delegate

    ListView {
        id: listView_rearInit
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

        model: listModel_rearInit
        delegate: listDelegate_rearInit
        clip: true
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000

        onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

        onActiveFocusChanged: {
            //if (activeFocus) console.log("listView_rearInit got activeFocus!!");
            //if (!activeFocus) {
                //console.log("listView_rearInit lost activeFocus...");
                if (canDB.AVM_RearView_Option==1) listView_rearInit.currentIndex = 1;
                else listView_rearInit.currentIndex = 0;
            //}
        }
    }


}
