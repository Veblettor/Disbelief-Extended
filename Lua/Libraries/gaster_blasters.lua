local blaster = {}

local function lerp(a,b,t)
	return a + (b - a) * (t*Time.mult)
end


local function MoveBeam(newBlaster)
if newBlaster.beam and newBlaster.beam.isactive then
newBlaster.beam.MoveToAbs(newBlaster.x,newBlaster.y)
newBlaster.beam.sprite.rotation = newBlaster.sprite.rotation
--newBlaster.beam.Move(math.sin(math.rad(newBlaster.sprite.rotation)))
newBlaster.beam.sprite.color = newBlaster.sprite.color
if newBlaster.beamEdge and newBlaster.beamEdge.isactive then
newBlaster.beamEdge.x = 0
newBlaster.beamEdge.y = 0
newBlaster.beamEdge.color = newBlaster.beam.sprite.color
newBlaster.beamEdge.rotation = newBlaster.sprite.rotation
end

end



end

local function SpawnBeam(newBlaster)
newBlaster.beam = CreateProjectileAbs("GasterBlaster/laser",0,0)
Misc.ShakeScreen(math.floor(30/Time.mult),3)
newBlaster.beam.sprite.Scale((0.5*newBlaster.xscale),newBlaster.yscale)
newBlaster.beam.ppcollision = true
newBlaster.beam.SetVar("Type",newBlaster.bullettype)
newBlaster.beam.SetVar("Lifetime",0)
newBlaster.beam.sprite.SetPivot(0.5,1)
Audio.PlaySound("blaster_shoot")
MoveBeam(newBlaster)
end

local function SpawnBeamGreenSoul(newBlaster)
newBlaster.beam = CreateProjectileAbs("px",0,0)
newBlaster.beamEdge = CreateSprite("px","BelowBullet")
newBlaster.beamEdge.absx = 0
newBlaster.beamEdge.absy = 0
newBlaster.beamEdge.SetPivot(0.5,0)
newBlaster.beamEdge.SetParent(newBlaster.beam.sprite)
newBlaster.beamEdge.SetAnchor(0.5,0)


Misc.ShakeScreen(math.floor(30/Time.mult),3)
newBlaster.beam.sprite.Scale(63,9999)
newBlaster.beam.ppcollision = true
newBlaster.beam.SetVar("Type",newBlaster.bullettype)
newBlaster.beam.SetVar("Lifetime",0)
newBlaster.beam.sprite.SetPivot(0.5,1)
newBlaster.beamEdge.SetAnimation({"GasterBlaster/ShieldCollision1","GasterBlaster/ShieldCollision2"},1/20)
newBlaster.beamEdge.rotation = newBlaster.targetang
Audio.PlaySound("blaster_shoot")
MoveBeam(newBlaster)
end


blaster.GasterBlasters = {}
blaster.GreenBlasters = {}
function blaster:New(startcoords,targetcoords,scale,targetang,startang,autoshoot,bullettype)

scale = scale or {1,1}
Audio.PlaySound("blaster_spawn")
local newBlaster = {}
newBlaster.bullettype = bullettype or "kr1"
newBlaster.sprite = CreateSprite("GasterBlaster/blaster0","Top")

newBlaster.sprite.Scale(scale[1],scale[2])
newBlaster.xscale = scale[1]
newBlaster.yscale = scale[2]
newBlaster.sprite.MoveTo(startcoords[1],startcoords[2])
newBlaster.sprite.rotation = 0
newBlaster.spd = 0
newBlaster.beamhold = 0.4
newBlaster.ready = false
newBlaster.firing = false
newBlaster.doneshooting = false
newBlaster.lifetime = 0
newBlaster.firingtime = 0
newBlaster.x = startcoords[1]
newBlaster.y = startcoords[2]
newBlaster.targetx = targetcoords[1]
newBlaster.targety = targetcoords[2]
newBlaster.ang = 0
newBlaster.targetang = targetang % 360

if startang then
newBlaster.ang = startang
newBlaster.sprite.rotation = startang
end

if newBlaster.targetang >= 180 then
newBlaster.targetang = newBlaster.targetang - 360
end

function newBlaster.Scale(x,y)
newBlaster.xscale = x
newBlaster.yscale = y
newBlaster.sprite.Scale(x,y)
end

function newBlaster.Fire()
if newBlaster and newBlaster.sprite and not newBlaster.Removed and not newBlaster.firing then
newBlaster.sprite.SetAnimation({"GasterBlaster/blaster1"})
SpawnBeam(newBlaster)
newBlaster.firing = true
end
end

local index = #self.GasterBlasters+1
function newBlaster.Remove()

if newBlaster.beam and newBlaster.beam.isactive then
newBlaster.beam.Remove()
end
newBlaster.Removed = true
newBlaster.firing = false
newBlaster.sprite.Remove()
end

table.insert(self.GasterBlasters,newBlaster)
return newBlaster
end

function blaster:WaveEnd()
local blasters = self.GasterBlasters

for i,gblaster in pairs(blasters) do

if gblaster.beam and gblaster.beam.isactive then
gblaster.beam.Remove()
end
gblaster.sprite.Remove()
gblaster = nil
end

self.GasterBlasters = {}
end

function blaster:Update()
local blasters = self.GasterBlasters
local greenblasters = self.GreenBlasters

for i,gblaster in pairs(blasters) do


	
	gblaster.lifetime = gblaster.lifetime + Time.dt
	
	if gblaster.beamEdge and gblaster.beamEdge.isactive and gblaster.beam and gblaster.beam.isactive then
gblaster.beamEdge.alpha = gblaster.beam.sprite.alpha

end
	
	if gblaster.firing and gblaster.sprite.isactive then
		gblaster.sprite.rotation = gblaster.targetang
		gblaster.spd = gblaster.spd + (24/(gblaster.beamhold*60))*Time.mult
		gblaster.x = gblaster.x - (gblaster.spd * math.sin(math.rad(gblaster.sprite.rotation)))*Time.mult
		gblaster.y = gblaster.y + (gblaster.spd * math.cos(math.rad(gblaster.sprite.rotation)))*Time.mult
		
		
		
		if gblaster.beam then
			gblaster.beam.SetVar("Lifetime",gblaster.beam.GetVar("Lifetime")+Time.dt)
			local beamlife = gblaster.beam.GetVar("Lifetime")
			MoveBeam(gblaster)
			if beamlife < gblaster.beamhold then
		
				if gblaster.isgreen then
			

				else
			
			
			
					if gblaster.beam.sprite.xscale < gblaster.xscale then
						gblaster.beam.sprite.xscale = math.min(gblaster.beam.sprite.xscale+(0.05*Time.mult),gblaster.xscale)
					elseif gblaster.beam.sprite.xscale >= gblaster.xscale then
						gblaster.beam.sprite.xscale = math.max(gblaster.beam.sprite.xscale-(0.05*Time.mult),gblaster.xscale*0.9)
				end
			
			
			
			
			
			end
		
			
			
			
		else
			
			gblaster.beam.sprite.alpha = gblaster.beam.sprite.alpha - Time.mult/(gblaster.beamhold*60)
			gblaster.beam.sprite.xscale = math.max(gblaster.beam.sprite.xscale - Time.mult/(gblaster.beamhold*60),0)
			
			if gblaster.beam.sprite.alpha <= 0 then
				gblaster.beam.Remove()
			end
			
		end
	  
		end
	
	  
	end
	
	if not gblaster.firing and not gblaster.Removed then
		gblaster.x = lerp(gblaster.x,gblaster.targetx,0.15)
		gblaster.y = lerp(gblaster.y,gblaster.targety,0.15)
		gblaster.ang = lerp(gblaster.ang,gblaster.targetang,0.15)
		gblaster.sprite.rotation = gblaster.ang
		
	elseif not gblaster.isgreen then
		gblaster.firingtime = gblaster.firingtime + Time.dt
		if gblaster.firingtime > (gblaster.beamhold*2 + 1) and gblaster.sprite.isactive then
			
			gblaster.Remove()
		end
		
	end
	
	if not gblaster.Removed then
		gblaster.sprite.x = gblaster.x
		gblaster.sprite.y = gblaster.y
	end
end



local facing = Encounter.Call("GetGSoulFacing")

local coords = {0,33}
			
			
			if facing  == "Down" then
				coords = {0,-33}
			elseif facing  == "Left" then
				coords = {-33,0}
			elseif facing  == "Right" then
			
				coords = {33,0}
			
			end

for i,v in pairs(greenblasters) do
if v.beam and v.beam.isactive and v.isgreen then
					
					local diff

					if v.Face == "Up" or v.Face == "Down" then
							diff = coords[2] - v.beam.y
						else
							diff = coords[1] - v.beam.x
					end
				
					if v.Face == facing then
						v.beam.sprite.yscale = math.abs(diff)
						Encounter.Call("HandleShield",v.beam)
					else
						v.beam.sprite.yscale = 9999
					end
				
				end
end

end






function blaster:NewGreenSoulBlaster(startcoords,targetcoords,scale,face,startang,autoshoot,bullettype)

scale = scale or {1,1}
Audio.PlaySound("blaster_spawn")
local newBlaster = {}
newBlaster.bullettype = bullettype or "Blaster"
newBlaster.sprite = CreateSprite("GasterBlaster/blaster0","Top")

newBlaster.sprite.Scale(scale[1],scale[2])
newBlaster.xscale = scale[1]
newBlaster.yscale = scale[2]
newBlaster.sprite.MoveTo(startcoords[1],startcoords[2])
newBlaster.sprite.rotation = 0
newBlaster.spd = 0
newBlaster.beamhold = 0.4
newBlaster.ready = false
newBlaster.firing = false
newBlaster.doneshooting = false
newBlaster.lifetime = 0
newBlaster.x = startcoords[1]
newBlaster.y = startcoords[2]
newBlaster.targetx = targetcoords[1]
newBlaster.targety = targetcoords[2]
newBlaster.ang = 0
newBlaster.targetang = 0
newBlaster.isgreen = true
newBlaster.Face = face or "Up"
if face == "Up" then
newBlaster.targetang = 0
elseif face == "Left" then
newBlaster.targetang = 90
elseif face == "Right" then
newBlaster.targetang = 270
else
newBlaster.targetang = 180
end

if startang then
newBlaster.ang = startang
newBlaster.sprite.rotation = startang
end

if newBlaster.targetang >= 180 then
newBlaster.targetang = newBlaster.targetang - 360
end

function newBlaster.Scale(x,y)
newBlaster.xscale = x
newBlaster.yscale = y
newBlaster.sprite.Scale(x,y)
end

function newBlaster.Fire()
if not newBlaster.firing then
newBlaster.sprite.SetAnimation({"GasterBlaster/blaster1"})
SpawnBeamGreenSoul(newBlaster)
newBlaster.firing = true
end
end

local index = #self.GasterBlasters+1
function newBlaster.Remove()
table.remove(self.GasterBlasters,index)

if gblaster.beam and gblaster.beam.isactive then
gblaster.beam.Remove()
end

if gblaster.beamEdge then
gblaster.beamEdge.Remove()
end

gblaster.sprite.Remove()

gblaster = nil
end

table.insert(self.GasterBlasters,newBlaster)
table.insert(self.GreenBlasters,newBlaster)
return newBlaster
end


return blaster