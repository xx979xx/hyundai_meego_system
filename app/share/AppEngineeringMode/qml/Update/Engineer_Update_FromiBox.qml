import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idUpdateiBoxLoader
    x:-1; y:261-89-166+5
    z:300
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
     property string imgFolderGeneral: imageInfo.imgFolderGeneral

    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
    }

    ListModel{
        id:updateiboxDate
        ListElement {   name:"Navi Program" ; }
        ListElement {   name:"Navi Map" ;   }
        ListElement {   name:"Update iBox" ; }


    }
    ListView{
        id:idUpdateView
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: updateiboxDate
        delegate: Engineer_UpdateIBOXDelegate{
            onWheelLeftKeyPressed:idUpdateView.decrementCurrentIndex()
            onWheelRightKeyPressed:idUpdateView.incrementCurrentIndex()
        }
        orientation : ListView.Vertical
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000
        highlightMoveSpeed: 9999999
        boundsBehavior: Flickable.StopAtBounds

    }

  }

