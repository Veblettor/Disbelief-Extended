helper = require("wave_helper")
spawntimer = 0
Arena.Resize(280,132)
Audio.LoadFile("p7_sansmemory")

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

function dodging()
	local b1 = CreateProjectile("Bones/tall",-Arena.width/2-8,70)
	b1.SetVar("yvel",0)
	b1.SetVar("xvel",2)
	b1.sprite.Scale(1,1)
	b1.SetVar("Type","kr1")
	
	
	local b2 = CreateProjectile("Bones/tall",Arena.width/2+8,-70)
	b2.SetVar("yvel",0)
	b2.SetVar("xvel",-2)
	b2.sprite.Scale(1,1)
	b2.SetVar("Type","kr1")
	
	b1.sprite.SetParent(mask)
	b2.sprite.SetParent(mask)
	table.insert(bullets,b1)
	table.insert(bullets,b2)
	
	local rand = math.random(1,2)
	
	local x
	local xvel
	
	if rand == 1 then
	x = -Arena.width/2-12
	xvel = 3
	else
	x = Arena.width/2+12
	xvel = -3
	end
	
	local b3 = CreateProjectile("Bones/tall",x,0)
	b3.SetVar("yvel",0)
	b3.SetVar("xvel",xvel)
	b3.SetVar("Type","krB")
	b3.sprite.color = {0,1,1}
	
	table.insert(bullets,b3)
	
	b1.sprite.SetParent(mask)
	b2.sprite.SetParent(mask)
	b3.sprite.SetParent(mask)
end

function soul()
	Audio.PlaySound("ding")
	Encounter.Call("ChangeSoul","Blue")
	Encounter.SetVar("atk",15)
end

function bo1()
	Encounter.SetVar("atk",13)
	local b = CreateProjectile("Bones/medium",Arena.width/2+8,-30)
	b.SetVar("xvel",-2)
	b.sprite.scale(1,1)
	b.SetVar("yvel",0)
	b.SetVar("Type","kr1")
	b.ppcollision = true
	b.sprite.SetParent(mask)
	table.insert(bullets,b)
end

function bo2()
	Encounter.SetVar("atk",11)
	local b = CreateProjectile("Bones/mediumer",Arena.width/2+8,-30)
	b.SetVar("xvel",-2)
	b.sprite.scale(1,1)
	b.SetVar("yvel",0)
	b.SetVar("Type","kr1")
	b.ppcollision = true
	b.sprite.SetParent(mask)
	table.insert(bullets,b)
end

function bo3()
	Encounter.SetVar("atk",9)
	local b = CreateProjectile("Bones/mediumish",Arena.width/2+8,-30)
	b.SetVar("xvel",-2)
	b.sprite.scale(1,1)
	b.SetVar("yvel",0)
	b.SetVar("Type","kr1")
	b.ppcollision = true
	b.sprite.SetParent(mask)
	table.insert(bullets,b)
end

function bo4()
	Encounter.SetVar("atk",7)
	local b = CreateProjectile("Bones/Small",Arena.width/2+8,-47)
	b.SetVar("xvel",-2)
	b.SetVar("yvel",0)
	b.SetVar("Type","kr1")
	b.ppcollision = true
	b.sprite.SetParent(mask)
	table.insert(bullets,b)
end

function bo5()
	Encounter.SetVar("atk",5)
	local b = CreateProjectile("Bones/Smaller",Arena.width/2+8,-55)
	b.SetVar("xvel",-2)
	b.SetVar("yvel",0)
	b.SetVar("Type","kr1")
	b.ppcollision = true
	b.sprite.SetParent(mask)
	table.insert(bullets,b)
end

function bo6()
	Encounter.SetVar("atk",3)
	local b = CreateProjectile("Bones/tiny",Arena.width/2+8,-59)
	b.SetVar("xvel",-1)
	b.sprite.Scale(0.5,0.5)
	b.SetVar("yvel",0)
	b.SetVar("Type","kr1")
	b.ppcollision = true
	b.sprite.SetParent(mask)
	table.insert(bullets,b)
end

dodging()
helper:AddRepeatEvent(dodging,1,8)
helper:AddEvent(soul,10)
helper:AddEvent(bo1,11)
helper:AddEvent(bo2,12)
helper:AddEvent(bo3,13)
helper:AddEvent(bo4,14)
helper:AddEvent(bo5,15)
helper:AddEvent(bo6,16)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()
if spawntimer % 60 == 0 and spawntimer < 600 then

end

if spawntimer == 660 then

end

if spawntimer == 720 then

end

if spawntimer == 780 then

end

if spawntimer == 840 then

end

if spawntimer == 900 then

end

if spawntimer == 960 then

end

if spawntimer == 1020 then

end

if spawntimer >= 25 then
Audio.Stop()
EndWave()
end

for i,bullet in pairs(bullets) do
	if bullet.isactive then
		bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
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