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
local types = {"krB","krO"}
aaaa = 90
local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")

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


	local a = gaster:New({-100,500},{x,320},{1,1},math.deg(atan)+(90*sign(diffx)),0,false,"kr1")
	a.sprite.SetPivot(0.5,0.5)

	
	a.firetime = 0.5
	


	table.insert(blasters,a)
end

function bone()
	b1 = CreateProjectileAbs("Bones/wide",Arena.x,Arena.y+Arena.height/2+5)
	b1.sprite.SetParent(mask)
	b1.sprite.rotation = 90
	b1.sprite.Scale(2,1)
	b1.sprite.SetPivot(0.5,0.5)
	b1.SetVar("xvel",0)
	b1.SetVar("yvel",0)
	b1.SetVar("Type","kr1")
	aaaa = 100
	b1.ppcollision = true
	table.insert(spinning,b1)
end

function bl1()
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
	a.firetime = 0.5
	table.insert(blasters,a)
end

function bl2()
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
	a.firetime = 0.5
	a.beamhold = 0.45
	local b = gaster:New({-100,500},{220,Arena.y+5+Arena.height/2},{1,1},90,0,false,"kr1")
	b.firetime = 0.5
	b.beamhold = 0.45
	table.insert(blasters,a)
	table.insert(blasters,b)
end

local f = false
helper:AddEvent(bl1,8.75)
helper:AddEvent(bone,9.50)
helper:AddEvent(bl2,16.8)
helper:AddRepeatEvent(targetblaster,1.25,6)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()
if spawntimer >= 19 then
		EndWave()
	end


if (spawntimer > 9.416667) and not f then
	f = true
	helper:AddRepeatEvent(targetblaster,1.5,4)
end

if spawntimer > 17.2 then
if (math.floor(b1.sprite.rotation) == 90 or math.floor(b1.sprite.rotation) == 91) or (math.floor(b1.sprite.rotation) == 270 or math.floor(b1.sprite.rotation) == 271) or (math.floor(b1.sprite.rotation) == 0 or math.floor(b1.sprite.rotation) == 1) or math.ceil(b1.sprite.rotation) == 360 then
b1.Remove()
end
end



for i,v in pairs(blasters) do
	if v.lifetime >= v.firetime then
		v.Fire()
	end
end


for i,bullet in pairs(spinning) do
	if bullet.isactive then
	bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
	bullet.sprite.rotation = bullet.sprite.rotation + 2*Time.mult
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