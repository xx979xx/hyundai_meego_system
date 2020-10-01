import Qt 4.7

import "../../system/DH" as MSystem

Button {
    id:idBackButton
    width:194; height:68; z:100
    MSystem.ImageInfo{ id: imageInfo }

    bgImage:imageInfo.imgFolderGeneral+"btn_back_n.png"
    bgImagePressed:imageInfo.imgFolderGeneral+"btn_back_p.png"

}
