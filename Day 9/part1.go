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
	file, err := os.Open("input")

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

	var risks [][]int

	for rowNum, row := range lines {
		for colNum, value := range row {
			isLowest := true
			if colNum > 0 {
				left := row[colNum-1]
				isLowest = isLowest && value < left
			}
			if colNum < len(row)-1 {
				right := row[colNum+1]
				isLowest = isLowest && value < right
			}
			if rowNum > 0 {
				top := lines[rowNum-1][colNum]
				isLowest = isLowest && value < top
			}
			if rowNum < len(lines)-1 {
				bottom := lines[rowNum+1][colNum]
				isLowest = isLowest && value < bottom
			}
			if isLowest {
				riskVal := value + 1
				if colNum == 0 {
					riskRow := []int{riskVal}
					risks = append(risks, riskRow)
				} else {
					risks[rowNum] = append(risks[rowNum], riskVal)
				}
			} else {
				if colNum == 0 {
					riskRow := []int{0}
					risks = append(risks, riskRow)
				} else {
					risks[rowNum] = append(risks[rowNum], 0)
				}
			}
		}
	}

	//debugRisks(risks)

	sum := 0

	for _, row := range risks {
		for _, value := range row {
			sum += value
		}
	}

	fmt.Printf("Sum %d\n", sum)
}

func debugRisks(risks [][]int) {
	for _, row := range risks {
		for _, value := range row {
			if value == 0 {
				fmt.Print("X")
			} else {
				fmt.Print(value)
			}
		}
		fmt.Print("\n")
	}
}
