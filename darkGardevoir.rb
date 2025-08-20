$WIRE_LATE_LOAD = [] unless defined?($WIRE_LATE_LOAD)
$WIRE_LATE_LOAD << proc {
  TextureOverrides.registerTextureOverrides({
  TextureOverrides::ICONS + "icon282_6" => __dir__[Dir.pwd.length+1..] + "/darkGardevoir/icon_mega",
  TextureOverrides::BATTLER + "282_6" => __dir__[Dir.pwd.length+1..] + "/darkGardevoir/front_mega",
  TextureOverrides::BATTLER + "282b_6" => __dir__[Dir.pwd.length+1..] + "/darkGardevoir/back_mega",
  TextureOverrides::BATTLER + "282_5" => __dir__[Dir.pwd.length+1..] + "/darkGardevoir/front",
  TextureOverrides::BATTLER + "282b_5" => __dir__[Dir.pwd.length+1..] + "/darkGardevoir/back",
  TextureOverrides::ICONS + "icon282_5" => __dir__[Dir.pwd.length+1..] + "/darkGardevoir/icon"
})
}
if $cache.pkmn[:GARDEVOIR].formData[:DefaultForm].is_a?(Numeric)
  $cache.pkmn[:GARDEVOIR].formData[:DefaultForm] = [0]
end

$cache.pkmn[:GARDEVOIR].formData[:DefaultForm].push(5) if !$cache.pkmn[:GARDEVOIR].formData[:DefaultForm].include?(5)

if $cache.pkmn[:GARDEVOIR].formData[:MegaForm][:GARDEVOIRITE].is_a?(Numeric)
  $cache.pkmn[:GARDEVOIR].formData[:MegaForm][:GARDEVOIRITE] = { 0 => 1 }
end

$cache.pkmn[:GARDEVOIR].formData[:MegaForm][:GARDEVOIRITE][5] = 6

$cache.abil[:DUSKILATE] = AbilityData.new(:DUSKILATE, {
  name: "Duskilate",
  :desc => "Normal-type moves become Dark-type moves...",
  :fullDesc => "Normal-type moves become Dark-type moves and deal 20% more damage. This overrides Ion Deluge."
}) 
$cache.pkmn[:GARDEVOIR].formData["Dark Form"] = {
  kind: "Animus",
  dexentry: "Gardevoir has unlocked its latent affinity for darkness, becoming consumed by hatred. It will still devote itself to a single cause and master.",
  :Moveset => [
            [0,:DARKPULSE],
            [1,:MOONBLAST],
            [1,:STOREDPOWER],
            [1,:MISTYTERRAIN],
            [1,:DAZZLINGGLEAM],
            [1,:HEALINGWISH],
            [1,:GROWL],
            [1,:CONFUSION],
            [1,:DOUBLETEAM],
            [1,:TELEPORT],
            [4,:CONFUSION],
            [6,:DOUBLETEAM],
            [9,:TELEPORT],
            [11,:DISARMINGVOICE],
            [14,:WISH],
            [17,:THIEF],
            [19,:SNARL],
            [23,:DRAININGKISS],
            [23,:PAINSPLIT],
            [26,:NASTYPLOT],
            [31,:PSYCHIC],
            [35,:IMPRISON],
            [40,:FUTURESIGHT],
            [44,:CAPTIVATE],
            [49,:HYPNOSIS],
            [53,:DREAMEATER],
            [58,:STOREDPOWER],
            [62,:MOONBLAST]],
        :compatiblemoves => [:BODYSLAM, :BURNINGJEALOUSY, :CALMMIND,:CHARGEBEAM,:CHARM, :DARKPULSE, :DAZZLINGGLEAM,:DEFENSECURL,:DOUBLEEDGE,:DRAININGKISS,:DREAMEATER,:ECHOEDVOICE,:ENERGYBALL,:EXPANDINGFORCE, :FAKETEARS, :FIREPUNCH,:FLASH,:FLING,:FOCUSBLAST,:FOULPLAY, :FUTURESIGHT,:GIGAIMPACT,:GRASSKNOT,:GUARDSWAP,:HEADBUTT,:HYPERBEAM,:HYPERVOICE, :ICEBEAM, :ICEPUNCH,:ICYWIND,:IMPRISON,:LASERFOCUS,:LIGHTSCREEN,:MAGICALLEAF,:MAGICCOAT,:MAGICROOM,:MEGAKICK,:MEGAPUNCH,:MIMIC,:MISTYEXPLOSION,:MISTYTERRAIN,:MUDSLAP,:MYSTICALFIRE,:NASTYPLOT, :NIGHTMARE,:LASHOUT, :PAINSPLIT,:POWERSWAP,:PSYCHIC,:PSYCHICTERRAIN,:PSYCHUP,:PSYSHOCK,:RAINDANCE,:RECYCLE,:REFLECT,:SAFEGUARD,:SHADOWBALL,:SHOCKWAVE,:SIGNALBEAM,:SKILLSWAP,:SNATCH,:STOREDPOWER,:SUNNYDAY,:SWIFT,:TAUNT,:TELEKINESIS,:THIEF,:THUNDERBOLT,:THUNDERPUNCH,:THUNDERWAVE,:TORMENT,:TRICK,:TRICKROOM,:TRIPLEAXEL,:WILLOWISP,:WONDERROOM,:ZENHEADBUTT],
  Abilities: [:MAGICIAN],
  Type1: :DARK,
  Type2: :FAIRY,
  toobig: true 
}
$cache.pkmn[:KIRLIA].evolutions.push([:GARDEVOIR,:ItemFemale,:DUSKSTONE]) unless $cache.pkmn[:KIRLIA].evolutions.include?([:GARDEVOIR,:ItemFemale,:DUSKSTONE])
alias :darkgardevoir_old_getEvolutionForm :getEvolutionForm

def getEvolutionForm(mon,item=nil)
  species = mon.species
  form = darkgardevoir_old_getEvolutionForm(mon,item) 
  case species
  when :KIRLIA
    if item == :DUSKSTONE
      return 5
    else
      return form
    end
  else return form
  end
end
$cache.pkmn[:GARDEVOIR].formData["Dark Mega Form"] = {
  Abilities: [:DUSKILATE],
  BaseStats: [68, 85, 65, 165, 135, 100],
  Type1: :DARK,
  Type2: :FAIRY,
  toobig: true,
}

$cache.pkmn[:GARDEVOIR].forms[5] = "Dark Form"
$cache.pkmn[:GARDEVOIR].forms[6] = "Dark Mega Form"
alias :darkgardevoir_old_pbIconBitmap :pbIconBitmap
alias :darkgardevoir_old_pbPokemonIconBitmap :pbPokemonIconBitmap

def pbPokemonIconBitmap(pokemon,egg=false)
  if (pokemon.species == :GARDEVOIR && (5..6).include?(pokemon.form))
    shiny = pokemon.isShiny?
    girl = pokemon.isFemale? ? "f" : ""
    form = pokemon.form
    egg = egg ? "egg" : ""
    species = $cache.pkmn[pokemon.species].dexnum 
    name = pokemon.species.downcase
    filename=sprintf("Graphics/Icons/icon%03d%s%s_%s",species,girl,egg,form)
    filename=sprintf("Graphics/Icons/icon%03d%s_%s", species,egg,form) if !pbResolveBitmap(filename)
    filename=sprintf("Graphics/Icons/%s%s%s_%s",name,girl,egg,form) if !pbResolveBitmap(filename)
    filename=sprintf("Graphics/Icons/%s%s_%s",name,egg,form) if !pbResolveBitmap(filename)
    if pbResolveBitmap(filename)
      iconbitmap = RPG::Cache.load_bitmap(filename)
      bitmap=Bitmap.new(128,64)
      x = shiny ? 128 : 0
      y = 0 # No form differentiation
      y = 0 if iconbitmap.height <= y
      rectangle = Rect.new(x,y,128,64)
      bitmap.blt(0,0,iconbitmap,rectangle)
      bitmap = makeShadowBitmap(bitmap, 128, 64) if pokemon.isShadow?
      return bitmap
    end
  end

  return darkgardevoir_old_pbPokemonIconBitmap(pokemon,egg)
end


def pbIconBitmap(species,form=0,shiny=false,girl=false,egg=false)
  if (species == :GARDEVOIR && (5..6).include?(form))
    filename=sprintf("Graphics/Icons/icon%03d%s%s_%s",species,girl,egg,form)
    filename=sprintf("Graphics/Icons/icon%03d%s_%s", species,egg,form) if !pbResolveBitmap(filename)
    filename=sprintf("Graphics/Icons/icon%03d_%s",species, form) if !pbResolveBitmap(filename)
    if pbResolveBitmap(filename)
      iconbitmap = RPG::Cache.load_bitmap(filename)
      bitmap=Bitmap.new(128,64)
      x = shiny ? 128 : 0
      y = 0 # No form differentiation
      y = 0 if iconbitmap.height <= y
      rectangle = Rect.new(x,y,128,64)
      return bitmap
    end
  end

  return darkgardevoir_old_pbIconBitmap(species,form,shiny,girl,egg)
end
