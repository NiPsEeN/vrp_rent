vRPrent = {}
Tunnel.bindInterface("vrp_rent",vRPrent)
Proxy.addInterface("vrp_rent",vRPrent)
PMserver = Tunnel.getInterface("vrp_rent","vrp_rent")
vRPserver = Tunnel.getInterface("vRP","vrp_rent")
vRP = Proxy.getInterface("vRP")


local CreateThread = Citizen.CreateThread
local Wait = Citizen.Wait
local isPressed = IsDisabledControlJustPressed
local rented = false
local Config = {
    isMenu = false,
    markerType = 44,
    rgba = vector4(255,255,255,255),
    theVeh1 = 'T20',
    theVeh2 = 'Faggio',
    theVeh3 = 'BMX',
    SpawnVeh = vector3(-235.08,-986.15,29.17),
    Heading = 338.06,

    ['RentInfo'] = {
        pos = vector3(-257.49057006836,-980.89569091797,31.219993591309),
        distMinim = 5.0,

        ['Lang'] = {
            RentText = '~p~Rent~w~ System',
            EnterRent = 'Apasa ~g~[E]~w~ pentru a deschide meniul de ~r~Inchirieri',
            PriceRent = 'Pret: ~g~'
        },
        ['Positions'] = {
            posMainRectangle = vector4(0.5,0.5,0.6,0.4), -- format: x,y,width,height
            posLinexd = vector4(0.5,0.3,0.6,0.040), -- format: x,y,width,height
        }
    },
}

CreateThread(function()

	local cIcon = CreateRuntimeTxd("carIcon")
	CreateRuntimeTextureFromImage(cIcon, "carIcon", "img/photo1.png")

	local cIcon1 = CreateRuntimeTxd("carIcon1")
	CreateRuntimeTextureFromImage(cIcon1, "carIcon1", "img/photo2.png")

	local cIcon2 = CreateRuntimeTxd("carIcon2")
    CreateRuntimeTextureFromImage(cIcon2, "carIcon2", "img/photo3.png")
    
end)

function drawInfoText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

CreateThread(function()
    while true do
        local textOpen = Config['RentInfo']['Lang'].EnterRent
        local textPrice = Config['RentInfo']['Lang'].PriceRent
        local coordsRent = Config['RentInfo'].pos
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local distance = #(coords - coordsRent)
        if distance <= Config['RentInfo'].distMinim and not Config.isMenu then
            drawInfoText(textOpen)
            DrawText3D(coordsRent[1],coordsRent[2],coordsRent[3], Config['RentInfo']['Lang'].RentText, 1.0,4) 
            if isPressed(0,38) then
                if not rented then
                    Config.isMenu = true
                else
                    vRP.notify({'~y~Rent:~w~ Deja ai inchiriat o masina!'})
                end
            end
        elseif Config.isMenu then
        	StartScreenEffect("MenuMGHeistOut", 50, false)
            DisableControlAction(0,24,true)
            DisableControlAction(0,47,true)
            DisableControlAction(0,58,true)
            DisableControlAction(0,263,true)
            DisableControlAction(0,264,true)
            DisableControlAction(0,257,true)
            DisableControlAction(0,140,true)
            DisableControlAction(0,141,true)
            DisableControlAction(0,142,true)
            DisableControlAction(0,143,true)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            SetPlayerControl(PlayerId(),false,134)

            drawScreenText(0.5, 0.66, 0,0, 0.38, "~w~Anuleaza", 255, 255, 255, 230, 1, 7, 1)
            drawScreenText(0.5, 0.277, 0,0, 0.60, "~w~Rent Menu",255, 255, 255,255,1,2,1)
            drawScreenText(0.5, 0.33, 0,0, 0.56, "~w~Alege masina pe care doresti sa o inchiriezi",255, 255, 255,255,1,2,1)
            DrawRect(Config['RentInfo']['Positions'].posMainRectangle[1],Config['RentInfo']['Positions'].posMainRectangle[2],Config['RentInfo']['Positions'].posMainRectangle[3],Config['RentInfo']['Positions'].posMainRectangle[4], 25,25,25,210)
            DrawRect(Config['RentInfo']['Positions'].posLinexd[1],Config['RentInfo']['Positions'].posLinexd[2],Config['RentInfo']['Positions'].posLinexd[3],Config['RentInfo']['Positions'].posLinexd[4], 132,102,226,255) -- linie cacatpisat
            ShowCursorThisFrame()
            DrawSprite("carIcon2","carIcon2",0.50, 0.50,0.13,0.24,0.0,255,255,255,255) -- photo 3
            DrawSprite("carIcon1","carIcon1",0.30, 0.50,0.11,0.14,0.0,255,255,255,255)  -- photo 2 
            DrawSprite("carIcon","carIcon",0.70, 0.50,0.11,0.14,0.0,255,255,255,255)  -- photo1
            if(isCursorInPosition(0.5, 0.68, 0.070, 0.020))then  
                SetMouseCursorSprite(5)
                if(isPressed(0, 24))then
                    Config.isMenu = false
                    StopScreenEffect("MenuMGHeistIn")
                end
            elseif(isCursorInPosition(0.50, 0.50, 0.13, 0.20)) then
                    SetMouseCursorSprite(5)
                    if(isPressed(0, 24))then
                        Config.isMenu = false
					    SetPlayerControl(PlayerId(),true,134)
                         local minute = KeyboardInput("Pe cate minute vrei sa inchiriezi masina? (T20):", "", 3)
                         if(minute ~= "") and (minute ~= nil) and (tonumber(minute))then
                            minute = minute
                            TriggerServerEvent('Jegyx:RentCar',minute,Config.theVeh1)
                        else
                            print('Failed :c | '..type(minute))
                        end
				    end
            elseif(isCursorInPosition(0.30, 0.50, 0.11, 0.14)) then
                SetMouseCursorSprite(5)
                if(isPressed(0, 24))then
                    Config.isMenu = false
                    SetPlayerControl(PlayerId(),true,134)
                    local minute = KeyboardInput("Pe cate minute vrei sa inchiriezi scuterul? (Faggio):", "", 3)
                    if(minute ~= "") and (minute ~= nil) and (tonumber(minute))then
                        minute = minute
                        TriggerServerEvent('Jegyx:RentCar',minute,Config.theVeh2)
                    else
                        print('Failed :c | '..type(minute))
                    end
                end
            elseif(isCursorInPosition(0.70, 0.50, 0.11, 0.14)) then
                SetMouseCursorSprite(5)
                if(isPressed(0, 24))then
                    Config.isMenu = false
                    SetPlayerControl(PlayerId(),true,134)
                    local minute = KeyboardInput("Pe cate minute vrei sa inchiriezi bicicleta? (BMX):", "", 3)
                    if(minute ~= "") and (minute ~= nil) and (tonumber(minute))then
                        minute = minute
                        TriggerServerEvent('Jegyx:RentCar',minute,Config.theVeh3)
                    else
                        print('Failed :c | '..type(minute))
                    end
                end
            else
                SetMouseCursorSprite(0)
            end
        else
            Wait(2500)
        end
        Wait(1)
        if not Config.isMenu then
            SetPlayerControl(PlayerId(),true,134)
        end
    end
end)

function drawScreenText(x,y ,width,height,scale, text, r,g,b,a, outline, font, center)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
	SetTextCentre(center)
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function isCursorInPosition(x, y, width, height)
    local sx, sy = GetActiveScreenResolution()
    local cx, cy = GetNuiCursorPosition()
    local cx, cy = (cx / sx), (cy / sy)

    local width = width / 2
    local height = height / 2

    if (cx >= (x - width) and cx <= (x + width)) and (cy >= (y - height) and cy <= (y + height)) then
        return true
    else
        return false
    end
end

function DrawText3D(x,y,z, text, scl,font) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function CreateCar(theVeh,theMins,pos,heading) -- van
    local hash = GetHashKey(theVeh)
    local n = 0
    while not HasModelLoaded(hash) and n < 500 do
        RequestModel(hash)
        Citizen.Wait(10)
        n = n+1
    end
    if HasModelLoaded(hash) then
        rented = false
        veh = CreateVehicle(hash,pos,heading,true,false)
        SetEntityHeading(veh,heading)
        SetEntityInvincible(veh,false)
        SetModelAsNoLongerNeeded(hash)
        SetVehicleLights(veh,2)
        SetVehicleColours(veh,147,41)
        SetVehicleNumberPlateTextIndex(veh,2)
        SetVehicleNumberPlateText(veh,"RENT-VEH")
        SetPedIntoVehicle(GetPlayerPed(-1),veh,-1)
        SetEntityAsMissionEntity(veh, true, true)
        for i = 0,24 do
            SetVehicleModKit(veh,0)
            RemoveVehicleMod(veh,i)
        end
        Citizen.SetTimeout(theMins * 60 * 1000,function()
            if DoesEntityExist(veh) then
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
                vRP.notify({'~y~Rent:~w~ Masina inchiriata a fost returnata!'})
            end
        end)
    else
        vRP.notify({'~r~Masina nu a fost incarcata!'})
    end    
end

RegisterNetEvent('DGPLM:SpawnTheVeh')
AddEventHandler('DGPLM:SpawnTheVeh',function(theVeh,theMins)
    CreateCar(theVeh,theMins,Config.SpawnVeh,Config.Heading)
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght, NoSpaces)
    AddTextEntry(GetCurrentResourceName() .. '_KeyboardHead', TextEntry)
    DisplayOnscreenKeyboard(1, GetCurrentResourceName() .. '_KeyboardHead', '', ExampleText, '', '', '', MaxStringLenght)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        if NoSpaces == true then
            vRP.notify({"~g~[RENT]~w~ Ai inchiriat masina cu succes."})
        end
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end