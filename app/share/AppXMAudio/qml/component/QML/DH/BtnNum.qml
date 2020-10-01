import Qt 4.7

Item {
    id : num
    width: 33
    height: 45
    x: (parent.width - num.width)/2
    y: (parent.height - num.height)/2

    property int setNum : 0

    property variant imgMouseN       : [ "num_0.png",
                                        "num_1.png",
                                        "num_2.png",
                                        "num_3.png",
                                        "num_4.png",
                                        "num_5.png",
                                        "num_6.png",
                                        "num_7.png",
                                        "num_8.png",
                                        "num_9.png",
    ]
    property variant imgMouseP       : [ "num_0.png",
                                        "num_1.png",
                                        "num_2.png",
                                        "num_3.png",
                                        "num_4.png",
                                        "num_5.png",
                                        "num_6.png",
                                        "num_7.png",
                                        "num_8.png",
                                        "num_9.png",
    ]

    Image {
        id: background
        source: imageInfo.imgFolderRadio_SXM + imgMouseN[setNum]
        anchors.fill: parent
        smooth: true
    }

    states: [
        State {
            name: 'pressed'; when: parent.pressed
            PropertyChanges {target: background; source: imageInfo.imgFolderRadio_SXM + imgMouseP[setNum]}
        }
    ]
}
