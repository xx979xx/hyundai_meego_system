import Qt 4.7

import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

/** Progress background image */
Image
{
    id: progress_bg

    /** --- Input parameters --- */
    property string bg_img: RES.const_PROGRESS_BG_IMG
    property string bar_img: RES.const_PROGRESS_BAR_IMG
    property string bar_img_red: RES.const_PROGRESS_BAR_IMG_RED

    property variant min
    property variant max
    property variant cur
    property bool useRed

    /** --- Object property --- */
   // width: sourceSize.width; height: sourceSize.height
    source: bg_img

    //anchors.horizontalCenter: parent.horizontalCenter

    /** --- Child object --- */
    /** Progress bar image */
    Image
    {
        property real cur_width: ( ( min - cur ) / ( max - min ) * ( sourceSize.width ) )

        fillMode: Image.Tile
        source: (useRed && ((cur / max) >= 0.9)) ? bar_img_red : bar_img

        anchors{ top: parent.top; bottom: parent.bottom; left: parent.right; right: parent.right;
                 leftMargin: cur_width }

    }

}
