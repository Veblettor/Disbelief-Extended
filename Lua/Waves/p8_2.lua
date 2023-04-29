
helper = require "wave_helper"
wavetimer = 8.0
spawntimer = 0



Encounter.Call("ChangeSoul","Green")


bullets = {}
blasters = {}

types = {"kr1","krB","krO"}

local vel = 6
local vel2 = 6


function spawnbone()
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

function spawnblue()

	if spawntimer >= 9 then
		helper:AddRepeatEvent(spawnbone,0.5,1)
	else
		helper:AddRepeatEvent(spawnbone,0.5,2)
	end
	

	local rng1 = math.random(1,2)
		
		local b
		
		
		
		
		 b = CreateProjectile("Bones/Small",600,0)
		
		b.SetVar("Type","krB")
		b.sprite.color = {0,1,1}
		if rng1 == 1 then
		
			if spawntimer < 5 then
		
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
			if spawntimer < 5 then
		
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
		
		
		
		end
		
	
		table.insert(Encounter["greensoul_bullets"],b)
		table.insert(bullets,b)
end

helper:AddRepeatEvent(spawnbone,0.5,2)
helper:AddRepeatEvent(spawnblue,1.5,6)
function Update()
    spawntimer = spawntimer + Time.dt
	helper:Update()

	
	
	for i,v in pairs(bullets) do
	
		if v.isactive then
	
		v.Move(v.GetVar("XVel")*Time.mult,v.GetVar("YVel")*Time.mult)
		
		end
	end
	
	
	
	if spawntimer >= 13.33333 then
		EndWave()
	end
	
	
end

function OnHit(bullet)
Encounter.Call("HandleHit",bullet)
end

function EndingWave()

end