local ver = "0.02"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Kassadin" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Kassadin/master/Kassadin.lua', SCRIPT_PATH .. 'Kassadin.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No Kassadin updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Kassadin/master/Kassadin.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local KassadinMenu = Menu("Kassadin", "Kassadin")

KassadinMenu:SubMenu("Combo", "Combo")

KassadinMenu.Combo:Boolean("Q", "Use Q in combo", true)
KassadinMenu.Combo:Boolean("W", "Use W in combo", true)
KassadinMenu.Combo:Boolean("E", "Use E in combo", true)
KassadinMenu.Combo:Boolean("R", "Use R in combo", true)
KassadinMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
KassadinMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
KassadinMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
KassadinMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
KassadinMenu.Combo:Boolean("RHydra", "Use RHydra", true)
KassadinMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
KassadinMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
KassadinMenu.Combo:Boolean("Randuins", "Use Randuins", true)


KassadinMenu:SubMenu("AutoMode", "AutoMode")
KassadinMenu.AutoMode:Boolean("Level", "Auto level spells", false)
KassadinMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
KassadinMenu.AutoMode:Boolean("Q", "Auto Q", false)
KassadinMenu.AutoMode:Boolean("W", "Auto W", false)
KassadinMenu.AutoMode:Boolean("E", "Auto E", false)
KassadinMenu.AutoMode:Boolean("R", "Auto R", false)

KassadinMenu:SubMenu("LaneClear", "LaneClear")
KassadinMenu.LaneClear:Boolean("Q", "Use Q", true)
KassadinMenu.LaneClear:Boolean("W", "Use W", true)
KassadinMenu.LaneClear:Boolean("E", "Use E", true)
KassadinMenu.LaneClear:Boolean("R", "Use R", true)
KassadinMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
KassadinMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

KassadinMenu:SubMenu("Harass", "Harass")
KassadinMenu.Harass:Boolean("Q", "Use Q", true)
KassadinMenu.Harass:Boolean("W", "Use W", true)

KassadinMenu:SubMenu("KillSteal", "KillSteal")
KassadinMenu.KillSteal:Boolean("Q", "KS w Q", true)
KassadinMenu.KillSteal:Boolean("W", "KS w W", true)
KassadinMenu.KillSteal:Boolean("E", "KS w E", true)
KassadinMenu.KillSteal:Boolean("R", "KS w R", true)

KassadinMenu:SubMenu("AutoIgnite", "AutoIgnite")
KassadinMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

KassadinMenu:SubMenu("Drawings", "Drawings")
KassadinMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

KassadinMenu:SubMenu("SkinChanger", "SkinChanger")
KassadinMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
KassadinMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if KassadinMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if KassadinMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 650) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end

            if KassadinMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 200) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if KassadinMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if KassadinMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if KassadinMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if KassadinMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if KassadinMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 700) then
			  CastSkillShot(_E, target)
	    end

            if KassadinMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 650) then
		     if target ~= nil then 
                         CastTargetSpell(target, _Q)
                     end
            end

            if KassadinMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if KassadinMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if KassadinMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if KassadinMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 200) then
			CastSpell(_W)
	    end
	    
	    
            if KassadinMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 500) and (EnemiesAround(myHeroPos(), 700) >= KassadinMenu.Combo.RX:Value()) then
			CastSkillShot(_R, target.pos)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 650) and KassadinMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 

                if IsReady(_W) and ValidTarget(enemy, 200) and KassadinMenu.KillSteal.W:Value() and GetHP(enemy) < getdmg("W",enemy) then
		                      CastSpell(_W)
  
                end

                if IsReady(_E) and ValidTarget(enemy, 700) and KassadinMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                       CastSkillShot(_E, target)
  
                end

                
                if IsReady(_R) and ValidTarget(enemy, 500) and KassadinMenu.KillSteal.R:Value() and GetHP(enemy) < getdmg("R",enemy) then
		                       CastSkillShot(_R, target.pos)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if KassadinMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 650) then
	        	CastTargetSpell(closeminion, _Q)
                end

                if KassadinMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 200) then
	        	CastSpell(_W)
	        end

                if KassadinMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 700) then
	        	 CastSkillShot(_E, target)
	        end

                if KassadinMenu.LaneClear.R:Value() and Ready(_R) and ValidTarget(closeminion, 500) then
	        	 CastSkillShot(_R, target.pos)
	        end

                if KassadinMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if KassadinMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if KassadinMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 650) then
		      CastTargetSpell(target, _Q)
          end
        end 
        if KassadinMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 200) then
	  	      CastSpell(_W)
          end
        end
        if KassadinMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 700) then
	   end	       CastSkillShot(_E, target)
        end
        if KassadinMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 500) then
		      CastSkillShot(_R, target.pos)
	  end
        end
                
	--AUTO GHOST
	if KassadinMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if KassadinMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 650, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
                

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if KassadinMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Kassadin</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





