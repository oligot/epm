note
	description: "Git fetch command."
	author: "Olivier Ligot"

class
	GIT_FETCH_COMMAND

inherit
	GIT_COMMAND

create
	make

feature {NONE} -- Initialization

	make
		do
			initialize
		end

feature -- Access

	name: STRING = "fetch"
			-- Git subcommand name

end
