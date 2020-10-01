/*
  XMMovieTimesListSelectDelegate
  */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../../XMData/Javascript/ConvertUnit.js" as MConvertUnit

XMDataAddDeleteCheckBoxListDelegate{
    id: idListItem
    x:0; y:0
    z: index
    width:ListView.view.width; height:92

    property string fav : favorite;
    property bool isAddFavorite:false;
    signal checkOn(int index);
    signal checkOff(int index);

    property bool distanceUnitChange: interfaceManager.DBIsMileDistanceUnit;
    property bool timeFormatChange: interfaceManager.DBIs24TimeFormat;
    property bool summerTime: false; // interfaceManager.DBIsDayLightSaving

    onCheckBoxOn:{
        //console.log(" checked entryID:" + entryID + ", index:"+index+", brand:" + brand)
        ListView.view.currentIndex = index;
        checkOn(index); //This signal will be catched by Delegate Definition.
    }
    onCheckBoxOff:{
        //console.log(" unchecked entryID:" + entryID + ", index:"+index+", brand:" + brand)
        ListView.view.currentIndex = index;
        checkOff(index) //This signal will be catched by Delegate Definition.
    }
    onClickOrKeySelected: {
        if(playBeepOn)
            UIListener.playAudioBeep();
        idListItem.ListView.view.currentIndex = index;
        itemClicked(idText.text);
        forceActiveFocus();
        toggleCheckBox();
    }
    onFavChanged: {
        if(fav == "on" || fav == "add" || fav == "deleteCheck")
            setCheckBoxOn();
        else if(fav == "off")
            setCheckBoxOff();
    }
    Component.onCompleted: {
        if(favorite == "on"){
            setCheckBoxOn();
        }
    }
    //=============================== Componet Layout
    property bool bFullMode : false;
    //Theater Name
    MComp.DDScrollTicker{
        id: idText
        x: (bFullMode)?75 + 83 + 155 + 17 + 22 : 281 + 40;//[ITS 188298]
        y: 0;
        width: 525-25
        height: parent.height
        text: theaterName
        fontFamily : systemInfo.font_NewHDB
        fontSize: 32
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

    Image {
        id: idMovieStartIcon
        x: 850
        y: 14 + 10
        source: imageInfo.imgFolderXMData + "ico_movie_start.png"
        visible: false
    }

    //Starting Time
    Text {
        id: idStarting
        x: 850 + 76
        width: 235
        height: parent.height;
        text: MConvertUnit.convertTimeFormatForOthers(startTime, summerTime, timeFormatChange);
        font.family: systemInfo.font_NewHDB
        font.pixelSize: 32
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        visible: false;// bFullMode

        //MXData.XMRectangleForDebug{}
    }

    //Distance
    Text {
        id: idPoint
        x: (bFullMode)?75+83:86 + 40;//[ITS 188298]
        y: 0//42 - font.pixelSize/2;
        width: 155
        height: parent.height;
        text: MConvertUnit.convertToDU(distanceUnitChange,distance) + (distanceUnitChange == false ? " km" : " mile")
        font.family: systemInfo.font_NewHDB
        font.pixelSize: 32
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        //MXData.XMRectangleForDebug{}
    }

//    // Under line
//    Image {
//        x: 0; y: parent.height
//        //source: imageInfo.imgFolderBt_phone + "line_list.png"
//        source: imageInfo.imgFolderMusic + "tab_list_line.png";//(bFullMode)?imageInfo.imgFolderGeneral + "list_line.png":imageInfo.imgFolderMusic + "tab_list_line.png";
//    }

    Image {
        x: (bFullMode)?75 + 83 + 155 + 17 : 258 + 40//[ITS 188298]
        y: 0
        height: parent.height
        source: imageInfo.imgFolderXMData + "movie_divider.png"
    }

    Image {
        x: 75 + 83 + 155 + 17 + 22 + 463 + 4 + 40//[ITS 188298]
        y: 0
        height: parent.height
        source: imageInfo.imgFolderXMData + "movie_divider.png"
        visible: bFullMode
    }

    // Direction Image
    Image {
        id:idDirectionImage
        x:(bFullMode)?75:0//[ITS 188298]
        anchors.verticalCenter: parent.verticalCenter;
        source: selectSource(direction)
        function selectSource(jDirection) {
            var direct = parseInt(jDirection);
            if( direct > 341 || direct <= 11 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_01.png";
            else if( direct > 11 && direct <= 33 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_02.png";
            else if( direct > 33 && direct <= 55 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_03.png";
            else if( direct > 55 && direct <= 77 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_04.png";
            else if( direct > 77 && direct <= 99 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_05.png";
            else if( direct > 99 && direct <= 121 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_06.png";
            else if( direct > 121 && direct <= 143 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_07.png";
            else if( direct > 143 && direct <= 165 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_08.png";
            else if( direct > 165 && direct <= 187 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_09.png";
            else if( direct > 187 && direct <= 209 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_10.png";
            else if( direct > 209 && direct <= 231 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_11.png";
            else if( direct > 231 && direct <= 253 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_12.png";
            else if( direct > 253 && direct <= 275 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_13.png";
            else if( direct > 275 && direct <= 297 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_14.png";
            else if( direct > 297 && direct <= 319 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_15.png";
            else if( direct > 319 && direct <= 341 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_16.png";
            else
                return imageInfo.imgFolderXMData + "direction/ico_direction_05.png";
        }
        //MXData.XMRectangleForDebug{}
    }



    //=============================== Debug Info
    Rectangle{
        id:idDebugInfoView
        z:200
        visible:isDebugMode()
        Column{
            id:idDebugInfo1
            x: 10
            y: 70
            Text{text: "["+index+"]["+selectedIndex+"] entryID:" + entryID +" szListMode : " + ", Fav:" + favorite; color: "white"; }
            Text{text: "name: "+theaterName+", s:" + startTime +", addr: "+theaterAddr+" [" + theaterPhoneNum+"]"; color: "white"; }
        }
        Column{
            id:idDebugInfo2
            x:400; y:5
            Row{
                spacing:10
                Column{
                    Text{text: "dist : " + distance; color: "white"; }
                    Text{text: "dir  : " + direction; color: "white"; }
                }
                Column{
                    Text{text: "lati : " + latitude; color: "white"; }
                    Text{text: "long : " + longitude; color: "white"; }
                }
            }
        }
    }
}
