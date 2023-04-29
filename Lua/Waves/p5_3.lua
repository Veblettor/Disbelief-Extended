gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0
Encounter.Call("ChangeSoul","Red")
--Arena.Resize(200,200)

Arena.Resize(300,130)
bullets = {}
blasters = {}

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")
seq = 0

function round2(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
  end

e = function()
	local b1 = CreateProjectileAbs("Bones/top_extended",Arena.x-160,Arena.y+Arena.height+5)
	b1.sprite.SetParent(mask)
	b1.sprite.SetPivot(0.5,1)
	b1.SetVar("xvel",1.5)
	b1.SetVar("yvel",0)
	b1.SetVar("Type","kr1")
	
	local b2 = CreateProjectileAbs("Bones/bottom_extended",Arena.x+160,Arena.y+5)
	b2.sprite.SetPivot(0.5,0)
	b2.sprite.SetParent(mask)
	b2.SetVar("xvel",-1.5)
	b2.SetVar("yvel",0)
	b2.SetVar("Type","kr1")
	table.insert(bullets,b1)
	table.insert(bullets,b2)
end

helper:AddRepeatEvent(e,0.75,6)

function Update()
spawntimer = spawntimer + Time.dt

helper:Update()


if spawntimer >= 4.66666666667 and seq == 0 then
seq = seq + 1
local a = gaster:New({-100,500},{200,320},{1,1},0,90,false,"kr1")
local b = gaster:New({740,500},{440,320},{1,1},0,90,false,"kr1")
a.firetime = 0.5
b.firetime = 0.5
table.insert(blasters,a)
table.insert(blasters,b)
end

if spawntimer >= 5.5 and seq == 1 then
seq = seq + 1
local c = gaster:New({-100,500},{270,320},{0.5,1},0,90,false,"kr1")
local d = gaster:New({740,500},{370,320},{0.5,1},0,90,false,"kr1")
c.firetime = 0.5
d.firetime = 0.5
table.insert(blasters,c)
table.insert(blasters,d)
end

if spawntimer >= 8.16666666667 then
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
end