# Spread Calculator [![Build Status][travis-badge]][travis-repo] [![Code Coverage][codecov-badge]][codecov-repo]

Calculate the yield spread between a corporate bond and its government bond benchmark

## Challenge #1

Calculate the yield spread (return) between a corporate bond and its government bond benchmark.

A government bond is a good benchmark if it is as close as possible to the corporate bond in terms of years to maturity (term).

### Sample input

| bond   | type       | term        | yield |
|--------|------------|-------------|-------|
| C1     | corporate  | 10.3 years  | 5.30% |
| G1     | government | 9.4 years   | 3.70% |
| G2     | government | 12 years    | 4.80% |

### Sample output

```
bond,benchmark,spread_to_benchmark
C1,G1,1.60%
```

To explain, the best candidate for a benchmark for C1 (corporate bond) is the G1 (government bond) since their difference in term is only 0.9 years vs G2 that is 1.7 years away. Hence, the `spread_to_benchmark` for C1 is C1.yield - G1.yield = 1.60%.

Given a list of corporate and government bonds, find a benchmark bond for each corporate bond and calculate the spread to benchmark.

 [travis-badge]: https://travis-ci.org/mariusbutuc/spread-calculator.svg?branch=master
 [travis-repo]:https://travis-ci.org/mariusbutuc/spread-calculator
 [codecov-badge]: https://codecov.io/gh/mariusbutuc/spread-calculator/branch/master/graph/badge.svg
 [codecov-repo]: https://codecov.io/gh/mariusbutuc/spread-calculator
