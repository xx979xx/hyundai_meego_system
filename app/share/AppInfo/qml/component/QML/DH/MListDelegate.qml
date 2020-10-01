/**
 * FileName: MListDelegate.qml
 * Author: David Bae
 * Time: 2011-10-26 14:07
 *
 * - 2011-10-26 Initial Crated by David Bae
 */
import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

FocusScope {
    MSystem.ImageInfo{id:imageInfo}

    id: delegate
    //width: delegate.ListView.view.width;
    width: 389;
    height: 78
    smooth: true

    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderRadio_HD : imageInfo.imgFolderRadio_Hd
    property string imgFolderDmb : imageInfo.imgFolderDmb //Add DMB tune mode by jyjeon
    property int numChange: 0
    property int firstIndex : 0;

    property string imgBgPreset01       :imgFolderRadio+"bg_preset_01.png" //touch Small background image
    property string imgBgPreset02       :imgFolderRadio+"bg_preset_02.png" //touch Large background image
    property string imgBgPreset03       :imgFolderRadio+"bg_preset_03.png" //Jog big background image
    property string imgBgPreset04       :imgFolderRadio_HD+"bg_preset_jog.png" //Jog small background image

    property string imgBtnPreset01n     :imgFolderRadio+"btn_preset_01_n.png"
    property string imgBtnPreset01s     :imgFolderRadio+"btn_preset_01_s.png"
    property string imgBtnPreset02n     :imgFolderRadio+"btn_preset_02_n.png"
    property string imgBtnPreset02s     :imgFolderRadio+"btn_preset_02_s.png"
    property string imgPresetDividerN   :imgFolderRadio+"preset_divider_n.png"
    property string imgPresetDividerS   :imgFolderRadio+"preset_divider_s.png"


    property string imgBtnPresetJog01n  :imgFolderRadio+"btn_preset_jog_01_n.png"
    property string imgBtnPresetJog01s  :imgFolderRadio+"btn_preset_jog_01_s.png"
    property string imgBtnPresetJog01f  :imgFolderRadio+"bg_preset_jog_01_f.png"
    property string imgBtnSmallJog01n   :imgFolderRadio_HD+"btn_preset_jog_01_n.png"
    property string imgBtnSmallJog01s   :imgFolderRadio_HD+"btn_preset_jog_01_s.png"
    property string imgBtnSmallJog01f   :imgFolderRadio_HD+"bg_preset_jog_01_f.png"

    property string imgBtnPresetJog02n  :imgFolderRadio+"btn_preset_jog_02_n.png"
    property string imgBtnPresetJog02s  :imgFolderRadio+"btn_preset_jog_02_s.png"
    property string imgBtnPresetJog02f  :imgFolderRadio+"bg_preset_jog_02_f.png"
    property string imgBtnSmallJog02n   :imgFolderRadio_HD+"btn_preset_jog_02_n.png"
    property string imgBtnSmallJog02s   :imgFolderRadio_HD+"btn_preset_jog_02_s.png"
    property string imgBtnSmallJog02f   :imgFolderRadio_HD+"bg_preset_jog_02_f.png"

    property string imgBtnPresetJog03n  :imgFolderRadio+"btn_preset_jog_03_n.png"
    property string imgBtnPresetJog03s  :imgFolderRadio+"btn_preset_jog_03_s.png"
    property string imgBtnPresetJog03f  :imgFolderRadio+"bg_preset_jog_03_f.png"
    property string imgBtnSmallJog03n   :imgFolderRadio_HD+"btn_preset_jog_03_n.png"
    property string imgBtnSmallJog03s   :imgFolderRadio_HD+"btn_preset_jog_03_s.png"
    property string imgBtnSmallJog03f   :imgFolderRadio_HD+"bg_preset_jog_03_f.png"

    property string imgBtnPresetJog04n  :imgFolderRadio+"btn_preset_jog_04_n.png"
    property string imgBtnPresetJog04s  :imgFolderRadio+"btn_preset_jog_04_s.png"
    property string imgBtnPresetJog04f  :imgFolderRadio+"bg_preset_jog_04_f.png"
    property string imgBtnSmallJog04n   :imgFolderRadio_HD+"btn_preset_jog_04_n.png"
    property string imgBtnSmallJog04s   :imgFolderRadio_HD+"btn_preset_jog_04_s.png"
    property string imgBtnSmallJog04f   :imgFolderRadio_HD+"bg_preset_jog_04_f.png"

    property string imgBtnPresetJog05n  :imgFolderRadio+"btn_preset_jog_05_n.png"
    property string imgBtnPresetJog05s  :imgFolderRadio+"btn_preset_jog_05_s.png"
    property string imgBtnPresetJog05f  :imgFolderRadio+"bg_preset_jog_05_f.png"
    property string imgBtnSmallJog05n   :imgFolderRadio_HD+"btn_preset_jog_05_n.png"
    property string imgBtnSmallJog05s   :imgFolderRadio_HD+"btn_preset_jog_05_s.png"
    property string imgBtnSmallJog05f   :imgFolderRadio_HD+"bg_preset_jog_05_f.png"

    property string imgBtnPresetJog06n  :imgFolderRadio+"btn_preset_jog_06_n.png"
    property string imgBtnPresetJog06s  :imgFolderRadio+"btn_preset_jog_06_s.png"
    property string imgBtnPresetJog06f  :imgFolderRadio+"bg_preset_jog_06_f.png"
    property string imgBtnSmallJog06n   :imgFolderRadio_HD+"btn_preset_jog_06_n.png"
    property string imgBtnSmallJog06s   :imgFolderRadio_HD+"btn_preset_jog_06_s.png"
    property string imgBtnSmallJog06f   :imgFolderRadio_HD+"bg_preset_jog_06_f.png"

    property string imgBtnPresetJog07n  :imgFolderRadio+"btn_preset_jog_07_n.png"
    property string imgBtnPresetJog07s  :imgFolderRadio+"btn_preset_jog_07_s.png"
    property string imgBtnPresetJog07f  :imgFolderRadio+"bg_preset_jog_07_f.png"
    property string imgBtnSmallJog07n   :imgFolderRadio_HD+"btn_preset_jog_07_n.png"
    property string imgBtnSmallJog07s   :imgFolderRadio_HD+"btn_preset_jog_07_s.png"
    property string imgBtnSmallJog07f   :imgFolderRadio_HD+"bg_preset_jog_07_f.png"

    property string imgBtnList1         :imgFolderRadio+"btn_list_l.png"

    property string imgBtnPresetTuneFocus    :imgFolderDmb+"focus_444.png" //Add DMB tune mode by jyjeon

    property string inputMode : idAppMain.inputMode//"touch" //"jog"
    property bool twoPartitionView : false //Default : ListDelegate ThreePartition 
    property string secondTextAlignment: "Right" // horizontalAlignment of secondText ("Right"/"Left"/"Center")
    property bool secondTextHdRadioIsAm: false  //  Band of HD radio is "AM"

    property int viewposition : (((index-firstIndex) >= 0) && ((index-firstIndex) < 7))?(index-firstIndex):0;

    property bool selectedFlag : false;
    property string firstText : "";
    property string secondText : "";
    property string thirdText : "";

    signal clickOrKeySelected()
    signal pressAndHold();

    states: [
        State{
            name:"Selected"; when:(selectedFlag)
            PropertyChanges { target: bgimg; source:getBgImageSelected()}
            PropertyChanges { target: idIndex; color:"black"}
            PropertyChanges { target: text2; color:"black"}
            PropertyChanges { target: text3; color:"black"}
            PropertyChanges { target: idDivider1; source:imgPresetDividerS}
            PropertyChanges { target: idDivider2; source:imgPresetDividerS}
        }
    ]

    function getBgImageNormal(){
        if(inputMode == "touch"){
            if(viewMode=="big"){
                return imgBtnPreset02n;
            }
            else{
                return imgBtnPreset01n;
            }
        }
        else if(inputMode == "tuneFocus"){ //Add DMB tune mode by jyjeon
            if(viewMode=="big"){
                return imgBtnPreset02n;
            }
            else{
                return ""
            }
        }
        else{
            if(viewMode=="big"){
                switch(viewposition){
                case 0:
                    return imgBtnPresetJog01n
                case 1:
                    return imgBtnPresetJog02n
                case 2:
                    return imgBtnPresetJog03n
                case 3:
                    return imgBtnPresetJog04n
                case 4:
                    return imgBtnPresetJog05n
                case 5:
                    return imgBtnPresetJog06n
                case 6:
                    return imgBtnPresetJog07n
                default:
                    break;
                }
                return imgBtnPreset02n
            }
            else{
                switch(viewposition){
                case 0:
                    return imgBtnSmallJog01n
                case 1:
                    return imgBtnSmallJog02n
                case 2:
                    return imgBtnSmallJog03n
                case 3:
                    return imgBtnSmallJog04n
                case 4:
                    return imgBtnSmallJog05n
                case 5:
                    return imgBtnSmallJog06n
                case 6:
                    return imgBtnSmallJog07n
                default:
                    break;
                }
                return imgBtnPreset01n
            }
        }
    }
    function getBgImageSelected(){
        if(inputMode == "touch"){
            if(viewMode=="big"){
                return imgBtnPreset02s;
            }
            else{
                return imgBtnPreset01s
            }
        }
        else if(inputMode == "tuneFocus"){ //Add DMB tune mode by jyjeon
            if(viewMode=="big"){
                return imgBtnPreset02s;
            }
            else{
                return imgBtnPreset01s
            }
        }
        else{
            if(viewMode=="big"){
                switch(viewposition){
                case 0:
                    return imgBtnPresetJog01s
                case 1:
                    return imgBtnPresetJog02s
                case 2:
                    return imgBtnPresetJog03s
                case 3:
                    return imgBtnPresetJog04s
                case 4:
                    return imgBtnPresetJog05s
                case 5:
                    return imgBtnPresetJog06s
                case 6:
                    return imgBtnPresetJog07s
                default:
                    break;
                }
                return imgBtnPreset02s
            }
            else
            {
                switch(viewposition){
                case 0:
                    return imgBtnSmallJog01s
                case 1:
                    return imgBtnSmallJog02s
                case 2:
                    return imgBtnSmallJog03s
                case 3:
                    return imgBtnSmallJog04s
                case 4:
                    return imgBtnSmallJog05s
                case 5:
                    return imgBtnSmallJog06s
                case 6:
                    return imgBtnSmallJog07s
                default:
                    break;
                }
                return imgBtnPreset02s
            }

        }
    }
    function getBgImagefocus(){
        if(!delegate.activeFocus){
            return "";
        }
        if(inputMode == "touch")
            return ""//imgBtnPreset02s;
        else if(inputMode == "tuneFocus"){ //Add DMB tune mode by jyjeon
                return imgBtnPresetTuneFocus;
        }
        else{
            if(viewMode=="big"){
                switch(viewposition){
                case 0:
                    return imgBtnPresetJog01f
                case 1:
                    return imgBtnPresetJog02f
                case 2:
                    return imgBtnPresetJog03f
                case 3:
                    return imgBtnPresetJog04f
                case 4:
                    return imgBtnPresetJog05f
                case 5:
                    return imgBtnPresetJog06f
                case 6:
                    return imgBtnPresetJog07f
                default:
                    break;
                }
                return imgBtnPresetJog01f
            }
            else
            {
                switch(viewposition){
                case 0:
                    return imgBtnSmallJog01f
                case 1:
                    return imgBtnSmallJog02f
                case 2:
                    return imgBtnSmallJog03f
                case 3:
                    return imgBtnSmallJog04f
                case 4:
                    return imgBtnSmallJog05f
                case 5:
                    return imgBtnSmallJog06f
                case 6:
                    return imgBtnSmallJog07f
                default:
                    break;
                }
                return imgBtnPresetJog01f
            }
        }
    }
    //************************ Alignment Function of SecondText ***//
    function secondTextAlignmentFunc(){
        //console.log("###secondTextAlignmentfunction###: ", secondTextAlignment)
        if(twoPartitionView){
            if(secondTextHdRadioIsAm){ return Text.AlignHCenter}
            else{ return Text.AlignLeft}
        }
        else{
            if(secondTextAlignment == "Center"){ return Text.AlignHCenter}
            else if(secondTextAlignment == "Left"){ return Text.AlignLeft}
            else{ return Text.AlignRight}
        }
    }

    Image {
        id: bgimgfocus
        x: -5;
        y: -6;
        //height: 90
        source: getBgImagefocus()
    }
    Image {
        id: bgimg
        x: 0; y: 0;
        height: 78
        source: getBgImageNormal()
    }
    Text {
        id: idIndex
        x: 19; y: 41 - idIndex.paintedHeight/2
        width: 39
        //text: (delegate.activeFocus)?(">" + (index + 1)):(index + 1)
        text: firstText//index + 1
        opacity : 1
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignHCenter
        font { family: "HDR"; pixelSize: 36}
    }
    Image{
        id:idDivider1
        x:68;y:7
        height: parent.height - 7*2;
        source: imgPresetDividerN
    }

    Text {
        id: text2
        x: secondTextAlignment == "Center" ? 19+39+28 : 19+39+24;
        y: 41-paintedHeight/2
        width: ((viewMode=="big") && (twoPartitionView))? 269 : 96
        text: secondText//name
        opacity : 1
        color: colorInfo.brightGrey
        horizontalAlignment: secondTextAlignmentFunc()
        elide: twoPartitionView ? (viewMode=="big" ? Text.ElideNone : Text.ElideRight) : ""
        font.family: "HDR";
        font.pixelSize: twoPartitionView ? 32 : 36
    }
    Image{
        id: idDivider2
        x: 68+124;y:7
        height: parent.height - 7*2;
        source: imgPresetDividerN
        visible: (viewMode=="big") && !(twoPartitionView)
    }
    Text {
        id: text3
        x: 19+39+24+92+38; y: 41-paintedHeight/2
        width: 156;
        text: thirdText; //ensembleLabel;
        opacity : 1
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
        visible:  (viewMode=="big") && !(twoPartitionView)
        font { family: "HDR"; pixelSize: 36} //List font
    }
    MouseArea{
        anchors.fill: delegate
        onClicked: {
            idAppMain.playBeep();
            clickOrKeySelected()
        }
        onPressAndHold: {
            idAppMain.playBeep();
            delegate.pressAndHold();
        }
        onPressed: {
            idAppMain.returnToTouchMode();
        }
    }

    Keys.forwardTo:idAppMain;
    Keys.onPressed:{
        if(!idAppMain.isJogMode(event)){return;}
        if(idAppMain.isSelectKey(event)){
            clickOrKeySelected()
        }
    } 
 	property int debugOnOff: idAppMain.debugOnOff;
}
