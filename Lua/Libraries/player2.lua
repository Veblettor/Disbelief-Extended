local Player2 = {}


Player2.SoulMode = "Red"
Player2.Stats = {}
Player2.OBJData = {} -- Table for storing objects used by this library.
Player2.Variables = {} -- Variables stored in the library. You can use :SetVar(name,value) and :GetVar(name) to set and obtain variables respectively.
Player2.Functions = {} -- Functions stored in the library. You can use :AddFunction(name,function) and :Call(function,...) to set and call functions respectively.
Player2.SoulModes = 
{
	Red = 
	{
		Color = {1,0,0};
		Sprite = nil;
		Activated = function(plr2,lastmode)
			plr2.ismoving_custom = false
		end,
		
		Deactivated = function(plr2)
			Player.SetControlOverride(true) 
		end,
		
		OnUpdate = function(plr2)
			
		end,
		
		WaveStart = function(plr2)
			Player.SetControlOverride(false) 
		end,
		
		WaveEnd = function(plr2)
		
		end
		
	}
};
Player2.KREnabled = false -- Determines if KR is enabled or not.
Player2.KRKills = false -- Determines if KR will leave you at 1 HP or fully drain your health if possible.
Player2.kr = 0 -- The current amount of KR the player has.
Player2.maxkr = 40 -- The maximum amount of KR the player can have at a time.
Player2.Elapsed = 0
Player2.WaveElapsed = 0
Player2.iswave = false
Player2.ismoving_custom = false -- this is for different soul control modes since SetControlOverride disables the default ismoving property.


function Player2:GetVar(varname) -- Returns a variable defined in the library.
	return self.Variables[varname]
end

function Player2:SetVar(varname,value) -- Define a variable in the library.
	self.Variables[varname] = value
end

function Player2:AddFunction(funcname,func) -- Add a function to the library.
self.Functions[funcname] = func
end

function Player2:Call(funcname,...) -- Remove a function from the library.
return self.Functions[funcname](...)
end

function Player2:NewSoulMode(name,color,sprite,activated,deactivated,wavestart,waveend,onupdate) -- Create a new soul mode. None of these arguments expect for the name are required. All arguments past "sprite" ask for functions that should be self explanatory based on their names.
local soul = {}

local emptyfunc = function(plr2,lastmode)

end

color = color or {1,1,1}
activated = activated or emptyfunc
deactivated = deactivated or emptyfunc
onupdate = onupdate or emptyfunc
wavestart = wavestart or emptyfunc
waveend = waveend or emptyfunc

soul.Color = color
soul.Sprite = sprite
soul.Activated = activated
soul.Deactivated = deactivated
soul.OnUpdate = onupdate
soul.WaveStart = wavestart
soul.WaveEnd = waveend

self.SoulModes[name] = soul

return soul
end

function Player2:SetSoulMode(mode) -- Sets the player's soul mode. Make sure you define it first before setting it!

if mode ~= self.SoulMode then
local last = self.SoulMode
local soul = self.SoulModes[mode]
if not soul then error("The Soul Mode \""..mode.."\" does not exist. make sure you create it first before calling this function!") end

if soul.Sprite then
Player.sprite = soul.Sprite
end

Player.sprite.color = soul.Color

self.SoulModes[last].Deactivated(self)
soul.Activated(self,last)

if GetCurrentState() == "DEFENDING" then
soul.WaveStart(self)
end


self.SoulMode = mode
end
end

function Player2:PreStart()

end

function Player2:Start() -- Create KR UI elements.
self.OBJData.KRBar = CreateBar(UI.hpbar.fill.absx,UI.hpbar.fill.absy,UI.hpbar.fill.xscale,UI.hpbar.fill.yscale)
self.OBJData.KRBar.background.alpha = 0
self.OBJData.KRBar.background.color = {0,1,0}
self.OBJData.KRBar.fill.color = {1,0,1}
--KRBar.background.layer = "Top"

self.OBJData.KRBar.SetVisible(false)
self.KRLabel = CreateSprite("UI/spr_krname_0")
self.KRLabel.absx = UI.hpbar.background.absx+UI.hpbar.background.xscale+self.KRLabel.width
self.KRLabel.absy = UI.hpbar.background.absy
self.Previous = {HP = Player.hp, MAXHP = Player.maxhp, KR = self.kr}
self.OBJData.KRBar.background.x = UI.hpbar.background.x
self.OBJData.KRBar.background.y = UI.hpbar.background.y
self.KRLabel.alpha = 0

self.OBJData.KRBar.Resize(UI.hpbar.fill.width*UI.hpbar.fill.xscale,20)
--
end

function Player2:ToggleKR(krenabled) -- Toggles KR depending on the boolean you give it.
if krenabled then
self.OBJData.KRBar.SetVisible(true)
self.KRLabel.alpha = 1
--UI.hptext.SetText("[instant]"..self.KRText.." "..Player.hp.." / "..Player.maxhp)
--UI.RepositionHPElements()
else
self.OBJData.KRBar.SetVisible(false)
self.KRLabel.alpha = 0
UI.hptext.SetText("[instant]"..Player.hp.." / "..Player.maxhp)
UI.RepositionHPElements()
end

self.KREnabled = krenabled

end

function Player2:AddKR(amount,bypassmaximum) -- Adds KR.
amount = math.floor(amount)

if self.KRKills then
self.kr = self.kr + amount
elseif Player.hp > 1 then
self.kr = math.min(self.kr+amount,Player.hp-1)
end

if not bypassmaximum then
self.kr = math.min(self.kr,self.maxkr)
end

--DEBUG(self.kr)
--DEBUG(self.kr/Player.hp)
end

function Player2:SetKR(amount,bypassmaximum) -- Sets KR to a specific amount.
amount = math.floor(amount)

if self.KRKills then
self.kr = amount
elseif Player.hp > 1 then
self.kr = math.min(amount,Player.hp-1)
end

if not bypassmaximum then
self.kr = math.min(self.kr,self.maxkr)
end

end

function Player2:WaveStart() -- Called everytime the defense state is triggered, for updating soul modes.
		self.iswave = true
end

function Player2:WaveEnd() -- Called everytime the defense state ends, for updating soul modes.
self.iswave = false
self.WaveElapsed = 0
self.SoulModes[self.SoulMode].WaveEnd(self)
end

function Player2:Update() -- Called every frame during the encounter.
self.Elapsed = self.Elapsed + 1

if self.iswave and self.WaveElapsed < 4 then -- ugly workaround but CYF takes a hot second to properly finish setting the defending state
	self.WaveElapsed = self.WaveElapsed + 1
	if self.WaveElapsed == 2 then
		self.SoulModes[self.SoulMode].WaveStart(self)
	end
end

local drain_thres

if self.kr >= 40 then
drain_thres = 2
elseif self.kr > 29 and self.kr < 40 then
drain_thres = 4
elseif self.kr > 19 and self.kr < 30 then
drain_thres = 10
elseif self.kr < 20 and self.kr > 9 then
drain_thres = 30
elseif self.kr < 10 then
drain_thres = 60
end

if self.KREnabled and self.kr > 0 and self.Elapsed % drain_thres == 0 then
self:AddKR(-1)
Player.Hurt(1,0,true,false)

end


if self.KREnabled then
UI.hptext.SetText("[instant]   "..Player.hp.." / "..Player.maxhp)
if self.kr > 0 then
UI.hptext.SetText("[instant][color:FF00FF]   "..Player.hp.." / "..Player.maxhp)
end
--UI.RepositionHPElements()
end


self.OBJData.KRBar.Resize(UI.hpbar.fill.xscale*(Player.hp/Player.maxhp),UI.hpbar.fill.yscale)

self.KRLabel.absx = UI.hpbar.background.absx+UI.hpbar.background.xscale+self.KRLabel.width
self.KRLabel.absy = UI.hpbar.background.absy+self.KRLabel.height

self.OBJData.KRBar.background.absx = UI.hpbar.fill.absx
self.OBJData.KRBar.background.absy = UI.hpbar.fill.absy
self.OBJData.KRBar.background.SetPivot(1,0)
self.OBJData.KRBar.background.rotation = 180
self.OBJData.KRBar.mask.x = self.OBJData.KRBar.mask.xscale-2
self.OBJData.KRBar.SetInstant((self.kr/Player.hp),true)


self.SoulModes[self.SoulMode].OnUpdate(self)

self.Previous.HP = Player.hp
self.Previous.MAXHP = Player.maxhp
self.Previous.KR = self.kr
end

return Player2
