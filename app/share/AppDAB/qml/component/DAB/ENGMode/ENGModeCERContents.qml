import Qt 4.7
import "../../QML/DH" as MComp

MComp.MComponent {
    id:idENGModeCERContents

    width: systemInfo.lcdWidth;
    height: systemInfo.subMainHeight - 72

    property int mCERValueFirstLine : 0
    property int mCERValueSecondLine : 35
    property int mCERValueThirdLine : 70
    property int mCERValueFourthLine : 105
    property int mCERValueHeight : 35

    Image {
        y : 0//-systemInfo.statusBarHeight
        source : imageInfo.imgBg_Main
    }

    ENGModeCERControl{
        id: idENGModeCERControl
        x: 950; y: 0;
        KeyNavigation.up: idENGModeBand
    }

    //////////////////////////////////////////////////////////////////////////////////////////// DAB-DAB Linking CER Value
    Item{
        y: 20
        Text{
            x: 5; y: -30
            text: "DAB-DAB Linking CER Value"
            color: colorInfo.dimmedGrey
            font.pixelSize: 20
            font.family: idAppMain.fonts_HDB
        }
        //****************************** (1 Line)
        Rectangle{
            x: 5; y: mCERValueFirstLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB Worst"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueFirstLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mDAB_DABLinkingDABWorstCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (1 Line)
        Rectangle{
            x: 645 - 155; y: mCERValueFirstLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB BAD"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 960 - 220; y: mCERValueFirstLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mDAB_DABLinkingDABBadCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (2 Line)
        Rectangle{
            x: 5; y: mCERValueSecondLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB NoGood"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueSecondLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mDAB_DABLinkingDABNoGoodCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (2 Line)
        Rectangle{
            x: 645 - 155; y: mCERValueSecondLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB Good"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 960 - 220; y: mCERValueSecondLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mDAB_DABLinkingDABGoodCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************** (3 Line)
        Rectangle{
            x: 5; y: mCERValueThirdLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB+ Worst"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueThirdLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mDAB_DABLinkingDABPlusWorstCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (3 Line)
        Rectangle{
            x: 645 - 155; y: mCERValueThirdLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB+ DAB"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 960 - 220; y: mCERValueThirdLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mDAB_DABLinkingDABPlusBadCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (4 Line)
        Rectangle{
            x: 5; y: mCERValueFourthLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB+ NoGood"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueFourthLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mDAB_DABLinkingDABPlusNoGoodCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (4 Line)
        Rectangle{
            x: 645 - 155; y: mCERValueFourthLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB+ Good"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 960 - 220; y: mCERValueFourthLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text:  mDAB_DABLinkingDABPlusGoodCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////// Pink noise CER Value
    Item{
        y: 200
        Text{
            x: 5; y: -30
            text: "Pink noise CER Value"
            color: colorInfo.dimmedGrey
            font.pixelSize: 20
            font.family: idAppMain.fonts_HDB
        }

        //****************************** (1 Line)
        Rectangle{
            x: 5; y: mCERValueFirstLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "Pink UnMute Status Count"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueFirstLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mPinkNoiseUnMuteStatusCount
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 645 - 155; y: mCERValueFirstLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "Pink Mute Status Count"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 960 - 220; y: mCERValueFirstLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mPinkNoiseMuteStatusCount
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (2 Line)
        Rectangle{
            x: 5; y: mCERValueSecondLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB Good"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueSecondLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mPinkNoiseDABGoodCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 645 - 155; y: mCERValueSecondLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB BAD"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 960 - 220; y: mCERValueSecondLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mPinkNoiseDABBadCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (3 Line)
        Rectangle{
            x: 5; y: mCERValueThirdLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB+ Good"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueThirdLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mPinkNoiseDABPlusGoodCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 645 - 155; y: mCERValueThirdLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB+ BAD"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 960 - 220; y: mCERValueThirdLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mPinkNoiseDABPlusBadCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////// Signal Status CER Value
    Item{
        y: 350
        Text{
            x: 5; y: -30
            text: "Signal Status CER Value"
            color: colorInfo.dimmedGrey
            font.pixelSize: 20
            font.family: idAppMain.fonts_HDB
        }
        //****************************** (1 Line)
        Rectangle{
            x: 5; y: 0
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: mCERValueFirstLine
                text: "Signal Status count"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueFirstLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mSignalStatusCount
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (1 Line)
        Rectangle{
            x: 645 - 155; y: mCERValueFirstLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB BAD"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 960 - 220; y: mCERValueFirstLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mSignalDABBadCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (2 Line)
        Rectangle{
            x: 5; y: mCERValueSecondLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB NoGood"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueSecondLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mSignalDABNoGoodCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (2 Line)
        Rectangle{
            x: 645 - 155; y: mCERValueSecondLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB Good"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 960 - 220; y: mCERValueSecondLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mSignalDABGoodCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************** (3 Line)
        Rectangle{
            x: 5; y: mCERValueThirdLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB+ BAD"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueThirdLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mSignalDABPlusBadCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (3 Line)
        Rectangle{
            x: 645 - 155; y: mCERValueThirdLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB+ NoGood"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 960 - 220; y: mCERValueThirdLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mSignalDABPlusNoGoodCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** (4 Line)
        Rectangle{
            x: 5; y: mCERValueFourthLine
            width: 250; height: mCERValueHeight
            color: "transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "DAB+ Good"
                color: colorInfo.dimmedGrey
                font.pixelSize: 20
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            x: 320 - 65; y: mCERValueFourthLine
            width: 225; height: mCERValueHeight
            color:"transparent"
            border.width: 2
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: mSignalDABPlusGoodCERValue
                color: colorInfo.bandBlue
                font.pixelSize: 24
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
