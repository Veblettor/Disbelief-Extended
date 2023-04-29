gaster = require "gaster_blasters"
helper = require "wave_helper"
wavetimer = 8.0
spawntimer = 0
ang = 90
Encounter.Call("ChangeSoul","Blue")
Encounter.Call("ChangeGravity","ceiling")
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

function bone1()
	local b1 = CreateProjectile("Bones/tall",-Arena.width/2-4,0)
		b1.SetVar("Type","krB")
		b1.SetVar("yvel",0)
		b1.SetVar("xvel",6)
		local b2 = CreateProjectile("Bones/tall",Arena.width/2+4,0)
		b2.SetVar("Type","krB")
		b2.SetVar("yvel",0)
		b2.SetVar("xvel",-6)
		
		b1.sprite.color = {0,1,1}
		b2.sprite.color = {0,1,1}
		b1.sprite.SetParent(mask)
		b2.sprite.SetParent(mask)
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
	Audio.PlaySound("ding")
end

function wall1()
	Audio.PlaySound("pierce",10)
	warn3:Remove()
	bonewall3 = CreateProjectileAbs("Bones/Spam",Arena.x,300)
	bonewall3.sprite.SetParent(mask)
	bonewall3.sprite.SetPivot(0.5,1)
	bonewall3.MoveToAbs(Arena.x,Arena.y+Arena.height + 14)
	bonewall3.sprite.rotation = 180
	bonewall3.ppcollision = true
	bonewall3.SetVar("Type","kr1")
	
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
	
	a.firetime = 2/3
	
	local b = gaster:New({700,25},{440,200},{1,1},270,0,false,"kr1")
	
	b.firetime = 2/3
	
	local c = gaster:New({-100,500},{200,100},{1,1},90,0,false,"kr1")
	
	c.firetime = 2/3
	
	
	
	table.insert(blasters,a)
	table.insert(blasters,b)
	table.insert(blasters,c)
end

function soulblaster()
	Encounter.Call("ChangeSoul","Red")
		
		
	local a = gaster:New({-100,500},{250,320},{0.5,1},0,90,false,"kr1")

	a.firetime = 0.5
	table.insert(blasters,a)

	

	local c = gaster:New({-100,500},{390,320},{0.5,1},0,90,false,"kr1")
	
	c.firetime = 0.5
	table.insert(blasters,c)
end

function warnf2()
	Audio.PlaySound("warn")
		
	warn4 = CreateSprite("px","BelowPlayer")
	warn4.x = Arena.x
	warn4.y = Arena.y - 23 + Arena.height/2
	warn4.xscale = Arena.width
	warn4.color = {1,0,0}
	Audio.PlaySound("ding")
	Encounter.Call("ChangeSoul","Blue")
	Encounter.Call("ChangeGravity","upright")
end

function wall2()
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

function warnf3()
	Encounter.Call("ChangeGravity","leftwall")
	Audio.PlaySound("ding")
	Audio.PlaySound("warn")
	warn1 = CreateSprite("px","BelowPlayer")
	warn1.x = Arena.x-20
	warn1.y = Arena.y + 5 + Arena.height/2
	warn1.yscale = Arena.height
	warn1.color = {1,0,0}
end

function wall3()
	warn1.Remove()
	Audio.PlaySound("pierce",10)
	bonewall1 = CreateProjectileAbs("Bones/Spam",Arena.x-Arena.width,300)
	bonewall1.sprite.SetParent(mask)
	bonewall1.sprite.SetPivot(0.5,0)
	bonewall1.MoveToAbs(Arena.x-Arena.width/2,Arena.y+Arena.height/2-7)
	bonewall1.sprite.rotation = 90
	bonewall1.ppcollision = true
	bonewall1.SetVar("Type","kr1")
end

function warnf4()
	Encounter.Call("ChangeGravity","rightwall")
		Audio.PlaySound("ding")
		Audio.PlaySound("warn")
		
		warn2 = CreateSprite("px","BelowPlayer")
		warn2.x = Arena.x+20
		warn2.y = Arena.y + 5 + Arena.height/2
		warn2.yscale = Arena.height
		warn2.color = {1,0,0}
end

function wall4()
	warn2.Remove()
	Audio.PlaySound("pierce",10)
	bonewall2 = CreateProjectileAbs("Bones/Spam",Arena.x+Arena.width,300)
	bonewall2.sprite.SetParent(mask)
	bonewall2.sprite.SetPivot(0.5,0)
	bonewall2.MoveToAbs(Arena.x+Arena.width/2,Arena.y+Arena.height/2-7)
	bonewall2.sprite.rotation = 270
	bonewall2.ppcollision = true
	bonewall2.SetVar("Type","kr1")
end

function soulr()
	Encounter.Call("ChangeSoul","Red")
end

function bl1()
	local a = gaster:New({-100,500},{250,200},{1,1},45,90,false,"kr1")
	
	a.firetime = 0.5
	table.insert(blasters,a)

	

	local c = gaster:New({-100,500},{390,200},{1,1},-45,90,false,"kr1")
	
	c.firetime = 0.5
	table.insert(blasters,c)
end

function bl2()
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
	
	a.firetime = 0.75
	table.insert(blasters,a)

	local b = gaster:New({-100,500},{400,200},{1,1},270,90,false,"kr1")

	b.firetime = 0.75
	table.insert(blasters,b)
	

	local c = gaster:New({-100,500},{200,100},{1,1},90,0,false,"kr1")
	
	c.firetime = 0.75
	table.insert(blasters,c)
end

function bl3()
	local a = gaster:New({-100,500},{250,320},{1,1},0,90,false,"kr1")
	
		a.firetime = 0.5
		table.insert(blasters,a)

		local b = gaster:New({-100,500},{390,320},{1,1},0,90,false,"kr1")
	
		b.firetime = 0.5
		table.insert(blasters,b)
end

function bl4()
	local a = gaster:New({-100,500},{320,320},{0.5,1},0,90,false,"kr1")
	
	a.firetime = 0.5
	table.insert(blasters,a)
end

function bl5()
	local a = gaster:New({-100,500},{265,320},{1,1},0,90,false,"kr1")
	
	a.firetime = 0.5
	table.insert(blasters,a)

	local b = gaster:New({-100,500},{400,200},{1,1},270,90,false,"kr1")

	b.firetime = 0.5
	table.insert(blasters,b)
	

	local c = gaster:New({-100,500},{200,100},{1,1},90,0,false,"kr1")
	
	c.firetime = 0.5
	table.insert(blasters,c)
	
	local d = gaster:New({-100,-200},{390,50},{1,1},180,90,false,"kr1")

	d.firetime = 0.5
	table.insert(blasters,d)
end

helper:AddEvent(warnf1,1/3)
helper:AddEvent(bone1,1/3)
helper:AddEvent(bone1,11 + 1/3)

--helper:AddEvent(warnf1,5/6)
helper:AddEvent(wall1,5/6)
helper:AddEvent(soulblaster,1.5)

helper:AddEvent(warnf2,3 + 1/6)
helper:AddEvent(wall2, 3+ 2/3)

helper:AddEvent(warnf3,4.166667)
helper:AddEvent(wall3,4.666667)

helper:AddEvent(warnf4,5.166667)
helper:AddEvent(wall4,5.666667)

helper:AddEvent(soulr,6)
helper:AddEvent(bl1,6)
helper:AddEvent(bl2,7)
helper:AddEvent(bl3,8.166667)
helper:AddEvent(bl4,8.833333)
helper:AddEvent(bl5,10)
function Update()
    
	
	
    spawntimer = spawntimer + Time.dt
	helper:Update()
	if spawntimer >= 12.5 then
		EndWave()
	end
	
	if bonewall1 then
		
		if spawntimer >= 7 then
			bonewall1.absx = lerp(bonewall1.absx,Arena.x-Arena.width/2 ,0.1)
		else
			bonewall1.absx = lerp(bonewall1.absx,Arena.x-Arena.width/2 + 57,0.1)
		end
		
		
	end
	
	if bonewall2 then
	
		if spawntimer >= 7 then
			bonewall2.absx = lerp(bonewall2.absx,Arena.x+Arena.width/2,0.1)
		else
			bonewall2.absx = lerp(bonewall2.absx,Arena.x+Arena.width/2 - 57,0.1)
		end
	
		
	end
	
	if bonewall3 then
		if spawntimer >= 6.166667 then
				bonewall3.absy = lerp(bonewall3.absy,Arena.y+Arena.height/2+122,0.1)
			else
			bonewall3.absy = lerp(bonewall3.absy,Arena.y+Arena.height/2 + 17,0.1)
		end
		
	end
	
	if bonewall4 then
	
		if spawntimer >= 6.166667 then
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