note
	description: "Git clone command."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	GIT_CLONE_COMMAND

inherit
	GIT_COMMAND

create
	make,
	make_directory

feature {NONE} -- Initialization

	make (a_repository: STRING)
		do
			initialize
			arguments.force_last (a_repository)
			repository := a_repository
		ensure
			repository_set: repository = a_repository
		end

	make_directory (a_repository, a_directory: STRING)
		do
			make (a_repository)
			arguments.force_last (a_directory)
			directory := a_directory
		ensure
			repository_set: repository = a_repository
			directory_set: directory = a_directory
		end

feature -- Access

	repository: STRING
			-- The (possibly remote) repository to clone from

	directory: detachable STRING
			-- The name of a new directory to clone into

	name: STRING = "clone"
			-- Git subcommand name

end
