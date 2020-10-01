import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../../XMData/Javascript/ConvertUnit.js" as MConvertUnit

MComp.MComponent {
    id: idListItem
    x:0; y:0
    z: index
    width:idListItem.ListView.view.width;
    height:92
    property bool bFullMode : szListMode == "normal" ? false : true
    property bool bFavMode : szFavListMode == "fav" ? true : false
    property int selectedIndex;

    property bool focusGoBtn: false;

    property bool distanceUnitChange: interfaceManager.DBIsMileDistanceUnit;
    property bool timeFormatChange: interfaceManager.DBIs24TimeFormat;
    property bool summerTime: false; // interfaceManager.DBIsDayLightSaving

    //Signal
    signal goButtonClicked(int index, int entryID, string name, string address, string phonenumber, double latitude,double longitude, string statename, string city, string street, string zipcode, int amenityseating, int amenityrocker);
//    signal showSeeOrAddFav(int index, int entryID, string name, string address, string phonenumber, double latitude,double longitude, string statename, string city, string street, string zipcode, int amenityseating, int amenityrocker, int locID);

    Image {
        x: 0; y: parent.height
        source: bFullMode ?  imageInfo.imgFolderGeneral + "list_line.png" : imageInfo.imgFolderMusic + "tab_list_line.png"
    }

    MComp.MButton{
        id: idBtnText
        x: 0; y:0
        width: bFullMode ? 1080 : bFavMode ? 880 : 850; height: 97
        bgImage: ""
        bgImageFocus: bFullMode? "" : imageInfo.imgFolderXMData + "xm_list_f.png"
        bgImagePress: bFullMode ? "" : imageInfo.imgFolderXMData + "xm_list_p.png"
        focus: !focusGoBtn
        isMuteButton: bFullMode ? true : false

        //Theater Name
        MComp.DDScrollTicker{
            id: idText
            x: (bFullMode)?75 + 83 + 155 + 17 + 22 : bFavMode ? 311 : 281;
            y:0;
            width: (bFullMode)? 463 : 512;
            height: parent.height
            text: theaterName
            fontFamily : systemInfo.font_NewHDR
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
            visible: bFullMode
        }

        //Starting Time
        Text {
            id: idStarting
            x: 850 + 76
            width: 251
            height: parent.height;
            text: startTime == 0 ? "" : MConvertUnit.convertTimeFormatForOthers(startTime, summerTime, timeFormatChange);
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 32
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            visible: bFullMode

            //MXData.XMRectangleForDebug{}
        }

        //Distance
        Text {
            id: idPoint
            x: (bFullMode)?75+83 : bFavMode ? 116 : 86;
            y: 0//42 - font.pixelSize/2;
            width: 155
            height: parent.height;
            text: MConvertUnit.convertToDU(distanceUnitChange,distance) + (distanceUnitChange == false ? " km" : " mile")
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 32
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter

            //MXData.XMRectangleForDebug{}
        }

        Image {
            x: (bFullMode)?75 + 83 + 155 + 17 : bFavMode ? 288 : 258
            y: 0
            source: imageInfo.imgFolderXMData + "movie_divider.png"
        }

        Image {
            x: 75 + 83 + 155 + 17 + 22 + 463 + 4
            y: 0
            source: imageInfo.imgFolderXMData + "movie_divider.png"
            visible: bFullMode
        }

        Image {
            id:idDirectionImage
            x:(bFullMode)?75 : bFavMode ? 0 : 6
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

        onClickOrKeySelected: {
            if(bFullMode == false)
            {
                if(pressAndHoldFlag == false){
                    idListItem.ListView.view.currentIndex = index;
                    idListItem.ListView.view.currentItem.focusGoBtn = false;
                    selectTheaterMovie(index, entryID, theaterName, theaterAddr, theaterPhoneNum, latitude, longitude, stateName, city, street, zipcode, amenityseating, amenityrocker, locID);
                }
            }else
            {
                idListItem.ListView.view.currentIndex = index;
                idListItem.ListView.view.currentItem.focusGoBtn = true;
            }
        }
    }


    // Go Button/
    MComp.MButton{
        id:idGoButton
        x: (bFullMode)?75 + 83 + 155 + 17 + 22 + 463 + 4 + 21 + 251 : bFavMode ? 831 : 801
        y: 8
        width: 134; height: 79
        focus: focusGoBtn || bFullMode

        bgImage:            imageInfo.imgFolderXMData + "btn_go_n.png"
        bgImagePress:       imageInfo.imgFolderXMData + "btn_go_p.png"
        bgImageFocus:       imageInfo.imgFolderXMData + "btn_go_f.png"

        firstText: stringInfo.sSTR_XMDATA_GO
        firstTextX: 12
        firstTextSize:32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.font_NewHDB
        onClickOrKeySelected: {
            idListItem.ListView.view.currentIndex = index;
            idListItem.ListView.view.currentItem.focusGoBtn = true;
            goButtonClicked(index, entryID, theaterName, theaterAddr, theaterPhoneNum, latitude, longitude, stateName, city, street, zipcode, amenityseating, amenityrocker);
        }
    }

    onHomeKeyPressed: {
        gotoFirstScreen();
    }
    onBackKeyPressed: {
        gotoBackScreen(false);//CCP
    }
    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        if(focusGoBtn == false && !bFullMode)
        {
            focusGoBtn = true;
        }
        else
        {
            ListView.view.moveOnPageByPage(rowPerPage, true);
            if(bFullMode)
                ListView.view.currentItem.focusGoBtn = true;
            else if(index != ListView.view.currentIndex)
                ListView.view.currentItem.focusGoBtn = false;
        }

    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        if(focusGoBtn == true && !bFullMode)
        {
            focusGoBtn = false;
        }
        else
        {
            ListView.view.moveOnPageByPage(rowPerPage, false);
            if(index != ListView.view.currentIndex)
                ListView.view.currentItem.focusGoBtn = true;
        }
    }
    Rectangle{
        x:25
        y:20
        visible:isDebugMode();
        Column{
            Row{
                Text{
                    color : "red";
                    text: "[theaterName]" + theaterName
                }
            }
        }
    }
}
