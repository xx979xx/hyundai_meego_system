import QtQuick 1.1
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item {
    id: scrollingTicker
    clip: true

    property string text: ""
    property string fontFamily: ""
    property int fontPointSize : 40
    property int fontStyle : Text.Normal
    property color fontColor: Dimensions.const_AppUserManual_ListText_Color_BrightGrey // "#FAFAFA"
    property bool fontBold: false
    property int scrollingTextMargin: 0
    property bool isScrolling: false
    property bool updateElide: true
    property int lastPaintedWidthFlag : 0
    property bool scrollType : false
    onFontBoldChanged:
    {
        console.log("ScrollText.qml :: onFontBoldChanged ")
        updateElide = false
        updateElide = true
    }

    Text {
        id: originText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: fontPointSize
        color: fontColor
        text: parent.text
        width: parent.width
        horizontalAlignment: Text.AlignLeft
        elide: !updateElide ? Text.ElideNone :
                (!isScrolling && (paintedWidth > width) ) ? Text.ElideRight : Text.ElideNone
        style: fontStyle
        visible: appUserManual.langId != 20
        //styleColor: "black"
        onElideChanged:
        {
            if ( appUserManual.langId == 20 ) return;

            if(lastPaintedWidthFlag < 2)   // skip first condition(PaintedWidth) to scroll because Textscroll should be operated dependant on Last value of PaintedWidth(QML).
            {
                if(isScrolling)
                {
                    if(originText.elide == Text.ElideNone)
                    {
                       scrollType = true
                    }
                }
                else
                {
                    if(scrollType == true)
                    {
                        lastPaintedWidthFlag = 0
                    }
                    scrollType = false
                }
                lastPaintedWidthFlag++
            }

            if(isScrolling && scrollType)
            {
                 scrollStartAni.running = true
            }
            else
            {
                scrollStartAni.running = false
                originText.anchors.leftMargin = 0
            }
        }
        onTextChanged: {
            if ( appUserManual.langId == 20 ) return;
            scrollStartAni.running = false
            originText.anchors.leftMargin = 0

            updateElide = false
            updateElide = true

            if(isScrolling && (originText.elide == Text.ElideNone) && (paintedWidth > width) )
            {
                scrollStartAni.running = true
            }

            else
            {
                scrollStartAni.running = false
                originText.anchors.rightMargin = 0
            }
        }

        font.family: fontFamily
    }
    Text {
        id: originText_arab
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: fontPointSize
        color: fontColor
        text: parent.text
        width: parent.width
        horizontalAlignment: Text.AlignRight
        visible: appUserManual.langId == 20
        elide: !updateElide ? Text.ElideNone :
                (!isScrolling && (paintedWidth > width) ) ? Text.ElideRight : Text.ElideNone
        style: fontStyle
        //styleColor: "black"
        onElideChanged:
        {
            if ( appUserManual.langId != 20 ) return;
            if(isScrolling)
            {
                if(originText_arab.elide == Text.ElideNone)
                {
                    scrollStartAni.running = true
                }
            }
            else
            {
                scrollStartAni.running = false
                originText_arab.anchors.rightMargin = 0
            }
        }

        onTextChanged: {
            if ( appUserManual.langId != 20 ) return;
            scrollStartAni.running = false
            originText_arab.anchors.rightMargin = 0

//            updateElide = false
//            updateElide = true

            if(isScrolling && (originText_arab.elide == Text.ElideNone) && (paintedWidth > width) )
            {
                scrollStartAni.running = true
            }

            else
            {
                scrollStartAni.running = false
                originText_arab.anchors.rightMargin = 0
            }
        }

        font.family: fontFamily
    }

    Text {
        id: scrollText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: originText.left
        anchors.leftMargin: originText.paintedWidth + scrollingTextMargin
        font.pointSize: fontPointSize
        color: fontColor
        text: visible ? parent.text : ""
        visible: scrollStartAni.running && appUserManual != 20
        font.family: fontFamily
    }
    Text {
        id: scrollText_arab
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: originText_arab.right
        anchors.rightMargin: originText_arab.paintedWidth + scrollingTextMargin
        font.pointSize: fontPointSize
        color: fontColor
        text: visible ? parent.text : ""
        visible: scrollStartAni.running && appUserManual.langId == 20
        font.family: fontFamily
    }

    SequentialAnimation
    {
        id: scrollStartAni
        running: false
        loops: Animation.Infinite
        PauseAnimation { duration: 900 }
        PropertyAnimation {
            target: appUserManual.langId == 20 ? originText_arab : originText
            property:  appUserManual.langId == 20 ?  "anchors.rightMargin" : "anchors.leftMargin"
            to: appUserManual.langId == 20 ?  -(originText_arab.paintedWidth + scrollingTextMargin) :  -(originText.paintedWidth + scrollingTextMargin)
            duration: appUserManual.langId == 20 ? Math.floor( Math.abs(originText_arab.paintedWidth + scrollingTextMargin) * 20) : Math.floor( Math.abs(originText.paintedWidth + scrollingTextMargin) * 20)
            // 0.01초에 1픽셀 이동 -> 1초에 100픽셀 이동
            // Scroll되어야 할 길이 = 실제 Text의 길이 + 120(Scroll Text간 간격)
        }
        PauseAnimation { duration: 1500 }
        PropertyAction { target: appUserManual.langId == 20 ? originText_arab : originText; property: appUserManual.langId == 20 ? "anchors.rightMargin" : "anchors.leftMargin"; value: 0 }
    }
}
