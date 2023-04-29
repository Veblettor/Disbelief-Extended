gaster = require "gaster_blasters"
wavetimer = 8.0
spawntimer = 0
Encounter.Call("ChangeSoul","Blue")
Audio.PlaySound("ding")
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

local seq = 0

local function lerp(a,b,t)
return a + (b - a) * t
end



types = {"kr1","krB","krO"}

function Update()
    
	
    spawntimer = spawntimer + Time.dt
	
	if spawntimer >= 8.166667 then
		EndWave()
	end
	
	if spawntimer >= 0.75 and seq == 0 then
		seq = seq + 1
		local a = gaster:New({-100,500},{100,320},{0.5,1},45,90,false,"kr1")
		local b = gaster:New({740,500},{540,320},{0.5,1},-45,90,false,"kr1")
		a.firetime = 0.5
		b.firetime = 0.5
		table.insert(blasters,a)
		table.insert(blasters,b)
	end
	
	if spawntimer >= 1.416667 and seq == 1 then
		seq = seq + 1
		local c = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
		c.firetime = 0.4166667
		table.insert(blasters,c)
	end
	
	
	if spawntimer >= 1.916667 and seq == 2 then
		seq = seq + 1
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
	
	if spawntimer >= 2.666667 and seq == 3 then
		seq = seq + 1
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
	
	if spawntimer >= 3.166667 and seq == 4 then
		seq = seq + 1
		local b1 = CreateProjectileAbs("Bones/top",Arena.x-Arena.width,Arena.y+Arena.height+5)
		b1.sprite.SetParent(mask)
		b1.sprite.SetPivot(0.5,1)
		b1.SetVar("xvel",3)
		b1.SetVar("yvel",0)
		b1.SetVar("Type","kr1")
		
		local b2 = CreateProjectileAbs("Bones/bottom",Arena.x-Arena.width,Arena.y+5)
		b2.sprite.SetPivot(0.5,0)
		b2.sprite.SetParent(mask)
		b2.SetVar("xvel",3)
		b2.SetVar("yvel",0)
		b2.SetVar("Type","kr1")
		
		
		local b3 = CreateProjectileAbs("Bones/top",Arena.x+Arena.width,Arena.y+Arena.height+5)
		b3.sprite.SetParent(mask)
		b3.sprite.SetPivot(0.5,1)
		b3.SetVar("xvel",-3)
		b3.SetVar("yvel",0)
		b3.SetVar("Type","kr1")
		
		local b4 = CreateProjectileAbs("Bones/bottom",Arena.x+Arena.width,Arena.y+5)
		b4.sprite.SetParent(mask)
		b4.sprite.SetPivot(0.5,0)
		b4.SetVar("xvel",-3)
		b4.SetVar("yvel",0)
		b4.SetVar("Type","kr1")
		
		
		
		table.insert(bullets,b1)
		table.insert(bullets,b2)
		table.insert(bullets,b3)
		table.insert(bullets,b4)
	end
	
	if spawntimer >= 4.333333 and seq == 5 then
		seq = seq + 1
		Audio.PlaySound("ding")
		Encounter.Call("ChangeGravity","ceiling")
	end
	
	if spawntimer >= 4.666667 and seq == 6 then
		seq = seq + 1
		Audio.PlaySound("warn")
		warn3 = CreateSprite("px","BelowPlayer")
		warn3.x = Arena.x
		warn3.y = Arena.y + 15 + Arena.height/2
		warn3.xscale = Arena.width
		warn3.color = {1,0,0}
	end
	
	if spawntimer >= 5.166667 and seq == 7 then
		seq = seq + 1
		Audio.PlaySound("pierce",10)
		warn3.Remove()
		bonewall3 = CreateProjectileAbs("Bones/Spam",Arena.x,300)
		bonewall3.sprite.SetParent(mask)
		bonewall3.sprite.SetPivot(0.5,1)
		bonewall3.MoveToAbs(Arena.x,Arena.y+Arena.height + 7)
		bonewall3.sprite.rotation = 180
		bonewall3.ppcollision = true
		bonewall3.SetVar("Type","kr1")
	end
	
	if spawntimer >= 5.666667 and seq == 8 then
		seq = seq + 1
		Encounter.Call("ChangeSoul","Red")
		local d = gaster:New({740,500},{480,200},{0.5,1},270,180,false,"kr1")
		d.firetime = 0.4166667
		table.insert(blasters,d)
	end
	
	if spawntimer >= 5.833333 and seq == 9 then
		seq = seq + 1
		local e = gaster:New({-100,500},{100,150},{0.5,1},90,180,false,"kr1")
		e.firetime = 0.4166667
		table.insert(blasters,e)
	end
	
	if spawntimer >= 6 and seq == 10 then
		seq = seq + 1
		local f = gaster:New({740,500},{480,120},{0.5,1},270,180,false,"kr1")
		f.firetime = 0.4166667
		table.insert(blasters,f)
	end
	
	if spawntimer >= 6.583333 and seq == 11 then
		seq = seq + 1
		Audio.PlaySound("warn")
		warn4 = CreateSprite("px","BelowPlayer")
		warn4.x = Arena.x
		warn4.y = Arena.y - 15 + Arena.height/2
		warn4.xscale = Arena.width
		warn4.color = {1,0,0}
	end
	
	if spawntimer >= 7.083333 and seq == 12 then
		seq = seq + 1
		Audio.PlaySound("pierce",10)
		warn4.Remove()
		bonewall4 = CreateProjectileAbs("Bones/Spam",Arena.x,300)
		bonewall4.sprite.SetParent(mask)
		bonewall4.sprite.SetPivot(0.5,1)
		bonewall4.MoveToAbs(Arena.x,Arena.y - 7)
		bonewall4.sprite.rotation = 0
		bonewall4.ppcollision = true
		bonewall4.SetVar("Type","kr1")
	end
	
	if bonewall1 then
		
		if spawntimer >= 6.666667 then

			bonewall1.absx = lerp(bonewall1.absx,Arena.x-Arena.width/2 ,0.1*Time.mult)
		else
			bonewall1.absx = lerp(bonewall1.absx,Arena.x-Arena.width/2 + 57,0.1*Time.mult)
		end
		
		
	end
	
	if bonewall2 then
	
		if spawntimer >= 6.666667 then
			bonewall2.absx = lerp(bonewall2.absx,Arena.x+Arena.width/2,0.1*Time.mult)
		else
			bonewall2.absx = lerp(bonewall2.absx,Arena.x+Arena.width/2 - 57,0.1*Time.mult)
		end
	
		
	end
	
	if bonewall3 then
		bonewall3.absy = lerp(bonewall3.absy,Arena.y+Arena.height/2 + 17,0.1*Time.mult)
	end
	
	if bonewall4 then
		bonewall4.absy = lerp(bonewall4.absy,Arena.y+Arena.height/2 - 17,0.1*Time.mult)
	end
	
		for i,v in pairs(blasters) do
			if v.lifetime > v.firetime then
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