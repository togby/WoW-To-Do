local addonName, addon = ...

local L = addon.L


function addon:SetupOptionList(profile)

	local options = {
		type='group',
			set = function(info,val)
				local s = profile -- ; for i = 2,#info-1 do s = s[info[i]] end
				s[info[#info]] = val; addon:Debug(info[#info].." set to: "..tostring(val))
			end,
			get = function(info)
				local s = profile -- ; for i = 2,#info-1 do s = s[info[i]] end
				return s[info[#info]]
			end,
		args = {
			config = {
				type = 'execute',
				name = L["Show configuration options"],
				desc = L["Show configuration options"],
				func = function()
					addon:OpenBlizzAddonOptions()
				end,
				guiHidden = true,
			},
			show = {
				type = 'execute',
				name = L["Show the buff report dashboard."],
				desc = L["Show the buff report dashboard."],
				func = function()
					addon:DoReport()
					addon:ShowReportFrame()
				end,
				guiHidden = true,
			},
			hide = {
				type = 'execute',
				name = L["Hide the buff report dashboard."],
				desc = L["Hide the buff report dashboard."],
				func = function()
					addon:HideReportFrame()
				end,
				guiHidden = true,
			},
			toggle = {
				type = 'execute',
				name = L["Hide and show the buff report dashboard."],
				desc = L["Hide and show the buff report dashboard."],
				func = function()
					if addon.frame then
						if addon.frame:IsVisible() then
							addon:HideReportFrame()
						else
							addon:DoReport()
							addon:ShowReportFrame()
						end
					end
				end,
				guiHidden = true,
			},
			report = {
				type = 'execute',
				name = 'report',
				desc = L["Report to /raid or /party who is not buffed to the max."],
				func = function()
					addon:DoReport()
					addon:ReportToChat(true)
				end,
				guiHidden = true,
			},
			debug = {
				type = 'toggle',
				name = L["debug messages."],
				desc = L["Toggles debug messages."],
				--order = 0
				width = "double",
				get = function(info) return profile.Debug end,
				set = function(info, v)
					profile.Debug = v
				end
			},
			development = {
			type = 'toggle',
			name = L["Development messages."],
			desc = L["Toggles Development messages. if on, it will show whatever random text i used for Development when i uploaded this version"],
			width = "double",
			get = function(info) return profile.Development end,
			set = function(info, v)
				profile.Development = v
			end,
			},
			f = {
				type = 'execute',
				name = 'f',
				desc = 'Testin stuff',
				func = function()
					addon:SendAddonMessage("oRA3", addon:Serialize("Inventory", "Healthstone"))
				end,
				guiHidden = true,
				cmdHidden = true,
			},
			taunt = {
				type = 'execute',
				name = 'taunt',
				desc = 'Refreshes tank list.',
				func = function()
					addon:oRA_MainTankUpdate()
				end,
				guiHidden = true,
				cmdHidden = true,
			},
			versions = {
				type = 'execute',
				name = 'versions',
				desc = 'Lists known RBS versions which other people and I have.',
				func = function()
					addon:Print("Me:" .. addon.version .. " build-" .. addon.revision)
					for name, version in pairs(addon.rbsversions) do
						addon:Print(name .. ":" .. version)
					end
				end,
				guiHidden = true,
				cmdHidden = false,
			},
			buffwizard = {
				type = 'group',
				name = L["Buff Wizard"],
				desc = L["Automatically configures the dashboard buffs and configuration defaults for your class or raid leading role"],
				order = 1,
				args = {
					intro = {
						type = 'description',
						name = L["The Buff Wizard automatically configures the dashboard buffs and configuration defaults for your class or raid leading role."] .. "\n",
						order = 1,
					},
					raidleader = {
						type = 'execute',
						name = L["Raid leader"],
						desc = L["This is the default configuration in which RBS ships out-of-the-box.  It gives you pretty much anything a raid leader would need to see on the dashboard"],
						order = 2,
						func = function(info, v)
							addon:SetAllOptions("raidleader")
						end,
					},
					coreraidbuffs = {
						type = 'execute',
						name = L["Core raid buffs"],
						desc = L["Only show the core class raid buffs"],
						order = 3,
						func = function(info, v)
							addon:SetAllOptions("coreraidbuffs")
						end,
					},
					justmybuffs = {
						type = 'execute',
						name = L["Just my buffs"],
						desc = L["Only show the buffs for which your class is responsible for.  This configuration can be used like a buff-bot where one simply right clicks on the buffs to cast them"],
						order = 4,
						func = function(info, v)
							addon:SetAllOptions("justmybuffs")
						end,
					},
				},
			},
			appearance = {
				type = 'group',
				name = L["Appearance"],
				desc = L["Skin and minimap options"],
				order = 6,
				args = {
					statusbars = {
						type = 'group',
						name = L["Raid Status Bars"],
						desc = L["Status bars to show raid, dps, tank health, mana, etc"],
						order = 1.5,
						args = {
							statusbarpositioning = {
								type = 'select',
								order = 0,
								name = L["Bar positioning"],
								desc = L["Choose where on the dashboard the bars appear"],
								values = {
									["top"] = L["Top"],
									["onedown"] = L["One group down"],
									["twodown"] = L["Two groups down"],
									["bottom"] = L["Bottom"],
								},
								get = function(info) return profile.statusbarpositioning end,
								set = function(info, v)
									profile.statusbarpositioning = v
									addon:AddBuffButtons()
								end,
							},
							raidhealth = {
								type = 'toggle',
								name = L["Raid health"],
								desc = L["The average party/raid health percent"],
								get = function(info) return profile.RaidHealth end,
								set = function(info, v)
									profile.RaidHealth = v
									addon:AddBuffButtons()
								end,
								order = 1,
							},
							tankhealth = {
								type = 'toggle',
								name = L["Tank health"],
								desc = L["The average tank health percent"],
								get = function(info) return profile.TankHealth end,
								set = function(info, v)
									profile.TankHealth = v
									addon:AddBuffButtons()
								end,
								order = 2,
							},
							raidmana = {
								type = 'toggle',
								name = L["Raid mana"],
								desc = L["The average party/raid mana percent"],
								get = function(info) return profile.RaidMana end,
								set = function(info, v)
									profile.RaidMana = v
									addon:AddBuffButtons()
								end,
								order = 3,
							},
							healermana = {
								type = 'toggle',
								name = L["Healer mana"],
								desc = L["The average healer mana percent"],
								get = function(info) return profile.HealerMana end,
								set = function(info, v)
									profile.HealerMana = v
									addon:AddBuffButtons()
								end,
								order = 4,
							},
							healerdrinkingsound = {
								type = 'toggle',
								name = L["Healer drinking sound"],
								desc = L["Play a sound when a healer drinks and is not full on mana"],
								get = function(info) return profile.healerdrinkingsound end,
								set = function(info, v)
									profile.healerdrinkingsound = v
								end,
								order = 5,
							},
							dpsmana = {
								type = 'toggle',
								name = L["DPS mana"],
								desc = L["The average DPS mana percent"],
								get = function(info) return profile.DPSMana end,
								set = function(info, v)
									profile.DPSMana = v
									addon:AddBuffButtons()
								end,
								order = 6,
							},
							alive = {
								type = 'toggle',
								name = L["Alive"],
								desc = L["The percentage of people alive in the raid"],
								get = function(info) return profile.Alive end,
								set = function(info, v)
									profile.Alive = v
									addon:AddBuffButtons()
								end,
								order = 7,
							},
							dead = {
								type = 'toggle',
								name = L["Dead"],
								desc = L["The percentage of people dead in the raid"],
								get = function(info) return profile.Dead end,
								set = function(info, v)
									profile.Dead = v
									addon:AddBuffButtons()
								end,
								order = 8,
							},
							tanksalive = {
								type = 'toggle',
								name = L["Tanks alive"],
								desc = L["The percentage of tanks alive in the raid"],
								get = function(info) return profile.TanksAlive end,
								set = function(info, v)
									profile.TanksAlive = v
									addon:AddBuffButtons()
								end,
								order = 9,
							},
							healersalive = {
								type = 'toggle',
								name = L["Healers alive"],
								desc = L["The percentage of healers alive in the raid"],
								get = function(info) return profile.HealersAlive end,
								set = function(info, v)
									profile.HealersAlive = v
									addon:AddBuffButtons()
								end,
								order = 10,
							},
							range = {
								type = 'toggle',
								name = L["In range"],
								desc = L["The percentage of people within 40 yards range"],
								get = function(info) return profile.Range end,
								set = function(info, v)
									profile.Range = v
									addon:AddBuffButtons()
								end,
								order = 11,
							},
						},
					},
					minimap = {
						type = 'group',
						name = L["Minimap icon"],
						order = 4,
						args = {
							minimap = {
								type = 'toggle',
								name = L["Minimap icon"],
								desc = L["Toggle to display a minimap icon"],
								order = 1,
								get = function(info) return profile.MiniMap end,
								set = function(info, v)
									profile.MiniMap = v
									addon:UpdateMiniMapButton()
								end,
							},
						},
					},
					skin = {
						type = 'group',
						name = L["Skin and scaling"],
						order = 2,
						args = {
							backgroundcolour = {
								type = 'color',
								name = L["Background colour"],
								desc = L["Background colour"],
								order = 1,
								hasAlpha = true,
								get = function(info)
									local r = profile.bgr
									local g = profile.bgg
									local b = profile.bgb
									local a = profile.bga
									return r, g, b, a
								end,
								set = function(info, r, g, b, a)
									profile.bgr = r
									profile.bgg = g
									profile.bgb = b
									profile.bga = a
									addon:SetFrameColours()
								end,
							},
							bordercolour = {
								type = 'color',
								name = L["Border colour"],
								desc = L["Border colour"],
								order = 2,
								hasAlpha = true,
								get = function(info)
									local r = profile.bbr
									local g = profile.bbg
									local b = profile.bbb
									local a = profile.bba
									return r, g, b, a
								end,
								set = function(info, r, g, b, a)
									profile.bbr = r
									profile.bbg = g
									profile.bbb = b
									profile.bba = a
									addon:SetFrameColours()
								end,
							},
							dashboardcolumns = {
								type = 'range',
								name = L["Dashboard columns"],
								desc = L["Number of columns to display on the dashboard"],
								order = 3,
								min = 2,
								max = 25,
								step = 1,
								bigStep = 1,
								get = function() return profile.dashcols end,
								set = function(info, v)
									profile.dashcols = v
									addon:AddBuffButtons()
								end,
							},
							dashboardscale = {
								type = 'range',
								name = L["Dashboard scale"],
								desc = L["Scale the dashboard window"],
								order = 4,
								min = 0.1,
								max = 5,
								step = 0.1,
								bigStep = 0.1,
								isPercent = true,
								get = function() return profile.dashscale end,
								set = function(info, v)
									local old = addon.frame:GetScale()
									local top = addon.frame:GetTop()
									local left = addon.frame:GetLeft()
									addon.frame:ClearAllPoints()
									addon.frame:SetScale(v)
									left = left * old / v
									top = top * old / v
									addon.frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
									addon:SaveFramePosition()
									profile.dashscale = v
								end,
							},
							hidebossrtrash = {
								type = 'toggle',
								name = L["Hide Boss R Trash"],
								desc = L["Always hide the Boss R Trash buttons"],
								order = 5,
								get = function(info) return profile.hidebossrtrash end,
								set = function(info, v)
									profile.hidebossrtrash = v
									addon:AddBuffButtons()
								end,
							},
							highlightmybuffs = {
								type = 'toggle',
								name = L["Highlight my buffs"],
								desc = L["Hightlight currently missing buffs on the dashboard for which you are responsible including self buffs and buffs which you are missing that are provided by someone else. I.e. show buffs for which you must take action"],
								order = 6,
								get = function(info) return profile.HighlightMyBuffs end,
								set = function(info, v)
									profile.HighlightMyBuffs = v
								end,
							},
							optionsscale = {
								type = 'range',
								name = L["Buff Options scale"],
								desc = L["Scale the Buff Options window"],
								order = 7,
								min = 0.1,
								max = 5,
								step = 0.1,
								bigStep = 0.1,
								isPercent = true,
								get = function() return profile.optionsscale end,
								set = function(info, v)
									local old = addon.optionsframe:GetScale()
									local top = addon.optionsframe:GetTop()
									local left = addon.optionsframe:GetLeft()
									addon.optionsframe:ClearAllPoints()
									addon.optionsframe:SetScale(v)
									left = left * old / v
									top = top * old / v
									addon.optionsframe:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
									profile.optionsscale = v
								end,
							},
							tooltipnamecolor = {
								type = 'toggle',
								name = L["Tooltip name coloring"],
								order = 8,
								get = function(info) return profile.TooltipNameColor end,
								set = function(info, v)
									profile.TooltipNameColor = v
								end,
							},
							tooltiproleicons = {
								type = 'toggle',
								name = L["Tooltip role icons"],
								order = 9,
								get = function(info) return profile.TooltipRoleIcons end,
								set = function(info, v)
									profile.TooltipRoleIcons = v
								end,
							},
						},
					},
					automation = {
						type = 'group',
						name = L["Automation"],
						desc = L["Options for automatically opening the dashboard and moving it"],
						order = 3,
						args = {
							autoshowdashraid = {
								type = 'toggle',
								name = L["Show in raid"],
								desc = L["Automatically show the dashboard when you join a raid"],
								order = 1,
								get = function(info) return profile.AutoShowDashRaid end,
								set = function(info, v)
									profile.AutoShowDashRaid = v
								end,
							},
							autoshowdashparty = {
								type = 'toggle',
								name = L["Show in party"],
								desc = L["Automatically show the dashboard when you join a party"],
								order = 2,
								get = function(info) return profile.AutoShowDashParty end,
								set = function(info, v)
									profile.AutoShowDashParty = v
								end,
							},
							autoshowdashbattle = {
								type = 'toggle',
								name = L["Show in battleground"],
								desc = L["Automatically show the dashboard when you join a battleground"],
								order = 3,
								get = function(info) return profile.AutoShowDashBattle end,
								set = function(info, v)
									profile.AutoShowDashBattle = v
								end,
							},
							hideincombat = {
								type = 'toggle',
								name = L["Hide in combat"],
								desc = L["Hide dashboard during combat"],
								order = 4,
								get = function(info) return profile.HideInCombat end,
								set = function(info, v)
									profile.HideInCombat = v
								end,
							},
							disableincombat = {
								type = 'toggle',
								name = L["Disable scan in combat"],
								desc = L["Skip buff checking during combat. You can manually initiate a scan by pressing Scan on the dashboard"],
								order = 5,
								get = function(info) return profile.DisableInCombat end,
								set = function(info, v)
									profile.DisableInCombat = v
								end,
							},
							movewithaltclick = {
								type = 'toggle',
								name = L["Move with Alt-click"],
								desc = L["Require the Alt buton to be held down to move the dashboard window"],
								order = 6,
								get = function(info) return profile.movewithaltclick end,
								set = function(info, v)
									profile.movewithaltclick = v
								end,
							},
						},
					},
					buffbuttonsorting = {
						type = 'group',
						name = L["Buff button sorting"],
						desc = L["Configure how the buff buttons and status bars on the dashboard are sorted and displayed"],
						order = 1,
						args = {
							groupsortstyle = {
								type = 'select',
								order = 1,
								name = L["Grouping style"],
								desc = L["Choose either one big collection of buff checks or traditional style with Warnings, Trash and Boss buff checks"],
								values = {
									["one"] = L["One big group"],
									["three"] = L["Warning, Trash, Boss groups"],
								},
								get = function(info) return profile.groupsortstyle end,
								set = function(info, v)
									profile.groupsortstyle = v
									addon:AddBuffButtons()
								end,
							},
							buffsortone = {
								type = 'select',
								order = 2,
								name = L["Sort buff buttons by"],
	--							desc = L[""],
								values = {
									["defaultorder"] = L["Default order"],
									["my"] = L["My buffs"],
									["self"] = L["Self buffs"],
									["single"] = L["Single target buffs"],
									["raid"] = L["Raid-wide buffs"],
									["class"] = L["Class-specific buffs"],
									["consumables"] = L["Consumables"],
									["other"] = L["Other"],
								},
								get = function(info) return profile.buffsort[1] end,
								set = function(info, v)
									profile.buffsort[1] = v
									addon:AddBuffButtons()
								end,
							},
							buffsorttwo = {
								type = 'select',
								order = 3,
								name = L["Then sort buff buttons by"],
	--							desc = L[""],
								values = {
									["defaultorder"] = L["Default order"],
									["my"] = L["My buffs"],
									["self"] = L["Self buffs"],
									["single"] = L["Single target buffs"],
									["raid"] = L["Raid-wide buffs"],
									["class"] = L["Class-specific buffs"],
									["consumables"] = L["Consumables"],
									["other"] = L["Other"],
								},
								get = function(info) return profile.buffsort[2] end,
								set = function(info, v)
									profile.buffsort[2] = v
									addon:AddBuffButtons()
								end,
								disabled = function(info)
									return (profile.buffsort[1]):find("defaultorder")
								end,
							},
							buffsortthree = {
								type = 'select',
								order = 4,
								name = L["Then sort buff buttons by"],
	--							desc = L[""],
								values = {
									["defaultorder"] = L["Default order"],
									["my"] = L["My buffs"],
									["self"] = L["Self buffs"],
									["single"] = L["Single target buffs"],
									["raid"] = L["Raid-wide buffs"],
									["class"] = L["Class-specific buffs"],
									["consumables"] = L["Consumables"],
									["other"] = L["Other"],
								},
								get = function(info) return profile.buffsort[3] end,
								set = function(info, v)
									profile.buffsort[3] = v
									addon:AddBuffButtons()
								end,
								disabled = function(info)
									return (profile.buffsort[1] .. profile.buffsort[2]):find("defaultorder")
								end,
							},
							buffsortfour = {
								type = 'select',
								order = 5,
								name = L["Then sort buff buttons by"],
	--							desc = L[""],
								values = {
									["defaultorder"] = L["Default order"],
									["my"] = L["My buffs"],
									["self"] = L["Self buffs"],
									["single"] = L["Single target buffs"],
									["raid"] = L["Raid-wide buffs"],
									["class"] = L["Class-specific buffs"],
									["consumables"] = L["Consumables"],
									["other"] = L["Other"],
								},
								get = function(info) return profile.buffsort[4] end,
								set = function(info, v)
									profile.buffsort[4] = v
									addon:AddBuffButtons()
								end,
								disabled = function(info)
									return (profile.buffsort[1] .. profile.buffsort[2] .. profile.buffsort[3]):find("defaultorder")
								end,
							},
							buffsortfive = {
								type = 'select',
								order = 6,
								name = L["Then sort buff buttons by"],
	--							desc = L[""],
								values = {
									["defaultorder"] = L["Default order"],
									["my"] = L["My buffs"],
									["self"] = L["Self buffs"],
									["single"] = L["Single target buffs"],
									["raid"] = L["Raid-wide buffs"],
									["class"] = L["Class-specific buffs"],
									["consumables"] = L["Consumables"],
									["other"] = L["Other"],
								},
								get = function(info) return profile.buffsort[5] end,
								set = function(info, v)
									profile.buffsort[5] = v
									addon:AddBuffButtons()
								end,
								disabled = function(info)
									return (profile.buffsort[1] .. profile.buffsort[2] .. profile.buffsort[3] .. profile.buffsort[4]):find("defaultorder")
								end,
							},
						},
					},
				},
			},
			utilannounce = {
				type = 'group',
				name = L["Utility announcements"],
				desc = L["Announcement options for raid utilities like Feasts"],
				order = 14,
				args = {
					announceHeader = {
						type = 'header',
						name = L["Utility announcements"],
						order = 0.9,
					},
					announceFeast = {
						type = 'toggle',
						name = L["Feasts"],
						desc = L["Announce to raid warning when a Feast is prepared"],
						order = 1,
					},
					feastautowhisper = {
						type = 'toggle',
						name = L["Feast auto whisper"],
						desc = L["Automatically whisper anyone missing Well Fed when your Feast expire warnings appear"],
						disabled = function() return not profile.announceExpiration end,
						order = 110,
					},
					announceCart = {
						type = 'toggle',
						name = L["Noodle Cart"],
						desc = L["Announce to raid warning when a %s is prepared"]:format(L["Noodle Cart"]),
						order = 2.5,
					},
					announceTable = {
						type = 'toggle',
						name = L["Refreshment Table"],
						desc = L["Announce to raid warning when a %s is prepared"]:format(L["Refreshment Table"]),
						order = 2.75,
					},
					announceCauldron = {
						type = 'toggle',
						name = L["Cauldron"],
						desc = L["Announce to raid warning when a %s is prepared"]:format(L["Cauldron"]),
						order = 3,
					},
					cauldronautowhisper = {
						type = 'toggle',
						name = L["Cauldron auto whisper"],
						desc = L["Automatically whisper anyone missing flasks or elixirs when your Cauldron expire warnings appear"],
						disabled = function() return not profile.announceExpiration end,
						order = 120,
					},
					announceSoulwell = {
						type = 'toggle',
						name = L["Soulwell"],
						desc = L["Announce to raid warning when a %s is prepared"]:format(L["Soulwell"]),
						order = 6,
					},
					wellautowhisper = {
						type = 'toggle',
						name = L["Well auto whisper"],
						desc = L["Automatically whisper anyone missing a Healthstone when your Soul Well expire warnings appear"],
						disabled = function() return not profile.announceExpiration end,
						order = 130,
					},
					announceRepair = {
						type = 'toggle',
						name = L["Repair Bot"],
						desc = L["Announce to raid warning when a %s is prepared"]:format(L["Repair Bot"]),
						order = 7,
					},
					announceMailbox = {
						type = 'toggle',
						name = L["Mailbox"],
						desc = L["Announce to raid warning when a %s is prepared"]:format(L["Mailbox"]),
						order = 8,
					},
					announcePortal = {
						type = 'toggle',
						name = L["Portal"],
						desc = L["Announce to raid warning when a %s is prepared"]:format(L["Portal"]),
						order = 9,
					},
					announceBlingtron = {
						type = 'toggle',
						name = L["Blingtron"],
						desc = L["Announce to raid warning when a %s is prepared"]:format(L["Blingtron"]),
						order = 10,
					},
					expireHeader = {
						type = 'header',
						name = L["Expiration announcements"],
						order = 100,
					},
					announceExpiration = {
						type = 'toggle',
						name = L["Announce expiration"],
						desc = L["Announce to raid warning when a utility is expiring"],
						order = 101,
					},
					antispam = {
						type = 'toggle',
						name = L["Anti spam"],
						desc = L["Wait before announcing to see if others have announced first in order to reduce spam"],
						order = 0.1,
						get = function(info) return profile.antispam end,
						set = function(info, v)
							profile.antispam = v
						end,
					},
					nonleadspeak = {
						type = 'toggle',
						name = L["Announce without lead"],
						desc = L["Announce even when you don't have assist or lead"],
						order = 0.2,
						get = function(info) return profile.nonleadspeak end,
						set = function(info, v)
							profile.nonleadspeak = v
						end,
					},
				},
			},
			autoacceptinvites = {
				type = 'group',
				name = L["Auto-accept invites"],
				desc = L["Automatically accept invites from friends and guild members so you can go for a bio-break whilst waiting for a raid invite"],
				order = 16,
				args = {
					guildmembers = {
						type = 'toggle',
						name = L["Guild members"],
						desc = L["Automatically accept invites from these"],
						order = 1,
						get = function(info) return profile.guildmembers end,
						set = function(info, v)
							profile.guildmembers = v
						end,
					},
					friends = {
						type = 'toggle',
						name = L["Friends"],
						desc = L["Automatically accept invites from these"],
						order = 2,
						get = function(info) return profile.friends end,
						set = function(info, v)
							profile.friends = v
						end,
					},
					bnfriends = {
						type = 'toggle',
						name = L["Battle.net friends"],
						desc = L["Automatically accept invites from these"],
						order = 3,
						get = function(info) return profile.bnfriends end,
						set = function(info, v)
							profile.bnfriends = v
						end,
					},
				},
			},
			autoinviteswhispers = {
				type = 'group',
				name = L["Auto-invite whispers"],
				desc = L["Automatically invite friends and guild members who whisper to you the word 'invite'"],
				order = 17,
				args = {
					guildmembers = {
						type = 'toggle',
						name = L["Guild members"],
						desc = L["Automatically invite these"],
						order = 1,
						get = function(info) return profile.aiwguildmembers end,
						set = function(info, v)
							profile.aiwguildmembers = v
						end,
					},
					friends = {
						type = 'toggle',
						name = L["Friends"],
						desc = L["Automatically invite these"],
						order = 2,
						get = function(info) return profile.aiwfriends end,
						set = function(info, v)
							profile.aiwfriends = v
						end,
					},
					bnfriends = {
						type = 'toggle',
						name = L["Battle.net friends"],
						desc = L["Automatically invite these"],
						order = 3,
						get = function(info) return profile.aiwbnfriends end,
						set = function(info, v)
							profile.aiwbnfriends = v
						end,
					},
				},
			},
			versionannounce = {
				type = 'group',
				name = L["Version announce"],
				desc = L["Tells you when someone in your party, raid or guild has a newer version of RBS installed"],
				order = 18,
				args = {
					versionannounce = {
						type = 'toggle',
						name = L["Version announce"],
						desc = L["Tells you when someone in your party, raid or guild has a newer version of RBS installed"],
						order = 1,
						get = function(info) return profile.versionannounce end,
						set = function(info, v)
							profile.versionannounce = v
						end,
					},
					userannounce = {
						type = 'toggle',
						name = L["User announce"],
						desc = L["Tells you when someone in your party, raid or guild has RBS installed"],
						order = 2,
						get = function(info) return profile.userannounce end,
						set = function(info, v)
							profile.userannounce = v
						end,
					},
				},
			},
		},
	}

	addon.configOptions = options
end