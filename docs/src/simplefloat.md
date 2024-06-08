A `SimpleFloat` is a concrete binary floating-point type, implemented as a paramterized `struct` with supertype `SimpleBinaryFloat{W,P}`. SimpleFloats are unsigned, finite and do not have a NaN value. As with all concrete binary floats, there are two fields: `value` and `encodeing`. For a given SimpleFloat, a SimpleFloat{W,P} with W and P known, this package provides a two dictionaries, one mapping encodings to their values and one mapping values to their encodings. 

A `SimpleFloat{3,2}` is developed:

|      |            signficand              |            exponent       |         value          |
| code | fractional | integer | significand | biased | unbiased | 2^    | significand * exponent |
|------|------------|---------|-------------|--------|----------|-------|------------------------|
| 0x00 |   0b0      |   0b0   |  0/2        |  0b00  |  -0b01   |  1/2  |            0           |
| 0x01 |   0b1      |   0b0   |  1/2        |  0b00  |  -0b01   |  1/2  |          1/4           |
| 0x02 |   0b0      |   0b1   |  1/1        |  0b01  |   0b00   |  1/1  |          1/1           |
| 0x03 |   0b1      |   0b1   |  3/2        |  0b01  |   0b00   |  1/1  |          3/2           |
| 0x04 |   0b0      |   0b1   |  1/1        |  0b10  |   0b01   |  2/1  |          2/1           |
| 0x05 |   0b1      |   0b1   |  3/2        |  0b10  |   0b01   |  2/1  |          3/1           |
| 0x06 |   0b0      |   0b1   |  1/1        |  0b11  |   0b10   |  4/1  |          4/1           |
| 0x07 |   0b1      |   0b1   |  3/2        |  0b11  |   0b10   |  4/1  |          6/1           |

