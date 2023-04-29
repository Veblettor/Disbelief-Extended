gaster = require "gaster_blasters"
helper = require "wave_helper"
wavetimer = 8.0
spawntimer = 0
ang = 90
bullets = {}
blasters = {}
Arena.Resize(380,130)
local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")


local b1 = CreateProjectile("Bones/tall",-Arena.width/2-4,0)
		b1.SetVar("Type","krB")
		b1.SetVar("yvel",0)
		b1.SetVar("xvel",5)
		local b2 = CreateProjectile("Bones/tall",Arena.width/2+4,0)
		b2.SetVar("Type","krB")
		b2.SetVar("yvel",0)
		b2.SetVar("xvel",-5)
		
		b1.sprite.color = {0,1,1}
		b2.sprite.color = {0,1,1}
		b1.sprite.SetParent(mask)
		b2.sprite.SetParent(mask)
		table.insert(bullets,b1)
		table.insert(bullets,b2)





types = {"kr1","krB","krO"}

function targetblaster()
	local x = math.random(Arena.x - Arena.width/2,Arena.x + Arena.width/2)
	local diffx = Player.absx - x
	local diffy = Player.absy - 320
	
	local atan = math.atan(diffy/diffx)
	
	local function sign(num)
	if num > 0 then
	return 1
	elseif num == 0 then
	return 0
	else
	return -1
	end
	end
	
	
	local a = gaster:New({-100,500},{x,320},{0.5,1},math.deg(atan)+(90*sign(diffx)),0,false,"kr1")
	a.sprite.SetPivot(0.5,0.5)
	
	a.firetime = 2/3
	
	
	table.insert(blasters,a)
end

helper:AddRepeatEvent(targetblaster,1.5,0)
function Update()
    
	
	
    spawntimer = spawntimer + Time.dt
	helper:Update()
	if spawntimer >= 13.16667 then
		EndWave()
	end


	
	
	
	
		for i,v in pairs(blasters) do
			if v.lifetime >= v.firetime then
			v.Fire()
			end
		end
	
	
	for i,bullet in pairs(bullets) do
		bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
		
		if bullet.absx >= Arena.x +Arena.width/2 + 4 then
		bullet.SetVar("xvel",-5)
		if bullet.GetVar("Type") == "krB" then
		bullet.SetVar("Type","krO")
		bullet.sprite.color = {1,0.5,0}
		else
		bullet.SetVar("Type","krB")
		bullet.sprite.color = {0,1,1}
		end
		elseif bullet.absx <= Arena.x - Arena.width/2 - 4 then
		bullet.SetVar("xvel",5)
		if bullet.GetVar("Type") == "krB" then
		bullet.SetVar("Type","krO")
		bullet.sprite.color = {1,0.5,0}
		else
		bullet.SetVar("Type","krB")
		bullet.sprite.color = {0,1,1}
		end
		end
	end
	
	gaster:Update()
end

function OnHit(bullet)
Encounter.Call("HandleHit",bullet)
end

function EndingWave()
mask.Remove()
gaster:WaveEnd()
Encounter.Call("ChangeSoul","Red")
end