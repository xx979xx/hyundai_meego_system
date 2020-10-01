/**
 * FileName: ENGDealerModeMain.qml
 * Author: KEH
 * Time: 2013-11
 *
 * - 2013-11 Initial Created by KEH
 */
 
import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent {
    id: idDabENGDealerModeContents

    property int mItemFirstLine : 0
    property int mItemSecondLine : 35
    property int mItemThirdLine : 70
    property int mItemFourthLine : 105
    property int mItemHeight : 80
    property int mItemWidth : 300
    property int mItemSpace: 70
    property int mItemPixelSize: 30
    property int mBoxBorderWidth: 3
    property int mBoxPixelSize: 22

    //****************************** S/W Version (1 Line)
    Rectangle{
        id: idInfo1
        x: 30; y: 30
        width: mItemWidth; height: mItemHeight
        color: "transparent"
        border.width: mBoxBorderWidth
        border.color: colorInfo.dimmedGrey
        Text{
            x: 0; y: 0
            text: "S/W Version"
            color: colorInfo.dimmedGrey
            font.pixelSize: mBoxPixelSize
            font.family: idAppMain.fonts_HDB
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    Rectangle{
        anchors.top: idInfo1.top;
        anchors.left: idInfo1.right;
        width: mItemWidth; height: mItemHeight
        color:"transparent"
        border.width: mBoxBorderWidth
        border.color: colorInfo.dimmedGrey
        Text{
            x: 0; y: 0
            text: UIListener.m_APP_VERSION
            color: colorInfo.bandBlue
            font.pixelSize: mItemPixelSize
            font.family: idAppMain.fonts_HDB
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

        //****************************** Module Bootloader Version (1 Line)
        Rectangle{
            id: idInfo2
            x: 640; y: 30
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "Module Bootloader"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo2.top;
            anchors.left: idInfo2.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: DABListener.m_sBootloaderVer
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** Module Kerner Version (2 Line)
        Rectangle{
             id: idInfo3
            x: 30; y: 30 + mItemHeight
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "Module Kerner"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo3.top;
            anchors.left: idInfo3.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: DABListener.m_sKernelVer
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************** Module Application Version (2 Line)
        Rectangle{
             id: idInfo4
            x: 640; y: 30 + mItemHeight
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "Module Application"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo4.top;
            anchors.left: idInfo4.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text:   DABListener.m_sApplicationVer
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************** Frequency (3 Line)
        Rectangle{
             id: idInfo5
            x: 30; y: 30 + mItemHeight*2
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "Frequency"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo5.top;
            anchors.left: idInfo5.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: m_sFrequencyID
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************** Ensemble Label (3 Line)
        Rectangle{
             id: idInfo6
            x: 640; y: 30 + mItemHeight*2
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "Ensemble Label"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo6.top;
            anchors.left: idInfo6.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: m_sEnsembleName
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************** Service Label (4 Line)
        Rectangle{
             id: idInfo7
            x: 30; y: 30 + mItemHeight*3
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "Service Label"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo7.top;
            anchors.left: idInfo7.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: m_sServiceName
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************** ServeiceID (4 Line)
        Rectangle{
             id: idInfo8
            x: 640; y: 30 + mItemHeight*3
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "ServeiceID"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo8.top;
            anchors.left: idInfo8.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text:  m_serviceID
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************** CER (5 Line)
        Rectangle{
             id: idInfo9
            x: 30; y: 30 + mItemHeight*4
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "CER"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo9.top;
            anchors.left: idInfo9.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: MDabOperation.checkCER(m_iCER)
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************** Bitrate (5 Line)
        Rectangle{
             id: idInfo10
            x: 640; y: 30 + mItemHeight*4
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "Bitrate"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo10.top;
            anchors.left: idInfo10.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: m_iBitrate
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************** SNR (6 Line)
        Rectangle{
             id: idInfo11
            x: 30; y: 30 + mItemHeight*5
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "SNR"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo11.top;
            anchors.left: idInfo11.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: MDabOperation.checSNR(m_iSNR)
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        //****************************** RSSI (6 Line)
        Rectangle{
             id: idInfo12
            x: 640; y: 30 + mItemHeight*5
            width: mItemWidth; height: mItemHeight
            color: "transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: "RSSI"
                color: colorInfo.dimmedGrey
                font.pixelSize: mBoxPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Rectangle{
            anchors.top: idInfo12.top;
            anchors.left: idInfo12.right;
            width: mItemWidth; height: mItemHeight
            color:"transparent"
            border.width: mBoxBorderWidth
            border.color: colorInfo.dimmedGrey
            Text{
                x: 0; y: 0
                text: MDabOperation.checRSSI(m_iRSSI)
                color: colorInfo.bandBlue
                font.pixelSize: mItemPixelSize
                font.family: idAppMain.fonts_HDB
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
}
