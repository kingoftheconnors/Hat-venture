extends Reference


var lsbbitpacker = preload('./lsbbitpacker.gd')

class CodeEntry:
	var raw_array: Array

	func _init(_sequence):
		raw_array = _sequence

	func add(other):
		return CodeEntry.new(self.raw_array + other.raw_array)
	
	func remove(other):
		return CodeEntry.new(raw_array.slice(0, -(other.raw_array.size()+1) ))
	
	func get_data() -> Array:
		return raw_array
	
	func slice(start, end) -> Array:
		return raw_array.slice(start, end)
	
	func append(other):
		self.raw_array += other.raw_array

class CodeTable:
	var entries: Dictionary = {}
	var counter: int = 0
	var lookup: Dictionary = {}

	func add(entry) -> int:
		self.entries[self.counter] = entry
		self.lookup[entry.raw_array] = self.counter
		counter += 1
		return counter

	func find(entry: Array) -> int:
		return self.lookup.get(entry, -1)

	func has(entry: Array) -> bool:
		return self.find(entry) != -1

	func get(index) -> CodeEntry:
		return self.entries.get(index, null)

func log2(value: float) -> float:
	return log(value) / log(2.0)

func get_bits_number_for(value: int) -> int:
	if value == 0:
		return 1
	return int(ceil(log2(value + 1)))

func initialize_color_code_table(colors: PoolByteArray) -> CodeTable:
	var result_code_table: CodeTable = CodeTable.new()
	for color_id in colors:
		# warning-ignore:return_value_discarded
		result_code_table.add(CodeEntry.new([color_id]))
	# move counter to the first available compression code index
	var last_color_index: int = colors.size() - 1
	# warning-ignore:narrowing_conversion
	var clear_code_index: int = pow(2, get_bits_number_for(last_color_index))
	result_code_table.counter = clear_code_index + 2
	return result_code_table

# compression and decompression done with source:
# http://www.matthewflickinger.com/lab/whatsinagif/lzw_image_data.asp

func compress_lzw(image: PoolByteArray, colors: PoolByteArray) -> Array:
	# Initialize code table
	var code_table: CodeTable = initialize_color_code_table(colors)
	# Clear Code index is 2**<code size>
	# <code size> is the amount of bits needed to write down all colors
	# from color table. We use last color index because we can write
	# all colors (for example 16 colors) with indexes from 0 to 15.
	# Number 15 is in binary 0b1111, so we'll need 4 bits to write all
	# colors down.
	var last_color_index: int = colors.size() - 1
	# warning-ignore:narrowing_conversion
	var clear_code_index: int = pow(2, get_bits_number_for(last_color_index))
	var index_stream: PoolByteArray = image
	var current_code_size: int = get_bits_number_for(clear_code_index)
	var binary_code_stream = lsbbitpacker.LSB_LZWBitPacker.new()

	# initialize with Clear Code
	binary_code_stream.write_bits(clear_code_index, current_code_size)
	
	# Read first index from index stream.
	var index_buffer: CodeEntry = CodeEntry.new([index_stream[0]])
	var data_index: int = 1
	
	# <LOOP POINT>
	while data_index < index_stream.size():
		# Get the next index from the index stream.
		var K: CodeEntry = CodeEntry.new([index_stream[data_index]])
		
		data_index += 1
		# Is index buffer + K in our code table?
		index_buffer.append(K)
		
		if !code_table.has(index_buffer.get_data()): # if NO
			# Don't add K to the end of the index buffer, use the old version for writing
			# Add a row for index buffer + K into our code table
			binary_code_stream.write_bits(code_table.find(index_buffer.slice(0, -(K.raw_array.size()+1))), current_code_size)
			
			# We don't want to add new code to code table if we've exceeded 4095
			# index.
			var last_entry_index: int = code_table.counter - 1
			if last_entry_index != 4095:
				# Output the code for just the index buffer to our code stream
				# warning-ignore:return_value_discarded
				code_table.add(index_buffer)
			else:
				# if we exceeded 4095 index (code table is full), we should
				# output Clear Code and reset everything.
				binary_code_stream.write_bits(clear_code_index, current_code_size)
				code_table = initialize_color_code_table(colors)
				# get_bits_number_for(clear_code_index) is the same as
				# LZW code size + 1
				current_code_size = get_bits_number_for(clear_code_index)
			# Detect when you have to save new codes in bigger bits boxes
			# change current code size when it happens because we want to save
			# flexible code sized codes
			var new_code_size_candidate: int = get_bits_number_for(code_table.counter - 1)
			if new_code_size_candidate > current_code_size:
				current_code_size = new_code_size_candidate
			
			# Index buffer is set to K
			index_buffer = K
	
	# Output code for contents of index buffer
	binary_code_stream.write_bits(code_table.find(index_buffer.get_data()), current_code_size)
	
	# output end with End Of Information Code
	binary_code_stream.write_bits(clear_code_index + 1, current_code_size)
	
	var min_code_size: int = get_bits_number_for(clear_code_index) - 1
	
	return [binary_code_stream.pack(), min_code_size]
