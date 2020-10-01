
"""A Python implementation of Conway's Life

Michael Wohlgenannt writes this about Life:
  "For a single cell there are two distinct states, dead and alive. A living
  cell dies of boredom if there are less than two living neighbours (all in
  all there are eight). A dead cell gets back to life again if there are
  exactly three living neighbours. The last rule is that a living cell dies
  if there are more than three living neighbours.
  A lot of cell configurations that can be constructed show a peculiar and
  amusing behaviour. Some stay as they are, dead or alive, some oscillate,
  some even propagate."
"""

# 26 august 1998, Just van Rossum <just@letterror.com>

from Numeric import *
import sys
import string

def life(cells):
	# convert cells to bytes for speed
	cells = cells.astype(Int8)

	# calculate how many neibors each cell has
	neighbors = shift_left(shift_up(cells))
	neighbors = neighbors + shift_up(cells)
	neighbors = neighbors + shift_right(shift_up(cells))
	neighbors = neighbors + shift_left(cells)
	neighbors = neighbors + shift_right(cells)
	neighbors = neighbors + shift_left(shift_down(cells))
	neighbors = neighbors + shift_down(cells)
	neighbors = neighbors + shift_right(shift_down(cells))

	# apply the "Life" rules (see module doc string)
	newcells = logical_or(
			logical_and(
				cells,
				logical_and(
					less_equal(2, neighbors),
					less_equal(neighbors, 3)
				)
			),
			equal(neighbors, 3)
		)

	# If I understood it correctly, with "rich comparisons"
	# the above could look like this:
	#
	# newcells = cell and (2 <= neighbors <= 3) or neighbors == 3
	#
	# Now, wouldn't that be nice...

	return newcells


def shift_up(cells):
	return concatenate((cells[1:], cells[:1]))

def shift_down(cells):
	return concatenate((cells[-1:], cells[:-1]))

def shift_left(cells):
	return transpose(shift_up(transpose(cells)))

def shift_right(cells):
	return transpose(shift_down(transpose(cells)))

def randomcells(width, height, chance = 5):
	from whrandom import randint
	cells = zeros((height, width), Int8)

	_range = range

	# fill with noise
	for y in _range(height):
		for x in _range(width):
			cells[y][x] = randint(0, chance) == 0
	return cells

def printcells(cells):
	x, y = cells.shape
	thing = "+" + y * "-" + "+"
	lines = [thing]
	for i in range(x):
		list = map(lambda x: " O"[x], cells[i])
		lines.append("|"+string.join(list, "")+"|")
	lines.append(thing)
	print string.join(lines, "\n")


if __name__ == "__main__":
	import time
	width = 20
	height = 10
	cells = randomcells(width, height)

	while 1:
		printcells(cells)
		time.sleep(0.1)
		cells = life(cells)


