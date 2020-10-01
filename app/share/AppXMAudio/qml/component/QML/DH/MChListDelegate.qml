/**
 * FileName: MChListDelegate.qml
 * Author: HYANG
 * Time: 2012-05
 *
 * - 2012-05 Initial Created by HYANG
 * - 2012-07-25 added presetList bigSize
 * - 2012-08-22 added TextScroll
 * - 2012-09-19 change text color
 * - 2012-11-20 GUI modify(selected image delete) Save, edit icon add
 */

import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComponent {
    id: idMChListDelegate
    x: 0; y: 0
    width: 462; height: 89

    // ITS 188587 # by WSH(131011)
    mEnabled: {
        if(presetOrder == true)
        {
            if(bDraggMode == true)
            {
                if(isDragItem == false)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            else
            {
                return true;
            }
        }
        else
        {
            return true;
        }
    }

    //****************************** # Preperty #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderRadio_Hd : imageInfo.imgFolderRadio_Hd
    property string imgFolderRadio_SXM : imageInfo.imgFolderRadio_SXM

    property int selectIndex: selectedItem
    property string selectedApp: "DMB"

    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property string mChListThirdText: ""
    property string mChListForthText: ""

    //****************************** # Preset Save and Order #
    property bool presetSave: idAppMain.gSXMSaveAsPreset == "TRUE" ? true : false
    property bool presetOrder: idAppMain.gSXMEditPresetOrder == "TRUE" ? true : false

    property bool isDragItem: false
    property bool isMoveUpScroll: true
    property int lastMousePositionY: 0

    property string playChNum : PLAYInfo.ChnNum
    property bool bIsMousePressed : isMousePressed()
    property bool bDraggMode : idChListView.isDragStarted

    signal changeRow(int fromIndex, int toIndex);
    //****************************** # Preset Save and Order #

    property bool bIsPresetScan : (idAppMain.gSXMPresetScan == "PresetScan") ? true : false
    property bool bCompletedComponent : false
    Component.onCompleted:
    {
        bCompletedComponent = true
        updateChnColor() // WSH(131108)
    }

    state : 'KeyRelease'

    Item{
        id: idLayoutItem
        x: 0; y: 0
        width:parent.width; height:parent.height

        //****************************** # Default/Selected/Press Image #
        Image{
            id: normalImage
            x: (selectedApp == "XMAudio") ? 43-29 : 44-7
            y: -4
            source: imgFolderRadio_Hd+"bg_menu_tab_l_p.png"
            visible: (idMChListDelegate.state != "KeyRelease")? true : false
        }

        //****************************** # Focus Image #
        BorderImage {
            id: focusImage
            x: (selectedApp == "XMAudio") ? 43-29 : 44-7
            y: -4
            source: imgFolderRadio_Hd+"bg_menu_tab_l_f.png"
            visible: (showFocus) && (idMChListDelegate.activeFocus) && (idMChListDelegate.state == "KeyRelease")
        }

        //****************************** # IR Recoder Image #
        Item {
            id: firstImage
            x: 43+371; y: 5
            visible: (selectedApp == "XMAudio")

            //Favorite Image
            Image {
                x: 0; y: 0; z:10
                source: imgFolderRadio_SXM+"ico_rec.png"
                visible: (mChListFirstText != "" || mChListSecondText != "" || mChListThirdText != "") && (index == 0 || index == 1 || index == 2 || index == 3 || index == 4 || index ==5) ? (!(presetOrder || presetSave) ? true : false) : false
            }
        }

        Item {
            id: idPresetTextItem

            //****************************** # Index (FirstText) #
            Text{
                id: firstText
                text: index+1
                x: 43-14; y: 89-43-font.pixelSize/2
                width: 62; height: 40
                font.pixelSize: 40
                font.family: systemInfo.font_NewHDB
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.dimmedGrey
            }

            //****************************** # Channel (SecondText) #
            Text{
                id: secondText
                text: ((selectedApp == "XMAudio") && (mChListSecondText == "0")) ? "" : mChListSecondText
                x: 43+48+15; y: 89-43-font.pixelSize/2
                width: 80; height: 40
                font.pixelSize: 40
                font.family: systemInfo.font_NewHDR
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.brightGrey
            }

            //****************************** # StationName (ThirdText) #
            MComp.DDScrollTicker{
                id: thirdText
                x: 43+48+15+80+20; y: 89-43-(thirdText.fontSize/2)-(thirdText.fontSize/(3*2))
                width: (presetOrder || presetSave) ? 139 : 253
                height: thirdText.fontSize+(thirdText.fontSize/3)
                text: ((selectedApp == "XMAudio") && (mChListThirdText == "")) ? stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY : mChListThirdText
                fontFamily : systemInfo.font_NewHDR
                fontSize: 40
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                visible: (selectedApp == "XMAudio") ? true : false
                tickerFocus: (idMChListDelegate.activeFocus && idAppMain.focusOn)
            }
        }

        //****************************** # Line Image #
        Image{
            x: 43; y: idMChListDelegate.height
            source: imgFolderGeneral+"line_ch.png"
        }

        Image {
            id:idDragIcon
            visible: presetOrder && !isDragItem
            x: 43+163+139+31; y: 89-43-13
            source: imageInfo.imgFolderRadio+"ico_handler.png"
        }

        Item{
            visible: presetOrder && isDragItem
            Image{
                x: 43+163+139+31+7
                y: 89-39-4-26
                source: idChListView.curIndex == 0? imageInfo.imgFolderRadio+"ico_arrow_u_d.png" : imageInfo.imgFolderRadio+"ico_arrow_u_n.png"
            }
            Image{
                x: 43+163+139+31+7
                y: 89-39
                source: idChListView.curIndex == (idChListView.count-1)? imageInfo.imgFolderRadio+"ico_arrow_d_d.png" : imageInfo.imgFolderRadio+"ico_arrow_d_n.png"
            }
        }
    }

    //****************************** # Preset Save Button (130104) #
    MButton{
        x: 43+163+139+4; y: 89-43-34
        width: 105; height: 68
	
        bgImage: imgFolderRadio+"btn_save_n.png"
	bgImagePress: imgFolderRadio+"btn_save_p.png"
        visible: presetSave

        firstText: stringInfo.sSTR_XMRADIO_SAVE
        firstTextX: 8
        firstTextY: 34
        firstTextWidth: 90
        firstTextSize: 24
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextPressColor: colorInfo.brightGrey
        onClickOrKeySelected: {
            XMOperation.setPresetSaveFlag(false);
            onSavePreset(index)
        }
    }

    property bool bMouseClicked : false
    onVisibleChanged: {
        //console.log("Preset List -> onVisibleChanged !!!!!!!!!!!")
        keyCancel()
    }
    onSelectKeyPressed:
    {
        //console.log("Preset List -> onSelectKeyPressed !!!!!!!!!!!")
        if(idChListView.flicking || idChListView.moving)   return;
        bMouseClicked = false;
        keyPressed()
    }
    onPressAndHold: keyLongPressed()
    onClickReleased: {
        //console.log("Preset List -> onClickReleased !!!!!!!!!!!")
        if(idChListView.flicking || idChListView.moving)   return;
        keyReleased()
        UIListener.HandleSetPresetIndex(); // ITS 196950 # by WSH(197698)
    }
    onClickOrKeySelected: {
        //console.log("Preset List -> onClickOrKeySelected !!!!!!!!!")
        keyReleased()
    }
    onCancel: {
        //console.log("Preset List -> onCancel !!!!!!!!!!!!")
        if(isDragItem != true)
            keyCancel()
    }
    onBIsMousePressedChanged:{
        if(bIsMousePressed == true)
        {
            //console.log("Preset List -> onBIsMousePressedChanged !!!!!!!!!!!! 0")
            bMouseClicked = true;
            keyPressed()
        }
        else
        {
            //console.log("Preset List -> onBIsMousePressedChanged !!!!!!!!!!!! 1")
            if(isDragItem != true)
                keyCancel()
        }
    }
    onBackKeyPressed: {
        console.log("[JEON] [MChListDelegate]  onBackKeyPressed :: idAppMain.isDragByTouch = "+ idAppMain.isDragByTouch)

        if(!presetOrder) return;
        if(moveTimer.running == true)
        {
            idAppMain.isDragByTouch = true;
            isDragItem = false;
            moveTimer.running =false;
            keyCancel();
        }
    }

    onMousePosChanged: {
        if(!presetOrder) return;

        if(isDragItem == false)
        {
            moveTimer.running =false;
            return;
        }

        var point = mapToItem(idChListView, x, y);

        if(point.y < 0){
            point.y = 0;
        }
        else if (point.y > 520) {
            point.y = 520;
        }

        if((point.y <= idChListView.y + 44 || point.y >= idChListView.height - 56) && (moveTimer.running == true))
        {
            lastMousePositionY = point.y;
            return;
        }else if(point.y <= idChListView.y + 44)
        {
            lastMousePositionY = point.y;
            isMoveUpScroll = true;
            moveTimer.running = true;
            return;
        }else if(point.y >= idChListView.height - 56)
        {
            lastMousePositionY = point.y;
            isMoveUpScroll = false;
            moveTimer.running = true;
            return;
        }else
        {
            moveTimer.running = false;
        }

        point.y += idChListView.contentY;

        if(point.y < 0)
            return;

        if(point.y > (idChListView.count * idMChListDelegate.height))
            return;

        var indexByPoint = parseInt(point.y / idMChListDelegate.height);
        if(indexByPoint == idChListView.curIndex)
            return;

        idChListView.curIndex = indexByPoint;
        idChListView.itemMoved(0,0);
    }

    onWheelLeftKeyPressed: {
        if(idChListView.flicking || idChListView.moving)   return;
        if(presetOrder)
        {
            if(isDragItem) //Drag Mode
            {
                if(idChListView.curIndex > 0)
                {
                    idChListView.curIndex--;
                    if(idChListView.curIndex*height < idChListView.contentY+height)
                    {
                        var tempIndex = idChListView.curIndex%6;

                        idChListView.contentY = idChListView.curIndex*height

                        // ITS 0207147 # by WSH(131107)
                        if(tempIndex == 5 )
                        {
                            if(idChListView.curIndex == 11)
                            {
                                idChListView.contentY = 534;
                            }
                            else if(idChListView.curIndex == 5)
                            {
                                idChListView.contentY  = 0;
                            }
                        }
                    }

                    idChListView.itemMoved(0,0);
                }
            }
            else //Jog Mode
            {
                if( idMChListDelegate.ListView.view.currentIndex )
                {
                    idMChListDelegate.ListView.view.decrementCurrentIndex();
                    onPresetPosUpdate(idMChListDelegate.ListView.view.currentIndex, true);
                }
                else
                {
                    idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.count-1, idMChListDelegate.ListView.view.Visible);
                    idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.count-1;
                }
            }
        }
        else //Jog Mode(None Preset Order)
        {
            onPresetUp(index, !presetSave);
        }
    }

    onWheelRightKeyPressed: {
        if(idChListView.flicking || idChListView.moving)   return;
        if(presetOrder)
        {
            if(isDragItem) //Drag Mode
            {
                if(idChListView.curIndex < (idChListView.count-1))
                {
                    idChListView.curIndex++;
                    if(idChListView.curIndex*height+height > idChListView.contentY+idChListView.height)
                    { // ITS 0207147 # by WSH(131107)
                        var tempIndex = idChListView.curIndex%6;

                        if(tempIndex == 0)
                        {
                            idChListView.contentY = (tempIndex+(idChListView.curIndex/6))*idChListView.height;
                        }
                        else
                        {
                            idChListView.contentY = (idChListView.curIndex*height+height)-idChListView.height;
                        }
                    }

                    idChListView.itemMoved(0,0);
                }
            }
            else //Jog Mode
            {
                if( idMChListDelegate.ListView.view.count-1 != idMChListDelegate.ListView.view.currentIndex )
                {
                    idMChListDelegate.ListView.view.incrementCurrentIndex();
                    onPresetPosUpdate(idMChListDelegate.ListView.view.currentIndex, true);
                }
                else
                {
                    idMChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                    idMChListDelegate.ListView.view.currentIndex = 0;
                }
            }
        }
        else //Jog Mode(None Preset Order)
        {
            onPresetDown(index, !presetSave);
        }
    }

    Timer {
        id: moveTimer
        interval: 100
        onTriggered: move()
        running: false
        repeat: true
        triggeredOnStart: true
    }

    function move()
    {
        var contentHeight = idChListView.count * height;
        if(isMoveUpScroll)
        {
            if(idChListView.contentY <= 50)
            {
                idChListView.contentY = 0;
                moveTimer.running =false;
            }
            else
                idChListView.contentY -= 50;
            checkOnScrollMoved();
        }
        else
        {
            if(idChListView.contentY >= contentHeight - idChListView.height - 50)
            {
                idChListView.contentY = contentHeight - idChListView.height;
                moveTimer.running = false;
            }
            else
                idChListView.contentY += 50;
            checkOnScrollMoved();
        }
    }

    function lockListView(){
        idChListView.interactive = false;
        idChListView.insertedIndex = index;
        idChListView.curIndex = index;
        idChListView.isDragStarted = true;
        z = z+1;
    }

    function unlockListView(){
        idChListView.isDragStarted = false;
        idChListView.interactive = true;
        idChListView.itemInitWidth();
        idChListView.currentIndex = idChListView.curIndex;
        idChListView.insertedIndex = -1;
        idChListView.curIndex = -1;
        idChListView.forceActiveFocus();
        z = z-1;
    }

    function checkOnScrollMoved(){
        if(isDragItem == false)
        {
            moveTimer.running = false;
            return;
        }

        if((idChListView.contentY + lastMousePositionY)/height != idChListView.curIndex)
        {
            if((idChListView.contentY + lastMousePositionY)/height >= 0 && (idChListView.contentY + lastMousePositionY)/height < (idChListView.count-1))
            {
                idChListView.curIndex = (idChListView.contentY + lastMousePositionY)/height;
                idChListView.itemMoved(0,0);
            }
        }
    }

    function getFirstTextColor(bSelected)
    {
        if((presetOrder == true) && (isDragItem == false) && (bDraggMode == true))
        {
            //console.log("[getFirstTextColor][0]-----------------------index:"+bSelected);
            return colorInfo.disableGrey;
        }
        else if((presetOrder == true || presetSave == true) && (index == idChListView.currentIndex))
        {
            if(idMChListDelegate.activeFocus == true)
            {
                //console.log("[getFirstTextColor][1]-----------------------index:"+bSelected);
                return colorInfo.brightGrey;
            }
            else
            {
                //console.log("[getFirstTextColor][2]-----------------------index:"+bSelected);
                return colorInfo.dimmedGrey
            }
        }
        else if((idMChListDelegate.state == "keyPress") || (idMChListDelegate.state == "KeyLonpress"))
        {
            //console.log("[getFirstTextColor][3]-----------------------index:"+bSelected);
            return colorInfo.brightGrey;
        }
        else if(showFocus && idMChListDelegate.activeFocus)
        {
            //console.log("[getFirstTextColor][4]-----------------------index:"+bSelected);
            return colorInfo.brightGrey;
        }
        else if(bSelected && (idChListView.currentIndex == index))
        {
            //console.log("[getFirstTextColor][5]-----------------------index:"+bSelected);
            return colorInfo.blue;
        }
        //        else if(mChListSecondText != "0")
        //        {
        //            console.log("[getFirstTextColor][6]-----------------------index:"+bSelected);
        //            return colorInfo.dimmedGrey;
        //        }
        else
        {
            //console.log("[getFirstTextColor][7]-----------------------index:"+bSelected);
            return colorInfo.dimmedGrey;
        }
    }

    function getSecondTextColor(bSelected)
    {
        if((presetOrder == true) && (isDragItem == false) && (bDraggMode == true))
        {
            //console.log("[getSecondTextColor][0]-----------------------index:"+bSelected);
            return colorInfo.disableGrey;
        }
        else if(presetOrder == true || presetSave == true)
        {
            //console.log("[getSecondTextColor][1]-----------------------index:"+bSelected);
            return colorInfo.brightGrey;
        }
        else if((idMChListDelegate.state == "keyPress") || (idMChListDelegate.state == "KeyLonpress"))
        {
            //console.log("[getSecondTextColor][2]-----------------------index:"+bSelected);
            return colorInfo.brightGrey;
        }
        else if(showFocus && idMChListDelegate.activeFocus)
        {
            //console.log("[getSecondTextColor][3]-----------------------index:"+bSelected);
            return colorInfo.brightGrey;
        }
        else if(bSelected && (idChListView.currentIndex == index))
        {
            //console.log("[getSecondTextColor][4]-----------------------index:"+bSelected);
            return colorInfo.blue;
        }
        else if(mChListSecondText != "0")
        {
            //console.log("[getSecondTextColor][5]-----------------------index:"+bSelected);
            return colorInfo.brightGrey;
        }
        else
        {
            //console.log("[getSecondTextColor][6]-----------------------index:"+bSelected);
            return colorInfo.disableGrey;
        }
    }

    function updateChnColor()
    {
        var bSelected = isSelectedPreset(index)
        firstText.color = getFirstTextColor(bSelected)
        secondText.color = getSecondTextColor(bSelected)
        thirdText.color = getSecondTextColor(bSelected)

        if ((getSecondTextColor(bSelected) == colorInfo.blue) && (getSecondTextColor(bSelected)) == colorInfo.blue)
        {
            secondText.font.family = systemInfo.font_NewHDB;
            thirdText.fontFamily = systemInfo.font_NewHDB;
        }
        else
        {
            secondText.font.family = systemInfo.font_NewHDR;
            thirdText.fontFamily = systemInfo.font_NewHDR;
        }
    }

    function updateLayout()
    {
        thirdText.width = (presetOrder || presetSave)? 139 : 253
        if(isDragItem == true && presetOrder == false)
            isDragItem = false;

        textPresetTickerRestart();
    }

    function textPresetTickerRestart()
    {
        //Text Ticker Restart
        thirdText.tickerEnable = false;
        thirdText.doCheckAndStartAnimation();
        thirdText.tickerEnable = true;
        thirdText.doCheckAndStartAnimation();
    }

    onPresetSaveChanged: updateLayout()
    onPresetOrderChanged: updateLayout()
    onStateChanged: updateChnColor()
    onBDraggModeChanged: updateChnColor()
    onActiveFocusChanged: {
        if(activeFocus == false) idMChListDelegate.state = 'KeyRelease'
        updateChnColor()
    }

    onPlayChNumChanged : {
        if(bCompletedComponent == true)
            updateChnColor()
    }

    onMChListSecondTextChanged : {
        if(bCompletedComponent == true)
            updateChnColor()
    }
    onBIsPresetScanChanged: {
        if(bCompletedComponent == true && gSXMPresetScan == "PresetScan")
            updateChnColor()
    }

    function keyPressed()
    {
        if(presetOrder)
        {
            if (idAppMain.inputModeXM == "jog")
            {
                onPresetPosUpdate(idMChListDelegate.ListView.view.currentIndex, true);
            }
        }

        idMChListDelegate.state = 'KeyPress';
    }

    function keyLongPressed()
    {
        if(idChListView.flicking || idChListView.moving)   return;
        idMChListDelegate.state = 'KeyLonpress';

        if(presetSave)
        {
            // do nothing...
        }
        else if(presetOrder)
        {
            if(bMouseClicked == true)
            {
                if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

                idMChListDelegate.ListView.view.currentIndex = index;
                isDragItem = true;
                lockListView();
            }
        }
        else
        {
            savePreset();
            idMChListDelegate.state = 'KeyRelease';
        }
    }

    function keyReleased()
    {
        if(idMChListDelegate.state == 'KeyRelease') return;
        idMChListDelegate.state = 'KeyRelease';

        if(presetOrder && (idAppMain.inputModeXM == "jog"))
        {
            //console.log("Preset List -> keyReleased !!!!!!!!"+presetOrder+" "+idAppMain.playBeepOn)
            if(isDragItem)
            {
                moveTimer.running = false;
                isDragItem = false;
                changeRow(idChListView.insertedIndex, idChListView.curIndex);
                unlockListView();
            }
            else
            {
                isDragItem = true;
                lockListView();
            }
        }
        else
        {
            selectPreset();
        }
    }

    function keyCancel()
    {
        //console.log("Preset List -> Key Cancel !!!!!!!!!!")
        idMChListDelegate.state = 'KeyRelease'
    }

    function savePreset()
    {
        onSavePreset(index)
    }

    function selectPreset()
    {
        if(presetOrder)
        {
            //console.log("Preset Order -> "+isDragItem+" "+bDraggMode)
            if(isDragItem == true && bDraggMode == true)
            {
                if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

                moveTimer.running = false;
                isDragItem = false;
                changeRow(idChListView.insertedIndex, idChListView.curIndex);
                unlockListView();

                if( 0<= idMChListDelegate.ListView.view.currentIndex && idMChListDelegate.ListView.view.currentIndex <= 5 ) // 1 page
                {
                    idChListView.contentY = 0;
                }
                else if( 6<= idMChListDelegate.ListView.view.currentIndex && idMChListDelegate.ListView.view.currentIndex <= 11 ) // 2 page
                {
                    idChListView.contentY = height * 6;
                }
                else if( 11< idMChListDelegate.ListView.view.currentIndex) // 3 page
                {
                    idChListView.contentY = height * 12;
                }
            }
            else
            {
                onSelectPreset(index)
            }
        }
        else if(presetSave)
        {
            XMOperation.setPresetSaveFlag(false);
            onSavePreset(index)
        }
        else
        {
            onSelectPreset(index)
        }
    }

    // ITS 196950 # by WSH(197698)
    Connections{
        target: UIListener
        onPresetIndexChanged:{
            if( !(idAppMain.gSXMSaveAsPreset == "TRUE" || idAppMain.gSXMEditPresetOrder == "TRUE") )
            {
                updateChnColor()
            }
        }
    }

    Connections{
        target: idAppMain

        onPresetScanFont: {
            updateChnColor()
        }
        onPresetOrderDisabledAndChangeOrder: {
            if(idChListView.isDragStarted)
            {
                moveTimer.running = false;
                isDragItem = false;
                changeRow(idChListView.insertedIndex, idChListView.curIndex);
                unlockListView();
            }
        }
    }

    Connections {
        target: idChListView
        onItemInitWidth: {
            isDragItem = false;
            if(height*index > 0)
                y = height*index;
            else y = 0;
        }
        onItemMoved: {
            if(index < idChListView.insertedIndex && index < idChListView.curIndex)
            {
                y = height*index;
            }else if(index > idChListView.insertedIndex && index > idChListView.curIndex)
            {
                y = height*index;
            }else if(index > idChListView.insertedIndex && index <= idChListView.curIndex)
            {
                y = height*index - height;
            }else if(index < idChListView.insertedIndex && index >= idChListView.curIndex)
            {
                y = height*index + height;
            }else if(index == idChListView.insertedIndex)
            {
                y = height*idChListView.curIndex
            }
        }
    }

    //****************************** # Preset Scan Animation # JSH 130121
//    SequentialAnimation{
//        id: aniPresetScan
//        running: (gSXMPresetScan == "PresetScan" && index == idMChListDelegate.ListView.view.currentIndex) ? true : false
//        onRunningChanged: {
//            if(!running)
//                idPresetTextItem.opacity = 1.0;
//        }
//        loops: Animation.Infinite
//        NumberAnimation{ target: idPresetTextItem; property: "opacity";  to: 0.0; duration: 250 }
//        PauseAnimation { duration: 250;}
//        NumberAnimation{ target: idPresetTextItem; property: "opacity"; to: 1.0;  duration: 250 }
//        PauseAnimation { duration: 250;}
//    }
}
