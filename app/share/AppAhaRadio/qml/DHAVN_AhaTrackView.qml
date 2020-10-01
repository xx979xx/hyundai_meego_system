import Qt 4.7
//wsuk.kim title_bar   import QmlModeAreaWidget 1.0
import QmlSimpleItems 1.0
import QmlOptionMenu 1.0
import AppEngineQMLConstants 1.0
import AhaMenuItems 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0   //wsuk.kim 130719 popup type change from toast to text

import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES

Item {
    id: ahaTrackView
    y: PR.const_AHA_ALL_SCREENS_TOP_OFFSET
    anchors.bottomMargin: PR.const_AHA_ALL_SCREEN_BOTTOM_MARGIN

    //QML Properties Declarations
    property int counter: PR.const_AHA_TIMER_COUNTER_MIN_VAL
    property int nTuneIndex : 0 //wsuk.kim TUNE
    property int nPlayBackStatus: 0 //wsuk.kim buffering
    property int nFocusPosition: 0  //wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
    property variant buttonState
    property bool foregroundEventState;
    property string albumArt;
    property string partnerLogo;
    property string ratingImage;
    property string currentstationart;
    property bool isFromErrorView: false
    property alias isOptionsMenuVisible: optMenu.visible
//wsuk.kim 131105 shift error popup move to AhaRadio.qml    property alias isShiftPopupVisible: shiftPopup.visible  //wsuk.kim jog_pop
    property alias isNaviExceptPopupVisible: naviExceptPopup.visible    //wsuk.kim navi_pop
    property bool isJogEventinModeArea: false // for Jog Events in mode area
    property bool isNaviPopCenterKey: false //wsuk.kim navi_pop
    property bool bTuneTextColor: true //wsuk.kim TUNE
    property alias trackViewBtnAllowCall : trackViewButtons.allowCall  //wsuk.kim Deactivate_call
//wsuk.kim 131105 receivingStation Popup.    property alias isReceivingPopupVisible: receivingStationPopup.visible    //wsuk.kim TUNE_TRACK
    property alias onGoingTimeShift: trackViewButtons.isJogLongPressTimerRunning    //wsuk.kim buffering flash
    property alias tuneSearching: tuneRevertInforTimer.running //wsuk.kim WHEEL_SEARCH
    //hsryu_0611_album_reflection
    property string fadeColor : "#000011"
    property bool isDRSTextScroll: UIListener.getDRSTextScrollState()   //wsuk.kim text_scroll
    property int position: 0   //wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
//wsuk.kim 130927 Touch Swing(Flicking) on TrackView.
    property int offsetX: 0
    property bool move_start: false
//wsuk.kim 130927 Touch Swing(Flicking) on TrackView.
    property bool bNoNetworkTextVisible: false    //140103
    property bool bTrackInfoDoubleCheck: false

    //QML Signals Declaration
    signal handleListViewEvent;
    signal handleBackRequest;
    signal handleRewindEvent;
    signal handleContentListViewEvent;//wsuk.kim list_view
    signal handleSelectionEvent;  //wsuk.kim TUNE
    //hsryu_0423_block_play_btcall
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    signal handleShowTrackBtBlockPopup(int jogCenter);
    signal handleShowErrorPopup(int reason);    //wsuk.kim 131105 shift error popup move to AhaRadio.qml   handleShowNaviBlockPopup(int reason); //hsryu_0514_check_latitude_longitude_for_aha

    //hsryu_0613_fail_load_station
//wsuk.kim 131105 receivingStation Popup.    signal handlShowFailLoadStation();
    signal handleHideErrorPopup;

    Component
    {
        id:listDelegate

        Item { //item 1
            id: albumArt_Image
//wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            y: PR.const_AHA_ALL_SCREENS_TOP_OFFSET
            width: PR.const_AHA_ALL_SCREEN_WIDTH
            height: PR.const_AHA_CONNECTING_SCREEN_HEIGHT
//wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            visible : !ahaController.noActiveStation //hsryu_0329_system_popup
            //TODO: Basic Text displayed. If no info from aha  then use basic text tobe displayed
            /*wsuk.kim album img*/
            Image {
                id:album_bg

                x: PR.const_AHA_TRACK_VIEW_DEFAULT_ALBUM_ART_IMG_X_OFFSET
                y: PR.const_AHA_TRACK_VIEW_DEFAULT_ALBUM_ART_IMG_Y_OFFSET
                source: PR_RES.const_APP_AHA_TRACK_VIEW_ALBUM_BG_IMG

                Image {
                    id: track_album_art

                    width: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_W_OFFSET
                    height: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_H_OFFSET

                    //hsryu_0314_fit_image
                    sourceSize.width: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_W_OFFSET
                    sourceSize.height: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_H_OFFSET

                    anchors
                    {
                        left: album_bg.left
                        leftMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_LEFT_MARGIN
                        top: album_bg.top
                        topMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_TOP_MARGIN
                    }
                    source: ahaTrackView.albumArt
                    Image
                    {
                        id: album_light
                        x: - PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_LEFT_MARGIN
                        y: - PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_TOP_MARGIN
                        source: PR_RES.const_APP_AHA_TRACK_VIEW_ALBUM_BG_LIGHT_IMG
                    }
//wsuk.kim buffering
                    Rectangle {
                       id: bufferingGray
                       anchors.left:  album_light.left
                       anchors.leftMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_LEFT_MARGIN
                       anchors.top: album_light.top
                       anchors.topMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_TOP_MARGIN
                       width: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_W_OFFSET
                       height: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_H_OFFSET
                       visible: bufferingGrayVisible
                       opacity: 0.5
                       color: "black"
                   }
                }
            }
/*
//hsryu_0611_album_reflection

            Image
            {
                id: album_bg_reflect

                x: PR.const_AHA_TRACK_VIEW_DEFAULT_ALBUM_ART_IMG_X_OFFSET + 5
                y: PR.const_AHA_TRACK_VIEW_DEFAULT_ALBUM_ART_IMG_Y_OFFSET + PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_H_OFFSET + 5

                anchors
                {
                    left: album_bg_reflect.left
                    leftMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_LEFT_MARGIN
                    top: album_bg_reflect.top
                    topMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_TOP_MARGIN
                }
                source: PR_RES.const_APP_AHA_TRACK_VIEW_ALBUM_BG_IMG


                //transform: Rotation { origin.x: PR.const_AHA_TRACK_VIEW_DEFAULT_ALBUM_ART_IMG_X_OFFSET - 5 - PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_LEFT_MARGIN; origin.y: PR.const_AHA_TRACK_VIEW_DEFAULT_ALBUM_ART_IMG_Y_OFFSET - 3 - PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_TOP_MARGIN; axis { x: 116; y: 110; z: 0 } angle: 180 }
                transform: Rotation { origin.x: 0; origin.y: 0;
                    axis { x: 112; y: 112; z: 0} angle: 180 }
                transformOrigin: Item.Center
                rotation: 90


                Image
                {
                    id: track_album_art_reflect

                    width: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_W_OFFSET
                    height: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_H_OFFSET

                    anchors
                    {
                        left: album_bg_reflect.left
                        leftMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_LEFT_MARGIN
                        top: album_bg_reflect.top
                        topMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_IMG_TOP_MARGIN
                    }
                    source: ahaTrackView.albumArt
                }

//wsuk.kim 131211 to remove loading animation on reflection.
//                Image
//                {
//                    id: track_album_art_wait_reflect

//                    width: 100
//                    height: 100

//                    anchors
//                    {
//                        left: album_bg_reflect.left
//                        leftMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_LOAD_IMG_LEFT_MARGIN
//                        top: album_bg_reflect.top
//                        topMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_LOAD_IMG_TOP_MARGIN
//                    }
//                    source: albumArtWaitIndicator.albumArtLoad
//                }

//                Image
//                {
//                    id: track_album_art_buffer_reflect

//                    width: 100
//                    height: 100

//                    anchors
//                    {
//                        left: album_bg_reflect.left
//                        leftMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_LOAD_IMG_LEFT_MARGIN
//                        top: album_bg_reflect.top
//                        topMargin: PR.const_AHA_TRACK_VIEW_ALBUM_ART_LOAD_IMG_TOP_MARGIN
//                    }
//                    source: loadingWaitImage.source
//                }
//wsuk.kim 131211 to remove loading animation on reflection.

                Rectangle
                {
                    width: 245
                    height: 232

                    gradient: Gradient {
                        GradientStop {
                            position: 0.4
                            color: "#FF" + fadeColor.substring(1)
                        }

                        GradientStop {
                            position: 1.0
                            color: "#AA" + fadeColor.substring(1)
                        }
                    }
                }
            }

//hsryu_0611_album_reflection
*/
            Item {//item 2
                id:track_radio
//wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
                property bool ticker1 : isDRSTextScroll

                onTicker1Changed:
                {
                    if(ticker1)
                        stationName.scrollingTicker = (position == 1) ?  true : false
                    else
                        stationName.scrollingTicker = false;
                }
//wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
                Image {
                    id: icon_station
                    x:PR.const_AHA_TRACK_VIEW_STATION_ICON_X_OFFSET
                    y:PR.const_AHA_TRACK_VIEW_STATION_ICON_ITEM_2_IMG_Y_OFFSET
                    width: PR.const_AHA_STATION_LIST_VIEW_THUMBNAIL_IMAGE_WIDTH
                    height: PR.const_AHA_STATION_LIST_VIEW_THUMBNAIL_IMAGE_HEIGHT
                    //hsryu_0312_cahnge_bg_station
                    sourceSize.width: PR.const_AHA_STATION_LIST_VIEW_THUMBNAIL_IMAGE_WIDTH
                    sourceSize.height: PR.const_AHA_STATION_LIST_VIEW_THUMBNAIL_IMAGE_HEIGHT
                    //fillMode: Image.PreserveAspectCrop
                    //clip : true
                    source: currentstationart
                }
//wsuk.kim text_scroll
                DHAVN_AhaTextScroll
                {
                    id: stationName
                    text: station

                    fontSize: PR.const_AHA_FONT_SIZE_TEXT_HDB_50_FONT
                    fontFamily: PR.const_AHA_FONT_FAMILY_HDR
                    color: bTuneTextColor ? PR.const_AHA_COLOR_TEXT_BRIGHT_GREY: PR.const_AHA_COLOR_TEXT_CURR_STATION

                    anchors.left: icon_station.left
                    anchors.leftMargin: PR.const_AHA_TRACK_VIEW_TEXT_OFFSET_FROM_ICONS
                    anchors.verticalCenter: icon_station.verticalCenter
                    width: PR.const_AHA_TRACK_VIEW_TRACK_INFO_STATON_TEXT_WIDTH
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
                    infinite : false
                    marque: (UIListener.getStringWidth(station, PR.const_AHA_FONT_FAMILY_HDR, PR.const_AHA_FONT_SIZE_TEXT_HDB_50_FONT)
                             > PR.const_AHA_TRACK_VIEW_TRACK_INFO_STATON_TEXT_WIDTH) ? true: false
                    scrollingTicker: (/*!tuneSearching &&*/ isDRSTextScroll && marque && position === 1) ? true: false

                    onTextChanged:  //wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
                    {
                        if(isDRSTextScroll)
                        {
                             if(UIListener.getStringWidth(stationName.text , PR.const_AHA_FONT_FAMILY_HDR ,
                               PR.const_AHA_FONT_SIZE_TEXT_HDB_50_FONT) > PR.const_AHA_TRACK_VIEW_TRACK_INFO_STATON_TEXT_WIDTH)
                            {
                                stationName.marque = true;
                                stationName.scrollingTicker = (position == 0 || position == 1) ?  true : false
                                if(stationName.scrollingTicker)stationName.restart();
                            }
                            else
                            {
                                //wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
                                /*stationName.scrollingTicker = false;
                                if(artistName.marque){ position = 2; artistName.restart()}
                                else if(titleName.marque){ position = 3; titleName.restart()}
                                else if(albumName.marque){ position = 4; albumName.restart()}
                                else stationName.stop();*/
                                 stationName.marque = false;
                            }
                        }
                    }

                    onMarqueeNext:
                    {
                        scrollingTicker = false;
                        if(artistName.marque && isDRSTextScroll) { position = 2; artistName.restart()}
                        else if(titleName.marque && isDRSTextScroll){ position = 3; titleName.restart()}
                        else if(albumName.marque && isDRSTextScroll){ position = 4; albumName.restart()}
                        else if(position == 1 && isDRSTextScroll && stationName.marque){ scrollingTicker = true; stationName.restart()}
                        //else { infinite = true; }
                    }
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
                }
//wsuk.kim text_scroll
            }

            Item {// Item 3
                id:track_artist
//wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
                property bool ticker2 : isDRSTextScroll

                onTicker2Changed:
                {
                    if(ticker2)
                        artistName.scrollingTicker = (position == 2) ?  true : false
                    else
                        artistName.scrollingTicker = false;
                }
//wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
//wsuk.kim text_scroll
                DHAVN_AhaTextScroll
                {
                    id: artistName
                    text: artist

                    fontSize: PR.const_AHA_FONT_SIZE_TEXT_HDR_36_FONT
                    fontFamily: PR.const_AHA_FONT_FAMILY_HDR
                    color: PR.const_AHA_LIGHT_DIMMED

                    x: PR.const_AHA_TRACK_VIEW_X_OFFSET
                    y: 213 - 73 + 61
                    width: PR.const_AHA_TRACK_VIEW_TRACK_INFO_TEXT_WIDTH
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
                    infinite : false
                    marque: (UIListener.getStringWidth(artist, PR.const_AHA_FONT_FAMILY_HDR, PR.const_AHA_FONT_SIZE_TEXT_HDR_36_FONT)
                             > PR.const_AHA_TRACK_VIEW_TRACK_INFO_TEXT_WIDTH) ? true: false
                    scrollingTicker: (!tuneSearching && isDRSTextScroll && marque && position === 2) ? true: false

                    onTextChanged:  //wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
                    {
                        if(isDRSTextScroll)
                        {
                            if(!stationName.marque && artistName.marque)
                            {
                                position = 2;
                                artistName.scrollingTicker = true;
                            }
                        }
                    }

                    onMarqueeNext:
                    {
                        scrollingTicker = false;
                        if(titleName.marque && isDRSTextScroll){ position = 3; titleName.restart()}
                        else if(albumName.marque && isDRSTextScroll){ position = 4; albumName.restart()}
                        else if(stationName.marque && isDRSTextScroll){ position = 1; stationName.restart()}
                        else if(position === 2 && isDRSTextScroll){ scrollingTicker = true; artistName.restart()}
                        //else { infinite = true; }
                    }
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
                }
//wsuk.kim text_scroll
            }

            Item {//item 4
                id:track_title
//wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
                property bool ticker3 : isDRSTextScroll

                onTicker3Changed:
                {
                    if(ticker3)
                        titleName.scrollingTicker = (position === 3) ?  true : false
                    else
                        titleName.scrollingTicker = false;
                }
//wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
//wsuk.kim text_scroll
                DHAVN_AhaTextScroll
                {
                    id: titleName
                    text: title

                    fontSize: PR.const_AHA_FONT_SIZE_TEXT_HDR_36_FONT
                    fontFamily: PR.const_AHA_FONT_FAMILY_HDR
                    color: PR.const_AHA_LIGHT_DIMMED

                    x: PR.const_AHA_TRACK_VIEW_X_OFFSET
                    y: 213 - 73 + 61 + 50
                    width: PR.const_AHA_TRACK_VIEW_TRACK_INFO_TEXT_WIDTH
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
                    infinite : false
                    marque: (UIListener.getStringWidth(title, PR.const_AHA_FONT_FAMILY_HDR, PR.const_AHA_FONT_SIZE_TEXT_HDR_36_FONT)
                             > PR.const_AHA_TRACK_VIEW_TRACK_INFO_TEXT_WIDTH) ? true: false
                    scrollingTicker: (!tuneSearching && isDRSTextScroll && marque && position === 3) ? true: false

                    onTextChanged:  //wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
                    {
                        if(isDRSTextScroll)
                        {
                            if(!stationName.marque && !artistName.marque && titleName.marque)
                            {
                                position = 3;
                                titleName.scrollingTicker = true;
                            }
                        }
                    }

                    onMarqueeNext:
                    {
                        scrollingTicker = false;
                        if(albumName.marque && isDRSTextScroll){ position = 4; albumName.restart()}
                        else if(stationName.marque && isDRSTextScroll){ position = 1; stationName.restart()}
                        else if(artistName.marque && isDRSTextScroll) { position = 2; artistName.restart()}
                        else if(position === 3 && isDRSTextScroll){ scrollingTicker = true; titleName.restart()}
                        //else { infinite = true; }
                    }
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
                }
//wsuk.kim text_scroll
            }

            Item {//item 5
                id:track_album
//wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
                property bool ticker4 : isDRSTextScroll

                onTicker4Changed:
                {
                    if(ticker4)
                        albumName.scrollingTicker = (position == 4) ?  true : false
                    else
                        albumName.scrollingTicker = false;
                }
//wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
//wsuk.kim text_scroll
                DHAVN_AhaTextScroll
                {
                    id: albumName
                    text: album

                    fontSize: PR.const_AHA_FONT_SIZE_TEXT_HDR_36_FONT
                    fontFamily: PR.const_AHA_FONT_FAMILY_HDR
                    color: PR.const_AHA_LIGHT_DIMMED

                    x: PR.const_AHA_TRACK_VIEW_X_OFFSET
                    y: PR.const_AHA_TRACK_VIEW_ICON_ITEM_5_IMG_Y_OFFSET - 10
                    width: PR.const_AHA_TRACK_VIEW_TRACK_INFO_TEXT_WIDTH
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
                    infinite : false
                    marque: (UIListener.getStringWidth(album, PR.const_AHA_FONT_FAMILY_HDR, PR.const_AHA_FONT_SIZE_TEXT_HDR_36_FONT)
                             > PR.const_AHA_TRACK_VIEW_TRACK_INFO_TEXT_WIDTH) ? true: false
                    scrollingTicker: (!tuneSearching && isDRSTextScroll && marque && position === 4) ? true: false

                    onTextChanged:  //wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
                    {
                        if(isDRSTextScroll)
                        {
                            if(!stationName.marque && !artistName.marque && !titleName.marque && albumName.marque)
                            {
                                position = 4;
                                albumName.scrollingTicker = true;
                            }
                        }
                    }

                    onMarqueeNext:
                    {
                        scrollingTicker = false;
                        if(stationName.marque && isDRSTextScroll){ position = 1; stationName.restart()}
                        else if(artistName.marque && isDRSTextScroll){ position = 2; artistName.restart()}
                        else if(titleName.marque && isDRSTextScroll){ position = 3; titleName.restart()}
                        else if(position === 4 && isDRSTextScroll){ scrollingTicker = true; albumName.restart()}
                        //else { infinite = true; }
                    }
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
                }
//wsuk.kim text_scroll
            }

            Item {
                    id:noNetwork

                    x: 1054
                    y: 185-110
                    width: 210
                    height: 45
                    visible: bNoNetworkTextVisible
                       Image {
                        id: focusImg
                        source: "/app/share/images/pandora/bg_no_net.png"
                        anchors.fill: noNetwork
                    }

                    Text {
                        id : lownwText
                        text:  qsTranslate("main","STR_AHA_NO_NETWORK");
                        font.pointSize: 24
                        font.family: PR.const_PANDORA_FONT_FAMILY_HDB
                        color: "#9599A0" //PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter

                    }
            }
//wsuk.kim buffering FOR CHECK
//            Item {
//                id:track_buffering

//                Text {
//                    text: buffering
//                    font.pixelSize: PR.const_AHA_FONT_SIZE_TEXT_HDR_36_FONT
//                    font.family: PR.const_AHA_FONT_FAMILY_HDR
//                    color: PR.const_AHA_LIGHT_DIMMED

//                    x: PR.const_AHA_TRACK_VIEW_X_OFFSET
//                    y: PR.const_AHA_TRACK_VIEW_ICON_ITEM_5_IMG_Y_OFFSET +24+37 - 10
//                    width: PR.const_AHA_TRACK_VIEW_TRACK_INFO_TEXT_WIDTH
//                }
//            }
//wsuk.kim buffering FOR CHECK

            Image {
                id: aha_partner_logo
                anchors.horizontalCenter: album_bg.horizontalCenter //wsuk.kim 121206_temp
//wsuk.kim 121206_temp x: PR.const_AHA_TRACK_VIEW_PARTNER_LOGO_IMG_X_OFFSET
                y: 388//wsuk.kim TEMP PR.const_AHA_TRACK_VIEW_PARTNER_LOGO_IMG_Y_OFFSET
                source: partnerLogo
            }

            Image {
                id: aha_rating_image
                x: PR.const_AHA_TRACK_VIEW_X_OFFSET //wsuk.kim 121206_temp 438  //wsuk.kim rating  PR.const_AHA_TRACK_VIEW_RATING_IMAGE_IMG_X
//wsuk.kim 121206_temp y: PR.const_AHA_TRACK_VIEW_RATING_IMAGE_IMG_Y
                anchors.verticalCenter: aha_partner_logo.verticalCenter //wsuk.kim 121206_temp
                source: ratingImage
            }
//wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            MouseArea{
                anchors.fill: parent
                beepEnabled: false  //wsuk.kim 131015 ITS_195759 beep sound off on TrackView info.

                onReleased: {
                    if(toastPopupVisible)
                    {
                        toastPopupVisible = false;
                    }
                }

//wsuk.kim 130927 Touch Swing(Flicking) on TrackView.
                onPressed:
                {
                    if(toastPopupVisible)
                    {
                        return;
                    }
                    ahaTrackView.move_start = true;
                    offsetX = mouseX;
                }

                onPositionChanged:
                {
                    if ((offsetX - mouseX) >= 100 && ahaTrackView.move_start)
                    {
                        ahaTrackView.move_start = false;

                        if(UIListener.getNetworkStatus() != 0) //  Network error
                        {
                            return;
                        }

                        if(UIListener.IsCallingSameDevice())    //wsuk.kim 131008 during BT call, block flicking
                        {
                            UIListener.OSDInfoCannotPlayBTCall();
                            return;
                        }
                        if(InTrackInfo.allowSkip)
                        {
                            albumArtWaitIndicator.visible = false;
                            UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                            ahaTrack.Skip();
                        }
                        else
                        {
                            ahaTrackView.handlePopupNoSkip();
                        }
                    }
                    else if ((offsetX - mouseX) <= -100 && ahaTrackView.move_start)
                    {
                        ahaTrackView.move_start = false;

                        if(UIListener.IsCallingSameDevice())    //wsuk.kim 131008 during BT call, block flicking
                        {
                            UIListener.OSDInfoCannotPlayBTCall();
                            return;
                        }
                        if(InTrackInfo.allowSkipBack)
                        {
                            albumArtWaitIndicator.visible = false;
                            UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                            ahaTrack.SkipBack();
                        }
                        else
                        {
                            ahaTrackView.handlePopupNoSkipBack();
                        }
                    }
                }
//wsuk.kim 130927 Touch Swing(Flicking) on TrackView.
            }
//wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
        }
    }

    Image {
        id: ahaLogo
        source: PR_RES.const_APP_AHA_TRACK_VIEW_AHALOGO_IMAGE
        x: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_X_OFFSET
//wsuk.kim 130717 to change front/rear title position
        //anchors.left: front_back_indicator_text.right
        //anchors.leftMargin: UIListener.GetVariantRearUSB()? 32 : 0  //wsuk.kim 130807 ISV_86633 variant RearUSB
        anchors.bottom: front_back_indicator_text.bottom
        anchors.bottomMargin: 13
//        x: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_X_OFFSET
//        y: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_Y_OFFSET
//wsuk.kim 130717 to change front/rear title position
        z: 1000
        MouseArea{
            anchors.fill: parent
            beepEnabled: false  //wsuk.kim 131015 ITS_195759 beep sound off on TrackView info.
        }
    }

    //hsryu_0618_device_text
    Text
    {
        id: front_back_indicator_text
//wsuk.kim 130717 to change front/rear title position
        //x: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_X_OFFSET
        anchors.left: ahaLogo.right
        anchors.verticalCenter: trackModeAreaWidget.verticalCenter
//        anchors.left: ahaLogo.right
//        anchors.leftMargin: 10
//        anchors.bottom: ahaLogo.bottom
//        anchors.bottomMargin: -9
//wsuk.kim 130717 to change front/rear title position
        z: 1000
        text: UIListener.getConnectTypeName();
        color: PR.const_AHA_LIGHT_DIMMED
        font.pointSize: PR.const_AHA_FONT_SIZE_TEXT_HDR_40_FONT
        font.family: PR.const_AHA_FONT_FAMILY_HDB
    }

    ListModel{
        id: trackInfoModel
    }

    OptionMenu{
        id: optMenu
        menumodel: ahaMenus.optTrackMenuModel
        signal lostFocus( int arrow, int focusID );
        z: 1000
        y: 0
        visible: false;
        autoHiding: true
        autoHideInterval: 10000
        scrollingTicker: isDRSTextScroll    //wsuk.kim 130909 Menu text scllor ticker

        onIsHidden:
        {
            UIListener.printQMLDebugString("AhaTrackView : onIsHidden() .... \n");
            optMenu.hideFocus();
            visible = false;
            //trackViewButtons.showFocus();

            if(UIListener.getNetworkStatus() != 0 )
            {
                trackModeAreaWidget.showFocus();
            }
            else
            {
                trackViewButtons.showFocus();
            }
        }

        onBeep: UIListener.ManualBeep(); //added by honggi.shin, 2014.01.28, Beep enable

        onTextItemSelect:
        {
            //hsryu_0417_sound_setting
            if(ahaController.blaunchSoundSetting) return;

            handleMenuItemEvent(itemId);
            __LOG("handleMenuItemEvent called");
        }

        onNextMenuSelect:
        {
            __LOG(  "onNextMenuSelect: "  +  itemId);
        }

        function showMenu()
        {
            optMenu.visible = true;
            optMenu.show();
        } // added by Sergey 02.08.2103 for ITS#181512

    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 5
        model: trackInfoModel
        delegate: listDelegate
        focus: true
    }

    state: "trackStateInfoWaiting"

    // define various states and its effect
    states: [
        State
        {
            name: "trackStateInfoWaiting"
            PropertyChanges { target:trackViewButtons; visible: true}
            PropertyChanges { target:trackViewButtons; state: "buttonsDisabled"}
            PropertyChanges { target:trackViewButtons; isRateVisible:true} //hsryu_0326_like_dislike
            //   PropertyChanges { target: prBar;bStartRunning:false}
        },

        State
        {
            name: "trackStatePlaying"
            PropertyChanges { target:trackViewButtons; visible: true}
            PropertyChanges { target:trackViewButtons; state: "buttonsEnabled"}
            PropertyChanges { target:trackViewButtons; isRateVisible:true} //hsryu_0326_like_dislike
            //   PropertyChanges { target: prBar;bStartRunning:true}
        },

        State
        {
            name: "trackStatePaused"
            PropertyChanges { target:trackViewButtons; visible: true}
            //PropertyChanges { target:trackViewButtons; state: "buttonsEnabled"}
            PropertyChanges { target:trackViewButtons; isRateVisible:true} //hsryu_0326_like_dislike
            // PropertyChanges { target: prBar;bStartRunning:false}
        },

        State   // Ryu 20140115 dimming cue BTN during No network
        {
            name: "trackStateNoNetwork"
            PropertyChanges { target:trackViewButtons; visible: true}
            PropertyChanges { target:trackViewButtons; state: "buttonsDisabled"}
            PropertyChanges { target:trackViewButtons; isRateVisible:true} //hsryu_0326_like_dislike
        },

        State   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
        {
            name: "trackStateBTcalling"
            PropertyChanges { target:trackViewButtons; visible: true}
            PropertyChanges { target:trackViewButtons; state: "buttonsDisabled"}
            PropertyChanges { target:trackViewButtons; isRateVisible:true}
        },

        State
        {
            name: "trackStateBtnEnable"
            PropertyChanges { target:trackViewButtons; visible: true}
            PropertyChanges { target:trackViewButtons; state: "buttonsEnabled"}
            PropertyChanges { target:trackViewButtons; isRateVisible:true}
        },

        State
        {
            name: "trackStateBtnDisable"
            PropertyChanges { target:trackViewButtons; visible: true}
            PropertyChanges { target:trackViewButtons; state: "buttonsDisabled"}
            PropertyChanges { target:trackViewButtons; isRateVisible:true}
        }

    ]

    /***************************************************************************/
    /**************************** Private functions START **********************/
    /***************************************************************************/

    function __LOG( textLog )
    {
        console.log( " DHAVN_AhaTrackView.qml: " + textLog )
    }

    // handles foreground event
    function handleForegroundEvent()
    {
        ahaTrackView.visible = true;
        listView.visible = false;
        trackViewButtons.setTrackCurrentState("trackStateInfoWaiting");
        ahaTrackView.state = "trackStateInfoWaiting";
        ahaTrack.RequestTrackInfo();

        if(UIListener.IsCallingSameDevice())    //wsuk.kim 130820 launch aha connect USB cable during BT calling.
        {
            UIListener.printQMLDebugString("AhaTrackView : IsCallingSameDevice() TRUE \n");
            ahaTrack.Pause();
            ahaTrackView.state = "trackStateBtnDisable";

            trackModeAreaWidget.isListDisabled = true;  //wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
            trackViewButtons.hideFocus();
            trackModeAreaWidget.showFocus();
            trackModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
        }
        else
        {
            UIListener.printQMLDebugString("AhaTrackView : IsCallingSameDevice() FALSE \n");
            if(UIListener.IsAVModeChanged() == false)
            {
                UIListener.openSoundChannel();
                UIListener.printQMLDebugString("AhaTrackView : openSoundChannel \n");

                if(UIListener.getNetworkStatus() == 0 && tuneSearching == false)      // Network normal
                {
                    ahaTrackView.state = "trackStateBtnEnable";
                }

                if(isSelectSameContent) //wsuk.kim 131217 ITS_215922 to remain previous play state when selected same content.
                {
                    isSelectSameContent = false;
                }
                else if(UIListener.getSelectionEvent() == true)
                {
                    ahaTrack.Play();        // by Ryu 20130828  ISV 89254
                    UIListener.setSelectionEvent(false);           // return to the default value
                }
            }
        }
    }

    //hsryu_0306_change_menu
    function handleMenuItemEvent(menuItemId)
    {
        switch(parseInt(menuItemId))
        {
/*wsuk.kim list_btn*/
        case MenuItems.StationList: // PresetList
        {
            ahaTrackView.handleListViewEvent();
            break;
        }
/*wsuk.kim list_btn*/
        case MenuItems.ContentsList: // ContentsList
        {
            ahaStationList.requestContentList();
            ahaTrackView.handleContentListViewEvent();
            break;
        }
        case MenuItems.ThumbsUp: // I like it
        {
            if(InTrackInfo.allowLike)//wsuk.kim menu_option   allowRating
            {
                ahaTrack.LikeButtonClicked();    //wsuk.kim menu_option  ThumbUp();
            }
            break;
        }
        case MenuItems.ThumbsDown: // I don't like it
        {
            if(InTrackInfo.allowDislike)//wsuk.kim menu_option   allowRating
            {
                ahaTrack.DislikeButtonClicked();    //wsuk.kim menu_option  ThumbDown();
            }
            break;
        }
/*wsuk.kim menu_option*/
        case MenuItems.Call:
        {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//            //hsryu_0423_block_play_btcall
//            if(UIListener.IsCallingSameDevice())
//            {
//                optMenu.hideFocus();
//                //optMenu.visible = false;
//                optMenu.quickHide();
//                trackModeAreaWidget.hideFocus();
//                trackViewButtons.showFocus();
//                handleShowTrackBtBlockPopup(0);
//                return;
//            }

            if(InTrackInfo.allowCall)
            {
                UIListener.CallPOI();
            }
            break;
        }
        case MenuItems.Navigate:
        {
            if(InTrackInfo.allowNavigate)
            {
                //hsryu_0312_navi_exception
                //hsryu_0514_check_latitude_longitude_for_aha
                if(UIListener.GetAhaGPSStatus() === 1)
                {
//wsuk.kim 130909 ITS_0188599 2 times display option menu.  optMenu.visible = false;
                    optMenu.hideFocus();
                    optMenu.quickHide();

                    handleShowErrorPopup(1);
                }
                else
                {
//hsryu_0620_unlock_navigate
                    //hsryu_0514_check_latitude_longitude_for_aha
//                    if(UIListener.CheckLocateForNavigation() === false)
//                    {
////wsuk.kim 130909 ITS_0188599 2 times display option menu.    optMenu.visible = false;
//                        optMenu.hideFocus();
//                        optMenu.quickHide();
//                        handleShowErrorPopup(2);
//                    }
//                    else
//                    {
                        UIListener.NavigateToPOI();
//                    }
                }
                //hsryu_0312_navi_exception
            }
            break;
        }
/*wsuk.kim menu_option*/
        case MenuItems.SoundSetting: //Sound Setting
        {
            //hsryu_0417_sound_setting
            ahaController.blaunchSoundSetting = true;
            UIListener.LaunchSoundSetting();
            break;
        }
        default:
        {
            __LOG("MyLog: No menu item matched")
            break;
        }
        }
        //optMenu.hideFocus();    //wsuk.kim title_jog

//hsryu_0417_sound_setting
        if(parseInt(menuItemId) === MenuItems.ThumbsUp || parseInt(menuItemId) === MenuItems.ThumbsDown)
        {
            optMenu.hideFocus();
            //optMenu.visible = false;
            optMenu.quickHide();
            trackModeAreaWidget.hideFocus();
            trackViewButtons.showFocus();
        }
/*
        //hsryu_0319_control_opt_sound_setting
        if(parseInt(menuItemId) === MenuItems.SoundSetting)
        {
//            optTrackTransitionTimer.start();
        }
        else
        {
            optMenu.hideFocus();
        	optMenu.visible = false;
            trackModeAreaWidget.hideFocus();
            trackViewButtons.showFocus();
        }
*/
//        trackModeAreaWidget.hideFocus();
//        trackViewButtons.showFocus();
    }

//hsryu_0319_control_opt_sound_setting
//    Timer{
//        id: optTrackTransitionTimer
//        running: false
//        repeat: false
//        interval: 500
//        onTriggered: {
//            optMenu.visible = false;
//        }
//    }

    // handle retranlateUI event
    function handleRetranslateUI(languageId)
    {
        trackModeAreaWidget.retranslateUI(PR.const_AHA_LANGCONTEXT);
        trackViewButtons.handleRetranslateUI(PR.const_AHA_LANGCONTEXT);
    }

    // Logic for highlighting the item based on jog key events
    function setHighlightedItem(inKeyId)
    {
        isDialUI = true;
    }

    function updateUIWithTrackInfo()
    {
        UIListener.printQMLDebugString("$$sam ================updateUIWithTrackInfo=============== 11111111111 \n");
        trackViewButtons.allowRating = InTrackInfo.allowRating;
        trackViewButtons.allowLike = InTrackInfo.allowLike;
        trackViewButtons.allowDislike = InTrackInfo.allowDislike;
        trackViewButtons.allowSkip = InTrackInfo.allowSkip;
        trackViewButtons.allowSkipBack = InTrackInfo.allowSkipBack;
        trackViewButtons.allowTimeShift = InTrackInfo.allowTimeShift;
        trackViewButtons.allowNavigate = InTrackInfo.allowNavigate;
        //hsryu_0423_block_play_btcall
        trackViewButtons.allowCall = InTrackInfo.allowCall;

        updateOptionsMenu();
        trackInfoModel.clear();
        trackInfoModel.append({station: tuneSearching? ahaStationList.getStationNameTune(nTuneIndex, true): InTrackInfo.station,
                                artist: InTrackInfo.artist,
                                title: InTrackInfo.title,
                                album: InTrackInfo.album,
//                              buffering : "",   //wsuk.kim buffering FOR CHECK
                                bufferingGrayVisible : (nPlayBackStatus === 3 && albumArt.length != 0 && !onGoingTimeShift)? true: false, //wsuk.kim buffering
                                currentstationart: PR_RES.const_APP_AHA_TRACK_VIEW_ICON_STATION_IMG})

        currentActiveStation = InTrackInfo.station;
        currentActiveStationToken = InTrackInfo.stationToken;
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
        if( UIListener.getStringWidth(InTrackInfo.station , PR.const_AHA_FONT_FAMILY_HDR ,
        PR.const_AHA_FONT_SIZE_TEXT_HDB_50_FONT) > PR.const_AHA_TRACK_VIEW_TRACK_INFO_STATON_TEXT_WIDTH)
            position = 1;
        else if( UIListener.getStringWidth(InTrackInfo.artist , PR.const_AHA_FONT_FAMILY_HDR ,
        PR.const_AHA_FONT_SIZE_TEXT_HDR_36_FONT) > PR.const_AHA_TRACK_VIEW_TRACK_INFO_TEXT_WIDTH)
            position = 2;
        else if( UIListener.getStringWidth(InTrackInfo.title , PR.const_AHA_FONT_FAMILY_HDR ,
        PR.const_AHA_FONT_SIZE_TEXT_HDR_36_FONT) > PR.const_AHA_TRACK_VIEW_TRACK_INFO_TEXT_WIDTH)
            position = 3;
        else if( UIListener.getStringWidth(InTrackInfo.album , PR.const_AHA_FONT_FAMILY_HDR ,
        PR.const_AHA_FONT_SIZE_TEXT_HDR_36_FONT) > PR.const_AHA_TRACK_VIEW_TRACK_INFO_TEXT_WIDTH)
            position = 4;
        else
            position = 0;
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview

    }

    //ITS_0226333
    function resetOptionMenu()
    {
        UIListener.printQMLDebugString("$$sam ================resetOptionMenu=============== 1111111111111 \n");
        ahaMenus.UpdateAllowInOptionsMenu(0, 0, 0, 0);
        trackViewButtons.isRateVisible = false;  // sync with menu 2014.03.17
    }

    function updateOptionsMenu()
    {
        UIListener.printQMLDebugString("$$sam ================updateOptionsMenu=============== 222222222222 \n");
        //hsryu_0423_block_play_btcall
        ahaMenus.UpdateAllowInOptionsMenu(InTrackInfo.allowLike, InTrackInfo.allowDislike, InTrackInfo.allowCall, InTrackInfo.allowNavigate);//wsuk.kim dynamic_menu
    }

    function hideOptionsMenu()
    {
        UIListener.printQMLDebugString("AhaTrackView : hideOptionsMenu \n");
        //optMenu.visible = false;
        optMenu.quickHide();
        optMenu.hideFocus();    //wsuk.kim title_jog

        for(var i = 0; i < ahaMenus.optTrackMenuModel.levelMenu; i++)
        {
            ahaMenus.optTrackMenuModel.backLevel();
        }

        if(UIListener.getNetworkStatus() != 0)
        {
            trackModeAreaWidget.showFocus();
            //trackViewButtons.hideFocus();
        }
        else{
            //trackModeAreaWidget.hideFocus();
            trackViewButtons.showFocus();
        }
    }

    function handleSeekTrackPressedFocus()  //wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
    {
        if(UIListener.getNetworkStatus() != 0)
        {
            trackModeAreaWidget.showFocus();
        }
        else{
            trackViewButtons.showFocus();
            trackModeAreaWidget.hideFocus();
        }
    }

    function handlePlayPauseEvent()
    {
        if(UIListener.getNetworkStatus() != 0)
        {
            trackModeAreaWidget.showFocus();
        }
        else{
            trackViewButtons.showFocus();
            trackModeAreaWidget.hideFocus();
        }
    }

    // Handle the seek event coming as result of hard key press
    function handleSkipEvent()
    {
        __LOG("Calling ahaTrack Skip slot")
        albumArtWaitIndicator.visible = false;
        //listView.visible = false;
        //ahaTrackView.state = "trackStateInfoWaiting";
        UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
        handleSeekTrackPressedFocus();  //wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
        ahaTrack.Skip();
    }

    // Handle the seek back event coming as result of hard key press
    function handleSkipBackEvent()
    {
        albumArtWaitIndicator.visible = false;
        //listView.visible = false;
        //ahaTrackView.state = "trackStateInfoWaiting";
        UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
        handleSeekTrackPressedFocus();  //wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
        ahaTrack.SkipBack();
    }

    function handleRewind15Event()
    {
        //albumArtWaitIndicator.visible = false;
        //listView.visible = false;
        //ahaTrackView.state = "trackStateInfoWaiting";
        UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleRewind15Event] ");
        ahaTrack.Rewind15();
    }

    function handleForward30Event()
    {
        //albumArtWaitIndicator.visible = false;
        //listView.visible = false;
        //ahaTrackView.state = "trackStateInfoWaiting";
        ahaTrack.Forward30();
    }

    function handleSkipFailedEvent()
    {
        // albumArtWaitIndicator.visible = false;
        listView.visible = true;
        UIListener.printQMLDebugString("$$sam ================handleSkipFailedEvent=============== buttonsEnabled...222\n");
        trackViewButtons.state = "buttonsEnabled";
        updateUIWithTrackInfo();
        if(ahaTrack.TrackStatus())
        {
            ahaTrackView.state = "trackStatePlaying";
        }
        else
        {
            ahaTrackView.state = "trackStatePaused";
        }
    }

    function handleMenukey(isJogMenuKey)
    {
        UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleMenukey] isJogMenuKey:"+isJogMenuKey);
        if(UIListener.getNetworkStatus() != 0 && !bNoNetworkTextVisible ) /*Network Error*/ // added by Ryu 20140203 // modified ITS 225504
        {
            return;
        }

        if(UIListener.IsCallingSameDevice())    //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
        {
            UIListener.OSDInfoCannotPlayBTCall();
            return;
        }

        if(isJogMenuKey && trackModeAreaWidget.getButtonPressed())  //wsuk.kim 131112 ITS_207932 modeArea SK pressed, menu HK make cancel.
        {
            trackModeAreaWidget.setButtonCancel(true);
        }

        isDialUI = isJogMenuKey;
        if( ahaTrackView !== null && ahaTrackView.visible)
        {
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            // ITS 225504
            if (bNoNetworkTextVisible === true)
            {
                ahaMenus.UpdateAllowInOptionsMenu(0, 0, 0, 0, bNoNetworkTextVisible);
            }
            else
            {
                ahaMenus.UpdateAllowInOptionsMenu(InTrackInfo.allowLike, InTrackInfo.allowDislike, InTrackInfo.allowCall, InTrackInfo.allowNavigate, bNoNetworkTextVisible);
            }

            if(!optMenu.visible)
                optMenu.showMenu();
            else
                optMenu.quickHide();

            UIListener.SetOptionMenuVisibilty(optMenu.visible);
            if(!optMenu.visible)
            {
                optMenu.hideFocus();
                trackModeAreaWidget.hideFocus();
UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleMenukey] hide option menu...");
                if(UIListener.getNetworkStatus() != 0)
                {
                    UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleMenukey] hide option menu...show modeAreaWidget");
                    trackModeAreaWidget.showFocus();
                }
                else if(!trackViewButtons.focusVisible)
                {
                    UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleMenukey] hide option menu...show trackViewButtons");
                    trackViewButtons.showFocus();
                }
            }
            else    //if(optMenu.visible)
            {
                trackViewButtons.hideFocus();
                trackModeAreaWidget.hideFocus();

                optMenu.showFocus();
                optMenu.setDefaultFocus(0); // focus at 0th index
            }
        }
    }

//wsuk.kim SEEK_TRACK
    function handleStartTimeshiftAnimation(allowKey)
    {
        trackViewButtons.startTimeshiftAnimation(allowKey);
    }

    function handleStopTimeshiftAnimation()
    {
        trackViewButtons.stopTimeshiftAnimation();
    }

    function handlePopupNoSkipBack()
    {
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_SKIP_BACK);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftPopup.showPopup(qsTranslate("main", "STR_NO_SUPPORT_SKIP_BACK"), true);
    }
    function handlePopupNoSkip()
    {
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_SKIP);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftPopup.showPopup(qsTranslate("main", "STR_NO_SUPPORT_SKIP"), true);
    }

    function handlePopupNoREW15()
    {
        trackViewButtons.releasedSkipPrevNextBtn();
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_REW15);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftPopup.showPopup(qsTranslate("main", "STR_AHA_NO_SUPPORT_REW15"), true);
    }

    function handlePopupNoFW30()
    {
        trackViewButtons.releasedSkipPrevNextBtn();
        handleShowErrorPopup(PR.const_AHA_NO_SUPPORT_FW30);
//wsuk.kim 131105 shift error popup move to AhaRadio.qml        shiftPopup.showPopup(qsTranslate("main", "STR_AHA_NO_SUPPORT_FW30"), true);
    }
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//    //hsryu_0423_block_play_btcall
//    function handleNoREWFW()
//    {
//        trackViewButtons.releasedSkipPrevNextBtn();
//    }

//wsuk.kim SEEK_TRACK

//wsuk.kim TUNE
    function handleFocusTuneDown(arrow)
    {
        UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleFocusTuneDown] 11111 arrow:"+arrow);
        if(UIListener.IsCallingSameDevice())
        {
            UIListener.OSDInfoCannotPlayBTCall();
            return;
        }

        if(!isReceivingPopupVisible /*&&!isShiftPopupVisible*/ &&!isOptionsMenuVisible &&!isNaviExceptPopupVisible && !networkErrorPopupVisible && !stationGuidePopupVisible)  //wsuk.kim TUNE_TRACK
        {
            bTuneTextColor = false;

            UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleFocusTuneDown] 2222 stationIDTune:"+ahaStationList.getStationIdTune());
            if(ahaStationList.getStationIdTune() === 1 /*STATION_PRESET*/)
            {
                if(nTuneIndex < ahaStationList.getPresetCount() - 1)
                {
                    nTuneIndex += 1;
                }
                else
                {
                    nTuneIndex = 0;
                }
            }
            else if(ahaStationList.getStationIdTune() === 2 /*STATION_LBS*/)
            {
                if(nTuneIndex < ahaStationList.getLBSCount() - 1)
                {
                    nTuneIndex += 1;
                }
                else
                {
                    nTuneIndex = 0;
                }
            }
            UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleFocusTuneDown] 2222222222 nTuneIndex:"+ nTuneIndex);

            bTuneTextColor = ahaStationList.checkSameStationId(nTuneIndex); //0319
            trackInfoModel.set(0,{station : ahaStationList.getStationNameTune(nTuneIndex, true)});
            trackInfoModel.set(0,{currentstationart : ahaStationList.getStationArtTune(nTuneIndex)});   //wsuk.kim 130902 ISV_90329 to display station art image that tune search.
//wsuk.kim TUNE_5SEC
            if(!bTuneTextColor)     // button disable
            {
                tuneRevertInforTimer.restart();
                // ITS 0221961   by Ryu 20140128
                trackViewButtons.state = "NextPrevBtnDisabled";
            }
            else        // button enable
            {
                tuneRevertInforTimer.stop();
                trackViewButtons.state = "NextPrevBtnEnabled";
            }
            ahaStationList.setTrackViewTuneIndex(nTuneIndex);
//wsuk.kim TUNE_5SEC

            // ITS 0221961   by Ryu 20140128
            //trackViewButtons.state = "NextPrevBtnDisabled";
        }
    }

    function handleFocusTuneUp(arrow)
    {
        if(UIListener.IsCallingSameDevice())
        {
            UIListener.OSDInfoCannotPlayBTCall();
            return;
        }

        if(!isReceivingPopupVisible /*&&!isShiftPopupVisible*/ &&!isOptionsMenuVisible &&!isNaviExceptPopupVisible && !networkErrorPopupVisible && !stationGuidePopupVisible)  //wsuk.kim TUNE_TRACK
        {
            bTuneTextColor = false;

            if(nTuneIndex > 0)
            {
                nTuneIndex -= 1;
            }
            else
            {
                if(ahaStationList.getStationIdTune() === 1 /*STATION_PRESET*/)
                {
                    nTuneIndex = ahaStationList.getPresetCount()-1;
                }
                else if(ahaStationList.getStationIdTune() === 2 /*STATION_LBS*/)
                {
                    nTuneIndex = ahaStationList.getLBSCount()-1;
                }
            }

            bTuneTextColor = ahaStationList.checkSameStationId(nTuneIndex); //0319
            trackInfoModel.set(0,{station : ahaStationList.getStationNameTune(nTuneIndex, true)});
            trackInfoModel.set(0,{currentstationart : ahaStationList.getStationArtTune(nTuneIndex)});   //wsuk.kim 130902 ISV_90329 to display station art image that tune search.
//wsuk.kim TUNE_5SEC
            if(!bTuneTextColor)     // button disable
            {
                tuneRevertInforTimer.restart();
                // ITS 0221961   by Ryu 20140128
                trackViewButtons.state = "NextPrevBtnDisabled";
            }
            else        // button enable
            {
                tuneRevertInforTimer.stop();
                trackViewButtons.state = "NextPrevBtnEnabled";
            }
            ahaStationList.setTrackViewTuneIndex(nTuneIndex);
//wsuk.kim TUNE_5SEC

            // ITS 0221961   by Ryu 20140128
            //trackViewButtons.state = "NextPrevBtnDisabled";
        }
    }

    function handleFocusTuneCenter()
    {
        //hsryu_0423_block_play_btcall
        if(UIListener.IsCallingSameDevice())
        {
            UIListener.OSDInfoCannotPlayBTCall();
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.            handleShowTrackBtBlockPopup(0);
            return;
        }
        else if(UIListener.getNetworkStatus() !== 0 && UIListener.getNetworkStatus() !== 3)
        {
            UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleFocusTuneCenter] network error..");
            return;
        }

        if(!isReceivingPopupVisible /*&&!isShiftPopupVisible*/ &&!isOptionsMenuVisible &&!isNaviExceptPopupVisible && !networkErrorPopupVisible && !stationGuidePopupVisible)  //wsuk.kim TUNE_TRACK
        {
            tuneRevertInforTimer.stop();

            // ITS 0221961   by Ryu 20140128
            trackViewButtons.state = "NextPrevBtnEnabled";

            if(ahaStationList.getStationIndexUsedfromStationIdTune() !== nTuneIndex &&
                    nTuneIndex !== -1) //hsryu_no_action_same_station_ITS_0174723
            {
                bTuneTextColor = true;

                if(ahaStationList.getStationIdTune() === 1 /*STATION_PRESET*/)
                    ahaStationList.selectPresetIndex(nTuneIndex);
                else if(ahaStationList.getStationIdTune() === 2 /*STATION_LBS*/)
                    ahaStationList.selectLBSIndex(nTuneIndex);

                ahaTrackView.handleSelectionEvent();
            }
            else if(/*activeView.visible === false*/UIListener.IsRunningInBG() && ahaStationList.getStationIndexUsedfromStationIdTune() === nTuneIndex)   // by Ryu 20130817
            {
                UIListener.OSDTrackInfo();
            }
        }
    }

//wsuk.kim TUNE_5SEC
    function handleRevertTrackInfoTune()
    {
        nTuneIndex = ahaStationList.getStationIndexUsedfromStationIdTune();
//        if(ahaStationList.getStationIdTune() === 1 /*STATION_PRESET*/)
//        {
//            nTuneIndex = ahaStationList.getPresetIndex();
//        }
//        else if(ahaStationList.getStationIdTune() === 2 /*STATION_LBS*/)
//        {
//            nTuneIndex = ahaStationList.getLBSIndex();
//        }

        bTuneTextColor = true;
        trackInfoModel.set(0,{station : InTrackInfo.station});
        trackInfoModel.set(0,{currentstationart : ahaTrack.GetCurrentStationFilePath()});  //wsuk.kim 130902 ISV_90329 to display station art image that tune search.

        // ITS 0221961   by Ryu 20140128,  ITS 0225357
        if(UIListener.IsCallingSameDevice() == false && UIListener.getNetworkStatus() == 0)
        {
            trackViewButtons.state = "NextPrevBtnEnabled";
        }
    }
//wsuk.kim TUNE_5SEC
//wsuk.kim TUNE

    function handleNetworkState(bNetworkState)  //140103
    {
        UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleNetworkState] bNetworkState:"+ bNetworkState);
        if(bNetworkState === false)    // network error
        {
            bNoNetworkTextVisible = true;
            trackInfoModel.set(0,{artist : qsTranslate("main","STR_AHA_NO_NETWORK")});
            trackInfoModel.set(0,{title : qsTranslate("main","STR_AHA_WAITING_FOR_RECOVERY")});
            trackInfoModel.set(0,{album : ""});

            /*
            artistName.scrollingTicker = false;
            artistName.marque = false;
            artistName.restart();

            titleName.scrollingTicker = false;
            titleName.marque = false;
            titleName.restart();
            */
            handleBtnState(false);
        }
        else    // network resume
        {
            bNoNetworkTextVisible = false;
            trackInfoModel.set(0,{artist : InTrackInfo.artist});
            trackInfoModel.set(0,{title : InTrackInfo.title});
            trackInfoModel.set(0,{album : InTrackInfo.album});

            if(UIListener.IsCallingSameDevice() === false)  // check call state
                handleBtnState(true);
        }
    }

    function handleBtnState(bBtnState)
    {
        UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [handleBtnState] bBtnState:"+ bBtnState);

        trackModeAreaWidget.isNoNetwork = bNoNetworkTextVisible; // ITS 225504

        if(bBtnState === false)
        {
            if(optMenu.visible)
            {
                optMenu.quickHide();
                optMenu.hideFocus();
            }

            ahaTrackView.state = "trackStateBtnDisable";
//wsuk.kim 131029 during BT call, focus move to title.
            trackModeAreaWidget.isListDisabled = true;  //wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
            trackViewButtons.hideFocus();
            trackModeAreaWidget.showFocus();
            trackModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
//wsuk.kim 131029 during BT call, focus move to title.
        }
        else
        {
            //Suryanto Tan 2014.03.18
            //When enabling the icon, change the playing state
            //according to actual track status.
            //ahaTrackView.state = "trackStatePlaying";
            if(ahaTrack.TrackStatus()===1)
            {
                ahaTrackView.state = "trackStatePlaying";
            }
            else
            {
                ahaTrackView.state = "trackStatePaused";
            }

//wsuk.kim 131029 during BT call, focus move to title.
            trackModeAreaWidget.isListDisabled = false; //wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
            trackModeAreaWidget.hideFocus();
            trackViewButtons.showFocus();
//wsuk.kim 131029 during BT call, focus move to title.
        }
    }

    function handleCallState(bCallState)  //140122
    {
        if(bCallState)      // now calling
        {
            trackViewButtons.releasedSkipPrevNextBtn();  // ITS 227244

            handleBtnState(false);
        }
        else                   // end call
        {
            handleHideErrorPopup();

            if(UIListener.getNetworkStatus() === 0 /*Network Normal*/)  // check network state
            {
                handleBtnState(true);
            }
            else
            {
                handleBtnState(false);
            }

            UIListener.printQMLDebugString("handleCallState ahaTrackView.state: "+ahaTrackView.state);
            UIListener.printQMLDebugString("handleCallState isPlaying: "+trackViewButtons.isPlaying);
            // ITS 227244
            if(ahaTrackView.state === "trackStatePlaying")
            {
                trackViewButtons.setTrackCurrentState(ahaTrackView.state);
            }
            trackViewButtons.stopTimeshiftAnimation();
        }
    }

//wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
    function handleTempHideFocus()
    {
        if(trackModeAreaWidget.focus_visible)
            nFocusPosition = 1;
        else //if(trackViewButtons.focusVisible)
            nFocusPosition = 2;

        trackModeAreaWidget.hideFocus();
        trackViewButtons.hideFocus();
		// ITS_0222226 focus reset
        trackViewButtons.releasedSkipPrevNextBtn();
    }

    function handleRestoreShowFocus()
    {
        if(nFocusPosition === 1 || UIListener.getNetworkStatus() != 0)
            trackModeAreaWidget.showFocus();
        else //if(nFocusPosition === 2)
            trackViewButtons.showFocus();
    }

    function handleTuneRevert()  // ISV 98805
    {
        if (tuneSearching)
        {
            tuneRevertInforTimer.stop();
            trackViewButtons.state = "NextPrevBtnEnabled";
            handleRevertTrackInfoTune();
        }
    }

//wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.

    /***************************************************************************/
    /**************************** Private functions END **********************/
    /***************************************************************************/

    /***************************************************************************/
    /**************************** Aha Qt connections START ****************/
    /***************************************************************************/

    Connections
    {
        //hsryu_0502_jog_control
        target: (!popupVisible && !isNaviExceptPopupVisible /*&& !isShiftPopupVisible*/
                 && !isReceivingPopupVisible && /*!btBlockPopupVisible*/!popUpTextVisible && !stationGuidePopupVisible &&!networkErrorPopupVisible) ? UIListener:null  //wsuk.kim navi_pop

        onMenuKeyPressed:
        {
            handleMenukey(isJogMenuKey);
        }

        onPlayCommandFromVR:
        {
            if ( ahaTrackView !== undefined )
            {
                if(inPayLoad === 1)
                {
                    if(ahaTrackView.state === "trackStatePaused")
                    {
                        //Play command
                        ahaTrack.PlayPause();
                    }
                }
                else
                {
                    if(ahaTrackView.state === "trackStatePlaying")
                    {
                        //Pause command
                        ahaTrack.PlayPause();
                    }
                }
            }
        }

        onRatingCommandFromVR:
        {
            if ( ahaTrackView !== undefined && InTrackInfo.allowRating === true)
            {
                if( inPayLoad === 1 )
                {
                    //Thumb Up command
//wsuk.kim menu_option NOT_USED                    ahaTrack.ThumbUp();
                }
                else
                {
                    //Thumb Down command
//wsuk.kim menu_option NOT_USED                    ahaTrack.ThumbDown();
                }
            }
        }

//wsuk.kim 131210 ITS_214306 duplicating hide option menu.
//        onSignalJogNavigation:
//        {
//            if(status === UIListenerEnum.KEY_STATUS_RELEASED)
//            //wsuk.kim 130903 menu hide to change jog left from press to releas. if(status === UIListenerEnum.KEY_STATUS_PRESSED) //hsryu_0502_jog_control
//            {
//                if(optMenu.visible)
//                {
//                    if(arrow === PR.const_AHA_JOG_EVENT_ARROW_LEFT)
//                    {
//                        //optMenu.visible = false;
//                        optMenu.quickHide();
//                        optMenu.hideFocus();

//                        trackModeAreaWidget.hideFocus();

//                        if(isDialUI)
//                        {
//                            trackViewButtons.showFocus();
//                        }
//                    }
//                    else
//                    {
//                        __LOG("MYLog: Menu is visible")
//                        trackViewButtons.hideFocus();
//                        trackModeAreaWidget.hideFocus();    //wsuk.kim title_jog
//                        if(!optMenu.focus_visible)
//                        {
//                            __LOG("Focus is not there on Menu So setting the focus")
//                            optMenu.showFocus();
//                            optMenu.setDefaultFocus(0);
//                        }
//                    }
//                }
//            }
//        }

//wsuk.kim WHEEL_SEARCH
        onHandleCCPDownEvent:
        {
            if(!trackModeAreaWidget.focus_visible)
            {
                handleFocusTuneDown(arrow);
            }
        }

        onHandleCCPUpEvent:
        {
            if(!trackModeAreaWidget.focus_visible)
            {
                handleFocusTuneUp(arrow);
            }
        }
//wsuk.kim WHEEL_SEARCH

//wsuk.kim text_scroll
        onHandleTextScrollState:
        {
            isDRSTextScroll = isTextScrolling;
        }
    }

    Connections
    {
        target: ahaTrack
        onPlayStarted:
        {
            UIListener.printQMLDebugString("DHAVN_AhaTrackView.qml   onPlayStarted: \n");
            if(UIListener.IsCallingSameDevice() == false && UIListener.getNetworkStatus() == 0)         // Call end & Network normal
            {
                trackViewButtons.setTrackCurrentState("trackStatePlaying");
                ahaTrackView.state = "trackStatePlaying";
                //            prBar.bStartRunning = true;
            }
        }

        onPauseDone:
        {
            trackViewButtons.setTrackCurrentState("trackStatePaused");
            if(UIListener.IsCallingSameDevice() || UIListener.getNetworkStatus() != 0)   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
                ahaTrackView.state = "trackStateBtnDisable";
            else
                ahaTrackView.state = "trackStatePaused";
            //           prBar.bStartRunning = false;
        }

        onSkipFailed:
        {
            __LOG ("Skip Failed");
        }

        onTrackUpdated:
        {
            UIListener.printQMLDebugString("DHAVN_AhaTrackView.qml   onTrackUpdated: \n");

            if(ahaTrackView !== undefined)
            {
                if(trackInfoModel.count > 0)
                    trackInfoModel.remove(0);
                //albumArt= ""; //hsryu_0314_default_albumart

                // Display Loading View when track changes
                //albumArtWaitIndicator.visible = false; //hsryu_0314_default_albumart
                //hsryu_0314_default_albumart
                listView.visible = false;
                ahaTrackView.state = "trackStateInfoWaiting"
                trackViewButtons.stopTimeshiftAnimation(); // added 2014.03.05
                trackViewButtons.state = "buttonsDisabled";
                ahaTrack.RequestTrackInfo();

//                qmlProperty.setActiveStationName(inTrackInfo.CurrentStation);
            }
        }
        onTrackInfoReceived:
        {
            listView.visible = true;
            trackViewButtons.setTrackCurrentState(initialStateofTrackView);
            // ITS 0223477  trackViewButtons.state = "dummy";
            updateUIWithTrackInfo();
            if(UIListener.IsCallingSameDevice())    //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
            {
                trackViewButtons.state = "buttonsDisabled";
//wsuk.kim 131029 during BT call, focus move to title.
                trackViewButtons.hideFocus();
                trackModeAreaWidget.showFocus();
                trackModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
//wsuk.kim 131029 during BT call, focus move to title.
            }
            else
            {
                UIListener.printQMLDebugString("$$sam ================onTrackInfoReceived=============== buttonsEnabled...111:"+InTrackInfo.allowTimeShift +" allowTimeShift:"+  trackViewButtons.allowTimeShift);
                trackViewButtons.state = "buttonsEnabled";
            }

            if( initialStateofTrackView === "trackStatePlaying" )
            {
                //               prBar.bStartRunning = true;
            }

            UIListener.printQMLDebugString("initialStateofTrackView " + initialStateofTrackView);
            ahaTrackView.state = initialStateofTrackView;
            albumArtWaitIndicator.visible = true;

           if(UIListener.IsRunningInBG() && bTrackInfoDoubleCheck === true)
            {
                UIListener.SetOSDFlag(true);
                UIListener.OSDTrackInfo();
                UIListener.printQMLDebugString("TrackInfoTEST onTrackInfoReceived OSDTrackInfo  ");

                bTrackInfoDoubleCheck = false;
            }
           bTrackInfoDoubleCheck = true;
        }

        //updating the like dislike buttons.
        onUpdateLikeDislikeFilePath:
        {
            UIListener.printQMLDebugString("$$sam ================onUpdateLikeDislikeFilePath===============isRateVisible: " + trackViewButtons.isRateVisible);
            trackViewButtons.updateLikeDislikeImage(currLikeIcon, altLikeIcon, currDislikeIcon, altDislikeIcon);
            //hsryu_0326_like_dislike
            trackViewButtons.isRateVisible = true;
        }

        onAlbumArtReceived:
        {
            UIListener.printQMLDebugString("$$ ================onAlbumArtReceived===============: " + filePath);
            //hsryu_0314_default_albumart
            albumArtWaitIndicator.visible =  false;
            if(filePath.length > 0)
            {
                albumArt = filePath;
            }
            else
            {
                albumArt = PR_RES.const_APP_AHA_TRACK_VIEW_NO_ALBUM_ART_IMG;
            }
            //hsryu_0314_default_albumart
            trackInfoModel.set(0,{bufferingGrayVisible : (nPlayBackStatus === 3 && albumArt.length != 0 && !onGoingTimeShift)? true: false});    //wsuk.kim buffering
        }
        onPartnerLogoReceived:
        {
            if(filePath.length>0)
            {
                partnerLogo = filePath;
            }
            else
            {
                partnerLogo = "";
            }
        }
        onRatingImageReceived:
        {
            if(filePath.length>0)
            {
                ratingImage = filePath;
            }
            else
            {
                ratingImage = "";
            }
        }
        onStationLogoReceived:
        {
            if(tuneSearching)   //wsuk.kim 130902 ISV_90329 to display station art image that tune search.
                trackInfoModel.set(0,{currentstationart : ahaStationList.getStationArtTune(nTuneIndex)});
            else
                trackInfoModel.set(0,{currentstationart : filePath});
        }
//wsuk.kim TUNE_TRACK
//wsuk.kim 131105 receivingStation Popup.
//        onReceivingStationShowPopup:
//        {
//            receivingStationPopup.visible = true;
//        }
//wsuk.kim TUNE_TRACK
    }

    Connections
    {
        target: ahaMenus
        onMenuDataChanged:
        {
            optMenu.menumodel = ahaMenus.optTrackMenuModel
        }
    }

    Connections
    {
        target: (trackModeAreaWidget.focus_visible && isDialUI)?UIListener:null

        onSignalJogCenterPressed:
        {
            isJogEventinModeArea = true;
        }

        onSignalJogNavigation:
        {
            if(status === UIListenerEnum.KEY_STATUS_PRESSED)
                isJogEventinModeArea = true;
        }
    }

//wsuk.kim TUNE_TRACK
    Connections
    {
        target: ahaStationList

        onReceivingStationHidePopup:
        {
//wsuk.kim 131105 receivingStation Popup.   receivingStationPopup.visible = false;
            //hsryu_no_action_same_station_ITS_0174723
            nTuneIndex = ahaStationList.getStationIndexUsedfromStationIdTune();
        }

        onSetBufferingStatus:  //wsuk.kim buffering
        {
            nPlayBackStatus = playBackStatus;
            bufferingTimer.stop();
            loadingWaitImage.source = "";
//            trackInfoModel.set(0,{buffering : (playBackStatus === 3)? "Buffering": "Playing"}); //wsuk.kim buffering FOR CHECK
            trackInfoModel.set(0,{bufferingGrayVisible : (nPlayBackStatus === 3 && albumArt.length != 0 && !onGoingTimeShift)? true: false});
//UIListener.printQMLDebugString("300suk ================playBackStatus=============== "+ playBackStatus +"\n");
            if(playBackStatus === 3 && !onGoingTimeShift)
            {
               bufferingTimer.start();
            }
        }
    }

//wsuk.kim TUNE_TRACK
    /***************************************************************************/
    /**************************** Aha Qt connections END ****************/
    /***************************************************************************/

    DHAVN_AhaAlbumArtWaitView{
        id: albumArtWaitIndicator
        visible: false
        //hsryu_0314_default_albumart
        onVisibleChanged: {
            if(!visible)
            {
                albumArt = PR_RES.const_APP_AHA_TRACK_VIEW_NO_ALBUM_ART_IMG;
            }
            else
            {
                albumArt = "";
            }
            UIListener.printQMLDebugString("[AhaTrackView.qml] albumArtWaitIndicator:onVisibleChanged..out");
        }
    }

    DHAVN_AhaTrackViewButtons{
        id: trackViewButtons
        parent: ahaTrackView
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: PR.const_APP_AHA_TRACK_VIEW_BUTTONS_TOP_MARGIN_OFFSET //520 - 93

        onLostFocus:
        {
            if(arrow === UIListenerEnum.JOG_UP)
            {
                trackModeAreaWidget.showFocus();
                if(trackModeAreaWidget.focus_index == -1)
                {
                    trackModeAreaWidget.setDefaultFocus(arrow);
                }
            }
        }
    }

    Loader { id: ahaRadio; }
    // MODE AREA

    DHAVN_AhaModeArea{
        id: trackModeAreaWidget

        modeAreaModel: trackModeAreaModel

        search_visible: false
        parent: ahaTrackView
        anchors.top: parent.top

        onModeArea_BackBtn:
        {
            isDialUI = isJogEventinModeArea;
            ahaTrackView.handleBackRequest();
            isJogEventinModeArea = false;
        }

        onModeArea_MenuBtn:
        {
            isDialUI = isJogEventinModeArea;
            handleMenukey(isJogEventinModeArea);
            isJogEventinModeArea = false;
        }

        onLostFocus:
        {
            isJogEventinModeArea = true;
            switch(arrow)
            {
                case UIListenerEnum.JOG_DOWN:
                {
                    if(UIListener.getNetworkStatus() != 0) //  during Network error,  focus can not move down
                    {
                        return;
                    }

                    if(UIListener.IsCallingSameDevice())    //wsuk.kim 131029 during BT call, focus move to title.
                    {
                        UIListener.OSDInfoCannotPlayBTCall();
                        break;
                    }
                    trackModeAreaWidget.hideFocus();
                    trackViewButtons.showFocus();
                    break;
                }
            }
        }

//wsuk.kim list_btn
        onModeArea_RightBtn:
        {
            if(UIListener.IsCallingSameDevice())    //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
            {
                UIListener.OSDInfoCannotPlayBTCall();
                return;
            }
            //ahaStationList.requestContentList();
            //ahaTrackView.handleContentListViewEvent();
            ahaStationList.requestStationList();
            ahaTrackView.handleListViewEvent();
        }

//wsuk.kim title_bar
        onModeArea_RightBtn2:
        {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
////hsryu_0423_block_play_btcall
//            isDialUI = isJogEventinModeArea;
//            //UIListener.printQMLDebugString("++++hsryu trView onModeArea_RightBtn2 ++++" + center_clicked +" \n");
//            //hsryu_0423_block_play_btcall
//            //if(center_clicked) //center key
//            {
//                trackModeAreaWidget.hideFocus();
//                trackViewButtons.showFocus();
//            }

            if(UIListener.IsCallingSameDevice())
            {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//                if(center_clicked) //center key
//                {
//                    handleShowTrackBtBlockPopup(1);
//                    center_clicked = false;
//                }
//                else
//                {
//                    handleShowTrackBtBlockPopup(0);
//                }
//                isJogEventinModeArea = false;
                UIListener.OSDInfoCannotPlayBTCall();
            }
            else
			{
                isDialUI = isJogEventinModeArea;
                if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                {
                    toastPopupVisible = false;
                }
//wsuk.kim 130916 ITS_190541 TrackView BG, focus movement.
//                if(isJogEventinModeArea)
//                {
//                    trackModeAreaWidget.hideFocus();
//                    trackViewButtons.showFocus();
//                }
				UIListener.CallPOI();
			}
//hsryu_0423_block_play_btcall
            
        }

        onModeArea_RightBtn1:
        {
//hsryu_0423_block_play_btcall
            isDialUI = isJogEventinModeArea;
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            //UIListener.printQMLDebugString("++++hsryu trView onModeArea_RightBtn1 ++++" + UIListener.GetAhaGPSStatus() +" \n");
//wsuk.kim 130916 ITS_190541 TrackView BG, focus movement.
//            if(isJogEventinModeArea)
//            {
//                trackModeAreaWidget.hideFocus();
//                trackViewButtons.showFocus();
//            }

            //hsryu_0312_navi_exception
            //hsryu_0502_jog_control
            if(UIListener.GetAhaGPSStatus() === 1)
            {
                if(isJogEventinModeArea)    //wsuk.kim 130916 ITS_190541 TrackView BG, focus movement.
                {
                    trackModeAreaWidget.hideFocus();
                    trackViewButtons.showFocus();
                }
                handleShowErrorPopup(1); //hsryu_0514_check_latitude_longitude_for_aha
                isJogEventinModeArea = false;   //wsuk.kim navi_pop
            }
            else
            {
//hsryu_0620_unlock_navigate
                //hsryu_0514_check_latitude_longitude_for_aha
//                if(UIListener.CheckLocateForNavigation() === false)
//                {
//                    handleShowErrorPopup(2);
//                    isJogEventinModeArea = false; //hsryu_0508_patch_jog_key
//                }
//                else
//                {
                    UIListener.NavigateToPOI();
//                }
            }
//hsryu_0423_block_play_btcall
        }
//wsuk.kim title_bar

        ListModel
        {
            id: trackModeAreaModel

            property bool search_visible: false
//wsuk.kim title_bar
            property bool rb2_visible: titlePhonePOI.enabled;
            property bool rb1_visible: titleNavigatePOI.enabled;
//wsuk.kim title_bar
            //hsryu_0306_change_menu
            property string rb_text: QT_TR_NOOP("STR_AHA_STATIONS");
            property bool rb_visible: true;
            property bool right_text_visible_f: true;

            property string image: PR_RES.const_APP_AHA_WAIT_VIEW_LOGO_AHA_IMG
            property string mb_text: QT_TR_NOOP("STR_AHA_MENU");
            property bool mb_visible: true;
        }
//wsuk.kim list_btn
    }

//wsuk.kim title_bar
    Rectangle
    {
        id: titlePhonePOI
        property bool enabled: titlePhonePOI.enabled
    }

    Rectangle
    {
        id: titleNavigatePOI
        property bool enabled: titleNavigatePOI.enabled
    }
//wsuk.kim title_bar
    /***************************************************************************/
    /**************************** Aha QML connections START ****************/
    /***************************************************************************/

    Component.onCompleted: {
        isLoadingPopupVisible = false;  //wsuk.kim 131106 loading/fail popup move to AhaRadio.qml
        activeView = ahaTrackView;
        if(!ahaController.noActiveStation)
            qmlProperty.setFocusArea(PR.const_STATION_LIST_TRACK_VIEW_FOCUS);

        handleForegroundEvent();
//wsuk.kim TUNE
        nTuneIndex = ahaStationList.getStationIndexUsedfromStationIdTune();
//        if(ahaStationList.getStationIdTune() === 1 /*STATION_PRESET*/)
//        {
//            nTuneIndex = ahaStationList.getPresetIndex();
//        }
//        else if(ahaStationList.getStationIdTune() === 2 /*STATION_LBS*/)
//        {
//            nTuneIndex = ahaStationList.getLBSIndex();
//        }
//wsuk.kim TUNE
    }

//wsuk.kim 130827 update indicator text when to change language.
    onVisibleChanged:
    {
        if(ahaTrackView.visible === true)
        {
            front_back_indicator_text.text = UIListener.getConnectTypeName();
        }
        else
        {
            handleTuneRevert();
        }
    }
//wsuk.kim 130827 update indicator text when to change language.

    Connections{
        target: ahaController
        //hsryu_0329_system_popup
        onHandleCloseTrackPopup:
        {
            UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [onHandleCloseTrackPopup] 2 ");
            if(optMenu.visible === true)
            {
                //optMenu.visible = false;
                optMenu.quickHide();
            }

            if(waitpopup.visible === true)
            {
                waitpopup.visible = false;
            }
//wsuk.kim 131105 shift error popup move to AhaRadio.qml
//            if(shiftPopup.visible === true)
//            {
//                shiftPopup.visible = false;
//            }

            if(naviExceptPopup.visible === true)
            {
                if(isNaviPopCenterKey)  //wsuk.kim navi_pop
                {
                    isNaviPopCenterKey = false;
                    break;
                }
                naviExceptTimer.stop();
                naviExceptPopup.visible = false
            }

            ahaTrackView.handleTempHideFocus();   //wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
        }
        onHandleRestoreTrackPopup:
        {
            ahaTrackView.handleRestoreShowFocus(); //wsuk.kim 140102 ITS_217338 to display system popup, hide view focus.
        }

        onHandleSelectionEvent:
        {
            UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [onHandleSelectionEvent] reset option menu....... ");
            ahaTrackView.resetOptionMenu();
        }

        onHandleFrontBackIndicatorRefresh:  // added ITS 228391
        {
            front_back_indicator_text.text = UIListener.getConnectTypeName();
        }

        //before calling handleShowDefaultDisplay, call ahaTrack.ClearTrackInfo()
        onHandleShowDefaultDisplay:
        {
            UIListener.printQMLDebugString("$$$$$$ ahaTrackView.qml [onHandleShowDefaultDisplay] ");
            trackInfoModel.set(0,{artist : ""});
            trackInfoModel.set(0,{title : ""});
            trackInfoModel.set(0,{album : ""});
            albumArt = "";
            //albumArt = PR_RES.const_APP_AHA_TRACK_VIEW_NO_ALBUM_ART_IMG;
            trackInfoModel.set(0,{bufferingGrayVisible : (nPlayBackStatus === 3 && albumArt.length != 0 && !onGoingTimeShift)? true: false});    //wsuk.kim buffering
            trackInfoModel.set(0,{station : ahaStationList.getStationNameTune(nTuneIndex, true)});
            albumArtWaitIndicator.visible = true;
        }

//wsuk.kim 130809 ITS_0183278 2focuses display when jog up
//        onIsDialUIChanged:
//        {
//            if(isDialUI)
//            {
//                if(optMenu.visible)
//                {
//                    optMenu.showFocus();
//                    optMenu.setDefaultFocus(0);
//                }
//                else
//                {
//                    trackViewButtons.showFocus();
//                }
//            }
//            else
//            {
//                trackViewButtons.hideFocus();
//                trackModeAreaWidget.hideFocus();
//            }
//        }
//wsuk.kim 130809 ITS_0183278 2focuses display when jog up
    }

    //connection from buttom button
    Connections{
        target: trackViewButtons
        onHandleListViewEvent:{
            //ToDo :: Commented for current release
            ahaTrackView.handleListViewEvent();
        }
        onHandlePlayPauseEvent:{
            ahaTrackView.handlePlayPauseEvent();
        }
        onHandleSkipEvent:{
            ahaTrackView.handleSkipEvent();
        }
        onHandleSkipBackEvent:{
            ahaTrackView.handleSkipBackEvent();
        }
        onHandleRewind15Event:{
            ahaTrackView.handleRewind15Event();
        }
        onHandleForward30Event:{
            ahaTrackView.handleForward30Event();
        }
        onHandleRewindEvent:{
            ahaTrackView.handleRewindEvent();
        }
        onHandleRatingEvent:
        {
            //    popupLoading.visible = true;
            if(rating === 1)
            {
                ahaTrack.LikeButtonClicked();
            }
            else if(rating === 2)
            {
                ahaTrack.DislikeButtonClicked();
            }
        }
//wsuk.kim 130207 jog_pop
        onHandleNoSkipBackEvent:{
            ahaTrackView.handlePopupNoSkipBack();
        }
        onHandleNoSkipEvent:{
            ahaTrackView.handlePopupNoSkip();
        }
        onHandleNoREW15Event:{
            ahaTrackView.handlePopupNoREW15();
        }
        onHandleNoFW30Event:{
            ahaTrackView.handlePopupNoFW30();
        }

//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//        //hsryu_0423_block_play_btcall
//        onTrackShowBtBlockPopup:
//        {
//            handleShowTrackBtBlockPopup(jogCenter);
//        }

//wsuk.kim 130207 jog_pop
//wsuk.kim WHEEL_SEARCH
        onHandleJogCenterSearch:
        {
           handleFocusTuneCenter();
        }
//wsuk.kim WHEEL_SEARCH

        onHandleStopTuneSearching:  //wsuk.kim 130912 ITS_0189859 pressed HK skip/skipback during tune search.
        {
            if(UIListener.IsCallingSameDevice() || UIListener.getNetworkStatus() != 0)
            {
                return;
            }

            tuneRevertInforTimer.stop();

            // ITS 0221961   by Ryu 20140128
            trackViewButtons.state = "NextPrevBtnEnabled";

            handleRevertTrackInfoTune();
        }
        
		//ITS_226621
        onHandlePressSeekTrack:
        {
            handleSeekTrackPressedFocus()
        }
    }

    /***************************************************************************/
    /**************************** Aha QML connections END ****************/
    /***************************************************************************/

//wsuk.kim 130207 jog_pop
//wsuk.kim 131105 shift error popup move to AhaRadio.qml
//    POPUPWIDGET.PopUpText
//    {
//        id: shiftPopup
//        z: 1000
//        y: -PR.const_AHA_ALL_SCREENS_TOP_OFFSET //hsryu_change_new_popup_pos
//        icon_title: EPopUp.WARNING_ICON
//        visible: false
//        message: shiftErrorModel
//        buttons: btnmodel
//        focus_visible: isDialUI && shiftPopup.visible
//        property bool showErrorView;

//        function showPopup(text, errorView)
//        {
//            shiftPopup.showErrorView = errorView;
//            if(!visible)
//            {
//                shiftErrorModel.set(0,{msg:text})
//                visible = true;
//                //functionalTimer.start();          // by Ryu : ITS 0187776
//                shiftPopup.setDefaultFocus(0);
//            }
//        }

//        function hidePopup()
//        {
//            visible = false;
//            //functionalTimer.stop();           // by Ryu : ITS 0187776
//        }

//        onBtnClicked:
//        {
//            switch ( btnId )
//            {
//                case "OK":
//                {
//                    //functionalTimer.stop();           // by Ryu : ITS 0187776
//                    shiftPopup.visible = false
//                }
//                break;
//            }
//        }
//    }

//    ListModel
//    {
//        id: shiftErrorModel
//        ListElement
//        {
//            msg: ""
//        }
//    }

//    Timer{
//     id: functionalTimer
//     running: false
//     repeat: false
//     interval: 3000
//        onTriggered:{
//            shiftPopup.visible = false;
//            if(shiftPopup.showErrorView && ahaController.state !== "ahaTrackView")
//            {
//                ahaController.state = "ahaTrackView"
//            }
//        }
//    }
//wsuk.kim 130207 jog_pop

    ListModel
    {
        id: errorModel
    }

    POPUPWIDGET.PopUpDimmed
    {
        id: waitpopup;
        visible: false;
        message: errorModel

        function showPopup(text)
        {
            if(!visible)
            {
                errorModel.clear();
                errorModel.append({msg:qsTranslate("main",text)})
                visible = true;
                timeOutTimer.start();
            }
        }

        Timer{
            id: timeOutTimer
            running: false
            repeat: false
            interval: 3000
            onTriggered: {
                waitpopup.visible = false
            }
        }
    }

    DHAVN_AhaPopup_Loading
    {
        visible: false;
    }

    MouseArea{
        anchors.fill: parent
        z: -10
        onClicked: {
        }
    }

    //hsryu_0312_navi_exception
    ListModel
    {
        id: msgModel
        ListElement
        {
            msg: ""
        }
    }

    POPUPWIDGET.PopUpText
    {
        id: naviExceptPopup
        z: 1
        y: -PR.const_AHA_ALL_SCREENS_TOP_OFFSET	//wsuk.kim 131101 status bar dimming during to display popup.   y: -80
        icon_title: EPopUp.WARNING_ICON
        visible: false
        message: msgModel
        buttons: btnmodel
        focus_visible: isDialUI && naviExceptPopup.visible

        function showPopup(text)
        {
            if(!visible)
            {
                msgModel.set(0,{msg:text})
                visible = true;
                naviExceptTimer.start();
                naviExceptPopup.setDefaultFocus(0);
            }
        }

        function hidePopup()
        {
            visible = false;
            naviExceptTimer.stop();
        }

        onBtnClicked:
        {
            switch ( btnId )
            {
                case "OK":
                {
//hsryu_0502_jog_control
//                    if(isNaviPopCenterKey)  //wsuk.kim navi_pop
//                    {
//                        isNaviPopCenterKey = false;
//                        break;
//                    }
                    naviExceptTimer.stop();
                    naviExceptPopup.visible = false;
                }
                break;
            }
        }
    }

    Timer{
        id: naviExceptTimer
        running: false
        repeat: false
        interval: 5000
        onTriggered:{
            naviExceptPopup.visible = false;
        }
    }
    //hsryu_0312_navi_exception


//wsuk.kim TUNE_5SEC
    Timer{
        id: tuneRevertInforTimer
        running: false
        repeat: false
        interval: 5000

        onTriggered:{
            handleRevertTrackInfoTune();
        }
    }
//wsuk.kim TUNE_5SEC

//wsuk.kim TUNE_TRACK
//wsuk.kim 131105 receivingStation Popup.
//    ListModel
//    {
//        id: receivingStationModel
//        ListElement{
//            msg: QT_TR_NOOP("STR_AHA_RECEIVING_STATIONS")
//        }
//    }

//wsuk.kim 131105 receivingStation Popup.
//   POPUPWIDGET.PopUpText/*PopUpToast*/
//   {
//       id: receivingStationPopup
//       y: -PR.const_AHA_ALL_SCREENS_TOP_OFFSET	//wsuk.kim 131101 status bar dimming during to display popup.   y: 0
//       z: 1000
//       visible: false
////wsuk.kim 130719 popup type change from toast to text
//       icon_title: EPopUp.LOADING_ICON
//       message: receivingStationModel
//       focus_id: 0
////wsuk.kim 130719 popup type change from toast to text
////       opacity: 0.9
////       bHideByTimer: false
////       listmodel: receivingStationModel

//       //hsryu_0613_fail_load_station
//       Timer{
//           id: receivingStationTimer
//           running: receivingStationPopup.visible
//           repeat: false
//           interval: 30000
//           onTriggered:{
//               UIListener.printQMLDebugString("\n receivingStationTimer \n" + receivingStationPopup.visible + "\n")
//               if(receivingStationPopup.visible === true)
//               {
//                   receivingStationPopup.visible = false;
//                   handlShowFailLoadStation();
//               }
//           }
//       }
//   }
//wsuk.kim TUNE_TRACK

//wsuk.kim buffering
   Item {
       id: bufferingItem

       Image {
           id: loadingWaitImage
           x: PR.const_AHA_TRACK_VIEW_ALBUM_ART_LOADING_IMG_X_OFFSET
           y: PR.const_AHA_TRACK_VIEW_ALBUM_ART_LOADING_IMG_Y_OFFSET
           source: ""
       }
   }

   Timer{
       id: bufferingTimer
       interval: 100    //wsuk.kim 130906 loading animation interval 100ms/frame
       running: false
       repeat: true
       property int counter : PR.const_AHA_TIMER_COUNTER_MIN_VAL

       onTriggered: {
           counter = counter + 1
           if(counter === PR.const_AHA_TIMER_COUNTER_MAX_VAL)
           {
               counter = PR.const_AHA_TIMER_COUNTER_MIN_VAL
           }
           loadingWaitImage.source = PR_RES.const_APP_AHA_CONNECTING_WAIT[counter]
       }
   }
//wsuk.kim buffering
}
