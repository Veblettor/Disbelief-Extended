gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0
--Arena.Resize(200,200)
wavetimer = 10.0
Encounter.Call("ChangeSoul","Red")
Arena.Resize(300,130)
bullets = {}
spinning = {}
blasters = {}

local types = {"krB","krO"}
local seq = 0
local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")


function b1()
	local a = gaster:New({-100,500},{200,320},{0.5,1},0,90,false,"kr1")
	local b = gaster:New({740,500},{440,320},{0.5,1},0,90,false,"kr1")
	a.firetime = 0.5
	b.firetime = 0.5
	table.insert(blasters,a)
	table.insert(blasters,b)
end

function b2()
	local a = gaster:New({-100,500},{220,320},{1,1},0,90,false,"kr1")
	local b = gaster:New({740,500},{420,320},{1,1},0,90,false,"kr1")
	a.firetime = 0.5
	b.firetime = 0.5
	table.insert(blasters,a)
	table.insert(blasters,b)
end

function b3()
	local a = gaster:New({-100,500},{260,320},{1,1},0,90,false,"kr1")
	local b = gaster:New({740,500},{380,320},{1,1},0,90,false,"kr1")
	a.firetime = 0.5
	b.firetime = 0.5
	table.insert(blasters,a)
	table.insert(blasters,b)
end

function spin1()
	local b1 = CreateProjectileAbs("Bones/tall",Arena.x-160,Arena.y+Arena.height/2)
		b1.sprite.SetParent(mask)
		b1.sprite.SetPivot(0.5,0.5)
		b1.SetVar("xvel",2)
		b1.SetVar("yvel",0)
		b1.SetVar("Type","kr1")
		b1.ppcollision = true
		table.insert(spinning,b1)
end

function color()
	local b = CreateProjectileAbs("Bones/tall",Arena.x+160,Arena.y+Arena.height/2)
	b.sprite.SetParent(mask)
	b.sprite.SetPivot(0.5,0.5)
	b.SetVar("xvel",-3)
	b.SetVar("yvel",0)
	
	local t = types[math.random(1,2)]
	
	if t == "krB" then
		b.sprite.color = {0,1,1}
	else
		b.sprite.color = {1,0.5,0}
	end
	
	b.SetVar("Type",t)
	
	table.insert(bullets,b)
end

helper:AddEvent(spin1,0.5)
helper:AddEvent(spin1,2.083333)
helper:AddEvent(b1,3.666667)
helper:AddEvent(b1,6.166667)
helper:AddEvent(b2,7.166667)
helper:AddEvent(b3,8.166667)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()

if spawntimer >= 10 then
		EndWave()
end


if spawntimer >= 3.666667 and seq == 0 then --spinning 2
	seq = seq + 1
	spin1()
	helper:AddRepeatEvent(spin1,1,2)
end

if spawntimer >= 4.166667 and seq == 1 then --spinning 3
	seq = seq + 1
	color()
	helper:AddRepeatEvent(color,1/3,3)
end





for i,v in pairs(blasters) do
	if v.lifetime >= v.firetime then
		v.Fire()
	end
end

for i,bullet in pairs(bullets) do
	bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
	
	if bullet.absx <= Arena.x - Arena.width/2 + 25 then
		bullet.SetVar("xvel",-(bullet.GetVar("xvel"))+0.5)
	end
	
end

for i,bullet in pairs(spinning) do
	bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
	bullet.sprite.rotation = bullet.sprite.rotation + 3*Time.mult
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