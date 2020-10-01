import Qt 4.7
import QtQuick 1.1
import QmlPopUpPlugin 1.0
import AudioControllerEnums 1.0
import AppEngineQMLConstants 1.0
import ListViewEnums 1.0

import "DHAVN_AppMusicPlayer_General.js" as MPC
import "DHAVN_AppMusicPlayer_Resources.js" as RES

Item
{
    id: carousel
    //{added by junam 2013.12.09 for ITS_NA_212868
    property int scrollIndex : 0
    property bool scrollingTicker: EngineListenerMain.scrollingTicker;
    property string firstLineTitle: ""
    property string secondLineTitle: ""
    property bool bJogCenterPressed: false  // added by sangmin.seol 2014.07.21 for ITS 0242575
    //}added by junam
 
    function __LOG(textLog)
    {
        EngineListenerMain.qmlLog("[MP] DHAVN_AppMediaPlayer_CoverflowView.qml: " + textLog)
    }

    //{ added by junam 2013.05.17 for temporary disable selection.
    onVisibleChanged:
    {
        if(visible)
        {
            coverListView.positionViewAtIndex(coverListView.currentIndex,ListView.Visible)//added by suilyou 20131001 for ITS 0192194/0191309
            //selectionDisableTimer.start(); //removed by junam 2013.10.10
        }
       // modified by sangmin.seol 2014.07.21 for ITS 0242575 
        else
        {
            bJogCenterPressed = false
        //    selectionDisableTimer.stop(); //removed by junam 2013.10.10
        }
    }
    //}added by junam


    signal lostFocus(variant arrow)

    //{changed by junam 2013.12.09 for ITS_NA_212868
    //signal setJoggedCover(string c_album, string c_artist, bool c_color)
    function setJoggedCover(firstText, secondText)
    {        
        carousel.firstLineTitle =  firstText;
        carousel.secondLineTitle = secondText;
        carousel.scrollIndex = textFirst.scrollable ? 0 : (textSecond.scrollable ? 1 : -1)
    }
    //}changed by junam

    //{changed by junam 2013.12.05 for ITS_GE_212842
    function stopJogDial()
    {
        if(coverListView.currentAlbumIdx != coverListView.currentIndex)
        {
            coverListView.currentIndex = -1;
            coverListView.currentIndex = coverListView.currentAlbumIdx;
            prBar.bTuneTextColor = false;
        }
        centerCurrentAlbumTimer.stop();
    }
    //}changed by junam

// modified by Dmitry 15.05.13
    function changeSelection_onJogDial(arrow, status, repeat)//changed by junam 2013.11.13 for add repeat
    {
        __LOG("changeSelection_onJogDial: arrow = " + arrow + " status = " + status + " repeat = "+repeat);

        if (mediaPlayer.focus_index == LVEnums.FOCUS_NONE)
        {
            mediaPlayer.focus_index = LVEnums.FOCUS_CONTENT;
        }

        if (status == UIListenerEnum.KEY_STATUS_PRESSED) // modified by Dmitry 15.05.13
        {
            switch (arrow)
            {
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    centerCurrentAlbumTimer.restart();
                    //coverListView.incrementCurrentIndex();
                    coverListView.incrementIndex(repeat); //changed by junam 2013.11.13 for add repeat
                    break;
                }

                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    centerCurrentAlbumTimer.restart();
                    //coverListView.decrementCurrentIndex();
                    coverListView.decrementIndex(repeat); //changed by junam 2013.11.13 for add repeat 
                    break;
                }

                //modified by aettie Focus moves when pressed 20131015
                case UIListenerEnum.JOG_UP:
                case UIListenerEnum.JOG_DOWN:
                {
                    lostFocus(arrow);
                    break;
                }

                // added by sangmin.seol 2014.07.21 for ITS 0242575
                case UIListenerEnum.JOG_CENTER:
                {
                    bJogCenterPressed = true
                }

              //{removed by junam 2013.11.22
              //case UIListenerEnum.JOG_RIGHT:
              //{
              //  centerCurrentAlbumTimer.restart();
              //  coverListView.incrementIndex(1);
              //  break;
              //}

              //case UIListenerEnum.JOG_LEFT:
              //{
              //  centerCurrentAlbumTimer.restart();
              //  coverListView.decrementIndex(1);
              //  break;
              //}
              //}removed by junam
                default:
                   break;
            }
            EngineListener.DisplayOSD(true); //added by edo.lee 2013.02.23
        }
        else if (status == UIListenerEnum.KEY_STATUS_RELEASED)
        {
           switch (arrow)
           {
              case UIListenerEnum.JOG_CENTER:
              {
                  __LOG("JOG_CENTER : isTune mode "+prBar.bTuneTextColor);

                  // { changed by cychoi 2015.11.30 for ITS 268855 //changed by junam 2013.08.22 for ITS_KOR_185514
                  //if (EngineListener.selectTune())
                  //if ( prBar.bTuneTextColor && EngineListener.selectTune())//added by junam 2013.04.02 for  ISV_NA71816
                  //{
                  //    __LOG("Tune selection handled..")
                  //}
                  //{changed by junam 2013.11.22 for coverflow click
                  //else if (coverListView.currentAlbumIdx == coverListView.currentIndex)
                  //{
                  //  if(PathViewModel.isBusy())
                  //      __LOG("Path view is too busy...")
                  //  else
                  //      mediaPlayer.showPlayerView(true); //showPlayerView(true)
                  //}
                  //else
                  //{
                  //  AudioController.album = coverListView.model.getAlbumName(coverListView.currentIndex);
                  //  mediaPlayer.showPlayerView(true);
                  //}
                  // added by sangmin.seol 2014.07.21 for ITS 0242575
                  //else if(bJogCenterPressed == false)
                  if(bJogCenterPressed == false)
                  {
                      __LOG("JogCenter Released during not pressed")
                  }
                  else 
                  {
                      var fileTitle = PathViewModel.getFilePath(coverListView.currentIndex);
                      if(AudioController.IsFileSupported(fileTitle)) //added by junam 2013.11.28 for ITS_CHN_211039
                      {
                          //{changed by junam 2013.11.28 for ITS_NA_211655
                          screenTransitionDisableTimer.interval = 5000;
                          screenTransitionDisableTimer.restart();
                          //mediaPlayer.showPlayerView(true); 
                          //}changed by junam
                          AudioController.invokeMethod( AudioController, "coverflowItemClick", fileTitle);
                      }
                      else
                      {
                          popup_loader.showPopup(LVEnums.POPUP_TYPE_PLAY_UNAVAILABLE_FILE);  //added by junam 2013.11.28 for ITS_CHN_211039
                      }
                  }
                  // } changed by cychoi 2015.11.30 //}changed by junam

                  bJogCenterPressed = false;	 // added by sangmin.seol 2014.07.21 for ITS 0242575
                  break;
              }

//moved
              default:
                 break;
           }
           EngineListener.DisplayOSD(true);
        }
        else if (status == UIListenerEnum.KEY_STATUS_LONG_PRESSED &&
                 arrow  == UIListenerEnum.JOG_CENTER)
        {
            __LOG("JOG_CENTER: KEY_STATUS_LONG_PRESSED");
         //   AudioController.album = coverListView.model.getAlbumName(coverListView.currentIndex); // added by suilyou 20131025
        }
    }
// modified by Dmitry 15.05.13

    function currentPlayStateIcon()
    {
        if(mediaPlayer.bScan)
            return 2;

        if(EngineListener.IsPlaying())
            return 0;

        return 1;
    }


    ListView
    {
        id: coverListView

        property int currentAlbumIdx: -1;
        //property string currentAlbumName : "" //removed by junam 2013.12.09 for ITS_NA_212868
        property string currentCoverArt: AudioController.coverart //added by junam 2013.11.11 for ITS_NA_208040
        //property string currentArtistName:"" //removed by junam 2013.12.09 for ITS_NA_212868
       
        property int playState : carousel.currentPlayStateIcon()

        model: PathViewModel  //added by junam for 2012.12.06 flow view focus

        anchors.fill: parent
        delegate: proxyDelegate
        currentIndex: 0

        // added by ruindmby 2012.07.31 for CR#12573
        highlightMoveDuration: 1000
        // added by ruindmby 2012.07.31 for CR#12573
        orientation: ListView.Horizontal
        header: Rectangle { width: (carousel.width - MPC.const_COVER_FLOW_ITEM_SIZE) / 2; height: 1; color: "transparent"; }
        footer: Rectangle { width: (carousel.width - MPC.const_COVER_FLOW_ITEM_SIZE) / 2; height: 1; color: "transparent"; }

        preferredHighlightBegin: (carousel.width - MPC.const_COVER_FLOW_ITEM_SIZE) / 2
        preferredHighlightEnd: (carousel.width - MPC.const_COVER_FLOW_ITEM_SIZE) / 2
        highlightRangeMode:ListView.StrictlyEnforceRange

        maximumFlickVelocity: 6000//1500 // default 2500

        onCurrentIndexChanged:
        {
            //{changed by junam 2013.12.09 for ITS_NA_212868
            if(centerCurrentAlbumTimer.running)
            {
                centerCurrentAlbumTimer.restart();
                //setJoggedCover( model.getAlbumName(currentIndex),
                //           (currentAlbumIdx == currentIndex) ?  AudioController.song : model.getArtistName(currentIndex), //changed by junam 2013.11.27 for ITS_EU_209101
                //               currentAlbumIdx != currentIndex);
                setJoggedCover((currentAlbumIdx == currentIndex) ?  AudioController.song : model.getArtistName(currentIndex),
                                                                                         model.getAlbumName(currentIndex))
            }
            //}changed by junam
        }

        //{added by junam 2013.09.06 for ITS_KOR_188249
        onMovementEnded:
        {
            if(centerCurrentAlbumTimer.running)
                centerCurrentAlbumTimer.restart();
        }
        //}added by junam

// added by Dmitry 29.09.13
        onMovementStarted:
        {
            centerCurrentAlbumTimer.restart();
            mediaPlayer.setDefaultFocus();
        }
// added by Dmitry 29.09.13

        // Keyboard navigation
        focus: true

        //{changed by junam 2013.11.13 for add repeat
        function incrementIndex(repeat)
        {
            if(currentIndex + repeat < count)
                currentIndex = currentIndex + repeat;
            else
                currentIndex = count - 1;
        }

        function decrementIndex(repeat)
        {
            if(currentIndex >= repeat )
                currentIndex = currentIndex - repeat;
            else
                currentIndex = 0;
        }
        //}changed by junam

        Connections
        {
            target: visible ? mediaPlayer : null

            onChangeHighlight: changeSelection_onJogDial(arrow, status, repeat); //changed by junam 2013.11.13 for add repeat

            onSignalSetFocus:
            {
                if (coverListView.currentAlbumIdx != -1)
                {
                    coverListView.currentIndex = coverListView.currentAlbumIdx;
                }
            }
        }
    }

    Component
    {
        id: proxyDelegate

        //SingleRowCarouselItem
        Item
        {
            id: proxyItem

            //property string coverImage: (coverListView.currentAlbumName == albumTitle) ?
            property string coverImage: ( index == coverListView.currentAlbumIdx && index == coverListView.currentIndex) ?  //changed by junam 2013.11.05 for ITS_NA_206156
                                                        ((coverListView.currentCoverArt == "") ? RES.const_IMG_COVERFLOW_DEFAULT : coverListView.currentCoverArt) :
                                                           ((image == "") ? RES.const_IMG_COVERFLOW_DEFAULT : image)
            property real zoomRatio: (index == coverListView.currentIndex && coverListView.moving == false ) ? 1.56: 1.0 //changed by junam 2013.11.15 for scroll performance

            Behavior on zoomRatio { NumberAnimation { easing.type: Easing.InOutSine; duration: 300 } }
            Behavior on z { NumberAnimation { easing.type: Easing.InOutSine; duration: 300 } } //added by junam 2013.10.15 for ITS_EU_195682

            y : 178 - (100*zoomRatio)
            width  : MPC.const_COVER_FLOW_ITEM_SIZE + 5
            height : zoomRatio * MPC.const_COVER_FLOW_ITEM_SIZE * 2 + 4
            z: (index == coverListView.currentIndex && coverListView.moving == false  )? 0 : -1 //changed by junam 2013.11.15 for scroll performance

            Image
            {
                id : frontImage //added by junam for ITS_KOR_195869
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 0
                height : zoomRatio * MPC.const_COVER_FLOW_ITEM_SIZE
                width : zoomRatio * MPC.const_COVER_FLOW_ITEM_SIZE
                source : coverImage

                Item
                {
		//modified for coverflow index image 20131029
                    visible: firstChar.length
                    //width: zoomRatio * 98
                    //height: zoomRatio * 97
                    Image
                    {
                        id: index_img
                        anchors.top: parent.top
                        anchors.left : parent.left    
                        source:  (index == coverListView.currentIndex) ?  RES.const_IMG_COVERFLOW_INDEX_S : RES.const_IMG_COVERFLOW_INDEX_N
                    }
                    Text
                    {
                        anchors.left : index_img.left 
                        anchors.leftMargin : (index == coverListView.currentIndex) ? 10 : 7
                        // { modified by cychoi 2014.12.18 for ITS 254804, ITS 254808 unprintable character alignment
                        //anchors.top: index_img.top                        
                        //anchors.topMargin : -7              
                        height : (index == coverListView.currentIndex) ? 53 + 7 : 40 + 5
                        verticalAlignment : Text.AlignVCenter
                        // } modified by cychoi 2014.12.18
                        text:firstChar
                        font.family: "DH_HDR"
                        font.pointSize: (index == coverListView.currentIndex) ? 53 : 40
                        color: "#eeeeee"
                    }
                }

                AnimatedImage
                {
                    //paused: coverListView.moving //removed by sangmin.seol 2014.05.19 ITS 0237580 fix the problem play playing icon after scroll in pause state  //added by junam 2013.11.15 for scroll performance
                    visible: (index == coverListView.currentAlbumIdx)&&(coverListView.playState != 2)
                    x: 141 * zoomRatio
                    y: 141 * zoomRatio
                    width: 52 * zoomRatio
                    height: 52 * zoomRatio
                    playing: (coverListView.playState == 0 && !coverListView.moving) //modified by sangmin.seol 2014.05.19 ITS 0237580 fix the problem play playing icon after scroll in pause state
                    source: "/app/share/images/music/music_play_s.gif"
                }

                Rectangle
                {
                    visible: (index == coverListView.currentIndex && carousel.parent.focus_visible) || (index == coverListView.currentAlbumIdx)
                    anchors.fill: parent
                    color: "#00000000"
                    border.color: (index == coverListView.currentIndex && carousel.parent.focus_visible) ? MPC.const_APP_MUSIC_PLAYER_COLOR_FOCUSED :
                                    MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
                    border.width : MPC.const_APP_MUSIC_PLAYER_POPUP_LIST_SONGS_LIST_FOCUS_WIDTH
                }
            }

            Image
            {
                anchors.horizontalCenter: parent.horizontalCenter
                y : 3
                height : zoomRatio * MPC.const_COVER_FLOW_ITEM_SIZE
                width : zoomRatio * MPC.const_COVER_FLOW_ITEM_SIZE
                transform: Rotation { origin.x: 0; origin.y: zoomRatio * MPC.const_COVER_FLOW_ITEM_SIZE; axis { x:1; y: 0; z:0 } angle: 180 }
                source : coverImage
            }

            Image
            {
                anchors.horizontalCenter: parent.horizontalCenter
                y : 3 + zoomRatio * MPC.const_COVER_FLOW_ITEM_SIZE
                height : zoomRatio * MPC.const_COVER_FLOW_ITEM_SIZE
                width : zoomRatio * MPC.const_COVER_FLOW_ITEM_SIZE
                source: RES.const_IMG_ALBUM_MASK_S
            }


            Component.onCompleted:
            {
                PathViewModel.onComponentCompleted(index);
                if (index == 0)
                {
                    EngineListener.setAlbumThumbnail(proxyItem.coverImage);
                    if (AudioController.AutoplayAllowed() && !AudioController.isSearch)
                    {
                        AudioController.album = albumTitle//proxyItem.albumName;
                    }
                }
            }

            Component.onDestruction: PathViewModel.onComponentDestruction(index); // added by junam for CR12458

            MouseArea
            {
                anchors.fill: frontImage
                noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445

                beepEnabled : false;

                enabled: !screenTransitionDisableTimer.running  //added by junam 2013.11.22 for coverflow click
                onClicked:
                {
                	EngineListenerMain.ManualBeep();
                    //{changed by junam 2013.11.22 for coverflow click
                    __LOG("onClicked: index = "+index+" fileTitle = " + fileTitle);
                    //AudioController.isEnableErrorPopup = true
                    //AudioController.invokeMethod(carousel, "doAlbumClick",  coverListView.currentAlbumIdx == index, albumTitle);
                    //EngineListener.DisplayOSD(true); //added by Michael.Kim 2013.05.04 for New OSD Implementation
                    if(AudioController.IsFileSupported(fileTitle)) //added by junam 2013.11.28 for ITS_CHN_211039
                    {
                        //{changed by junam 2013.11.28 for ITS_NA_211655
                        screenTransitionDisableTimer.interval = 5000;
                        screenTransitionDisableTimer.restart();
                        //mediaPlayer.showPlayerView(true); 
                        //}changed by junam
                        AudioController.invokeMethod( AudioController, "coverflowItemClick", fileTitle);
                    }
                    else
                    {
                        popup_loader.showPopup(LVEnums.POPUP_TYPE_PLAY_UNAVAILABLE_FILE); //added by junam 2013.11.28 for ITS_CHN_211039
                    }
                    //}changed by junam
                }
                onPressed : centerCurrentAlbumTimer.restart(); //added by junam 2013.08.10 for flowview tune
            }
        }
    }

    //{added by junam 2013.12.09 for ITS_NA_212868
    DHAVN_Animation_Text
    {
        id: textFirst
        y : 347
        width: 770
        anchors.left: parent.left
        anchors.leftMargin: 255
        text:(carousel.firstLineTitle == " ") ? qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty : carousel.firstLineTitle
        font.pointSize: 32//40 ys 2013.09.09 ITS-0188614
        horizontalAlignment: Text.AlignHCenter
        font.family : MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
        color: (coverListView.currentAlbumIdx == coverListView.currentIndex)
               ? MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
               : MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT
        scrolling: (scrollIndex == 0) && visible && carousel.scrollingTicker && !coverListView.moving
        loops: textSecond.scrollable ? 1: Animation.Infinite
        onRunningFinished:
        {
            if (textSecond.scrollable && carousel.scrollingTicker)
                scrollIndex = 1;
        }
    }

    DHAVN_Animation_Text
    {
        id: textSecond
        y : textFirst.y + 50
        width: 770
        anchors.left: parent.left
        anchors.leftMargin: 255
        text: (carousel.secondLineTitle == " ") ? qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty : carousel.secondLineTitle
        font.pointSize: 40
        horizontalAlignment: Text.AlignHCenter
        color : (coverListView.currentAlbumIdx == coverListView.currentIndex)
                ? MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
                : MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT
        scrolling: (scrollIndex == 1) && visible && carousel.scrollingTicker && !coverListView.moving
        loops: textFirst.scrollable ? 1: Animation.Infinite
        onRunningFinished:
        {
            if (textFirst.scrollable && carousel.scrollingTicker)
                scrollIndex = 0;
        }
    }
    //}added by junam

    function doAlbumClick( isCurrent, album )
    {
        mediaPlayer.setCurrentCategory("Album");//added by junam 2013.05.19 for album entry
        if (isCurrent)
        {
            //{added by junam 2013.03.22 for ISV76946
            if(PathViewModel.isBusy())
                __LOG("Path view is too busy...")
            else //}added by junam
                mediaPlayer.showPlayerView(true)
        }
        else
        {
            centerCurrentAlbumTimer.restart(); //added by junam 2013.07.15 for ITS_NA_166666
            AudioController.album = album;
            mediaPlayer.showPlayerView(true);
        }
    }

    Connections
    {
        target: AudioController

        onSetHighlightCover:
        {
            __LOG("onSetHighlightCover: coverIndex = " + coverIndex + "isScroll = "+isScroll);
            /* Set current Album index to highlight it */
            coverListView.currentAlbumIdx = coverIndex;
            /* Move to the center current playing album */
            if (isScroll)// && centerCurrentAlbumTimer.running == false) // revert by junam 2013.09.08 for side effect of ITS_KOR_188249
            {
                coverListView.currentIndex = coverIndex;
            }
        }
        //{added by junam 2013.11.06 for coverflow update
        onClearCoverflowIndex:
        {
            __LOG("onClearCoverflowIndex : count = "+count+", "+coverListView.currentIndex);
            if( count <= coverListView.currentIndex)
                coverListView.currentIndex = -1;
        }

        onSetCoverflowIndex:
        {
            __LOG("onSetCoverflowIndex : index = " + index +" running="+centerCurrentAlbumTimer.running+" currentIndex="+coverListView.currentIndex +" album ="+coverListView.currentAlbumIdx );
            if(coverListView.currentAlbumIdx ==  coverListView.currentIndex )
            {
                coverListView.currentIndex = -1; //add by junam for donot index change annimation
                coverListView.currentIndex = (index < 0) ? 0 : index;
                coverListView.currentAlbumIdx = index;
            }
            else
            {
                if(coverListView.currentAlbumIdx < 0 )
                {
                    if(index >= 0)
                    {
                        coverListView.currentIndex = index;
                        coverListView.currentAlbumIdx = index;
                    }
                }
                else
                {
                    coverListView.currentAlbumIdx = index;
                }
            }
        }
        //}added by junam
        // modified by Dmitry 22.04.13 for ISV81181
        onStateChanged:
        {
            if (AudioController.getScanMode() == 0)
            {
                coverListView.playState = carousel.currentPlayStateIcon();
            }
        }
        // modified by Dmitry 22.04.13 for ISV81181

        //{modified by kihyung 2013.08.21 for ITS 0185499
        onCoverFlowMediaInfoChanged:
        {
            __LOG("onCoverFlowMediaInfoChanged: " + album + artist);
            //{changed by junam 2013.12.09 for ITS_NA_212868
            //coverListView.currentAlbumName  = album
            coverListView.currentCoverArt   = cover
            //coverListView.currentArtistName = artist
            //setJoggedCover( album, title, false); //changed by junam 2013.10.08 for ITS_KOR_194401
            setJoggedCover( title, album);
            //}changed by junam
        }
        //}modified by kihyung 2013.08.21 for ITS 0185499

        onStartScan: coverListView.playState = carousel.currentPlayStateIcon();

        onStopScan: coverListView.playState = carousel.currentPlayStateIcon();
    }
    //{changed by junam 2013.12.09 for ITS_NA_212868
    Connections
    {
        target:EngineListenerMain
        onTickerChanged: carousel.scrollingTicker = ticker;
    }
    //}changed by junam

    Timer
    {
        id: centerCurrentAlbumTimer
        interval: 5000
        running: false
        repeat : true  //added by junam 2013.09.06 for ITS_KOR_188249

        onTriggered:
        {
            //{changed by junam 2013.09.06 for ITS_KOR_188249
            if (coverListView.currentAlbumIdx != -1 && coverListView.moving == false)
            {
                coverListView.currentIndex = coverListView.currentAlbumIdx;
                //{changed by junam 2013.12.09 for ITS_NA_212868
                //setJoggedCover(coverListView.model.getAlbumName(coverListView.currentIndex), AudioController.song, false); 
                setJoggedCover( AudioController.song, coverListView.model.getAlbumName(coverListView.currentIndex));
                //}changed by junam
                stop(); 
            }
            //}changed by junam
        }
    }
    // } modified by eugeny.novikov 2012.12.06 for CR 16150

    // { added by sangmin.seol 2013.11.10 ITS-0207999 Change focus to content-view if focused in modearea
    Connections
    {
        target : (/*!popup.visible &&*/ !popup_loader.visible ) ? EngineListener : null; // modified by cychoi 2015.06.03 for Audio/Video QML optimization

        onSignalTuneNavigation:
        {
            if (mediaPlayer.focus_index == LVEnums.FOCUS_MODE_AREA)
            {
                mediaPlayer.setDefaultFocus();
            }
        }
    }
    // } added by sangmin.seol 2013.11.10 ITS-0207999 Change focus to content-view if focused in modearea
}
