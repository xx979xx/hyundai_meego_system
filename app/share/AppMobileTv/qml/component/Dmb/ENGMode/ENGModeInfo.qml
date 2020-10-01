import QtQuick 1.0
import "../../QML/DH" as MComp

Item{
    id: idENGModeInfo
    height: systemInfo.contentAreaHeight
    width: 509
    focus: true

    property string currentName : CommParser.m_iPresetListIndex < 0 ? "" : idAppMain.presetListModel.get(CommParser.m_iPresetListIndex,39)

    MComp.MText{
        id : idVersion
        mTextX: 100
        mTextY: 440
        mTextWidth: 400
        mText: "S/W Version : " +  CommParser.m_APP_VERSION
        mTextHorizontalAlies: "Left"
        mTextSize: 20
        mTextColor: colorInfo.brightGrey
    } // End MText
    MComp.MText{
        id: idBuildDate
        mTextX: 100
        mTextY: 470
        mTextWidth: 400
        mText: "Build Date : " + CommParser.m_BUILDDATE
        mTextHorizontalAlies: "Left"
        mTextSize: 20
        mTextColor: colorInfo.brightGrey
    } // End MText
    MComp.MText{
        id: idCurrentCh
        mTextX: 100
        mTextY: 500
        mTextWidth: 400
        mText: "Current Channel : " + currentName
        mTextHorizontalAlies: "Left"
        mTextSize: 20
        mTextColor: colorInfo.brightGrey
    } // End MText
    Connections {
        target: CommParser
        onPresetListIndexChanged : {
            if(CommParser.m_iPresetListIndex != -1)
            {
                currentName = idAppMain.presetListModel.get(CommParser.m_iPresetListIndex,39);
            }
//            console.log("[QML] ENGModeInfo.qml : onCurrentChIndexChanged = " + CommParser.m_iPresetListIndex + ", currentName = " + currentName)
        }
    }
} // End Item
