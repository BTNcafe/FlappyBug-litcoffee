MAIN.litcoffee
==============

	FlappyBug.MAIN = METHOD

		run : ->

			# Home view.
			FlappyBug.MATCH_VIEW
				uris : ['']
				target : FlappyBug.HomeView

			# Game view.
			FlappyBug.MATCH_VIEW
				uris : ['Game']
				target : FlappyBug.GameView

			# Restart view.
			FlappyBug.MATCH_VIEW
				uris : ['Restart']
				target : CLASS

					preset : ->
						VIEW

					init : (cls, inner, self) ->
						FlappyBug.GO 'Game'
