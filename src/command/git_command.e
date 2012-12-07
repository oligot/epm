note
	description: "Git command."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GIT_COMMAND

feature {NONE} -- Initialization

	initialize
		do
			create {DS_LINKED_LIST [STRING]} arguments.make
		end

feature -- Access

	git: STRING = "git"
			-- Git command name

	name: STRING
			-- Git subcommand name
		deferred
		end

	arguments: DS_LIST [STRING]
			-- Subcommand arguments

feature -- Basic operations

	execute
			-- Execute current command.
		local
			l_splitter: ST_SPLITTER
			l_command: STRING
			l_shell_command: DP_SHELL_COMMAND
		do
			create l_splitter.make
			l_splitter.set_escape_character ('\')
			create l_command.make (20)
			l_command.append_string (git)
			l_command.append_character (' ')
			l_command.append_string (name)
			if not arguments.is_empty then
				l_command.append_character (' ')
				l_command.append_string (l_splitter.join (arguments))
			end
			create l_shell_command.make (l_command)
			l_shell_command.execute
		end

end
