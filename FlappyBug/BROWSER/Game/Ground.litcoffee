FlappyBug ground in game.
=========================

	FlappyBug('Game').Ground = CLASS

		init : (cls, inner, self) ->

			# ground loop
			groundLoop = undefined

			layer = USCREEN.LAYER
				zIndex : 2

			EVENT
				node : IMG
					src : FlappyBug.R 'ground.png'
				name : 'load'
			, (e, img) ->

				# generate ground layers.
				left = 0
				while left < FlappyBug.GameView.gameWidth
					USCREEN.LAYER(
						img : img
						left : left
						top : 400
					).appendTo layer
					left += img.getWidth()
				USCREEN.LAYER(
					img : img
					left : left
					top : 400
				).appendTo layer

				# move ground loop
				left = 0
				groundLoop = LOOP ->
					left -= 2
					layer.moveTo
						left : left

					if left <= -img.getWidth()
						left = 0

			# when remove layer.
			layer.addAfterRemoveProc ->
				if groundLoop isnt undefined
					groundLoop.remove()

			self.appendTo = appendTo = (parent) ->
				#REQUIRED: parent

				layer.appendTo parent

				self

			self.remove = remove = ->
				layer.remove()

			self.removeGroundLoop = removeGroundLoop = ->
				if groundLoop isnt undefined
					groundLoop.remove()
					groundLoop = undefined
