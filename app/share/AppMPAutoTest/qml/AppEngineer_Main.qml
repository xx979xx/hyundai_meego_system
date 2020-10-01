import Qt 4.7

Rectangle{
    width: 1280
    height: 720

    Rectangle{
        id:btn1
        x:0
        y:0
        width: 320//256
        height:360

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "1";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch(1)
            }
        }
    }

    Rectangle{
        id:btn2
        x:320
        y:0
        width: 320
        height:360

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "2";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch(2)
            }
        }
    }

    Rectangle{
        id:btn3
        x:640
        y:0
        width: 320
        height:360

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "3";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch(3)
            }
        }
    }

    Rectangle{
        id:btn4
        x:960
        y:0
        width: 320
        height:360

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "4";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch(4)
            }
        }
    }

    Rectangle{
        id:btn5
        x:0
        y:360
        width: 320
        height:360

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "5";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch(5)
            }
        }
    }

    Rectangle{
        id:btn6
        x:320
        y:360
        width: 320
        height:360

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "6";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch(6)
            }
        }
    }

    Rectangle{
        id:btn7
        x:640
        y:360
        width: 320
        height:360

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "7";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch(7)
            }
        }
    }

    Rectangle{
        id:btn8
        x:960
        y:360
        width: 320
        height:360

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "8";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch(8)
            }
        }
    }






}

