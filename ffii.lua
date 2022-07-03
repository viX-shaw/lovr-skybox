ffi = require('ffi')

image = lovr.data.newImage(256, 256)
blob = image:getBlob()
pixels = ffi.cast('uint8_t*', blob:getPointer())

for y = 0, image:getHeight() - 1 do -- hi holo
  for x = 0, image:getWidth() - 1 do
    local i = (y * 256 + x) * 4
    pixels[i + 0] = y / 256 * 255
    pixels[i + 1] = 128
    pixels[i + 2] = x / 256 * 255
    pixels[i + 3] = 255
  end
end

texture = lovr.graphics.newTexture(image)
material = lovr.graphics.newMaterial(texture)

function lovr.draw()
  lovr.graphics.plane(material, 0, 1.5, -3)
end