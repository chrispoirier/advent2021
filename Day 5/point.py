class Point:
    x = 0
    y = 0

    def __init__(self, x = 0, y = 0):
        self.x = int(x)
        self.y = int(y)

    @staticmethod
    def fromPointDef(pointDef):
        pts = pointDef.strip().split(",")
        return Point(pts[0], pts[1])