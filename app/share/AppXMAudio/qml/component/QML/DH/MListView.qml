import QtQuick 1.1

ListView{
    id: idMListView

    property bool upKeyLongPressed : idAppMain.upKeyLongPressed;
    property bool downKeyLongPressed : idAppMain.downKeyLongPressed;
    property bool upKeyReleased : idAppMain.upKeyReleased;
    property bool downKeyReleased : idAppMain.downKeyReleased;
    property bool isKeyPressHere: false;
    property bool reorderPresetDrag : false
    property bool optionMenuNoBand : false
    property bool isSuppportAutoFocusByScroll: true
    signal downKeyLongListDown();
    signal upKeyLongListUp();

    onActiveFocusChanged: {
        if(activeFocus == false)
        {
            idUpLongKeyTimer.running = false
            idDownLongKeyTimer.running = false
        }
    }

    onVisibleChanged: {
        if(visible == false)
        {
            idUpLongKeyTimer.running = false
            idDownLongKeyTimer.running = false
        }
    }

    onMovementEnded: {
        if (idAppMain.state == "AppRadioOptionMenuSub" || idAppMain.state == "AppRadioOptionMenu")
            return;

        if(isSuppportAutoFocusByScroll)
        {
            var point = mapFromItem(currentItem, 0, 0);

            //console.log("----------------------------------------------"+currentIndex+","+contentY+","+point.y+","+indexAt(100, contentY+85)+","+contentX)
            if(point.y+85 < 0 || point.y+85 > idMListView.height)
                currentIndex = indexAt(300, contentY+85);      // for section margin
        }
    }

    onUpKeyLongPressedChanged:{
        if(!activeFocus) return;
        if((idAppMain.gSXMEditPresetOrder == "TRUE") && (isDragStarted == true)) return;
        if(idAppMain.state == "PopupRadioAddToFavorite") return;

        if(upKeyLongPressed)
        {
            //console.debug("-----------[luna] onUpKeyLongPressedChanged: " + idMListView.currentIndex)
            idUpLongKeyTimer.running = true
        }
        else
        {
            idUpLongKeyTimer.running = false
        }
    }

    onDownKeyLongPressedChanged:{
        if(!activeFocus) return;
        if((idAppMain.gSXMEditPresetOrder == "TRUE") && (isDragStarted == true)) return;
        if(idAppMain.state == "PopupRadioAddToFavorite") return;

        if(downKeyLongPressed)
        {
            //console.debug("-----------[luna] onDownKeyLongPressedChanged: " + idMListView.currentIndex)
            if(idMListView.currentIndex != (idMListView.count-1))
                idAppMain.downKeyLongListDownOperation(true);
            idDownLongKeyTimer.running = true
        }
        else
        {
            idAppMain.downKeyLongListDownOperation(false);
            idDownLongKeyTimer.running = false
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
            if(!optionMenuNoBand) topBandforceActiveFocus();
            event.accepted = true;
        }
        else if(event.key == Qt.Key_Down && event.modifiers == Qt.NoModifier && downKeyLongPressed == false && downKeyReleased == true && isKeyPressHere == true)
        {
            //console.log("!!!!!!!!!!! Down key released")
            event.accepted = true;
        }
        else if(event.key == Qt.Key_1)
        {
            idUpLongKeyTimer.running = true
        }
        else if(event.key == Qt.Key_2)
        {
            idDownLongKeyTimer.running = true
        }
        isKeyPressHere = false;
    }

    Timer {
        id: idUpLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered: upKeyLongListUp()
        triggeredOnStart: true
    }
    Timer {
        id: idDownLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered: downKeyLongListDown()
        triggeredOnStart: true
    }

    onDownKeyLongListDown: {
        if (idMListView.currentItem != null) {
            if((idMListView.currentItem.wheelRightKeyPressed != null) && reorderPresetDrag)
            {
                idMListView.currentItem.wheelRightKeyPressed(1);
                return;
            }
        }

        if((idAppMain.state == "AppRadioOptionMenu") || (idAppMain.state =="AppRadioOptionMenuSub") || (idAppMain.state =="AppRadioListMenu"))
        {
            if(listOptionMenu.flicking || listOptionMenu.moving)   return;
            if(idAppMain.isSettings) return;

            idMOptionMenu.timerRestart();
            //# Focus skip when Disable KEH (20130307)
            var i = 0, curIndex, totalCount;
            curIndex = idMListView.currentIndex;
            totalCount = idMListView.count-1;
            while(i != totalCount)
            {
                if(curIndex >= totalCount)
                {
                    if(listOptionMenu.count > 8)
                        curIndex = 0;
                    else
                        break;
                }
                else
                {
                    curIndex++;
                }

                if( getEnabled(curIndex) == true )
                {
                    idMListView.currentIndex = curIndex;
                    break;
                }
                i++;
            }
        }
        else
        {
            idMListView.incrementCurrentIndex();
        }
    }

    onUpKeyLongListUp : {
        if (idMListView.currentItem == null) {
            if((idMListView.currentItem != null) || ((idMListView.currentItem.wheelLeftKeyPressed != null) && reorderPresetDrag))
            {
                idMListView.currentItem.wheelLeftKeyPressed(1);
                return;
            }
        }

        if((idAppMain.state == "AppRadioOptionMenu") || (idAppMain.state =="AppRadioOptionMenuSub") || (idAppMain.state =="AppRadioListMenu") )
        {
            if(listOptionMenu.flicking || listOptionMenu.moving)   return;
            if(idAppMain.isSettings) return;

            idMOptionMenu.timerRestart();
            //# Focus skip when Disable KEH (20130307)
            var i = 0, curIndex, totalCount;
            curIndex = idMListView.currentIndex;
            totalCount = idMListView.count-1;
            while(i != totalCount)
            {
                if(idMListView.currentIndex <= 0)
                {
                    if(listOptionMenu.count > 8)
                        idMListView.currentIndex = totalCount;
                    else
                        break;
                }
                else
                {
                    curIndex--;
                }

                if( getEnabled(curIndex) == true )
                {
                    idMListView.currentIndex = curIndex;
                    break;
                }
                i++;
            }
        }
        else
        {
            idMListView.decrementCurrentIndex();
        }
    }

    function topBandforceActiveFocus()
    {
        switch(idAppMain.state)
        {
        case "AppRadioMain":
        {
            //console.log("[0]---------------- Preset")
            if((idAppMain.gSXMSaveAsPreset == "TRUE") || (idAppMain.gSXMEditPresetOrder == "TRUE"))
                topBand.giveForceFocus("backBtn"); //Back Button
            else
                topBand.giveForceFocus(3); //SiriusXM Tab
            topBand.focus = true;
            break;
        }
        case "AppRadioList":
        {
            //console.log("[1]---------------- List : "+idAppMain.gSXMListMode)
            if(idAppMain.gSXMListMode == "LIST")
                topBand.giveForceFocus("menuBtn");
            else
                topBand.giveForceFocus("backBtn");
            topBand.focus = true;
            break;
        }
        case "AppRadioEPG":
        {
            //console.log("[2]---------------- EPG(Program Guide) : "+idAppMain.gSXMEPGMode)
            if(idAppMain.gSXMEPGMode == "PROGRAM")
                topBand.giveForceFocus("subBtn");
            else
                topBand.giveForceFocus("backBtn");
            topBand.focus = true;
            break;
        }
        case "AppRadioSearch": //Not used MListView
        {
            //console.log("[3]---------------- Direct Tune")
            topBand.giveForceFocus("backBtn");
            topBand.focus = true;
            break;
        }
        case "AppRadioFeaturedFavorites":
        {
            //console.log("[4]---------------- Featured Favorites")
            topBand.giveForceFocus("backBtn");
            topBand.focus = true;
            break;
        }
        case "AppRadioFavorite": //BigBand
        {
            //console.log("[5]---------------- Favorite : "+idAppMain.gSXMFavoriteDelete)
            if(idAppMain.gSXMFavoriteDelete == "LIST")
                topBand.giveForceFocus(1); //List
            else
                topBand.giveForceFocus(6); //MENU
            topBand.focus = true;
            break;
        }
        case "AppRadioFavoriteActive": //BigBand
        {
            //console.log("[6]---------------- Favorite - Active")
            topBand.giveForceFocus(2); //Active
            topBand.focus = true;
            break;
        }
        case "AppRadioGameZone": //BigBand
        {
            //console.log("[7]---------------- Game Zone - Live")
            if(idRadioGameZoneCategoryList.activeFocus)
                topBand.giveForceFocus(1); //Live
            if(idRadioGameZoneChannelList.activeFocus)
                topBand.giveForceFocus(7); //Back
            topBand.focus = true;
            break;
        }
        case "AppRadioGameSet": //BigBand
        {
            //console.log("[8]---------------- Set Team")
            if(idRadioGameSetLeagueList.activeFocus)
                topBand.giveForceFocus(2); //Set Team
            if(idRadioGameSetTeamList.activeFocus)
                topBand.giveForceFocus(4); //Alert On/Off
            topBand.focus = true;
            break;
        }
        case "AppRadioGameActive": //BigBand
        {
            //console.log("[9]---------------- Game Zone - Active")
            topBand.giveForceFocus(3); //Active
            topBand.focus = true;
            break;
        }
        case "AppRadioEngineering": //Not used MListView
        {
            //console.log("[10]---------------- Engineering Mode : ")
            if(idAppMain.gSXMENGMode == "ENGNORMAL")
                topBand.giveForceFocus("menuBtn");
            else
                topBand.giveForceFocus("backBtn");
            topBand.focus = true;
            break;
        }
        default:
        {
            topBand.forceActiveFocus();
            break;
        }
        }
    }

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
}
