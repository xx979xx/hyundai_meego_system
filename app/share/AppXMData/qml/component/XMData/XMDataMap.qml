/**
 * FileName: Map.qml
 * Author: HYANG
 * Time: 2012-10
 *
 * - 2012-10 Initial Created by HYANG
 */

import Qt 4.7
import AGWDataMapItem 1.0
import AGWDataMapBackground 1.0

import "../QML/DH" as MComp

MComp.MComponent {
    id: idMap

    property alias tileSupport: idAGW_DatamapItem.TileSupport;

    property string imgPath: imageInfo.imgFolderXMData+"WeatherMaps_1280_720/Map_With_Labels/"
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    //*****************************************# Receiving value
    property int zoomLevel: 1      //# 1, 2, 4, 8
    property int moveInterval: 20
    //*****************************************#
    property int viewportX: 0
    property int viewportY: 0
    //*****************************************# Key Pressed
    property bool upKeyPressed: idAppMain.upKeyPressed;
    property bool downKeyPressed: idAppMain.downKeyPressed;
    property bool rightKeyPressed: idAppMain.rightKeyPressed;
    property bool leftKeyPressed: idAppMain.leftKeyPressed;
    property bool enterKeyPressed: idAppMain.enterKeyPressed;
    property bool upKeyLongPressed: idAppMain.upKeyLongPressed;
    property bool downKeyLongPressed: idAppMain.downKeyLongPressed;
    property bool leftKeyLongPressed: idAppMain.leftKeyLongPressed;
    property bool rightKeyLongPressed: idAppMain.rightKeyLongPressed;
//    property bool wheelLeftKeyPressed: idAppMain.wheelLeftKeyPressed;
//    property bool wheelRightKeyPressed: idAppMain.wheelRightKeyPressed;

    property bool upleftKeyLongPressed: idAppMain.upleftKeyLongPressed;
    property bool uprightKeyLongPressed: idAppMain.uprightKeyLongPressed;
    property bool downleftKeyLongPressed: idAppMain.downleftKeyLongPressed;
    property bool downrightKeyLongPressed: idAppMain.downrightKeyLongPressed;


    property int longPressDirection: 0

    property string agwCurrLocPath: imageInfo.imgFolderXMData + "ico_radar_location.png";

    property double curLon: weatherDataManager.fCurLon
    property double curLat: weatherDataManager.fCurLat
    property int currLocX: 0//weatherAGWDataManager.getCurrentLocPointX(curLon, zoomLevel) - (104/2);
    property int currLocY: 0//weatherAGWDataManager.getCurrentLocPointY(curLat, zoomLevel) - 93;

    onCurLonChanged: {
        currLocX = weatherAGWDataManager.getCurrentLocPointX(curLon, zoomLevel) - (104/2);
    }
    onCurLatChanged: {
        currLocY = weatherAGWDataManager.getCurrentLocPointY(curLat, zoomLevel) - 93;
    }

    //*****************************************# Map Image(Up_Left, Up_Right, Down_Left, Down_Right)
    Item {
        x: 0
        y: 0

        Item {
            id:idImageTest
            x: viewportX;
            y: viewportY;
            z: 0
            width:1280*zoomLevel;
            height: 720*zoomLevel;

            Repeater{
                id: idRepeater
                model: zoomLevel*zoomLevel
                AGWDataMapBackground{
                    id:idImageBG
                    x:(parseInt(index%zoomLevel)*1280)
                    y:(parseInt(index/zoomLevel)*720)
                    width: 1280
                    height: 720
                    property int imageIndexX: parseInt(index%zoomLevel)
                    property int imageIndexY: parseInt(index/zoomLevel)
                    property int pointX: idImageTest.x
                    property int pointY: idImageTest.y
                    property int zoom: zoomLevel

                    onZoomChanged: {
                        source = getSource();
                    }
                    onPointXChanged: {
                        source = getSource();
                    }
                    onPointYChanged: {
                        source = getSource();
                    }

                    function getSource()
                    {
                        var currentViewIndexX = (parseInt(pointX/1280)*-1) - imageIndexX;
                        var currentViewIndexY = (parseInt(pointY/720)*-1) - imageIndexY;


                        if((currentViewIndexX >= -1 && currentViewIndexX<= 1) && (currentViewIndexY >= -1 && currentViewIndexY <= 1))
                        {
                            return zoomLevel + "x_" + (parseInt(index/zoomLevel)+1) + "_" + parseInt(parseInt(index%zoomLevel)+1)
                        }
                        return "";
                    }
                }
            }

//            Image{
//                id:idAGW_CurrLoc
//                x: currLocX
//                y: currLocY
//                z: idAGW_DatamapItem.z+1;
//                property int zoom: zoomLevel;
//                source: agwCurrLocPath;
//                onZoomChanged: {
//                    currLocX = weatherAGWDataManager.getCurrentLocPointX(weatherDataManager.fCurLon, zoomLevel) - (104/2);
//                    currLocY = weatherAGWDataManager.getCurrentLocPointY(weatherDataManager.fCurLat, zoomLevel) - 93;
//                }
//            }

        }

        MouseArea{
            x:0; y:0; width: 1280; height: 720
            enabled: idOptionMenu.activeFocus == false//[ISV 91880]

            property int startX: 0
            property int startY: 0
            property int originalX: 0
            property int originalY: 0

            onMousePositionChanged: {
                var movedX = (startX - mouse.x)*-1;
                var movedY = (startY - mouse.y)*-1;

                var preViewportX = viewportX + movedX;
                var preViewportY = viewportY + movedY;

                if(preViewportX >= 0)
                    preViewportX = 0;
                else if(preViewportX <= -(1280*zoomLevel-1280))
                    preViewportX = -(1280*zoomLevel-1280);

                if(preViewportY >= 0)
                    preViewportY = 0;
                else if(preViewportY <= -(720*zoomLevel-720))
                    preViewportY = -(720*zoomLevel-720);

                viewportX = preViewportX;
                viewportY = preViewportY;

                startX = mouse.x;
                startY = mouse.y;

            }
            onPressed: {
                UIListener.playAudioBeep();
                startX = mouse.x;
                startY = mouse.y;

                originalX = startX;
                originalY = startY;
            }
            onReleased: {
                if(mouse.x >= (originalX - 5) && mouse.x <= (originalX + 5))
                    if(mouse.y >= (originalY - 5) && mouse.y <= (originalY +5))
                        idWeatherRadarMain.openForRadar();
            }
        }

        AGWDataMapItem{
            id:idAGW_DatamapItem
            x: viewportX;
            y: viewportY;
            width:1280*zoomLevel;
            height: 720*zoomLevel;

            Image{
                id:idAGW_CurrLoc
                x: currLocX
                y: currLocY
                z: idAGW_DatamapItem.z+1;
                property int zoom: zoomLevel;
                source: agwCurrLocPath;
                onZoomChanged: {
                    currLocX = weatherAGWDataManager.getCurrentLocPointX(curLon, zoomLevel) - (104/2);
                    currLocY = weatherAGWDataManager.getCurrentLocPointY(curLat, zoomLevel) - 93;
                }
            }
        }

        Image {
            id: idRegend
            x:1068; y: 403;
            z: idAGW_DatamapItem.z+1;
            source: imageInfo.imgFolderXMDataWeather+"bg_legend.png"
            visible: (tileSupport & idAGW_DatamapItem.E_NOWRAD) == true

//            Text {
//                x: 17; y: 12
//                text: "Legend (dbz)"//[ITS 188578]
//                visible: parent.visible
//                color: colorInfo.brightGrey
//                font.pixelSize: 20
//                font.family: systemInfo.font_NewHDB
//                horizontalAlignment: Text.AlignVCenter
//                verticalAlignment: Text.AlignVCenter
//            }
//            Text {
//                x: 124; y: 55
//                text: "Snow"
//                visible: parent.visible
//                color: colorInfo.brightGrey
//                font.pixelSize: 18
//                font.family: systemInfo.font_NewHDR
//                horizontalAlignment: Text.AlignVCenter
//                verticalAlignment: Text.AlignVCenter
//            }
//            Text {
//                x: 124; y: 106
//                text: "Mixed"
//                visible: parent.visible
//                color: colorInfo.brightGrey
//                font.pixelSize: 18
//                font.family: systemInfo.font_NewHDR
//                horizontalAlignment: Text.AlignVCenter
//                verticalAlignment: Text.AlignVCenter
//            }
//            Text {
//                x: 124; y: 207
//                text: "Rain"
//                visible: parent.visible
//                color: colorInfo.brightGrey
//                font.pixelSize: 18
//                font.family: systemInfo.font_NewHDR
//                horizontalAlignment: Text.AlignVCenter
//                verticalAlignment: Text.AlignVCenter
//            }
        }

// tools // mini map   // do not delete!!
//        Item{
//            id: idTools
//            x: sizeWidth*3-20
//            y: sizeHeight*3-100
//            width: sizeWidth
//            height: sizeHeight
//            opacity: 0.7
//            visible: true //for debug
//            property int sizeWidth: parseInt(1280/4)
//            property int sizeHeight: parseInt(720/4)
//            Repeater{
//                id: idToolsRepeater
//                model: zoomLevel*zoomLevel
//                Image{
//                    id:idToolsImageBG
//                    x: (parseInt(index%zoomLevel)*parseInt(idTools.sizeWidth/zoomLevel))
//                    y:(parseInt(index/zoomLevel)*parseInt(idTools.sizeHeight/zoomLevel))
//                    width:idTools.sizeWidth/zoomLevel
//                    height:idTools.sizeHeight/zoomLevel
//                    asynchronous: true
//                    focus: true
//                    property int imageIndexX: parseInt(index%zoomLevel)
//                    property int imageIndexY: parseInt(index/zoomLevel)
//                    property int pointX: idImageTest.x
//                    property int pointY: idImageTest.y
//                    property int zoom: zoomLevel

//                    onZoomChanged: {
//                        source = getSource();
//                    }
//                    onPointXChanged: {
//                        source = getSource();
//                    }
//                    onPointYChanged: {
//                        source = getSource();
//                    }
//                    function getSource()
//                    {
//                        var currentViewIndexX = (parseInt(pointX/1280)*-1) - imageIndexX;
//                        var currentViewIndexY = (parseInt(pointY/720)*-1) - imageIndexY;
////                        if((currentViewIndexX >= -2 && currentViewIndexX<= 2) && (currentViewIndexY >= -2 && currentViewIndexY <= 2))
//                        if((currentViewIndexX >= -1 && currentViewIndexX<= 1) && (currentViewIndexY >= -1 && currentViewIndexY <= 1))
//                        {
////                            return imgPath + zoomLevel + "x_" + (parseInt(index/zoomLevel)+1) + "_" + parseInt(parseInt(index%zoomLevel)+1) + ".png"
//                            return "image://mapForNA//" + zoomLevel + "x_" + (parseInt(index/zoomLevel)+1) + "_" + parseInt(parseInt(index%zoomLevel)+1)
//                        }
//                        return "";
//                    }
//                    Component.onCompleted: {
//                        idToolsImageBG.cache = false;
//                    }
//                }
//            }
//            Rectangle{
//                x:0;y:0
//                width: parent.width
//                height: parent.height
//                border.color: "red"
//                border.width: 1
//                color:"transparent"
//            }
//            Rectangle{
//                x:(viewportX/zoomLevel)/4 < 0 ? ((viewportX/zoomLevel)/4)*-1 : (viewportX/zoomLevel)/4;
//                y:(viewportY/zoomLevel)/4 < 0 ? ((viewportY/zoomLevel)/4)*-1 : (viewportY/zoomLevel)/4;
//                width: idTools.sizeWidth/zoomLevel
//                height: idTools.sizeHeight/zoomLevel - ((720-628)/4/zoomLevel)
//                border.color: "red"
//                border.width: 1
//                color:"transparent"
//            }
//        }
    }

    //***********in******************************# Coordinate move of mapImage
    function mapCoordinate(zoom){
        var fCenterX = (100 / ((1280*zoomLevel) / ((viewportX*-1)+640)))
        var fCenterY = (100 / ((720*zoomLevel) / ((viewportY*-1)+360)))

        var fNewCenterX = ((1280*zoom) / 100)* fCenterX
        var fNewCenterY = ((720*zoom) / 100)* fCenterY

        viewportX = (fNewCenterX-640) < 0 ? 0 : ((fNewCenterX-640)*-1) < ((1280*(zoom-1))*-1) ? ((1280*(zoom-1))*-1) : ((fNewCenterX-640)*-1)
        viewportY = (fNewCenterY-360) < 0 ? 0 : ((fNewCenterY-360)*-1) < ((720*(zoom-1))*-1) ? ((720*(zoom-1))*-1) : ((fNewCenterY-360)*-1)

        zoomLevel = zoom;
    }

    //*****************************************# Map Image / CurrentPoint Move
    function mapLeftMoveFunc(){ //*************# Left Move
        if(viewportX >= 0)
            viewportX = 0;
        else
            viewportX+= moveInterval;
        return;
    }
    function mapRightMoveFunc(){//************# Right Move
        if(viewportX <= -(1280*zoomLevel-1280))
            viewportX = -(1280*zoomLevel-1280);
        else
            viewportX-= moveInterval;
        return;
    }
    function mapUpMoveFunc(){   //************# Up Move
        if(viewportY >= 0)
            viewportY = 0;
        else
            viewportY+= moveInterval;
        return;
    }
    function mapDownMoveFunc(){ //************# Down Move
        if(viewportY <= -(720*zoomLevel-720))
            viewportY = -(720*zoomLevel-720);
        else
            viewportY-= moveInterval;
        return;
    }
    function mapCurrentPositionMoveFunc(){
        var targetX = weatherAGWDataManager.getCurrentLocPointX(curLon, zoomLevel);
        var targetY = weatherAGWDataManager.getCurrentLocPointY(curLat, zoomLevel);

        var tempX = targetX - (1280/2);
        var tempY = targetY - (720/2);

        if(tempX <= 0)
            tempX = 0;
        else if(tempX > ((1280*zoomLevel)-1280))
            tempX = (1280*zoomLevel)-1280;

        if(tempY <= 0)
            tempY = 0;
        else if(tempY > ((720*zoomLevel)-720))
            tempY = (720*zoomLevel)-720;

        viewportX = tempX * -1;
        viewportY = tempY * -1;
    }

    function mapRemoteSelectForUpdate(type)
    {
        var tile = tileSupport;
        switch(type)
        {
        case 0:
            tile ^= idAGW_DatamapItem.E_NOWRAD;
            break;
        case 1:
            tile ^= 0x00;
            break;
        case 2:
            tile ^= 0x00;
            break;
        case 3:
            tile ^= idAGW_DatamapItem.E_FRONT;
            break;
        case 4:
            tile ^= idAGW_DatamapItem.E_ISOBAR;
            break;
        case 5:
            tile ^= idAGW_DatamapItem.E_PRESSURECENTER;
            break;
        case 6:
            tile ^= idAGW_DatamapItem.E_STORMATTRIBUTES;
            break;
        case 7:
            tile ^= idAGW_DatamapItem.E_STORMPOSITION;
            break;
        case 8:
            tile ^= idAGW_DatamapItem.E_WINDRADII;
            break;
        }

        if(tile != tileSupport)
        {
            tileSupport = tile;
            idAGW_DatamapItem.saveSupportFlag(tileSupport);
        }
    }

    function agwCoordinateForUpdate()
    {
        idAGW_DatamapItem.TileSupport = idAGW_DatamapItem.TileSupport;
    }

    //*****************************************# Map Move (Key) Test

    onLeftKeyPressedChanged: {
        if(leftKeyPressed == true && idMap.activeFocus == true)
            mapLeftMoveFunc();
    }
    onRightKeyPressedChanged: {
        if(rightKeyPressed == true && idMap.activeFocus == true)
            mapRightMoveFunc();
    }
    onUpKeyPressedChanged: {
        if(upKeyPressed == true && idMap.activeFocus == true)
            mapUpMoveFunc();
    }
    onDownKeyPressedChanged: {
        if(downKeyPressed == true && idMap.activeFocus == true)
            mapDownMoveFunc()
    }

    onUpLeftKeyPressed: {
        mapLeftMoveFunc();
        mapUpMoveFunc();
    }

    onUpRightKeyPressed: {
        mapRightMoveFunc();
        mapUpMoveFunc();
    }

    onDownLeftKeyPressed: {
        mapDownMoveFunc();
        mapLeftMoveFunc();
    }

    onDownRightKeyPressed: {
        mapDownMoveFunc();
        mapRightMoveFunc();
    }

    onEnterKeyPressedChanged: {
        if(enterKeyPressed == true && idMap.activeFocus == true)
            mapCurrentPositionMoveFunc();
    }

    onWheelLeftKeyPressed: {
        if(idMap.activeFocus == true)
        {
            mapCoordinate(zoomLevel == 1 ? 1 : zoomLevel/2)
            agwCoordinateForUpdate();
        }
    }

    onWheelRightKeyPressed: {
        if(idMap.activeFocus == true)
        {
            mapCoordinate(zoomLevel == 8 ? 8 : zoomLevel*2)
            agwCoordinateForUpdate();
        }
    }

    onUpKeyLongPressedChanged: {
        if(upKeyLongPressed && idMap.activeFocus == true)
        {
            longPressDirection = 0;
            idLongKeyTimer.start()
        }else
        {
            idLongKeyTimer.stop();
        }
    }

    onDownKeyLongPressedChanged: {
        if(downKeyLongPressed && idMap.activeFocus == true)
        {
            longPressDirection = 1;
            idLongKeyTimer.start();
        }else
        {
            idLongKeyTimer.stop();
        }
    }

    onLeftKeyLongPressedChanged: {
        if(leftKeyLongPressed && idMap.activeFocus == true)
        {
            longPressDirection = 2;
            idLongKeyTimer.start();
        }else
        {
            idLongKeyTimer.stop();
        }
    }

    onRightKeyLongPressedChanged: {
        if(rightKeyLongPressed && idMap.activeFocus == true)
        {
            longPressDirection = 3;
            idLongKeyTimer.start();
        }else
        {
            idLongKeyTimer.stop();
        }
    }

    onUpleftKeyLongPressedChanged: {
        if(upleftKeyLongPressed && idMap.activeFocus == true)
        {
            longPressDirection = 4;
            idLongKeyTimer.start();
        }else
        {
            idLongKeyTimer.stop();
        }
    }

    onUprightKeyLongPressedChanged: {
        if(uprightKeyLongPressed && idMap.activeFocus == true)
        {
            longPressDirection = 5;
            idLongKeyTimer.start();
        }else
        {
            idLongKeyTimer.stop();
        }
    }

    onDownleftKeyLongPressedChanged: {
        if(downleftKeyLongPressed && idMap.activeFocus == true)
        {
            longPressDirection = 6;
            idLongKeyTimer.start();
        }else
        {
            idLongKeyTimer.stop();
        }
    }

    onDownrightKeyLongPressedChanged: {
        if(downrightKeyLongPressed && idMap.activeFocus == true)
        {
            longPressDirection = 7;
            idLongKeyTimer.start();
        }else
        {
            idLongKeyTimer.stop();
        }
    }

    Timer{
        id: idLongKeyTimer
        interval: 100
        repeat: true
        running: false
//        triggeredOnStart: true
        onTriggered:
        {
            switch(longPressDirection)
            {
                case 0:
                {
                    mapUpMoveFunc();
                    break;
                }
                case 1:
                {
                    mapDownMoveFunc();
                    break;
                }
                case 2:
                {
                    mapLeftMoveFunc();
                    break;
                }
                case 3:
                {
                    mapRightMoveFunc();
                    break;
                }
                case 4:
                {
                    mapUpMoveFunc();
                    mapLeftMoveFunc();
                    break;
                }
                case 5:
                {
                    mapUpMoveFunc();
                    mapRightMoveFunc();
                    break;
                }
                case 6:
                {
                    mapDownMoveFunc();
                    mapLeftMoveFunc();
                    break;
                }
                case 7:
                {
                    mapDownMoveFunc();
                    mapRightMoveFunc();
                    break;
                }
                default:
                    break;
            }
        }
    }

    //[ITS 191210]
    Connections {
        target: UIListener

        onTemporalModeMaintain:{
            if(idLongKeyTimer.running == true)
            {
                idLongKeyTimer.stop();
            }
        }

        onSignalShowSystemPopup:{
            if(idLongKeyTimer.running == true && idMap.visible == true)
            {
                idMap.focus = false;
                idLongKeyTimer.stop();
            }
            if(idAppMain.isFullScreen == 2)
                idWeatherRadarMain.openForRadar();
        }

        onSignalHideSystemPopup:{
            idMap.focus = true;
        }
    }

// Delete Zoom Button :: blacktip
//    //*****************************************# 1x Button Test
//    MComp.MButton{
//        x: 50; y: 10
//        width: 20; height: 20
//        bgImage: imgFolderGeneral+"checkbox_uncheck.png"
//        firstText: "1x"
//        firstTextX: 0
//        firstTextY: 10
//        firstTextSize: 12
//        firstTextWidth: 20
//        firstTextHeight: 20
//        firstTextStyle: systemInfo.font_NewHDB
//        firstTextColor: colorInfo.black
//        firstTextAlies: "Center"
//        firstTextVerticalAlies: "Center"
//        onClickOrKeySelected: {
//            mapCoordinate(1);
//            clearMemAGWData();
//        }
//    }
//    //*****************************************# 2x Button Test
//    MComp.MButton{
//        x: 75; y: 10
//        width: 20; height: 20
//        bgImage: imgFolderGeneral+"checkbox_uncheck.png"
//        firstText: "2x"
//        firstTextX: 0
//        firstTextY: 10
//        firstTextSize: 12
//        firstTextWidth: 20
//        firstTextHeight: 20
//        firstTextStyle: systemInfo.font_NewHDB
//        firstTextColor: colorInfo.black
//        firstTextAlies: "Center"
//        firstTextVerticalAlies: "Center"
//        onClickOrKeySelected: {
//            mapCoordinate(2);
//            clearMemAGWData();
//        }
//    }
//    //*****************************************# 4x Button Test
//    MComp.MButton{
//        x: 100; y: 10
//        width: 20; height: 20
//        bgImage: imgFolderGeneral+"checkbox_uncheck.png"
//        firstText: "4x"
//        firstTextX: 0
//        firstTextY: 10
//        firstTextSize: 12
//        firstTextWidth: 20
//        firstTextHeight: 20
//        firstTextStyle: systemInfo.font_NewHDB
//        firstTextColor: colorInfo.black
//        firstTextAlies: "Center"
//        firstTextVerticalAlies: "Center"
//        onClickOrKeySelected: {
//            mapCoordinate(4);
//            clearMemAGWData();
//        }
//    }
//    //*****************************************# 8x Button Test
//    MComp.MButton{
//        x: 125; y: 10
//        width: 20; height: 20
//        bgImage: imgFolderGeneral+"checkbox_uncheck.png"
//        firstText: "8x"
//        firstTextX: 0
//        firstTextY: 10
//        firstTextSize: 12
//        firstTextWidth: 20
//        firstTextHeight: 20
//        firstTextStyle: systemInfo.font_NewHDB
//        firstTextColor: colorInfo.black
//        firstTextAlies: "Center"
//        firstTextVerticalAlies: "Center"
//        onClickOrKeySelected: {
//            mapCoordinate(8);
//            clearMemAGWData();
//        }
//    }
}
