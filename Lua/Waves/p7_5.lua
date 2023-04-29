helper = require("wave_helper")
Arena.resize(280,132)
bullets = {}
Encounter.Call("ChangeSoul","Blue")

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")

orange = CreateProjectile("Bones/tall",Arena.width/2+5,0)
orange.sprite.SetParent(mask)


orange.SetVar("Type","krO")
orange.sprite.color = {1,0.5,0}


orange.SetVar("xvel",3)
orange.SetVar("yvel",0)

function bones()
    local b = CreateProjectile("Bones/Smaller",Arena.width/2+5,-Arena.height/2+12)
    b.sprite.SetParent(mask)
    b.SetVar("Type","kr1")
    b.SetVar("xvel",-2)
    b.SetVar("yvel",0)
    table.insert(bullets,b)
end

spawntimer = 0
helper:AddRepeatEvent(bones,1,10)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()
if spawntimer >= 12.5 then
EndWave()
end

orange.Move(orange.GetVar("xvel")*Time.mult,orange.GetVar("yvel")*Time.mult)

if orange.absx <= Arena.x - Arena.width/2-5 then
orange.SetVar("xvel",3)
elseif orange.absx >= Arena.x + Arena.width/2+5 then
orange.SetVar("xvel",-3)
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