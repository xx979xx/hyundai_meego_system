import Qt 4.7
import QtQuick 1.1

Item
{
    x:0
    y:parent.y;
    z:parent.z +1;
    visible: false

    MouseArea{
        x:0
        y:systemInfo.titleAreaHeight
        width: parent.width
        height: parent.height
    }

    Image
    {
        x:0
        y:systemInfo.titleAreaHeight
        width: parent.width
        height: parent.height
        source: imageInfo.imgFolderGeneral + "bg_main.png"
    }
    Image
    {
        id: idBlock
        x:562
        y:systemInfo.headlineHeight
        width: 162
        height: 161
        source: imageInfo.imgFolderGeneral + "ico_block.png"
    }
    Text
    {
        x:100
        y:systemInfo.headlineHeight + idBlock.height + 1;
        width: 1080
        height: 82
        text : stringInfo.sSTR_XMDATA_DRS_WARNING_EX
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 32
        wrapMode: Text.Wrap
        color: colorInfo.brightGrey
        lineHeight: 0.75
    }

    onVisibleChanged: {
        console.log("DRS onVisibleChanged = " + visible);
        if(visible)
            idAppMain.isDRSShow = true;
        else
            idAppMain.isDRSShow = false;
    }
}
