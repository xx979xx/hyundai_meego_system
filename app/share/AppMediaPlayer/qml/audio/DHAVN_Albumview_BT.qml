// modified by Dmitry 08.05.13
import Qt 4.7
import QtQuick 1.1
import AppEngineQMLConstants 1.0

import "DHAVN_AppMusicPlayer_General.js" as MPC
import "DHAVN_AppMusicPlayer_Resources.js" as RES

Item
{
    id: album_bt_view
    width: MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH
    height: MPC.const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_HEIGHT

    LayoutMirroring.enabled: EngineListenerMain.middleEast
    LayoutMirroring.childrenInherit: EngineListenerMain.middleEast

    property string sSongName: qsTranslate( LocTrigger.empty + "main", QT_TR_NOOP("STR_MEDIA_UNKNOWN")) 
    property string sAlbumName: qsTranslate( LocTrigger.empty + "main", QT_TR_NOOP("STR_MEDIA_UNKNOWN")) 
    property string sArtistName: qsTranslate( LocTrigger.empty + "main", QT_TR_NOOP("STR_MEDIA_UNKNOWN")) 

    property string fadeColor : "#0E1318"	//"#000011"		//modified by hyochang.ryu 20131026 for New UX	// added by hyochang.ryu 20130923 for ITS189883
    property string sFilesCount: ""
    property string sCoverAlbum: "/app/share/images/music/basic_album_bg_bt.png" //added by aettie 2013.01.09
    property string sDeviceName: qsTranslate( LocTrigger.empty + "main", QT_TR_NOOP("STR_MEDIA_UNKNOWN")) 
    property int offsetX: 0;
    property bool move_start: false
    property int tranCount: 1;
    //{ added by hyochang.ryu 20130729 for text scrolling
    property bool scrollingTicker: EngineListenerMain.scrollingTicker;
    property int textIdx:0;
    //} added by hyochang.ryu 20130729 for text scrolling
    
    property bool isMetaInfo: false // added by radhakrushna 20221212 cr16683
    property bool isRemoteCtrl: false // added by cychoi 2015.05.15 for ITS 262799

    // { modified by cychoi 2015.07.13 for HMC new spec - set text index to zero on Screen Transition
    onVisibleChanged:
    {
        if(visible==false)
        {
            scrollingTicker=false
            album_bt_view.textIdx = 0;
            btTextScrollTimer.timerIdx = 0;
        }
        else
            scrollingTicker=EngineListenerMain.scrollingTicker
    }
    // } modified by cychoi 2015.07.10

    function __LOG( textLog )
    {
       EngineListenerMain.qmlLog( " DHAVN_AlbumView_BT.qml: " + textLog )
    }

    //{ added by hyochang.ryu 20130729 for text scrolling
    function getTextLength0(str)
    {
        return ( EngineListener.getStringWidth(str, MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR, 
        MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_BLUETOOTH)+1 )
    }
    function getTextLength(str)
    {
        return ( EngineListener.getStringWidth(str, MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR, 
        MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT)+1 )	//modified by hyochang.ryu 20131031 for ITS 205114
    }
    function getTextScrollDuration(idx)
    {
        var textInput;
        if(idx == 0 && view_btmusic.scrolling)
        {
            textInput = view_btmusic.viewText;
        }
        else if(idx == 1 && view_artist.scrolling)
        {
            textInput = view_artist.viewText;
        }
        else if(idx == 2 && view_song.scrolling) 
        {
            textInput = view_song.viewText;
        }
        else if(idx == 3 && view_album.scrolling) 
        {
            textInput = view_album.viewText;
        }
        //else if(idx == 3 && view_folder.scrolling) 
        //{
        //    textInput = view_folder.viewText;
        //}
        else textInput = "";

           //{ modified by hyochang.ryu 20131018 for New UX
           /*return textInput==""? 1 : (idx==0) ? 
               (EngineListener.getStringWidth(textInput, MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR, MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_BLUETOOTH)+1) *15  + 2500
              :(EngineListener.getStringWidth(textInput, MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR, MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT)+1) *20  + 2500
           */
           return textInput==""? 1 : ( ( EngineListener.getStringWidth(textInput, 
            MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR, 
            MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT)+ 120)/50 * 1000 ) + 1500	//+1) *10 ) + 2500		//modified by hyochang.ryu 20131031 for ITS 205114
           //} modified by hyochang.ryu 20131018 for New UX
    }
    function getOneLineScroll()
    {
        __LOG((view_artist.scrolling + view_song.scrolling + view_album.scrolling + view_btmusic.scrolling));
         return ( view_artist.scrolling + view_song.scrolling + view_album.scrolling + view_btmusic.scrolling ) 
    }
    //} added by hyochang.ryu 20130729 for text scrolling
    
    /*Image
    {
        id:cover_basic

        anchors.left: parent.left
        anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN
        y: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_TOP_MARGIN

        Image
        {
            id: cover_album

            width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_WIDTH_BT
            height: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_HEIGHT_BT
            anchors
            {
                left: cover_basic.left
                leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_LEFT_MARGIN
                top: cover_basic.top
                topMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_TOP_MARGIN
            }
            source: album_bt_view.sCoverAlbum
        }
       
        Image
        {
            id: album_light
            source: RES.const_IMG_ALBUM_LIGHT
            anchors.fill: parent
        }

        MouseArea
        {
            id: album_mouseArea
            anchors.fill: parent
            hoverEnabled: true;
            onReleased: mediaPlayer.showPlayerView(false)
        }
    }*/
    
    //{ added by hyochang.ryu 20130923 for ITS189883
    Image
    {
        id:cover_btmusic

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN
        anchors.topMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_TOP_MARGIN

        source: RES.const_IMG_ALBUM_BG_BT

        Image
        {
            id: cover_album_bt
            LayoutMirroring.enabled: false

            width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_WIDTH_BT
            height: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_HEIGHT_BT

            anchors
            {
                left: cover_btmusic.left
                leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_LEFT_MARGIN-1
                top: cover_btmusic.top
                topMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_TOP_MARGIN
            }
            source: ""
            //source: album_bt_view.sCoverAlbum
            cache: false 
        }
        Image
        {
            id: album_light
            source: RES.const_IMG_ALBUM_LIGHT
            anchors.fill: parent
        }

        // added by Dmitry
	// everyting works without this useless mouse area, take a look at gesture area below!
	// don't know how to fix, ask me
    }

    Image
    {
        id:cover_btmusic_reflect

        anchors.left: parent.left
        anchors.bottom: cover_btmusic.bottom
        anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN

        source: RES.const_IMG_ALBUM_BG_BT
        transform: Rotation { origin.x: cover_btmusic_reflect.width / 2; origin.y: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_HEIGHT + 11; axis { x:1; y: 0; z:0 } angle: 180 }

        Image
        {
            id: cover_album_reflect
            LayoutMirroring.enabled: false

            width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_WIDTH_BT
            height: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_HEIGHT_BT

            anchors
            {
                left: cover_btmusic_reflect.left
                leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_LEFT_MARGIN
                top: cover_btmusic_reflect.top
                topMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_TOP_MARGIN
            }
            source: ""
            //source: album_bt_view.sCoverAlbum
            cache: false 
        }

        Rectangle
        {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "#030406"
                }

                GradientStop {
                    position: 0.3
                    color: "#080b0e"
                }

                GradientStop {
                    position: 0.5
                    color: "#0c1015"
                }

                GradientStop {
                    position: 0.7
                    color: "#FF" + fadeColor.substring(1)
                }

                GradientStop {
                    position: 1.0
                    color: "#AA" + fadeColor.substring(1)
                }
            }
        }
    }
    //} added by hyochang.ryu 20130923 for ITS189883
	
    Item
    {
        id:view_main
        anchors.left: parent.left
        anchors.top: parent.top   //modified by yongkyun.lee 2013-10-11 for : ITS 194874
        anchors.rightMargin: 125
        anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_LEFT_MARGIN
        anchors.topMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_TOP_MARGIN   //modified by yongkyun.lee 2013-10-11 for : ITS 194874
        //y: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_TOP_MARGIN
        height:MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_HEIGHT

    //{ added by hyochang.ryu 20130729 for text scrolling
        Timer  
        {
            id: btTextScrollTimer // added by sangmin.seol 2014.09.19 ITS 0248490 for initialize timerIdx in mediainfochanged
            property int timerIdx:0
            interval: getTextScrollDuration(album_bt_view.textIdx); 
            running: ( getOneLineScroll() <= 1 ) ? false : true; 
            repeat: true
            onTriggered: 
            {
                //{changed by junam 2013.12.05 for ITS_NA_212881
                //if(timerIdx < 4)
                //{
                //    album_bt_view.textIdx = timerIdx;
                //    timerIdx++;
                //}
                //else if (timerIdx == 4)
                //{
                //    timerIdx = 0;
                //    album_bt_view.textIdx = timerIdx;
                //    timerIdx ++;
                //}
                timerIdx = (timerIdx + 1) % 4;
                album_bt_view.textIdx = timerIdx;
            }
        }
    //} added by hyochang.ryu 20130729 for text scrolling
		
        Item
        {
            id: view_btmusic
            height: view_main.height/4
    //{ added by hyochang.ryu 20130729 for text scrolling
            property string viewText: text_btmusic.text;
            property bool scrolling: getTextLength(viewText) > text_btmusic.width? 1 : 0;		//mofided by hyochang.ryu 20131018 for New UX
    //} added by hyochang.ryu 20130729 for text scrolling

            Image
            {
                id: icon_title
                source: RES.const_MUSIC_BT_ICON
                anchors.left: parent.left
                anchors.top: parent.top
            }
 
     //{ added by hyochang.ryu 20130729 for text scrolling
           DHAVN_Marquee_Text
            {
                 id: text_btmusic
                 // { modified by oseong.kwon 2014.01.10 for ITS 218981 
                 text: (album_bt_view.sDeviceName == "Unknown" || album_bt_view.sDeviceName == "") ? qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty : album_bt_view.sDeviceName
                 // } modified by oseong.kwon 2014.01.10

                 scrollingTicker: ( album_bt_view.scrollingTicker &&  album_bt_view.textIdx == 0 ) || ( album_bt_view.scrollingTicker &&  getOneLineScroll() <= 1 )
                 
                 anchors
                 {
                     left: parent.left
                     top : parent.top 
                     // topMargin : -10//{ modified by yongkyun.lee 2013-10-10 for : ITS 194874
                     leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                     verticalCenter: icon_title.top
                     verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                 }

                 color         :  "#fafafa"
                 fontFamily   : MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
                 fontSize      : MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT  //modified by yongkyun.lee 2013-10-11 for : ITS 194874
                 width         : MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH 
                 //horizontalAlignment: Text.AlignLeft
             }
           /*Text
            {
                id: text_btmusic
                text: album_bt_view.sDeviceName

                anchors
                {
                    left: parent.left
                    top : parent.top 
                    topMargin : -10
                    leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                    verticalCenter: icon_artist.top
                }

                color         :  "#fafafa"
                font.family   : MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
                font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_BLUETOOTH
                width         : MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH 
                horizontalAlignment: Text.AlignLeft
            }*/
     //} added by hyochang.ryu 20130729 for text scrolling
        }

        Item
        {
            id: view_artist

            height: view_main.height/4
            anchors.top: view_btmusic.bottom
            //anchors.topMargin: 10  //modified by yongkyun.lee 2013-10-11 for : ITS 194874
    //{ added by hyochang.ryu 20130729 for text scrolling
            property string viewText: text_artist.text;
            property bool scrolling: getTextLength(viewText) > text_artist.width? 1 : 0;
            //height: view_main.height/4 //MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_HEIGHT
    //} added by hyochang.ryu 20130729 for text scrolling
            Image
            {
                id: icon_artist
                source      : "/app/share/images/music/basic_ico_artist.png"
                anchors.left: parent.left
                anchors.top : parent.top 
            }

     //{ added by hyochang.ryu 20130729 for text scrolling
           DHAVN_Marquee_Text
            {
                 id: text_artist
                 // { modified by oseong.kwon 2014.01.10 for ITS 218981 
                 text: (album_bt_view.sArtistName == "Unknown" || album_bt_view.sArtistName == "") ? qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty : album_bt_view.sArtistName
                 // } modified by oseong.kwon 2014.01.10

                 scrollingTicker: ( album_bt_view.scrollingTicker &&  album_bt_view.textIdx == 1 ) || ( album_bt_view.scrollingTicker &&  getOneLineScroll() <= 1 )
                 
                 anchors
                 {
                     left: icon_artist.left
                     top : parent.top 
                     leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                     verticalCenter: icon_artist.top
                     verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                 }

                 color         :  "#fafafa"
                 fontFamily   : MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
                 fontSize      : MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT
                 width         : MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH 
                 //horizontalAlignment: Text.AlignLeft
             }
           /*Text
            {
                id  : text_artist
                text: album_bt_view.sArtistName

                anchors
                {
                    left: parent.left
                    top : parent.top
                    leftMargin    : MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                    verticalCenter: icon_artist.top
                    verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                }

                color:  "#fafafa"
                font.family   : MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
                font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_36_FONT
                width : MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH 
                elide : "ElideRight" 
                horizontalAlignment: Text.AlignLeft
            }*/
    //} added by hyochang.ryu 20130729 for text scrolling
        }

        Item
        {
            id: view_song
    //{ added by hyochang.ryu 20130729 for text scrolling
            property string viewText: text_song.text;
            property bool scrolling: getTextLength(viewText) > text_song.width? 1 : 0;
    //} added by hyochang.ryu 20130729 for text scrolling

            height:view_main.height/4
            anchors.top: view_artist.bottom
            Image
            {
                id: icon_song
                source: "/app/share/images/music/basic_ico_song.png"
                anchors.left: parent.left
            }

    //{ added by hyochang.ryu 20130729 for text scrolling
            DHAVN_Marquee_Text
            {
                 id: text_song
                 // { modified by oseong.kwon 2014.01.10 for ITS 218981
                 text: (album_bt_view.sSongName == "Unknown" || album_bt_view.sSongName == "") ? qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty : album_bt_view.sSongName
                 // } modified by oseong.kwon 2014.01.10
                 scrollingTicker: ( album_bt_view.scrollingTicker &&  album_bt_view.textIdx == 2 ) || ( album_bt_view.scrollingTicker &&  getOneLineScroll() <= 1 )

                 anchors
                 {
                     left: icon_song.left
                     leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                     verticalCenter: icon_song.top
                     verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                 }

                 color:  "#fafafa"
                 fontSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT
                 fontFamily: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
                 width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH
                 //horizontalAlignment: Text.AlignLeft
             }
          /*Text
            {
                id  : text_song
                text: album_bt_view.sSongName

                anchors
                {
                    left: parent.left
                    top :  parent.top 
                    leftMargin    : MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                    verticalCenter: icon_song.top
                    verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                }

                color:  "#fafafa"
                font.family   : MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
                font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_36_FONT 
                width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH
                elide: "ElideRight" 
                horizontalAlignment: Text.AlignLeft
            }*/
    //} added by hyochang.ryu 20130729 for text scrolling
        }

        Item
        {
            id: view_album
    //{ added by hyochang.ryu 20130729 for text scrolling
            property string viewText: text_album.text;
            property bool scrolling: getTextLength(viewText) > text_album.width? 1 : 0;
    //} added by hyochang.ryu 20130729 for text scrolling

            height: view_main.height/4
            anchors.top: view_song.bottom

            Image
            {
                id: icon_album
                source: "/app/share/images/music/basic_ico_album.png"
                anchors.left: parent.left
            }

    //{ added by hyochang.ryu 20130729 for text scrolling
            DHAVN_Marquee_Text
            {
                 id: text_album
                 // { modified by oseong.kwon 2014.01.10 for ITS 218981
                 text: (album_bt_view.sAlbumName == "Unknown" || album_bt_view.sAlbumName == "") ? qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty : album_bt_view.sAlbumName
                 // } modified by oseong.kwon 2014.01.10
                 scrollingTicker: ( album_bt_view.scrollingTicker &&  album_bt_view.textIdx == 3 )|| ( album_bt_view.scrollingTicker &&  getOneLineScroll() <= 1 )

                 anchors
                 {
                     left: icon_album.left
                     leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                     verticalCenter: icon_album.top
                     verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                 }

                 color:  "#fafafa"
                 fontSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT
                 fontFamily: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
                 width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH
                 //horizontalAlignment: Text.AlignLeft
            }
          /*Text
            {
                id  : text_album
                text: album_bt_view.sAlbumName

                anchors
                {
                    left: parent.left
                    top : parent.top 
                    leftMargin    : MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                    verticalCenter: icon_album.top
                    verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                }

                color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157
                font.family   : MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
                font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_36_FONT
                width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH 
                elide: "ElideRight"
                horizontalAlignment: Text.AlignLeft
            }*/
    //} added by hyochang.ryu 20130729 for text scrolling
        }
    }

    Connections
    {
        target: AudioController

         onBtMusicInfoChanged:
        {
            __LOG("onBtMusicInfoChanged : title= " + title + " , " + album + " , " + artist );
            // { modified by cychoi 2015.03.27 for ITS 260508
            album_bt_view.sSongName = title;
            album_bt_view.sAlbumName = album;
            album_bt_view.sArtistName = artist;
            // } modified by cychoi 2015.03.27

            album_bt_view.sCoverAlbum = "/app/share/images/music/basic_album_bg_bt.png"; //modified by aettie.ji 2013.01.07

            //added by sangmin.seol 2014.09.15 ITS 0248490, 0248491 reset textIdx if mediainfo changed.
            album_bt_view.textIdx = 0;
            btTextScrollTimer.timerIdx = 0;
        }
    }
    Connections
    {
       target:EngineListener
       onUpdateBTDeviceName:
       {
          EngineListenerMain.qmlLog("[BT QML: onUpdateBTDeviceName]: deviceName =" + deviceName )
          EngineListenerMain.qmlLog("[BT QML: isMetaInfo ] :  " + bIsMetaInfo)
          sDeviceName = deviceName // modified by cychoi 2015.03.27 for ITS 260508
          isMetaInfo = bIsMetaInfo // added by radhakrushna 20221212 cr16683
          isRemoteCtrl = bIsRemoteCtrl // added by cychoi 2015.05.15 for ITS 262799
          /*album_bt_view.sDeviceName =  (deviceName == "")? "Unknown":EngineListener.makeElidedString(deviceName,
                                               MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB,
                                               MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_BLUETOOTH ,
                                               MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH);*/
       }
    }

    //{ added by hyochang.ryu 20130729 for text scrolling
    Connections
    {
        target:EngineListenerMain
        onTickerChanged:
        {
            __LOG("onTickerChanged ticker : " + ticker);
            album_bt_view.scrollingTicker = ticker;
        }
    }
    //} added by hyochang.ryu 20130729 for text scrolling

    MouseArea
    {
        id: imageMouse_album
        anchors.fill: parent
        anchors.leftMargin:cover_basic.width + MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN
        beepEnabled: false
        noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445
        onPressed:
        {
            album_bt_view.move_start = true;
            offsetX = mouseX;
        }

        onPositionChanged:
        {
            /* //{ modified by hyochang.ryu 20130826 for ITS186053
            if ((offsetX - mouseX) >= 100 && album_bt_view.move_start)
            {
                album_bt_view.move_start = false;
                mediaPlayer.nextTrack();
            }
            else if ((offsetX - mouseX) <= -100 && album_bt_view.move_start)
            {
                album_bt_view.move_start = false;
                mediaPlayer.previousTrack(false);
            }
            //} modified by hyochang.ryu 20130826 for ITS186053 */
        }
    }

    Component.onCompleted:
    {
	//{ modified by hyochang.ryu 20130718 
          /*album_bt_view.sDeviceName =  EngineListener.makeElidedString(EngineListener.getBTDeviceName(),
                                               MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB,
                                               MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_BLUETOOTH ,
                                               MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH);*/
	//} modified by hyochang.ryu 20130718 
       album_bt_view.sDeviceName = EngineListener.getBTDeviceName();
       album_bt_view.isMetaInfo = EngineListener.getIsMetaInfo();
       album_bt_view.isRemoteCtrl = EngineListener.getIsRemoteCtrl(); // added by cychoi 2015.05.15 for ITS 262799
       // { added by cychoi 2014.06.12 for ITS 240076
       album_bt_view.sSongName = AudioController.GetBTSongName();
       album_bt_view.sAlbumName = AudioController.GetBTAlbumName();
       album_bt_view.sArtistName = AudioController.GetBTArtistName();
       __LOG("onCompleted : sSongName= " + album_bt_view.sSongName + " , " + album_bt_view.sAlbumName + " , " + album_bt_view.sArtistName );
       // } added by cychoi 2014.06.12
    }
}
// modified by Dmitry 08.05.13
