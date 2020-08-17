ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(2000)
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

function retire_argent()
    local amount = KeyboardInput('Retiré de l\'argent', '', 4)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            TriggerServerEvent('RetiréArgent', amount)
        end
    end
end

function depot_argent()
    local amount = KeyboardInput('Poser de l\'argent', '', 4)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            TriggerServerEvent('PoserArgent', amount)
        end
    end
end

local PlayerMoney, PlayerCash = 0, 0

RMenu.Add('Bank', 'main', RageUI.CreateMenu("Fl~g~ee~s~ca Banque", "Bienvenue a la Fl~g~ee~s~ca !", nil, nil, "bank", "interaction_bgd"))

RMenu.Add('Bank', 'compte', RageUI.CreateMenu("Fl~g~ee~s~ca Informations", "Informations de votre compte :", nil, nil, "bank", "interaction_bgd"))

Citizen.CreateThread(function()
    while true do
    RageUI.IsVisible(RMenu:Get('Bank', 'main'),  function()

         --------------------------------------- Sous Menu -----------------------------        
         RageUI.Button("Dépot", nil, {RightLabel = "~g~Confirmer ~b~ →"}, true, function(Hovered, Active, Selected)
            if (Selected) then
                depot_argent()
                RageUI.CloseAll()
            end
        end)
        RageUI.Button("Retrait", nil, {RightLabel = "~g~Confirmer ~b~ →"}, true, function(Hovered, Active, Selected)
            if (Selected) then
                retire_argent()
                RageUI.CloseAll()
            end
        end)
        RageUI.Button("Informations du compte", nil, { RightLabel = "~b~ →" },true, function()
        end, RMenu:Get('Bank', 'compte'))                                                
    end, function()
    end)

    RageUI.IsVisible(RMenu:Get('Bank', 'compte'),  function()


        RageUI.Button("Propriétaire du compte : ", nil, {RightLabel = "~b~ ".. GetPlayerName(PlayerId()) .." "}, true, function(Hovered, Active, Selected)
        end)


        RageUI.Button("Solde banquaire ~b~:", nil, {RightLabel = "~g~$".. PlayerMoney .."" }, true, function(Hovered, Active, Selected)
        end) 

        RageUI.Button("~g~Retour", nil, { RightLabel = "→" },true, function()
        end, RMenu:Get('Bank', 'main'))         
    end, function()
    end, 1)
    Citizen.Wait(0)
end
end)
-- Début Solde

RegisterNetEvent("solde:argent")
AddEventHandler("solde:argent", function(money, cash)
    PlayerMoney = tonumber(money)
end)

Citizen.CreateThread(function()
    while true do
        Config.GetPlayerMoney()
        Wait(2500)
    end
end)

-- Fin du solde


--- Menu de la positon


local position = {
    {x = 149.92, y = -1040.83, z = 29.37}, 
	{x=-1212.980, y=-330.841, z=37.56},
	{x=-2962.582, y=482.627, z=15.703},
	{x=-112.202, y=6469.295, z=31.626},
	{x=314.187, y=-278.621, z=54.170},
	{x=-351.534, y=-49.529, z=49.042},
	{x=246.59, y=223.51, z=106.29},
	{x=1175.0643310547, y=2706.6435546875, z=38.094036102295},
}    


RegisterNetEvent("menuopen")
AddEventHandler("menuopen", function()
    RageUI.Visible(RMenu:Get('Bank', 'main'), not RageUI.Visible(RMenu:Get('Bank', 'main')))
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(position) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

            if dist <= 0.6 then

                   ESX.DrawMissionText("Appuyer sur ~w~[~b~E~w~] pour ouvrir votre compte banquaire")

            if dist < 0.6 then

                if IsControlJustPressed(1,51) then
                    TriggerServerEvent('bank:menu')
                end
            end
        elseif (GetDistanceBetweenCoords(coords, dist, true) < 1.3) then
            RageUI.CloseAll()
        end
        end
    end
end)


-- Fin menu postition

-- Blips

Citizen.CreateThread(function()

	for i=1, #Config.kBank, 1 do

		local kblip = AddBlipForCoord(Config.kBank[i].x, Config.kBank[i].y, Config.kBank[i].z)

		SetBlipSprite (kblip, 434)
		SetBlipDisplay(kblip, 4)
		SetBlipScale  (kblip, 0.8)
		SetBlipColour (kblip, 2)
        SetBlipAsShortRange(kblip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Banque")
        EndTextCommandSetBlipName(kblip)
	end

end)


-- Fin blips