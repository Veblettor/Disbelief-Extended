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
local f = false
local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")

function bla1()
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
	a.firetime = 0.5
	table.insert(blasters,a)
end

function bla2()
	local a = gaster:New({-100,500},{320,320},{1,1},0,90,false,"kr1")
	a.firetime = 0.5
	--a.beamhold = 0.6
	table.insert(blasters,a)
end

function bone()
	b1 = CreateProjectileAbs("Bones/wide",Arena.x,Arena.y+Arena.height/2+5)
		b1.sprite.SetParent(mask)
		b1.sprite.rotation = 90
		b1.sprite.SetPivot(0.5,0.5)
		b1.SetVar("xvel",0)
		b1.SetVar("yvel",0)
		b1.SetVar("Type","krB")
		b1.sprite.color = {0,1,1}
		b1.ppcollision = true
		table.insert(spinning,b1)
end

function trackblaster()
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
	a.firetime = 0.6


	table.insert(blasters,a)
end


helper:AddEvent(bla1,0.5)
helper:AddEvent(bone,1.25)
helper:AddEvent(bla2,11.4)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()

if spawntimer >= 13 then
		EndWave()
	end

if spawntimer >= 2 and not f then
	f = true
	helper:AddRepeatEvent(trackblaster,1.25,6)
end



if spawntimer > 11.5 then
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
	bullet.sprite.rotation = bullet.sprite.rotation + 3*Time.mult
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