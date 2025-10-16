def bettermissy_patchForm(species, form="Aevian Form", **values)
  $cache.pkmn[species].formData[form].merge! values
end # expandable if i feel like it
bettermissy_patchForm(:MISMAGIUS, BaseStats: [60,105,105,60,60,105])