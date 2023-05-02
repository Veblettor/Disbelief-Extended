-- The bouncing bullets attack from the documentation example.
spawntimer = 0
helper = require("wave_helper")
bullets = {}
circlebullets = {}
circlebullets2 = {}
Arena.Resize(640,480)
Arena.Move(0,-90,false)
Arena.outerColor = {0,0,0,0}
Arena.innerColor = {0,0,0,0}
function explode(x,y)
local ang = 22.5
Audio.PlaySound("pierce")
for i = 1,16 do
	local lol = CreateProjectile("Papyrus/Body/WindowsIsAShittyOS",x,y)
	local rads = math.rad(ang)*i
	lol.sprite.rotation = ang*i
	lol.ppcollision = true
    lol.SetVar('Type','nothing')
    lol.SetVar("lifetime",0)
	lol.SetVar("ang",rads)
	lol.SetVar("radius",0)
	lol.SetVar("velx",math.cos(rads)*5)
	lol.SetVar("vely",math.sin(rads)*5)
	lol.SetVar("offsetx",x)
	lol.SetVar("offsety",y)
	lol.SetVar("offsetvely",8)
	lol.SetVar("offsetvelx",math.random(-1,1))
	lol.sprite.scale(0.05,0.05)
	table.insert(circlebullets,lol)
end
end

function implode(x,y)
local ang = 22.5
Audio.PlaySound("pierce")
for i = 1,16 do
	local lol = CreateProjectile("Papyrus/Body/WindowsIsAShittyOS",x,y)
	local rads = math.rad(ang)*i
	lol.sprite.rotation = ang*i
	lol.ppcollision = true
	lol.SetVar("ang",rads)
    lol.SetVar('Type','nothing')
    lol.SetVar("lifetime",0)
	lol.SetVar("radius",1024)
	lol.SetVar("velx",math.cos(rads)*5)
	lol.SetVar("vely",math.sin(rads)*5)
	lol.SetVar("offsetx",x)
	lol.SetVar("offsety",y)
	lol.SetVar("offsetvely",8)
	lol.SetVar("offsetvelx",math.random(-1,1))
	lol.sprite.scale(0.05,0.05)
	table.insert(circlebullets2,lol)
end

end


function spawnin()
        local posx = math.random(-520,520)
	
		local posy = math.random(-420,420)
	   
        if posy == 0 then posy = math.random(-320,320) end
		
		local dist = posx - Player.x
		
		
		if math.abs(dist) < 64 then
           
            if dist > 32 then
                    posx = posx + math.random(100,200)
                else
                    posx = posx - math.random(100,200)
            end
        end
		

		
        local posy = 0
		
		local rand = math.random(1,2)
		
		if rand == 1 then
			explode(posx,math.random(-420,420))
		else
			implode(posx,math.random(-420,420))
		end
		
		
        --[[local bullet = CreateProjectile('bullet', posx, posy)
        bullet.SetVar('velx', 1 - 2*math.random())
        bullet.SetVar('vely', 0)
		
        table.insert(bullets, bullet)--]]
end

function spawnin2()
   helper:AddRepeatEvent(spawnin,1/24,12)
end

function spawnin3()
    implode(0,-100)
end

helper:AddRepeatEvent(spawnin,1/30,0)
--helper:AddRepeatEvent(spawnin2,1.5,0)
--helper:AddRepeatEvent(spawnin3,3,0)
Player.speed = 240
function Update()
    spawntimer = spawntimer + Time.dt
    helper:Update()
    
	if spawntimer > 15 then
		EndWave()
	end
	
	for i,v in pairs(circlebullets) do
		if v.isactive then
		local radius = v.GetVar("radius")
		v.sprite.alpha = v.GetVar("lifetime")/0.25
		 if v.GetVar('lifetime') < 0.25 then
		     v.SetVar('lifetime',v.GetVar('lifetime')+Time.dt)
         elseif v.GetVar("Type") == "nothing" then
            v.SetVar('Type','kr1')
	     end
		
		if radius < 2048 then
		--v.SetVar("ang",v.GetVar("ang")+math.rad(Time.mult))
		v.MoveTo(v.GetVar("offsetx")+radius*math.cos(v.GetVar("ang")), v.GetVar("offsety")+radius*math.sin(v.GetVar("ang")))
		v.SetVar("radius",v.GetVar("radius")+Time.mult*6)
		else
			v.Remove()	
		end
		
		end
		
	end
	
	
	
	for i,v in pairs(circlebullets2) do
		if v.isactive then
		    local radius = v.GetVar("radius")
            v.sprite.alpha = v.GetVar("lifetime")/0.25
         if v.GetVar('lifetime') < 0.25 then
		     v.SetVar('lifetime',v.GetVar('lifetime')+Time.dt)
               
         elseif v.GetVar("Type") == "nothing" then
            v.SetVar('Type','kr1')
	     end
		
		if radius > 0 then
		--v.SetVar("ang",v.GetVar("ang")+math.rad(Time.mult))
		v.MoveTo(radius*math.cos(v.GetVar("ang"))+v.GetVar("offsetx"), radius*math.sin(v.GetVar("ang"))+v.GetVar("offsety"))
	
		--v.SetVar("offsetvely",v.GetVar("offsetvely")-0.15*Time.mult)
		
		
		v.SetVar("radius",v.GetVar("radius")-Time.mult*6)
		--v.SetVar("xvel",math.cos(v.GetVar("ang"))+v.GetVar("offsetvelx"))
		--v.SetVar("yvel",math.sin(v.GetVar("ang"))+v.GetVar("offsetvely"))
		else
			v.Remove()	
		end
		
		end
		
	end
end


function OnHit(bullet)
Encounter.Call("HandleHit",bullet)
end



