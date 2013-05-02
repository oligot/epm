note
	description: "Git merge command."
	author: "Olivier Ligot"

class
	GIT_MERGE_COMMAND

inherit
	GIT_COMMAND

create
	make

feature {NONE} -- Initialization

	make (a_commit: STRING)
		do
			initialize
			arguments.force_last (a_commit)
			commit := a_commit
		ensure
			commit_set: commit = a_commit
		end

feature -- Access

	commit: STRING
			-- Commit to merge
			-- Can also be a branch

	name: STRING = "merge"
			-- Git subcommand name

end
