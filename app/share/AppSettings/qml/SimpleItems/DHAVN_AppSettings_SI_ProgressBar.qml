import QtQuick 1.1

Image{
    id: progressBar

    property string bg: ""
    property string fg: ""
    property int nMaxValue: 100
    property int nCurrentValue: 1

    property double delta: progressBar.width / progressBar.nMaxValue

    source: progressBar.bg

    Item{
        id: hideArea
        clip: true
        width: (progressBar.delta * progressBar.nCurrentValue)
        height: parent.height

        Image{
            id: usageImage
            source: progressBar.fg
        }
    }
}
