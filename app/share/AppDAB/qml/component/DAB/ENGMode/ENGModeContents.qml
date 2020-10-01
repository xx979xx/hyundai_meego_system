/**
 * FileName: ENGModeContents.qml
 * Author: HYANG
 * Time: 2013-02-15
 *
 * - 2013-02-15 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent {
    id:idDabENGModeListView

    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property int mItemFirstLine : 0
    property int mItemSecondLine : 35
    property int mItemThirdLine : 70
    property int mItemFourthLine : 105
    property int mItemHeight : 35

    MComp.MComponent{
        id: idText
        x: 0; y: 0
        width: 1000; height: 550
        Flickable{
            id: idFlickable
            contentX: 0; contentY: 0
            contentWidth: 1000
            contentHeight: 1130
            flickableDirection: Flickable.VerticalFlick;
            boundsBehavior: Flickable.StopAtBounds//Flickable.DragAndOvershootBounds //Flickable.StopAtBounds  //
            anchors.fill: parent;
            clip: true

            //****************************** S/W Version (1 Line)
            Rectangle{
                x: 5; y: 0
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "S/W Version"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 320 - 65; y: 0
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: UIListener.m_APP_VERSION
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            //****************************** Module Bootloader Version (1 Line)
            Rectangle{
                x: 645 - 155; y: 0
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "Module Bootloader Version"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 960 - 220; y: 0
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: DABListener.m_sBootloaderVer
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            //****************************** Module Kerner Version (2 Line)
            Rectangle{
                x: 5; y: 35
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "Module Kerner Version"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 320 - 65; y: 35
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: DABListener.m_sKernelVer
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            //****************************** Module Application Version (2 Line)
            Rectangle{
                x: 645 - 155; y: 35
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "Module Application Version"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 960 - 220; y: 35
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text:   DABListener.m_sApplicationVer
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            //****************************** Frequency (3 Line)
            Rectangle{
                x: 5; y: 70
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "Frequency"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 320 - 65; y: 70
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: m_sFrequencyID
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            //****************************** Ensemble Label (3 Line)
            Rectangle{
                x: 645 - 155; y: 70
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "Ensemble Label"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 960 - 220; y: 70
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: m_sEnsembleName
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            //****************************** Service Label (4 Line)
            Rectangle{
                x: 5; y: 105
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "Service Label"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 320 - 65; y: 105
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: m_sServiceName
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            //****************************** ServeiceID (4 Line)
            Rectangle{
                x: 645 - 155; y: 105
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "ServeiceID"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 960 - 220; y: 105
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text:  m_serviceID
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            //****************************** CER (5 Line)
            Rectangle{
                x: 5; y: 140
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "CER"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 320 - 65; y: 140
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: MDabOperation.checkCER(m_iCER)
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            //****************************** Bitrate (5 Line)
            Rectangle{
                x: 645 - 155; y: 140
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "Bitrate"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 960 - 220; y: 140
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: m_iBitrate
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            //****************************** SNR (6 Line)
            Rectangle{
                x: 5; y: 175
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "SNR"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 320 - 65; y: 175
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: MDabOperation.checSNR(m_iSNR)
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            //****************************** RSSI (6 Line)
            Rectangle{
                x: 645 - 155; y: 175
                width: 250; height: mItemHeight
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: "RSSI"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 18
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                x: 960 - 220; y: 175
                width: 225; height: mItemHeight
                color:"transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    x: 0; y: 0
                    text: MDabOperation.checRSSI(m_iRSSI)
                    color: colorInfo.bandBlue
                    font.pixelSize: 24
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            //////////////////////////////////////////////////////////////////////////////////////////// Timeout Conotrol

            Item{
                y: 210
                //****************************** Ann.End (1 Line)
                Rectangle{
                    x: 5; y: 0
                    width: 250; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: "Ann.End"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle{
                    x: 320 - 65; y: 0
                    width: 225; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: mAnnounceTimeout
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                //****************************** Ann.End Delay (1 Line)
                Rectangle{
                    x: 645 - 155; y: 0
                    width: 250; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: "Ann.End Delay"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle{
                    x: 960 - 220; y: 0
                    width: 225; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: mAnnounceDelayTimeout
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                //****************************** Ann.Weak (2 Line)
                Rectangle{
                    x: 5; y: 35
                    width: 250; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: "Ann.Weak"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle{
                    x: 320 - 65; y: 35
                    width: 225; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: mAnnounceWeakTimeout
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                //****************************** Seek timeout (2 Line)
                Rectangle{
                    x: 645 - 155; y: 35
                    width: 250; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: "Seek timeout"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle{
                    x: 960 - 220; y: 35
                    width: 225; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: mSeekTimeout
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                //****************************** SLS timeout (3 Line)
                Rectangle{
                    x: 5; y: 70
                    width: 250; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: "SLS timeout"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle{
                    x: 320 - 65; y: 70
                    width: 225; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: mSLSTimeout
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                //****************************** DL+ timeout (3 Line)
                Rectangle{
                    x: 645 - 155; y: 70
                    width: 250; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: "DL+ timeout"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle{
                    x: 960 - 220; y: 70
                    width: 225; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: mDLPlusDLSTimeout
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                //****************************** DLS timeout (3 Line)
                Rectangle{
                    x: 5; y: 105
                    width: 250; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: "DLS timeout"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle{
                     x: 320 - 65; y: 105
                    width: 225; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: mDLSTimeout
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                //****************************** Mute time(in DAB-DAB SF) (4 Line)
                Rectangle{
                    x: 645 - 155; y: 105
                    width: 250; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: "DAB-DAB Mute time"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle{
                     x: 960 - 220; y: 105
                    width: 225; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: mDAB_DABLinkingMuteTimeout + " sec"
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                //****************************** DAB-FM SF (4 Line)
                Rectangle{
                     x: 5; y: 140
                    width: 250; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text: "DAB-FM SF"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle{
                    x: 320 - 65; y: 140
                    width: 225; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        x: 0; y: 0
                        text:  MDabOperation.checkIntervalCount(mDAB_FMlinking)
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                //****************************** DAB-DAB On/Off (6 Line)
                Row {
                    id: idDABtoDABOnOff
                    x: 645 - 155; y: 140
                    spacing:  0
                    Rectangle{
                        width: 250; height: mItemHeight
                        color: "transparent"
                        border.width: 2
                        border.color: colorInfo.dimmedGrey
                        Text{
                            text: "DAB-DAB On/Off"
                            color: colorInfo.dimmedGrey
                            font.pixelSize: 20
                            font.family: idAppMain.fonts_HDB
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Rectangle{
                        width: 225; height: mItemHeight
                        color:"transparent"
                        border.width: 2
                        border.color: colorInfo.dimmedGrey
                        Text{
                            text: mDABtoDABOnOff
                            color: colorInfo.bandBlue
                            font.pixelSize: 24
                            font.family: idAppMain.fonts_HDB
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }


            //****************************** DAB-FM Freq, PID, Sensitivity (5 Line)
            Row {
                id: idDABtoFMInfo
                x:5; y: 360 + 35
                spacing:  6
                Rectangle{
                    width: 155; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: "FM Frequency"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    width: 155; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: m_iFMFrequency
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    width: 155; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: "FM PICode"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    width: 155; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: m_sPicode
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    width: 155; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: "FM Sensitivity"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    width: 155; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: MDabOperation.checkFMSensitivity(m_iFMSensitivity)
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            //****************************** AudioInfo
            Row {
                id: idAudioInfo
                x:5; y: 360 + 35 + 35
                spacing:  6
                Rectangle{
                    width: 155; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: "ProtectType"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    width: 155; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: mProtectType
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    width: 155; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: "Protect Level"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    width: 155; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: mProtectLevel
                        color: colorInfo.bandBlue
                        font.pixelSize: 24
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    width: 155; height: mItemHeight
                    color: "transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: "Protect Option"
                        color: colorInfo.dimmedGrey
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    width: 155; height: mItemHeight
                    color:"transparent"
                    border.width: 2
                    border.color: colorInfo.dimmedGrey
                    Text{
                        text: mProtectOption
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDB
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            MComp.MButton{
                x:5
                y: 360 + 35 + 35 + 35
                width: 155; height: 72
                bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                firstText : "Debug Info"
                firstTextX : 10
                firstTextY : 30
                firstTextWidth : 479
                firstTextSize :25
                firstTextStyle :idAppMain.fonts_HDR
                firstTextAlies: "Left"
                fgImageX: 0
                fgImageY: 0
                fgImageWidth: 155
                fgImageHeight: 50
                onClickOrKeySelected: {
                    if(idAppMain.m_bDebugInfo)
                        idAppMain.m_bDebugInfo = false
                    else
                        idAppMain.m_bDebugInfo = true
                }
            }

            Rectangle{
                x:5 + 155
                y: 360 + 35 + 35 + 35 + 5
                width: 155; height: 60
                color: "transparent"
                border.width: 2
                border.color: colorInfo.dimmedGrey
                Text{
                    text: idAppMain.m_bDebugInfo? "Debug On" : "Debug Off"
                    color: colorInfo.dimmedGrey
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDB
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
