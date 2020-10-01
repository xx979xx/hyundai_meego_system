/**
 * FileName: RadioFmFrequencyDial.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import QtQuick 1.1
import "../../QML/DH" as MComp

Item/*MComp.MComponent*/ {
    id: idRadioDisplayLiveModeQml
    x: 0; y: 0

    property bool channelNameActivFocus : false;
    property bool textTickerInit : false;
    property QtObject currentTextScrollId: idRadioDisplayLiveModeQml;
    property QtObject nextTextScrollId: idRadioDisplayLiveModeQml;
    //****************************** # Preset Save & EDIT , Dim Background Image #
    Image {
        id: idRadioDisplayLiveModeDim
        x: -660; y: 0; z: 5
        source: imageInfo.imgFolderRadio_Hd + "bg_dim.png"
        visible: (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")
        MouseArea{
            anchors.fill: parent;
            onPressed: {return;}
        }
    }

    //****************************** # Display Radio ID #
    /*******************************************************************
    * Text Block
    *******************************************************************/
    Text{
        id: idRadioIDChannelNumber
        x: -24; y: 250-(font.pixelSize/2)
        width: 620; height: 55
        font.pixelSize : 55
        font.family : systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        text: "CH" + PLAYInfo.ChnNum
        elide: Text.ElideRight
        visible: (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : ((PLAYInfo.ChnNum == "0") ? true : false)
    }
    Text{
        id: idRadioIDDisplay
        x: -20; y: 310-(font.pixelSize/2)
        width: 620; height: 55
        font.pixelSize : 55
        font.family : systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        text: "RADIO ID  : " + PLAYInfo.ChnTitle
        elide: Text.ElideRight
        visible: (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : ((PLAYInfo.ChnNum == "0") ? true : false)
    }

    /*******************************************************************
    * Text Block
    *******************************************************************/
    Text{
        id: idPreparingMessageDisplay
        x: -40; y: 200-(font.pixelSize/2)
        width: 620; height: 45
        font.pixelSize : 45
        font.family : systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        text: stringInfo.sSTR_XMRADIO_PREPAIRING_MESSAGE
        elide: Text.ElideRight
        visible: (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? true : false
    }

    //****************************** # Scan Image #
    Image{
        id: scanIcon
        property bool bShowIcon : true ;
        x : 548; y : 35
        source: imageInfo.imgFolderRadio+"ico_radio_scan.png"//(gSXMScan == "Scan") ? imageInfo.imgFolderRadio+"ico_radio_scan.png" : imageInfo.imgFolderRadio+"ico_radio_autotune.png"
        visible: ((PLAYInfo.ChnNum != "0") && (gSXMScan == "Scan" || gSXMPresetScan == "PresetScan") && bShowIcon)
        opacity: 1

        Timer{
            id : scanIconTimer
            interval : 500
            running : (gSXMScan == "Scan" || gSXMPresetScan == "PresetScan")
            repeat : true
            onTriggered : {scanIcon.bShowIcon = !scanIcon.bShowIcon;}
        }
    }

    //****************************** # Display channel information #
    /*******************************************************************
    * Text Block
    *******************************************************************/
    Item {
        id: idRadioDisplayInfo
        x: 0; y:0
        width: parent.width; height: parent.height
        visible: (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : ((PLAYInfo.ChnNum != "0") ? true : false)

        /*******************************************************************
        * Channel Art (Logo) Used
        *******************************************************************/
        //        // Art Image
        //        Image{
        //            id : idRadioChannelArt
        //            x: 10; y: 52
        //            width: 122;height:101
        //            smooth: true
        //            cache: false
        //            asynchronous: true
        //            fillMode: Image.PreserveAspectFit
        //            source: PLAYInfo.ChnArt

        //            onStatusChanged: {
        //                if(idRadioChannelArt.status == Image.Null)
        //                {
        //                    UIListener.HandleChannelArtSourceChange(PLAYInfo.ChnNum, 0);
        //                }
        //                else if(idRadioChannelArt.status == Image.Ready)
        //                {
        //                    UIListener.HandleChannelArtSourceChange(PLAYInfo.ChnNum, 1);
        //                }
        //                else if(idRadioChannelArt.status == Image.Loading)
        //                {
        //                    UIListener.HandleChannelArtSourceChange(PLAYInfo.ChnNum, 2);
        //                }
        //                else if(idRadioChannelArt.status == Image.Error)
        //                {
        //                    UIListener.HandleChannelArtSourceChange(PLAYInfo.ChnNum, 3);
        //                }
        //            }
        //        }
        //        // Channel Number
        //        Text {
        //            id : idRadioChannelNumber
        //            x:10+147; y:52+23-(font.pixelSize/2)
        //            width: 370; height: 45
        //            font.pixelSize: 45
        //            font.family : systemInfo.font_NewHDR
        //            horizontalAlignment: Text.AlignLeft
        //            verticalAlignment: Text.AlignVCenter
        //            color: PLAYInfo.VirtualChannel ? colorInfo.blue : colorInfo.brightGrey
        //            text : PLAYInfo.ChnNum
        //            elide: Text.ElideRight
        //        }
        //        // Channel Name
        //        MComp.DDScrollTicker {
        //            id: idRadioChannelName
        //            x:10+147; y:52+23+54-(idRadioChannelName.fontSize/2)-(idRadioChannelName.fontSize/(3*2))
        //            width: 370; height: idRadioChannelName.fontSize+(idRadioChannelName.fontSize/3)
        //            fontSize: 45
        //            fontFamily : systemInfo.font_NewHDR
        //            horizontalAlignment: Text.AlignLeft
        //            verticalAlignment: Text.AlignVCenter
        //            color: colorInfo.brightGrey
        //            text : PLAYInfo.ChnName
        //            tickerFocus: (idRadioDisplayLiveModeQml.channelNameActivFocus && idAppMain.focusOn)
        //        }

        /*******************************************************************
        * Channel Art (Logo) Not used - Driving Restriction
        *******************************************************************/
        // Channel Number
        Text {
            id : idRadioChannelNumber
            x:10; y:104-(font.pixelSize/2)
            width: 240; height: 73
            font.pixelSize: 70
            font.family : systemInfo.font_NewHDR
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: PLAYInfo.VirtualChannel ? colorInfo.blue : colorInfo.brightGrey
            text : "CH" + PLAYInfo.ChnNum
            elide: Text.ElideRight
        }
        // Channel Name
        MComp.DDScrollTicker {
            id: idRadioChannelName
            x:10+247; y:104+7-(idRadioChannelName.fontSize/2)-(idRadioChannelName.fontSize/(3*2))
            width: 270; height: idRadioChannelName.fontSize+(idRadioChannelName.fontSize/3)
            fontSize: 34
            fontFamily : systemInfo.font_NewHDR
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            text : PLAYInfo.ChnName
            tickerFocus: (idRadioDisplayLiveModeQml.channelNameActivFocus && idAppMain.focusOn)
        }

        // Artist Icon
        Image{
            id : idRadioIconTitle
            x: 4; y: 198;
            smooth: true
            fillMode: Image.PreserveAspectFit
            source:imageInfo.imgFolderRadio_SXM+"ico_artist.png"
        }
        // Artist
        MComp.DDScrollTicker{
            id: idRadioTitle
            x: 4+56; y:198+23-(idRadioTitle.fontSize/2)-(idRadioTitle.fontSize/(3*2))
            width: 485; height: idRadioTitle.fontSize+(idRadioTitle.fontSize/3)
            text : PLAYInfo.ChnArtist
            fontFamily : systemInfo.font_NewHDR
            fontSize: 34
            color: colorInfo.dimmedGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerFocus: false
            onTickerTextEnd:{
                nextTextScrollId = idRadioArtist;
                setNextTextScroll();
            }
            onTextChanged: {
                //                console.log("[QML][XMAudioDisplayLiveMode] idRadioTitle:: onTextChanged !!!!!!!!!!!!!!!!!!!!!!!")
                if(idSetNextTextScrollTimer.running == false)
                {
                    idSetNextTextScrollTimer.start();
                }
            }
        }

        // Title Icon
        Image{
            id : idRadioIconArtist
            x: 4; y: 198+23+29;
            smooth: true
            fillMode: Image.PreserveAspectFit
            source:imageInfo.imgFolderRadio_SXM+"ico_song.png"
        }
        // Title
        MComp.DDScrollTicker{
            id: idRadioArtist
            x: 4+56; y:198+23+29+23-(idRadioArtist.fontSize/2)-(idRadioArtist.fontSize/(3*2))
            width: 485; height: idRadioArtist.fontSize+(idRadioArtist.fontSize/3)
            text : PLAYInfo.ChnTitle
            fontFamily : systemInfo.font_NewHDR
            fontSize: 34
            color: colorInfo.dimmedGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerFocus: false
            onTickerTextEnd:{
                nextTextScrollId = idRadioContentInfo;
                setNextTextScroll();
            }
            onTextChanged: {
                //                console.log("[QML][XMAudioDisplayLiveMode] idRadioArtist::onTextChanged !!!!!!!!!!!!!!!!!!!!!!!")
                if(idSetNextTextScrollTimer.running == false)
                {
                    idSetNextTextScrollTimer.start();
                }
            }
        }

        // Content Info Icon
        Image{
            id : idRadioIconContentInfo
            x: 4; y: 198+23+29+23+29
            smooth: true
            fillMode: Image.PreserveAspectFit
            source:imageInfo.imgFolderRadio_SXM+"ico_info.png"
        }
        // Content Info
        MComp.DDScrollTicker {
            id : idRadioContentInfo
            x: 4+56; y:198+23+29+23+29+23-(idRadioContentInfo.fontSize/2)-(idRadioContentInfo.fontSize/(3*2))
            width: 485; height: idRadioContentInfo.fontSize+(idRadioContentInfo.fontSize/3)
            fontSize: 34
            fontFamily : systemInfo.font_NewHDR
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: (PLAYInfo.Advisory != "" ||  PLAYInfo.SubAdvisory != "")? colorInfo.blue : colorInfo.dimmedGrey
            text : convertLanguage(PLAYInfo.Advisory, PLAYInfo.SubAdvisory, PLAYInfo.ChnInfo);
            tickerFocus: false
            onTickerTextEnd:{
                nextTextScrollId = idRadioCategory;
                setNextTextScroll();
            }
            onTextChanged: {
                //                console.log("[QML][XMAudioDisplayLiveMode] idRadioContentInfo::onTextChanged !!!!!!!!!!!!!!!!!!!!!!!")
                if(idSetNextTextScrollTimer.running == false)
                {
                    idSetNextTextScrollTimer.start();
                }
            }
        }

        // Category Icon
        Image{
            id : idRadioIconCategory
            x: 4; y: 198+23+29+23+29+23+29
            smooth: true
            fillMode: Image.PreserveAspectFit
            source:imageInfo.imgFolderRadio_SXM+"ico_genre.png"
        }
        // Category
        MComp.DDScrollTicker {
            id : idRadioCategory
            x: 4+56; y:198+23+29+23+29+23+29+23-(idRadioCategory.fontSize/2)-(idRadioCategory.fontSize/(3*2))
            width: PLAYInfo.CategoryLock ? 393 : 246; height: idRadioCategory.fontSize+(idRadioCategory.fontSize/3)
            fontSize: 34
            fontFamily : systemInfo.font_NewHDR
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: PLAYInfo.CategoryLock ? colorInfo.dimmedGrey : colorInfo.brightGrey
            text : PLAYInfo.ChnCategory
            tickerFocus: false
            onTickerTextEnd:{
                nextTextScrollId = idRadioTitle;
                setNextTextScroll();
            }

            onTextChanged: {
                //                console.log("[QML][XMAudioDisplayLiveMode] idRadioCategory:: onTextChanged !!!!!!!!!!!!!!!!!!!!!!!")
                if(idSetNextTextScrollTimer.running == false)
                {
                    idSetNextTextScrollTimer.start();
                }
            }

            onOverTextPaintedWidthChanged: {
                if(idSetNextTextScrollTimer.running == false)
                {
                    idSetNextTextScrollTimer.start();
                }
            }
        }
    }

    Connections{
        target: idAppMain
        onCategoryLockClicked: {
            //console.log("Category Lock Clicked !!!!!!!!!!!!!!!!!!!!!!!"+PLAYInfo.CategoryLock)
            idRadioCategory.width = PLAYInfo.CategoryLock ? 393 : 246
            //Text Ticker Restart
            idRadioCategory.tickerEnable = false;
            idRadioCategory.doCheckAndStartAnimation();
            idRadioCategory.tickerEnable = true;
            idRadioCategory.doCheckAndStartAnimation();
        }
    }

    Connections{
        target: UIListener
        onMainPlayTickerInit:
        {
            stopAllTextTicker();
            nextTextScrollId = idRadioTitle;
            currentTextScrollId = idRadioDisplayLiveModeQml;
            setNextTextScroll();
        }
    }
    
    Timer{
        id: idSetNextTextScrollTimer
        interval: 200
        repeat: false;

        onTriggered:{
            //            console.log("[QML] XMAudioDisplayLiveMode :: idSetNextTextScrollTimer")
            if(idRadioDisplayLiveModeQml.textTickerInit == true )
            {
                stopAllTextTicker();
                nextTextScrollId = idRadioTitle;
                setNextTextScroll();
            }
        }
    }

    onTextTickerInitChanged:{
        //        console.log("[QML] XMAudioDisplayLiveMode :: onTextTickerInitChanged  textTickerInit = "+ textTickerInit)
        if(textTickerInit == true)
        {
            stopAllTextTicker()
            nextTextScrollId = idRadioTitle;
            currentTextScrollId = idRadioDisplayLiveModeQml;
            setNextTextScroll();
        }
        else
        {
            stopAllTextTicker()
        }
    }

    function stopAllTextTicker()
    {
        //        console.log("[QML][XMAudioDisplayLiveMode] stopAllTextTicker  ")
        idRadioTitle.tickerFocus = false;
        idRadioArtist.tickerFocus = false;
        idRadioContentInfo.tickerFocus = false;
        idRadioCategory.tickerFocus = false;
        nextTextScrollId = idRadioDisplayLiveModeQml;
        currentTextScrollId = idRadioDisplayLiveModeQml;
        if(idSetNextTextScrollTimer.running == true)
        {
            idSetNextTextScrollTimer.stop();
        }
    }

    function setNextTextScroll()
    {
        if(idRadioDisplayLiveModeQml.visible == false)
        {
            console.log("Main don't display -> Textscroll Stop ############################")
            return;
        }

        console.log("[QML][XMAudioDisplayLiveMode] setNextTextScroll")

        if(idRadioTitle.overTextPaintedWidth == false && idRadioArtist.overTextPaintedWidth == false &&
                idRadioContentInfo.overTextPaintedWidth == false && idRadioCategory.overTextPaintedWidth == false)
        {
            console.log("[QML][XMAudioDisplayLiveMode] setNextTextScroll :: None Text scroll !!!!!!!!!!!!!!!!!!!!!!!")
            stopAllTextTicker();
            return;
        }

        switch(nextTextScrollId)
        {
        case idRadioTitle:
        {
            //                console.log("[QML][XMAudioDisplayLiveMode] idRadioTitle :: idRadioTitle.textPaintedWidth ="+ idRadioTitle.overTextPaintedWidth)
            if(idRadioTitle.overTextPaintedWidth == true)
            {

                if(currentTextScrollId != nextTextScrollId)
                {
                    stopAllTextTicker();
                }

                currentTextScrollId = idRadioTitle;

                if(idRadioTitle.tickerFocus == false)
                {
                    idRadioTitle.tickerFocus = true;
                }
            }
            else
            {
                nextTextScrollId = idRadioArtist;
                setNextTextScroll();
            }
            break;
        }
        case idRadioArtist:
        {
            //                console.log("[QML][XMAudioDisplayLiveMode] idRadioArtist :: idRadioArtist.textPaintedWidth ="+ idRadioArtist.overTextPaintedWidth)
            if(idRadioArtist.overTextPaintedWidth == true)
            {
                if(currentTextScrollId != nextTextScrollId)
                {
                    stopAllTextTicker();
                }

                currentTextScrollId = idRadioArtist;

                if(idRadioArtist.tickerFocus == false)
                {
                    idRadioArtist.tickerFocus = true;
                }
            }
            else
            {
                nextTextScrollId = idRadioContentInfo;
                setNextTextScroll();
            }
            break;
        }
        case idRadioContentInfo:
        {
            //                console.log("[QML][XMAudioDisplayLiveMode] idRadioContentInfo :: idRadioContentInfo.textPaintedWidth ="+ idRadioContentInfo.overTextPaintedWidth)
            if(idRadioContentInfo.overTextPaintedWidth == true)
            {
                if(currentTextScrollId != nextTextScrollId)
                {
                    stopAllTextTicker();
                }

                currentTextScrollId = idRadioContentInfo;

                if(idRadioContentInfo.tickerFocus == false)
                {
                    idRadioContentInfo.tickerFocus = true;
                }
            }
            else
            {
                nextTextScrollId = idRadioCategory;
                setNextTextScroll();
            }
            break;
        }
        case idRadioCategory:
        {
            //                console.log("[QML][XMAudioDisplayLiveMode] idRadioCategory :: idRadioCategory.textPaintedWidth ="+ idRadioCategory.overTextPaintedWidth)
            if(idRadioCategory.overTextPaintedWidth == true)
            {
                if(currentTextScrollId != nextTextScrollId)
                {
                    stopAllTextTicker();
                }

                currentTextScrollId = idRadioCategory;

                if(idRadioCategory.tickerFocus == false)
                {
                    idRadioCategory.tickerFocus = true;
                }
            }
            else
            {
                nextTextScrollId = idRadioTitle;
                setNextTextScroll();
            }
            break;
        }
        default :
            break;
        }
        return;
    }

    function convertLanguage(szAdvisory, szSubAdvisory, szChnInfo)
    {
        if(szAdvisory != "") //Preparing SiriusXM Radio
        {
            return stringInfo.sSTR_XMRADIO_PREPAIRING_MESSAGE;
        }
        else
        {
            if(szSubAdvisory != "")
            {
                switch(szSubAdvisory)
                {
                case "STR_XMRADIO_ANTENNA_DISCONNECTED": //Antenna Disconnected
                    return stringInfo.sSTR_XMRADIO_ANTENNA_DISCONNECTED;
                case "STR_XMRADIO_ANTENNA_SHORTED": //Antenna Shorted
                    return stringInfo.sSTR_XMRADIO_ANTENNA_SHORTED;
                case "STR_XMRADIO_LOSS_OF_SIGNAL": //No Signal
                    return stringInfo.sSTR_XMRADIO_LOSS_OF_SIGNAL;
                case "STR_XMRADIO_ACQUIRING_SIGNAL": //Acquiring Signal
                    return stringInfo.sSTR_XMRADIO_ACQUIRING_SIGNAL;
                case "STR_XMRADIO_BUSY": //Busy
                    return stringInfo.sSTR_XMRADIO_BUSY;
                case "STR_XMRADIO_NO_AUTHORIZED1": //Channel Not Subscribed
                    return UIListener.HandleAdvisoryAddChannelNumber(0); //stringInfo.sSTR_XMRADIO_NO_AUTHORIZED1;
                case "STR_XMRADIO_CHANNEL_NOT_AVAILABLE": //Channel Not Available
                    return UIListener.HandleAdvisoryAddChannelNumber(1); //stringInfo.sSTR_XMRADIO_CHANNEL_NOT_AVAILABLE;
                case "STR_XMRADIO_WEAK_SIGNAL": //Weak Signal
                    return stringInfo.sSTR_XMRADIO_WEAK_SIGNAL;

                default:
                    return "";
                }
            }
            else
            {
                return szChnInfo;
            }
        }
    }
}
