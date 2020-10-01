import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../../../component/XMData/Javascript/ConvertUnit.js" as MConvertUnit


XMDataSportsLargeTypeListDelegate{
    id: idListItem
    y: 0
    width:ListView.view.width; height: 159
    property bool isNoFocusBG : !thereIsNoTableData && (homeTeamCommentaryChannel > 0 || visitingTeamCommentaryChannel > 0 || nationalTeamCommentaryChannel > 0) && (eventState == sportsLabel.iEVENT_STATE_IN_PROGRAM)

    property bool summerTime: interfaceManager.DBIsDayLightSaving
    property bool timeFormatChange: interfaceManager.DBIs24TimeFormat

    onClickOrKeySelected: {
        if(isDebugVersion)
        {
//            roles[AffiliateIDRole] = "affiliateID";
//            roles[AffiliateNameRole] = "affiliateName";
//            roles[ThereIsNoTableDataRole] = "thereIsNoTableData";
//            roles[SportsIDRole] = "sportsID";
//            roles[TableIDRole] = "tableID";
//            roles[InformationClassRole] = "informationClass";
//            roles[SeasonStatusRole] = "seasonStatus";
//            roles[EpochRole] = "epoch";
//            roles[ReceiptTimeRole] = "receiptTime";
//            roles[HeaderKeyRole] = "headerKey";
//            roles[THeadNameRole] = "tHeadName";
//            roles[HomeTeamNameRole] = "HomeTeamName";
//            roles[VisitingTeamNameRole] = "visitingTeamName";
//            roles[EventStateRole] = "eventState";
//            roles[EventDivisionRole] = "eventDivision";
//            roles[EventClockRole] = "eventClock";
//            roles[EventStartTimeRole] = "eventStartTime";
//            roles[HomeTeamScoreRole] = "homeTeamScore";
//            roles[VisitingTeamScoreRole] = "visitingTeamScore";
//            roles[HomeTeamSupplementalInfoRole] = "homeTeamSupplementalInfo";
//            roles[VisitingTeamSupplementalInfoRole] = "visitingTeamSupplementalInfo";
//            roles[ResultRole] = "result";
//            roles[ExtraInformationRole] = "extraInformation";
//            roles[HomeTeamCommentaryChannelRole] = "homeTeamCommentaryChannel";
//            roles[VisitingTeamCommentaryChannelRole] = "visitingTeamCommentaryChannel";
//            roles[NationalTeamCommentaryChannelRole] = "nationalTeamCommentaryChannel";
//            roles[RaceNameRole] = "raceName";
//            roles[TrackNameRole] = "trackName";
//            roles[HeadlineBodyRole] = "HeadlineBodyRole";
//            roles[RankRole] = "Rank";
//            roles[YdsRole] = "Yds";
//            roles[PurseRole] = "Purse";
//            roles[RefTable] = "RefTable";
//            roles[RankingNameList] = "RankingNameList";
//            roles[RankingScoreList] = "RankingScoreList";
//            roles[SectionNameRole] = "SectionName";
//            roles[UniqKey] = "UniqKey";
//            roles[RootAffiliateID] = "RootAffiliateID";
//            roles[StartDateTimeUTC] = "StartDateTimeUTC";
//            var time = eventClock.;

            console.log("affiliateID:"+affiliateID+",affiliateName:"+affiliateName+",thereIsNoTableData:"+thereIsNoTableData+",sportsID:"+sportsID+",tableID:"+tableID+
                        ",informationClass:"+informationClass+",seasonStatus:"+seasonStatus+",epoch:"+epoch+",receiptTime:"+receiptTime+",headerKey:"+headerKey+
                        ",tHeadName:"+tHeadName+",HomeTeamName:"+HomeTeamName+",visitingTeamName:"+visitingTeamName+",eventState:"+eventState+",eventDivision:"+eventDivision+
                        ",eventClock:"+eventClock+",eventStartTime:"+eventStartTime+",homeTeamScore:"+homeTeamScore+",visitingTeamScore:"+visitingTeamScore+
                        ",homeTeamSupplementalInfo:"+homeTeamSupplementalInfo+",visitingTeamSupplementalInfo:"+visitingTeamSupplementalInfo+",result:"+result+
                        ",extraInformation:"+extraInformation+",homeTeamCommentaryChannel:"+homeTeamCommentaryChannel+",visitingTeamCommentaryChannel:"+visitingTeamCommentaryChannel+
                        ",nationalTeamCommentaryChannel:"+nationalTeamCommentaryChannel+",raceName:"+raceName+",trackName:"+trackName+",HeadlineBodyRole:"+HeadlineBodyRole+
                        ",Rank:"+Rank+",Yds:"+Yds+",Purse:"+Purse+",RefTable:"+RefTable+",RankingNameList:"+RankingNameList+",RankingScoreList:"+RankingScoreList+",SectionName:"+SectionName+
                        ",UniqKey:"+UniqKey+",RootAffiliateID:"+RootAffiliateID+",StartDateTimeUTC:"+StartDateTimeUTC+",StartDate:"+StartDate);
        }
    }

    BorderImage {
        id: idBGFocus
        x: parent.x+19; y:0
        width: parent.width-19-30; height: parent.height
        source: imageInfo.imgFolderXMData + "bg_widget_02_f.png"
        visible: !isNoFocusBG && idListItem.activeFocus && focusOn
        border { left: 20; right: 20; top: 20; bottom: 20 }
    }
    BorderImage {
        id:idBgImage
        x: parent.x+19; y:0
        width: parent.width-19-30; height: (informationClass == 3) ? parent.height+3 : parent.height
        source: (informationClass == 0) ? imageInfo.imgFolderXMData + "bg_widget_02_n.png" : ""
        visible: idBGFocus.visible == false
        border { left: 20; right: 20; top: 20; bottom: 20 }
    }

    //[ISV 88554]
    Item{
        // Layout
        focus: true;
        //Visiting Team Name
        MComp.DDScrollTicker{
            id: idVisitingTeam
            x: 57; y: 15+25-(34/2);
            width: 633
            height: 51
            text: visitingTeamName
            fontFamily : (homeTeamScore < visitingTeamScore) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR
            fontSize: 34
            color: (homeTeamScore < visitingTeamScore) ? colorInfo.bandBlue:colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerEnable: true
            tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
        }
        Text {
            id: idVisitingTeamScore
            x: idVisitingTeam.x+idVisitingTeam.width + 10/*20*/; y: 15+25-(font.pixelSize/2);
            width: 62+10
            text: visitingTeamScore
            font.family: (homeTeamScore < visitingTeamScore) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR
            font.pixelSize: 34
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide:Text.ElideRight
        }
        //Home Team Name
        MComp.DDScrollTicker{
            id: idHomeTeam
            x: idVisitingTeam.x; y: 15+25+32+32-(fontSize/2);
            width: idVisitingTeam.width
            height: 51
            text: HomeTeamName
            fontFamily : (homeTeamScore > visitingTeamScore) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR
            fontSize: 34
            color: (homeTeamScore > visitingTeamScore) ? colorInfo.bandBlue:colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerEnable: true
            tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
        }
        Text {
            id: idHomeTeamScore
            x: idVisitingTeamScore.x; y: 15+25+32+32-(font.pixelSize/2);
            width: idVisitingTeamScore.width
            text: homeTeamScore
            font.family:  (homeTeamScore > visitingTeamScore) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR
            font.pixelSize: 34
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide:Text.ElideRight
        }

        // Event State
        Loader{
            sourceComponent: eventState == sportsLabel.iEVENT_STATE_IN_PROGRAM ? idCompInProgress : idCompFinal
            focus: isNoFocusBG
        }

        Component{
            id: idCompFinal
            Item{
                Text {
                    id: idEndGame
                    x: idVisitingTeamScore.x+idVisitingTeamScore.width + 40; y: 15+25+32-(font.pixelSize/2);
                    width: 410
                    text: sportsLabel.getEventState(eventState)
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide:Text.ElideRight
                }
            }
        }

        Component{
            id: idCompInProgress
            Item{
                Text {
                    id: idInProgress
                    x: idVisitingTeamScore.x + idVisitingTeamScore.width + 40;
                    y: 15+25+32-(font.pixelSize/2);
                    text: eventDivision != "" ?  eventDivision : (new Date(eventClock*1000).getUTCMinutes()) + ":" + ((new Date(eventClock*1000).getUTCSeconds()) <= 9 ? "0" + (new Date(eventClock*1000).getUTCSeconds()) : (new Date(eventClock*1000).getUTCSeconds()));
                    width:256;
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide:Text.ElideRight
                }

                MComp.MButton {
                    id: idLiveCast
                    visible: (homeTeamCommentaryChannel > 0 || visitingTeamCommentaryChannel > 0 || nationalTeamCommentaryChannel > 0)
                    focus: visible
                    x: idInProgress.x + idInProgress.width + 20;
                    y: 24
                    width:138;
                    height: 112
                    bgImage: imageInfo.imgFolderXMData + "btn_widget_02_n.png"
                    bgImagePress: imageInfo.imgFolderXMData + "btn_widget_02_p.png"
                    bgImageFocus: imageInfo.imgFolderXMData + "btn_widget_02_f.png"
                    bgImageFocusPress: imageInfo.imgFolderXMData + "btn_widget_02_p.png"

                    fgImage: imageInfo.imgFolderXMData + "icon_widget_radio.png"
                    fgImageX: 33
                    fgImageY: 14
                    fgImageWidth: 77
                    fgImageHeight: 77
                    fgImageVisible: true;

                    onClickOrKeySelected: {
                        var hCH = homeTeamCommentaryChannel;
                        var vCH = visitingTeamCommentaryChannel;
                        var nCH = nationalTeamCommentaryChannel;

                        idPopupLiveCast.show(hCH,vCH,nCH);
                    }
                }
            }
        }
    }

    Rectangle{
        x:25
        y:15
        visible:isDebugMode();
        Column{
            Row{
                Text{
                    color : "white";
                    text:"[HomeTeamName] : "+ HomeTeamName + " [visitingTeamName] : "+ visitingTeamName + " [eventClock] : "+ eventClock + " [eventDivision] : "+ eventDivision + " [eventState] : "+ eventState + " [eventStartTime] : "+ eventStartTime
                }
            }
        }
    }
}
