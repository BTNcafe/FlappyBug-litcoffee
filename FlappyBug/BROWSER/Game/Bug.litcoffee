FlappyBug bug in game.
======================

	FlappyBug('Game').Bug = CLASS

		statics : (cls) ->

			# half collision size
			cls.halfCollisionWidth = 30 / 2
			cls.halfCollisionHeight = 20 / 2

		init : (cls, inner, self, onDie) ->
			#REQUIRED: onDie

			# jump sound
			jumpSound = SOUND
				mp3 : FlappyBug.R_URI('jump.mp3')
				ogg : FlappyBug.R_URI('jump.ogg')

			# die sound
			dieSound = SOUND
				mp3 : FlappyBug.R_URI('die.mp3')
				ogg : FlappyBug.R_URI('die.ogg')

			# waiting loop count
			waitingLoopCount = 0

			# gravity amount
			g = 9.80665

			# gs
			gs = undefined

			# left
			left = 60

			# top
			top = 200

			# half img width
			halfImgWidth = undefined

			# half img height
			halfImgHeight = undefined

			# degree
			degree = undefined

			# is dead
			isDead = undefined

			# frame count
			frameCount = 0

			# gravity loop
			gravityLoop = undefined

			layer = USCREEN.LAYER()

			# load bug image.
			EVENT
				node : IMG
					src : FlappyBug.R 'bug.png'
				name : 'load'
			, (e, img) ->

				halfImgWidth = img.getWidth() / 2 / 2
				halfImgHeight = img.getHeight() / 2

				# init layer.
				layer.setClipWidth halfImgWidth * 2
				layer.setImg img
				layer.moveTo
					left : left - halfImgWidth
					top : top - halfImgHeight
					zIndex : 3

			animationLoop = LOOP 20, ->

				layer.setClipLeft frameCount * halfImgWidth * 2

				frameCount += 1

				if frameCount >= 2
					frameCount = 0;

			waitingLoop = LOOP ->

				waitingLoopCount += 0.1

				top += (Math.sin waitingLoopCount) / 2

				layer.moveTo
					top : top - halfImgHeight

			# when remove layer.
			layer.addAfterRemoveProc ->

				if animationLoop isnt undefined
					animationLoop.remove()

				if waitingLoop isnt undefined
					waitingLoop.remove()

				if gravityLoop isnt undefined
					gravityLoop.remove()

			self.appendTo = appendTo = (parent) ->
				#REQUIRED: parent

				layer.appendTo parent

				self

			self.remove = remove = ->
				layer.remove()

			self.die = die = ->

				isDead = true

				dieSound.play()

				animationLoop.remove()
				animationLoop = undefined

				onDie()

			self.jump = jump = ->

				if isDead isnt true

					# init values.
					gs = -5
					degree = -45

					# play jump sound.
					jumpSound.play()

					if gravityLoop is undefined

						# remove waiting loop.
						waitingLoop.remove()
						waitingLoop = undefined

						# init gravity loop.
						gravityLoop = LOOP ->

							# fall.
							if top + gs < 400 - cls.halfCollisionHeight

								top += gs
								gs += g / 60 * 1.5

								degree += 2
								if degree > 90
									degree = 90

							# when touches ground.
							else

								top = 400 - cls.halfCollisionHeight

								if isDead isnt true
									die()

							# too high!
							if top < 0
								top = 0

							# rotate bug.
							layer.rotate
								centerLeft : 19
								centerTop : 19
								degree : degree

							# change position.
							layer.moveTo
								top : top - halfImgHeight

			self.getPosition = getPosition = ->
				left : left
				top : top
