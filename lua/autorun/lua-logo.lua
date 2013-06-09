if SERVER then
	util.AddNetworkString( "gcompute_open_luahud_tosv" )
	util.AddNetworkString( "gcompute_open_luahud_tocl" )
	SPapate = {}
	SPapate.Player = {}
	
	net.Receive("gcompute_open_luahud_tosv", function( len, ply )
		local act = tobool(net.ReadBit())
		if act then
			SPapate.Player[ply:EntIndex()] = ply
		else
			SPapate.Player[ply:EntIndex()] = nil
		end
		net.Start("gcompute_open_luahud_tocl")
		net.WriteTable( SPapate.Player )
		net.Send( player.GetAll() )
		
	end )
else
	local Frame = GCompute.IDE.GetInstance():GetFrame()
	local Players = {}
	
	if not Frame.SetVisibleOld then
		Frame.SetVisibleOld = Frame.SetVisible
	end
	
	function Frame:SetVisible( act )
		self:SetVisibleOld( act )
		net.Start( "gcompute_open_luahud_tosv" )
			net.WriteBit( act )
		net.SendToServer()
	end
	
	net.Receive("gcompute_open_luahud_tocl", function( len )
		local tab = net.ReadTable()
		Players = tab
	end )
	
	
	local proute = {}
	proute.x = 0
	
	local size = 2560
	hook.Add("PostDrawTranslucentRenderables", "lualogohud", function()
		proute.y = math.sin(SysTime()*2)*10
		for k,v in pairs(Players) do
			if LocalPlayer() != v then
				local pos = v:EyePos() + Vector(0, 0, 20)
				local distance = LocalPlayer():EyePos():Distance( pos )
				local cal = "32"
				if distance < 30 then
					cal = "1024"
				elseif distance < 90 then
					cal = "512"
				elseif distance < 270 then
					cal = "256"
				elseif distance < 810 then
					cal = "128"
				elseif distance < 2430 then
					cal = "64"
				else
					cal = "32"
				end
				
				cam.Start3D2D( pos, Angle(0, EyeAngles().y - 90, 90), 0.01)
					surface.SetDrawColor( 255, 255, 255, 255 ) 
					surface.SetMaterial( Material( "lua-logo/"..cal.."/lua-1.png" ) )
					surface.DrawTexturedRect( proute.x - size/2, proute.y  - size/2, size, size ) 
				
					surface.SetDrawColor( 255, 255, 255, 255 ) 
					surface.SetMaterial( Material( "lua-logo/"..cal.."/lua-2.png" ) )
					surface.DrawTexturedRectRotated( proute.x, proute.y, size, size, SysTime()*10 ) 
				
					
					local x = math.sin(-SysTime())*0.54296875*size
					local y = math.cos(-SysTime())*0.54296875*size
				
					surface.SetDrawColor( 255, 255, 255, 255 ) 
					surface.SetMaterial( Material( "lua-logo/"..cal.."/lua-3.png" ) )
					surface.DrawTexturedRect( size*0.3828125 + x + proute.x  - size/2, size*0.3828125 + y + proute.y  - size/2, size*0.2265625, size*0.2265625 ) 
				cam.End3D2D()
			end
		end
	end)
end