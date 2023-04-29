gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0
Arena.Resize(200,96)
Encounter.Call("ChangeSoul","Red")

bullets = {}
blasters = {}

local function lerp(a,b,t)
return a + (b - a) * (t*Time.mult)
end

local blockade

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")

function AddBlockade()
	blockade = CreateProjectile("Bones/lesstall",-75,300)
	blockade.SetVar("Type","kr1")
	blockade.SetVar("xvel",0)
	blockade.sprite.SetParent(mask)
end

function MakeBlue()
	blockade.sprite.color = {0,1,1}
	blockade.SetVar("Type","krB")
	Audio.PlaySound("ding")
end

function MakeOrange()
	blockade.sprite.color = {1,.5,0}
	blockade.SetVar("Type","krO")
	Audio.PlaySound("ding")
end



function ChangeVel()
	blockade.SetVar("xvel",-5)
end

function SpawnBones()
	local rng = math.random(1,7)
	local stop = false
	for i = 1,8 do

	local b = CreateProjectile("Bones/Smaller",-150,999)
	b.sprite.SetParent(mask)
	b.absy = Arena.y+(Arena.height-(12*(i-1)))
	b.SetVar("xvel",1.75)
	b.SetVar("yvel",0)
	if i == rng then
		b.SetVar("Type","krB")
		b.sprite.color = {0,1,1}
		if not stop then
			stop = true
			rng = i+1
		end
		else
		b.SetVar("Type","kr1")
	end
	b.ppcollision = true
	b.sprite.rotation = 90
	table.insert(bullets,b)
	end
end

function StartSpawning()
	helper:AddRepeatEvent(SpawnBones,1,12)
end

function  Bla1()
	local		a = gaster:New({-100,500},{550,186},{.8,1},270,180,false,"kr1")
	local		b = gaster:New({740,500},{100,110},{.8,1},90,0,false,"kr1")
	a.firetime = 2/3
	b.firetime = 2/3

	table.insert(blasters,a)
	table.insert(blasters,b)
end

function Bla2()
	local		a = gaster:New({-100,500},{Player.absx,320},{1,1},0,90,false,"krB")
	local		b = gaster:New({740,500},{100,Player.absy},{.75,1},90,0,false,"kr1")
	a.firetime = 0.75
	b.firetime = 0.5833333

	a.sprite.color = {0,1,1}

	table.insert(blasters,a)
	table.insert(blasters,b)
end

function Bla3()
	local		a = gaster:New({-100,500},{Player.absx,320},{1.5,1.5},0,90,false,"krO")
	a.firetime = 2/3
	a.sprite.color = {1,.5,0}
	table.insert(blasters,a)
end

helper:AddEvent(AddBlockade,1/3)
helper:AddEvent(MakeBlue,2)
helper:AddEvent(StartSpawning,3)
helper:AddEvent(ChangeVel,20 + 1/3)
helper:AddEvent(MakeOrange,21)

helper:AddEvent(Bla1,17.66667)
helper:AddEvent(Bla2,18.66667)
helper:AddEvent(Bla3,20.33333)
function Update()
	spawntimer = spawntimer + Time.dt
	helper:Update()

	if blockade then

		if spawntimer < 2 then
			blockade.absy = lerp(blockade.absy,Arena.y+Arena.height/2+5,0.1)
		elseif blockade.absx < Arena.x+75 then
			blockade.absx = blockade.absx + 1.5*Time.mult
		end





		if spawntimer > 20.33333 then
			blockade.SetVar("xvel",blockade.GetVar("xvel")+0.12*Time.mult)
		end


		if blockade.GetVar("xvel") then
			blockade.Move(blockade.GetVar("xvel")*Time.mult,0)
		end

	end




	if spawntimer >= 23.33333 then
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