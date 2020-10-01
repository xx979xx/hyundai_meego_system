import Qt 4.7
import "../System" as MSystem
import "../Component" as MComp

MComp.MComponent {
    id:idDTCListView
    //    x: 18; y:200
    width: 1200; height: 90*6
    focus: true

    ListView{
        id: idDTCTitleList
        width: parent.width
        anchors.fill: parent
        model: DTCListCodeModel
        delegate: DTCTitleDelegate{}
        focus: true

    }

}

