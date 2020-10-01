import Qt 4.7
import "../../QML/DH" as MComp
import "../../system/DH" as MSystem

////Dmb EngineerMode 
MComp.MComponent {
//FocusScope {
    id:idENGModeTMC
    y:10
    width: systemInfo.lcdWidth - (x*2); height: 90*6
    focus: true

//    property string imgFolderGeneral : imageInfo.imgFolderGeneral
//    property string imgFolderRadio : imageInfo.imgFolderRadio
//    property int engineerModeSelected : -1
//    property int prevEngineerModeSelected : -1
//    property int modeType :0      // 0: eng mode , 1: tune alignment
//    property int cmd      :0      // tune alignment command

//    property int delegatefontSize       : 0
    property int cellWidth      : 125
    property int cellHeight     : 60
    property int firstLineHeight : 0
//    property int delegateWidth          : 0

    property int    antMode  : 0 // -1
    property int    st : 1 // -1
    property int    bg : 1 // -1
    property int    af :  1 // -1
    property int    tmc : 1 //-1
//    property int    split : -1
//    property int    currentPage : -1
    property int    erase  : 0
    property int    aflog  : -1 // JSH 130508 added
//    property bool   dealerMode : false // JSH 131101
    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id : colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    property int mItemHeight : 35 //KSW 140220

    //**************************************** Ch Mgt background
//    Image {
//        y:-(systemInfo.statusBarHeight)
//        id: backGruond
//        source: imgFolderGeneral+"bg.png"
//    }

    //**************************************** Band
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
                   text: "TMC MODE"
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
                   id:id0_1;
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
                   id:id0_4;
                   x: 0; y: 0
                   text: "Data1"//UIListener.m_APP_VERSION
                   color: colorInfo.bandBlue
                   font.pixelSize: 24
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
                   text: "STATION"
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
                   text: "STATION1"//UIListener.m_APP_VERSION
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
                   text: "National Code"
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
                   text: "National Code1"//UIListener.m_APP_VERSION
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
                   text: "FREQ1"
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
                   text: "FREQ2"
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
                   text: "FREQ3"
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
                   text: "FREQ4"
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
                   text: "FREQ5"
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
                   text: "FREQ6"
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
                   text: "FREQ7"
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
                   text: "FREQ8"
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
                   text: "FREQ9"
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
                   text: "FREQ10"
                   color: colorInfo.dimmedGrey
                   font.pixelSize: 18
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
                   id:id2_0;
                   x: 0; y: 0
                   text: "FREQ1"//UIListener.m_APP_VERSION
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
                   id:id2_1;
                   x: 0; y: 0
                   text: "FREQ2"//UIListener.m_APP_VERSION
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
                   id:id2_2;
                   x: 0; y: 0
                   text: "FREQ3"//UIListener.m_APP_VERSION
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
                   id:id2_3;
                   x: 0; y: 0
                   text: "FREQ4"//UIListener.m_APP_VERSION
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
                   id:id2_4;
                   x: 0; y: 0
                   text: "FREQ5"//UIListener.m_APP_VERSION
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
                   id:id2_5;
                   x: 0; y: 0
                   text: "FREQ6"//UIListener.m_APP_VERSION
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
                   id:id2_6;
                   x: 0; y: 0
                   text: "FREQ7"//UIListener.m_APP_VERSION
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
                   id:id2_7;
                   x: 0; y: 0
                   text: "FREQ8"//UIListener.m_APP_VERSION
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
                   id:id2_8;
                   x: 0; y: 0
                   text: "FREQ9"//UIListener.m_APP_VERSION
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
                   id:id2_9;
                   x: 0; y: 0
                   text: "FREQ10"//UIListener.m_APP_VERSION
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
                   firstText : "1"
                   firstTextX : (cellWidth - 10 )/2
                   firstTextY : (cellHeight - 10 )/2
                   firstTextWidth : cellWidth - 10
                   firstTextHeight: cellHeight - 10
                   firstTextSize :18
                   fgImageX: 0
                   fgImageY: 0
                   onClickOrKeySelected: {
                       QmlController.setEngModePage(0);
                       QmlController.diagnosticInfoRequest(5, 0x01);
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
                       QmlController.setEngModePage(--cnt);
                       QmlController.diagnosticInfoRequest(1,0x01);
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
                       console.log("onClickOrKeySelected=======================>",engModePage);
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
//            console.log(">> TMC onEngRdsData == " + index);
            switch(command)
            {

                case 0x8614:
                {
                    switch(index)
                    {
                    case 0:
                        id0_0.text = msg;
                        break;
                    case 1:
                        id0_1.text = msg;
                        break;
                    case 2:
                        id0_2.text = msg;
                        break;
                    case 3:
                        id0_3.text = msg;
                        break;
                    case 4:
                        id0_4.text = msg;
                        break;
                    case 5:
                        id1_0.text = msg;
                        break;
                    case 6:
                        id1_1.text = msg;
                        break;
                    case 7:
                        id2_0.text = msg;
                        break;
                    case 8:
                        id2_1.text = msg;
                        break;
                    case 9:
                        id2_2.text = msg;
                        break;
                    case 10:
                        id2_3.text = msg;
                        break;
                    case 11:
                        id2_4.text = msg;
                        break;
                    case 12:
                        id2_5.text = msg;
                        break;
                    case 13:
                        id2_6.text = msg;
                        break;
                    case 14:
                        id2_7.text = msg;
                        break;
                    case 15:
                        id2_8.text = msg;
                        break;
                    case 16:
                        id2_9.text = msg;
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
