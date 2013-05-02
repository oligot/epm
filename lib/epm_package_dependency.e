note
	description: "Package depedency."
	author: "Olivier Ligot"

class
	EPM_PACKAGE_DEPENDENCY

create

	make

feature {NONE} -- Initialization

	make (s: STRING)
		local
			i: INTEGER
		do
			i := s.index_of ('#', 1)
			if i > 0 then
				repository := s.substring (1, i - 1)
				branch := s.substring (i + 1, s.count)
			else
				repository := s
				branch := "master"
			end
		end

feature -- Access

	repository: STRING
			-- Repository

	branch: STRING
			-- Branch name

end
