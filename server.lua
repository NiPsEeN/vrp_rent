local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPpm = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_rent")
PMclient = Tunnel.getInterface("vrp_rent","vrp_rent")
vRPpm = Tunnel.getInterface("vrp_rent","vrp_rent")
Tunnel.bindInterface("vrp_rent",vRPrent)

local function moneyFormat(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

RegisterServerEvent('Jegyx:RentCar')
AddEventHandler('Jegyx:RentCar',function(theMins,theVehicle)
	local thePlayer = source
	local user_id = vRP.getUserId({thePlayer})
	local mins = parseInt(theMins)
	if mins ~= nil and mins > 0 then
		local pricePerTheMins = theMins * 500 / (2 ^ 3)
		if vRP.tryFullPayment({user_id,pricePerTheMins}) then
			vRPclient.notify(thePlayer,{'~y~Rent:~w~ Ai cumparat masina ~r~'..theVehicle..'~w~ pentru pretul de ~g~'..moneyFormat(pricePerTheMins)})

			TriggerClientEvent('DGPLM:SpawnTheVeh',thePlayer,theVehicle,theMins)
		else
			vRPclient.notify(thePlayer,{'~r~Esti prea sarac, marsh la ma-ta-n cotetz'})
		end
	end
end)

