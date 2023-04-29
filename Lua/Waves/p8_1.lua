
helper = require "wave_helper"
wavetimer = 8.0
spawntimer = 0
local vel = 7.5



bullets = {}
blasters = {}




Encounter.Call("ChangeSoul","Green")




function spawnbone()
	local rng1 = math.random(1,4)
		
	local b
	
	
	 b = CreateProjectile("Bones/Small",600,0)
	
		if spawntimer > 8.333333 then
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

types = {"kr1","krB","krO"}




function slowdown1()
	helper:AddRepeatEvent(spawnbone,0.4166667,7)
	vel = 6.5
end

function slowdown2()
	
	helper:AddRepeatEvent(spawnbone,0.5,2)
	vel = 5.5
end

function slowdown3()
	helper:AddRepeatEvent(spawnbone,0.75,1)
	vel = 5
end	

helper:AddRepeatEvent(spawnbone,1/3,12)
helper:AddEvent(slowdown1,4)
helper:AddEvent(slowdown2,7)
helper:AddEvent(slowdown3,8.333333)
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