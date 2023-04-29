helper = require("wave_helper")
Arena.resize(280,132)
bullets = {}
Encounter.Call("ChangeSoul","Blue")

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")


spawntimer = 0

function bones1()
    local b = CreateProjectile("Bones/Smaller",Arena.width/2+5,-Arena.height/2+12)
    b.sprite.SetParent(mask)
    b.SetVar("Type","kr1")
    b.SetVar("xvel",-2)
    b.SetVar("yvel",0)
    table.insert(bullets,b)
end

function bones2()
    local b = CreateProjectile("Bones/tall",-Arena.width/2-5,0)
    b.sprite.SetParent(mask)
    local rand = math.random(1,2)
    if rand == 1 then
    b.SetVar("Type","krB")
    b.sprite.color = {0,1,1}
    else
    b.SetVar("Type","krO")
    b.sprite.color = {1,0.5,0}
    end
    
    b.SetVar("xvel",2)
    b.SetVar("yvel",0)
    table.insert(bullets,b)
end



function bones2start()
helper:AddRepeatEvent(bones2,1,4)
end
helper:AddRepeatEvent(bones1,1,10)
helper:AddEvent(bones2start,10.5)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()

if spawntimer >= 17.16667 then
EndWave()
end



for i,v in pairs(bullets) do

if v.isactive then
v.Move(v.GetVar("xvel")*Time.mult,v.GetVar("yvel")*Time.mult)
end

end


end


function OnHit(bullet)
Encounter.Call("HandleHit",bullet)
end

function EndingWave()
mask.Remove()
Encounter.Call("ChangeSoul","Red")
end