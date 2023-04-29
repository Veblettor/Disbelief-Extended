gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0

--Encounter.Call("ChangeSoul","Blue")
--Audio.PlaySound("ding")
bullets = {}
blasters = {}
spinning = {}

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")


local spin1 = nil
local spin2 = nil
local f,bonef,finalf

local function lerp(a,b,t)
return a + (b - a) * t
end



types = {"kr1","krB","krO"}

function kill()
	Player.ForceAttack(1)
end

function bl11()
	local a = gaster:New({-100,500},{270,320},{0.5,1},0,90,false,"kr1")
		
	a.firetime = 0.5
	
	local b = gaster:New({-100,500},{100,200},{0.5,1},90,0,false,"kr1")
	
	b.firetime = 0.5
	
	table.insert(blasters,a)
		table.insert(blasters,b)
end

function bl12()
	local a = gaster:New({-100,500},{310,320},{0.5,1},0,90,false,"kr1")
		
	a.firetime = 0.5
	
	local b = gaster:New({-100,500},{100,170},{0.5,1},90,0,false,"kr1")
	
	b.firetime = 0.5
	
	table.insert(blasters,b)
	table.insert(blasters,a)
end

function bl13()
	local a = gaster:New({-100,500},{350,320},{0.5,1},0,90,false,"kr1")
		
	a.firetime = 0.5
	
	local b = gaster:New({-100,500},{100,140},{0.5,1},90,0,false,"kr1")
	
	b.firetime = 0.5
	
	table.insert(blasters,b)
	table.insert(blasters,a)
end

function bl21()
	local a = gaster:New({700,500},{390,320},{0.5,1},0,90,false,"kr1")
		
		a.firetime = 0.5
		
		local b = gaster:New({700,500},{540,200},{0.5,1},270,0,false,"kr1")
		
		b.firetime = 0.5
		
		table.insert(blasters,a)
			table.insert(blasters,b)
end

function bl22()
	local a = gaster:New({700,500},{350,320},{0.5,1},0,90,false,"kr1")
		
	a.firetime = 0.5
	
	local b = gaster:New({700,500},{540,170},{0.5,1},270,0,false,"kr1")
	
	b.firetime = 0.5
	
	table.insert(blasters,a)
		table.insert(blasters,b)
end

function bl23()
	local a = gaster:New({700,500},{310,320},{0.5,1},0,90,false,"kr1")
		
		a.firetime = 0.5
		
		local b = gaster:New({700,500},{540,140},{0.5,1},270,0,false,"kr1")
		
		b.firetime = 0.5
		
		table.insert(blasters,a)
		table.insert(blasters,b)
end

function bl31()
	local a = gaster:New({-100,500},{200,290},{1,1},45,90,false,"kr1")
	local b = gaster:New({740,500},{440,290},{1,1},-45,90,false,"kr1")
	a.firetime = 0.5
	b.firetime = 0.5
	table.insert(blasters,a)
	table.insert(blasters,b)
end

function bl32()
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
	local b = gaster:New({740,500},{440,180},{1,1},270,0,false,"kr1")
	a.firetime = 0.5
	b.firetime = 0.5
	table.insert(blasters,a)
	table.insert(blasters,b)
end

function soul1()
	Audio.PlaySound("ding")
	Encounter.Call("ChangeSoul","Blue")
	Encounter.Call("ChangeGravity","ceiling")
end

function soul2()
	Audio.PlaySound("ding")
	Encounter.Call("ChangeGravity","upright")
end

function soulbl1()
	local a = gaster:New({700,500},{270,320},{1,1},0,90,false,"kr1")
		
	a.firetime = 0.5
	
	local b = gaster:New({700,500},{540,200},{1,1},270,0,false,"kr1")
	
	b.firetime = 0.5
	
	table.insert(blasters,a)
	table.insert(blasters,b)
end

function soulbl2()
	local a = gaster:New({700,500},{320,320},{1,1},0,90,false,"kr1")
		
		a.firetime = 0.5
		
		local b = gaster:New({700,500},{100,105},{1,1},90,0,false,"kr1")
		b.firetime = 0.5
		table.insert(blasters,a)
		table.insert(blasters,b)
end

function soul3()
	Audio.PlaySound("ding")
	Encounter.Call("ChangeSoul","Red")
end

function soulbl31()
	local a = gaster:New({-100,500},{270,320},{1,1},0,90,false,"kr1")
		
	a.firetime = 0.5
	table.insert(blasters,a)	
end

function soulbl32()
	local a = gaster:New({700,500},{450,200},{1,1},270,0,false,"kr1")
		
			a.firetime = 0.5
			table.insert(blasters,a)	
end

function soulbl33()
	local a = gaster:New({700,500},{100,105},{1,1},90,0,false,"kr1")
		
			a.firetime = 0.5
			table.insert(blasters,a)	
end

function soulbl34()
	local a = gaster:New({700,500},{370,50},{1,1},180,0,false,"kr1")
		
			a.firetime = 0.5
			table.insert(blasters,a)	
end

function bonespin()
	spin1 = CreateProjectileAbs("Bones/wide",Arena.x,Arena.y+Arena.height/2+5)
	spin1.sprite.SetParent(mask)
	spin1.sprite.rotation = 90
	spin1.sprite.SetPivot(0.5,0.5)
	spin1.SetVar("xvel",0)
	spin1.SetVar("yvel",0)
	spin1.SetVar("spd",3)
	spin1.sprite.Scale(2,1)
	spin1.SetVar("Type","krB")
	spin1.sprite.color = {0,1,1}
	spin1.ppcollision = true
	
	spin2 = CreateProjectileAbs("Bones/wide",Arena.x,Arena.y+Arena.height/2+5)
	spin2.sprite.SetParent(mask)
	spin2.sprite.rotation = 0
	spin2.sprite.SetPivot(0.5,0.5)
	spin2.sprite.color = {1,0.5,0}
	spin2.SetVar("xvel",0)
	spin2.SetVar("yvel",0)
	spin2.SetVar("spd",3)
	spin2.sprite.Scale(2,1)
	spin2.SetVar("Type","krO")
	
	spin2.ppcollision = true
	
	table.insert(spinning,spin1)
	table.insert(spinning,spin2)
end

function blbone1()
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
	local b = gaster:New({-100,-100},{100,150},{1,1},90,90,false,"kr1")
	a.firetime = 0.5
	b.firetime = 0.5
	table.insert(blasters,a)
	table.insert(blasters,b)
end

function blbone2()
	local a = gaster:New({-100,500},{200,290},{1,1},45,90,false,"kr1")
	local b = gaster:New({740,500},{440,290},{1,1},-45,90,false,"kr1")
	local c = gaster:New({740,500},{320,320},{1,1},0,90,false,"kr1")
	a.firetime = 0.5
	b.firetime = 0.5
	c.firetime = 0.5
	table.insert(blasters,a)
	table.insert(blasters,b)
	table.insert(blasters,c)
end

function blbone3()
	local a = gaster:New({-100,500},{280,320},{1,1},0,90,false,"kr1")
	local b = gaster:New({740,500},{360,320},{1,1},0,90,false,"kr1")
	a.firetime = 0.5
	b.firetime = 0.5
	table.insert(blasters,a)
	table.insert(blasters,b)
end

function colorbones()
	local b = CreateProjectile("Bones/wide",0,Arena.height/2+5)
	b.SetVar("xvel",0)
	b.SetVar("yvel",-3)
	b.sprite.SetParent(mask)
	local r = math.random(1,2)
	if r == 1 then
	b.SetVar("Type","krB")
	b.sprite.color = {0,1,1}
	else
	b.SetVar("Type","krO")
	b.sprite.color = {1,0.5,0}
	end
	table.insert(bullets,b)
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
	
	
	local a = gaster:New({-100,500},{x,320},{0.5,1},math.deg(atan)+((90)*sign(diffx)),0,false,"kr1")
	a.sprite.SetPivot(0.5,0.5)
	
	a.firetime = 0.5833333
	
	
	table.insert(blasters,a)
end

helper:AddEvent(kill,48.3333333333)

helper:AddEvent(bl11,1/3+1/6)
helper:AddEvent(bl12,1/3+2/6)
helper:AddEvent(bl13,1/3+3/6)

helper:AddEvent(bl21,1.5+1/6)
helper:AddEvent(bl22,1.5+2/6)
helper:AddEvent(bl23,1.5+3/6)

helper:AddEvent(soul1,3)
helper:AddEvent(soulbl1,3+1/3)

helper:AddEvent(soul2,4+1/3)
helper:AddEvent(soulbl2,4+2/3)

helper:AddEvent(soul3,5+2/3)
helper:AddEvent(soulbl31,6)
helper:AddEvent(soulbl32,6+1/12)
helper:AddEvent(soulbl33,6+2/12)
helper:AddEvent(soulbl34,6+3/12)

helper:AddEvent(bl31,7.16666666667)
helper:AddEvent(bl32,8.16666666667)

helper:AddEvent(bonespin,8.91666666667)
helper:AddEvent(blbone1,14.9166666667)
helper:AddEvent(blbone2,16.4166666667)
helper:AddEvent(blbone3,17.6666666667)
function Update()
    spawntimer = spawntimer + Time.dt
	helper:Update()
	for i,v in pairs(blasters) do
		if v.lifetime >= v.firetime then
			v.Fire()
		end
	end
		
	
		
		
	if spawntimer >= 8.91666666667 and not f then
		f = true
		helper:AddRepeatEvent(targetblaster,1.5,3)
	end
		
		


	if spawntimer >= 15.4166666667 then
		spin1.Remove()
		spin2.Remove()
	end

	if spawntimer >= 18.8333333333 and not bonef then
		bonef = true
		Arena.Resize(132,130)
		mask.Scale(Arena.width,Arena.height)
		mask.x = Arena.x
		mask.y = Arena.y+5+Arena.height/2
		helper:AddRepeatEvent(colorbones,0.5,20)
	end


	for i,bullet in pairs(bullets) do
		bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
	end
	
	for i,bullet in pairs(spinning) do
		if bullet.isactive then
			bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
			bullet.sprite.rotation = bullet.sprite.rotation + bullet.GetVar("spd")*Time.mult
		end
	end


		if spawntimer > 30 and not finalf then
			finalf = true
			helper:AddRepeatEvent(targetblaster,0.5,32)
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