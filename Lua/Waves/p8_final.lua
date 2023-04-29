gaster = require "gaster_blasters"
helper = require "wave_helper"
spawntimer = 0
local killblastera
local killblasterb
Encounter.Call("ChangeSoul","Red")
Audio.LoadFile("p8_end")
Arena.MoveToAndResize(320,240,44,44)


bullets = {}
blasters = {}
interval = 25
local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")

local part2 = false
local iskilling = false
local face_elapsed = 0
function startpart2()
part2 = true
Encounter.Call("phase8aftermath")
end



function sethead(head)
Encounter.Call("SetHead",head)
end

function die()
	killblastera.Fire()
	killblasterb.Fire()
end

function  p8tired()
	Encounter.Call("phase8tired")
end

function  bo1()
	local b = CreateProjectile("Bones/Small",0,600)

	b.SetVar("xvel",0)
	b.SetVar("yvel",-7)


	b.SetVar("Type","kr1")
	table.insert(bullets,b)
end

function  bo2()
	local b = CreateProjectile("Bones/Small",16,600)

	b.SetVar("xvel",0)
	b.SetVar("yvel",-7)


	b.SetVar("Type","kr1")

	local b1 = CreateProjectile("Bones/Small",-16,600)

	b1.SetVar("xvel",0)
	b1.SetVar("yvel",-7)


	b1.SetVar("Type","kr1")

	table.insert(bullets,b)
	table.insert(bullets,b1)
end

function bo3()
	local b = CreateProjectile("Bones/Small",Player.x,600)

	b.SetVar("xvel",0)
	b.SetVar("yvel",-7)

	b.SetVar("Type","kr1")
	table.insert(bullets,b)
end

function  bo4()
	local b = CreateProjectile("Bones/Small",-400,Player.y)

	b.SetVar("xvel",7)
	b.SetVar("yvel",0)
	b.sprite.rotation = 90
	b.ppcollision = true
	b.SetVar("Type","kr1")
	table.insert(bullets,b)
end

function  bo5()
	local b = CreateProjectile("Bones/Small",620,Player.y)

	b.SetVar("xvel",-7)
	b.SetVar("yvel",0)
	b.sprite.rotation = 90
	b.ppcollision = true
	b.SetVar("Type","kr1")
	table.insert(bullets,b)
end

function bo6()
	local b = CreateProjectile("Bones/Small",Player.x,-600)

	b.SetVar("xvel",0)
	b.SetVar("yvel",7)

	b.SetVar("Type","kr1")
	table.insert(bullets,b)
end

function BlasterSec()
	Arena.MoveToAndResize(320,90,100,100)
end

function Bla1()
	local b = CreateProjectile("Bones/lesstall",125,0)

	b.SetVar("xvel",-5)
	b.SetVar("yvel",0)

	b.SetVar("Type","kr1")

	local b1 = CreateProjectile("Bones/lesstall",-125,0)

	b1.SetVar("xvel",5)
	b1.SetVar("yvel",0)

	b1.SetVar("Type","kr1")
	b1.sprite.SetParent(mask)
	b.sprite.SetParent(mask)
	b.sprite.color = {0,1,1}
	b1.sprite.color = {0,1,1}
	b.SetVar("Type","krB")
	b1.SetVar("Type","krB")
	table.insert(bullets,b)
	table.insert(bullets,b1)
end

function Bla2()
	local		a = gaster:New({-700,600},{250,200},{1,1},45,0,false,"kr1")
	local		b = gaster:New({740,500},{500,140},{1,1},270,180,false,"kr1")
	a.firetime = 0.75
	b.firetime = 0.75



	table.insert(blasters,a)
	table.insert(blasters,b)
end

function Bla3()
	local		a = gaster:New({-700,600},{390,200},{1,1},-45,0,false,"kr1")
	local		b = gaster:New({740,500},{120,140},{1,1},90,180,false,"kr1")
	a.firetime = 0.75
	b.firetime = 0.75



	table.insert(blasters,a)
	table.insert(blasters,b)
end

function Bla4()
	local		a = gaster:New({-700,600},{320,380},{1,1},0,0,false,"kr1")
	local		b = gaster:New({-740,500},{100,140},{1,1},90,180,false,"kr1")
	a.firetime = 0.75
	b.firetime = 0.75



	table.insert(blasters,a)
	table.insert(blasters,b)
end

function Bla5()
	local		a = gaster:New({-700,600},{190,240},{1,1},45,0,false,"kr1")
	local		b = gaster:New({-700,600},{440,240},{1,1},-45,180,false,"kr1")
	a.firetime = 0.75
	b.firetime = 0.75



	table.insert(blasters,a)
	table.insert(blasters,b)
end

function Bla6()
	local		a = gaster:New({-700,600},{320,320},{1,1},0,0,false,"kr1")
	local		b = gaster:New({740,500},{520,140},{1,1},270,180,false,"kr1")
	a.firetime = 0.75
	b.firetime = 0.75



	table.insert(blasters,a)
	table.insert(blasters,b)
end

function Bla7()
	local		a = gaster:New({-700,600},{320,320},{1,1},0,0,false,"kr1")
	a.firetime = 0.75
	table.insert(blasters,a)
end

function Bla8()
	local		a = gaster:New({-700,600},{280,320},{.8,1},0,0,false,"kr1")
	local		b = gaster:New({700,600},{370,320},{.8,1},0,0,false,"kr1")
	a.firetime = 0.75
	b.firetime = 0.75
	table.insert(blasters,a)
	table.insert(blasters,b)
end

function GreenSec()
	Encounter.Call("ChangeSoul","Green")
	Arena.MoveTo(Misc.WindowWidth/2,Misc.WindowHeight/2-50,false)
	Encounter.Call("phase8nottired")
end

function ReallyTired()
	Encounter.Call("phase8supertired")
end

function BeginEnding()
	Encounter.Call("ChangeSoul","Red")
	Arena.Resize(16,16,true)
	killblastera = gaster:New({-100,Arena.y+Arena.height/2+5},{100,Arena.y+Arena.height/2},{1,1},90,0,false,"krDontKill")
	killblasterb = gaster:New({740,Arena.y+Arena.height/2+5},{540,Arena.y+Arena.height/2},{1,1},270,180,false,"krDontKill")
	killblastera.sprite.layer = "BelowUI"
	killblasterb.sprite.layer = "BelowUI"
	Encounter.Call("PlayCutscene","p8end")
end

function  SpawnBones()
	local rng1 = math.random(1,4)
		local rng2 = math.random(1,4)
		local b


		 b = CreateProjectile("Bones/Small",600,0)

			if (rng2 == 4 and spawntimer < 27 + 2/3) or spawntimer >= 38 + 1/6 then
			b.SetVar("Type","krB")
			b.sprite.color = {0,1,1}
		end




		if rng1 == 1 then
			b.x = 0
			b.y = 600
			b.SetVar("xvel",0)
			b.SetVar("yvel",-5)
			b.SetVar("YOffset",-15)
		elseif rng1 == 2 then
			b.x = 0
			b.y = -600
			b.SetVar("xvel",0)
			b.SetVar("yvel",5)
			b.SetVar("YOffset",15)--]]
		elseif rng1 == 3 then
		b.x = -600
		b.SetVar("xvel",5)
		b.SetVar("yvel",0)
		b.SetVar("XOffset",15)

		b.sprite.rotation = 90
		else


		b.SetVar("xvel",-5)
		b.SetVar("yvel",0)
		b.SetVar("XOffset",-15)

		b.sprite.rotation = 90
		end


		table.insert(Encounter["greensoul_bullets"],b)
		table.insert(bullets,b)
end

function SpawnBlasters()
	local arng = math.random(1,4)

		local a
		if arng == 1 then
			a = gaster:NewGreenSoulBlaster({600,Misc.WindowHeight/2-40},{Misc.WindowWidth/2,425},{1,1},"Up",90,false,"Blaster")

			a.firetime = 1

		elseif arng == 2 then
			a = gaster:NewGreenSoulBlaster({600,-200},{Misc.WindowWidth/2,50},{1,1},"Down",0,false,"Blaster")

			a.firetime = 1

		elseif arng == 3 then
			a = gaster:NewGreenSoulBlaster({0,Misc.WindowHeight/2-40},{125,Misc.WindowHeight/2-10},{1,1},"Left",0,false,"Blaster")

		a.firetime = 1
		else
		a = gaster:NewGreenSoulBlaster({600,Misc.WindowHeight/2-40},{475,Misc.WindowHeight/2-10},{1,1},"Right",0,false,"Blaster")

		a.firetime = 1

		end

		table.insert(blasters,a)
end

function StartSpawnBones()
	SpawnBones()
	helper:AddRepeatEvent(SpawnBones,0.4166667,44)
end

function StartBlueBones()
	helper:AddRepeatEvent(SpawnBones,0.5833333,12)
end

function StartBlasters()
	SpawnBlasters()
	helper:AddRepeatEvent(SpawnBlasters,2,3)
end

function BlasterKilling()
	if not hpflag then
		if Player.hp <= 10 then
			hpflag = true
			Encounter.Call("TransitionCutscene","p8end")
		end

		local a = gaster:New({-100,Arena.y+Arena.height/2+5},{100,Arena.y+Arena.height/2},{1,1},90,0,false,"kr1")
		local b = gaster:New({740,Arena.y+Arena.height/2+5},{540,Arena.y+Arena.height/2},{1,1},270,180,false,"kr1")

			if Player.hp > 10 then
				a.firetime = 0.75
				b.firetime = 0.75
			else
				a.firetime = 2
				b.firetime = 2
			end

		table.insert(blasters,a)
		table.insert(blasters,b)
	end
end

function startkilling()
	helper:AddRepeatEvent(BlasterKilling,1.5,0)
end

local hpflag = false
local part2_elapsed = 0
helper:AddEvent(p8tired,0.5)
helper:AddEvent(bo1,0.5)
helper:AddEvent(bo5,1 + 1/3)
helper:AddEvent(bo6,1.916667)
helper:AddEvent(bo5,2 + 1/3)
helper:AddEvent(bo6,3.416667)
helper:AddEvent(bo4,3 + 2/3)
helper:AddEvent(bo5,4 + 1/6)
helper:AddEvent(bo3,5)
helper:AddEvent(bo6,5.083333)
helper:AddEvent(bo5,5.833333)
helper:AddEvent(bo5,6 + 1/3)
helper:AddEvent(bo4,6.5)
helper:AddEvent(bo2,7)
helper:AddEvent(bo1,7.5)
helper:AddEvent(BlasterSec,10)
helper:AddEvent(Bla1,10.5)
helper:AddEvent(Bla2,11.5)
helper:AddEvent(Bla3,12 + 2/3)
helper:AddEvent(Bla4,13.83333)
helper:AddEvent(Bla5,14.83333)
helper:AddEvent(Bla6,15 + 2/3)
helper:AddEvent(Bla7,16.5)
helper:AddEvent(Bla8,17 + 2/3)
helper:AddEvent(GreenSec,19.5)
helper:AddEvent(p8tired,38 + 2/3)
helper:AddEvent(ReallyTired,47 + 2/3)
helper:AddEvent(StartSpawnBones,19.83333)
helper:AddEvent(StartBlueBones,38 + 2/3)
helper:AddEvent(StartBlasters,47 + 2/3)
helper:AddEvent(BeginEnding,56)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5



if spawntimer > 19.5 and spawntimer < 20.16667 then
Player.MoveToAbs(Arena.x,Arena.y+5+Arena.height/2)
end

if spawntimer == 1660 then
interval = 35
end



if spawntimer == 2860 then
interval = 120

end

if spawntimer == 3360 then

end

if spawntimer > 3360 then
UI.fightbtn.alpha = UI.fightbtn.alpha - 1/60
UI.actbtn.alpha = UI.actbtn.alpha - 1/60
UI.itembtn.alpha = UI.itembtn.alpha - 1/60
UI.mercybtn.alpha = UI.itembtn.alpha - 1/60
end


if spawntimer == 3600 then
Audio.Stop()
Encounter["cutscenesprite"].color = {1,1,1}
end

if spawntimer > 3600 and spawntimer < 3670 then
Encounter["cutscenesprite"].alpha = Encounter["cutscenesprite"].alpha + 1/60
Player.sprite.alpha = Player.sprite.alpha - 1/60
end



if spawntimer == 3690 then
local dialogue = {"[noskip][font:papyrus][voice:v_papyrus_royalguard]WHY CAN'T I DO IT?", "[noskip][font:papyrus][voice:v_papyrus_royalguard]EVEN AFTER LEARNING THE\nTRUTH...","[noskip][font:papyrus][voice:v_papyrus_royalguard]WHY IS IT SO HARD TO KILL\nYOU?","[noskip][font:papyrus][voice:v_papyrus_royalguard]...","[noskip][font:papyrus][voice:v_papyrus_royalguard]I REMEMBERED LEARNING\nABOUT HOW SANS DIED.", "[noskip][font:papyrus][voice:v_papyrus_royalguard]I REMEMBERED THE TIME YOU\nKILLED ME IN COLD BLOOD.","[noskip][font:papyrus][voice:v_papyrus_royalguard]I REMEMBERED HAVING HOPE\nTHAT YOU WOULD CHANGE\nEVEN IN MY DEATH.","[noskip][font:papyrus][voice:v_papyrus_royalguard]AND YET...","[noskip][voice:v_papyrus]...", "[noskip][font:papyrus][voice:v_papyrus]THERE WASN'T A SINGLE\nTIMELINE WHERE YOU DECIDED\nTO SPARE US.","[noskip][font:papyrus][voice:v_papyrus]THAT'S WHY I CAN'T\nLET YOU GO ANYMORE.","[noskip][font:papyrus][voice:v_papyrus]THAT'S WHY I HAVE TO\nEND THIS.","[noskip][func:startpart2][next]"}
local txt = CreateText(dialogue,{20,180},640,"Top")
txt.progressmode = "manual"
txt.Scale(2,2)
txt.deleteWhenFinished = true
txt.HideBubble()
end

if spawntimer % interval == 0 and spawntimer > 2860  and spawntimer < 3350 then

end

if spawntimer % interval == 0 and spawntimer > 1190 and spawntimer < 2750 then

end


if part2 then
part2_elapsed = part2_elapsed + 1
if part2_elapsed < 61 then

end


if part2_elapsed == 180 then
Encounter["deathtext"] = {"TO BE CONTINUED..."}
ttt = CreateText({"[noskip][font:papyrus][voice:v_papyrus]GOODBYE,[w:4] [func:sethead,Phase 4/nyeh...]HUMAN...","[noskip][func:die][w:9][next]","[noskip][func:startkilling][next]"},{410,420},200,"OverTop")
ttt.bubbleHeight = 75
ttt.SetTail("left")
ttt.progressmode = "manual"
end

if not hpflag and iskilling and part2_elapsed % 90 == 0 then



end

if Player.hp <= 10 and iskilling then
face_elapsed = face_elapsed + 1

if face_elapsed == 60 then
sethead("Phase 4/Thinking")
elseif face_elapsed == 120 then
sethead("Phase 4/Power")
end


end

end



for i,v in pairs(blasters) do
	if v.lifetime >= v.firetime then
		v.Fire()
	end
end

for i,bullet in pairs(bullets) do
if bullet.isactive then
	bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
end
end

gaster:Update()
end


function OnHit(bullet)
Encounter.Call("HandleHit",bullet)
end

function EndingWave()
gaster:WaveEnd()
Encounter.Call("ChangeSoul","Red")
end