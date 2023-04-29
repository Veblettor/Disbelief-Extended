gaster = require "gaster_blasters"
helper = require "wave_helper"
wavetimer = 8.0
spawntimer = 0

Arena.MoveTo(Misc.WindowWidth/2,Misc.WindowHeight/2-50)

Encounter.Call("ChangeSoul","Green")

bullets = {}
blasters = {}




types = {"kr1","krB","krO"}

local interval = 90
local ftime = 0.75
local waiting = false

function SpawnBlasters()
	local rng = math.random(1,4)
		waiting = true
		for i = 1,4 do
			local a
			local coords = {}
			local coords_start = {}
			local side = ""
			local Type = "BlasterBlue"

			if i == rng then Type = "Blaster" end



			if i == 1 then
				coords_start = {600,Misc.WindowHeight/2-40}
				coords = {Misc.WindowWidth/2,425}
				side = "Up"

				elseif i == 2 then
				coords_start = {600,-200}
				coords = {Misc.WindowWidth/2,50}
				side = "Down"
				elseif i == 3 then
				coords_start = {0,Misc.WindowHeight/2-40}
				coords = {125,Misc.WindowHeight/2-10}
				side = "Left"

				else
				coords_start = {600,Misc.WindowHeight/2-40}
				coords = {475,Misc.WindowHeight/2-10}
				side = "Right"

			end
			a = gaster:NewGreenSoulBlaster(coords_start,coords,{1,1},side,90,false,Type)
			if Type == "BlasterBlue" then a.sprite.color = {0,1,1} end
			a.firetime = ftime
			table.insert(blasters,a)
		end
end

function Acc1()
	interval = 1 + 1/3
	ftime = 2/3
	helper:AddRepeatEvent(SpawnBlasters,0.7,1)
end

function Acc2()
	interval = 1 + 1/6
	ftime = 0.5833333
	SpawnBlasters()
	helper:AddRepeatEvent(SpawnBlasters,1 + 1/6,3)
end

function Acc3()
	interval = 1
	ftime = 0.5
	--SpawnBlasters()
	helper:AddRepeatEvent(SpawnBlasters,1,6)
end

helper:AddRepeatEvent(SpawnBlasters,1.5,3)
helper:AddEvent(Acc1,5)
helper:AddEvent(Acc2,7.5)
helper:AddEvent(Acc3,11 + 2/3)
function Update()
    spawntimer = spawntimer + Time.dt
	helper:Update()

	

	for i,v in pairs(blasters) do
			if v.lifetime >= v.firetime then
			v.Fire()
			end

		end


	

	if spawntimer >= 20.33333 then
		EndWave()
	end

	gaster:Update()
end

function OnHit(bullet)
Encounter.Call("HandleHit",bullet)
end

function EndingWave()
gaster:WaveEnd()
Encounter.Call("ChangeSoul","Red")
end