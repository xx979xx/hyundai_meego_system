import Qt 4.7

FocusScope {
    id: xm_tagginglist_list1
    x: 0; y:0
    width: systemInfo.lcdWidth; height: 550

    GridView {
        id: tagginglist_list
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        cellWidth: 317
        cellHeight: 50
        model: ENGINEERINGList
        delegate: EngineeringListListDelegate{}
    }
}
