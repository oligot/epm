note
	description: "Git command."
	author: "Olivier Ligot"

deferred class
	GIT_COMMAND

inherit
	KL_SHARED_FILE_SYSTEM

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

	directory: detachable STRING
			-- Directory where the command will be executed

feature -- Element change

	set_directory (a_directory: STRING)
		require
			a_directory_not_void: a_directory /= Void
		do
			directory := a_directory
		ensure
			directory_set: directory = a_directory
		end

feature -- Basic operations

	execute
			-- Execute current command.
		local
			l_cwd: detachable STRING
			l_splitter: ST_SPLITTER
			l_command: STRING
			l_shell_command: KL_SHELL_COMMAND
		do
			if attached directory as l_directory then
				l_cwd := File_system.cwd
				File_system.cd (l_directory)
			end
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
			if l_cwd /= Void then
				File_system.cd (l_cwd)
			end
		end

end
