import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MComponent {
    id:statuBar
    height:systemInfo.statusBarHeight

    MSystem.SystemInfo { id:systemInfo }

    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    signal goHomeMenu()

    function retranslateUi(languageId)
    {    }

    Column {
        Item{
            width:systemInfo.lcdWidth;height:systemInfo.statusBarHeight

            Image {
                id:staticBarImg
                source: imgFolderGeneral+"static_bar.png"
                smooth:true
            } // End Image
            MComp.Button {
                //x:1;y:1
                width:161; height:81
                txtAlign:"Left"

                bgImage:imgFolderGeneral+"btn_home_n.png"
                bgImagePressed:imgFolderGeneral+"btn_home_p.png"
                smooth:true
                //text:"Home MComp.Button"
                onClicked: {
                    UIListener.HandleHomeKey();
                }
            } // End Button
            MComp.Label {
                id:monthTxt
                x:178;//y:17
                //height:systemInfo.statusBarHeight
                txtAlign:"Left"
                //text:"DEC"
                function set()
                {
                  text = Qt.formatDateTime(new Date(), "MMM/dd AP h:mm:ss");
                }                 
            } // End Label
            Timer {
              id: textTimer
              interval: 1000
              repeat: true
              running: true
              triggeredOnStart: true
              onTriggered: {
                  monthTxt.set()
              }   
            } // End Timer

            Row{
                x:systemInfo.lcdWidth-281;y:20
                spacing: 11
                //layoutDirection:Qt.RightToLeft
                MComp.Label {
                    //x:191;y:20
                    width:43; height:43
                    bgImage:imgFolderGeneral+"indicator_bluetooth.png"
                    //bgImagePressed:bgImage
                    //text:"indicator_bluetooth"
                } // End Label
                MComp.Label {
                    //x:191;y:20
                    width:43; height:43
                    bgImage:imgFolderGeneral+"indicator_call_history.png"
                    //bgImagePressed:bgImage
                    //text:"indicator_call history"
                } // End Label
                MComp.Label {
                    //x:191;y:20
                    width:43; height:43
                    bgImage:imgFolderGeneral+"indicator_message.png"
                    //bgImagePressed:bgImage
                    //text:"indicator_message"
                } // End Label
                MComp.Label {
                    //x:191;y:20
                    width:43; height:43
                    bgImage:imgFolderGeneral+"indicator_sound.png"
                    //bgImagePressed:bgImage
                    //text:"indicator_sound.png"
                } // End Label
                MComp.Label {
                    //x:191;y:20
                    width:43; height:43
                    bgImage:imgFolderGeneral+"indicator_wifi.png"
                } // End Label
            } // End Row
        } // End Item
        MComp.Label {
            width:systemInfo.lcdWidth; height:13
            bgImage:imgFolderGeneral+"indicator_bar_shadow.png"
        }
    } // End Column
} // End Rectangle
