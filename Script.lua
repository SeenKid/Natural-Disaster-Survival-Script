--Made by Stickmasterluke


disasters={}


--X Meteor Storm
--X Flash Flood
--X Thunder Storm
--X Fire
--X Tornado
--X Tsunami
--O earthquake
--O Epidemic/Pandemic/zombie infection?
--O murderer
--O plane crash
--O alien attack
--O homing missiles
--O zombie attack
--O Zoo animal escape
--O Wild Bear Attack
--O Acid Rain

--[[geographically impossible disasters
	-volcanic eruption
	-sandstorm
	-avilanch
	-landslide
	-sinkhole
]]

balloonvip=66670555

mapradius=200
rate=1/30
maxtimer=60*2
timer=maxtimer

--tornado---------------------
tornadopos=Vector3.new(0,0,0)
maxhight=300
low=40
speed=100
push=.1
pull=-.5
lift=.25
breakradius=40
cycloneradius=10
------------------------------

--tsunami---------------------
wavedistance=2000
wavespeed=40
wavewidth=20
wavehight=50
wavelength=500
segmentradius=20
wavesegments=wavelength/segmentradius
------------------------------

function cframemodel(modl,centercframe,goalcframe)
	for _,Object in pairs(modl:GetChildren()) do
		Object.CFrame=goalcframe:toWorldSpace(centercframe:toObjectSpace(Object.CFrame))
	end
end

function RandomizeTable(tbl)
	local returntbl={}
	if tbl[1]~=nil then
		for i=1,#tbl do
			table.insert(returntbl,math.random(1,#returntbl+1),tbl[i])
		end
	end
	return returntbl
end

function resurface(p,s)
	if p and s then
		p.BackSurface=s
		p.BottomSurface=s
		p.FrontSurface=s
		p.LeftSurface=s
		p.RightSurface=s
		p.TopSurface=s
	end
end

function clouds(cloudtime)
	local cloud=game.Lighting.Cloud:clone()
	cloud.Parent=game.Workspace.Structure
	local pos1=Vector3.new(6000,300,-4000)
	local pos2=Vector3.new(-2000,300,2000)
	for i=1,(1/rate)*cloudtime do
		if cloud then
			wait(rate)
			cloud.CFrame=CFrame.new(pos1+((pos2-pos1)*(i/(cloudtime*(1/rate)))))
		end
	end
end

function createmeteor()
	local m=Instance.new("Part")
	m.Name="Meteor"
	m.BrickColor=meteorcolors[math.random(1,#meteorcolors)]
	m.FormFactor="Symmetric"
	m.Shape="Ball"
	local msize=meteorsizes[math.random(1,#meteorsizes)]
	m.Size=Vector3.new(msize,msize,msize)
	resurface(m,meteorsurfaces[math.random(1,#meteorsurfaces)])
	m.Position=Vector3.new(math.random(-mapradius/2,mapradius/2),500,math.random(-mapradius/2,mapradius/2))
	m.Velocity=Vector3.new(math.random(-100,100),-100,math.random(-100,100))
	m.CanCollide=false
	local f=Instance.new("Fire")
	f.Size=msize*2
	f.Parent=m
	local ms=script.MeteorScript:clone()
	ms.Disabled=false
	ms.Parent=m
	game.Debris:AddItem(m,10)
	m.Parent=game.Workspace.Structure
end

function createlightning(tmr)
	local m=Instance.new("Model")
	m.Name="Lightning"
	local ls=script.LightningScript:clone()
	ls.Disabled=false
	ls.Parent=m
	origin=Vector3.new(math.random(-mapradius/2,mapradius/2),300,math.random(-mapradius/2,mapradius/2))
	lastpoint=origin
	depth=300
	nothit=true
	local segments=0
	while depth>0 and nothit and segments<20 do
		segments=segments+1
		range=30
		casted=false
		nextpoint=lastpoint+Vector3.new(math.random(-range,range),math.random(-range*2,-5),math.random(-range,range))
		stuff=game.Workspace:FindPartsInRegion3(Region3.new(lastpoint-Vector3.new(range/2,range*2,range/2),lastpoint+Vector3.new(range/2,-5,range/2)),nil,100)
		if stuff then
			if #stuff>0 then
				local highest=nextpoint
				for i2,v2 in ipairs(stuff) do
					if v2 then
						if v2.Position.y>highest.y then
							highest=v2.Position
						end
					end
				end
				nextpoint=highest
			end
		end
		local dist=(lastpoint-nextpoint).magnitude
		local hit,pos=game.Workspace:FindPartOnRay(Ray.new(lastpoint,nextpoint-lastpoint))
		if hit~=nil and pos~=nil then
			nothit=false
			e=Instance.new("Explosion")
			e.BlastRadius=7
			e.BlastPressure=2000000
			e.Position=pos
			if tmr<=1 then
				e.Hit:connect(function(hit2,distnc)
					if hit2.Parent~=nil and hit2.Name=="Head" then
						local dedman=game.Players:GetPlayerFromCharacter(hit2.Parent)
						if dedman then
							game:GetService("BadgeService"):AwardBadge(dedman.userId,66918848)
						end
					end
				end)
			end
			e.Parent=game.Workspace
		end
		if pos~=nil then
			nextpoint=pos
		end
		depth=nextpoint.y
		local p=game.Lighting.LightningPart:clone()
		local dist=(lastpoint-nextpoint).magnitude
		p.Size=Vector3.new(.75,dist,.75)
		p.CFrame=CFrame.new(lastpoint,nextpoint)*CFrame.Angles(math.pi/2,0,0)*CFrame.new(0,-dist/2,0)
		p.Parent=m
		lastpoint=nextpoint
	end
	m.Parent=game.Workspace.Structure
end

function breakjointsunderhight(mdl,breakhight,breakchance)
	if mdl then
		if mdl.className=="Part" or mdl.className=="VehicleSeat" or mdl.className=="Seat" or mdl.className=="WedgePart" or mdl.className=="Truss" or mdl.className=="CornerWedgePart" then
			if not mdl.Anchored and mdl.Position.y<=breakhight then
				if math.random()<breakchance then
					mdl:BreakJoints()
					mdl.Velocity=mdl.Velocity+Vector3.new(math.random(-3,3),math.random(-3,3),math.random(-3,3))
				end
				if math.random()<breakchance then
					mdl:remove()
				end
			end
		end
		if mdl then
			if mdl.Parent~=nil then
				for i3,v3 in ipairs(mdl:GetChildren()) do
					breakjointsunderhight(v3,breakhight,breakchance)
				end
			end
		end
	end
end

function updatefireparts(mdl)
	if mdl then
		if mdl.className=="Part" or mdl.className=="VehicleSeat" or mdl.className=="Seat" or mdl.className=="WedgePart" or mdl.className=="TrussPart" or mdl.className=="CornerWedgePart" then
			local ft=mdl:FindFirstChild("FireTag")
			if not mdl.Anchored and ft then
				ft.Value=ft.Value+1
				if ft.Value==1 and mdl.Transparency==0 then
					local f=Instance.new("Fire")
					f.Parent=mdl
				elseif ft.Value==5 then
					mdl.BrickColor=BrickColor.new("Black")
				elseif ft.Value==10 then
					mdl:BreakJoints()
				elseif ft.Value==20 and math.random()>.5 then
					mdl:remove()
				elseif ft.Value==30 then
					local f=mdl:FindFirstChild("Fire")
					if f then
						f:remove()
					end
				end
				if ft.Value>5 and ft.Value<30 then
					local range=Vector3.new((mdl.Size.x/2)+1,(mdl.Size.y/2)+1,(mdl.Size.z/2)+1)
					local stuff=game.Workspace:FindPartsInRegion3(Region3.new(mdl.Position-range,mdl.Position+range),nil,100)
					for i2,v2 in ipairs(stuff) do
						if v2 then
							if v2.className=="Part" or v2.className=="VehicleSeat" or mdl.className=="Seat" or v2.className=="WedgePart" or v2.className=="Truss" or v2.className=="CornerWedgePart" then
								local ft=v2:FindFirstChild("FireTag")
								if not v2.Anchored and not ft then
									local h=v2.Parent:FindFirstChild("Humanoid")
									if h then
										h.Health=h.Health-16
									elseif math.random()>.25 then
										local ft=Instance.new("IntValue")
										ft.Name="FireTag"
										ft.Value=0
										ft.Parent=v2
									end
								end
							end
						end
					end
				end
			end
		end
		if mdl then
			if mdl.Parent~=nil then
				for i3,v3 in ipairs(mdl:GetChildren()) do
					updatefireparts(v3)
				end
			end
		end
	end
end

function updatetornado(mdl)
	if mdl then
		if mdl.className=="Part" or mdl.className=="VehicleSeat" or mdl.className=="Seat" or mdl.className=="WedgePart" or mdl.className=="TrussPart" or mdl.className=="CornerWedgePart" then
			if not mdl.Anchored and mdl.Position.y<maxhight then
				local dist=((mdl.Position*Vector3.new(1,0,1))-tornadopos).magnitude
				if dist<breakradius then
					if not mdl.Parent:FindFirstChild("Humanoid") then
						mdl:BreakJoints()
					end
					local pushpull=pull
					local hightpercentage=(mdl.Position.y/(maxhight-low))
					pushpull=pull+((push-pull)*hightpercentage)
					if dist<cycloneradius then
						pushpull=push
					end
					local angle=math.atan2(mdl.Position.x-tornadopos.x,mdl.Position.z-tornadopos.z)
					local ncf=(CFrame.new(tornadopos)+Vector3.new(0,mdl.Position.y,0))*CFrame.Angles(0,angle+.1,0)*CFrame.new(0,0,dist+pushpull)

					if game.Workspace:FindFirstChild("Marker") then
						game.Workspace.Marker.CFrame=ncf
					end

					local vec=(ncf.p-mdl.Position).unit
					local speedpercent=(dist-cycloneradius)/(breakradius-cycloneradius)
					if speedpercent<0 then
						speedpercent=0
					end
					speedpercent=1-speedpercent
					speedpercent=speedpercent+.1
					if speedpercent>1 then
						speedpercent=1
					end
					mdl.Velocity=(vec*speedpercent*speed*(1+(2*hightpercentage)))+Vector3.new(0,(lift*(speedpercent+hightpercentage)*speed),0)
					mdl.RotVelocity=mdl.RotVelocity+Vector3.new(math.random(-1,1),math.random(-1,1)+.1,math.random(-1,1))
					local tt=mdl:FindFirstChild("TornadoTag")
					if tt==nil then
						if math.random(1,2)==1 then
							mdl:remove()
						else
							local tt=Instance.new("StringValue")
							tt.Name="TornadoTag"
							tt.Parent=mdl
						end
					end
				end
			end
		end
		if mdl then
			if mdl.Parent~=nil then
				for i3,v3 in ipairs(mdl:GetChildren()) do
					updatetornado(v3)
				end
			end
		end
	end
end

function startfire(mdl)
	if mdl then
		if mdl.Name=="FireStarter" then
			if mdl.className=="Part" or mdl.className=="Seat" or mdl.className=="WedgePart" or mdl.className=="Truss" or mdl.className=="CornerWedgePart" then
				local ft=Instance.new("IntValue")
				ft.Name="FireTag"
				ft.Value=0
				ft.Parent=mdl
			end
		end
		for i3,v3 in ipairs(mdl:GetChildren()) do
			startfire(v3)
		end
	end
end

function spread(mdl,func)
	if mdl and mdl.Parent~=nil then
		func(mdl)
		if mdl and mdl.Parent~=nil then
			for i,v in ipairs(mdl:GetChildren()) do
				spread(v,func)
			end
		end
	end
end

meteorstorm={}
meteorstorm.Name="Meteor Shower"
meteorstorm.PreStart=function()
end
meteorstorm.Start=function()
	meteorsurfaces={"Universal","Inlet"}
	meteorcolors={BrickColor.new("Dusty Rose"),BrickColor.new("Reddish brown"),BrickColor.new("Black")}
	meteorsizes={2,5,10,15}
	maxtimer=60*1.5
	timer=maxtimer
	while timer>0 do
		timer=timer-1
		createmeteor()
		wait(.5)
		createmeteor()
		wait(.5)
	end
end

flooding={}
flooding.Name="Flash Flood"
flooding.PreStart=function()
	delay(1,function()
		clouds(100)
	end)
end
flooding.Start=function()
	local fl=game.Lighting.FloodLevel:clone()
	fl.Parent=game.Workspace.Structure
	totalfloodhight=70
	floodspeed=2*rate
	floodstart=15
	radius=3			--hight
	wavetime=10		--seconds
	a=0
	maxtimer=60*1
	timer=maxtimer
	while timer>0 do
		wait(rate)
		a=a+1
		local floodhight=floodstart+(a*floodspeed)
		if floodhight>totalfloodhight then
			floodhight=totalfloodhight
		end
		local floodhight=floodhight+math.sin((a/(wavetime*30))*math.pi)*radius
		if fl then
			fl.CFrame=CFrame.new(0,floodhight,0)
		end
		if a%30==0 then
			timer=timer-1
			for i,v in ipairs(game.Players:GetChildren()) do
				if v then
					if v.Character~=nil then
						local he=v.Character:FindFirstChild("Head")
						local hu=v.Character:FindFirstChild("Humanoid")
						if he and hu then
							if he.Position.y<floodhight then
								hu.Health=hu.Health-10
							end
						end
					end
				end
			end
		end
		if (a+15)%30==0 then
			breakjointsunderhight(game.Workspace.Structure,floodhight,.075)
		end
	end
end

lightningstorm={}
lightningstorm.Name="Thunder Storm"
lightningstorm.PreStart=function()
	delay(1,function()
		clouds(100)
	end)
end
lightningstorm.Start=function()
	maxtimer=60*1.5
	timer=maxtimer
	while timer>=0 do
		timer=timer-1
		if timer%2==0 then
			createlightning(timer)
		end
		wait(1)
	end
end

fire={}
fire.Name="Fire"
fire.PreStart=function()
end
fire.Start=function()
	a=0
	maxtimer=60*1.5
	timer=maxtimer
	startfire(game.Workspace.Structure)
	while timer>0 do
		wait(rate)
		a=a+1
		if a%30==0 then
			timer=timer-1
		end
		if a%30==0 then
			updatefireparts(game.Workspace.Structure)
		end
	end
end

tornado={}
tornado.Name="Tornado"
tornado.PreStart=function()
	delay(1,function()
		clouds(100)
	end)
end
tornado.Start=function()
	a=0
	maxtimer=60*1.5
	timer=maxtimer
	tornadoposes={}
	for i=1,10 do
		table.insert(tornadoposes,Vector3.new(math.random(-85,70),0,math.random(-90,80)))
	end
	tornadopos=tornadoposes[1]
	local tp=game.Lighting.TornadoPart:clone()
	tp.CFrame=CFrame.new(tornadopos+Vector3.new(0,40,0))
	tp.Parent=game.Workspace.Structure
	while timer>0 do
		wait(rate)
		a=a+1
		if a%30==0 then
			timer=timer-1
		end
		if a%2==0 then
			local totalframes=((maxtimer*(1/rate))/(#tornadoposes-1))
			local posframe=math.floor(a/totalframes)+1
			local pospercent=(a-((posframe-1)*totalframes))/totalframes
			if posframe<=#tornadoposes-1 then
				tornadopos=tornadoposes[posframe]+((tornadoposes[posframe+1]-tornadoposes[posframe])*pospercent)
				if tp then
					tp.CFrame=CFrame.new(tornadopos+Vector3.new(0,low,0))
				end
				updatetornado(game.Workspace.Structure)
			end
		else
			for i,v in ipairs(game.Players:GetChildren()) do
				if v then
					if v.Character~=nil then
						updatetornado(v.Character)
					end
				end
			end
		end
	end
end

tsunami={}
tsunami.Name="Tsunami"
tsunami.PreStart=function()
end
tsunami.Start=function()
	a=0
	maxtimer=60*1
	timer=maxtimer
	--presetangle=(math.pi/4)+(math.pi/2)
	waveangle=math.pi*2*math.random()
	tsunamiinitial=CFrame.Angles(0,waveangle,0)*CFrame.new(-wavedistance/2,11+wavehight/2,0)
	tsunamifinal=CFrame.Angles(0,waveangle,0)*CFrame.new(wavedistance/2,11+wavehight/2,0)
	wavevec=(tsunamiinitial.p-tsunamifinal.p).unit --tsunamiinitial.lookVector--
	tsunamiwave=game.Lighting.TsunamiWave:clone()
	tsunamiwave.Parent=game.Workspace.Structure
	cframemodel(tsunamiwave,tsunamiwave.Center.CFrame,tsunamiinitial*CFrame.Angles(0,math.pi,0))
	while timer>0 do
		wait(rate)
		a=a+1
		local wavepercentage=a/(maxtimer*30)
		tsunamicurrent=CFrame.Angles(0,waveangle,0)*CFrame.new((-wavedistance/2)+wavedistance*wavepercentage,11+wavehight/2,0)
		if tsunamiwave and tsunamiwave~=nil then
			cframemodel(tsunamiwave,tsunamiwave.Center.CFrame,tsunamicurrent*CFrame.Angles(0,math.pi,0))
		end
		for i=1,wavesegments do
			local segpos=(tsunamicurrent*CFrame.new(0,0,(-wavelength/2)+(i*segmentradius))).p
			local waverange=Vector3.new(segmentradius,wavehight/2,segmentradius)
			local stuff=game.Workspace:FindPartsInRegion3(Region3.new(segpos-waverange,segpos+waverange),nil,100)
			for i2,v2 in ipairs(stuff) do
				if v2 and v2.Parent~=nil then
					if not v2.Anchored then
						v2:BreakJoints()
						if math.random(1,5)==1 then
							v2.Velocity=wavevec*-1*wavespeed
						end
						if math.random(1,100)==1 then
							v2:remove()
						end
					end
				end
			end
		end
		if a%30==0 then
			timer=timer-1
		end
	end
end



disasters={meteorstorm,flooding,lightningstorm,fire,tornado,tsunami}




function onPlayerRespawn(property,player)
	if property=="Character" and player.Character~=nil then
		local cs=script.CharacterScript:clone()
		cs.Disabled=false
		cs.Parent=player.Character
		if game:GetService("BadgeService"):UserHasBadge(player.userId,balloonvip) then
			if player:FindFirstChild("Backpack") then
				game.Lighting.GreenBalloon:clone().Parent=player.Backpack
			end
		end
		if player.DataReady then
			player:SaveNumber("ConsecutiveWins",0)	
		end
	end
end
function onPlayerEntered(newPlayer)
	while newPlayer.Character~=nil do
		wait(.1)
	end
	newPlayer.Changed:connect(function(property)
		onPlayerRespawn(property,newPlayer)
	end)
	onPlayerRespawn("Character",newPlayer)
end
game.Players.ChildAdded:connect(onPlayerEntered)

game.Workspace.ChildAdded:connect(function(item)
	if item.className=="Tool" then
		item:remove()
	end
end)

function checkplayer(pv,ph,pst,pst2)
	delay(0,function()
		if pv.DataReady and pv and ph and pst and pst2 then
			local cwscore=pv:LoadNumber("ConsecutiveWins") or 0
			pv:SaveNumber("ConsecutiveWins",cwscore+1)
			local disasterscore=pv:LoadNumber("Survived"..pst) or 0
			pv:SaveNumber("Survived"..pst,disasterscore+1)
			local mapscore=pv:LoadNumber("Survived"..pst2) or 0
			pv:SaveNumber("Survived"..pst2,mapscore+1)
			local totalscore=pv:LoadNumber("SurvivedTotal") or 0
			pv:SaveNumber("SurvivedTotal",totalscore+1)
			if pv~=nil and pv.Parent~=nil and cwscore+1==5 then
				game:GetService("BadgeService"):AwardBadge(pv.userId,66918916)
			end
			if pv~=nil and pv.Parent~=nil and totalscore+1>=1 then
				game:GetService("BadgeService"):AwardBadge(pv.userId,66918518)
			end
			if pv~=nil and pv.Parent~=nil and totalscore+1>=10 then
				game:GetService("BadgeService"):AwardBadge(pv.userId,66918551)
			end
			if pv~=nil and pv.Parent~=nil and totalscore+1>=25 then
				game:GetService("BadgeService"):AwardBadge(pv.userId,66918611)
			end
			if pv~=nil and pv.Parent~=nil and totalscore+1>=50 then
				game:GetService("BadgeService"):AwardBadge(pv.userId,66918640)
			end
			if pv~=nil and pv.Parent~=nil and totalscore+1>=100 then
				game:GetService("BadgeService"):AwardBadge(pv.userId,66918685)
			end
			if pv~=nil and pv.Parent~=nil and totalscore+1>=200 then
				game:GetService("BadgeService"):AwardBadge(pv.userId,66918716)
			end
			if pv~=nil and pv.Parent~=nil and totalscore+1>=400 then
				game:GetService("BadgeService"):AwardBadge(pv.userId,66918795)
			end
			if ph~=nil and ph.Parent~=nil and pv~=nil and pv.Parent~=nil and ph.Health<=10 then
				game:GetService("BadgeService"):AwardBadge(pv.userId,66919023)
			end
			if pv~=nil and pv.Parent~=nil then
				if pst2=="Sunny Ranch" and pst=="Fire" then
					game:GetService("BadgeService"):AwardBadge(pv.userId,66918988)
				elseif pst2=="Trailer Park" and pst=="Tornado" then
					game:GetService("BadgeService"):AwardBadge(pv.userId,66956295)
				elseif pst2=="Surf Central" and pst=="Tsunami" then
					game:GetService("BadgeService"):AwardBadge(pv.userId,66918948)
				elseif pst2=="Happy Home" and pst=="Flash Flood" then
					game:GetService("BadgeService"):AwardBadge(pv.userId,66919105)
				elseif pst2=="Fort Indestructable" and pst=="Thunder Storm" then
					game:GetService("BadgeService"):AwardBadge(pv.userId,66919155)
				elseif pst2=="Rakish Refinery" and pst=="Acid Rain" then
					--game:GetService("BadgeService"):AwardBadge(v.userId,0)
				end
			end
		end
	end)
end


while true do
	wait(20)
	while #game.Players:GetChildren()<1 do
		script.Status.Value="Waiting for more players"
		wait(1)
	end
	for i,v in ipairs(game.Workspace.Structure:GetChildren()) do
		v:remove()
	end
	for i,v in ipairs(game.Workspace:GetChildren()) do
		if v.className=="Accoutrement" or v.className=="Hat" then
			v:remove()
		end
	end
	wait(3)
	local structures=game.Lighting.Structures:GetChildren()
	local rs=math.random(1,#structures)
	--rs=8
	local ns=structures[rs]:clone()
	ns.Parent=game.Workspace.Structure
	script.Information.Value=ns.Name
	script.Status.Value="New Map"
	wait(3)
	ns:MakeJoints()
	wait(2)
	spread(ns,function(mdl2)
		if mdl2~=nil then
			if mdl2.className=="Part" or mdl2.className=="VehicleSeat" or mdl2.className=="Seat" or mdl2.className=="WedgePart" or mdl2.className=="TrussPart" or mdl2.className=="CornerWedgePart" then
				if not mdl2:FindFirstChild("KeepAnchored") then
					mdl2.Anchored=false
				end
			end
		end
	end)

	wait(1)

	local rd=math.random(1,#disasters)
	local disaster=disasters[rd]
	--disaster=disasters[5]

	for i,v in pairs(game.Players:GetChildren()) do
		if v then
			if v.Character then
				local t=v.Character:FindFirstChild("Torso")
				local h=v.Character:FindFirstChild("Humanoid")
				--if t~=nil and h~=nil then
					if h.Health>0 then
						--t.Velocity=Vector3.new(0,0,0)
						v.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-109,47,16.5))+Vector3.new(math.random(-20,20),0,math.random(-20,20))
						--v.Character:MoveTo((CFrame.new(Vector3.new(-109,47,16.5))+Vector3.new(math.random(-20,20),0,math.random(-20,20))).p)
						--v.Character:MoveTo((CFrame.new(-109,47,16.5)+Vector3.new(math.random(-20,20),0,math.random(-20,20))).p)
						local st=Instance.new("StringValue")
						st.Name="SurvivalTag"
						st.Value=disaster.Name
						local st2=Instance.new("StringValue")
						st2.Name="MapName"
						st2.Value=ns.Name
						st2.Parent=st
						st.Parent=v.Character
						if v.DataReady then
							disasterscore=v:LoadNumber("Played"..disaster.Name) or 0
							v:SaveNumber("Played"..disaster.Name,disasterscore+1)

							mapscore=v:LoadNumber("Played"..ns.Name) or 0
							v:SaveNumber("Played"..ns.Name,mapscore+1)

							totalscore=v:LoadNumber("PlayedTotal") or 0
							v:SaveNumber("PlayedTotal",totalscore+1)
						end
					end
				end
			end
		end
	--end

	disaster.PreStart()

	wait(40)

	disaster.Start()

	for i,v in pairs(script.Survivers:GetChildren()) do
		v:remove()
	end
	local spawns=game.Workspace.Spawns:GetChildren()
	pws={}
	p = m.Workspace:findFirstChild("Humanoid")
	for i,v in ipairs(game.Players:GetChildren()) do
		if v then
			if v.Character then
				local t=v.Character:FindFirstChild("Torso")
				local h=v.Character:FindFirstChild("Humanoid")
				--if t~=nil and h~=nil then
					local st=v.Character:FindFirstChild("SurvivalTag")
					--if st~=nil and h.Health>0 then
						v.Character:MoveTo(spawns[math.random(1,#spawns)].Position)
						for _,player in pairs(game:GetService("Players"):GetPlayers())do
							if player and player.Character then
						v.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-262.579, 205.21, 313.561))+Vector3.new(math.random(-20,20),0,math.random(-20,20))
								--player.Character:MoveTo(CFrame.new(-109,47,16.5))
								--v.Character:MoveTo((CFrame.new(Vector3.new(-109,47,16.5))+Vector3.new(math.random(-20,20),0,math.random(-20,20))).p)	
							--end
						--end
						--table.insert(pws,v.Name)
						--checkplayer(v,h,st.Value,st.MapName.Value)
					end
					for i2,v2 in ipairs(v.Character:GetChildren()) do
						if v2.Name=="SurvivalTag" then
							v2:remove()
						end
					end
				end
			end
		end
	end
	pws=RandomizeTable(pws)
	for i,v in ipairs(pws) do
		local sst=Instance.new("StringValue")
		sst.Name=v
		sst.Parent=script.Survivers
	end
	script.Status.Value="Survivers"
end




