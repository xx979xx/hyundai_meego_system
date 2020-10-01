// modified by Dmitry 11.05.13
import Qt 4.7
import AudioControllerEnums 1.0 // added by jaden1.lee 2012.08.13 CR 11655
import AppEngineQMLConstants 1.0
import ListViewEnums 1.0 // added by eugene.seo 2013.03.16
import QtQuick 1.1
import Qt.labs.gestures 2.0

import "DHAVN_AppMusicPlayer_General.js" as MPC
import "DHAVN_AppMusicPlayer_Resources.js" as RES

Item
{
    id: album_basic_view
    width: MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH
    height: MPC.const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_HEIGHT

    property string sTrackName: qsTranslate( LocTrigger.empty + "main", QT_TR_NOOP("STR_MEDIA_TRACK")) // added by wonseok.heo for ITS 197433 2013.10.28
    property string sSongName: ""
    property string sAlbumName: qsTranslate( LocTrigger.empty + "main", QT_TR_NOOP("STR_MEDIA_UNKNOWN")) // modified by wonseok.heo for ITS 197433 2013.10.28
    property string sArtistName: qsTranslate( LocTrigger.empty + "main", QT_TR_NOOP("STR_MEDIA_UNKNOWN")) // modified by wonseok.heo for ITS 197433 2013.10.28
    //    property string sFolderName: "Music"
//    property string sFolderName: "/.." //modified by aettie.ji 2013.01.31 for ISV 70943
    // modified by aettie 20130812 for ITS 183630
    //property string sFolderName: "Root" //modified by aettie 2013 08 05 for ISV NA 85625
    property string sFolderName: qsTranslate( LocTrigger.empty + "main", QT_TR_NOOP("STR_MEDIA_ROOT_FOLDER") ) 
    property string sFilesCount: ""
    property string sCoverAlbum: ""
    property string sGenre: ""
    property string sComposer: "" // add by junggil 2012.06.29 for CR08958 : Composer info is not displayed on activating more info in Basic play back screen
    property bool isVisibleGenre: false
    property bool isVisibleComposer: false // add by junggil 2012.06.29 for CR08958 : Composer info is not displayed on activating more info in Basic play back screen
    property bool isVislbleFoler: false //true // modified by cychoi 2016.03.30 for HMC IdeaBank Folder Name not displayed. // added by eunkoo 2012.07.26 for CR11898

    property string fadeColor : "#0E1318"	//"#000011"	//modified by hyochang.ryu 20131026 for New UX
//aettie for Main Player text scrolling 20130725
    property bool scrollingTicker: EngineListenerMain.scrollingTicker;
    property int textIdx:0;
    
    signal showIndexingPopUp() // added by eugene.seo 2013.03.16
    signal showIPODIndexingPopUp() // added by kihyung 2013.4.7

    property string sCategoryId: ""	//added by aettie 2013.04.01 for New UX
    property bool gesture_enable: true // modified by ravikanth 02-10-13 for ITS 0190988

    property bool gracenote_logo_visible: false; //added gracenote logo spec changed 20131008

    onVisibleChanged:
    {
        if(visible==false)
        {
            scrollingTicker=false // added by suilyou ISV EU 90087
            // { added by cychoi 2015.07.13 for HMC new spec - set text index to zero on Screen Transition
            album_basic_view.textIdx = 0;
            textScrollTimer.timerIdx = 0;
            // } added by cychoi 2015.07.13
        }
        else
            scrollingTicker=EngineListenerMain.scrollingTicker
    }
    function __LOG( textLog )
    {
        EngineListenerMain.qmlLog( " DHAVN_AlbumView_basic.qml: " + textLog )
    }
    
    //aettie for Main Player text scrolling 20130725

    function getTextLength(str)
    {
        return ( EngineListener.getStringWidth(str, 
        MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR, 
        MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT)+1)
    }
    function getTextScrollDuration(idx)
    {
        var textInput;
        if(idx == 0 && view_artist.scrolling)
        {
            textInput = view_artist.viewText;
        }
        else if(idx == 1 && view_song.scrolling) 
        {
            textInput = view_song.viewText;
        }
        else if(idx == 2 && view_album.scrolling) 
        {
            textInput = view_album.viewText;
        }
        else if(idx == 3 && view_folder.scrolling) 
        {
            textInput = view_folder.viewText;
        }
        else textInput = "";
           //modified for Text scroll speed 20131031
           return textInput==""? 1 : ( ( EngineListener.getStringWidth(textInput, 
            MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR, 
            MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT) + 120)/50 * 1000 ) + 1500
           
    }
    function getOneLineScroll()
    {
        __LOG((view_artist.scrolling + view_song.scrolling + view_album.scrolling + view_folder.scrolling));
         return ( view_artist.scrolling + view_song.scrolling + view_album.scrolling + view_folder.scrolling ) 
    }
    
    LayoutMirroring.enabled: EngineListenerMain.middleEast
    LayoutMirroring.childrenInherit: EngineListenerMain.middleEast

    Image
    {
        id:cover_basic

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN
        anchors.topMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_TOP_MARGIN

        source: RES.const_IMG_ALBUM_BG

        Image
        {
            id: cover_album
            LayoutMirroring.enabled: false

            width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_WIDTH
            height: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_HEIGHT

            anchors
            {
                left: cover_basic.left
                leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_LEFT_MARGIN - 1 //modified by Michael.Kim 2013.03.14 for New UX
                top: cover_basic.top
                topMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_TOP_MARGIN
            }
            source: album_basic_view.sCoverAlbum
            cache: false //added by junam 2013.07.19 for disable cache
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
    //added gracenote logo spec changed 20131008
    Item
    {
        id: gracenote_logo_item
        //LayoutMirroring.enabled: EngineListenerMain.middleEast
        //LayoutMirroring.childrenInherit: EngineListenerMain.middleEast

        visible: album_basic_view.gracenote_logo_visible
              
        anchors.left: parent.left
        anchors.leftMargin: 188
        anchors.top: parent.top
        anchors.topMargin: 301

        width: 191
        height: 110

        Image
        {
            id: gracenote_logo_image
            anchors.left: parent.left
            anchors.top: parent.top
            source: "/app/share/images/music/logo_gracenote.png"
        }
    }
    Image
    {
        id:cover_basic_reflect

        anchors.left: parent.left
        anchors.bottom: cover_basic.bottom
        anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN

        source: RES.const_IMG_ALBUM_BG
        transform: Rotation { origin.x: cover_basic_reflect.width / 2; origin.y: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_HEIGHT + 11; axis { x:1; y: 0; z:0 } angle: 180 }
        visible: !gracenote_logo_item.visible //added gracenote logo spec changed 20131008
        Image
        {
            id: cover_album_reflect
            LayoutMirroring.enabled: false

            width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_WIDTH
            height: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_HEIGHT

            anchors
            {
                left: cover_basic_reflect.left
                leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_LEFT_MARGIN
                top: cover_basic_reflect.top
                topMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_TOP_MARGIN
            }
            source: album_basic_view.sCoverAlbum
            cache: false //added by junam 2013.07.19 for disable cache
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

    Item
    {
        id:view_main
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_LEFT_MARGIN
        anchors.topMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_TOP_MARGIN
        anchors.rightMargin: 125 // modified by Dmitry 08.05.13
        height:MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_HEIGHT

        // { added by jaden1.lee 2012.08.13 CR 11655
        state: "state_known_album"
        states: [
            State {
                name: "state_known_album"
                PropertyChanges { target: view_artist; visible: true; height: view_main.height/4; }
                PropertyChanges { target: view_album;  visible: true; height: view_main.height/4; }
            },
            State {
                name: "state_unknown_album"
                // {modified by wonseo.heo 2013.07.27 for ITS 180979
                PropertyChanges { target: view_artist; visible: true; height: view_main.height/4; }
                PropertyChanges { target: view_album;  visible: true; height: view_main.height/4; }
//                PropertyChanges { target: view_artist; visible: false; height: 0; }
//                PropertyChanges { target: view_album;  visible: false; height: 0; }
                //  } modified by wonseo.heo 2013.07.27 for ITS 180979
            }
        ]
        // } added by jaden1.lee
//aettie for Main Player text scrolling 20130725
        Timer  
        {
            id: textScrollTimer // added by sangmin.seol 2014.09.19 ITS 0248490 for initialize timerIdx in mediainfochanged
            property int timerIdx:0
            interval: getTextScrollDuration(album_basic_view.textIdx); 
            running: ( getOneLineScroll() <= 1 ) ? false : true; 
            repeat: true
            onTriggered: 
            {
                //{changed by junam 2013.12.05 for ITS_NA_212881
                //if(timerIdx < 4)
                //{
                //    album_basic_view.textIdx = timerIdx;
                //    timerIdx++;
                //}
                //else if (timerIdx == 4)
                //{
                //    timerIdx = 0;
                //    album_basic_view.textIdx = timerIdx;
                //    timerIdx ++;
                //}
                timerIdx = (timerIdx + 1) % 4;
                album_basic_view.textIdx = timerIdx;
                //}changed by junam
            }
        }        

        Item
        {
            id: view_artist
	    ////aettie for Main Player text scrolling 20130725

            property string viewText: text_artist.text;
            property bool scrolling: getTextLength(viewText) > text_artist.width? 1 : 0;
                
            height: view_main.height/4 //MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_HEIGHT
            
            Image
            {
                id: icon_artist
                source: "/app/share/images/music/basic_ico_artist.png"
                anchors.left: parent.left
            }
	    ////aettie for Main Player text scrolling 20130725

            DHAVN_Marquee_Text
            {
            
                 id: text_artist
                 // { modified by wonseok.heo for ITS 197433 2013.10.28 // modified for iPod 2013.10.31
                 text: (((AudioController.PlayerMode == MP.DISC) &&( AudioController.DiscType == MP.AUDIO_CD)) || AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2 )
                       && (album_basic_view.sArtistName == "" || album_basic_view.sArtistName == "Unknown" || album_basic_view.sArtistName == "Unknown Artist") ? (qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty)
                            : (album_basic_view.sArtistName == "Unknown" || album_basic_view.sArtistName == " " ? (qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty) : album_basic_view.sArtistName)
                 // } modified by wonseok.heo for ITS 197433 2013.10.28 // modified for iPod 2013.10.31
                 scrollingTicker: ( album_basic_view.scrollingTicker &&  album_basic_view.textIdx == 0 ) || ( album_basic_view.scrollingTicker &&  getOneLineScroll() <= 1 )
                 
                 color: prBar.bTuneTextColor? MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT 
                                                        : MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY 
                
                 anchors
                 {
                     left: icon_artist.left
                     leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                     verticalCenter: icon_artist.top
                     verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                 }

                 fontSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT
                 fontFamily: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR

                 //{ modified by yongkyun.lee 2013-09-16 for : ITS 189480
		//modified gracenote logo spec changed 20131008
                 width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH
                 //} modified by yongkyun.lee 2013-09-16 

             }
        }

        Item
        {
            id: view_song
//aettie for Main Player text scrolling 20130725
            property string viewText: text_song.text;
            property bool scrolling: getTextLength(viewText) > text_song.width? 1 : 0;
                
            height:view_main.height/4
            anchors.top: view_artist.bottom

            Image
            {
                id: icon_song
                source: "/app/share/images/music/basic_ico_song.png"
                anchors.left: parent.left
            }
//aettie for Main Player text scrolling 20130725
            DHAVN_Marquee_Text
            {
            
                 id: text_song
                 // { modified by wonseok.heo for ITS 197433 2013.10.28 // modified for iPod 2013.11.05
                 text: ((AudioController.PlayerMode == MP.DISC) &&( AudioController.DiscType == MP.AUDIO_CD) && (AudioController.GetCDDAGraceNoteStatus() == 2 || album_basic_view.sArtistName == "Unknown" ))
                       ? (album_basic_view.sSongName == "Unknown" ? (qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty) : (album_basic_view.sTrackName + " " + album_basic_view.sSongName)) // modified by cychoi 2015.07.24 for ISV 117672
                       : ((AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2) && (album_basic_view.sSongName == "Unknown" || album_basic_view.sSongName == "Unknown Title"))
                       ? (qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty)
                       : album_basic_view.sSongName
                 // } modified by wonseok.heo for ITS 197433 2013.10.28 // modified for iPod 2013.11.05
                 scrollingTicker: ( album_basic_view.scrollingTicker &&  album_basic_view.textIdx == 1 ) || ( album_basic_view.scrollingTicker &&  getOneLineScroll() <= 1 )
                 color: prBar.bTuneTextColor? MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT 
                                                        : MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY 
                 anchors
                 {
                     left: icon_song.left
                     leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                     verticalCenter: icon_song.top
                     verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                 }

                 fontSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT
                 fontFamily: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR

                 width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH // modified by yongkyun.lee 2013-09-16 for : ITS 189480
             }
          /*  Text
            {
                id: text_song
                text: album_basic_view.sSongName

                anchors
                {
                    left: icon_song.left
                    leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                    verticalCenter: icon_song.top
                    verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                }

                color: prBar.bTuneTextColor? MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT : MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY //modified by aettie.ji 2013.01.28 for ISV 61921

                font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR // modified by Michael.Kim 2013.03.16 for new UX
                font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_40_FONT  // modified by Michael.Kim 2013.03.16 for new UX
                width: mediaPlayer.gracenote_logo_visible ? MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH_GN : MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH
                elide: "ElideRight"                                                                  // added by dongjin 2012.08.21 for NEW UX
                horizontalAlignment: Text.AlignLeft
            }*/
        }

        Item
        {
            id: view_album
//aettie for Main Player text scrolling 20130725
            property string viewText: text_album.text;
            property bool scrolling: getTextLength(viewText) > text_album.width? 1 : 0;
                
            height: view_main.height/4
            anchors.top: view_song.bottom

            Image
            {
                id: icon_album
                source: "/app/share/images/music/basic_ico_album.png"
                anchors.left: parent.left
            }
//aettie for Main Player text scrolling 20130725
            DHAVN_Marquee_Text
            {
            
                 id: text_album
                 // { modified by wonseok.heo for ITS 197433 2013.10.28 // modified for iPod 2013.10.31
                 text: (((AudioController.PlayerMode == MP.DISC) &&( AudioController.DiscType == MP.AUDIO_CD)) || AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2 )
                         && (album_basic_view.sAlbumName == "" || album_basic_view.sAlbumName == "Unknown" || album_basic_view.sAlbumName == "Unknown Album") ? (qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty)
                            : ( album_basic_view.sAlbumName == "Unknown" || album_basic_view.sAlbumName == " " ? (qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty) : album_basic_view.sAlbumName)
                 // } modified by wonseok.heo for ITS 197433 2013.10.28 // modified for iPod 2013.10.31
                 scrollingTicker: ( album_basic_view.scrollingTicker &&  album_basic_view.textIdx == 2 )|| ( album_basic_view.scrollingTicker &&  getOneLineScroll() <= 1 )
                 color: prBar.bTuneTextColor? MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT 
                                                        : MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY 
                 anchors
                 {
                     left: icon_album.left
                     leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                     verticalCenter: icon_album.top
                     verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                 }

                 fontSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT
                 fontFamily: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR

                 width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH// modified by yongkyun.lee 2013-09-16 for : ITS 189480
             }
        }

        Item
        {
            id: view_folder
//aettie for Main Player text scrolling 20130725
            property string viewText: text_folder.text;
            property bool scrolling: getTextLength(viewText) > text_folder.width? 1 : 0;
                
            visible: isVislbleFoler // added by eunkoo 2012.07.26 for CR11898
            height: view_main.height/4
            anchors.top: view_album.bottom

            Image
            {
                id: icon_folder
                source: "/app/share/images/music/basic_ico_folder.png"
                anchors.left: parent.left
            }
//aettie for Main Player text scrolling 20130725
            DHAVN_Marquee_Text
            {
            
                 id: text_folder
                //updateElide: album_basic_view.updateElide
		// modified by Dmitry 05.10.13 for ITS0193742
                text: album_basic_view.sFolderName == "" || album_basic_view.sFolderName == "STR_MEDIA_ROOT_FOLDER" ? (qsTranslate("main", "STR_MEDIA_ROOT_FOLDER") + LocTrigger.empty)
                                                                            : album_basic_view.sFolderName 

                 scrollingTicker: ( album_basic_view.scrollingTicker &&  album_basic_view.textIdx == 3 )|| ( album_basic_view.scrollingTicker &&  getOneLineScroll() <= 1 )
                 color: prBar.bTuneTextColor? MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT 
                                                        : MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY 
                 anchors
                 {
                     left: icon_folder.left
                     leftMargin: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_L_MARGIN
                     verticalCenter: icon_folder.top
                     verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_TITLE_VC_OFFSET
                 }

                 fontSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT
                 fontFamily: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR

                 width:  MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_ITEM_WIDTH// modified by yongkyun.lee 2013-09-16 for : ITS 189480
             }
        }
    }
// modified by Dmitry 05.05.13
    Item
    {
        id: view_genre

        height: 28
        visible: isVisibleGenre
        anchors.top: cover_basic.bottom                                  // added by dongjin 2012.08.14 for CR12351
        x:MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN   // added by dongjin 2012.08.14 for CR12351
        width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_INFO_WIDTH          // added by dongjin 2012.08.14 for CR12351
     Text
        {
            id: text_genre
            text: album_basic_view.sGenre

            color: MPC.const_APP_MUSIC_PLAYER_COLOR_SUB_TEXT_GREY       // added by dongjin 2012.08.14 for CR12351
            width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_INFO_WIDTH     // added by dongjin 2012.08.21 for NEW UX
            //font.pixelSize: 22
            font.pointSize: 22		//modified by aettie.ji 2012.11.28 for uxlaunch update
            font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR		// modified by Michael.Kim 2013.03.16 for new UX
            elide: "ElideRight"                                         // added by dongjin 2012.08.21 for NEW UX
        }
    }

    Item
    {
        id: view_composer

        height: 28
        visible: isVisibleComposer
        anchors.top: view_genre.bottom
        x:MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_COVER_BASE_LEFT_MARGIN   // added by dongjin 2012.08.14 for CR12351
        width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_INFO_WIDTH          // added by dongjin 2012.08.14 for CR12351
        Text
        {
            id: text_composer
            text: album_basic_view.sComposer

            color: MPC.const_APP_MUSIC_PLAYER_COLOR_SUB_TEXT_GREY       // added by dongjin 2012.08.14 for CR12351
            width: MPC.const_APP_MUSIC_PLAYER_ALBUM_VIEW_INFO_WIDTH     // added by dongjin 2012.08.21 for NEW UX
            font.pointSize:22		//modified by aettie.ji 2012.11.28 for uxlaunch update
            font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR		// modified by Michael.Kim 2013.03.16 for new UX
            elide: "ElideRight"                                         // added by dongjin 2012.08.21 for NEW UX
        }
    }

    Connections
    {
        target: EngineListener
        onMoreInfoChanged:
        {
            isVisibleGenre =  tmp;
            isVisibleComposer = tmp;
            __LOG("tmp = " + tmp);
        }
    }
    
    // { modified by kihyung 2013.08.08 for ITS 0183028 
    function mediaInfoChange(device, title, album, artist, genre, cover, composer, folder, filename)
    {
        //{ modified by yongkyun.lee 2013-10-18 for : 
        if(device == MP.BLUETOOTH )
            return
        //} modified by yongkyun.lee 2013-10-18 
        // { modified by cychoi 2015.03.19 for should show file name as OSD if title is Unknwon in Jukebox/USB mode
        if((AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.MP3_CD) ||
           (AudioController.PlayerMode == MP.JUKEBOX) ||
           (AudioController.PlayerMode == MP.USB1 || AudioController.PlayerMode == MP.USB2))
        {
            view_main.state = "state_known_album"
            if((title == " ") || (title == "") || (title == "Unknown") || (title == "Unknown Title"))
            {
                album_basic_view.sSongName = filename
            }
            else
            {
                album_basic_view.sSongName = title
            }
        }
        // } modified by cychoi 2015.03.19
        else
        {
            view_main.state = "state_known_album"
            album_basic_view.sSongName = title
        }         

        album_basic_view.sAlbumName         = album
        album_basic_view.sArtistName        = artist
        //{changed by junam 2013.08.30 for ITS_KOR_186080
        //album_basic_view.sFilesCount        = EngineListener.GetFilesCountInfo()
        album_basic_view.sFilesCount        = EngineListener.GetFilesCountInfo(device)
        //}changed by junam
        album_basic_view.sGenre             = genre
        album_basic_view.sComposer          = composer
        album_basic_view.sCoverAlbum        = cover
        // { modified by wonseok.heo 2013-19-20 for ITS 197065
        if((AudioController.PlayerMode == MP.DISC) &&( AudioController.DiscType == MP.MP3_CD)){
             if(folder != "")
                 album_basic_view.sFolderName        = folder
        }else{
            album_basic_view.sFolderName        = folder
        }
        // } modified by wonseok.heo 2013-19-20 for ITS 197065
        album_basic_view.isVisibleGenre     = AudioController.bShowInfo
        album_basic_view.isVisibleComposer  = AudioController.bShowInfo

        // { modified by cychoi 2016.03.30 for HMC IdeaBank Folder Name not displayed.
        //if((device == MP.DISC && AudioController.DiscType != MP.MP3_CD) || device == MP.IPOD1 || device == MP.IPOD2)
        //{
            album_basic_view.isVislbleFoler = false
        //}
        //else 
        //{ 
        //    album_basic_view.isVislbleFoler = true
        //}
        // } modified by cychoi 2016.03.30
    }
    // } modified by kihyung 2013.08.08 for ITS 0183028 

    // {added by Michael.Kim 2013.06.23 for cover image change issue
    function mediaInfoCDDAChange(  title,  album,  artist, genre,  composer,  folder,  filename)
    {
        view_main.state = "state_known_album";

        album_basic_view.sSongName          = (title == "") ? "Unknown" : title
        album_basic_view.sAlbumName         = (album == "") ? "" : album
        album_basic_view.sArtistName        = (artist == "") ? "" : artist
        album_basic_view.sFilesCount        = EngineListener.GetFilesCountInfo()
        album_basic_view.sGenre             = (genre=="") ? "Unknown" : genre
        album_basic_view.sComposer          = (composer=="") ? "Unknown" : composer
        album_basic_view.sFolderName        = folder
        album_basic_view.isVislbleFoler     = false
        album_basic_view.isVisibleGenre     = AudioController.bShowInfo
        album_basic_view.isVisibleComposer  = AudioController.bShowInfo
    }
    // {added by Michael.Kim 2013.06.23 for cover image change issue

    Connections
    {
        target: AudioController//modified by edo.lee 2013.05.01 update UI front rear view
        //(isFrontView == mediaPlayer.isCurrentFrontView) ? AudioController : null //modified by edo.lee 2013.04.04
		//{modified by edo.lee 2013.05.11
        onMediaInfoTempChanged:
        {
	//added by aettie.ji 20130904 for gracenote logo
            __LOG("receive onMediaInfoTempChanged signal");
	    //deleted for gracenote logo spec changed 20131008
            // {added by Michael.Kim 2013.06.23 for cover image change issue
            if(AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.AUDIO_CD)
                mediaInfoCDDAChange(  title,  album,  artist, genre,  composer,  folder,  filename);
            else
                mediaInfoChange(AudioController.PlayerMode,  title,  album,  artist, genre,  album_basic_view.sCoverAlbum ,  composer,  folder,  filename); // modified by sangmin.seol 2014.05.29 remain coverart during trackchange
                //mediaInfoChange(AudioController.PlayerMode,  title,  album,  artist, genre,  cover,  composer,  folder,  filename); // modified by kihyung 2013.08.08 for ITS 0183028
            // {added by Michael.Kim 2013.06.23 for cover image change issue

            //added by sangmin.seol 2014.09.15 ITS 0248490, 0248491 reset textIdx if mediainfo changed.
            album_basic_view.textIdx = 0;
            textScrollTimer.timerIdx = 0;
        }

        onMediaInfoChanged:
        {
         	// { modified by kihyung 2013.08.08 for ITS 0183028
            __LOG("receive onMediaInfoChanged signal " + device);
            mediaInfoChange( device, title,  album,  artist, genre,  cover,  composer,  folder,  filename);
            // } modified by kihyung 2013.08.08 for ITS 0183028

            //added by sangmin.seol 2014.09.15 ITS 0248490, 0248491 reset textIdx if mediainfo changed.
            album_basic_view.textIdx = 0;
            textScrollTimer.timerIdx = 0;
        }
        //}modified by edo.lee 2013.05.11
        
        //{ added by wonseok.heo 2013.05.17
        onMp3fileInfo:
        {
	//added by aettie.ji 20130904 for gracenote logo
	    //deleted for gracenote logo spec changed 20131008
            //{ modified by yongkyun.lee 2013-08-15 for :   NO CR  MP3 ID3-tag update
            album_basic_view.sCoverAlbum = m_coverart;
            album_basic_view.sArtistName = m_artist; 
            album_basic_view.sSongName = m_song;
            album_basic_view.sAlbumName = m_album; 
            //} modified by yongkyun.lee 2013-08-15 
            //album_basic_view.sFolderName = m_folder; // modified by wonseok.heo 2013-19-20 for ITS 197065
            album_basic_view.sFilesCount = m_countInfo;
        }
        //} added by wonseok.heo 2013.05.17

        onUpdateFolderName:
        {
            album_basic_view.sFolderName = folderName;
        }
    }
//aettie for Main Player text scrolling 20130725
    Connections
    {
        target:EngineListenerMain
        onTickerChanged:
        {
            __LOG("onTickerChanged ticker : " + ticker);
            album_basic_view.scrollingTicker = ticker;
        }
    }
    
    GestureArea
    {
        id: imageMouse_album
        anchors.fill: parent
        enabled: {
                    if (album_basic_view.visible && album_basic_view.gesture_enable) // modified by ravikanth 02-10-13 for ITS 0190988
                    {
                       if (optionMenuLoader.status == Loader.Ready && optionMenuLoader.item.visible)
                          return false
                       else if (popup_loader.status == Loader.Ready && popup_loader.item.visible)
                          return false
                       return true
                    }
                    return false
                 }
        property bool isCoverArt: false
        property bool pbAreaTouch: false // added by oseong.kwon 2014.12.16 for ITS 254650, ITS 254652
        property bool pbAreaPan: false // added by cychoi 2015.09.04 for ITS 268398 & ITS 268399

        Tap
        {
            // gesture area uses global mouse position hence need to minus 93 (staus bar height) and 72 (mode area height)
            onStarted:
            {
               imageMouse_album.pbAreaTouch = true // added by oseong.kwon 2014.12.16 for ITS 254650, ITS 254652
               if ((gesture.position.x >= cover_basic.x && gesture.position.x <= (cover_basic.x + cover_basic.sourceSize.width)) &&
                    (gesture.position.y - 93 - 72 >= cover_basic.y && (gesture.position.y - 93 - 72 <= cover_basic.y + cover_basic.sourceSize.height)) &&
                    screenTransitionDisableTimer.running == false   ) // added by junam 2013.11.22 for coverflow click
               {
                  imageMouse_album.isCoverArt = true
               }
            }

            onCanceled: imageMouse_album.isCoverArt = false //added by junam 2013.09.10

            onFinished:
            {
               imageMouse_album.pbAreaTouch = false // added by oseong.kwon 2014.12.16 for ITS 254650, ITS 254652
               if (imageMouse_album.isCoverArt)
               {
                   if(AudioListViewModel.isCategoryTabAvailable())
                   {
                       if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2 || // added for ITS 207832
                          AudioController.PlayerMode == MP.DISC) // added by cychoi 2013.11.18 for ITS 209814
                       {
                           __LOG("iPod & Disc. No Beep");
                       }
                       else
                       {
                           EngineListenerMain.ManualBeep(); //added by junam 2013.06.08 for add manual beep
                       }

                       screenTransitionDisableTimer.interval = 1000; //added by junam 2013.11.28 for ITS_NA_211655
                       screenTransitionDisableTimer.restart(); //added by junam 2013.11.22 for coverflow click
                       mediaPlayer.showPlayerView(false)
                   }
                   imageMouse_album.isCoverArt = false
               }
            }
        }

        Pan
        {
            // { added by cychoi 2015.09.04 for ITS 268398 & ITS 268399
            onStarted: imageMouse_album.pbAreaPan = false
            
            onUpdated: imageMouse_album.pbAreaPan = true
            // } added by cychoi 2015.09.04

            onFinished:
            {
                // { modified by cychoi 2015.09.04 for ITS 268398 & ITS 268399 // { modified by oseong.kwon 2014.12.16 for ITS 254650, ITS 254652
                if(mediaPlayer.state == "listView" || imageMouse_album.pbAreaTouch == false || imageMouse_album.pbAreaPan == false)
                {
                    imageMouse_album.pbAreaTouch = false
                    imageMouse_album.pbAreaPan = false
                    return; //[EU][ITS][180214][minor](aettie.ji)
                }
                imageMouse_album.pbAreaPan = false
                // } added by cychoi 2015.09.04 // } modified by oseong.kwon 2014.12.16
                //{added by junam for 2013.07.09 for ITS_171822 // modified 2013.12.11 ITS 214424
                if (Math.abs(gesture.offset.y) < 300 && (gesture.offset.x < -100 || gesture.offset.x > 100))
                {
                    if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE)) //changed by junam 2013.07.12 for music app
                    {
                        __LOG("controller disabled..");
                    } //}added by junam
                    else if (gesture.offset.x < -100) // modified by Dmitry 21.05.13  //modified by aettie 20130522 for Master car QE issue
                    {
                        mediaPlayer.nextTrack();
                    }
                    else if (gesture.offset.x > 100) // modified by Dmitry 21.05.13 //modified by aettie 20130522 for Master car QE issue
                    {
                        mediaPlayer.previousTrack(true);
                    }
                }
            }
        }
    }
// modified by Dmitry 11.05.13
}
