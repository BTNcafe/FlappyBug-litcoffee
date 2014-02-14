FlappyBug game view.
isisisisisis==

	FlappyBug.GameView = CLASS

		statics : (cls) ->

			# game screen size.
			cls.gameWidth = 360
			cls.gameHeight = 480

		preset : ->
			return VIEW;

		init : (cls, inner, self) ->

			# bgm
			bgm = SOUND
				mp3 : FlappyBug.R_URI 'bgm.mp3'
				ogg : FlappyBug.R_URI 'bgm.ogg'
				isLoop : true
			.play()

			# score store
			scoreStore = FlappyBug.STORE 'score'

			# pass pipe count
			passPipeCount = 0

			# is started
			isStarted = undefined

			# is game over
			isGameOver = undefined

			# create pipe interval
			createPipeInterval = undefined

			# end modal
			endModal = undefined

			# pipes
			pipes = []

			TITLE 'FlappyBug :: Game'

			wrapper = DIV
				style :
					position : 'absolute'
					left : 0
					top : 0
					width : '100%'
					height : '100%'

				childs : [

					# game surface
					surface = USCREEN.SURFACE
						style :
							position : 'absolute'
							left : 0
							top : 0

					# start panel
					startPanel = UUI.V_CENTER
						wrapperStyle :
							position : 'absolute'
							left : 0
							top : 0
							width : '100%'
							height : '100%'
						childs : [
							UUI.PANEL
								wrapperStyle :
									width : 150
									margin : 'auto'
									backgroundColor : '#73BE31'
									border : '5px solid #666'
								contentStyle :
									padding : 10
								childs : [
									P
										style :
											fontSize : 12
										childs : [if BROWSER_CONFIG.USCREEN is undefined || BROWSER_CONFIG.USCREEN.isLayerOnCanvas is true then 'HTML5 Canvas Mode' else 'DOM Mode']
									P
										childs : ['BEST SCORE: ', if scoreStore.get 'best' is undefined then 0 else scoreStore.get 'best']
									P
										style :
											fontSize : 12
										childs : ['TOUCH or\nSPACE KEY/CLICK\nto START!']
								]
						]

					# pass pipe count panel
					countPanel = DIV
						style :
							position : 'absolute'
							left : 0
							top : 0
							textAlign : 'center'
							zIndex : 999
							width : '100%'
							fontSize : 20
							marginTop : 10
						childs : [0]
				]

				on :
					# when touch screen.
					touchstart : (e) ->

						# start game.
						if isStarted isnt true
							isStarted = true;
							startGame()

						bug.jump()

						e.stop()

			.appendTo BODY

			# show start panel.
			ANIMATE
				dom : startPanel.getDom()
				keyframes : KEYFRAMES
					from :
						transform : 'scaleY(0)'
					to :
						transform : 'scaleY(100%)'
				duration : 0.2
				timingFunction : 'ease-out'

			# init surface size.
			surface.setSize
				width : cls.gameWidth
				height : cls.gameHeight

			# init stage center.
			center = USCREEN.LAYER().appendTo surface

			# attach sky.
			USCREEN.LAYER
				img : IMG
					src : FlappyBug.R_URI 'sky.jpg'
			.appendTo center

			# create ground.
			ground = FlappyBug.Game.Ground().appendTo center

			# create bug.
			bug = FlappyBug.Game.Bug ->

					isGameOver = true

					# stop bgm.
					bgm.stop()

					# remove move ground loop.
					ground.removeGroundLoop()

					# remove create pipe interval.
					clearInterval createPipeInterval

					# remove move pipe loops.
					EACH pipes, (pipe) ->
						pipe.removeMoveLoop()

					# save best score.
					if scoreStore.get('best') is undefined || (parseInt (scoreStore.get 'best'), 10) < passPipeCount
						scoreStore.save
							key : 'best'
							value : passPipeCount

					# create end modal.
					endModal = UUI.MODAL
						wrapperStyle :
							width : 200
							margin : 'auto'
							backgroundColor : '#73BE31'
							border : '5px solid #666'
						contentStyle :
							padding : 10
						isCannotClose : true
						childs : [

							# scores
							P
								childs : ['YOUR SCORE: ', passPipeCount]
							P
								childs : ['BEST SCORE: ', scoreStore.get 'best']

							# home button
							UUI.BUTTON
								style : buttonStyle =
									marginTop : 10
									padding : 10
									backgroundColor : '#fff'
									color : '#666'
									borderRadius : 10
								title : 'HOME'
								onTap : ->
									FlappyBug.GO ''

							# restart button
							UUI.BUTTON
								style : buttonStyle
								title : 'RESTART'
								onTap : ->
									FlappyBug.GO 'Restart'

							P
								style : 
									marginTop : 10
									fontSize : 12
								childs : ['or SPACE KEY to RESTART.']

							# facebook like button
							Facebook.LikeButton
								style :
									marginTop : 10
								href : 'http://flappybug.uppercase.io'
								layout : 'button_count'
						]

					# hide end modal.
					ANIMATE
						dom : endModal.getDom()
						keyframes : KEYFRAMES
							from :
								transform : 'scaleY(0)'
							to :
								transform : 'scaleY(100%)'
						duration : 0.2
						timingFunction : 'ease-out'

			.appendTo center

			startGame = ->

				# hide start panel.
				ANIMATE
					dom : startPanel.getDom()
					keyframes : KEYFRAMES
						from :
							transform : 'scaleY(100%)'
						to :
							transform : 'scaleY(0)'
					duration : 0.2
					timingFunction : 'ease-in'
				, ->
					startPanel.remove()

				# init create pipe interval.
				createPipeInterval = setInterval ->

					# create pipe.
					pipes.push (FlappyBug.Game.Pipe
						pipes : pipes
						bug : bug
					, ->
						passPipeCount += 1

						countPanel.removeAllChilds()
						countPanel.append passPipeCount

					).appendTo center

				, 2000

			# init keydown event.
			keydownEvent = EVENT
				name : 'keydown'
			, (e) ->

				# when keydown space key.
				if e.getKeyCode() is 32

					# start game.
					if isStarted isnt true
						isStarted = true
						startGame()

					bug.jump()

					# restart game.
					if isGameOver is true
						FlappyBug.GO 'Restart'

					e.stop()

			# init resize event.
			resizeEvent = EVENT
				name : 'resize'
			, RAR ->

				# wrapper width
				wrapperWidth = wrapper.getWidth()

				# wrapper height
				wrapperHeight = wrapper.getHeight()

				# scale
				scale = if wrapperWidth / cls.gameWidth < wrapperHeight / cls.gameHeight then wrapperWidth / cls.gameWidth else wrapperHeight / cls.gameHeight

				# size
				size = surface.setScale scale

				surface.addStyle
					left : (wrapperWidth - size.width) / 2
					top : (wrapperHeight - size.height) / 2

				countPanel.addStyle
					top : (wrapperHeight - size.height) / 2

			# init update canvas loop.
			updateCanvasLoop = LOOP ->
				center.updateCanvas()

			#OVERRIDE: self.close
			self.close = close = (params) ->

				TITLE CONFIG.defaultTitle

				# remove doms.
				wrapper.remove()

				if endModal isnt undefined

					ANIMATE
						dom : endModal.getDom()
						keyframes : KEYFRAMES
							from :
								transform : 'scaleY(100%)'
							to :
								transform : 'scaleY(0)'
						duration : 0.2
						timingFunction : 'ease-in'
					, ->
						endModal.remove()

				# remove loops and intervals.
				updateCanvasLoop.remove()
				clearInterval createPipeInterval

				# remove events.
				keydownEvent.remove()
				resizeEvent.remove()

				# stop bgm.
				if isGameOver isnt true
					bgm.stop()
