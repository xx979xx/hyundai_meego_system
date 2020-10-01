import Qt 4.7
import "../../../component/QML/DH" as MComp

Item {
    id:idDmbChangingChannel
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight

    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderDmb: imageInfo.imgFolderDmb
    property int loadingImageNumber: 1

    //--------------------- Bg Image #
    Image {
        id: imgBgReceiving
        height: parent.height
        source: imgFolderGeneral + "bg_main.png"
    } // End Image

    //--------------------- Loading Image #
//    AnimatedImage {
    Image {
        id: idImageContainer
        x:(CommParser.m_bIsFullScreen)?307+306:549+306; y:302
        width:60; height:60
//        source: imgFolderDmb + "/loading/loading.gif"
//        visible: idImageContainer.on
//        property bool on: parent.visible;
//        NumberAnimation on rotation { running: idImageContainer.on; from: 0; to: 360; loops: Animation.Infinite; duration: 2400 }
    } // End Image

    //--------------------- Text #
    MComp.MText{
        id: idReceivingCh
        mTextX: (CommParser.m_bIsFullScreen)?0:549;
        mTextY: idImageContainer.y+106
        mTextWidth: (CommParser.m_bIsFullScreen) ? systemInfo.lcdWidth : 306+364
        mText: stringInfo.strChSignal_ChChanging
        mTextColor:colorInfo.brightGrey
        mTextStyle: idAppMain.fontsR
        mTextSize: 32
        mTextHorizontalAlies: "Center"
    } // End MText

    Timer {
        id: idLoadingImageTimer
        interval: 100
        running: true
        repeat: true
        onTriggered:
        {
            idImageContainer.source = imgFolderDmb + "loading/loading_"+ loadingImageNumber +".png"
            loadingImageNumber++;

            if(loadingImageNumber == 17)
            {
                loadingImageNumber = 1;
            }
        }
    }

    onVisibleChanged: {

        if(idDmbChangingChannel.visible == true)
        {
            idLoadingImageTimer.start();
        }
        else
        {
             loadingImageNumber = 1;
            idLoadingImageTimer.stop();
        }
    }

} // End Item
