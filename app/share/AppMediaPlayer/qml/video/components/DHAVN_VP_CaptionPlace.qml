import QtQuick 1.0
import Qt 4.7

import "../DHAVN_VP_CONSTANTS.js" as CONST


Item
{
    id: rootItem

    Text
    {
        id: subtitlePlace
        visible: video_model.captionEnable // added by kihyung 2013.06.14
        color: CONST.const_CAPTION_FONT_COLOR_STR
        style: Text.Outline
        styleColor: CONST.const_CAPTION_FONT_COLOR_OUTLINE_STR
        text: video_model.subtitleStr
        textFormat : TextEdit.RichText                 //added by Puneet 2013.07.01 for ITS 166425
        wrapMode : TextEdit.Wrap                       //added by Puneet 2013.07.01 for ITS 166425
        horizontalAlignment : Text.AlignHCenter        //added by Puneet 2013.07.01 for ITS 166425
        width : CONST.const_SCREEN_WIDTH               //added by Puneet 2013.07.01 for ITS 166425
        anchors.bottom: rootItem.bottom
        anchors.bottomMargin: CONST.const_CAPTION_PLACE_BOTTOM_MARGIN
        anchors.horizontalCenter: rootItem.horizontalCenter
        font.pointSize: ( video_model.captionSize == CONST.const_CAPTION_TYPE_SMALL  )? CONST.const_CAPTION_SIZE_SMALL  :
                        ( video_model.captionSize == CONST.const_CAPTION_TYPE_NORMAL )? CONST.const_CAPTION_SIZE_NORMAL :
                                                                                        CONST.const_CAPTION_SIZE_LARGE
    }
}
