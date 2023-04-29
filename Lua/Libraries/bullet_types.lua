local bullet2 = {}

bullet2.Types = {} -- List of our defined types.
bullet2.ShieldTypes = {} -- Types that interact with the Green Soul.

function bullet2:NewType(name,onhit,onshieldhit); -- Add a new bullet type. onhit is a function that takes the bullet hit as an argument.
self.Types[name] = onhit
self.ShieldTypes[name] = onshieldhit
end

function bullet2:RemoveType(name); -- Remove a type from our list if you don't need it anymore.

if self.Types[name] then self.Types[name] = nil end
if self.ShieldTypes[name] then self.ShieldTypes[name] = nil end
end

function bullet2:HandleCollision(bullet); -- Handles bullet collision.
local Type = bullet.GetVar("Type")

if self.Types[Type] then

return self.Types[Type](bullet)

else


-- Some default variables you can set on your bullet if you don't give it a type.
local dmg = bullet.GetVar("Damage") or math.ceil(Player.maxhp*0.08)
local inv = bullet.GetVar("Inv") or 0.5
local def = bullet.GetVar("IgnoreDef") or false
local sfx = bullet.GetVar("PlaySound") or true
local stay = bullet.GetVar("StayOnHit") or false

if not Player.ishurting and not stay then
bullet.Remove()
end
Player.Hurt(dmg,inv,def,sfx)


end

end

function bullet2:HandleShieldCollision(bullet)
local Type = bullet.GetVar("Type")

if self.ShieldTypes[Type] then
self.ShieldTypes[Type](bullet)
return 

else

bullet.Remove()
Audio.PlaySound("ding")

end

end

return bullet2