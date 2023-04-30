local papyrus = {}
local phelper = require("wave_helper")
papyrus.Head = nil
papyrus.Jaw = nil
papyrus.Arms = {Left = nil, Right = nil}
papyrus.Torso = nil
papyrus.Legs = nil

papyrus.Animation = ""
papyrus.LastAnim = ""
papyrus.GoingDown = true
papyrus.RotatingLeft = false
papyrus.elapsed = 0
papyrus.deltaelapsed = 0
papyrus.p6elapsed = 0
papyrus.SavedRotation = 0
papyrus.SavedRotation2 = 0
local function lerp(a,b,t)
return a + (b - a) * t
end

function papyrus:Spawn()
self.Legs = CreateSprite("Papyrus/Legs/Normal","BelowArena")
self.Legs.SetPivot(0.5,1)
self.Torso = CreateSprite("Papyrus/Body/My style","BelowArena")
self.Torso.SetParent(self.Legs)
self.Torso.SetPivot(0.5,0)
self.Torso.SetAnchor(0.5,1)
self.Arms.Left = CreateSprite("Papyrus/Arms/Right Tired 2","BelowArena")
self.Arms.Left.SetParent(self.Torso)
self.Arms.Left.SetPivot(0.5,1)
self.Arms.Left.SetAnchor(0.85,0.6)

self.Arms.Right = CreateSprite("Papyrus/Arms/Left Tired 2","BelowArena")
self.Arms.Right.SetParent(self.Torso)
self.Arms.Right.SetPivot(0.5,1)
self.Arms.Right.SetAnchor(0.15,0.6)

self.Jaw = CreateSprite("Papyrus/Jaw","BelowArena")
self.Jaw.SetParent(self.Torso)
self.Jaw.SetPivot(0.5,0)
self.Jaw.SetAnchor(0.5,0.8)

self.Head = CreateSprite("Papyrus/Head/Phase 4/...","BelowArena")
self.Head.SetParent(self.Jaw)
self.Head.SetPivot(0.5,0)
self.Head.SetAnchor(0.5,0.35)

self.Torso.y = -10
self.Arms.Left.y = 0
self.Arms.Right.y = 0
self.Jaw.y = -3
self.Jaw.x = 3
self.Head.y = 0
self.Legs.y = 330

self.Bone = CreateSprite("Bones/Small",self.Legs.layer)
self.Bone.alpha = 0
self.Bone.SetParent(self.Arms.Left)
self.Bone.SetAnchor(0.75,0.7)
self.Bone.y = 0
self.Bone.x = 0
self.BoneVel = 4

self.AnimationSpeed = 1 --1.5 for phase 8 (.5 for tired p8)

end

function papyrus:SetVisible(visible)
local a = 0

if visible then a = 1 else a = 0 end

self.Jaw.alpha = a
self.Head.alpha = a
self.Legs.alpha = a
self.Arms.Left.alpha = a
self.Arms.Right.alpha = a
self.Torso.alpha = a

end

function papyrus:SetAlpha(a)
self.Jaw.alpha = a
self.Head.alpha = a
self.Legs.alpha = a
self.Arms.Left.alpha = a
self.Arms.Right.alpha = a
self.Torso.alpha = a
end

function papyrus:Dust()
self.Jaw.Dust()
self.Head.Dust(false)
self.Legs.Dust(false)
self.Arms.Left.Dust(false)
self.Arms.Right.Dust(false)
self.Torso.Dust(false)
end

function papyrus:SetLayer(layer)
self.Legs.layer = layer
end

function papyrus:SendToBottom()
  self.Legs.SendToBottom()
  end

function papyrus:ChangeHead(headname)
self.Head.SetAnimation({"Papyrus/Head/"..headname})
end

function papyrus:SetAnimation(animation)
self.LastAnim = self.Animation
self.Animation = animation
self.Bone.alpha = 0
self.p6elapsed = 0
self.SavedRotation = 0
self.SavedRotation2 = 0
if self.Animation == "WAIT!" then
self:ChangeHead("Phase 4/WAIT!")

if self.LastAnim == "Phase 5 Idle" then
self.Arms.Right.SetAnimation({"Papyrus/Arms/Left Tired 2"})
self.Arms.Right.SetPivot(0.5,1)
self.Arms.Right.SetAnchor(0.15,0.6)
end

elseif self.Animation == "Rest" then
  self.Legs.SetAnimation({"Papyrus/Legs/Normal"})
  self.Legs.SetPivot(0.5,1)
  self.Torso.SetAnchor(0.5,1)
  
  
  self.Torso.SetPivot(0.5,0)
  self.Arms.Left.SetPivot(0.5,1)
  self.Arms.Left.SetAnchor(0.85,0.6)
  self.Arms.Right.SetPivot(0.5,1)
  self.Arms.Right.SetAnchor(0.15,0.6)
  self.Jaw.SetPivot(0.5,0)
  self.Jaw.SetAnchor(0.5,0.8)
  self.Head.SetPivot(0.5,0)
  self.Head.SetAnchor(0.5,0.35)
  
  self.Torso.y = -10
  self.Arms.Left.y = 0
  self.Arms.Right.y = 0
  self.Arms.Right.x = 0
  self.Arms.Right.rotation = 0
  self.Arms.Left.rotation = 0
  self.Jaw.y = -3
  self.Jaw.x = 3
  self.Head.y = 0
  
  
  
  self.Legs.y = 330
  
  if self.LastAnim == "Phase 5 Idle" then
  self.Arms.Right.SetAnimation({"Papyrus/Arms/Left Tired 2"})
  self.Arms.Right.SetPivot(0.5,1)
  self.Arms.Right.SetAnchor(0.15,0.6)
  
  end
  

elseif self.Animation == "Phase 5 Idle" then
self:ChangeHead("Phase 5/unsure1")
self.Arms.Right.SetAnimation({"Papyrus/Arms/P5 Right Arm"})
self.Arms.Right.SetPivot(0.85,0.35)
self.Arms.Right.SetAnchor(0.15,0.6)
self.Legs.SetAnimation({"Papyrus/Legs/Front"})
self.Legs.SetPivot(0.5,0.9)
self.Torso.SetAnchor(0.5,0.95)
self.Jaw.rotation = 0
self.Arms.Right.rotation = 0
elseif self.Animation == "Phase 5 Hit" then
self:ChangeHead("Phase 5/downed")
self.Arms.Right.SetAnimation({"Papyrus/Arms/Left Tired 2"})
self.Arms.Right.SetPivot(0.5,1)
self.Arms.Right.SetAnchor(0.15,0.6)
self.Legs.SetAnimation({"Papyrus/Legs/Given Up"})
self.Legs.SetPivot(0.5,1)
self.Legs.yscale = 0.8
self.Torso.yscale = 0.8
self.Jaw.y = -20
self.Legs.y = 290
elseif self.Animation == "Phase 6 Idle" then
self.Head.SetAnimation({"Papyrus/Head/Phase 6/1", "Papyrus/Head/Phase 6/2"},1)
self.Arms.Right.SetAnimation({"Papyrus/Arms/P6 Right Arm 01","Papyrus/Arms/P6 Right Arm 02"},1)
self.Arms.Right.SetPivot(0.85,0.35)
self.Arms.Right.SetAnchor(0.15,0.6)
self.Arms.Left.SetAnimation({"Papyrus/Arms/Right Tired 2 Grab"})
self.Legs.SetAnimation({"Papyrus/Legs/Front"})
self.Legs.SetPivot(0.5,0.9)
self.Torso.SetAnchor(0.5,0.95)
elseif self.Animation == "Phase 7 Idle" then
self.Legs.SetAnimation({"Papyrus/Legs/Front"})
self.Legs.SetPivot(0.5,0.9)
self.Torso.SetAnchor(0.5,0.95)
elseif self.Animation == "Phase 8 Idle" then
self.Legs.SetAnimation({"Papyrus/Legs/Royal Guard"})
self.Legs.SetPivot(0.5,1)

self.Torso.SetAnimation({"Papyrus/Body/Royal Guard"})
self.Torso.SetPivot(0.35,0)
self.Torso.SetAnchor(0.5,1)
self.Torso.y = 0

self.Arms.Right.SetAnimation({"Papyrus/Arms/Left Royal Guard"})
self.Arms.Right.SetPivot(0.5,0.8)
self.Arms.Right.SetAnchor(0,.6)
self.Arms.Right.x = -15

self.Arms.Left.SetAnimation({"Papyrus/Arms/Right Royal Guard"})
self.Arms.Left.SetPivot(0.15,0.75)
self.Arms.Left.SetAnchor(0.85,.65)

self.Jaw.SetAnimation({"Papyrus/Jaw Royal Guard"})
self.Jaw.SetPivot(0.5,0)
self.Jaw.SetAnchor(0.45,0.75)

self.Head.SetAnimation({"Papyrus/Head/Phase 8/determined"})
self.Head.SetAnchor(0.5,0.25)

self.Bone.alpha = 1

elseif self.Animation == "Phase 8 Tired" then
  self.Legs.SetAnimation({"Papyrus/Legs/Royal Guard"})
  self.Legs.SetPivot(0.5,1)
  
  self.Torso.SetAnimation({"Papyrus/Body/Royal Guard"})
  self.Torso.SetPivot(0.35,0)
  self.Torso.SetAnchor(0.5,1)
  self.Torso.y = 0
  self.Jaw.y = -3
  self.Jaw.x = 0
  self.Arms.Right.SetAnimation({"Papyrus/Arms/Left Royal Guard"})
  self.Arms.Right.SetPivot(0.5,0.8)
  self.Arms.Right.SetAnchor(0,.6)
  self.Arms.Right.x = -15
  
  self.Arms.Left.SetAnimation({"Papyrus/Arms/Right Royal Guard Tired"})
  self.Arms.Left.SetPivot(0.5,0.75)
  self.Arms.Left.SetAnchor(0.85,.65)
  
  self.Jaw.SetAnimation({"Papyrus/Jaw Royal Guard"})
  self.Jaw.SetPivot(0.5,0)
  self.Jaw.SetAnchor(0.45,0.75)
  
  self.Head.SetAnimation({"Papyrus/Head/Phase 8/..."})
  self.Head.SetAnchor(0.5,0.25)
  
  self.Arms.Right.rotation = 0
  self.Arms.Left.rotation = 0
  
  self.Arms.Left.y = -12
  self.Arms.Left.x = 3
 elseif self.Animation == "      " then
   self:SetAlpha(0)
   self.Torso.alpha = 1
   self.Torso.SetAnimation({"Papyrus/Body/      _"})
   self.Torso.Scale(0.25,0.25)
   self.Torso.y = -100
end

end

function p6glitch()
  if papyrus.Animation == "Phase 6 Idle" then
    if papyrus.Jaw.rotation == 0 then
      papyrus.Jaw.rotation = 5 
      elseif papyrus.Jaw.rotation == 5 then 
        papyrus.Jaw.rotation = 0 
      end
  end
end

function p6glitch2()
  if papyrus.Animation == "Phase 6 Idle" then
    if papyrus.Arms.Right.rotation == 0 then
      papyrus.Arms.Right.rotation = 5 
    elseif  papyrus.Arms.Right.rotation == 5 then 
      papyrus.Arms.Right.rotation = 0 
    end
  end
end

phelper:AddRepeatEvent(p6glitch,0.08333333,0)
phelper:AddRepeatEvent(p6glitch2,0.05,0)
function papyrus:Update()
self.elapsed = self.elapsed + 1

local convertedelapsed = self.elapsed*Time.mult
local animspd = self.AnimationSpeed*Time.mult

if self.Animation == "WAIT!" then


self.Head.y = lerp(self.Head.y, 5,0.1*self.AnimationSpeed)
self.Arms.Left.rotation = lerp(self.Arms.Left.rotation,20,0.1*animspd)
self.Arms.Right.rotation = -self.Arms.Left.rotation
elseif self.Animation == "Rest" then

if self.LastAnim == "WAIT!" then

if math.floor(self.Arms.Right.rotation + 0.5) ~= 0 then
self.Arms.Right.rotation = self.Arms.Right.rotation + animspd
end

self.Arms.Left.rotation = lerp(self.Arms.Left.rotation,0,0.1*animspd)
self.Arms.Right.rotation = -self.Arms.Left.rotation
self.Head.y = lerp(self.Head.y, 0,0.1*animspd)
end

elseif self.Animation == "Phase 5 Idle" then

if self.GoingDown then
self.Jaw.y = lerp(self.Jaw.y, -8,0.05*animspd)
self.Torso.y = lerp(self.Torso.y, -15,0.05*animspd)
if self.Jaw.y < -7.9 then
self.GoingDown = false
end

else

self.Jaw.y = lerp(self.Jaw.y, -2,0.05*animspd)
self.Torso.y = lerp(self.Torso.y, -9,0.05*animspd)

if self.Jaw.y > -2.1 then
self.GoingDown = true
end

end

elseif self.Animation == "Phase 5 Hit" then
self.Torso.yscale = lerp(self.Torso.yscale,1,0.1*animspd)
self.Legs.yscale = lerp(self.Legs.yscale,1,0.1*animspd)
self.Jaw.y = lerp(self.Jaw.y,-3,0.05*animspd)
elseif self.Animation == "Phase 6 Idle" then

if self.Torso.y <= -14.9 then
self.GoingDown = false
elseif self.Torso.y >= -12.05 then
self.GoingDown = true
end

if self.Legs.yscale <= 0.951 then
self.ScalingDown = false
elseif self.Legs.yscale >= 1.049 then
self.ScalingDown = true
end

if self.Torso.x <= -5 then
self.GoingLeft = false
elseif self.Torso.x >= 5 then
self.GoingLeft = true
end

if self.GoingLeft then
--self.Torso.x = lerp(self.Torso.x,-5,0.15)
self.Torso.x = self.Torso.x - 0.1*animspd
else
self.Torso.x = self.Torso.x + 0.1*animspd
end

 phelper:Update()
--[[if self.Jaw and (convertedelapsed) % (5/animspd) == 0 then
if self.Jaw.rotation == 0 then
 self.Jaw.rotation = 5 
 elseif self.Jaw.rotation == 5 then 
 self.Jaw.rotation = 0 
 end
end

if self.Arms.Right and (convertedelapsed) % (3/animspd) == 0 then

 
end--]]

if self.ScalingDown then
self.Legs.y = lerp(self.Legs.y,323,0.1*animspd)
self.Legs.yscale = lerp(self.Legs.yscale,0.95,0.1*animspd)
else
self.Legs.yscale = lerp(self.Legs.yscale,1.05,0.1*animspd)
self.Legs.y = lerp(self.Legs.y,332,0.1*animspd)
end

if self.GoingDown then


self.Torso.y = self.Torso.y - 0.08*animspd
else


self.Torso.y = self.Torso.y + 0.08*animspd
end
elseif self.Animation == "Phase 7 Idle" then
if self.Torso.y <= -15 then
self.GoingDown = false
elseif self.Torso.y >= -9.5 then
self.GoingDown = true
end

if self.GoingDown then
self.Torso.y = self.Torso.y - 0.04*animspd
else
self.Torso.y = self.Torso.y + 0.04*animspd
end

elseif self.Animation == "Phase 8 Idle" then
local bonevel = self.BoneVel
self.Bone.rotation = self.Bone.rotation + bonevel*Time.mult

if self.BoneVel <= -8 then
self.Dec = false
elseif self.BoneVel >= 8 then
self.Dec = true
end

if self.Dec then
self.BoneVel = self.BoneVel - 0.1*Time.mult
else
self.BoneVel = self.BoneVel + 0.1*Time.mult
end

if self.Torso.y <= -1.5 then
self.GoingDown = false
elseif self.Torso.y >= 5 then
self.GoingDown = true
end

if self.Jaw.y <= -0.5 then
self.HeadGoingDown = false
elseif self.Jaw.y >= 2 then
self.HeadGoingDown = true
end

if self.Legs.yscale <= 0.951 then
self.ScalingDown = false
elseif self.Legs.yscale >= 1.049 then
self.ScalingDown = true
end

if self.Torso.x <= -0.75 then
self.GoingLeft = false
elseif self.Torso.x >= 2.5 then
self.GoingLeft = true
end

if self.GoingLeft then
--self.Torso.x = lerp(self.Torso.x,-5,0.15)
self.Torso.x = self.Torso.x - 0.1*animspd
else
self.Torso.x = self.Torso.x + 0.1*animspd
end

if self.ScalingDown then
self.Legs.y = lerp(self.Legs.y,323,0.2*animspd)
self.Legs.yscale = lerp(self.Legs.yscale,0.95,0.2*animspd)
else
self.Legs.yscale = lerp(self.Legs.yscale,1.05,0.2*animspd)
self.Legs.y = lerp(self.Legs.y,332,0.2*animspd)
end

if self.GoingDown then


--self.Torso.y = self.Torso.y - 0.2

else


--self.Torso.y = self.Torso.y + 0.2
end


if self.HeadGoingDown then
self.Jaw.y = self.Jaw.y - 0.1*animspd
else
self.Jaw.y = self.Jaw.y + 0.1*animspd
end

if self.RotatingLeft then
--self.SavedRotation = lerp(self.SavedRotation,-10,0.05)
--self.SavedRotation2 = lerp(self.SavedRotation2,10,0.05)

self.SavedRotation = self.SavedRotation - 0.4*animspd
self.SavedRotation2 = self.SavedRotation2 + 0.4*animspd
self.Arms.Right.rotation = self.SavedRotation
self.Arms.Left.rotation = self.SavedRotation2
else

--self.SavedRotation = lerp(self.SavedRotation,20,0.05)
--self.SavedRotation2 = lerp(self.SavedRotation2,-20,0.05)
self.SavedRotation = self.SavedRotation + 0.4*animspd
self.SavedRotation2 = self.SavedRotation2 - 0.4*animspd
self.Arms.Right.rotation = self.SavedRotation
self.Arms.Left.rotation = self.SavedRotation2
end

if self.SavedRotation <= -3 then
self.RotatingLeft = false
elseif self.SavedRotation >= 10 then

self.RotatingLeft = true
end

elseif self.Animation == "Phase 8 Tired" then

  if self.Torso.y <= -1 then
  self.GoingDown = false
  elseif self.Torso.y >= 2.5 then
  self.GoingDown = true
  end
  
  if self.GoingDown then
  self.Torso.y = self.Torso.y - 0.08*animspd
  else
  self.Torso.y = self.Torso.y + 0.08*animspd
  end
  
  if self.RotatingLeft then
  --self.SavedRotation = lerp(self.SavedRotation,-10,0.05)
  --self.SavedRotation2 = lerp(self.SavedRotation2,10,0.05)
  
  self.SavedRotation = self.SavedRotation - 0.16*animspd
  self.SavedRotation2 = self.SavedRotation2 + 0.16*animspd
  self.Arms.Right.rotation = self.SavedRotation
  self.Arms.Left.rotation = self.SavedRotation2
  else
  
  --self.SavedRotation = lerp(self.SavedRotation,20,0.05)
  --self.SavedRotation2 = lerp(self.SavedRotation2,-20,0.05)
  self.SavedRotation = self.SavedRotation + 0.16*animspd
  self.SavedRotation2 = self.SavedRotation2 - 0.16*animspd
  self.Arms.Right.rotation = self.SavedRotation
  self.Arms.Left.rotation = self.SavedRotation2
  end
  
  if self.SavedRotation <= -10 then
  self.RotatingLeft = false
  elseif self.SavedRotation >= 10 then
  
  self.RotatingLeft = true
  end
  
elseif self.Animation == "      " then
  self.Jaw.alpha = 0
  self.Head.alpha = 0
  self.Legs.alpha = 0
  self.Arms.Left.alpha = 0
  self.Arms.Right.alpha = 0
  self.Torso.alpha = 1
end -- end of animations

end


return papyrus
