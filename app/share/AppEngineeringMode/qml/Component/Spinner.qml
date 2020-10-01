import QtQuick 1.0

import "../System" as MSystem

MComponent {
    id:container
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id: imageInfo }

    property string imgFolderSpinner : imageInfo.imgFolderSpinner
    focus:true
    property int itemWidth: 350
    property int itemHeight: 68
    property int itemCount:aSpinControlTextModel.count
    property string selectedItemName;
    property int currentIndexVal: 0
    signal spinControlValueChanged()
    property alias curVal: spinner.currentIndex
    //    property alias idSpinDelegate: idSpinner.bgSize
    //    property alias bgImgSize: idSpinner.bgSize


    /** list of text that should be shown in SpinControl*/
    property ListModel aSpinControlTextModel: ListModel{}
    // property alias focusMode: idSpinner.leftFocus



    // property QtObject spinnerModel

    width: itemWidth.width+75+75; height: itemHeight


    MButton{
        id:leftButton
        height: 68
        width: 75
        x:0
        focus:true
        defaultImage: imgFolderSpinner + "btn_arrow_l_n.png"
        bgImage:  imgFolderSpinner + "btn_arrow_l_n.png"
        bgImageFocusPress: imgFolderSpinner+"btn_arrow_l_fp.png"
        bgImageFocus: imgFolderSpinner+"btn_arrow_l_f.png"
        bgImagePress: imgFolderSpinner+"btn_arrow_l_p.png"
        fgImage: imgFolderSpinner + "btn_arrow_l_n.png"
        fgImageActive: imgFolderSpinner + "btn_arrow_l_n.png"
        KeyNavigation.right:rightButton
        onClickOrKeySelected: {
            leftButton.forceActiveFocus()
            console.log("Press Left Key")
            //leftButton.forceActiveFocus()
            if(spinner.currentIndex != 0){
              //leftButton.focus =true
              //leftButton.forceActiveFocus()
                spinner.decrementCurrentIndex()
                spinControlValueChanged()
                                //leftButton
            }
            else{
              //leftButton.focus =true
              //leftButton.forceActiveFocus()
              spinner.currentIndex = itemCount -1
              spinControlValueChanged()
            //leftButton
            }

        }

    }

    MButton{
        id:rightButton
        height: 68
        width: 75
        x:itemWidth-74
        //focus:true
        defaultImage: imgFolderSpinner + "btn_arrow_r_n.png"
        bgImage:  imgFolderSpinner + "btn_arrow_r_n.png"
        bgImageFocusPress: imgFolderSpinner+"btn_arrow_r_fp.png"
        bgImageFocus: imgFolderSpinner+"btn_arrow_r_f.png"
        bgImagePress: imgFolderSpinner+"btn_arrow_r_p.png"
        fgImage: imgFolderSpinner + "btn_arrow_r_n.png"
        fgImageActive: imgFolderSpinner + "btn_arrow_r_n.png"
        KeyNavigation.left:leftButton
        onClickOrKeySelected: {
            rightButton.forceActiveFocus()
            //rightButton.forceActiveFocus()
            if(spinner.currentIndex < itemCount-1){
                //leftButton.focus = false
                //rightButton.focus =true;
                spinner.incrementCurrentIndex()
                spinControlValueChanged()
                //rightButton
            }
            else{
                //leftButton.focus = false
                //rightButton.focus =true;
                spinner.currentIndex = 0
                spinControlValueChanged()
                //rightButton
            }
        }
    }

    ListView {
        id: spinner
        model: aSpinControlTextModel
        x:76
        //focus:true
        preferredHighlightBegin: 0; preferredHighlightEnd: 0
        highlightRangeMode: ListView.StrictlyEnforceRange
        orientation: ListView.Horizontal
        snapMode: ListView.NoSnap;
        flickDeceleration: 3000
        highlightMoveSpeed :3000
        currentIndex: currentIndexVal
        delegate: SpinnerDelegate {}
    }
}
