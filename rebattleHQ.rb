# CREDITS
# Rejuvenation Team for the game
# Wiresegal for helping me code this and creating the framework (also fixing my spaghetti code)
# Toby Fox/Undertale Team for music

# DEPENDENCIES
# 0000.injection.rb, 0000.textures.rb, trainerRebattler.rb, 0000.music.rb

Variables[:StarterChoice] = 7
Variables[:PlayerPositionX] = 468
Variables[:PlayerPositionY] = 469
Variables[:PlayerMapLocation] = 467


# Music Signpost
class Game_System
  alias :jakeebsans_old_initialize :initialize

  def initialize(*args, **kwargs)
    ret = jakeebsans_old_initialize(*args, **kwargs)
    MusicSignpostDisplay::MAPPING["jakeeb_sans"] = "[Music] sans." if defined?(MusicSignpostDisplay)
    return ret
  end
end
# Map name override
class MapMetadata
  attr_writer :ShowArea
  attr_writer :MapPosition
end
$cache.mapinfos[308].name = "Team Xans HQ"
$cache.mapdata[308].ShowArea = true
$cache.mapdata[308].MapPosition = [0, 22, 29]
$WIRE_LATE_LOAD = [] unless defined?($WIRE_LATE_LOAD)
$WIRE_LATE_LOAD << proc {
  # Texture Overrides
  TextureOverrides.registerTextureOverride(TextureOverrides::CHARS + "NPC jakeeb", __dir__[Dir.pwd.length+1..] + "/rebattleInfo/jakeeb")
  # Music Overrides
  MusicOverrides.registerMusicOverride("Audio/BGM/jakeeb_sans", __dir__[Dir.pwd.length+1..] + "/rebattleInfo/jakeeb_sans")
  MusicOverrides.registerMusicOverride("Audio/SE/jakeeb_drink", __dir__[Dir.pwd.length+1..] + "/rebattleInfo/jakeeb_drink")
  # Map Patches
  InjectionHelper.defineMapPatch(304) { |map| # Gearen Labs
    # Add desk
    map.fillArea( 9, 12,
      ["A",
      "B"],
      {
        "A" => [nil, 1521, 0],
        "B" => [nil, 1529, nil],
      }
    )
    # Teleport to Xans HQ
    InjectionHelper.createNewEvent(map, 9, 12, "jakeeb_to_xans", "jakeeb_to_xans") { |event|
    # Initial interaction  
      event.newPage { |page|
        page.setGraphic("NPC jakeeb", direction: :Down, pattern: 0)
        page.requiresVariable(:StarterChoice, 1) # ensures npc doesn't appear when you don't have a pokemon
        page.interact(
          [:ConditionalBranch, :Character, :Player, :Up],
            [:ControlSelfSwitch, "A", true],
            [:Script, "$game_self_switches[[294, 'jakeeb_to_xans', 'A']] = true"],
            [:ShowText, "???: Hello there! I'm Jakeeb."],
            [:ShowText, "I found someone while exploring around here that allows you to rebattle trainers."],
            [:ShowText, "They call themself \\c[6]Madame Xans\\c[0\]."],
            [:ShowText, "Would you like me to take you to them?"],
            [:ShowChoices, ["Yes", "No"], 2],
            [:When, 0, "Yes"],
              [:ShowText, "Right this way, then!"],
              [:ControlVariable, :PlayerPositionX, :Set, :Character, :Player, :x],
              [:ControlVariable, :PlayerPositionY, :Set, :Character, :Player, :y],
              [:ControlVariable, :PlayerMapLocation, :Set, :Other, :map_id],
              [:PlaySoundEvent, "Entering Door", 80, 100],
              [:ChangeScreenColorTone, Tone.new(-255,-255,-255,0), 10],
              [:Wait, 10],
              [:TransferPlayer, :Constant, 308, 26, 46, :Up, true],
              [:ChangeScreenColorTone, Tone.new(0,0,0,0), 10],
              [:Wait, 10],
              :Done,
            [:When, 1, "No"],
              [:ShowText, "JAKEEB: Okay then, talk to me if you would like me to warp you to them later!"],
              :Done,
          :Else,
            [:ShowText, "???: Please don't talk to me from this side. I have social anxiety."], # this is true
          :Done
        )
      }
      # Second+ Interaction
      event.newPage { |page|
        page.requiresSelfSwitch("A")

        page.setGraphic("NPC jakeeb", direction: :Down, pattern: 0)

        page.interact(
          [:ConditionalBranch, :Character, :Player, :Up],
            [:ShowText, "JAKEEB: Would you like me to take you to Xans HQ?"],
            [:ShowChoices, ["Yes", "No"], 2],
            [:When, 0, "Yes"],
              [:ShowText, "Right this way, then!"],
              [:ControlVariable, :PlayerPositionX, :Set, :Character, :Player, :x],
              [:ControlVariable, :PlayerPositionY, :Set, :Character, :Player, :y],
              [:ControlVariable, :PlayerMapLocation, :Set, :Other, :map_id],
              [:PlaySoundEvent, "Entering Door", 80, 100],
              [:ChangeScreenColorTone, Tone.new(-255,-255,-255,0), 10],
              [:Wait, 10],
              [:TransferPlayer, :Constant, 308, 26, 46, :Up, true],
              [:ChangeScreenColorTone, Tone.new(0,0,0,0), 10],
              [:Wait, 10],
            :Done,
            [:When, 1, "No"],
            :Done,
          :Else,
            [:ShowText, "JAKEEB: Please don't talk to me from this side. I have social anxiety."],
          :Done)
      }
    }
  }
  InjectionHelper.defineMapPatch(294) { |map| # GDC Central
    # Teleport to Xans HQ
    InjectionHelper.createNewEvent(map, 6, 8, "jakeeb_to_xans", "jakeeb_to_xans") { |event|
    # Initial interaction  
      event.newPage { |page|
        page.setGraphic("NPC jakeeb", direction: :Left, pattern: 0)
        page.requiresVariable(:StarterChoice, 1) # ensures npc doesn't appear when you don't have a pokemon
        page.interact(
          [:ConditionalBranch, :Character, :Player, :Right],
            [:ControlSelfSwitch, "A", true],
            [:Script, "$game_self_switches[[304, 'jakeeb_to_xans', 'A']] = true"],
            [:ShowText, "???: Hello there! I'm Jakeeb."],
            [:ShowText, "I found someone while exploring around here that allows you to rebattle trainers."],
            [:ShowText, "They call themself \\c[6]Madame Xans\\c[0\]."],
            [:ShowText, "Would you like me to take you to them?"],
            [:ShowChoices, ["Yes", "No"], 2],
            [:When, 0, "Yes"],
              [:ShowText, "Right this way, then!"],
              [:ControlVariable, :PlayerPositionX, :Set, :Character, :Player, :x],
              [:ControlVariable, :PlayerPositionY, :Set, :Character, :Player, :y],
              [:ControlVariable, :PlayerMapLocation, :Set, :Other, :map_id],
              [:PlaySoundEvent, "Entering Door", 80, 100],
              [:ChangeScreenColorTone, Tone.new(-255,-255,-255,0), 10],
              [:Wait, 10],
              [:TransferPlayer, :Constant, 308, 26, 46, :Up, true],
              [:ChangeScreenColorTone, Tone.new(0,0,0,0), 10],
              [:Wait, 10],
              :Done,
            [:When, 1, "No"],
              [:ShowText, "JAKEEB: Okay then, talk to me if you would like me to warp you to them later!"],
            :Done,
          :Else,
            [:ShowText, "???: Please don't talk to me from this side. I have social anxiety."], # this is true
          :Done)
      }
      # Second+ Interaction
      event.newPage { |page|
        page.requiresSelfSwitch("A")
        page.setGraphic("NPC jakeeb", direction: :Left, pattern: 0)

        page.interact(
          [:ConditionalBranch, :Character, :Player, :Right],
            [:ShowText, "JAKEEB: Would you like me to take you to Xans HQ?"],
            [:ShowChoices, ["Yes", "No"], 2],
              [:When, 0, "Yes"],
                [:ShowText, "Right this way, then!"],
                [:ControlVariable, :PlayerPositionX, :Set, :Character, :Player, :x],
                [:ControlVariable, :PlayerPositionY, :Set, :Character, :Player, :y],
                [:ControlVariable, :PlayerMapLocation, :Set, :Other, :map_id],
                [:PlaySoundEvent, "Entering Door", 80, 100],
                [:ChangeScreenColorTone, Tone.new(-255,-255,-255,0), 10],
                [:Wait, 10],
                [:TransferPlayer, :Constant, 308, 26, 46, :Up, true],
                [:ChangeScreenColorTone, Tone.new(0,0,0,0), 10],
                [:Wait, 10],
              :Done,
              [:When, 1, "No"],
              :Done,
          :Else,
            [:ShowText, "JAKEEB: Please don't talk to me from this side. I have social anxiety."],
          :Done)
      }
    }
  }
  InjectionHelper.defineMapPatch(308) { |map| # Removed Lab
    # Makeover
    map.fillArea( 18, 36,
    ["     AABBBAA     ",
    "     CDEFGCD     ",
    "B    HIJJJHI     ",
    "K    LMOOOPQ     ",
    "RBBBBSTOOOTUBBBBB",
    "VKKKKWTOOOTXKCDKK",
    "YZZZZaTOOOTaZHIZZ",
    "OOTOOOTOOOTOOLMOO",
    "OOTOOOTOOOTOOOTOO",
    "OOTOOOTOOOTOOOTOO",
    "b   cdTOOOTcd    "],
    {
      "A" => [387, nil, 0],
      "B" => [387, nil, nil],
      "C" => [1417, nil, 1586],
      "D" => [1417, nil, 1587],
      "E" => [1417, nil, 2280],
      "F" => [1417, nil, 2281],
      "G" => [1417, nil, 2282],
      "H" => [1425, nil, 1594],
      "I" => [1425, nil, 1595],
      "J" => [1425, nil, 0],
      "K" => [1417, nil, nil],
      "L" => [1376, nil, 1602],
      "M" => [1378, nil, 1603],
      "O" => [1376, nil, nil],
      "P" => [1378, nil, 1602],
      "Q" => [1376, nil, 1603],
      "R" => [1425, 1537, nil],
      "S" => [1376, 1372, nil],
      "T" => [1378, nil, nil],
      "U" => [1376, 1371, nil],
      "V" => [1376, 1545, nil],
      "W" => [1376, 1380, 0],
      "X" => [1376, 1379, 0],
      "Y" => [1376, 1553, nil],
      "Z" => [1425, nil, nil],
      "a" => [1376, nil, 0],
      "b" => [1376, 1617, 951],
      "c" => [1376, nil, 1586],
      "d" => [1376, nil, 1587],
    })

    map.autoplay_bgm = true  
    map.bgm = RPG::AudioFile.new('jakeeb_sans', 80, 100)
    # Teleport to Gearen Labs
    map.createSinglePageEvent(29, 43, "jakeeb_to_gearen") { |page|
      page.setGraphic("NPC jakeeb", direction: :Down, pattern: 0)
      page.interact(
        [:ShowText, "JAKEEB: Would you like to go back?"],
        [:ShowChoices, ["Yes", "No"], 2],
        [:When, 0, "Yes"],
          [:ShowText, "Right this way, then!"],
          [:PlaySoundEvent, "Entering Door", 80, 100],
          [:ChangeScreenColorTone, Tone.new(-255,-255,-255,0), 10],
          [:Wait, 10],
          [:ConditionalBranch, :Variable, :PlayerMapLocation, :Constant, 294, :Equals],
            [:TransferPlayer, :Variable, :PlayerMapLocation, :PlayerPositionX, :PlayerPositionY, :Right, true],
          :Else,
            [:TransferPlayer, :Variable, :PlayerMapLocation, :PlayerPositionX, :PlayerPositionY, :Down, true],
            [:ChangeScreenColorTone, Tone.new(0,0,0,0), 10],
          :Done,
          [:Wait, 10],
        :Done,
        [:When, 1, "No"],
        :Done)
    }
    # Wiresegal NPC
    map.createSinglePageEvent(23, 43, "wiresegal") { |page|
      page.setGraphic("BGirlWalk_3", direction: :Down, pattern: 0)
      page.interact(
        [:ConditionalBranch, :Switch, :Ana, true],
          [:ConditionalBranch, :Variable, :Outfit, :Constant, 3, :Equals],
            [:ShowAnimation, :This, 17],
            [:Wait, 20],
            [:ShowText, "WIRE: Oh, hey, nice taste. Looking <c3=f64f4f,802929>f</c3><c3=bb7814,613e0a>a</c3><c3=7c9b00,405100>b</c3><c3=36bb14,1c610a>u</c3><c3=17be5a,0c632e>l</c3><c3=0cb3b3,065d5d>o</c3><c3=478aee,25477c>u</c3><c3=8567ff,45348b>s</c3><c3=cc46ed,6a247b>.</c3>"],
          :Else,
            [:ConditionalBranch, :Variable, :Outfit, :Constant, 4, :Equals],
              [:ShowAnimation, :This, 29],
              [:Wait, 20],
              [:ShowText, "WIRE: lol, lmao, you're a box"],
            :Else,
              [:ConditionalBranch, :Variable, :Outfit, :Constant, 2, :Equals],
                [:ShowAnimation, :This, 19],
                [:Wait, 20],
                [:ShowText, "WIRE: Legacy Ana is such a genderthing, isn't she?"],
              :Else,
                [:ShowAnimation, :This, 18],
                [:Wait, 20],
                [:ShowText, "WIRE: Glad to see you're using the best character."],
              :Done,
            :Done,
          :Done,
          [:ShowText, "I'm Wire Segal. I helped jakeeb make this mod. I'm just hanging out."],
        :Else,
          [:ShowText, "WIRE: I'm Wire Segal. I helped jakeeb make this mod. I'm just hanging out."],
        :Done)
    }
    # Refight NPC
    map.createSinglePageEvent(26, 40, "madame_xans") { |page|
      page.setGraphic("Sans")
      page.interact([:Script, "TrainerRefightSelection.selectFight"])
    }
    # Heal Star
    map.createSinglePageEvent(24, 46, "heal_star") { |page|
      page.setGraphic("HealBell")
      page.direction_fix = true
      page.move_speed = 1
      page.step_anime = true
      page.interact(
        [:Script, 'Kernel.pbSetPokemonCenter'],
        [:ScreenFlash, Color.new(255,255,255,255), 35],
        [:PlayMusicEvent, 'Pokemon Healing', 100, 100],
        [:HealParty, 0],
        [:Wait, 60],
        [:ShowText, 'Your party has been healed!'])
    }
    # PC Star
    map.createSinglePageEvent(28, 46, "heal_star") { |page| 
      page.setGraphic("HealBell", hueShift: 100)
      page.direction_fix = true
      page.move_speed = 1
      page.step_anime = true
      page.interact(
        [:Script, 'Kernel.pbPokeCenterPC'])
    }
    # Meme panel
    map.createSinglePageEvent(34, 42, "meme_panel") { |page|
      page.interact(
        [:ShowText, "\\se[computeropen]You booted up the access panel."],
        [:ShowText, "..."],
        [:ShowText, "It's filled with shitposts, including an image titled \"bnuuy.png.\""],
        [:ShowText, "Strangely, it looks like Melia, and is signed \"-XxXCursedEyeXxX.\""],
        [:PlaySoundEvent, "computerclose"])
    }
    map.createSinglePageEvent(18, 46, "meme_beer") { |page|
      page.interact(
        [:ShowText, "You see an ice cold beer. Drink some?"],
        [:ShowChoices, ["Yes", "No"], 2],
        [:When, 0, "Yes"],
          [:PlaySoundEvent, "jakeeb_drink"],
          [:Script, 'pbWait((Graphics.frame_rate / 6.5).round())'],
          [:PlaySoundEvent, "jakeeb_drink"],
          [:Script, 'pbWait((Graphics.frame_rate / 6.5).round())'],
          [:PlaySoundEvent, "jakeeb_drink"],
          [:Script, 'pbWait((Graphics.frame_rate / 6.5).round())'],
          [:ShowText, 'You\'re now drunk as hell.'],
        :Done,
        [:When, 1, "No"],
          [:ShowText, "A wise choice."],
        :Done)
    }
    map.createSinglePageEvent(26, 38, "meme_board") { |page|
      page.interact([:ShowText, "It probably says something important, but unfortunately you're illiterate."])
    }
    map.createSinglePageEvent(18, 42, "meme_pc") { |page|
      page.interact(
        [:ShowText, "You wonder why this computer is facing this way."],
        [:ShowText, '"How would you ever use it?" you ask yourself.'],
        [:Wait, 20],
        [:ShowText, "There are no answers. \\|There will \\c[2]never\\c[0] be answers."])
    }
    map.createSinglePageEvent(23, 42,  "shard_left") { |page|
      page.setGraphic("object_blackshardore", direction: :Up, hueShift: 210)
      page.step_anime = true
      page.move_speed = 1
    }
    map.createSinglePageEvent(29, 42,  "shard_right") { |page|
      page.setGraphic("object_blackshardore", direction: :Up, hueShift: 290, pattern: 2)
      page.step_anime = true
      page.move_speed = 1
    }
  }
}
