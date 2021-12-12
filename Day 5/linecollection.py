from typing import MutableSequence
from line import Line
from point import Point

class LineCollection:
    lines = []

    def __init__(self, lines = []):
        self.lines = lines

    @staticmethod
    def fromData(data):
        lines = []
        for lineDef in data:
            lines.append(Line.fromLineDef(lineDef))
        return LineCollection(lines)

    def debugOutput(self):
        for line in self.lines:
            line.debugOutput()
        print()

    def getStraightLines(self):
        lines = list(filter(lambda p : (p.isStraight()), self.lines))
        return LineCollection(lines)

    def getMaxCoords(self):
        maxCoords = Point(0,0)
        for line in self.lines:
            if(line.point1.x > maxCoords.x): maxCoords.x = line.point1.x
            if(line.point2.x > maxCoords.x): maxCoords.x = line.point2.x
            if(line.point1.y > maxCoords.y): maxCoords.y = line.point1.y
            if(line.point2.y > maxCoords.y): maxCoords.y = line.point2.y
        return maxCoords