import Qt 4.7
import "../../QML/DH" as MComp
import "../../system/DH" as MSystem

MComp.MComponent {
    id:idENGModeRDSAF
    y:10
    width: systemInfo.lcdWidth - (x*2); height: 90*6
    focus: true


    property int cellWidth      : 125
    property int cellHeight     : 45
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

    FocusScope {
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
                   x: 0; y: 0
                   text: "PSN"
                   color: colorInfo.dimmedGrey
                   font.pixelSize: 18
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
                   x: 0; y: 0
                   text: "PTY"
                   color: colorInfo.dimmedGrey
                   font.pixelSize: 18
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
                   x: 0; y: 0
                   text: "Q"
                   color: colorInfo.dimmedGrey
                   font.pixelSize: 18
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
                   x: 0; y: 0
                   text: "MP"
                   color: colorInfo.dimmedGrey
                   font.pixelSize: 18
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
                   x: 0; y: 0
                   text: "BW"
                   color: colorInfo.dimmedGrey
                   font.pixelSize: 18
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
                   id:id0_0;
                   x: 0; y: 0
                   text: "Data1"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   text: "Data1"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 20
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
                   id:id0_2;
                   x: 0; y: 0
                   text: "Data1"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   text: "Data1"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 18
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
                   id:id0_4;
                   x: 0; y: 0
                   text: "Data1"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id0_5;
                   x: 0; y: 0
                   text: "Data1"//UIListener.m_APP_VERSION
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
                   id:id0_6;
                   x: 0; y: 0
                   text: "Data1"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id0_7;
                   x: 0; y: 0
                   text: "Data1"//UIListener.m_APP_VERSION
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
                   id:id0_8;
                   x: 0; y: 0
                   text: "Data1"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id0_9;
                   x: 0; y: 0
                   text: "Data1"//UIListener.m_APP_VERSION
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
                   text: "AF1"
                   color: colorInfo.dimmedGrey
                   font.pixelSize: 18
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
                   text: "AF2"
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
                   text: "AF3"
                   color: colorInfo.dimmedGrey
                   font.pixelSize: 18
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
                   text: "AF4"
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
                   text: "AF5"
                   color: colorInfo.dimmedGrey
                   font.pixelSize: 18
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
                   text: "AF6"
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
                   text: "TP / TA"
                   color: colorInfo.dimmedGrey
                   font.pixelSize: 18
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
                   id:id1_0;
                   x: 0; y: 0
                   text: "Freq1"//UIListener.m_APP_VERSION
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
                   id:id1_1;
                   x: 0; y: 0
                   text: "Freq2"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   text: "Freq3"//UIListener.m_APP_VERSION
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
                   id:id1_3;
                   x: 0; y: 0
                   text: "Freq4"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   text: "Freq5"//UIListener.m_APP_VERSION
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
                   id:id1_5;
                   x: 0; y: 0
                   text: "Freq6"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id1_6;
                   x: 0; y: 0
                   text: "TP/TA"//UIListener.m_APP_VERSION
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
                   id:id1_7;
                   x: 0; y: 0
                   text: "PD mode"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id2_0;
                   x: 0; y: 0
                   text: "FS1"//UIListener.m_APP_VERSION
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
                   id:id2_1;
                   x: 0; y: 0
                   text: "FS2"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   text: "FS3"//UIListener.m_APP_VERSION
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
                   id:id2_3;
                   x: 0; y: 0
                   text: "FS4"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   text: "FS5"//UIListener.m_APP_VERSION
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
                   id:id2_5;
                   x: 0; y: 0
                   text: "FS6"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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

       //2Page, 6nd line
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
                   id:id3_0;
                   x: 0; y: 0
                   text: "MP1"//UIListener.m_APP_VERSION
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
                   id:id3_1;
                   x: 0; y: 0
                   text: "MP2"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   text: "MP3"//UIListener.m_APP_VERSION
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
                   id:id3_3;
                   x: 0; y: 0
                   text: "MP4"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id3_4;
                   x: 0; y: 0
                   text: "MP5"//UIListener.m_APP_VERSION
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
                   id:id3_5;
                   x: 0; y: 0
                   text: "MP6"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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

       //2Page, 7nd line
       Row {
           x: 5; y: cellHeight * 6;
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
                   id:id4_0;
                   x: 0; y: 0
                   text: "USN1"//UIListener.m_APP_VERSION
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
                   id:id4_1;
                   x: 0; y: 0
                   text: "USN2"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id4_2;
                   x: 0; y: 0
                   text: "USN3"//UIListener.m_APP_VERSION
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
                   id:id4_3;
                   x: 0; y: 0
                   text: "USN4"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id4_4;
                   x: 0; y: 0
                   text: "USN5"//UIListener.m_APP_VERSION
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
                   id:id4_5;
                   x: 0; y: 0
                   text: "USN6"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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

       //2Page, 8nd line
       Row {
           x: 5; y: cellHeight * 7;
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
                   text: "SMALLQ"
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
                   id:id5_0;
                   x: 0; y: 0
                   text: "SMALLQ1"//UIListener.m_APP_VERSION
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
                   id:id5_1;
                   x: 0; y: 0
                   text: "SMALLQ2"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id5_2;
                   x: 0; y: 0
                   text: "SMALLQ3"//UIListener.m_APP_VERSION
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
                   id:id5_3;
                   x: 0; y: 0
                   text: "SMALLQ4"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id5_4;
                   x: 0; y: 0
                   text: "SMALLQ5"//UIListener.m_APP_VERSION
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
                   id:id5_5;
                   x: 0; y: 0
                   text: "SMALLQ6"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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

       //2Page, 9nd line
       Row {
           x: 5; y: cellHeight * 8;
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
                   text: "PI Code"
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
                   id:id6_0;
                   x: 0; y: 0
                   text: "PI Code1"//UIListener.m_APP_VERSION
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
                   id:id6_1;
                   x: 0; y: 0
                   text: "PI Code2"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id6_2;
                   x: 0; y: 0
                   text: "PI Code3"//UIListener.m_APP_VERSION
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
                   id:id6_3;
                   x: 0; y: 0
                   text: "PI Code4"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   id:id6_4;
                   x: 0; y: 0
                   text: "PI Code5"//UIListener.m_APP_VERSION
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
                   id:id6_5;
                   x: 0; y: 0
                   text: "PI Code6"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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

       //2Page, 10nd line
       Row {
           x: 5; y: cellHeight * 9;
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
                   text: "AF LOG"
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
                   firstText : "OFF"
                   firstTextX : (cellWidth - 10 )/2
                   firstTextY : (cellHeight - 10 )/2
                   firstTextWidth : cellWidth - 10
                   firstTextHeight: cellHeight - 10
                   firstTextSize :18
                   fgImageX: 0
                   fgImageY: 0
                   onClickOrKeySelected: {
                       aflog = 0;
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
                   firstText : "ON"
                   firstTextX : (cellWidth - 10 )/2
                   firstTextY : (cellHeight - 10 )/2
                   firstTextWidth : cellWidth - 10
                   firstTextHeight: cellHeight - 10
                   firstTextSize :18
                   fgImageX: 0
                   fgImageY: 0
                   onClickOrKeySelected: {
                       aflog = 1;
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
                   text: "AF MODE"
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
                   id:id7_0;
                   x: 0; y: 0
                   text: "Data1"
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
                   id:id7_1;
                   x: 0; y: 0
                   text: "Data1"
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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

       //2Page, 11nd line
       Row {
           x: 5; y: cellHeight * 10;
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
                   firstText : "1"
                   firstTextX : (cellWidth - 10 )/2
                   firstTextY : (cellHeight - 10 )/2
                   firstTextWidth : cellWidth - 10
                   firstTextHeight: cellHeight - 10
                   firstTextSize :18
                   fgImageX: 0
                   fgImageY: 0
                   onClickOrKeySelected: {
                       var cnt = QmlController.getEngModePage();
                       QmlController.setEngModePage(--cnt);
                       console.log("onClickOrKeySelected=======================>",engModePage);
                       QmlController.diagnosticInfoRequest(5, 0x01);
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
                   firstText : "2"
                   firstTextX : (cellWidth - 10 )/2
                   firstTextY : (cellHeight - 10 )/2
                   firstTextWidth : cellWidth - 10
                   firstTextHeight: cellHeight - 10
                   firstTextSize :18
                   fgImageX: 0
                   fgImageY: 0
                   onClickOrKeySelected: {
                       console.log("onClickOrKeySelected=======================>",engModePage);
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
                   firstText : "3"
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

    //KSW 140220
    Connections{
        target: QmlController
        onEngRdsData: {
//            console.log(">> RDSAF onEngRdsData == " + index);
            switch(command)
            {
                case 0x8612:
                {
                    switch(index)
                    {
                    case 1: //FREQ
                        id0_0.text = msg;
                        break;

                    case 2: //PSN
                        id0_1.text = msg;
                        break;

                    case 3: //PI Code
                        id0_2.text = msg;
                        break;

                    case 4: //PTY
                        id0_3.text = msg;
                        break;

                    case 5: //RDS Quality
                        id0_4.text = msg;
                        break;

                    case 6: //Q
                        id0_5.text = msg;
                        break;

                    case 7: //FS
                        id0_6.text = msg;
                        break;

                    case 8: //MP
                        id0_7.text = msg;
                        break;

                    case 9: //USN
                        id0_8.text = msg;
                        break;

                    case 10: //BW
                        id0_9.text = msg;
                        break;

                    case 11: //AF1 Freq
                        id1_0.text = msg;
                        break;

                    case 12: //AF1 FS
                        id2_0.text = msg;
                        break;

                    case 13: //AF1 MP
                        id3_0.text = msg;
                        break;

                    case 14: //AF1 USN
                        id4_0.text = msg;
                        break;

                    case 15: //AF1 SmallQ
                        id5_0.text = msg;
                        break;

                    case 16: //AF1 PI Code
                        id6_0.text = msg;
                        break;

                    case 17: //AF2 Freq
                        id1_1.text = msg;
                        break;

                    case 18: //AF2 FS
                        id2_1.text = msg;
                        break;

                    case 19: //AF2 MP
                        id3_1.text = msg;
                        break;

                    case 20: //AF2 USN
                        id4_1.text = msg;
                        break;

                    case 21: //AF2 SmallQ
                        id5_1.text = msg;
                        break;

                    case 22: //AF2 PI Code
                        id6_1.text = msg;
                        break;

                    case 23: //AF3 Freq
                        id1_2.text = msg;
                        break;

                    case 24: //AF3 FS
                        id2_2.text = msg;
                        break;

                    case 25: //AF3 MP
                        id3_2.text = msg;
                        break;

                    case 26: //AF3 USN
                        id4_2.text = msg;
                        break;

                    case 27: //AF3 SmallQ
                        id5_2.text = msg;
                        break;

                    case 28: //AF3 PI Code
                        id6_2.text = msg;
                        break;

                    case 29: //AF4 Freq
                        id1_3.text = msg;
                        break;

                    case 30: //AF4 FS
                        id2_3.text = msg;
                        break;

                    case 31: //AF4 MP
                        id3_3.text = msg;
                        break;

                    case 32: //AF4 USN
                        id4_3.text = msg;
                        break;

                    case 33: //AF4 SmallQ
                        id5_3.text = msg;
                        break;

                    case 34: //AF4 PI Code
                        id6_3.text = msg;
                        break;

                    case 35: //AF5 Freq
                        id1_4.text = msg;
                        break;

                    case 36: //AF5 FS
                        id2_4.text = msg;
                        break;

                    case 37: //AF5 MP
                        id3_4.text = msg;
                        break;

                    case 38: //AF5 USN
                        id4_4.text = msg;
                        break;

                    case 39: //AF5 SmallQ
                        id5_4.text = msg;
                        break;

                    case 40: //AF5 PI Code
                        id6_4.text = msg;
                        break;

                    case 41: //AF6 Freq
                        id1_5.text = msg;
                        break;

                    case 42: //AF6 FS
                        id2_5.text = msg;
                        break;

                    case 43: //AF6 MP
                        id3_5.text = msg;
                        break;

                    case 44: //AF6 USN
                        id4_5.text = msg;
                        break;

                    case 45: //AF6 SmallQ
                        id5_5.text = msg;
                        break;

                    case 46: //AF6 PI Code
                        id6_5.text = msg;
                        break;

                    case 47: //AF mode
                        id7_0.text = msg;
                        break;

                    case 48: //TMC Tuner
                        id7_1.text = msg;
                        break;

                    case 49: //PD mode
                        id1_7.text = msg;
                        break;

                    case 50: //TP/TA
                        id1_6.text = msg;
                        break;

                    default:
                        break;
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }
}
