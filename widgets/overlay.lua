local Addon = _G[...]local modName = ...local title = "Overlay"local widget = Addon:NewWidget(title, "Frame")widget.defaults = {	basic = {		padding = {			top = 0,			right = 8,			left = 0,			bottom = 0,		},		position = {			frameLevel = 4,			frameStrata = 2,		},		texture = {			minus = "Minus",			enable = true,			rare = "Rare",			elite = "Elite",			player = "Target",			noMana = "No Mana",			worldboss = "Elite",			rareelite = "Rare Elite",			vehicle = "Vehicle",			isLeftToRight = true,			boss = "Boss",		},	},}	function widget:New(parent)	local bar = self:Bind(CreateFrame('Frame', nil, parent.box))	bar:EnableMouse(false)	bar.left = bar:CreateTexture(nil, 'ARTWORK')	bar.left:Show()	bar.right = bar:CreateTexture(nil, 'ARTWORK')	bar.right:Show()	bar.middle = bar:CreateTexture(nil, 'ARTWORK')	bar.middle:Show()	self.Glows = {}	bar.GlowPad = CreateFrame("Frame", nil, bar)		bar.leftGlow = bar:CreateTexture(nil, 'ARTWORK')	bar.leftGlow:SetTexture('Interface\\CharacterFrame\\UI-Player-Status')	bar.leftGlow:SetTexCoord(0, 0.74609375, 0, 0.53125)	bar.leftGlow:SetBlendMode('ADD')			bar.middleGlow = bar:CreateTexture(nil, 'ARTWORK')	bar.middleGlow:SetTexture('Interface\\CharacterFrame\\UI-Player-Status')	bar.middleGlow:SetTexCoord(0, 0.74609375, 0, 0.53125)	bar.middleGlow:SetBlendMode('ADD')	self.Glows.middle = bar.middleGlow		bar.rightGlow = bar:CreateTexture(nil, 'ARTWORK')	bar.rightGlow:SetTexture('Interface\\CharacterFrame\\UI-Player-Status')	bar.rightGlow:SetTexCoord(0, 0.74609375, 0, 0.53125)	bar.rightGlow:SetBlendMode('ADD')	self.Glows.right = bar.rightGlow	bar.rightGlow:Hide()	bar.leftGlow:Hide()	bar.middleGlow:Hide()	bar.rightGlow:SetParent(bar.GlowPad)	bar.leftGlow:SetParent(bar.GlowPad)	bar.middleGlow:SetParent(bar.GlowPad)		parent.threatIndicator = bar.leftGlow	parent.unit = parent.id	bar.leftGlow.unit = parent.id	bar.statusCounter = 0	bar.statusSign = -1		bar:SetAllPoints(self)	bar.owner = parent	bar.title = title	bar.handler = parent.id	return barendlocal texturePath = "Interface\\addons\\Dominos_Units\\overlays\\UI-"local files = {	["Elite"]				= 'TargetingFrame-Elite',	["Rare Elite"]			= 'TargetingFrame-Rare-Elite',	["Rare"]				= 'TargetingFrame-Rare',	["Rare Mob"]			= 'TargetingFrame-RareMob',	["Minus"]				= 'TargetingFrame-Minus',	["No Mana"]				= 'TargetingFrame-NoMana',	["Small"]				= 'SmallTargetingFrame',	["Small No Mana"]		= 'SmallTargetingFrame-NoMana',	["Target"]				= 'TargetingFrame',	["Target No Level"]		= 'TargetingFrame-NoLevel',	["Death Knight"]		= 'DeathKnightFrame',	["Vehicle"]				= 'VEHICLE-FRAME',	["Vehicle: Alliance"]	= 'VEHICLE-FRAME-ALLIANCE',	["Vehicle: Party"]		= 'VEHICLES-PARTYFRAME.png',	["Boss"] 				= 'UNITFRAME-BOSS',}function widget:Load()	self:EnableMouse(false)	self.noMouse = true	self.id = self.owner.id		Addon.lib.MediaType.OVERLAY = Addon.lib.MediaType.OVERLAY or  {}		Addon.lib.MediaTable.overlay =  Addon.lib.MediaTable.overlay or {}	local o = Addon.lib.MediaTable.overlay		for name, file in pairs(files) do		o[name] = texturePath .. file	endendfunction widget:Layout()	if self.sets.basic.texture.enable ~= true then		self:Hide()		self.noUpdate = true		return	else		self:Show()		self.noUpdate = nil	end	self:ApplyTexture()	self:Update()	self:Reposition()	endfunction widget:ApplyTexture()	self:EnableMouse(false)	self:ClearAllPoints()	self:SetAllPoints(self:GetParent())	self.left:ClearAllPoints()	self.right:ClearAllPoints()	self.middle:ClearAllPoints()	self.leftGlow:ClearAllPoints()	self.rightGlow:ClearAllPoints()	self.middleGlow:ClearAllPoints()	local pad = self.sets.basic.padding	local top, right, bottom, left = pad.top + 8, pad.right, pad.bottom- 17, pad.left		local L, CL, CR, R	local T, B = top, bottom	glowT, glowB = T - 10, B + 25		local a, b, c, d, _a, _b, _c, _d, l, r 		local e, f		local _e, _f,_g		if self.sets.basic.texture.isLeftToRight == true then		 L, CL, CR, R = right + 26, right - 82, left - 16, left	+ 8			glowL, glowCL, glowCR, glowR = L - 37, CL - 12, CR + 20, R + 8						r, l =  "Left", "Right"			else	--]]		 L, CL, CR, R = left - 38, left + 73, right - 16, right	+ 8			glowL, glowCL, glowCR, glowR = L + 37, CL + 12, CR - 8, R - 20						l, r =  "Left", "Right"	end		self.left:SetPoint(l, self, L, 0)	self.left:SetPoint(r, self, l, CL, 0)	self.left:SetPoint("Top", self, 0, T)	self.left:SetPoint("Bottom", self, 0, B)	self.right:SetPoint(r, self, R, 0)	self.right:SetPoint(l, self, r, CR, 0)	self.right:SetPoint("Top", self, 0, T)	self.right:SetPoint("Bottom", self, 0, B)		self.middle:SetPoint("Top"..l, self.left, "Top"..r, 0, 0)	self.middle:SetPoint("Bottom"..r, self.right, "Bottom"..l, 0, 0)	self.leftGlow:SetPoint(l, self, glowL, 0)	self.leftGlow:SetPoint(r, self, l, glowCL, 0)	self.leftGlow:SetPoint("Top", self, 0, glowT)	self.leftGlow:SetPoint("Bottom", self, 0, glowB)	self.rightGlow:SetPoint(r, self, glowR, 0)	self.rightGlow:SetPoint(l, self, r, glowCR, 0)	self.rightGlow:SetPoint("Top", self, 0, glowT)	self.rightGlow:SetPoint("Bottom", self, 0, glowB)	self.middleGlow:SetPoint("Top"..l, self.leftGlow, "Top"..r, 0, 0)	self.middleGlow:SetPoint("Bottom"..r, self.rightGlow, "Bottom"..l, 0, 0)endfunction widget:Reposition()	local position = self.sets.basic.position	--self:ClearAllPoints()	--self:SetPoint(position.anchor, self:GetParent(), position.x, position.y)		local lay = Addon.layers[position.frameStrata]	self:SetFrameStrata(lay)	self:SetFrameLevel(position.frameLevel)	endfunction widget:Update()	if self.noUpdate then		return	end	if self.OnUpdate then		self:OnUpdate()	endendfunction widget:GetMediaPath(mediaName)	return (Addon.lib and Addon.lib:Fetch("overlay", mediaName))endlocal basePower = {Druid = 0, Warlock = 0, Shaman = 0, Mage = 0, Monk = 0, Paladin = 0, Priest = 0, Warrior = 1, Hunter = 3 , ["Death Knight"] = 6, Rogue = 3}function widget:GetOverlayTexture (unit, forceNormalTexture)	local classification = UnitClassification(unit);	local texture, haveElite	local basePower_index = basePower[UnitClass(unit)]	local Max = UnitPowerMax(unit, basePower_index)	local texturePaths = self.sets.basic.texture	if ( forceNormalTexture == true) then		texture = self:GetMediaPath(texturePaths.player)	elseif ( classification == "minus" ) then		texture = self:GetMediaPath(texturePaths.minus)	elseif ( classification == "worldboss") then		texture = self:GetMediaPath(texturePaths.worldboss)	elseif (classification == "elite" ) then		texture = self:GetMediaPath(texturePaths.elite)	elseif ( classification == "rareelite" ) then		texture = self:GetMediaPath(texturePaths.rareelite)	elseif ( classification == "rare" ) then		texture = self:GetMediaPath(texturePaths.rare)	elseif Max == 0 then		texture = self:GetMediaPath(texturePaths.noMana)	elseif UnitIsUnit("vehicle",unit) then		texture = self:GetMediaPath(texturePaths.vehicle)	else		texture = self:GetMediaPath(texturePaths.player)	end	return texture, haveEliteendlocal duration = .83local function GetAlpha(seconds, low, high)	return math.floor(low + ((math.abs(((seconds - (duration/2))/1) * 100)*(high - low))/100)) / 100endlocal _timelocal pulsing = {}local isPulsinglocal function PulseIcons()	_time = _time or GetTime()	if not isPulsing then --don't pulse if function is already being run.		isPulsing = true		local seconds = GetTime() - _time				if seconds > duration then			_time,isPulsing  = nil, nil			return PulseIcons()		end		local alpha = GetAlpha(seconds, 10, 120)		for i, texture in pairs(pulsing) do			texture:SetAlpha(alpha)			isPulsing = nil		end		isPulsing = nil	end	endlocal function StartPulse(self)	pulsing[self.id] = pulsing[self.id] or self.GlowPadendlocal function EndPulse(self)	if pulsing[self.id] then		pulsing[self.id] = nil		self.GlowPad:SetAlpha(1)	endendfunction widget:OnUpdate()    if ( UnitHasVehiclePlayerFrameUI(self.owner.id) ) then		self.GlowPad:Hide()	elseif (UnitIsUnit(self.owner.id, 'player')) and( IsResting() ) then		self.rightGlow:SetVertexColor(1.0, 0.88, 0.25, 1.0)		self.leftGlow:SetVertexColor(1.0, 0.88, 0.25, 1.0)		self.middleGlow:SetVertexColor(1.0, 0.88, 0.25, 1.0)		self.GlowPad:Show()    else		self.rightGlow:SetVertexColor(1,1,1,1)		self.leftGlow:SetVertexColor(1,1,1,1)		self.middleGlow:SetVertexColor(1,1,1,1)		self.GlowPad:Hide()    end	if ( self.GlowPad:IsShown() ) then			StartPulse(self)	else		EndPulse(self)    end	local classification = UnitClassification(self.owner.id)	local texture = self:GetOverlayTexture (self.owner.id, self.owner.id == "player")	self.left:SetTexture(texture)	self.right:SetTexture(texture)	self.middle:SetTexture(texture)		local a, b, c, d = 1, .56, 0, .13	local aa, bb ,cc, dd = 0, .35, .7, 0.74609375			local w, x, y, z = 0, 0, 0.78125, 0.53125			if self.sets.basic.texture.isTopToBottom == true then		y, z, w, x = 0 -.079, 0 + .079, 0.78125 - .079, 0.53125	end			if self.sets.basic.texture.isLeftToRight == true then		self.left:SetTexCoord(  b, a,w,y)		self.middle:SetTexCoord(d, b,w,y)		self.right:SetTexCoord( c, d,w,y)--portait				self.leftGlow:SetTexCoord(bb, aa, x, z)		self.middleGlow:SetTexCoord(cc ,bb, x, z)		self.rightGlow:SetTexCoord(dd, cc, x, z)	else		self.left:SetTexCoord(  a+.02, b,w,y)		self.middle:SetTexCoord(b, d,w,y)		self.right:SetTexCoord( d, c,w,y)--portait				self.leftGlow:SetTexCoord(aa, bb, x, z)		self.middleGlow:SetTexCoord(bb ,cc, x, z)		self.rightGlow:SetTexCoord(cc, dd, x, z)	end	PulseIcons()endwidget.Options = {	{		name = "Basic",		kind = "Panel",		key = "basic",		panel = "Basic",		options = {			{				name = 'Enable',				kind = 'CheckButton',				key = 'enable',				panel = "texture",			},			{				name = 'Flip Left to Right',				kind = 'CheckButton',				key = 'isLeftToRight',				panel = "texture",			},			{				name = 'Flip Top to Bottom',				kind = 'CheckButton',				key = 'isTopToBottom',				panel = "texture",			},			{				name = 'Boss',				kind = 'Media',				key = 'boss',				mediaType = 'Overlay',				panel = "texture",			},			{				name = 'WolrdBoss',				kind = 'Media',				key = 'worldboss',				mediaType = 'Overlay',				panel = "texture",			},			{				name = 'Elite',				kind = 'Media',				key = 'elite',				mediaType = 'Overlay',				panel = "texture",			},						{				name = 'Rare Elite',				kind = 'Media',				key = 'rareelite',				mediaType = 'Overlay',				panel = "texture",			},						{				name = 'Rare',				kind = 'Media',				key = 'rare',				mediaType = 'Overlay',				panel = "texture",			},						{				name = 'Normal',				kind = 'Media',				key = 'player',				mediaType = 'Overlay',				panel = "texture",			},						{				name = 'No Mana',				kind = 'Media',				key = 'noMana',				mediaType = 'Overlay',				panel = "texture",			},						{				name = 'Minus',				kind = 'Media',				key = 'minus',				mediaType = 'Overlay',				panel = "texture",			},						{				name = 'Vehicle',				kind = 'Media',				key = 'vehicle',				mediaType = 'Overlay',				panel = "texture",			},			{				name = "Left",				kind = "Slider",				key = "left",				panel = 'padding',				min = -100,				max = 100,			},			{				name = "Right",				kind = "Slider",				key = "right",				panel = 'padding',				min = -100,				max = 100,			},			{				name = "Top",				kind = "Slider",				key = "top",				panel = 'padding',				min = -100,				max = 100,			},			{				name = "Bottom",				kind = "Slider",				key = "bottom",				panel = 'padding',				min = -100,				max = 100,			},						{				name = "Frame Level",				kind = "Slider",				key = "frameLevel",				panel = 'position',				min = 1,				max = 100,			},			{				name = "Frame Strata",				kind = "Slider",				key = "frameStrata",				panel = 'position',				min = 1,				max = 8,			},		}	},	}	--]]