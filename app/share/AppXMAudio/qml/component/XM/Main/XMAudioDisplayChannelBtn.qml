/**
 * FileName: RadioFmFrequencyDial.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MComponent {
    id: idRadioDisplayChannelBtnQml
    x: 0; y: 0

    BorderImage {
        id: idChannelfocusImage
        x:-31; y: (PLAYInfo.ChnNum != "0") ? 16 : 190
        source: imageInfo.imgFolderRadio_SXM+"btn_ch_station_f.png"
        visible: showFocus && idRadioDisplayChannelBtnQml.activeFocus
    }

    onSelectKeyPressed: {
        if(idRadioDisplayChannelBtnQml.activeFocus && idAppMain.isJogEnterLongPressed == false)
            idChannelfocusImage.source = imageInfo.imgFolderRadio_SXM+"btn_ch_station_p.png"
    }

    onClickOrKeySelected: {
        if(idRadioDisplayChannelBtnQml.activeFocus)
        {
            if(gSXMScan == "Scan")
            {
                XMOperation.setPreviousScanStop();
            }
            else
            {
                XMOperation.setPresetSaveFlag(true);
                XMOperation.setForceFocusEnterPresetOrderOrSave();
            }

            idChannelfocusImage.source = imageInfo.imgFolderRadio_SXM+"btn_ch_station_f.png"
        }
        else if(!idRadioDisplayChannelBtnQml.activeFocus && idAppMain.isJogEnterLongPressed == true)
        {
            idChannelfocusImage.source = ""
        }
    }

    onActiveFocusChanged: {
        if(activeFocus == false)
        {
            idChannelfocusImage.source = imageInfo.imgFolderRadio_SXM+"btn_ch_station_f.png";
        }
    }

    onCancel:{
        idChannelfocusImage.source = imageInfo.imgFolderRadio_SXM+"btn_ch_station_f.png"
    }

    onWheelLeftKeyPressed: {
        UIListener.HandleScanAndPresetScanStop();
        UIListener.HandleChnDown();
    }
    onWheelRightKeyPressed: {
        UIListener.HandleScanAndPresetScanStop();
        UIListener.HandleChnUp();
    }
}
