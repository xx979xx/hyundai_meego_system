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
    property bool   overTextPaintedWidth: idText2.paintedWidth > idTicker.width
    property int    tickerPaintedHeight : idText1.paintedHeight
    property int    tickerDuration      : (idText2.paintedWidth + 120)/50 * 1000  //(idText2.paintedWidth * 10) < 1?1:Math.round((idText2.paintedWidth +tickerTextSpacing)/50 *1000)
    // property int    tickerDuration      : (idText2.paintedWidth * 10) < 1?1:Math.round((idText2.paintedWidth +tickerTextSpacing)/100 *1000)
    property bool   variantText         : false
    property bool   variantTextTickerEnable : false
    property bool   tickerTextWrapMode  : false
    signal tickerTextZeroCheck();

    clip: overTextPaintedWidth  && tickerEnable ? true : false
    onTickerTextChanged : {
        idText1.text = tickerText;
        idText2.text = tickerText;

        if(variantText){
            if(tickerEnable)
                tickerEnable = false

            tickerEnable = variantTextTickerEnable
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
        if (overTextPaintedWidth && tickerEnable){
            idScrollAnimation.restart()
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
            if(tickerEnable == true || tickerTextWrapMode == true) {Text.ElideNone     }
            else                                                   {Text.ElideRight    }
        }
        wrapMode: {
            if(tickerTextWrapMode == false)     {Text.NoWrap        }
            else                                {Text.Wrap          }
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
        onXChanged: {
            if(idText2.x == 0)
                tickerTextZeroCheck();
        }
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
            duration: tickerDuration   //tickerDuration - tickerTextSpacing < 0 ? 0 : tickerDuration - tickerTextSpacing
        }
        PauseAnimation {duration: 1500 }
    }    
}

