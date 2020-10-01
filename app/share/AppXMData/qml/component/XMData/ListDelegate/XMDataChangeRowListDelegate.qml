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

MComp.MButton {
    id: idListItem
    x:0; y:0
    width: listView.width; height:92
    isChangeRow: true

    property bool isDragItem: idListView.curIndex == index
    property bool isMoveUpScroll: true
    property bool isDragItemPress: false
    property bool isJogPressList: true
    property string bgImage: ""

    signal changeRow(int fromIndex, int toIndex);
    signal changeRowForReorderModel(int fromIndex, int toIndex);

    function checkBGImage(){
        if(isMousePressedOnly())
        {
            if(idListView.isDragStarted == true && isDragItemPress == false)
                return "";
            else
                return imageInfo.imgFolderGeneral + "list_p.png";
        }else
        {
            if(idListItem.activeFocus && focusOn)
            {
                if( (isDragItem && idListView.isMouseActionIndex == index) || (isJogPressList == false) )
                    return imageInfo.imgFolderGeneral + "list_p.png";
                else
                    return imageInfo.imgFolderGeneral + "list_f.png";
            }
            else
            {
                if(isDragItem && idListView.isMouseActionIndex == index)
                {
                    return imageInfo.imgFolderGeneral + "list_p.png";
                }
            }
        }
        return "";
    }

    //Layout Items.
    Item{
        x: 0;
        y: 0;
        width:parent.width-70
        height:parent.height
        id:idLayoutItem

        Image {
            id: idBgImage
            x: 0; y:0
            source: checkBGImage()
        }

        Image {
            id:idLine
            x: 0; y: parent.height
            source: imageInfo.imgFolderGeneral + "list_line.png"
        }
        Image {
            id:idDragIcon
            visible: (isDragItem == false)
            x:101+996+10; y:30;
            source: imageInfo.imgFolderRadio + "ico_handler.png"
        }

        Item{
            visible: isDragItem
            Image{
                x: 101+996+10+10
                y: 15
                source: idListView.curIndex == 0? imageInfo.imgFolderRadio+"ico_arrow_u_d.png" : imageInfo.imgFolderRadio+"ico_arrow_u_n.png"
            }
            Image{
                x: 101+996+10+10
                y: 15+30+4
                source: idListView.curIndex == (idListView.count-1)? imageInfo.imgFolderRadio+"ico_arrow_d_d.png" : imageInfo.imgFolderRadio+"ico_arrow_d_n.png"
            }
        }
    }

    onPressAndHold: {
        if(idListView.isDragStarted == true && isDragItemPress == false)
            return;
        if(ListView.view.flicking || ListView.view.moving || idAppMain.isDRSShow)   return;

        if(pressAndHoldFlag)
        {
            if(playBeepOn)
                UIListener.playAudioBeep();
            lockListView();
            isDragItemPress = true;
        }
    }

    onSelectKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        isJogPressList = false;
    }

    onClickOrKeySelected: {
        if(ListView.view.flicking || ListView.view.moving || idAppMain.isDRSShow)   return;
        if(isJogPressList)
        {
            if(idListView.isDragStarted != true)
            {
                idListView.currentIndex = index;
                checkFocusOfScreen();
            }
            return;
        }
        isJogPressList = true;
        if(idListView.isDragStarted == true)
        {
            changeRow(idListView.insertedIndex, idListView.curIndex);
            unlockListView();
        }else
        {
            lockListView();
        }
    }

    onMousePressChanged: {
        if(ListView.view.flicking || ListView.view.moving || idAppMain.isDRSShow)   return;
        idListView.isMouseActionIndex = isPressed ? index : -1;
        isJogPressList = true;
        if(isPressed)
        {
            if(isDragItem)
            {
                isDragItemPress = true;
                return;
            }
        }
        isDragItemPress = false;
    }
    onMousePosChanged: {
        if(idListView.isDragStarted == false || idAppMain.isDRSShow)
            return;

        if(isDragItemPress == false)
            return;

        var point = mapToItem(idListView, x, y);

        if(point.y < 0)
            return

        if(point.y >= (idListView.count * idListItem.height))
            return;

        if((point.y <= container.y + 50 || point.y >= container.height - 50) && (moveTimer.running == true))
        {
            return;
        }else if(point.y <= container.y + 50 && idListView.contentY != 0)
        {
            var yPositionForUp = point.y + idListView.contentY;

           var indexByPoint = parseInt(yPositionForUp / idListItem.height);
           if(indexByPoint == idListView.curIndex)
            {
               isMoveUpScroll = true;
               moveTimer.running = true;
               return;
            }
        }else if(point.y >= container.height - 50)
        {
            var yPositionForDown = point.y + idListView.contentY;

            var indexByPoint = parseInt(yPositionForDown / idListItem.height);
            if(indexByPoint == idListView.curIndex)
            {
                isMoveUpScroll = false;
                moveTimer.running = true;
                return;
            }
        }else
        {
            moveTimer.running = false;
        }

        point.y += idListView.contentY;

        var indexByPoint = parseInt(point.y / idListItem.height);
        if(indexByPoint == idListView.curIndex)
            return;

        changeRowForReorderModel(idListView.curIndex, indexByPoint);
        idListView.curIndex = indexByPoint;
        idListView.currentIndex = indexByPoint;
        idListView.isMouseActionIndex = indexByPoint;
    }

    Keys.onReleased: {
        if(idListView.isDragStarted)
        {
            if(event.key == Qt.Key_Up && event.modifiers == Qt.NoModifier && idListView.upKeyReleased == true)
            {
                changeRow(idListView.insertedIndex, idListView.curIndex);
                unlockListView();
            }
        }
    }

    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        if(idListView.isDragStarted == true)
        {
            if(idListView.curIndex > 0)
            {
                changeRowForReorderModel(idListView.curIndex,idListView.curIndex-1);
                idListView.curIndex--;
                idListView.moveOnPageByPage(idListView.rowPerPage, false);
            }
        }
        else
        {
            console.log("[QML] XMDataChangeRowListDelegate.qml :: onWheelLeftKeyPressed")
            idListView.moveOnPageByPage(idListView.rowPerPage, false);
        }
    }


    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        if(idListView.isDragStarted == true)
        {
            if(idListView.curIndex < (idListView.count-1))
            {
                changeRowForReorderModel(idListView.curIndex,idListView.curIndex+1);
                idListView.curIndex++;
                idListView.moveOnPageByPage(idListView.rowPerPage, true);
            }
        }
        else
        {
            console.log("[QML] XMDataChangeRowListDelegate.qml :: onWheelRightKeyPressed")
            idListView.moveOnPageByPage(idListView.rowPerPage, true);
        }
    }

    onClickReleased: {
        if(idAppMain.isDRSShow) return;
        if(idListView.isDragStarted == true && isDragItemPress== true)
        {
            moveTimer.running = false;
            var contentYBackup = idListView.contentY
            changeRow(idListView.insertedIndex, idListView.curIndex);
            unlockListView();
            checkFocusOfScreen();
//            idListView.contentY = contentYBackup;
        }
        isJogPressList = true;
    }

    Timer {
        id: moveTimer
        interval: 200
        onTriggered: move()
        running: false
        repeat: true
        triggeredOnStart: true

    }

    function move()
    {
        if(idListView.isDragStarted == false)
            return;

        if(isMoveUpScroll)
        {
            if(idListView.curIndex > 0)
            {
                changeRowForReorderModel(idListView.curIndex,idListView.curIndex-1);
                idListView.curIndex--;
            }
        }else
        {
            if(idListView.curIndex < (idListView.count-1))
            {
                changeRowForReorderModel(idListView.curIndex,idListView.curIndex+1);
                idListView.curIndex++;
            }
        }
        idListView.currentIndex = idListView.curIndex;
        idListView.isMouseActionIndex = idListView.curIndex;

    }

    function lockListView(){
        idListView.cacheBuffer = idListView.count * 92;
        idListView.interactive = false;
        idListView.insertedIndex = index;
        idListView.curIndex = index;
        idListView.currentIndex = index;
        idListView.isDragStarted = true;
        z = z+1;
        idListView.positionViewAtIndex(idListView.currentIndex, ListView.Visible);
    }
    function unlockListView(){
        idListView.currentIndex = -1;
        idListView.isDragStarted = false;
        idListView.interactive = true;
        idListView.itemInitWidth();
        idListView.currentIndex = idListView.curIndex;
        idListView.insertedIndex = -1;
        idListView.curIndex = -1;
        z = z-1;

        if (idListView.currentIndex == 0 && (idListView.count > 0) ){
                    idListView.positionViewAtIndex(idListView.currentIndex, ListView.Beginning);
        }
        else if(idListView.currentIndex < (idListView.count -1)){
            idListView.positionViewAtIndex(idListView.currentIndex, ListView.Visible);
        }
        else{
            idListView.positionViewAtIndex(idListView.currentIndex, ListView.End);
        }
    }

    Connections {
        target: UIListener
        onSignalShowSystemPopup:{
            if(idListView.isDragStarted)
            {
                changeRow(idListView.insertedIndex, idListView.curIndex);
                unlockListView();
            }
        }

        onReleaseTouchPress:{
            if(idListView.isDragStarted)
            {
                moveTimer.running = false;
                changeRow(idListView.insertedIndex, idListView.curIndex);
                unlockListView();
            }
            idListView.isMouseActionIndex = -1;
            isJogPressList = true;
        }
    }
}
