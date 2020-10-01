import Qt 4.7
import QtQuick 1.0
import "../DHAVN_AppPhoto_Constants.js" as CONST
import AppEngineQMLConstants 1.0

// modified by Dmitry 18.05.13
Item
{
   id: visualcue_main

   /** Properties */
   property bool is_focused: root.photo_focus_visible&&( root.photo_focus_index == root.focusEnum.cue )

   signal lostFocus(variant arrow)

// { modified by Sergey 28.05.13
   function handleJogEvent( arrow, status )
   {
       EngineListenerMain.qmlLog( "[MP_Photo] set focus on visualcue main for arrow = " + arrow +"status ="+status )

       if( status == UIListenerEnum.KEY_STATUS_PRESSED )
           topbar_timer.stop()
       else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
           topbar_timer.start()

       switch( arrow )
       {
           case UIListenerEnum.JOG_UP:
           case UIListenerEnum.JOG_DOWN:
           {
           //modified by aettie Focus moves when pressed 20131015
//               if( status == UIListenerEnum.KEY_STATUS_RELEASED )
               if( status == UIListenerEnum.KEY_STATUS_PRESSED )
               {
                   if (root.state == "fullScreen")
                       root.state = "normal"
                   else
                       visualcue_main.lostFocus( arrow )
               }
               break
           }

           case UIListenerEnum.JOG_LEFT:
           {
               if( status == UIListenerEnum.KEY_STATUS_PRESSED )
               {
                   visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", true ) // modified by sangmin.seol 2014.12.23 for ITS 254979
               }
               else if( status == UIListenerEnum.KEY_STATUS_RELEASED )
               {
                   visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", false ) // modified by sangmin.seol 2014.12.23 for ITS 254979
                   visualcue_main.prev_clicked()
               }
// added by Dmitry 18.08.13 for ITS0176369
               else if( status == UIListenerEnum.KEY_STATUS_CANCELED )
               {
                   visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", false ) // modified by sangmin.seol 2014.12.23 for ITS 254979
               }
               break
           }

           case UIListenerEnum.JOG_RIGHT:
           {
               if( status == UIListenerEnum.KEY_STATUS_PRESSED )
               {
                   visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", true ) // modified by sangmin.seol 2014.12.23 for ITS 254979
               }
               else if( status == UIListenerEnum.KEY_STATUS_RELEASED )
               {
                   visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", false ) // modified by sangmin.seol 2014.12.23 for ITS 254979
                   visualcue_main.next_clicked()
               }
// added by Dmitry 18.08.13 for ITS0176369
               else if (status == UIListenerEnum.KEY_STATUS_CANCELED )
               {
                  visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", false ) // modified by sangmin.seol 2014.12.23 for ITS 254979
               }
               break
           }

           case UIListenerEnum.JOG_CENTER:
           {
               if( status == UIListenerEnum.KEY_STATUS_PRESSED)
               {
                   visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", true )
               }
               else if( status == UIListenerEnum.KEY_STATUS_RELEASED )
               {
               //added by aettie 20130801 for ITS 181813
                   visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", false )
               //modified by aettie 20130531
               //[KOR][ITS][180467][minor](aettie.ji)
                   if(imageViewer.imageLargerThanScreen)
                       root.state = "zoom"
                   else if (root.state == "fullScreen")
                   {
                       root.state = "normal"
                       imageViewer.stopSlideShow();

                   }
                   else if(root.state == "normal")
                   {
                       // {modified by Michael.Kim for 2013.10.01 for Hyundai Request
                       root.state = "fullScreen"
                       //imageViewer.startSlideShow();
                       imageViewer.stopSlideShow();
                       // }modified by Michael.Kim for 2013.10.01 for Hyundai Request
                   }
               }
// added by Dmitry 18.08.13 for ITS0176369
               else if (status == UIListenerEnum.KEY_STATUS_CANCELED)
               {
                  visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", false )
               }
               break
           }

           case UIListenerEnum.JOG_WHEEL_LEFT:
           {
               if( status == UIListenerEnum.KEY_STATUS_RELEASED )
               {
                   imageViewer.zoomOut()
                   break
               }
           }

           case UIListenerEnum.JOG_WHEEL_RIGHT:
           {
               if( status == UIListenerEnum.KEY_STATUS_RELEASED )
               {
                   imageViewer.zoomIn()
                   break
               }
           }
       }
   }
// } modified by Sergey 28.05.13

   // reset properties
   function reset()
   {
      visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", false )
      visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", false )
      // removed by sangmin.seol 2014.12.23 for ITS 254979
   }

// added for expand touch area
   Rectangle{
       id: rectLeft
       color: "transparent"
       anchors
       {
           top: parent.top
           topMargin: CONST.const_VISUAL_CUE_MA_TOP_MARGIN // added by cychoi 2015.11.06 for ISV 120461
           left: parent.left
           leftMargin: CONST.const_VISUAL_CUE_MA_LEFT_MARGIN // added by cychoi 2015.11.06 for ISV 120461
       }
       width:105 //157 - CONST.const_VISUAL_CUE_MA_LEFT_MARGIN // modified by cychoi 2015.11.06 for ISV 120461
       height:150
       clip:false

       MouseArea{
           id: mouseAreaLeft
           anchors.fill:parent
           enabled: !visualcue_main_model.get( CONST.const_REW_BTN_NUMBER ).is_dimmed && !root.toastVisible
           noClickAfterExited: true
           beepEnabled: false //added by Michael.Kim 2014.07.04 for ITS 240747
           onPressed:
           {
               EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main Prev(mouseAreaLeft) pressed" )
               visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", true );
           }
           onReleased:
           {
               visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", false );
           }

           onExited:
           {
               visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", false )
               // removed by sangmin.seol 2014.12.23 for ITS 254979
           }

           onCanceled:
           {
               visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", false )
               // removed by sangmin.seol 2014.12.23 for ITS 254979
           }
           onClicked:
           {
               EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main Prev(mouseAreaLeft) clicked" )
               EngineListenerMain.ManualBeep() // added by Michael.Kim 2014.07.04 for ITS 240747
               visualcue_main.prev_clicked()
           }

       }
   }

   Rectangle{
       id: rectCenter
       color: "transparent"
       anchors
       {
           top: parent.top
           left: rectLeft.right
       }
       width:176
       height:157
       clip:false

       MouseArea{
           id: mouseAreaCenter
           anchors.fill:parent
           enabled: !visualcue_main_model.get( CONST.const_VISUALCUE_BTN_NUMBER ).is_dimmed && !root.toastVisible
           noClickAfterExited: true
           beepEnabled: false // added by Michael.Kim 2014.07.04 for ITS 240747
           // {added by Michael.Kim 2014.02.28 for ITS 227487
           onPressed:  visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", true )

           onClicked:
           {
               EngineListenerMain.ManualBeep() // added by Michael.Kim 2014.07.04 for ITS 240747
               visualcue_main.center_clicked()
               visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", false )
           }

           onReleased: visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", false )

           onExited: visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", false )

           onCanceled: visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", false )
           // }added by Michael.Kim 2014.02.28 for ITS 227487

       }
   }

   Rectangle{
       id: rectRight
       color: "transparent"
       anchors
       {
           top: parent.top
           topMargin: CONST.const_VISUAL_CUE_MA_TOP_MARGIN // added by cychoi 2015.11.06 for ISV 120461
           left: rectCenter.right
       }
       width:105 //157 - CONST.const_VISUAL_CUE_MA_LEFT_MARGIN // modified by cychoi 2015.11.06 for ISV 120461
       height:150
       clip:false

       MouseArea{
           id: mouseAreaRight
           anchors.fill:parent
           enabled: !visualcue_main_model.get( CONST.const_FOR_BTN_NUMBER ).is_dimmed && !root.toastVisible
           noClickAfterExited: true
           beepEnabled: false // added by Michael.Kim 2014.07.04 for ITS 240747
           onPressed:
           {
               EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main Next(mouseAreaRight) pressed" )
               visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", true );
           }
           onReleased:
           {
               visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", false );
           }

           onExited:
           {
               visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", false )
               // removed by sangmin.seol 2014.12.23 for ITS 254979
           }

           onCanceled:
           {
               visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", false )
               // removed by sangmin.seol 2014.12.23 for ITS 254979
           }
           onClicked:
           {
               EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main Next(mouseAreaRight) clicked" )
               EngineListenerMain.ManualBeep() // added by Michael.Kim 2014.07.04 for ITS 240747
               visualcue_main.next_clicked()
           }

       }
   }
// added for expand touch area

   Row
   {
      id: bottomElements
      spacing: CONST.const_VISUAL_CUE_ELEMENTS_SPACING
      Repeater
      {
         id: bottom_repeater
         model: visualcue_main_model
         delegate: btnDelegate
      }
   }

   Component
   {
      id: btnDelegate

      Image
      {
         id: image_main
         anchors.verticalCenter: parent.verticalCenter
         width: btn_width
         height: btn_height
         source: image_main_url
         //[NA][ITS][172609][ minor](aettie.ji)
         property bool is_dimmed: model.is_dimmed || false
         property bool is_pressed: model.is_pressed || false
         // removed by sangmin.seol 2014.12.23 for ITS 254979
         //[KOR][ITS][181070][minor](aettie.ji)
         property url image_main_url: model.is_dimmed ? ( model.icon_d || "" ) : "" // modified by sangmin.seol 2014.12.23 for ITS 254979

         /** Focus image */
         Image
         {
             id: visual_cue_icon
             anchors.verticalCenter: parent.verticalCenter
             anchors.horizontalCenter: parent.horizontalCenter
             // { modified by sangmin.seol 2014.12.23 for ITS 254979
             visible: !main_image.is_dimmed
             source: is_pressed ? (icon_p || "") :
                        visualcue_main.is_focused && btn_id == "CenterButton" ?  (icon_f || "") : (icon_n || "")
             // } modified by sangmin.seol
         }

         /** Wheel left image */
         Image
         {
            id: wheel_left
            anchors.top: parent.top
            anchors.topMargin: CONST.const_VISUAL_CUE_WHEEL_TOP_MARGIN
            anchors.left: parent.left
            anchors.leftMargin: CONST.const_VISUAL_CUE_WHEEL_L_LEFT_MARGIN
            // { modified by yungi 2013.3.17 for ISV 76162
            //modified by aettie 20130531 zoom arrow
            source: (image_main.is_dimmed || image_main.is_unsupported || (imageViewer.mainImageScale <= 1)) ? ( model.icon2_l_d || "" ): ( model.icon2_l_p || "" )
            /* source: image_main.is_dimmed ? ( model.icon2_l_d || "" ):
                    ( visualcue_main.is_focused ? ( model.icon2_l_p || "" ) : ( model.icon2_l_n || "" ) )
            */
            // } modified by yungi 2013.3.17 for ISV 76162
         }

         /** Wheel right image */
         Image
         {
            id: wheel_right
            anchors.top: parent.top
            anchors.topMargin: CONST.const_VISUAL_CUE_WHEEL_TOP_MARGIN
            anchors.left: parent.left
            anchors.leftMargin: CONST.const_VISUAL_CUE_WHEEL_R_LEFT_MARGIN
            // { modified by yungi 2013.3.17 for ISV 76162
            //modified by aettie 20130531 zoom arrow
            source:( image_main.is_dimmed || image_main.is_unsupported || (imageViewer.mainImageScale >= 4)) ? ( model.icon2_r_d || "" ): ( model.icon2_r_p || "" )
            /* source: image_main.is_dimmed ? ( model.icon2_r_d || "" ):
                    ( visualcue_main.is_focused ? ( model.icon2_r_p || "" ) : ( model.icon2_r_ || "") )
            */
            // } modified by yungi 2013.3.17 for ISV 76162
         }

         Connections
         {
             target:EngineListenerMain
             onTickerChanged:
             {
                 if(ticker)
                     reset()
             }
         }  //added by nhj 2013.9.27 for ITS 0191846

         MouseArea
         {
            id: mouseArea
            anchors.fill: parent
            enabled: !is_dimmed && !root.toastVisible // added by wspark 2013.03.11 for ISV 69413
         //[KOR][ITS][180462][minor](aettie.ji)
            //added by suilyou 20130910 for ITS 0183002 START
            noClickAfterExited: true
            beepEnabled: false //added by Michael.Kim 2014.07.04 for ITS 240747
            onPressed:
            {
                switch(model.btn_id)
                {
                    case "Prev":
                    {
                        visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", true );
                        break;
                    }
                    case "Next":
                    {
                        visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", true );
                        break;
                    }
                    case "CenterButton":
                    {
                        visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", true ); // added by Michael.Kim 2014.02.28 for ITS 227487
                        break;
                    }
                }
            }
            onReleased:
            {
                switch(model.btn_id)
                {
                    case "Prev":
                    {
                        visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", false );
                        break;
                    }
                    case "Next":
                    {
                        visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", false );
                        break;
                    }
                    case "CenterButton":
                    {
                        visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", false ); // added by Michael.Kim 2014.02.28 for ITS 227487
                        break;
                    }

                }
            }
            //added by suilyou 20130910 for ITS 0183002 END
           onExited:
           {
                EngineListenerMain.qmlLog("[MP_Photo] onExited")
               switch( model.btn_id )
               {
                  case "Prev":
                  {
                     EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main Prev onExited" )
                      visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", false )//added by suilyou 20130910 for ITS 0183002
                      // removed by sangmin.seol 2014.12.23 for ITS 254979
                      break;
                  }
                  case "Next":
                  {
                     EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main Next onExited" )
                      visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", false )//added by suilyou 20130910 for ITS 0183002
                      // removed by sangmin.seol 2014.12.23 for ITS 254979
                      break;
                  }
                  case "CenterButton":
                  {
                      visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", false ); // added by Michael.Kim 2014.02.28 for ITS 227487
                      break;
                  }
                }
            }

           //{added by Michael.Kim 2013.09.24 for ITS 190815
           onCanceled:
           {
               EngineListenerMain.qmlLog("[MP_Photo] onCanceled")
               switch( model.btn_id )
               {
                  case "Prev":
                  {
                     EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main Prev onCanceled" )
                     visualcue_main_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", false )//added by suilyou 20130910 for ITS 0183002
                     // removed by sangmin.seol 2014.12.23 for ITS 254979
                     break;
                  }
                  case "Next":
                  {
                     EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main Next onCanceled" )
                     visualcue_main_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", false )//added by suilyou 20130910 for ITS 0183002
                     // removed by sangmin.seol 2014.12.23 for ITS 254979
                     break;
                  }
                  case "CenterButton":
                  {
                      visualcue_main_model.setProperty( CONST.const_VISUALCUE_BTN_NUMBER, "is_pressed", false ); // added by Michael.Kim 2014.02.28 for ITS 227487
                      break;
                  }
                }
            }
            //}added by Michael.Kim 2013.09.24 for ITS 190815

            onClicked:
            {
               switch( model.btn_id )
               {
                  case "Prev":
                  {
                     EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main Prev clicked" )
                     EngineListenerMain.ManualBeep() // added by Michael.Kim 2014.07.04 for ITS 240747
                     visualcue_main.prev_clicked()
                     break;
                  }

                  case "CenterButton":
                  {
                     EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main CenterButton clicked" )
                     EngineListenerMain.ManualBeep() // added by Michael.Kim 2014.07.04 for ITS 240747
                     visualcue_main.center_clicked()
                     break;
                  }

                  case "Next":
                  {
                     EngineListenerMain.qmlLog( "[MP_Photo] visualcue_main Next clicked" )
                     EngineListenerMain.ManualBeep() // added by Michael.Kim 2014.07.04 for ITS 240747
                     visualcue_main.next_clicked()
                     break;
                  }
               }
            }
         }
      }
   }

   ListModel
   {
      id: visualcue_main_model

      ListElement
      {
         btn_id: "dummy"
         icon_p: "/app/share/images/general/dummy.png"
         icon_n: "/app/share/images/general/dummy.png"
         icon_d: "/app/share/images/general/dummy.png"
         icon_f: "/app/share/images/general/dummy.png"

         btn_width: 52 // modified by cychoi 2015.11.06 for ISV 120461
         btn_height: 1
         is_dimmed: false
         is_pressed: false
         // removed by sangmin.seol 2014.12.23 for ITS 254979
      }  // added for expand touch area

      ListElement
      {
         btn_id: "Prev"
//modified by aettie 2013 08 07 for ITS_181070
         icon_p: "/app/share/images/general/media_rew_p.png" // modified by sangmin.seol 2014.12.23 for ITS 254979
         icon_n: "/app/share/images/general/media_rew_n.png"
         icon_d: "/app/share/images/general/media_rew_d.png"
         icon_f: "/app/share/images/general/media_rew_f.png"

         btn_width: 90
         btn_height: 81
         is_dimmed: false
         is_pressed: false
         // removed by sangmin.seol 2014.12.23 for ITS 254979
      }

      ListElement
      {
         btn_id: "CenterButton"

         icon_n: "/app/share/images/general/media_visual_cue_n.png"
         icon_d: "/app/share/images/general/media_visual_cue_d.png"
         icon_f: "/app/share/images/general/media_visual_cue_f.png"
         icon_p: "/app/share/images/general/media_visual_cue_p.png" 	       //added by aettie 20130801 for ITS 181813

 //changed by Alexey Edelev. New images according new requirements. 2012.08.17
 //{
         icon2_l_n: "/app/share/images/photo/photo_wheel_zoom_l_n.png"
         icon2_l_p: "/app/share/images/photo/photo_wheel_zoom_l_f.png" //Changed by Alexey Edelev 2012.09.19. CR12989
         icon2_l_d: "/app/share/images/photo/photo_wheel_zoom_l_d.png"
         icon2_r_n: "/app/share/images/photo/photo_wheel_zoom_r_n.png"
         icon2_r_p: "/app/share/images/photo/photo_wheel_zoom_r_f.png" //Changed by Alexey Edelev 2012.09.19. CR12989
         icon2_r_d: "/app/share/images/photo/photo_wheel_zoom_r_d.png"
 //}
 //changed by Alexey Edelev. New images according new requirements. 2012.08.17
 //modified by aettie 20130625 for New GUI
         btn_width: 148
         btn_height: 157
         is_dimmed: false
         is_pressed: false
         // removed by sangmin.seol 2014.12.23 for ITS 254979
      }

      ListElement
      {
         btn_id: "Next"

         //Visual Cue Next Button
//modified by aettie 2013 08 07 for ITS_181070
         icon_p: "/app/share/images/general/media_for_p.png" // modified by sangmin.seol 2014.12.23 for ITS 254979
         icon_n: "/app/share/images/general/media_for_n.png"
         icon_d: "/app/share/images/general/media_for_d.png"
         icon_f: "/app/share/images/general/media_for_f.png"

         btn_width: 90
         btn_height: 81
         is_dimmed: false
         is_pressed: false
         // removed by sangmin.seol 2014.12.23 for ITS 254979
      }
   }
   function prev_clicked() {
      root.byFlick = true
      //imageViewer.previous();
       if(!nextPrevAsynTimer.running)
       {
           nextPrevAsynTimer.timerState = "prev"
           nextPrevAsynTimer.restart();
       }
   }

   function next_clicked() {
      root.byFlick = true
      //imageViewer.next();
       if(!nextPrevAsynTimer.running)
       {
           nextPrevAsynTimer.timerState = "next"
           nextPrevAsynTimer.restart();
       }
   }

   function center_clicked() {
   //[KOR][ITS][180467][minor](aettie.ji)
     // imageViewer.startSlideShow();
       if(imageViewer.imageLargerThanScreen)
           root.state = "zoom"
       else if (root.state == "fullScreen")
       {
           root.state = "normal"
           imageViewer.stopSlideShow();
       }
       else if(root.state == "normal")
       {
           // {modified by Michael.Kim 2013.10.01 for Hyundai Request
           root.state = "fullScreen"
           //imageViewer.startSlideShow();
           imageViewer.stopSlideShow();
           // }modified by Michael.Kim 2013.10.01 for Hyundai Request
       }
   }

   // modified for ITS 0208457
   Timer
   {
       id: nextPrevAsynTimer

       interval: 5000 // maximum next/prev timer
       running: false
       triggeredOnStart: true
       property string timerState: "none";

       onTriggered:
       {
           if(timerState == "next")
           {
               imageViewer.next();
           }
           else if(timerState == "prev")
           {
               imageViewer.previous();
           }
           timerState = "none";
           nextPrevAsynTimer.stop();
       }
   }
}
// modified by Dmitry 18.05.13
