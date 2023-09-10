import QtQuick 2.0

Item {
    // INTERNAL FUNCTIONS
    QtObject{
        id: internalFunction

        //---SPECTRUM CHAR
        function findClosestPoint(targetX, targetY) {
            var closestPoint;
            var minDistance = Number.MAX_VALUE;

            for (var i = 0; i < spectrumLine.count; i++) {
                var point = spectrumLine.at(i);
                var distance = Math.abs(point.x - targetX);
                if (distance < minDistance) {
                    closestPoint = point;
                    minDistance = distance;
                }
            }

            return closestPoint;
        }

        function showInfoRectangle(x, y) {
            infoRectangle.visible = true;
            infoRectangle.x = x - infoRectangle.width / 2;
            infoRectangle.y = y - infoRectangle.height - 10; // Adjust position
            infoText.text = "X: " + x.toFixed(2) + " Y: " + y.toFixed(2);
        }

        function hideInfoRectangle() {
            infoRectangle.visible = false;
        }

    }
}
