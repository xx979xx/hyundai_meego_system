import Qt 4.7
import "../../QML/DH" as MComp

Item{
    id: idDmbDLSMessage
    x: 0; y: 0
    width: 0; height: 0

    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderDmb: imageInfo.imgFolderDmb

    // Image Info
    property string dmbDLSImage : imgFolderDmb + "bg_dls_bottom_full.png"

    // Text Info
    property string dmbDLStext : ""

    // DLS Info
    property bool isBottom : true

    // MText Info
    property int mTextY: parent.y
    property int dlsTextSize: 32
    property int dlsTextHeight: dlsTextSize+4

    Item{ // bottom
        id: dlsBottm
        visible: isBottom ? true : false
        anchors.fill: parent

        Image{
            id: idBGImage
            x: 0; y: parent.height - (height)
            width: parent.width; height:72
            source: (CommParser.m_bIsFullScreen)?(imgFolderDmb + "bg_dls_bottom_full.png"):(imgFolderDmb + "bg_dls_bottom.png")  //dmbDLSImage
        } // End Image

        MComp.MText{
            id: idDmbDLStext
            mTextX: 32; mTextY: parent.height - (dlsTextHeight) - 4
            mTextWidth : parent.width - (mTextX*2); mTextHeight: 32
            mText: dmbDLStext
            mTextSize: dlsTextSize
            mTextColor: colorInfo.brightGrey
            mTextElide: "Right"
        } // End MText
    } // End Item

    Item{ // bottom X
        id: dlsDis
        visible: isBottom ? false : true
        anchors.fill: parent

        Image{
            id: idBGImageDis
            anchors.fill: parent
            source: (CommParser.m_bIsFullScreen)?(imgFolderDmb + "bg_dls_full.png"):(imgFolderDmb + "bg_dls.png")

        } // End Image

        Text {
            id: idText
            text: dmbDLStext
            color: colorInfo.subTextGrey
            font.family: idAppMain.fontsR
            font.pixelSize: dlsTextSize
            verticalAlignment: Text.AlignTop
            wrapMode:  Text.WordWrap
            horizontalAlignment: { Text.AlignLeft }
            elide:  Text.ElideNone
            anchors.leftMargin: 25
            anchors.rightMargin: 25
            anchors.topMargin: 60
            anchors.fill: parent
        } // End Text
    } // End Item
} // End Item
