
--[[
	A quick example of drawing a repeating pattern within a 9slice center region, using
	the draw function's 'hollow' flag and a repeating texture.

	This functionality is not included in the core quadSlice library because the texture
	rebind breaks autobatching. (Not that that's the end of the world or anything, but
	it seems like a reasonable cut-off point.)
--]]


local quadSlice = require("quad_slice")

-- The repeating pattern.
local image_rep = love.graphics.newImage("demo_res/rep_pattern.png")
image_rep:setWrap("repeat", "repeat")
local quad_rep = love.graphics.newQuad(0, 0, 0, 0, image_rep)

-- The 9slice.
local image_slice = love.graphics.newImage("demo_res/rep_9s.png")
local slice = quadSlice.new9Slice(0,0, 32,32, 32,32, 32,32, image_slice:getDimensions())
quadSlice.setQuadMirroring(slice, true, true)
image_slice:setWrap("mirroredrepeat", "mirroredrepeat")

-- Some optional extras.
local image_adornments = love.graphics.newImage("demo_res/adornments.png")
local q_b = love.graphics.newQuad(0, 0, 64, 64, image_adornments)
local q_w = love.graphics.newQuad(0, 64, 64, 64, image_adornments)

-- We need to continuously update the repeating pattern's quad viewport.
local vp_x = 0
local vp_y = 0
local vp_w = 640
local vp_h = 480

-- Width and height of one portion of the frame, along each axis.
local frame_w = slice.w1
local frame_h = slice.h1


function love.keypressed(kc, sc, rep)
	if sc == "escape" then
		love.event.quit()
	end
end


function love.update(dt)

	-- Move the pattern in the direction of the mouse.

	local mx, my = love.mouse.getPosition()
	local w, h = love.graphics.getDimensions()

	vp_x = vp_x + dt*(mx-w/2)/4 -- too fast...
	vp_y = vp_y + dt*(my-h/2)/4
end


function love.draw()

	local window_x = love.graphics.getWidth()/2 - (vp_w + frame_w*2)/2
	local window_y = love.graphics.getHeight()/2 - (vp_h + frame_h*2)/2

	-- Handle the repeating pattern first, then draw the 9slice frame over it.
	quad_rep:setViewport(math.floor(vp_x), math.floor(vp_y), vp_w, vp_h)
	love.graphics.draw(image_rep, quad_rep, window_x + frame_w/2, window_y + frame_h/2)

	quadSlice.draw(image_slice, slice, window_x, window_y, vp_w + frame_w, vp_h + frame_h, true)

	-- Uncomment to add a literal bell and whistle to the 9slice frame.
	--[[
	love.graphics.draw(image_adornments, q_b, window_x - 30, window_y + 36)
	love.graphics.draw(image_adornments, q_w, window_x + vp_w, window_y + 432)
	--]]
end


