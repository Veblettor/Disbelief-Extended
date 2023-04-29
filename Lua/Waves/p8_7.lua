gaster = require "gaster_blasters"
helper = require "wave_helper"
wavetimer = 8.0
spawntimer = 0

Arena.MoveTo(Misc.WindowWidth/2,Misc.WindowHeight/2-50)

Encounter.Call("ChangeSoul","Green")

bullets = {}
blasters = {}









types = {"kr1","krB","krO"}

local vel = 5.25

local interval = 30

function SpawnBones()
	local rng1 = math.random(1,4)

		local b


		 b = CreateProjectile("Bones/Small",600,0)


			b.SetVar("Type","krB")
			b.sprite.color = {0,1,1}





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

function SpawnBlasters()
	local rng = math.random(1,4)

		local a
		local b
		if rng == 1 then
			a = gaster:NewGreenSoulBlaster({600,Misc.WindowHeight/2-40},{Misc.WindowWidth/2,425},{1,1},"Up",90,false,"Blaster")

			a.firetime = 0.75

			b = gaster:NewGreenSoulBlaster({0,Misc.WindowHeight/2-40},{125,Misc.WindowHeight/2-10},{1,1},"Left",0,false,"BlasterBlue")
			b.sprite.color = {0,1,1}
			b.firetime = 0.75


		elseif rng == 2 then
			a = gaster:NewGreenSoulBlaster({600,-200},{Misc.WindowWidth/2,50},{1,1},"Down",0,false,"Blaster")

			a.firetime = 0.75

			b = gaster:NewGreenSoulBlaster({600,Misc.WindowHeight/2-40},{475,Misc.WindowHeight/2-10},{1,1},"Right",0,false,"BlasterBlue")
			b.sprite.color = {0,1,1}
			b.firetime = 0.75

		elseif rng == 3 then
			a = gaster:NewGreenSoulBlaster({0,Misc.WindowHeight/2-40},{125,Misc.WindowHeight/2-10},{1,1},"Left",0,false,"Blaster")

			a.firetime = 0.75

			b = gaster:NewGreenSoulBlaster({600,Misc.WindowHeight/2-40},{Misc.WindowWidth/2,425},{1,1},"Up",90,false,"BlasterBlue")
			b.sprite.color = {0,1,1}
			b.firetime = 0.75

		else
		a = gaster:NewGreenSoulBlaster({600,Misc.WindowHeight/2-40},{475,Misc.WindowHeight/2-10},{1,1},"Right",0,false,"Blaster")

		a.firetime = 0.75

		b = gaster:NewGreenSoulBlaster({600,-200},{Misc.WindowWidth/2,50},{1,1},"Down",0,false,"BlasterBlue")
		b.sprite.color = {0,1,1}
		b.firetime = 0.75

		end

		table.insert(blasters,a)
		table.insert(blasters,b)
end

function  StartBlasters()
	helper:AddRepeatEvent(SpawnBlasters,1.5,4)
end

helper:AddRepeatEvent(SpawnBones,0.5,18)
helper:AddEvent(StartBlasters,11)
function Update()
    spawntimer = spawntimer + Time.dt
	helper:Update()
	

	for i,v in pairs(blasters) do
		if v.lifetime >= v.firetime then
			v.Fire()
		end
	end

	for i,v in pairs(bullets) do
		if v.isactive then
			v.Move(v.GetVar("XVel")*Time.mult,v.GetVar("YVel")*Time.mult)
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
end