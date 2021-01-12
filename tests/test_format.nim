import unittest
import strutils
import uuidv4

# To run these tests, simply execute `nimble test`.

test "format is correct":
  let uuid = getUUID()
  check uuid.len == 36
  let parts = uuid.split('-')
  check parts.len == 5
  check parts[0].len == 8
  check parts[1].len == 4
  check parts[2].len == 4
  check parts[3].len == 4
  check parts[4].len == 12
  check parts[2][0] == '4'
  check parts[3][0] in "89ab"
  for part in parts:
    for c in part:
      check c in "0123456789abcdef"
