import Qt 4.7

// System Import
import "../../QML/DH" as MComp

//MComp.MComponent {
XMDataSmallTypeListDelegate{
    id: idListItem
    x:0; y:0
    z: index
    width:ListView.view.width - 34; height:92

    signal itemSelected(int index);
    // Type
    Text {
        id: idText
        x: 19; y: 0//44 - font.pixelSize/2;
        width: 932
        height: parent.height
        text:  name
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    Component.onCompleted: {
        if(ListView.view.count > 0)
        {
            leftFocusAndLock(false);
        }
    }

    onClickOrKeySelected: {
        //itemClicked(idText.text);
        //selectTypename(index);
        if(playBeepOn)
            UIListener.playAudioBeep();
        ListView.view.currentIndex = index;
        itemSelected(index);
    }
}
