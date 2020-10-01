/**
 * FileName: DABPlayerFreqInfo.qml
 * Author: DaeHyungE
 * Time: 2013-01-17
 *
 * - 2013-01-17 Initial Crated by HyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

FocusScope {
    id : idDABPlayerFreqInfo

    function getPresetIndex()
    {
        // if Very First Entry, presetIndex is '... '
        //        if(idAppMain.m_sPtyName == 0/* || idAppMain.m_bIsServiceNotAvailable*/) return "..."
        if(idAppMain.m_iPresetIndex == 0) return ""
        else return "P" + idAppMain.m_iPresetIndex
    }

    /* Channel Info View ====================================== */
    Text {
        id : idEnsembleLabel
        x : 0
        y : -36/2
        width : 776
        height : 36

        text : idAppMain.m_sChannelInfo + " " + idAppMain.m_sEnsembleName
        font.family: idAppMain.fonts_HDR
        font.pixelSize : 36
        color: colorInfo.grey
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment:Text.AlignLeft
    }

    Text {
        id : idServiceName
        x : 0
        y : 60 - 56/2
        width : 776
        height : 56

        text : m_sServiceName
        font.family: idAppMain.fonts_HDR
        font.pixelSize : 56
        color: idAppMain.m_bViewMode? colorInfo.bandBlue : colorInfo.brightGrey
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment:Text.AlignLeft
        //	elide: Text.ElideRight
    }

    Text {
        id : idPty
        x : 0
        y : 100  //437 + 12 - 28/2 - 335
        width : paintedWidth
        height : 28
        text : MDabOperation.getProgramTypeName(m_sPtyName)
        font.family: idAppMain.fonts_HDR
        font.pixelSize : 28
        color: Qt.rgba( 163/255, 170/255, 185/255, 1)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment:Text.AlignLeft
        visible: MDabOperation.checkProgramType(m_sPtyName)
    }

    Image {
        id : idImgDivider
        x : idPty.width + 12
        y : 102  //437 - 335
        width : 2
        height : 27
        source : imageInfo.imgChInfoDivider
        visible: (idPty.visible && idAppMain.m_iPresetIndex != 0)
    }

    Text {
        id : idPresetIndex
        x : (idPty.visible) ? idImgDivider.x + idImgDivider.width + 14 : 0
        y : 100  //437 + 12 - 28/2 - 335
        width : paintedWidth
        height : 28

        text : getPresetIndex()/*(m_iPresetIndex == 0)?(""):("P" + m_iPresetIndex)*/
        font.family: idAppMain.fonts_HDR
        font.pixelSize : 28
        color: Qt.rgba( 163/255, 170/255, 185/255, 1)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment:Text.AlignLeft
    }

    /* DL+ View ====================================== */
    Item {
        id : idArtistRect
        x : -10     //454 - 464
        y : 160     //495 - 335
        width : 785 //65 + 720
        height : 49

        Image {
            id : idArtistImg
            source : imageInfo.imgIcoArtist
            anchors.verticalCenter : parent.verticalCenter;
        }
    }

    //****************************** # For Scroll Text (Artist)
    property bool bArtistTicker : (idArtistText.overTextPaintedWidth == true) ? true : false;
    MComp.MTickerText{
        id: idArtistText
        x:  -10  + 65     ; y: 160 + 7
        width: 720; height: 36
        tickerTextSpacing   : 120
        tickerText          : m_sArtist == "" ? stringInfo.strPlayer_NoInfo : m_sArtist
        tickerTextSize      : 36
        tickerTextColor     : colorInfo.brightGrey
        tickerTextStyle     : idAppMain.fonts_HDR
        tickerTextAlies     : "Left"
        variantText         : true
        variantTextTickerEnable : (m_bIsDrivingRegulation == false) && (idDabPlayerMain.visible == true) && (bArtistTicker == true)
        onTickerTextZeroCheck: {
            if(idSongText.overTextPaintedWidth == true){
                 idTimerTickerPause.start();
               // bArtistTicker = false;
            }
        }
    }

    Item {
        id : idSongRect
        x : -10             //454 - 464
        y : 160 + 25 + 31   //495 - 335
        width : 785         //65 + 720
        height : 49

        Image {
            id : idSongImg
            source : imageInfo.imgIcoMusic
            anchors.verticalCenter : parent.verticalCenter;
        }
    }

    //****************************** # For Scroll Text (Song)
    MComp.MTickerText{
        id: idSongText
        x:  -10  + 65     ; y: 160 + 25 + 31 + 7
        width: 720      ; height:36
        tickerTextSpacing   : 120
        tickerText          : m_sTitle == "" ? stringInfo.strPlayer_NoInfo : m_sTitle
        tickerTextSize      : 36
        tickerTextColor     : colorInfo.brightGrey
        tickerTextStyle     : idAppMain.fonts_HDR
        tickerTextAlies     : "Left"
        variantText         : true
        variantTextTickerEnable : (m_bIsDrivingRegulation == false) && (idDabPlayerMain.visible == true) && (bArtistTicker == false)
        onTickerTextZeroCheck: {
            if(idArtistText.overTextPaintedWidth == true){
                idTimerTickerPause.start();
              //  bArtistTicker = true;
            }
        }
    }


    Timer {
        id: idTimerTickerPause
        interval: 1500
        running: false;
        repeat: false
        onTriggered:
        {
            if( bArtistTicker ==  true) bArtistTicker = false;
            else bArtistTicker = true;
            idTickerPause.stop();
        }
    }
    //    Item {
    //        id : idDebugArea
    //        x : 630
    //        y : 280
    //        width : 174
    //        height : 100

    //        MouseArea {
    //            anchors.fill: parent
    //            onPressAndHold: {
    //                MDabOperation.DebugViewOnOff();
    //            }
    //        }
    //    }
}
