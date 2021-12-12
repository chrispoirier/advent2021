from point import Point

class Line:
    point1 = Point()
    point2 = Point()

    def __init__(self, p1, p2):
        self.point1 = p1
        self.point2 = p2
    
    @staticmethod
    def fromLineDef(lineDef):
        pts = lineDef.strip().split(" -> ")
        return Line(Point.fromPointDef(pts[0]), Point.fromPointDef(pts[1]))

    def isStraight(self):
        return self.isHorizontal() or self.isVertical()

    def isVertical(self):
        return self.point1.x == self.point2.x

    def isHorizontal(self):
        return self.point1.y == self.point2.y

    def debugOutput(self):
        print(self.point1.x + "," + self.point1.y + " -> " + self.point2.x + "," + self.point2.y);
