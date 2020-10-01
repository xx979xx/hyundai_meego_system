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
    id: idRadioDisplayCategoryBtnQml
    x: 0; y: 0

    //****************************** # Display Category Button #
    Item{
        id: idRadioCategoryBtn
        x: 326; y: 349
        width: 221; height: 57
        visible:PLAYInfo.ChnNum != "0"

        // Category Left
        MComp.MButton{
            id: idRadioCategoryBtnLeft
            x: 0; y: 0
            width: 72; height: 57
            visible: PLAYInfo.CategoryLock ? false : true
            enabled: (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true

            bgImage: imageInfo.imgFolderRadio_SXM+"btn_seek_l_n.png"
            bgImagePress: imageInfo.imgFolderRadio_SXM+"btn_seek_l_p.png"
            bgImageFocus: imageInfo.imgFolderRadio_SXM+"btn_seek_l_f.png"

            onClickOrKeySelected: {
                setForceFocusButton("CategoryButton");
                idRadioCategoryBtnLeft.focus = true;

                XMOperation.setPreviousScanStop();
                UIListener.HandleCatDownKey()
            }

            onWheelRightKeyPressed: idRadioCategoryBtnRight.forceActiveFocus()
        }

        // Category Right
        MComp.MButton{
            id: idRadioCategoryBtnRight
            x: 72; y: 0
            width: 72; height: 57
            visible: PLAYInfo.CategoryLock ? false : true
            enabled: (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true

            bgImage: imageInfo.imgFolderRadio_SXM+"btn_seek_r_n.png"
            bgImagePress: imageInfo.imgFolderRadio_SXM+"btn_seek_r_p.png"
            bgImageFocus: imageInfo.imgFolderRadio_SXM+"btn_seek_r_f.png"

            onClickOrKeySelected: {
                setForceFocusButton("CategoryButton");
                idRadioCategoryBtnRight.focus = true;

                XMOperation.setPreviousScanStop();
                UIListener.HandleCatUpKey()
            }

            onWheelLeftKeyPressed: idRadioCategoryBtnLeft.forceActiveFocus()
            onWheelRightKeyPressed: PLAYInfo.CategoryLock ? idRadioCategoryBtnLeft.forceActiveFocus() : idRadioCategoryBtnLock.forceActiveFocus()
        }

        // Category Lock
        MComp.MButton{
            id: idRadioCategoryBtnLock
            x: 147; y: 0
            width: 74; height: 57
            visible: true
            focus: true
            enabled: (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true

            bgImage: imageInfo.imgFolderRadio_SXM+"btn_lock_n.png"
            bgImagePress: imageInfo.imgFolderRadio_SXM+"btn_lock_p.png"
            bgImageFocus: imageInfo.imgFolderRadio_SXM+"btn_lock_f.png"

            fgImage: PLAYInfo.CategoryLock ? imageInfo.imgFolderRadio_SXM+"ico_lock.png" : imageInfo.imgFolderRadio_SXM+"ico_unlock.png"
            fgImageX: 13
            fgImageY: 9
            fgImageWidth: 48
            fgImageHeight: 37

            onClickOrKeySelected: {
                setForceFocusButton("CategoryButton");
                idRadioCategoryBtnLock.focus = true;

                if(PLAYInfo.CategoryLock) //Category Lock
                    UIListener.HandleSetCategoryLock(0);
                else //Category Unlock
                {
                    UIListener.HandleSetCategoryLock(1);
                    idRadioCategoryBtnLock.focus = true;
                }

                idAppMain.categoryLockClicked();
                UIListener.writeSettings_CategoryLock();
            }

            onWheelLeftKeyPressed: PLAYInfo.CategoryLock ? null : idRadioCategoryBtnRight.forceActiveFocus()
        }
    }
}
