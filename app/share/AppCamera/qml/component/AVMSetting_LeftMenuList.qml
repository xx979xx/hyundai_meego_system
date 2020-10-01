import QtQuick 1.1
import "../system" as MSystem

MCompoForListView {
    id: leftMenuMain
    x:0; y: systemInfo.bandHeight
    clip:true
    lCount: 3
    focus:false
    enableClick: false;
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }

    property int selectedIndex: 0

    Component.onCompleted: {
        //For AutoTest
        UIListener.SendAutoTestSignal()
    }

    Timer {
        id: rightMenuChangeTimer
        interval: 200
        running: false
        repeat: false
        onTriggered: {
            //console.log("onTriggered----------!!, selectedIndex:" + selectedIndex);
            changeRightMenuNow()
            //console.log("--------------------------end onTriggered-");
        }
    }

    function changeRightMenuNow() {
        //console.log("changeRightMenuNow....listView.currentIndex:" + listView.currentIndex + ", selectedIndex:" + selectedIndex);
        setRightMenuScreen(selectedIndex, true);
    }

    ListModel {
        id: listModel

        Component.onCompleted:{
            listModel.append({name: QT_TR_NOOP("STR_CAMERA_SETTAP1"), bold: false})
            listModel.append({name: QT_TR_NOOP("STR_CAMERA_SETTAP2"), bold: false})
            listModel.append({name: QT_TR_NOOP("STR_CAMERA_SETTAP3"), bold: false})

            listView.currentIndex = 0;
            listView.currentItem.forceActiveFocus();
        }
    }

    Component {
        id: listDelegate

        MButton {
            width: 537; height:89
            bgImagePress: systemInfo.imageInternal+"bg_menu_tab_l_p.png"
            bgImageFocus: systemInfo.imageInternal+"bg_menu_tab_l_f.png"
            firstText : qsTranslate("StringInfo", listView.model.get(index).name) + LocTrigger.empty
            firstTextX : 20
            firstTextY : 0
            firstTextColor: (listView.model.get(index).bold)? colorInfo.selected : colorInfo.brightGrey
            firstTextSize: systemInfo.normalFontSize
            firstTextStyle: (listView.model.get(index).bold)? stringInfo.fontName : stringInfo.fontNameSetting
            firstTextPressStyle: stringInfo.fontNameSetting
            firstTextWidth: 490+12
            firstTextAlies: {
                if(cppToqml.IsArab) {"Right"}
                else {"Left"}
            }

            Image {
                anchors.bottom: parent.bottom
                height:3
                source: systemInfo.imageInternal+"line_menu_list.png"
            }

            onClickOrKeySelected: {
                rightMenuChangeTimer.stop();
                listView.currentIndex = index;
                selectedIndex = index;
                changeRightMenuNow();
                changeRightMenuFocus(index);
            }

            Keys.onRightPressed:{
                if (!cppToqml.IsArab) {
                    rightMenuChangeTimer.stop();
                    listView.currentIndex = index;
                    selectedIndex = index;
                    changeRightMenuNow();
                    changeRightMenuFocus(index);
                    idVisualCue.arrowMode = 2;
                }
            }

            Keys.onLeftPressed:{
                if (cppToqml.IsArab) {
                    rightMenuChangeTimer.stop();
                    listView.currentIndex = index;
                    selectedIndex = index;
                    changeRightMenuNow();
                    changeRightMenuFocus(index);
                    idVisualCue.arrowMode = 1;
                }
            }

            KeyNavigation.up: listView
            KeyNavigation.down: listView

            onWheelLeftKeyPressed: {
                if (cppToqml.IsArab) {
                    listView.incrementCurrentIndex()
                    if(index!=2) selectedIndex = index+1;
                }
                else {
                    listView.decrementCurrentIndex()
                    if(index!=0) selectedIndex = index-1;
                }
                rightMenuChangeTimer.start();
            }
            onWheelRightKeyPressed: {
                if (cppToqml.IsArab) {
                    listView.decrementCurrentIndex()
                    if(index!=0) selectedIndex = index-1;
                }
                else {
                    listView.incrementCurrentIndex()
                    if(index!=2) selectedIndex = index+1;
                }
                rightMenuChangeTimer.start();
            }

        }

    }

    ListView {
        id: listView
        focus: false
        spacing: -3

        anchors.top: parent.top
        anchors.topMargin: 0
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

        onCurrentIndexChanged: {
            positionViewAtIndex(currentIndex, ListView.Contain);
            selectedIndex = currentIndex;
            changeRightMenuNow();
        }

        onActiveFocusChanged: {
            if (activeFocus) {
                //console.log("listView got activeFocus!!");
                if(listView.currentIndex>-1) listModel.setProperty(listView.currentIndex, "bold", false);
            }
            else {
                //console.log("listView lost activeFocus...");
                if(listView.currentIndex>-1) listModel.setProperty(listView.currentIndex, "bold", true);
            }
        }


    }

}
