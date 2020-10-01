import QtQuick 1.1 // modified by Sergey 12.05.2013
import Qt 4.7
import AppEngineQMLConstants 1.0
import "../DHAVN_VP_CONSTANTS.js" as CONST

DHAVN_VP_FocusedItem
{
    id: visualCue

    x : 471
    y : 460
    width: 354
    height: 170
    property bool lTextColor: false;//{ added by yongkyun.lee 20130621 for : ITS 175492
    property bool longPressed: false; // added by cychoi 2013.08.07 for ITS 181411 Move focus to Menu and Back SK's in DVD Title/Disc Menu
    property bool modeAreaDownArrowEnabled : false // added by yungi 2013.11.07 for ITS 207181
    property bool pressed : false  // added by yungi 2013.12.16 for ITS 215797

    signal upperArrowLongClicked() // added by cychoi 2013.08.07 for ITS 181411 Move focus to Menu and Back SK's in DVD Title/Disc Menu
    signal upperArrowClicked()
    signal leftArrowClicked()
    signal rightArrowClicked()
    signal bottomArrowClicked()
    signal centerClicked()
    signal signalVisualCueSelected() // added by yungi 2014.01.14 for ITS 219246

    function jogOnPressed(index)
    {
       arrow_elements.model.get(index).mod_source_current = arrow_elements.model.get(index).mod_source_s
    }

    function jogOnReleased(index)
    {
       arrow_elements.model.get(index).mod_source_current = arrow_elements.model.get(index).mod_source_n

    }

// modified by Dmitry 15.05.13
    function handleJogEvent( arrow, status )
       {
          switch ( arrow )
          {
             case UIListenerEnum.JOG_UP:
             {
                if(status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
                   visualCue.jogOnPressed(1)
                   longPressed = false; // added by cychoi 2013.08.07 for ITS 181411 Move focus to Menu and Back SK's in DVD Title/Disc Menu
                }
                else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                   // { modified by cychoi 2013.09.24 for ITS 181411 Move focus to Menu and Back SK's in DVD Title/Disc Menu
                   if(!longPressed)
                   {
                      visualCue.jogOnReleased(1)
                      visualCue.upperArrowClicked()
                   }
                   // } modified by cychoi 2013.09.24
                }
                // { added by cychoi 2013.09.24 for ITS 181411 Move focus to Menu and Back SK's in DVD Title/Disc Menu
                else if(status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
                {
                   if(!longPressed)
                   {
                      visualCue.jogOnReleased(1)
                      UIListener.ManualBeep() // added by cychoi 2014.05.30 for ITS 239064 Beep on 4 arrow key touch (Title/Disc Menu)
                      visualCue.upperArrowLongClicked()
                      longPressed = true;
                   }
                }
                // } added by cychoi 2013.09.24
                // { added by oseong.kwon 2014.09.30 for ITS 249365, ITS 249367 Key Cancel on Title/Disc Menu
                else if(status == UIListenerEnum.KEY_STATUS_CANCELED)
                {
                    visualCue.jogOnReleased(1)
                }
                // } added by oseong.kwon 2014.09.30
             }
             break
             case UIListenerEnum.JOG_RIGHT:
             {
                 if(status == UIListenerEnum.KEY_STATUS_PRESSED)
                 {
                    visualCue.jogOnPressed(5)
                 }
                 else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                 {
                    visualCue.jogOnReleased(5)
                    visualCue.rightArrowClicked()
                 }
                 // { added by oseong.kwon 2014.09.30 for ITS 249365, ITS 249367 Key Cancel on Title/Disc Menu
                 else if(status == UIListenerEnum.KEY_STATUS_CANCELED)
                 {
                     visualCue.jogOnReleased(5)
                 }
                 // } added by oseong.kwon 2014.09.30
             }
             break
             case UIListenerEnum.JOG_DOWN:
             {
                 if(status == UIListenerEnum.KEY_STATUS_PRESSED)
                 {
                    visualCue.jogOnPressed(7)
                    modeAreaDownArrowEnabled = true // added by yungi 2013.11.07 for ITS 207181
                 }
                 else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                 {
                    visualCue.jogOnReleased(7)
                    visualCue.bottomArrowClicked()
                    modeAreaDownArrowEnabled = false // added by yungi 2013.11.07 for ITS 207181
                 }
                 // { added by oseong.kwon 2014.09.30 for ITS 249365, ITS 249367 Key Cancel on Title/Disc Menu
                 else if(status == UIListenerEnum.KEY_STATUS_CANCELED)
                 {
                     visualCue.jogOnReleased(7)
                 }
                 // } added by oseong.kwon 2014.09.30
             }
             break
             case UIListenerEnum.JOG_LEFT:
             {
                 if(status == UIListenerEnum.KEY_STATUS_PRESSED)
                 {
                    visualCue.jogOnPressed(3)
                 }
                 else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                 {
                    visualCue.jogOnReleased(3)
                    visualCue.leftArrowClicked()
                 }
                 // { added by oseong.kwon 2014.09.30 for ITS 249365, ITS 249367 Key Cancel on Title/Disc Menu
                 else if(status == UIListenerEnum.KEY_STATUS_CANCELED)
                 {
                     visualCue.jogOnReleased(3)
                 }
                 // } added by oseong.kwon 2014.09.30
             }
             break
             case UIListenerEnum.JOG_CENTER:
             {
                 //{ added by yongkyun.lee 20130621 for :  ITS 175492
                 if(status == UIListenerEnum.KEY_STATUS_PRESSED)
                     lTextColor = true;
                 else
                 //} added by yongkyun.lee 20130621 
                 if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                 {
                    lTextColor = false;// added by yongkyun.lee 20130621 for :  ITS 175492
                    visualCue.centerClicked()
                 }
                 // { added by oseong.kwon 2014.09.30 for ITS 249365, ITS 249367 Key Cancel on Title/Disc Menu
                 else if(status == UIListenerEnum.KEY_STATUS_CANCELED)
                 {
                     lTextColor = false;
                 }
                 // } added by oseong.kwon 2014.09.30
             }
             break
          }
       }
// modified by Dmitry 15.05.13

    Image
    {
      id: visual_cue_center
      anchors.horizontalCenter: visualCue.horizontalCenter
      anchors.verticalCenter: visualCue.verticalCenter
      //{ added by yongkyun.lee 20130621 for :  ITS 175492
      //source: "/app/share/images/general/ch_visual_cue_bg.png"
      // { modified by yungi 2013.11.04 for ITS 206323  //added by yongkyun.lee 20130625 for : its 172688
      source: lTextColor ?              "/app/share/images/general/media_visual_cue_p.png" :
              visualCue.focus_visible ? "/app/share/images/general/media_visual_cue_f.png" :"/app/share/images/general/media_visual_cue_n.png"
      // } modified by yungi

      //} added by yongkyun.lee 20130621 

      MouseArea
      {
         id: okMouseArea
         beepEnabled: false // added by cychoi 2014.05.30 for ITS 239064 Beep on 4 arrow key touch (Title/Disc Menu)
         anchors.fill:  parent

         // { modified by yungi 2013.12.17 for ITS 215797 //{ added by yongkyun.lee 20130625 for : its 172688
         onPressed: {
            visualCue.lTextColor = true
            visualCue.pressed = true
            visualCue.signalVisualCueSelected() // added by yungi 2014.01.14 for ITS 219246
         }
         onReleased: {
             visualCue.lTextColor = false
         }
         onExited: {
             visualCue.lTextColor = false
             visualCue.pressed = false
         }
         //} added by yongkyun.lee 20130625

         onClicked: {
             if(visualCue.pressed)
             {
                 UIListener.ManualBeep() // added by cychoi 2014.05.30 for ITS 239064 Beep on 4 arrow key touch (Title/Disc Menu)
                 visualCue.centerClicked()
             }
             visualCue.pressed = false
         }
         // } modified by yungi 2013.12.17
      }
    }

    Text
    {
       anchors.verticalCenter: visual_cue_center.verticalCenter
       anchors.horizontalCenter: visual_cue_center.horizontalCenter
       text:  "OK"
       // { modified by wspark 2013.02.13
       //color: "grey"
       // { rollback by sangmin.seol 2014.12.23 for ITS 254979 //{ added by yongkyun.lee 20130621 for :  ITS 175492
       color: CONST.const_FONT_COLOR_BRIGHT_GREY
       //color: lTextColor ?  CONST.const_FONT_COLOR_RGB_BLUE_TEXT : CONST.const_FONT_COLOR_BRIGHT_GREY
       // } rollback by sangmin.seol 2014.12.23 //} added by yongkyun.lee 20130621 
       // } modified by wspark
            font.family: CONST.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
       //font.pixelSize: 32
       font.pointSize: 32   //modified by aettie.ji 2012.11.28 for uxlaunch update
    }



    GridView
    {
      id: arrow_elements
      interactive:  false
      model: visual_cue_model
      delegate: vc_delegate
      width: 300
      height:  300
      anchors.horizontalCenter: visual_cue_center.horizontalCenter
      anchors.verticalCenter: visual_cue_center.verticalCenter
      LayoutMirroring.enabled: false // added by Sergey 12.05.2013
    }

    Component {
       id: vc_delegate

       Item {

       width: 100
       height: 100

       Image
       {
         id: arrow_image
         // { modified by eunhye 2013.03.19
         //anchors.fill:  parent
         anchors.centerIn: parent
         width: model.icon_width
         height: model.icon_height
         // } modified by eunhye 2013.03.19
         source:  model.mod_source_current || ""
       }

        MouseArea
        {
            id: mouseArea
            enabled: arrow_image.source != ""
            beepEnabled: false // added by cychoi 2014.05.30 for ITS 239064 Beep on 4 arrow key touch (Title/Disc Menu)
            anchors.fill:  parent

            onPressed: // modified by yungi 2013.12.16 for ITS 215797
            {
                visualCue.jogOnPressed(index)
                visualCue.pressed = true
                visualCue.signalVisualCueSelected() // added by yungi 2014.01.14 for ITS 219246
            }
            onReleased: { visualCue.jogOnReleased(index) }
            onExited: { visualCue.jogOnReleased(index); visualCue.pressed = false; } // added by yungi 2013.12.16 for ITS 215797
            onClicked:
            {
                // { modified by yungi 2013.12.16 for ITS 215797
                if(visualCue.pressed)
                {
                    switch(model.mod_id)
                    {
                        case "upper_arrow":
                        {
                            UIListener.ManualBeep() // added by cychoi 2014.05.30 for ITS 239064 Beep on 4 arrow key touch (Title/Disc Menu)
                            visualCue.upperArrowClicked();
                            break;
                        }
                        case "left_arrow":
                        {
                            UIListener.ManualBeep() // added by cychoi 2014.05.30 for ITS 239064 Beep on 4 arrow key touch (Title/Disc Menu)
                            visualCue.leftArrowClicked();
                            break;
                        }
                        case "right_arrow":
                        {
                            UIListener.ManualBeep() // added by cychoi 2014.05.30 for ITS 239064 Beep on 4 arrow key touch (Title/Disc Menu)
                            visualCue.rightArrowClicked();
                            break;
                        }
                        case "bottom_arrow":
                        {
                            modeAreaDownArrowEnabled= true ;
                            UIListener.ManualBeep() // added by cychoi 2014.05.30 for ITS 239064 Beep on 4 arrow key touch (Title/Disc Menu)
                            visualCue.bottomArrowClicked();
                            break;
                        } // modified by yungi 2013.11.07 for ITS 207181
                    }
                    visualCue.pressed = false
                }
                // } modified by yungi 2013.12.16 for ITS 215797
            }
        }
    }

    }
    //{ added by shkim for ITS 206323 visual Cue Issue 2013.11.06
    Connections
    {
        target: EngineListenerMain

        onSignalBgReceived:
        {
            EngineListenerMain.qmlLog("Reset All arrow Image State. ");
            visualCue.lTextColor = false
            visualCue.jogOnReleased(1)
            visualCue.jogOnReleased(5)
            visualCue.jogOnReleased(7)
            visualCue.jogOnReleased(3)
        }
    }
    //} added by shkim for ITS 206323 visual Cue Issue 2013.11.06
    // { modified by aettie.ji 2012.11.21 for New UX
    /*ListModel
    {
       id: visual_cue_model

       ListElement  { }
       ListElement
       {
           mod_id: "upper_arrow"
           mod_source_n: "/app/share/images/general/ch_visual_cue_u_n.png"
           mod_source_s: "/app/share/images/general/ch_visual_cue_u_s.png"
           mod_source_current: "/app/share/images/general/ch_visual_cue_u_n.png"
       }
       ListElement  { }

       ListElement
       {
           mod_id: "left_arrow"
           mod_source_n: "/app/share/images/general/ch_visual_cue_l_n.png"
           mod_source_s: "/app/share/images/general/ch_visual_cue_l_s.png"
           mod_source_current: "/app/share/images/general/ch_visual_cue_l_n.png"
       }
       ListElement { }
       ListElement
       {
           mod_id: "right_arrow"
           mod_source_n: "/app/share/images/general/ch_visual_cue_r_n.png"
           mod_source_s: "/app/share/images/general/ch_visual_cue_r_s.png"
           mod_source_current: "/app/share/images/general/ch_visual_cue_r_n.png"
       }

       ListElement { }
       ListElement
       {
           mod_id: "bottom_arrow"
           mod_source_n: "/app/share/images/general/ch_visual_cue_d_n.png"
           mod_source_s: "/app/share/images/general/ch_visual_cue_d_s.png"
           mod_source_current: "/app/share/images/general/ch_visual_cue_d_n.png"
       }
       ListElement { }

    }*/

    ListModel
    {
       id: visual_cue_model

       ListElement  { }
       ListElement
       {
           mod_id: "upper_arrow"
           mod_source_n: "/app/share/images/photo/photo_visual_cue_u_n.png"
           mod_source_s: "/app/share/images/photo/photo_visual_cue_u_p.png"
           mod_source_current: "/app/share/images/photo/photo_visual_cue_u_n.png"
           // { added by eunhye 2013.03.19
           icon_width: 85
           icon_height: 65
           // } added by eunhye 2013.03.19
       }
       ListElement  { }

       ListElement
       {
           mod_id: "left_arrow"
           mod_source_n: "/app/share/images/photo/photo_visual_cue_l_n.png"
           mod_source_s: "/app/share/images/photo/photo_visual_cue_l_p.png"
           mod_source_current: "/app/share/images/photo/photo_visual_cue_l_n.png"
           // { added by eunhye 2013.03.19
           icon_width: 65
           icon_height: 77
           // } added by eunhye 2013.03.19
       }
       ListElement { }
       ListElement
       {
           mod_id: "right_arrow"
           mod_source_n: "/app/share/images/photo/photo_visual_cue_r_n.png"
           mod_source_s: "/app/share/images/photo/photo_visual_cue_r_p.png"
           mod_source_current: "/app/share/images/photo/photo_visual_cue_r_n.png"
           // { added by eunhye 2013.03.19
           icon_width: 65
           icon_height: 77
           // } added by eunhye 2013.03.19
       }

       ListElement { }
       ListElement
       {
           mod_id: "bottom_arrow"
           mod_source_n: "/app/share/images/photo/photo_visual_cue_d_n.png"
           mod_source_s: "/app/share/images/photo/photo_visual_cue_d_p.png"
           mod_source_current: "/app/share/images/photo/photo_visual_cue_d_n.png"
           // { added by eunhye 2013.03.19
           icon_width: 85
           icon_height: 65
           // } added by eunhye 2013.03.19
       }
       ListElement { }

    }
    // } modified by aettie.ji 2012.11.21 for New UX

}
