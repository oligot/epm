note
	description: "Git pull command."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	GIT_PULL_COMMAND

inherit
	GIT_COMMAND

create
	make,
	make_repository

feature {NONE} -- Initialization

	make
		do
			initialize
		end

	make_repository (a_repository: STRING)
		do
			initialize
			arguments.force_last (a_repository)
			repository := a_repository
		ensure
			repository_set: repository = a_repository
		end

feature -- Access

	repository: detachable STRING
			-- The remote repository that is the source of a fetch or pull operation

	name: STRING = "pull"
			-- Git subcommand name

end
