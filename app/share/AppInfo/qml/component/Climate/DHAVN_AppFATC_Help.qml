import QtQuick 1.0

import "../../component/QML/DH" as MComp
import "../../component/system/DH" as MSystem

FocusScope {
    focus : true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    property string title_string : qsTranslate("NonAV", "STR_HVAC_HELP")
    property string subTitle_ads : qsTranslate("NonAV", "STR_HVAC_strADS")
    property string subTitle_smartVent : qsTranslate("NonAV", "STR_HVAC_strSmartVent")
    property string subTitle_rear : qsTranslate("NonAV", "STR_HVAC_strRear")
    property string help_rear : qsTranslate("NonAV", "STR_HVAC_HELP_REAR")
    property string help_ads : qsTranslate("NonAV", "STR_HVAC_HELP_ADS")
    property string help_smartVent : qsTranslate("NonAV", "STR_HVAC_HELP_SVENT")

    MComp.MBand {
        id: idFATCBand
        x: 0; y: 0
        focus : true
        isArab: idClimateAppMain.isReverse
        titleText: title_string

        onBackKeyClicked: {
            //console.log(" #### onBackKeyClicked")
             closeHelpPage();
            //sendBackKeySignalTimer.start();
        }
    } // End MBand

    Rectangle {
        x:0;  y:systemInfo.titleAreaHeight
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight - y - systemInfo.statusBarHeight
        color: "black"

        Image {
            id: line_1
            y: 136
            x: (idClimateAppMain.isReverse)? 72-5 : 72
            source: imgFolderClimate + "climate_line.png"
            width: 1198; height: 2
        }

        Image {
            id: line_2
            y: line_1.y+215;
            x: 72
            source: imgFolderClimate + "climate_line.png"
            width: 1198; height: 2
        }

        Item {
            id: contentsArea
            x: 40
            y: 18
            width: 32+1136

            Image {
                id: image_index_1
                y: 0;
                x:(idClimateAppMain.isReverse)? contentsArea.width+25: 0
                source: imgFolderClimate + "climate_index.png"
                width: 25; height: 54
            }

            Text {
                id: subTitle_text_1
                text: subTitle_rear
                x: 32; y: 4
                width: 1136+15
                font.pixelSize: 32
                font.family: "DH_HDR"
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.commonGrey
                horizontalAlignment: {
                    if (idClimateAppMain.isReverse) {Text.AlignRight}
                    else {Text.AlignLeft}
                }
            }

            Text {
                id: help_text_1
                text: help_rear
                x: 32; y: subTitle_text_1.y+46
                font.pixelSize: 28
                width: 1136+15
                font.family: "DH_HDR"
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.dimmedGrey
                horizontalAlignment: {
                    if (idClimateAppMain.isReverse) {Text.AlignRight}
                    else {Text.AlignLeft}
                }
            }

            Image {
                id: image_index_2
                y:135;
                x:(idClimateAppMain.isReverse)? contentsArea.width+25 : 0
                source: imgFolderClimate + "climate_index.png"
                width: 25; height: 54
            }

            Text {
                id: subTitle_text_2
                text: subTitle_smartVent
                x: subTitle_text_1.x; y: subTitle_text_1.y + 135
                font.pixelSize: 32
                width: 1136+15
                font.family: "DH_HDR"
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.commonGrey
                horizontalAlignment: {
                    if (idClimateAppMain.isReverse) {Text.AlignRight}
                    else {Text.AlignLeft}
                }
            }

            Text {
                id: help_text_2
                text: help_smartVent
                x: 32; y: subTitle_text_2.y+46
                font.pixelSize: 28
                width: 1136+15
                font.family: "DH_HDR"
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.dimmedGrey
                horizontalAlignment: {
                    if (idClimateAppMain.isReverse) {Text.AlignRight}
                    else {Text.AlignLeft}
                }
            }

            Image {
                id: image_index_3
                y:image_index_2.y+215;
                x:(idClimateAppMain.isReverse)? contentsArea.width+25 : 0
                source: imgFolderClimate + "climate_index.png"
                width: 25; height: 54
            }

            Text {
                id: subTitle_text_3
                text: subTitle_ads
                x: subTitle_text_1.x; y: subTitle_text_2.y + 215
                font.pixelSize: 32
                width: 1136+15
                font.family: "DH_HDR"
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.commonGrey
                horizontalAlignment: {
                    if (idClimateAppMain.isReverse) {Text.AlignRight}
                    else {Text.AlignLeft}
                }
            }

            Text {
                id: help_text_3
                text: help_ads
                x: 32; y: subTitle_text_3.y+46
                font.pixelSize: 28
                width: 1136+15
                font.family: "DH_HDR"
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.dimmedGrey
                horizontalAlignment: {
                    if (idClimateAppMain.isReverse) {Text.AlignRight}
                    else {Text.AlignLeft}
                }
            }

        }

    }

//    Component.onCompleted: {
//        idFATCBand.forceActiveFocus();
//    }

    Keys.onPressed: {
        switch( event.key )
        {
            case Qt.Key_Backspace: //CCP BACK
            //case Qt.Key_Slash: //RRC Menu
            //case Qt.Key_L:  //CCP NENU HK
                //console.log(" #### BACK HK pressed")
                closeHelpPage();
                break;
            case Qt.Key_Return:
            case Qt.Key_Enter:
            case Qt.Key_I:
                //console.log(" #### CCP Enter HK pressed")
                break;
        }
    }

    Keys.onReleased: {
        switch( event.key )
        {
            case Qt.Key_Return:
            case Qt.Key_Enter:
            //case Qt.Key_I: //CCP NENU HK
                //console.log(" #### CCP Enter HK onReleased")
                sendBackKeySignalTimer.start();
                break;
        }
    }

    function closeHelpPage() {
        helpPageLoader.source = "";
        isHelpPageMode = false;
        id_topButton_rect.forceActiveFocus();
        console.log("==> closeHelpPage(),  id_topButton_rect.forceActiveFocus()");
    }

    function setStrings() {
        title_string = qsTranslate("NonAV", "STR_HVAC_HELP")
        subTitle_smartVent  = qsTranslate("NonAV", "STR_HVAC_strSmartVent")
        subTitle_ads = qsTranslate("NonAV", "STR_HVAC_strADS")
        subTitle_rear = qsTranslate("NonAV", "STR_HVAC_strRear")
        help_smartVent  = qsTranslate("NonAV", "STR_HVAC_HELP_SVENT")
        help_ads = qsTranslate("NonAV", "STR_HVAC_HELP_ADS")
        help_rear = qsTranslate("NonAV", "STR_HVAC_HELP_REAR")
    }

    Timer {
        id: sendBackKeySignalTimer
        interval: 200
        running: false
        repeat: false
        onTriggered: {
            //console.log(" #### sendBackKeySignalTimer onTriggered")
            closeHelpPage();
        }
    }

    Connections {
        target: uiListener
        onRetranslateUi: {
//            if (languageId==20) isReverse=true//idFATCBand.isArab=true;
//            else isReverse=false//idFATCBand.isArab=false;
            setStrings()
        }

        onSignalShowSystemPopup:{
            //console.log("onSignalShowSystemPopup")
            idFATCBand.backBtnShowFocus = false
        }
        onSignalHideSystemPopup:{
            //console.log("onSignalHideSystemPopup")
            idFATCBand.backBtnShowFocus = true
            //idFATCBand.forceActiveFocus()
        }
    }


}
