gaster = require "gaster_blasters"
helper = require "wave_helper"
wavetimer = 8.0
spawntimer = 0
ang = 90
--Encounter.Call("ChangeSoul","Blue")
bullets = {}
blasters = {}

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")


local warn1
local warn2

local bonewall1
local bonewall2
local bonewall3
local bonewall4

local function lerp(a,b,t)
return a + (b - a) * (t*Time.mult)
end



types = {"kr1","krB","krO"}

function bl1()
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
		
	a.firetime = 0.5
	
	table.insert(blasters,a)
end

function soul1()
	Audio.PlaySound("warn")
	warn3 = CreateSprite("px","BelowPlayer")
	warn3.x = Arena.x
	warn3.y = Arena.y + 23 + Arena.height/2
	warn3.xscale = Arena.width
	warn3.color = {1,0,0}
	Audio.PlaySound("ding")
	Encounter.Call("ChangeSoul","Blue")
	Encounter.Call("ChangeGravity","ceiling")
end

function bonew1()
	Audio.PlaySound("pierce",10)
	warn3:Remove()
	bonewall3 = CreateProjectileAbs("Bones/Spam",Arena.x,300)
	bonewall3.sprite.SetParent(mask)
	bonewall3.sprite.SetPivot(0.5,1)
	bonewall3.MoveToAbs(Arena.x,Arena.y+Arena.height + 14)
	bonewall3.sprite.rotation = 180
	bonewall3.ppcollision = true
	bonewall3.SetVar("Type","kr1")
end

function soul2()
	Audio.PlaySound("warn")
		
	warn4 = CreateSprite("px","BelowPlayer")
	warn4.x = Arena.x
	warn4.y = Arena.y - 23 + Arena.height/2
	warn4.xscale = Arena.width
	warn4.color = {1,0,0}
	Audio.PlaySound("ding")
	Encounter.Call("ChangeGravity","upright")
end

function bonew2()
	Audio.PlaySound("pierce",10)
	warn4.Remove()
	bonewall4 = CreateProjectileAbs("Bones/Spam",Arena.x,300)
	bonewall4.sprite.SetParent(mask)
	bonewall4.sprite.SetPivot(0.5,1)
	bonewall4.MoveToAbs(Arena.x,Arena.y - 14)
	bonewall4.sprite.rotation = 0
	bonewall4.ppcollision = true
	bonewall4.SetVar("Type","kr1")
end

function bonel()
	local b1 = CreateProjectile("Bones/Smaller",-Arena.width/2-24,10)
		b1.SetVar("Type","kr1")
		b1.SetVar("yvel",0)
		b1.SetVar("xvel",2)
		local b2 = CreateProjectile("Bones/Smaller",Arena.width/2+24,-15)
		b2.SetVar("Type","kr1")
		b2.SetVar("yvel",0)
		b2.SetVar("xvel",-2)
		
		b1.sprite.SetParent(mask)
		b2.sprite.SetParent(mask)
		table.insert(bullets,b1)
		table.insert(bullets,b2)
end

function soul3()
	Encounter.Call("ChangeSoul","Red")
	bonel()
	helper:AddRepeatEvent(bonel,0.75,2)
end

function bl2()
	local a = gaster:New({-100,500},{320,320},{0.5,1},0,90,false,"kr1")
		
	a.firetime = 4/6
	
	local b = gaster:New({-100,500},{250,320},{0.5,1},0,90,false,"kr1")
	
	b.firetime = 4/6
	
	local c = gaster:New({-100,500},{390,320},{0.5,1},0,90,false,"kr1")
	
	c.firetime = 4/6
	
	
	
	table.insert(blasters,a)
	table.insert(blasters,b)
	table.insert(blasters,c)
end

function blastercircle()
	local rads = math.rad(ang)
	local x = Arena.x + math.cos(rads)*160
	local y = (Arena.y+Arena.height/2) + math.sin(rads)*160
		
		local a = gaster:New({-100,500},{x,y},{0.5,1},ang+270,90,false,"kr1")
		a.sprite.SetPivot(0.5,0.5)
		a.firetime = 0.3666667
		ang = ang - 25
		table.insert(blasters,a)
end

helper:AddEvent(bl1,0.5)
helper:AddEvent(soul1,1.5)
helper:AddEvent(bonew1,2)
helper:AddEvent(soul2,2.5)
helper:AddEvent(bonew2,3)
helper:AddEvent(soul3,3.5)
helper:AddEvent(bl2,6.5)
function Update()
    spawntimer = spawntimer + Time.dt
	helper:Update()
	if spawntimer >= 13.1 then
		EndWave()
	end
	
	
	if spawntimer >= 7.75 and not f then
		helper:AddRepeatEvent(blastercircle,1/6,25)
		f = true
	end
		
	
	if bonewall3 then
		if spawntimer >= 6.5 then
				bonewall3.absy = lerp(bonewall3.absy,Arena.y+Arena.height/2+122,0.1)
			else
			bonewall3.absy = lerp(bonewall3.absy,Arena.y+Arena.height/2 + 26,0.1)
		end
		
	end
	
	if bonewall4 then
	
		if spawntimer >= 6.5 then
			bonewall4.absy = lerp(bonewall4.absy,Arena.y+Arena.height/2-122,0.1)
			else
			bonewall4.absy = lerp(bonewall4.absy,Arena.y+Arena.height/2 - 23,0.1)
		end
	
		
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
mask.Remove()
gaster:WaveEnd()
Encounter.Call("ChangeSoul","Red")
end