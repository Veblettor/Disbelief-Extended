helper = require("wave_helper")
Arena.resize(280,132)
bullets = {}
Encounter.Call("ChangeSoul","Blue")

local mask = CreateSprite("empty","BelowBullet")
mask.Scale(Arena.width,Arena.height)
mask.x = Arena.x
mask.y = Arena.y+Arena.height/2+5
mask.Mask("box")
rand = math.random(1,2)
x1 = 0
xvel1 = 0
spawntimer = 0

function jumps()
    rand = math.random(1,2)
    if rand == 1 then
        xvel1 = -2
        x1 = Arena.width/2+132
    else
        xvel1 = 2
        x1 = -Arena.width/2-132
    end
        
        local b = CreateProjectile("Bones/Jump",x1,-Arena.height/2+19)
        b.sprite.SetParent(mask)
        b.sprite.Scale(0.5,0.5)
        b.SetVar("Type","kr1")
        b.SetVar("xvel",xvel1)
        b.SetVar("yvel",0)
        b.ppcollision = true
        table.insert(bullets,b)

        local x
        local xvel

        local b1 = CreateProjectile("Bones/tall",-x1,0)
        b1.sprite.SetParent(mask)
        local rand2 = math.random(1,2)
        if rand2 == 1 then
        b1.SetVar("Type","krB")
        b1.sprite.color = {0,1,1}
        else
        b1.SetVar("Type","krO")
        b1.sprite.color = {1,0.5,0}
        end

        b1.SetVar("xvel",-xvel1)
        b1.SetVar("yvel",0)
        table.insert(bullets,b1)
end


function colors()
    local b1 = CreateProjectile("Bones/tall",-Arena.width/2-5,0)
    b1.sprite.SetParent(mask)
    
    
    b1.SetVar("Type","krB")
    b1.sprite.color = {0,1,1}
    
    
    b1.SetVar("xvel",2)
    b1.SetVar("yvel",0)
    table.insert(bullets,b1)
    
    local b2 = CreateProjectile("Bones/tall",Arena.width/2+5,0)
    b2.sprite.SetParent(mask)
    
    
    b2.SetVar("Type","krO")
    b2.sprite.color = {1,0.5,0}
    
    
    b2.SetVar("xvel",-2)
    b2.SetVar("yvel",0)
    table.insert(bullets,b2)
    
end

function addcolors()
    helper:AddRepeatEvent(colors,1,8)
end

jumps()
helper:AddEvent(jumps,2)
helper:AddEvent(addcolors,6)
function Update()
spawntimer = spawntimer + Time.dt
helper:Update()
if spawntimer >= 16.66667 then
EndWave()
end

if spawntimer % 120 == 0 and spawntimer < 360 then


end

if spawntimer < 360 and spawntimer % 120 == 0 then

end

if spawntimer > 420 and spawntimer % 60 == 0 and spawntimer < 900 then


end

for i = 1, #bullets do

local bullet = bullets[i]
bullet.Move(bullet.GetVar("xvel")*Time.mult,bullet.GetVar("yvel")*Time.mult)
end


end


function OnHit(bullet)
Encounter.Call("HandleHit",bullet)
end

function EndingWave()
mask.Remove()
Encounter.Call("ChangeSoul","Red")
end