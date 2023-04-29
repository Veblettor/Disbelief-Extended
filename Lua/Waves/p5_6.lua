-- The bouncing bullets attack from the documentation example.
gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0
Arena.Resize(451,130)
Encounter.Call("ChangeSoul","Blue")
bullets = {}
platforms = {}
blasters = {}
yOffset = 180
mult = 0.5

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")

function flick()
	Encounter.Call("Flicker",1/3)
end

function spawnparkour()
	local wall = CreateProjectile("Bones/Spam_Big",Arena.x-Arena.width-150,0)
	wall.sprite.SetPivot(1,0.5)
	wall.SetVar("Type","kr1")
	wall.SetVar("velx",1)
	wall.SetVar("vely",0)
	wall.sprite.SetParent(mask)
	table.insert(bullets,wall)	
	local b = CreateProjectile("Bones/platforming_1",0,0)
	b.ppcollision = true
	b.SetVar("Type","kr1")
	
	local platform = CreateProjectile("Platforms/70",-185,10)
	platform.SetVar("Height",5)
	platform.SetVar("Type","platform")
	platform.SetVar("XVel",0)
	platform.SetVar("YVel",0)
	
	local platform2 = CreateProjectile("Platforms/70",-85,-20)
	platform2.SetVar("Height",5)
	platform2.SetVar("Type","platform")
	platform2.SetVar("XVel",0)
	platform2.SetVar("YVel",0)
	
	local platform3 = CreateProjectile("Platforms/70",10,0)
	platform3.SetVar("Height",5)
	platform3.SetVar("Type","platform")
	platform3.SetVar("XVel",0)
	platform3.SetVar("YVel",0)
	
	local platform4 = CreateProjectile("Platforms/70",10,-30)
	platform4.SetVar("Height",5)
	platform4.SetVar("Type","platform")
	platform4.SetVar("XVel",1)
	platform4.SetVar("YVel",0)
	
	local platform5 = CreateProjectile("Platforms/70",186,-10)
	platform5.SetVar("Height",5)
	platform5.SetVar("Type","platform")
	platform5.SetVar("XVel",0)
	platform5.SetVar("YVel",0)
	
	Player.MoveTo(-400,90)
	
	table.insert(platforms,platform)
	table.insert(platforms,platform2)
	table.insert(platforms,platform3)
	table.insert(platforms,platform4)
	Encounter.Call("AddPlatform",platform)
	Encounter.Call("AddPlatform",platform2)
	Encounter.Call("AddPlatform",platform3)
	Encounter.Call("AddPlatform",platform4)
	Encounter.Call("AddPlatform",platform5)
end

function flickend()
	Encounter.Call("Flicker",1/3)
	EndWave()
end

function bl1()
	local a = gaster:New({700,500},{Player.absx,320},{0.5,1},0,90,false,"kr1")
	a.firetime = 0.5

	table.insert(blasters,a)
end

function bl2()
	local a = gaster:New({-100,-100},{320,170},{1,1},90,0,false,"kr1")
	a.firetime = 0.5

	table.insert(blasters,a)
end

helper:AddEvent(flick,1/3)
helper:AddEvent(flickend,9.583333)
helper:AddEvent(spawnparkour,2/3)
helper:AddEvent(bl1,7.5)
helper:AddEvent(bl2,8.583333)
function Update()
	helper:Update()
  
    
	for i=1, #platforms do
	local platform = platforms[i]
	local velx = platform.GetVar("XVel")*Time.mult
	local vely = platform.GetVar("YVel")*Time.mult
	
	platform.Move(velx,vely)
	
	if platform.y >= 30 and platform.GetVar("YVel") ~= 0 then
	platform.SetVar("YVel",-platform.GetVar("YVel"))
	elseif platform.y <= -40 and platform.GetVar("YVel") ~= 0  then
	platform.SetVar("YVel",-platform.GetVar("YVel"))
	end
	
	if platform.x >= 95 and platform.GetVar("XVel") ~= 0 then
	platform.SetVar("XVel",-platform.GetVar("XVel"))
	elseif platform.x <= 10 and platform.GetVar("XVel") ~= 0  then
	platform.SetVar("XVel",-platform.GetVar("XVel"))
	end
	
	
	end
	
	
	for i = 1, #bullets do
		local bullet = bullets[i]
		
		if bullet.isactive and bullet.x < -171 then
			
			local velx = bullet.GetVar('velx')
			local vely = bullet.GetVar('vely')
			
			
			
			bullet.Move(velx*Time.mult,vely*Time.mult)
			else
		end
	end
	
	
	
    
	
	
	for i,v in pairs(blasters) do
	if v.lifetime >= v.firetime then
		v.Fire()
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