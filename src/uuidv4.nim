import random, times

# generates a uuid version 4, variant 1 as specified in rfc4122

# 4.4.  Algorithms for Creating a UUID from Truly Random or
#       Pseudo-Random Numbers
#
#    The version 4 UUID is meant for generating UUIDs from truly-random or
#    pseudo-random numbers.
#
#    The algorithm is as follows:
#
#    o  Set the two most significant bits (bits 6 and 7) of the
#       clock_seq_hi_and_reserved to zero and one, respectively.
#
#    o  Set the four most significant bits (bits 12 through 15) of the
#       time_hi_and_version field to the 4-bit version number from
#       Section 4.1.3.
#
#    o  Set all the other bits to randomly (or pseudo-randomly) chosen
#       values.

var
  rand {.threadvar.}: Rand
  randInitialized {.threadvar.}: bool

proc toHex(b: uint8): string =
  const HexChars = "0123456789abcdef"
  return HexChars[b shr 4] & HexChars[b and 0x0f]

proc getUUID*(): string =
  if not randInitialized:
    let now = getTime()
    rand = initRand(now.toUnix * 1_000_000_000 + now.nanosecond)
    randInitialized = true
  let uuidLow: uint64 = rand.next
  let uuidHigh: uint64 = rand.next
  var bytes: array[16, uint8]
  bytes[0 .. 7] = cast[array[8, uint8]](uuidLow)
  bytes[8 .. 15] = cast[array[8, uint8]](uuidHigh)
  # clock_seq_hi_and_reserved begins at the 8th byte (starting from 0)
  # set the two most significant bits to 1 and 0 (variant 1)
  bytes[8] = (bytes[8] and 0b00_111111) or 0b10_000000
  # time_hi_and_version field begins at the 6th byte
  # set the four most significant bits to 0100 (version 4)
  bytes[6] = (bytes[6] and 0b0000_1111) or 0b0100_0000
  for idx, b in bytes:
    result &= b.toHex
    if idx in [3, 5, 7, 9]:
      result &= "-"
