/**
 * FileName: MChListDelegate.qml
 * Author: WSH
 * Current Modified Data: 2013-06-26
 *
 * - 2012-05 Initial Created by HYANG
 * - 2013-01-05 Preser Order
 * - 2013-05-24 Added TextScroll
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComponent {
    id: idMChListDelegate
    width: 422 ; height: 89
    mEnabled: {
        if(presetOrder == true)
        {
            if(idAppMain.isDragItemSelect == true)
            {
                if(isDragItem == true)
                {
                    return true;
                }
                else
                {
                    return false;
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

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    // # Delegate Info
    property bool active: false
    property bool focusMove: false
    property bool focusImgVisible: showFocus && idMChListDelegate.activeFocus
    property bool moveChannelSaving: false

    // # Image Path
    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderRadio_Hd : imageInfo.imgFolderRadio_Hd
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderDmb : imageInfo.imgFolderDmb

    // # Button Image
    property string bgImage: ""
    property string bgImagePress: imgFolderDmb+"ch_list_p.png"
    property string bgImageFocus: imgFolderDmb+"ch_list_f.png"

    // # Line Image
    property int lineImageX: 43
    property int lineImageY: 89
    property string lineImage: imgFolderGeneral+"line_ch.png"

    // # First Text Info
    property string firstText: ""
    property int firstTextSize: 40
    property int firstTextX: 33
    property int firstTextY: 89-44
    property int firstTextWidth: 58    
    // property int firstTextHeight: firstTextSize
    property string firstTextStyle: idAppMain.fontsR
    property string firstTextStyleB: idAppMain.fontsB
    property string firstTextHorizontalAlies: "Center"
    property string firstTextVerticalAlies: "Center"
    property string firstTextElide: "None"
    property bool firstTextVisible: true
    property bool firstTextEnabled: true
    property string firstTextColor: colorInfo.dimmedGrey
    property string firstTextPressColor: firstTextColor
    //property string firstTextFocusColor: colorInfo.brightGrey
    property string firstTextDisableColor: colorInfo.disableGrey
    property string firstTextSelectedColor:  colorInfo.selectedBlue //RGB(124, 189, 255)

    // # First Text Scroll
    property bool firstTextScrollEnable: false
    property bool firstTextOverPaintedWidth: false

    // # Second Text Info
    property string secondText: ""
    property int secondTextSize: 40
    property int secondTextX: firstTextX+58+15
    property int secondTextY: 89-44
    property int secondTextWidth: 337/*(presetOrder == false) ? 337 : 249*/
    //property int secondTextHeight: 40 + (40/4 - 40/8)
    property string secondTextStyle: idAppMain.fontsR
    property string secondTextStyleB: idAppMain.fontsB
    property string secondTextHorizontalAlies: "Left"
    property string secondTextVerticalAlies: "Center"
    property string secondTextElide: "Right"
    property bool secondTextVisible: true
    property bool secondTextEnabled: true
    property string secondTextColor: colorInfo.brightGrey
    property string secondTextPressColor: secondTextColor
    //property string secondTextFocusColor: secondTextColor
    property string secondTextDisableColor: colorInfo.disableGrey
    property string secondTextSelectedColor: colorInfo.selectedBlue //RGB(124, 189, 255)

    // # Second Text Scroll
    property bool secondTextScrollEnable: false
    property bool secondTextOverPaintedWidth: false

    // # Move Mode Info
    property bool presetOrder: (idAppMain.presetEditEnabled == true) ? true : false
    property bool isDragItem: false
    property bool isMoveUpScroll: true
    property int lastMousePositionY: 0
    signal changeRow(int fromIndex, int toIndex);

    property int temp_contentY: 0

    function setFirstTextFontFamily()
    {
        if(index == CommParser.m_iPresetListIndex)
        {
            return firstTextStyleB;
        }
        else
        {
            return firstTextStyle;
        }
    }

    function setSecondTextFontFamily()
    {
        if(index == CommParser.m_iPresetListIndex)
        {
            return secondTextStyleB;
        }
        else
        {
            return secondTextStyle;
        }
    }

    function setFirstTextColor()
    {
        if(index == CommParser.m_iPresetListIndex)
        {
            return firstTextSelectedColor;
        }
        else
        {
            return firstTextColor;
        }
    }

    function setSecondTextColor()
    {
            if(index == CommParser.m_iPresetListIndex)
            {
                return secondTextSelectedColor;                
            }
            else
            {
                return secondTextColor;
            }
    }

    // # Default Image
    Image{
        id: idBgImg
        x: 30//44-7
        y: -1
        source: bgImage
    }

    // # Button Focus Image
    BorderImage {
        id: idFocusImage
        x: 30//44-7
        y: -1
        source: bgImageFocus;
        visible: focusImgVisible//showFocus && idMChListDelegate.activeFocus
    }

    // # Index (FirstText) #
    Item {
        id: idFirstTextItem
        x: firstTextX
        y: firstTextY - (firstTextSize/2) - (firstTextSize/3)
        width: firstTextWidth
        height: parent.height
        clip: firstTextOverPaintedWidth ? true : false;

        Text {
            id: txtFirstText
            width: (firstTextScrollEnable == false) ? firstTextWidth : txtFirstText2.paintedWidth
            text: firstText
            color: (idAppMain.isPopUpShow == true) ? setFirstTextColor() : firstTextColor
            font.family:  (idAppMain.isPopUpShow == true) ? setFirstTextFontFamily() : firstTextStyle
            font.pixelSize: firstTextSize
            verticalAlignment: { MDmbOperation.getVerticalAlignment(firstTextVerticalAlies) }
            horizontalAlignment: { MDmbOperation.getHorizontalAlignment(firstTextHorizontalAlies) }
            elide: {
                if(firstTextScrollEnable == true){ Text.ElideNone }
                else{ MDmbOperation.getTextElide(firstTextElide) }
            }
            visible: firstTextVisible
            enabled: firstTextEnabled
        }

        Text {
            id: txtFirstText2
            text: firstText
            color: (idAppMain.isPopUpShow == true) ? setFirstTextColor() : firstTextColor
            font.family:  (idAppMain.isPopUpShow == true) ? setFirstTextFontFamily() : firstTextStyle
            font.pixelSize: firstTextSize
            visible: firstTextOverPaintedWidth ? true : false
            enabled: firstTextEnabled
            verticalAlignment: txtFirstText.verticalAlignment
            horizontalAlignment: txtFirstText.horizontalAlignment
            anchors.left: txtFirstText.right
            anchors.leftMargin: 120
        }

    }

    // # Channel (SecondText) #
    Item {
        id: idSecondTextItem
        x: secondTextX
        y: secondTextY-(secondTextSize/2) - (secondTextSize/4)
        width: secondTextWidth
        height: parent.height
        clip: secondTextOverPaintedWidth ? true : false;

        Text {
            id: txtSecondText
            width: (secondTextScrollEnable == false) ? secondTextWidth : txtSecondText2.paintedWidth
            text: secondText
            color: (idAppMain.isPopUpShow == true) ? setSecondTextColor() : secondTextColor
            font.family:  (idAppMain.isPopUpShow == true) ? setSecondTextFontFamily() : secondTextStyle
            font.pixelSize: secondTextSize
	    verticalAlignment: { MDmbOperation.getVerticalAlignment(secondTextVerticalAlies) }
            horizontalAlignment: { MDmbOperation.getHorizontalAlignment(secondTextHorizontalAlies) }
            elide: {
                if(secondTextScrollEnable == true){ Text.ElideNone }
                else{ MDmbOperation.getTextElide(secondTextElide) }
            }
            visible: secondTextVisible           
            enabled: secondTextEnabled
        }

        Text {
            id: txtSecondText2
            text: secondText
            color: (idAppMain.isPopUpShow == true) ? setSecondTextColor() : secondTextColor
            font.family:  (idAppMain.isPopUpShow == true) ? setSecondTextFontFamily() : secondTextStyle
            font.pixelSize: secondTextSize
            visible: secondTextOverPaintedWidth ? true : false
            enabled: secondTextEnabled
            verticalAlignment: txtSecondText.verticalAlignment
            horizontalAlignment: txtSecondText.horizontalAlignment
            anchors.left: txtSecondText.right
            anchors.leftMargin: 120
            onFontChanged: {
                setPaintedWidth();
            }
        }
    }
    
    // # For Scroll Text Animation
    SequentialAnimation {
        id: idTickerAnimation1
        loops: Animation.Infinite
        running: false
        PauseAnimation { duration: 1000 }
        PropertyAnimation {
            target: txtFirstText
            property: "x"
            from: 0
            to: -(txtFirstText2.paintedWidth + 120)
            duration: (txtFirstText2.paintedWidth + 120)/50 *1000
        }
        PauseAnimation { duration: 1500 }
    }

    SequentialAnimation {
        id: idTickerAnimation2
        loops: Animation.Infinite
        running: false
        PauseAnimation { duration: 1000 }
        PropertyAnimation {
            target: txtSecondText
            property: "x"
            from: 0
            to: -(txtSecondText2.paintedWidth + 120)
            duration: (txtSecondText2.paintedWidth + 120)/50 *1000
        }
        PauseAnimation { duration: 1500 }
    }

    // # For Scroll Text
    onFirstTextScrollEnableChanged:{
        if( (firstTextOverPaintedWidth == true) && (firstTextScrollEnable == true) )
        {
            idTickerAnimation1.start();
        }
        else
        {
            idTickerAnimation1.stop();
            txtFirstText.x = 0;
        }
    }

    onSecondTextScrollEnableChanged:{
        if( (secondTextOverPaintedWidth == true) && (secondTextScrollEnable == true) )
        {
            if(idTickerAnimation2.running == true)
                idTickerAnimation2.restart();
            else
                idTickerAnimation2.start();
        }
        else
        {
            idTickerAnimation2.stop();
            txtSecondText.x = 0/*secondTextX*/;
        }
    }

    function setPaintedWidth()
    {
        if(txtFirstText2.paintedWidth > firstTextWidth) firstTextOverPaintedWidth = true;
        else firstTextOverPaintedWidth = false;

        if(txtSecondText2.paintedWidth > secondTextWidth) secondTextOverPaintedWidth = true;
        else secondTextOverPaintedWidth = false;

        if(secondTextOverPaintedWidth == false){
            if(secondTextScrollEnable == true)
                secondTextScrollEnable = false;
        }else{
            if(secondTextScrollEnable == true){
                if(idTickerAnimation2.running == true)
                    idTickerAnimation2.restart();
            }
        }
    }

   
    // # Line Image
    Image {
        id: idLineImage
        x: lineImageX
        y: lineImageY
        source: lineImage
    }

    // # Move Mode
    Image {
        id:idDragIcon
        visible: (presetOrder == true && isDragItem == false)
        x: 43+62+249+10; y: 89-43-13
        source: imgFolderRadio+"ico_handler.png"
    }

    Item{
        id: idArrowImage
        visible: presetOrder && isDragItem
        Image{
            x: 43+62+249+10+7
            y: 89-39-5-25
            source: idMChListDelegate.ListView.view.curIndex == 0? imgFolderRadio+"ico_arrow_u_d.png" : imgFolderRadio+"ico_arrow_u_n.png"
        }
        Image{
            x: 43+62+249+10+7
            y: 89-39
            source: idMChListDelegate.ListView.view.curIndex == (idMChListDelegate.ListView.view.count-1)? imgFolderRadio+"ico_arrow_d_d.png" : imgFolderRadio+"ico_arrow_d_n.png"
        }
    }

    // ### Jog Event
    Keys.onUpPressed: {

// Set focus for Band
//        if((presetOrder == true || idAppMain.drivingRestriction == true) && (CommParser.m_bIsFullScreen == false))
//        {
//            idDmbPlayerBand.focusBackBtn()
//        }
	
        event.accepted = true;
        return;
    }

    onUpKeyReleased: {
        if(idAppMain.upKeyReleased == true && CommParser.m_bIsFullScreen == false && idAppMain.state != "PopupSearching")
        {
            idDmbPlayerBand.focus = true;

            if( (idMChListDelegate.presetOrder == true) && (CommParser.m_bIsFullScreen == false) )
            {
                if(isDragItem == true && moveChannelSaving == false){
                    if(idPresetChList.insertedIndex >= 0 && idPresetChList.curIndex >= 0)
                        EngineListener.selectChangeList(idPresetChList.insertedIndex, idPresetChList.curIndex, idPresetChList.contentY, CommParser.m_iPresetListIndex, index);
                }
                idDmbPlayerBand.focus = true;
                idDmbPlayerBand.focusBackBtn()
            }else{
                idDmbPlayerBand.focusMenuBtn();
            }

            focusMove = true;
            idMChListDelegate.state="keyRelease"
        }
        idAppMain.upKeyReleased = false;
    }

    Keys.onDownPressed:{ // No Movement
        event.accepted = true;
        return;
    }

    onWheelLeftKeyPressed: {
        if(presetOrder)
        {
            if(isDragItem) //Drag Mode
            {
                if(idPresetChList.curIndex > 0)
                {
                    idPresetChList.curIndex--;
//                    if(idPresetChList.curIndex*height < idPresetChList.contentY+height)
//                        idPresetChList.contentY = idPresetChList.curIndex*height

                    if(idMChListDelegate.ListView.view.count > 6)
                    {
                        var currentPage = 0;
                        var totalPage = 0;
                        var tempPage = 0;
                        currentPage = EngineListener.getPresetListPageValue(1,idPresetChList.curIndex);
                        totalPage = EngineListener.getPresetListPageValue(2, idPresetChList.curIndex);


                        if(idPresetChList.curIndex%6 == 5){
                            tempPage = currentPage -1;


                            if(currentPage != totalPage){
                                idPresetChList.contentY = idPresetChList.height*tempPage;
                            }else{
                                idPresetChList.contentY = (idPresetChList.height*(tempPage - 1)) + ((idPresetChList.count%6)*height);
                            }
                        }
                    }

                    idPresetChList.itemMoved(0,0);
                }
            }
            else //Jog Mode
            {
                if(idMChListDelegate.ListView.view.flicking || idMChListDelegate.ListView.view.moving) return;
                if( idMChListDelegate.ListView.view.currentIndex )
                {
                    idMChListDelegate.ListView.view.decrementCurrentIndex();
                }
                else
                {
                    idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.count-1, ListView.Visible);
                    idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.count-1;
                }

                if(idMChListDelegate.ListView.view.count > 6)
                {
                    if(idMChListDelegate.ListView.view.currentIndex%6 == 5)
                        idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.currentIndex-5, ListView.Beginning);
                }
            }
        }
//        else //Jog Mode(None Preset Order)
//        {
//            if( idMChListDelegate.ListView.view.currentIndex )
//            {
//                idMChListDelegate.ListView.view.decrementCurrentIndex();
//            }
//            else
//            {
//                idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.count-1, ListView.Visible);
//                idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.count-1;
//            }
//        }
    }

    onWheelRightKeyPressed: {
        if(presetOrder)
        {
            if(isDragItem) //Drag Mode
            {
                if(idPresetChList.curIndex < (idPresetChList.count-1))
                {
                    idPresetChList.curIndex++;

//                    if(idPresetChList.curIndex*height+height > idPresetChList.contentY+idPresetChList.height)
//                        idPresetChList.contentY = (idPresetChList.curIndex*height+height)-idPresetChList.height;

                    if(idMChListDelegate.ListView.view.count > 6)
                    {
                        var currentPage = 0;
                        var totalPage = 0;
                        var tempPage = 0;
                        currentPage = EngineListener.getPresetListPageValue(1,idPresetChList.curIndex);
                        totalPage = EngineListener.getPresetListPageValue(2, idPresetChList.curIndex);


                        if(idPresetChList.curIndex%6 == 0){
                            tempPage = currentPage -1;

                            if(currentPage != totalPage){
                                idPresetChList.contentY = idPresetChList.height*tempPage;
                            }else{
                                if((idPresetChList.count%6) == 0)
                                    idPresetChList.contentY = idPresetChList.height*tempPage;
                                else
                                    idPresetChList.contentY = (idPresetChList.height*(tempPage - 1)) + ((idPresetChList.count%6)*height);
                            }
                        }
                    }

                    idPresetChList.itemMoved(0,0);
                }
            }
            else //Jog Mode
            {
                if(idMChListDelegate.ListView.view.flicking || idMChListDelegate.ListView.view.moving) return;
                if( idMChListDelegate.ListView.view.count-1 != idMChListDelegate.ListView.view.currentIndex )
                {
                    idMChListDelegate.ListView.view.incrementCurrentIndex();
                }
                else
                {
                    idMChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                    idMChListDelegate.ListView.view.currentIndex = 0;
                }

                if(idMChListDelegate.ListView.view.count > 6)
                {
                    if(idMChListDelegate.ListView.view.currentIndex%6 == 0)
                        idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.currentIndex, ListView.Beginning);
                }
            }
        }
//        else //Jog Mode(None Preset Order)
//        {
//            if( idMChListDelegate.ListView.view.count-1 != idMChListDelegate.ListView.view.currentIndex )
//            {
//                idMChListDelegate.ListView.view.incrementCurrentIndex();
//            }
//            else
//            {
//                idMChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
//                idMChListDelegate.ListView.view.currentIndex = 0;
//            }
//        }
    }

    // ### Key Selected
    onSelectKeyPressed: {
        //console.log(" [QML][JOG] onSelectKeyPressed : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

        if(idMChListDelegate.ListView.view.flicking || idMChListDelegate.ListView.view.moving) return;

        idMChListDelegate.state="pressed"

//        if(presetOrder)
//        {
//            if(isDragItem)
//            {
//                if(EngineListener.getDRSShowStatus() == false)
//                {
//                    var contentYBackup = idPresetChList.contentY;
//                    moveTimer.stop();
//                    isDragItem = false;
//                    idAppMain.isDragItemSelect = false;
//                    setPresetListIndex(CommParser.m_iPresetListIndex, idPresetChList.insertedIndex, idPresetChList.curIndex, index);
//                    changeRow(idPresetChList.insertedIndex, idPresetChList.curIndex);
//                    unlockListView(idPresetChList.curIndex);
//                    idPresetChList.contentY = contentYBackup;
//                }
//                else
//                {
////                    changeRow(idPresetChList.insertedIndex, idPresetChList.curIndex);
//                    EngineListener.selectChangeList(idPresetChList.insertedIndex, idPresetChList.curIndex, idPresetChList.contentY, CommParser.m_iPresetListIndex, index);
//                }
//            }else
//            {
////                isDragItem = true;
////                idAppMain.isDragItemSelect = true;
//                if(EngineListener.getDRSShowStatus() == false)
//                {
//                    lockListView(index);
//                }
//                else
//                {
//                    idAppMain.dmbListPageInit(index);
//                    EngineListener.selectLockList(index);
//                }
//            }
//        }
    }
    
    // ### Key Released
    onSelectKeyReleased: {
        //console.log(" [QML][JOG]  onSelectKeyReleased : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

//        if(presetOrder) return;

//        if(firstText == index) {
//            idMChListDelegate.state="selected"
//        }else{
            if(idDmbPlayerBand.focus == false){
                focusMove = false;
                idMChListDelegate.state="keyRelease"
            }
//        }
    }

    // ### Touch Release Event
    onClickReleased: {
        if(playBeepOn && idAppMain.inputModeDMB == "touch" /* && pressAndHoldFlagDMB == false*/) idAppMain.playBeep();

        if(!presetOrder) return;

        if(isDragItem)
        {
            if(EngineListener.getDRSShowStatus() == false)
            {
                var contentYBackup = idPresetChList.contentY;
                moveTimer.stop();
                isDragItem = false;
                idAppMain.isDragItemSelect = false;
                setPresetListIndex(CommParser.m_iPresetListIndex, idPresetChList.insertedIndex, idPresetChList.curIndex, index);
                changeRow(idPresetChList.insertedIndex, idPresetChList.curIndex);
                unlockListView(idPresetChList.curIndex);
                idPresetChList.contentY = contentYBackup;
            }
            else
            {
//                idAppMain.dmbListPageInit(idPresetChList.curIndex);
                var temp = 0;
                if(temp_contentY < idPresetChList.contentY) // DOWN
                {
                    if(idPresetChList.curIndex > 5 && ( idPresetChList.curIndex*idMChListDelegate.height >= idPresetChList.contentY &&  idPresetChList.contentY >= (idPresetChList.curIndex-5)*idMChListDelegate.height))
                    {
                        temp = EngineListener.setContentYinPresetMoveMenuByTouch(idPresetChList.contentY);
                        if(temp < ((idPresetChList.count-6) * idMChListDelegate.height) )
                        {
                            idPresetChList.contentY = temp;
                        }
                        else
                        {
                            temp = idPresetChList.contentY
                        }

                    }
                    else
                    {

                        temp = EngineListener.setContentYinPresetMoveMenuByTouch(idPresetChList.contentY+50);

                        if(temp <= ((idPresetChList.curIndex-5)*idMChListDelegate.height))
                        {
                            temp = (idPresetChList.curIndex-5)*idMChListDelegate.height;
                            idPresetChList.contentY = temp;
                        }
                        else if(temp < ((idPresetChList.count-6) * idMChListDelegate.height) )
                        {
                            idPresetChList.contentY = temp;
                        }
                        else
                        {
                            temp = idPresetChList.contentY;
                        }

                    }
                }
                else if(temp_contentY > idPresetChList.contentY) // UP
                {
                    if( idPresetChList.contentY !=0)
                    {
                        temp = EngineListener.setContentYinPresetMoveMenuByTouch(idPresetChList.contentY);
                        if(temp > ((idPresetChList.count-6) * idMChListDelegate.height) )
                        {
                            temp = idPresetChList.contentY;
                        }
                        else
                        {
                            if(idPresetChList.curIndex*idMChListDelegate.height <idPresetChList.contentY)
                            {
                                idPresetChList.contentY  = idPresetChList.curIndex*idMChListDelegate.height;
                                temp = idPresetChList.contentY;
                            }
                            else
                            {
                                idPresetChList.contentY = temp;
                                temp =  idPresetChList.contentY;
                            }
                        }
                    }
                    else
                    {
                        temp =  idPresetChList.contentY;
                    }
                }
                else
                {
                    temp = idPresetChList.contentY;
                }

                moveChannelSaving = true;
                if(idPresetChList.insertedIndex >= 0 && idPresetChList.curIndex >= 0)
                    EngineListener.selectChangeList(idPresetChList.insertedIndex, idPresetChList.curIndex,  temp, CommParser.m_iPresetListIndex, index);
            }
        }
    }
    
    // ### Key Enter / Touch Click
    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            //console.log(" [QML][JOG/TOUCH] onClickOrKeySelected : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! index="+index)

            if(presetOrder==true){
                idMChListDelegate.ListView.view.currentIndex = index

                idMChListDelegate.ListView.view.focus = true
                idMChListDelegate.ListView.view.forceActiveFocus()
            }

            if(idMChListDelegate.ListView.view.flicking || idMChListDelegate.ListView.view.moving) return;
            if(presetOrder)
            {
                if(isDragItem)
                {
                    moveChannelSaving = true;
                    if(idPresetChList.insertedIndex >= 0 && idPresetChList.curIndex >= 0)
                        EngineListener.selectChangeList(idPresetChList.insertedIndex, idPresetChList.curIndex, idPresetChList.contentY, CommParser.m_iPresetListIndex, index);
                }else
                {
                    idAppMain.dmbListPageInit(index);
                    EngineListener.selectLockList(index);
                }
            }
        }
    }
    
    // ### Key Enter / Touch Long Pressed
    onPressAndHold: {
        //console.log(" [QML][JOG/TOUCH] onPressAndHold : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

        if(idMChListDelegate.ListView.view.flicking || idMChListDelegate.ListView.view.moving) return;

        if(presetOrder)
        {
            if(playBeepOn && idAppMain.inputModeDMB == "touch") idAppMain.playBeep();
            if(idAppMain.inputModeDMB == "jog") return;

//            if(idPresetChList.isDragStarted)
//            {
//                unlockListView(idPresetChList.curIndex);
//                idPresetChList.itemInitWidth();
//            }

            isDragItem = true;
            idAppMain.isDragItemSelect = true;
            if(EngineListener.getDRSShowStatus() == false)
            {
                lockListView(index);
            }
            else
            {
                if(!idPresetChList.isDragStarted)
                    EngineListener.selectLockList(index);
            }
        }
    }

    // ### About EditMode
    onPresetOrderChanged:{
        //idMChListDelegate.secondTextWidth = (presetOrder == false) ? 337 : 249

        if(presetOrder == true){
            idMChListDelegate.ListView.view.currentIndex = CommParser.m_iPresetListIndex            
            idMChListDelegate.secondTextWidth = 249
            idPresetChList.forceActiveFocus()
        }
        else
	{
            idMChListDelegate.ListView.view.currentIndex = CommParser.m_iPresetListIndex
            selectedItem = CommParser.m_iPresetListIndex
            isDragItem = false
            idAppMain.isDragItemSelect = false;
            idMChListDelegate.secondTextWidth = 337
        }
        setPaintedWidth();
        if(secondTextOverPaintedWidth && idAppMain.drivingRestriction == false){
            if(idMChListDelegate.ListView.view.currentIndex == index)
                secondTextScrollEnable = true;
        }else{
            secondTextScrollEnable = false;
        }
    }

    onMousePosChanged: {
        if(presetOrder == false) return;

        if(isDragItem == false) return;

        // console.log(" [QML] =========> [MChListDelegate][onMousePosChanged] Preset Order")
        var point = mapToItem(idPresetChList, x, y);

        if( (presetOrder == true) && (idMChListDelegate.isDragItem == true) && (idPresetChList.count <= 6) && (idAppMain.inputModeDMB == "touch") )
        {
            if(point.y >= (idPresetChList.count * idMChListDelegate.height)) return;
        }

        if((point.y <= idPresetChList.y + 50 || point.y >= idPresetChList.height - 50) && (moveTimer.running == true))
        {
            lastMousePositionY = point.y;
            return;
        }
        else if(point.y <= idPresetChList.y + 50)
        {
            lastMousePositionY = point.y;
            isMoveUpScroll = true;
            moveTimer.start();
            return;
        }
        else if(point.y >= idPresetChList.height - 50)
        {
            lastMousePositionY = point.y;
            isMoveUpScroll = false;
            moveTimer.start();
            return;
        }
	else
        {
            moveTimer.stop();
        }

        point.y += idPresetChList.contentY;

        if(point.y < 0) return;

        if(point.y > (idPresetChList.count * idMChListDelegate.height)) return;

        var indexByPoint = parseInt(point.y / idMChListDelegate.height);

        if(indexByPoint == idPresetChList.curIndex) return;

        idPresetChList.curIndex = indexByPoint;
        idPresetChList.itemMoved(0,0);
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
        var contentHeight = idPresetChList.count * height;
        if(isMoveUpScroll)
        {
            if(idPresetChList.contentY <= 50)
            {
                idPresetChList.contentY = 0;
                moveTimer.stop();
            }
            else
                idPresetChList.contentY -= 50;
            checkOnScrollMoved();
        }else
        {
            if(idPresetChList.contentY >= contentHeight - idPresetChList.height - 50)
            {
                idPresetChList.contentY = contentHeight - idPresetChList.height;
                moveTimer.stop();
            }
            else
                idPresetChList.contentY += 50;
            checkOnScrollMoved();
        }
    }

    function lockListView(ListIndex){
        idPresetChList.currentIndex = ListIndex
        idPresetChList.interactive = false;   // Cant't move list
        idPresetChList.insertedIndex = ListIndex; // Save slected index
        idPresetChList.curIndex = ListIndex;
        idPresetChList.isDragStarted = true;
        temp_contentY = idPresetChList.contentY;
        z = z+1;
    }

    function unlockListView(signal_curIndex){

        idPresetChList.isDragStarted = false;
        idPresetChList.interactive = true;
        idPresetChList.itemInitWidth();
        idPresetChList.currentIndex = signal_curIndex;
        idPresetChList.curIndex = -1;
        idPresetChList.insertedIndex = -1;
        idPresetChList.forceActiveFocus();
        temp_contentY = 0;
        z = z-1;
    }

    function setPresetListIndex(signal_iPresetListIndex,signal_insertedIndex, signal_curIndex, signal_Index)
    {
        //console.log("blacktip::===============1 "+CommParser.m_iPresetListIndex+":"+idPresetChList.insertedIndex+":"+idPresetChList.curIndex+":"+index)
        if( signal_iPresetListIndex < signal_insertedIndex && signal_iPresetListIndex < signal_curIndex)
        {
        }else if(signal_iPresetListIndex > signal_insertedIndex && signal_iPresetListIndex > signal_curIndex)
        {
        }else if(signal_iPresetListIndex > signal_insertedIndex && signal_iPresetListIndex <= signal_curIndex)
        {
            CommParser.m_iPresetListIndex = signal_iPresetListIndex - 1;
        }else if(signal_iPresetListIndex < signal_insertedIndex && signal_iPresetListIndex >= signal_curIndex)
        {

            CommParser.m_iPresetListIndex = signal_iPresetListIndex + 1;
        }else if(signal_Index == signal_insertedIndex)
        {
            CommParser.m_iPresetListIndex = signal_curIndex;
        }
        //console.log("blacktip::=============== 2 "+CommParser.m_iPresetListIndex+":"+idPresetChList.insertedIndex+":"+idPresetChList.curIndex+":"+index)
    }

    function checkOnScrollMoved(){

        var moveTempIndex = parseInt( (idPresetChList.contentY + lastMousePositionY) / height );

        if(moveTempIndex != idPresetChList.curIndex)
        {
            if(moveTempIndex >= 0 && moveTempIndex <= (idPresetChList.count-1))
            {
                idPresetChList.curIndex = moveTempIndex;
                idPresetChList.itemMoved(0,0);
            }
        }
    }

    // ### Delegate Event
    onActiveFocusChanged: {
//        console.log(" [JEON] onActiveFocusChanged:: activeFocus="+idMChListDelegate.activeFocus)
//        console.log(" [JEON] onActiveFocusChanged::currentIndex = "+idMChListDelegate.ListView.view.currentIndex+" index="+index+" m_iPresetListIndex"+CommParser.m_iPresetListIndex)

        //setPaintedWidth();

        if(idMChListDelegate.activeFocus == true)
        {
            if(idMChListDelegate.ListView.view.currentIndex == CommParser.m_iPresetListIndex)
            {
                focusMove = false;
                idMChListDelegate.state="keyRelease"
            }

            if(presetOrder){
                if(index == idMChListDelegate.ListView.view.currentIndex && secondTextOverPaintedWidth == true && idAppMain.drivingRestriction == false){
                    secondTextScrollEnable = true;
                }
            }else{
                if(index == CommParser.m_iPresetListIndex && secondTextOverPaintedWidth == true && idAppMain.drivingRestriction == false){
                    secondTextScrollEnable = true;
                }
            }
        }
        else
        {
            if(index == CommParser.m_iPresetListIndex)// && ((idAppMain.upKeyLongPressed == true ||idAppMain.downKeyLongPressed == true) || (presetOrder == true)))
            {
                focusMove = true;
                idMChListDelegate.state="keyRelease"
            }

            if(secondTextScrollEnable)
                secondTextScrollEnable = false;
        }
    }

    onMouseExit:{
//        console.log(" [JEON][chlistDelegate][onMouseExit")
        if(presetOrder == false)
        {
            idMChListDelegate.state="keyRelease"
        }
    }

    Component.onCompleted:{
        setPaintedWidth()
    }

//    onFocusImgVisibleChanged :{
//        if(presetOrder == true && isDragItem == true){
//            if(focusImgVisible == false && moveChannelSaving == false){
//                if(idPresetChList.insertedIndex >= 0 && idPresetChList.curIndex >= 0)
//                    EngineListener.selectChangeList(idPresetChList.insertedIndex, idPresetChList.curIndex, idPresetChList.contentY, CommParser.m_iPresetListIndex, index);
//            }
//        }
//    }

    Connections {
        target: idPresetChList
        onItemInitWidth: {
            isDragItem = false;
            idAppMain.isDragItemSelect = false;
            if(height*index > 0)
                y = height*index;
            else y = 0;
        }
        onItemMoved: {
            if(index < idPresetChList.insertedIndex && index < idPresetChList.curIndex)
            {
                y = height*index;
            }else if(index > idPresetChList.insertedIndex && index > idPresetChList.curIndex)
            {
                y = height*index;
            }else if(index > idPresetChList.insertedIndex && index <= idPresetChList.curIndex)
            {
                y = height*index - height;
            }else if(index < idPresetChList.insertedIndex && index >= idPresetChList.curIndex)
            {
                y = height*index + height;
            }else if(index == idPresetChList.insertedIndex)
            {
                y = height*idPresetChList.curIndex
            }
        }

        onContentYChanged: {
            if( (presetOrder == true) && (idMChListDelegate.isDragItem == true) && (idPresetChList.count <= 6) && (idAppMain.inputModeDMB == "touch") )
	    {
                idPresetChList.contentY = 0
            }
        }
    }

    Connections{
        target:EngineListener
        onSetChangeList:{
            var contentYBackup = signal_contentY;
            moveTimer.stop();
            isDragItem = false;
            idAppMain.isDragItemSelect = false;
            setPresetListIndex(signal_iPresetListIndex, signal_insertedIndex, signal_curIndex, signal_Index);
            unlockListView(signal_curIndex);
            idPresetChList.contentY = contentYBackup;
            moveChannelSaving = false;
//            idAppMain.dmbListPageInit(signal_curIndex);
        }

        onSetLockList:{
//            isDragItem = true;
            idAppMain.isDragItemSelect = true;
            if(index == ListIndex)
            {
                isDragItem = true;
            }
            else
            {
                isDragItem = false;
            }

            lockListView(ListIndex);
        }

        onRetranslateUi:{
//            setPaintedWidth()
        }
    }

//    Connections{
//        target: idAppMain
//        onSignalRefreshList: {
//            //idMChListDelegate.state = "";
//            idAppMain.beRefreshList = false;
//        }
//    }

    // # State
    onStateChanged:{
//        console.log("========>>[JEON][onStateChanged] idMChListDelegate.state: "+idMChListDelegate.state+" idMChListDelegate.active: "+idMChListDelegate.active +" index="+index)
//        console.log("========>>[JEON][onStateChanged] idMChListDelegate.ListView.view.currentIndex: "+idMChListDelegate.ListView.view.currentIndex)

        setPaintedWidth();

        if(idAppMain.inputModeDMB == "jog" && idMChListDelegate.state == "pressed")
        {
            idAppMain.listState = idMChListDelegate.state
        }

        if(idMChListDelegate.state == ""){
            if(/*index == CommParser.m_iPresetListIndex && */secondTextOverPaintedWidth == true && idAppMain.drivingRestriction == false){
                if(presetOrder){
                    if(index == idMChListDelegate.ListView.view.currentIndex)
                        secondTextScrollEnable = true;
                }else{
                    if(index == CommParser.m_iPresetListIndex)
                        secondTextScrollEnable = true;
                }
            }else{
                if(secondTextScrollEnable)
                    secondTextScrollEnable = false;
            }
        }

    }

    states: [
        State {
            name: 'pressed'; when: isMousePressed()// && idMChListDelegate.ListView.view.currentIndex == index
            PropertyChanges {target: idBgImg; source: bgImagePress;}
//            PropertyChanges {target: txtFirstText; color: firstTextPressColor}
//            PropertyChanges {target: txtSecondText; color: secondTextPressColor}
            PropertyChanges {target: idFocusImage; visible: false}
//            PropertyChanges {target: txtFirstText; color: firstTextPressColor; font.family: firstTextStyle;}
//            PropertyChanges {target: txtFirstText2; color: firstTextPressColor; font.family: firstTextStyle;}
//            PropertyChanges {target: txtSecondText; color: secondTextPressColor; font.family: secondTextStyle;}
//            PropertyChanges {target: txtSecondText2; color: secondTextPressColor; font.family: secondTextStyle;}
        },
        State {
            name: 'selected'; // when: CommParser.m_iPresetListIndex == index && idAppMain.inputMode == "jog"
            PropertyChanges {target: txtFirstText; color: firstTextColor}
            PropertyChanges {target: txtSecondText; color: secondTextColor}
        },
        State {
            name: 'focused'; when: CommParser.m_iPresetListIndex == index &&  idAppMain.inputMode == "touch"// && (!presetOrder)
            PropertyChanges {target: txtFirstText; color: firstTextSelectedColor}
            PropertyChanges {target: txtSecondText; color: secondTextSelectedColor}
        },
        State {
            name: 'keyPress'; when: idFocusImage.active
            PropertyChanges {target: idBgImg; source: bgImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
        },
        State {
            name: 'keyRelease'; when: (idAppMain.iskeyRelease == true)
            PropertyChanges {target: idBgImg; source: bgImage;}
            PropertyChanges {target: txtFirstText;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index && focusMove == true && idMChListDelegate.activeFocus == false) ? firstTextSelectedColor :
                                               (presetOrder == true && idPresetChList.interactive == false && idMChListDelegate.activeFocus == false) ? firstTextDisableColor : firstTextColor;
                                      font.family: (presetOrder == true) ? firstTextStyle :
                                                        (CommParser.m_iPresetListIndex == index && focusMove == true && idMChListDelegate.activeFocus == false) ? firstTextStyleB :
                                                        (CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus&& focusImgVisible == false) ? firstTextStyleB : firstTextStyle;
            }
            PropertyChanges {target: txtFirstText2;
                                      font.family: (presetOrder == true) ? firstTextStyle :
                                                       (CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? firstTextStyleB :
                                                       (presetOrder == false && CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? firstTextStyleB : firstTextStyle;
            }

            PropertyChanges {target: txtSecondText;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index && focusMove == true && idMChListDelegate.activeFocus == false) ? secondTextSelectedColor :
                                              (presetOrder == true && idPresetChList.interactive == false && idMChListDelegate.activeFocus == false) ? secondTextDisableColor : secondTextColor;
                                      font.family: (presetOrder == true) ? secondTextStyle :
                                                       (CommParser.m_iPresetListIndex == index && focusMove == true && idMChListDelegate.activeFocus == false) ? secondTextStyleB :
                                                       (CommParser.m_iPresetListIndex == index && focusImgVisible == false) ? secondTextStyleB : secondTextStyle;
            }

            PropertyChanges {target: txtSecondText2;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index && focusMove == true && idMChListDelegate.activeFocus == false) ? secondTextSelectedColor :
                                              (presetOrder == true && idPresetChList.interactive == false && idMChListDelegate.activeFocus == false) ? secondTextDisableColor : secondTextColor;
                                      font.family: (presetOrder == true) ? secondTextStyle :
                                                       (CommParser.m_iPresetListIndex == index && focusMove == true && idMChListDelegate.activeFocus == false) ? secondTextStyleB :
                                                       (CommParser.m_iPresetListIndex == index && focusImgVisible == false) ? secondTextStyleB : secondTextStyle;
            }
        },
        State {
            name: '';
            PropertyChanges {target: idBgImg; source: bgImage;}
            PropertyChanges {target: txtFirstText;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index && /*idMChListDelegate.activeFocus*/focusImgVisible == false) ? firstTextSelectedColor : firstTextColor;
                                      //font.family: (CommParser.m_iPresetListIndex == index && (idMChListDelegate.activeFocus == false || focusImgVisible == false)) ? firstTextStyleB:firstTextStyle;
                                      font.family: (presetOrder == true) ? firstTextStyle :
                                                       (presetOrder == false && CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? firstTextStyleB :
                                                       (presetOrder == false && CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? firstTextStyleB : firstTextStyle;

            }
            PropertyChanges {target: txtFirstText2;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index && /*idMChListDelegate.activeFocus*/focusImgVisible == false) ? firstTextSelectedColor : firstTextColor;
                                      //font.family: (CommParser.m_iPresetListIndex == index && (idMChListDelegate.activeFocus == false || focusImgVisible == false)) ? firstTextStyleB:firstTextStyle;
                                      font.family: (presetOrder == true) ? firstTextStyle :
                                                       (presetOrder == false && CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? firstTextStyleB :
                                                       (presetOrder == false && CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? firstTextStyleB : firstTextStyle;
            }
            PropertyChanges {target: txtSecondText;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index &&/*idMChListDelegate.activeFocus*/focusImgVisible == false)  ? secondTextSelectedColor : secondTextColor;
                                      //font.family: (CommParser.m_iPresetListIndex == index && (idMChListDelegate.activeFocus == false || focusImgVisible == false)) ? secondTextStyleB:secondTextStyle;
                                      font.family: (presetOrder == true) ? secondTextStyle :
                                                       (CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? secondTextStyleB :
                                                       (CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? secondTextStyleB : secondTextStyle;
            }
            PropertyChanges {target: txtSecondText2;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index &&/*idMChListDelegate.activeFocus*/focusImgVisible == false)  ? secondTextSelectedColor : secondTextColor;
                                      //font.family: (CommParser.m_iPresetListIndex == index && (idMChListDelegate.activeFocus == false || focusImgVisible == false)) ? secondTextStyleB:secondTextStyle;
                                      font.family: (presetOrder == true) ? secondTextStyle :
                                                       (CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? secondTextStyleB :
                                                       (CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? secondTextStyleB : secondTextStyle;
            }
        },
        State {
            name: 'refresh';  when: (idAppMain.beRefreshList == true);
            PropertyChanges {target: idBgImg; source: bgImage;}
            PropertyChanges {target: txtFirstText;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index && /*idMChListDelegate.activeFocus*/focusImgVisible == false) ? firstTextSelectedColor : firstTextColor;
                                      //font.family: (CommParser.m_iPresetListIndex == index && (idMChListDelegate.activeFocus == false || focusImgVisible == false)) ? firstTextStyleB:firstTextStyle;
                                      font.family: (presetOrder == true) ? firstTextStyle :
                                                       (presetOrder == false && CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? firstTextStyleB :
                                                       (presetOrder == false && CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? firstTextStyleB : firstTextStyle;

            }
            PropertyChanges {target: txtFirstText2;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index && /*idMChListDelegate.activeFocus*/focusImgVisible == false) ? firstTextSelectedColor : firstTextColor;
                                      //font.family: (CommParser.m_iPresetListIndex == index && (idMChListDelegate.activeFocus == false || focusImgVisible == false)) ? firstTextStyleB:firstTextStyle;
                                      font.family: (presetOrder == true) ? firstTextStyle :
                                                       (presetOrder == false && CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? firstTextStyleB :
                                                       (presetOrder == false && CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? firstTextStyleB : firstTextStyle;
            }
            PropertyChanges {target: txtSecondText;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index && /*idMChListDelegate.activeFocus*/focusImgVisible == false)  ? secondTextSelectedColor : secondTextColor;
                                      //font.family: (CommParser.m_iPresetListIndex == index && (idMChListDelegate.activeFocus == false || focusImgVisible == false)) ? secondTextStyleB:secondTextStyle;
                                      font.family: (presetOrder == true) ? secondTextStyle :
                                                       (CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? secondTextStyleB :
                                                       (CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? secondTextStyleB : secondTextStyle;
            }
            PropertyChanges {target: txtSecondText2;
                                      color: (presetOrder == false && CommParser.m_iPresetListIndex == index &&/*idMChListDelegate.activeFocus*/focusImgVisible == false)  ? secondTextSelectedColor : secondTextColor;
                                      //font.family: (CommParser.m_iPresetListIndex == index && (idMChListDelegate.activeFocus == false || focusImgVisible == false)) ? secondTextStyleB:secondTextStyle;
                                      font.family: (presetOrder == true) ? secondTextStyle :
                                                       (CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? secondTextStyleB :
                                                       (CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? secondTextStyleB : secondTextStyle;
            }
        },
        State {
            name: 'disabled'; when: (presetOrder == true && idPresetChList.interactive == false && idMChListDelegate.activeFocus == false);
            PropertyChanges {target: idBgImg; source: bgImage;}
            PropertyChanges {target: txtFirstText; color: firstTextDisableColor;
                                     //color: ( CommParser.m_iPresetListIndex == index && focusMove == true) ? firstTextSelectedColor : firstTextDisableColor;
                                     font.family: (presetOrder == true) ? firstTextStyle :
                                                      (CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? firstTextStyleB :
                                                       (CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? firstTextStyleB : firstTextStyle;
            }
            PropertyChanges {target: txtFirstText2; color: firstTextDisableColor;
                                     //color: ( CommParser.m_iPresetListIndex == index && focusMove == true) ? firstTextSelectedColor : firstTextDisableColor;
                                     font.family: (presetOrder == true) ? firstTextStyle :
                                                      (CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? firstTextStyleB :
                                                       (CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? firstTextStyleB : firstTextStyle;
            }
            PropertyChanges {target: txtSecondText; color: secondTextDisableColor;
                                     //color: ( CommParser.m_iPresetListIndex == index && focusMove == true) ? secondTextSelectedColor : secondTextDisableColor;
                                     font.family: (presetOrder == true) ? secondTextStyle :
                                                      (CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? secondTextStyleB :
                                                       (CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? secondTextStyleB : secondTextStyle;
            }
            PropertyChanges {target: txtSecondText2; color: secondTextDisableColor;
                                     //color: ( CommParser.m_iPresetListIndex == index && focusMove == true) ? secondTextSelectedColor : secondTextDisableColor;
                                     font.family: (presetOrder == true) ? secondTextStyle :
                                                      (CommParser.m_iPresetListIndex == index && idMChListDelegate.activeFocus == false) ? secondTextStyleB :
                                                       (CommParser.m_iPresetListIndex == index && focusImgVisible == false)  ? secondTextStyleB : secondTextStyle;
            }
          }
    ]
}

