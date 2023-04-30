-- A basic encounter script skeleton you can copy and modify for your own creations.
--autolinebreak = true
fun = math.random(1,100)

function funevents(event)
local events = {["glitchy"] = 15, [" "] = 2}

return fun < events[event]
end

ffwiz = require "ffwizard"
Player2 = require "player2"
BulletTypes = require "bullet_types"
PapsRig = require "paps_animate"
BG = require "background"
Cutscene = require "cutscene"
CreateLayer("OverTop", "Top", false)
CreateLayer("OverOverTop", "OverTop", false)
Platforms = {}
Cutscenes = {}
flickertimer = 0
flickersprite = CreateSprite("px","OverTop")
flickersprite.color = {0,0,0}
flickersprite.xscale = Misc.WindowWidth
flickersprite.yscale = Misc.WindowHeight
flickersprite.x = 320
flickersprite.y = 240
flickersprite.alpha = 0
static = CreateSprite("Distortion/1","OverOverTop")
static.Scale(2,2)
static.alpha = 0
static:SetAnimation({"1","2","3"},1/30,"Distortion")

cutscenesprite = CreateSprite("px","BelowBullet")
cutscenesprite.color = {0,0,0}
cutscenesprite.xscale = Misc.WindowWidth
cutscenesprite.yscale = Misc.WindowHeight
cutscenesprite.x = 320
cutscenesprite.y = 240
cutscenesprite.alpha = 0


fadinganim = false
didatk = false
phase = 4
progress = 0
legsEaten = 0
papy = nil
atk = 20
 music = "p5_loop" --Either OGG or WAV. Extension is added automatically. Uncomment for custom music.
encountertext = "..." --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"sparing"}
wavetimer = 999
arenasize = {155, 130}
enemies = {
"paps"
}

enemypositions = {
{0, 50}
}

flee = false
grad = nil
function CoolFunction()
	Audio.Unpause()
	grad.Remove()
end


-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
possible_attacks = {"sparing"}

greensoul_bullets = {}
greensoul_blasters = {}
local function RegisterSoulModes()
	local activated = function(plr2,last) -- Blue Soul Functions
		plr2:SetVar("MoveSpeed",2)
		plr2:SetVar("DragX",0)
		plr2:SetVar("DragY",0)
		plr2:SetVar("Jump",4)
		plr2:SetVar("PlatformOffTimer",0)
		plr2:SetVar("AttachedPlatform",nil)
		plr2:SetVar("MaxJump",4.4)
		plr2:SetVar("Gravity",0.12)
		plr2:SetVar("GravityMode","upright")
		plr2:SetVar("YVel",0)
		plr2:SetVar("XVel",0)
		plr2:SetVar("JumpButton",Input.Up)
		plr2:SetVar("LeftButton",Input.Left)
		plr2:SetVar("RightButton",Input.Right)


		local function SetGravityMode(mode) -- Sets the gravity mode.

			plr2:SetVar("GravityMode",mode)
		end

		local function IsGrounded() -- Detects if the player is at the bottom of the arena or on a platform.
			grounded = false
			local direction = plr2:GetVar("GravityMode")

			if direction == "upright" and (Player.y - (Player.sprite.height/2)) > -(Arena.currentheight/2) then

			elseif direction == "rightwall" and (Player.x + (Player.sprite.width/2))  <  (Arena.currentwidth/2)  then

			elseif direction == "leftwall" and (Player.x - (Player.sprite.width/2))  > -(Arena.currentwidth/2) then

			elseif direction == "ceiling" and (Player.y + (Player.sprite.height/2)) <  (Arena.currentheight/2) then

			else
			grounded = true
			end

			local found = false
			for i,bullet in pairs(Platforms) do
			if bullet.isactive and plr2:GetVar("PlatformOffTimer") <= 0 then
				local height = bullet.GetVar("Height") -- 5
				local width = bullet.sprite.width*bullet.sprite.xscale



				local point = bullet.sprite.y + height + plr2:GetVar("DragY")



				local playerbottom = Player.sprite.y - ((Player.sprite.height*Player.sprite.yscale)/2)

				if Player.sprite.x >= bullet.sprite.x - width/2 and Player.sprite.x <= bullet.sprite.x + width/2 and playerbottom <= point and playerbottom > bullet.sprite.y - height - plr2:GetVar("DragY") and plr2:GetVar("YVel") <= math.abs(plr2:GetVar("DragY")) then
					--DEBUG("Attached")
					grounded = true

					local xdrag = bullet.GetVar("XVel") or 0
					local ydrag = bullet.GetVar("YVel") or 0



					if ydrag > 0 then ydrag = 0 end


					plr2:SetVar("DragX",xdrag)
					plr2:SetVar("DragY",ydrag)

					--xvel = xvel + xdrag
					--yvel = yvel + ydrag


					Player.Move(xdrag*Time.mult,point - playerbottom + ydrag*Time.mult)

					plr2:SetVar("AttachedPlatform",bullet)
					plr2:SetVar("YVel",0)
					found = true


				end--]]
			end


			end

			if not found then plr2:SetVar("AttachedPlatform",nil) end

			if not plr2:GetVar("AttachedPlatform") or not grounded then
				plr2:SetVar("DragX",0)
				plr2:SetVar("DragY",0)
			elseif plr2:GetVar("AttachedPlatform") and grounded then
					local xdrag = plr2:GetVar("AttachedPlatform").GetVar("XVel") or 0
					local ydrag = plr2:GetVar("AttachedPlatform").GetVar("YVel") or 0
					plr2:SetVar("DragX",xdrag)
					plr2:SetVar("DragY",ydrag)
			end

			return grounded
		end

		plr2:AddFunction("SetGravityMode",SetGravityMode)
		plr2:AddFunction("IsGrounded",IsGrounded)

	end

	local wavestart = function(plr2) -- Disabling Red Soul Controls
		Player.SetControlOverride(true)
	end

	local waveend = function(plr2) -- Resetting Variables
		plr2:Call("SetGravityMode","upright")
		Player.sprite.rotation = 0
		plr2:SetVar("MoveSpeed",2)
		plr2:SetVar("DragX",0)
		plr2:SetVar("DragY",0)
		plr2:SetVar("Jump",4)
		plr2:SetVar("PlatformOffTimer",0)
		plr2:SetVar("AttachedPlatform",nil)
		plr2:SetVar("MaxJump",4.4)
		plr2:SetVar("Gravity",0.12)
		plr2:SetVar("GravityMode","upright")
		plr2:SetVar("YVel",0)
		plr2:SetVar("XVel",0)
		plr2:SetVar("JumpButton",Input.Up)
		plr2:SetVar("LeftButton",Input.Left)
		plr2:SetVar("RightButton",Input.Right)
	end

	local deactivated = function(plr2) -- Removing variables that are no longer needed.
		plr2:SetVar("MoveSpeed",nil)
		plr2:SetVar("DragX",nil)
		plr2:SetVar("DragY",nil)
		plr2:SetVar("Jump",nil)
		plr2:SetVar("Gravity",nil)
		plr2:SetVar("GravityMode",nil)
		plr2:SetVar("PlatformOffTimer",nil)
		plr2:SetVar("AttachedPlatform",nil)
		plr2:SetVar("JumpButton",nil)
		plr2:SetVar("LeftButton",nil)
		plr2:SetVar("RightButton",nil)
		plr2:SetVar("YVel",nil)
		plr2:SetVar("XVel",nil)
		Player.sprite.rotation = 0
	end

	local update = function(plr2)
		if GetCurrentState() == "DEFENDING" then -- Make sure to only update movement during waves

		local xvel = plr2:GetVar("XVel")
		local yvel = plr2:GetVar("YVel")
		-- Drag the player if they are on a platform
		xvel = xvel + plr2:GetVar("DragX")
		yvel = yvel + plr2:GetVar("DragY")



		local JumpButton
		local LeftButton
		local RightButton


		if Input.Cancel >= 1 then -- Slow the Player if they are pressing X
			plr2:SetVar("MoveSpeed",1)
		else
			plr2:SetVar("MoveSpeed",2)
		end


		local direction = plr2:GetVar("GravityMode",mode) -- Get Gravity Direction

		if direction == "upright" then

		Player.sprite.rotation = 0
		JumpButton = Input.Up
		LeftButton = Input.Left
		RightButton = Input.Right

		if Input.Down > 0 then
			plr2:SetVar("PlatformOffTimer",0.25)
		end

		if plr2:GetVar("PlatformOffTimer") > 0 then
		plr2:SetVar("PlatformOffTimer",plr2:GetVar("PlatformOffTimer")-Time.dt)
		end

		elseif direction == "rightwall" then
		Player.sprite.rotation = 90
		JumpButton = Input.Left
		LeftButton = Input.Down
		RightButton = Input.Up
		elseif direction == "leftwall" then
		Player.sprite.rotation = 270
		JumpButton = Input.Right
		LeftButton = Input.Down
		RightButton = Input.Up
		elseif direction == "ceiling" then
		Player.sprite.rotation = 180
		JumpButton = Input.Down
		LeftButton = Input.Left
		RightButton = Input.Right
		end



			local grounded = plr2:Call("IsGrounded")



			if grounded and JumpButton > 0 then

				if direction == "upright" then
					yvel = plr2:GetVar("Jump")
				elseif direction == "rightwall" then
					xvel = -plr2:GetVar("Jump")
				elseif direction == "leftwall" then
					xvel = plr2:GetVar("Jump")
				elseif direction == "ceiling" then
					yvel = -plr2:GetVar("Jump")
				end--]]
			elseif grounded then
				if direction == "upright" or direction == "ceiling" then
					yvel = 0
				else
					xvel = 0
				end--]]
			end

			if not grounded and JumpButton <= 0 then -- Variable Jump
			if direction == "upright" then

					if yvel > 2 then yvel = 2 end

				elseif direction == "rightwall" then
					if xvel < -2 then xvel = -2 end
				elseif direction == "leftwall" then
					if xvel > 2 then xvel = 2 end
				elseif direction == "ceiling" then
					if yvel < -2 then yvel = -2 end
				end--]]
			end

		if not plr2:GetVar("AttachedPlatform") and not grounded then -- Apply Gravity
			if direction == "upright" then
				yvel = yvel - plr2:GetVar("Gravity")*(Time.mult)
			elseif direction == "rightwall" then
				xvel = xvel + plr2:GetVar("Gravity")*(Time.mult)
			elseif direction == "leftwall" then
				xvel = xvel - plr2:GetVar("Gravity")*Time.mult
			elseif direction == "ceiling" then
				yvel = yvel + plr2:GetVar("Gravity")*Time.mult
			end
		end



		if LeftButton > 0 then
			if direction == "upright" then
			xvel = -plr2:GetVar("MoveSpeed")*Time.mult
			elseif direction == "rightwall" then
			yvel = -plr2:GetVar("MoveSpeed")*Time.mult
			elseif direction == "leftwall" then
			yvel = plr2:GetVar("MoveSpeed")*Time.mult
			elseif direction == "ceiling" then
			xvel = -plr2:GetVar("MoveSpeed")*Time.mult
			end
			plr2.ismoving_custom = true
		end

		if RightButton > 0 then
			if direction == "upright" then
			xvel = plr2:GetVar("MoveSpeed")*Time.mult
			elseif direction == "rightwall" then
			yvel = plr2:GetVar("MoveSpeed")*Time.mult
			elseif direction == "leftwall" then
			yvel = -plr2:GetVar("MoveSpeed")*Time.mult
			elseif direction == "ceiling" then
				xvel = plr2:GetVar("MoveSpeed")*Time.mult
			end
			plr2.ismoving_custom = true
		end

		if RightButton <= 0 and LeftButton <= 0 then
			if direction == "upright" or direction == "ceiling" then
				xvel = 0

				if yvel == 0 then
					plr2.ismoving_custom = false
				end

			else
				yvel = 0

				if xvel == 0 then
					plr2.ismoving_custom = false
				end
			end





		end






		plr2:SetVar("XVel",xvel)
		plr2:SetVar("YVel",yvel)
		if direction == "upright" or direction == "ceiling" then
			Player.Move(xvel,yvel*Time.mult)
		else
			Player.Move(xvel*Time.mult,yvel)
		end
		else

		plr2:SetVar("MoveSpeed",2)
		plr2:SetVar("DragX",0)
		plr2:SetVar("DragY",0)
		plr2:SetVar("Jump",4)
		plr2:SetVar("PlatformOffTimer",0)
		plr2:SetVar("AttachedPlatform",nil)
		plr2:SetVar("Gravity",0.12)
		plr2:SetVar("GravityMode","upright")
		plr2:SetVar("YVel",0)
		plr2:SetVar("XVel",0)
		plr2:SetVar("JumpButton",Input.Up)
		plr2:SetVar("LeftButton",Input.Left)
		plr2:SetVar("RightButton",Input.Right)

		end
	end

	-- Orange Functions
	local o_activated = function(plr2,last)
		plr2:SetVar("Speed",3)
		plr2:SetVar("YVel",0)
		plr2:SetVar("XVel",3)
	end

	local o_wavestart = function(plr2)
		Player.SetControlOverride(true)
	end

	local o_waveend = function(plr2)
		plr2:SetVar("YVel",0)
		plr2:SetVar("XVel",3)
	end

	local o_deactivated = function(plr2)
		plr2:SetVar("Speed",nil)
		plr2:SetVar("YVel",nil)
		plr2:SetVar("XVel",nil)
	end

	local o_update = function(plr2)
	 if GetCurrentState() == "DEFENDING" then
		plr2.ismoving_custom = true
		local spd = plr2:GetVar("Speed")
		if Input.Left > 0 then
		plr2:SetVar("XVel",-spd)
		plr2:SetVar("YVel",0)
		elseif Input.Right > 0 then
		plr2:SetVar("XVel",spd)
		plr2:SetVar("YVel",0)
		elseif Input.Up > 0 then
		plr2:SetVar("YVel",spd)
		plr2:SetVar("XVel",0)
		elseif Input.Down > 0 then
		plr2:SetVar("YVel",-spd)
		plr2:SetVar("XVel",0)
		end

		Player.Move(plr2:GetVar("XVel")*Time.mult,plr2:GetVar("YVel")*Time.mult) -- Nothing that special here, just red soul movement but you are always moving.
      end
	end

	-- Green Functions
	local g_activated = function(plr2,last)
		local circle = CreateSprite("Green Mode","BelowPlayer")
		circle.SetParent(Player.sprite)

		circle.alpha = 0

		local shield = CreateSprite("Shield/1","BelowPlayer")
		shield.SetParent(circle)



		shield.x = 0
		shield.y = 0
		circle.x = 0
		circle.y = 0

		plr2:SetVar("CircleSprite",circle)
		plr2:SetVar("ShieldSprite",shield)
		plr2:SetVar("Facing","Up")
		plr2:SetVar("LastFace","Up")
		plr2:SetVar("TargetAng",0)
		plr2:SetVar("StoredAng",0)
		plr2:SetVar("ShieldCD",0)
		plr2:SetVar("AnimTime",0)
	end

	local g_wavestart = function(plr2)

		local circle = plr2:GetVar("CircleSprite")
		local shield = plr2:GetVar("ShieldSprite")

		circle.alpha = 1
		shield.alpha = 1

		Arena.MoveToAndResize(Misc.WindowWidth/2,Misc.WindowHeight/2-50,75,75,true)
		--Arena.Resize(75,75)
		Player.MoveTo(0,0,true)

		Player.SetControlOverride(true)
	end

	local g_waveend = function(plr2)
		local circle = plr2:GetVar("CircleSprite")
		local shield = plr2:GetVar("ShieldSprite")

		circle.alpha = 0
		shield.alpha = 0
		shield.Set("Shield/1")
		plr2:SetVar("Facing","Up")
		plr2:SetVar("TargetAng",0)
		plr2:SetVar("StoredAng",0)
		plr2:SetVar("ShieldCD",0)
		plr2:SetVar("AnimTime",0)
	end

	local g_deactivated = function(plr2)
		local circle = plr2:GetVar("CircleSprite")
		local shield = plr2:GetVar("ShieldSprite")

		circle.Remove()
		shield.Remove()

		plr2:SetVar("CircleSprite",nil)
		plr2:SetVar("ShieldSprite",nil)
		plr2:SetVar("Facing",nil)
		plr2:SetVar("LastFace",nil)
		plr2:SetVar("TargetAng",nil)
		plr2:SetVar("StoredAng",nil)
		plr2:SetVar("ShieldCD",nil)
		plr2:SetVar("AnimTime",nil)
		Player.SetControlOverride(false)
	end

	local function sign(num)
		if num < 0 then return -1 elseif num > 0 then return 1 else return 0 end
	end

	local g_update = function(plr2)
		if GetCurrentState() == "DEFENDING" then

			Player.MoveTo(0,0,true)

			if plr2:GetVar("ShieldCD") > 0 then plr2:SetVar("ShieldCD",plr2:GetVar("ShieldCD")-Time.dt) elseif plr2:GetVar("ShieldCD") < 0 then plr2:SetVar("ShieldCD",0) end

			local circle = plr2:GetVar("CircleSprite")
			local shield = plr2:GetVar("ShieldSprite")


			if Input.Up == 1 and plr2:GetVar("Facing") ~= "Up" then
				plr2:SetVar("LastFace",plr2:GetVar("Facing"))
				plr2:SetVar("Facing","Up")

				if plr2:GetVar("TargetAng") == -270 then

				plr2:SetVar("TargetAng",-360)

				elseif plr2:GetVar("TargetAng") == 270 then
				plr2:SetVar("TargetAng",360)
				else
				plr2:SetVar("TargetAng",0)
				end


				plr2:SetVar("ShieldCD",0.05)


			end

			if Input.Down == 1 and plr2:GetVar("Facing") ~= "Down" then
				plr2:SetVar("LastFace",plr2:GetVar("Facing"))
				plr2:SetVar("Facing","Down")


				if plr2:GetVar("TargetAng") == -90 or plr2:GetVar("TargetAng") == -270 then
					plr2:SetVar("TargetAng",-180)
					else
					plr2:SetVar("TargetAng",180)
				end

				plr2:SetVar("ShieldCD",0.05)

			end

			if Input.Left == 1 then

				plr2:SetVar("LastFace",plr2:GetVar("Facing"))
				plr2:SetVar("Facing","Left")
				if plr2:GetVar("TargetAng") == -180 then
					plr2:SetVar("TargetAng",-270)
					else
					plr2:SetVar("TargetAng",90)
				end

				plr2:SetVar("ShieldCD",0.05)

			end





			if Input.Right == 1 then
				plr2:SetVar("LastFace",plr2:GetVar("Facing"))
				plr2:SetVar("Facing","Right")


				if plr2:GetVar("TargetAng") == 180 then
					plr2:SetVar("TargetAng",270)
					else
					plr2:SetVar("TargetAng",-90)
				end

				plr2:SetVar("ShieldCD",0.05)

			end




			if plr2:GetVar("StoredAng") < plr2:GetVar("TargetAng") then
				plr2:SetVar("StoredAng",math.min(plr2:GetVar("StoredAng")+(20*Time.mult),plr2:GetVar("TargetAng")))
			elseif plr2:GetVar("StoredAng") > plr2:GetVar("TargetAng") then
				plr2:SetVar("StoredAng",math.max(plr2:GetVar("StoredAng")-(20*Time.mult),plr2:GetVar("TargetAng")))
			end

			if plr2:GetVar("StoredAng") == 360 or plr2:GetVar("StoredAng") == -360 then
				plr2:SetVar("TargetAng",0)
				plr2:SetVar("StoredAng",0)
			end

			--[[DEBUG(plr2:GetVar("StoredAng"))
			DEBUG("LAST: "..plr2:GetVar("LastFace"))
			DEBUG("CURRENT: "..plr2:GetVar("Facing"))--]]
			shield.rotation = plr2:GetVar("StoredAng")

			local coords = {0,35}


			if plr2:GetVar("Facing") == "Down" then
				coords = {0,-35}
			elseif plr2:GetVar("Facing") == "Left" then
				coords = {-35,0}
			elseif plr2:GetVar("Facing") == "Right" then

				coords = {35,0}

			end

			if plr2:GetVar("ShieldCD") <= 0 then
			for i,v in pairs(greensoul_bullets) do
				if v.isactive then
				local target = v

				local offsetx = target.GetVar("XOffset") or 0
				local offsety = target.GetVar("YOffset") or 0

				local xDifference = coords[1] - (target.x + offsetx);
				local yDifference = coords[2] - (target.y + offsety);
				local distance = math.sqrt(xDifference*xDifference+yDifference*yDifference);

				if distance <= 8 then
					BulletTypes:HandleShieldCollision(target)
					plr2:SetVar("AnimTime",1/6)
					shield.Set("Shield/2")
				end

				end
			end

			end



			if plr2:GetVar("AnimTime") > 0 then

				plr2:SetVar("AnimTime",plr2:GetVar("AnimTime")-Time.dt)

				if plr2:GetVar("AnimTime") <= 0 then
					plr2:SetVar("AnimTime",0)
					shield.Set("Shield/1")
				end

			end

		end
	end

	-- Register them.
	Player2:NewSoulMode("Blue",{0,0,1},nil,activated,deactivated,wavestart,waveend,update)
	Player2:NewSoulMode("Orange",{1,0.5,0},nil,o_activated,o_deactivated,o_wavestart,o_waveend,o_update)
	Player2:NewSoulMode("Green",{0,1,0},nil,g_activated,g_deactivated,g_wavestart,g_waveend,g_update)
end -- End of soul registry


function GetGSoulFacing() -- scriptcommunication.jpeg
	return Player2:GetVar("Facing")
end

local function RegisterBulletTypes()
	-- For registering different "types" of bullets that will react on collision differently. Mainly to help with communication between the player2 library and waves.
	local function platformHit(bullet)

	--[[local height = bullet.GetVar("Height") -- 5
	
	local point = bullet.sprte.y + height

	local playerbottom = player.sprite.y - ((player.sprite.height*player.sprite.yscale)/2)
	
	if playerbottom >= point then
	
	end--]]

	end

	local function kr1(bullet)
		Player.Hurt(atk,1,true,true)
		--Player2:AddKR(1)
	end

	local function krDontKill(bullet)
		if Player.hp > atk then
		Player.Hurt(atk,1,true,true)
		else
			Player.Hurt(Player.hp-1,1,true,true)
		end
		--Player2:AddKR(1)
	end

	local function krS(bullet)
		Audio.PlaySound("ding")
		bullet.Remove()
	end

	local function krSB(bullet)
	end

	local function bluekrshb(bullet)
		Player.Hurt(atk,1,true,true)

	end

	local function bluekr(bullet)
		if (Player2.SoulMode == "Red" and Player.ismoving) or (Player2.SoulMode ~= "Red" and Player2.ismoving_custom) then
			Player.Hurt(atk,1,true,true)
			--Player2:AddKR(1)
		end
	end

	local function bluekrsh(bullet)
		Player.Hurt(atk,1,true,true)
		bullet.Remove()
	end

	local function orangekr(bullet)
		if (Player2.SoulMode == "Red" and not Player.ismoving) or (Player2.SoulMode ~= "Red" and not Player2.ismoving_custom) then
			Player.Hurt(atk,1,true,true)
			--Player2:AddKR(1)
		end
	end

	BulletTypes:NewType("kr1",kr1,krS)
	BulletTypes:NewType("krDontKill",krDontKill,krS)
	BulletTypes:NewType("krB",bluekr,bluekrsh)
	BulletTypes:NewType("krO",orangekr,krS)
	BulletTypes:NewType("platform",platformHit)
	BulletTypes:NewType("Blaster",kr1,krSB)
	BulletTypes:NewType("BlasterBlue",bluekr,bluekrshb)
end -- End of bullet registry

function AddCutscene(id,update,stop,start)
	local new = Cutscene.new(update,stop,start)
	Cutscenes[id] = new
end

local function lerp(a,b,t)
	return a + (b - a) * t
end

function TransitionCutscene(id)
	Cutscenes[id]:TransitionPhase()
end

function dieidiot()

	local wave
	for i,v in pairs(Wave) do
		if v.scriptname == "p8_final" then
			wave = v
		end
	end

	wave.Call("die")
	--wave["killblastera"].Fire()
	--wave["killblasterb"].Fire()
end

function startkilling()
	local wave
	for i,v in pairs(Wave) do
		if v.scriptname == "p8_final" then
			wave = v
		end
	end

	wave.Call("startkilling")
end

local function RegisterCutscenes()
	local spareupdate = function(self)
		flickersprite.alpha = flickersprite.alpha + Time.mult/60


		local picture = self:GetVar("pic")

		if self.ElapsedDelta >= 1 and not picture then
			Audio.Stop()
			picture = self:SetVar("pic",CreateSprite("end...questionmark","OverOverTop"))
			picture.x = 320
			picture.y = 320
			picture.Scale(2,2)
			picture.alpha = 0
			--enemies[1]["currentdialogue"] = {"[noskip][w:99999999999][next]"}
			--State("ENEMYDIALOGUE")		
		end

		if self.ElapsedDelta >= 1.5 and self.ElapsedDelta < 6.666667 and picture and picture.isactive then
			picture.alpha = picture.alpha + Time.mult/60
		end

		if self.ElapsedDelta > 6.666667 and picture and picture.isactive then
			picture.alpha = picture.alpha - Time.mult/60
		end

		if self.ElapsedDelta > 8.333333 then
			State("DONE")
		end
	end

	local sparestopped = function(self)
		flickersprite.alpha = 0
		local picture = self:GetVar("pic")

		if picture and picture.isactive then picture.Remove() end
		self:SetVar("pic",nil)
	end

	local blockstart = function(self)
		self:SetVar("blockgoingleft",true)
		if phase == 5 then
			local bonespr = self:SetVar("BoneSpr",CreateSprite("Bones/bone_block","BelowBullet"))
			bonespr.rotation = 0
			bonespr.alpha = 0
			bonespr.x = 320
			bonespr.y = 330
			Audio.PlaySound("spawn",1)
		elseif phase == 6 then

			if progress < 6 then
			static.alpha = 0.5
			end


		elseif phase == 7 then

			if fadinaway then
				SetHead("Phase 7/fading ouch")
			else
				SetHead("Phase 5/tired3")
			end


		elseif phase == 8 then

		end
	end

	local blockstop = function(self)
		self:SetVar("blockgoingleft",nil)
		if phase == 5 then
			self:SetVar("hitf",nil)
			local bonespr = self:GetVar("BoneSpr")

			if bonespr and bonespr.isactive then
				bonespr.Remove()
				self:SetVar("BoneSpr",nil)
			end

		elseif phase == 6 then

			static.alpha = 0
			self:SetVar("blockgoingleft",nil)
			PapsRig.Legs.x = 320

		elseif phase == 7 then

			if progress < 7 then
				if fadinaway then
					SetHead("Phase 7/fading")
				else
					SetHead("Phase 5/downed")
				end
			end

			PapsRig.Legs.x = 320

		elseif phase == 8 then
			PapsRig.Legs.x = 320
		end
	end

	local blockupdate = function(self)
		if phase == 5 then
			local bonespr = self:GetVar("BoneSpr")

			if self.ElapsedDelta <= 0.75 then
				bonespr.rotation = bonespr.rotation + 4*Time.mult
				bonespr.alpha = bonespr.alpha + Time.mult/30
			end

			if self.ElapsedDelta > 0.75 then
				bonespr.rotation = 0
			end

			if self.ElapsedDelta >= 1.083333 and not self:GetVar("hitf") then
				self:SetVar("hitf",true)
				Audio.PlaySound("hitsound")
			end

			if self.ElapsedDelta > 1.083333 and self.ElapsedDelta < 1.666667 then

			if bonespr.x < 316.1 then
				self:SetVar("blockgoingleft",false)
			elseif bonespr.x > 324.9 then
				self:SetVar("blockgoingleft",true)
			end

			if self:GetVar("blockgoingleft") then
				bonespr.x = lerp(bonespr.x, 315,0.8*Time.mult)
			else
				bonespr.x = lerp(bonespr.x, 325,0.8*Time.mult)
			end


			elseif self.ElapsedDelta > 2 and self.ElapsedDelta < 2.516667 then
				bonespr.alpha = bonespr.alpha - Time.mult/30
			end

			if self.ElapsedDelta >= 2.516667 then
				self:Stop()
			end

			elseif phase == 6 then

				if self.ElapsedDelta < 2 then
					if PapsRig.Legs.x < 315.1 then
						self:SetVar("blockgoingleft",false)
					elseif PapsRig.Legs.x > 324.9 then
						self:SetVar("blockgoingleft",true)
					end

					if self:GetVar("blockgoingleft") then
						PapsRig.Legs.x = lerp(PapsRig.Legs.x,315,0.75*Time.mult)
					else
						PapsRig.Legs.x = lerp(PapsRig.Legs.x,325,0.75*Time.mult)
					end

				elseif self.ElapsedDelta >= 2 then
					blockgoingleft = true
					PapsRig.Legs.x = lerp(PapsRig.Legs.x,320,0.75*Time.mult)
				end

				if self.ElapsedDelta >= 2 then
					self:Stop()
				end

			elseif phase == 7 then

				if enemies[1]["talkcount"] > 0 then
					cutscenesprite.alpha = 1
				end

				if self.ElapsedDelta < 1.333333 then
					if PapsRig.Legs.x < 315.1 then
						self:SetVar("blockgoingleft",false)
					elseif PapsRig.Legs.x > 324.9 then
						self:SetVar("blockgoingleft",true)
					end

					if self:GetVar("blockgoingleft") then
						PapsRig.Legs.x = lerp(PapsRig.Legs.x,315,0.75*Time.mult)
					else
						PapsRig.Legs.x = lerp(PapsRig.Legs.x,325,0.75*Time.mult)
					end

				elseif self.ElapsedDelta >= 1.333333 then
					self:SetVar("blockgoingleft",true)
					PapsRig.Legs.x = lerp(PapsRig.Legs.x,320,0.75*Time.mult)
				end

				if self.ElapsedDelta >= 1.5 and enemies[1]["talkcount"] < 1 then
					enemies[1]["hp"] = 0
					self:Stop()
				elseif self.ElapsedDelta >= 1.666667 and not self:GetVar("endf1") then
					self:SetVar("endf1",true)
					PapsRig.Legs.x = 320
					PapsRig:Dust()
					enemies[1]["currentdialogue"] = {"[noskip][w:999999][next]"}
					State("ENEMYDIALOGUE")
				end


				if self.ElapsedDelta >= 6.666667 and enemies[1]["talkcount"] >= 1 and not self:GetVar("endf2") then
					self:SetVar("endf2")
					local t = CreateText("[color:FFFFFF]TO BE CONTINUED...",{200,320},300,"OverOverTop")
					SetAlMightyGlobal("papyrusdisbeliefex_checkpoint",0)
					t.HideBubble()
				end

				if self.ElapsedDelta >= 9.333333 and enemies[1]["talkcount"] >= 1 then
					State("DONE")
				end

			elseif phase == 8 then

				if self.ElapsedDelta < 1.333333 then
					if PapsRig.Legs.x < 315.1 then
						self:SetVar("blockgoingleft",false)
					elseif PapsRig.Legs.x > 324.9 then
						self:SetVar("blockgoingleft",true)
					end

					if self:GetVar("blockgoingleft") then
						PapsRig.Legs.x = lerp(PapsRig.Legs.x,315,0.75*Time.mult)
					else
						PapsRig.Legs.x = lerp(PapsRig.Legs.x,325,0.75*Time.mult)
					end

				elseif self.ElapsedDelta >= 1.333333 then
					self:SetVar("blockgoingleft",true)
					PapsRig.Legs.x = lerp(PapsRig.Legs.x,320,0.75*Time.mult)
				end


				if self.ElapsedDelta >= 1.5 then
					self:Stop()
				end


			end
	end


	local p5introstart = function(self)
		flickersprite.alpha = 1
		cutscenesprite.alpha = 1
		PapsRig:SetAnimation("Rest")
		enemies[1].SetVar("currentdialogue",{"[noskip][w:120][next]","[noskip][waitall:2][func:sethead,Phase 4/Thinking]I...","[noskip][waitall:2][func:sethead,Phase 4/huh]I EXPECTED THIS.", "[noskip][w:13][next]","[noskip][waitall:2][func:sethead,Phase 4/...]...", "[noskip][waitall:2]BUT...", "[noskip][waitall:2][func:sethead,Phase 4/Please]I CAN'T LET YOU\nGO NOW.", "[noskip][waitall:2]EVEN AFTER I\nFAILED TO\nSAVE YOU.", "[noskip][waitall:1][func:sethead,Phase 4/NO!]I'M SORRY,[w:4] BUT\nYOU CANNOT BE\nREDEEMED.", "[noskip][waitall:3][func:sethead,Phase 4/...]I'M GOING TO\nEND THIS.","[noskip][func:phase5begin][w:210][next]", "[noskip]FORGIVE ME FOR\nTHIS.[w:50][next]","[noskip][w:110][next]","[func:State,DEFENDING]"})
	end

	local p5introupdate = function(self)
		if self.Phase == 0 then

			if self.ElapsedDelta >= 0.5 and not self:GetVar("hitf") then
				self:SetVar("hitf",true)
				Audio.PlaySound("hitsound")
			end

			local bonespr = self:GetVar("BoneSpr")

			if self.ElapsedDelta >= 4.833333 and not bonespr then
				enemies[1]["monstersprite"].layer = "Top"
				PapsRig:SetLayer("Top")
				bonespr = self:SetVar("BoneSpr",CreateSprite("Bones/bone_block","Top"))
				bonespr.y = 330
			end

			if self.ElapsedDelta >= 7 then
				self:SetVar("cyclecomplete",true)
				bonespr.alpha = bonespr.alpha - Time.mult/30
			end

			if self.ElapsedDelta >= 5 and not self:GetVar("cyclecomplete") then
				flickersprite.alpha = flickersprite.alpha - Time.mult/30
				bonespr.rotation = bonespr.rotation + 90*Time.dt
			end

		else

			if self.ElapsedDelta >= 6.333333 and not self:GetVar("BGf") then
				self:SetVar("BGf",true)
				BG.Sprite.layer = "Top"
				BG:SetColor({1,0.5,0})
				BG:SetActive(true)
			end

			if self.ElapsedDelta >= 9 then
				flickersprite.alpha = flickersprite.alpha + Time.mult/60
			end

			if self.ElapsedDelta >= 10.16667 and not self:GetVar("legf") then
				self:SetVar("legf",true)
				PapsRig.Legs.y = 200
			end



			if self.ElapsedDelta > 18.41667 and self.ElapsedDelta < 19.75 then
				flickersprite.alpha = flickersprite.alpha - Time.mult/30
				PapsRig.Legs.y = lerp(PapsRig.Legs.y,330,0.033*Time.mult)
			end

			if self.ElapsedDelta >= 19.75 and not self:GetVar("statf")  then
				self:SetVar("statf",true)
				flickersprite.color = {1,1,1}
				flickersprite.alpha = 1
				cutscenesprite.alpha = 0
				PapsRig.Legs.y = 330
				BG.Sprite.layer = "BelowUI"
				enemies[1]["canspare"] = false
				enemies[1]["atk"] = 90
				enemies[1]["def"] = 20
				enemies[1]["comments"] = {"No more puzzles.", "Papyrus is holding back.", "Papyrus is reluctant to end you.", "Papyrus is doubting himself."}
			end

			if self.ElapsedDelta > 19.75 and self.ElapsedDelta < 20.01667 then
				flickersprite.alpha = flickersprite.alpha - Time.mult/15
			end

			if  self.ElapsedDelta > 20.01667 then
				phase = 5
				SetAlMightyGlobal("papyrusdisbeliefex_checkpoint",1)
				PapsRig:SetLayer("BelowBullet")
				encountertext = "No more puzzles."
				enemies[1]["monstersprite"].layer = "Top"
				enemies[1]["check"] = "[w:4]Reluctant to finish the job.[w:4]\nDon't give him the chance."
				self:Stop()
			end

		end
	end

	local p5introstop = function(self)
		if self:GetVar("BoneSpr") and self:GetVar("BoneSpr").isactive then
			self:GetVar("BoneSpr").Remove()
		end
		self.Variables = {}
		flickersprite.alpha = 0
		flickersprite.color = {0,0,0}
	end

	local p5endstart = function(self)
		flickersprite.alpha = 1
		cutscenesprite.alpha = 1
		papy.alpha = 1
		self:SetVar("g",0)
		self:SetVar("g2",0)
		if not funevents(" ") then
			PapsRig:SetVisible(false)
		end
		BG:SetActive(false)
	end

	local p5endupdate = function(self)
		if self.Phase == 0 then
			if self.ElapsedDelta >= 1 and not self:GetVar("disableui") then
				self:SetVar("disableui",true)
				UI.StopUpdate(false)
				flickersprite.alpha = 0
				cutscenesprite.alpha = 0
				Arena.Hide()
				UI.mercybtn.alpha = 0
				UI.actbtn.alpha = 0
				UI.itembtn.alpha = 0
				UI.fightbtn.alpha = 0
				UI.hplabel.alpha = 0
				UI.hptext.alpha = 0
				UI.namelv.alpha = 0
				UI.hpbar.background.alpha = 0
				UI.hpbar.fill.alpha = 0
				Player.sprite.alpha = 0
			end

			if self.ElapsedDelta < 1.5 and self.ElapsedDelta > 1 then

				if papy.x < 315.1 then
					self:SetVar("blockgoingleft",false)
				elseif papy.x > 324.9 then
					self:SetVar("blockgoingleft",true)
				end

				if self:GetVar("blockgoingleft") then
					papy.x = lerp(papy.x,315,0.25*Time.mult)
				else
					papy.x = lerp(papy.x,325,0.25*Time.mult)
				end

				elseif self.ElapsedDelta >= 1.5 and papy.isactive then
					self:SetVar("blockgoingleft",true)
					papy.x = lerp(papy.x,320,0.25*Time.mult)
				end

				if self.ElapsedDelta >= 1.5 and not self:GetVar("f1") then
					self:SetVar("f1",true)
					--(enemies[1]).Call("bubble",{0,25})
					enemies[1]["monstersprite"].y = 251.5
					enemies[1]["currentdialogue"] = {"[noskip][w:150][next]","[noskip][waitall:1.5]WHAT JUST\nHAPPENED?","[noskip][waitall:1.5]I...","[noskip][func:sethead,Phase 5/huh][func:phase6begin][w:1000000][next]"}
					BattleDialog({"[noskip][waitall:3][voice:v_papyrus][font:papyrus][color:FFFFFF]WHY?[w:20][next]","[noskip][waitall:3][voice:v_papyrus][font:papyrus][color:FFFFFF]WITHOUT A REASON...[w:20][next]", "[noskip][waitall:3][voice:v_papyrus][font:papyrus][color:FFFFFF]YOU [color:FF0000]SLAUGHTERED[color:FFFFFF] EVERY LAST ONE OF US.[w:20][next]","[noskip][waitall:8][voice:none][font:papyrus][color:FFFFFF]...[w:40][next]", "[noskip][waitall:4][voice:v_papyrus][font:papyrus][color:FFFFFF]I DON'T UNDERSTAND...[w:90][font:uidialog][func:State,ENEMYDIALOGUE]"})
			end

			if papy.isactive and self.ElapsedDelta > 2.833333 then
				papy.yscale = lerp(papy.yscale,0.8,0.25*Time.mult)
				papy.y = lerp(papy.y,300,0.2*Time.mult)
			end

			if self.ElapsedDelta >= 3 then
				local sbone

				if not self:GetVar("sbone") then
					sbone =  self:SetVar("sbone",CreateSprite("Bones/SharpBone","OverOverTop"))
					sbone.SetPivot(0.85,0.35)
					sbone.x = PapsRig.Arms.Right.absx
					sbone.y = PapsRig.Arms.Right.absy
					Audio.PlaySound("click")
					Audio.PlaySound("transform")
					papy.Remove()
					PapsRig:SetVisible(true)
					PapsRig:SetAnimation("Phase 5 Hit")
				else
					sbone = self:GetVar("sbone")
				end

				sbone.alpha = sbone.alpha - Time.mult/30
				sbone.yscale = sbone.yscale + 0.025*Time.mult
			end


			if self.ElapsedDelta >= 26.16667 and Audio.isplaying then
				Audio.Stop()
			end

			if self.ElapsedDelta >= 26.3 and not self:GetVar("attackf") then
				self:SetVar("attackf",true)
				flickersprite.alpha = 1

				Audio.PlaySound("slice")
				enemies[1]["fake_atksprite"].y = 300
				enemies[1]["fake_atksprite"].SetAnimation({"spr_slice_o_0","spr_slice_o_1","spr_slice_o_2","spr_slice_o_3","spr_slice_o_4","spr_slice_o_5"},1/10,"UI/Battle")
			end

			local wingdings

			if self.ElapsedDelta > 26.5 then

				if not self:GetVar("wingdings") then
					wingdings = self:SetVar("wingdings",{})
				else
					wingdings = self:GetVar("wingdings")
				end

				for i,v in pairs(wingdings) do
					if v.isactive then
					v.xscale = v.xscale + 0.4*Time.mult
					v.yscale = v.yscale + 0.4*Time.mult
					v.alpha = v.alpha - Time.mult/30

					end
				end

			end

			if self.ElapsedDelta >= 26.5 and self:GetVar("g") == 0 then
				self:SetVar("g",self:GetVar("g")+1)
				Audio.PlaySound("ding")
				local g = CreateSprite("WingDings/thumbs_down","OverOverTop")
				g.y = 200
				g.x = 280
				table.insert(wingdings,g)
			elseif self.ElapsedDelta >= 26.5+1/6 and self:GetVar("g") == 1  then
				self:SetVar("g",self:GetVar("g")+1)
				Audio.PlaySound("ding")
				local g = CreateSprite("WingDings/open_hand","OverOverTop")
				g.y = 200
				g.x = 340
				table.insert(wingdings,g)
			elseif self.ElapsedDelta >= 26.5+2/6 and self:GetVar("g") == 2 then
				self:SetVar("g",self:GetVar("g")+1)
				Audio.PlaySound("ding")
				local g = CreateSprite("WingDings/point_left","OverOverTop")
				g.y = 200
				g.x = 400
				table.insert(wingdings,g)
			elseif self.ElapsedDelta >= 26.5+3/6 and self:GetVar("g") == 3  then
				self:SetVar("g",self:GetVar("g")+1)
				Audio.PlaySound("spawn")
				local ghand = self:SetVar("ghand",CreateSprite("gaster_hand","Top"))
				ghand.Scale(1.5,1.5)
				ghand.y = 290
			end


			if self.ElapsedDelta >= 26.5+2/3 and not self:GetVar("hitf") then
				self:SetVar("hitf",true)
				Audio.PlaySound("hitsound")
				PapsRig:SetVisible(false)
			end

			if self.ElapsedDelta > 29.66667 and self.ElapsedDelta < 30.83333 then
				flickersprite.alpha = flickersprite.alpha - Time.mult/60
			end

			if self.ElapsedDelta > 32.83333 then
				PapsRig:SetAlpha(PapsRig.Legs.alpha + Time.mult/60)
			end

			if self.ElapsedDelta > 34.58333 then
				local ghand = self:GetVar("ghand")
				ghand.alpha = ghand.alpha - Time.mult/30
			end

		else
			local wingdings = self:GetVar("wingdings")
				if self.ElapsedDelta < 1/12 then
					wingdings = self:SetVar("wingdings",{})
					flickersprite.alpha = 0
					cutscenesprite.alpha = 0
					if papy.isactive then
					papy.alpha = 0
					papy.Remove()
					end
					if not funevents(" ") then
						PapsRig:SetVisible(true)
					end
				end
				for i,v in pairs(wingdings) do
					if v.isactive then
						v.xscale = v.xscale + 0.2*Time.mult
						v.yscale = v.yscale + 0.2*Time.mult
						v.alpha = v.alpha - Time.mult/30
					end
				end


				if self.ElapsedDelta >= 1/12 and self:GetVar("g2") == 0 then

					self:SetVar("g2",1)
					Audio.PlaySound("ding")
					local g = CreateSprite("WingDings/moon","OverOverTop")

					g.y = 200
					g.absx = 160
					table.insert(wingdings,g)
				elseif self.ElapsedDelta >= 1/6 and self:GetVar("g2") == 1 then
					self:SetVar("g2",2)
					Audio.PlaySound("ding")
					local g = CreateSprite("WingDings/point_left","OverOverTop")
					g.y = 200
					g.absx = 200
					table.insert(wingdings,g)
				elseif self.ElapsedDelta >= 3/12 and self:GetVar("g2") == 2 then
					self:SetVar("g2",3)
					Audio.PlaySound("ding")
					local g = CreateSprite("WingDings/sun","OverOverTop")
					g.y = 200
					g.absx = 240
					table.insert(wingdings,g)
				elseif self.ElapsedDelta >= 2/6 and self:GetVar("g2") == 3 then
					self:SetVar("g2",4)
					Audio.PlaySound("ding")
					local g = CreateSprite("WingDings/flag","OverOverTop")
					g.y = 200
					g.absx = 280
					table.insert(wingdings,g)
				elseif self.ElapsedDelta >= 5/12 and self:GetVar("g2") == 4 then
					self:SetVar("g2",5)
					Audio.PlaySound("ding")
					local g = CreateSprite("WingDings/neutral_face","OverOverTop")
					g.y = 200
					g.absx = 320
					table.insert(wingdings,g)
				elseif self.ElapsedDelta >= 0.5 and self:GetVar("g2") == 5 then
					self:SetVar("g2",6)
					Audio.PlaySound("ding")
					local g = CreateSprite("WingDings/peace","OverOverTop")
					g.y = 200
					g.absx = 360
					table.insert(wingdings,g)
				elseif self.ElapsedDelta >= 7/12 and self:GetVar("g2") == 6 then
					self:SetVar("g2",7)
					Audio.PlaySound("ding")
					local g = CreateSprite("WingDings/leo","OverOverTop")
					g.y = 200
					g.absx = 400
					table.insert(wingdings,g)
				end

				if self.ElapsedDelta >= 4/6 and not self:GetVar("staticf") then
					self:SetVar("staticf",true)
					Audio.LoadFile("static_mus")
					Audio.PlaySound("hitsound")
					SetHead("Phase 5/glitch")
					Misc.ShakeScreen(math.floor(190/Time.mult),  6, false)

					static.alpha = 0.5
				end

				if self.ElapsedDelta > 1.1 and self.ElapsedDelta < 4.9 then

					if PapsRig.Legs.x < 315.1 then
						self:SetVar("blockgoingleft",false)
					elseif PapsRig.Legs.x > 324.9 then
						self:SetVar("blockgoingleft",true)
					end

					if self:GetVar("blockgoingleft") then
						PapsRig.Legs.x = lerp(PapsRig.Legs.x,315,0.75*Time.mult)
					else
						PapsRig.Legs.x = lerp(PapsRig.Legs.x,325,0.75*Time.mult)
					end

				elseif self.ElapsedDelta >= 4.9 then
					self:SetVar("blockgoingleft",true)
					PapsRig.Legs.x = lerp(PapsRig.Legs.x,320,0.75*Time.mult)
				end

				if self.ElapsedDelta >= 5 and not self:GetVar("f2") then
					self:SetVar("f2",true)
					PapsRig:SetVisible(false)
					static.alpha = 0
					Audio.Stop()
				end

				if self.ElapsedDelta>= 9 and not self:GetVar("standup") then
						self:SetVar("standup",true)
						Audio.LoadFile("p6_intro")
						Audio.PlaySound("click")
						if not funevents(" ") then
							PapsRig:SetAnimation("Phase 6 Idle")
						end
				end

				local p6_eye = self:GetVar("p6eye")
				if self.ElapsedDelta >= 10.83333 and not p6_eye then
					p6_eye = self:SetVar("p6eye",CreateSprite("Papyrus/Head/p6_eye","OverOverTop"))
					p6_eye.y = PapsRig.Head.absy
					p6_eye.x = PapsRig.Head.absx
					p6_eye.alpha = 0
				end

				if self.ElapsedDelta >= 19.81667 and not self:GetVar("eyef") then
					self:SetVar("eyef",true)
					p6_eye.alpha = 1
					Audio.PlaySound("transform")
				end

				if self.ElapsedDelta > 19.83333 then
					p6_eye.Scale(p6_eye.xscale+(0.2*Time.mult),p6_eye.yscale+(0.2*Time.mult))
					p6_eye.alpha = p6_eye.alpha - Time.mult/30
				end

				if self.ElapsedDelta >= 20.5 and (not GetAlMightyGlobal("papyrusdisbeliefex_checkpoint") or GetAlMightyGlobal("papyrusdisbeliefex_checkpoint") < 2) then
					SetAlMightyGlobal("papyrusdisbeliefex_checkpoint",2)
				end

				if self.ElapsedDelta > 20.5 then
					UI.namelv.alpha = UI.namelv.alpha + Time.mult/60
					UI.hplabel.alpha = UI.hplabel.alpha + Time.mult/60
					UI.hptext.alpha = UI.hptext.alpha + Time.mult/60
					UI.hpbar.background.alpha = UI.hpbar.background.alpha + Time.mult/60
					UI.hpbar.fill.alpha = UI.hpbar.fill.alpha + Time.mult/60
				end

				if self.ElapsedDelta >= 22 and not self:GetVar("uiff") then
					self:SetVar("uiff",true)
					UI.StopUpdate(false)
				end

				if self.ElapsedDelta > 23.5 then
					UI.fightbtn.alpha = UI.fightbtn.alpha + Time.mult/60
				end

				if self.ElapsedDelta > 26 then
					UI.actbtn.alpha = UI.actbtn.alpha + Time.mult/60
				end

				if self.ElapsedDelta > 28.5 then
					UI.itembtn.alpha = UI.itembtn.alpha + Time.mult/60
				end

				if self.ElapsedDelta > 31 then
					UI.mercybtn.alpha = UI.mercybtn.alpha + Time.mult/60
				end

				local arenamask = self:GetVar("arenamask")

				if self.ElapsedDelta >= 32 and not arenamask then
					arenamask = self:SetVar("arenamask",CreateSprite("px","OverOverTop"))
					arenamask.yscale = Arena.height+15
					arenamask.xscale = 999
					arenamask.x = Arena.x
					arenamask.y = Arena.y+(Arena.height/2)+5
					arenamask.color = {0,0,0}
					Arena.Show()
				end

				if self.ElapsedDelta > 32 and arenamask then
					arenamask.alpha = arenamask.alpha - Time.mult/60
				end

				if self.ElapsedDelta > 34.33333 then
					Player.sprite.alpha = Player.sprite.alpha + Time.mult/30
				end

				if self.ElapsedDelta >= 34.83333 and not self:GetVar("endff") then
					self:SetVar("endff",true)


					nextwaves = {"p6_1"}
					phase = 6
					progress = 0
					waveProgress = 1

					State("DEFENDING")
					Audio.LoadFile("p6_loop")
					atk = 20
					enemies[1]["canspare"] = false
					enemies[1]["check"] = "[w:4]Seems to be enchanted by\ra mysterious force."
					enemies[1]["atk"] = 115
					enemies[1]["def"] = -2147483648

					if funevents(" ") then
						enemies[1]["comments"] = {"Prunsel wears a fraught\rexpression.", "Prunsel looks through you.", "..."}
					else
						enemies[1]["comments"] = {"Papyrus wears a fraught\rexpression.", "Papyrus looks through you.", "..."}
					end


					self:Stop()
				end


		end
	end

	local p5endstop = function(self)
		local wingdings = self:GetVar("wingdings")

		if wingdings then
			for i,v in pairs(wingdings) do
				if v.isactive then v.Remove() end
			end
		end

		if self:GetVar("ghand") and self:GetVar("ghand").isactive then
			self:GetVar("ghand").Remove()
		end

		if self:GetVar("sbone") and self:GetVar("sbone").isactive then
			self:GetVar("sbone").Remove()
		end

		if self:GetVar("arenamask") and self:GetVar("arenamask").isactive then
			self:GetVar("arenamask").Remove()
		end



		self.Variables = {}

		BG.Sprite.layer = "BelowUI"
		BG:SetColor({1,0.5,0})
		BG:SetActive(true)
		cutscenesprite.alpha = 0
		flickersprite.alpha = 0


		PapsRig:SendToBottom()
		enemies[1]["monstersprite"].y = 281.5
	end

	local p6tiredstart = function(self)
		PapsRig:SetAnimation("Phase 5 Idle")
		SetHead("Phase 6/tired")
	end

	local p6tiredupdate = function(self)


		if (self.ElapsedDelta < 0.5) or (self.ElapsedDelta > 6 and self.ElapsedDelta < 6.5) or (self.ElapsedDelta > 12 and self.ElapsedDelta < 12.5) then
			if PapsRig.Legs.x < 315.1 then
				self:SetVar("blockgoingleft",false)
			elseif PapsRig.Legs.x > 324.9 then
				self:SetVar("blockgoingleft",true)
			end

			if self:GetVar("blockgoingleft") then
				PapsRig.Legs.x = lerp(PapsRig.Legs.x,315,0.75*Time.mult)
			else
				PapsRig.Legs.x = lerp(PapsRig.Legs.x,325,0.75*Time.mult)
			end

		elseif (self.ElapsedDelta >= 0.5 and self.ElapsedDelta < 6) or (self.ElapsedDelta >= 6.5 and self.ElapsedDelta < 12) or (self.ElapsedDelta >= 12.5) then
			self:SetVar("blockgoingleft",true)
			PapsRig.Legs.x = lerp(PapsRig.Legs.x,320,0.75*Time.mult)
		end

		if self.ElapsedDelta >= 6 and not self:GetVar("f1") then
			self:SetVar("f1",true)
			PapsRig.Arms.Left:SetAnimation({"Papyrus/Arms/Right Tired 2"})
			PapsRig.Head.y = -1
		end

		sbone = self:GetVar("sbone")

		if self.ElapsedDelta >= 12 and not sbone then
			PapsRig:SetLayer("Top")
			sbone = self:SetVar("sbone",CreateSprite("Bones/SharpBone","OverOverTop"))
			sbone.SetPivot(0.85,0.35)
			sbone.x = PapsRig.Arms.Right.absx
			sbone.y = PapsRig.Arms.Right.absy
			Audio.PlaySound("transform")
			PapsRig.Arms.Right.SetAnimation({"Papyrus/Arms/Left Tired 2"})
			PapsRig.Arms.Right.SetPivot(0.5,1)
			PapsRig.Arms.Right.SetAnchor(0.15,0.6)
			SetHead("Phase 5/glitch")
			PapsRig.Head.y = 0
		end

		if self.ElapsedDelta > 12 and sbone then
			sbone.alpha = sbone.alpha - Time.mult/30
			sbone.yscale = sbone.yscale + 0.025*Time.mult
		end

		if self.ElapsedDelta > 18 and self.ElapsedDelta < 24 then
			cutscenesprite.alpha = cutscenesprite.alpha + Time.mult/60
		end



		if self.ElapsedDelta >= 24 and not self:GetVar("endf") then
			self:SetVar("endf",true)
			Audio.Stop()
			enemies[1]["canspare"] = true
			enemies[1]["def"] = 0
			enemies[1]["atk"] = 20
			enemies[1]["check"] = "[w:4][color:FF0000][voice:v_floweymad]Papyrus is vulnerable =)"
			enemies[1]["currentdialogue"] = {"[noskip][waitall:3]I...[w:30][next]","[noskip][w:7][next]"}
			BG:SetActive(false)
			enemies[1]["comments"] = {"..."}
			PapsRig:SetAnimation("Rest")
			State("ENEMYDIALOGUE")
		end

		if self.ElapsedDelta > 26 then
			cutscenesprite.alpha = cutscenesprite.alpha - Time.mult/30
		end

		if self.ElapsedDelta >= 26.66667 then
			self:Stop()
		end
	end

	function p6tiredstop(self)
		if self:GetVar("sbone") and self:GetVar("sbone").isactive then
			self:GetVar("sbone").Remove()
		end

		self.Variables = {}
	end

	local function p7introstart(self)
		self:SetVar("helper",require("wave_helper"))
	end

	local function p7introupdate(self)
		if self.Phase == 0 then
			self:GetVar("helper"):Update()



			if funevents("glitchy") then

				if self.ElapsedDelta >= 2.166667 and not self:GetVar("glitch") then
					self:SetVar("glitch",true)
					Audio.PlaySound("glitchy")
				end

				if self.ElapsedDelta >= 2.5 and not self:GetVar("glitch2") then
					self:SetVar("glitch2",true)
					Misc.ShakeScreen(math.floor(40/Time.mult),  6, false)
				end

				if self.ElapsedDelta < 2.5 and self.ElapsedDelta >= 2.166667 then
					PapsRig.Jaw.y = PapsRig.Jaw.y - Time.mult
					PapsRig:SetAlpha(PapsRig.Legs.alpha - Time.mult/40)
					PapsRig.Head.alpha = 1
					PapsRig.Jaw.alpha = 1
				end



				if self.ElapsedDelta >= 2.5 and self.ElapsedDelta < 3.166667 and not self:GetVar("headf") then
					self:SetVar("headf",true)
					local func = function()

						if PapsRig.Jaw.y ~= -20 then
							PapsRig.Jaw.y = -20
						else
							PapsRig.Jaw.y = 0
						end--]]
					end

					func()
					self:GetVar("helper"):AddRepeatEvent(func,1/12,8)
					--[[if math.floor(cutscene_converted + 0.5) % 5 == 0 then
						PapsRig.Jaw.y = -20
					else
						
					end--]]


				end

				if self.ElapsedDelta >= 3.166667 and not self:GetVar("jawf") then
					self:SetVar("jawf",true)
					PapsRig.Jaw.y = -20
				end

				if self.ElapsedDelta < 3.5 and self.ElapsedDelta > 3.166667 then
					PapsRig.Jaw.y = PapsRig.Jaw.y + Time.mult
					PapsRig:SetAlpha(PapsRig.Legs.alpha + Time.mult/40)
					PapsRig.Head.alpha = 1
					PapsRig.Jaw.alpha = 1
				end

				if self.ElapsedDelta > 4.666667 and self.ElapsedDelta < 4.85 then
					PapsRig.Legs.y = lerp(PapsRig.Legs.y,316,0.1*Time.mult)
					PapsRig.Legs.yscale = lerp(PapsRig.Legs.yscale,0.9,0.1*Time.mult)
				end

				if self.ElapsedDelta >= 4.85 and not self:GetVar("fall") then
					self:SetVar("fall",true)
					Audio.PlaySound("click")
					PapsRig.Legs.y = 330
					enemies[1]["monstersprite"].y = 251.5
					PapsRig:SetAnimation("Phase 5 Hit")
					SetHead("Phase 5/tired3")
				end

			else

				if self.ElapsedDelta >= 2.5 and not self:GetVar("bloodf") then
					self:SetVar("bloodf",true)
					Bleed()
				end

				if self.ElapsedDelta < 3 and self.ElapsedDelta > 2.5 then
					if PapsRig.Legs.x < 315.1 then
						self:SetVar("blockgoingleft",false)
					elseif PapsRig.Legs.x > 324.9 then
						self:SetVar("blockgoingleft",true)
					end

					if self:GetVar("blockgoingleft") then
						PapsRig.Legs.x = lerp(PapsRig.Legs.x,315,0.75*Time.mult)
					else
						PapsRig.Legs.x = lerp(PapsRig.Legs.x,325,0.75*Time.mult)
					end

				elseif self.ElapsedDelta >= 3 then
					self:SetVar("blockgoingleft",true)
					PapsRig.Legs.x = lerp(PapsRig.Legs.x,320,0.75*Time.mult)
				end


				if self.ElapsedDelta > 3.75 and self.ElapsedDelta < 3.95 then
					PapsRig.Legs.y = lerp(PapsRig.Legs.y,316,0.1*Time.mult)
					PapsRig.Legs.yscale = lerp(PapsRig.Legs.yscale,0.9,0.1*Time.mult)
				end

				if self.ElapsedDelta >= 3.95 and not self:GetVar("fall") then
					self:SetVar("fall",true)
					Audio.PlaySound("click")
					PapsRig.Legs.y = 330
					enemies[1]["monstersprite"].y = 251.5
					PapsRig:SetAnimation("Phase 5 Hit")
					SetHead("Phase 5/tired3")
				end

			end





		elseif self.Phase == 1 then
			flickersprite.alpha = flickersprite.alpha + Time.mult/60


			if self.ElapsedDelta >= 1 + 1/6 and not self:GetVar("ff") then
				self:SetVar("ff",true)
				Audio.PlaySound("click")
				enemies[1]["monstersprite"].y = 281.5
				enemies[1]["hp"] = 0
				PapsRig:SetAnimation("Rest")
				SetHead("Phase 5/downed")
			end

		elseif self.Phase == 2 then
			flickersprite.alpha = flickersprite.alpha - Time.mult/60
		elseif self.Phase == 3 then
				if self.ElapsedDelta < 1 then
				SetHead("Phase 5/tired3")
				end

				if self.ElapsedDelta > 1/6 and self.ElapsedDelta <= 1 + 1/6 then
				flickersprite.alpha = flickersprite.alpha + Time.mult/60
				end

				if self.ElapsedDelta >= 3 and not self:GetVar("endf") then
					self:SetVar("endf",true)
					SetHead("Phase 5/downed")
					PapsRig:SetAnimation("Phase 7 Idle")
					Audio.LoadFile("p7_loop")
					enemies[1]["comments"] = {"..."}
					enemies[1]["atk"] = 50
					enemies[1]["def"] = 0
					enemies[1]["check"] = "[w:4]He knows his time is up,[w:4]\rbut he can't go until he\runderstands what he just saw."
					State("ACTIONSELECT")
				end

				if self.ElapsedDelta > 3 then
				flickersprite.alpha = flickersprite.alpha - Time.mult/60
				cutscenesprite.alpha = cutscenesprite.alpha - Time.mult/60
				end

				if self.ElapsedDelta >= 4.016667 and not self:GetVar("endf2") then
					self:SetVar("endf2",true)
					progress = 0
					waveProgress = 0
					SetAlMightyGlobal("papyrusdisbeliefex_checkpoint",3)
					phase = 7
					self:Stop()
				end
		end
	end

	local function p7introstop(self)
		self.Variables = {}
	end

	local function fadingawaystart(self)
		SetHead("Phase 5/tired3")
		cutscenesprite.layer = "BelowPlayer"
	end

	local function fadingawayupdate(self)


			if self.ElapsedDelta <= 0.5 then
				cutscenesprite.alpha = cutscenesprite.alpha + Time.mult/60
			end

			if (self.ElapsedDelta > 0.5 and self.ElapsedDelta < 1) or  (self.ElapsedDelta >= 2 and self.ElapsedDelta < 2.5) then
				if PapsRig.Legs.x < 315.1 then
					self:SetVar("blockgoingleft",false)
				elseif PapsRig.Legs.x > 324.9 then
					self:SetVar("blockgoingleft",true)
				end

			if self:GetVar("blockgoingleft",true) then
				PapsRig.Legs.x = lerp(PapsRig.Legs.x,315,0.75*Time.mult)
			else
				PapsRig.Legs.x = lerp(PapsRig.Legs.x,325,0.75*Time.mult)
			end

			if self.ElapsedDelta >= 2 and not fadinaway then
				fadinaway = true
				Audio.PlaySound("enemydust")
				SetHead("Phase 7/fading")
				PapsRig.Torso:SetAnimation({"Papyrus/Body/Fading Away"})
			end

			elseif (self.ElapsedDelta >= 1 and self.ElapsedDelta < 2) or (self.ElapsedDelta >= 2.5) then
				blockgoingleft = true
				PapsRig.Legs.x = lerp(PapsRig.Legs.x,320,0.75*Time.mult)
			end

			if self.ElapsedDelta >= 3 then
				cutscenesprite.alpha = cutscenesprite.alpha - Time.mult/60
			end

			if self.ElapsedDelta >= 3.666667 then
				self:GetVar("blockgoingleft",nil)
				cutscenesprite.layer = "BelowBullet"
				self:Stop()
				State("ACTIONSELECT")
			end
	end

	local function p8introstart(self)
		PapsRig:SetLayer("BelowBullet")

		local fullybody = self:SetVar("papy",CreateSprite("Papyrus/Royal Guard Silo","Top")) 
		fullybody.SetPivot(0.5,0)
		fullybody.SetParent(PapsRig.Legs)
		fullybody.y = 0
		fullybody.x = 0
		fullybody.alpha = 0
		fullybody.SetAnchor(0.5,0)
	end

	local function p8introupdate(self)
		if self.Phase == 0 then
			cutscenesprite.alpha = cutscenesprite.alpha + Time.mult/60
		elseif self.Phase == 1 then

			if not self:GetVar("dtf") then
				self:SetVar("dtf",true)
				Audio.LoadFile("determination")
			end
		elseif self.Phase == 2 then
			if not self:GetVar("dtf2") then
				self:SetVar("dtf2",true)
				Audio.Stop()
				Audio.PlaySound("transform2")
				flickersprite.color = {1,1,1}
			end


			if self.ElapsedDelta < 4 then
				flickersprite.alpha = flickersprite.alpha + Time.mult/240
			else
				flickersprite.alpha = flickersprite.alpha - Time.mult/240
			end

			if self.ElapsedDelta >= 4 and not self:GetVar("hidef") then
				self:SetVar("hidef",true)
				UI.StopUpdate(false)
				PapsRig:SetVisible(false)
				cutscenesprite.alpha = 0
				Arena.Hide()
				UI.mercybtn.alpha = 0
				UI.actbtn.alpha = 0
				UI.itembtn.alpha = 0
				UI.fightbtn.alpha = 0
				UI.hplabel.alpha = 0
				UI.hptext.alpha = 0
				UI.namelv.alpha = 0
				UI.hpbar.background.alpha = 0
				UI.hpbar.fill.alpha = 0
				Player.sprite.alpha = 0
			end
		elseif self.Phase == 3 then
			local fullybody = self:GetVar("papy")

			if fullybody and fullybody.isactive then
				fullybody.alpha = fullybody.alpha - Time.mult/15
			end

			if not self:GetVar("beginf") then
				self:SetVar("beginf",true)
				Audio.LoadFile("p8")
			end

			if self.ElapsedDelta >= 6.666667 and not self:GetVar("bgf") then
				self:SetVar("bgf",true)
				BG:SetColor({0,1,0})
				BG:SetActive(true)
			end

			if self.ElapsedDelta > 10 then
				UI.namelv.alpha = UI.namelv.alpha + Time.mult/60
				UI.hplabel.alpha = UI.hplabel.alpha + Time.mult/60
				UI.hptext.alpha = UI.hptext.alpha + Time.mult/60
				UI.hpbar.background.alpha = UI.hpbar.background.alpha + Time.mult/60
				UI.hpbar.fill.alpha = UI.hpbar.fill.alpha + Time.mult/60
			end

			if self.ElapsedDelta > 13.5 then
				UI.fightbtn.alpha = UI.fightbtn.alpha + Time.mult/60
				UI.actbtn.alpha = UI.actbtn.alpha + Time.mult/60
				UI.itembtn.alpha = UI.itembtn.alpha + Time.mult/60
				UI.mercybtn.alpha = UI.mercybtn.alpha + Time.mult/60
			end

			if self.ElapsedDelta >= 17.66667 and not self:GetVar("dingf") then
				self:SetVar("dingf",true)
				Audio.PlaySound("ding")

				if fullybody and fullybody.isactive then
					fullybody.alpha = 1
				end

			end

			if self.ElapsedDelta >= 18 and not self:GetVar("dingf1") then
				self:SetVar("dingf1",true)
				Audio.PlaySound("ding")

				if fullybody and fullybody.isactive then
					fullybody.alpha = 1
				end
			end

			if self.ElapsedDelta >= 18.33333 and not self:GetVar("dingf2") then
				self:SetVar("dingf2",true)
				Audio.PlaySound("ding")

				if fullybody and fullybody.isactive then
					fullybody.alpha = 1
				end
			end

			if self.ElapsedDelta >= 18.83333 and not self:GetVar("endf") then
				self:SetVar("endf",true)
				Audio.PlaySound("transform")
				flickersprite.alpha = 1
				Arena.Show()
				Player.sprite.alpha = 1
				PapsRig:SetAnimation("Phase 8 Idle")
				PapsRig.AnimationSpeed = 1.5
				PapsRig:SetVisible(true)

			end

			if self.ElapsedDelta >= 20 and not self:GetVar("endf2") then
				self:SetVar("endf2",true)
				SetAlMightyGlobal("papyrusdisbeliefex_checkpoint",4)
				atk = 30
				progress = 0
				waveProgress = 0
				enemies[1]["atk"] = 999
				enemies[1]["def"] = 999
				enemies[1]["maxhp"] = 100000
				enemies[1]["hp"] = 100000
				enemies[1]["canspare"] = false

				enemies[1]["comments"] = {"The true hero appears.", "Wind echos around you..."}
				Player.atk = 4500 + 80*legsEaten
				didatk = false
				enemies[1]["check"] = "[w:4]Is ready to do whatever it takes\nto bring everybody back."
				State("DEFENDING")
				self:Stop()
			end

		end
	end

	local function p8introstop(self)
		flickersprite.alpha = 0
		flickersprite.color = {0,0,0}
		phase = 8
		PapsRig:SetLayer("BelowArena")

		if self:GetVar("papy") and self:GetVar("papy").isactive then
			self:GetVar("papy").Remove()
		end
	end

	local function p8endupdate(self)

		if self.Phase == 0 then
			UI.fightbtn.alpha = UI.fightbtn.alpha - Time.mult/60
			UI.actbtn.alpha = UI.actbtn.alpha - Time.mult/60
			UI.itembtn.alpha = UI.itembtn.alpha - Time.mult/60
			UI.mercybtn.alpha = UI.itembtn.alpha - Time.mult/60

			if self.ElapsedDelta >= 4 and not self:GetVar("f") then
				self:SetVar("f",true)
				Audio.Stop()
				cutscenesprite.color = {1,1,1}
			end

			if self.ElapsedDelta > 4 and self.ElapsedDelta < 5 + 1/6 then
				cutscenesprite.alpha = cutscenesprite.alpha + Time.mult/60
				Player.sprite.alpha = Player.sprite.alpha - Time.mult/60
			end

			if self.ElapsedDelta >= 5.5 and not self:GetVar("diaf") then
				phase8aftermath()
				self:SetVar("diaf",true)
				local dialogue = {"[noskip][font:papyrus][voice:v_papyrus_royalguard]WHY CAN'T I DO IT?", "[noskip][font:papyrus][voice:v_papyrus_royalguard]EVEN AFTER LEARNING THE\nTRUTH...","[noskip][font:papyrus][voice:v_papyrus_royalguard]WHY IS IT SO HARD TO KILL\nYOU?","[noskip][font:papyrus][voice:v_papyrus_royalguard]...","[noskip][font:papyrus][voice:v_papyrus_royalguard]I REMEMBERED LEARNING\nABOUT HOW SANS DIED.", "[noskip][font:papyrus][voice:v_papyrus_royalguard]I REMEMBERED THE TIME YOU\nKILLED ME IN COLD BLOOD.","[noskip][font:papyrus][voice:v_papyrus_royalguard]I REMEMBERED HAVING HOPE\nTHAT YOU WOULD CHANGE\nEVEN IN MY DEATH.","[noskip][font:papyrus][voice:v_papyrus_royalguard]AND YET...","[noskip][voice:v_papyrus]...", "[noskip][font:papyrus][voice:v_papyrus]THERE WASN'T A SINGLE\nTIMELINE WHERE YOU DECIDED\nTO SPARE US.","[noskip][font:papyrus][voice:v_papyrus]THAT'S WHY I CAN'T\nLET YOU GO ANYMORE.","[noskip][font:papyrus][voice:v_papyrus]THAT'S WHY I HAVE TO\nEND THIS.","[noskip][func:TransitionCutscene,p8end][next]"}
				local txt = CreateText(dialogue,{20,180},640,"Top")
				txt.progressmode = "manual"
				txt.Scale(2,2)
				txt.deleteWhenFinished = true
				txt.HideBubble()
			end

		elseif self.Phase == 1 then

			if self.ElapsedDelta < 1.1 then
				Player.sprite.alpha = Player.sprite.alpha + Time.mult/60
				cutscenesprite.alpha = cutscenesprite.alpha - Time.mult/60
			end

			if self.ElapsedDelta >= 3 and not self:GetVar("Papf") then
				self:SetVar("Papf",true)
				deathtext = {"TO BE CONTINUED..."}
				local ttt = CreateText({"[noskip][font:papyrus][voice:v_papyrus]GOODBYE,[w:4] [func:SetHead,Phase 4/nyeh...]HUMAN...","[noskip][func:dieidiot][w:9][next]","[noskip][func:startkilling][next]"},{410,420},200,"OverTop")
				ttt.bubbleHeight = 75
				ttt.SetTail("left")
				ttt.progressmode = "manual"
			end
		else
			if self.ElapsedDelta >= 0.75 and not self:GetVar("facef1") then
				self:SetVar("facef1",true)
				SetHead("Phase 4/Thinking")
			end

			if self.ElapsedDelta >= 1.95 and not self:GetVar("facef2") then
				self:SetVar("facef2",true)
				SetHead("Phase 4/Power")
			end
		end
	end

	AddCutscene("spared",spareupdate,sparestopped)
	AddCutscene("block",blockupdate,blockstop,blockstart)
	AddCutscene("p5intro",p5introupdate,p5introstop,p5introstart)
	AddCutscene("p5end",p5endupdate,p5endstop,p5endstart)
	AddCutscene("p6tired",p6tiredupdate,p6tiredstop,p6tiredstart)
	AddCutscene("p7intro",p7introupdate,p7introstop,p7introstart)
	AddCutscene("fadingaway",fadingawayupdate,nil,fadingawaystart)
	AddCutscene("p8intro",p8introupdate,p8introstop,p8introstart)
	AddCutscene("p8end",p8endupdate,nil,nil)
end

function PlayCutscene(id)
	Cutscenes[id]:Start()
end



function EncounterStarting()
    -- If you want to change the game state immediately, this is the place.
	Audio.LoadFile("p5_end")
	Audio.LoadFile("nyeh")
	Audio.LoadFile("p6_intro")
	Audio.LoadFile("p6_loop")
	Audio.LoadFile("p6_end")
	Audio.LoadFile("p7_sansmemory")
	Audio.LoadFile("p5_loop")
	Audio.Stop()
	Player2:Start()

	Player.lv = 19
	Player.maxhp = 184
	Player.hp = 184
	Player.name = "Chara"
	Inventory.AddCustomItems({"Pie","Snow Piece", "I. Noodles", "L. Hero"},  {0,0,0,0})
	Inventory.SetInventory({"Pie", "Snow Piece", "Snow Piece", "Snow Piece", "I. Noodles", "L. Hero", "L. Hero", "L. Hero"})
	--ffwiz:Load()
	Player2:ToggleKR(false)
	RegisterSoulModes()
	RegisterBulletTypes()
	PapsRig:Spawn()
	RegisterCutscenes()
	--PapsRig:SetAnimation("Phase 8 Idle")
	papy = CreateSprite("Papyrus/fullbody_hit","Top")
	papy.SetPivot(0.72,0.46)
	papy.y = PapsRig.Legs.y
	papy.alpha = 0
	
	SetAlMightyGlobal("papyrusdisbeliefex_checkpoint",3)
	if GetAlMightyGlobal("papyrusdisbeliefex_checkpoint") == 1 then
		Audio.LoadFile("p5_loop")
		phase = 5
		PapsRig:SetAnimation("Phase 5 Idle")
		BG:SetColor({1,0.5,0})
		BG:SetActive(true)
		PapsRig:SetLayer("BelowArena")
		bonespr = CreateSprite("Bones/bone_block",PapsRig.Legs.layer)
		bonespr.y = 330
		bonespr.alpha = 0

		encountertext = "No more puzzles."
		enemies[1]["monstersprite"].layer = "Top"
		enemies[1]["canspare"] = false
		enemies[1]["atk"] = 90
		enemies[1]["def"] = 20
		enemies[1]["check"] = "[w:4]Reluctant to finish the job.[w:4]\nDon't give him the chance."
		if funevents(" ") then
			enemies[1]["comments"] = {"No more puzzles.", "Prunsel is holding back.", "Prunsel is reluctant to end you.", "Prunsel is doubting himself."}
		else
			enemies[1]["comments"] = {"No more puzzles.", "Papyrus is holding back.", "Papyrus is reluctant to end you.", "Papyrus is doubting himself."}
		end

	elseif GetAlMightyGlobal("papyrusdisbeliefex_checkpoint") == 2 then
		enemies[1]["hp"] = 2115
		phase = 5
		if not funevents(" ") then
			PapsRig:SetAnimation("Phase 5 Hit")
		end

		UI.StopUpdate(false)
		flickersprite.alpha = 0
		cutscenesprite.alpha = 0
		Arena.Hide()
		UI.mercybtn.alpha = 0
		UI.actbtn.alpha = 0
		UI.itembtn.alpha = 0
		UI.fightbtn.alpha = 0
		UI.hplabel.alpha = 0
		UI.hptext.alpha = 0
		UI.namelv.alpha = 0
		UI.hpbar.background.alpha = 0
		UI.hpbar.fill.alpha = 0
		Player.sprite.alpha = 0
		progress = 11


		enemies[1]["currentdialogue"] = {"[noskip][w:999][next]"}
		State("ENEMYDIALOGUE")
		PlayCutscene("p5end")
		enemies[1].Call("phase6begin")
	elseif GetAlMightyGlobal("papyrusdisbeliefex_checkpoint") == 3 then
		enemies[1]["hp"] = 0
		Audio.LoadFile("p7_loop")
		PapsRig:SetLayer("BelowArena")
		enemies[1]["monstersprite"].layer = "Top"
		enemies[1]["comments"] = {"..."}
		enemies[1]["atk"] = 50
		enemies[1]["def"] = 0

		enemies[1]["check"] = "[w:4]He knows his time is up,[w:4]\rbut he can't go until he\runderstands what he just saw."
		PapsRig:SetAnimation("Phase 7 Idle")
		PapsRig:ChangeHead("Phase 5/downed")
		PapsRig:SetLayer("Top")
		PapsRig:SendToBottom()
		Bleed()
		phase = 7
		progress = 5
		enemies[1]["canspare"] = false
	elseif GetAlMightyGlobal("papyrusdisbeliefex_checkpoint") == 4 then
			progress = 0
			enemies[1]["atk"] = 999
			enemies[1]["def"] = 999
			enemies[1]["maxhp"] = 100000
			enemies[1]["hp"] = 100000
			enemies[1]["canspare"] = false
			PapsRig:SetLayer("BelowArena")
			if funevents(" ") then
				enemies[1]["comments"] = {"The true        appears.", "Prunsel looks through you.", }
			else
				enemies[1]["comments"] = {"The true hero appears.", "Wind is echoing..."}
			end

			Player.atk = 4500

			didatk = false
			enemies[1]["check"] = "[w:4]Is ready to do whatever it takes\rto bring everybody back."
			atk = 30
			Audio.LoadFile("p8")
			BG:SetColor({0,1,0})
			BG:SetActive(true)
			phase = 8
			waveProgress = 0
			PapsRig:SetLayer("BelowArena")
			PapsRig:SetAnimation("Phase 8 Idle")
			PapsRig.AnimationSpeed = 1.5
	end--]]

	if funevents(" ") then
		Audio.Pitch(-0.9)
		PapsRig:SetAnimation("      ")
		enemies[1]["name"] = "Prunsel"
		enemies[1]["check"] = "[w:4]    forget    ."
	end
	--PlayCutscene("p7intro")
end

function HandleItem(ItemID)
	if ItemID == "PIE" then
		Player.Heal(184)
		BattleDialog("You ate the Butterscotch Pie.\nYour HP was maxed out!")
	elseif ItemID == "SNOW PIECE" then
		Player.Heal(45)
		BattleDialog("You ate the snowman piece.\nYou recovered 45 HP!")
	elseif ItemID == "I. NOODLES" then
		Player.Heal(90)
		BattleDialog("They're better dry.\nYou recovered 90 HP!")
	elseif ItemID == "L. HERO" then
		legsEaten = legsEaten + 1
		Player.atk = Player.atk + 80
		Player.Heal(45)
		BattleDialog("You ate the Legendary Hero.\nYou recovered 45 HP!\nYour attack increased by 4.")
	end
end

noflickersound = false

function Flicker(flickert,nosound)
	flickersprite.alpha = 1
	if not nosound then
		Audio.Pause()
		Audio.PlaySound("click")
	end
	flickertimer = flickert
end

function ToggleKR() -- For script communication
	Player2:ToggleKR(not Player2.KREnabled)
end

function AddPlatform(platform) -- Add platforms to the platform table so our blue soul can see them.
	table.insert(Platforms,platform)
end

function ChangeGravity(gravitymode) -- Possible modes are upright, rightwall, leftwall, and ceiling. Only usable in Blue Soul Mode.
	if Player2.SoulMode == "Blue" then
		Player2:Call("SetGravityMode",gravitymode)

		if gravitymode == "ceiling" then
			Player2:SetVar("YVel",6)
		elseif gravitymode == "upright" then
			Player2:SetVar("YVel",-6)
		elseif gravitymode == "leftwall" then
			Player2:SetVar("XVel",-6)
		elseif gravitymode == "rightwall" then
			Player2:SetVar("XVel",6)
		end

	end
end

function ChangeSoul(soul) -- Change the soul mode from a wave.
	Player2:SetSoulMode(soul)
end

function HandleHit(bullet) -- Handle getting hit by a bullet.
	BulletTypes:HandleCollision(bullet)
end

function HandleShield(bullet)
	BulletTypes:HandleShieldCollision(bullet)
end

function SetHead(head)
	PapsRig:ChangeHead(head)
end

function BeginPhase5()
	--phase = 5

	Cutscenes["p5intro"]:TransitionPhase()
	Flicker(2)
	PapsRig:SetAnimation("Phase 5 Idle")
	enemies[1]["monstersprite"].layer = "OverOverTop"
	Audio.Play()
end

function BeginPhase6()
	Cutscenes["p5end"]:TransitionPhase()
	enemies[1]["monstersprite"].layer = "OverOverTop"
end

function Phase7Part2()
	Cutscenes["p7intro"]:TransitionPhase()
end

function Phase7Part3()
	Cutscenes["p7intro"]:TransitionPhase()
end

function BeginPhase7()
	Cutscenes["p7intro"]:TransitionPhase()
end

function Phase8Part1()
	PlayCutscene("p8intro")
end


function BeginPhase8()

end

function ContinuePhase8()
	Cutscenes["p8intro"]:TransitionPhase()
end

function phase8tired()
	atk = 20
	PapsRig.AnimationSpeed = 0.5
	BlockAnim()

	PapsRig:ChangeHead("Phase 8/tired")
end

function phase8nottired()
	atk = 30
	BlockAnim()
	PapsRig.AnimationSpeed = 1.5
	PapsRig:ChangeHead("Phase 8/determined")
end

function phase8supertired()
	atk = 20
	PapsRig.AnimationSpeed = 1
	PapsRig:SetAnimation("Phase 8 Tired")
	BlockAnim()
end

function phase8aftermath()
	atk = 10
	PapsRig:SetAnimation("Rest")
	PapsRig:SetAnimation("Phase 7 Idle")
	PapsRig.Torso.SetAnimation({"Papyrus/Body/NOT Hyperrealistic Blood"})
	PapsRig.Jaw.SetAnimation({"Papyrus/Jaw"})
	PapsRig.Arms.Right.SetAnimation({"Papyrus/Arms/Left Tired 2"})
	PapsRig.Arms.Left.SetAnimation({"Papyrus/Arms/Right Tired 2"})
	PapsRig:ChangeHead("Phase 4/huh")
	BG:SetActive(false)
end


fadinaway = false
function BlockAnim()
	Cutscenes["block"]:Start()
end

spared = false
p6_eye = nil
ghand = nil
arenamask = nil
sbone = nil
picture = nil
wingdings = {}



function Bleed()
	if not funevents(" ") then
		PapsRig.Jaw:SetAnimation({"Papyrus/Jaw BLEEDING OMG"})
		PapsRig.Torso:SetAnimation({"Papyrus/Body/Hyperrealistic Blood"})
	end
end

function NOTBleed()
	if not funevents(" ") then
		PapsRig.Torso:SetAnimation({"Papyrus/Body/NOT Hyperrealistic Blood"})
	end
end

function dustpaps()
	PapsRig:Dust()
end



function Update()
	Player2:Update()
	PapsRig:Update()



	if GetCurrentState() ~= "DEFENDING" and PapsRig.Legs.alpha ~= 1 and phase == 6  and not funevents(" ") then
		PapsRig:SetAlpha(PapsRig.Legs.alpha + Time.mult/60)
	end

	BG:Update()

	for i,cts in pairs(Cutscenes) do
		if cts.Running then cts:Update() end
	end

	if grad and grad.isactive then
		grad:SendToTop()
	end

	if flickertimer > 0 then
		flickertimer = flickertimer - Time.dt

		if flickertimer <= 0 then

			flickertimer = 0

			if noflickersound == false then
				Audio.PlaySound("click")
				Audio.Unpause()
				noflickersound = false
			end

			flickersprite.alpha = 0
		end
	end
end

function phase6tired()
progress = 6
PlayCutscene("p6tired")
end

function SetAnimation(animation)
PapsRig:SetAnimation(animation)
end




function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.

	if phase == 5 then

	if progress == 10 then
	Audio.LoadFile("p5_end")
	SetHead("Phase 5/tired1")
	atk = 14
	enemies[1]["currentdialogue"] = {"[noskip][waitall:2]I...[w:30][next]", "[noskip][w:15][next]","[noskip][waitall:2][func:sethead,Phase 5/tired3]HAVE TO STOP\nHOLDING BACK.[w:30][next]", "[noskip][waitall:2][func:sethead,Phase 5/tired2]ITS TIME FOR ME\nTO FINISH\nTHE JOB.[w:25][next]","[noskip][func:sethead,Phase 5/angry][next]"}
	elseif progress == 4 then
	SetHead("Phase 5/unsure2")
	atk = 18
	enemies[1]["atk"] = 80
	elseif progress == 7 then
	SetHead("Phase 5/unsure1")
	atk = 16
	enemies[1]["atk"] = 70
	end

	elseif phase == 6 and didatk then
	didatk = false
	if progress == 1 then
		enemies[1]["currentdialogue"] = {"[waitall:3]..."}
	elseif progress == 2 then
		enemies[1]["currentdialogue"] = {"[waitall:3]WHAT IS THIS..?"}
	elseif progress == 3 then
		enemies[1]["currentdialogue"] = {"[waitall:3]WHAT ARE YOU\nSHOWING ME?"}
	elseif progress == 4 then
		enemies[1]["currentdialogue"] = {"[waitall:3]I DON'T\nUNDERSTAND."}
	elseif progress == 5 then
		enemies[1]["currentdialogue"] = {"[waitall:3]ARE THESE JUST\nILLUSIONS..?", "[waitall:3]OR ARE THEY...", "[noskip][waitall:4]..."}
	end

	elseif phase == 7 and didatk then
	didatk = false

	if progress == 1 then
		enemies[1]["currentdialogue"] = {"..."}
	elseif progress == 6 then
		enemies[1]["canspare"] = true
		enemies[1]["currentdialogue"] = {"[waitall:2]I...","[waitall:2][func:sethead,Phase 7/can't take anymore of this]CAN'T TAKE\nANYMORE OF\nTHIS.","[noskip][func:sethead,Phase 7/fading ouch][next]"}
	end

	elseif phase == 8 and progress == 2 and didatk then



	end

	if funevents(" ") then

		if grad and grad.isactive then
			grad.Remove()
		end

		grad = CreateSprite("red","OverOverTop")

		grad.Scale(0.5,0.25)
		grad.color = {1,0,0}
		grad.x = 510
		grad.y = 380
		Audio.Pause()
		Audio.PlaySound("     _")
		enemies[1]["currentdialogue"] = {"[noskip] [w:128][func:CoolFunction][next]"}

	end
end

waveProgress = 0
p7_final = false
function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
	if phase == 4 then

		if funevents(" ") then
   		 	nextwaves = {"      _"}
		else
			nextwaves = {"sparing"}
		end

	elseif phase == 5 then
	waveProgress = waveProgress + 1
	if waveProgress > 10 then waveProgress = 1 end
	if waveProgress == 0 then nextwaves = {"sparing"} else nextwaves = {"p5_"..waveProgress} end

	if progress == 10 then
		if funevents(" ") then
			nextwaves = {"      _"}
		else
			nextwaves = {"p5_final"}
		end
	end

	elseif phase == 6 then
	waveProgress = waveProgress + 1
	if waveProgress > 5 then waveProgress = 1 end
	nextwaves = {"p6_"..waveProgress}
	if progress == 5 then nextwaves = {"p6_final"} end
	if progress == 6 then nextwaves = {"sparing"} end

	elseif phase == 7 then
	waveProgress = waveProgress + 1
	if waveProgress > 5 then waveProgress = 1 end
	nextwaves = {"p7_"..waveProgress}
	if progress == 6 and not p7_final then
	p7_final = true
	if funevents(" ") then
		nextwaves = {"      _"}
	else
		nextwaves = {"p7_final"}
	end
	elseif progress >= 6 and p7_final then
	nextwaves = {"sparing"}
	end
	elseif phase == 8 then
	waveProgress = waveProgress + 1
	if waveProgress > 8 then waveProgress = 1 end
	nextwaves = {"p8_"..waveProgress}

	if enemies[1]["hp"] <= 35000 then
		if funevents(" ") then
			nextwaves = {"      _"}
		else
			nextwaves = {"p8_final"}
		end
	end

	end


end

function EnteringState(newstate, oldstate)
	if newstate == "DEFENDING" then

		Player2:WaveStart()
	end

	if oldstate == "DEFENDING" then

		Player2:WaveEnd()
	end

	if newstate == "ATTACKING" and phase == 4 and enemies[1].GetVar("scared") < 6 and not funevents(" ") then
		PapsRig:SetAnimation("WAIT!")
		ttt = CreateText({"[font:papyrus][voice:v_papyrus]WAIT!!!"},{410,420},200,"OverTop")
		ttt.bubbleHeight = 75
		ttt.SetTail("left")
		ttt.progressmode = "auto"
	elseif oldstate == "ATTACKING" and newstate == "ENEMYDIALOGUE" and phase == 4 then

	end

end
no1stdialoguecheck = false
function DefenseEnding() --This built-in function fires after the defense round ends.

	Platforms = {} -- Clear this table out since we don't need the platforms from the recently ended wave.
    encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.

	if phase == 5 then

	if progress == 4 or progress == 7 then
		if funevents(" ") then
			encountertext = "Prunsel's attack decreased."
		else
			encountertext = "Papyrus' attack decreased."
		end

	elseif progress == 9 then
		if funevents(" ") then
			encountertext = "Prunsel is preparing something."
		else
			encountertext = "Papyrus is preparing something."
		end

	end

	end

	if phase == 8 and didatk and not no1stdialoguecheck then
		no1stdialoguecheck = true
		--enemies[1]["disableaddatk"] = true
		if not funevents(" ") then
			enemies[1]["currentdialogue"] = {"[voice:v_papyrus_royalguard]SORRY...", "[voice:v_papyrus_royalguard]THIS IS A FIRST\nFOR ME.","[noskip][func:State,ACTIONSELECT][next]"}

		else
			grad = CreateSprite("red","Top")
			grad.Scale(0.5,0.25)
			grad.color = {1,0,0}
			grad.x = 510
			grad.y = 380
			Audio.Pause()
			Audio.PlaySound("     _")
			enemies[1]["currentdialogue"] = {"[noskip] [w:128][func:CoolFunction][next]"}
		end
		State("ENEMYDIALOGUE")
	end

	if phase == 7 then

		if progress == 3 and not fadinaway then
			enemies[1]["currentdialogue"] = {"[noskip][w:999][next]"}

			if not funevents(" ") then
				State("ENEMYDIALOGUE")
				PlayCutscene("fadingaway")
			end
		end

		if progress == 8 and phase == 7 then
			encountertext = "[color:FF0000][voice:v_floweymad]..."
		elseif progress == 9 and enemies[1]["talkcount"] < 1 and phase == 7 then
			enemies[1]["commands"] = {"Talk"}
			encountertext = "[color:FF0000][voice:v_floweymad]This isn't working.[w:4]\nTry something new."
		elseif progress == 10 and enemies[1]["talkcount"] < 1 and phase == 7 then
			encountertext = "[color:FF0000][voice:v_floweymad]You're wasting time.[w:4]\nTry something new."
		elseif progress >= 11 and enemies[1]["talkcount"] < 1 and phase == 7 then
			encountertext = "[color:FF0000][voice:v_floweymad]......"
		elseif enemies[1]["talkcount"] >= 1 and phase == 7 then
			encountertext = "[color:FF0000][voice:v_floweymad]..."
 		end
	end

end

function HandleSpare()
    State("ENEMYDIALOGUE")
end

