tga_encoder = {}

function tga_encoder.encode_pixels(pixels)
end

function tga_encoder.save_image(filename, pixels)
	local f = assert(io.open(filename))
	local encoded = tga_encoder.encode_pixels(pixels)
	f:write(encoded)
	f:close()
end
