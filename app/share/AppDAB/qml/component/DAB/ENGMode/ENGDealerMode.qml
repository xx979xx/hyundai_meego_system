/**
 * FileName: ENGDealerModeMain.qml
 * Author: KEH
 * Time: 2013-11
 *
 * - 2013-11 Initial Created by KEH
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../DAB/Common" as MDabCommon


MComp.MComponent {
    id: idDabENGDealerMode
    x: 0; y: 0;
    width: systemInfo.lcdWidth;
    height: systemInfo.subMainHeight
    focus: true

    MDabCommon.ImageInfo { id : imageInfo }

    Image {
        y : 0
        source : imageInfo.imgBg_Main
    }

    MComp.MBand{
        titleText: "DEALER MODE"
        focus: true;

        onBackBtnClicked:{
            UIListener.HandleBackKey(idAppMain.inputMode);
        }
    }

    ENGDealerModeContents{
        x: 0; y: systemInfo.titleAreaHeight
    }

    onBackKeyPressed: {
        UIListener.HandleBackKey(idAppMain.inputMode);
    }
}
