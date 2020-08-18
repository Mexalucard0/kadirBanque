ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)


function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght

	AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
	
	blockinput = true --Blocks new input while typing if **blockinput** is used
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		Citizen.Wait(0)
	end 
		 
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
end

local Central = {
    	Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 0, 0}, Title = "FL~g~EE~s~CA central"},
        Data = { currentMenu = "Bienvenue à la FL~g~EE~s~CA central ." },
        Events = {
        onExited = function(self, _, btn, CMenu, menuData, currentButton, currentBtn, currentSlt, result, slide, onSlide) 
			FreezeEntityPosition(GetPlayerPed(-1), false)
		end,	    
        onSelected = function(self, _, btn, CMenu, menuData, currentButton, currentSlt, result)
                if btn.name == "Prénom" then local result = GetOnscreenKeyboardResult() if result ~= nil then ResultPrenom = result end elseif btn.name == "Nom" then local result = GetOnscreenKeyboardResult() if result ~= nil then ResultNom = result end elseif btn.name == "Date de naissance" then local result = GetOnscreenKeyboardResult() if result ~= nil then ResultDateDeNaissance = result end  elseif btn.name == "Sexe" then local result = GetOnscreenKeyboardResult() if result ~= nil then ResultSexe = result end 
                elseif btn.name == "~g~Confirmer" then
                    TriggerServerEvent("bank:carte")
                    FreezeEntityPosition(GetPlayerPed(-1), false)
                    self:CloseMenu(true)
                    Citizen.Wait(1500)
                    ESX.ShowNotification("~o~Aurevoir~s~ , passer une bonne journée .")
            end
        end,
    },

    Menu = {

        ["Bienvenue à la FL~g~EE~s~CA central ."] = {
            b = {
                {name = "Prénom", ask = "James" },    
                {name = "Nom", ask = "Gordon" },
                {name = "Date de naissance", ask = "jj/mm/aa" }, 
                {name = "Sexe", ask = "m/f" },
                {name = "~g~Confirmer" },  
            } 
        }
    }
}

--- Parler au ped

local positionCentral = {
    {x = 252.18, y = 223.13, z = 106.28}
}


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(positionCentral) do

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, positionCentral[k].x, positionCentral[k].y, positionCentral[k].z)
        
        if (GetDistanceBetweenCoords(coords, dist, true) < 2.0) then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler avec ~o~le banquier !")
            if IsControlJustReleased(1, 51) then
                DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
                TriggerServerEvent('bank:openverif')
            end
        end
            
        end
    end
end)

-- On ouvre le menu

RegisterNetEvent("openmenu")
AddEventHandler("openmenu", function()
    FreezeEntityPosition(GetPlayerPed(-1), true)
    ESX.DrawMissionText('[~b~Vous~s~] Bonjour monsieur , on ma dis que c\'étais ici pour je prend ma carte banquaire', 2500)
    Citizen.Wait(3000)
    ESX.DrawMissionText('[~o~Banquier~s~] Bonjour , oui c\'est biens ici pour prendre/créer votre carte banquaire .', 2500)
    Citizen.Wait(3000)
    ESX.DrawMissionText('[~b~Vous~s~] D\'accord moi je voudrais la créer s\'il vous plait .', 2500)
    Citizen.Wait(3000)
    ESX.DrawMissionText('[~o~Banquier~s~] Pas de problème je vous laisse remplir vos informations et me donner ~g~25$~s~. Merci', 2500)
    CreateMenu(Central)
end)

-- Petit ped

Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_m_movprem_01")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", "s_m_m_movprem_01", 252.18, 223.13, 105.28, 150.00, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
end)

-- Blip

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #positionCentral, 1 do
        local bBlip = AddBlipForCoord(positionCentral[i].x, positionCentral[i].y, positionCentral[i].z)
        SetBlipSprite (bBlip, 277)
		SetBlipDisplay(bBlip, 4)
		SetBlipScale  (bBlip, 0.8)
		SetBlipColour (bBlip, 2)
        SetBlipAsShortRange(bBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Banque Principale")
        EndTextCommandSetBlipName(bBlip)
	end
end)








































                                                                                                                                                                                                                                                                print("^0======================================================================^7") print("^2Creator ^0: Kadir") print("My discord :^2 https://discord.gg/Kp8ej8a") print("My Github :^2 https://github.com/Kadir-Fivem") print("^0======================================================================^7") 	
