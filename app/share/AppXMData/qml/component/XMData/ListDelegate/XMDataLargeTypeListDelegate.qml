/**
 * FileName: XMDataChangeRowListDelegate.qml
 * Author: David.Bae
 * Time: 2012-04-26 16:46
 *
 * - 2012-04-26 Initial Created by David
 */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXMData

MComp.MComponent {
    id: idListItem
    x:101; y:0
    z: index
    width:ListView.view.width-x; height:91

    function getBgImageOfDelegate()
    {
      /*  if(idListItem.activeFocus && isMousePressed()){
           return imageInfo.imgFolderGeneral + "list_fp.png"
        }else*/ if(!idListItem.focus && isMousePressed()){
            return imageInfo.imgFolderGeneral + "list_p.png"
        }else{
            return "";
        }
    }
    Image {
        id: idBGFocus
        x: -86; y:0;/* z:1*/
        source: imageInfo.imgFolderGeneral + "list_f.png"
        visible: idListItem.activeFocus && focusOn
    }
    Image {
        id:idBgImage
        x: -86; y: 0; z:0
        source: getBgImageOfDelegate();
    }
    Image {
        x: -86; y: parent.height
        source: imageInfo.imgFolderGeneral + "list_line.png"
    }

    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        var endIndex = ListView.view.getEndIndex(ListView.view.contentY);
        if(endIndex == ListView.view.currentIndex){
            if((endIndex + rowPerPage) < ListView.view.count){
                ListView.view.positionViewAtIndex(ListView.view.count-1, ListView.End);
            }
            else{
                ListView.view.positionViewAtIndex(ListView.view.currentIndex+1, ListView.Beginning);
            }
        }

        if( ListView.view.count-1 != index )
        {
            ListView.view.incrementCurrentIndex();
        }
        else
        {
            if(ListView.view.count <= rowPerPage)
                return;
            ListView.view.positionViewAtIndex(0, ListView.Visible);
            ListView.view.currentIndex = 0;
        }
    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        var startIndex = ListView.view.getStartIndex(ListView.view.contentY);
        if(startIndex == ListView.view.currentIndex){
            if(startIndex < rowPerPage){
                ListView.view.positionViewAtIndex(rowPerPage-1, ListView.End);
            }
            else{
                ListView.view.positionViewAtIndex(ListView.view.currentIndex-1, ListView.End);
            }
        }

        if( index )
        {
            ListView.view.decrementCurrentIndex();
        }
        else
        {
            if(ListView.view.count <= rowPerPage)
                return;
            ListView.view.positionViewAtIndex(ListView.view.count-1, ListView.Visible);
            ListView.view.currentIndex = ListView.view.count-1;
        }
    }
}
