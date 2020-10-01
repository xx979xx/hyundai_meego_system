/**
 * MScroll.qml
 *
 */
import Qt 4.7
import "../../system/DH" as MSystem


Item {
    id: idMScroll

    // PROPERTIES
    property variant scrollArea
    property variant orientation: Qt.Vertical

    property string bgImage: imageInfo.imgFolderGeneral + "scroll_menu_list_bg.png"

    property string topScrollImage:     imageInfo.imgFolderGeneral + "scroll_t.png"
    property string middleScrollImage:  imageInfo.imgFolderGeneral + "scroll_m.png"
    property string bottomScrollImage:  imageInfo.imgFolderGeneral + "scroll_b.png"
    property string selectedScrollImage:  "" // 2013.01.07 added by qutiguy : not used but need to exist

    property real heightRatio: 0.0;


    /* INTERNAL functions */
    function position() {
        var ny = 0;
        var nh = 0;

        if(1 == scrollArea.visibleArea.heightRatio || 0 == scrollArea.visibleArea.heightRatio) {
            /* �ֱ���ȭ��Ͽ��� ����Ʈ�� ��ȭ�ɶ� visibleArea.heightRatio�� 1�� �����Ǿ� ��ũ�ѹٰ� ��ü �� �����ϴ� ���̽���
             * �����ڵ����ῡ�� Repeater�� ���ɶ� heightRatio�� 0���� �����Ǿ� ��ũ�ѹٰ� �۰� ������ ������ ���� ����
             * (visibleArea�� read only value�� �����Ұ�����)
             */

            nh = heightRatio * idMScroll.height
        } else {
            nh = scrollArea.visibleArea.heightRatio * idMScroll.height;
        }

        ny = scrollArea.visibleArea.yPosition * idMScroll.height;

        if(nh < 40)
        {
            ny = ny * (idMScroll.height - 40) / (idMScroll.height - nh);
        }

        // limit lower boundary
        if(ny > idMScroll.height - imgTopScroll.height - imgBottomScroll.height)
            ny = idMScroll.height - imgTopScroll.height - imgBottomScroll.height;

        return (ny > 2) ? ny : 2;
    }

    function size() {
        var height = 0;
        var nh, ny;

        if(1 == scrollArea.visibleArea.heightRatio || 0 == scrollArea.visibleArea.heightRatio) {
            /* �ֱ���ȭ��Ͽ��� ����Ʈ�� ��ȭ�ɶ� visibleArea.heightRatio�� 1�� �����Ǿ� ��ũ�ѹٰ� ��ü �� �����ϴ� ���̽���
             * �����ڵ����ῡ�� Repeater�� ���ɶ� heightRatio�� 0���� �����Ǿ� ��ũ�ѹٰ� �۰� ������ ������ ���� ����
             * (visibleArea�� read only value�� �����Ұ�����)
             */

            nh = heightRatio * idMScroll.height
        } else {
            nh = scrollArea.visibleArea.heightRatio * idMScroll.height;
        }

        ny = scrollArea.visibleArea.yPosition * idMScroll.height;

        if(ny > 3) {
            var t;
            if(idMScroll.orientation == Qt.Vertical) {
                t = Math.ceil(idMScroll.height - 3 - ny);
            } else {
                t = Math.ceil(idMScroll.width - 3 - ny);
            }

            if(nh > t) {
                height = t;
            } else {
                height = nh;
            }
        } else {
            height = nh + ny;
        }

        if(ny < 0) {
            if(40 > nh ) {
                height = (40 - nh) + height;
            }
        }else if(ny > idMScroll.height - nh) {
            if(40 > nh ) {
                height = (40 - nh) + height;
            }
            height += 1;
        } else {
            if(40 > height ) {
                height = 40;
            }
        }

        return (height > imgTopScroll.height + imgBottomScroll.height) ? height : imgTopScroll.height + imgBottomScroll.height;
    }

    function update(height_ratio) {
        //heightRatio = height / contentHeight;
        //yPosition = 1.0 - heightRatio;

        imgScroll.y = position() + imgTopScroll.height;
        imgScroll.height = size() - imgTopScroll.height - imgBottomScroll.height;
    }


    /* WIDGETS */
    BorderImage {
        id: imgBg
        width: parent.width
        height: parent.height
        source: bgImage
    }

    Image {
        id: imgTopScroll
        source: topScrollImage

        width: 14
        height: 8

        anchors.bottom: imgScroll.top
    }

    Image {
        id: imgScroll
        source: middleScrollImage
        y: position() + imgTopScroll.height

        width: 14
        height: size() - imgTopScroll.height - imgBottomScroll.height

        /*DEPRECATED
        onVisibleChanged: {
            if(true == imgScroll.visible) {
                imgScroll.y = idMScroll.orientation == Qt.Vertical ? size() : idMScroll.height - 8
                imgScroll.height = idMScroll.orientation == Qt.Vertical ? size() : idMScroll.height - 8
            }
        }
DEPRECATED*/
    }

    Image {
        id: imgBottomScroll
        source: bottomScrollImage

        width: 14
        height: 8

        anchors.top: imgScroll.bottom
    }
}
/* EOF */
