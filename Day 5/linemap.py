from linecollection import LineCollection
from line import Line
from point import Point

class LineMap:
    lmap = []

    def __init__(self): pass

    def applyLineCollection(self, lines: LineCollection):
        self.initMap(lines.getMaxCoords())
        for line in lines.lines:
            self.applyLine(line)

    def initMap(self, maxCoords: Point):
        points = []
        for j in range(0, maxCoords.x+1):
            points.append(".")
        for i in range(0, maxCoords.y+1):
            self.lmap.append(points.copy())

    def applyLine(self, line: Line):
        minX = min(line.point1.x, line.point2.x)
        maxX = max(line.point1.x, line.point2.x)
        minY = min(line.point1.y, line.point2.y)
        maxY = max(line.point1.y, line.point2.y)
        if (line.isHorizontal()):
            for i in range(minX, maxX+1):
                self.applyPoint(Point(i, line.point1.y))
        else:
            if(line.isVertical()):
                for i in range(minY, maxY+1):
                    self.applyPoint(Point(line.point1.x, i))
            else:
                deltaX = 1 if line.point1.x < line.point2.x else -1
                deltaY = 1 if line.point1.y < line.point2.y else -1
                curX = line.point1.x
                curY = line.point1.y
                while curX != line.point2.x and curY != line.point2.y:
                    self.applyPoint(Point(curX, curY))
                    curX += deltaX
                    curY += deltaY
                self.applyPoint(Point(curX, curY))

    
    def applyPoint(self, point: Point):
        current = self.lmap[point.y][point.x]
        if (current == "."):
            self.lmap[point.y][point.x] = 1
        else:
            (self.lmap[point.y][point.x]) += 1

    def countFilter(self, filterFunc):
        count = 0
        for line in self.lmap:
            for point in line:
                if filterFunc(point): count += 1
        return count

    def debugOutput(self):
        for line in self.lmap:
            print("|", end="")
            for point in line:
                print(point, end="")
            print("|")
        print()
