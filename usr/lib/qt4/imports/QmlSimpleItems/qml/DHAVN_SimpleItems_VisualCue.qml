import Qt 4.7
import "DHAVN_SimpleItems_VisualCue.js" as HM
import "DhAvnSimpleItemsResources.js" as RES

Item
{
   id: visual_cue

   property int const_TYPE_INVALID: -1
   property int const_TYPE_HOME: 0
   property int const_TYPE_MUSIC: 1
   property int const_TYPE_VIDEO: 2
   property int const_TYPE_RADIO_TYPE_A: 3
   property int const_TYPE_RADIO_MODE_2: 4
   property int const_TYPE_SOUND_THERAPY: 5
   property int const_TYPE_DMB: 6

   property int const_KEY_ALL: 0
   property int const_KEY_CENTER: 1
   property int const_KEY_ARROW_LEFT: 2
   property int const_KEY_ARROW_RIGHT: 3
   property int const_KEY_ARROW_UP: 4
   property int const_KEY_HOLD_LEFT: 5
   property int const_KEY_HOLD_RIGHT: 6
   property int const_KEY_WHEEL_LEFT: 7
   property int const_KEY_WHEEL_RIGHT: 8

   property int __type: const_TYPE_INVALID

   property bool __bCenter: false
   property bool __bArrowLeft: false
   property bool __bArrowRight: false
   property bool __bArrowUp: false
   property bool __bWheelLeft: false
   property bool __bWheelRight: false
   property bool __bHoldLeft: false
   property bool __bHoldRight: false

   property bool __anyKeyPressed: __bCenter || __bArrowLeft || __bArrowRight || __bArrowUp || __bWheelLeft || __bWheelRight || __bHoldLeft || __bHoldRight

   property string __imgCenter: RES.const_URL_IMG_VISUAL_CUE_CENTER
   property string __imgWheel: RES.const_URL_IMG_VISUAL_CUE_WHEEL
   property string __imgArrow: RES.const_URL_IMG_VISUAL_CUE_ARROW
   property string __imgHold: RES.const_URL_IMG_VISUAL_CUE_HOLD
   property string __imgPlayUnmute: __bPlayPause ? RES.const_URL_IMG_VISUAL_CUE_PLAY : RES.const_URL_IMG_VISUAL_CUE_UNMUTE
   property string __imgPauseMute: __bPlayPause ? RES.const_URL_IMG_VISUAL_CUE_PAUSE : RES.const_URL_IMG_VISUAL_CUE_MUTE
   property string __text: ""

   property bool __bArrowsTransparent: false
   property bool __bShowHoldArrows: false
   property bool __bShowCenterIcon: false

   /** If true - will be displayed Play/Pause icon.
     * If false - will be displayed Mute/Unmute icon. */
   property bool __bPlayPause: false

   /** If true - will be displayed Play/Unmute icon.
     * If false - will be displayed Pause/Mute icon. */
   property bool __bPlayUnmute: true

   property url __urlCenter: __imgCenter + ( __bCenter ? HM.const_URL_IMG_PRESSED : HM.const_URL_IMG_NORMAL ) + HM.const_URL_IMG_EXTENSION_PNG
   property url __urlLeftWheel: __imgWheel + HM.const_URL_IMG_L + ( __bWheelLeft ? HM.const_URL_IMG_PRESSED : HM.const_URL_IMG_NORMAL ) + HM.const_URL_IMG_EXTENSION_PNG
   property url __urlRightWheel: __imgWheel + HM.const_URL_IMG_R + ( __bWheelRight ? HM.const_URL_IMG_PRESSED : HM.const_URL_IMG_NORMAL ) + HM.const_URL_IMG_EXTENSION_PNG
   property url __urlArrowLeft: __imgArrow + ( ( !__bArrowLeft && __bArrowsTransparent ) ? HM.const_URL_IMG_TRANSPARENT : "" ) + HM.const_URL_IMG_L + ( __bArrowLeft ? HM.const_URL_IMG_PRESSED : HM.const_URL_IMG_NORMAL ) + HM.const_URL_IMG_EXTENSION_PNG
   property url __urlArrowRight: __imgArrow + ( ( !__bArrowRight && __bArrowsTransparent ) ? HM.const_URL_IMG_TRANSPARENT : "" ) + HM.const_URL_IMG_R + (  __bArrowRight ? HM.const_URL_IMG_PRESSED : HM.const_URL_IMG_NORMAL ) + HM.const_URL_IMG_EXTENSION_PNG
   property url __urlArrowUp: __imgArrow +  HM.const_URL_IMG_UP + ( ( !__bArrowUp && __bArrowsTransparent ) ? HM.const_URL_IMG_TRANSPARENT : "" ) + ( __bArrowUp ? HM.const_URL_IMG_PRESSED : HM.const_URL_IMG_NORMAL ) + HM.const_URL_IMG_EXTENSION_PNG
   property url __urlHoldLeft: __imgHold + ( ( !__bHoldLeft && __bArrowsTransparent ) ? HM.const_URL_IMG_TRANSPARENT : "" ) + HM.const_URL_IMG_L + ( __bHoldLeft ? HM.const_URL_IMG_PRESSED : HM.const_URL_IMG_NORMAL ) + HM.const_URL_IMG_EXTENSION_PNG
   property url __urlHoldRight: __imgHold + ( ( !__bHoldRight && __bArrowsTransparent ) ? HM.const_URL_IMG_TRANSPARENT : "" ) + HM.const_URL_IMG_R + ( __bHoldRight ? HM.const_URL_IMG_PRESSED : HM.const_URL_IMG_NORMAL ) + HM.const_URL_IMG_EXTENSION_PNG
   property url __urlPlayUnmute: __imgPlayUnmute + ( __bCenter ? HM.const_URL_IMG_PRESSED : HM.const_URL_IMG_NORMAL ) + HM.const_URL_IMG_EXTENSION_PNG
   property url __urlPauseMute: __imgPauseMute + ( __bCenter ? HM.const_URL_IMG_PRESSED : HM.const_URL_IMG_NORMAL ) + HM.const_URL_IMG_EXTENSION_PNG

   signal visualCueHidedSignal()

   function retranslateUI( context )
   {
      if (context) { __lang_context = context }
      __emptyString = " "
      __emptyString = ""
   }

   function setText(newText)
   {
      __text = newText
   }

   property string __lang_context: HM.const_VISUAL_CUE_LANGCONTEXT
   property string __emptyString: ""

   function setType( type, label )
   {
      switch( type )
      {
         case const_TYPE_HOME:
            __bArrowsTransparent = true
            __bShowHoldArrows = false
            __bShowCenterIcon = false
            __bPlayPause = false
            break

         case const_TYPE_MUSIC:
            __bArrowsTransparent = false
            __bShowHoldArrows = true
            __bShowCenterIcon = true
            __bPlayPause = true
            break

         case const_TYPE_VIDEO:
            __bArrowsTransparent = true
            __bShowHoldArrows = true
            __bShowCenterIcon = true
            __bPlayPause = true
            break

         case const_TYPE_RADIO_TYPE_A:
            __bArrowsTransparent = true
            __bShowHoldArrows = true
            __bShowCenterIcon = true
            __bPlayPause = false
            break

         case const_TYPE_RADIO_MODE_2:
            __bArrowsTransparent = true
            __bShowHoldArrows = true
            __bShowCenterIcon = false
            __bPlayPause = false
            break

         case const_TYPE_SOUND_THERAPY:
            __bArrowsTransparent = true
            __bShowHoldArrows = true
            __bShowCenterIcon = true
            __bPlayPause = true
            break

         case const_TYPE_DMB:
            __bArrowsTransparent = true
            __bShowHoldArrows = false
            __bShowCenterIcon = false
            __bPlayPause = false
            break
      }

      __type = type
      __text = qsTranslate( __lang_context ,label ) + __emptyString
   }

   function setPlayUnmuteIcon()
   {
      __bPlayUnmute = true
   }

   function setPauseMuteIcon()
   {
      __bPlayUnmute = false
   }

   function keyEvent( key, highlight )
   {
      if( const_TYPE_INVALID == __type )
      {
         console.log( " DHAVN_SimpleItems_VisualCue.qml: VISUAL CUE TYPE NOT DEFINED!" )
         return
      }

      if( true == highlight )
      {
         hideVisualCue.stop()
         showVisualCue.restart()
      }

      switch( key )
      {
         case const_KEY_CENTER:
            __bCenter = highlight
            break

         case const_KEY_ARROW_LEFT:
            __bArrowLeft = highlight
            break

         case const_KEY_ARROW_RIGHT:
            __bArrowRight = highlight
            break

         case const_KEY_ARROW_UP:
            __bArrowUp = highlight
            break

         case const_KEY_HOLD_LEFT:
            __bHoldLeft = highlight
            break

         case const_KEY_HOLD_RIGHT:
            __bHoldRight = highlight
            break

         case const_KEY_WHEEL_LEFT:
            __bWheelLeft = highlight
            break

         case const_KEY_WHEEL_RIGHT:
            __bWheelRight = highlight
            break

         case const_KEY_ALL:
            __bCenter = highlight
            __bArrowLeft = highlight
            __bArrowRight = highlight
            __bArrowUp = highlight
            __bHoldLeft = highlight
            __bHoldRight = highlight
            __bWheelLeft = highlight
            __bWheelRight = highlight
            break
      }

      if( __anyKeyPressed )
      {
         timer.stop()
      }
      else
      {
         timer.restart()
      }
   }

   function retransliteUI()
   {
      caption.text = qsTr( caption.text )
   }

   x: HM.const_SCREEN_POSITION_X
   y: HM.const_SCREEN_POSITION_Y

   height: bg.height
   width: bg.width

   opacity: 0

   /** Background */
   Image
   {
      id: bg

      x: 0
      y: 0
      z: HM.const_ORDER_BG

      source: RES.const_URL_IMG_VISUAL_CUE_BG
   }

   /** Center image */
   Image
   {
      x: HM.const_CENTER_POSITION_X
      y: HM.const_CENTER_POSITION_Y
      z: HM.const_ORDER_CENTER
      source: __urlCenter
   }

   /** Text */
   Text
   {
      id: caption

      x: HM.const_TEXT_POSITION_X
      y: HM.const_TEXT_POSITION_Y_CENTER - height/2
      z: HM.const_ORDER_TEXT

      width: HM.const_TEXT_WIDTH
      horizontalAlignment: Text.AlignHCenter
     // font.family: HM.const_TEXT_FONT_FAMILY
      font.family: HM.const_TEXT_FONT_FAMILY_NEW

      font.pixelSize: HM.const_TEXT_PIX_SIZE
      color: HM.const_TEXT_FONT_COLOR

      text: qsTranslate( __lang_context ,__text ) + __emptyString

      visible: ( "" == __text ) ? false : true
   }

   /** Play/pause or mute/unmute image */
   Image
   {
      x: __bPlayPause ? HM.const_PLAY_PAUSE_POSITION_X : HM.const_MUTE_UNMUTE_POSITION_X
      y: __bPlayPause ? HM.const_PLAY_PAUSE_POSITION_Y : HM.const_MUTE_UNMUTE_POSITION_Y
      z: HM.const_ORDER_PLAY_PAUSE
      source: __bPlayUnmute ? __urlPlayUnmute : __urlPauseMute
      visible: __bShowCenterIcon
   }

   /** Left arrrow icon */
   Image
   {
      x: HM.const_ARROW_L_POSITION_X
      y: HM.const_ARROW_L_POSITION_Y
      z: HM.const_ORDER_ARROW
      source: __urlArrowLeft
   }

   /** Right arrrow icon */
   Image
   {
      x: HM.const_ARROW_R_POSITION_X
      y: HM.const_ARROW_R_POSITION_Y
      z: HM.const_ORDER_ARROW
      source: __urlArrowRight
   }

   /** Up arrrow icon */
   Image
   {
      x: HM.const_ARROW_UP_POSITION_X
      y: HM.const_ARROW_UP_POSITION_Y
      z: HM.const_ORDER_ARROW
      source: __urlArrowUp
   }

   /** Left hold arrow */
   Image
   {
      x: HM.const_ARROW_HOLD_L_POSITION_X
      y: HM.const_ARROW_HOLD_L_POSITION_Y
      z: HM.const_ORDER_ARROW
      source: __urlHoldLeft
      visible: __bShowHoldArrows
   }

   /** Right hold arrow */
   Image
   {
      x: HM.const_ARROW_HOLD_R_POSITION_X
      y: HM.const_ARROW_HOLD_R_POSITION_Y
      z: HM.const_ORDER_ARROW
      source: __urlHoldRight
      visible: __bShowHoldArrows
   }

   /** Left wheel icon */
   Image
   {
      x: HM.const_WHEEL_L_POSITION_X
      y: HM.const_WHEEL_L_POSITION_Y
      z: HM.const_ORDER_WHEEL
      source: __urlLeftWheel
   }

   /** Right wheel icon */
   Image
   {
      x: HM.const_WHEEL_R_POSITION_X
      y: HM.const_WHEEL_R_POSITION_Y
      z: HM.const_ORDER_WHEEL
      source: __urlRightWheel
   }

   NumberAnimation
   {
      id: showVisualCue

      target: visual_cue
      property: "opacity"
      duration: HM.const_ANIMATION_DURATION_SHOW
      to: 1
   }

   NumberAnimation
   {
      id: hideVisualCue

      target: visual_cue
      property: "opacity"
      duration: HM.const_ANIMATION_DURATION_HIDE
      to: 0
      onCompleted:
      {
         visualCueHidedSignal();
      }
   }

   /** Timer */
   Timer
   {
      id: timer

      interval: HM.const_TIMER_DURATION
      running: false

      onTriggered:
      {
         hideVisualCue.start()
      }
   }
}
