import Qt 4.7

// System Import
import "../../QML/DH" as MComp
// Local Import
import "../../XMData" as MXMData

MComp.MComponent {
    id: idListItem
    x:0; y:0
    width:parent.width; height:91

    property bool checkBox_OnOff: false;
    signal checkBoxOn();
    signal checkBoxOff();

    function setCheckBoxOn()
    {
        idCheckBox.setOn();
        checkBox_OnOff = true;
    }
    function setCheckBoxOff()
    {
        idCheckBox.setOff();
        checkBox_OnOff = false;
    }
    function toggleCheckBox()
    {
        idCheckBox.toggle();
    }

    Image {
        id:idBgImage
        x: 15; y: 0
        width: parent.width - 15 -35
        source: isMousePressed() ? imageInfo.imgFolderGeneral + "list_p.png" : idListItem.activeFocus && focusOn ? imageInfo.imgFolderGeneral + "list_f.png" : ""
    }

    Image {
        x: 0; y: parent.height+1
        source: imageInfo.imgFolderGeneral + "edit_list_line.png"
    }

    MComp.CheckBox{
        id:idCheckBox
        x:939;
        y:24;
        onCheckBoxChecked:{
            checkBox_OnOff = true;
            checkBoxOn(); //This signal will be catched by Delegate Definition.
        }
        onCheckBoxUnchecked:{
            checkBox_OnOff = false;
            checkBoxOff()
        }

        Item {
            id: idCheckBoxImage
            Image {
                id: checkOff
                source: imageInfo.imgFolderGeneral+"checkbox_uncheck.png"
                visible: !checkBox_OnOff
            }
            Image {
                id: checkOn
                source: imageInfo.imgFolderGeneral+"checkbox_check.png"
                visible: checkBox_OnOff
            }
        }
    }
//    Image {
//        id: idBGFocus
//        x: idBgImage.x; y:idBgImage.y; z:1
//        source: imageInfo.imgFolderGeneral + "edit_list_01_f.png"
//        visible: idListItem.activeFocus && focusOn
//    }

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

    MXMData.XMRectangleForDebug{}
}
