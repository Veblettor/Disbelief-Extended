gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0

Arena.MoveTo(Misc.WindowWidth/2,Misc.WindowHeight/2-50)

Encounter.Call("ChangeSoul","Green")

bullets = {}
blasters = {}






local function lerp(a,b,t)
return a + (b - a) * t
end



types = {"kr1","krB","krO"}

local vel = 4

function SpawnBlaster()
	local a = gaster:NewGreenSoulBlaster({600,Misc.WindowHeight/2-40},{475,Misc.WindowHeight/2-10},{1,1},"Right",0,false,"Blaster")

	a.firetime = 1

	table.insert(blasters,a)
end

function SpawnSlowBone()
	b = CreateProjectile("Bones/Small",-400,0)
	b.SetVar("XVel",0.51)
	b.SetVar("YVel",0)
	b.SetVar("XOffset",15)
	b.SetVar("Type","kr1")
	b.sprite.rotation = 90

	table.insert(Encounter["greensoul_bullets"],b)
	table.insert(bullets,b)
end

function SpawnBone()
	local rng1 = math.random(1,4)
	local rng2 = math.random(1,2)
	local b


	 b = CreateProjectile("Bones/Small",600,0)

	if rng2 == 2 then
		b.SetVar("Type","krB")
		b.sprite.color = {0,1,1}
	end




	if rng1 == 1 then
		b.x = 0
		b.y = 600
		b.SetVar("XVel",0)
		b.SetVar("YVel",-vel)
		b.SetVar("YOffset",-15)
	elseif rng1 == 2 then
		b.x = 0
		b.y = -600
		b.SetVar("XVel",0)
		b.SetVar("YVel",vel)
		b.SetVar("YOffset",15)--]]
	elseif rng1 == 3 then
		b.x = -600
		b.SetVar("XVel",vel)
		b.SetVar("YVel",0)
		b.SetVar("XOffset",15)

		b.sprite.rotation = 90
	else


		b.SetVar("XVel",-vel)
		b.SetVar("YVel",0)
		b.SetVar("XOffset",-15)

		b.sprite.rotation = 90
	end


	table.insert(Encounter["greensoul_bullets"],b)
	table.insert(bullets,b)
end

helper:AddEvent(SpawnSlowBone,1/3)
helper:AddEvent(SpawnBlaster,9.416667)
helper:AddRepeatEvent(SpawnBone,0.5833333,13)
function Update()



    spawntimer = spawntimer + Time.dt
	helper:Update()


	for i,v in pairs(bullets) do

		if v.isactive then

		v.Move(v.GetVar("XVel")*Time.mult,v.GetVar("YVel")*Time.mult)

		end
	end

	for i,v in pairs(blasters) do
			if v.lifetime >= v.firetime then
			v.Fire()
			end
		end

	if spawntimer >= 13.33333 then
		EndWave()
	end

	gaster:Update()
end

function OnHit(bullet)
Encounter.Call("HandleHit",bullet)
end

function EndingWave()
gaster:WaveEnd()
end