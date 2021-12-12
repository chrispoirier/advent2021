from line import Line
from linecollection import LineCollection
from linemap import LineMap

input = open("input", "r")
data = input.readlines()

lines = LineCollection.fromData(data)
#lines.debugOutput()

lineMap = LineMap()
lineMap.applyLineCollection(lines)
lineMap.debugOutput()

print(lineMap.countFilter(lambda p: (type(p) is int and p >= 2)))