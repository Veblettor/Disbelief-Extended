gaster = require "gaster_blasters"
spawntimer = 0
--Arena.Resize(200,200)
Encounter.Call("ChangeSoul","Blue")

bullets = {}
blasters = {}

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")
local seq = 0
function Update()
	spawntimer = spawntimer + Time.dt

if spawntimer >= 0.333333 and seq == 0 then
	seq = seq + 1
local b1 = CreateProjectileAbs("Bones/top_extended",Arena.x-Arena.width,Arena.y+Arena.height+5)
		b1.sprite.SetParent(mask)
		b1.sprite.SetPivot(0.5,1)
		b1.SetVar("xvel",2)
		b1.SetVar("yvel",0)
		b1.SetVar("Type","kr1")
		
		local b2 = CreateProjectileAbs("Bones/bottom_extended",Arena.x+Arena.width,Arena.y+5)
		b2.sprite.SetPivot(0.5,0)
		b2.sprite.SetParent(mask)
		b2.SetVar("xvel",-2)
		b2.SetVar("yvel",0)
		b2.SetVar("Type","kr1")
		table.insert(bullets,b1)
		table.insert(bullets,b2)
end

if spawntimer >= 1 and seq == 1 then
	seq = seq + 1
local b1 = CreateProjectileAbs("Bones/top_extended",Arena.x+Arena.width,Arena.y+Arena.height+5)
		b1.sprite.SetParent(mask)
		b1.sprite.SetPivot(0.5,1)
		b1.SetVar("xvel",-2)
		b1.SetVar("yvel",0)
		b1.SetVar("Type","kr1")
		
		local b2 = CreateProjectileAbs("Bones/bottom_extended",Arena.x-Arena.width,Arena.y+5)
		b2.sprite.SetPivot(0.5,0)
		b2.sprite.SetParent(mask)
		b2.SetVar("xvel",2)
		b2.SetVar("yvel",0)
		b2.SetVar("Type","kr1")
		table.insert(bullets,b1)
		table.insert(bullets,b2)
end

if spawntimer >= 1.5 and seq == 2 then
	seq = seq + 1
	local a = gaster:New({-100,500},{260,320},{0.5,1},0,270,false,"kr1")
		local b = gaster:New({740,500},{380,320},{0.5,1},0,90,false,"kr1")
		a.firetime = 0.5
		b.firetime = 0.5
		table.insert(blasters,a)
		table.insert(blasters,b)
end

if spawntimer >= 2 and seq == 3 then
	seq = seq + 1
local b1 = CreateProjectileAbs("Bones/bottom_extended",Arena.x+Arena.width,Arena.y+5)
		b1.sprite.SetPivot(0.5,0)
		b1.sprite.SetParent(mask)
		b1.SetVar("xvel",-2)
		b1.SetVar("yvel",0)
		b1.SetVar("Type","kr1")
local b2 = CreateProjectileAbs("Bones/bottom_extended",Arena.x-Arena.width,Arena.y+5)
		b2.sprite.SetPivot(0.5,0)
		b2.sprite.SetParent(mask)
		b2.SetVar("xvel",2)
		b2.SetVar("yvel",0)
		b2.SetVar("Type","kr1")
		table.insert(bullets,b1)
		table.insert(bullets,b2)
end

if spawntimer >= 3 and seq == 4 then
seq = seq + 1
Encounter.Call("ChangeGravity","ceiling")
local c = gaster:New({-100,500},{320,320},{1,1},0,270,false,"kr1")
c.firetime = 0.5
table.insert(blasters,c)
end

if spawntimer >= 3.666667 and seq == 5 then
	seq = seq + 1
local a = gaster:New({-100,500},{100,380},{0.5,1},45,90,false,"kr1")
		local b = gaster:New({740,500},{540,380},{0.5,1},-45,90,false,"kr1")
		a.firetime = 0.5
		b.firetime = 0.5
		table.insert(blasters,a)
		table.insert(blasters,b)
end

if spawntimer >= 4.666667 then
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
mask.Remove()
gaster:WaveEnd()
--Encounter.Call("ChangeSoul","Red")
end