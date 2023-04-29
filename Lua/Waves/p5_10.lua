gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0
--Arena.Resize(200,200)
wavetimer = 10.0
Encounter.Call("ChangeSoul","Red")
Arena.Resize(130,130)
bullets = {}
spinning = {}
blasters = {}
b1 = nil
b2 = nil
local types = {"krB","krO"}

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")

function bl1()
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
	a.firetime = 0.5
	table.insert(blasters,a)
end

function bone1()
	b1 = CreateProjectileAbs("Bones/wide",Arena.x,Arena.y+Arena.height/2+5)
		b1.sprite.SetParent(mask)
		b1.sprite.rotation = 90
		b1.sprite.SetPivot(0.5,0.5)
		b1.SetVar("xvel",0)
		b1.SetVar("yvel",0)
		b1.SetVar("spd",2.5)
		b1.sprite.Scale(2,1)
		b1.SetVar("Type","kr1")
		
		b1.ppcollision = true
		
		 b2 = CreateProjectileAbs("Bones/wide",Arena.x,Arena.y+Arena.height/2+5)
		b2.sprite.SetParent(mask)
		b2.sprite.rotation = 90
		b2.sprite.SetPivot(0.5,0.5)
		b2.sprite.color = {1,0.5,0}
		b2.SetVar("xvel",0)
		b2.SetVar("yvel",0)
		b2.SetVar("spd",3)
		b2.sprite.Scale(2,1)
		b2.SetVar("Type","krO")
		
		b2.ppcollision = true
		
		table.insert(spinning,b1)
		table.insert(spinning,b2)
end

function bone2()
	b1.sprite.color = {0,1,1}
	b1.SetVar("Type","krB")
	b1.SetVar("spd",3)
	b2.SetVar("spd",3.5)
end

helper:AddEvent(bl1,0.5)
helper:AddEvent(bl1,5)
helper:AddEvent(bl1,13 + 1/3)
helper:AddEvent(bone1,1.25)
helper:AddEvent(bone2,5.75)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()
if spawntimer >= 16.6666666667 then
		EndWave()
	end



if spawntimer > 14 then
	b2.Remove()
	b1.Remove()
end



for i,v in pairs(blasters) do
	if v.lifetime >= v.firetime then
		v.Fire()
	end
end


for i,bullet in pairs(spinning) do
	if bullet.isactive then
	bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
	bullet.sprite.rotation = bullet.sprite.rotation + bullet.GetVar("spd")*Time.mult
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
end