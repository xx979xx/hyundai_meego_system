import Qt  4.7
import QmlModeAreaWidget 1.0
import QmlSimpleItems 1.0
import QmlOptionMenu 1.0
import AppEngineQMLConstants 1.0
import PandoraMenuItems 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
//{ modified by yongkyun.lee 2014-02-18 for : 
import POPUPEnums 1.0
//} modified by yongkyun.lee 2014-02-18 

import CQMLLogUtil 1.0

Item {
    id: pndrTrackView
    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    y: PR.const_PANDORA_ALL_SCREENS_TOP_OFFSET

    //QML Properties Declarations
    property int counter: PR.const_PANDORA_TIMER_COUNTER_MIN_VAL
    property variant buttonState
    property bool foregroundEventState;
    property string albumArt: ""
    property bool isFromErrorView: false
    property alias isOptionsMenuVisible: optMenu.visible
    property bool isTuneOn: false
    property bool updateTrackInfoOnTuneoff: false
    property bool scrollingTicker:UIListener.scrollingTicker;
    property string fadeColor : "#000011"
    property  int position: 0
    property bool featureOfTrack : true;
    property string noNetworkStationName: "";
    property string noNetworkArtistName: "";
    property string noNetworkTitleName: "";
    property string noNetworkAlbumName: "";
    property string noNetworkCurrentstationart: "";
    property bool isInsufficientTV: false;  
    property string logString :""

    //QML Signals Declaration
    signal handleListViewEvent;
    signal handleExplainViewEvent;
    //signal handleBackRequest;
    signal handleBackRequest(bool isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
    signal handleRewindEvent;


    //{ modified by yongkyun.lee 2014-12-12 for : ITS 254472
    function isToastPopup()
    {
        __LOG("[leeyk1]isToastPopup:" + myToastPopup.visible , LogSysID.LOW_LOG);
        return myToastPopup.visible ;
    }

    function forceCloseToastPopup()
    {
        __LOG("[leeyk1]toastLoadingPopup :" + myToastPopup.visible , LogSysID.LOW_LOG);
        if(myToastPopup.visible )
        {
            myToastPopup.visible = false;
            return true;
        }
        return false;
    }    
    //} modified by yongkyun.lee 2014-12-12 

    function closeToastPopup()
    {
        if(myToastPopup.visible && myToastPopup.dismiss) // if dissmisable toast pop up is visible , then make it false
        {
            myToastPopup.visible = false;
            return true;
        }

        return false;
    }

    function toastPopUpVisible(status)
    {
        if(!myToastPopup.visible)
            trackViewButtons.allowTouchEvent = !status;
    }

    function setInsufficient(isIns)
    {
        isInsufficientTV = isIns;
    }
    //} modified by yongkyun.lee 2014-03-11 

    //{ modified by yongkyun.lee 2014-09-01 for : Pandora 4.25 TEST
    function toastLoadingPopup()//onToastLoadingPopup:
    {
        __LOG("toastLoadingPopup :" , LogSysID.LOW_LOG);
        myToastPopup.show(QT_TR_NOOP("STR_PANDORA_LOADING") , false)
    }
    //{ modified by yongkyun.lee 2014-09-01

    //{ modified by yongkyun.lee 2014-11-27 for : NOCR
    function checkTune()
    {
        isTuneOn = false;
        UIListener.TuneSelectTimer(false);
        
        if( updateTrackInfoOnTuneoff || 
           !(UIListener.getModeStateHistoryCurr() == 21 || 
             UIListener.getModeStateHistoryCurr() == 12 || 
             UIListener.getModeStateHistoryCurr() == 15 ) )
        {
            updateTrackInfoOnTuneoff = false;
            pndrTrack.RequestTrackInfo();
        }
        trackViewButtons.jog_press = false;
        trackViewButtons.setTuneState(isTuneOn)
    }
    //} modified by yongkyun.lee 2014-11-27 

    Component
    {
        id:listDelegate


        Item {  // Item ONE
            id: albumArt_Image

            Image
            {
                id:cover_basic

                x: PR.const_PANDORA_TRACK_VIEW_DEFAULT_ALBUM_ART_IMG_X_OFFSET + 4
                y: PR.const_PANDORA_TRACK_VIEW_DEFAULT_ALBUM_ART_IMG_Y_OFFSET - PR.const_PANDORA_MODE_ITEM_HEIGHT
                source: PR_RES.const_APP_PANDORA_TRACK_VIEW_ALBUM_BG_IMG_2
                asynchronous : true
                Image
                {
                    id: cover_album

                    width: PR.const_APP_PANDORA_ALBUM_ART_WIDTH
                    height: PR.const_APP_PANDORA_ALBUM_ART_HEIGHT

                    anchors
                    {
                        left: cover_basic.left
                        leftMargin: PR.const_APP_PANDORA_ALBUM_LEFT_MARGIN - 1
                        top: cover_basic.top
                        topMargin: PR.const_APP_PANDORA_ALBUM_TOP_MARGIN
                    }
                    source: albumArt
                }
                Image
                {
                    id: album_light
                    source: PR_RES.const_IMG_ALBUM_LIGHT
                    anchors.fill: parent
                }
            }

            Image
            {
                id:cover_basic_reflect

                x: PR.const_APP_PANDORA_ALBUMART_LEFT_MARGIN_REFLECT_X + 6 //modified by wonseok.heo ITS 265596
                y: PR.const_APP_PANDORA_ALBUMART_TOP_MARGIN_REFLECT_Y
                asynchronous : true

                width: 242

                anchors
                {
                    //left: cover_basic_reflect.left //remove by jyjeon 2014.01.20 for warning catch
                    leftMargin: PR.const_APP_PANDORA_ALBUM_LEFT_MARGIN
                    //top: cover_basic_reflect.top //remove by jyjeon 2014.01.20 for warning catch
                    topMargin: PR.const_APP_PANDORA_ALBUM_TOP_MARGIN
                }
                source: PR_RES.const_APP_PANDORA_TRACK_VIEW_ALBUM_BG_IMG_2
                transform: Rotation
                {
                    //origin.x: PR.const_APP_PANDORA_BASE_ALBUMART_LEFT_MARGIN_REFLECT - const_APP_PANDORA_ALBUM_LEFT_MARGIN;
                    //origin.y: PR.const_APP_PANDORA_BASE_ALBUMART_TOP_MARGIN_REFLECT -  const_APP_PANDORA_ALBUM_TOP_MARGIN;
                    axis { x: 112; y: 112; z: 0 }
                    angle: 180
                }
                transformOrigin: Item.Center
                rotation: 90

                Image
                {
                    id: cover_album_reflect

                    width: PR.const_APP_PANDORA_ALBUM_ART_WIDTH
                    height: PR.const_APP_PANDORA_ALBUM_ART_HEIGHT

                    anchors
                    {
                        left: cover_basic_reflect.left
                        leftMargin: PR.const_APP_PANDORA_ALBUM_LEFT_MARGIN -6 //modified by wonseok.heo ITS 265596
                        top: cover_basic_reflect.top
                        topMargin: PR.const_APP_PANDORA_ALBUM_TOP_MARGIN
                    }
                    source: albumArt
                }

                Rectangle
                {
                     //{ modified by yongkyun.lee 2014-12-18 for : ITS 254824
                     anchors.fill: parent
             
                     gradient: Gradient 
                     {
                         GradientStop 
                         {
                            position: 0.0
                            color: "#030406"
                         }
                         GradientStop 
                         {
                             position: 0.3
                             color: "#080b0e"
                         }
                         GradientStop 
                         {
                             position: 0.5
                             color: "#0c1015"
                         }
                         GradientStop 
                         {
                             position: 0.7
                             color: "#FF" + fadeColor.substring(1) 
                         }
                         GradientStop 
                         {
                             position: 1.0
                             color: "#AA" + fadeColor.substring(1)
                         }
                     }
                     //} modified by yongkyun.lee 2014-12-18 
                 }
            }



            Item { // Item 2
                id:track_radio

                property bool ticker1 : scrollingTicker

                onTicker1Changed:
                {
                    if(ticker1){
                        stationName.scrollingTicker = (position == 1) ?  true : false
                    }
                    else
                        stationName.scrollingTicker = false;
                }

                Image {
                    id: icon_station
                    x:PR.const_PANDORA_TRACK_VIEW_X_OFFSET -4                 
                    y:PR.const_PANDORA_TRACK_VIEW_STATION_ICON_ITEM_2_IMG_Y_OFFSET
                    height:49
                    width:49
                    source: currentstationart === PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_STATION_IMG ? PR_RES.const_APP_PANDORA_DEFAULT_STATION_ICON_IMG : currentstationart //added by wonseok.heo 2014.10.29 // modified by esjang for Default Image
                    asynchronous : true

                    onStatusChanged:{
                        if(Image.Error == icon_station.status || Image.Null  == icon_station.status){
                            __LOG("Error Image loading status : " + status , LogSysID.LOW_LOG );
                            trackInfoModel.set(0, {currentstationart : PR_RES.const_APP_PANDORA_LIST_VIEW_BG_STATION_LIST_IMG}) // modified by esjang for Default Image
                        }
                    }
                }


                DHAVN_MarqueeText
                 {
                    id: stationName
                    y:PR.const_PANDORA_TRACK_VIEW_STATION_ICON_ITEM_2_IMG_Y_OFFSET 
                    text: station
                    infinite : false
                    marque: (UIListener.getStringWidth(station , PR.const_PANDORA_FONT_FAMILY_HDR ,
                                                       PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT) > PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH)
                    scrollingTicker:( pndrTrackView.scrollingTicker && marque &&  position === 1)

                    fontSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT// added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                    fontFamily: PR.const_PANDORA_FONT_FAMILY_HDR// added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                    color: isTuneOn ? PR.const_PANDORA_COLOR_TEXT_CURR_STATION : PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
                    anchors.left: icon_station.left
                    anchors.leftMargin: PR.const_PANDORA_TRACK_VIEW_TEXT_OFFSET_FROM_ICONS
                    anchors.verticalCenter: icon_station.verticalCenter
                    width: PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH_FIRST// modified by yongkyun.lee 2014-12-19 for : ITS 254935

                    onTextChanged:
                    {
                        __LOG("station: " + station , LogSysID.LOW_LOG );
                        if(pndrTrackView.scrollingTicker)
                        {
                            stationName.marque = UIListener.getStringWidth(stationName.text , PR.const_PANDORA_FONT_FAMILY_HDR ,
                                                               PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT) > PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH_FIRST; //
                             if(stationName.marque)
                            {
                                stationName.scrollingTicker = (position == 0 || position == 1) ?  true : false
                                 if(stationName.scrollingTicker)
                                 {
                                     position = 1; //added by jyjeon 2014-03-04 for ITS 228075
                                     stationName.restart();
                                 }
                            }
                            else
                            {
                                stationName.scrollingTicker = false;
                                stationName.stop();
                                if(position == 1 ){position = 0}
                                if(position > 1){}
                                else if(artistName.marque ) {position = 2;artistName.restart()}
                                else if(titleName.marque ){ position = 3; titleName.restart()}
                                else if(albumName.marque ){ position = 4;albumName.restart()}
                                else {position = 0}
                            }
                        }
                    }

                    onMarqueeNext:{
                        if(!scrollingTicker ) return;
                        scrollingTicker = false ;
                        if(artistName.marque && pndrTrackView.scrollingTicker) {position = 2;artistName.restart()}
                        else if(titleName.marque && pndrTrackView.scrollingTicker){ position = 3; titleName.restart()}
                        else if(albumName.marque && pndrTrackView.scrollingTicker){ position = 4;albumName.restart()}
                        else if(pndrTrackView.scrollingTicker && position == 1){ scrollingTicker = true ;stationName.restart();}
                    }
                 }
            }

            Item // Item 3
            {
                id:track_artist

                property bool ticker2: scrollingTicker

                onTicker2Changed:
                {
                    if(ticker2){
                        artistName.scrollingTicker = (position == 2) ?  true : false
                    }
                    else
                        artistName.scrollingTicker = false;
                }
                Image {
                    id: icon_artist
                    x:PR.const_PANDORA_TRACK_VIEW_X_OFFSET-4
                    y:PR.const_PANDORA_TRACK_VIEW_ICON_ITEM_3_IMG_Y_OFFSET
                    height:49
                    width:49
                    source: PR_RES.const_APP_PANDORA_TRACK_VIEW_ICON_ARTIST_IMG
                }

                DHAVN_MarqueeText
                 {
                    id: artistName
                    text: artist
                    infinite : false
                    marque: (UIListener.getStringWidth(artist , PR.const_PANDORA_FONT_FAMILY_HDR ,
                                                       PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT) > PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH)
                    scrollingTicker: (pndrTrackView.scrollingTicker && marque &&  position == 2)

                    fontSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT// added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                    fontFamily: PR.const_PANDORA_FONT_FAMILY_HDR// added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                    color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
                    anchors.left: icon_artist.left
                    anchors.margins: PR.const_PANDORA_TRACK_VIEW_TEXT_OFFSET_FROM_ICONS
                    anchors.verticalCenter: icon_artist.verticalCenter
                    width: PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH

                    onMarqueeNext:{
                        scrollingTicker = false ;
                        if(titleName.marque && pndrTrackView.scrollingTicker) {position = 3; titleName.restart();}
                        else if(albumName.marque && pndrTrackView.scrollingTicker ){ position = 4;albumName.restart();}
                        else if(stationName.marque && pndrTrackView.scrollingTicker){ position = 1;stationName.restart();}
                        else if(pndrTrackView.scrollingTicker && pndrTrackView.scrollingTicker ){scrollingTicker = true ; artistName.restart();}

                       // console.log("Animation stooped on Artist name , change to : " + position )
                    }
                 }
            }

            Item // Item 4
            {
                id:track_title

                property bool ticker3: scrollingTicker

                onTicker3Changed:
                {
                    if(ticker3){
                        titleName.scrollingTicker = (position == 3) ?  true : false
                    }
                    else
                        titleName.scrollingTicker = false;
                }

                Image {
                    id: icon_music
                    height:49
                    width:49
                    x:PR.const_PANDORA_TRACK_VIEW_X_OFFSET-4
                    y:PR.const_PANDORA_TRACK_VIEW_ICON_ITEM_4_IMG_Y_OFFSET
                    source: PR_RES.const_APP_PANDORA_TRACK_VIEW_ICON_MUSIC_IMG
                }

                DHAVN_MarqueeText
                 {
                    id: titleName
                    text: title
                    infinite : false
                    marque: (UIListener.getStringWidth(title , PR.const_PANDORA_FONT_FAMILY_HDR ,
                                                       PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT) > PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH)
                    scrollingTicker: (pndrTrackView.scrollingTicker && marque &&  position == 3)

                    fontSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT// added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                    fontFamily: PR.const_PANDORA_FONT_FAMILY_HDR// added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                    color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY // modified by wonseok.heo NOCR for text location 2014.03.10 PR.const_PANDORA_LIGHT_DIMMED
                    anchors.left: icon_music.left
                    anchors.leftMargin: PR.const_PANDORA_TRACK_VIEW_TEXT_OFFSET_FROM_ICONS
                    anchors.verticalCenter: icon_music.verticalCenter
                    width: PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH

                    onMarqueeNext:{
                        scrollingTicker = false;
                        if(albumName.marque && pndrTrackView.scrollingTicker ) {position = 4; albumName.restart()}
                        else if(stationName.marque && pndrTrackView.scrollingTicker ) {position = 1;stationName.restart()}
                        else if(artistName.marque && pndrTrackView.scrollingTicker ) {position = 2;artistName.restart()}
                        else if(pndrTrackView.scrollingTicker){scrollingTicker = true; titleName.restart();}
                    }

                 }
            }

            Item // Item 5
            {
                id:track_album

                property bool ticker4: scrollingTicker

                onTicker4Changed:
                {
                    if(ticker4){
                        albumName.scrollingTicker = (position == 4) ?  true : false
                    }
                    else
                        albumName.scrollingTicker = false;
                }

                Image {
                    id: icon_album
                    height:49
                    width:49
                    x:PR.const_PANDORA_TRACK_VIEW_X_OFFSET-4
                    y:PR.const_PANDORA_TRACK_VIEW_ICON_ITEM_5_IMG_Y_OFFSET
                    source: PR_RES.const_APP_PANDORA_TRACK_VIEW_ICON_ALBUM_IMG
                }


                DHAVN_MarqueeText
                 {
                    id: albumName
                    text: album
                    infinite : false
                    marque: (UIListener.getStringWidth(album , PR.const_PANDORA_FONT_FAMILY_HDR ,
                                                       PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT) > PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH)
                    scrollingTicker:  (pndrTrackView.scrollingTicker && marque &&  position == 4)

                    fontSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT// added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                    fontFamily: PR.const_PANDORA_FONT_FAMILY_HDR// added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                    color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY // modified by wonseok.heo NOCR for text location 2014.03.10 PR.const_PANDORA_LIGHT_DIMMED
                    anchors.left: icon_album.left
                    anchors.leftMargin: PR.const_PANDORA_TRACK_VIEW_TEXT_OFFSET_FROM_ICONS
                    anchors.verticalCenter: icon_album.verticalCenter
                    width: PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH

                    onMarqueeNext:{
                        scrollingTicker = false;
                        if(stationName.marque && pndrTrackView.scrollingTicker ) {position = 1 ; stationName.restart()}
                        else if(artistName.marque && pndrTrackView.scrollingTicker ) {position = 2 ; artistName.restart()}
                        else if(titleName.marque && pndrTrackView.scrollingTicker) {position = 3; titleName.restart()}
                        else if(pndrTrackView.scrollingTicker){ scrollingTicker = true ; albumName.restart();}
                    }
                 }
            }
        }
    }

    Text
    {
        id: front_back_indicator_text
        text: UIListener.getConnectTypeName()

        anchors.left :pandoraLogo.right //modified by wonseok.heo NOCR for text location 2014.03.10 ( language == 2 || language == 7 ) ?  pndrTrackView.left : pandoraLogo.right
        anchors.leftMargin:28 //modified by wonseok.heo NOCR for text location 2014.03.10 (language == 2 || language == 7) ? PR.const_PANDORA_MODEWIDGET_LOGO_TEXT1_X_OFFSET : 28

        y: PR.const_PANDORA_MODEWIDGET_LOGO_TEXT1_Y_OFFSET
        z: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: PR.const_PANDORA_LIGHT_DIMMED // modified by wonseok.heo NOCR for text location 2014.03.10 PR.const_PANDORA_COLOR_WHITE//const_PANDORA_COLOR_LOG_TEXT_GREY
        font.pointSize: 40
        font.family: "NewHDB"//"HDR"
        style: Text.Sunken
        visible: UIListener.GetVariantRearUSB() || UIListener.IsBTPandora() //modified by jyjeon 2014.01.11 for ITS 218524
    }

    Image{
        id: pandoraLogo
        source: PR_RES.const_APP_PANDORA_TRACK_VIEW_PANDORALOGO_IMAGE
        
        anchors.left : pndrTrackView.left 
        anchors.leftMargin: 42 //modified by wonseok.heo NOCR for text location 2014.03.10( language == 2 || language == 7 ) ? ( (front_back_indicator_text.text !="" /*UIListener.GetVariantRearUSB()*/== true )? 28 : 46 ) : 46 //modified by jyjeon 2014.01.15 for ITS 219728
        y: PR.const_APP_PANDORA_TRACK_VIEW_PANDORALOGO_Y_OFFSET
        z: 1
    }
    DHAVN_PandoraSharedTrack { //added by wonseok.heo 2015.04.27 for DH PE new spec
        id:icon_Share
    }



    DHAVN_PandoraTrackViewIcon {
        id:icon_AuidoAD
        iconText: qsTranslate("main","STR_PANDORA_AUDIO_AD")  //"Audio AD"
    }

    Item {
        id:icon_Error
        visible: isInsufficientTV
        property bool isNoNetwork:false
        property bool isNoLicense:false

        DHAVN_PandoraTrackViewIcon {
            id:noNetwork
            iconText: qsTranslate("main","STR_PANDORA_TRACK_VIEW_NO_NETWORK_TEXT")
            visible: icon_Error.isNoNetwork
            x: (icon_Error.isNoLicense)? 840 : 1054
        }

        DHAVN_PandoraTrackViewIcon {
            id:noLicense
            visible: icon_Error.isNoLicense
            iconText: qsTranslate("main","STR_PANDORA_TRACK_VIEW_NO_LICENSE_TEXT")
            x: 1054
        }

            onVisibleChanged:
            {
            var artistName;
            icon_AuidoAD.visible = false; 
                trackModeAreaWidget.isListDisabled= visible;

                if(visible)
                {
                icon_AuidoAD.visible = false; //added by jyjeon 2014-05-19 for No Network/No lisence/AD Icon
                    if(optMenu.visible)
                    {
                        optMenu.hide();
                        UIListener.SetOptionMenuVisibilty(false);
                    }
                    if(myToastPopup.visible)
                        myToastPopup.visible = false;

                    trackViewButtons.hideFocus();
                    trackViewButtons.state = "buttonsDisabled";
                    trackViewButtons.callingState(true)
                    trackModeAreaWidget.showFocus();
                    trackModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
                    if(pndrTrackView.state == "trackStateInfoWaiting")
                    {
                        prBar.nTotalTime = 0;
                        prBar.nCurrentTime = 0;
                        position = 0;
                        trackInfoModel.clear();
                        position = 0;
                        var statioArt = PR_RES.const_APP_PANDORA_TRACK_VIEW_ICON_STATION_IMG ;
                        var stationName = pndrStationList.CurrentStationName();
                        if(stationName.length > 0 ){
                            if(stationName.toLowerCase() === "shuffle"){
                                statioArt = PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_QUICKMIX
                            }else{
                                var stArt = pndrTrack.IsStationArtPresent()
                                 if(stArt.length > 0 ){
                                     statioArt = stArt
                                 }
                            }
                        }
                        else{
                             stationName= qsTranslate("main","STR_PANDORA_TRACK_VIEW_NO_NETWORK_TEXT");
                        }
                        trackInfoModel.append({title: "",station: stationName,
                                               artist:"",album: "",
                                               currentstationart:statioArt })
                        albumArt = PR_RES.const_APP_PANDORA_TRACK_VIEW_NO_ALBUM_ART_IMG;
                        waitIndicator.visible = false;
                        listView.visible = true;
                    }
                    else
                    {
                        position = 0;
                        trackInfoModel.clear();
                        position = 0;
                        var statioArt = PR_RES.const_APP_PANDORA_TRACK_VIEW_ICON_STATION_IMG ;
                        var stationName = pndrStationList.CurrentStationName();
                    if(isNoLicense && !isNoNetwork)
                        artistName = qsTranslate("main","STR_PANDORA_TRACK_VIEW_NO_LICENSE_TEXT");
                    else
                        artistName = qsTranslate("main","STR_PANDORA_TRACK_VIEW_NO_NETWORK_TEXT");
                    
                        var titleName = qsTranslate("main","STR_PANDORA_WAITING_FOR_RECOVERY");
                        
                        if(stationName.length > 0 ){
                            if(stationName.toLowerCase() === "shuffle"){
                                statioArt = PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_QUICKMIX
                            }else{
                                var stArt = pndrTrack.IsStationArtPresent()
                                 if(stArt.length > 0 ){
                                     statioArt = stArt
                                 }
                            }
                        }
                        trackInfoModel.append({title: titleName,station: stationName,
                                               artist: artistName,album: "",
                                               currentstationart:statioArt })
                        albumArt = PR_RES.const_APP_PANDORA_TRACK_VIEW_NO_ALBUM_ART_IMG;
                        waitIndicator.visible = false;
                        listView.visible = true;
                    }
                pndrTrackView.scrollingTicker = false; 
                visibleNoNetworkOptions(false); 
                }
                else // added by esjang 2013.12.17 for ITS # 215639 
                {
                isNoNetwork = false;
                isNoLicense = false; 
                    trackViewButtons.state = "buttonsEnabled";
                    trackViewButtons.callingState(false)
                    trackViewButtons.showFocus();
                    trackModeAreaWidget.hideFocus();
                    if(noNetworkStationName != "")
                    {
                        trackInfoModel.set(0, {currentstationart : noNetworkCurrentstationart, station : noNetworkStationName,
                                                title : noNetworkTitleName, artist : noNetworkArtistName, album : noNetworkAlbumName});
                    }
                pndrTrackView.scrollingTicker = UIListener.scrollingTicker;
                    visibleNoNetworkOptions(true);
                }
            }
        }

    ListModel{
        id: trackInfoModel
    }

    OptionMenu{
        id: optMenu
        menumodel: pandoraMenus.optTrackMenuModel
        signal lostFocus( int arrow, int focusID );
        z: 1000
        y: 0 
        visible: false;
        autoHiding: true
        autoHideInterval: 10000
        scrollingTicker: pndrTrackView.scrollingTicker
        
        onBeep: UIListener.ManualBeep(); 

        onIsHidden:
        {
            optMenu.visible = false ;
            if(isInsufficientTV) // modified by cheolhwan 2014-01-16. UX update. (with Ver2.25_131213_E_No Network). Add condition "!isInsufficient".
            {
                trackModeAreaWidget.showFocus();
            }
            else
            {
                trackModeAreaWidget.hideFocus();
                if(!trackViewButtons.focusVisible && popup.visible == false) //modified by wonseok.heo for ITS 233582
                {
                    trackViewButtons.showFocus();
                }
            }
        }

        onTextItemSelect:
        {
            __LOG(  "onTextItemSelect: "  +  itemId , LogSysID.LOW_LOG  );
            optMenu.disableMenu();
            handleMenuItemEvent(itemId);
        }

        function showMenu()
        {
            optMenu.visible = true
            optMenu.show()
        } 
    }

    ListView {
        id: listView
        y: PR.const_PANDORA_MODE_ITEM_HEIGHT
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
            PropertyChanges { target:trackViewButtons; isRateVisible:false}
         },

        State
        {
            name: "trackStatePlaying"
            PropertyChanges { target:trackViewButtons; visible: true}
            PropertyChanges { target:trackViewButtons; state: "buttonsEnabled"}
            PropertyChanges { target:trackViewButtons; isRateVisible:true}
        },

        State
        {
            name: "trackStatePaused"
            PropertyChanges { target:trackViewButtons; visible: true}
            PropertyChanges { target:trackViewButtons; state: "buttonsEnabled"}
            PropertyChanges { target:trackViewButtons; isRateVisible:true}
        }
    ]

    Connections{
        target: pndrTrackView
        onStateChanged:
        {
            __LOG("onStatesChanged :: state=" + pndrTrackView.state , LogSysID.LOW_LOG );
            trackViewButtons.setTrackCurrentState(pndrTrackView.state);
        }
    }
    
    function getWaitIndicatorStatus()
    {
        return (waitIndicator.visible || waitpopup.visible);
    }

    /***************************************************************************/
    /**************************** Private functions START **********************/
    /***************************************************************************/

    function __LOG( textLog , level)
    {
       logString = "TrackView.qml::" + textLog ;
       logUtil.log(logString , level);
    }

    // handles foreground event
    function handleForegroundEvent ()
    {
        __LOG("handleForegroundEvent" , LogSysID.LOW_LOG );

       pndrTrackView.visible = visibleStatus;
       waitIndicator.visible = pndrTrackView.visible;
       listView.visible = false;
       if(waitIndicator.visible === true)
       {
           trackViewButtons.state = "buttonsDisabled";
           trackViewButtons.setButtonState(true); //Dimmed
       }
       pndrTrackView.state = "trackStateInfoWaiting"
       pndrTrack.RequestTrackInfo();
    }

    
    function showTrackWait()
    {

        __LOG("showTrackWait" , LogSysID.LOW_LOG );
        pndrTrackView.visible = true;
        waitIndicator.visible = true;
        trackViewButtons.state = "buttonsDisabled";
        trackViewButtons.setButtonState(true); //Dimmed
        listView.visible = false;
        pndrTrackView.state = "trackStateInfoWaiting"

    }

    function requestForTrackInfo()
    {
         pndrTrack.RequestTrackInfo();
    }

    function handleMenuItemEvent(menuItemId)
    {
        __LOG("menuItemId clicked is : " + menuItemId , LogSysID.LOW_LOG );
        var hideMenu = true;
        switch(parseInt(menuItemId))
        {
            case MenuItems.StationList: // StationList
            {
                __LOG("pndrTrackView.handleListViewEvent() called" , LogSysID.LOW_LOG );
                pndrTrackView.handleListViewEvent();
                break;
            }
            case MenuItems.ThumbsUp: // I like it
            {
               // if(pndrTrack.IsNullTrackInof() )
               //    return;
                if(InTrackInfo.allowRating)
                {
                    pndrTrack.ThumbUp();
                }
                break;
            }
            case MenuItems.ThumbsDown: // I don't like it
            {
                if(InTrackInfo.allowRating)
                {
                    pndrTrack.ThumbDown();
                }
                break;
            }
            case MenuItems.BookmarkSong: // Bookmark Song
            {
                if(InTrackInfo.allowBookmark)
                {
                    pndrTrack.BookmarkSong();
                }
                break;
            }
            case MenuItems.BookmarkArtist: //Bookmark Artist
            {
                if(InTrackInfo.allowBookmark)
                {
                    pndrTrack.BookmarkArtist();
                }
                break;
            }
            case MenuItems.WhyThisSongIsPlaying: // Why this song is playing
            {
                //__LOG("TrackElapsedPolling disabled");
                //pndrTrack.SetTrackElapsedPolling(false);

                if(InTrackInfo.allowExplain)
                {
                    pndrTrackView.handleExplainViewEvent();
                }
                break;
            }
            case MenuItems.SoundSetting: //Sound Setting
            {
                UIListener.LaunchSoundSetting();
                break;
            }
            default:
            {
                __LOG("MyLog: No menu item matched" , LogSysID.LOW_LOG )
                break;
            }
        }
        if(hideMenu === true){
            optMenu.quickHide();
            if(!isInsufficientTV && popup.visible == false)  //modified by wonseok.heo for ITS 233582 // modified by cheolhwan 2014-01-16. UX update. (with Ver2.25_131213_E_No Network). Add condition "!isInsufficient".
            {
                trackModeAreaWidget.hideFocus();
                trackViewButtons.showFocus();
            }
        }
    }

    // handle retranlateUI event
    function handleRetranslateUI(languageId)
    {
        LocTrigger.retrigger()
        trackModeAreaWidget.retranslateUI(PR.const_PANDORA_LANGCONTEXT);
        icon_AuidoAD.iconText = qsTranslate("main","STR_PANDORA_AUDIO_AD")  //"Audio AD"  
        waitIndicator.handleRetranslateUI(languageId);// modified by yongkyun.lee 2014-12-11 for : ITS 254387        
    }
    function updateUIWithTrackInfo()
	{
        prBar.nTotalTime = 0;
        prBar.nCurrentTime = 0;
        position = 0;

        prBar.nTotalTime = InTrackInfo.duration;
        prBar.nCurrentTime = InTrackInfo.elapsed;

        trackViewButtons.allowRating = InTrackInfo.allowRating;
        trackViewButtons.allowSkip = InTrackInfo.allowSkip;
        trackViewButtons.allowBookMark = InTrackInfo.isTrackBookmarked; //added by wonseok.heo for Bookmark DH PE 2015.07.03

       // { modified by wonseok.heo for rated during AD
        if(InTrackInfo.isAD == true ){
            trackViewButtons.rated(3);
            trackViewButtons.chkBookmark(3);
        }else{

            if(trackViewButtons.allowRating === false ){
                trackViewButtons.rated(0);
            }else{
                trackViewButtons.rated(InTrackInfo.ratingStatus);
            }
            if(trackViewButtons.allowBookMark === false){
                trackViewButtons.chkBookmark(1); //added by wonseok.heo for Bookmark DH PE 2015.07.03
            }else{
                trackViewButtons.chkBookmark(2); //added by wonseok.heo for Bookmark DH PE 2015.07.03
            }
        }// } modified by wonseok.heo for rated during AD

        icon_AuidoAD.visible = (isInsufficientTV)? false : InTrackInfo.isAD 
        albumArt = PR_RES.const_APP_PANDORA_TRACK_VIEW_NO_ALBUM_ART_IMG;

        featureOfTrack = InTrackInfo.allowExplain;
        updateOptionsMenu();

        trackInfoModel.clear();


        if( UIListener.getStringWidth(InTrackInfo.station , PR.const_PANDORA_FONT_FAMILY_HDR ,
        PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT) > PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH)
            position = 1;
        else if( UIListener.getStringWidth(InTrackInfo.artist , PR.const_PANDORA_FONT_FAMILY_HDR ,
        PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT) > PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH)
            position = 2;
        else if( UIListener.getStringWidth(InTrackInfo.title , PR.const_PANDORA_FONT_FAMILY_HDR ,
        PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT) > PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH)
            position = 3;
        else if( UIListener.getStringWidth(InTrackInfo.album , PR.const_PANDORA_FONT_FAMILY_HDR ,
        PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT) > PR.const_PANDORA_TARCK_VIEW_TRACK_INFO_TEXT_WIDTH)
            position = 4;
        else
            position = 0;

        __LOG( " ScrollingTicker = " + pndrTrackView.scrollingTicker + " Current scrooling index = " + position , LogSysID.LOW_LOG  )

        var albumPath = PR_RES.const_APP_PANDORA_TRACK_VIEW_ICON_STATION_IMG ;
        if(InTrackInfo.stationArt.length > 0){

            albumPath = InTrackInfo.stationArt;
        }

        trackInfoModel.append({title: InTrackInfo.title,station:InTrackInfo.station,
                               artist:InTrackInfo.artist,album: InTrackInfo.album,
                               currentstationart: (InTrackInfo.station.toLowerCase() === "shuffle") ?
                               PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_QUICKMIX:
                               albumPath })

        currentActiveStation = InTrackInfo.station;
        currentActiveStationToken = InTrackInfo.stationToken;
        noNetworkStationName = InTrackInfo.station;
        noNetworkArtistName = InTrackInfo.artist;
        noNetworkTitleName = InTrackInfo.title;
        noNetworkAlbumName = InTrackInfo.album;
        noNetworkCurrentstationart = ((InTrackInfo.station.toLowerCase() === "shuffle") ?
                               PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_QUICKMIX:
                               albumPath);

        trackViewButtons.updateskipIcon(InTrackInfo.allowSkip);

        if(UIListener.IsCalling())
            trackViewButtons.setTrackCurrentState("trackStateInfoWaiting");
	}

    function visibleTrackOptions(status)
    {        
        featureOfTrack = status;
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsUp, status)
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsDown, status)
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.BookmarkSong, status)
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.BookmarkArtist, status)
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.WhyThisSongIsPlaying, status)
    }

    function updateOptionsMenu()
    {
        __LOG("updateOptionsMenu::allowRating= " + InTrackInfo.allowRating  +" , shared =" + InTrackInfo.sharedStation , LogSysID.LOW_LOG );
        if( InTrackInfo.allowRating == false || InTrackInfo.sharedStation != false )//modified by wonseok.heo 140915 { modified by yongkyun.lee 2014-08-20 for : ITS 245654
        {
            __LOG("disable option menu " , LogSysID.LOW_LOG );
            pandoraMenus.UpdateRatingDisableInOptionsMenu();            
        }
        trackViewButtons.setSharedStation(InTrackInfo.sharedStation); //add by wonseok.heo 2015.01.20 for 256640
        //{ modified by yongkyun.lee 2014-08-20 for : ITS 245654
        //pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsUp, InTrackInfo.allowRating && !InTrackInfo.sharedStation)
        //pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsDown, InTrackInfo.allowRating && !InTrackInfo.sharedStation)
        //} modified by yongkyun.lee 2014-08-20
        //pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.BookmarkSong, InTrackInfo.allowBookmark)
        //pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.BookmarkArtist, InTrackInfo.allowBookmark)
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.WhyThisSongIsPlaying, InTrackInfo.allowExplain)

    }

    function visibleNoNetworkOptions(status)
    {        
        __LOG("[OptionsMenu] visibleNoNetworkOptions() status = " + status , LogSysID.LOW_LOG );
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.StationList, status)
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsUp, status)
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsDown, status)
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.BookmarkSong, status)
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.BookmarkArtist, status)
        pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.WhyThisSongIsPlaying, status)
    }
    
    function hideOptionsMenu()
    {
        optMenu.hide()
    }

    function handleSkipEvent()
    {
        if(waitIndicator.visible == false &&  pndrTrackView.state != "trackStateInfoWaiting" && trackViewButtons.allowSkip) //modified by jyjeon 2014-03-13 for ISV 98611
        {
            __LOG("Calling pndrTrack Skip slot" , LogSysID.LOW_LOG )
            albumArtWaitIndicator.visible = false;
            showTrackWait();
            trackViewButtons.updateskipIcon(false);           
            pndrTrack.Skip();

            if(!clusterClearTimer.running)
                clusterClearTimer.start()
            UIListener.IfMute_SentAudioPass();
        }
    }

    function handleSkipFailedEvent()
    {
        __LOG ("Skip Failed" , LogSysID.LOW_LOG );
        waitIndicator.visible = false;
        listView.visible = true;
        trackViewButtons.state = "buttonsEnabled";
        trackViewButtons.setButtonState(false);
        if(trackViewButtons.allowSkip)
            trackViewButtons.setSkipIcon(false);
        if(pndrTrack.TrackStatus() === 1)
         {
            pndrTrackView.state = "trackStatePlaying";
         }
         else
         {
            pndrTrackView.state = "trackStatePaused";
         }
        trackViewButtons.updateskipIcon(trackViewButtons.allowSkip);
        UIListener.SetSeekStatus(false);

        // { modified by wonseok.heo for TP Cluster 2015.01.30
        if(!clusterTPTimer.running)
            clusterTPTimer.start()
        // } modified by wonseok.heo for TP Cluster 2015.01.30
        //pndrNotifier.UpdateTrackTitle(InTrackInfo.title); //modified by wonseok.heo for TP Cluster 2015.01.29

    }

    function handleRateFailedEvent()
    {
        __LOG("Calling pndrTrack rate slot" , LogSysID.LOW_LOG );
    }    

     function handleMenukey(/*isJogMenuKey*/)
     {
        if(UIListener.IsCalling())
        {
            popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE , false);
            return;
        }
        if( pndrTrackView !== null && pndrTrackView.visible )
        {
            if(!waitIndicator.visible && !waitpopup.visible)
            {                
                __LOG("Toggling the menu" , LogSysID.LOW_LOG );
                if(popupVisible)
                {
                    popup.hidePopup();
                    popup.visible = false;
                }

                closeToastPopup();
                if(optMenu.visible)
                {
                    optMenu.hide();
                    UIListener.SetOptionMenuVisibilty(false);
                }
                else
                {
                    trackViewButtons.hideFocus();
                    trackModeAreaWidget.hideFocus();
                    optMenu.showMenu();
                    optMenu.showFocus();
                    optMenu.setDefaultFocus(UIListenerEnum.JOG_DOWN); // focus at 0th index
                    UIListener.SetOptionMenuVisibilty(true);
                    if(isTuneOn)
                    {
                       UIListener.onTuneSelectTimer();
                    }
                }
            }
        }
    }

    function isJogListenState()
    {
        var ret = true;

        if(waitIndicator.visible || optMenu.visible || waitpopup.visible ||
                myToastPopup.visible || trackModeAreaWidget.focus_visible || isInsufficientTV)
        {
            ret = false;
        }
        return ret;
    }

    function handleJogKey(arrow , status)
    {
        __LOG("handlejogkey -> arrow : " + arrow + " , status : "+status , LogSysID.LOW_LOG );

        switch(arrow)
        {
            case UIListenerEnum.JOG_LEFT:
            case UIListenerEnum.JOG_RIGHT:            
            case UIListenerEnum.JOG_CENTER:
                if(trackViewButtons.focusVisible){
                    __LOG("IsCalling() [" + UIListener.IsCalling() + "] isTuneOn[" + isTuneOn + "]" , LogSysID.LOW_LOG );

                    if(UIListener.IsCalling()){
                        // modified by jyjeon 2014.01.06 for ITS 217984
                        //pndrNotifier.UpdateOSDOnCallingState();
                        popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE , false);
                        return;
                    }

                    if(isTuneOn === true)
                    {
                        if(arrow === UIListenerEnum.JOG_CENTER &&  status == UIListenerEnum.KEY_STATUS_RELEASED){
                            // select station
                            pndrTrack.ClearTrackInfo()
                            pndrStationList.TuneSelect();
                            isTuneOn = false;
                            UIListener.TuneSelectTimer(false);
                            trackViewButtons.jog_press = false; // added by cheolhwan 2014-01-14. ITS 218715.
                            trackViewButtons.setTuneState(isTuneOn)
                            UIListener.IfMute_SentAudioPass();
                        }
                        else if(arrow === UIListenerEnum.JOG_CENTER &&  status == UIListenerEnum.KEY_STATUS_PRESSED)
                        {
                            trackViewButtons.jog_press = true; 
                        }
                    }
                    else
                    {
                        if(arrow === UIListenerEnum.JOG_CENTER &&  status == UIListenerEnum.KEY_STATUS_RELEASED)
                        {
                            trackViewButtons.jog_press = false; 
                        }
                        trackViewButtons.handleJogKey(arrow , status);
                    }
                }
                break;
            case UIListenerEnum.JOG_UP: // It should not come here
                if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                    __LOG("explainModeAreaWidget.count : " + trackModeAreaWidget.modeAreaModel.count , LogSysID.LOW_LOG );
                    trackViewButtons.hideFocus();
                    trackModeAreaWidget.showFocus();
                    trackModeAreaWidget.setDefaultFocus(arrow);
                }
                break;

            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
                if(UIListener.IsCalling()){
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE , false);
                    return;
                }

                if(status == UIListenerEnum.KEY_STATUS_RELEASED ) // added by esjang 2013.08.21 for BT phone call
                {
                    if ( trackViewButtons.focusVisible === true && trackInfoModel.count > 0){
                        isTuneOn = true;
                        UIListener.TuneSelectTimer(true); // Start timer
                        pndrStationList.GetStationName(true); // forward
                        trackViewButtons.setTuneState(isTuneOn)
                    }
                }
            }
            break;
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                if(UIListener.IsCalling()){
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE , false);
                    return;
                }

                if(status == UIListenerEnum.KEY_STATUS_RELEASED ) // modified by esjang 2013.08.21 for BT phone call
                {
                    if ( trackViewButtons.focusVisible === true && trackInfoModel.count > 0)
                    {
                        isTuneOn = true;
                        UIListener.TuneSelectTimer(true) //Start timer
                        pndrStationList.GetStationName(false); //Reverse
                        trackViewButtons.setTuneState(isTuneOn);
                    }
                }
            }
            break;
        }
    }


    function manageFocusOnPopUp(status)
    {
        __LOG(" manageFocusOnPopUp(status) -> " + status , LogSysID.HIGH_LOG );

        if(status)
        {
            optMenu.quickHide();
            trackModeAreaWidget.hideFocus();
            trackViewButtons.hideFocus();
        }
        else
        {
            if(isInsufficientTV /*|| UIListener.IsCalling()*/) // modified by jyjeon 2014-02-13 for ITS 224934
                trackModeAreaWidget.showFocus(); //no Network
            else if(UIListener.IsCalling())
            {
                __LOG("manageFocusOnPopUp -> UIListener.IsCalling()" , LogSysID.LOW_LOG );
                trackModeAreaWidget.is_lockoutMode= true;
                trackModeAreaWidget.isListDisabled= true;

                trackViewButtons.hideFocus();
                trackViewButtons.state = "buttonsDisabled";
                trackViewButtons.callingState(true)
                trackModeAreaWidget.showFocus();
                trackModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
            }
            else
                trackViewButtons.showFocus();
        }
    }

    function startAnimation()
    {
        if(position == 1){stationName.restart()}
        else if(position == 2){artistName.restart()}
        else if(position == 3){titleName.restart()}
        else if(position == 4){albumName.restart()}
        else{}

    }

    function stopAnimation()
    {
        if(position == 1){stationName.stop()}
        else if(position == 2){artistName.stop()}
        else if(position == 3){titleName.stop()}
        else if(position == 4){albumName.stop()}
        else{}
    }

    function setTextChange(errIdx)
    {
        switch(errIdx)
        {
            case 31: // License restriction
                icon_Error.isNoLicense = true; //modifed by jyjeon 2014-05-19 for No Network/No lisence/AD Icon
                break;
            default:// Insufficient network
                icon_Error.isNoNetwork = true; //modifed by jyjeon 2014-05-19 for No Network/No lisence/AD Icon
                break;
        }
    }

    /***************************************************************************/
    /**************************** Private functions END **********************/
    /***************************************************************************/

    /***************************************************************************/
    /**************************** Pandora Qt connections START ****************/
    /***************************************************************************/
    Connections
    {
        target: !popupVisible? UIListener:null
        onMenuKeyPressed:
        {
            handleMenukey(/*isJogMenuKey*/);
        }

        onSkipKeyEvent:
        {
            __LOG("[TrackButton] onSkipKeyEvent: trackViewButtons.allowSkip["+trackViewButtons.allowSkip+"]  getWaitIndicatorStatus()"+getWaitIndicatorStatus()+"]", LogSysID.LOW_LOG);
            if(trackViewButtons.allowSkip && getWaitIndicatorStatus() == false  && !UIListener.IsCalling()){
                if(optMenu.visible)
                {
                    optMenu.hideFocus(); //added by esjang 2013.08.10 for sanity 
                    optMenu.quickHide(); //added by esjang 2013.08.10 for sanity 
                    optMenu.visible = false ;
                    trackModeAreaWidget.hideFocus();
                    if(!trackViewButtons.focusVisible)
                    {
                        trackViewButtons.showFocus();
                    }
                }
                trackViewButtons.setSkipIcon(inStatus);
            }
        }
    }

    Connections
    {
        target:  ( !waitpopup.visible && pndrTrackView.state != "trackStateInfoWaiting") ? UIListener:null

        onTuneKeyDialed: //isForward
        {
            if(optMenu.visible)
            {
                optMenu.hideFocus(); //added by esjang 2013.08.10 for sanity 
                optMenu.quickHide(); //added by esjang 2013.08.10 for sanity 
                optMenu.visible = false ;
                trackModeAreaWidget.hideFocus();
                if(!trackViewButtons.focusVisible)
                {
                    trackViewButtons.showFocus();
                }
            }

            isTuneOn = true;
            pndrStationList.GetStationName(isForward);
            trackViewButtons.setTuneState(isTuneOn)
        }

        onTuneCenterPressed:
        {
            if(isTuneOn) 
            {
                // { added by wonseok.heo ITS 249363
                if(UIListener.IsSystemPopupVisible())
            {
                     UIListener.CloseSystemPopup();
                }// } added by wonseok.heo ITS 249363

                if(popupVisible)
                {
                    popup.hidePopup();
                    popup.visible = false;
                }
                trackViewButtons.jog_press = true;
            }
        }
        
        onTuneCenterReleased:
        {
            __LOG("[TrackButton] onTuneCenterReleased: isTuneOn[" + isTuneOn + "]" , LogSysID.LOW_LOG );
            trackViewButtons.jog_press = false; // added by cheolhwan 2014-01-14. ITS 218715.
            if(isTuneOn)
            {   
                UIListener.TuneSelectTimer(false);
                pndrNotifier.ClearCluster();
                pndrTrack.ClearTrackInfo()
                pndrStationList.TuneSelect();
                pndrStationList.ClearCurrentRequest();
                currentActiveStationToken = -1;
                isTuneOn = false;
                trackViewButtons.setTuneState(isTuneOn)
                UIListener.IfMute_SentAudioPass();
            }
            else
            {
                trackViewButtons.setTuneState(isTuneOn)
            }
        }
        
        onTuneOff:
        {
            __LOG(" onTuneOff: updateTrackInfoOnTuneoff["+updateTrackInfoOnTuneoff+"]", LogSysID.LOW_LOG);
            isTuneOn = false;
            if( updateTrackInfoOnTuneoff || 
               !(UIListener.getModeStateHistoryCurr() == 21 || 
                 UIListener.getModeStateHistoryCurr() == 12 || 
                 UIListener.getModeStateHistoryCurr() == 15 ) )
            {
                updateTrackInfoOnTuneoff = false;
                pndrTrack.RequestTrackInfo();
            }
            trackViewButtons.jog_press = false; // added by cheolhwan 2014-01-14. ITS 218715.
            trackViewButtons.setTuneState(isTuneOn)
        }
    }

    Connections
    {
        target: pndrTrackView.visible ? pndrStationList : null

        onTunedStation:  // (const quint32 token , const QString inStationName);
        {
            __LOG("onTunedStation token : " + token + " , name : "+inStationName + " , isCurr : " + isCurr , LogSysID.LOW_LOG );

            if( isCurr /*token === currentActiveStationToken*/ )
            {
               isTuneOn = false;
            }
            else
            {
               isTuneOn = true;
            }
            trackViewButtons.setTuneState(isTuneOn)


            if(token > 0 && inStationName.length > 0)
            {
                var stationArt = pndrStationList.StationArtPresent(token);

                if(stationArt.length === 0){
                    stationArt = PR_RES.const_APP_PANDORA_TRACK_VIEW_ICON_STATION_IMG;
                }

                (inStationName.toLowerCase() === "shuffle" || inStationName.toLowerCase() === "quickmix")?
                    trackInfoModel.set(0, {currentstationart : PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_QUICKMIX, station : inStationName})
                                                             : trackInfoModel.set(0,{currentstationart : stationArt ,
                                                                              station : inStationName})
            }
        }
        onNoStationPresent:
        {
            isTuneOn = false;
            UIListener.TuneSelectTimer(false); // Stop timer
            if(updateTrackInfoOnTuneoff)
            {
                updateTrackInfoOnTuneoff = false;
                pndrTrack.RequestTrackInfo();
            }
            trackViewButtons.setTuneState(isTuneOn)
        }
    }

    Connections
    {
        target: pndrTrack
        onPlayStarted:
        {
            pndrTrackView.state = "trackStatePlaying";
            if( isInsufficientTV || isInsufficient)
                isInsufficient = false;
            pndrTrack.CheckTrackInfo();// modified by yongkyun.lee 2014-08-21 for :  ITS 244978
        }

        onPauseDone:
        {
            //if(!UIListener.IsCalling()) //removed by wonseok.heo 2014-03-28 for ITS 231733
            {
                pndrTrackView.state = "trackStatePaused";
            }
            //trackViewButtons.setSharedStation(InTrackInfo.sharedStation); // add by wonseok.heo 2015.01.20 for 256640
            
            if( isInsufficientTV || isInsufficient )
                isInsufficient = false;

            pndrTrack.CheckTrackInfo();// modified by yongkyun.lee 2014-08-21 for :  ITS 244978	
        }

        onSkipFailed:
        {
            __LOG ("Skip Failed" , LogSysID.LOW_LOG );
        }

        onTrackUpdated:
        {
            __LOG("onTrackUpdated Token = " + inTrackToken + " TuneOn = " + isTuneOn , LogSysID.LOW_LOG  );

            if(isInsufficientTV)
            {
                __LOG("onTrackUpdated isInsufficientTV = " + isInsufficientTV , LogSysID.HIGH_LOG  );
                return;
            }

            if(isTuneOn === true)
            {
                visibleTrackOptions(false);

                if(trackInfoModel.count > 0){
                    trackInfoModel.set(0 , {title: "",artist: "",album: "" })
                }
                albumArt= "";

                if(inTrackToken > 0)
                {
                    pndrTrack.RequestTrackInfo();
                }
            }
            else
            {
                if(pndrTrackView !== undefined )
                {
                    if(trackInfoModel.count > 0)
                        trackInfoModel.remove(0);
                    albumArt= "";
                    // Display Loading View when track changes
                    albumArtWaitIndicator.visible = false;
                    listView.visible = false;

                    if(inTrackToken > 0)
                    {
                        if(pndrTrackView.state != "trackStateInfoWaiting")
                        {
                            pndrTrackView.state = "trackStateInfoWaiting"
                        }
                        pndrTrack.RequestTrackInfo();
                    }
                    else
                    {
                        //Its Track none
                        listView.visible = true;
                        updateUIWithTrackInfo();

                        waitIndicator.visible = false;
                        //myToastPopup.show(QT_TR_NOOP("STR_PANDORA_LOADING") , false)//modified by yongkyun.lee 2014-09-01 for : Pandora 4.25 TEST
                    }
                    visibleTrackOptions(false)
                }
            }

              //trackViewButtons.updateskipIcon(false); //modified by yongkyun.lee 2014-09-01 for : Pandora 4.25 TEST
        }
    onTrackShardReceived: //added by wonseok.heo 2015.04.27 for DH PE new spec
    {
        if(UIListener.IsVehicleType() == 2){ //added by wonseok.heo for integration DH PE
            icon_Share.visible = InTrackInfo.sharedStation;

        }else{
            icon_Share.visible = false;
        }
    }

        onTrackInfoReceived:
        {

            __LOG("onTrackInfoReceived:  TuneOn[" + isTuneOn + "]  isInsufficientTV[" + isInsufficientTV + "]" , LogSysID.LOW_LOG );
            if( myToastPopup.visible || isInsufficientTV)
            {
                myToastPopup.visible = false;
                trackViewButtons.state = "buttonsEnabled";
                trackViewButtons.callingState(false)
            }
            
            visibleTrackOptions(true);
            
            if(isTuneOn === true)
            {
                updateTrackInfoOnTuneoff = true;
            }
            else //{ modified by yongkyun.lee 2014-11-27 for : BG->next->tune->home -> loding......
            {
                listView.visible = true;
                trackViewButtons.state = "buttonsEnabled";
                trackViewButtons.setButtonState(false);  
                
                updateUIWithTrackInfo();

                // Stop showing wait screen.
                waitIndicator.visible = false;

                pndrTrack.SetTrackElapsedPolling(true);
                pndrTrackView.state = initialStateofTrackView;
                albumArtWaitIndicator.visible = true;
            }

            trackViewButtons.setSharedStation(InTrackInfo.sharedStation); // added by wonseok.heo for Crash 2015.01.30
            //if(pndrTrack.IsNullTrackInof() )
            //   return;
            trackViewButtons.updateskipIcon(InTrackInfo.allowSkip); // disable/enable skip icon on track updated
        }

        onSongBookmarked:
        {
        //added by wonseok.heo for Bookmark DH PE 2015.07.03
        trackViewButtons.chkBookmark(2);

             myToastPopup.show(QT_TR_NOOP("STR_PANDORA_BOOKMARK_SONG_POPUP_TEXT") , true)
        }

        onArtistBookmarked:
        {
            myToastPopup.show(QT_TR_NOOP("STR_PANDORA_BOOKMARK_ARTIST_POPUP_TEXT") , true)
        }

        //With C++ signal We need whether its thumbs up or down inUserRating
        onRated:
        {
            __LOG ("onRatingCompletionRecieved " + inUserRating , LogSysID.LOW_LOG );
            trackViewButtons.rated(inUserRating);
        }

        onTrackElapsedTime:
        {
            if(inElapsedTime >= 0 && inElapsedTime <= prBar.nTotalTime)
            {
                prBar.nCurrentTime = inElapsedTime; // added by esjang 2013.04.24 for Cluster & UI Time Sync
            }
        }
        onAlbumArtReceived:
        {
            __LOG("Album art received :"+ filePath , LogSysID.LOW_LOG  );
            albumArtWaitIndicator.visible =  false;
            if(filePath.length > 0)
            {
                albumArt = filePath;
            }
        }    
    }

    Connections
    {
        target: pandoraMenus
        onMenuDataChanged:
        {
            optMenu.menumodel = pandoraMenus.optTrackMenuModel
        }
    }


    Connections
    {
        target:visible ? pndrStationList : null

        onCurrStArt:
        {
             if(pndrTrack.IsNullTrackInof() )
                return;
            if(InTrackInfo.station.length > 0)//{ modified by yongkyun.lee 2014-03-17
            {
                (InTrackInfo.station.toLowerCase() === "shuffle")?
                trackInfoModel.set(0, {currentstationart : PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_QUICKMIX}) :
                trackInfoModel.set(0,{currentstationart : inStationArtPath})//modified by esjang 2013.06.10 for ITS #165774
            }
        }
    }


    /***************************************************************************/
    /**************************** Pandora Qt connections END ****************/
    /***************************************************************************/

    DHAVN_PandoraWaitView{
        id: waitIndicator
        visible: false
        onVisibleChanged: {
            if(!visible)
            {
                if(!waitpopup.prefetching)
                    waitpopup.visible = visible;
                counter = 0;
            }
            //{ modified by yongkyun.lee 2014-03-14 for : ISV 99008
            if(isTuneOn && visible == true )
            {
                UIListener.onTuneSelectTimer();
            }
            //} modified by yongkyun.lee 2014-03-14 
       }
    }
    DHAVN_PandoraAlbumArtWaitView{
        id: albumArtWaitIndicator
        visible: false
    }

    DHAVN_PandoraTrackViewButtons
    {
        id: trackViewButtons
        parent: pndrTrackView
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: PR.const_APP_PANDORA_TRACK_VIEW_BUTTONS_TOP_MARGIN_OFFSET
        allowTouchEvent: !myToastPopup.visible
    }

    Loader { id: pndrRadio; }
    // MODE AREA
    QmlModeAreaWidget
    {
        id: trackModeAreaWidget
        bAutoBeep: false
        modeAreaModel: trackModeAreaModel
        search_visible: false
        //parent: pndrTrackView
        anchors.top: parent.top
        onBeep: UIListener.ManualBeep(); // added by esjang for ITS # 217173  //deleted by cheolhwan 2014-01-15. ITS 218630.        

        onModeArea_BackBtn:
        {
            __LOG ("QmlModeAreaWidget: onModeArea_BackBtn" , LogSysID.LOW_LOG );
            pndrTrackView.handleBackRequest(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
        }

        onModeArea_MenuBtn:
        {
            handleMenukey();
        }

        onModeArea_RightBtn:
        {
            if(UIListener.IsCalling())
            {  
                popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE , false);
                return;
            }

            if( pndrTrackView !== null && pndrTrackView.visible ) // modified by esjang 2013.08.21 for BT phone call
            {
                if(!waitIndicator.visible)
                {
                    __LOG("Toggling the menu" , LogSysID.LOW_LOG );
                    optMenu.quickHide();
                    UIListener.SetOptionMenuVisibilty( optMenu.visible);
                    pndrTrackView.handleListViewEvent();
                }
            }
        }

        onLostFocus:
        {
            switch(arrow)
            {
                case UIListenerEnum.JOG_DOWN:
                {
                    __LOG ("QmlModeAreaWidget: onLostFocus " , LogSysID.LOW_LOG );
                    if(UIListener.IsCalling()){

                        popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE , false);
                        return;
                    } 
                    
                    if( ! UIListener.IsCalling() && !myToastPopup.visible ) // modified by esjang 2013.08.21 for BT phone call
                    {
                        if(isInsufficientTV){
                            trackModeAreaWidget.showFocus();
                            trackModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
                        }
                        else{
                            trackModeAreaWidget.hideFocus();
                            trackViewButtons.showFocus();
                        }
                    }                   
                    break;
                }
            }
        }

        ListModel
        {
            id: trackModeAreaModel
            property bool search_visible: false
            property string image: PR_RES.const_APP_PANDORA_WAIT_VIEW_LOGO_PANDORA_IMG
            property string mb_text: QT_TR_NOOP("STR_PANDORA_MENU");
            property bool mb_visible: true;           
            property string rb_text: QT_TR_NOOP("STR_PANDORA_LIST");// modified by esjang 2013.07.06 for ITS#178684
            property bool rb_visible: true;
        }
    }

    /***************************************************************************/
    /**************************** Pandora QML connections START ****************/
    /***************************************************************************/

    Component.onCompleted: {
        activeView = pndrTrackView;
        //handleForegroundEvent();

        // added by jyjeon 2014.01.06 for ITS 217984
        if(UIListener.IsCalling())
        {
            trackModeAreaWidget.is_lockoutMode= true;
            trackModeAreaWidget.isListDisabled= true;

            trackViewButtons.hideFocus();
            trackViewButtons.state = "buttonsDisabled";
            trackViewButtons.callingState(true)
            trackModeAreaWidget.showFocus();
            trackModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
        }
        // added by jyjeon 2014.01.06 for ITS 217984
    }
    onVisibleChanged:
    {
        // added by jyjeon 2014.01.10 for ITS 217984
        if(visible && UIListener.IsCalling() && trackViewButtons.state == "buttonsEnabled")
        {
            trackModeAreaWidget.is_lockoutMode= true;
            trackModeAreaWidget.isListDisabled= true;

            trackViewButtons.hideFocus();
            trackViewButtons.state = "buttonsDisabled";
            trackViewButtons.callingState(true)
            trackModeAreaWidget.showFocus();
            trackModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
        }
        // added by jyjeon 2014.01.10 for ITS 217984

        if(pndrTrackView.visible === false && !UIListener.IsCalling()){

            if(EngineListener.isFrontLCD())
            {
                optMenu.quickHide();
            }
            trackModeAreaWidget.hideFocus();
            trackViewButtons.showFocus();
        }
        else
        {
            front_back_indicator_text.text = UIListener.getConnectTypeName();
        }

        if(pndrTrackView.visible == true && waitpopup.visible == true)
        {
            if( !pndrStationList.IsPreFetchingStations() &&  waitpopup.prefetching){
                 waitpopup.prefetching = false;
                 waitpopup.visible = false;
            }
        }
    }
    Connections
    {
        target:UIListener

        onTickerChanged:
        {

            __LOG("onTickerChanged : " + inScrollingTicker , LogSysID.LOW_LOG );
            pndrTrackView.scrollingTicker = inScrollingTicker;

            if(trackInfoModel.count > 0){
                if(position == 1 )
                    trackInfoModel.set(0 , {ticker1: inScrollingTicker })
                else if(position == 2 )
                    trackInfoModel.set(0 , {ticker2: inScrollingTicker })
                else if(position == 3 )
                    trackInfoModel.set(0 , {ticker3: inScrollingTicker })
                else if(position == 4 )
                    trackInfoModel.set(0 , {ticker4: inScrollingTicker })
                else{}
            }
        }
        
        onCallingState: //{ modified by esjang 2013.08.21 for BT phone call
        {
            trackModeAreaWidget.is_lockoutMode= incallingState;
            trackModeAreaWidget.isListDisabled= incallingState;
            if(optMenu.visible &&  incallingState == true )
            {
                __LOG ("optMenu.quickHide " , LogSysID.LOW_LOG );
                optMenu.quickHide();    
            }

            if(incallingState)
            {
                trackViewButtons.hideFocus();
                trackViewButtons.callingState(true) //modified by wonseok.heo for ITS 229730 2014.03.18
                trackViewButtons.state = "buttonsDisabled";

                if(popup.visible )
                    return
                trackModeAreaWidget.showFocus();
                trackModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
            }
            else
            {
                trackViewButtons.callingState(false) //modified by wonseok.heo for ITS 229730 2014.03.18
                trackViewButtons.state = "buttonsEnabled";
                trackViewButtons.skipIconChange(false)

            }
        }
    }

    Connections
    {
        target: pndrStationList //pndrTrackView.visible ? pndrStationList : null
        onPreFetchingStart:
        {
            waitpopup.showPopup(qsTranslate("main","STR_RECEIVING_STATIONS") + "\n" + 
                                qsTranslate("main","STR_PANDORA_CONNECTING_VIEW_TEXT2"));
            timeOutTimer.stop();
            waitpopup.prefetching = true;
        }

        onPreFetchingCompleted:
        {
            if( waitpopup.prefetching )
                waitpopup.visible = false;
            waitpopup.prefetching = false;

            if(trackInfoModel.count > 0 && trackInfoModel.get(0).station.length <= 0)
            {
                __LOG("Recovery logic to get station name " , LogSysID.LOW_LOG );
                 var stationArt = pndrStationList.StationArtPresent(token);
                if(stationArt.length === 0){
                    stationArt = PR_RES.const_APP_PANDORA_TRACK_VIEW_ICON_STATION_IMG;
                }
                var stationName = pndrStationList.CurrentStationName()

                (stationName.toLowerCase() === "shuffle")?
                trackInfoModel.set(0, {currentstationart : PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_QUICKMIX}) :
                trackInfoModel.set(0,{currentstationart : stationArt})

                trackInfoModel.set(0,{station : stationName})
            }

            pndrStationList.FetchStationArt()

            if(!reqBrandTimer.running)
                reqBrandTimer.start()
        }
    }


    //connection from buttom button
    Connections{
        target: trackViewButtons

        onStateChanged:
        {
           trackViewButtons.setTrackCurrentState(pndrTrackView.state);
        }
        
        onHandleListViewEvent:{
            //ToDo :: Commented for current release
            pndrTrackView.handleListViewEvent();
        }
        onHandleSkipEvent:{
            pndrTrackView.handleSkipEvent();
        }
        onHandleRewindEvent:{
            pndrTrackView.handleRewindEvent();
        }
        onHandleRatingEvent:
        {
           // popupLoading.visible = true;
            if(rating === 1)
            {
                pndrTrack.ThumbUp();
            }
            else if(rating === 2)
            {
                pndrTrack.ThumbDown();
            }
        }

        onHandleBookmark:{ //added by wonseok.heo 2015.04.27 for DH PE new spec

        if(bookmarkTimer.running){
            //bookmarkTimer.start();
        }else{
            bookmarkTimer.start();
            //pndrTrack.BookmarkSong();
        }

        }

        onHandleTouchEvent:{
            trackModeAreaWidget.hideFocus();

            if(!trackViewButtons.focusVisible)
            {
                trackViewButtons.showFocus();
            }
        }

        onTuneClicked:
        {
            pndrTrack.ClearTrackInfo()
            pndrStationList.TuneSelect();
            isTuneOn = false;
            UIListener.TuneSelectTimer(false);
            trackViewButtons.jog_press = false; // added by cheolhwan 2014-01-14. ITS 218715.
            trackViewButtons.setTuneState(isTuneOn)
            UIListener.IfMute_SentAudioPass();
        }
    }


    /***************************************************************************/
    /**************************** Pandora QML connections END ****************/
    /***************************************************************************/
    //MediaProgressBar
    DHAVN_PandoraProgressBar
    {
        id: prBar
        anchors.left:parent.left
        nCurrentTime : 0
        nTotalTime : 0
        anchors.top: trackViewButtons.bottom // modified by esjang for ITS #166568
//        anchors.topMargin: 12 // modified by esjang for ITS #166568
    }

    DHAVN_ToastPopup
    {
        id:myToastPopup
        visible:false;

        onVisibleChanged:
        {
            UIListener.SetLoadingPopupVisibilty(visible);
        }

        function show( text , value)
        {
            dismiss = value;
            sText = text;
            visible = true ;
            if(value)
                restartTimer();
            else
                stopTimer();
        }
    }


    POPUPWIDGET.PopUpText
    {
        id: waitpopup;
        z: 1000
        y: -PR.const_PANDORA_ALL_SCREENS_TOP_OFFSET // modified by cheolhwan 2013.12.26. ITS 217300. dimming a status bar during display the receiving popup.
        visible: false;
        icon_title: EPopUp.LOADING_ICON
        message: errorModel
        property bool prefetching: false

        onVisibleChanged:
        {
            UIListener.SetLoadingPopupVisibilty(visible);
        }

        
        function showPopup(text)
        {
            if(!visible)
            {
               if(UIListener.IsSystemPopupVisible())
               {
                    UIListener.CloseSystemPopup();
               }
                errorModel.set(0,{msg:text})
                visible = true;
                timeOutTimer.start();
            }
        }
    }
    Timer{
        id: timeOutTimer
        running: false
        repeat: false
        interval: 3000
        onTriggered:{
            if(!waitpopup.prefetching)
                waitpopup.visible = false;
        }
    }

    ListModel
    {
        id: errorModel
        ListElement
        {
            msg: ""
        }
    }

    Timer{
        id: reqBrandTimer
        running: false
        repeat: false
        interval: 10
        onTriggered:{
             __LOG("reqBrandTimer timeout  : " , LogSysID.LOW_LOG );
             pndrTrack.onBrandingImageStart()//{ modified by yongkyun.lee 2014-08-25 for : Branding Image
        }
    }

    Timer{
        id: clusterClearTimer
        running: false
        repeat: false
        interval: 60
        onTriggered:{
             __LOG("clusterClearTimer timeout  : " , LogSysID.LOW_LOG );
             pndrNotifier.ClearCluster(); 
        }
    }

    // { modified by wonseok.heo for TP Cluster 2015.01.30
    Timer{
        id: clusterTPTimer
        running: false
        repeat: false
        interval: 60
        onTriggered:{
            __LOG("clusterTPTimer timeout  " , LogSysID.LOW_LOG );
            pndrNotifier.UpdateTrackTitle(InTrackInfo.title);
        }

    } // } modified by wonseok.heo for TP Cluster 2015.01.30

    // added by wonseok.heo 2015.04.27 for DH PE new spec
    Timer{
        id: bookmarkTimer
        running: false
        repeat: false
        interval: 1000
        onTriggered:{
            __LOG("bookmarkTimer  " , LogSysID.LOW_LOG );
            pndrTrack.BookmarkSong();
        }

    } // added by wonseok.heo 2015.04.27 for DH PE new spec
    
 }


