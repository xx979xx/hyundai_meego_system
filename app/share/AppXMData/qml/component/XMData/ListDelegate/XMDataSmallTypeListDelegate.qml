import Qt 4.7

// System Import
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idListItem
    x:0; y:0
    z: index
    width:parent.width; height:92

    property bool isShowBGImage: true

    Image {
        id: idBGFocus
        x: 0; y:0
        source: (isMousePressed() && focusOn) ? imageInfo.imgFolderMusic + "tab_list_p.png" : (idListItem.activeFocus && focusOn) ? imageInfo.imgFolderMusic + "tab_list_f.png" : ""
        visible: isShowBGImage
    }
    Image {
        x: 0; y: parent.height
        source: imageInfo.imgFolderMusic + "tab_list_line.png"
    }
    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        ListView.view.moveOnPageByPage(rowPerPage, true);

    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        ListView.view.moveOnPageByPage(rowPerPage, false);

    }
}
