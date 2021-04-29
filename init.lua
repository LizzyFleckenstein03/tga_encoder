tga_encoder = {}

local image = setmetatable({}, {
	__call = function(self, ...)
		local t = setmetatable({}, {__index = image})
		t:constructor(...)
		return t
	end,
})

function image:constructor(pixels)
	self.bytes = {}
	self.pixels = pixels
	self.width = #pixles[1]
	self.height = #pixels

	self:encode()
end

function image:write(size, value)
	-- TGA uses little endian encoding
	local l = #self.bytes
	for i = 1, size do
		local byte = value % 256
		value = value - byte
		value = value / 256
		self.bytes[l + i] = byte
	end
end

function image:encode_colormap_spec()
	-- first entry index
	self:write(2, 0)
	-- number of entries
	self:write(2, 0)
	-- number of bits per pixel
	self:write(1, 0)
end

function image:encode_image_spec()
	-- X- and Y- origin
	self:write(2, 0)
	self:write(2, 0)
	-- width and height
	self:write(2, width)
	self:write(2, height)
	-- pixel depth
	self:write(1, 24)
	-- image descriptor
	self:write(1, 0)
end

function image:encode_header()
	-- id length
	self:write(1, 0) -- no image id info
	-- color map type
	self:write(1, 0) -- no color map
	-- image type
	self:write(1, 2) -- uncompressed true-color image
	-- color map specification
	self:encode_colormap_spec()
	-- image specification
	self:encode_image_spec()
end

function image:encode_data()
	-- ToDo
end

function image:encode()
	-- encode header
	self:encode_header()
	-- no color map and image id data
	-- encode data
	self:encode_data()
	-- no extension area or file footer
end

function image:save(filename)
	self.data = self.data or string.char(unpack(self.bytes))
	local f = assert(io.open(filename))
	f:write(data)
	f:close()
end

tga_encoder.image = image
