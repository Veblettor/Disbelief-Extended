gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0

Arena.MoveTo(Misc.WindowWidth/2,Misc.WindowHeight/2-50)

Encounter.Call("ChangeSoul","Green")

bullets = {}
blasters = {}



types = {"kr1","krB","krO"}

local vel = 7.5




function SpawnBones()
	local rng1 = math.random(1,4)

		local b


		 b = CreateProjectile("Bones/Small",600,0)

			if spawntimer > 500 then
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

function Dec1()
	helper:AddRepeatEvent(SpawnBones,0.4166667,7)
	vel = 6.5
end

function Dec2()
	helper:AddRepeatEvent(SpawnBones,0.5,2)
	vel = 5.5
end

function Dec3()
	helper:AddRepeatEvent(SpawnBones,0.75,1)
	vel = 5
end

function SpawnBones2()
	local rng1 = math.random(1,4)

	local b


	 b = CreateProjectile("Bones/Small",600,0)

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

function SpawnBlueBone()
	local rng1 = math.random(1,2)

		local b




		 b = CreateProjectile("Bones/Small",600,0)

		b.SetVar("Type","krB")
		b.sprite.color = {0,1,1}
		if rng1 == 1 then

			if spawntimer < 1060 then

			b.x = 0
			b.y = 600
			b.SetVar("XVel",0)
			b.SetVar("YVel",-vel)
			b.SetVar("YOffset",-15)
			else
				b.x = -600
		b.SetVar("XVel",vel)
		b.SetVar("YVel",0)
		b.SetVar("XOffset",15)

		b.sprite.rotation = 90
			end
		elseif rng1 == 2 then
			if spawntimer < 1060 then

			b.x = 0
			b.y = -600
			b.SetVar("XVel",0)
			b.SetVar("YVel",vel)
			b.SetVar("YOffset",15)--]]
			else
				b.SetVar("XVel",-vel)
		b.SetVar("YVel",0)
		b.SetVar("XOffset",-15)

		b.sprite.rotation = 90
			end
		elseif rng1 == 3 then

		else



		end
		table.insert(Encounter["greensoul_bullets"],b)
		table.insert(bullets,b)
		helper:AddRepeatEvent(SpawnBones2,0.4166667,2)
end

function SpawnBlaster()
	local rng = math.random(1,4)
	local a
	if rng == 1 then
		a = gaster:NewGreenSoulBlaster({600,Misc.WindowHeight/2-40},{Misc.WindowWidth/2,425},{1,1},"Up",90,false,"Blaster")

		a.firetime = 0.75

	elseif rng == 2 then
		a = gaster:NewGreenSoulBlaster({600,-200},{Misc.WindowWidth/2,50},{1,1},"Down",0,false,"Blaster")

		a.firetime = 0.75

	elseif rng == 3 then
		a = gaster:NewGreenSoulBlaster({0,Misc.WindowHeight/2-40},{125,Misc.WindowHeight/2-10},{1,1},"Left",0,false,"Blaster")

		a.firetime = 0.75
	else
		a = gaster:NewGreenSoulBlaster({600,Misc.WindowHeight/2-40},{475,Misc.WindowHeight/2-10},{1,1},"Right",0,false,"Blaster")

		a.firetime = 0.75
	end

	
	vel = 6

	if spawntimer < 20 then
		helper:AddRepeatEvent(SpawnBones2,0.4166667,2)
		helper:AddRepeatEvent(SpawnBlueBone,1.25,5)
	end

	table.insert(blasters,a)
end

helper:AddEvent(SpawnBlaster,11.5)
helper:AddEvent(SpawnBlaster,21.33333)
helper:AddRepeatEvent(SpawnBones,1/3,12)
helper:AddEvent(Dec1,4)
helper:AddEvent(Dec2,7)
helper:AddEvent(Dec3,8.333333)
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

	if spawntimer >= 23.33333 then
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