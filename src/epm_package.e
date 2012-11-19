note
	description: "Package definition."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	EPM_PACKAGE

create

	make

feature {NONE} -- Initialization

	make (a_name, a_version: STRING)
		do
			name := a_name
			version := a_version
			create dependencies.make_default
		ensure
			name_set: name = a_name
			version_set: version = a_version
		end

feature -- Access

	name: STRING
			-- Name

	version: STRING
			-- Version

	description: detachable STRING
			-- Description

	dependencies: DS_HASH_TABLE [STRING_32, STRING_32]

feature -- Element change

	set_description (a_description: like description)
			-- Set `description' to `a_description'.
		do
			description := a_description
		ensure
			description_set: description = a_description
		end

	set_dependencies (a_dependencies: like dependencies)
			-- Set `dependencies' to `a_dependencies'.
		do
			dependencies := a_dependencies
		ensure
			dependencies_set: dependencies = a_dependencies
		end

end
