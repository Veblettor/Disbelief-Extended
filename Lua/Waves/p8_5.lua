gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0
Arena.Resize(48,72)
Encounter.Call("ChangeSoul","Red")

bullets = {}
blasters = {}

function SpawnBlasters()
		local a
		local b
		
		local r =  math.random(1,2)
		
		if r == 1 then
			a = gaster:New({-100,500},{310,320},{0.5,1},0,270,false,"kr1")
			b = gaster:New({740,500},{335,320},{0.5,1},0,90,false,"krB")
			b.sprite.color = {0,1,1}
		else
			a = gaster:New({-100,500},{310,320},{0.5,1},0,270,false,"krB")
			b = gaster:New({740,500},{335,320},{0.5,1},0,90,false,"kr1")
			a.sprite.color = {0,1,1}
		end
		
		
		a.firetime = 2/3
		b.firetime = 2/3
		
		table.insert(blasters,a)
		table.insert(blasters,b)
end

function SpawnBones()
	local rng = math.random(1,3)
	
	local b = CreateProjectile("Bones/Small",600,600)
	
	if rng == 1 then
		b.x = -200
		b.y =  math.random(-Arena.height/2,Arena.height/2)
		b.SetVar("xvel",5)
		b.SetVar("yvel",0)
		b.sprite.rotation = 90
	elseif rng == 2 then
		b.x = 600
		b.y =  math.random(-Arena.height/2,Arena.height/2)
		b.SetVar("xvel",-5)
		b.SetVar("yvel",0)
		b.sprite.rotation = 90
	else
		b.x = math.random(-Arena.width/2,Arena.width/2)
		b.y =  600
		b.SetVar("xvel",0)
		b.SetVar("yvel",-5)
	end
	b.ppcollision = true
	b.SetVar("Type","kr1")
	table.insert(bullets,b)
end

helper:AddEvent(SpawnBlasters,10)
helper:AddRepeatEvent(SpawnBones,0.5833333,14)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()




if spawntimer >= 12.5 then
EndWave()
end



for i,v in pairs(blasters) do
	if v.lifetime >= v.firetime then
		v.Fire()
	end
end

for i,bullet in pairs(bullets) do
	bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
end

gaster:Update()	
end


function OnHit(bullet)
Encounter.Call("HandleHit",bullet)
end

function EndingWave()
gaster:WaveEnd()

end