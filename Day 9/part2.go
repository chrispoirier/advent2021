package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {
	lines := getLines("input")
	//debugLines(lines)

	basins := getBasinMap(lines)
	//debugBasinMap(basins)

	sizes := getBasinMapSizes(basins)
	//fmt.Println(sizes)

	top3 := getTop3Sizes(sizes)
	//fmt.Println(top3)

	fmt.Printf("Top 3 sizes multiplied: %d\n", (top3[0] * top3[1] * top3[2]))
}

func debugLines(lines [][]int) {
	for _, row := range lines {
		for _, value := range row {
			fmt.Print(value)
		}
		fmt.Print("\n")
	}
	fmt.Println("")
}

func getLines(filename string) [][]int {
	file, err := os.Open(filename)

	if err != nil {
		log.Fatal(err)
	}

	scan := bufio.NewScanner(file)

	var lines [][]int

	for scan.Scan() {
		line := strings.Split(scan.Text(), "")

		var iLine []int
		for _, val := range line {
			iVal, err := strconv.Atoi(val)
			if err != nil {
				log.Fatal(err)
			}
			iLine = append(iLine, iVal)
		}

		lines = append(lines, iLine)
	}

	if err := scan.Err(); err != nil {
		log.Fatal(err)
	}

	return lines
}

func getBasinMap(lines [][]int) [][]rune {
	var basinMap [][]rune
	nextBasin := 'A'

	for rowNum, row := range lines {
		for colNum, value := range row {
			if value == 9 {
				appendToMap(&basinMap, '-', colNum, rowNum)
			} else {
				appendToMap(&basinMap, '?', colNum, rowNum)
			}
		}
	}

	//debugBasinMap(basinMap)

	for rowNum, row := range basinMap {
		for colNum, marker := range row {
			if marker != '-' {
				adjacentBasin := '-'
				if colNum > 0 {
					left := row[colNum-1]
					if left != '-' {
						adjacentBasin = left
					}
				}
				if adjacentBasin == '-' && rowNum > 0 {
					top := basinMap[rowNum-1][colNum]
					if top != '-' {
						adjacentBasin = top
					}
				}

				if adjacentBasin != '-' {
					basinMap[rowNum][colNum] = adjacentBasin
				} else {
					basinMap[rowNum][colNum] = nextBasin
					nextBasin++
				}
			}
		}
	}

	//debugBasinMap(basinMap)

	consistent := false
	for !consistent {
		consistent = !makeBasinMapConsistent(&basinMap)
		//debugBasinMap(basinMap)
	}

	return basinMap
}

func makeBasinMapConsistent(basinMap *[][]rune) bool {
	foundInconsistent := false

	for rowNum, row := range *basinMap {
		for colNum, marker := range row {
			if marker == '-' {
				continue
			}
			if colNum > 0 {
				left := row[colNum-1]
				if left != '-' && left != marker {
					(*basinMap)[rowNum][colNum] = left
					foundInconsistent = true
				}
			}
			if !foundInconsistent && rowNum > 0 {
				top := (*basinMap)[rowNum-1][colNum]
				if top != '-' && top != marker {
					(*basinMap)[rowNum][colNum] = top
					foundInconsistent = true
				}
			}
			if !foundInconsistent && colNum < len(row)-1 {
				right := row[colNum+1]
				if right != '-' && right != marker {
					(*basinMap)[rowNum][colNum] = right
					foundInconsistent = true
				}
			}
			if !foundInconsistent && rowNum < len((*basinMap))-1 {
				bottom := (*basinMap)[rowNum+1][colNum]
				if bottom != '-' && bottom != marker {
					(*basinMap)[rowNum][colNum] = bottom
					foundInconsistent = true
				}
			}
		}
	}

	return foundInconsistent
}

func appendToMap(mapArr *[][]rune, toAppend rune, colNum int, rowNum int) {
	if colNum == 0 {
		mapRow := []rune{toAppend}
		*mapArr = append(*mapArr, mapRow)
	} else {
		(*mapArr)[rowNum] = append((*mapArr)[rowNum], toAppend)
	}
}

func debugBasinMap(basinMap [][]rune) {
	for _, row := range basinMap {
		for _, value := range row {
			fmt.Print(string(value))
		}
		fmt.Print("\n")
	}
	fmt.Println("")
}

func getBasinMapSizes(basinMap [][]rune) map[string]int {
	sizes := map[string]int{}
	for _, row := range basinMap {
		for _, marker := range row {
			if marker != '-' {
				sizes[string(marker)]++
			}
		}
	}
	return sizes
}

func getTop3Sizes(sizes map[string]int) [3]int {
	top3 := [3]int{0, 0, 0}
	for _, size := range sizes {
		if size > top3[0] {
			top3[2] = top3[1]
			top3[1] = top3[0]
			top3[0] = size
		} else if size > top3[1] {
			top3[2] = top3[1]
			top3[1] = size
		} else if size > top3[2] {
			top3[2] = size
		}
	}
	return top3
}
