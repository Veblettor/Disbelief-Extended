gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0
--Arena.Resize(200,200)
wavetimer = 10.0
--Encounter.Call("ChangeSoul","Red")
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
	a.firetime = 0.75
	table.insert(blasters,a)
	
	local b = gaster:New({-100,500},{450,Arena.y+Arena.height/2+5},{1,1},270,0,false,"kr1")
	b.firetime = 0.75
	table.insert(blasters,b)
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
	
	a.firetime = 0.75
	
	
	table.insert(blasters,a)
end

function bones()
	b1 = CreateProjectileAbs("Bones/wide",Arena.x,Arena.y+Arena.height/2+5)
	b1.sprite.SetParent(mask)
	b1.sprite.rotation = 90
	b1.sprite.SetPivot(0.5,0.5)
	b1.SetVar("xvel",0)
	b1.SetVar("yvel",0)
	b1.SetVar("spd",1.5)
	b1.sprite.Scale(2,1)
	b1.SetVar("Type","kr1")
	
	b1.ppcollision = true
	
	 b2 = CreateProjectileAbs("Bones/wide",Arena.x,Arena.y+Arena.height/2+5)
	b2.sprite.SetParent(mask)
	b2.sprite.rotation = 0
	b2.sprite.SetPivot(0.5,0.5)
	
	b2.SetVar("xvel",0)
	b2.SetVar("yvel",0)
	b2.SetVar("spd",1.5)
	b2.sprite.Scale(2,1)
	b2.SetVar("Type","kr1")
	
	b2.ppcollision = true
	
	table.insert(spinning,b1)
	table.insert(spinning,b2)

	helper:AddRepeatEvent(targetblaster,1, 9)
end

function bl2()
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
	a.firetime = 0.5
	a.beamhold = 0.75
	table.insert(blasters,a)
	
	
	local b = gaster:New({-100,500},{450,Arena.y+Arena.height/2+5},{1,1},270,0,false,"kr1")
	b.firetime = 0.5
	b.beamhold = 0.75
	table.insert(blasters,b)
end

helper:AddEvent(bl1,0.5)
helper:AddEvent(bones,1.5)
helper:AddEvent(bl2,12.5)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()
if spawntimer >= 15 then
		EndWave()
	end

if spawntimer == 30 then

end

if spawntimer == 90 then
 
end


if spawntimer > 90 and spawntimer < 700 and spawntimer % 80 == 0 then

end


if spawntimer == 750 then


end


if spawntimer > 11.66667 then

if (math.floor(b2.sprite.rotation) == 0 or math.floor(b2.sprite.rotation) == 1) or (math.floor(b2.sprite.rotation) == 180 or math.floor(b1.sprite.rotation) == 181) then
b2.Remove()
end

if (math.floor(b1.sprite.rotation) == 90 or math.floor(b1.sprite.rotation) == 91) or (math.floor(b1.sprite.rotation) == 270 or math.floor(b1.sprite.rotation) == 271) then
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
Encounter.Call("ChangeSoul","Red")
end