note
	description: "Git checkout command."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	GIT_CHECKOUT_COMMAND

inherit
	GIT_COMMAND

create
	make

feature {NONE} -- Initialization

	make (a_branch: STRING)
		do
			initialize
			arguments.force_last (a_branch)
			branch := a_branch
		ensure
			branch_set: branch = a_branch
		end

feature -- Access

	branch: STRING
			-- Branch to checkout

	name: STRING = "checkout"
			-- Git subcommand name

end
