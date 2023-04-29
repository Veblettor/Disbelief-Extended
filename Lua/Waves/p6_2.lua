gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0

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
	local a = gaster:New({-100,500},{250,320},{0.5,1},0,90,false,"kr1")
	
	a.firetime = 0.5
	table.insert(blasters,a)
end

function bl2()
	local b = gaster:New({-100,500},{320,320},{0.5,1},0,90,false,"kr1")
		
	b.firetime = 0.5
	table.insert(blasters,b)
end

function bl3()
	local c = gaster:New({-100,500},{390,320},{0.5,1},0,90,false,"kr1")
		
	c.firetime = 0.5
	table.insert(blasters,c)
end

function bl4()
	local a = gaster:New({-100,500},{200,Arena.y+Arena.height},{0.5,1},90,0,false,"kr1")
	
		a.firetime = 0.5
		table.insert(blasters,a)
end

function bl5()
	local a = gaster:New({-100,500},{200,Arena.y+Arena.height/2},{0.5,1},90,0,false,"kr1")
	
		a.firetime = 0.5
		table.insert(blasters,a)
end

function bl6()
	local a = gaster:New({-100,500},{200,Arena.y+5},{0.5,1},90,0,false,"kr1")
	
	a.firetime = 0.5
	table.insert(blasters,a)
end

function warnf1()
	Audio.PlaySound("warn")
		warn1 = CreateSprite("px","BelowPlayer")
		warn1.x = Arena.x-20
		warn1.y = Arena.y + 5 + Arena.height/2
		warn1.yscale = Arena.height
		warn1.color = {1,0,0}
		
		
		warn2 = CreateSprite("px","BelowPlayer")
		warn2.x = Arena.x+20
		warn2.y = Arena.y + 5 + Arena.height/2
		warn2.yscale = Arena.height
		warn2.color = {1,0,0}
end

function walls1()
	Audio.PlaySound("pierce",10)
	warn1.Remove()
	warn2.Remove()
	bonewall1 = CreateProjectileAbs("Bones/Spam",Arena.x-Arena.width,300)
	bonewall1.sprite.SetParent(mask)
	bonewall1.sprite.SetPivot(0.5,0)
	bonewall1.MoveToAbs(Arena.x-Arena.width/2,Arena.y+Arena.height/2-7)
	bonewall1.sprite.rotation = 90
	bonewall1.ppcollision = true
	bonewall1.SetVar("Type","kr1")
	bonewall2 = CreateProjectileAbs("Bones/Spam",Arena.x+Arena.width,300)
	bonewall2.sprite.SetParent(mask)
	bonewall2.sprite.SetPivot(0.5,0)
	bonewall2.MoveToAbs(Arena.x+Arena.width/2,Arena.y+Arena.height/2-7)
	bonewall2.sprite.rotation = 270
	bonewall2.ppcollision = true
	bonewall2.SetVar("Type","kr1")
end

function colorbones1()
	local rand = math.random(1,2)
	local b1 = CreateProjectileAbs("Bones/Small",Arena.x,Arena.y+Arena.height+5)
	b1.sprite.SetParent(mask)
	b1.sprite.rotation = 90
	b1.sprite.SetPivot(0.5,0.5)
	b1.SetVar("xvel",0)
	b1.SetVar("yvel",-3)
	b1.ppcollision = true
	if rand == 1 then
	b1.SetVar("Type","krB")
	b1.sprite.color = {0,1,1}
	else
	b1.SetVar("Type","krO")
	b1.sprite.color = {1,0.5,0}
	end
	
	
	table.insert(bullets,b1)
end

function colorbones2()
	local rand = math.random(1,2)
	local b1 = CreateProjectileAbs("Bones/Small",Arena.x+Arena.width+6,Arena.y+Arena.height/2)
	b1.sprite.SetParent(mask)
	b1.sprite.SetPivot(0.5,0.5)
	b1.SetVar("xvel",-3)
	b1.SetVar("yvel",0)
	b1.ppcollision = true
	if rand == 1 then
	b1.SetVar("Type","krB")
	b1.sprite.color = {0,1,1}
	else
	b1.SetVar("Type","krO")
	b1.sprite.color = {1,0.5,0}
	end
	
	
	table.insert(bullets,b1)
end

function warnf2()
	Audio.PlaySound("warn")
	warn3 = CreateSprite("px","BelowPlayer")
	warn3.x = Arena.x
	warn3.y = Arena.y + 15 + Arena.height/2
	warn3.xscale = Arena.width
	warn3.color = {1,0,0}
	warn4 = CreateSprite("px","BelowPlayer")
	warn4.x = Arena.x
	warn4.y = Arena.y - 15 + Arena.height/2
	warn4.xscale = Arena.width
	warn4.color = {1,0,0}
end

function walls2()
	Audio.PlaySound("pierce",10)
	warn3.Remove()
	warn4.Remove()
	bonewall3 = CreateProjectileAbs("Bones/Spam",Arena.x,300)
	bonewall3.sprite.SetParent(mask)
	bonewall3.sprite.SetPivot(0.5,1)
	bonewall3.MoveToAbs(Arena.x,Arena.y+Arena.height + 7)
	bonewall3.sprite.rotation = 180
	bonewall3.ppcollision = true
	bonewall3.SetVar("Type","kr1")
	bonewall4 = CreateProjectileAbs("Bones/Spam",Arena.x,300)
	bonewall4.sprite.SetParent(mask)
	bonewall4.sprite.SetPivot(0.5,1)
	bonewall4.MoveToAbs(Arena.x,Arena.y - 7)
	bonewall4.sprite.rotation = 0
	bonewall4.ppcollision = true
	bonewall4.SetVar("Type","kr1")
end

function bl7()
	local a = gaster:New({-100,500},{250,320},{1,1},0,90,false,"kr1")
	
	a.firetime = 0.5
	table.insert(blasters,a)
	local c = gaster:New({-100,500},{390,320},{0.5,1},0,90,false,"kr1")
	
	c.firetime = 0.5
	table.insert(blasters,c)
end

function bl8()
	local a = gaster:New({-100,500},{320,320},{0.5,1},0,90,false,"kr1")
	
		a.firetime = 2/3
		table.insert(blasters,a)
end

helper:AddEvent(bl1,1/6)
helper:AddEvent(bl2,1/3)
helper:AddEvent(bl3,0.5)
helper:AddEvent(bl4,1 + 1/3)
helper:AddEvent(bl5,1.5)
helper:AddEvent(bl6,1 + 2/3)

helper:AddEvent(warnf1,2 + 1/6)
helper:AddEvent(walls1,2 + 4/6)

helper:AddEvent(warnf2,7.5)
helper:AddEvent(walls2,8)

helper:AddEvent(bl7,13.5)
helper:AddEvent(bl8,13.5 + 1/6)
function Update()
    
	
	
    spawntimer = spawntimer + Time.dt
	helper:Update()
	if spawntimer >= 15.16667 then
		EndWave()
	end
	
	
	
	if spawntimer >= (3 + 1/6) and not f1 then
		f1 = true
		colorbones1()
		helper:AddRepeatEvent(colorbones1,0.5,8)
		
	end
	
	if spawntimer >= 8.5 and not f2 then
		f2 = true
		colorbones2()
		helper:AddRepeatEvent(colorbones2,0.5,9)
	end
	
	if spawntimer == 450 then
		
	end
	
	if spawntimer == 480 then
		
	end
	
	
	if spawntimer == 810 then
		
	elseif spawntimer == 820 then
	
	end
	
	
	
	if bonewall1 then
		
		if spawntimer >= 8 then
			bonewall1.absx = lerp(bonewall1.absx,Arena.x-Arena.width/2 ,0.1)
		else
			bonewall1.absx = lerp(bonewall1.absx,Arena.x-Arena.width/2 + 57,0.1)
		end
		
		
	end
	
	if bonewall2 then
	
		if spawntimer >= 8 then
			bonewall2.absx = lerp(bonewall2.absx,Arena.x+Arena.width/2,0.1)
		else
			bonewall2.absx = lerp(bonewall2.absx,Arena.x+Arena.width/2 - 57,0.1)
		end
	
		
	end
	
	if bonewall3 then
		if spawntimer >= 14.66667 then
				bonewall3.absy = lerp(bonewall3.absy,Arena.y+Arena.height/2+122,0.1)
			else
			bonewall3.absy = lerp(bonewall3.absy,Arena.y+Arena.height/2 + 17,0.1)
		end
	end
	
	if bonewall4 then
		
		if spawntimer >= 14.66667 then
			bonewall4.absy = lerp(bonewall4.absy,Arena.y+Arena.height/2-122,0.1)
			else
			bonewall4.absy = lerp(bonewall4.absy,Arena.y+Arena.height/2 - 17,0.1)
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