require '../UPPERCASE/BOOT.js'

_BOOT = BOOT

global.BOOT = (params) ->
	
	compile = (require './coffee-script.js').CoffeeScript.compile

	params.OTHER_LANGS =
		coffee : (code) ->
			compile code
		litcoffee : (code) ->
			compile code, { literate: true }
		
	_BOOT params