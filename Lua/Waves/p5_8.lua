helper = require "wave_helper"
spawntimer = 0
Arena.Resize(524,132)
Encounter.Call("ChangeSoul","Red")

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

local f = false
function spawngap()
	local randl = math.random(20,75)
	local t = math.random(1,2)
	local b = CreateProjectile("Bones/Body",Arena.width/2,Arena.y-Arena.height-25)
	
	b.sprite.SetPivot(0.5,0)
	b.sprite.yscale = randl
	local s = CreateProjectile("Bones/Head",0,0)
	s.sprite.absy = b.sprite.absy + b.sprite.yscale
	local diff = ((Arena.y+5+Arena.height) - (Arena.y+5+randl)) - math.random(22,35)
	
	local b1 = CreateProjectile("Bones/Body",Arena.width/2,Arena.y-24)
	b1.sprite.yscale = diff
	b1.sprite.SetPivot(0.5,1)
	b.SetVar("yvel",0)
	b.SetVar("xvel",-2)
	b.sprite.SetParent(mask)
	
	b1.SetVar("yvel",0)
	b1.SetVar("xvel",-2)
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


	if spawntimer >= 11.66667 and not f then
		f = true
		local b2 = CreateProjectile("Bones/tall",-Arena.width/2,0)
		b2.SetVar("Type","kr1")
		b2.SetVar("yvel",0)
		b2.SetVar("xvel",5)
		
		
		b2.sprite.SetParent(mask)
		table.insert(bullets2,b2)
		else
		local b2 = CreateProjectile("Bones/tall",-Arena.width/2,0)
		b2.SetVar("Type",types[t])
		b2.SetVar("yvel",0)
		b2.SetVar("xvel",3)
		
		if t == 1 then
		b2.sprite.color = {1,0.5,0}
		else
		b2.sprite.color = {0,1,1}
		end
		
		b2.sprite.SetParent(mask)
		table.insert(bullets2,b2)
	end

	table.insert(bullets,b)
	table.insert(bullets,b1)
	table.insert(sprites,s)
	table.insert(sprites,s1)
end

helper:AddRepeatEvent(spawngap,1.166667,0)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()


if spawntimer >= 12.9 then
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
end