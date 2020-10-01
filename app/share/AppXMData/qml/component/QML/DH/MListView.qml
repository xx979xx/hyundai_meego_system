import QtQuick 1.0

ListView{
    id: idMListView

    property bool upKeyLongPressed : idAppMain.upKeyLongPressed;
    property bool downKeyLongPressed : idAppMain.downKeyLongPressed;
    property bool upKeyReleased : idAppMain.upKeyReleased;
    property bool downKeyReleased : idAppMain.downKeyReleased;
    property bool isKeyPressHere: false;
    property bool isSuppportAutoFocusByScroll: true
    property bool isDragStarted: false;
    property int isMouseActionIndex: -1;
    property bool showFocus: idAppMain.focusOn
    property bool isOptionMenuList: false
    property Item upFocusItemForReleaseUpKeyWithoutLongPress: null
    property int lastIndex: 0
    property bool sportKeyLongMoveOnPage: false;

    onShowFocusChanged: {
        if(activeFocus == false)
        {
            idUpLongKeyTimer.running = false
            idDownLongKeyTimer.running = false
            idAppMain.upKeyLongPressed = false
            idAppMain.downKeyLongPressed = false
        }
    }

    onActiveFocusChanged: {
        if(activeFocus == false)
        {
            idUpLongKeyTimer.running = false
            idDownLongKeyTimer.running = false
            idAppMain.upKeyLongPressed = false
            idAppMain.downKeyLongPressed = false
        }
    }

    onVisibleChanged: {
        if(visible == false)
        {
            idUpLongKeyTimer.running = false
            idDownLongKeyTimer.running = false
            idAppMain.upKeyLongPressed = false
            idAppMain.downKeyLongPressed = false
        }
    }

    onCurrentIndexChanged: {
        if(lastIndex == currentIndex)
        {
            idAppMain.forceActiveFocus();
        }
        lastIndex = currentIndex;
    }

    onMovementEnded: {
        if(isSuppportAutoFocusByScroll && isDragStarted == false)
        {
            var point = mapFromItem(currentItem, 0, 0);

            if(point.y+77 < 0 || point.y+85 > idMListView.height)
            {
                var idx = indexAt(300, contentY+85);
                if(idx < 0)             // not found row
                {
                    for(var tryCount = 1 ; tryCount <= 5 ; tryCount++)        // try 5 times for find fisrt view row
                    {
                        idx = indexAt(300, contentY+85+(85*tryCount));
                        if(idx >= 0)
                            break;
                    }
                }

                if(idx >= 0 && idx < count)
                    currentIndex = idx;
            }

            if(idMListView.visible && currentItem != null)
            {
                if(idAppMain.isDRSShow == false)
                    checkFocusOfMovementEnd();
            }
            //            if(idMListView.visible && idMListView.isCurrentItem)
            //                currentItem.focus = true;
        }
    }

//    onFlickStarted: {
//            if(idMListView.visible && currentItem != null)
//            {
//                checkFocusOfFlickStart();
//            }
//    }

    onUpKeyLongPressedChanged:{
        if (!activeFocus)
            return;

        if(isDragStarted)
            return;

//        if(idAppMain.checkFirstSignal())
//            UIListener.playAudioBeep();

        if(upKeyLongPressed){
            console.debug("-----------[luna] onUpKeyLongPressedChanged: " + idMListView.currentIndex)
            idUpLongKeyTimer.running = true            
        }
        else{
            idUpLongKeyTimer.running = false
        }
    }

    onDownKeyLongPressedChanged:{
        if (!activeFocus)
            return;

        if(isDragStarted)
            return;

//        if(idAppMain.checkFirstSignal())
//            UIListener.playAudioBeep();

        if(downKeyLongPressed){
            console.debug("-----------[luna] onDownKeyLongPressedChanged: " + idMListView.currentIndex)
            idDownLongKeyTimer.running = true
        }
        else{
            idDownLongKeyTimer.running = false
            if(sportKeyLongMoveOnPage){
                var endIndex = getEndIndex(contentY);
                var currentItemY = idMListView.currentItem.y;
                // delegate(159) * 2 + section.delegate(79) - margin(17) = 380
		if( (currentIndex < (count-1)) && (endIndex <= currentIndex) && ((currentItemY - contentY) > 380) && (endIndex - startIndex > 2) )
		{
                    idMListView.positionViewAtIndex(currentIndex-2, ListView.Beginning);
                }
            }
        }
    }

    Keys.onPressed: {
        if(event.key == Qt.Key_Up && event.modifiers == Qt.NoModifier && upKeyLongPressed == false)
        {
            //console.log("!!!!!!!!!!! Up key Pressed")
            event.accepted = true;
            isKeyPressHere = true;
        }
        else if(event.key == Qt.Key_Down && event.modifiers == Qt.NoModifier && downKeyLongPressed == false)
        {
            //console.log("!!!!!!!!!!! Down key Pressed")
            event.accepted = true;
            isKeyPressHere = true;
        }
    }

    Keys.onReleased: {
        if(event.key == Qt.Key_Up && event.modifiers == Qt.NoModifier && upKeyLongPressed == false && upKeyReleased == true && isKeyPressHere == true)
        {
            //console.log("!!!!!!!!!!! Up key released")
            if(upFocusItemForReleaseUpKeyWithoutLongPress != null)
                upFocusItemForReleaseUpKeyWithoutLongPress.forceActiveFocus();
            else if(idMenuBar.contentItem.KeyNavigation.up)
            {
                idMenuBar.focusInitLeft();
                idMenuBar.contentItem.KeyNavigation.up.forceActiveFocus();
            }
            event.accepted = true;
        }
        else if(event.key == Qt.Key_Down && event.modifiers == Qt.NoModifier && downKeyLongPressed == false && downKeyReleased == true && isKeyPressHere == true)
        {
            //console.log("!!!!!!!!!!! Down key released")
            if(idMenuBar.contentItem.KeyNavigation.down && idMenuBar.visibleSearchTextInput != true)//[ITS 188442]
                idMenuBar.contentItem.KeyNavigation.down.forceActiveFocus();
            event.accepted = true;
        }
        isKeyPressHere = false;
    }

    Timer {
        id: idUpLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            if(isOptionMenuList)
            {
                if(idMListView.flicking || idMListView.moving)   return;

                var i = 0, curIndex, totalCount;
                curIndex = idMOptionMenu.linkedCurrentIndex;
                totalCount = idMListView.count-1;

                while(i != totalCount){
                    if(curIndex <= 0){
                        if(idMListView.count > 8) curIndex = totalCount;
                        else break;
                    }
                    else{ curIndex--; }
                    if( getEnabled(curIndex) == true ){
                        idMOptionMenu.linkedCurrentIndex = curIndex;
                        break;
                    }
                    i++;
                }

            }
            else
            {
                if(idAppMain.isWsaListModelChanged)
                {
                    UIListener.consolMSG("idUpLongKeyTimer:: onWsaListModelChanged is True. so ignored !! ")
                }
                else
		{
                    idMListView.decrementCurrentIndex();
		}
            }
        }
        triggeredOnStart: true
    }
    Timer {
        id: idDownLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            if(isOptionMenuList)
            {
                if(idMListView.flicking || idMListView.moving)   return;

                var i = 0, curIndex, totalCount;
                curIndex = idMOptionMenu.linkedCurrentIndex;
                totalCount = idMListView.count-1;

                while(i != totalCount){
                    if(curIndex >= totalCount){
                        if(idMListView.count > 8)
                            curIndex = 0;
                        else break;
                    }
                    else{ curIndex++; }
                    if( getEnabled(curIndex) == true )
                    {
                        idMOptionMenu.linkedCurrentIndex = curIndex;
                        break;
                    }
                    i++;
                }
            }
            else
            {
                if(idAppMain.isWsaListModelChanged)
                {
                    UIListener.consolMSG("idDownLongKeyTimer:: onWsaListModelChanged is True. so ignored !! ")
                }
                else
                {
                    idMListView.incrementCurrentIndex();
                }
            }
        }
        triggeredOnStart: true
    }

    function getEnabled(index){
        switch(index){
        case 0: return idMOptionMenu.menu0Enabled;
        case 1: return idMOptionMenu.menu1Enabled;
        case 2: return idMOptionMenu.menu2Enabled;
        case 3: return idMOptionMenu.menu3Enabled;
        case 4: return idMOptionMenu.menu4Enabled;
        case 5: return idMOptionMenu.menu5Enabled;
        default: return true;
        }
    } // End function

    function getEndIndex(posY) {
        var endIndex = -1;
        console.log("[QML] MListView.qml :: getEndIndex :: posY : " + posY + ", height : " + height )
        for(var i = 0; i < 5; i++) {
            endIndex = indexAt(120, posY + (height - 10) - 50 * i);
            if(-1 < endIndex) {  return endIndex }
        }
        return -1;
    }

    function getStartIndex(posY) {
        var startIndex = -1;
        for(var i = 1; i < 10; i++) {
            startIndex = indexAt(120, posY + 50 * i);
            if(-1 < startIndex) { return startIndex }
        }
        return -1;
    }

    function moveOnPageByPage(rowPerPage, direction)
    {
        if(direction) // right
        {
            var endIndex = getEndIndex(contentY);
            if(endIndex === currentIndex){
                if(count <= rowPerPage)
                    return;
                if(currentIndex < (count-1))
                idMListView.positionViewAtIndex(currentIndex+1, ListView.Beginning);
//                if((endIndex + rowPerPage) < count)
//                {
//                    idMListView.positionViewAtIndex(count-1, ListView.End);
//                }
//                else{
//                    idMListView.positionViewAtIndex(currentIndex+1, ListView.Beginning);
//                }
            }
            if( count-1 != currentIndex )
            {
                idMListView.incrementCurrentIndex();
            }
            else
            {
                if(count <= rowPerPage)
                    return;
                idMListView.positionViewAtIndex(0, ListView.Beginning);
                currentIndex = 0;
            }
        }
        else
        {
            var startIndex = getStartIndex(contentY);
            if(startIndex === currentIndex){
                if(count <= rowPerPage)
                    return;
                if(currentIndex > 0)
                    idMListView.positionViewAtIndex(currentIndex-1, ListView.End);
//                if(currentIndex < rowPerPage){
//                    idMListView.positionViewAtIndex(rowPerPage-1, ListView.End);
//                }
//                else{
//                    idMListView.positionViewAtIndex(currentIndex-1, ListView.End);
//                }
            }
            if( currentIndex )
            {
                idMListView.decrementCurrentIndex();
            }
            else
            {
                if(count <= rowPerPage)
                    return;

                idMListView.positionViewAtIndex(count-1, ListView.End);
                idMListView.currentIndex = count-1;
            }
        }
    }

    function sportmoveOnPageByPage(rowPerPage, direction)
    {
        var endIndex = getEndIndex(contentY);
        var startIndex = getStartIndex(contentY);

        if(direction) // right
        {
            if(endIndex == currentIndex){
                if(count <= rowPerPage)
                    return;
                if(currentIndex < (count-1))
                    idMListView.positionViewAtIndex(currentIndex+1, ListView.Beginning);
            }

            if( count-1 != currentIndex )
            {
                idMListView.incrementCurrentIndex();
                var currentItemY = idMListView.currentItem.y;
                // delegate(159) * 3 - margin(27) = 450
                if(endIndex == currentIndex && (currentItemY - contentY) > 450){
                    idMListView.positionViewAtIndex(currentIndex, ListView.Beginning);
                }
            }
            else
            {
                if(count <= rowPerPage)
                    return;
                idMListView.positionViewAtIndex(0, ListView.Visible);
                currentIndex = 0;
            }
        }
        else
        {
            if(startIndex == currentIndex){
                if(count <= rowPerPage)
                    return;
                if(currentIndex > 0){
                    if((currentIndex-3) > -1)
                        idMListView.positionViewAtIndex(currentIndex-3, ListView.Beginning);
                    else
                        idMListView.positionViewAtIndex(currentIndex-1, ListView.End);
                }
            }
            if( currentIndex )
            {
                idMListView.decrementCurrentIndex();
            }
            else
            {
                if(count <= rowPerPage)
                    return;

                idMListView.positionViewAtIndex(count-1, ListView.Visible);
                idMListView.currentIndex = count-1;
            }
        }
    }

    function fuelmoveOnPageByPage(rowPerPage, direction)
    {
        var endIndex = getEndIndex(contentY);
        var startIndex = getStartIndex(contentY);

        if(direction) // right
        {
            if(endIndex == currentIndex){
                if(count <= rowPerPage)
                    return;
                if(currentIndex < (count-1))
                    idMListView.positionViewAtIndex(currentIndex+1, ListView.Beginning);
            }

            if( count-1 != currentIndex )
            {
                idMListView.incrementCurrentIndex();
                var currentItemY = idMListView.currentItem.y;
                // delegate(138) * 3 - margin(14) = 400
                if(endIndex == currentIndex && (currentItemY - contentY) > 400){
                    idMListView.positionViewAtIndex(currentIndex, ListView.Beginning);
                }
            }
            else
            {
                if(count <= rowPerPage)
                    return;
                idMListView.positionViewAtIndex(0, ListView.Visible);
                currentIndex = 0;
            }
        }
        else
        {
            if(startIndex == currentIndex){
                if(count <= rowPerPage)
                    return;
                if(currentIndex > 0){
                    if((currentIndex-3) > -1)
                        idMListView.positionViewAtIndex(currentIndex-3, ListView.Beginning);
                    else
                        idMListView.positionViewAtIndex(currentIndex-1, ListView.End);
                }
            }
            if( currentIndex )
            {
                idMListView.decrementCurrentIndex();
            }
            else
            {
                if(count <= rowPerPage)
                    return;

                idMListView.positionViewAtIndex(count-1, ListView.Visible);
                idMListView.currentIndex = count-1;
            }
        }
    }
}
