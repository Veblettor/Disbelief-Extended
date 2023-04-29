gaster = require "gaster_blasters"
helper = require "wave_helper"
wavetimer = 8.0
spawntimer = 0
ang = 90
ang2 = 0
Encounter.Call("ChangeSoul","Blue")
Encounter.Call("ChangeGravity","ceiling")
Audio.PlaySound("ding")
Audio.LoadFile("p6_end")
bullets = {}
bullets2 = {}
blasters = {}

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")


local warn1
local warn2
local warn3
local warn4

local bonewall1
local bonewall2
local bonewall3
local bonewall4

local function lerp(a,b,t)
return a + (b - a) * (t*Time.mult)
end



types = {"kr1","krB","krO"}

function bl1()
	local a = gaster:New({-100,500},{Player.absx,320},{0.5,1},0,90,false,"kr1")
		
	a.firetime = 2/3
	table.insert(blasters,a)
end

function bones1()
	local b1 = CreateProjectile("Bones/top",Arena.width/2+5,Arena.height/2+15)
		b1.sprite.SetParent(mask)
		b1.SetVar("xvel",-3)
		b1.SetVar("yvel",0)
		b1.SetVar("Type","kr1")
		
		local b2 = CreateProjectile("Bones/top",-Arena.width/2-5,Arena.height/2+15)
		b2.sprite.SetParent(mask)
		b2.SetVar("xvel",3)
		b2.SetVar("yvel",0)
		b2.SetVar("Type","kr1")
		
		table.insert(bullets,b1)
		table.insert(bullets,b2)
end

function warnf1()
	Audio.PlaySound("warn")
	warn3 = CreateSprite("px","BelowPlayer")
	warn3.x = Arena.x
	warn3.y = Arena.y + 23 + Arena.height/2
	warn3.xscale = Arena.width
	warn3.color = {1,0,0}
	warn4 = CreateSprite("px","BelowPlayer")
	warn4.x = Arena.x
	warn4.y = Arena.y - 23 + Arena.height/2
	warn4.xscale = Arena.width
	warn4.color = {1,0,0}
end

function soul()
	Encounter.Call("ChangeSoul","Red")
	Audio.PlaySound("ding")
end

function wall1()
	Audio.PlaySound("pierce",10)
		warn3:Remove()
		warn4:Remove()
		bonewall3 = CreateProjectileAbs("Bones/Spam",Arena.x,300)
		bonewall3.sprite.SetParent(mask)
		bonewall3.sprite.SetPivot(0.5,1)
		bonewall3.MoveToAbs(Arena.x,Arena.y+Arena.height + 14)
		bonewall3.sprite.rotation = 180
		bonewall3.ppcollision = true
		bonewall3.SetVar("Type","kr1")
		bonewall4 = CreateProjectileAbs("Bones/Spam",Arena.x,300)
		bonewall4.sprite.SetParent(mask)
		bonewall4.sprite.SetPivot(0.5,1)
		bonewall4.MoveToAbs(Arena.x,Arena.y - 14)
		bonewall4.sprite.rotation = 0
		bonewall4.ppcollision = true
		bonewall4.SetVar("Type","kr1")
end

function bonedodge()
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

function bonedodgestart()
	bonedodge()
	helper:AddRepeatEvent(bonedodge,0.75,2)
end

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

function targetstart()
	targetblaster()
	helper:AddRepeatEvent(targetblaster,0.75,3)
end

function circleblaster()
	local rads = math.rad(ang)
	
	local x = Arena.x + math.cos(rads)*160
	local y = (Arena.y+Arena.height/2) + math.sin(rads)*160
	
	
	
	local a = gaster:New({-100,500},{x,y},{0.5,1},ang+270,90,false,"kr1")
	a.sprite.SetPivot(0.5,0.5)
	a.firetime = 0.3666667
	ang = ang - 25
	table.insert(blasters,a)
end

function circlestart()
	helper:AddRepeatEvent(circleblaster,1/6,64)
end

function tired()
	Encounter.Call("phase6tired")
end

helper:AddRepeatEvent(bl1,1.5,3)
helper:AddRepeatEvent(bones1,0.75,6)

helper:AddEvent(warnf1,5.5)
helper:AddEvent(soul,5+2/3)
helper:AddEvent(wall1,6)
helper:AddEvent(bonedodgestart,6.333333)
helper:AddEvent(targetstart,10.25)
helper:AddEvent(circlestart,13.25)
helper:AddEvent(tired,24)
function Update()
    
	
	
    spawntimer = spawntimer + Time.dt
	helper:Update()
	if spawntimer == 9999 then
		EndWave()
	end
	
	
	
	
	
	
	
	if spawntimer > 380 and spawntimer % 45 == 0 and spawntimer < 510 then
		
	end
	
	
	
		if spawntimer % 45 == 0 and spawntimer > 615 and spawntimer < 795 then

	end
	
	
	if spawntimer >= 795 and spawntimer % 10 == 0 and spawntimer < 1440 then
		
		
		
		
	end

		
	if bonewall1 then
		
		if spawntimer >= 6.666667 then
			bonewall1.absx = lerp(bonewall1.absx,Arena.x-Arena.width/2 ,0.1)
		else
			bonewall1.absx = lerp(bonewall1.absx,Arena.x-Arena.width/2 + 57,0.1)
		end
		
		
	end
	
	if bonewall2 then
	
		if spawntimer >= 6.666667 then
			bonewall2.absx = lerp(bonewall2.absx,Arena.x+Arena.width/2,0.1)
		else
			bonewall2.absx = lerp(bonewall2.absx,Arena.x+Arena.width/2 - 57,0.1)
		end
	
		
	end
	
	if bonewall3 then
		if spawntimer >= 10 then
				bonewall3.absy = lerp(bonewall3.absy,Arena.y+Arena.height/2+122,0.1)
			else
			bonewall3.absy = lerp(bonewall3.absy,Arena.y+Arena.height/2 + 26,0.1)
		end
		
	end
	
	if bonewall4 then
	
		if spawntimer >= 10 then
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