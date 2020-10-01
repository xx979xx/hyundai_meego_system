/**
 * FileName: DABInfoSLSContents.qml
 * Author: HYANG
 * Time: 2013-01-23
 *
 * - 2013-01-23 Initial Created by HYANG
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp

MComp.MComponent{
    id: idDabInfoSLSContents
    width: systemInfo.lcdWidth
    height: systemInfo.contentAreaHeight

    //******************************# SLS Background Image
    Image {
        id: idSLSImageBg
        x: 58; y: 230 - systemInfo.headlineHeight
        source: imageInfo.imgBg_SLS_Img  //  imgBg_SLS_NOT_Img
        visible: (m_sSLS == "") ? true : false
    }

    Rectangle{
        x: idSLSImage.x-1
        y: idSLSImage.y-1
        width: idSLSImage.paintedWidth+2
        height: idSLSImage.paintedHeight+2
        color: Qt.rgba(100/255, 100/255, 100/255, 1)
        visible: idSLSImageBg.visible == false;
        anchors.horizontalCenter: idSLSImage.horizontalCenter
        anchors.verticalCenter: idSLSImage.verticalCenter

    }

    //******************************# SLS Image
    Image {
        id: idSLSImage
        x: 58; y: 230 - systemInfo.headlineHeight
        width: 532; height: 395
        fillMode: Image.PreserveAspectFit
        source: m_sSLS;
    }

    MComp.MButton {
        id: idSLSFocusArea
        x: idSLSImage.x-1
        y: idSLSImage.y-1
        width: idSLSImage.paintedWidth+2
        height: idSLSImage.paintedHeight+2
        visible: idSLSImageBg.visible == false;
        anchors.horizontalCenter: idSLSImage.horizontalCenter
        anchors.verticalCenter: idSLSImage.verticalCenter
        focus: true
        BorderImage {
            source: imageInfo.imgSLS_Rectangle_F
            anchors.fill: parent;
            border {left: 10; right: 10; top: 10; bottom: 10}
            visible: idSLSFocusArea.activeFocus
        }
        onClickOrKeySelected: {
            if(idAppMain.m_sSLS != "")
                setAppMainScreen("DABPlayerMain", false);
        }
    }

    //******************************# SLS Artist Image
    property bool bArtistTicker : (idTextArtist.overTextPaintedWidth == true) ? true : false;
    Image{
        x: 650; y: 352 - systemInfo.headlineHeight
        source: imageInfo.imgIcoArtist
    }

    MComp.MTickerText{
        id: idTextArtist
        x: 714; y: 356 - systemInfo.headlineHeight
        width: 550; height: 40
        tickerTextSpacing   : 120
        tickerText          : m_sArtist == "" ? stringInfo.strPlayer_NoInfo : m_sArtist
        tickerTextSize      : 40
        tickerTextColor     : colorInfo.brightGrey
        tickerTextStyle     : idAppMain.fonts_HDR
        tickerTextAlies     : "Left"
        variantText         : true
        variantTextTickerEnable : (m_bIsDrivingRegulation == false) && (idDabInfoSLSMain.visible == true) && (bArtistTicker == true)
        onTickerTextZeroCheck: {
            if(idTxtSong.overTextPaintedWidth == true){
                idTimerSLSTickerPause.start();
                //    bArtistTicker = false;
            }
        }
    }

    //******************************# SLS Song Image
    Image{
        x: 650; y: 352 + 24 + 37 - systemInfo.headlineHeight
        source: imageInfo.imgIcoMusic
    }
    //******************************# SLS Song Text

    MComp.MTickerText{
        id: idTxtSong
        x:  714; y: 417 - systemInfo.headlineHeight
        width: 550; height: 40
        tickerTextSpacing   : 120
        tickerText          : m_sTitle == "" ? stringInfo.strPlayer_NoInfo : m_sTitle
        tickerTextSize      : 40
        tickerTextColor     : colorInfo.brightGrey
        tickerTextStyle     : idAppMain.fonts_HDR
        tickerTextAlies     : "Left"
        variantText         : true
        variantTextTickerEnable : (idAppMain.m_bIsDrivingRegulation == false) && (idDabInfoSLSMain.visible == true) && (bArtistTicker == false)
        onTickerTextZeroCheck: {
            if(idTextArtist.overTextPaintedWidth == true){
                idTimerSLSTickerPause.start();
                //  bArtistTicker = true;
            }
        }
    }

    Timer {
        id: idTimerSLSTickerPause
        interval: 1500
        running: false;
        repeat: false
        onTriggered:
        {
            if( bArtistTicker ==  true) bArtistTicker = false;
            else bArtistTicker = true;
            idTimerSLSTickerPause.stop();
        }
    }
}
