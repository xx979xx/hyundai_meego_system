import QtQuick 1.1
//import Transparency 1.0 //removed by junam 2013.09.30 for change raster
import Qt.labs.gestures 2.0
import QmlModeAreaWidget 1.0
import "DHAVN_AppPhoto_Constants.js" as CONST
//import QmlStatusBarWidget 2.0 // removed by kihyung 2012.12.15 for STATUSBAR_NEW
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0
import QmlStatusBar 1.0 //modified by edo.lee 2013.04.04
import "visual_cue"
//import QmlPopUpPlugin 1.0 // added by ravikanth 25-12-12
import "../video/popUp" // added by edo.lee 2013.01.17

//{changed by junam 2013.09.30 for change raster
//TransparencyPainter
Item //}changed by junam
{
    id: root
    clip: true
    width: CONST.const_SCREEN_WIDTH
    height: CONST.const_SCREEN_HEIGHT
    property variant focusEnum: { 'none': 0, 'status': 1, 'modeArea': 2, 'cue': 3, 'options': 4, 'popup': 5 }
    //modified by aettie 20130611 for ITS 172875 
    property variant photo_focus_index:(popup_screen.item && popup_screen.item.visible)? root.focusEnum.none : root.focusEnum.cue
    property bool photo_focus_visible: true //modified by aettie 2013.03.27 for Touch focus rule
    property bool isNext: true
    property int corruptedImages: 0
    property int popup_state: CONST.const_POPUP_ID_NONE
    property bool gestureBlocked: (popup_screen.item && popup_screen.item.visible) || option_menu.visible
    property int cur_source_id: CONST.const_JUKEBOX_SOURCE_ID
    property int cur_source_mask: CONST.const_SOURCE_JUKEBOX_MASK
    property int pre_source_id: CONST.const_JUKEBOX_SOURCE_ID
    property bool isRotate: false //added by yungi 2012.11.26 for No CR - Photo Roatateing,full backkey don't exit when Backkey
    property bool isFullscreen: false //added by yungi 2012.11.26 for No CR - Photo Roatateing,full backkey don't exit when Backkey
    property bool toastVisible : toast_popUp.visible // added by wspark 2013.03.11 for ISV 69413
    property bool bGoingToSearch : false // added by edo.lee 2013.03.22
    // property bool isOnInitializationState: true // modified by ravikanth 15-05-13
    property bool byFlick: false // added by Dmitry 15.04.13
    property bool scrollingTicker: true //EngineListenerMain.scrollingTicker; // modified by sangmin.seol 2014.08.04 ITS 0244649 //added by aettie 20130610 for ITS 172859 (ticker)
    property bool currentFrontScreen : true;//added by edo.lee 2013.07.03
    property bool panStarted: false; //[KOR][ITS][181688][minor](aettie.ji)
    // modified foy ITS 0207553, 0207551
    property bool pinchFinished: false; //added by Michael.Kim 2014.03.15 for ITS 229326
    property bool guesterPanUpdated: false // similar to property byFlick, but byFlick is not efficent on unsupported images as it reset on source image
    property url unsupportedImageUrl: "/app/share/images/photo/photo_icon_unsupported.png"
    property bool systemPopupVisible: false

    // { modified by edo.lee  2013.08.10 ITS 183057
    states:[
        State {
            name: "normal"
            PropertyChanges {
               target: visualCueLoader
               source: "./visual_cue/DHAVN_AppPhoto_VisualCue_Main.qml"
               anchors.topMargin: CONST.const_VISUAL_CUE_TOP_MARGIN
               anchors.leftMargin : CONST.const_VISUAL_CUE_LEFT_MARGIN
            }
            //PropertyChanges { target: statusBar; y: 0 }//modified by edo.lee 2013.04.04
            PropertyChanges { target: mode_area; y: CONST.const_MODE_AREA_WIDGET_Y  }
            PropertyChanges { target: fileName_item; anchors.bottomMargin: 8 } // added by cychoi 2015.11.24 for ITS 270267 (full screen animation)
            PropertyChanges { target: topbar_timer; running: true }
        },
        State {
            name: "rotation"
            PropertyChanges {
               target: visualCueLoader
               source: "./visual_cue/DHAVN_AppPhoto_VisualCue_Rotation.qml"
               anchors.topMargin: CONST.const_VISUAL_CUE_TOP_MARGIN
               anchors.leftMargin : CONST.const_VISUAL_CUE_LEFT_MARGIN
            }
            PropertyChanges { target: mode_area; y:  CONST.const_MODE_AREA_WIDGET_Y- CONST.const_FULL_SCREEN_OFFSET}//-CONST.const_MODE_AREA_WIDGET_Y }
            PropertyChanges { target: topbar_timer; running: false }
        },
        State {
            name: "zoom"
            PropertyChanges {
               target: visualCueLoader
               source: "./visual_cue/DHAVN_AppPhoto_VisualCue_Zoom.qml"
               anchors.topMargin : CONST.const_VISUAL_CUE_ZOOM_TOP_MARGIN
               anchors.leftMargin : CONST.const_VISUAL_CUE_ZOOM_LEFT_MARGIN
            }
           // PropertyChanges { target: statusBar; y: -CONST.const_STATUSBAR_WIDGET_Y  } 
            PropertyChanges { target: mode_area; y: CONST.const_MODE_AREA_WIDGET_Y- CONST.const_FULL_SCREEN_OFFSET }//-CONST.const_MODE_AREA_WIDGET_Y }
            PropertyChanges { target: topbar_timer; running: false }
        },
        State {
            name: "fullScreen"
           // PropertyChanges { target: statusBar; y: -CONST.const_STATUSBAR_WIDGET_Y   }
            PropertyChanges { target: mode_area; y:  CONST.const_MODE_AREA_WIDGET_Y- CONST.const_FULL_SCREEN_OFFSET } //-CONST.const_MODE_AREA_WIDGET_Y   }//modified by edo.lee 2013.08.09 fullscreen speed
            PropertyChanges {
               target: visualCueLoader
               source: "./visual_cue/DHAVN_AppPhoto_VisualCue_Main.qml"
               anchors.topMargin: CONST.const_VISUAL_CUE_TOP_MARGIN
               anchors.leftMargin : CONST.const_VISUAL_CUE_LEFT_MARGIN
            }
            PropertyChanges { target: visualCueLoader; anchors.topMargin: CONST.const_VISUAL_CUE_TOP_MARGIN + CONST.const_FULL_SCREEN_OFFSET  } //* 2 }
            PropertyChanges { target: fileName_item; anchors.bottomMargin: 8 - CONST.const_FULL_SCREEN_OFFSET } // added by cychoi 2015.11.24 for ITS 270267 (full screen animation)
            PropertyChanges { target: topbar_timer; running: false }
        }
        // } modified by edo.lee  2013.08.10 ITS 183057
    ]

    state: "normal"

    onStateChanged: {
       if(root.state === "rotation")
       {
          imageViewer.reset();
       }
       else if (root.state === "fullScreen")
       {
          if (imageViewer.imageLargerThanScreen)
             imageViewer.reset();
          photo_focus_index = root.focusEnum.cue
       }
       else if (root.state == "normal")
       {
           if(lockoutRect.visible)
               photo_focus_index = root.focusEnum.modeArea

           imageViewer.stopSlideShow()
           if(!visualCueLoader.enabled)
               visualCueLoader.enabled = true // added by Michael.Kim 2014.09.25 for ITS 249048
           // commented for ITS 0198359 26-10-13
           //added by edo.lee 2013.06.09
           //if(lockoutRect.visible)
           //    EngineListener.stopOtherViewSlideShow()
           //added by edo.lee 2013.06.09
       }

       EngineListenerMain.qmlLog( "[MP_Photo] state: " + state );
    }

    //added by edo.lee 2013.03.26
  Rectangle
    {
    	z:0
        anchors.fill:parent
        color: "black"
    }
  //added by edo.lee 2013.03.26
    Item {
        id:imageViewer
        width: CONST.const_SCREEN_WIDTH
        height: CONST.const_SCREEN_HEIGHT
        clip: true
        //LayoutMirroring.enabled: EngineListener.mirrorLayout // modified by ravikanth 04-05-13
        //LayoutMirroring.childrenInherit: EngineListener.mirrorLayout // modified by ravikanth 04-05-13
        LayoutMirroring.enabled: EngineListenerMain.middleEast // modified by aettie 20130514 for mode area layout mirroring
        LayoutMirroring.childrenInherit: EngineListenerMain.middleEast // modified by aettie 20130514 for mode area layout mirroring
        property int contentHeight: contentItem.height
        property int contentWidth: contentItem.width
        property alias interactive: contentMoveMouseArea.enabled
        property bool imageLargerThanScreen: ( contentItem.width > imageViewer.width || contentItem.height > imageViewer.height )
        property variant rotateDirections: { 'left': 0, 'right': 1 }
        property variant zoomDirections: { 'zoomIn': 0, 'zoomOut': 1 }
        property variant moveDirections: { 'left': 0, 'right': 1, 'up': 2, 'down': 3, 'upright': 4, 'downright': 5, 'upleft': 6, 'downleft': 7 } // modified by ravikanth 11.06.2013
        property real prevScale: 1
        property real pinchStartContentX: 0
        property real pinchStartContentY: 0
        property real mainImageScale: contentItem.imageScale  //added by aettie 20130531 zoom arrow
        property bool bFullScreenAnimation: true // added by cychoi 2016.01.25 for disable full screen animation
        Item
        {
            id: fileName_item
            z: 2
            clip: root.state == "zoom" // added by Radhakrushna for ISV 75307 on dated 9-mar-2013 .
            // { added by cychoi 2015.11.24 for ITS 270267 (full screen animation)
            visible: mode_area.mode_area_counter_total != 0
            //visible: root.state == "normal" && mode_area.mode_area_counter_total != 0
            // } added by cychoi 2015.11.24
            anchors.left: parent.left
            anchors.leftMargin: 21
            anchors.right: parent.right
            anchors.rightMargin: 21
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            // { added by cychoi 2015.11.24 for ITS 270267 (full screen animation)
            Behavior on anchors.bottomMargin {
                // { modified by cychoi 2016.01.25 for disable full screen animation
                PropertyAnimation {
                    duration: imageViewer.bFullScreenAnimation ? CONST.const_FULLSCREEN_DURATION_ANIMATION : 0
                    onRunningChanged:
                    {
                        if(!running && imageViewer.bFullScreenAnimation == false)
                            imageViewer.bFullScreenAnimation = true
                    }
                }
                // } modified by cychoi 2016.01.25
            }
            // } added by cychoi 2015.11.24

            DHAVN_AppPhoto_Marquee_Text
            {
                id: folderName_text
                text: EngineListener.folderName // modified for ITS 0215804
                scrollingTicker: true //EngineListenerMain.scrollingTicker // modified by sangmin.seol 2014.08.04 ITS 0244649
                // { modified by lssanh 2013.01.22 ITS149968
                color: "#FAFAFA"
                //fontSize: 30
                fontSize: 26		
                // } modified by lssanh 2013.01.22 ITS149968
                fontFamily: CONST.const_APP_PHOTO_FONT_FAMILY_NEW_HDB   
                style: Text.Outline;
                styleColor: "#000000"
                anchors.left: parent.left
                anchors.right: parent.right

                anchors.bottom: parent.bottom
                anchors.bottomMargin: 34 // added by lssanh 2013.01.22 ITS149968
            }

            DHAVN_AppPhoto_Marquee_Text
            {
                id: fileName_text
                text: EngineListener.getCurrentFileNameByPath(EngineListener.currentSource)
                scrollingTicker: true //root.scrollingTicker // modified by sangmin.seol 2014.08.04 ITS 0244649 //modified by aettie 20130610 for ITS 172859 (ticker)
                // { modified by lssanh 2013.01.22 ITS149968
                //color: "#9E9E9E"
                //fontSize: 26
                color: "#FAFAFA"
                fontSize: 30		
                // } modified by lssanh 2013.01.22 ITS149968
                fontFamily: CONST.const_APP_PHOTO_FONT_FAMILY_NEW_HDB   
                style: Text.Outline;
                styleColor: "#000000"
                
                anchors.left: parent.left
                anchors.right: parent.right

                anchors.bottom: parent.bottom
                // anchors.bottomMargin: 34 // deleted by lssanh 2013.01.22 ITS149968
            }
        }

        Text
        {
           visible: mode_area.mode_area_counter_total == 0
           text: (root.cur_source_id == CONST.const_JUKEBOX_SOURCE_ID) ? qsTranslate( CONST.const_APP_PHOTO_LANGCONTEXT,"STR_MEDIA_NO_DISPLAY_IMAGES" )
                                                                       : qsTranslate( CONST.const_APP_PHOTO_LANGCONTEXT,"STR_MEDIA_NO_IMAGE_IN_USB" ) // modified by ravikanth 10-05-13
           anchors.centerIn: parent
           color: "#FAFAFA"
           //font.pixelSize: 36
	   font.pointSize: 36	//modified by aettie.ji 2012.11.28 for uxlaunch update
            font.family: CONST.const_APP_PHOTO_FONT_FAMILY_NEW_HDB   
           style: Text.Outline;
           styleColor: "#000000"
        }

	// { modified by ravikanth 15-05-13
//        Text
//        {
//           visible: EngineListener.isUnsupportedFile
//           text: qsTranslate( CONST.const_APP_PHOTO_LANGCONTEXT,"STR_MEDIA_UNAVAILABLE_FORMAT" ) + LocTrigger.empty
//           anchors.centerIn: parent
//           color: "#FAFAFA"
//           //font.pixelSize: 36
//           font.pointSize: 36	//modified by aettie.ji 2012.11.28 for uxlaunch update
//            font.family: CONST.const_APP_PHOTO_FONT_FAMILY_NEW_HDB
//           style: Text.Outline;
//           styleColor: "#000000"
//	   // modified for ITS 0196040
//           onVisibleChanged:
//           {
//               if(root.cur_source_id != CONST.const_JUKEBOX_SOURCE_ID)
//                   EngineListener.photoMenuUpdate(root.cur_source_id)
//           }
//        }

        Image
        {
            id: unsupportedImage
            source: unsupportedImageUrl
            visible: EngineListener.isUnsupportedFile
            anchors.centerIn: parent
        }
        // } modified by ravikanth 15-05-13

//        PinchArea{
//           id: pinchArea
//            property real minScale:  1.0
//            anchors.fill: parent
//            property real lastScale: 1.0
//            pinch.target: mainImage
//            pinch.minimumScale: minScale
//            pinch.maximumScale: 3.0
//        }

        // modified by Michael.Kim 2014.07.21 to block to touch in status bar area & mode area
        GestureArea {
            id: gestureArea
            anchors.fill: parent
            enabled: !lockoutRect.visible // modified by ravikanth 05-10-13 for ITS 0193980, 0193988
            property int centerPointX: -1
            property int centerPointY: -1
            property int panStartNum: 0    // added by sungha.choi 2013.09.03 for ITS 0187536
            property bool isPanUpdate: false    // added by sungha.choi 2013.09.03 for ITS 0187536
            property bool isPanFinished: false    // added by sungha.choi 2013.09.03 for ITS 0187536
            property bool pbAreaTouch: false // added by Michael.Kim 2014.07.21 to block to touch in status bar area & mode area

            Timer { // added ITS 189019
                id: pan_timer
                interval: CONST.const_PAN_MAX_TIME
                running: false

                onTriggered:
                {
                    if (gestureArea.isPanFinished == true) {
                        panStarted = false;
                    }
                }
            }

            Tap {
               onStarted: {
                   EngineListenerMain.qmlLog("[MP_Photo] tapStarted gesture.position.x " + gesture.position.x + " gesture.position.y = " + gesture.position.y)
                   if (popup_screen.item && popup_screen.item.visible) return; //added by Michael.Kim 2014.03.25 for ITS 230404
                   if(root.state == "fullScreen" || (gesture.position.y > CONST.const_STATUSBAR_WIDGET_Y))
                       gestureArea.pbAreaTouch = true;
//                  root.photo_focus_visible = false
                  root.photo_focus_visible = true //modified by aettie 2013.03.27 for Touch focus rule
                   //topbar_timer.restart(); // removed by Michael.Kim 2014.04.15 for ITS 234571
                   topbar_timer.running = false // added by Michael.Kim 2014.04.15 for ITS 234571
                   // { added by cychoi 2015.11.02 for lets chance to initialize some local propertys of Gesture Area 
                   panStarted = false
                   pinchFinished = false
                   // } added by cychoi 2015.11.02
               }

               onFinished: {
                   topbar_timer.running = true // added by Michael.Kim 2014.04.15 for ITS 234571
                   gestureArea.pbAreaTouch = false;
                   EngineListenerMain.qmlLog("[MP_Photo] tapFinished")
               }
            }

            Pinch {
                property real previousScalingFactor: -1
                onStarted: {
                    if(EngineListener.isSlideShow || root.gestureBlocked || root.state == "rotation" || !gestureArea.pbAreaTouch) {
                        return
                    }
                    previousScalingFactor = mainImage.scale
                    imageViewer.interactive = false
                    visualCueLoader.enabled = false
                    topbar_timer.running = false
                    gestureArea.centerPointX = gesture.centerPoint.x
                    gestureArea.centerPointY = gesture.centerPoint.y
                    imageViewer.prevScale = mainImage.scale
                    imageViewer.pinchStartContentX = contentItem.x
                    imageViewer.pinchStartContentY = contentItem.y

                    // {added by Michael.Kim 2014.03.15 for ITS 229326
                    if(imageViewer.imageLargerThanScreen == true && root.state == "normal")
                        root.state = "zoom"
                    // }added by Michael.Kim 2014.03.15 for ITS 229326
                    EngineListenerMain.qmlLog("[MP_Photo] pinchStarted")
                }

                onUpdated: {
                    if(EngineListener.isSlideShow || root.gestureBlocked || root.state == "rotation" || !gestureArea.pbAreaTouch) {
                        return
                    }

                    var newScale = gesture.totalScaleFactor * previousScalingFactor
		    //modified by aettie for Master Car QE issue 20130523
                    if(newScale > 4 ) {
                        newScale = 4
                    } else if(newScale < 1) {
                        newScale = 1
                    }

                    mainImage.scale = newScale
                    preloading_mainImage.scale = newScale // modified for ITS 0190584
                    //EngineListenerMain.qmlLog("[MP_Photo] pinchUpdated")
                }
                onFinished: {
                    if(EngineListener.isSlideShow || root.gestureBlocked || root.state == "rotation" || !gestureArea.pbAreaTouch) {
                        return
                    }
                    imageViewer.interactive = true
                    visualCueLoader.enabled = true
                    topbar_timer.running = true
//                    gestureArea.centerPointX = -1
//                    gestureArea.centerPointY = -1
                    pinchFinished = true //added by Michael.Kim 2014.03.15 for ITS 229326
                    gestureArea.pbAreaTouch = false
                    EngineListenerMain.qmlLog("[MP_Photo] pinchFinished")
                }
            }
            Pan {
	    //[KOR][ITS][181688][minor](aettie.ji)
                onStarted:
                {
                    if(gestureArea.isPanFinished == true)    // { added by sungha.choi 2013.09.03 for ITS 0187536
                    {
                        gestureArea.panStartNum = 0   // for stable
                    }
                    gestureArea.panStartNum ++
                    gestureArea.isPanUpdate = false
                    gestureArea.isPanFinished = false    // } added by sungha.choi 2013.09.03 for ITS 0187536

                    panStarted = true;
                    pan_timer.restart();
                    EngineListenerMain.qmlLog("[MP_Photo] panStarted = " +panStarted);
                }
                onUpdated:    // { added by sungha.choi 2013.09.03 for ITS 0187536
                {
                    gestureArea.isPanUpdate = true  // gesture always occur this event in normal case.
                    //EngineListenerMain.qmlLog("[MP_Photo] panUpdated")
                }    // } added by sungha.choi 2013.09.03 for ITS 0187536
                onFinished:
                {
                    gestureArea.isPanFinished = true    // { added by sungha.choi 2013.09.03 for ITS 0187536
                    gestureArea.panStartNum --   // Only onStarted, onUpdated, onFinished is normal case
                    if(gestureArea.panStartNum == 0 && gestureArea.isPanUpdate == true)    // } added by sungha.choi 2013.09.03 for ITS 0187536
                    {
                        if( (root.state != "normal" && root.state != "fullScreen")
                              || EngineListener.isSlideShow
                              || root.gestureBlocked
                              || imageViewer.imageLargerThanScreen) {
                           guesterPanUpdated = true // modified foy ITS 0207553
                           panStarted = false
                           EngineListenerMain.qmlLog("[MP_Photo] panFinished #1")
                           return
                        }
                        // { modified by lssanh 2013.03.15 ITS159038
                        byFlick = true; // added by Dmitry 15.04.13
                        if(gestureArea.pbAreaTouch) {
                            if (gesture.offset.x > 75 && Math.abs(gesture.offset.y) < 300) { //modified by aettie 20130522 for Master car QE issue
                                guesterPanUpdated = true
                                imageViewer.previous()
                            } else if (gesture.offset.x < -75 && Math.abs(gesture.offset.y) < 300) { //modified by aettie 20130522 for Master car QE issue
                                guesterPanUpdated = true
                                imageViewer.next()
                            }
                            topbar_timer.restart(); //added by Michael.Kim 2014.04.23 for ITS 235608
                        }
                        else
                            topbar_timer.running =  true;
                        // } modified by lssanh 2013.03.15 ITS159038
                    }
                    else if(gestureArea.isPanUpdate == false)    // { added by sungha.choi 2013.09.03 for ITS 0187536
                    {
                        //panStarted = false // commented for ITS 0194404
                        onSingleClicked()   // this is not gesture (only tab)
                    }    // } added by sungha.choi 2013.09.03 for ITS 0187536
                    panStarted = false // modified for ITS 0194404
                    gestureArea.pbAreaTouch = false;
                    pinchFinished = false //added by Michael.Kim 2014.09.25 for ITS 249048
                    imageViewer.interactive = true // added by Michael.Kim 2014.09.04 for ITS 249048
                    if(!visualCueLoader.enabled)
                        visualCueLoader.enabled = true // added by Michael.Kim 2014.10.03 for ITS 249526
                    EngineListenerMain.qmlLog("[MP_Photo] panFinished #2")
                }
            }
        }
        // }modified by Michael.Kim 2014.07.21 to block to touch in status bar area & mode area

        Item {
            id: contentItem

            property real imageScale:mainImage.scale //added by aettie 20130531 zoom arrow
            
            width: {
                if(mainImage.rotation != 90 && mainImage.rotation != 270) {
                    return imageViewer.width > mainImage.width*mainImage.scale ? imageViewer.width : mainImage.width*mainImage.scale
                }
                return imageViewer.width > mainImage.height*mainImage.scale ? imageViewer.width : mainImage.height*mainImage.scale
            }
            height: {
                if(mainImage.rotation != 90 && mainImage.rotation != 270) {
                    return imageViewer.height > mainImage.height*mainImage.scale ? imageViewer.height : mainImage.height*mainImage.scale
                }
                return imageViewer.height > mainImage.width*mainImage.scale ? imageViewer.height : mainImage.width*mainImage.scale
            }
	    // { modified by ravikanth 08-04-13
            Image {
                id: preloading_mainImage
                source: EngineListener.isUnsupportedFile ? "" : EngineListener.getThumbnailName(EngineListener.currentSource) // modified by ravikanth 15-05-13
                anchors.centerIn: parent
                cache: false
                // added mainImage.status != Image.Ready for ITS 0186449, on Normal to Slideshow black image shown temporarily
                visible: !mainImage.visible && ( !EngineListener.isSlideShow || mainImage.status != Image.Ready ) && !EngineListener.isUnsupportedFile // modified by ravikanth 15-05-13
                //[EU][ITS][168157][ minor](aettie.ji)
	        onSourceSizeChanged: {
                    imageViewer.fitToSceneForPreLoading();
                }
            }
            Image {
                id: mainImage
                source: EngineListener.isUnsupportedFile ? "" : EngineListener.currentSource // modified by ravikanth 15-05-13
                anchors.centerIn: parent
                cache: false;
                visible: (status == Image.Ready) && !EngineListener.isUnsupportedFile && ( !EngineListener.isHighResolutionImage() || root.state === "zoom" || EngineListener.isSlideShow || (root.state === "normal" && imageViewer.imageLargerThanScreen)) // modified by ravikanth 13.06.2013 for ITS 0172957
                asynchronous: (preloading_mainImage.source != "") && !EngineListener.isSlideShow // modified by Dmitry 04.08.13 for photo crash during slideshow
                // } modified by ravikanth 08-04-13 //modified by Michael.Kim 2013.11.04 for Cooperational Hyundai Test
                onSourceSizeChanged: {
                    imageViewer.fitToScene();
                }
                onStatusChanged: {
                    EngineListenerMain.qmlLog("[MP_Photo] status = " +status);
                    if(status == Image.Error) {
                        // root.isOnInitializationState = true // commented by ravikanth 15-05-13
                       if (!EngineListener.isRunFromFileManager)
                       {
                          root.corruptedImages++
                          /*if (root.corruptedImages == EngineListener.GetCurrentPlayListCount())
                          {
                             root.corruptedImages = 0
                             switch (root.cur_source_id)
                             {
                             case CONST.const_USB1_SOURCE_ID:
                             case CONST.const_USB2_SOURCE_ID:
                                popup_screen.show(CONST.const_POPUP_ID_NO_IMAGE_FILES_IN_USB)
                                break;
                             case CONST.const_JUKEBOX_SOURCE_ID:
                             default:
                                popup_screen.show(CONST.const_POPUP_ID_NO_IMAGE_FILES_IN_JUKEBOX)
                                break;
                             }
                          }*/
                          if (root.corruptedImages != 1)
                          {
                              root.corruptedImages = 0
                              EngineListener.setUnsupportedOnImageLoadingError()
                          }
                          else
                          {
			  // modified by ravikanth 26-03-13
                              if(root.corruptedImages == 1)
                              {
                                  mainImage.source = ""
//                                  root.isNext ? imageViewer.next() : imageViewer.previous() // commented by Sergey 22.05.2013
                                  mainImage.source = function() { return EngineListener.currentSource }
                              }
                          }
                       }
                       else
                       {
                          popup_screen.show(CONST.const_POPUP_ID_UNAVAILABLE_FORMAT)
                       }
                    }
                    else if(status == Image.Ready) // modified by ravikanth 26-03-13
                    {
                        if(EngineListener.isSlideShow)
                            EngineListener.slideShowTimerReset(); //added by Michael.Kim 2014.11.03 for ITS 251728
                        // root.isOnInitializationState = false // commented by ravikanth 15-05-13
                        root.corruptedImages = 0
                    }
                }
                onSourceChanged: {
// modified by Dmitry 15.04.13
                   if (byFlick)
                   {
                      if(mainImage.status == Image.Ready)
                      {
                         mainImage.scale = 1;
                         mainImage.rotation = 0;
                      }
                      byFlick = false
                   }
                   else
                   {
                      imageViewer.reset()
                   }
// modified by Dmitry 15.04.13
                }
            }
        }

        MouseArea
        {
            id: contentMoveMouseArea

            enabled: !root.toastVisible // added by wspark 2013.03.11 for ISV 69413

            // { modified by Sergey 21.08.2013 for ITS#184097
            anchors.top: parent.top
            anchors.topMargin: mode_area.y + mode_area.height
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
			// } modified by Sergey 21.08.2013 for ITS#184097
			
			beepEnabled: false // added by Sergey 04.01.2014 for ITS#217286
			
            property real startX : 0
            property real startY : 0
            property real prevX : 0
            property real prevY : 0

            Timer {
                id: doubleTap_timer
                interval: CONST.const_DOUBLE_TAP_MAX_TIME_DELTA
                running: false

                onTriggered:
                {
                    contentMoveMouseArea.onSingleClicked();
                }
            }

            onClicked:
            {
                if(!guesterPanUpdated) // modified foy ITS 0207551
                    handleClick(mouseX, mouseY);
                guesterPanUpdated = false
            }

            onPressedChanged: {
                if(pressed) {
                    guesterPanUpdated = false
                    startX = mouseX;
                    startY = mouseY;
                } else {
                    startX = 0;
                    startY = 0;
                }
            }

            onMousePositionChanged: {
                if(pressed) {
                    if(startX == 0 && startY == 0) {
                        return;
                    }
                    var deltaX = (mouseX - startX);
                    var deltaY = (mouseY - startY);
                    if(contentItem.width > imageViewer.width) {
                        if((contentItem.x + deltaX) > 0) {
                            contentItem.x = 0
                        } else if((contentItem.x + deltaX) < (imageViewer.width-contentItem.width)) {
                            contentItem.x = (imageViewer.width-contentItem.width);
                        } else {
                            contentItem.x += deltaX;
                        }
                    }
                    if(contentItem.height > imageViewer.height) {
                        if((contentItem.y + deltaY) > 0) {
                            contentItem.y = 0
                        } else if((contentItem.y + deltaY) < (imageViewer.height-contentItem.height)) {
                            contentItem.y = (imageViewer.height-contentItem.height);
                        } else {
                            contentItem.y += deltaY;
                        }
                    }
                    startX = mouseX;
                    startY = mouseY;
                }
            }

            function onSingleClicked() {
                EngineListenerMain.qmlLog("[MP_Photo] onSingleClicked() panStarted = " + panStarted + " pinchFinished = " + pinchFinished);
                // { added by cychoi 2015.10.08 for ITS 269503
                if(panStarted || pinchFinished)
                {
                    //[KOR][ITS][181688][minor](aettie.ji)
                    if(panStarted)
                    {
                        // panStarted = false; // removed ITS 189019
                    }

                    // {added by Michael.Kim 2014.03.15 for ITS 229326
                    if(pinchFinished)
                    {
                        pinchFinished = false
                    }
                    // }added by Michael.Kim 2014.03.15 for ITS 229326

                    return;
                }
                // } added by cychoi 2015.10.08

                EngineListenerMain.ManualBeep(); // added by Sergey 04.01.2014 for ITS#217286

                // { modified by Sergey 10.09.2013 for ITS#184097
                if(!option_menu.visible)
                {
                    if(!imageViewer.imageLargerThanScreen) {
                        root.state = (root.state === "normal") ? "fullScreen" : "normal"
                    } else {
                        //restored by aettie 20130904 for ITS_185782
                        root.state = (root.state === "normal") ? "zoom" : "normal"
                        photo_focus_index = root.focusEnum.cue // added by Michael.Kim 2014.02.13 for ITS 225035
                    }
                }
                // } modified by Sergey 10.09.2013 for ITS#184097

                imageViewer.stopSlideShow()

            }

            function onDoubleClicked() {
                EngineListenerMain.qmlLog("[MP_Photo] onDoubleClicked()");
                if(panStarted)
                {
                    return;
                }

                if( root.state === "rotation" || EngineListener.m_isDRSShow) { // modified 01-09-13 for ITS 0187336
                    return
                }
                if(mainImage.scale == 1) {
                    imageViewer.zoomIn()
                } else {
                    root.state = "normal" // modified by eugene.seo 2012.12.11 for new UX Photo #3
                    imageViewer.reset()
                }
            }

            function handleClick( X, Y ) {
                EngineListenerMain.qmlLog("[MP_Photo] handleClick prevX = " +prevX+ " X = " +X+ " prevY = " +prevY+ " Y = " +Y);
                EngineListenerMain.qmlLog("[MP_Photo] handleClick doubleTap_timer.running: " +doubleTap_timer.running);
                if ( doubleTap_timer.running == false ) {
                    prevX = X
                    prevY = Y
                    doubleTap_timer.start()
                } else {
                    doubleTap_timer.stop()
                    if( ( Math.abs(prevX - X) <= CONST.const_DOUBLE_TAP_MAX_PIX_DELTA ) &&
                            ( Math.abs(prevY - Y) <= CONST.const_DOUBLE_TAP_MAX_PIX_DELTA ) )
                    {
                        //second tap on same area - handle double tap
                        onDoubleClicked()
                    } else {
                        onSingleClicked()
                        //second tap on another area is like first tap - again start doubleTap timer
                        doubleTap_timer.running = true

                        prevX = X
                        prevY = Y
                    }
                }
            }
        }

        onImageLargerThanScreenChanged: {
           if( root.state === "rotation" || EngineListener.isSlideShow) { // modified by ravikanth 03-06-13 for ITS 0177831
              return
           }
           // modified for ITS 0206480
           if(imageLargerThanScreen && mainImage.scale > 1) {
              root.state = "zoom"
           }
           else if(root.state != "fullScreen"){
              root.state = "normal"
           }
        }

        onContentWidthChanged: {
            if(contentItem.width > imageViewer.width) {
//               EngineListenerMain.qmlLog("[MP_Photo] imageViewer.imageCenterX*mainImage.scale: " + (imageViewer.imageCenterX));
//               EngineListenerMain.qmlLog("[MP_Photo] gestureArea.centerPointX: " + (gestureArea.centerPointX));
               if( gestureArea.centerPointX < 0) // modified by ravikanth 06-08-13 for ITS 0179050
                   {
                   return;
               }
               var tmpX = gestureArea.centerPointX - (gestureArea.centerPointX * mainImage.scale)/* - (gestureArea.centerPointX * imageViewer.prevScale - gestureArea.centerPointX)*/;
               if(tmpX > 0) {
                  contentItem.x = 0
               } else if(tmpX < (imageViewer.width-contentItem.width)) {
                  contentItem.x = (imageViewer.width-contentItem.width);
               } else {
                  contentItem.x = tmpX
               }
            } else {
                contentItem.x =(imageViewer.width - contentItem.width)/2;
            }
        }
        onContentHeightChanged: {
           if(contentItem.height > imageViewer.height) {
               if( gestureArea.centerPointY < 0) // modified by ravikanth 06-08-13 for ITS 0179050
                   {
                   return;
               }
              var tmpY = gestureArea.centerPointY - (gestureArea.centerPointY * mainImage.scale)/* - (gestureArea.centerPointY * imageViewer.prevScale - gestureArea.centerPointY)*/;
              if( tmpY > 0) {
                 contentItem.y = 0
              } else if(tmpY < (imageViewer.height-contentItem.height)) {
                 contentItem.y = (imageViewer.height-contentItem.height);
              } else {
                 contentItem.y = tmpY
              }
           } else {
              contentItem.y = (imageViewer.height - contentItem.height)/2;
           }
        }

        function rotate(direction) {
            if(EngineListener.isSlideShow) {
                return;
            }

            mainImage.scale = 1;
            if(direction == rotateDirections.left) {
                if(mainImage.rotation == 0)
                    mainImage.rotation = 270;
                else
                    mainImage.rotation -= 90;
            } else if(direction == rotateDirections.right) {
                if(mainImage.rotation == 270)
                    mainImage.rotation = 0;
                else
                    mainImage.rotation += 90;
            }
            fitToScene();
        }

        function fitToScene() {
            var aspectRatio = mainImage.sourceSize.width/mainImage.sourceSize.height;
            if(mainImage.rotation == 90 || mainImage.rotation == 270) {
                if(mainImage.sourceSize.width > imageViewer.height) {
                    mainImage.width = imageViewer.height;
                    mainImage.height = mainImage.width/aspectRatio;
                } else {
                    mainImage.height = mainImage.sourceSize.height;
                    mainImage.width = mainImage.sourceSize.width;
                }

                if(mainImage.height > imageViewer.width) {
                    mainImage.height = imageViewer.width;
                    mainImage.width = mainImage.height*aspectRatio;
                } else {
                    mainImage.height = mainImage.width/aspectRatio;
                }
            } else {
	    //[EU][ITS][168157][ minor](aettie.ji)
               // if(mainImage.sourceSize.height > imageViewer.height) {
                    mainImage.height = imageViewer.height;
                    mainImage.width = mainImage.height*aspectRatio;
                //} else {
                //    mainImage.height = mainImage.sourceSize.height;
                //    mainImage.width = mainImage.sourceSize.width;
               // }

                if(mainImage.width > imageViewer.width) {
                    mainImage.width = imageViewer.width;
                    mainImage.height = mainImage.width/aspectRatio;
                } else {
                    mainImage.width = mainImage.height*aspectRatio;
                }
            }
        }
	//[EU][ITS][168157][ minor](aettie.ji)
        function fitToSceneForPreLoading() 
        {
            var aspectRatio = preloading_mainImage.sourceSize.width/preloading_mainImage.sourceSize.height;

            preloading_mainImage.height = imageViewer.height;
            preloading_mainImage.width = preloading_mainImage.height*aspectRatio;

            if(preloading_mainImage.width > imageViewer.width) 
            {
                preloading_mainImage.width = imageViewer.width;
                preloading_mainImage.height = preloading_mainImage.width/aspectRatio;
            } 
            else 
            {
                preloading_mainImage.width = preloading_mainImage.height*aspectRatio;
            }
        }

        function next() {
            if(!lockoutRect.visible) { //modified by Michael.Kim 2013.12.18 for ITS 216261
                root.isNext = true
                // reset(); // removed by Dmitry 15.04.13
                // root.isOnInitializationState = false; // commented by ravikanth 15-05-13
                EngineListener.next();
                imageViewer.reset()//added by edo.lee 2013.05.27
            }
        }
        function previous() {
            if(!lockoutRect.visible) { //modified by Michael.Kim 2013.12.18 for ITS 216261
                root.isNext = false
                // reset(); // removed by Dmitry 15.04.13
                // root.isOnInitializationState = false; // commented by ravikanth 15-05-13
                EngineListener.previous();
                imageViewer.reset()//added by edo.lee 2013.05.27
            }
        }

        function zoomIn() {
            if(!EngineListener.isUnsupportedFile && !lockoutRect.visible) // modified by ravikanth 15-05-13 //modified by Michael.Kim 2013.12.18 for ITS 216261
            {
                //{ modified by eugene.seo 2012.12.11 for new UX Photo #3
                if(mainImage.scale <= 1)  //modified by aettie for Master Car QE issue 20130523
                    root.state = "normal";
                else
                    root.state = "zoom";
                //} modified by eugene.seo 2012.12.11 for new UX Photo #3
                imageViewer.cueZoom(imageViewer.zoomDirections.zoomIn);
            }
        }

        function zoomOut() {
            if(!EngineListener.isUnsupportedFile && !lockoutRect.visible) // modified by ravikanth 15-05-13 //modified by Michael.Kim 2013.12.18 for ITS 216261
            {
	    //modified by aettie for Master Car QE issue 20130523
                if(mainImage.scale <= 1)
                    root.state = "normal";
                else
                    root.state = "zoom";

               // root.state = "zoom"; // modified by eugene.seo 2012.12.11 for new UX Photo #3
                imageViewer.cueZoom(imageViewer.zoomDirections.zoomOut);
            }
        }

        function reset() {
            preloading_mainImage.scale = 1 // modified by ravikanth 08-04-13
            // {modified by Michael.Kim 2014.02.21 for ITS 226370
            mainImage.scale = 1;
            mainImage.rotation = 0;
            // }modified by Michael.Kim 2014.02.21 for ITS 226370
            if(mainImage.status == Image.Ready) {
              if (!EngineListener.isSlideShow && !lockoutRect.visible) // added by lssanh 2013.03.16 ISV76351
              {
                  root.state="normal"; //added by aettie 2013.03.05 for ISV 70011
              }
           }
        }

        // { added by Michael.Kim 2014.09.25 for ITS 249048
        function resetGesture() {
            root.panStarted = false
            gestureArea.isPanFinished = false
            gestureArea.panStartNum = 0
            gestureArea.pbAreaTouch = false
        }
        // } added by Michael.Kim 2014.09.25 for ITS 249048

        function startSlideShow() {
           if(!EngineListener.isSlideShow) {
              interactive= true; //added by hyejin 20150205 for ITS#257677
              resetGesture(); //added by hyejin 20150205 for ITS#257677
              reset();
              fitToScene();
              root.state = "fullScreen"
              EngineListener.isSlideShow = true;
           }
        }
        function stopSlideShow() {
           if(EngineListener.isSlideShow) {
              reset();
              fitToScene();
              EngineListener.isSlideShow = false;
              fadeInOutAnimation.stop();
              mainImage.opacity = 1.0;
           }
        }
        function save() {
            var tmpRotation = mainImage.rotation;
            imageViewer.reset();
            EngineListener.save(tmpRotation);
        }
//{modified by aettie for Master Car QE issue 20130523
        function cueZoom(direction) {
            if(EngineListener.isSlideShow) {
                return;
            }
	    
	    // modified by ravikanth 06-08-13 for ITS 0179050
            gestureArea.centerPointX = -1
            gestureArea.centerPointY = -1

            mainImage.rotation = 0;
            var tmpScale = mainImage.scale < 1 ? 1 : mainImage.scale;

            if(direction == imageViewer.zoomDirections.zoomIn)
            {
                tmpScale++;
                if(tmpScale > 4) {
                    tmpScale = 4;
                }
                if(tmpScale == -1 || tmpScale == 0) {
                    tmpScale = 1;
                }
            } else if(direction == imageViewer.zoomDirections.zoomOut) {
                tmpScale--;
                if(tmpScale < 1) {
                    tmpScale = 1;
                }
            }

            var oldHeight = contentItem.height;
            var oldWidth = contentItem.width;
            mainImage.scale = tmpScale < 1 ? 1  : tmpScale;
            var tmpX  = mainImage.scale > 1 ? ( contentItem.x - (contentItem.width - oldWidth)/2 ) : 0;
            var tmpY  = mainImage.scale > 1 ? ( contentItem.y - (contentItem.height - oldHeight)/2 ) : 0 ;
            if(tmpX > 0) {
                 contentItem.x = 0
            }
            else if (tmpX < (imageViewer.width - contentItem.width)) {
                contentItem.x = imageViewer.width - contentItem.width
            }
            else {
                contentItem.x = tmpX
            }

            if(tmpY > 0) {
                 contentItem.y = 0
            }
            else if (tmpY < (imageViewer.height - contentItem.height)) {
                contentItem.y = imageViewer.height - contentItem.height
            }
            else {
                contentItem.y = tmpY
            }
            // EngineListenerMain.qmlLog("[MP_Photo] zoom content x: "+contentItem.x +" y: "+contentItem.y )
            cueZoomLoadingImg(direction) // modified by ravikanth 08-04-13
        }
	// { modified by ravikanth 08-04-13
        function cueZoomLoadingImg(direction) {
            var tmpScale = preloading_mainImage.scale < 1 ? 1 : preloading_mainImage.scale;

            if(direction == imageViewer.zoomDirections.zoomIn)
            {
                tmpScale++;
                if(tmpScale > 4) {
                    tmpScale = 4;
                }
                if(tmpScale == -1 || tmpScale == 0) {
                    tmpScale = 1;
                }
            } else if(direction == imageViewer.zoomDirections.zoomOut) {
                tmpScale--;
                if(tmpScale < 1) {
                    tmpScale = 1;
                }
            }

            preloading_mainImage.scale = tmpScale < 0 ? 1 : tmpScale;
        }
	// } modified by ravikanth 08-04-13
//}modified by aettie for Master Car QE issue 20130523
        function cueMove(direction) {
           var tmpMove
           var tmpMove_x // modified by ravikanth 11.06.2013
           var tmpMove_y
	   // modified by ravikanth 17-08-13 for hotfix
           var xFactor = mainImage.sourceSize.width/100
           var yFactor = mainImage.sourceSize.height/100
           xFactor = xFactor < 15 ? 15 : xFactor
           yFactor = yFactor < 15 ? 15 : yFactor
           switch(direction) {
           case imageViewer.moveDirections.left:
           case imageViewer.moveDirections.right:
              if(direction == imageViewer.moveDirections.left) {
                 tmpMove = contentItem.x + xFactor;
              } else {
                 tmpMove = contentItem.x - xFactor;
              }
              if(tmpMove > 0) {
                  contentItem.x = 0
              } else if(tmpMove < (imageViewer.width-contentItem.width)) {
                  contentItem.x = (imageViewer.width-contentItem.width);
              } else {
                 contentItem.x = tmpMove
              }
              break;

           case imageViewer.moveDirections.up:
           case imageViewer.moveDirections.down:
              if(direction == imageViewer.moveDirections.up) {
                 tmpMove = contentItem.y + yFactor;
              } else {
                 tmpMove = contentItem.y - yFactor;
              }
              if(tmpMove > 0) {
                  contentItem.y = 0
              } else if(tmpMove < (imageViewer.height-contentItem.height)) {
                  contentItem.y = (imageViewer.height-contentItem.height);
              } else {
                 contentItem.y = tmpMove
              }
              break;
	      // { modified by ravikanth 11.06.2013
           case imageViewer.moveDirections.upright:
           case imageViewer.moveDirections.downright:
           case imageViewer.moveDirections.upleft:
           case imageViewer.moveDirections.downleft:
               if(direction == imageViewer.moveDirections.upright) {
                   tmpMove_x = contentItem.x - xFactor;
                   tmpMove_y = contentItem.y + yFactor;
               }
               else if(direction == imageViewer.moveDirections.downright) {
                   tmpMove_x = contentItem.x - xFactor;
                   tmpMove_y = contentItem.y - yFactor;
               }
               else if(direction == imageViewer.moveDirections.upleft) {
                   tmpMove_x = contentItem.x + xFactor;
                   tmpMove_y = contentItem.y + yFactor;
               }
               else {
                   tmpMove_x = contentItem.x + xFactor;
                   tmpMove_y = contentItem.y - yFactor;
               }

               if(tmpMove_x > 0) {
                   contentItem.x = 0
               } else if(tmpMove_x < (imageViewer.width-contentItem.width)) {
                   contentItem.x = (imageViewer.width-contentItem.width);
               } else {
                  contentItem.x = tmpMove_x
               }
               if(tmpMove_y > 0) {
                   contentItem.y = 0
               } else if(tmpMove_y < (imageViewer.height-contentItem.height)) {
                   contentItem.y = (imageViewer.height-contentItem.height);
               } else {
                  contentItem.y = tmpMove_y
               }
	       // } modified by ravikanth 11.06.2013
           }
        }

        function getImageResolution() {
            return mainImage.sourceSize.width + "x" + mainImage.sourceSize.height;
        }

        SequentialAnimation {
            id: fadeInOutAnimation
            PauseAnimation { duration: 1000 } //added by Michael.Kim 2013.10.23 for removed slide show animation effect by Hyundai Request
            //{removed by Michael.Kim 2013.10.23 for removed slide show animation effect by Hyundai Request
            /*NumberAnimation {
                target: mainImage
                property: "opacity"
                duration: 1000
                //from: 1.0 //removed by Michael.Kim 2013.10.23 for removed slide show animation effect by Hyundai Request
                //to: 0.0 //removed by Michael.Kim 2013.10.23 for removed slide show animation effect by Hyundai Request
            }*/
            //}removed by Michael.Kim 2013.10.23 for removed slide show animation effect by Hyundai Request
            ScriptAction {
                script: {
                    imageViewer.reset();
                    EngineListener.next();
                }
            }
            PauseAnimation { duration: 1000 } //added by Michael.Kim 2013.10.23 for removed slide show animation effect by Hyundai Request
            //{removed by Michael.Kim 2013.10.23 for removed slide show animation effect by Hyundai Request
            /*NumberAnimation {
                target: mainImage
                //property: "opacity"
                duration: 1000
                //from: 0.0
                //to: 1.0
            }*/
            //}removed by Michael.Kim 2013.10.23 for removed slide show animation effect by Hyundai Request
        }
    }
	//added by edo.lee 2013.07.03
    Connections
    {
    	target:EngineListener
    	onPhotoIsFront:
    	{
    		root.currentFrontScreen = isFront;
    	}
    }
    //added by edo.lee 2013.07.03
    Connections
    {
        target: EngineListener//root.currentFrontScreen == isFrontView ? EngineListener : null

        onSlideShowNext:
        {
            fadeInOutAnimation.start();
        }

        //{added by edo.lee 2012.08.24
        onBacktoPrev:
        {
           // EngineListenerMain.qmlLog( "[MP_Photo] onBacktoPrev" )
           handleUpdateSource( pre_source_id, sourceMask )
        }
        //}added by edo.lee

        onPhotoRequestFG:
        {
            EngineListenerMain.qmlLog( "[MP_Photo] onPhotoRequestFG "+bGoingToSearch );
            if(mainImage.status == Image.Error)
                EngineListener.setUnsupportedOnImageLoadingError() // added by Michael.Kim 2014.08.22 for ITS 246028
            // EngineListener.photoMenuUpdate(root.cur_source_id) //remove by edo.lee 2013.08.25 
            // modified by ravikanth 30.06.13 for ITS 0177326.. moved photo_focus_visible before bGoingToSearch check made below
            photo_focus_visible = true; // modified by Dmitry 15.05.13
            // modified by ravikanth 11-07-13 for ITS 0179160
            topbar_timer.restart(); // added by Dmitry 23.07.13
            if(bGoingToSearch /*|| retainPreviousState*/) // modified by cychoi 2016.01.25 for should switch to Normal screen when clsoed DRS popup
            { // modified by edo.lee 2013.08.29
                if(bGoingToSearch == false){                 
                    if (option_menu.visible) option_menu.quickHide() 
                    //EngineListener.photoMenuUpdate(root.cur_source_id); // removed by Michael.Kim 2014.09.19 for ITS 248635
                }
                /*if(!option_menu.visible && !lockoutRect.visible) // modifid by edo.lee 2013.09.06 show option menu
                                photo_focus_index = root.focusEnum.cue
                            else if(lockoutRect.visible)
                                photo_focus_index = root.focusEnum.modeArea*/
                if(lockoutRect.visible)//modifid by taihyun.ahn for ITS 019472
                {
                    // { modified by hyejin.noh 2015.02.05 for ITS 257651
                    if(root.state === "fullScreen")
                        photo_focus_index = root.focusEnum.cue
                    else
                        photo_focus_index = root.focusEnum.modeArea
                    // } modified by hyejin.noh 2015.02.05
                }
                gestureArea.enabled = !lockoutRect.visible // added by cychoi 2015.11.02 for ITS 269978
                EngineListener.photoMenuUpdate(root.cur_source_id); // added by Michael.Kim 2014.09.19 for ITS 248635
                return; //added by edo.lee 2013.03.22
            }// modified by edo.lee 2013.08.29

           root.state = "normal"
           imageViewer.interactive = true // added by Michael.Kim 2014.09.04 for ITS 248020
           imageViewer.resetGesture() // added by Michael.Kim 2014.09.25 for ITS 249048
           imageViewer.reset()
           gestureArea.enabled = !lockoutRect.visible // modified by cychoi 2015.11.02 for ITS 269978 // added by Michael.Kim 2014.10.06 for ITS 249770
           if((popup_screen.item && popup_screen.item.visible) && EngineListener.isRunFromFileManager)
           {
               photo_focus_index = root.focusEnum.popup
           }
           else
           {
               if (popup_screen.item && popup_screen.item.visible) popup_screen.item.visible = false
	       // modified by ravikanth 05-10-13 for ITS 0193980, 0193988
               if(!lockoutRect.visible)
                   photo_focus_index = root.focusEnum.cue
               else
                   photo_focus_index = root.focusEnum.modeArea
           }
           if (option_menu.visible) option_menu.quickHide()  // modified by Sergey 02.08.2103 for ITS#181512
           // removed by Dmitry 23.07.13
              EngineListener.photoMenuUpdate(root.cur_source_id) //added by edo.lee 2013.08.25 showing 2-depth menu on FG,  crash occurs
           // { added by cychoi 2016.01.25 for disable full screen animation
           imageViewer.bFullScreenAnimation = false
           mode_area.bFullScreenAnimation = false
           visualCueLoader.bFullScreenAnimation = false
           // } added by cychoi 2016.01.25

           // { commented by ravikanth 15-05-13
//           if(mainImage.status == Image.Ready) {
//               root.isOnInitializationState = false
//           }
//           else if(mainImage.status == Image.Error)
//           {
//               switch (root.cur_source_id)
//               {
//               case CONST.const_USB1_SOURCE_ID:
//               case CONST.const_USB2_SOURCE_ID:
//                   popup_screen.show(CONST.const_POPUP_ID_NO_IMAGE_FILES_IN_USB)
//                   break;
//               case CONST.const_JUKEBOX_SOURCE_ID:
//               default:
//                   popup_screen.show(CONST.const_POPUP_ID_NO_IMAGE_FILES_IN_JUKEBOX)
//                   break;
//               }
//           }
           // } commented by ravikanth 15-05-13
        }

        onPhotoDRSModeON:
        {
        	EngineListenerMain.qmlLog("[MP PhotoPopup] show DRS popup on event ")
        	photo_focus_visible = true // modified by edo.lee 2013.03.05
        	imageViewer.stopSlideShow();
        	isRotate = false  
        	isFullscreen = false 
                //root.state = "normal"
          	//modified by edo.lee 2013.05.24
            //popup_screen.show( CONST.const_POPUP_ID_DRS )
            lockoutRect.visible = true;
            visualCueLoader.visible = false;
            //modified by edo.lee 2013.05.24
	    // modified by ravikanth 05-10-13 for ITS 0193980, 0193988
            if(photo_focus_index == root.focusEnum.cue && root.state != "fullScreen") // modified by hyejin.noh 2015.02.05 for ITS 257651
            {
                photo_focus_index = root.focusEnum.modeArea
                mode_area.setDefaultFocus(UIListenerEnum.JOG_UP)
            }
            imageViewer.resetGesture() // added by Michael.Kim 2014.09.25 for ITS 249048
        }
        //{added by yongkyun.lee 2012.12.03 for photo DRS from VR.
        onPhotoDRSModeOFF:
        {
            // root.isOnInitializationState = true // commented by ravikanth 15-05-13
            //if(popup_screen.item && popup_screen.item.visible
            //&&  popup_state == CONST.const_POPUP_ID_DRS ) // modified by edo.lee 2013.03.05
            // {
            EngineListenerMain.qmlLog("[MP PhotoPopup] close DRS popup on event ")
            //if(!option_menu.visible) // modifid by edo.lee 2013.09.06 show option menu
            //	photo_focus_index = root.focusEnum.cue
            //modified by edo.lee 2013.05.24
            //popup_screen.item.hide();
            //  popup_state = CONST.const_POPUP_ID_NONE // added by edo.lee 2013.03.05
            lockoutRect.visible = false;
            if(visualCueLoader.visible == false)
                visualCueLoader.visible = true;
            //modified by edo.lee 2013.05.24
            // }
	    // modified by ravikanth 05-10-13 for ITS 0193980, 0193988
            /*if(photo_focus_index == root.focusEnum.modeArea)//removed by taihyun.ahn 0194172
            {
                photo_focus_index = root.focusEnum.cue
            }*/
            imageViewer.interactive = true // added by Michael.Kim 2014.09.25 for ITS 249048
            topbar_timer.restart() // added by cychoi 2015.12.28 for restart full screen timer
        }
        //}added by yongkyun.lee 
        
        onCloseMenu:
        {            
            //if (option_menu.visible == true)
            {         
                option_menu.hideMenu(false);
            }

        }

        onPhotoUpdateSource:
        {
           // EngineListenerMain.qmlLog( "[MP_Photo] onPhotoUpdateSource" )
           handleUpdateSource( sourceId, sourceMask )
        }

        onPhotoKeyMenuReleased:
        {
           // { modified by dongjin 2012.11.30
           if(lockoutRect.visible)//added by edo.lee 2013.09.07  ITS 187822
		       return;
           // EngineListenerMain.qmlLog( "[MP_Photo] onPhotoKeyMenuReleased" )
           if (popup_screen.item)
           {
              if(popup_screen.item.visible)
                 return;
           }

// modified by Dmitry 26.04.13
           if (option_menu.visible == true)
           {
               option_menu.hide()
           }
           else
           {
              root.photo_focus_index = root.focusEnum.options
              option_menu.showMenu() // modified by Sergey 02.08.2103 for ITS#181512
           }

           if (nKeyType)
           {
              photo_focus_visible = true;
           }
           if (option_menu.visible)
           {
              imageViewer.stopSlideShow()
              root.state = "normal"
              option_menu.setDefaultFocus(UIListenerEnum.JOG_DOWN)
           }
// modified by Dmitry 26.04.13
        }

        onPhotoKeyBackPressed:
        {
           // EngineListenerMain.qmlLog( "[MP_Photo] onPhotoKeyBackPressed" )
           root.backHandler()
        }

        onNoImageFile:
        {
           // EngineListenerMain.qmlLog( "[MP_Photo] onNoImageFile " + sourceId )
           switch( sourceId )
           {
              case CONST.const_JUKEBOX_SOURCE_ID:
              {
                 popup_screen.show( CONST.const_POPUP_ID_NO_IMAGE_FILES_IN_JUKEBOX )
              }
              break

              case CONST.const_USB1_SOURCE_ID:
              case CONST.const_USB2_SOURCE_ID:
              {
                 popup_screen.show( CONST.const_POPUP_ID_NO_IMAGE_FILES_IN_USB )
              }
              break
           }
        }

        onUsbPluggedOut:
        {
           // EngineListenerMain.qmlLog( "[MP_Photo] onUsbPluggedOut " )
           //{ added by yongkyun.lee 20130401 for : ISV 78014
           if( (root.cur_source_id == newSourceID )   && EngineListener.isSlideShow ) 
               imageViewer.stopSlideShow()
           //if( EngineListener.isSlideShow ) imageViewer.stopSlideShow()
           //} added by yongkyun.lee 20130401 
        }

        onShowErrorPopup:
        {
            // EngineListenerMain.qmlLog( "[MP_Photo] onShowErrorPopup" )
            if(EngineListener.isRunFromFileManager)
                popup_screen.show( CONST.const_POPUP_ID_UNAVAILABLE_FORMAT )
            // { removed by kihyung 2013.3.19. getIsNewSource() is removed by edo.lee
            /* 
            else if(EngineListener.getIsNewSource())
            {
              popup_screen.show( CONST.const_POPUP_ID_UNAVAILABLE_FORMAT )
            }
            */
            // } removed by kihyung 2013.3.19. getIsNewSource() is removed by edo.lee            
        }
	// { modified by ravikanth 23-04-13 ISV 80359
        onPhotoUIHidden:
        {
            if(EngineListener.uiHidden)
            {
	    // modified by ravikanth 04-07-13 for not to set focus on cue control when modearea list clicked
                // EngineListenerMain.qmlLog( "[MP_Photo] onPhotoUIHidden " )
		// modified by ravikanth 11-07-13 for ITS 0179160
                bGoingToSearch = false; // reset on background
                photo_focus_visible = false;
                if( popup_screen.item && popup_screen.item.visible)
                {
                    //photo_focus_index = root.focusEnum.cue // removed by Michael.Kim 2014.02.13 for ITS 224751
                    //popup_screen.item.hide() // removed by Michael.Kim 2014.02.13 for ITS 224751
                }
                visualCueLoader.item.reset() // added by Dmitry for ITS0179888
                // modified by ravikanth 21-08-13 for ITS 0185238
                //state = "normal" // added by Dmitry 16.07.13 for ITS0180264
                topbar_timer.stop(); // added by Dmitry 16.07.13 for ITS0180264
            }
        }
	// } modified by ravikanth 23-04-13 ISV 80359
	// { modified by ravikanth 28-04-13
        onHandleAllUnsupportedFiles:
        {
            // modified by ravikanth for ITS 0186038
//            (root.cur_source_id == mediaSource)
//            {
//                switch (root.cur_source_id)
//                {
//                case CONST.const_USB1_SOURCE_ID:
//                case CONST.const_USB2_SOURCE_ID:
//                    popup_screen.show(CONST.const_POPUP_ID_NO_IMAGE_FILES_IN_USB)
//                    break;
//                case CONST.const_JUKEBOX_SOURCE_ID:
//                default:
//                    popup_screen.show(CONST.const_POPUP_ID_NO_IMAGE_FILES_IN_JUKEBOX)
//                    break;
//                }
//            }
        }
	// } modified by ravikanth 28-04-13

		// removed by Sergey 22.05.2013
        // {added by Michael.Kim 2013.10.11 for ITS 194857
        onDefaulControlCue:
        {
            root.state = "normal"
        }
        // }added by Michael.Kim 2013.10.11 for ITS 194857

	// modified for ITS 0217509
        onCloseCopyCancelConfirmPopup:
        {
            EngineListenerMain.qmlLog("[Photo] onCloseCopyCancelConfirmPopup")
            if(popup_screen.status == Loader.Ready)
            if( popup_screen.item && popup_screen.item.visible ) {
                if(root.popup_state == CONST.const_POPUP_ID_COPY_TO_JUKEBOX_PROGRESS)
                {
                    popup_screen.item.hide()
                    photo_focus_index = root.focusEnum.cue
                    photo_focus_visible = true;
                }
            }
        }
    }

    function handleUpdateSource( source_id, source_mask )
    {
       EngineListenerMain.qmlLog("[MP_Photo] handleUpdateSource source_id = " + source_id + "source_mask = " + source_mask)

       // modified by kihyung 2013.3.19 for ISV 67749
       // added by eugene.seo 2013.02.05 for usb image display with no jukebox images
       if( source_id != cur_source_id  || mode_area.mode_area_counter_total == 0 || EngineListener.isSwitchFromRestore() == true) 
       {
          EngineListener.setIsSwitchFromRestore( false );
          // EngineListener.SwitchMode( source_id ) // modified by ravikanth 18.06.13 for ITS 0173604
       }

       pre_source_id = cur_source_id
       cur_source_id = source_id
       cur_source_mask = source_mask
       root.isNext = true
       root.corruptedImages = 0
//[KOR][ITS][180278](aettie.ji)
       if( ( source_mask & CONST.const_SOURCE_USB1_MASK )&&( source_mask & CONST.const_SOURCE_USB2_MASK ) )
       {
            if ( source_id == CONST.const_USB1_SOURCE_ID ){
                if(!EngineListenerMain.GetVariantRearUSB()){
                    mode_area.modeAreaModel.set( 0, { isVisible: false } )
                    mode_area.modeAreaModel.set( 1, { isVisible: false } )
                    mode_area.modeAreaModel.set( 2, { isVisible: false } )
                    mode_area.modeAreaModel.set( 3, { isVisible: true } )
                }else{
                    mode_area.modeAreaModel.set( 0, { isVisible: false } )
                    mode_area.modeAreaModel.set( 1, { isVisible: true } )
                    mode_area.modeAreaModel.set( 2, { isVisible: false } )
                    mode_area.modeAreaModel.set( 3, { isVisible: false } )
                }
            }
            else {
                if(!EngineListenerMain.GetVariantRearUSB()){
                    mode_area.modeAreaModel.set( 0, { isVisible: false } )
                    mode_area.modeAreaModel.set( 1, { isVisible: false } )
                    mode_area.modeAreaModel.set( 2, { isVisible: false } )
                    mode_area.modeAreaModel.set( 3, { isVisible: true } )
                }else{
                    mode_area.modeAreaModel.set( 0, { isVisible: false } )
                    mode_area.modeAreaModel.set( 1, { isVisible: false } )
                    mode_area.modeAreaModel.set( 2, { isVisible: true } )
                    mode_area.modeAreaModel.set( 3, { isVisible: false } )
                }
            }
            if((source_mask & CONST.const_SOURCE_JUKEBOX_MASK) && (source_id == CONST.const_JUKEBOX_SOURCE_ID))
            {
               mode_area.modeAreaModel.set( 0, { isVisible: true } )
               mode_area.modeAreaModel.set( 1, { isVisible: false } )
               mode_area.modeAreaModel.set( 2, { isVisible: false } )
               mode_area.modeAreaModel.set( 3, { isVisible: false } ) 
            }

            if(source_id == CONST.const_JUKEBOX_SOURCE_ID)
            {
               mode_area.currentSelectedIndex = 0
            }else if(source_id == CONST.const_USB1_SOURCE_ID)
            {
               mode_area.currentSelectedIndex = 1
            }else if(  source_id == CONST.const_USB2_SOURCE_ID)
            {
               mode_area.currentSelectedIndex = 2
            }
       }
       else if (  source_mask & CONST.const_SOURCE_USB1_MASK  )
       {
          /** only one USB connected */
          // EngineListenerMain.qmlLog("[MP_Photo] One usb: 1")
            if(!EngineListenerMain.GetVariantRearUSB()){
                mode_area.modeAreaModel.set( 0, { isVisible: false } )
                mode_area.modeAreaModel.set( 1, { isVisible: false } )
                mode_area.modeAreaModel.set( 2, { isVisible: false } )
                mode_area.modeAreaModel.set( 3, { isVisible: true } )
            }else{
                mode_area.modeAreaModel.set( 0, { isVisible: false } )
                mode_area.modeAreaModel.set( 1, { isVisible: true } )
                mode_area.modeAreaModel.set( 2, { isVisible: false } )
                mode_area.modeAreaModel.set( 3, { isVisible: false } )
            }

          if((source_mask & CONST.const_SOURCE_JUKEBOX_MASK) && (source_id == CONST.const_JUKEBOX_SOURCE_ID))
          {
            EngineListenerMain.qmlLog("[MP_Photo] handleUpdateSource source_id = " + source_id + "source_mask = " + source_id)
            mode_area.modeAreaModel.set( 0, { isVisible: true } )
            mode_area.modeAreaModel.set( 1, { isVisible: false } )
            mode_area.modeAreaModel.set( 2, { isVisible: false } )
            mode_area.modeAreaModel.set( 3, { isVisible: false } )
          }

       }
        else if (  source_mask & CONST.const_SOURCE_USB2_MASK  )
       {
          /** only one USB connected */
          // EngineListenerMain.qmlLog("[MP_Photo] One usb : 2")
            if(!EngineListenerMain.GetVariantRearUSB()){
                mode_area.modeAreaModel.set( 0, { isVisible: false } )
                mode_area.modeAreaModel.set( 1, { isVisible: false } )
                mode_area.modeAreaModel.set( 2, { isVisible: false } )
                mode_area.modeAreaModel.set( 3, { isVisible: true } )
            }else{
                mode_area.modeAreaModel.set( 0, { isVisible: false } )
                mode_area.modeAreaModel.set( 1, { isVisible: false } )
                mode_area.modeAreaModel.set( 2, { isVisible: true } )
                mode_area.modeAreaModel.set( 3, { isVisible: false } )
            }

          if((source_mask & CONST.const_SOURCE_JUKEBOX_MASK) && (source_id == CONST.const_JUKEBOX_SOURCE_ID))
          {
	      mode_area.modeAreaModel.set( 0, { isVisible: true } )
            mode_area.modeAreaModel.set( 1, { isVisible: false } )
            mode_area.modeAreaModel.set( 2, { isVisible: false } )
            mode_area.modeAreaModel.set( 3, { isVisible: false } )
          }
       }
       else
       {
          /** no USB */
          mode_area.modeAreaModel.set( 1, { isVisible: false } )
          mode_area.modeAreaModel.set( 2, { isVisible: false } )
          mode_area.modeAreaModel.set( 3, { isVisible: false } )

          if( source_id == CONST.const_JUKEBOX_SOURCE_ID )
          {
             mode_area.modeAreaModel.set( 0, { isVisible: true } )
             mode_area.currentSelectedIndex = 0
          }
       }
    }

    function backHandler()
    {
        // EngineListenerMain.qmlLog( "[MP_Photo] backHandler, state = " + photoviewer.state )

        if( popup_screen.item && popup_screen.item.visible)
        {
            //added by edo.lee 2013.03.05
            if( popup_state == CONST.const_POPUP_ID_DRS )
            {
                EngineListener.HandleBackKey()
            }else{
                //added by edo.lee
                photo_focus_index = root.focusEnum.cue
                popup_screen.item.hide()
                root.photo_focus_visible = true // modified for ITS 0210809
            }
        }
        else if( option_menu.visible )
        {
            // modified by Dmitry 26.04.13
            option_menu.backLevel()
            // modified by Dmitry 26.04.13
        }
        // modified by ravikanth 05-09-13 for ITS 0188375
        //{deleted on Sep. 10. 2013 [KOR][ITS][188966][minor](aettie.ji)
        else if( EngineListener.isSlideShow || isRotate || root.state == "fullScreen" ) //modified by yungi 2012.11.26 for No CR - Photo Roatateing backkey don't exit when Backkey
        {
            if(!EngineListenerMain.getCloneState4QML()) // modified for ITS 0206065
            {
                photo_focus_index = root.focusEnum.cue
                imageViewer.stopSlideShow();
                isRotate = false  //added by yungi 2012.11.26 for No CR - Photo Roatateing backkey don't exit when Backkey
                isFullscreen = false //added by yungi 2012.11.26 for No CR - Photo Roatateing backkey don't exit when Backkey
                //root.state = "normal" // removed by Michael.Kim 2013.10.11 for ITS 194857
            }
            EngineListener.HandleBackKey(true)
        }
        //{ added by eugene.seo 2012.12.10 for new UX Photo #4
        else if( mainImage.scale != 1 )
        {
            //imageViewer.reset()
            EngineListener.HandleBackKey()
        }
        //} added by eugene.seo 2012.12.10 for new UX Photo #4
        //}deleted on Sep. 10. 2013 [KOR][ITS][188966][minor](aettie.ji)
        else
        {
            EngineListener.HandleBackKey()
        }
    }

	// { remove by edo.lee statusbar animation speed 2013.08.10
    //modified by edo.lee 2013.04.04
	/*QmlStatusBar {
		id: statusBar
		x: 0 
		y: 0 
		width: 1280 
		height: 93
		homeType: "button"
		middleEast: EngineListenerMain.middleEast //[ME][ITS][177647][minor](aettie.ji)
		z:3

		Behavior on y {
			PropertyAnimation {
				duration: CONST.const_FULLSCREEN_DURATION_ANIMATION
			}
		}
	}*/
// } remove by edo.lee statusbar animation speed 2013.08.10
        QmlModeAreaWidget
        {
            id: mode_area
            z:2  //modified by edo.lee 2013.04.04
            focus_id: root.focusEnum.modeArea
            // modified for ITS 0214753, added systemPopupVisible. This is to hide focus on system popup launch
            focus_visible: ( root.focusEnum.modeArea == photo_focus_index )&&( photo_focus_visible ) && !systemPopupVisible
            currentSelectedIndex: 0
            image_type_visible : true // added by eugene 2012.12.12 for NewUX - Photo #5-2
  	    isListMode : false // added by eugene 2012.12.12 for NewUX - Photo #5-2
            counter_visible: toast_popUp.visible ? false : true // modified by ravikanth 25-04-13
            mode_area_counter_total: EngineListener.playlistCount
            mode_area_counter_number: EngineListener.currentIndex + 1
            mirrored_layout: EngineListenerMain.middleEast // modified by aettie 20130514 for mode area layout mirroring
            is_lockoutMode: lockoutRect.visible //added by edo.lee 2013.09.07 ITS 187822
            //isAVPMode: true   // modified by sangmin.seol ITS_0218558 RollBack DUAL_KEY for Photo.
            isPhotoMode: true
            is_focusable: (root.state != "fullScreen") // modified for ITS 0209200
            bAutoBeep: false // added by Sergey 19.11.2013 for beep issue
            property bool bFullScreenAnimation: true // added by cychoi 2016.01.25 for disable full screen animation
            onBeep: EngineListenerMain.ManualBeep(); // added by Sergey 19.11.2013 for beep issue
            onQmlLog: EngineListenerMain.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log

// { added by edo.lee  2013.08.10 ITS 183057
            QmlStatusBar {
				id: statusBar
				x: 0 
				y: -93 
				width: 1280 
				height: 93
				homeType: "button"
				middleEast: EngineListenerMain.middleEast 
				z:3
			}
// } added by edo.lee  2013.08.10 ITS 183057
            onLostFocus:
            {
                if( arrow == UIListenerEnum.JOG_DOWN )
                {
                    // modified by ravikanth 05-10-13 for ITS 0193980, 0193988
                    if(!lockoutRect.visible)
                        photo_focus_index = root.focusEnum.cue
                }
            }

            modeAreaModel: DHAVN_AppPhoto_ModeAreaList{}

            // modified by ruindmby 2012.08.16
            Behavior on y {
               //SequentialAnimation {
                  PropertyAnimation {
                       id: fullScreenAnimation // added by Sergey 10.09.2013 for ITS#184097
                     duration: mode_area.bFullScreenAnimation ? CONST.const_FULLSCREEN_DURATION_ANIMATION : 0 // modified by cychoi 2016.01.25 for disable full screen animation
                       // { added by cychoi 2016.01.25 for disable full screen animation
                       onRunningChanged:
                       {
                           if(!running && mode_area.bFullScreenAnimation == false)
                               mode_area.bFullScreenAnimation = true
                       }
                       // } added by cychoi 2016.01.25
		      //modified by edo.lee 2013.04.04
                     //onRunningChanged:
                     //{
                     //   if (!running && mode_area.y == -CONST.const_MODE_AREA_WIDGET_Y
                              // { modified by wspark 2013.02.27 for ISV 72949
                              //&& root.state == "fullScreen")
                    //          && (root.state == "fullScreen" || root.state == "zoom"))
                              // } modified by wspark
                    //    {
                    //       EngineListener.setStatusBarVisible(false)
                    //    }
                    // }
		     //modified by edo.lee 2013.04.04
                  }
            }
            // modified by ruindmby 2012.08.16

            onModeArea_Tab:
            {
                modeAreaWidget.currentSelectedIndex = tabId; //added by edo.lee 2013.01.10
            }

            onModeArea_BackBtn:
            {
               //{ added by eugene.seo 2012.12.10 for new UX Photo #4
	       //modified on Sep. 10. 2013 [KOR][ITS][188966][minor](aettie.ji) 
               //if(mainImage.scale != 1)
                  //imageViewer.reset()                            
               //else     
               //{
	       //modified by aettie 20130620 for back key event
                EngineListenerMain.qmlLog("[MP_Photo] Back_key: setIsBackPressByJog ="+isJogDial);
                EngineListener.setIsBackPressByJog(isJogDial);
                EngineListener.HandleSoftBackKey(isFrontView, bRRC);
               //}
               //} added by eugene.seo 2012.12.10 for new UX Photo #4
            }

            onModeArea_RightBtn:
            {
                // EngineListenerMain.qmlLog("[MP_Photo] onModeArea_RightBtn")
                if(mode_area.mode_area_counter_total > 0) // modified by ravikanth 10-05-13
                {
                    EngineListener.LaunchFileManager( EngineListener.getCurrentFilePath(EngineListener.currentSource))
                    //photo_focus_visible = false // modified by ravikanth 04-07-13 for not to set focus on cue control when modearea list clicked
                }
            }
            //{added by edo.lee 2012.08.21 for new UX Photo(LGE) #5
            onModeArea_MenuBtn:
            {
// modified by Dmitry 26.04.13
                if(mode_area.mode_area_counter_total > 0 && !fullScreenAnimation.running) // modified by Sergey 10.09.2013 for ITS#184097
                {
                    root.photo_focus_index = root.focusEnum.options
                    if( option_menu.visible != true) // modified by ravikanth 21-09-13 for ITS 0190634
                        option_menu.showMenu() // modified by Sergey 02.08.2103 for ITS#181512
                    option_menu.setDefaultFocus(UIListenerEnum.JOG_DOWN)
                }
// modified by Dmitry 26.04.13
            }
            onModeArea_BtnPressed:
            {
                topbar_timer.stop();
            }
        }
        //{ added by yongkyun.lee 20130214 for : ISV 70301
        Connections
        {
            // modified by sangmin.seol ITS_0218558 RollBack DUAL_KEY for Photo.
            target: (  root.photo_focus_index == root.focusEnum.modeArea) ? UIListener : null
                
            onSignalJogNavigation:
            {
                topbar_timer.restart()
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_UP:
                    {
                        if( mode_area.focus_index<=0)
                             mode_area.focus_index = 5;
                        break;
                    }
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                    {                       
                        if( mode_area.focus_index <= 0)
                             mode_area.focus_index = 5;
                        break;
                    }
		//added by edo.lee 2013.03.30
		    case UIListenerEnum.JOG_CENTER:
		    {
			if(mode_area.focus_index == 5
                        && status == UIListenerEnum.KEY_STATUS_RELEASED)
			{							
				EngineListener.setIsBackPressByJog(true);
                                EngineListenerMain.qmlLog("[MP_Photo] Back_key: setIsBackPressByJog true ");
			 }
		    }
                    
                }
                return;
            }
        }
        //} added by yongkyun.lee 20130214 
        
    //}  //modified by edo.lee 2013.04.04

    DHAVN_AppPhoto_OptionMenu
    {
        id: option_menu
// removed by Dmitry 26.04.13
    }

    Loader {
       id: visualCueLoader
       anchors.left: parent.left
       anchors.top: parent.top
       property bool bFullScreenAnimation: true // added by cychoi 2016.01.25 for disable full screen animation
       Behavior on anchors.topMargin {
           // { modified by cychoi 2016.01.25 for disable full screen animation
           PropertyAnimation {
               duration: visualCueLoader.bFullScreenAnimation ? CONST.const_FULLSCREEN_DURATION_ANIMATION : 0
               onRunningChanged:
               {
                   if(!running && visualCueLoader.bFullScreenAnimation == false)
                       visualCueLoader.bFullScreenAnimation = true
               }
           }
           // } modified by cychoi 2016.01.25
       }

       Connections
       {
          target: visualCueLoader.item

          onLostFocus:
          {
             if (UIListenerEnum.JOG_UP == arrow)
             {
                EngineListenerMain.qmlLog("[MP_Photo] cue lost focus")
                photo_focus_index = root.focusEnum.modeArea
                mode_area.setDefaultFocus(arrow)
             }

          }
       }
    }

    Timer {
       id: topbar_timer
       interval: 5000
       running: true
       onTriggered:
       {
           //{ added by yongkyun.lee 20130222 for : ISV  66443
           //modified by aettie 20130611 for ITS 167263
           if((photo_focus_index == root.focusEnum.options)||(popup_screen.item && popup_screen.item.visible) )
               return;
           //} added by yongkyun.lee 20130222
               photo_focus_index = root.focusEnum.cue
           //{modified by aettie.ji for ISV 64901
           //root.state = "fullScreen"
           if (root.state == "rotation")
               return
           // { modified by ravikanth 22-03-13
           else
           {
               if(!imageViewer.imageLargerThanScreen)
               {
                   root.state = "fullScreen"
               }
               else
               {
                   root.state = "zoom"
               }
           }
           // } modified by ravikanth 22-03-13
           //}modified by aettie.ji for ISV 64901
       }
    }

    onPhoto_focus_indexChanged:
    {
        //modified by aettie 20130611 for ITS 167263 // modified by Michael.Kim 2014.04.15 for ITS 234572
       if (((photo_focus_index == root.focusEnum.options)||(photo_focus_index == root.focusEnum.popup)) || !photo_focus_visible)
       {
          topbar_timer.stop()
       }
       else
       {
           topbar_timer.restart()
       }
    }

    Loader {
       id: popup_screen

       z: 1000
       anchors.fill: parent

       function show( popup_id )
       {
          if( popup_screen.status != Loader.Ready )
          {
             source = "DHAVN_AppPhoto_PopUpScreen.qml"
          }
// modified by ruindmby 2012.11.30 for CR#15766
		//deleted by aettie 20130611 for ITS 172875 	

          //if (popup_id == CONST.const_POPUP_ID_VALUE_SAVED)
          //{
          //   EngineListener.SaveSettings()
          //}//deleted by aettie 20130604 Master car QE issue
// modified by ruindmby 2012.11.30 for CR#15766
          item.show_popup( popup_id ) //restored by aettie 20130604 
       }
    }
	//added by edo.lee 2013.03.22
    Connections
    {
        target: EngineListenerMain
        onSignalPhotoFgReceived:
        {
            if(/*(root.state == "normal" || root.state == "rotation" || root.state == "zoom" || root.state == "fullScreen") &&*/ fgState)
            {
                if(option_menu.visible)
                    photo_focus_index = root.focusEnum.options  // added by Sergey 02.08.2103 for ITS#181512

                bGoingToSearch = true;
            }
            else{
                bGoingToSearch = false;
            }
        }
	//added by aettie 20130610 for ITS 172859 (ticker)
        onSignalBgReceived:
        {
            panStarted = false; //added by suilyou 20131001 ITS 0191309
        }

        // removed by sangmin.seol 2014.08.04 ITS 0244649
        //onTickerChanged:
        //{
            //__LOG("onTickerChanged ticker : " + ticker);
        //    root.scrollingTicker = ticker;
        //}
    }
	//added by edo.lee 2013.03.22
    Connections
    {
        // modified by sangmin.seol ITS_0218558 RollBack DUAL_KEY for Photo.
        target: ( EngineListener.isActive ) ? UIListener : null
        onSignalJogNavigation:
        {
           handleJogDial(arrow, status)	// modified by sangmin.seol ITS_0218558 RollBack DUAL_KEY for Photo.
        }

        //{ modified by wonseok.heo for ITS 177631  2013.07.05 //added by edo.lee 2013.03.27
        onSignalShowSystemPopup:
        {
            EngineListenerMain.qmlLog("[MP_Photo] signalShowSystemPopup");
            if( option_menu.visible ){
                //option_menu.backLevel()
                option_menu.quickHide() // modified by Michael.Kim 2014.06.26 for ITS 241424
            }

            if( popup_screen.item && popup_screen.item.visible ) {
                popup_screen.item.hide()
                photo_focus_index = root.focusEnum.cue
            }
            systemPopupVisible = true;
            photo_focus_visible = false;
            gestureArea.enabled = false; // modified by ravikanth 02-10-13 for ITS 0190988
        }
        onSignalHideSystemPopup:
        {
            systemPopupVisible = false;
            gestureArea.enabled = !lockoutRect.visible; // modified by cychoi 2015.11.02 for ITS 269978 // modified by ravikanth 02-10-13 for ITS 0190988
            photo_focus_visible = true;
            EngineListenerMain.qmlLog("[MP_Photo] signalHideSystemPopup");
        }
        // } modified by wonseok.heo for ITS 177631  2013.07.05 //added by edo.lee 2013.03.27
    }

    function handleJogDial(arrow, status)	// modified by sangmin.seol ITS_0218558 RollBack DUAL_KEY for Photo.
    {
       EngineListenerMain.qmlLog("[MP_Photo] handleJogDial arrow = " + arrow + " status = " + status) // modified by sangmin.seol ITS_0218558 RollBack DUAL_KEY for Photo.
       EngineListenerMain.qmlLog("[MP_Photo] photo_focus_index = " + photo_focus_index)
       if (popup_screen.item && popup_screen.item.visible) return; //added by aettie 20130611 for ITS 172875 
       topbar_timer.restart()

       switch (photo_focus_index)
       {
       //deleted by aettie 20130611 for ITS 172875 
          //case root.focusEnum.popup:
          //{
          //   if( popup_screen.item && popup_screen.item.visible )
          //       popup_screen.item.handleJog( arrow )
          //   break;
          //}

          case root.focusEnum.cue:
          {
             if (visualCueLoader.item)
             {
                // do not cancel slideshow on pressed because release will be handled by cue after that
                if (EngineListener.isSlideShow && (status == UIListenerEnum.KEY_STATUS_RELEASED))
                {
                    if(!option_menu.visible) // modified for ITS 0212100
                    {
                        // EngineListenerMain.qmlLog("[MP_Photo] slide show stopped")
                        imageViewer.stopSlideShow()
                        root.state = "normal"
                    }
                }
                else
                {
                   // Modified for ITS 0198336
                   //if (root.state == "fullScreen" && (status != UIListenerEnum.KEY_STATUS_RELEASED))
                   //   break;
                    if(!EngineListener.isSlideShow) // Modified for ITS 0210005
                        visualCueLoader.item.handleJogEvent( arrow, status )
                }
             }
             break;
          }

          default:
             break;
       }
    }

    // removed by Sergey 22.05.2013

    // { added by ravikanth 25-12-12
    //PopUpDimmed
    DHAVN_MP_PopUp_Dimmed
    {
        id: toast_popUp
        message: toast_text_model
        bHideByTimer: false
	// modified by ravikanth for ITS 0186006
        visible: false // EngineListener.loadingOnCopy
    }

    ListModel
        {
        id: toast_text_model
        ListElement { msg: QT_TR_NOOP("STR_MEDIA_LOADING_DATA") }
        }
    // } added by ravikanth 25-12-12
	//added by edo.lee 2013.05.24
    Rectangle
    {
        id: lockoutRect 

        anchors.fill:parent
        visible: false
        color: "black"

        Image
        {
	//[KOR][ITS][181226][comment](aettie.ji)
            id: lockoutImg
          //  anchors.horizontalCenter:parent.horizontalCenter
           anchors.left: parent.left
           anchors.leftMargin: 562
            anchors.top: parent.top
            anchors.topMargin: CONST.const_LOCKOUT_ICON_TOP_OFFSET
            source: "/app/share/images/general/ico_block_image.png"
        }

        Text
        {
        	//{added by edo.lee 2013.06.29
        	width: parent.width
        	horizontalAlignment:Text.AlignHCenter
            //anchors.horizontalCenter: parent.horizontalCenter   
            //}added by edo.lee 2013.06.29
	    //[KOR][ITS][181226][comment](aettie.ji)
            anchors.top: lockoutImg.bottom
            //anchors.topMargin: CONST.const_LOCKOUT_TEXT_TOP_OFFSET            
            text: qsTranslate(CONST.const_APP_PHOTO_LANGCONTEXT,"STR_MEDIA_IMAGE_DRIVING_REGULATION") + LocTrigger.empty
            font.pointSize: 32
            color: "white"
        }

        // modified for ITS 213375
        onVisibleChanged:
        {
            if((photo_focus_index == root.focusEnum.modeArea) && !visible)
            {
                photo_focus_index = root.focusEnum.cue
            }
        }
    }
    //added by edo.lee 2013.05.24    
}
// modified by Dmitry 18.05.13

