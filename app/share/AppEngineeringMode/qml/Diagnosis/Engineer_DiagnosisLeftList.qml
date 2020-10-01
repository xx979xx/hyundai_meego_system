import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idDiagnosisLeftMenu
    x:0; y: systemInfo.bandHeight
    clip:true
    focus:true
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property alias menuList: idMenuListView

    onVisibleChanged:
    {
        //idMenuListView.currentIndex = 0;
    }


    ListModel{
        id:diagnosisModel
        ListElement {   name:"DTC" ; subname:""; check:"off"; gridId:0  }
        ListElement {   name:"MOST" ; subname:""; check:"off";gridId:1  }
        ListElement {   name:"Command" ; subname:""; check:"off"; gridId:2  }
        ListElement {   name:"HU" ; subname:""; check:"off" ; gridId:3 }
    }
    ListModel{
        id: mapcareDiagnosisModel
        ListElement {   name:"MOST" ; subname:""; check:"off";gridId:0  }
        ListElement {   name:"Service Code" ; subname:""; check:"off"; gridId:1  }
        ListElement {   name:"Factory Reset Command" ; subname:""; check:"off"; gridId:2  }
    }

    ListView{
        id:idMenuListView
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: (isMapCareMain == true) ? mapcareDiagnosisModel: diagnosisModel
        delegate: Engineer_DiagnosisLeftDelegate{
            id:idDiagnosisdelegate
            onWheelLeftKeyPressed:idMenuListView.decrementCurrentIndex()
            onWheelRightKeyPressed:idMenuListView.incrementCurrentIndex()
        }
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        interactive: false

    }



}
