#= require egg_carton

#Older iOS requires json2 (used by coffeekup)
#Fixes for older iOS missing functions
Object.keys ?= _.keys
Array.isArray ?= _.isArray

window.eggCarton = new EggCarton()
