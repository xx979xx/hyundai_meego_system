/*
  XMMovieTimesListSearchDelegate
  */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../../XMData/Javascript/ConvertUnit.js" as MConvertUnit


import Qt 4.7

// System Import
import "../../QML/DH" as MComp


MComp.MComponent {
    id: idListItem
    x:0; y:0
    z: index
    width:ListView.view.width-35-x; height:91

    property bool focusFavoriteBtn: false

    property bool distanceUnitChange: interfaceManager.DBIsMileDistanceUnit;

    //Signal
    signal goButtonClicked(int index, int entryID, string name, string address, string phonenumber, double latitude,double longitude, string statename, string city, string street, string zipcode, int amenityseating, int amenityrocker);


    Image {
        x: 0; y: parent.height //In GUI Guide this position is 88 (height-2)
        source: imageInfo.imgFolderGeneral + "list_line.png"
    }

    // Direction Image
    Image {
        id:idDirectionImage
        x:25/*[ITS 192688]*//*75*/
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

    Image {
        x: 75 + 83 + 155 + 17
        y: 0
        height: parent.height
        source: imageInfo.imgFolderXMData + "movie_divider.png"
    }

    //Distance
    Text {
        id: idPoint
        x: 75+83;
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

    //Theater Name
    MComp.DDScrollTicker{
        id: idText
        x: 75 + 83 + 155 + 17 + 22 ; y: 0;
        width: 439
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

    MComp.MButton {
        id: idGoButton
        x: 772+44
        y: 46-38
        width: 134; height: 79
        bgImage: imageInfo.imgFolderXMData + "btn_go_n.png"
        bgImagePress: imageInfo.imgFolderXMData + "btn_go_p.png"
        bgImageFocus: imageInfo.imgFolderXMData + "btn_go_f.png"
        firstTextX: 12
        firstText: stringInfo.sSTR_XMDATA_GO
        firstTextSize: 32
        firstTextStyle: systemInfo.font_NewHDB
        firstTextColor: colorInfo.brightGrey
        focus: !idAddFavoriteButton.focus

        onBackKeyPressed: {
            gotoBackScreen(false);
        }
        onHomeKeyPressed: {
            gotoFirstScreen();
        }
        onClickOrKeySelected: {
            idListItem.ListView.view.currentIndex = index;
            idListItem.ListView.view.currentItem.focusFavoriteBtn = false;
            goButtonClicked(index, entryID, theaterName, theaterAddr, theaterPhoneNum, latitude, longitude, stateName, city, street, zipcode, amenityseating, amenityrocker);
        }
    }

    MComp.MButton {
        id: idAddFavoriteButton
        x: 915+44
        y: 46-38
        width: 274; height: 79
        bgImage: imageInfo.imgFolderXMData + "btn_fav_n.png"
        bgImagePress: imageInfo.imgFolderXMData + "btn_fav_p.png"
        bgImageFocus: imageInfo.imgFolderXMData + "btn_fav_f.png"
        firstTextX: 9
        focus: focusFavoriteBtn

        firstText: movieTimesDataManager.isExistInFavoriteListModel(locID) ? stringInfo.sSTR_XMDATA_DELETEFAVORITE : stringInfo.sSTR_XMDATA_ADDFAVORITE
        firstTextSize: 26//32
        firstTextStyle: systemInfo.font_NewHDB
        firstTextColor: colorInfo.brightGrey

        onBackKeyPressed: {
            gotoBackScreen(false);
        }
        onHomeKeyPressed: {
            gotoFirstScreen();
        }

        onClickOrKeySelected: {
            idListItem.ListView.view.currentIndex = index;
            idCenterFocusScope.focus = true;
            idListItem.ListView.view.currentItem.focusFavoriteBtn = true;
            if(movieTimesDataManager.isExistInFavoriteListModel(locID))
            {
                movieTimesDataManager.setToFavoriteFromSearchListItem(entryID, false);
                idAddFavoriteButton.firstText = stringInfo.sSTR_XMDATA_ADDFAVORITE;
                showDeletedSuccessfully();
            }else
            {
                if(movieTimesDataManager.setToFavoriteFromSearchListItem(entryID, true))
                {
                    idAddFavoriteButton.firstText = stringInfo.sSTR_XMDATA_DELETEFAVORITE;
                    showAddedToFavorite(movieTimesDataManager.getRegisterFavoriteCount());
                }else{
                    showListIsFull();
                }
            }
        }
    }

    onClickOrKeySelected: {
        idListItem.ListView.view.currentIndex = index;
        idListItem.ListView.view.currentItem.focusFavoriteBtn = false;
//        itemClicked(idText.text);
//        console.log("[QML] XMWeatherSearchListDelegate - Pressed:"+index)
//        goButtonClicked(index, entryID, theaterName, theaterAddr, theaterPhoneNum, latitude, longitude, stateName, city, street, zipcode, amenityseating, amenityrocker);
    }

    onHomeKeyPressed: {
        gotoFirstScreen();
    }
    onBackKeyPressed: {
        gotoBackScreen(false);
    }
    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        if(focusFavoriteBtn == false)
        {
            focusFavoriteBtn = true;
        }
        else
        {
            ListView.view.moveOnPageByPage(rowPerPage, true);
            if(index != ListView.view.currentIndex)
            {
                ListView.view.currentItem.focusFavoriteBtn = false;
                focusFavoriteBtn = false;
            }
        }
    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        if(focusFavoriteBtn)
        {
            focusFavoriteBtn = false;
        }
        else
        {
            ListView.view.moveOnPageByPage(rowPerPage, false);
            if(index != ListView.view.currentIndex)
                ListView.view.currentItem.focusFavoriteBtn = true;
        }
    }
}
