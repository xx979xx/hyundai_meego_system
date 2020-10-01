import Qt 4.7
import "../../QML/DH" as MComp
import "../../system/DH" as MSystem

MComp.MComponent {
    id:idENGModeRadioReception
    width: systemInfo.lcdWidth - (x*2); height: 90*6

    focus: true

    property int cellWidth      : 125
    property int cellHeight     : 60
    property int firstLineHeight : 0

    property int    antMode  : 0 // -1
    property int    st : 1 // -1
    property int    bg : 1 // -1
    property int    af :  1 // -1
    property int    tmc : 1 //-1

    property int    erase  : 0
    property int    aflog  : -1 // JSH 130508 added

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id : colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    property int mItemHeight : 35 //KSW 140220

   ///first line
   Row {
       x : 5
       spacing: 2
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "FREQ"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id0_0;
               x: 0; y: 0
               text: "";
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "PSN"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id0_1;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "PI CODE"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id0_2;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "TP / TA"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id0_3;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "PTY"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id0_4;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 20
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
   }
   //2nd line
   Row {
       x: 5; y: cellHeight;
       spacing: 2
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "RDS Quality"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id1_0;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "Q"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id1_1;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "FS"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id1_2;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "MP"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id1_3;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "USN"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id1_4;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
   }

   //3nd line
   Row {
       x: 5; y: cellHeight * 2;
       spacing: 2
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "BW"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id2_0;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "ST (%)"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id2_1;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "EON PI"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id2_2;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "EON TP / TA"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id2_3;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "EON PS"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id2_4;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
   }

   //4nd line
   Row {
       x: 5; y: cellHeight * 3;
       spacing: 2
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "PD MODE"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id3_0;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "TMC TUNER"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id3_1;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               id:id3_2;
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
   }

   //5nd line
   Row {
       x: 5; y: cellHeight * 4;
       spacing: 2
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "ANT MODE"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5 + cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey

           MComp.MButton{
               x:5; y: 5
               width: cellWidth - 10; height: cellHeight - 10
               bgImage: imgFolderGeneral+"btn_title_sub_n.png"
               bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
               bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
               bgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"//
               firstText : "PD mode"
               firstTextX : 20
               firstTextY : (cellHeight - 10 )/2
               firstTextWidth : cellWidth - 10
               firstTextHeight: cellHeight - 10
               firstTextSize :18
               fgImageX: 0
               fgImageY: 0
               onClickOrKeySelected: {
                   console.log("onClickOrKeySelected==>",engModePage);
                   antMode = 0;
                   QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd);
               }
           }
       }
       Rectangle{
           x: 5 + cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey

           MComp.MButton{
               x:5; y: 5
               width: cellWidth - 10; height: cellHeight - 10
               bgImage: imgFolderGeneral+"btn_title_sub_n.png"
               bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
               bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                              bgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"//
               firstText : "Main ANT"
               firstTextX : 15
               firstTextY : (cellHeight - 10 )/2
               firstTextWidth : cellWidth - 10
               firstTextHeight: cellHeight - 10
               firstTextSize :18
               fgImageX: 0
               fgImageY: 0
               onClickOrKeySelected: {
                   console.log("onClickOrKeySelected==>",engModePage);
                   antMode=1;
                   QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd);
               }
           }
       }

       Rectangle{
           x: 5 + cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey

           MComp.MButton{
               x:5; y: 5
               width: cellWidth - 10; height: cellHeight - 10
               bgImage: imgFolderGeneral+"btn_title_sub_n.png"
               bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
               bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
               bgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"//
               firstText : "Sub ANT"
               firstTextX : 20
               firstTextY : (cellHeight - 10 )/2
               firstTextWidth : cellWidth - 10
               firstTextHeight: cellHeight - 10
               firstTextSize :18
               fgImageX: 0
               fgImageY: 0
               onClickOrKeySelected: {
                   console.log("onClickOrKeySelected==>",engModePage);
                   antMode = 2;
                   QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd);
               }
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
   }

   //6nd line
   Row {
       x: 5; y: cellHeight * 5;
       spacing: 2

       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "PAGE"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5 + cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey

           MComp.MButton{
               x:5; y: 5
               width: cellWidth - 10; height: cellHeight - 10
               bgImage: imgFolderGeneral+"btn_title_sub_n.png"
               bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
               bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                              bgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"//
               firstText : "1"
               firstTextX : (cellWidth - 10 )/2
               firstTextY : (cellHeight - 10 )/2
               firstTextWidth : cellWidth - 10
               firstTextHeight: cellHeight - 10
               firstTextSize :18
               fgImageX: 0
               fgImageY: 0
               onClickOrKeySelected: {
                   console.log("onClickOrKeySelected=======================>",engModePage);
//                       if(idAppMain.m_bDebugInfo)
//                           idAppMain.m_bDebugInfo = false
//                       else
//                           idAppMain.m_bDebugInfo = true
               }
           }
       }
       Rectangle{
           x: 5 + cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           MComp.MButton{
               x:5; y: 5
               width: cellWidth - 10; height: cellHeight - 10
               bgImage: imgFolderGeneral+"btn_title_sub_n.png"
               bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
               bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                              bgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"//
               firstText : "2"
               firstTextX : (cellWidth - 10 )/2
               firstTextY : (cellHeight - 10 )/2
               firstTextWidth : cellWidth - 10
               firstTextHeight: cellHeight - 10
               firstTextSize :18
               fgImageX: 0
               fgImageY: 0
               onClickOrKeySelected: {
                   var cnt = QmlController.getEngModePage();
                   QmlController.setEngModePage(++cnt);
                   console.log("onClickOrKeySelected=======================>",engModePage);
                   QmlController.diagnosticInfoRequest(1,0x01);
               }
           }
       }

       Rectangle{
           x: 5 + cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           MComp.MButton{
               x:5; y: 5
               width: cellWidth - 10; height: cellHeight - 10
               bgImage: imgFolderGeneral+"btn_title_sub_n.png"
               bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
               bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                              bgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"//
               firstText : "3"
               firstTextX : (cellWidth - 10 )/2
               firstTextY : (cellHeight - 10 )/2
               firstTextWidth : cellWidth - 10
               firstTextHeight: cellHeight - 10
               firstTextSize :18
               fgImageX: 0
               fgImageY: 0
               onClickOrKeySelected: {
                   QmlController.setEngModePage(2);
                   console.log("onClickOrKeySelected=======================>",engModePage);
                   QmlController.diagnosticInfoRequest(4,0x01);
               }
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: "AF ON"
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5 + cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           MComp.MButton{
               x:5; y: 5
               width: cellWidth - 10; height: cellHeight - 10
               bgImage: imgFolderGeneral+"btn_title_sub_n.png"
               bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
               bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                              bgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"//
               firstText : "OFF"
               firstTextX : (cellWidth - 10 )/2
               firstTextY : (cellHeight - 10 )/2
               firstTextWidth : cellWidth - 10
               firstTextHeight: cellHeight - 10
               firstTextSize :18
               fgImageX: 0
               fgImageY: 0
               onClickOrKeySelected: {
                   af = 0;
                   QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd);
               }
           }
       }
       Rectangle{
           x: 5 + cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           MComp.MButton{
               x:5; y: 5
               width: cellWidth - 10; height: cellHeight - 10
               bgImage: imgFolderGeneral+"btn_title_sub_n.png"
               bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
               bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                              bgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"//
               firstText : "ON"
               firstTextX : (cellWidth - 10 )/2
               firstTextY : (cellHeight - 10 )/2
               firstTextWidth : cellWidth - 10
               firstTextHeight: cellHeight - 10
               firstTextSize :18
               fgImageX: 0
               fgImageY: 0
               onClickOrKeySelected: {
                   af = 1;
                   QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd);
               }
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""//UIListener.m_APP_VERSION
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
       Rectangle{
           x: 5; y: firstLineHeight
           width:cellWidth ; height: cellHeight
//               width: 250; height: mItemHeight
           color: "transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""
               color: colorInfo.dimmedGrey
               font.pixelSize: 18
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }

       Rectangle{
           x: 5+cellWidth; y: firstLineHeight
           width:cellWidth ; height: cellHeight
           color:"transparent"
           border.width: 2
           border.color: colorInfo.dimmedGrey
           Text{
               x: 0; y: 0
               text: ""//UIListener.m_APP_VERSION
               color: colorInfo.bandBlue
               font.pixelSize: 24
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
   }

   //KSW 140220
//    onVisibleChanged: {
//        if(!visible){
//            //engineerMode = 0//!engineerMode
//            if(engineerModeSelected < 0)
//                return;

//            //QmlController.diagnosticInfoRequest(engineerModeSelected,0x00);
//            currentPage             = -1
//            engineerModeSelected    = -1;
//            idRadioENGModeMain.dealerMode = false;
//        }
//    }


    ///////////////////////////////////////////////////////////////////
//    onBackKeyPressed:{ // JSH 130527 added
//        var cnt = QmlController.getEngModePage();
//        if(cnt)
//            QmlController.setEngModePage(--cnt);

//        engineerMode = 0//!engineerMode
//        if(engineerModeSelected < 0)
//            return;
//        currentPage             = -1
//        engineerModeSelected    = -1;
//        idRadioENGModeMain.dealerMode = false;

//        UIListener.HandleBackKey(idAppMain.enterType);
//    }

    //140220
    Connections{
        target: QmlController
        onEngRdsData: {
//            console.log(">> Reception onEngRdsData == " + index);
            switch(command)
            {
                case 0x8615:
                {
                    switch(index)
                    {
                    case 1 : //FREQ
                        id0_0.text = msg;
                        break;
                    case 2: //PSN
                        id0_1.text = msg;
                        break;
                    case 3: //PI Code
                        id0_2.text = msg;
                        break;
                    case 4 : //TP/TA
                        id0_3.text = msg;
                        break;
                    case 5 : //PTY
                        id0_4.text = msg;
                        break;
                    case 6 : //RDS Quality
                        id1_0.text = msg;
                        break;
                    case 7 : // Q
                        id1_1.text = msg;
                        break;
                    case 8 : // FS
                        id1_2.text = msg;
                        break;
                    case 9 : // MP
                        id1_3.text = msg;
                        break;
                    case 10 : // USN
                        id1_4.text = msg;
                        break;
                    case 11 : // BW
                        id2_0.text = msg;
                        break;
                    case 12 : // ST(%)
                        id2_1.text = msg;
                        break;
                    case 13 : // EON PI
                        id2_2.text = msg;
                        break;
                    case 14 : // EON TP/TA
                        id2_3.text = msg;
                        break;
                    case 15 : // EON PSN
                        id2_4.text = msg;
                        break;
                    case 16 : // PD mode
                        id3_0.text = msg;
                        break;
                    case 17: //TMC TUNER
                        id3_1.text = msg;
                        break;
                    }
                    break;
                }
                default:
                    break;
            }
        }
        onChangeEngModePage :{
            if(!rdsPage) return;

            console.log(">> onChangeEngModePage : " + page);

           switch(page)
           {
           case 0:
               engineerModeSelected = 5; //RadioInfo
               break;
           case 1:
               engineerModeSelected = 1; //RDS
               break;
           case 2:
               engineerModeSelected = 4; //TMC
               break;
           default:
               engineerModeSelected = -1;
               break;

           }
        }
    }
}
