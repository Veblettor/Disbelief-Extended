Cutscene = {}
Cutscene.__index = Cutscene

function Cutscene.new(OnUpdate,OnStopped,OnStart)
    local object = {}
    setmetatable(object,Cutscene)

    object.Variables = {}
    object.Running = false
    object.TrueElapsedFPS = 0
    object.ElapsedFPS = 0
    object.ElapsedDelta = 0
    object.Phase = 0
    object.OnStart = OnStart
    object.OnStopped = OnStopped
    object.OnUpdate = OnUpdate
    object.Mult = Time.mult
    
    return object
end

function Cutscene:GetVar(varname) 
	return self.Variables[varname]
end

function Cutscene:SetVar(varname,value)
	self.Variables[varname] = value
    return self.Variables[varname]
end

function Cutscene:Stop()
self.Running = false
if self.OnStopped then
self.OnStopped(self)
end
self.TrueElapsed = 0
self.Elapsed = 0
self.ElapsedDelta = 0
self.Phase = 0
end

function Cutscene:Start()
if self.Running then DEBUG("(WARN) Tried to begin cutscene that is already running.") return end
self.TrueElapsedFPS = 0
self.ElapsedFPS = 0
self.ElapsedDelta = 0
self.Running = true

if self.OnStart then
self.OnStart(self)
end

end

function Cutscene:TransitionPhase()
    self.TrueElapsedFPS = 0
    self.ElapsedFPS = 0
    self.ElapsedDelta = 0
    self.Phase = self.Phase + 1
end

function Cutscene:Update()
    if not self.Running then self:Stop() return end
    self.TrueElapsedFPS = self.TrueElapsedFPS + 1
   
    self.ElapsedFPS = self.TrueElapsedFPS * Time.mult
    self.ElapsedDelta = self.ElapsedDelta + Time.dt
    self.OnUpdate(self)
end

return Cutscene

