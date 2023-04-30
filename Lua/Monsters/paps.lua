-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {"..."}
commands = {}
randomdialogue = {"[noskip][next]"}
dialogueprefix = "[font:papyrus][voice:v_papyrus]"
sprite = "empty_monster" --Always PNG. Extension is added automatically.
name = "Papyrus"
maxhp = 10000
hp = 8376
atk = 20
def = 20
talkcount = 0
fake_atksprite = CreateSprite("empty","OverTop")
fake_atksprite.loopmode = "ONESHOTEMPTY"
fake_atksprite.y = 360
--SetDamageUIOffset(0, 50)
SetSliceAnimOffset(-5,40)
SetBubbleOffset(0,  50)
check = "[w:4]He just wants to be your friend.[w:12]\n[color:FF0000][voice:v_floweymad]Not worth my time."
dialogbubble = "rightwide" -- See documentation for what bubbles you have available.
canspare = true
cancheck = true
defensemisstext = "BLOCKED"
scared = 0

disableaddatk = false
function bubble(a,b)
SetBubbleOffset(a,  b)
end

function CoolFunction()
	Encounter.Call("CoolFunction")
end

function slice(a,b)
SetSliceAnimOffset(a,b)
end

function please()
Encounter.Call("SetHead","Phase 4/Please")
Encounter.Call("SetAnimation","Rest")
end

function phase5begin()
Encounter.Call("BeginPhase5")
end

function beginSpare()
Encounter.Call("PlayCutscene","spared")
end

function dustPaps()
Encounter.Call("dustpaps")
end

function phase6begin()
defensemisstext = "ERROR"
Player.ForceAttack(1)
Encounter.Call("BeginPhase6")
end

function phase7part2()
Encounter.Call("Phase7Part2")
end

function phase7part3()
Encounter.Call("Phase7Part3")
end

function phase7begin()
Encounter.Call("BeginPhase7")
end

function phase8part1()
Encounter.Call("Phase8Part1")
end

function phase8continue()
Encounter.Call("ContinuePhase8")
end


function sethead(head)
Encounter.Call("SetHead",head)
end

-- Happens after the slash animation but before 
function HandleAttack(attackstatus)
    if attackstatus == -1 and Encounter.GetVar("phase") == 4 then
        -- player pressed fight but didn't press Z afterwards
		if scared == 0 then
		currentdialogue = {"[noskip][font:papyrus][voice:papyrus][effect:none]YOU WERE ABOUT\nTO DO THE WRONG\nCHOICE!","[noskip][font:papyrus][voice:papyrus][effect:none]THIS IS NOT A\nGAME!","[noskip][font:papyrus][voice:papyrus][effect:none]JUST STOP[w:10],[func:please]\nPLEASE!","[noskip][font:papyrus][voice:papyrus][effect:none]IT'S NOT TOO\nLATE YET![w:10]\nJUST [color:f2c900]SPARE[color:000000] ME!","[noskip][font:papyrus][voice:papyrus][effect:none]I'M BEGGING YOU...[func:sethead,Phase 4/...]"}
		elseif scared == 1 then
		currentdialogue = {"[noskip][font:papyrus][voice:papyrus][effect:none]WHAT IS WRONG\nWITH YOU?!","[noskip][font:papyrus][voice:papyrus][effect:none]STOP SCARING ME\nLIKE THAT AND\nJUST [color:f2c900]SPARE[color:000000] ME!","[noskip][font:papyrus][voice:papyrus][effect:none][func:please]PLEASE[w:10], JUST\nSTOP DOING\nTHAT...[func:sethead,Phase 4/...]"}
		elseif scared == 2 then
		currentdialogue = {"[noskip][font:papyrus][voice:papyrus][effect:none]AM I A JOKE TO\nYOU?!","[noskip][font:papyrus][voice:papyrus][effect:none][func:please]ARE YOU JUST\nMESSING WITH ME?","[noskip][font:papyrus][voice:papyrus][effect:none]WHY?![w:10] ARE YOU\nEVEN LISTENING\nTO ME?!"}
		elseif scared == 3 then
		currentdialogue = {"[noskip][font:papyrus][voice:papyrus][effect:none]HOW MANY TIMES\nARE YOU GONNA\nDO THIS?!","[noskip][font:papyrus][voice:papyrus][effect:none]JUST[w:10] STOP[w:10] DOING[w:10]\nTHAT[w:10] ALREADY!","[noskip][font:papyrus][voice:papyrus][effect:none][func:please]YOU'RE GONNA\nMAKE ME GO\nCRAZY..."}
		elseif scared == 4 then
		currentdialogue = {"[noskip][font:papyrus][voice:papyrus][effect:none]WHY?!","[noskip][font:papyrus][voice:papyrus][effect:none]I DON'T GET IT!","[noskip][font:papyrus][voice:papyrus][effect:none][func:please]I DON'T...","[noskip][font:papyrus][voice:papyrus][effect:none]I DON'T KNOW\nWHAT YOU'RE\nEVEN TRYING\n TO DO ANYMORE...","[noskip][font:papyrus][voice:papyrus][effect:none]STOP...[w:10] PLEASE...[func:sethead,Phase 4/...]"}
		elseif scared == 5 then
		currentdialogue = {"[noskip][font:papyrus][voice:papyrus][effect:none][func:please]I DON'T CARE\nANYMORE...","[noskip][font:papyrus][voice:papyrus][effect:none]WHEN YOU FINISH\nDOING THAT...","[noskip][font:papyrus][voice:papyrus][effect:none]JUST...","[noskip][font:papyrus][voice:papyrus][effect:none][color:f2c900]SPARE[color:000000] ME...[func:sethead,Phase 4/...]"}
		end
		scared = scared + 1
    elseif attackstatus ~= -1 then
        -- player did actually attack
		if Encounter.GetVar("phase") == 6 then

			if Encounter["progress"] < 6 then
				Misc.ShakeScreen(120/Time.mult,  6, false)
				Audio.PlaySound("static")
			else
				Encounter.Call("PlayCutscene","p7intro")
				Encounter["cutscenesprite"].alpha = 1
				sethead("Phase 5/downed")
				if Encounter.Call("funevents","glitchy") then
					Encounter.Call("Bleed")
				else
					Encounter.Call("NOTBleed")
				end
				currentdialogue = {"[noskip][w:80][next]","[noskip]I CONVINCED\nMYSELF THAT YOU\nDID ALL OF THIS\nBECAUSE YOU\nWERE SCARED.", "[noskip]BUT WHAT I WAS\nSHOWN WASN'T\nJUST AN ILLUSION.","[noskip][waitall:2]...I RELIVED\nEVERYTHING.","[noskip][func:phase7part2][w:25][next]","[noskip][waitall:2]AND NOW...","[noskip][func:phase7part3][w:25][next]", "[noskip]I CAN'T HELP BUT\nTHINK...","[noskip]THAT YOU DID\nTHIS NOT OUT OF\nFEAR...", "[noskip]BUT BECAUSE OF\nSOMETHING FAR\nMORE SINISTER.","[noskip][func:phase7begin][w:999][next]"}
			end
			
			Audio.PlaySound("hitsound")
			Encounter.Call("BlockAnim")
			Encounter["progress"] = Encounter["progress"] + 1
			Encounter["didatk"] = true
		elseif Encounter.GetVar("phase") == 7 then
			Encounter.Call("BlockAnim")
			Encounter["progress"] = Encounter["progress"] + 1
			Encounter["didatk"] = true
		elseif Encounter.GetVar("phase") == 8 and not disableaddatk then
			Encounter.Call("BlockAnim")
			Encounter["didatk"] = true
			Encounter["progress"] = Encounter["progress"] + 1
		end
    end
end
 
 function BeforeDamageCalculation()
 
	if Encounter.GetVar("phase") == 6 then
	if Encounter["progress"] < 6 then
	SetDamage(0)
	
	else
	SetDamage(9999999)
	canspare = false
	end
	end
 
	if Encounter.GetVar("phase") == 7 then
		SetDamage(9999999)
	end
 
	if Encounter.GetVar("phase") == 4 then
	Encounter.Call("PlayCutscene","p5intro")
	SetDamage(0)
	
	fake_atksprite.SetAnimation({"spr_slice_o_0","spr_slice_o_1","spr_slice_o_2","spr_slice_o_3","spr_slice_o_4","spr_slice_o_5"},1/15,"UI/Battle")
	

	elseif Encounter.GetVar("phase") == 5 then
	if Encounter["progress"] < 10 then
	SetDamage(0)
	
	Encounter.Call("BlockAnim")
	
	
	else
	
	if Encounter["progress"] ~= 11 then
	SetDamage(6261)
	fake_atksprite.SetAnimation({"spr_slice_o_0","spr_slice_o_1","spr_slice_o_2","spr_slice_o_3","spr_slice_o_4","spr_slice_o_5"},1/10,"UI/Battle")
	Encounter.Call("PlayCutscene","p5end")
	else
	SetDamage(0)
	end
	
	
	end
	
	Encounter["progress"] = Encounter["progress"] + 1
	end
 end
 
 function OnDeath()
	if phase == 6 then
		Encounter.SetVar("cutscene",true)
	end
	
	if talkcount > 0 then
		--Kill()
	end
 end
 
 function mus()
	Audio.LoadFile("nyeh")
 end
 
 function OnSpare()
	if Encounter["phase"] == 4 then
		currentdialogue = ({"[noskip][func:sethead,Phase 4/huh]...?", "[noskip]ARE YOU REALLY\n[color:f2c900]SPARING[color:000000] ME?!", "[noskip][func:sethead,Phase 4/Thinking]THAT IS...", "[noskip][func:sethead,Phase 4/Well]GREAT,[w:4][func:sethead,Phase 4/Thinking] BUT...", "[noskip][func:sethead,Phase 4/nyeh...]IT'S A BIT LATE\nFOR THAT NOW...", "[noskip][func:sethead,Phase 4/...]...", "[noskip][func:mus][func:sethead,Phase 4/Well]BUT HEY![w:4] NOT ALL\nIS LOST YET!", "[noskip][func:sethead,Phase 4/Look!]JUST LOOK AT\nYOURSELF![w:4]\nYOU DID THE RIGHT\nTHING!", "[noskip][func:sethead,Phase 4/YES!]YOU ONLY NEEDED\nTHE SUPPORT OF\nME[w:4], THE GREAT\nPAPYRUS!","[noskip][func:State,DONE][next]"})
	elseif Encounter["phase"] == 6 and Encounter["progress"] == 6 then
		currentdialogue = ({"[noskip]...", "[noskip]ARE YOU...[w:4]\n[color:f2c900]SPARING[color:000000][w:4] ME?", "[noskip]I...", "[noskip][func:sethead,Phase 4/huh]ITS PRETTY LATE\nFOR THAT\nNOW[w:4],[func:sethead,Phase 4/...] AND...", "[noskip]I DON'T THINK\nWHAT I SAW\nWERE JUST\nILLUSIONS...",  "[noskip][func:mus][func:sethead,Phase 4/HEY!]BUT HEY![w:4][func:sethead,Phase 4/NYEH HEH] JUST\nLOOK AT\nYOURSELF!", "[noskip][func:sethead,Phase 4/Look!]YOU FINALLY\n DID THE RIGHT\nTHING!", "[noskip][func:sethead,Phase 4/YES!]YOU ONLY NEEDED\nTHE SUPPORT OF\nME[w:4], THE GREAT\nPAPYRUS!","[noskip][func:beginSpare][w:9999999][next]"})
	elseif Encounter["phase"] == 7 and Encounter["progress"] >= 4 then
	
		if talkcount < 1 then
			--currentdialogue = {"[noskip]...", "[noskip]DID YOU JUST...[w:4]\n[func:sethead,Phase 7/fading][color:f2c900]SPARE[color:000000][w:4] ME?", "[noskip]ITS...[w:4][func:sethead,Phase 7/can't take anymore of this] WAY TOO\nLATE FOR THAT.", "[noskip]THE GREAT\nPAPYRUS ISN'T IN\nGREAT CONDITION\nTO[waitall:2]...", "[noskip][func:sethead,Phase 7/fading ouch][w:8][next]","LIVE...", "[noskip][func:sethead,Phase 7/fading]WELL,[w:4] AT LEAST...[w:4]\nI GOT TO SEE YOU\nCHANGE...", "[noskip]BEFORE I GO...", "[noskip]I HOPE...[w:4] YOU DO A[w:4]\nLITTLE BETTER....", "[noskip]THE NEXT TIME\nAROUND...[func:sethead,Phase 7/fading ouch][w:4]", "[noskip][func:dustPaps][w:35][next]", "[noskip][func:beginSpare][w:9999999][next]"}
			currentdialogue = {"[noskip]...", "[noskip]DID YOU JUST...[w:4]\n[func:sethead,Phase 7/fading][color:f2c900]SPARE[color:000000][w:4] ME?", "[noskip]DID YOU ACTUALLY\nCHANGE[w:4], OR...[func:sethead,Phase 7/fading ouch]", "DID YOU JUST\nWANT TO SEE\nWHAT WOULD\nHAPPEN...?", "...", "WELL...", "ITS...[w:4][func:sethead,Phase 7/can't take anymore of this] WAY TOO\nLATE NOW.", "THE GREAT\nPAPYRUS ISN'T IN\nGREAT CONDITION\nTO[waitall:2]...", "[noskip][func:sethead,Phase 7/fading ouch][w:8][next]","LIVE...", "[noskip][func:sethead,Phase 7/fading]WELL,[w:4] AT LEAST...[w:4]\nI GOT TO SEE YOU\nCHANGE...", "[noskip]BEFORE I GO...", "[noskip]I HOPE...[w:4] YOU DO A[w:4]\nLITTLE BETTER...", "[noskip]THE NEXT TIME\nAROUND...[func:sethead,Phase 7/fading ouch][w:4]", "[noskip][func:dustPaps][w:35][next]", "[noskip][func:beginSpare][w:9999999][next]"}
		else
			currentdialogue = {"[noskip]...", "[noskip]DID YOU JUST...[w:4]\n[func:sethead,Phase 7/fading][color:f2c900]SPARE[color:000000][w:4] ME?", "[noskip]DID YOU ACTUALLY\nCHANGE[w:4], OR...[func:sethead,Phase 7/fading ouch]", "DID YOU JUST\nWANT TO SEE\nWHAT WOULD\nHAPPEN...?", "...", "WELL...", "ITS...[w:4][func:sethead,Phase 7/can't take anymore of this] WAY TOO\nLATE NOW.", "THE GREAT\nPAPYRUS ISN'T IN\nGREAT CONDITION\nTO[waitall:2]...", "[noskip][func:sethead,Phase 7/fading ouch][w:8][next]","LIVE...", "[noskip][func:sethead,Phase 7/fading]WELL,[w:4] AT LEAST...[w:4]\nI GOT TO SEE YOU\nCHANGE...", "[noskip]BEFORE I GO...", "[noskip]I HOPE...[w:4] YOU DO A[w:4]\nLITTLE BETTER...", "[noskip]THE NEXT TIME\nAROUND...[func:sethead,Phase 7/fading ouch][w:4]", "[noskip][func:dustPaps][w:35][next]", "[noskip][func:beginSpare][w:9999999][next]"}
		end

	end

 end

-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)
 if command == "TALK" then
	talkcount = talkcount + 1
	if talkcount == 1 then
	commands = {}
	currentdialogue = ({"I KNEW IT WAS\nINEVITABLE FROM\nTHE START.", "IF IT WAS\nALWAYS GOING TO\nEND THIS WAY...", "[noskip][func:phase8part1][waitall:2]WHAT WAS IT THAT\nI WAS EXPECTING?", "[noskip][waitall:2]...","[noskip]WHEN I FOUGHT\nYOU...", "[noskip][func:sethead,Phase 7/fading]I WAS LOOKING FOR\nA WAY OUT OF ALL\nOF THIS.", "[noskip][func:phase8continue][func:sethead,Phase 7/fading ouch]EVERYBODY'S\nHOPES AND\nDREAMS...", "[noskip][func:sethead,Phase 7/fading]ALL OF THOSE\nFALLEN ARE\nCOUNTING ON ME\nTO END THIS.","[noskip][func:sethead,Phase 7/nyeh!]ONLY THE GREAT\nPAPYRUS CAN\nOUTLAST YOUR\nDETERMINATION.","[noskip][func:sethead,Phase 7/a way out]AND NOW THAT I\nKNOW A WAY OUT...", "[noskip][func:sethead,Phase 7/nyeh!]I AM DETERMINED\nTO SEE IT\nTHROUGH.", "[noskip][func:sethead,Phase 7/a way out]I AM EVERYBODY'S\nLAST HOPE.","[noskip]ALL OF THEM ARE\nCOUNTING ON ME\nTO DEFEAT YOU.","[noskip][func:sethead,Phase 7/fading ouch][waitall:3]...","[noskip][func:sethead,Phase 7/nyeh!][color:FF0000][func:phase8continue][waitall:2]AND I WILL...[w:48][next]", "[noskip][w:88][next]", "[noskip][voice:v_papyrus_royalguard]I DON'T HAVE\nTO BE LIKE\nUNDYNE TO DEFEAT\nYOU.","[noskip][voice:v_papyrus_royalguard]IT'S JUST ONLY\nFAIR THAT IN HER\nMEMORY...", "[noskip][voice:v_papyrus_royalguard][color:FF0000]I,[w:4] PAPYRUS,[w:4] THE\nLAST ROYAL\nGUARD...", "[noskip][voice:v_papyrus_royalguard][color:FF0000][waitall:2]STRIKE YOU DOWN.","[noskip][func:phase8continue][next]","[noskip][w:450][func:State,ACTIONSELECT]"})
	BattleDialog({"You tell Papyrus your\rdetermination was what\rlead you here.", "Your resolve to see what's\rnext.", "You tell him that this\rdriving force is what made\rhis loss inevitable."})
	elseif talkcount == 2 then
	--currentdialogue = ({"[waitall:2]SO WE HAVE\nBEEN THROUGH\nTHIS BEFORE...", "[waitall:3]...."})
	--BattleDialog({"You tell Papyrus that you've\rbeen through this journey\rcountless times...","and that you can read him\nlike a book."})
	elseif talkcount >= 3 then
	--BattleDialog({"[color:FF0000][voice:v_floweymad]Stop wasting time.[w:4]\nJust kill him already."})
	end
 end
   
end