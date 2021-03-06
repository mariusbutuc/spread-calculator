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

## Challenge #2

The next challenge is calculate the spread to the government bond curve.

Since the corporate bond term is not exactly the same as its benchmark term, we need to use linear interpolation to dermine the spread to the curve.

### Sample input

| bond   | type       | term        | yield |
|--------|------------|-------------|-------|
| C1     | corporate  | 10.3 years  | 5.30% |
| C2     | corporate  | 15.2 years  | 8.30% |
| G1     | government | 9.4 years   | 3.70% |
| G2     | government | 12 years    | 4.80% |
| G3     | government | 16.3 years  | 5.50% |

### Sample output

```
bond,spread_to_curve
C1,1.22%
C2,2.98%
```

This image will help visualize how to calcualte spread to curve:

![Spread Calculator][spread_calculator.png]

The formula is:

```
C1.spread_to_curve = A - B
C2.spread_to_curve = X - Y
```

Where `A = C1.yield = 5.30%` and `X = C2.yield = 8.30%`. Values of B and Y require [linear interpolation][linear-interpolation-video] to determine. We leave this as an exercise to the challenger.

You can assume that the list of bonds will always contain at least one government bond with a term less all the corporate bonds. As well, it will contain at least one government bond with a term greater than all the corporate bonds. So that you will always be able to calculate `spread_to_curve` for each corporate bond.



 [travis-badge]: https://travis-ci.org/mariusbutuc/spread-calculator.svg?branch=master
 [travis-repo]:https://travis-ci.org/mariusbutuc/spread-calculator
 [codecov-badge]: https://codecov.io/gh/mariusbutuc/spread-calculator/branch/master/graph/badge.svg
 [codecov-repo]: https://codecov.io/gh/mariusbutuc/spread-calculator
 [spread_calculator.png]: https://gist.githubusercontent.com/mariusbutuc/3f4f6ed1bf7256cdce1a30c794270454/raw/fbe2d4cd957ee204b44cdf674c965a9279f8387f/spread_calculator.png
 [linear-interpolation-video]: https://www.youtube.com/watch?v=pXS8tKU2g6Y
