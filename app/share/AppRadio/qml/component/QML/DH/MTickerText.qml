import Qt 4.7

Item{
    id: idTicker
    property int    tickerTextSpacing   : 0
    property bool   tickerEnable        : false
    property string tickerText          : ""
    property int    tickerTextSize      : 0
    property string tickerTextColor     : ""
    property string tickerTextStyle     : ""
    property string tickerTextAlies     : ""
    property bool   overTextPaintedWidth: idText2.paintedWidth > idTicker.width ? true : false
    property int    tickerDuration      : (idText2.paintedWidth * 10) < 1?1:Math.round((idText2.paintedWidth +tickerTextSpacing)/100 *1000)
    property bool   variantText         : false
    property bool   variantTextTickerEnable : false
    property alias  checkScroll         : idText2.x // JSH 140113
    property bool   scrollSequenceOn    : false     // JSH 140113

    clip: overTextPaintedWidth  && tickerEnable ? true : false

    onWidthChanged : { 
        if(overTextPaintedWidth && tickerEnable) {
            idText1.width = idText2.paintedWidth;
        } else {
            idText1.width = idTicker.width;
        }
    }

    //dg.jin 20141006 ITS 249614 Ticker error
    onTickerTextColorChanged : { 
        if(overTextPaintedWidth && tickerEnable) {
            idText1.width = idText2.paintedWidth;
        } else {
            idText1.width = idTicker.width;
        }
    }
    
    onTickerTextStyleChanged : { 
        if(overTextPaintedWidth && tickerEnable) {
            idText1.width = idText2.paintedWidth;
        } else {
            idText1.width = idTicker.width;
        }
    }

    onTickerTextChanged : {
        idText1.text = tickerText;
        idText2.text = tickerText;

        if(variantText){
            if(tickerEnable)
                tickerEnable = false

            tickerEnable = variantTextTickerEnable
        }

        //dg.jin 20150806 Ticker width error after language change
        if(overTextPaintedWidth && tickerEnable) {	
            idText1.width = idText2.paintedWidth;
        } else {
            idText1.width = idTicker.width;
        }
        if (overTextPaintedWidth && tickerEnable){
            idText1.x = 0;
            if(idScrollAnimation.running == true)
                idScrollAnimation.restart();
            else
                idScrollAnimation.start();
        }
        else{
            idScrollAnimation.stop()
            idText1.x = 0;
        }
    }
    onVariantTextTickerEnableChanged : {
        if(variantText){
            if(tickerEnable)
                tickerEnable = false

            tickerEnable = variantTextTickerEnable
        }
    }
    onTickerEnableChanged:{
        if(overTextPaintedWidth && tickerEnable) {
            idText1.width = idText2.paintedWidth;
        } else {
            idText1.width = idTicker.width;
        }

        if (overTextPaintedWidth && tickerEnable){
            idText1.x = 0;
            if(idScrollAnimation.running == true)
                idScrollAnimation.restart();
            else
                idScrollAnimation.start();
        }
        else{
            idScrollAnimation.stop()
            idText1.x = 0;
        }
    }

    Text {
        id: idText1
        //text: tickerText
        width: !tickerEnable ? idTicker.width : idText2.paintedWidth
        height: idTicker.height
        color: tickerTextColor
        font.family: tickerTextStyle
        font.pixelSize: tickerTextSize
        verticalAlignment:{ Text.AlignVCenter }
        horizontalAlignment: {
            if      (tickerTextAlies=="Right")  {Text.AlignRight    }
            else if (tickerTextAlies=="Left")   {Text.AlignLeft     }
            else if (tickerTextAlies=="Center") {Text.AlignHCenter  }
            else                                {Text.AlignHCenter  }
        }
        elide: {
            if(tickerEnable == true)            {Text.ElideNone     }
            else                                {Text.ElideRight    }
        }
    }

    Text {
        id: idText2
        height: idTicker.height
        verticalAlignment:{ Text.AlignVCenter }
        visible: overTextPaintedWidth && tickerEnable ? true : false
        //text: tickerText
        color: tickerTextColor
        font.family: tickerTextStyle
        font.pixelSize: tickerTextSize
        anchors.left: idText1.right
        anchors.leftMargin: tickerTextSpacing
    }

    SequentialAnimation {
        id: idScrollAnimation
        loops: Animation.Infinite
        running: false
        PauseAnimation { duration: 1000 }
        PropertyAnimation {
            target: idText1
            property: "x"
            from: 0
            to: -(idText2.paintedWidth + tickerTextSpacing)
            duration: tickerDuration - tickerTextSpacing < 0 ? 0 : (tickerDuration - tickerTextSpacing) + 7000 // 2013.11.08 add + 7000 ISV 93405 : GPU Performance Issues.
        }
        PauseAnimation { duration: 1500 }
    }
}

