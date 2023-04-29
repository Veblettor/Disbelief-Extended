helper = require("wave_helper")
spawntimer = 0
Arena.Resize(280,132)


bullets = {}
bullets2 = {}
sprites = {}
blasters = {}

types = {"krO","krB"}

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")


function gaps()
	local randl = math.random(20,75)
local rand2 = math.random(1,2)
local x
local xvel
if rand2 == 1 then
xvel = -2
x = Arena.width/2+5
else
xvel = 2
x = -Arena.width/2-5
end

local t = math.random(1,2)
local b = CreateProjectile("Bones/Body",x,Arena.y-Arena.height-25)

b.sprite.SetPivot(0.5,0)
b.sprite.yscale = randl
local s = CreateProjectile("Bones/Head",0,0)
s.sprite.absy = b.sprite.absy + b.sprite.yscale
local diff = ((Arena.y+5+Arena.height) - (Arena.y+5+randl)) - math.random(30,50)

local b1 = CreateProjectile("Bones/Body",x,Arena.y-24)
b1.sprite.yscale = diff
b1.sprite.SetPivot(0.5,1)
b.SetVar("yvel",0)
b.SetVar("xvel",xvel)
b.sprite.SetParent(mask)

b1.SetVar("yvel",0)
b1.SetVar("xvel",xvel)
b1.SetVar("flipped",true)
b1.sprite.SetParent(mask)
local s1 = CreateProjectile("Bones/Head",0,0)
s1.sprite.absy = b.sprite.absy - b.sprite.yscale
s1.sprite.rotation = 180

s.sprite.SetParent(mask)
s1.sprite.SetParent(mask)
b1.sprite.Scale(1,diff)
b.sprite.Scale(1,randl)
b1.SetVar("Type","kr1")
b.SetVar("Type","kr1")
s1.SetVar("Type","kr1")
s.SetVar("Type","kr1")

table.insert(bullets,b)
table.insert(bullets,b1)
table.insert(sprites,s)
table.insert(sprites,s1)

local bb = CreateProjectile("Bones/tall",-x,0)
local rand3 = math.random(1,2)
bb.sprite.SetParent(mask)
bb.SetVar("yvel",0)
bb.SetVar("xvel",-xvel)
if rand3 == 1 then
bb.SetVar("Type","krB")
bb.sprite.color = {0,1,1}
else
bb.SetVar("Type","krO")
bb.sprite.color = {1,0.5,0}

end
table.insert(bullets2,bb)
end

helper:AddRepeatEvent(gaps,1+1/6,10)

function Update()
spawntimer = spawntimer + Time.dt
helper:Update()


if spawntimer % 70 == 0 and spawntimer < 720 then

end

if spawntimer >= 14.33333 then
EndWave()
end

for i,bullet in pairs(bullets2) do
	if bullet.isactive then
		bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
	end
end

for i,bullet in pairs(bullets) do
	if bullet.isactive then
	bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
	if sprites[i] then
	if bullet.GetVar("flipped") then
	sprites[i].absx = bullet.sprite.absx
	sprites[i].absy = bullet.sprite.absy - bullet.sprite.yscale
	else
	sprites[i].absx = bullet.sprite.absx
	sprites[i].absy = bullet.sprite.absy + bullet.sprite.yscale
	end
	
	end
	elseif sprites[i] then
	sprites[i].Remove()
	end
end

end


function OnHit(bullet)
Encounter.Call("HandleHit",bullet)
end

function EndingWave()

for i,v in pairs(sprites) do
v.Remove()
end

mask.Remove()
Encounter.Call("ChangeSoul","Red")
end