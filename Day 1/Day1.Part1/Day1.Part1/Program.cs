using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Day1.Part1
{
    class Program
    {
        private const bool DEBUG = false;

        static void Main(string[] args)
        {
            var input = File.ReadAllLines("input");
            if (DEBUG) Console.WriteLine("Found {0} lines of input", input.Length);
            var depths = input.Select(i => Convert.ToInt32(i)).ToList();

            Part1(depths);
            Part2(depths);
        }

        private static void Part1(List<int> depths)
        {
            var lastDepth = depths.First();
            var incCount = 0;
            var decCount = 0;
            var sameCount = 0;
            foreach (var depth in depths.TakeLast(depths.Count - 1))
            {
                if (DEBUG) Console.Write("Found depth {0}, previous depth {1} ... ", depth, lastDepth);
                if (depth > lastDepth)
                {
                    if (DEBUG) Console.Write("increasing");
                    incCount++;
                }
                else if (depth < lastDepth)
                {
                    if (DEBUG) Console.Write("decreasing");
                    decCount++;
                }
                else
                {
                    if (DEBUG) Console.Write("same");
                    sameCount++;
                }
                if (DEBUG) Console.Write("\n");
                lastDepth = depth;
            }
            Console.WriteLine("{0} increasing", incCount);
            if (DEBUG)
            {
                Console.WriteLine("{0} decreasing", decCount);
                Console.WriteLine("{0} same", sameCount);
            }
        }

        private static void Part2(List<int> depths)
        {
            var lastDepthSum = (int?)null;
            var incCount = 0;
            var decCount = 0;
            var sameCount = 0;
            for (int i = 0; i < depths.Count - 2; i++)
            {
                var depthSum = depths[i] + depths[i + 1] + depths[i + 2];
                if (DEBUG) Console.Write("Found depth sum {0}, ", depthSum);
                if (lastDepthSum.HasValue)
                {
                    if (DEBUG) Console.Write("previous depth sum {0} ... ", lastDepthSum.Value);
                    if (depthSum > lastDepthSum.Value)
                    {
                        if (DEBUG) Console.Write("increasing");
                        incCount++;
                    }
                    else if (depthSum < lastDepthSum.Value)
                    {
                        if (DEBUG) Console.Write("decreasing");
                        decCount++;
                    }
                    else
                    {
                        if (DEBUG) Console.Write("same");
                        sameCount++;
                    }
                }
                if (DEBUG) Console.Write("\n");
                lastDepthSum = depthSum;
            }
            Console.WriteLine("{0} increasing", incCount);
            if (DEBUG)
            {
                Console.WriteLine("{0} decreasing", decCount);
                Console.WriteLine("{0} same", sameCount);
            }
        }
    }
}
