import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/system/DH" as MSystem
import "../../../component/Dmb" as MDmb

Item{
    id:idDmbDisasterListEmpty
    width: parent.width
    height: parent.height

    //--------------------- Text #
    MComp.MText{
        id: idNotReceivedDisaster
        //mTextX: 287
        //mTextY: 441-systemInfo.statusBarHeight
        mTextWidth: systemInfo.lcdWidth-267
        mText: stringInfo.strPOPUP_NoDisasterInfo
        mTextColor:colorInfo.brightGrey
        mTextStyle: idAppMain.fontsR
        mTextSize: 32
        mTextHorizontalAlies: "Center"
        anchors.verticalCenter: parent.verticalCenter
    } // End MText
} // End Item
