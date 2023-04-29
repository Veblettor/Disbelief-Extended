local ffwiz = {}

ffwiz.LV = 99
ffwiz.HP = 999
ffwiz.ATK = 999
ffwiz.DEF = 999
ffwiz.NAME = "FFWIZARD"
ffwiz.SoulColor = {0.1,0.1,0.1}

function ffwiz:Load()
Player.name = ffwiz.NAME
Player.lv = ffwiz.LV
Player.SetMaxHPShift(ffwiz.HP,0,true,true,false)
Player.hp = 999
Player.atk = ffwiz.ATK
Player.def = ffwiz.DEF
Player.sprite.color = ffwiz.SoulColor
Player2.SoulModes["Red"].Color = self.SoulColor
UI.hpbar.background.absx = UI.hpbar.background.absx - 50
UI.hplabel.absx = UI.hplabel.absx - 50
UI.hptext.absx = UI.hptext.absx - 50
UI.namelv.SetText("[instant]"..string.upper(ffwiz.NAME).."  LV ??")
end

return ffwiz