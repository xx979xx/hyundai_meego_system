import Qt 4.7
import "../../../component/QML/DH" as MComp

//--------------------- Not Received Channel
Item{
    id:idDmbNoSinal
    x:0; y:0
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight

    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderDmb: imageInfo.imgFolderDmb

    //--------------------- Bg Image #
    Image {
        id: mainbackground
        height: parent.height
        source: imgFolderGeneral + "bg_main.png"
    } // End Image

    //--------------------- Warning Image #
    Image {
        id: idCautionIcon
        x:(CommParser.m_bIsFullScreen)?307+306:549+306;
        y:302
        //width:46; height:42
        source: imgFolderDmb + "ico_warning.png";
    } // End Image

    //--------------------- Text #
    MComp.MText{
        id: idNotReceivedCh
        mTextX:(CommParser.m_bIsFullScreen)?0:549;
        mTextY: idCautionIcon.y+106
        mTextWidth: (CommParser.m_bIsFullScreen) ? systemInfo.lcdWidth : 306+364//227+493
        mText: (presetListModel.rowCount() > 0 ) ? stringInfo.strChSignal_NoSignal : stringInfo.strChSignal_NoCH
        mTextColor:colorInfo.brightGrey
        mTextStyle: idAppMain.fontsR
        mTextSize: 32
        mTextHorizontalAlies: "Center"
    } // End MText

    onVisibleChanged: {
        if(visible){
            idNotReceivedCh.mText = (presetListModel.rowCount() > 0 ) ? stringInfo.strChSignal_NoSignal : stringInfo.strChSignal_NoCH
        }
    }

    Connections{
        target: CommParser

        onPresetListIndexChanged:{  // WSH(130220)
//            console.log(" [QML] ===================> onPresetListIndexChanged :presetListModel.rowCount() ",presetListModel.rowCount())

            if(presetListModel.rowCount() == 0){
                idNotReceivedCh.mText = stringInfo.strChSignal_NoCH
            }else{
                idNotReceivedCh.mText = stringInfo.strChSignal_NoSignal
            }//End If
        }
    }

    Connections{
        target: EngineListener
        onRetranslateUi:{
            if(presetListModel.rowCount() == 0){
                idNotReceivedCh.mText = stringInfo.strChSignal_NoCH
            }else{
                idNotReceivedCh.mText = stringInfo.strChSignal_NoSignal
            }//End If
        }
    }

} // End Item
