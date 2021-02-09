local cp, cl = component.proxy, component.list
local gpu = cp(cl("gpu")())
local eeprom = cp(cl("eeprom")())

local resX, resY = gpu.getResolution()

gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
gpu.fill(1, 1, resX, resY, " ")
gpu.set(1, 1, "Select OS for boot:")
gpu.set(1, 3, "MineOS")
gpu.set(1, 4, "OpenOS")

local selected = 1
local f = "/OS.lua"

local function sel(num)
	selected = num

	if (num == 1) then
		gpu.setBackground(0x000000)
		gpu.setForeground(0xFFFFFF)
		gpu.set(1, 4, "OpenOS")

		gpu.setBackground(0xFFFFFF)
		gpu.setForeground(0x000000)
		gpu.set(1, 3, "MineOS")

		f = "/OS.lua"
	elseif (num == 2) then
		gpu.setBackground(0xFFFFFF)
		gpu.setForeground(0x000000)
		gpu.set(1, 4, "OpenOS")

		gpu.setBackground(0x000000)
		gpu.setForeground(0xFFFFFF)
		gpu.set(1, 3, "MineOS")

		f = "/init.lua"
	end
end

sel(1)


local running = true

while running do
	local e, _, _, c, _ = computer.pullSignal()
	if (e == "key_down") then
		if (c == 200) then
			sel(1)
		elseif (c == 208) then
			sel(2)
		elseif (c == 28) then
			running = false
		end
	end
end


local proxy = cp(eeprom.getData() )

local handle, data, chunk, success, reason = proxy.open(f, "rb"), ""
repeat
	chunk = proxy.read(handle, math.huge)
	data = data .. (chunk or "")
until not chunk

proxy.close(handle)

load(data)()