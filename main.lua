local ltask = require "ltask"
local spritemgr = require "soluna.spritemgr"

local batch = ...

local loader = ltask.uniqueservice "loader"
local sprites = ltask.call(loader, "loadbundle", "asset/cards.dl")
local render = ltask.uniqueservice "render"
ltask.call(render, "load_sprites", "asset/cards.dl")

local callback = {}
local focus
local s = {}
for i = 1, #sprites.card do
	s[i] = { id = sprites.card[i], x = 60 * i - 30, y = 400, w = 200, h = 280 , pos = 0 }
end

local function hover(x, y)
	for i = #s, 1, -1 do
		local spr = s[i]
		if x >= spr.x and x < spr.x + spr.w and y >= spr.y and y < spr.y + spr.h then
			return i
		end
	end
end

local speed <const> = 20

function callback.frame(count)
	for i = 1, #sprites.card do
		local spr = s[i]
		local pos = spr.pos
		if i == focus then
			if pos < speed then
				pos = pos + 1
				spr.pos = pos
			end
		elseif pos > 0 then
			pos = pos - 1
			spr.pos = pos
		end
		local dy = math.sin (pos / speed * math.pi / 2) * 30
		batch:add(spr.id, spr.x, spr.y - dy)
	end
end

function callback.mouse_move(x, y)
	focus = hover(x, y)
end

return callback
