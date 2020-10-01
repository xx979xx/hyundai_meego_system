/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Image {
    fillMode: Image.PreserveAspectFit
    asynchronous: true

    function limitSize() {
        var screenLong = Math.max(window.width, window.height)
        var screenShort = Math.min(window.width, window.height)
        var imageLong = Math.max(sourceSize.width, sourceSize.height)
        var imageShort = Math.min(sourceSize.width, sourceSize.height)

        if (1.0 * imageLong / imageShort > 1.0 * screenLong / screenShort) {
            // limit the long side
            if (imageLong == sourceSize.width) {
                if (sourceSize.width > screenLong) {
                    sourceSize.width = screenLong
                    sourceSize.height = 0
                }
            }
            else if (sourceSize.height > screenLong) {
                sourceSize.height = screenLong
                sourceSize.width = 0
            }
        }
        else {
            // limit the short side
            if (imageShort == sourceSize.width) {
                if (sourceSize.width > screenShort) {
                    sourceSize.width = screenShort
                    sourceSize.height = 0
                }
            }
            else if (sourceSize.height > screenShort) {
                sourceSize.height = screenShort
                sourceSize.width = 0
            }
        }
    }

    onStatusChanged: {
        if (status == Image.Ready) {
            limitSize()
        }
    }
}
