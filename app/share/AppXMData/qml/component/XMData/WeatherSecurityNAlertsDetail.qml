/**
 * FileName: SportsAllLeague.qml
 * Author: blacktip.Bae
 * Time: 2013-06-19 17:19
 *
 * - 2012-05-25 Initial Created by Blacktip
 */
import Qt 4.7
import WSADataMapItem 1.0

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../QML/DH" as MComp
import "./ListElement" as XMListElement
import "./Popup" as MPopup
import "./Javascript/Definition.js" as MDefinition
import "./Menu" as MMenu

MComp.MComponent {
    id:container
    focus: true

    Image{
        id: idBgImage
        x: 0; y: 0
        width: 1280; height: 555
        source : container.activeFocus == true && container.showFocus == true ? imageInfo.imgFolderGeneral + "bg_full_f.png" : ""
    }

    property string wsaMessage: ""
    // Map
    Rectangle{
        id: idMapArea
        x: 40
        y: 225-93-73
        width: 720+2+2
        height: 435+2+2
        border.color: "#556270"
        color: "#00000000"

        WSADataMapItem{
            id: idMap
            x: 2
            y: 2
            width: 720
            height: 435

            Image{
                id: idBottomBar
                x: 0
                y: 375
                width: parent.width
                height: 435-375
                source: imageInfo.imgFolderXMData + "map_alert_info.png"
                Text{
                    id: idTextLow
                    x: 13
                    y: 27
                    width: 140
                    height: 20
                    text: stringInfo.sSTR_XMDATA_WSA_MENU_LOW_5_6/*"Low"*/
                    font.pixelSize: 20
                    font.family: systemInfo.font_NewHDR
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                }
                Text{
                    id: idTextMedium
                    x: 13+140+135
                    y: 27
                    width: 140
                    height: 20
                    text: stringInfo.sSTR_XMDATA_WSA_LEGEND_MEDIUM/*"Medium"*/
                    font.pixelSize: 20
                    font.family: systemInfo.font_NewHDR
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                }
                Text{
                    id: idTextHigh
                    x: 13+140+135+140+135
                    y: 27
                    width: 140
                    height: 20
                    text: stringInfo.sSTR_XMDATA_WSA_MENU_HIGH_7_8/*"High"*/
                    font.pixelSize: 20
                    font.family: systemInfo.font_NewHDR
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                }
            }
        }
    }

    Flickable{
        id: idMsgText
        x: 40+749
        y: 225-93-73
        width: 470//for scroll
        height: 435+2+2
        contentX: idMsgContent.x
        contentY: idMsgContent.y
        contentWidth: idMsgContent.paintedWidth
        contentHeight: idMsgContent.paintedHeight
        flickableDirection: Flickable.VerticalFlick
        interactive : contentHeight > height ? true : false
        clip: true;
        focus: false;
        Text{
            id: idMsgContent
            text: wsaMessage
            width: 470
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 32
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            color: colorInfo.subTextGrey
            wrapMode: Text.WordWrap
        }

        onInteractiveChanged: {
            onCheckFocus();
        }

        onMovementStarted:{
            idMenuBar.contentItem.focus = true;
        }

        MouseArea{
            anchors.fill: parent
            onReleased: {
                if(idMenuBar.contentItem != null)
                	idMenuBar.contentItem.focus = true;
            }
        }


        Behavior on contentY{
            SmoothedAnimation{duration: 100}
        }
    }

    MComp.MScroll{
        x: idMsgText.x + idMsgText.width + 5
        y: idMsgText.y
        height: idMsgText.height
        scrollArea:idMsgText
        width: 13
        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"
        visible: idMsgText.interactive
    }

    Image {
        x: 760
        y: 604 - 166
        source: imageInfo.imgFolderXMData+"sxm_alert_mask.png"
        visible: idMsgText.interactive
    }

    function doLoadData(){
        wsaMessage = UIListener.getAlertLevel(weatherDataManager.getWSADetailPriority()) + "\n" +
                UIListener.getFullNameForMsgType(weatherDataManager.getWSADetailMsgType()) + "\n\n" +
                getAfterTrimGarbage(weatherDataManager.getWSADetailMsg());

        if(interfaceManager.DBIs24TimeFormat == false)
            wsaMessage = getParsingTimeFormat(wsaMessage);

        idMap.doReDraw();
    }

    function getParsingTimeFormat(msgText){
        var regEx = /[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/g;
        var matchs = msgText.match(regEx);

        if(matchs == null)
            return msgText;

        for(var nCnt = 0 ; nCnt < matchs.length ; nCnt++)
        {
            var timeStrBefore = matchs[nCnt];
            var times = timeStrBefore.split(":");
            var ampm;
            if(times[0] < 12)
            {
                ampm = " AM";
                times[0] = times[0] == 0 ? "12" : (times[0] < 10 ? times[0].slice(-1) : times[0]);
            }else
            {
                ampm = " PM";
                times[0] = (times[0] > 12 ? times[0] - 12 : times[0]);
//                times[0] = ("0" + times[0]).slice(-2);
            }
            times.pop();
            var timeStrAfter = times.join(":") + ampm;

            msgText = msgText.replace(timeStrBefore, timeStrAfter);
        }
        return msgText;
    }

    onWheelLeftKeyPressed: {
        var tempContentY = idMsgText.contentY - (64*3);
        if(tempContentY < 0)
            idMsgText.contentY = 0;
        else
            idMsgText.contentY = tempContentY;
    }

    onWheelRightKeyPressed: {
        var tempContentY = idMsgText.contentY + (64*3);
        if(tempContentY > idMsgText.contentHeight - idMsgText.height)
            idMsgText.contentY = idMsgText.contentHeight - idMsgText.height;
        else
            idMsgText.contentY = tempContentY;
    }

    function onCheckFocus(){
        if(idMsgText.interactive)
        {
            // over size
            upFocusAndLock(false);
        }else
        {
            upFocusAndLock(true);
        }
    }

    function getInteractive(){
        console.log("=== WeatherSecurityNAlertsDetail.qml getInteractive idMsgText.interactive" + idMsgText.interactive);
        return idMsgText.interactive;
    }

}
