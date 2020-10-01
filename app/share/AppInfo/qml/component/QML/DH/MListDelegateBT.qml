import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent {
    MSystem.ImageInfo{id:imageInfo}

    id: delegate
    width:565//bgimgfocus.width
    height:102//bgimgfocus.height
    smooth: true

    property string imgFolderBtPhone : imageInfo.imgFolderBt_phone
    property int firstIndex : 0;

    property string imgBtnPresetJog01f  :imgFolderBtPhone+"bg_contacts_list_01_f.png"

    property string imgBtnPresetJog02f  :imgFolderBtPhone+"bg_contacts_list_02_f.png"

    property string imgBtnPresetJog03f  :imgFolderBtPhone+"bg_contacts_list_03_f.png"

    property string imgBtnPresetJog04f  :imgFolderBtPhone+"bg_contacts_list_04_f.png"

    property string inputMode : idAppMain.inputMode//"touch" //"jog"
    property bool twoPartitionView : false //Default : ListDelegate ThreePartition

    property int viewposition : (((index-firstIndex) >= 0) && ((index-firstIndex) < 4))?(index-firstIndex):0;

    property bool selectedFlag : false;
    property string firstText : "";
    property string secondText : "";
    property string thirdText : "";

    signal clickOrKeySelected();
    signal pressAndHold();

    function getBgImagefocus(){
        if(!delegate.activeFocus){
            return "";
        }
        if(inputMode == "touch")
            return ""//imgBtnPreset02s;
        else{
            switch(viewposition){
            case 0:
                return imgBtnPresetJog01f
            case 1:
                return imgBtnPresetJog02f
            case 2:
                return imgBtnPresetJog03f
            case 3:
                return imgBtnPresetJog04f
            }
            return imgBtnPresetJog01f
        }
    }


    Text {
        id:idIndex
        x: 24; y:32-20
        //text: (delegate.activeFocus)?(">" + (index + 1)):(index + 1)
        text: firstText
        color: colorInfo.brightGrey
        font { family: "HDR"; pixelSize: 40}
    }
    Text {
        id:text2
        x: 24
        y: 32+38-12
        text: secondText//name
        color: colorInfo.dimmedGrey
        font.family: "HDR";
        font.pixelSize: 24
    }
    Image{
        x:11
        y:89
        source: imgFolderBt_phone+"line_contacts_list.png"
    }

    MouseArea{
        anchors.fill: delegate
        onClicked: {
            idAppMain.playBeep();
            clickOrKeySelected();
        }
        onPressAndHold: {
            idAppMain.playBeep();
            delegate.pressAndHold();
        }
    }
    Keys.forwardTo:idAppMain;
    Keys.onPressed:{
        if(!idAppMain.isJogMode(event)){return;}
        if(idAppMain.isSelectKey(event)){
            clickOrKeySelected();
        }
    }

    Image {
        id:bgimgfocus
        x:-11;
        z:100
        y:(viewposition==3)?-15:-10;
        source: getBgImagefocus()
    }
    //property int debugOnOff: idAppMain.debugOnOff;
}
