import QtQuick 1.1
import "../system" as MSystem

MCompoForListView {
    id: menuItem
    x:0; y:0
    MSystem.SystemInfo { id:systemInfo }
    MSystem.ColorInfo { id:colorInfo }
    MSystem.StringInfo {id:stringInfo}
    lCount: 2
    focus: true
    enableClick: false;
    width:538
    height:systemInfo.lcdHeight-systemInfo.statusBarHeight-systemInfo.modeAreaHeight

    Component.onCompleted: {
        //For AutoTest
        UIListener.SendAutoTestSignal()
    }

    onVisibleChanged: {
        if (visible) z = 1
        else z = 0;
    }

    ListModel {
        id: listModel_general

        Component.onCompleted:{
            listModel_general.append({name: QT_TR_NOOP("STR_CAMERA_PGSSETMENU2")})
            listModel_general.append({name: QT_TR_NOOP("STR_CAMERA_SETMENU2")})

            listView.currentIndex = 0;
        }
    }

    Component {
        id: listDelegate_general

        MButton {
            height: 90; width: menuItem.width-10
            bgImagePress: systemInfo.imageInternal+"bg_menu_tab_r_p.png"
            bgImageActive: systemInfo.imageInternal+"bg_menu_tab_r_p.png"
            bgImageFocus: systemInfo.imageInternal+"bg_menu_tab_r_f.png"

            CheckItem {
                anchors.verticalCenter: parent.verticalCenter
                txtAreaWidth : 450
                txtLeftMargin : 20
                txt: (cppToqml.Is1LineLang)? qsTranslate("StringInfo", listView.model.get(index).name) + LocTrigger.empty : "<div style=\"line-height:80%\">"+qsTranslate("StringInfo", listView.model.get(index).name) + LocTrigger.empty+"</div>"
                txtFontSize: (cppToqml.Is1LineLang)? systemInfo.normalFontSize : systemInfo.listNumberFontSize
                isChecked: {
                    if (index==0) canDB.IsAngleInterwork ? true: false
                    else if (index==1) canDB.IsDisplayObstacle ? true: false
                }
            }

            Image{
                anchors.bottom: parent.bottom
                height: 3; width: menuItem.width-20
                source: systemInfo.imageInternal+ "line_menu_list.png"
            }

            onClickOrKeySelected: {
                listView.currentIndex = index;
                canCon.changeAVMGeneralSet(index+1);
            }

            KeyNavigation.up: listView
            KeyNavigation.down: listView

            onWheelLeftKeyPressed: {
                (cppToqml.IsArab)? listView.incrementCurrentIndex() : listView.decrementCurrentIndex()
            }
            onWheelRightKeyPressed: {
                (cppToqml.IsArab)? listView.decrementCurrentIndex() : listView.incrementCurrentIndex()
            }
        }
    }

    ListView {
        id: listView
        focus: true
        spacing: -3

        anchors.top: parent.top
        anchors.topMargin: 3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right

        interactive: true
        boundsBehavior: Flickable.DragAndOvershootBounds

        model: listModel_general
        delegate: listDelegate_general
        clip: true
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000

        onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

        onActiveFocusChanged: {
            //if (activeFocus) console.log("listView got activeFocus!!");
            if (!activeFocus) {
                //console.log("listView lost activeFocus...");
                listView.currentIndex = 0;
            }
        }

    }

}
