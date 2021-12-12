from line import Line
from linecollection import LineCollection
from linemap import LineMap

input = open("input", "r")
data = input.readlines()

lines = LineCollection.fromData(data)
#lines.debugOutput()

stLines = lines.getStraightLines()
#stLines.debugOutput()

lineMap = LineMap()
lineMap.applyLineCollection(stLines)
#lineMap.debugOutput()

print(lineMap.countFilter(lambda p: (type(p) is int and p >= 2)))