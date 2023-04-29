local bg = {}

local function lerp(a,b,t)
return a + (b - a) * t
end

bg.Sprite = CreateSprite("gradient","BelowUI")
bg.Sprite.SetPivot(0.5,0)
bg.Sprite.x = 320
bg.Sprite.y = 0
bg.Sprite.alpha = 0

bg.Countdown = 0
bg.MaxScale = 1.25
bg.MinScale = 0.75
bg.Speed = 0.005
bg.GoingDown = false
bg.Paused = false
bg.FadingIn = false
bg.Active = false
function bg:SetColor(color)
self.Sprite.color = color
end

function bg:SetActive(active)

self.Active = active

if active then
self.Sprite.yscale = self.MinScale
self.GoingDown = false
self.Countdown = 0
self.Paused = false
self.FadingIn = true
else
self.Sprite.alpha = 0
end



end

function bg:Update()


if self.FadingIn then

self.Sprite.alpha = self.Sprite.alpha + self.Speed*Time.mult

if self.Sprite.alpha >= 0.5 then
self.FadingIn = false
end

elseif self.Active then

if self.Sprite.alpha >= 0.5 then
self.Sprite.alpha = self.Sprite.alpha - self.Speed*Time.mult
elseif self.Sprite.alpha <= 0.25 then
self.Sprite.alpha = self.Sprite.alpha + self.Speed*Time.mult
end

end

if self.Active then

if self.Paused then
self.Countdown = self.Countdown - 1

if self.Countdown <= 0 then
self.Paused = false

if self.Sprite.yscale >= self.MaxScale-0.01 then
self.GoingDown = true
else
self.GoingDown = false
end

end

elseif not self.Paused and self.GoingDown then

self.Sprite.yscale = lerp(self.Sprite.yscale,self.MinScale,0.066*Time.mult)

if self.Sprite.yscale <= self.MinScale+0.01 then
self.Paused = true
self.Countdown = 5
end

elseif not self.Paused and not self.GoingDown then
self.Sprite.yscale = lerp(self.Sprite.yscale,self.MaxScale,0.066*Time.mult)

if self.Sprite.yscale >= self.MaxScale-0.01 then
self.Paused = true
self.Countdown = 5
end

end

end

end

return bg